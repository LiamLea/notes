"""quick sort"""

import random

def qsort(seq):
    if len(seq) < 2:
        return seq
    middle=seq[0]
    smaller=[i for i in seq[1:] if i<middle]
    larger=[i for i in seq[1:] if i>=middle]
    return qsort(smaller)+[middle]+qsort(larger)

if __name__ == '__main__':
    nums=[random.randint(0,100) for i in range(10)]
    print(qsort(nums))