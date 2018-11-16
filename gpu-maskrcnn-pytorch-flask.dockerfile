FROM azadehkhojandi/gpu-minimal-notebook

ENV GPU_Arch=sm_37

USER $NB_UID

# Install pytorch 0.4.0
RUN  pip install --upgrade pip && \
  pip install pillow-simd && \
  pip install http://download.pytorch.org/whl/cu90/torch-0.4.0-cp36-cp36m-linux_x86_64.whl && \
  pip install torchvision==0.2.0 && rm -rf ~/.cache/pip

USER root
COPY ./maskrcnn/cloneflask.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/cloneflask.sh
RUN chmod 777 /home/$NB_USER/work
RUN cloneflask.sh

RUN pip install flask
RUN pip install wget
RUN chmod -R 777 /home/$NB_USER/work

CMD cd /home/$NB_USER/work/pytorch-mask-rcnn-flask && \
  python application.py

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

