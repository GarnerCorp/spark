from typing import List
from local_blueprint.table_cls import Table

class InstanceTables:
    def __init__(self,context_name: str, instance_name: str):
        self.context_name = context_name
        self.instance_name = instance_name
        self.tables: List[Table] = []

    def add(self, table: Table):
        self.tables.append(table)
