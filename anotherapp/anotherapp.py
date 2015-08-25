#!/usr/bin/python

import time

if __name__ == '__main__':

    while True:
        with open('/etc/anotherapp.cfg', 'r') as f:
            print f.read()
        time.sleep(1)
