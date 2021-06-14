#!/usr/bin/env python3

from spark_kube.spark_kube import SparkKube
from custom_executor.operators import run_until_end


def repair_spark(context_name: str, instance_name: str, sk: SparkKube):
    pods_list = sk.get_pods_list(instance_name)
    print(f"\nFIST LOOK AT {instance_name}  in {context_name}:")
    print(pods_list)

    pods_older_than_master = sk._pods_older(pods_list, 'master')
    pods_older_than_postgres = sk._pods_older(pods_list, 'postgres')
    # its a union of the two quick little if statement is easier than set code
    if len(pods_older_than_master) > len(pods_older_than_postgres):
        pods_older_than_critical = pods_older_than_master
    else:
        pods_older_than_critical = pods_older_than_postgres
    bad_pods = sk.clean_list(pods_older_than_critical)

    bad_pods_p = [sk.kill_bad_pod_p(context_name, bad_pod) for bad_pod in bad_pods]
    run_until_end(bad_pods_p)

    all_good = sk.get_pods_list(instance_name)
    print(all_good)



