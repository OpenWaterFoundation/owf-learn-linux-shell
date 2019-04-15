# Linux Shell / Shell Script Basics #

The following are Bourne shell tutorials found on the internet.
Use the table of contents and index features of each site to find information about a specific
shell script language feature, or search the internet.  
Additional specific examples will be added.

* [Shell Script Tutorial](https://www.shellscript.sh/) - Bourne shell tutorial
* [Bourne Shell Programming](https://www.ooblick.com/text/sh/)
* [Linux Shell Scripting Tutorial - A Beginner's Handbook](http://www.freeos.com/guides/lsst/)
* [UNIX/Linux Tutorial from Tutorials Point](http://www.tutorialspoint.com/unix/)

Examples of useful shell syntax are described below.
The following are important topics to get started:

* [First Line - Shebang](#first-line-shebang)
* [Script Main Entry Point](#script-main-entry-point)

The following topics are listed alphabetically and highlight some of the most useful features of shell
scripts syntax:

* [Arrays](#arrays)
* [Functions](#functions)
* [Function and Command Return Status for Error Handling](#function-and-command-return-status-for-error-handling)
* ["Here Document" to Include Text in Script](#here-document-to-include-text-in-script)
* [Scope of Variables](#scope-of-variables)

--------------------

## First Line - Shebang ##

The ["shebang" ("hashbang", etc.) line](https://en.wikipedia.org/wiki/Shebang_(Unix))
is the first line of the shell script and indicates the program that should be used to run the script.
It can specify a program other than shell (for example Python interpreter).
For example, the following indicates to run the script using the `sh` shell:

```sh
#!/bin/sh
```

And the following indicates to run using the `bash` shell:

```sh
#!/bin/bash
```

The path specified must be found on the computer.
Unix/Linux variants generally have standard folders to find important programs.
As discussed elsewhere, the shell program that is indicated may actually use a different program,
such as `dash` being used for `sh` on some systems.
It is important to understand how well a shell program adheres to standards so that the script
will run on as many operating systems as possible.
The only way to confirm this is to run the script on different operating systems and read
system documentation such as "man pages".

## Script Main Entry Point ##

A shell script is entered at the first line,
which as described in the previous section, is typically a "shebang" line that indicates the program to run .
The shell script interpreter will then parse the script and execute its lines in order.
Shell script lines can be coded sequentially in the file in order to run
sequentially from top to bottom.
However, a best practice is to use [functions](#functions) as much as possible
and provide a clear entry point, for example:

```sh
#!/bin/bash
#

# Supporting functions, alphabetized

# This is function 1
function1() {
}

# This is function 2
function2() {
}

# Main entry point
# - define controlling variables here
# - include shell and Linux commands to run
# - call functions

version="1.0.0"
variable1="some value"

# Call functions
```

The above design can use the main script scope for the main code,
calling functions where needed.

Another approach is to have a `main()` function that is
immediately called in the script at the top or bottom, and that function will call other functions:

```sh
#!/bin/bash

main() {
}

# Main entry point.  Call the main() function
main
```

## Arrays ##

Arrays are a useful construct to manage lists of data values.
The `sh` shell has limited ability to represent true arrays, whereas `bash` has extensive features.

**Need to complete this section an confirm support in `sh` and `bash`.**

See:

* [TutorialsPoint tutorial on Using Shell Arrays](https://www.tutorialspoint.com/unix/unix-using-arrays.htm)

## Functions ##

It is generally good practice to organize script code into functions where possible.
This makes the code more readable, encapsulates functionality, and makes it easier to copy and
paste code between scripts, because functions can be copied.
It is possible to split code into many small scripts that call each other, but this can be more fragile.
Ensuring that a script includes all necessary functions provides stability.
The general syntax of a function is as follows, which works for `sh` and `bash` shell:

```sh
# Call a function
# - arguments are passed as if running a program on command line
functionName arg1 arg2

# Comments to document function
# - don't list arguments in the parentheses
functionName() {
	# Indicate which variables are have scope that is local to the function
	# - if a variable is not declared as "local", it be global to the script
	local arg1 arg2
	arg1=$1
	arg2=$2
	# Can use "shift" or parse arguments by looping, similar to parsing script commmand line

	# some logic here

	# Can return value the following ways
	# 1. Return an integer
	#    - this is similar to any program's main calling exit with a status,
	#      such as exit(0)
	#    - exit status of 0 means success and non-zero indicates error code
	#    - calling code can check value of $? but must assing to a variable
	#      immediately because $? gets reassigned to the exit code of the
	#      most-recently run program/command
	return 0

	# 2. Echo a string
	#    - calling code would assign a variable using returnVal=$(functionName arg1 arg2)
	# 
	echo "some return string"

	# 3. Use a script global scope variable
	#    - DO NOT declare the variable as "local" in the script
	#    - Can declare the variable and set an initial value in the main (global) scope
	#      or wait until function sets the value
}
```

## "Here Document" to Include Text in Script ##

It is often useful to include a block of text in a script, for example:

* avoid having to add backslash continuation character to each text line
* text that will be output to a file but it is undesirable to distribute a separate file with the script
because it complicates distribution
* multi-line message that will be displayed to to the user
* SQL statement used with a database query program

The "here document" feature of shells provides needed functionality.
For background, see:

* [Here document on Wikipedia](https://en.wikipedia.org/wiki/Here_document)

The following example illustrates the user of a here document to output a block of text to a file,
for example as a patch file to a system.
The example illustrates how to redirect the here document to a file.

```sh
#!/bin/sh
#
# example-here-doc-redirect

# Illustrate how to use a "here document" to populate a file that is needed for a system update.
# - this demonstrates how to redirect the here document to a file

# First might get the operating system and parse the returned string to determine specifics
operatingSystem=$(uname -a)
# Would have some logic to check for different operating systems
# - for this example just check for empty string
if [ ! -z "$operatingSystem" ]; then
    # Need to make sure that the patch file is in place
    # - use a here document to create the output file
    # - for this example just use a temporary file
    # - the __HERE_DOC__ string can be anything, as long as it bounds the text
    #   and is not found in the text
    # - using single quotes around __HERE_DOC indicates to the shell to NOT expand variables
    #   (for example don't convert $variable to its value)
    patchFile="$(mktemp).patch"
    cat << '__HERE_DOC__' > $patchFile
This is text that is part of the patch.
Because single quotes were used around the here doc string,
a variable like $PATH won't be expanded.
There are other modifiers to the here doc string that can be used
(see reference documentation).
__HERE_DOC__
fi

echo "Created patch file $patchFile:"
cat $patchFile
```

The following example illustrates how to to pipe the here document to another command.
This could be used, for example, to format an SQL statement for a command-line query tool.

```sh
#!/bin/sh
#
# example-here-doc-pipe

# Illustrate how to use a "here document" to pipe text to a command line program.

# Set variables to the values used in a query
queryVal1="something"
queryVal2="somethingElse"

# In the following example, cat just prints the text,
# but if a database query program is used it would actually query a database
# and return results, such as comma-separated-value result set.
# - note that the output string has been expanded with variable values
# - a simple awk program is used to print the expanded result and
#   in a more substantial program would process the query result
# - the receiving command is provided starting on the line immediately
#   after the trailing __HERE_DOC__ string.
    cat << __HERE_DOC__ |
SELECT * from table where val1=${queryVal1} and val2='${queryVal2}'
__HERE_DOC__
    awk '
    { print $0 }
    '
```

Output from the above script is:

```
SELECT * from table where val1=something and val2='somethingElse'
```

## Function and Command Return Status for Error Handling ##

Any code that is comprised of calls to external programs (commands), built-in shell commands,
and script functions should implement some type of error handling.
An integer return status is used to indicate success or failure:

* Programming languages such as C, Java, Python, etc. typically use a `main()` program
function that calls `exit(0)` (or other integer value) to exit the program and pass the integer
value to the shell as the program exit status.
* Shell scripts can call `exit 0` (or other integer value) to indicate the exit status of the script.
* Shell script functions can call  `return 0` (or other integer value) to indicate the return value of the script.

It is customary that a value of zero (`0`) is used to indicate success,
and a non-zero value is used to indicate failure,
typically with documentation available to understand the return status.

The following sections describe ways to check exit status.

### Built-in `$?` Exit Status Variable ###

Linux shells provide the `$?` variable to check the return status of the
built-in command, program, or function that was just called.
The value of this variable must be assigned to another variable to protect the value because
it will be reset as soon as another command or function is called.
For example:

```sh
#!/bin/sh

# example-built-in-exit-status - example of exit status.
# The following will always fail because the file does not exist.

fileToRemove="/tmp/some-file-that-does-not-exist"
# Redirect error to /dev/null so script message is used instead.
rm "$fileToRemove" 2> /dev/null
if [ $? -eq 0 ]; then
    echo "Success removing file:  $fileToRemove"
else
    echo "File does not exist:  $fileToRemove"
fi
```

The output from the script is:

```
File does not exist:  /tmp/some-file-that-does-not-exist
```

### Checking Return Status Directly ###

The previous section describes how to check the return status by using the `$?` variable.
However, the return value can be also be checked directly.
Whereas programming languages typically treat a zero value as "false" and a non-zero
value as "true", shell script `if` statements consider a return value of 0 to be success
and all other values to be failure.  See the following example:

```sh
#!/bin/sh

# example-if-return-status-check - example of checking return status

# Function to return the value passed as first argument
testFunction() {
    local returnValue
    returnValue=$1
    return $returnValue
}

# Main entry point

# Call the test function
# - could also call a program or built-in command
# - pass the value to return from the function
if testFunction 0; then
    echo "Function was successful (return value 0)"
fi
if testFunction 1; then
    # This will not called because 1 is considered false
    echo "Function was not successful (return value 1)"
fi
# Use ! to negate the logical check
# - therefore a failure causes the if to evaluate as true
if ! testFunction 1; then
    echo "Function was not successful (return value 1)"
fi
```

Output from the script is:

```
Function was successful (return value 0)
Function was not successful (return value 1)
```

### Bash `PIPESTATUS` for Piped Exit Status ###

It is common to use pipes to chain together several processing steps.
However, the `sh` shell does not allow checking the exit status for
each step of the chain.  For example, the following will always
result in `$?=0` because the status is set for the last command in the chain and
`echo` will always be successful.

```sh
#!/bin/sh
#
# example-sh-pipe-status

# Example to show how normal shell cannot get status of command that is piped.

# Start a temporary file as an output file
logFile="$(mktemp).log"
echo "Using log file:  $logFile"

# Write one message to start the log file
echo "New log file" > $logFile

# Run a command that will always fail.
# - redirect standard error and output to logfile, while also showing to the terminal.
# - the exit status will always be 0 because it is for the "tee" command

fileToRemove="/tmp/some-file-that-does-not-exist"
rm $fileToRemove 2>&1 | tee --append $logFile
echo "exit status:  $?" 2>&1 | tee --append $logFile
```

The output from the above script is as follows.
Unfortunately, `sh` does not provide a simple way to get the exit status of the
commands in the pipe chain.

```txt
Using log file:  /tmp/tmp.iV310qo8EF.log
rm: cannot remove '/tmp/some-file-that-does-not-exist': No such file or directory
exit status:  0
```

However, the `bash` shell provides the `PIPESTATUS` feature to get the status for each part of the pipe chain,
as shown in the following example:

```sh
#!/bin/bash
#
# example-bash-pipe-status

# Example to show how bash can get status of command that is piped.

# Start a temporary file as an output file
logFile="$(mktemp).log"
echo "Using log file:  $logFile"

# Write one message to start the log file
echo "New log file" > $logFile

# Run a command that will always fail.
# - redirect standard error and output to logfile, while also showing to the terminal.
# - the exit status will be 1 for the remove command.

fileToRemove="/tmp/some-file-that-does-not-exist"
rm $fileToRemove 2>&1 | tee --append $logFile
echo "exit status:  ${PIPESTATUS[0]}" 2>&1 | tee --append $logFile
```

The output from the above script is as follows.
Consequently, appropriate error handling can be implemented.

```txt
Using log file:  /tmp/tmp.lFs3ueX9J6.log
rm: cannot remove '/tmp/some-file-that-does-not-exist': No such file or directory
exit status:  1
```

## Scope of Variables ##

Variables have a "scope" meaning that their name is recognized in some context and not in other context.
The default scope for variables in shell scripts is global, meaning that variables can be declared
in the main program area or in functions and will be visible throughout the script.
This can be confusing because the main scope also includes environment variables from the calling
environment, and variable names may be reused in functions, in which case the last use will dictate
what the current value for a variable.

One best practice in [functions](#functions) is to use `local` followed by a list of variables that
should have scope local to the function.
The exception is if the function needs to return multiple values and global variables are used
to accomplish this.

A complication is when the shell executes a sub-shell, for example when `$()` or pipe (`|`) is used.
A `while` command is also executed as a sub-shell.
In this case the sub-shell's variables will be local to the sub-shell and won't be available
when the sub-shell returns to the calling shell.
To gain access to the sub-shell variable, it may be necessary to use echoed string or file to pass data.
The following examples illustrate some of these issues.

In the following (which works in `sh` and `bash`), the value of variable `joined` will not be set after execution
because the a sub-shell is used for the `while` loop:

```sh
#!/bin/sh
#
# example-broken-while-return-string.sh
#
# Example showing how while loop variable can be shared with calling code.
# - generating input with "printf" requires \n to terminate each line
# - generating input with "echo" requires -e to convert \n to newline, but does not need \n at end

#joined2=$(printf "line1\nline2\n" |
joined2=$(echo -e "line1\nline2" |
     while read line; do
       if [ -z "$joined" ]; then
         joined="$line"
       else
         joined="$joined,$line"
       fi
     done
     echo $joined
)
# Will echo blank because scope of "joined" modifications in while
# does not extend to outside of the while loop
echo $joined2
```

One way to solve this problem is to group commands using
[curly braces](https://www.gnu.org/software/bash/manual/html_node/Command-Grouping.html#Command-Grouping).
The following example (works in `sh` and `bash`) illustrates how using curly braces
to group the `while` loop and following `echo` command allows sub-shell to had off a variable
value to the calling shell.

```sh
#!/bin/sh
#
# example-braces-while-return-string.sh
#
# Example showing how while loop variable can be shared with calling code.
# - generating input with "printf" requires \n to terminate each line
# - generating input with "echo" requires -e to convert \n to newline, but does not need \n at end
# - the curly braces group commands in the same shell (or sub-shell),
#   in this case ensuring that "joined" variable has a final value

# Notes
#joined2=$(printf "line1\nline2\n" |
joined2=$(echo -e "line1\nline2" |
{
     while read line; do
       if [ -z "$joined" ]; then
         joined="$line"
       else
         joined="$joined,$line"
       fi
     done
     echo $joined
}
)
# Will echo "line1,line2"
echo $joined2
```

Other options for returning sub-shell output to calling code includes:

* Use a file.  Direct output to a file in one sub-process and
then read the file in the calling code.
The Linux [`mktemp`](https://linux.die.net/man/1/mktemp)
command can be used to generate a unique temporary filename,
and the temporary file should be removed after use.
* Use process substitution syntax (similar to files).  See the following:
	+ ["Shell variables set inside while loop not visible outside of it"](https://stackoverflow.com/questions/4667509/shell-variables-set-inside-while-loop-not-visible-outside-of-it) 
	+ [Advanced Bash Scripting Guide / Process Substitution](https://www.tldp.org/LDP/abs/html/process-sub.html)
