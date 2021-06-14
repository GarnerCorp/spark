#!/usr/bin/env python3
from typing import List, Dict
import yaml
from pathlib import PosixPath
from local_blueprint.table_cls import Table
from local_blueprint.instance_tables_cls import InstanceTables

class LocalBlueprint:
    def __init__(
            self,
            yamlfileloc: PosixPath,
            cluster_name: str,
            instance_name: str):

        self.instance_tables: InstanceTables = \
            self._get_all_table(yamlfileloc, cluster_name, instance_name)



    @staticmethod
    def _get_all_table(
            yamlfileloc: PosixPath,
            cluster_name: str,
            instance_name: str) -> InstanceTables:
        instab = InstanceTables(cluster_name,instance_name)
        with yamlfileloc.open() as file:
            try:
                yaml_raw = yaml.load(
                    file,
                    Loader=yaml.FullLoader
                )[instance_name]
                for table_item in yaml_raw:
                    instab.add(Table(
                        table_item['function_path'],
                        table_item['table_name'])
                    )
            except Exception as e:
                print(e)
            return instab

