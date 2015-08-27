#!/usr/bin/python

import time

if __name__ == '__main__':
    inputdata = None
    with open('/workdir/input', 'r') as infile:
        inputdata = infile.read()

    outputdata = inputdata[::-1]
    time.sleep(10)

    with open('/workdir/output', 'w') as outfile:
        outfile.write(outputdata)
