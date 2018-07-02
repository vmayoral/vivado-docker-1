FROM ubuntu:16.04

# Original author
  # MAINTAINER Colm Ryan <cryan@bbn.com>

MAINTAINER Víctor Mayoral Vilches <victor@erlerobotics.com>
# Fetched the Vivado installer from https://www.xilinx.com/support/download.html
# build with:
#        docker build -t vivado .

#install dependences for:
# * downloading Vivado (wget)
# * xsim (gcc build-essential to also get make)
# * MIG tool (libglib2.0-0 libsm6 libxi6 libxrender1 libxrandr2 libfreetype6 libfontconfig)
# * CI (git)
WORKDIR /
RUN apt-get update && apt-get install -y \
  wget \
  build-essential \
  libglib2.0-0 \
  libsm6 \
  libxi6 \
  libxrender1 \
  libxrandr2 \
  libfreetype6 \
  libfontconfig \
  git

# # copy in config file
# COPY install_config.txt /

# download and run the install
ARG VIVADO_TAR_HOST
ARG VIVADO_TAR_FILE
ARG VIVADO_VERSION
# RUN echo "Downloading ${VIVADO_TAR_FILE} from ${VIVADO_TAR_HOST}" && \
#   wget ${VIVADO_TAR_HOST}/${VIVADO_TAR_FILE}.tar.gz -q && \

RUN echo "Using local file: Xilinx_Vivado_Lab_Lin_2018.2_0614_1954.tar.gz"
COPY Xilinx_Vivado_Lab_Lin_2018.2_0614_1954.tar.gz /
RUN echo "Extracting Vivado tar file"
  # tar xzf ${VIVADO_TAR_FILE}.tar.gz && \
RUN tar xzf Xilinx_Vivado_Lab_Lin_2018.2_0614_1954.tar.gz

# copy in config file
COPY install_config.txt /

# Install it
RUN /Xilinx_Vivado_Lab_Lin_2018.2_0614_1954/xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --batch Install --config install_config.txt
# cleanup
RUN rm -rf Xilinx_Vivado_Lab_Lin_2018.2_0614_1954*
#make a Vivado user
RUN adduser --disabled-password --gecos '' vivado
USER vivado
WORKDIR /home/vivado
#add vivado tools to path
RUN echo "source /opt/Xilinx/Vivado/${VIVADO_VERSION}/settings64.sh" >> /home/vivado/.bashrc

#copy in the license file
RUN mkdir /home/vivado/.Xilinx
COPY Xilinx.lic /home/vivado/.Xilinx/
