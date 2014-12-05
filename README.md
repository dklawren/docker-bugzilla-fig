Docker Bugzilla
===============

Create a Bugzilla instance for development and testing purposes
using Docker and Fig.

# Installation

## Linux Workstation

1. Visit [Docker][docker] and get docker up and running on  your system.

2. Visit [Fig][fig] to install Fig for managing multiple related Docker containers.

3. Run the following git clone (specify a directory of your choosing if you like):

        git clone https://github.com/dklawren/docker-bugzilla-fig.git docker-bugzilla

4. cd into the name of the directory into which you cloned the git repository

        cd docker-bugzilla

5. Start the collection of containers!

        fig up

7. Visit [http://localhost/bugzilla][localhost] in your browser and you should be all set.

## OSX Workstation

1. Visit [Docker][docker] and get docker up and running on your system.

2. Visit [Fig][fig] to install Fig for managing multiple related Docker containers.

3. Start boot2docker in a terminal once it is installed. Ensure that you run the
 export DOCKER_HOST=... lines when prompted:

        boot2docker start
        export DOCKER_HOST=tcp://192.168.59.103:2375

4. Run the following git clone to a directory of your choosing:

        git clone https://github.com/dklawren/docker-bugzilla-fig.git docker-bugzilla

5. cd into the name of the directory into which you cloned the git repository

        cd docker-bugzilla

6. Start the collection of containers!:

        fig up

7. Visit http://localhost/bugzilla in your browser and you should be all set.

## Windows Workstation

Windows based developers will be best served by installing [Vagrant][vagrant] and
relying on a shim VM to run Docker. Follow the instructions in the installer until
you reach the ``vagrant init`` section. Instead of doing ``vagrant init hashicorp/precise32`` do:

    vagrant init ubuntu/trusty64

From there resume the install process and finish with:

    vagrant ssh

# Hacking on Bugzilla Code

There are two option for accessing the code in the running web container so that
you can make changes and generate patches.

## docker exec

With Docker version 1.3 and higher, you can now use ``docker exec`` to shell
into a running container. First, you will need to find the exact name given to
the running container by the ``fig up`` command. You can use ``fig ps`` to see
the list of containers. For example:

    Name                 Command              State         Ports
    -----------------------------------------------------------------------
    bugzilla_bzdb_1    mysqld_safe                    Up      3606/tcp, 3306/tcp
    bugzilla_bzweb_1   /usr/sbin/httpd -DFOREGROUND   Up      80->80/tcp

So to shell into the container as the ``bugzilla`` user you would simply do:

    docker exec -it bugzilla_bzweb_1 su - bugzilla
    cd ~/htdocs/bugzilla

Now you should be able to edit the code using ``vim`` and use ``git diff`` for
example to generate patches.

To shell in as the root user, to restart the web server after code changes for
example, you would just do the following instead:

    docker exec -it bugzilla_bzweb_1 bash

More information on using ``docker exec`` can be found in the
[Docker Exec Documentation](https://docs.docker.com/reference/commandline/cli/#exec).

## nsenter

For versions of Docker prior to 1.3, you need to either run a sshd server inside
the container or you could use a Linux utility called ``nsenter``. To use
``nsenter``, you should either install the ``util-linux`` package for your Linux
distro or follow the installation instructions described
[here](http://blog.docker.com/tag/nsenter/).

You will need to know the name of the web container using ``fig ps``.

    Name                 Command              State         Ports
    -----------------------------------------------------------------------
    bugzilla_bzdb_1    mysqld_safe                    Up      3606/tcp, 3306/tcp
    bugzilla_bzweb_1   /usr/sbin/httpd -DFOREGROUND   Up      80->80/tcp

Using the container name, you can find the process ID of the container in order
to use the ``nsenter`` command to run a command in the container.

    PID=$(docker inspect --format {{.State.Pid}} bugzilla_bzweb_1)
    sudo nsenter --target $PID --mount --uts --ipc --net --pid su - bugzilla

Now you should be able to edit the code using ``vim`` and use ``git diff`` for
example to generate patches.

For root access just remove the last part:

    sudo nsenter --target $PID --mount --uts --ipc --net --pid

[docker]: https://docs.docker.com/installation/
[fig]: http://www.fig.sh
[localhost]: http://localhost/bugzilla
[vagrant]: https://docs.vagrantup.com/v2/getting-started/
