# iR+ Hackathon notes

**Dates**: 2020/09/02 - 2020/09/04

[**Hackathon Google Drive Folder**](https://drive.google.com/drive/folders/1C0ExnBbHFQH9SQrFIZ6J1Bn5Ify5mx0P)

**Tool list**: [Hackathon_tools (Google Drive)](https://docs.google.com/spreadsheets/d/1gX--D6XY4JwbkoWo1hoFmZ7-IdGAv3d95aZRHcDjdGs/edit#gid=0)  
**Presentation**: [ir+ Hackathon.pptx](./iR+_Hackathon.pptx) ([Google drive](https://drive.google.com/file/d/1pZOegzTnZMBP3LaFJ5HvEUmlCwzaAD7t/view?usp=sharing))

**Videos**:
- [Day 1](./iReceptorPlusHackathon20200902.mp4) ([Google drive](https://drive.google.com/file/d/1pM0zgvgKWtcwBlgGrBMDWQBivxTk22ju/view))
- [Day 2](./iReceptorPlusHackathon20200902.mp4) ([No direct link to Google drive, see Hackathon folder.](https://drive.google.com/drive/folders/1C0ExnBbHFQH9SQrFIZ6J1Bn5Ify5mx0P))

**About Singularity**:
- [User guide](https://sylabs.io/guides/3.6/user-guide/)
- [Examples](https://github.com/sylabs/examples)


## Environment Setup

Setup your accounts and machine to use during the hackathon

### Accounts
- GitHub account
        We will need to have access to the ireceptor-plus/tapis repository (this is where the first example is).
- VDJ account
        This will be required to access the singularity and data files, and to authenticate and authorize against the HPC (lonestar 5 at U.Texas: irplus-ls5.tacc.utexas.edu).
        
### Software
- Download and install Git from the [Git official site](https://git-scm.com/). Check one pf the [GUI for windows](https://git-scm.com/download/gui/windows).
- Download and install Docker Desktop from the [Docker official site](https://www.docker.com/products/docker-desktop)
- Some editor to edit the files ([notepad++](https://notepad-plus-plus.org/), [Brackets](http://brackets.io/), [VSCode](https://code.visualstudio.com/), ...)

### Filesystem
We will need a filesystem folder for the Hackathon, let call it _20200902_hackathon_.  
Inside the hackathon folder we will need two folders, both folders (and their names) will be required for running the docker image:
- **irplus**
        holds the clone of the github repository.
- **tapis-token**
        Used to give persistence to the auth token that will be used by tapis.

Open a __command line__ or a __Windows powershell__ in a folder where you want to add your hackathon area and execute the following instruction to create the filesystem structure:
> mkdir 20200902_hackathon; cd 20200902_hackathon\; mkdir irplus; mkdir tapis-token

## Docker and GIT Setup

We need to get the docker image and clone the git repository.

### Docker image

The Docker image can be pulled from the docker registry. Using the opened __command line__ or __Windows powershell__ execute:

> docker pull ireceptorplus/tapis

The output should be:

        Using default tag: latest  
        latest: Pulling from ireceptorplus/tapis  
        Digest: sha256:6e66e16c9ddae44d37bc20d289eecbcc6bbd8b7f57ef97ad765c7e341f5d4428  
        Status: Image is up to date for ireceptorplus/tapis:latest  
        docker.io/ireceptorplus/tapis:latest  

### GIT clone

**Previous note**: We found that, on windows machines, the following error was thrown during the execution of the docker image. This is an error with the line endings and can be easily solved with the _git clone_  instruction.
        
        upload-bundle.sh: line 17: $'\r': command not found

To clone the ireceptor-plus/tapis repo, execute on the __command line__ or __Windows powershell__:  
> git clone https://github.com/ireceptor-plus/tapis.git irplus --config core.autocrlf=input

The output should be similar to:  

        Cloning into 'irplus'...
        remote: Enumerating objects: 128, done.
        remote: Counting objects: 100% (128/128), done.
        remote: Compressing objects: 100% (96/96), done.
        Receiving objects8 (delta 43), reused 102 (delta 21), pack-reused 0eceiving objects:  42% (54/128), 3.04 MiB | 6.06
        Receiving objects: 100% (128/128), 7.52 MiB | 6.06 MiB/s, done.
        Resolving deltas: 100% (43/43), done.
        
The parameter '_--config core.autocrlf=input_' on the _clone_ instruction tells git to automatically change all **LF** (linux/macos) line endings to **CRLF** (windows) line endings. As it appears the same parameter will ensure that all **CRLF** are reverted to **LF** upon committing to GIT.



## Running Docker

To start the docker image, use the opened __command line__ or __Windows powershell__ and execute: 
> docker run -v \\$PWD/tapis-token/mao:/root/.agave -v \\$PWD/irplus:/work -it ireceptorplus/tapis bash

You will get a bash within the docker environment.

Then to check if the filesystem mapping is correct you can list the contents of the _/work_ and _/root/.agave_ and check that it maps with the contents of the folders **irplus** and **tapis-token** previously created.

**NOTE**: During docker execution changes in the contents of **irplus** and **tapis-token** folders reflect both ways (inside and outside docker). Thus we can edit the files in **irplus** outside the docker and use them inside the docker environment.

## Tutorial - Toy application

### Step 1 - Edit files

In your phisical machine (__command line__, __Windows powershell__ or __windows explorer__). Change to folder _20200902_Hackathon\irplus\apps\toy\0.1\ls5\_

> cd irplus\apps\toy\0.1\ls5\

Edit the files _toy.json_, _upload-bundle.sh_ and _test\test-app.json_.  

        Replace  all values **schristley** to your **username** (example **mao**)

This will ensure that we use a unique directory to upload the files, and that will not override other user files.

        
### Step 2 - Authetication

Within **docker bash**, initialize tapis authentication:

> tapis auth init

It will start an interactive process

        +---------------+--------------------------------------+----------------------------------------+
        |      Name     |             Description              |                  URL                   |
        +---------------+--------------------------------------+----------------------------------------+
        |      3dem     |             3dem Tenant              |         https://api.3dem.org/          |
        |   agave.prod  |         Agave Public Tenant          |      https://public.agaveapi.co/       |
        |  araport.org  |               Araport                |        https://api.araport.org/        |
        |     bridge    |                Bridge                |     https://api.bridge.tacc.cloud/     |
        |   designsafe  |              DesignSafe              |    https://agave.designsafe-ci.org/    |
        |  iplantc.org  |         CyVerse Science APIs         |       https://agave.iplantc.org/       |
        |      irec     |              iReceptor               | https://irec.tenants.prod.tacc.cloud/  |
        |    portals    |            Portals Tenant            |  https://portals-api.tacc.utexas.edu/  |
        |      sd2e     |             SD2E Tenant              |         https://api.sd2e.org/          |
        |      sgci     | Science Gateways Community Institute |        https://sgci.tacc.cloud/        |
        |   tacc.prod   |                 TACC                 |      https://api.tacc.utexas.edu/      |
        | vdjserver.org |              VDJ Server              | https://vdj-agave-api.tacc.utexas.edu/ |
        +---------------+--------------------------------------+----------------------------------------+
        Enter a tenant name [tacc.prod]:

> vdjserver.org

        vdjserver.org username: 

> <username>
    
        vdjserver.org password for mao:

> <password>

For the next questions just hit enter.

        Container registry access:
        --------------------------
        Registry Url [https://index.docker.io]:
        Registry Username:
        Registry Password:
        Registry Namespace:

        Git server access:
        ------------------
        Git Username:
        Learn about github.com personal access tokens:
        https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
        Git Token:
        Git Namespace:
        +--------------------+-------------------------------------+
        | Field              | Value                               |
        +--------------------+-------------------------------------+
        | tenant_id          | vdjserver.org                       |
        | username           | <username>                          |
        | client_name        | _cli-vdjserver.org-mao-8f4a1317b803 |
        | api_key            | UdMXETMq6KXutzHlwOIsEMISU4ca        |
        | access_token       | 949f61032efea2864c476f6a7bd1d5      |
        | expires_at         | Thu Sep  3 15:06:42 2020            |
        | verify             | True                                |
        | registry_url       | https://index.docker.io             |
        | registry_username  |                                     |
        | registry_password  |                                     |
        | registry_namespace |                                     |
        | git_username       |                                     |
        | git_token          |                                     |
        | git_namespace      |                                     |
        +--------------------+-------------------------------------+


**NOTE**: To renew the tokens use (a token has a life of ~ one hour):

> tapis auth tokens refresh

To create a new token:  

> tapis auth token create


To show the token:
    
> tapis auth show
    
        +---------------+----------------------------------+
        | Field         | Value                            |
        +---------------+----------------------------------+
        | tenant_id     | vdjserver.org                    |
        | username      | mao                              |
        | api_key       | UdMXETMq6KXutzHlwOIsEMISU4ca     |
        | access_token  | 949f61032efea2864c476f6a7bd1d5   |
        | expires_at    | Thu Sep  3 15:06:42 2020         |
        | refresh_token | a365aac7605df77b9f6886b584eb7525 |
        +---------------+----------------------------------+
    
### Step 3 - (if required) prior setup 
 
List all available systems  
    
> tapis systems list
    
        +-----------------------------+--------------------------+-----------+---------+
        | id                          | name                     | type      | default |
        +-----------------------------+--------------------------+-----------+---------+
        | ls5.tacc.utexas.edu         | Lonestar 5 Supercomputer | EXECUTION | False   |
        | data.vdjserver.org          | VDJData                  | STORAGE   | True    |
        | irplus-ls5.tacc.utexas.edu  | Lonestar 5 Supercomputer | EXECUTION | False   |
        | stampede2.tacc.utexas.edu   | Stampede2 Supercomputer  | EXECUTION | False   |
        | stampede.tacc.utexas.edu    | Stampede Supercomputer   | EXECUTION | False   |
        | vdj-exec-02.tacc.utexas.edu | VDJ Exec 02              | EXECUTION | False   |
        | lonestar.tacc.utexas.edu    | Lonestar 4 Supercomputer | EXECUTION | False   |
        | vdj-exec-01.tacc.utexas.edu | VDJ Exec 01              | EXECUTION | False   |
        | sftp.vdjserver.org          | SFTP Dev System          | STORAGE   | False   |
        +-----------------------------+--------------------------+-----------+---------+
    
List files and folders  

> tapis files list agave:///irplus
    
        +--------+----------------+--------+
        | name   | lastModified   | length |
        +--------+----------------+--------+
        | apps   | 16 hours ago   |   4096 |
        | data   | 18 hours ago   |   4096 |
        | images | 22 minutes ago |   4096 |
        +--------+----------------+--------+

Folders meaning:
- apps: Application assets (tapis concept=definition of inputs and parameters, script and executable files that can be ran as a tapis execution.
- data: Available data
- images: Put code on the super computer (singularity images). A image is one of the files that compose an APP.

Upload files:  

> tapis files upload ...
    
List all apps
    
> tapis apps list
    


### step 4 - Upload files

Within docker, change directory to _/work/apps/toy/0.1/ls5_:

> cd /work/apps/toy/0.1/ls5

Run _upload-bundle.sh_

> bash upload-bundle.sh
    
Output:

        +--------------+-------+
        | Field        | Value |
        +--------------+-------+
        | deleted      | 0     |
        | skipped      | 1     |
        | warnings     | 1     |
        | elapsed_msec | 0     |
        +--------------+-------+
        +--------------+--------------------------------------+
        | Field        | Value                                |
        +--------------+--------------------------------------+
        | name         | toy                                  |
        | uuid         | 713570405814440426-242ac112-0001-002 |
        | owner        | vdj                                  |
        | path         | /irplus/apps/toy                     |
        | lastModified | 2020-09-03T09:41:42.222-05:00        |
        | source       | None                                 |
        | status       | STAGING_COMPLETED                    |
        | nativeFormat | dir                                  |
        | systemId     | data.vdjserver.org                   |
        +--------------+--------------------------------------+
        +--------------+---------------------------------------+
        | Field        | Value                                 |
        +--------------+---------------------------------------+
        | name         | mao                                   |
        | uuid         | 8020383441663815190-242ac112-0001-002 |
        | owner        | mao                                   |
        | path         | /irplus/apps/toy/mao                  |
        | lastModified | 2020-09-03T09:41:45.735-05:00         |
        | source       | None                                  |
        | status       | STAGING_COMPLETED                     |
        | nativeFormat | dir                                   |
        | systemId     | data.vdjserver.org                    |
        +--------------+---------------------------------------+
        +--------------+---------------------------------------+
        | Field        | Value                                 |
        +--------------+---------------------------------------+
        | name         | ls5                                   |
        | uuid         | 7944596991379107350-242ac112-0001-002 |
        | owner        | mao                                   |
        | path         | /irplus/apps/toy/mao/ls5              |
        | lastModified | 2020-09-03T09:41:54.278-05:00         |
        | source       | None                                  |
        | status       | STAGING_COMPLETED                     |
        | nativeFormat | dir                                   |
        | systemId     | data.vdjserver.org                    |
        +--------------+---------------------------------------+
        +--------------+---------------------------------------+
        | Field        | Value                                 |
        +--------------+---------------------------------------+
        | name         | test                                  |
        | uuid         | 7782633774646947350-242ac112-0001-002 |
        | owner        | mao                                   |
        | path         | /irplus/apps/toy/mao/ls5/test         |
        | lastModified | 2020-09-03T09:41:57.699-05:00         |
        | source       | None                                  |
        | status       | STAGING_COMPLETED                     |
        | nativeFormat | dir                                   |
        | systemId     | data.vdjserver.org                    |
        +--------------+---------------------------------------+
        +-------------------+---------+
        | Field             | Value   |
        +-------------------+---------+
        | uploaded          | 1       |
        | skipped           | 0       |
        | messages          | 0       |
        | bytes_transferred | 1.41 kB |
        | elapsed_sec       | 1       |
        +-------------------+---------+
        +-------------------+---------+
        | Field             | Value   |
        +-------------------+---------+
        | uploaded          | 1       |
        | skipped           | 0       |
        | messages          | 0       |
        | bytes_transferred | 3.48 kB |
        | elapsed_sec       | 1       |
        +-------------------+---------+
        +-------------------+---------+
        | Field             | Value   |
        +-------------------+---------+
        | uploaded          | 1       |
        | skipped           | 0       |
        | messages          | 0       |
        | bytes_transferred | 3.25 kB |
        | elapsed_sec       | 1       |
        +-------------------+---------+
        +---------------+----------------+--------+
        | name          | lastModified   | length |
        +---------------+----------------+--------+
        | test          | 13 seconds ago |   4096 |
        | toy.json      | just now       |   3568 |
        | toy.sh        | just now       |   1442 |
        | toy_common.sh | just now       |   3331 |
        +---------------+----------------+--------+
        +-------------------+------------+
        | Field             | Value      |
        +-------------------+------------+
        | uploaded          | 1          |
        | skipped           | 0          |
        | messages          | 0          |
        | bytes_transferred | 0.00 bytes |
        | elapsed_sec       | 1          |
        +-------------------+------------+
        +-------------------+---------+
        | Field             | Value   |
        +-------------------+---------+
        | uploaded          | 1       |
        | skipped           | 0       |
        | messages          | 0       |
        | bytes_transferred | 3.75 MB |
        | elapsed_sec       | 3       |
        +-------------------+---------+
        +---------+--------------+--------+
        | name    | lastModified | length |
        +---------+--------------+--------+
        | test.sh | just now     |      0 |
        +---------+--------------+--------+


After running the upload script we should see a new folder <username> under agave:///irplus/apps/toy 

> tapis files list agave:///irplus/apps/toy
    
        +---------------+--------------+--------+
        | name          | lastModified | length |
        +---------------+--------------+--------+
        | aurelienbzh   | a day ago    |   4096 |
        | bcorrie       | a day ago    |   4096 |
        | caschramm     | a day ago    |   4096 |
        | edgar.s.silva | a day ago    |   4096 |
        | franasa       | a day ago    |   4096 |
        | grojas        | a day ago    |   4096 |
        | mao           | an hour ago  |   4096 |
        | schristley    | a day ago    |   4096 |
        | sharikrish    | 7 hours ago  |   4096 |
        +---------------+--------------+--------+

> tapis files list agave:///irplus/apps/toy/mao/ls5
    
        +---------------+--------------+--------+
        | name          | lastModified | length |
        +---------------+--------------+--------+
        | test          | an hour ago  |   4096 |
        | toy.json      | an hour ago  |   3568 |
        | toy.sh        | an hour ago  |   1442 |
        | toy_common.sh | an hour ago  |   3331 |
        +---------------+--------------+--------+
    
### Step 5 - Create the application
    
To create an application we will use the _tapis app_ command. To see the help type:  

>  tapis apps create --help
    
It is using this command that we set the wrapper json definition file (in our case the _toy.json_ file).

> less toy.json
    

Then we can create the application. The toy.json is a reference to the local (in docker) file, it is not necessary to be uploaded.
    
> tapis apps create -F toy.json

        +--------------------------+---------------------------------------+
        | Field                    | Value                                 |
        +--------------------------+---------------------------------------+
        | id                       | irplus-toy-ls5-mao-0.1                |
        | name                     | irplus-toy-ls5-mao                    |
        | version                  | 0.1                                   |
        | revision                 | 2                                     |
        | label                    | toy                                   |
        | lastModified             | just now                              |
        | shortDescription         | Toy app on Lonestar5                  |
        | longDescription          | iReceptor+ toy app                    |
        | owner                    | mao                                   |
        | isPublic                 | False                                 |
        | executionType            | HPC                                   |
        | executionSystem          | irplus-ls5.tacc.utexas.edu            |
        | deploymentSystem         | data.vdjserver.org                    |
        | available                | True                                  |
        | parallelism              | PARALLEL                              |
        | defaultProcessorsPerNode | 40                                    |
        | defaultMemoryPerNode     | 1                                     |
        | defaultNodeCount         | 1                                     |
        | defaultMaxRunTime        | None                                  |
        | defaultQueue             | normal                                |
        | helpURI                  | None                                  |
        | deploymentPath           | /irplus/apps/toy/mao/ls5              |
        | templatePath             | toy.sh                                |
        | testPath                 | test/test.sh                          |
        | checkpointable           | False                                 |
        | uuid                     | 8883588656832844266-242ac117-0001-005 |
        | icon                     | None                                  |
        +--------------------------+---------------------------------------+

If the create command runs ok, then the application will have an identifier, which is the name and the version attached to it. I this case the identifier is the value on the field id (above) _irplus-toy-ls5-mao-0.1_.
With this value we can use the show command
    
> tapis appls show <appId>

Results in the same table above.
    
We can list all applications with:
    
> tapis apps list
    
    
        +------------------------------+-------------+
        | id                           | label       |
        +------------------------------+-------------+
        | irplus-toy-ls5-mao-0.1       | toy         |
        | irplus-singularity-ls5-0.1u1 | singularity |
        | igblast-stampede2-1.14u2     | igblast     |
        | repcalc-stampede2-1.0u5      | repcalc     |
        | repcalc-stampede2-1.0u4      | repcalc     |
        | vdj_pipe-stampede2-0.1.7u3   | vdj_pipe    |
        | presto-stampede2-0.5u2       | None        |
        | igblast-stampede2-1.14u1     | igblast     |
        | presto-ls5-0.5.2u6           | None        |
        +------------------------------+-------------+
 
    
### Step 6 - Submit a Job

We have a test job (test-app.json) inside the _test_folder.


Change to test folder:
    
> cd test

See the test job app:
    
> less test-app.json
    
        {
          "name":"test_toy",
          "appId": "irplus-toy-ls5-mao-0.1",
          "batchQueue": "normal",
          "maxRunTime": "01:00:00",
          "nodeCount": 1,
          "archive": false,
          "archiveSystem": "data.vdjserver.org",
          "inputs": {
            "singularity_image": "agave://data.vdjserver.org//irplus/images/immcantation_suite-4.1.0.sif",
            "rearrangement_file": "agave://data.vdjserver.org//irplus/apps/toy/mao/ls5/test/IGH_SRR1383450.airr.tsv.gz"
          },
          "parameters": {
            "creator": "mao",
            "single_flag": true
          }
        }
        test-app.json (END)    

In this job we use two input files that were previously uploaded to tapis, the singularity image and the rearrangements file.

Next, we will submit the test job:

> tapis jobs submit -F test-app.json
    
outputs:
    
        +--------+------------------------------------------+
        | Field  | Value                                    |
        +--------+------------------------------------------+
        | id     | 1ff219f4-523b-4134-8095-1d7cd7efad88-007 |
        | name   | test_toy                                 |
        | status | ACCEPTED                                 |
        +--------+------------------------------------------+
 

### Step 6 - List all the running/failed/finished jobs
    
List all your Jobs:

> tapis jobs list
    
        +------------------------------------------+----------+----------------+
        | id                                       | name     | status         |
        +------------------------------------------+----------+----------------+
        | 1ff219f4-523b-4134-8095-1d7cd7efad88-007 | test_toy | STAGING_INPUTS |
        | b2d6b63e-08a1-4bb9-95c3-57a847637433-007 | test_toy | FINISHED       |
        | 38e3a74e-7cdd-471c-96d1-9ec4fbf68b27-007 | test_toy | FINISHED       |
        | 4d795099-a9a8-4f4b-82d6-4b2e32073c37-007 | test_toy | FAILED         |
        +------------------------------------------+----------+----------------+

And we can see the status of a single job

> tapis jobs show 1ff219f4-523b-4134-8095-1d7cd7efad88-007
    
        +--------------------+------------------------------------------------------------------------------+
        | Field              | Value                                                                        |
        +--------------------+------------------------------------------------------------------------------+
        | accepted           | 2020-09-03T17:48:17.508-05:00                                                |
        | appId              | irplus-toy-ls5-mao-0.1                                                       |
        | appUuid            | 8883588656832844266-242ac117-0001-005                                        |
        | archive            | False                                                                        |
        | archivePath        | mao/archive/jobs/job-1ff219f4-523b-4134-8095-1d7cd7efad88-007                |
        | archiveSystem      | data.vdjserver.org                                                           |
        | blockedCount       | 0                                                                            |
        | created            | 2020-09-03T17:48:17.000-05:00                                                |
        | ended              | None                                                                         |
        | failedStatusChecks | 0                                                                            |
        | id                 | 1ff219f4-523b-4134-8095-1d7cd7efad88-007                                     |
        | lastStatusCheck    | 42 seconds ago                                                               |
        | lastStatusMessage  | Transitioning from status QUEUED to RUNNING in phase MONITORING.             |
        | lastUpdated        | 2020-09-03T17:50:26.000-05:00                                                |
        | maxHours           | 1.0                                                                          |
        | memoryPerNode      | 1.0                                                                          |
        | name               | test_toy                                                                     |
        | nodeCount          | 1                                                                            |
        | owner              | mao                                                                          |
        | processorsPerNode  | 40                                                                           |
        | remoteEnded        | None                                                                         |
        | remoteJobId        | 3034682                                                                      |
        | remoteOutcome      | None                                                                         |
        | remoteQueue        | normal                                                                       |
        | remoteStarted      | 2020-09-03T17:50:26.801-05:00                                                |
        | remoteStatusChecks | 1                                                                            |
        | remoteSubmitted    | a minute ago                                                                 |
        | schedulerJobId     | None                                                                         |
        | status             | RUNNING                                                                      |
        | submitRetries      | 0                                                                            |
        | systemId           | irplus-ls5.tacc.utexas.edu                                                   |
        | tenantId           | vdjserver.org                                                                |
        | tenantQueue        | aloe.jobq.vdjserver.org.submit.DefaultQueue                                  |
        | visible            | True                                                                         |
        | workPath           | /scratch/01114/vdj/mao/job-1ff219f4-523b-4134-8095-1d7cd7efad88-007-test_toy |
        +--------------------+------------------------------------------------------------------------------+
 
To list the logs (stderr) from a job use:
    
> tapis jobs output logs 1ff219f4-523b-4134-8095-1d7cd7efad88-007

        tar (child): binaries.tgz: Cannot open: No such file or directory

        tar (child): Error is not recoverable: exiting now

        tar: Child returned status 2

        tar: Error is not recoverable: exiting now

        cat: joblist: No such file or directory

_The above errors are normal because Scott left some commands in the script._

To list the STDOUT (standard output) of the jobs use:

> tapis jobs output logs 1ff219f4-523b-4134-8095-1d7cd7efad88-007 --stdout

        START at Thu Sep  3 12:50:30 CDT 2020

        Input files:
        singularity_image=immcantation_suite-4.1.0.sif
        rearrangement_file=IGH_SRR1383450.airr.tsv.gz

        Application parameters:
        single_flag=1
        optional_number=
        optional_enum=
        VERSIONS:
        immcantation: 4.1.0
        date: 2020.08.12

        presto: 0.6.1
        changeo: 1.0.0
        alakazam: 1.0.2
        shazam: 1.0.2
        tigger: 1.0.0
        scoper: 1.1.0
        prestor: 0.0.5
        rabhit: 0.1.5
        rdi: 1.0.0
        igphyml: 1.1.3
        airr-py: 1.3.0
        airr-r: 1.3.0
        blast: 2.9.0
        cd-hit: 4.8.1
        igblast: 1.16.0
        muscle: 3.8.425
        phylip: 3.697
        vsearch: 2.13.6

        START at Thu Sep  3 12:52:07 CDT 2020
        initProvenance
        total 1178572
        -rw------- 1 vdj G-803419   31140885 Sep  3 12:50 IGH_SRR1383450.airr.tsv
        -rw------- 1 vdj G-803419 1176412160 Sep  3 12:50 immcantation_suite-4.1.0.sif
        drwx------ 2 vdj G-803419       4096 Sep  3 12:50 test
        -rw------- 1 vdj G-803419        229 Sep  3 12:52 test_toy-1ff219f4-523b-4134-8095-1d7cd7efad88-007.err
        -rw------- 1 vdj G-803419        579 Sep  3 12:52 test_toy-1ff219f4-523b-4134-8095-1d7cd7efad88-007.out
        -rwx------ 1 vdj G-803419       3147 Sep  3 12:50 test_toy.ipcexe
        -rw------- 1 vdj G-803419       3568 Sep  3 12:50 toy.json
        -rw------- 1 vdj G-803419       1442 Sep  3 12:50 toy.sh
        -rw------- 1 vdj G-803419       3331 Sep  3 12:50 toy_common.sh
        DONE at Thu Sep  3 12:52:07 CDT 2020

In the end, what this toy-app does is to print the versions of the software in the incantation suite (the singularity image) and a _ls_ of the directory is it run.
    
### Step 7 - Retrieve outputs

To download see the output files of a job we can use the _tapis jobs output_ command. We can retrieve the help with:

> tapis jobs output --help
    
To list all the output files of a job use the job identifier:
    
> tapis jobs output list 1ff219f4-523b-4134-8095-1d7cd7efad88-007

        +-------------------------------------------------------+---------------+------------+
        | name                                                  | lastModified  |     length |
        +-------------------------------------------------------+---------------+------------+
        | IGH_SRR1383450.airr.tsv                               | 5 minutes ago |   31140885 |
        | immcantation_suite-4.1.0.sif                          | 5 minutes ago | 1176412160 |
        | test                                                  | 4 minutes ago |       4096 |
        | test_toy-1ff219f4-523b-4134-8095-1d7cd7efad88-007.err | 3 minutes ago |        229 |
        | test_toy-1ff219f4-523b-4134-8095-1d7cd7efad88-007.out | 3 minutes ago |       1293 |
        | test_toy.ipcexe                                       | 4 minutes ago |       3147 |
        | toy.json                                              | 4 minutes ago |       3568 |
        | toy.sh                                                | 4 minutes ago |       1442 |
        | toy_common.sh                                         | 4 minutes ago |       3331 |
        +-------------------------------------------------------+---------------+------------+

We can retrieve a single file from the ouput list, or all output.
To retrieve **ALL** the output of the processing use the **Job Id** (This download takes a lot of time - be prepared):
    
> tapis jobs output download 4d795099-a9a8-4f4b-82d6-4b2e32073c37-007

        +-------------+-------+
        | Field       | Value |
        +-------------+-------+
        | downloaded  | 12    |
        | skipped     | 0     |
        | messages    | 0     |
        | elapsed_sec | 616   |
        +-------------+-------+

This will create a folder with the _job id_ as a name, the downloaded contents are inside that folder.
    
    
### Step 8 - Apply with other applications
    
Use this structure to test with other applications.  
    If you modify any of the files, for example the shell scripts, we need to upload the files again. If any change occurs in the json files we need to use the _create_ command:
    
> tapis apps create -F toy.json
    
The downside of using the singularity image is that it occupies several Gb, if we download everything from the output of a job, we will get the singularity file also.

# Requirements to wrap an App with TAPIS

## Files

### Minimum to create an App

To create an App you need at least the Wrapper Description, the Wrapper Bash script and a Test Bash script (currently its blank).


### Upload Script

This is a simple script to upload local files into the Tapis filesystem. All input files must be in the Tapis Filesystem to be retrieved by the Tapis App Wraper.  
The filesystem structure mirrors the github directory structure, i.e. /irplus/apps/TOOL_NAME/VERSION

**NOTE**: Normally an application is compiled on the execution system, and the binaries are added to the App assets. But we will be using singularity images during the Hackathon.

### App Wrapper Description (JSON)

In our tutorial this corresponds to the file _toy.json_.  
The Wrapper (description file) is divided in:
- Important settings:
    - name, version
    - executionSystem (execution system name), see Step 3 above (_tapis systems list_ command)
    - deployementPath (where the app assets are)
    - templatePath (Wrappers Bash script)
    - testPath (Test Bash script)
- inputs:
    - A list of file descriptors
    - Files that Tapis will automatically copy to the job scratch directory
        - e.g. data files, singularity image,
        - minCardinality, maxCardiality, required
- parameters:
    - id, type, required, default, mincardinality, maxCardinality
    - Basic JSON types, arrays and enumerations
    - Create your own: add parameters to trigger different tool usage (e.g. if a single tool performs different unique analysis functionality)
    
### App Wrapper Details (Bash script)

Please note that there are in fact 2 wrapper scripts:
- common/toy_common.sh (Common along all the execution systems)
        
        This script contains the function that runs the Wrapped tool - run_workflow()  which is common to all the execution systems, thus not requiring to be changed or adapted as it happens with the other script below. It also shares a set of common functions that can be used within the App Wrapper script. 
        Loaded within the execution system specific wrapper script (the other one) - see around line 38 of toy.sh:
        
    > \# bring in common functions  
    > source ./toy_common.sh

- ls5/toy.sh (Technically the wrapper script)
        - assign the inputs and parameters of the App Wrapper Description (JSON) to variables.
                NOTE: to use a input or a parameter within the script use "${<id_value>}",  
                where <id_value> is the value of the id property of the object within  
                App Wrapper description file (toy.json)
                Example:
                
    > singularity_image="\\${singularity_image}"  
    > optional_number="\\${optional_number}"
                
        - load Modules, or other pre-installed tools that are available in the HPC
        - calls functions in the common script
        
Some command where left commented - for example see _laucher_ for embarrassingly-parallel multi-processing.


## Singularity image

See if the tool has a docker/singularity image, if not we will need to create one:
- Setup a docker file and put the dockerfile in the tapis github
- Get the tool running in your local docker
- If required run a job passing the docker file using the tool singularity-ls5-0.1u1 app for building a singularity image from docker hub (not really explained how to use it).


