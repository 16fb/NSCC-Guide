This is a .md file, view in a markdown viewer(reccomended) or as plain text. I reccomend VS Code <br>

# Preclude
This Guide serves as a "wtf is going on" and serves to try and explain why things are done in X way and what things are being done. <br>
It is meant to be comprehensive and explain why things are done. <br>

These guides below are "how to" guides made by us, meant to get jobs running: (start from first) <br>
Python_Singularity_Guide.md -> Guide to use tensorflow library and run python files <br>
JupyterNoteBook_Guide.md -> Guide to setting up jupyter notebook server <br>

These are other usefull resources online: <br>
* Official quick start guide by NSCC, [link](https://help.nscc.sg/pbspro-quickstartguide/)
* NSCC [User Guides](https://help.nscc.sg/user-guide/)
* NSCC [quick reference sheet](https://help.nscc.sg/wp-content/uploads/2016/08/PBS_Professional_Quick_Reference.pdf)
* NSCC [faq page](https://help.nscc.sg/faqs/)
* Guide to using dgx GPUs [link](https://help.nscc.sg/wp-content/uploads/AI_System_QuickStart.pdf) 

# So whats actually happening?
NSCC owns the supercomputer, Aspire1, and lets users "borrow" its computing power.<br>
To facilitate this, the linux Operating System [PBS Pro](https://www.altair.com/pbs-professional/) is used.
See [Portable Batch System](https://en.wikipedia.org/wiki/Portable_Batch_System).<br>
Users submit "jobs", which are requests for resources that contains code/commands they want to run.<br>
These "jobs" use [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) to tell the supercomputer what to do and what files to run.<br>

"Jobs" are submitted in the NSCC Login node, where they are processed and sent to an internal compute node to be processed.<br>
To connect to the Login node, we join the VPN used by NSCC, Sophos VPN.<br>
Then we have to [SSH](https://en.wikipedia.org/wiki/Ssh_(Secure_Shell)) to the Login node to connect to it.<br>

PBS Pro have special commands to submit jobs, such as `qsub`, `qstat`, `qdel`.<br>
As jobs are Bash Scripts, we will need to use Bash to run our code.<br>
ie. all our code can be run using the bash command line.<br>

We need all our dependacies to be working on NSCC as well.
<br>
to enable use of some commands like anaconda, we can add it as a module using `module load` <br>

Installing modules is problematic. we dont have root access, so we cannot just `pip install <module>`. <br>
We cannot modify the root file where modules are installed, we have to install into our local directory. <br>

## SSH (Secure Shell)
[SSH](https://en.wikipedia.org/wiki/Ssh_(Secure_Shell)) is a Network protocol to securely allow a user to access the command line(shell) of another computer<br>

We use this to access NSCC login terminal.<br>
A popular SSH terminal software is [PuTTy](https://www.putty.org/), we reccomend using it to SSH into the Login Node<br>
It can be downloaded [here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)<br>


## Bash (Unix Shell)
[Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) is a [shell](https://en.wikipedia.org/wiki/Shell_(computing)), a user interface for access to an operating system's services, in this case Linux Machines  <br>
Basically, Bash is the windows command prompt, but for Linux machines(UNIX). <br>

NSCC uses PBS Pro, which is a Linux OS and uses the Bash shell. <br>
Therefore we will need to use Bash commands to interact with NSCC. <br>

Common Bash Commands:
* `ls` => List all files + folders in current directory
* `cd` => Change directory 
* `mkdir` => Makes a directory
* `rm` => Removes an item
* `echo` => Prints to console(stdout) 
* `env` => List all environment variables

## WinSCP, Transfering Files
NSCC uses SFTP ([Secure File Transfer Protocol](https://en.wikipedia.org/wiki/File_Transfer_Protocol)) protocol to transfer files from host computer to NSCC. <br>
Reccomended software to use is [WinSCP](https://winscp.net/eng/download.php) <br>

Therefore, we use WinSCP to tranfer bash scripts and python files to NSCC

## PBS Commands
PBS has commands to submit, delete and track jobs.<br>
NSCC has [guides](https://help.nscc.sg/pbspro-quickstartguide/) on how to use these commands,
As well as a [quick reference sheet](https://help.nscc.sg/wp-content/uploads/2016/08/PBS_Professional_Quick_Reference.pdf).<br>

These commands flags are placed on the top of the bash file, after #!/bin/sh, and always start with #PBS.<br>

`### The following requests 1 Chunk, 5 CPU Nodes, 1 GPU`<br>
`#PBS -l select=1:ncpus=5:ngpus=1`<br>

`### Specify amount of time required`<br>
`### Values less than 4 hours go into a higher priority queue`<br>
`#PBS -l walltime=2:00:00`<br>

`### Specify gpu/dgx queue`<br>
`#PBS -q gpu`<br>

Some Common Commands:
* `qsub <shell_script>` => Submit a job to queue
* `qdel <job_id>` => Delete a running or queued job
* `qstat`  => Find information about current jobs
* `qstat -f <job_id>` => Full information of specific job
<br>
To view more info about commands  , use `<command> help`
<br>

## PBS Queues
Different queues are used to satisfy the resource requirements of the various workloads that run on NSCC. <br>
If we want use dgx GPU vs normal GPU, we have to send out job into different queues. <br>

As a user, we submit jobs into an external queue depending on our needs <br>
Examples:
* normal => just use CPUs
* GPU => use normal GPUs
* dgx => use special dgx fast GPUs
<br>
Specifc documentation on queues can be found on pg.4 of [quick start guide](https://help.nscc.sg/pbspro-quickstartguide/) <br>


## Problem with pip install as no root access  
Usually, when we add libraries for python, we enter into the command prompt `pip install <module>` or `conda install <module>`. <br>
However if we `pip install <module>`, we get a permission error, as we end up trying to overwrite files we dont have permission to.

Therefore, we have to use `pip install -U -q --user <module>`: 
* `-U` => upgrade if possible
* `-q` => preserve time stamps
* `--user` => install to user home directory instead of system directory (Installs in site.USER_SITE)
[documentation](https://pip.pypa.io/en/stable/reference/pip_install/)


## Modules
Modules are a part of Modules Package in Linux. [Modules Documentation](https://modules.readthedocs.io/en/latest/module.html) <br>
Modules allow for dynamic modification of the user's environment (`$PATH`, `$MANPATH`) via modulefiles. <br>
In essence, **modules prepares the environment and allows us to use commands.** <br>

We load modules we want with the command `module load`. <br>
Example: `module load anaconda` to let us use the `conda` command. <br>

Commonly used commands:
* `module help`   => Show help manual
* `module list`   => List currently added modules
* `module avail`  => Show available modules
* `module add/load [module file]` => Add/Loads modules 
* `module remove/unload [module file]` => Remove/Unloads module
* `module show [modulefile]`      => Shows what module file does to environment
* `module whatis [modulefile]`    => Query what the module does

----------
# Running Python With Tensorflow
Tensorflow 2.0 is a tricky module to add. <br>
Tensorflow is GPU dependant, and `module load tensorflow` only supports Tensorflow 1.4. <br>
Even worse, `module load anaconda` and `module load tensorflow` are incompatiable and will raise a warning.<br>
Even `pip install tensorflow` can cause errors.<br>

The only proper way to add GPU Tensorflow libraries i'hv found so far is by using containers.

## Containers
[Containers](https://en.wikipedia.org/wiki/OS-level_virtualization) allows for OS-level virtualisation. <br>
Basically its a Virtual Machine that virtualises processes and not the whole computer, which makes it much more efficient.

The main benefit of containers is isolation, <br> 
allowing us to **package an application with all of its dependencies into a standardized unit.** <br>
In essence, we can put our setup into the container (such as installing dependacies), and it will work anywhere.<br>

The most popular containerisation software is [Docker](https://en.wikipedia.org/wiki/Docker_(software)). <br>
However for High Performance Computing(HPC) in scientific context, [Singularity](https://en.wikipedia.org/wiki/Singularity_(software)) is a popular option. <br>
While both can be used with NSCC, in our guide we use Singularity. <br>

NSCC has ready-made containers with tensorflow that works with their GPUs.<br>
So we can: 
1. "Boot up" a container with tensorflow
2. Add other dependacies as needed (pip install)
3. Run our code from there.

## Container Syntax

Singularity Container Syntax: `singularity exec --nv <image> /bin/bash << EOF` <br>
Example: `singularity exec --nv /app/singularity/images/tensorflow/tensorflow_2.3.0_gpu_py3.simg /bin/bash << EOF` <br>

* `singularity exec` => executes singularity image 
* `--nv` => specify nvidia card
* `<image>` => specify image path
* `/bin/bash` => specify to use bash
* `<< EOF` => [here-document](https://askubuntu.com/questions/678915/whats-the-difference-between-and-in-bash), takes in terminal input and input into /bin/bash untill it see an `EOF` character

## << EOF and Bash variable resolution 
Below `<< EOF`, we enter commands we want to run inside the container. <br>
Container starts at location defined in image. As this image is defined by NSCC, it means it starts at some weird nameless location. <br>
We will need to cd into the correct directory like so, `cd "$PBS_O_WORKDIR"`. <br>
$PBS_O_WORKDIR refers to the directory the job was submitted in. <br>

Variables in bash shell and in the container are different when we use `<< EOF`. <br>
In bash shell `$variable` will resolve the variable in bash shell. <br>
Instead using `\$variable` will escape the $ character, so the variable will not be resolved in shell, but instead when it runs in container. <br>


----------
# Running Jupyter NoteBook Server
Jupyter Notebook lets us run a webpage on a host server machine, and by accessing the webpage, we can run python code on the machine.<br>
The key point to note, is that anyone that can access the webpage on the machine, can run python code on the machine.<br>
connect to webpage => run python code!<br>
Link to [documentation](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html) <br>

So the idea is to have our job run a Jupyter Notebook Server. Then we connect from our computer to the Jupyter Notebook Server! <br>

## SSH Tunneling
There are some caveats and problems to the above plan. <br>
Our jobs run on a compute node, which is not directly exposed to the internet. <br>
It is however connected to the login node(where you connect PuTTy to), which is exposed to the internet. <br>
 
So... we need to "jump" from the login node to the compute node. <br>
Welcome [SSH Port Forwarding/Tunneling](https://www.ssh.com/ssh/tunneling/example) which does exactly that. <br>
We basically ssh into the login node, then tell the login node to forward our messages to the compute node. <br>

Syntax: <br>
ssh -N -L localhost:<localhostPort>:<hostname>-ib0:<NOTEBOOKPORT> <username>@aspire.nscc.sg <br>
* -N => dont do anything after ssh connection established
* -L => Local Port Forwarding 
* <localhost> => Start a connection from us 
* <localhostPort> => On Port <localhostPort>
* <hostname>-ib0 => when connected, forward to <hostname>-ib0
* <NOTEBOOKPORt> => On Port <NOTEBOOKPORt> (Port which Jupyter Notebook runs on)
* <username>@aspire.nscc.sg => Where to ssh to and as what user

<br>
We cannot determine which compute node our job will run on before hand(that i know of). <br>
So we need to query the running job with `qstat -f <job_id>` and determine <hostname> from EXEC_1720 variable <br>

## Hashing
Jupyter Notebook needs to verify whoever connecting is legit. <br>
so we set a password using:
1. `from notebook.auth import passwd`<br>
   `passwd()`

This generates a salted hash from our password, and we copy this into our script.<br>
So when we enter our password, the jupyter notebook server can verify <br>

Why use a [Salted Hash](https://auth0.com/blog/adding-salt-to-hashing-a-better-way-to-store-passwords/)? <br>
TL;DR cannot [reverse compute](https://en.wikipedia.org/wiki/Cryptographic_hash_function) password and wont fall to [rainbow table](https://en.wikipedia.org/wiki/Rainbow_table) attacks.

## Exporting variables
If we want export Shell variables into Singularity Container, <br>
we use `SINGULARITYENV_<VAR_NAME>=<VAR_VALUE>`<br>