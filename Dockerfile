# Copyright (c) MONAI Consortium
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# To build with a different base image
# please run `./runtests.sh --clean && DOCKER_BUILDKIT=1 docker build -t projectmonai/monailabel:latest .`
# to use different version of MONAI pass `--build-arg MONAI_IMAGE=...`

# Use the NVIDIA base image with CUDA and cuDNN
# To test the CUDA run docker run --rm --gpus all nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04 nvidia-smi
FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04 as base

RUN apt-get update && apt-get install -y \
    python3-pip \
    python3 \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

FROM node:slim as ohifbuild
ADD . /opt/monailabel
RUN apt update -y && apt install -y git
RUN cd /opt/monailabel/plugins/ohifv3 && ./build.sh

FROM projectmonai/monai:1.3.1 as build
LABEL maintainer="monai.contact@gmail.com"

ADD . /opt/monailabel/
COPY --from=ohifbuild /opt/monailabel/monailabel/endpoints/static/ohif /opt/monailabel/monailabel/endpoints/static/ohif
RUN python -m pip install --upgrade --no-cache-dir pip setuptools wheel twine \
    && cd /opt/monailabel \
    && BUILD_OHIF=false python setup.py sdist bdist_wheel --build-number $(date +'%Y%m%d%H%M')

FROM base
LABEL maintainer="monai.contact@gmail.com"

COPY --from=build /opt/monailabel/dist/monailabel* /opt/monailabel/dist/
WORKDIR /opt/monailabel
RUN python -m pip install --upgrade --no-cache-dir pip \
    && python -m pip install /opt/monailabel/dist/monailabel*.whl

# Copy the entrypoint script
COPY entrypoint.sh /opt/monailabel/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/opt/monailabel/entrypoint.sh"]
    
    
    
# Execute these in the container.
# # download Radiology sample app to local directory
# monailabel apps --name radiology --download --output .
# 
# # download Task 2 MSD dataset
# monailabel datasets --download --name Task09_Spleen --output .
# 
# # start the Radiology app in MONAI label server
# # and start annotating the downloaded images using deepedit model
# monailabel start_server --app radiology --studies Task09_Spleen/imagesTr --conf models deepedit
