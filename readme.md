
https://azure.microsoft.com/en-us/global-infrastructure/services/?products=virtual-machines
https://github.com/NVIDIA/nvidia-docker

Ubuntu 14.04/16.04/18.04, Debian Jessie/Stretch
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi


sudo nvidia-docker build -t azadehkhojandi/pygpu3 -f az.dockerfile .
sudo docker image list
sudo nvidia-docker run -it azadehkhojandi/pygpu3
//sudo nvidia-docker run -it -p 8888:8888 azadehkhojandi/pygpu3 /bin/bash

#check Pytorch and cuda
lsb_release -a
nvcc --version
python
import  torch
torch.__version__
torch.cuda.is_available()
if torch.cuda.current_device():
  torch.cuda.get_device_name(torch.cuda.current_device())