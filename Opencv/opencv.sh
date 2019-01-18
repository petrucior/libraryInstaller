#!/bin/bash
# Shell script to install the Opencv with CUDA / OpenCL libraries.
# Author: Petrucio Ricardo Tavares de Medeiros
# Date: August, 2015.
# Update: January, 2019.
# Attention: The installation of Opencv need rebooting of operating system.

# Installation information
function printUsage(){
    echo "Use these commands: ";
    echo "chmod +x opencv.sh";
    echo "./opencv.sh #option";
    echo "- If #option == none, then only Opencv is configured to be used.";
    echo "- If #option == cuda, then CUDA is configured to be used.";
    echo "- If #option == opencl, then OpenCL is configured to be used.";
    exit 1;
}

if [ $# -lt 1 ]; then
    printUsage;
fi

echo "OpenCV installer";

# Update system
sudo apt-get update

# Installing compiler
sudo apt-get -y install build-essential

# Installing required packages
sudo apt-get -y install cmake-gui git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev libqt4-dev

# Install optional packages
sudo apt-get -y install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev

# Accessing Root
\cd ~/

# OpenCV from Git repository
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

# Accessing OpenCV and creating build diretory
\cd opencv/
mkdir build
\cd build/

# Configuring OpenCV
if [ $1 == "none" ]; then
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules ~/opencv/ -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D WITH_QT=ON -D ENABLE_FAST_MATH=ON -D BUILD_TBB=ON -D ENABLE_SSE42=ON -D ENABLE_SSSE3=ON -D WITH_OPENMP=ON -D WITH_OPENGL=ON BUILD_EXAMPLES=ON ..
fi

if [ $1 == "cuda" ]; then
    echo "Configuring CUDA";

    # Verify if SDK from drivers were installed ( see https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html )
    # Verify if you have a GPU NVIDIA
    NVIDIA=`lspci | grep -i NVIDIA`;
    if [ $? == 0 ]; then # Answer 0 means true
	echo "There is NVIDIA!";

        # Verify if your system is 64 bits
	VERSIONLINUX=`uname -m && cat /etc/*release`;
	if [ ${VERSIONLINUX:0:6} == "x86_64" ] || [ ${VERSIONLINUX:0:6} == "POWER8" ] || [${VERSIONLINUX:0:6} == "POWER9"]
	then echo "64 bits";

	     # Verify the gcc and headers version ( Update allows your system to keep the updated version )
	     #gcc --version
	     #uname -r

	     # Install from Hands on GPU Accelerated Computer Vision With OpenCV and CUDA 
	     #---------------------------------------------------------------------------
	     # Install repository meta-data
	     #sudo dpkg -i cuda-repo-<distro>_<version>_<architecture>.deb

	     # Installing the CUDA public GPG key
	     #sudo apt-key add /var/cuda-repo-<version>/7fa2af80.pub

	     # Update the Apt repository cache
	     #sudo apt-get update
	     
	     # Install CUDA
	     #sudo apt-get install cuda

	     # The PATH variable needs to include /usr/local/cuda-10.0/bin
	     #export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}

	     # To change the environment variables for 64-bit operating systems:
	     #export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64\
	     #	 ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

	     #---------------------------------------------------------------------------

	     # Install alternative
	     #---------------------------------------------------------------------------
	     sudo add-apt-repository ppa:graphics-drivers/ppa
	     sudo apt-get update
	     sudo ubuntu-drivers autoinstall
	     #---------------------------------------------------------------------------
	     
	     # CUDA toolkit
	     sudo apt-get -y install nvidia-cuda-toolkit
	     
	     cmake -D CMAKE_BUILD_TYPE=RELEASE -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules ~/opencv/ -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D WITH_QT=ON -D ENABLE_FAST_MATH=ON -D BUILD_TBB=ON -D ENABLE_SSE42=ON -D ENABLE_SSSE3=ON -D WITH_OPENMP=ON -D WITH_OPENGL=ON BUILD_EXAMPLES=ON WITH_CUDA=ON WITH_CUBLAS=ON ..
	     
	fi
    fi
fi

if [ $1 == "opencl" ]; then
    echo "Configuring OpenCL";

    # Verify if SDK from drivers were installed ( see https://gist.github.com/Brainiarc7/dc80b023af5b4e0d02b33923de7ba1ed )
    
    # Installing OpenCL packages
    sudo apt-get -y install ocl-icd-* opencl-headers
    
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules ~/opencv/ -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D WITH_QT=ON -D ENABLE_FAST_MATH=ON -D BUILD_TBB=ON -D ENABLE_SSE42=ON -D ENABLE_SSSE3=ON -D WITH_OPENMP=ON -D WITH_OPENGL=ON BUILD_EXAMPLES=ON WITH_OPENCL=ON WITH_OPENCLAMDFFT=ON WITH_OPENCLAMDBLAS=ON ..
fi

# Build OpenCV
echo "Build opencv";
make -j $(nproc)

echo "Instalando configuracoes";
sudo make install

# Modifying system bash
sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig

# Restart operating system after installation
#sudo shutdown -r now
