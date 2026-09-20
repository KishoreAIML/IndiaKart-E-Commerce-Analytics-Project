import os
import yaml
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parents[1]
print(ROOT_DIR)

with open(ROOT_DIR/"config.yaml", "r") as file:
    config = yaml.safe_load(file)

Raw_data = config["Paths"]["Raw_data"]
Load_data = config["Paths"]["Load_data"]
Database = config["Paths"]["Database"]
Reports = config["Paths"]["Reports"]