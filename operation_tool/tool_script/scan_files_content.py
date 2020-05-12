#!/bin/env python3

import os
import re

def scan_files_content(dir, search_pattern):
    ret = {}
    pattern = re.compile(search_pattern)
    for path, folders, files in os.walk(dir):
        for file in files:
            item = os.path.join(path,file)
            try:
                with open(item,encoding = 'utf8') as fobj:
                    for line in fobj:
                        match = pattern.search(line)
                        if match :
                            if ret.get(item):
                                ret[item].append(line.strip())
                            else:
                                ret[item] = [line.strip()]
            except UnicodeDecodeError:
                pass
    return ret

if __name__ == '__main__':
    dir = r"D:\cloud"
    search_pattern = r"docker\sbuild"
    results = scan_files_content(dir, search_pattern)
    for file in results:
        print(file)
        for line in results[file]:
            print('\t',line)
        print('\n')