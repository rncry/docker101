# Docker

## What is it
You can imagine Docker containers as super lightweight VMs. However, instead of running one VM and launching a few apps
or services on it, you would usually just have one Docker container per application. This means you're not
running things like systemd inside the container, you don't need to set up multiple users inside the container, the
container image should only include your application and its dependencies.

Working with Docker forces you to decouple your applications, and this is one of the hardest challenges I faced when 
getting started with it. I'd always read that decoupling services and systems in software design was a good thing, and 
have strived to achieve it, but Docker really forces you to separate different parts of the system and highlights 
coupling you may not have noticed before.

## Why should I care?
Using docker offers a number of quick and great wins:

* Application dependencies are no longer an issue. Everything is contained within the image. Use whichever version of Boost you want. Need Python3? No problem.
* Images will run anywhere, the same, every time.
* Images will run anywhere, the same, every time.
* Test several different versions of an app on the same system at the same time without conflicts.
* You can deploy and install a whole application, including dependencies and even the OS, with a simple push/pull command.

## How does it work
Docker itself runs as a daemon on your host system. To start and build containers you interact with the daemon via a
command line tool (or python API etc) and the daemon does the actual work.

An image contains everything from the OS level up to your application. The kernel itself is shared across all running
containers, this means that startup of a container is near instant. Isolation is achieved using a combination of Linux
namespaces (pid, mount, network etc) and cgroups. Unlike a VM, hardware is not being simulated, so there isn't a
performance penalty to using a container, it's simply leveraging features built into the Linux kernel.

The filesystem that contains all the docker images on your system is based on the copy on write principle, so docker images
are effectively built in layers. All the images which share the same ubuntu base OS, will share the same base layer. If
you modify something in the OS, that gets layered on top rather than modifying the underlying image. So layers can be
shared but separation is preserved.

## Examples
Docker is incredibly powerful and allows you to do many things. We're going to just run through the basics here, with a
couple of interesting use cases. Hopefully this should give you an overview of what's possible, but for more advanced
usage, I'd recommend reading the [docker documentation](https://docs.docker.com/userguide/).

If you see any errors like this:

```
INFO[0001] Error getting container 0c05d122f4ab8155a2febc5f4e35f9c6838de8a06d110ec3258b8022019cb5d7 from driver devicemapper: Error mounting '/dev/mapper/docker-253:2-13893636-0c05d122f4ab8155a2febc5f4e35f9c6838de8a06d110ec3258b8022019cb5d7' on '/var/tmp/doNotRemove/docker/devicemapper/mnt/0c05d122f4ab8155a2febc5f4e35f9c6838de8a06d110ec3258b8022019cb5d7': no such file or directory
```

Just retry the docker command. It's an issue with Centos' support for devicemapper filesystems, whilst fixable, it's 
beyond the scope of this exercise!

### First steps
First you need to get the docker daemon running on your machine. Docker is a single binary file which you can download
from [get.docker.com](get.docker.com). The binary can be run as a daemon, and is also the CLI. If you want it installed 
as a service on your host, I'd suggest looking at the relevant install instructions here: 
[https://docs.docker.com/installation/](https://docs.docker.com/installation/).

Once you have docker installed somewhere, you can start the daemon by typing:

```docker -d```

Interacting with the docker daemon requires root privileges, so you can either add sudo to all the following commands,
or open up access to the docker run socket. In theory you should be able to get this access by adding your user to the
`docker` user group, but I've found that this doesn't always work on some of our systems. For foolproof access, you
can run:

```sudo chmod 777 /var/run/docker.sock```

(with the obvious security issues this raises).

To test out the installation run `docker -v` to see the version, and `docker ps` will show you all running containers
(currently this should be empty!)

### Hello World
Ok so lets bring up an ubuntu container and echo Hello World to the terminal:

```docker run -it ubuntu echo 'Hello World'```

Lets break down the command:

`docker run` : this is the entrypoint for running containers.

`-it` : `i` stands for interactive (meaning it connects stdin and stdout to your terminal) and `t` stands for tty, so docker
presents a tty interface to the container running. Basically if you want to interact with a container, use `-it`

`ubuntu` : this is the name of the image to be run. We could have written `centos:6` or `redis` or `mycoolapp` and so on.
When you run this command the first time, it will download the latest ubuntu image from Docker Hub (basically a big
repository of Docker images, all of the major OS versions have official images in there, as well as many many applications
and user generated images).

`echo 'Hello World'` : this is the command to run inside the container. The ubuntu image doesn't have a default command
so would just exit immediately if you didn't provide anything here. Now try replacing `echo 'Hello World'` with `/bin/bash`
Boom. You're in a bash shell inside an ubuntu OS. Take a look around: `ls`, `cd`, `touch` some files, run `apt-get install`
and so on, it's a full Linux OS running in the container. Now hit ctrl+D (or type `exit`) and you're back to the shell
on your host machine. Pretty powerful right?

### Running a Docker Registry
By default, when you supply an image name to docker run, if you don't have that image built locally, docker will go to
[Docker Hub](hub.docker.com/explore) and look for that image name, pull it (`docker pull ubuntu`) and then run it. You
can set up a user account with Docker Hub and push your own images to it which will be publically available under your
username. But what if you want to host your own private repository? There's a docker image for that.

The Docker Registry ([docs](https://docs.docker.com/registry/)) provides a quick and easy way to host your own repo. To
run the registry, use the following command:

```docker run -d -p 5000:5000 --name registry registry:2```

Lets break that down:

`docker run` : this command should start to become familiar

`-d` : this means run in detached mode. Kind of the opposite to `-it`. The container will be launched as a background
process and the docker CLI will return immediately.

`-p 5000:5000` : `-p` is the parameter used to map network ports from inside the container, to the host. Inside the
container, the registry application is listening on port 5000, but if we don't open up that port to the host machine,
it won't be able to see any connections from the outside world. `5000:5000` maps port 5000 in the container to port 5000
on the host. If we wanted we could use `-p 80:5000` to map port 80 on the host to port 5000 on the container. That would
mean that anything that connects to port 80 on your host machine would be forwarded to the service INSIDE the container
listening on port 5000.

`--name registy` : this gives the running container a name which you can use later to stop or inspect it. If you don't
specify a name docker will give it a random name. Naming containers is more useful if you're linking them together on
your host (something we won't cover here but gets explained in the docker docs). We'll use it later to kill this container.

`registry:2` this specifies the image to run (registry) and the tagged version (2)

After exectuing that command, you should have a docker registry running on your host on port 5000. So lets play around
with it.

`docker pull ubuntu` : strictly speaking this isn't really necessary as we've already pulled this container from docker
hub and it's available on our host (typing `docker images` will verify this).

`docker tag ubuntu localhost:5000/myfirstimage` : here we are tagging the ubuntu image with a new name. To use your private
registry, you need to tag all the images you create with the registry name (in this case `localhost:5000/`). If you don't
tag the registry name as part of the image name, docker assumes you mean docker hub and will attempt to push/pull from
there instead.

`docker push localhost:5000/myfirstimage` : now you're pushing the image you just tagged into your locally running repo.

`docker pull localhost:5000/myfirstimage` : and now you've just pulled it back again.

When you're done with this tutorial you can stop the registry and remove the image and all data:

`docker stop registry && docker rm -v registry`

### Writing a Dockerfile
When working with containers, you could start up a centos image, install all your dependencies with Yum, write your code
and so on, then use `docker commit` to save your image which you can then push to the repo or run again later.

But wouldn't it be much nicer if we could just build images programmatically? Enter the Dockerfile.

Dockerfiles are a bit like bash scripts, in that they execute each line one after the other, saving the output into a
new container, which is used to run the next command and so on. Here's a very basic example of a dockerfile (watch out
for the gotcha!):

```
FROM centos:7
# Add EPEL repos (for python-pip)
RUN rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum -y update
RUN yum -y install python python-pip git jq openssl python-devel
RUN yum -y groupinstall "Development tools"
RUN export foo=bar
RUN echo ${foo}
```

Lets run through it:

`FROM centos:7` : At the top of every dockerfile you specify the base image. In this case we're using Centos 7, but you
could specify your own image here, say if you wanted a common base image which installs development tools and other
images based on top of it for separate applications.

```
RUN rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum -y update
RUN yum -y install python python-pip git jq openssl python-devel
RUN yum -y groupinstall "Development tools"
```
Here we're installing some basic packages. The `RUN` directive basically means execute that command in the container,
the output of which becomes the next container.

`RUN export foo=bar` : Again this just runs a command to set the environment variable in the container.

`RUN echo ${foo}` : Uh oh! `foo` is not set! But why? The point I'm trying to hammer home here, is that as the dockerfile
is processed, every command runs in a fresh container, produced by the output of the last command. The previous statement
`RUN export foo=bar` didn't actually change anything in the container, it just set an environment variable, and that
environment does not persist when you start a new container. 'But I want to set environment variables!' I hear you cry!
Don't worry, there's a directive in the dockerfile you can use to do that:

`ENV foo bar` : this will ensure that this environment variable becomes part of the image.

Now another problem with that example is that you'd never RUN an echo command (or anything similar) as part of a Dockerfile.
A Dockefile is for building your image, when you want to specify a command to run when the image executes as a container,
use `ENTRYPOINT` or `CMD`:

`CMD echo $foo`

You'll find a file called `Dockerfile` along with this readme. Take a look at it and then build it:

`docker build -t foobar .`

This tells docker to build the current directory (`.`) and tag the resulting image with the
name `foobar`. By default, docker will look for a file called `Dockerfile` in the build directory and use that.

Now run the image:

`docker run -it foobar`

You should see `bar` printed to the terminal. Now you can override the CMD directive in the dockerfile with your own
command:

`docker run -it foobar /bin/bash`

Verify that `foo` is set in your bash environment inside the container.

### Mounting your code in a container
So far we've seen how you can create images, push them to a repo and run them. But what if you need to tinker a little?
Or what if you want to access some data on the host's filesystem inside your container?

Docker allows you to mount files and directories from the host directly into the container. This can be useful if you
want to test out some new development code inside a production container.

`cd coolapp` to get into the coolapp directory. Inside you'll find a Dockerfile, some python code, and a dependency of
our application (an archive of fonts). Have a look inside the Dockerfile and then build it:

`docker build -t coolapp .`

Now our application is a Qt app and so requires access to the host's X server in order to show a window on our display.
Docker allows you to mount host files into containers, and this includes sockets, so we can run the container like this:

`docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY coolapp`

The new bits:

`-v /tmp/.X11-unix:/tmp/.X11-unix` : this tells docker to mount `/tmp/.X11-unix` from the host into the same location
inside the running container.

`-e DISPLAY` : this tells docker to set the `DISPLAY` environment variable inside the container, as we haven't specified
a value, docker will use the same value from the host.

Note: if this doesn't work (can't access display errors or something similar) you may need to open up access permissions
to your local X server. You can either create an Xauthority file and mount this inside the container, or run `xhost +`
on your host (which is insecure!) before running the container.

When you run the container you should see a Qt popup saying 'Hello I'm production code!'. Now take a look at `coolapp-dev.py`
(feel free to change it!). This file has not been baked into the docker image during the build process, but we want to
try it inside our container to see if our dev code works. Well, we can simply mount it into the container over the top
of the existing file:

`docker run -it -v ${PWD}/coolapp-dev.py:/usr/local/bin/coolapp -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY coolapp`

Now change the message in coolapp-dev.py and run that command again.. you can see how easy it could be to test whole 
development branches against production systems.

### Attaching to a running container
Now lets go a little further. Change into the `anotherapp` folder, have a look at the files and then build the docker
image:

`docker build -t anotherapp .`

(Note that we're inheriting from the coolapp image you already built, simply to speed things up)

All this application does is read a configuration file and print the output to stdout. So lets launch it:

`docker run -it anotherapp`

You should see `production` being printed every second. Now open another terminal and run another copy of the app (you'll
see why in a second):
 
`docker run -it anotherapp`
 
Again, `production` will start filling up your terminal. You now have two identical copies of the container running, 
completely independent of each other. So lets test out a new configuration file in one of them, live, and see what 
happens. Docker allows you to execute a new process inside an already running container, so lets jump inside one and run
a bash shell. First of all we'll need to list all the running containers to get the ID of one to attach to, so open a 
new shell and type:

`docker ps`

Will give an output something like:

```
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                                             NAMES            
980db5fba47d        anotherapp:latest   "/bin/sh -c /usr/loc   9 seconds ago       Up 7 seconds                                                          compassionate_goodall   
cd4a44b88d86        anotherapp:latest   "/bin/sh -c /usr/loc   16 seconds ago      Up 15 seconds                                                         modest_albattani
```

Using the Container ID we can execute a command inside the container, in much the same way as the RUN command, so lets 
start an interactive bash shell in one:

`docker exec -it 980db5fba47d /bin/bash`

Note that we could have named our containers using the `--name` flag of the RUN command (perhaps `production` and 
`development` would have been good names) but we're using the ID here just to show that you can.

Now inside your container, use vi (or install your favourite editor and use that) and change the contents of 
`/etc/anotherapp.cfg` to `development`.
  
Now, have a look at the two other shells you have open (running the two containers), one should still be scrolling 
`production` and the other should now be displaying `development`. To kill the containers either hit Ctrl+C in the shell
(we're in interactive mode, so stdin will get passed to the container) or use:

`docker stop 980db5fba47d`

Hopefully your mind is blown with the possibilities available here...

# Mesos

## What is it

## How does it work?
Moving parts, frameworks

## Getting up and running

## Starting a task
