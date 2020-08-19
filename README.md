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

When you initialize Tapis and login with your VDJServer user account, Tapis provides returns an
authentication token for all subsequence requests. This token is managed for you and is
saved to disk. However, files created in the docker container are deleted when
exiting the container. To avoid having to initialize Tapis every time you use the docker image,
we mount a local directory into the docker container where the files are saved.

```
# Create a local directory to hold Tapis initialization and token data
mkdir tapis-token
```

Run a bash shell and initialize Tapis. The initialization with ask a few questions.
When it asks for the tenant name, pick `vdjserver.org`. It will then ask for you VDJServer
username and password for login.
The prompts for container registry access and git server access can be left blank or
with the provided defaults.

```
docker run -v $PWD/tapis-token:/root/.agave -it ireceptorplus/tapis bash

tapis auth init
```
