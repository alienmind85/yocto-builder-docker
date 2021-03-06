
#Target: NXP Yocto @ version L4.14.78_1.0.0

# Use Ubuntu 16.04 LTS as the basis for the Docker image.
FROM ubuntu:16.04


# Install essential Yocto Project host package
RUN  apt-get update && apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat libsdl1.2-dev


# Install i.MX layers host packages for a Ubuntu 12.04 or 14.04 host setup
RUN apt-get -y install libsdl1.2-dev xterm sed cvs subversion coreutils texi2html \
    docbook-utils python-pysqlite2 help2man make gcc g++ desktop-file-utils \
    libgl1-mesa-dev libglu1-mesa-dev mercurial autoconf automake groff curl lzop asciidoc


# Install utility
RUN apt-get install sudo locales


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8


# Replace dash with bash
# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up the build environment in CMD. Use bash as an alias for sh.
RUN rm /bin/sh && ln -s bash /bin/sh


# Install the “repo” utility
RUN  curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
&& chmod a+x /usr/local/bin/repo


ENV USER_NAME none
# script/binary to exec when the user perform the login
# If there is something to exec the container exec the task and than cloeses itself (handless
# usage). Otherwise, there is nothing to execute, the container will be used in a interactive
# mode and container allows the user to perform what he wants.
ENV USER_CMD none

ADD startup.sh /bin

ENTRYPOINT ["sh", "startup.sh"]