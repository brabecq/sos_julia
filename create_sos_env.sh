#!/bin/bash

# Function to display the help message
display_help() {
    echo "Usage: ./create_sos_env.sh [options]"
    echo "The bash script creates a conda environment installing sos notebook and julia kernel to use sos with Julia"
    echo "Options:"
    echo "  -h, --help      Display this help message"
    echo "  -n, --name      Name of the conda environment created"
    exit 0
}

create_env() {
	my_env=$1
	echo "Creating environment..."
    conda create -n "$my_env" -y pip jupyter
	conda install -n "$my_env" -y conda-libmamba-solver
    conda install -n "$my_env" -c conda-forge julia -y
    conda install -n "$my_env" -c conda-forge sos sos-pbs sos-notebook sos-papermill -y
    conda install -n "$my_env" -c conda-forge jupyterlab-sos -y

    eval "$(conda shell.bash hook)"
    conda activate "$my_env"
    
    my_jupyter=$(which jupyter)
    echo "$my_jupyter"
	export LD_LIBRARY_PATH="$CONDA_PREFIX/lib/:${LD_LIBRARY_PATH}"
	wget https://curl.se/ca/cacert.pem -O $CONDA_PREFIX/share/julia/cert.pem

    julia --project create_julia.jl "$my_jupyter"
    eval "$(conda shell.bash hook)"
    conda activate "$my_env"

    conda install -n "$my_env" -c conda-forge feather-format -y
    pip install sos-julia 
    exit 0
}

# Check whether there is an argument given
if [ $# -eq 0 ]; then
    echo "Error: No arguments provided. For help, run ./create_sos_env.sh -h"
    exit 1
fi

# Check for the --help or -h argument
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    display_help
fi

# Check for the --name or -n argument and pass it to the create_env function
if [ "$1" == "--name" ] || [ "$1" == "-n" ]; then
    if [ -z "$2" ]; then
        echo "Error: Please provide a name for the conda environment."
        exit 1
    fi
    create_env "$2"
fi
