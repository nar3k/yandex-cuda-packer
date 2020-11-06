#!/bin/bash


wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.2.148-1_amd64.deb
dpkg -i cuda-repo-ubuntu1604_9.2.148-1_amd64.deb
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
apt-get update -y
sudo apt-get install -y cuda-9-2
echo 'export PATH=/usr/local/cuda-9.2/bin:$PATH' |  sudo tee -a  /etc/profile.d/cuda.sh
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib64' | sudo tee -a  /etc/profile.d/ld.sh
