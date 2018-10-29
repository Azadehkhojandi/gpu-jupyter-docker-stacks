FROM azadehkhojandi/gpu-minimal-notebook

USER root

RUN pip install tensorflow-gpu

RUN sudo apt-get install protobuf-compiler python-pil python-lxml python-tk
RUN pip install --user Cython
RUN pip install --user contextlib2

RUN mkdir -p /tensorflow/models
RUN git clone https://github.com/tensorflow/models.git /tensorflow/models

WORKDIR /tensorflow/models/research
RUN protoc object_detection/protos/*.proto --python_out=.
RUN export PYTHONPATH=$PYTHONPATH:'pwd':'pwd'/slim


# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
