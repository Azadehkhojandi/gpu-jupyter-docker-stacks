FROM azadehkhojandi/gpu-pytorch-notebook

ENV GPU_Arch=sm_37

USER $NB_UID

USER root

#torch version 0.4.1 torchvision
RUN  pip install --upgrade pip && \
  pip install pillow-simd && \
  pip install http://download.pytorch.org/whl/cu91/torch-0.4.0-cp36-cp36m-linux_x86_64.whl && \
  pip install torchvision==0.2.0 && rm -rf ~/.cache/pip

RUN  pip install opencv-python
RUN  pip install azure
RUN  pip install azure-storage --upgrade

COPY maskrcnn/clone.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/clone.sh
RUN chmod 777 /home/$NB_USER/work
RUN clone.sh
# ENTRYPOINT ["tini", "-g", "--"]
# CMD ["sh","-c","clone.sh && start-notebook.sh"]

# Expose port for flask app
EXPOSE 5000

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

