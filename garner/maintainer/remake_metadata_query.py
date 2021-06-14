from local_blueprint.table_cls import  Table
from typing import List


def remake_metadata_query(tables_list: List[Table]):
    query = (
        """DROP TABLE IF EXISTS default.dummy_base;"""
        """CREATE EXTERNAL TABLE default.dummy_base (Value STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE location  '/opt/spark/externals';"""
    )
    for table in tables_list:
      tablequery =(
            f""" DROP FUNCTION IF EXISTS {table.function_name};"""
            f""" create function {table.function_name} as '{table.function_path}';"""
            f"""DROP VIEW IF EXISTS {table.table_name};"""
            f"""CREATE VIEW {table.table_name} AS SELECT {table.function_name}(Value) FROM dummy_base;"""
        )
      query=query+tablequery

    return query

