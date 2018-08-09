#!/bin/bash

wget primos/authorized_keys
mkdir /root/.ssh
cp authorized_keys /root/.ssh/
