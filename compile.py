# A simple checkout tool used to perform automatic pin mapping and top level entity changing by
# lookup json files.
# This is designed for qsf (Quartus Setting File).
#
# Usage: py pinner.py <LabEntry>
#
# LabEntry should be defined in user_mapping.json.
#
# Author: ChAoS-UnItY (Kyle Lin) 
import json
import sys
import re
import subprocess
import pathlib

quartus_installation = pathlib.Path("C:\\altera\\13.1\\quartus\\bin")

def resolve_pin(mapping, index):
    prefix = mapping["prefix"]
    assignment = mapping["list"][index]

    return f"{prefix}_{assignment}"

mapping_file = open('mapping.json')
mapping_data = json.load(mapping_file)

user_mapping_file = open("user_mapping.json")
user_mapping_data = json.load(user_mapping_file)

target = sys.argv[1]

with open("DigitalLogic.qsf", "r+") as file:
    file_string = file.read()
    if file_string[-1] != '\n':
        file_string += '\n'
    file.seek(0)
    # Replace top level entity
    file_string = re.sub(r"set_global_assignment -name TOP_LEVEL_ENTITY \w+", f"set_global_assignment -name TOP_LEVEL_ENTITY {target}", file_string)
    # Clear all pin assignments
    file_string = re.sub(r"set_location_assignment \w+ -to (\w|\d|\[|\])+\n", "", file_string)
    # Add all assignments in the end
    target_settings = user_mapping_data[target]

    for pin_setting in target_settings:
        pin = pin_setting["pin"]
        type = pin_setting["type"]
        index = pin_setting["index"]
        file_string += f"set_location_assignment {resolve_pin(mapping_data[type], index)} -to {pin}\n"

    # File cleanup: Remove empty lines if applicable
    file_string = file_string.replace('\n\n', '\n')

    file.write(file_string)
    file.truncate()

# Compile
subprocess.run([quartus_installation / "quartus_sh", "--flow", "compile", "DigitalLogic.qpf" ])

# Burn
subprocess.run([quartus_installation / "quartus_pgm", "-m", "jtag", "-o", "p;output_files/DigitalLogic.sof@1"])
