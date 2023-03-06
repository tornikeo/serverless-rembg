# Must use a Cuda version 11+
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime
# FROM nvidia/cuda:11.6.0-runtime-ubuntu18.04

ENV DEBIAN_FRONTEND noninteractive

# Install git
RUN apt-get update && apt-get install -y git

# RUN rm /etc/apt/sources.list.d/cuda.list || true
# RUN rm /etc/apt/sources.list.d/nvidia-ml.list || true
# RUN apt-key del 7fa2af80
# RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
# RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

# RUN apt update -y
# RUN apt upgrade -y
# RUN apt install -y curl wget software-properties-common
# RUN add-apt-repository ppa:deadsnakes/ppa
# RUN apt install -y python3.9 python3.9-distutils
# RUN curl https://bootstrap.pypa.io/get-pip.py | python3.9

WORKDIR /workdir

COPY rembg /workdir/rembg/

RUN cd /workdir/rembg && python3.9 -m pip install .[gpu]

RUN mkdir -p /root/.u2net
# RUN wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2netp.onnx -O ~/.u2net/u2netp.onnx
RUN wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net.onnx -O ~/.u2net/u2net.onnx
# RUN wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net_human_seg.onnx -O ~/.u2net/u2net_human_seg.onnx
# RUN wget https://github.com/danielgatis/rembg/releases/download/v0.0.0/u2net_cloth_seg.onnx -O ~/.u2net/u2net_cloth_seg.onnx

# EXPOSE 5000
# ENTRYPOINT ["rembg"]
# CMD ["--help"]


# Install python packages
RUN pip3 install --upgrade pip
ADD requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

# # We add the banana boilerplate here
# ADD server.py .

# # Add your model weight files 
# # (in this case we have a python script)
# ADD download.py .
# RUN python3 download.py


# # Add your custom app code, init() and inference()
# ADD app.py .

EXPOSE 8000

CMD python3 -u server.py
