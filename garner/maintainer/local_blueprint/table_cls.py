class Table:
    def __init__(self, function_path: str, table_name: str):
        self.function_path = function_path
        self.table_name = table_name.lower()
        self.function_name = self.function_path_to_name(self.function_path).lower()
        self.query = self._to_query(self.function_name,self.function_path,self.table_name)

    @staticmethod
    def function_path_to_name(function_path: str) -> str:
        return "default." + \
               function_path.split("views.")[-1].replace(".", "_") \
               + "_func"

    @staticmethod
    def _to_query(function_name,function_path,table_name):
        query = (
            f""" DROP FUNCTION IF EXISTS {function_name};"""
                f""" create function {function_name} as '{function_path}';"""
                f"""DROP VIEW IF EXISTS {table_name};"""
                f"""CREATE VIEW {table_name} AS SELECT {function_name}(Value) FROM dummy_base;"""
                 )
        return query


    def __str__(self):
        out =  (
            f"""   table_name: {self.table_name}"""
            f"""   function_name:   {self.function_name}"""
            f"""   function_path:   {self.function_path}"""
        )
        return out


