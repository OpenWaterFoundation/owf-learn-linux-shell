# Linux Shell / Shell Script Best Practices #

This page lists best practices, based on industry standards and first-hand experience.

* [Use simple shell scripts to memorialize tasks](#use-simple-shell-scripts-to-memorialize-tasks)
* [Use version control](#use-version-control)
* [Indicate the shell to run in the first line of shell scripts](#indicate-the-shell-to-run-in-the-first-line-of-shell-scripts)
* [Check whether the script is running in the correct folder](#check-whether-the-script-is-running-in-the-correct-folder)
* [Echo useful troubleshooting information](#echo-useful-troubleshooting-information)
* [Consider options for logging](#consider-options-for-logging)
* [Create documentation](#create-documentation)
* [Include useful web resource links in shell script comments](#include-useful-web-resource-links-in-shell-script-comments)
* [Learn how to use shell features](#learn-how-to-use-shell-features)
* [Use functions to create reusable blocks of code](#use-functions-to-create-reusable-blocks-of-code)

-----------------

## Use simple shell scripts to memorialize tasks ##

It is often necessary to perform a number of steps to process data and/or automate program calls to complete a task.
These steps may be a one-time task, but often will need to be repeated in the future.
Rather than relying on written or electronic notes, email, etc., creating a short shell script to memorialize
the task can ensure that knowledge is retained.
The script can also be enhanced over time to provide more functionality.

A useful best practice is to create a simple shell script in the files being processed,
with comments in the shell script to explain its purpose and use.
Additionally, a `README.md` file can be created to provide formatted explanation of the shell script.

The script and `README.md` file can be managed in a version control system to track changes over time and serve as a backup.

## Use version control ##

Any script worth creating and using is probably worth tracking in a version control system.
There is nothing more frustrating that asking "where did I put that script?"
Therefore, use Git and a cloud-hosted version control system like GitHub or Bitbucket to maintain the script.
This also provides information about the author so that questions and bugs can be dealt with,
for example via the repository issues page.

## Indicate the shell to run in the first line of shell scripts ##

A shell script (actually any script) can be written in various languages and language standards.
Shell scripts can be written for `sh`, `bash`, or other command shells.
Do not assume that the default command shell that will be used will be correct.
Therefore, always specify the shell to run, for example:

```sh
#!/bin/sh
#
# The above indicates that the Bourne shell `sh` command shell will be used to run the script.
```

## Check whether the script is running in the correct folder ##

The folder from which a script is run often has a large impact on the functionality of the script.
Options include:

1. Allow the script to run in any folder since the task does not depend on the location.
2. Allow the script to run in any folder and locate input and output based on the
environment, such as detecting the user's home folder or a standard folder structure within the environment.
3. Require the script to be run from a certain folder because input and output folders are relative
to the run folder.

Great pains may need to be taken in a script's code to ensure that a script runs correctly in any folder,
in order to ensure that input files are found and output is created in the proper location.
However, for simple tasks, it may be easier to require running from a specific folder.

A best practice is to put checks in place, if necessary, to ensure that the script is running in the
correct folder. For example, the following does a simple check to make sure that
the script is running in a `build-util` folder.
The following check is not fool-proof because running in one `build-util` folder and specifying
a path to another `build-util` folder would pass the test, but the basic check helps prevent many issues.

```sh
# Make sure that this is being run from the build-util folder
pwd=`pwd`
dirname=`basename ${pwd}`
if [ ! ${dirname} = "build-util" ]
        then
        echo "Must run from build-util folder"
        exit 1
fi
```

## Echo useful troubleshooting information ##

Shell scripts can be difficult to troubleshoot, especially if the script coding is not clear
and the script user did not write the script.
Therefore, it is often helpful to print important configuration information
at the start of the script.
For example use `echo` statements to print important environment variable names and values,
names of input files, etc.

If the script is more advanced, such output could be printed only when a command line parameter is specified, such as `--verbose`.

## Consider options for logging ##

Logging for shell scripts can be implemented in various ways.
The standard for Linux is often to output to the stdout stream (for example `echo ...`).
The script output can then be redirected into a file or piped to another program for further processing.
However, diagnostic or progress messages that are separate from analytical output generally
need to be separated from the general output.

Depending on the complexity of the script, it may be very useful to save logging messages to a file.
This can be done by echoing output to a file in the current folder or a special location.
The author of the script probably has a good idea of how logging should be done because
they use it themselves.
A best practice is to implement options for logging in a way that will benefit users of the script
and then provide documentation to explain options.
This will help users, especially those who may not fully understand how to do logging with
redirection.

## Create documentation ##

A shell script is only truly useful if someone other than the original author can use it.
Therefore, all shell scripts should have documentation in one or more forms,
depending on the significance of the script, including:

* Code comments, enough to understand the purpose, and good in-line comments.
* A `printUsage()` or similar function that prints basic usage,
run via `-h` or `--help`, or by default to show user available command options.
* `README.md` file in the repository.
* User documentation, such as this documentation.

## Include useful web resource links in shell script comments ##

Technologies can be complicated and shell programming is no different.
It is often necessary to search the web for a solution or comparative example to perform a task.
Once the solution is coded, it can be difficult to understand the approach.
Therefore, include a comment in the code with the link to the web resource that explained the solution.
Don't make the next programmer relearn the same material from terse code.
Allow the code to be a teaching tool that can be maintained by the next developer.
Also, including links is a way to give credit to the person that helped solve a technical issue.

## Learn how to use shell features ##

There is always a brute force "quick and dirty" way to do things.
However, there is a balance between the technical debt of quick and dirty solutions,
and more elegant solutions that take more time to learn, but are more robust and maintainable in the long run.
In particular, quick and dirty solutions that negatively impact the user experience
and resources spent by other developers should be avoided.
Shell programmers should take the time to learn shell programming concepts and features such
as command line parsing, functions, log files, etc. so that they can improve shell script quality
and functionality.
 
## Use functions to create reusable blocks of code ##

This should go without saying, but modular code tends to be easier to maintain,
especially when a script becomes long.
Every script author should consider using functions to organize script functionality.
Functions also simplify sharing code between scripts since functions can be copied and pasted
between scripts.

The alternative to writing a function is to write a separate script that can be called
with an appropriate command line.
This approach is OK as long as the called script is located in a location that can be found by the calling script.
