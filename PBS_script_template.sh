#!/bin/sh

### The following requests 1 Chunk, 5 CPU Nodes, 1 GPU
#PBS -l select=1:ncpus=5:ngpus=1

### Specify amount of time required
### Values less than 4 hours go into a higher priority queue
#PBS -l walltime=2:00:00

### Specify gpu/dgx queue
### #PBS -q dgx
### #PBS -q gpu
#PBS -q gpu

### Specify project code
### NOTE: only project codes can run on dgx queue
### #PBS -P <Project Number> [50000163]
### #PBS -P Personal
#PBS -P Personal

### Specify name for job
#PBS -N <name>

### Specify path for output and error files
#PBS -o <path>




### Start of commands to be run

# Singularity image to use for container
image="/home/app/singularity/images/tensorflow/tensorflow_2.3.0_gpu_py3.simg"

### We need export these environment variables to container
# NoteBook Port Between 8000 and 9999
export NOTEBOOKPORT=8899
# Hash 
export Hash='argon2:$argon2id$v=19$m=10240,t=10,p=8$7QOTfWRYvwnNRuV+cHfGbQ$Gu8NugEjIi9IUvRXdjYDlA'

# Please note that when you start a container then it will start in a directory defined by the image
# You will also need to change to the correct directory inside the container
echo
echo Job should start in your home directory:
pwd
echo Change to directory where job was submitted:
cd "$PBS_O_WORKDIR" || exit $?
pwd
echo

# See which node job is running on and GPU status
echo Shell hostname:
hostname
echo
echo Shell nvidia-smi:
nvidia-smi
echo

echo Loading singularity module:
module load singularity
echo

echo View Envrionment Variables of Shell:
env
echo

echo Variables defined in script:
echo image:
echo $image
echo NOTEBOOKPORT:
echo $NOTEBOOKPORT
echo Hash:
echo $Hash
echo

# execture container with nvidia, loading env variables
SINGULARITYENV_NOTEBOOKPORT=$NOTEBOOKPORT SINGULARITYENV_Hash=$Hash singularity exec --nv $image /bin/bash << EOF
echo Container Hostname:
hostname
echo

echo nvidia-smi:
nvidia-smi
echo

echo Base working directory is:
pwd
echo Change directory to shells $PBS_O_WORKDIR:
cd "$PBS_O_WORKDIR"
echo PWD is now:
pwd
echo

echo Show all modules in container:
pip list
echo

# Fail to import module unless already installed.
echo Should fail on first run:
python -c "import keras;print('Imported keras')"
echo

echo PATH in job shell:
echo PATH=$PATH
echo
echo PATH inside container:
echo PATH=\$PATH
echo

echo Python version:
python --version
echo

### Install Other Modules Here
echo Install keras and other modules inside container:
pip install -U -q --user keras
pip install -U -q --user matplotlib
echo All modules installed
echo

echo List ENV var of container:
env
echo

### okay, we need put \\ in front of Hash because if not bash will try and resolve apparently
# Run Jupyter NoteBook
echo NoteBookPort as per shell is:
echo $NOTEBOOKPORT
echo

echo Hash with backslash:
echo \$Hash
echo

### Run jupyter notebook 
echo Running Jupyter Notebook Server:
jupyter notebook --NotebookApp.password=\$Hash --no-browser --port=$NOTEBOOKPORT --ip=0.0.0.0



EOF
