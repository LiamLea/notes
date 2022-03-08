#!/bin/env python3

import subprocess

def get_all_resources_type():
    command = r"kubectl api-resources"
    results = subprocess.run(command, shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    results = [ i.split()[0] for i in results.stdout.decode().split('\n')[1:] if i != '' ]
    return results

def get_all_resources(namespace):
    ret = {}
    all_types = get_all_resources_type()
    for type in all_types:
        command = r"kubectl get %s -n %s" %(type, namespace)
        results = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if results.stdout:
            ret[type] = results.stdout.decode()
    return ret

if __name__ == '__main__':
    namespace = r"es-lil"
    resources = get_all_resources(namespace)
    for type in resources:
        print('*' * 50, type, '*' * 50, '\n')
        print(resources[type])
        print('\n')