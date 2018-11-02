Stack of GPU Docker files based on nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04. 
All of the docker images has been tested on Azure GPU VM NC6

# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
`$ sudo docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f`

`$ sudo apt-get purge -y nvidia-docker`

# Add the package repositories
```
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
```

`$ sudo apt-get update`

# Install nvidia-docker2 and reload the Docker daemon configuration
`$ sudo apt-get install -y nvidia-docker2`

`$ sudo pkill -SIGHUP dockerd`

# Test nvidia-smi with the latest official CUDA image
`$ sudo docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi`

`$ sudo docker login`

#test jupyter 
`$ sudo docker pull jupyter/minimal-notebook`

`$ sudo  docker run --rm -p 8888:8888 -v "$PWD":/home/jovyan/work jupyter/minimal-notebook `

#set up your workspace folder - ideally on the attached disk 
`$ mkdir myworkspace`

`$ cd myworkspace/`

`$ chmod 777 $PWD`

# pull image from docker hub

## basic gpu jupyter notebook 
`$ sudo docker pull azadehkhojandi/gpu-minimal-notebook`

`$ sudo nvidia-docker run --rm -p 8888:8888  -v "$PWD":/home/jovyan/work azadehkhojandi/gpu-minimal-notebook`

## mask rcnn pytorch notebook 

`$ sudo docker pull azadehkhojandi/gpu-maskrcnn-pytorch-notebook`

`$ sudo nvidia-docker run --rm -p 8888:8888  -v "$PWD":/home/jovyan/work azadehkhojandi/gpu-maskrcnn-pytorch-notebook`




# GPU VM - Azure NC6 
add port 8888 into network panel
http://{publicipofvm}:8888/?token={token after running azadehkhojandi/pytorchgpujupyter }
check gpu on vm
`$ lsb_release -a`




# Check Pytorch and cuda - inside container
`$ nvcc --version`

```
import torch
print('Torch version:',torch.__version__)
print('Is cuda available:',torch.cuda.is_available())
if torch.cuda.is_available():
    print('Graphic card name:',torch.cuda.get_device_name(torch.cuda.current_device()))
```
If torch can not be found run `pip install torch`


# Mask RCNN - inside container
From the folder myworkspace created above:
`$ git clone https://github.com/multimodallearning/pytorch-mask-rcnn.git`

for NC6
| Tesla K80 | sm_37 |

```
cd pytorch-mask-rcnn
cd nms/src/cuda/
nvcc -c -o nms_kernel.cu.o nms_kernel.cu -x cu -Xcompiler -fPIC -arch=sm_37
cd ../../
python build.py
cd ../
```
```
cd roialign/roi_align/src/cuda/
nvcc -c -o crop_and_resize_kernel.cu.o crop_and_resize_kernel.cu -x cu -Xcompiler -fPIC -arch=sm_37
cd ../../
python build.py
cd ../../
```
When running build.py, if you received the error:
```
/home/jovyan/work/myworkspace/pytorch-mask-rcnn/roialign/roi_align/src/crop_and_resize.c:124:33: error: dereferencing pointer to incomplete type ‘THTensor {aka struct THTensor}’
    const int batch_size = image->size[0];
```
Run the command `pip install http://download.pytorch.org/whl/cu91/torch-0.4.0-cp36-cp36m-linux_x86_64.whl` rather than the standard `pip install torch` 
The github issues found here: https://github.com/longcw/RoIAlign.pytorch/issues/11 say it can be fixed by installing pytorch

`$ git clone https://github.com/cocodataset/cocoapi.git`

```
$ cd cocoapi/PythonAPI
make
cd ../..
```

`$ wget 'https://azpublicblob.blob.core.windows.net/public/mask_rcnn_coco.pth'`

`$ ln -s cocoapi/PythonAPI/pycocotools pycocotools`

`$ pip install scikit-image matplotlib scipy  h5py`

`$ python demo.py`

# Install Az copy - inside container
https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-linux
In order to do the following steps, the docker container must be launched with `sudo nvidia-docker run --rm --privileged -p 8888:8888 -e GRANT_SUDO=yes --user root -v "$PWD":/home/jovyan/work azadehkhojandi/gpu-minimal-notebook`. This grants sudo privileges inside of the container

`$ echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod/ xenial main" > azure.list`

`$ sudo cp ./azure.list /etc/apt/sources.list.d/`

`$ sudo apt-key adv --keyserver packages.microsoft.com --recv-keys EB3E94ADBE1229CF`

`$ sudo apt-get update`

`$ sudo apt-get install azcopy`

`$ nano demo.py`

update "# Visualize results" to following
```
# Visualize results
r = results[0]
print(r['rois'])
print(r['masks'])
print(r['class_ids'])
print(class_names)
print(r['scores'])
visualize.display_instances(image, r['rois'], r['masks'], r['class_ids'],
                            class_names, r['scores'])
plt.savefig('result.jpg')
```

`python demo.py`
you should be able to see 'result.jpg' created 

`cv2`
pip install opencv-python

pip install azure
pip install azure-storage --upgrade




* note => replace `azadehkhojandi` with your dockerhub or azure container regisetry username

# Buidling gpu-minimal-notebook image from docker file 
`$ sudo nvidia-docker build -t azadehkhojandi/gpu-minimal-notebook -f gpu-minimal-notebook.dockerfile .`

`$ sudo docker image list`

`$ sudo nvidia-docker tag {imageid} azadehkhojandi/gpu-minimal-notebook:barebone`

`$ sudo nvidia-docker push azadehkhojandi/gpu-minimal-notebook`

`$ sudo nvidia-docker run --rm -p 8888:8888  -v "$PWD":/home/jovyan/work azadehkhojandi/gpu-minimal-notebook`

# Buidling gpu-pytorch-notebook image from docker file 
`$ sudo nvidia-docker build -t azadehkhojandi/gpu-pytorch-notebook -f gpu-pytorch-notebook.dockerfile .`

`$ sudo docker image list`

`$ sudo nvidia-docker tag {imageid} azadehkhojandi/gpu-pytorch-notebook:barebone`

`$ sudo nvidia-docker push azadehkhojandi/gpu-pytorch-notebook`

`$ sudo nvidia-docker run --rm -p 8888:8888  -v "$PWD":/home/jovyan/work azadehkhojandi/gpu-pytorch-notebook`

# Buidling pu-objectdetection-tensorflow-notebook image from docker file 
* wip - unstable
`$ sudo nvidia-docker build -t azadehkhojandi/gpu-objectdetection-tensorflow-notebook -f gpu-objectdetection-tensorflow-notebook.dockerfile .`

`$ sudo docker image list`

`$ sudo nvidia-docker tag {imageid} azadehkhojandi/gpu-objectdetection-tensorflow-notebook:barebone`

`$ sudo nvidia-docker push azadehkhojandi/gpu-objectdetection-tensorflow-notebook`

`$ sudo nvidia-docker run --rm -p 8888:8888  -v "$PWD":/home/jovyan/work azadehkhojandi/gpu-objectdetection-tensorflow-notebook`


# Buidling gpu-maskrcnn-pytorch-notebook image from docker file 
* wip - unstable
`$ sudo nvidia-docker build -t azadehkhojandi/gpu-maskrcnn-pytorch-notebook -f gpu-maskrcnn-pytorch-notebook.dockerfile .`

`$ sudo docker image list`

`$ sudo nvidia-docker tag {imageid} azadehkhojandi/gpu-maskrcnn-pytorch-notebook:barebone`

`$ sudo nvidia-docker push azadehkhojandi/gpu-maskrcnn-pytorch-notebook`

`$ sudo nvidia-docker run --rm -p 8888:8888  -v "$PWD":/home/jovyan/work azadehkhojandi/gpu-maskrcnn-pytorch-notebook`

# References

https://azure.microsoft.com/en-us/global-infrastructure/services/?products=virtual-machines

https://github.com/NVIDIA/nvidia-docker

http://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/

https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile

https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook

http://goinbigdata.com/docker-run-vs-cmd-vs-entrypoint/

https://towardsdatascience.com/tensorflow-object-detection-with-docker-from-scratch-5e015b639b0b

