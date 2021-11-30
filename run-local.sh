#!/bin/sh

exec ansible-playbook local.yml -l localhost -e @host_vars/localhost "$@"
