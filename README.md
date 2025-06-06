# Autonomous Airborne Security System Simulation

This repository contains a complete simulation environment for an autonomous UAV-based perimeter surveillance system. The system uses PX4 SITL, Gazebo Harmonic, and YOLOv8 for real-time computer vision processing.

## System Requirements

### Hardware Requirements
- x86_64 CPU (Intel/AMD) or NVIDIA Jetson Nano
- NVIDIA GPU (for x86 systems, optional for Jetson)
- 8GB RAM minimum (16GB recommended)
- 20GB free disk space

### Software Requirements
- Ubuntu 22.04 LTS
- Python 3.10+
- CUDA 12.3.1 (for x86 systems with NVIDIA GPU)
- Docker 24.0.5+
- NVIDIA Container Toolkit (for GPU support)

## Component Versions

| Component | Version | Notes |
|-----------|---------|-------|
| PX4 | v1.14.0 | Latest stable tag |
| Gazebo | Harmonic | Based on Ignition Fortress |
| QGroundControl | Latest | AppImage format |
| MAVSDK-Python | Latest | Python 3.10+ |
| YOLOv8 | Latest | via ultralytics |
| CUDA | 12.3.1 | x86 only |
| Python | 3.10+ | Virtual environment |
| Docker | 24.0.5+ | With NVIDIA support |

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/yourusername/Autonomous-Airborne-Security-System-Simulation.git
cd Autonomous-Airborne-Security-System-Simulation
```

2. Run the setup script:
```bash
sudo ./setup_toolchain.sh
```

3. Log out and log back in for environment changes to take effect.

4. Validate the setup:
```bash
cd /opt/PX4-Autopilot
make px4_sitl gazebo
```

5. Launch QGroundControl:
```bash
QGroundControl
```

## Directory Structure

```
.
├── setup_toolchain.sh    # Main setup script
├── README.md            # This file
├── validation.md        # Setup validation guide
├── gazebo_world/        # Gazebo world files
├── px4/                 # PX4 configuration
├── perception/          # CV processing
├── autonomy/           # Mission logic
└── launch/             # Launch files
```

## Troubleshooting

### Common Issues

1. **PX4 SITL fails to start**
   - Check if Gazebo is properly installed
   - Verify environment variables are set
   - Check system logs: `journalctl -xe`

2. **QGC connection issues**
   - Verify MAVLink port permissions
   - Check if PX4 is running
   - Verify network settings

3. **CUDA/GPU issues**
   - Verify NVIDIA drivers: `nvidia-smi`
   - Check CUDA installation: `nvcc --version`
   - Verify Docker GPU support: `docker run --gpus all nvidia/cuda:12.3.1-base-ubuntu22.04 nvidia-smi`

4. **Python environment issues**
   - Activate virtual environment: `source /opt/uav_cv_env/bin/activate`
   - Verify package installation: `pip list`
   - Check Python version: `python --version`

## Support

For issues and feature requests, please use the GitHub issue tracker.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 