# iReceptorPlus for Tapis

Scripts and JSON definitions for deploying iReceptorPlus systems and apps in Tapis.

[Tapis](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/index.html) (formerly called Agave) is an open source, science-as-a-service API platform.

# Contents

* systems: JSON definitions for execution/storage systems.

* apps: JSON definitions and application wrapper for tools.

# Using the docker image

This repository has a corresponding docker image which can be used to access Tapis. The
image contains the Tapis command-line interface ([CLI](https://tapis-cli.readthedocs.io/en/latest/)),
[agavepy](https://agavepy.readthedocs.io/en/master/) python library, and other
useful tools. Immune repertoire analysis tools do not reside within this image, as they
will be provided in separate images that can be run on HPC.

## Requirements

To use the docker image, you need these requirements:

* [Docker Desktop](https://www.docker.com/products/docker-desktop) installed on your computer.

* [VDJServer](https://vdjserver.org) user account.

Pull down the latest image from docker hub.

```
docker pull ireceptorplus/tapis
```

## Initialize Tapis CLI and User Authentication

When you initialize Tapis and login with your VDJServer user account, Tapis returns an
authentication token for all subsequence requests. This token is managed for you and is
saved to disk. However, by default, files created in the docker container are deleted when
exiting the container. To avoid having to initialize Tapis every time you use the docker image,
we mount a local directory into the docker container where the files are saved.

```
# Create a local directory to hold Tapis initialization and token data
mkdir tapis-token
```

Run a bash shell and initialize Tapis. The initialization with ask a few questions.
When it asks for the tenant name, pick `vdjserver.org`. It will then ask for your VDJServer
username and password for login.
The prompts for container registry access and git server access can be left blank or
left as the provided defaults.

```
docker run -v $PWD/tapis-token:/root/.agave -it ireceptorplus/tapis bash

tapis auth init
```

With Tapis initialized, you can now try some commands:

```
# help for the Tapis CLI
tapis --help

# show your authentication token
tapis auth show

# refresh your authentication token when it expires
tapis auth tokens refresh

# create a new authentication token (requires password)
tapis auth tokens create

# list of systems available
tapis systems list

# list of apps available
tapis apps list

# list files in the irplus directory (you need permission to view)
tapis files list agave:///irplus
```

## App Development

While the docker image provides a copy of this repository, any changes you make to the file
might be lost, so clone this repository to your local system and mount it in the docker
container for doing development. You will generally want to perform git commands and use
an editor outside of docker.

```
# clone the repository
git clone https://github.com/ireceptor-plus/tapis.git

# run docker with both your tapis token and source directories mounted
docker run -v $PWD/tapis-token:/root/.agave -v $PWD/tapis:/work -it ireceptorplus/tapis bash

# access local app development
cd /work
```
