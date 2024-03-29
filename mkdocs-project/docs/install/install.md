# Linux Shell / Select and Install Shell Software #

Selecting a Linux shell will define the features of the shell scripting language.
Linux shell software must be installed before running the shell command program and shell scripts.
Installing Linux shell software on Windows requires extra effort.
Default shell programs such as `sh` and `bash` will already be installed in Linux environments,
although others can additionally be installed.
This page describes how to install different shell programs,
as well as providing background on which shell to use.

*   [Choosing a Linux Shell](#choosing-a-linux-shell)
*   [Installing a Shell on Linux](#installing-a-shell-on-linux)
*   [Installing Cygwin](#installing-cygwin)
*   [Installing MinGW](#installing-mingw)
*   [Installing Git for Windows (Git Bash)](#installing-git-for-windows-git-bash)
*   [Installing the Linux Subsystem on Windows 10](#installing-the-linux-subsystem-on-windows-10)

-------

## Choosing a Linux Shell ##

Many Linux shells are available, often deriving from a common ancestry such as `sh`:

*   [Comparison of command shells (Wikipedia)](https://en.wikipedia.org/wiki/Comparison_of_command_shells)

Choosing a command shell typically boils down to a few considerations, including:

*   what is the default in an environment?
*   what is the availability of the shell on other environments (how portable)?
*   does a shell adhere to standards?
*   what is the functionality of the shell?
*   what is the performance of the shell (how fast does it load and run)?

These questions may be of little concern to the average shell user, especially those who just
want to get some work done and are not professional programmers.
In this case, the choice of shell may depend on what was used in an example that was found on the internet.

The Bourne shell (`sh` program) is distributed with most Linux systems and provides a common set of features
intended for automated tasks.
The `bash` shell is also distributed with most Linux systems and is intended for login 
shells, meaning those that provide a command prompt that users interact with.
The `bash` shell is slower to start up and run than `sh` and therefore `sh` is
preferred when performance is a major consideration,
and comparison of run times can be compared to see if this is an issue.
The `bash` shell provides useful command line features such as command completion that are used
in interactive environments.
**A general guideline is:  use the power and features of `bash` unless there are concerns about performance
or portability.**  See:

*   [`sh` man page](http://man7.org/linux/man-pages/man1/sh.1p.html)
*   [`bash` man page](http://man7.org/linux/man-pages/man1/bash.1.html)

Note that in some systems shells have been aliased to a specific version, for example:
[`sh` same as `bash`](https://linux.die.net/man/1/sh).
To determine whether this is occurring, do a long listing on the program files to see if symbolic links are used or
the file sizes the same.  If the files are the same size, the `diff` program can be used to confirm.
For example, the following, run on Cygwin, indicates that `sh` and `bash` are equivalent.
This is important because different Linux operating systems may have different defaults
and it is important to know what features are available in a shell to ensure portable scripts.

```
$ ls -l /bin/sh /bin/bash
-rwxr-xr-x 2 SystemAdmin None 723K Jan 27  2017 /bin/bash*
-rwxr-xr-x 2 SystemAdmin None 723K Jan 27  2017 /bin/sh*
$ diff /bin/sh /bin/bash
$
```

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

The following tables present information about which Linux environment and shell to choose.
When writing shell scripts, it is often necessary to support scripts on multiple Linux environments
and therefore more than one of the following Linux environments may be used.

**<p style="text-align: center;">
Selecting a Windows Linux Environment
</p>**

| **Windows Linux Environment** | **Reasons to Use**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | **Reasons to Not Use** |
|-----------|-------------------|-----------------------|
| Cygwin    | <ul><li>Full-featured environment with access to many software components via Cygwin installer.</li><li>Direct access to Windows file system and software.</li><li>When working with Git, properly handles executable file permissions and Git file mode.</li></ul> | |
| Git Bash (uses MinGW) | <ul><li>Use with Git command line to automate typical development environment tasks.</li></ul> | <ul><li>Installing additional software can be a challenge.</li><li>When working with Git, may NOT properly handle executable file permissions because of underlying Windows file system limitations.</li><li>`git` program handles Windows and Linux end of line but many MinGW programs shipped with Git Bash use Linux end of line, leading to confusion (software users need to understand when files are created with a Windows or Linux program and use `dos2unix` and `unix2dos` as needed.</li></ul>| |
| MinGW     | <ul><li>Used with Fortran/C development environment.</li></ul> | Not as easy to install as Cygwin and Git Bash. |

**<p style="text-align: center;">
Selecting a Linux Shell
</p>**

| **Shell** | **Reasons to Use** | **Reasons to Not Use** |
|-----------|-------------------|-----------------------|
| `bash`    | <ul><li>Used for interactive sessions.</li><li>Provides useful features in addition to `sh` features, with documented examples.</li><li>Arrays.</li><li>`PIPESTATUS` for getting status of command in a sequence of piped commands.</li></ul> | <ul><li>Slower, takes more resources than `sh`, unless they are the same underlying command, in which case `sh` and `bash` take the same resources.</li></ul>|
| `sh`      | <ul><li>Runs fast, for cases where processes are repeated and need to complete quickly.</li></ul>| <ul><li>Does not offer some features that `bash` has.</li></ul>|

## ![Linux](../images/linux-32.png)Installing a Shell on Linux ##

In most cases, the default shell programs that are installed will be sufficient
but sometimes it is useful to install other shell programs.
Installing a shell program on Linux involves determining the package name for the program
and then running the installer for that version of Linux.
For example, the Cygwin installer lists available shells and Linux distributions
usually use an installer such as `apt-get`.

Refer to Linux software installation instructions for the Linux version.

## ![Cygwin](../images/cygwin-32.png)Installing Cygwin ##

The Cygwin software is a free and open source Linux implementation that runs on Windows.
The Cygwin shells can run Windows programs because Cygwin programs are compiled to run on Windows.
The Cygwin installation program will install `sh` and `bash` by default and additional shells and programs can be installed.
Cygwin is a very useful environment to increase productivity.  See:

*   See [OWF Learn Cygwin](http://learn.openwaterfoundation.org/owf-learn-cygwin/)
*   See the [Cygwin](https://www.cygwin.com/) website

## Installing MinGW ##

MinGW is the GNU software project to provide a free and open source version of UNIX.
The Open Water Foundation does not typically install MinGW unless it is a part of another software tool
such as Git for Windows.
For example, if Git For Windows is installed, MinGW will be available in some form and therefore a command shell will be available.
See:

*   [Minimalist GNU for Windows](http://www.mingw.org/)

## ![Git](../images/git-bash-32.png)Installing Git for Windows (Git Bash) ##

Git for Windows is often installed by software developers and others who are using the Git version control system
to track versions of electronic files and collaborate with others on electronic file edits.
Git for Windows will also install MinGW and Git Bash.  See:

*   [Git](https://git-scm.com/) - select the ***Downloads*** link and then ***Windows***

## ![Windows](../images/windows-32.png)Installing the Linux Subsystem on Windows 10 ##

The following explains how to enable/install the Linux Subsystem on Windows 10.
Microsoft is now shipping a version of Linux to help developers.

*   [How to Install and Use the Linux Bash Shell on Windows 10](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/)
    +   As indicated above, after enabling the Windows Subsystem for Linux, visit the app store as indicated in the above instructions and
        install a version of Linux.  Ubuntu is recommended.
    +   As indicated above, after installing, specify a login and password that will be used in the Linux shell.
