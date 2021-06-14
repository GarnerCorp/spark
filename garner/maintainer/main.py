
from spark_instances.instances import INSTANCES
from spark_instances.spark_instance_cls import SparkInstance
from check_tables import check_tables
from spark_kube.spark_kube import SparkKube
from repair_spark import repair_spark
import argparse
from env import BEELINE_CONNECTION_STRING
import os

def run_main_instances(bee_loc):
    print("Running All instances")
    for instance in INSTANCES:
        sk = SparkKube(instance.context, instance.instance, proxy=proxy, in_kube=False )
        repair_spark(instance.context, instance.instance, sk)

        check_tables(
            instance.context,
            instance.instance,
            instance.beeline_conn,
            instance.beeline_username,
            instance.beeline_password,
            bee_loc,
            sk
        )
        print(f"DONE: {instance.instance} ! \n")

def run_kube_instance():
    print("running in kube")
    bee_loc = os.environ['SPARK_HOME'] + "/bin/beeline"
    instance= SparkInstance.get_instance_from_env(BEELINE_CONNECTION_STRING)
    sk = SparkKube(instance.context, instance.instance, proxy=proxy, in_kube=True )
    repair_spark(instance.context, instance.instance, sk)
    
    check_tables(
        instance.context,
        instance.instance,
        instance.beeline_conn,
        instance.beeline_username,
        instance.beeline_password,
        bee_loc,
        sk
    )
    print(f"DONE: {instance.instance} ! \n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--proxy", help="Proxy url")
    parser.add_argument("-k", "--inkube", help="is in kube?", action="store_true")
    parser.add_argument("-b", "--beeloc", help="beeline_location?")

    args = parser.parse_args()
    if args.proxy:
        proxy = args.proxy
    else:
        proxy = None
    if not args.inkube:
        if args.beeloc:
            run_main_instances(args.beeloc)
        else:
            print("no beeline loc defined")
    else:
        run_kube_instance()



