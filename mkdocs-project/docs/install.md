# Learn Linux Shell / Install Shell Software #

Linux shell software must be installed before running the shell command program and shell scripts.
Installing shell software on Windows requires extra effort.
Default shell programs will already be installed in Linux environments, although others can additionally be installed.
This page describes how to install different shell programs,
as well as providing background on which shell to use.

* [Choosing a Linux Shell](#choosing-a-linux-shell)
* [Installing a Shell on Linux](#installing-a-shell-on-linux)
* [Installing Cygwin](#installing-cygwin)
* [Installing MinGW](#installing-mingw)
* [Installing Git for Windows](#installing-git-for-windows)
* [Installing the Linux Subsystem on Windows 10](#installing-the-linux-subsystem-on-windows-10)

-------

## Choosing a Linux Shell ##

Many Linux shells are available:

* [Comparison of command shells (Wikipedia)](https://en.wikipedia.org/wiki/Comparison_of_command_shells)

Choosing a command shell typically boils down to a few considerations, including:

* what is the default in an environment?
* what is the availability of the shell on other environments (how portable)?
* does a shell adhere to standards?
* what is the functionality of the shell?
* what is the performance of the shell?

These questions may be of little concern to the average shell user, especially those who just
want to get some work done and are not professional programmers.
In this case, the choice may be between a POSIX standards shell like `sh` and a popular shell with extensions such as `bash`
that make some tasks easier.

The Bourne shell (`sh` program) is distributed with most Linux systems and provides a common set of features
intended for automated tasks.
The `bash` shell is also distributed with most Linux systems and is intended for login 
shells, meaning those that provide a command prompt that users interact with.
The `bash` shell is slower to start up and run than `sh` and therefore `sh` is preferred when
performance is a consideration.  The `bash` shell provides useful command line features such as command completion.

The ultimate choice will depend on the programmer that creates a shell script.
Shell script programmers should seek to be adept at `sh` and learn where `bash` provides benefits.
For the remainder of this documentation, discussion will generally focus on `sh`,
with `bash` topics clearly indicated.

Most of the environments discussed in the following sections will provide `sh` and `bash`.
Additional shells can be installed within the environment using the normal installation tools for the environment.

Use the following command to find whether a program is available once a shell has been opened:

```sh
$ which sh

$ which bash
```

## ![Linux](images/linux-32.png)Installing a Shell on Linux ##

In most cases, the default shell programs that are installed will be sufficient
but sometimes it is useful to install other shell programs.
Installing a shell program on Linux involves determining the package name for the program
and then running the installer for that version of Linux.
For example, the Cygwin installer lists available shells and Linux distributions
usually use an installer such as `apt-get`.

Refer to Linux software installation instructions for the Linux version.

## ![Cygwin](images/cygwin-32.png)Installing Cygwin ##

The Cygwin software is a free and open source Linux implementation that runs on Windows.
The Cygwin shells can run Windows programs because Cygwin programs are compiled to run on Windows.
The Cygwin installation program will install `sh` and `bash` by default and additional shells and programs can be installed.
Cygwin is a very useful environment to increase productivity.  See:

* See [OWF Learn Cygwin](http://learn.openwaterfoundation.org/owf-learn-cygwin/)
* See the [Cygwin](https://www.cygwin.com/) website

## Installing MinGW ##

MinGW is the GNU software project to provide a free and open source version of UNIX.
The Open Water Foundation does not typically install MinGW unless it is a part of another software tool
such as Git for Windows.
For example, if Git For Windows is installed, MinGW will be available in some form and therefore a command shell will be available.
See:

* [Minimalist GNU for Windows](http://www.mingw.org/)

## ![Git](images/git-bash-32.png)Installing Git for Windows ##

Git for Windows is often installed by software developers and others who are using the Git version control system
to track versions of electronic files and collaborate with others on electronic file edits.
Git for Windows will also install MinGW and Git Bash.  See:

* [Git](https://git-scm.com/) - select the ***Downloads*** link and then ***Windows***

## ![Windows](images/windows-32.png)Installing the Linux Subsystem on Windows 10 ##

The following explains how to enable/install the Linux Subsystem on Windows 10.
Microsoft is now shipping a version of Linux to help developers.
**OWF will attempt to improve on this documentation when time allows.**

* [How to Install and Use the Linux Bash Shell on Windows 10](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/)
