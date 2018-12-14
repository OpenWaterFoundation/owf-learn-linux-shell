# Linux Shell / User Environment Basics #

The command shell operates between the core operating system and other programs.
Consequently, a certain amount of start-up information must be configured for the shell to do its work.
This page explains fundamental configuration and interactions for the different Linux environments and shells,
in particular for Windows environments.

* [Location of Software Files](#location-of-software-files)
* [Location of User Files](#location-of-user-files)
* [Login Shell and Shell Script Shell](#login-shell-and-shell-script-shell)
* [Shell Configuration Files](#shell-configuration-files)
* [Environment Variables](#environment-variables)
* [PATH Environment Variable](#path-environment-variable)
* [File Paths](#file-paths)

-----

## Location of Software Files ##

Software files for each Linux environment are located in standard folders depending on the environment.
These files provide the functionality of the Linux environment.
It may be unnecessary to deal with software files;
however, it is helpful to know where files exist in order to troubleshoot, etc.
The following table summarizes software locations for each Linux environment.

| Environment                   | Software File Location (from shell) | Software File Location (from Windows) |
| ----------------------------- | ----------------------------------- | ------------------------------------- |
| Cygwin                        | `/`                                 | `C:\cygwin64`                         |
| Git for Windows               | `/`                                 | `C:\Program Files\Git`                |
| Linux                         | [Filesystem Hierarchy Standard on Wikipedia](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard) | Not applicable |
| Linux Subsystem on Windows 10 | `/`                                 | ?                                     |
| MinGW                         | ?                                   | `C:\MinGW`                            |

## Location of User Files ##

User files for each Linux environment are located in standard folders depending on the environment.
The user files in the Linux environment are typically shared with the Windows file system (when installed on Windows)
via links or logic built into the command shell programs.
The following table summarizes user file locations for each Linux environment, where `user` is the name of the user.
The Linux `pwd` command can be used to determine the present working directory,
for example after opening a command shell.

| Environment                   | Linux User File Location (from Linux) | Linux User File Location (from Windows) | Windows User File Location (from Linux) | Windows User File Location (from Windows) |
| ----------------------------- | ------------------------------------- | --------------------------------------- | --------------------------------------- | ----------------------------------------- |
| Cygwin                        | `/home/user`                          | `C:\cygwin64\home\user`                 | `/cygdrive/C/Users/user`                | `C:\Users\user`                           |
| Git for Windows (Git Bash)    | `/c/Users/user`                       | `C:\Users\user`                         | `/c/Users/user`                         | `C:\Users\user`                           |
| Linux                         | `/home/user`                          | Not applicable                          | Not applicable                          | Not applicable                            |
| Linux Subsystem on Windows 10 | `/home/user`                          | `C:\Users\sam\AppData\Local\Packages\CanonicalGroupLimited.UbuntuonWindows_abcd123etc\LocalState\rootfs\home\sam` | `/mnt/c`, etc. | `C:\Users\user` |
| MinGW                         | ?                                     | `C:\MinGW\msys\1.0\home\user`           | ?                                       | `C:\Users\user`                           |

The Linux and Windows files may exist in the same location or may be separate.
For example, Git Bash user files are in the same location as Windows user files.
However, Cygdrive uses a folder for user files within Cygwin,
while allowing access to Windows files (`/cygdrive/C/Users/user`).

The home folder can be accessed programmatically using an environment variable, as [discussed in the Environment Variables section below](#environment-variables).

## Login Shell and Shell Script Shell ##

A Linux command shell can be used as the login shell or to run a shell script.
A Linux command shell is used when a shell window is opened and provides the command shell prompt.
The command shell that is being run can be listed by running the `ps` (process status) command:

```sh
$ ps
      PID    PPID    PGID     WINPID   TTY         UID    STIME COMMAND
    14148   14320   14148      11836  pty0        1001   Nov 28 /usr/bin/bash
     9032       1    9032       9032  ?           1001   Nov 28 /usr/bin/mintty
S   19264   14148   19264       5892  pty0        1001 23:47:44 /usr/bin/vim

```

In the above it is clear that the `bash` shell is being run.

Shell scripts are run from a parent command shell using the command shell indicated in the shell script.
It is standard for the first line in the shell script to indicate which program should be used for the script,
and the program can be a command shell or another program.
For example, the following comment at the top of the shell script indicates to run the
script with the `sh` command shell program located in the standard Linux software installation folder:

```sh
#!/bin/sh
#
# This script will be run with the Bourne shell
```

It is common to use the `bash` command shell as the login shell and other command shells such
as `sh` to run other programs.

## Shell Configuration Files ##

Command shell programs can be configured for a user by modifying files in the user's home folder.
Configuration files depend on the shell that is being used.
Configuration changes are often required when installing software and such
changes may occur automatically during installation or require the user
to make such changes with a text editor.

### `bash` Configuration Files ###

The `bash` command shell is often used for the login shell and provides
features such as:

* command completion - for example, the tab key will complete filenames
* command prompt customization - for example show the current folder
* command aliases - for example alias `la` to `ls -a` to list all files

The following `bash` configuration files are used to configure the `bash` shell environment:

* `.bash_profile` - is executed for login shells
* `.bashrc` - is executed for interactive non-login shells and when running a shell script

On Linux, files and folders with names that start with a period are treated as hidden and are not
by default listed by the `ls` command (use `ls -a` to list all files).
Both of these files can be created in the user's home folder.
To avoid redundancy, the `.bashrc` file can be called by the `.bash_profile` file, as in:

```sh
# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

```

## Environment Variables ##

Command shell programs use environment variables to hold important configuration information.
This simplifies access to important data such as the user's account name.
Standard Linux defines standard environment variables and each shell also defines environment variables.
For example, the `HOME` environment variable indicates the user's home folder.

Environment variables are separate from normal variables in a shell script.
Normal variables are only visible in the shell script and are then discarded when the shell script is complete.
The following illustrates setting a normal variable and environment variable in a shell script:

```sh
normalVariable="test value"
export ENVIRONMENT_VARIABLE="test value"
```

It is customary to name environment variables with all uppercase letters.

A list of all environment variables can be displayed using the following commands:

```sh
$ env
$ set
```

A single environment variable can be displayed using syntax similar to:

```sh
$ echo $HOME
```

A Microsoft Windows command shell also maintains a list of environment variables, which can be displayed with the following command:

```cmd
> set
> echo %USERPROFILE%
```

The following table indicates whether the Linux environments are able to access Windows environment variables.

### Scope of Environment Variables ###

Environment variables that are defined for a parent shell are typically inherited by child shell programs,
such as those used to run shell scripts.
Therefore, when a shell script is run from a command shell prompt, it is generally
not necessary to reinitialize environment variables.
However, if the shell script being run needs additional configuration,
then such configuration needs to be done in the login shell before running the shell script.

Environment variables that are set in a script to do not propagate to other command shells that were previously started.
For example, if a login window is opened and environment variables are set, they are active only for that window.
Setting the environment variables in a startup configuration file will cause those variables to be set for every
window that is opened.

### Accessing Windows Environment Variables from Linux ###

Linux environments that run on Windows can access Windows environment variables.
This includes Cygwin and Git Bash.

## PATH Environment Variable ##

The `PATH` environment variable indicates to shell programs how to find programs when program names
are typed at the command shell prompt.
All folders in the `PATH` are searched to find the program name and if found the program is run.

If `PATH` environment variable does not contain the required folder,
then the `PATH` environment variable can be modified to add the folder.
This is typically done in shell startup files, such as the `.bash_profile` or `.bashrc` file.

Another option is to edit the `PATH` environment variable in a "setup" shell script file that is
run from the command line.
The disadvantage to this approach is that it must be run each time the setting is configured.
The advantage of this approach is that configuration can be isolated from the general user environment.

## File Paths ##

File paths in Linux and Windows can be absolute or relative,
where absolute paths include the full path from root folder, `/` on Linux, and `C:\` on Windows.
Relative paths are relative to the current folder and can contain `..` to move up a folder level.

File paths on Linux use the `/` separator for folder (directory) levels whereas Windows uses `\` for the separator.

Spaces in file and folder names can cause issues because programs do not know whether the
space indicates a break between command parameters.
Therefore, names containing spaces must be surrounded by double or single quotes.
Some environments, such as Cygwin, allow spaces to be handled by inserting a backslash before the space.

Modifying the `PATH` can simplify handling software installation folders that contain spaces because
the spaces don't need to be dealt with every time that a program name is typed.
