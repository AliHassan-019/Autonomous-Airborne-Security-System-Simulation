FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    ninja-build \
    python3-pip \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    python3-venv \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    libssl-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libatlas-base-dev \
    gfortran \
    libhdf5-serial-dev \
    libopenblas-dev \
    libblas-dev \
    liblapack-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 \
    gstreamer1.0-pulseaudio \
    udev \
    wget \
    curl \
    unzip \
    pkg-config \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install Gazebo
RUN curl -sSL https://get.gazebo.org | sh

# Create workspace directory
RUN mkdir -p /home/px4/PX4_Files

# Set up Python environment
RUN python3 -m venv /opt/uav_cv_env
ENV PATH="/opt/uav_cv_env/bin:$PATH"
RUN pip install --upgrade pip && \
    pip install \
    numpy \
    opencv-python \
    ultralytics \
    torch \
    torchvision \
    gstreamer-python \
    mavsdk

# Clone PX4
WORKDIR /home/px4/PX4_Files
RUN git clone https://github.com/PX4/PX4-Autopilot.git && \
    cd PX4-Autopilot && \
    git checkout v1.14.0 && \
    make submodulesclean && \
    make submodulesupdate

# Set up environment variables
ENV GAZEBO_PLUGIN_PATH=/home/px4/PX4_Files/PX4-Autopilot/build/px4_sitl_default/build_gazebo-classic
ENV GAZEBO_MODEL_PATH=/home/px4/PX4_Files/PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_gazebo-classic/models
ENV LD_LIBRARY_PATH=/home/px4/PX4_Files/PX4-Autopilot/build/px4_sitl_default/build_gazebo-classic

# Set working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"] 