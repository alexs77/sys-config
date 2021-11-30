#!/bin/bash

# This file is managed by Ansible. Keep your hands off it!


#### Clear log files
find /var/log -type f -name "*log" -exec truncate -s 0 {} \;
truncate -s 0 /var/log/*tmp


#### Clear user files
find /home /root -type f -name .bash_history -exec rm {} '+'
find /home /root -type f -name .viminfo -exec rm {} '+'
