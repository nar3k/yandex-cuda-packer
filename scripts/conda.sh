#!/bin/bash


wget https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh
bash ~/Anaconda3-2020.07-Linux-x86_64.sh -b -p /usr/local/anaconda/

echo 'export PATH=/usr/local/anaconda/bin:$PATH' |  sudo tee -a  /etc/profile.d/anaconda.sh
/usr/local/anaconda/bin/conda install -y  pytorch==1.4.0 torchvision==0.5.0 cudatoolkit=9.2 -c pytorch