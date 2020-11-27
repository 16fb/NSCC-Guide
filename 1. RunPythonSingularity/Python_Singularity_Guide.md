## OverView
Script file that we will use `RunPythonSingularity.pbs` \

Example error and output files are the files :
* PythonSingularity.e<job_number> 
* SingularityContainer.e<job_number>
## 1) Modify Script File
Modify the Script File:  <br />
Select Image to use (in this case we using tensorflow): <br />
`image="/app/singularity/images/tensorflow/tensorflow_2.3.0_gpu_py3.simg"`

Choose Modules to pip install: <br />
```
pip install -U -q --user keras
pip install -U -q --user matplotlib
```

Choose Which python File to Run: <br />
`python MNISTDataset.py`

## 2) Transfer Script into NSCC
Use software with [Secure Copy Protocol](https://en.wikipedia.org/wiki/Secure_copy_protocol) or [Secure File Transfer Protocol](https://en.wikipedia.org/wiki/File_Transfer_Protocol) to transfer files from Local Computer to NSCC such as [WinSCP](https://winscp.net/eng/download.php) (Reccomended) or [Filezilla](https://filezilla-project.org/)
<br />
For WinSCP create a new site with
*   File Protocol = SFTP    
*   Host Name =  aspire.com.sg
*   User Name = `<your_username>`

Transfer over python files, script file and other resources

## 3) Run Script by queuing job.
Login to NSCC Login Node. <br />
Submit your job to queue by using the command into the terminal
1. `qsub <Script_name>`

Make sure to run command in the same directory/folder your python file is
