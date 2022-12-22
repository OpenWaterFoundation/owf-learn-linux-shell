# Linux Shell / Troubleshooting #

Troubleshooting shell scripts typically involves reviewing error messages printed by the shell program.
Often a line number will be printed indicating the location of a syntax error.
Otherwise, the fix requires interpreting how to respond to a printed error message.
Troubleshooting tricks include the following, which are explained in sections below:

*   [Redirect the output from the program to a file](#redirect-the-output-from-the-program-to-a-file)
*   [Use the `-x` command parameter to run the shell script](#use-the-x-command-parameter-to-run-the-shell-script)
*   [Add `echo` commands to print information](#add-echo-commands-to-print-information)

Common errors are listed below and are explained in sections below:

*   [Error Message: `-bash: test.sh: command not found`](#error-message-bash-testsh-command-not-found)


----------------------

## Redirect the output from the program to a file ##

The easiest way to output information from a shell script is to use the `echo` command.
For example, the following prints one message to standard output and one message to standard error:

```sh
#!/bin/sh

# Print message to standard output
echo "standard output message"

# Print message to standard error
>&2 echo "standard error message"
```
Both messages will be visible in the command shell window.
The output can then be scrolled through to review results of the script.
However, this can be cumbersome, especially if the output is long and it is necessary to search for a string.
One way to resolve this is to redirect the output to a file so that the file can then be edited in a text editor.

Programs in most operating systems can generate output to different *streams* and these streams
can be redirected to files (see [Redirection on Wikipedia](https://en.wikipedia.org/wiki/Redirection_(computing))).
The standard output and standard error streams are used for printing messages.
The following syntax can be used to redirect a program's standard output stream to a file.

```sh
$ ./example-redirection.sh > example-redirection.stdout
```
The following example redirects only the standard error messages to a file,
where the number `2` indicates the standard error stream:

```sh
$ ./example-redirection.sh 2> example-redirection.stderr
```

It is often useful to redirect the standard output and standard error streams to the same output file,
as follows:

```sh
$ ./example-redirection.sh 2&> example-redirection.allout
```

Because the standard output and standard error messages are handled separately within the
program, they may not actually be printed in the expected sequence,
and it may not be obvious whether a message is an error message.
For this reason, it is often helpful to include `ERROR` or other indicator in the message
to differentiate from an informational message.

## Use the `-x` command parameter to run the shell script ##

In most cases shell scripts run without echoing each line of the script.
However, when troubleshooting it can be useful to see more output.
The `-x` command line option to shell scripts can be used to print more output.
For example, see the following script and the output from running the script.

```sh
#!/bin/sh -x

# Print message to standard output
echo "See more output when running"

date

ls

```

```sh
$ ./example-x.sh
+ echo 'See more output when running'
See more output when running
+ date
Sun, Jan 07, 2018  5:35:48 PM
+ ls
example-debug.sh  example-redirection.sh  example-x.sh  troubleshooting.md

```

## Add `echo` commands to print information ##

Simple `echo` commands in a script can be used to print troubleshooting information.
These can be added as needed or can be formalized into debugging messages as in the example below.
The debug variable can default to `false` and can be set with a command line parameter.
In any case, troubleshooting messages inserted for ad hoc debugging should not
be printed for users in most cases because extraneous output can be overwhelming and confusing.

```sh
#!/bin/sh

# Example of using debug messaging

debug="true"

# Simple function
abc () {
        if [ "${debug}"=="true" ]; then
                echo "DEBUG:  Starting function abc"
        fi
}

# Call function abc
abc
```

## Error Message:  `-bash: test.sh: command not found` ##

This type of message will be printed if the command that is being run is not found in the `PATH`
environment variable.  Resolve as follows:

*   Program is in current folder but `.` is not in the `PATH`.
    Often the current folder `.` will not be included in the path for security reasons (see article below).
    Therefore, if the script is executable (see below for changing executable permissions), it can be run with `./test.sh`.
    +   [Is it safe to add . to my PATH?  How come?](https://unix.stackexchange.com/questions/65700/is-it-safe-to-add-to-my-path-how-come)
    +   If `.` is in the `PATH`, someone could spoof a command like `ls` in the current folder with undesirable results.
*   Program is not in a folder that is in the `PATH`.
    +   Fix by deploying the script to a folder that is in the `PATH`.
    +   Or, add a new folder to the `PATH`.
*   Program is not executable.
    +   On Linux a program needs to have execute permissions to run.
        Therefore change permissions with, for example:  `chmod a+x test.sh` (change so all can execute).
        See the [chmod documentation](https://en.wikipedia.org/wiki/Chmod) for more information.
