#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting UAV Security System Simulation...${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

# Build the simulation container if it doesn't exist
if ! docker image inspect uav-security-sim:latest > /dev/null 2>&1; then
    echo -e "${YELLOW}Building simulation container...${NC}"
    docker build -t uav-security-sim:latest .
fi

# Run the simulation container
echo -e "${YELLOW}Starting simulation container...${NC}"
docker run -it --rm \
    --name uav-security-sim \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd):/workspace \
    uav-security-sim:latest \
    /bin/bash

echo -e "${GREEN}Simulation container started successfully!${NC}"
echo -e "${YELLOW}To run PX4 SITL, execute: ./run_px4_sitl.sh${NC}" 