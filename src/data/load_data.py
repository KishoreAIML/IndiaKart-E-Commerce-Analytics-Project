import os
import traceback
import logging
import pandas as pd
from memory_profiler import profile
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parents[2]
from src.config import Raw_data

logging.basicConfig(
    level = logging.INFO,
    format = "%(asctime)s - %(levelname)s - %(message)s"
)

@profile
def read_data(tablename: str)-> None:
    try:
        logging.info("Changing directiory...")
        os.chdir(ROOT_DIR/Raw_data)
        print("current cwd : ", os.getcwd())
        logging.info("loading dataset...")
        data = pd.read_csv(f"{tablename}.csv")
        logging.info("@@@@ dataset Readed Successfuly. @@@")
        return data
    except FileNotFoundError:
        logging.error("Give file name does not found!!!!")
        logging.error("Traceback :-")
        logging.error(traceback.format_exc())
    except NotADirectoryError:
        logging.error("Give directory name is not directory!!!!")
        logging.error("Traceback :-")
        logging.error(traceback.format_exc())       
    except Exception as e:
        logging.error("Unexcepted error!!!")
        logging.error("Traceback :-")
        logging.error(traceback.format_exc())

