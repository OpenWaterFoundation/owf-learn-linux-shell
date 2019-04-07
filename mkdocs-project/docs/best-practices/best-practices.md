# Linux Shell / Shell Script Best Practices #

This page lists best practices, based on industry standards and first-hand experience.

* [Use simple shell scripts to memorialize tasks](#use-simple-shell-scripts-to-memorialize-tasks)
* [Use version control](#use-version-control)
* [Indicate the shell to run in the first line of shell scripts](#indicate-the-shell-to-run-in-the-first-line-of-shell-scripts)
* [Write code that is understandable](#write-code-that-is-understandable)
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

If a true version control system is not used, the script can also be saved in a knowledge base or other
information platform.

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

## Write code that is understandable ##

It is common that code is rewritten simply because the original author's work is not understandable.
This results in extra cost, potentially bugs, and potentially loss in functionality if the original
code was not understood.
The urge to rewrite code may be because of a lack of documentation, confusing logic, bad programming style,
use of obscure or advanced language syntax without explanation, or other reasons.

Documenting code at the time it is being written is the best time to document code.
If updating code, read the code comments again and if they do not make sense, clarify the comments.
A simple rule is to ask "will the next person working on this code understand it?"

The following are some basic guidelines to making code understandable:

* Add full grammar comments to code.  Don't force people to assume what you mean.
Use proper grammar.  Sloppy comments and incomplete thoughts can indicate sloppy code.
* Explain complex syntax.  Don't assume that the next programmer will have a PhD in shell scripting.
Yes, every answer can be found on the web, but the web also contains many misleading and out of date examples.
* Use variable and function names that are verbose enough to provide context.
Code should read like a clear process.  Using appropriate names will also reduce
the need for code comments.
* Be consistent in names and style.  If editing someone else's code, try to be consistent
with the original style if possible.
* Use double or single quotes around strings, as appropriate, to indicate strings.
* Use appropriate indentation consistently.  Tabs are OK and if used should not be mixed with spaces.
Spaces if used should be in groups of 2 or 4.  Do not assume that the next person to edit
the code will use the same convention in their editor, and make it obvious what is being used
by being consistent.

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

A more robust solution is to allow the script to be run from any folder, including finding in the `PATH`
or specifying the path to the script manually.
In this case the following syntax can be used to determine the location of the script,
and other folders and files can be located relative to that location,
assuming there is a standard.

```sh
# Get the location where this script is located since it may have been run from any folder
scriptFolder=`cd $(dirname "$0") && pwd`
# Also determine the script name, for example for usage and version.
# - this is useful to prevent issues if the script name has been changed by renaming the file
scriptName=$(basename $scriptFolder)
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
The standard for Linux is often to output to the `stdout` stream (for example `echo ...`).
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

The following is a basic example of implementing logging:

```sh
#!/bin/sh

# example-logging

# This example shows basic logging approach

# Define the logfile
# - in this case it is a temporary file but a name and location
#   specific to the script purpose would normally be used
logFile="$(mktemp).log"
scriptName="myscript"

# Write one record to the logfile indicating the time and program
# - use tee command to show output to terminal and logfile if appropriate
# - write standard output and error to the file
now=$(date --iso-8601=seconds)
echo "[${now}] Logfile for $scriptName:  $logFile" 2>&1 | tee $logFile

# Write subsequent message by appending
echo "Another log message" 2>&1 | tee --append $logFile
```

The script output is:

```txt
[2019-04-07T01:50:12-06:00] Logfile for myscript:  /tmp/tmp.S25lMrx7nN.log
Another log message
```

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

There is always a brute force "quick and dirty" way to do things,
such as by copying and pasting code from a web search.
However, there is a balance between the technical debt of quick and dirty solutions,
and more elegant solutions that take more time to learn, but are more robust and maintainable in the long run.
In particular, quick and dirty solutions that negatively impact the user experience
and resources spent by other developers should be avoided.
Shell programmers should take the time to learn shell programming concepts and features such
as command line parsing, functions, log files, etc. so that they can improve shell script quality
and functionality.
This documentation is an attempt to provide easily understood examples that go beyond
the often terse and trivial examples on the web.
 
## Use functions to create reusable blocks of code ##

This should go without saying, but modular code tends to be easier to maintain,
especially when a script becomes long.
Every script author should consider using functions to organize script functionality.
Functions also simplify sharing code between scripts since functions can be copied and pasted
between scripts.

The alternative to writing a function is to write a separate script that can be called
with an appropriate command line.
This approach is OK as long as the called script is located in a location that can be found by the calling script.
