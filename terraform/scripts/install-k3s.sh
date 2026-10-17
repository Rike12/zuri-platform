#!/bin/bash
set -e

curl -sfL https://get.k3s.io | sh -

systemctl enable k3s
systemctl start k3s

mkdir -p /home/ec2-user/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/.kube/config
chown -R ec2-user:ec2-user /home/ec2-user/.kube
chmod 600 /home/ec2-user/.kube/config
