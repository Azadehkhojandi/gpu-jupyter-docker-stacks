
https://azure.microsoft.com/en-us/global-infrastructure/services/?products=virtual-machines
https://github.com/NVIDIA/nvidia-docker
http://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/


Ubuntu 14.04/16.04/18.04, Debian Jessie/Stretch
# ON NC6 VM

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


sudo docker login

sudo nvidia-docker build -t azadehkhojandi/pytorchgpu -f az.dockerfile .
sudo nvidia-docker build -t azadehkhojandi/pytorchgpujupyter -f az.dockerfile .
sudo docker image list
sudo nvidia-docker run -it azadehkhojandi/pytorchgpu
sudo nvidia-docker tag {imageid} azadehkhojandi/pytorchgpu:barebone
sudo nvidia-docker push azadehkhojandi/pytorchgpu

//sudo nvidia-docker run -it -p 8888:8888 azadehkhojandi/pygpu3 /bin/bash

docker pull jupyter/minimal-notebook
sudo  docker run --rm -p 8888:8888  jupyter/minimal-notebook  -v "$PWD":/home/jovyan/work
sudo nvidia-docker run --rm -p 8888:8888    azadehkhojandi/pytorchgpujupyter -v "$PWD":/home/jovyan
sudo nvidia-docker run -it azadehkhojandi/pytorchgpujupyter
http://104.210.69.179:8888/?token=ca124b48f49a5e31a4a9409286ed64084c90f93a08c6ba66




#check Pytorch and cuda
lsb_release -a
nvcc --version
python
import  torch
torch.__version__
torch.cuda.is_available()
if torch.cuda.current_device():
  torch.cuda.get_device_name(torch.cuda.current_device())

# Mask RCNN - inside container
`git clone https://github.com/multimodallearning/pytorch-mask-rcnn.git`

for NC6
| Tesla K80 | sm_37 |

`cd nms/src/cuda/
 nvcc -c -o nms_kernel.cu.o nms_kernel.cu -x cu -Xcompiler -fPIC -arch=sm_37
 cd ../../
 python build.py
 cd ../`

 `cd roialign/roi_align/src/cuda/
 nvcc -c -o crop_and_resize_kernel.cu.o crop_and_resize_kernel.cu -x cu -Xcompiler -fPIC -arch=sm_37
 cd ../../
 python build.py
 cd ../../`

`git clone https://github.com/cocodataset/cocoapi.git`
`cd cocoapi/PythonAPI`
`make`
`cd ../..`

 `wget 'https://azpublicblob.blob.core.windows.net/public/mask_rcnn_coco.pth'`

 `ln -s cocoapi/PythonAPI/pycocotools/ pycocotools`

 `pip install scikit-image matplotlib scipy  h5py`

 `python demo.py`

# Install Az copy in the container 
https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-linux

`echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod/ xenial main" > azure.list`
`sudo cp ./azure.list /etc/apt/sources.list.d/`
`sudo apt-key adv --keyserver packages.microsoft.com --recv-keys EB3E94ADBE1229CF`
`sudo apt-get update`
`sudo apt-get install azcopy`

`vim demo.py`
update # Visualize results to following
`# Visualize results
r = results[0]
print(r['rois'])
print(r['masks'])
print(r['class_ids'])
print(class_names)
print(r['scores'])
visualize.display_instances(image, r['rois'], r['masks'], r['class_ids'],
                            class_names, r['scores'])
plt.savefig('result.jpg')
`

`python demo.py`
you should be able to see 'result.jpg' created 


oneweek3@oneweek3:~/aztest$ sudo nvidia-docker run --rm -p 8888:8888    azadehkhojandi/pytorchgpujupyter -v "$PWD":/home/jovyan/work
[FATAL tini (8)] exec -v failed: No such file or directory




