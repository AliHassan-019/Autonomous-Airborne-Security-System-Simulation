# Autonomous Airborne Security System Simulation

## Project Overview
This project simulates an autonomous UAV security system using PX4 SITL (Software In The Loop), Gazebo, and YOLOv8 for object detection. The system is designed to autonomously detect and track potential security threats using computer vision.

## Development Progress

### Day 1: Environment Setup and Basic Simulation
1. **Environment Setup**
   - WSL2 installation and configuration
   - Docker setup for containerized development
   - PX4 SITL configuration
   - Gazebo environment setup
   - YOLOv8 integration

2. **Basic Simulation Components**
   - PX4 SITL running successfully
   - Gazebo visualization working
   - Camera stream operational
   - YOLOv8 model loaded and tested

### Project Structure
```
Autonomous-Airborne-Security-System-Simulation/
├── Dockerfile                 # Container configuration
├── run_simulation.sh         # Main simulation launcher
├── run_px4_sitl.sh          # PX4 SITL launcher
├── requirements.txt          # Python dependencies
└── README.md                # Project documentation
```

## Setup Instructions

### Prerequisites
1. **WSL2 Installation**
   ```bash
   wsl --install
   wsl --set-default-version 2
   ```

2. **Docker Installation**
   ```bash
   sudo apt update
   sudo apt install docker.io
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -aG docker $USER
   ```

3. **PX4 Development Environment**
   ```bash
   git clone https://github.com/PX4/PX4-Autopilot.git
   cd PX4-Autopilot
   make px4_sitl gazebo
   ```

### Running the Simulation

1. **Build the Docker Container**
   ```bash
   docker build -t uav-security-sim .
   ```

2. **Start the Simulation**
   ```bash
   ./run_simulation.sh
   ```

3. **Run PX4 SITL**
   ```bash
   ./run_px4_sitl.sh
   ```

4. **Verify Setup**
   ```bash
   # Check Gazebo topics
   gz topic -l | grep camera
   
   # Test YOLOv8
   python3 -c "from ultralytics import YOLO; model = YOLO('yolov8n.pt')"
   ```

## Testing Progress

### Completed Tests
1. **Environment Tests**
   - [x] WSL2 functionality
   - [x] Docker container build and run
   - [x] PX4 SITL compilation
   - [x] Gazebo installation and launch

2. **Component Tests**
   - [x] Camera stream in Gazebo
   - [x] YOLOv8 model loading
   - [x] Basic object detection
   - [x] PX4 SITL communication

### Pending Tests
1. **Integration Tests**
   - [ ] UAV control system
   - [ ] Object tracking
   - [ ] Autonomous navigation
   - [ ] Threat assessment

2. **Performance Tests**
   - [ ] Real-time processing
   - [ ] Detection accuracy
   - [ ] System latency
   - [ ] Resource utilization

## Development Notes

### Key Components
1. **PX4 SITL**
   - Version: Latest stable
   - Configuration: Standard quadcopter model
   - Communication: MAVLink protocol

2. **Gazebo**
   - Version: 11.x
   - World: Empty world with camera
   - Models: Quadcopter with gimbal

3. **YOLOv8**
   - Model: YOLOv8n
   - Classes: COCO dataset
   - Integration: Python API

### Known Issues
1. Camera stream initialization delay
2. Resource intensive simulation
3. WSL2 performance considerations

### Next Steps
1. Implement UAV control system
2. Develop object tracking algorithms
3. Create autonomous navigation system
4. Design threat assessment module

## Troubleshooting

### Common Issues
1. **WSL2 Performance**
   - Solution: Increase WSL2 memory limit
   - File: `.wslconfig` in Windows user directory

2. **Docker Permissions**
   - Solution: Add user to docker group
   - Command: `sudo usermod -aG docker $USER`

3. **PX4 SITL Issues**
   - Solution: Clean build
   - Command: `make clean && make px4_sitl gazebo`

## References
1. [PX4 Documentation](https://docs.px4.io/)
2. [Gazebo Tutorials](http://gazebosim.org/tutorials)
3. [YOLOv8 Documentation](https://docs.ultralytics.com/)
4. [WSL2 Documentation](https://docs.microsoft.com/en-us/windows/wsl/)

## Contact
For any questions or issues, please open an issue in the project repository. 