#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting PX4 SITL Simulation...${NC}"

# Set up environment variables
export GAZEBO_PLUGIN_PATH=$GAZEBO_PLUGIN_PATH:/home/px4/PX4_Files/PX4-Autopilot/build/px4_sitl_default/build_gazebo-classic
export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/home/px4/PX4_Files/PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_gazebo-classic/models
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/px4/PX4_Files/PX4-Autopilot/build/px4_sitl_default/build_gazebo-classic

# Navigate to PX4 directory
cd /home/px4/PX4_Files/PX4-Autopilot

# Build PX4 if not already built
if [ ! -d "build/px4_sitl_default" ]; then
    echo -e "${YELLOW}Building PX4...${NC}"
    make px4_sitl_default
fi

# Start PX4 SITL with Gazebo
echo -e "${YELLOW}Starting PX4 SITL with Gazebo...${NC}"
make px4_sitl gazebo_iris

echo -e "${GREEN}PX4 SITL started successfully!${NC}"
echo -e "${YELLOW}To check camera topics, open a new terminal and run: gz topic -l | grep camera${NC}" 