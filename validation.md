# Setup Validation Guide

This document provides step-by-step instructions to validate the complete setup of the UAV Security System simulation environment.

## Prerequisites

Before starting validation, ensure you have:
1. Completed the `setup_toolchain.sh` script
2. Logged out and logged back in
3. At least 8GB of free RAM
4. A working internet connection

## 1. System Environment Validation

### 1.1 Check Python Environment
```bash
# Activate virtual environment
source /opt/uav_cv_env/bin/activate

# Verify Python version
python --version  # Should show Python 3.10+

# Check installed packages
pip list | grep -E "numpy|opencv|ultralytics|torch|mavsdk"
```

### 1.2 Verify CUDA Installation (x86 only)
```bash
# Check NVIDIA drivers
nvidia-smi

# Verify CUDA installation
nvcc --version  # Should show CUDA 12.3.1

# Test GPU support in Docker
docker run --gpus all nvidia/cuda:12.3.1-base-ubuntu22.04 nvidia-smi
```

### 1.3 Check Gazebo Installation
```bash
# Verify Gazebo version
gz --version  # Should show Gazebo Harmonic

# List available Gazebo worlds
gz topic -l
```

## 2. PX4 SITL Validation

### 2.1 Start PX4 SITL
```bash
cd /opt/PX4-Autopilot
make px4_sitl gazebo
```

Expected output:
- Gazebo window should open
- PX4 console should show startup messages
- No error messages in red

### 2.2 Verify MAVLink Connection
```bash
# In a new terminal
mavlink-routerd -e 127.0.0.1:14550 127.0.0.1:14540
```

## 3. QGroundControl Validation

### 3.1 Launch QGC
```bash
QGroundControl
```

### 3.2 Connect to SITL
1. Open QGC
2. Click "Connect" button
3. Select "UDP" connection
4. Enter port 14550
5. Click "Connect"

Expected behavior:
- QGC should connect to PX4
- Telemetry data should appear
- Vehicle status should show "Ready to Fly"
- Map should show vehicle position

## 4. Camera Stream Validation

### 4.1 Check Gazebo Camera Topics
```bash
# List available camera topics
gz topic -l | grep camera
```

Expected topics:
- `/camera/rgb/image_raw`
- `/camera/thermal/image_raw` (if enabled)

### 4.2 Verify Image Streaming
```bash
# Install rqt if not present
sudo apt install ros-humble-rqt ros-humble-rqt-image-view

# Launch rqt
rqt_image_view
```

Expected behavior:
- Select camera topic in rqt
- Live camera feed should appear
- No significant latency or artifacts

## 5. YOLOv8 Validation

### 5.1 Test YOLOv8 Installation
```bash
# Activate virtual environment
source /opt/uav_cv_env/bin/activate

# Run YOLOv8 test
python3 -c "from ultralytics import YOLO; model = YOLO('yolov8n.pt'); print('YOLOv8 loaded successfully')"
```

Expected output:
- No error messages
- "YOLOv8 loaded successfully" message

## 6. MAVSDK-Python Validation

### 6.1 Test MAVSDK Connection
```bash
# Create test script
cat > test_mavsdk.py << EOF
import asyncio
from mavsdk import System

async def main():
    drone = System()
    await drone.connect(system_address="udp://:14540")
    print("Connected to drone!")
    async for state in drone.core.connection_state():
        print(f"Connection state: {state}")
        break

if __name__ == "__main__":
    asyncio.run(main())
EOF

# Run test
python3 test_mavsdk.py
```

Expected output:
- "Connected to drone!" message
- Connection state should be "CONNECTED"

## 7. Performance Validation

### 7.1 Check System Resources
```bash
# Monitor system resources
htop
```

Expected metrics:
- CPU usage < 80%
- Memory usage < 80%
- GPU memory usage < 80% (if applicable)

### 7.2 Measure Camera Stream Performance
```bash
# Install performance monitoring tools
sudo apt install python3-pip
pip3 install psutil

# Create performance test script
cat > test_performance.py << EOF
import cv2
import time
import psutil
import numpy as np

def test_camera_performance():
    cap = cv2.VideoCapture(0)
    frames = 0
    start_time = time.time()
    
    while frames < 100:
        ret, frame = cap.read()
        if ret:
            frames += 1
        else:
            break
    
    end_time = time.time()
    fps = frames / (end_time - start_time)
    print(f"Camera FPS: {fps}")
    print(f"CPU Usage: {psutil.cpu_percent()}%")
    print(f"Memory Usage: {psutil.virtual_memory().percent}%")
    
    cap.release()

if __name__ == "__main__":
    test_camera_performance()
EOF

# Run performance test
python3 test_performance.py
```

Expected metrics:
- Camera FPS > 20
- CPU usage < 80%
- Memory usage < 80%

## 8. Final Checklist

- [ ] All system components installed successfully
- [ ] PX4 SITL launches without errors
- [ ] QGC connects and shows telemetry
- [ ] Camera streams are visible and performant
- [ ] YOLOv8 loads and runs without errors
- [ ] MAVSDK connects to PX4
- [ ] System resources are within acceptable limits
- [ ] No error messages in system logs

## Troubleshooting

If any validation step fails:
1. Check system logs: `journalctl -xe`
2. Verify environment variables: `env | grep -E "PX4|GAZEBO|PYTHON"`
3. Check component versions match those in README.md
4. Ensure all dependencies are installed
5. Verify network connectivity
6. Check file permissions in /opt directory

## Support

For issues not covered in this guide, please:
1. Check the troubleshooting section in README.md
2. Search existing GitHub issues
3. Create a new issue with detailed error messages and system information 