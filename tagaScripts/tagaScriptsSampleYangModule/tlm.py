#!/usr/bin/env python

import subprocess

'''
## License

The MIT License (MIT)

GrovePi for the Raspberry Pi: an open source platform for connecting Grove Sensors to the Raspberry Pi.
Copyright (C) 2015  Dexter Industries

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
'''

import time
from grovepi import *

# define the counter
count=0

time.sleep(1)

subprocess.call(["mkdir", "/var/opt/taga/tlm"])
subprocess.call(["mkdir", "/var/opt/taga/tlm/run"])
subprocess.call(["mkdir", "/var/opt/taga/tlm/log"])

while True:
    count = count + 1
    try:

        print ("TAGA LOG MGT (TLM) MANAGING and MONITORING")

        time.sleep(2)

        subprocess.call("date", shell=True)
        command="/home/pi/scripts/taga/tagaScripts/tagaScriptsLogMgt/tlm_daemon_agent.sh"
        command = command + " "
        command = command + str(count)
        subprocess.call(command, shell=True)

        command="/home/pi/scripts/taga/tagaScripts/tagaScriptsLogMgt/tlm_daemon.sh"
        command = command + " "
        command = command + str(count)
        subprocess.call(command, shell=True)

        # do a system call
        return_code = subprocess.call("echo Hello World from tlm.py >> /var/opt/taga/tlm/run/tlm.dat", shell=True)
        return_code = subprocess.call("echo Hello World from tlm.py >> /var/opt/taga/tlm/log/tlm.log", shell=True)

    except KeyboardInterrupt:	# Handle keyboard interrupt if necessary
        print ("Keyboard Intterupt")
        break
    except IOError:	        # Print "Error" if communication error encountered
        print ("Error")
