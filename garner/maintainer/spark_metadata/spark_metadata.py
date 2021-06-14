
from custom_executor.interruptible_cls import  Interruptable
from typing import List
class SparkMetadata:

    def __init__(
            self,
            beeline_loc: str,
            beeline_con: str):
        self._beeline_loc = beeline_loc
        self._beeline_con = beeline_con

    class beeline_p(Interruptable):
        def err_f(self, x: bytes):
            print(f"beeline_p error says {x.decode()}")
            if "ERROR HiveConnection" in x.decode():
                self.out_collect = []
                return False
            if "HTTP Response code: 401" in x.decode():
                self.out_collect = []
                return False
            if "Could not establish connection" in  x.decode():
                self.out_collect = []
                return False
            return True

        def out_f(self, x: bytes):
            self.out_collect.append(x.decode())
            return True

    def get_beeline_p(
            self,
            username: str,
            password: str,
            query: str,
            inter_cls=beeline_p):
        cmd = (
            f"""{self._beeline_loc}"""
            """  --outputformat=csv2"""
            f""" -u '{self._beeline_con}'"""
            f""" -n {username} """
            f""" -p {password} """
            f""" -e "{query}" """
        )

        return inter_cls(cmd)



    def get_meta_data(self, username, password):
        query = (
            f"""show tables; show functions;"""
        )
        return self.get_beeline_p(username, password, query)

    @staticmethod
    def parse_meta_data(metadata_raw: List[str]):
        tables = []
        functions = []
        reading_tables = False
        reading_functions =False
        for b in metadata_raw:
            if "database,tableName,isTemporary" in b:
                reading_tables =True
                reading_functions = False
            if "function" in b:
                reading_tables = False
                reading_functions = False

            if reading_tables:
                tables.append(b)

        table_names =[f"""{table_line.split(',')[0]}.{table_line.split(',')[1]}"""
                      for table_line in tables[1:]]


        return table_names
