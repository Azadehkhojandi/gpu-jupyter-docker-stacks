FROM azadehkhojandi/gpu-minimal-notebook

USER $NB_UID

#torch version 0.3.1 torchvision
RUN  pip install --upgrade pip && \
  pip install pillow-simd && \
  pip install http://download.pytorch.org/whl/cu90/torch-0.3.1-cp36-cp36m-linux_x86_64.whl && \
  pip install torchvision==0.2.0 && rm -rf ~/.cache/pip


# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
