import os
import subprocess


# Wrapper function for subprocess
def command(_):
    return _.split()


def find_terraform_directories():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    os.chdir("..")

    # Find all Terraform files
    terraform_files = subprocess.run(command('find ./infra -name *.tf'), capture_output=True)

    # Decode byte string to utf-8 and split into a list of strings
    file_list = terraform_files.stdout.decode('utf-8').rstrip().split(sep='\n')

    # Filter files and extract unique directories
    exclude_dirs = [".terraform"]
    unique_directories = {
        os.path.dirname(file) for file in file_list if not any(excluded in file for excluded in exclude_dirs)
    }

    return sorted(unique_directories)
