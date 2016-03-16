#!/usr/bin/env python
# coding: utf-8

import argparse
import os
import sys
import time
import atexit
import logging
import signal
import subprocess

class Daemon(object):
    """
    A generic daemon class.
    Usage: subclass the Daemon class and override the run() method
    """

    def __init__(self, pidfile, stdin='/dev/null',
                 stdout='/dev/null', stderr='/dev/null'):
        self.stdin = stdin
        self.stdout = stdout
        self.stderr = stderr
        self.pidfile = pidfile

    def daemonize(self):
        """
        do the UNIX double-fork magic, see Stevens' "Advanced 
        Programming in the UNIX Environment" for details (ISBN 0201563177)
        http://www.erlenstar.demon.co.uk/unix/faq_2.html#SEC16
        """

        message = "dlm temp 22222222aaaaaaaaaaa \n"
        #sys.stderr.write(message)

        # Do first fork
        self.fork()

        message = "dlm temp 22222222bbbbbbbbbbb \n"
        #sys.stderr.write(message)

        # Decouple from parent environment
        self.dettach_env()

        message = "dlm temp 22222222ccccccccccccccc \n"
        #sys.stderr.write(message)

        # Do second fork
        self.fork()

        message = "dlm temp 22222222dddddddddddddddd \n"
        #sys.stderr.write(message)

        # Flush standart file descriptors
        sys.stdout.flush()
        sys.stderr.flush()

        message = "dlm temp 22222222eeeeeeeeeeeeeeeee \n"
        #sys.stderr.write(message)

        # 
        self.attach_stream('stdin', mode='r')
        self.attach_stream('stdout', mode='a+')
        # dlm temp this function hangs!!!
        #self.attach_stream('stderr', mode='a+')

        message = "dlm temp 22222222fffffffffffffff \n"
        #sys.stderr.write(message)
       
        # write pidfile
        self.create_pidfile()

        # do a system call
        #subprocess.call(["ls", "-l"])
        subprocess.call("ls -l > /tmp/ls.out", shell=True)
        #subprocess.call(["mkdir", "/tmp/testdir"])
        #subprocess.call(["touch", "/tmp/testdir/myfile.txt"])
        return_code = subprocess.call("echo Hello World", shell=True)
        return_code = subprocess.call("echo Hello World > /tmp/testdir/myfile.txt", shell=True)
        subprocess.call("/home/darrin/code/nanomsg_app/PubSub/testPubSub.sh > /tmp/pubsub.out", shell=True)
        #subprocess.call(["/home/darrin/code/nanomsg_app/PubSub/test.sh", "dummyArg"])

        message = "dlm temp 22222222ggggggggggggg \n"
        #sys.stderr.write(message)



    def attach_stream(self, name, mode):
        """
        Replaces the stream with new one
        """
        stream = open(getattr(self, name), mode)
        os.dup2(stream.fileno(), getattr(sys, name).fileno())

    def dettach_env(self):
        os.chdir("/")
        os.setsid()
        os.umask(0)

    def fork(self):
        """
        Spawn the child process
        """
        try:
            pid = os.fork()
            if pid > 0:
                message = "Starting Daemon Parent Pid: %d \n"
                sys.stderr.write(message % pid)
                sys.exit(0)
            else:
                message = "Starting Daemon Parent Pid: %d \n"
                sys.stderr.write(message % pid)
        except OSError as e:
            sys.stderr.write("Fork failed: %d (%s)\n" % (e.errno, e.strerror))
            sys.exit(1)

    def create_pidfile(self):

        message = "dlm temp 22222222eeeeeeeeeeeeee11111111111111 \n"
        #sys.stderr.write(message)

        atexit.register(self.delpid)

        message = "dlm temp 22222222eeeeeeeeeeeeee222222222222222 \n"
        #sys.stderr.write(message)

        pid = str(os.getpid())

        message = "dlm temp 22222222eeeeeeeeeeeeee33333333333333333 \n"
        #sys.stderr.write(message)

        open(self.pidfile,'w+').write("%s\n" % pid)

        message = "dlm temp 22222222eeeeeeeeeeeeee44444444444444444 \n"
        #sys.stderr.write(message)

    def delpid(self):
        """
        Removes the pidfile on process exit
        """
        os.remove(self.pidfile)

    def start(self):
        """
        Start the daemon
        """
        # Check for a pidfile to see if the daemon already runs
        pid = self.get_pid()

        if pid:
            message = "pidfile %s already exist. Daemon already running?\n"
            sys.stderr.write(message % self.pidfile)
            sys.exit(1)

        # Start the daemon
        message = "dlm temp 111111111111111111 \n"
        #sys.stderr.write(message)
        self.daemonize()
        message = "dlm temp 222222222222222222 \n"
        self.run()
        message = "dlm temp 3333333333333333333 \n"

    def get_pid(self):
        """
        Returns the PID from pidfile
        """
        try:
            pf = open(self.pidfile,'r')
            pid = int(pf.read().strip())
            pf.close()
        except (IOError, TypeError):
            pid = None
        return pid

    def stop(self, silent=False):
        """
        Stop the daemon
        """
        # Get the pid from the pidfile
        pid = self.get_pid()

        if not pid:
            if not silent:
                message = "pidfile %s does not exist. Daemon not running?\n"
                sys.stderr.write(message % self.pidfile)
            return # not an error in a restart

        # Try killing the daemon process    
        try:
            while True:
                os.kill(pid, signal.SIGTERM)
                time.sleep(0.1)
        except OSError as err:
            err = str(err)
            if err.find("No such process") > 0:
                if os.path.exists(self.pidfile):
                    os.remove(self.pidfile)
            else:
                sys.stdout.write(str(err))
                sys.exit(1)

    def restart(self):
        """
        Restart the daemon
        """
        self.stop(silent=True)
        self.start()

    def run(self):
        """
        You should override this method when you subclass Daemon. It will be called after the process has been
        daemonized by start() or restart().
        """
        raise NotImplementedError


class MyDaemon(Daemon):
    def run(self):
        print("wee")
        while True:
            time.sleep(0.1)


def main():
    """
    The application entry point
    """
    parser = argparse.ArgumentParser(
        #prog='PROG',
        description='Daemon runner',
        epilog="That's all folks"
    )

    parser.add_argument('operation',
                    metavar='OPERATION',
                    type=str,
                    help='Operation with daemon. Accepts any of these values: start, stop, restart, status',
                    choices=['start', 'stop', 'restart', 'status'])

    args = parser.parse_args()
    operation = args.operation

    # Daemon
    daemon = MyDaemon('/home/darrin/python/python.pid',
    )

    if operation == 'start':
        print("Starting daemon")
        daemon.start()
        pid = daemon.get_pid()

        if not pid:
            print("Unable run daemon")
        else:
            print("Daemon is running [PID=%d]" % pid)

    elif operation == 'stop':
        print("Stoping daemon")
        daemon.stop()

    elif operation == 'restart':
        print("Restarting daemon")
        daemon.restart()
    elif operation == 'status':
        print("Viewing daemon status")
        pid = daemon.get_pid()

        if not pid:
            print("Daemon isn't running ;)")
        else:
            print("Daemon is running [PID=%d]" % pid)

    sys.exit(0)

if __name__ == '__main__':
    main()
