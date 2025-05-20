#!/usr/bin/env python3

import argparse
import json
import yaml # Use yaml to parse json files because VSCode format insists on using trailing commas

parser = argparse.ArgumentParser(description=
    """
    Update vscode settings JSON with settings from the given JSON file.
    Typical usage: ./update-vscode-settings.py vscode-host-settings.json ~/Library/Application\\ Support/Code/User/settings.json
    """
)
parser.add_argument("source", help="File to pull desired settings from")
parser.add_argument("dest", help="File to push desired settings to")
args = parser.parse_args()

with open(args.source) as source_file:
    source_settings = yaml.load(source_file, Loader=yaml.FullLoader)

with open(args.dest) as dest_file:
    dest_settings = yaml.load(dest_file, Loader=yaml.FullLoader)

for (key, setting_value) in source_settings.items():
    dest_settings[key] = setting_value

with open(args.dest, "w") as dest_file:
    json.dump(dest_settings, dest_file, indent=4)
