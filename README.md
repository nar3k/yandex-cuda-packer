# Creates Image with Cuda , Anaconda and Pytorch

This repo shows how to create image with custom cuda version in Yandex Cloud for GPU Instances with Packer.


### Prerequisites


1) Account in Yandex.Cloud and  quota enought for 1 GPU VM - 1 GPU, 8 Cores, 96 Gb of ram , 33 Gb SSd Disk . Quotas can be found [here](https://console.cloud.yandex.ru/cloud?section=quotas)
2) Installed  [packer](https://www.packer.io) (you can archive it into the binary) and jq
3) Some bash shell 
4) Installed and initiated [Yandex.Cloud Cli](https://cloud.yandex.com/docs/cli/quickstart)


## Part One - Image creation with packer

1) Please export variables for packer to work


```
export YC_TOKEN=$(yc config get token)
export YC_FOLDER_ID=$(yc config get folder-id)
```

2) Then you can get this repo and execute packer recipe 

```
git clone https://github.com/nar3k/yandex-cuda-packer.git
cd yandex-cuda-packer
$ packer build cuda-packer-ubuntu.json
```

and wait for about 20 minutes untill it ends.
You should see output like that if it works ok

```
Build 'yandex' finished after 20 minutes 23 seconds.

==> Wait completed after 20 minutes 23 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: ubuntu-16-cuda-2020-11-06t13-44-00z (id: fd8421dcoahht6qb7ocl) with family name ubuntu-16-cuda
```


3) Create a Vm with this image 

```
$ yc compute instance create \
      --name gpu-instance \
      --zone ru-central1-a \
      --hostname gpu-instance \
      --platform-id=gpu-standard-v1 \
      --cores=8 \
      --memory=96 \
      --gpus=1 \
      --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
      --create-boot-disk image-family=ubuntu-16-cuda \
      --ssh-key ~/.ssh/id_rsa.pub
```


1) ssh to the VM

```
#get vm ip address
export GPU_VM_IP=$(yc compute  instance get  --name=gpu-instance --format=json | jq -r .network_interfaces[0].primary_v4_address.one_to_one_nat.address)

#wait untill you get pings 

$ ping $GPU_VM_IP
PING 84.201.132.119 (84.201.132.119): 56 data bytes
64 bytes from 84.201.132.119: icmp_seq=0 ttl=251 time=25.706 ms
64 bytes from 84.201.132.119: icmp_seq=1 ttl=251 time=25.280 ms
^C
--- 84.201.132.119 ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 25.280/25.493/25.706/0.213 ms
nrkk-osx:cuda-packer nrkk$

# ssh to it with default user 

$ ssh yc-user@$GPU_VM_IP
```


check that torch and cuda are available

```
$ nvcc -V
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2018 NVIDIA Corporation
Built on Tue_Jun_12_23:07:04_CDT_2018
Cuda compilation tools, release 9.2, V9.2.148

nrkk@gpu-instance:~$ python
Python 3.8.3 (default, Jul  2 2020, 16:21:59)
[GCC 7.3.0] :: Anaconda, Inc. on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import torch
>>> print(torch.__version__)
1.4.0
>>> torch.cuda.is_available()
True
>>> torch.cuda.get_device_name(0)
'Tesla V100-PCIE-32GB'
>>> exit()
```

https://forums.developer.nvidia.com/t/older-versions-of-cuda/108163

