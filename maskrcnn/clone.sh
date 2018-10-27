
ls /usr/local/bin/

echo /home/$NB_USER/work/pytorch-mask-rcnn

if [ -d /home/$NB_USER/work/pytorch-mask-rcnn ]   
then 
    echo "repo exist"
else
    echo "repo doesnot exist"
    cd /home/$NB_USER/work
    git clone https://github.com/multimodallearning/pytorch-mask-rcnn.git
    
    cd pytorch-mask-rcnn
    
    cd nms/src/cuda/
    nvcc -c -o nms_kernel.cu.o nms_kernel.cu -x cu -Xcompiler -fPIC -arch=$GPU_Arch
    cd ../../
    python build.py
    cd ../

    cd roialign/roi_align/src/cuda/
    nvcc -c -o crop_and_resize_kernel.cu.o crop_and_resize_kernel.cu -x cu -Xcompiler -fPIC -arch=GPU_Arch
    cd ../../
    python build.py
    cd ../../

    git submodule add https://github.com/cocodataset/cocoapi.gi pytorch-mask-rcnn/cocoapi

    cd cocoapi/PythonAPI
    make
    cd ../..

    wget 'https://azpublicblob.blob.core.windows.net/public/mask_rcnn_coco.pth'
    wget 'https://azpublicblob.blob.core.windows.net/public/resnet50_imagenet.pth'


fi