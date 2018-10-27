FROM azadehkhojandi/gpu-minimal-notebook

ENV GPU_Arch=sm_37

USER $NB_UID

RUN  pip install opencv-python
RUN  pip install azure
RUN  pip install azure-storage --upgrade

USER root

COPY maskrcnn/clone.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/clone*
RUN ls /usr/local/bin/
CMD ["clone.sh"]



# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

