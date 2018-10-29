echo /home/$NB_USER/work/pytorch-mask-rcnn
if [ -d /home/$NB_USER/work/pytorch-mask-rcnn ]   
then 
    echo "repo exist"
else
    echo "repo doesn't exist"
    git clone https://github.com/multimodallearning/pytorch-mask-rcnn.git
    echo "going inside repo"
    cd pytorch-mask-rcnn
    ls
    chmod 777 /home/$NB_USER/work/pytorch-mask-rcnn
    echo "getting weights"
    wget 'https://azpublicblob.blob.core.windows.net/public/mask_rcnn_coco.pth'
    wget 'https://azpublicblob.blob.core.windows.net/public/resnet50_imagenet.pth'
    echo "build 1"
    cd nms/src/cuda/
    nvcc -c -o nms_kernel.cu.o nms_kernel.cu -x cu -Xcompiler -fPIC -arch=$GPU_Arch
    cd ../../
    python build.py
    cd ../
    echo "build 2"
    cd roialign/roi_align/src/cuda/
    nvcc -c -o crop_and_resize_kernel.cu.o crop_and_resize_kernel.cu -x cu -Xcompiler -fPIC -arch=$GPU_Arch
    cd ../../
    python build.py
    cd ../../
    echo "clone cocoapi"
    git clone https://github.com/cocodataset/cocoapi.git
    echo "build/settings cocoapi"
    cd cocoapi/PythonAPI
    make
    cd ../..
    
fi
