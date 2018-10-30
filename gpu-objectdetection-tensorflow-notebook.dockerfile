FROM azadehkhojandi/gpu-minimal-notebook


USER $NB_UID
RUN pip install tensorflow-gpu

USER root
RUN sudo apt-get update
RUN sudo apt-get -y install  apt-utils
RUN sudo apt-get -y install  python-pil python-lxml python-tk

USER $NB_UID
RUN pip install --user Cython
RUN pip install --user contextlib2
RUN mkdir -p /tensorflow/models
RUN git clone https://github.com/tensorflow/models.git /tensorflow/models
WORKDIR /tensorflow/models/research
# From tensorflow/models/research/
RUN wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip
RUN unzip protobuf.zip -d protoc330
RUN export PROTOC="$(pwd)/protoc330/bin/protoc"
RUN chmod 777 /tensorflow/models/research
RUN chmod 777 $(pwd)/protoc330/bin/protoc

# From tensorflow/models/research/
RUN "$PROTOC" object_detection/protos/*.proto --python_out=.
RUN echo $PYTHONPATH
RUN export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
RUN echo $PYTHONPATH

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
