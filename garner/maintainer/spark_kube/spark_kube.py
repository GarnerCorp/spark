import subprocess
from typing import List
from custom_executor.interruptible_cls import Interruptable

class SparkKube:
    def __init__(self, context_name: str, instance_name: str, proxy=None, in_kube=False):

        self.instance_name: str = instance_name
        self.proxy = proxy
        self.in_kube = in_kube
        if not self.in_kube:
            self._use_context_cmd = f""" kubectl config use-context {context_name}; """
            self.context_name: str = context_name
        else:
            self._use_context_cmd = f"""echo ''; """
            self.context_name: str = ""
        if self.proxy:
            self._use_proxy_cmd = (
                f""" export http_proxy={self.proxy};"""
                """  export https_proxy=$http_proxy; """
            )
        else:
            self._use_proxy_cmd = f"""echo ''; """

    def open_port_forward_p(self):
        open_port_cmd = (
            f""" {self._use_proxy_cmd} """
            f""" {self._use_context_cmd} """
            """  kubectl -n spark port-forward """
            f""" {self.instance_name}-thriftserver-admin-0 10002:10002 &  """
        )

        class open_port_p(Interruptable):
            def out_f(self, x: bytes):
                print(f"out {x.decode()}")
                if "Forwarding from 127.0.0.1:1000" in x.decode():
                    return False
                return True

            def err_f(self, x: bytes):
                print(x.decode())
                return True


        return open_port_p(open_port_cmd)


    @staticmethod
    def clean_list(podNameList: List[str]) -> List[str]:
        def is_neither(x):
            return all(
                sub not in x
                for sub in ("master", "postgres", "maintainer")
            )
        return list(filter(is_neither, podNameList))

    @staticmethod
    def _pods_older(podNameList: List[str], pod_name) -> List[str]:
        pod_idx = [idx for idx, value in enumerate(podNameList)
                      if pod_name in value][0]
        return podNameList[0:pod_idx]

    def get_pods_list(
            self,
            spark_instance_name: str
    ) -> List[str]:


        get_pods_cmd = (
            f""" {self._use_proxy_cmd}"""
            "kubectl get pods"
            " -n spark"
            " --selector=app.kubernetes.io/name=spark"
            f" --selector=app.kubernetes.io/instance={spark_instance_name}"
            " -o jsonpath='{.items[*].metadata.name}'"
            " --sort-by={metadata.creationTimestamp}"
        )


        use_context_p = subprocess.Popen(
            self._use_context_cmd,
            executable='/bin/bash',
            shell=True,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        output, err = use_context_p.communicate()
        if err:
            print(err.decode())
        get_pods_p = subprocess.Popen(
            get_pods_cmd,
            executable='/bin/bash',
            shell=True,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        get_pods_o, err = get_pods_p.communicate()
        if err:
            print(err.decode())
        if get_pods_o:
            return get_pods_o.decode().split()
        else:
            return []



    def kill_bad_pods(self, use_context, bad_pods: List[str]) -> None:
        if self.in_kube:
            use_context_cmd = f"""echo 'in kube'; """
        else:
            use_context_cmd = f""" kubectl config use-context {use_context}; """


        if self.proxy:
            print("using proxy")
            kill_pod_cmd = (
                f""" export http_proxy={self.proxy};"""
                """  export https_proxy=$http_proxy; """
                f"{use_context_cmd }"
            )
        else:
            kill_pod_cmd = (
                f"{use_context_cmd }"
            )

        for pod_name in bad_pods:
            kill_pod_append = (
                f" kubectl delete pod {pod_name}  -n spark; "
            )
            kill_pod_cmd = kill_pod_cmd + kill_pod_append

        print(kill_pod_cmd)
        class kill_pods_p(Interruptable):
            def out_f(self, x: bytes):
                print(f"kill_pods_p out: {x.decode()}")
                return True

            def err_f(self, x: bytes):
                print(f"kill_pods_p err:{x.decode()}")
                return True
        kp = kill_pods_p(kill_pod_cmd)
        kp.execute()

    def kill_bad_pod_p(self, use_context, bad_pod: str) -> Interruptable:
        if self.in_kube:
            use_context_cmd = f"""echo 'in kube'; """
        else:
            use_context_cmd = f""" kubectl config use-context {use_context}; """
        if self.proxy:
            print("using proxy")
            kill_pod_cmd = (
                f""" export http_proxy={self.proxy};"""
                """  export https_proxy=$http_proxy; """
                f"{use_context_cmd }"
                f" kubectl delete pod {bad_pod}  -n spark; "
            )
        else:
            kill_pod_cmd = (
                f"{use_context_cmd }"
                f" kubectl delete pod {bad_pod}  -n spark; "
            )

        print(kill_pod_cmd)
        class kill_pod_p(Interruptable):
            def out_f(self, x: bytes):
                print(f"kill_pods_p out: {x.decode()}")
                return True

            def err_f(self, x: bytes):
                print(f"kill_pods_p err:{x.decode()}")
                return True
        return kill_pod_p(kill_pod_cmd)
