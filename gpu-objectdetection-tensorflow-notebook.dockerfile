FROM azadehkhojandi/gpu-minimal-notebook

USER $NB_UID

RUN pip install tensorflow-gpu

RUN sudo apt-get install protobuf-compiler python-pil python-lxml python-tk
RUN pip install --user Cython
RUN pip install --user contextlib2


# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
