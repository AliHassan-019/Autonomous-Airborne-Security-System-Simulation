#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting UAV Security System Toolchain Setup...${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root or with sudo${NC}"
    exit 1
fi

# Update system
echo -e "${YELLOW}Updating system packages...${NC}"
apt update && apt upgrade -y

# Install basic dependencies
echo -e "${YELLOW}Installing basic dependencies...${NC}"
apt install -y \
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
    software-properties-common

# Install Docker
echo -e "${YELLOW}Installing Docker...${NC}"
# Remove old versions if they exist
apt remove -y docker docker-engine docker.io containerd runc

# Install prerequisites
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
apt update
apt install -y docker-ce docker-ce-cli containerd.io

# Add user to docker group
usermod -aG docker $SUDO_USER

# Start Docker service
systemctl start docker
systemctl enable docker

# Install PX4
echo -e "${YELLOW}Installing PX4...${NC}"
cd /opt
git clone https://github.com/PX4/PX4-Autopilot.git
cd PX4-Autopilot
git checkout v1.14.0  # Latest stable tag
make submodulesclean
make submodulesupdate
make px4_sitl_default

# Install Gazebo Harmonic
echo -e "${YELLOW}Installing Gazebo Harmonic...${NC}"
curl -sSL https://get.gazebo.org | sh
apt install -y ignition-fortress

# Install QGroundControl
echo -e "${YELLOW}Installing QGroundControl...${NC}"
wget https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage
chmod +x QGroundControl.AppImage
mv QGroundControl.AppImage /usr/local/bin/QGroundControl

# Install MAVSDK-Python
echo -e "${YELLOW}Installing MAVSDK-Python...${NC}"
pip3 install mavsdk

# Create Python virtual environment for CV processing
echo -e "${YELLOW}Setting up Python virtual environment...${NC}"
python3 -m venv /opt/uav_cv_env
source /opt/uav_cv_env/bin/activate
pip install --upgrade pip
pip install \
    numpy \
    opencv-python \
    ultralytics \
    torch \
    torchvision \
    gstreamer-python \
    mavsdk

# Create udev rules for MAVLink
echo -e "${YELLOW}Creating udev rules...${NC}"
cat > /etc/udev/rules.d/99-px4.rules << EOF
SUBSYSTEM=="tty", ATTRS{idVendor}=="26ac", ATTRS{idProduct}=="0011", MODE="0666"
SUBSYSTEM=="tty", ATTRS{idVendor}=="26ac", ATTRS{idProduct}=="1011", MODE="0666"
EOF

# Reload udev rules
udevadm control --reload-rules
udevadm trigger

# Create environment setup script
echo -e "${YELLOW}Creating environment setup script...${NC}"
cat > /etc/profile.d/uav_env.sh << EOF
# PX4 environment
export PX4_HOME=/opt/PX4-Autopilot
export PATH=\$PATH:\$PX4_HOME/Tools

# Gazebo environment
export GAZEBO_MODEL_PATH=\$GAZEBO_MODEL_PATH:/opt/PX4-Autopilot/Tools/sitl_gazebo/models
export GAZEBO_PLUGIN_PATH=\$GAZEBO_PLUGIN_PATH:/opt/PX4-Autopilot/Tools/sitl_gazebo/build
export GAZEBO_RESOURCE_PATH=\$GAZEBO_RESOURCE_PATH:/opt/PX4-Autopilot/Tools/sitl_gazebo/worlds

# Python environment
export PYTHONPATH=\$PYTHONPATH:/opt/uav_cv_env/lib/python3.10/site-packages
EOF

# Make setup script executable
chmod +x /etc/profile.d/uav_env.sh

echo -e "${GREEN}Toolchain setup completed successfully!${NC}"
echo -e "${YELLOW}Please log out and log back in for environment changes to take effect.${NC}"
echo -e "${YELLOW}To validate the setup, run: make px4_sitl gazebo${NC}" 