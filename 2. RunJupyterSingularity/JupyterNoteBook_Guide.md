## Prelude
This Guide assumes you have already registered and can login to NSCC Login Node
This guide is for running jupyter notebook using the provided bash file (RunPythonSinguliarity.pbs)
it is intended as a "quick guide" and not an explanation

## Step 1) Generate Hash with password 
Allow login to JupyterNotebook using password

In Local Computer's Jupyter Notebook, Run the following code to generate a hash
1. `from notebook.auth import passwd`<br />
   `passwd()`

Copy and Note down the hash and remember your password


## Step 2) Setup Bash Script
In the Bash Script, Modify Params: <br />
Choose + Set singularity image to use (In this case we using tensorflow 2.3 library)
1. `image="/app/singularity/images/tensorflow/tensorflow_2.3.0_gpu_py3.simg"`

Set NOTEBOOKPORT (Any number between 8000 and 9999 is fine)
1. `export NOTEBOOKPORT=8899`

Set Hash, using hash generated from step 1 (Ensure encased in single quotes)
1. `export Hash='argon2:$argon2id$v=19$m=10240,t=10,p=8$7QOTfWRYvwnNRuV+cHfGbQ$Gu8NugEjIi9IUvRXdjYDlA'`

Set other variables if need be
1. `other variables`

your script can have any extension(.sh/.pbs), but reccomeneded to use .sh/.pbs

## Step 3) Transfer Script into NSCC
Use software with [Secure Copy Protocol](https://en.wikipedia.org/wiki/Secure_copy_protocol) or [Secure File Transfer Protocol](https://en.wikipedia.org/wiki/File_Transfer_Protocol) to transfer files from Local Computer to NSCC such as [WinSCP](https://winscp.net/eng/download.php) (Reccomended) or [Filezilla](https://filezilla-project.org/)
<br />
For WinSCP create a new site with
*   File Protocol = SFTP    
*   Host Name =  aspire.com.sg
*   User Name = `<your_username>`

<br />
Transfer Script and other relevant files into your working directory (Usually i use desktop)


## Step 4) Queue job
Login to NSCC Login Node. <br />
Submit your job to queue by using the command into the terminal
1. `qsub <Script_name>`


## Step 5) Look for hostname which job runs on
Determine when Job is Running using the command
1. qstat 

Once job is running(Status = R), <br />
Obtain the job id (7 digits usually) and check full stats using the command
1. qstat -f `<job_id>`

Find the hostname of the node under EXEC_1720 env variable
and note it down
<br />

## Step 6) Establish SSH connection from computer to jupyter notebook
Open up a Linux terminal on Local Computer and use the ssh command,
[Guide to Download windows subsystem for linux](https://www.windowscentral.com/install-windows-subsystem-linux-windows-10)
1. `ssh -N -L localhost:<LOCAL_HOST_PORT>:<HOST_NAME>-ib0:<NOTEBOOK_PORT> <USER_NAME>@aspire.nscc.sg`
2. `ssh -N -L localhost:8899:gpu1834-ib0:8899 wp_wong@aspire.nscc.sg`
<br />
where                 <br />
LOCAL_HOST_PORT -> any number from 8000-9999 thats unsued on your system                          <br />
HOST_NAME ->      hostname obtained when `qstat -f <job_id>`  under EXEC_1720 variable in Step 5  <br />
NOTEBOOK_PORT ->  NOTEBOOKPORT as in Bash Script     <br />
USER_NAME ->      Your NSCC account username         <br />

There should be blank reply and no error messages about refusing to connect


## Step 7) View Jupyter Notebook in Browser
1. Open your browser of choice
2. set url as `localhost:<LOCAL_HOST_PORT>`                           <br />
3. enter your password used to create the hash in Step 1              <br />

congrats, your jupyter notebook should work now, use it as you would any other jupyter notebook!

## Step 8) Delete Job When Done [REMEMBER]
Enter into NSCC Login Node Terminal this command to close your job.
1. `qdel <job_id>`

An error file and output file should appear after awhile, Respectively (<Job_Name>.e<Job_num>, <Job_Name>.o<Job_num>) <br />
Use these for Debugging
