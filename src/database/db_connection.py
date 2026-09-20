import os
import logging
import traceback
from sqlalchemy import create_engine
from urllib.parse import quote_plus
from dotenv import load_dotenv

load_dotenv()

logging.basicConfig(
    level = logging.ERROR,
    format = "%(asctime)s - %(levelname)s - %(message)s"
)

logging.info("loading env varailbles...")
DB_HOST = os.getenv("SSDB_HOST")
DB_NAME = os.getenv("SSDB_NAME")
DB_DRIVER = os.getenv("SSDB_DRIVER")

if not DB_HOST:
    raise ValueError("SQL SERVER HOST IS NOT FOUND!!")
    raise ValueError("SQL SERVER DATABASE NAME IS NOT FOUND!!")
if not DB_DRIVER:
    raise ValueError("SQL SERVER DRIVER NAME IS NOT FOUND!!")
logging.info("env variables loaded and saved!")

try:
    logging.info("intiating connection string..")
    CONNECTION_STRING = (
        f"DRIVER={{{DB_DRIVER}}};"
        f"SERVER={DB_HOST};"
        f"DATABASE={DB_NAME};"
        f"Trusted_Connection=yes;"
        f"TrustServerCertificate=yes;"
    )
    logging.info("intiated connection string!")

    logging.info("creating alchemy Engine...")
    engine = create_engine(
        "mssql+pyodbc:///?odbc_connect="
        + quote_plus(CONNECTION_STRING),
        echo=False
    )
    logging.info("Engine Created Successfully.")

except TypeError:
    logging.error("invalid connection string!!")
    logging.error("Traceback :-")
    logging.error(traceback.format_exc())
except ArgumentError:
    logging.error("invalid DB URL!!")
    logging.error("Traceback :-")
    logging.error(traceback.format_exc())
except Exception as e:
    logging.error("Unecepted Error!!")
    logging.error("Traceback :-")
    logging.error(traceback.format_exc())

