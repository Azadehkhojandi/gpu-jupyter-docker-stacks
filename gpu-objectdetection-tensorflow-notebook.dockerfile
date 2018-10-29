FROM azadehkhojandi/gpu-minimal-notebook

USER root

RUN pip install tensorflow-gpu
RUN sudo apt-get update


RUN apt-get -y install  python-pil python-lxml python-tk
RUN pip install --user Cython
RUN pip install --user contextlib2



RUN mkdir -p /tensorflow/models
RUN git clone https://github.com/tensorflow/models.git /tensorflow/models

WORKDIR /tensorflow/models/research

# From tensorflow/models/research/
RUN wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip
RUN unzip protobuf.zip -d protoc330
RUN export PROTOC="$(pwd)/protoc330/bin/protoc"
# From tensorflow/models/research/
RUN "$PROTOC" object_detection/protos/*.proto --python_out=.

RUN export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim


# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
