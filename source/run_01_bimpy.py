#!/usr/bin/env python3
"""bimpy test code.
Usage:
  run_01_bimpy [-vh]

Options:
  -h --help               Show this screen
  -v --verbose            Print debugging output
"""
# martin kielhorn 2019-04-05
# https://github.com/podgorskiy/bimpy
import os
import sys
import docopt
import traceback
import numpy as np
import pathlib
import time
import bimpy as b
def current_milli_time():
    return int(round(((1000)*(time.time()))))
class bcolors():
    OKGREEN="\033[92m"
    WARNING="\033[93m"
    FAIL="\033[91m"
    ENDC="\033[0m"
global g_last_timestamp
g_last_timestamp=current_milli_time()
def milli_since_last():
    global g_last_timestamp
    current_time=current_milli_time()
    res=((current_time)-(g_last_timestamp))
    g_last_timestamp=current_time
    return res
def fail(msg):
    print(((bcolors.FAIL)+("{:8d} FAIL ".format(milli_since_last()))+(msg)+(bcolors.ENDC)))
    sys.stdout.flush()
def plog(msg):
    print(((bcolors.OKGREEN)+("{:8d} LOG ".format(milli_since_last()))+(msg)+(bcolors.ENDC)))
    sys.stdout.flush()
args=docopt.docopt(__doc__, version="0.0.1")
if ( args["--verbose"] ):
    print(args)
ctx=b.Context()
ctx.init(600, 600, "Hello")
str=b.String()
f=b.Float()
while (not(ctx.should_close())):
    with ctx:
        b.text("hello world")
        if ( b.button("OK") ):
            print(str.value)
        b.input_text("string", str, 256)
        b.slider_float("float", f, (0.0e+0), (1.e+0))