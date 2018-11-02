FROM azadehkhojandi/gpu-minimal-notebook

ENV GPU_Arch=sm_37

USER $NB_UID

# USER root

RUN chown -R $NB_UID /home/$NB_USER

#torch version 0.4.1 torchvision
RUN  pip install --upgrade pip && \
  pip install pillow-simd && \
  pip install http://download.pytorch.org/whl/cu91/torch-0.4.0-cp36-cp36m-linux_x86_64.whl && \
  pip install torchvision==0.2.0 && rm -rf ~/.cache/pip

RUN  pip install opencv-python
RUN  pip install azure
RUN  pip install azure-storage --upgrade

#COPY maskrcnn/clone.sh /usr/local/bin/
#RUN chmod +x /usr/local/bin/clone.sh
#RUN chmod 777 /home/$NB_USER/work
#RUN clone.sh
# ENTRYPOINT ["tini", "-g", "--"]
# CMD ["sh","-c","clone.sh && start-notebook.sh"]

RUN cd /home/$NB_USER && \
  git clone https://github.com/Azadehkhojandi/pytorch-mask-rcnn.git

RUN ls /home/$NB_USER/pytorch-mask-rcnn

# Build nms
RUN cd /home/$NB_USER/pytorch-mask-rcnn/nms/src/cuda/ && \
  nvcc -c -o nms_kernel.cu.o nms_kernel.cu -x cu -Xcompiler -fPIC -arch=$GPU_Arch && \
  cd ../.. && \
  python build.py

# Build roi_align
RUN cd /home/$NB_USER/pytorch-mask-rcnn/roialign/roi_align/src/cuda && \
  nvcc -c -o crop_and_resize_kernel.cu.o crop_and_resize_kernel.cu -x cu -Xcompiler -fPIC -arch=$GPU_Arch && \
  cd ../.. && \
  python build.py

# Clone cocoapi
RUN cd /home/$NB_USER/pytorch-mask-rcnn && \
  git clone https://github.com/cocodataset/cocoapi.git && \
  ls -l && \
  cd cocoapi && \
  ls && cd PythonAPI && \
  make

RUN ln -s /home/$NB_USER/pytorch-mask-rcnn/cocoapi/PythonAPI/pycocotools /home/$NB_USER/pytorch-mask-rcnn/pycocotools

# Get the model
RUN cd /home/$NB_USER/pytorch-mask-rcnn && \
  wget 'https://azpublicblob.blob.core.windows.net/public/mask_rcnn_coco.pth'

# Expose port for flask app
EXPOSE 5000

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

