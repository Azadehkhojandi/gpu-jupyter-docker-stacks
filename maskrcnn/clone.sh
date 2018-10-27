
echo /home/$NB_USER/work/pytorch-mask-rcnn

if [ -d /home/$NB_USER/work/pytorch-mask-rcnn ]   
then 
    echo "repo exist"
else
    echo "repo doesn't exist"
    cd /home/$NB_USER/work
    sudo git clone https://github.com/multimodallearning/pytorch-mask-rcnn.git
    
    echo "going inside repo"
    cd pytorch-mask-rcnn
    ls
    
    echo "build 1"
    cd nms/src/cuda/
    nvcc -c -o nms_kernel.cu.o nms_kernel.cu -x cu -Xcompiler -fPIC -arch=$GPU_Arch
    cd ../../
    python build.py
    cd ../

    echo "build 2"
    cd roialign/roi_align/src/cuda/
    nvcc -c -o crop_and_resize_kernel.cu.o crop_and_resize_kernel.cu -x cu -Xcompiler -fPIC -arch=GPU_Arch
    cd ../../
    python build.py
    cd ../../

    echo "add cocoapi as submodule"
    git submodule add https://github.com/cocodataset/cocoapi.gi pytorch-mask-rcnn/cocoapi

    echo "build/settings cocoapi"
    cd cocoapi/PythonAPI
    make
    cd ../..

    echo "getting weights"
    wget 'https://azpublicblob.blob.core.windows.net/public/mask_rcnn_coco.pth'
    wget 'https://azpublicblob.blob.core.windows.net/public/resnet50_imagenet.pth'


fi