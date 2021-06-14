#!/usr/bin/env python3
from spark_kube.spark_kube import SparkKube
from spark_metadata.spark_metadata import SparkMetadata
from local_blueprint.local_blueprint_cls import LocalBlueprint
from remake_metadata_query import remake_metadata_query
import env
from custom_executor.operators import run_with_rety

def check_tables(
        context_name: str,
        instance_name: str,
        beeline_conn: str,
        user_name: str,
        password: str,
        beeline_loc: str,
        sk: SparkKube):
    print(f"checking metadata for: {instance_name} ! \n")

    sm = SparkMetadata(beeline_loc, beeline_conn)
    sb = LocalBlueprint(env.BLUEPRINT_LOCATION, context_name,instance_name)
    pf = sk.open_port_forward_p()
    bq_metadata = sm.get_meta_data(user_name, password)

    print("Opening port forward ")
    pf.execute(term_on_term=False)
    try:
        print(f"Asking {instance_name} for metadata")
        if run_with_rety(bq_metadata, env.BEELINE_RETIRES, env.BEELINE_WAIT_ON_RETRY_S):

            out = bq_metadata.out_collect
            table_names_in_spark = sm.parse_meta_data(out)
            table_dict_in_blueprint = {table.table_name: table for table in sb.instance_tables.tables}

            need_to_remake = False
            for key in table_dict_in_blueprint.keys():
                if not key in table_names_in_spark:
                    print(f"table:{key} not found in spark!!")
                    need_to_remake = True
                else:
                    print(f"table:{key} is in spark!!")

            if need_to_remake:
                print("Remaking all tables")
                remake_q = remake_metadata_query(sb.instance_tables.tables)
                sm.get_beeline_p(user_name, password, remake_q).execute()
        else:
            print("could not get beeline connection")
    except Exception as e:
        print(e)

    pf.pgkill()
    print("Port forward closed")





