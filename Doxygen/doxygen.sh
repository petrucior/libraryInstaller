#!/bin/bash
# Shell script to install the Doxygen
# Author: Petrucio Ricardo Tavares de Medeiros
# Date: January, 2019.
# Update:

# Installation information
function printUsage(){
    echo "Use these commands: ";
    echo "chmod +x opencv.sh";
    echo "./doxygen #path #projectName";
    echo "- #path from project to be configured by doxygen.";
    echo "- #projectName is the name of the project that will be used in documentation.";
    exit 1;
}

if [ $# -lt 2 ]; then
    printUsage;
fi

echo "Doxygen installer";

# Update system
sudo apt-get update

# Installing packages
sudo apt-get -y install doxygen graphviz

# Accessing Root and Path
\cd ~/

# Accessing Project and creating docs diretory
\cd $1/
mkdir docs
\cd docs/

# Generate an initial file
doxygen -g

# Configuring the initial file
sed -i 's/PROJECT_NAME           = "My Project"/PROJECT_NAME           = '$2'/g' Doxyfile
sed -i 's/HAVE_DOT               = NO/HAVE_DOT               = Yes/g' Doxyfile
sed -i 's/RECURSIVE              = NO/RECURSIVE              = YES/g' Doxyfile
sed -i 's/EXTRACT_ALL            = NO/EXTRACT_ALL            = YES/g' Doxyfile
sed -i 's/GENERATE_LATEX         = YES/GENERATE_LATEX         = NO/g' Doxyfile

# Generating documentation
doxygen Doxyfile
