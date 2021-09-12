#!/bin/python3
import random
import logging

logging.basicConfig(format='%(asctime)s %(levelname)s-%(message)s', datefmt='%Y-%m-%d %H:%M:%S', filename="foo.log", filemode='a')

for i in range(0, 45):
    r = random.randint(0, 2)
    if r == 0:
        logging.warning('Test warning log')
    elif r == 1:
        logging.critical('Test critical log')
    else:
        logging.error('Test error log')
