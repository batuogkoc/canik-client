import re
import os

if __name__ == "__main__":
    in_directory = "../data/shot_det_validation"
    out_file_path = "/home/batu/projects/canik-client/dart/canik_flutter/lib/shot_det_datasets/shot_det_datasets.dart"
    if not os.path.exists(os.path.split(out_file_path)[0]):
        os.makedirs(os.path.split(out_file_path)[0])
    final_out = ""
    for file in os.listdir(in_directory):
        file_name, file_extension = os.path.splitext(file)
        if file_extension != ".csv":
            continue
        print(file)
        file_path = os.path.join(in_directory, file)
        list_name = ''.join(x for x in file_name.replace("_", " ").title() if not x.isspace()) + "List"
        list_name = list_name[0].lower() + list_name[1:]
        lines = None
        with open(file_path, "r") as file:
            lines = file.readlines()
        
        out = f"List<List<double>> {list_name} = [\n"
        for line in lines:
            line = line.strip()
            elements = re.split(";|,", line)
            is_valid_line = True
            for element in elements:
                try:
                    element_float = float(element)
                except Exception as e:
                    print(e)
                    is_valid_line = False
                    break
            
            if not is_valid_line:
                exit()
            out_line = "\t[" + ", ".join(elements) + "],\n"
            out += out_line
        out += "];"
        final_out += out
    with open(out_file_path, "w") as file:
        file.write(final_out)