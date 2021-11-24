#!/bin/sh

ansible_repo_url=https://github.com/alexs77/sys-config.git

# Add Ansible repo
sudo sh -c '
  apt-get update
  apt-get install --yes software-properties-common
  add-apt-repository --yes --update ppa:ansible/ansible
  apt-get install -y ansible
'

# Install git
sudo apt-get install -y git

case `lsb_release -is` in
  Pop)
    distrib=pop_os
    ;;
esac

ansible-pull --inventory hosts --tags $distrib --url $ansible_repo_url

exit $?
