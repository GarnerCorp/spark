from spark_instances.spark_instance_cls import SparkInstance

INSTANCES = [
    SparkInstance("golden-pass",
                  "spark-live",
                  "jdbc:hive2://localhost:10002/default;httpPath=cliservice;transportMode=http;ssl=false;",
                  "demo@garnercorp.com",
                  "ztt7!Cd!SSM8wDM"
                  ),
    SparkInstance("control-center_gke_default-cluster",
                  "spark-chad",
                  "jdbc:hive2://localhost:10002/default;httpPath=cliservice;transportMode=http;ssl=false;",
                  "demo+expeditor@garnercorp.com",
                  "Garner999"
                  )
]
