Docker Bugzilla
===============

Create a Bugzilla instance for development and testing purposes
using Docker and Fig.

# Installation

### Linux Workstation

1. Visit [Docker][docker] and get docker up and running on  your system.

2. Visit [Fig][fig] to install Fig for managing multiple related Docker containers.

3. Run the following git clone (specify a directory of your choosing if you like):

        git clone https://github.com/dklawren/docker-bugzilla-fig.git docker-bugzilla

4. cd into the name of the directory into which you cloned the git repository

        cd docker-bugzilla

5. Start the collection of containers!

        fig up

7. Visit [http://localhost/bugzilla][localhost] in your browser and you should be all set.

### OSX Workstation

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

### Windows Workstation

Windows based developers will be best served by installing [Vagrant][vagrant] and
relying on a shim VM to run Docker. Follow the instructions in the installer until
you reach the ``vagrant init`` section. Instead of doing ``vagrant init hashicorp/precise32`` do:

    vagrant init ubuntu/trusty64

From there resume the install process and finish with:

    vagrant ssh

[docker]: https://docs.docker.com/installation/
[fig]: http://www.fig.sh
[localhost]: http://localhost/bugzilla
[vagrant]: https://docs.vagrantup.com/v2/getting-started/
