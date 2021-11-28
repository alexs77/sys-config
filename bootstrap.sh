#!/bin/sh

ansible_repo_url=git@github.com:alexs77/sys-config.git

hostname="$1"
ansible_branch="$2"

echo "Setting hostname to $hostname"
hostnamectl set-hostname "$hostname"

if ! test -r ~/.ssh/id_ed25519; then
  echo "SSH Key ~/.ssh/id_ed25519 doesn't exist. Creating it..."
  ssh-keygen -t ed25519 -N '' -C 'Admin Pop!OS VM <admin@'"$hostname"'>' -f ~/.ssh/id_ed25519
  echo "Copy public key to Github - https://github.com/settings/keys"
  cat ~/.ssh/id_ed25519.pub
  read
else
  echo "SSH Key ~/.ssh/id_ed25519 exists"
fi

echo 'Dummy SSH connect to github, to add key to known_hosts'
ssh -oStrictHostKeyChecking=no -n git@github.com || :

# Create sudoers file for group adm without password
echo '# Allow members of group operator to execute any command without password
%adm	ALL=(ALL:ALL) NOPASSWD:ALL' | sudo sh -c '
  tee /etc/sudoers.d/adm-nopasswd > /dev/null
  chmod 0444 /etc/sudoers.d/adm-nopasswd
'

# Add Ansible repo
sudo sh -c '
  apt-get update
  apt-get install --yes software-properties-common
  add-apt-repository --yes --update ppa:ansible/ansible
  apt-get install -y ansible
'

# Install git
sudo apt-get install -y git

# case `lsb_release -is` in
#   Pop)
#     distrib=pop_os
#     ;;
# esac
# ansible-pull --inventory hosts --tags $distrib --url $ansible_repo_url

sudo sh -c '
  touch /var/log/ansible.log
  chown root /var/log/ansible.log
  chgrp guru /var/log/ansible.log
  chmod ug=rw,o=r /var/log/ansible.log
'

if [ "$ansible_branch" = "" ]; then
  echo "Going to use default branch on ansible repository $ansible_repo_url"
  ansible-pull --url $ansible_repo_url
else
  echo "Goint to use branch \`$ansible_branch' on ansible repository $ansible_repo_url"
  ansible-pull --url $ansible_repo_url --checkout "$ansible_branch"
fi

exit $?
