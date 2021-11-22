#!/bin/sh

ansible_repo_url=https://github.com/alexs77/sys-config.git

sudo apt-get update
sudo apt-get install -y git ansible

case `lsb_release -is` in
  Pop)
    distrib=pop_os
    ;;
esac

ansible-pull -i $distrib -U $ansible_repo_url

exit $?