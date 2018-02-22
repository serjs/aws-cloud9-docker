#!/bin/bash
mkdir /root/.ssh
chmod 700 /root/.ssh
echo $SSH_PUBLIC_KEY > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

/usr/sbin/sshd -D