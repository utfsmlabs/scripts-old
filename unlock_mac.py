#!/usr/bin/env python

import paramiko
from random import Random
import sys
from getpass import getpass

def generate_pass(length = 5, althands = True):

    righthand = '23456qwertasdfgzxcvb'
    lefthand = '789yuiophjknm'
    allchars = righthand + lefthand

    rng = Random()
    if not althands:
        return ''.join([rng.choice(allchars) for i in range(length)])
    else:
        return ''.join([rng.choice(righthand) if i % 2 == 0 else rng.choice(lefthand) for i in range(length)])

def main(argv=None):
    if len(argv) < 2:
        return help(argv)

    user_passwd =  generate_pass()

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        try:
            ssh.connect(argv[1], username='root')
        except paramiko.SSHException:
            passwd = getpass('Root password: ')
            ssh.connect(argv[1], username='root', password=passwd)
    except Exception as e:
        print e

    stdin, stdout, stderr = ssh.exec_command(
        'dscl localhost -passwd /Search/Users/alumno {}'.format(user_passwd)
        )

    print 'User password: {}'.format(user_passwd)

def help(argv):
    print '{} [hostname]'.format(argv[0])
    return 0

if __name__ == '__main__':
    main(sys.argv)

