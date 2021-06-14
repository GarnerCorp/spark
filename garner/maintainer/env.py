from pathlib import Path

HERE = Path(__file__).parent.resolve()

BEELINE_CONNECTION_STRING = "jdbc:hive2://localhost:10002/default;httpPath=cliservice;transportMode=http;ssl=false;"
BLUEPRINT_LOCATION = HERE / r'table_blueprint.yaml'

BEELINE_RETIRES = 5
BEELINE_WAIT_ON_RETRY_S = 30
