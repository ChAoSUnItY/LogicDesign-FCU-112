import json
import sys
import re

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
    file.seek(0)
    # Replace top level entity
    file_string = re.sub(r"set_global_assignment -name TOP_LEVEL_ENTITY \w+", f"set_global_assignment -name TOP_LEVEL_ENTITY {target}", file_string)
    # Clear all pin assignments
    file_string = re.sub(r"set_location_assignment \w+ -to \w+\n", "", file_string)
    # Add all assignments in the end
    target_settings = user_mapping_data[target]

    for pin_setting in target_settings:
        pin = pin_setting["pin"]
        type = pin_setting["type"]
        index = pin_setting["index"]
        file_string += f"set_location_assignment {resolve_pin(mapping_data[type], index)} -to {pin}\n"

    file.write(file_string)
    file.truncate()
