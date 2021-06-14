import os

class SparkInstance:
    def __init__(self,
                 context: str,
                 instance: str,
                 beeline_conn: str,
                 beeline_username: str,
                 beeline_password: str):
        self.context = context
        self.instance = instance
        self.beeline_conn = beeline_conn
        self.beeline_username = beeline_username
        self.beeline_password = beeline_password

    @staticmethod
    def get_instance_from_env(beeline_conn):
        return SparkInstance(context="in kube",
                             instance=os.environ['MAINTAINER_INSTANCE_NAME'],
                             beeline_conn=beeline_conn,
                             beeline_username=os.environ['BEELINE_EMAIL'],
                             beeline_password=os.environ['BEELINE_PASSWORD'],
                             )


