import os
from pathlib import Path


def get_config_base_path():
    import new_to_card_config

    return Path(os.path.dirname(new_to_card_config.__file__))


# === UC MODEL STORAGE CONFIG ===
TARGET_SCHEMA_NAME = "DEV.new_to_card"
MODEL_FULL_PATH = f"{TARGET_SCHEMA_NAME}.model"
