# Linux Shell / Useful Script Examples #

This page provides examples of useful shell scripts or nuggets of code that can be used in scripts.
Most of these examples are for `sh`.
However, the examples shown should also work for `bash` and other shells in most cases
(if not, equivalent syntax can be determined).

*   [Check user running script](#check-user-running-script)
*   [Command to do nothing](#command-to-do-nothing)
*   [Control echo of script commands as script runs](#control-echo-of-script-commands-as-script-runs)
*   [Determine the folder where a script exists](#determine-the-folder-where-a-script-exists)
*   [Determine the operating system](#determine-the-operating-system)
*   [Echo colored text to console](#echo-colored-text-to-console)
*   [Ensure that script runs on Linux and Windows](#ensure-that-script-runs-on-linux-and-windows)
*   [Log Messages and Program Output](#log-messages-and-program-output)
*   [Parsing command line options](#parsing-command-line-options)
    +   [Parsing command line options with built-in getopts](#parsing-command-line-options-with-built-in-getopts)
    +   [Parsing command line options with `getopt` command](#parsing-command-line-options-with-getopt-command)
*   [Set Terminal Title](#set-terminal-title)

-----------------

## Check user running script ##

It is sometimes necessary to check which user is running a script.
For example, check whether the user is "superuser" or not.
The following function function uses the `whoami` Linux command to determine whether the user
is running as a superuser and if not, prints a warning and exits.
In most cases the script would be run with `sudo scriptname`.

```sh
#!/bin/sh

# Get the location where this script is located since it may have been run from any folder
scriptFolder=$(cd $(dirname "$0") && pwd)
# Script name is used in some output, use the actual script in case file was renamed
scriptNameFromCommandLine=$(basename $0)

# Call the function to make sure running as superuser
checkSudo $scriptNameFromCommandLine

# Make sure that the script is being run as as root (or sudo)
# - pass the script name (file only) as the first function argument
# - Running 'sudo whomami' shows "root"
checkSudo() {
    local user scriptName
    scriptName = $1
    user=`whoami`
    if [ "$user" != "root" ]; then
        echo ""
        echo "You are not running as root."
        echo "Run with:          sudo $scriptName"
        echo "or, if necessary:  sudo ./$scriptName"
        echo ""
        exit 1
    else
        echo ""
        echo "You are running as root or sudo.  There should be no permissions issues."
        echo ""
    fi
}
```

## Command to do nothing ##

It is sometimes useful to use a command that does nothing (like the `pass` command in Python).
For example, such a command can be useful to write clear `if` statements.
The following illustrates using the colon command to achieve this result:

```
answer="no"
if [ "$answer" = "no" ]; then
  # don't do anything
  :
fi
```

The above logic is needed because a comment only within an `if` block will result in a syntax error.


## Control echo of script commands as script runs ##

In most cases, the commands executed in a script should not be echoed to the console
because this produces excessive and confusing output that is often difficult to understand.
However, there may be cases where it is helpful to echo (trace) the commands as they are run,
such as for troubleshooting or to show a long command to the user without having to use a duplicative `echo` command.

### Turn on echo/trace for entire script

To turn on echo/trace for an entire script, the `-x` option can be added in the
[shebang line](https://en.wikipedia.org/wiki/Shebang_(Unix)), as in the following:

```
#!/bin/sh -x
```

This will cause every command in the script to print to the console before it is executed.
This is normally used only in troubleshooting or during development.

### Run a script with echo/trace turned on

A similar effect can be achieved by running the script as follows.
The `-x` option is only in effect in the top-level script and any called scripts
will have their own setting.

```
$ sh -x some-script
```

### Control echo/trace line by line within a script

It may also be useful to turn on echo/trace for specific lines in a script,
for example to help the user understand what is being run.
The following illustrates how to turn on the echo for one command and then turn it off:

```
# Some script ...
# The following starts to echo commands as the are run
set -x
somecommands..
{ set +x; } 2> /dev/null
```

The `set -x` turns on echo/trace.  The `{ set +x; } 2> /dev/null` turns off echo/trace
and absorbs the output into the special `/dev/null` output device.

## Determine the folder where a script exists

Scripts often need to know the location of input and output files.
This can be complicated by how the script is run, for example by specifying
the name in the current folder, using an absolute or relative path to a different folder,
or being found in the `PATH` environment variable.

One option is to require that a script is executed from a specific folder,
such as the location of the script.
However, this reduces flexibility.
To allow running the script from any folder,
it is necessary to determine the absolute location of the script so that input and output
can be specified relative to that location.
The following determines the absolute path to the script being run:

```
# Get the location where this script is located since it may have been run from any folder
scriptFolder=$(cd $(dirname "$0") && pwd)
# Also determine the script name, for example for usage and version.
# - this is useful to prevent issues if the script name has been changed by renaming the file
scriptName=$(basename $scriptFolder)
```
The `$0` command argument contains the script name, which can be a file or path.
The above logic therefore changes to the directory in which the script resides.
The `&&` indicates to run the second command after the first command, in this case the `pwd` command.
The output is assigned to the `scriptFolder` variable, which can be used in other logic.
This approach may not work if symbolic links are involved and additional information is available on the web.

Examples:

*   [Open Water Foundation git-check-util](https://github.com/OpenWaterFoundation/owf-util-git/blob/master/build-util/git-check-util.sh)


## Determine the operating system

Sometimes it is necessary to have different logic in a script to support differing Linux-like operating systems.
For example, files may exist in different locations in different operating systems.
The following `sh` function sets a variable to indicate the operating system and the variable
can be used in `if` statements to control logic:

```
# Determine the operating system that is running the script
# - mainly care whether Cygwin
checkOperatingSystem()
{
  operatingSystem="unknown"
  os=`uname | tr [a-z] [A-Z]`
  case "${os}" in
    CYGWIN*)
      operatingSystem="cygwin"
      ;;
    LINUX*)
      operatingSystem="linux"
      ;;
    MINGW*)
      operatingSystem="mingw"
      ;;
  esac
  echo "operatingSystem=$operatingSystem (used to check for Cygwin and filemode compatibility)"
}
```

Examples:

*   [Open Water Foundation git-check](https://github.com/OpenWaterFoundation/owf-app-geoprocessor-python/blob/master/build-util/git-util/git-check.sh)

## Echo colored text to console

It can be useful to print colored text to the console, for example to highlight warning or error messages.
The `echo` command can be used to print special characters.  See:

*   [How to change RGB colors in Git Bash for windows](https://stackoverflow.com/questions/21243172/how-to-change-rgb-colors-in-git-bash-for-windows)
*   [Bash: Using Colors](http://webhome.csc.uvic.ca/~sae/seng265/fall04/tips/s265s047-tips/bash-using-colors.html)
*   [Unix escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code#Unix-like_systems)
*   [Yellow "33" in Linux can show as brown](https://unix.stackexchange.com/questions/192660/yellow-appears-as-brown-in-konsole)

To print special characters requires using `echo -e`
The built-in `echo` command found in the shell may not support the `-e` option,
and it may be necessary to run a different `echo` program such as the system program.
Therefore, first determine which `echo` command to use:

```
# Determine which echo to use, needs to support -e to output colored text
# - normally built-in shell echo is OK, but on Debian Linux dash is used, and it does not support -e
echo2='echo -e'
testEcho=`echo -e test`
if [ "${testEcho}" = '-e test' ]; then
  # The -e option did not work as intended.
  # -using the normal /bin/echo should work
  # -printf is also an option
  echo2='/bin/echo -e'
  # The following does not seem to work
  #echo2='printf'
fi
```

Characters that control color are output as escape characters in `echo` statements.
It is useful to assign colors as variables as follows:

```
# Strings to change colors on output, to make it easier to indicate when actions are needed
# - Set the background to black to eensure that white background window will clearly show colors contrasting on black.
# - Tried to use RGB but could not get it to work - for now live with "yellow" as it is
actionColor='\e[0;40;33m' # user needs to do something, 40=background black, 33=yellow
actionWarnColor='\e[0;40;31m' # serious issue, 40=background black, 31=red
okColor='\e[0;40;32m' # status is good, 40=background black, 32=green
colorEnd='\e[0m' # To switch back to default color
```

Finally, use the special characters in `echo` statements.  Note that `${echo2}` is used to run the correct `echo` command.

```
${echo2} "Number of up-to-date repositories: ${okColor}${upToDateRepoCount}${colorEnd}"
```

Examples:

*   [Open Water Foundation git-check](https://github.com/OpenWaterFoundation/owf-app-geoprocessor-python/blob/master/build-util/git-util/git-check.sh)


## Ensure that script runs on Linux and Windows ##

Linux shell scripts can be written to run on Linux, Cygwin, Git Bash, etc.
However, the script may have the wrong end of line character for an environment.
For example, Git Bash may be used to clone a repository, which results in `CRLF` characters
being used on Windows.  Trying to run the script using Cygwin, which is a POSIX Linux environment
that expects only `LF` at the end of lines, may display an error similar to the following:

```
./copy-to-owf-amazon-s3.sh: line 5: $'\r': command not found
./copy-to-owf-amazon-s3.sh: line 10: $'\r': command not found
./copy-to-owf-amazon-s3.sh: line 41: syntax error: unexpected end of file
```

A work-around is to add the second line to the script as follows,
which causes carriage return at the end of lines to be ignored.
The script is then portable between Linux and Windows shell environments.


```
#!/bin/sh
(set -o igncr) 2>/dev/null && set -o igncr; # this comment is required
# The above line ensures that the script can be run on Cygwin/Linux even with Windows CRNL
#
# ... rest of the script...
```

Examples:

*   [Open Water Foundation git-check.sh](https://github.com/OpenWaterFoundation/owf-util-git/blob/master/build-util/git-util/git-check.sh)

## Log Messages and Program Output ##

It is often useful to print messages to the terminal and/or to a log file,
similar to logging frameworks in programming languages,
Logging is helpful for debugging and to to provide the user with feedback as a script runs.

The functions below can be inserted into a script and can be called similar to the following:

```
scriptFolder=$(cd $(dirname "$0") && pwd)
scriptName=$(basename $scriptFolder)
# Start a log file that will be used by the logging functions
logFileStart ${scriptName} "${scriptFolder)/${scriptName}.log"

# The following logs the message string passed to the function.
# - use a space for empty lines because otherwise the logging function
#   will hang waiting for input
logInfo " "
logInfo "Starting to do some work."

# The following will log each `stdout` and `stderr` line piped to the function.
someOtherProgram 2>&1 | logInfo
```

Output is similar to:

```
[DEBUG] some debug message
[INFO] some informational message
[WARNING] some warning message
[ERROR] some error message
```

Functions to insert (see also [logging-functions.txt](resources/logging-functions.txt)):

```sh
# Echo to stderr
echoStderr() {
  # - if necessary, quote the string to be printed
  # - redirect stdout from echo to stderr
  echo "$@" 1>&2
  # Or, use an alternate echo as discussed in "Echo colored text to console" example
  # ${echo2} "$@" 1>&2
}

# Print a DEBUG message
# - prints to stderr and optionally appends to log file if ${logFile} is defined globally
#   - see logFileStart() to start a log file
# - call with parameters or pipe stdout and stderr to this function: 2>&1 | logDebug
# - print empty lines with a space " " to avoid hanging the program waiting on stdin input
logDebug() {
  if [ -n "${1}" ]; then
    if [ -n "${logFile}" ]; then
      # Are using a log file
      echoStderr "[DEBUG] $@" 2>&1 | tee --append $logFile
    else
      # Are NOT using a log file
      echoStderr "[DEBUG] $@"
    fi
  else
    while read inputLine; do
      if [ -n "${logFile}" ]; then
        # Are using a log file
        echoStderr "[DEBUG] ${inputLine}" 2>&1 | tee --append $logFile
      else
        # Are NOT using a log file
        echoStderr "[DEBUG] ${inputLine}"
      fi
    done
  fi
}

# Print an ERROR message
# - prints to stderr and optionally appends to log file if ${logFile} is defined globally
#   - see logFileStart() to start a log file
# - call with parameters or pipe stdout and stderr to this function: 2>&1 | logError
# - print empty lines with a space " " to avoid hanging the program waiting on stdin input
logError() {
  if [ -n "${1}" ]; then
    if [ -n "${logFile}" ]; then
      # Are using a log file
      echoStderr "[ERROR] $@" 2>&1 | tee --append $logFile
    else
      # Are NOT using a log file
      echoStderr "[ERROR] $@"
    fi
  else
    while read inputLine; do
      if [ -n "${logFile}" ]; then
        # Are using a log file
        echoStderr "[ERROR] ${inputLine}" 2>&1 | tee --append $logFile
      else
        # Are NOT using a log file
        echoStderr "[ERROR] ${inputLine}"
      fi
    done
  fi
}

# Start a new logfile
# - name of program that is being run is the first argument
# - path to the logfile is the second argument
# - echo a line to the log file to (re)start
# - subsequent writes to the file using log*() functions will append
# - the global variable ${logFile} will be set for use by log*() functions
logFileStart() {
  local newLogFile now programBeingLogged
  programBeingLogged=$1
  # Set the global logfile, in case it was not saved
  if [ -n "${2}" ]; then
    logFile=${2}
  else
    # Set the logFile to stderr if not specified, so it is handled somehow
    logFile=/dev/stderr
  fi
  now=$(date '+%Y-%m-%d %H:%M:%S')
  # Can't use logInfo because it only appends and want to restart the file
  echo "Log file for ${programBeingLogged} started at ${now}" > ${logFile}
}

# Print an INFO message
# - prints to stderr and optionally appends to log file if ${logFile} is defined globally
#   - see logFileStart() to start a log file
# - call with parameters or pipe stdout and stderr to this function: 2>&1 | logInfo
# - print empty lines with a space " " to avoid hanging the program waiting on stdin input
logInfo() {
  if [ -n "${1}" ]; then
    if [ -n "${logFile}" ]; then
      # Are using a log file
      echoStderr "[INFO] $@" 2>&1 | tee --append $logFile
    else
      # Are NOT using a log file
      echoStderr "[INFO] $@"
    fi
  else
    while read inputLine; do
      if [ -n "${logFile}" ]; then
        # Are using a log file
        echoStderr "[INFO] ${inputLine}" 2>&1 | tee --append $logFile
      else
        # Are NOT using a log file
        echoStderr "[INFO] ${inputLine}"
      fi
    done
  fi
}

# Print an WARNING message
# - prints to stderr and optionally appends to log file if ${logFile} is defined globally
#   - see logFileStart() to start a log file
# - call with parameters or pipe stdout and stderr to this function: 2>&1 | logWarning
# - print empty lines with a space " " to avoid hanging the program waiting on stdin input
logWarning() {
  if [ -n "${1}" ]; then
    if [ -n "${logFile}" ]; then
      # Are using a log file
      echoStderr "[WARNING] $@" 2>&1 | tee --append $logFile
    else
      # Are NOT using a log file
      echoStderr "[WARNING] $@"
    fi
  else
    while read inputLine; do
      if [ -n "${logFile}" ]; then
        # Are using a log file
        echoStderr "[WARNING] ${inputLine}" 2>&1 | tee --append $logFile
      else
        # Are NOT using a log file
        echoStderr "[WARNING] ${inputLine}"
      fi
    done
  fi
}
```

## Parsing command line options ##

A common task when writing a script is to parse command line options.
Options may take various forms including:

* `-a` - single character option
* `-a xyz` - single character option with an argument
* `-abc` - long option with single dash
* `-abc xyz` - long option with single dash with an argument
* `--aabc` - long option with multiple dashes
* `--aabc xyz` - long option with multiple dashes with an argument
* `--aabc=xyz` - long option with multiple dashes and assignment using equal sign 

Current Linux conventions are to use single dash single character (`-a`) or
double dash long option (`--abc`).  The single dash long option (`-abc`) should be avoided by convention.
The options can be parsed by iterating through the command line options with custom code.
However, the following sections illustrate how to parse options using standard Linux shell features.

### Parsing command line options with built-in getopts ###

Command line parsing can be implemented using the `sh` built-in `getopts` feature.
This approach only supports single character options.  See:

* [`getopts` documentation](http://pubs.opengroup.org/onlinepubs/9699919799.2008edition/utilities/getopts.html)
* [Using getopts inside a Bash function](https://stackoverflow.com/questions/16654607/using-getopts-inside-a-bash-function)

For example, create a function similar to the following.
The use of `local` is necessary as explained in the second link above.
The built-in `getopts` command has specific syntax where colons after an option letter indicate whether a trailing argument is expected.
For example, in the following, the `-i` and `-o` arguments are used to specify filenames.
The colon at the start of the `optstring` indicates that options that require an argument
should result in the `:` case statement should be executed to handle the error.

```
# Parse the command line and set variables to control logic
parseCommandLine() {
  # Special case that nothing was provided on the command line so print usage
  # - include this if it is desired to print usage by default
  if [ "$#" -eq 0 ]; then
    printUsage
    exit 0
  fi
  local OPTIND opt h i o v
  optstring=":hi:o:v"
  while getopts $optstring opt; do
    #echo "Command line option is $opt"
    case $opt in
      h) # -h  Print usage
        printUsage
        exit 0
        ;;
      i) # -i inputFile  Get the input file
        inputFile=$OPTARG
        ;;
      o) # -o outputFile  Get the output file
        outputFile=$OPTARG
        ;;
      v) # -v  Print the version
        printVersion
        exit 0
        ;;
      \?) # Unknown single-character option
        echo ""
        echo "Invalid option:  -$OPTARG" >&2
        printUsage
        exit 1
        ;;
      :) # Option is recognized but it is missing an argument
        echo ""
        echo "Option -$OPTARG requires an argument" >&2
        printUsage
        exit 1
        ;;
    esac
  done
  # Get a list of all command line options that do not correspond to dash options.
  # - These are "non-option" arguments.
  # - For example, one or more file or folder names that need to be processed.
  # - If multiple values, they will be delimited by spaces.
  # - Command line * will result in expansion to matching files and folders.
  shift $((OPTIND-1))
  additionalOpts=$*
}
```

This function needs to be called by passing the original command line arguments:

```
parseCommandLine "$@"
```

[See the full working example that can be run on a Linux command line](resources/parse-command-line-builtin-getopts.txt)
(The link will display text file but can save as `.sh` or no extension to run on a computer.
If necessary, run with `sh parse-command-line-builtin-getopts.txt`).

### Parsing command line options with `getopt` command ###

The built-in `getopts` syntax is limited in that it cannot handle long options.
This limitation can be overcome using the `getopts` Linux command (not built into the shell but instead a command that is called).  See:

*   [getopt man page](https://linux.die.net/man/1/getopt)
*   [TutorialsPoint getopt tutorial](https://www.tutorialspoint.com/unix_commands/getopt.htm)

The code below is an example of a function to parse a command line using `getopt` command.
Note the following:

*   The `getopt` command can handle short (`-a`) and long (`--abc`) arguments for cases
    of no argument, required argument, and optional argument.
*   If an option has optional argument, the syntax `-o=argument` or `--option=argument` must be used.
*   Handling single-dash long option (`-abc`) is not an explicit feature.
    Errors may be generated that `b` and `c` are unrecognized single-character options.
*   The `getopt` command essentially parses and recreates the command line so that
    special cases are handled:
    +   Missing optional arguments are output as empty single-quoted string.
    +   Option specified as `--option=argument` is output as space-delimited `--option argument`.
*   If `-h` is specified before `--`, the `getopt` help will be printed.
    Make sure to put the command line to parse after the `getopt` `--` option.
*   The `case` statement that is used to check for options uses the full option value, with leading dash(es).
    This is different than the built-in `getopts` feature, in which dashes are not used in the `case` statement.
*   The code below requires using `shift` to advance parsing through the options and arguments.
    This is foolproof because `getopt` reformats the original command line into simpler syntax
    and also generates an error if bad input is detected.
*   There is no way to do custom error handling such as for missing argument or unknown argument
    because `getopt` generates the error.
    There is different from built-in `getopts` that allows a colon to be specified at the beginning of `optstring`.

The `getopt` call by itself does not print anything:

```
$ getopt --options "hi:o::v"
```

However, passing options does output a "nice" command line.
Note that the `--` is output to indicate the end of command line
and an empty string has been inserted for output file because it was not specified.

```
$ getopt --options "hi:o::v" -- -h -v -o
 -h -v -o '' --
```

The following is code for a function to parse the command line:

```
# Parse the command line and set variables to control logic
parseCommandLine() {
  # Special case that nothing was provided on the command line so print usage
  # - include this if it is desired to print usage by default
  if [ "$#" -eq 0 ]; then
    printUsage
    exit 0
  fi
  # Indicate specification for single character options
  # - 1 colon after an option indicates that an argument is required
  # - 2 colons after an option indicates that an argument is optional, must use -o=argument syntax
  optstring="hi:o::v"
  # Indicate specification for long options
  # - 1 colon after an option indicates that an argument is required
  # - 2 colons after an option indicates that an argument is optional, must use --option=argument syntax
  optstringLong="help,input-file:,output-file::,version"
  # Parse the options using getopt command
  # - the -- is a separator between getopt options and parameters to be parsed
  # - output is simple space-delimited command line
  # - error message will be printed if unrecognized option or missing parameter but status will be 0
  # - if an optional argument is not specified, output will include empty string ''
  GETOPT_OUT=$(getopt --options $optstring --longoptions $optstringLong -- "$@")
  exitCode=$?
  if [ $exitCode -ne 0 ]; then
    echo ""
    printUsage
    exit 1
  fi
  # The following constructs the command by concatenating arguments
  # - the $1, $2, etc. variables are set as if typed on the command line
  # - special cases like --option=value and missing optional arguments are generically handled
  #   as separate parameters so shift can be done below
  eval set -- "$GETOPT_OUT"
  # Loop over the options
  # - the error handling will catch cases were argument is missing
  # - shift over the known number of options/arguments
  while true; do
    #echo "Command line option is $opt"
    case "$1" in
      -h|--help) # -h or --help  Print usage
        printUsage
        exit 0
        ;;
      -i|--input-file) # -i inputFile or --input-file inputFile  Specify the input file
        # Input file must be specified so $2 can be used
        inputFile=$2
        shift 2
        ;;
      -o|--output-file) # -o outputFile or --output-file outputFile  Specify the output file
        case "$2" in
          "")  # No output file so use default (check elsewhere)
            outputFile="stdout"
            shift 2  # Because output file is an empty string $2=''
            ;;
          *) # Output file has been specified so use it
            outputFile=$2
            shift 2  # Because output file is $2
            ;;
        esac
        ;;
      -v|--version) # -v or --version  Print the version
        printVersion
        exit 0
        ;;
      --) # No more arguments
        shift
        break
        ;;
      *) # Unknown option - will never get here because getopt catches up front
        echo ""
        echo "Invalid option $1." >&2
        printUsage
        exit 1
        ;;
    esac
  done
  # Get a list of all command line options that do not correspond to dash options.
  # - These are "non-option" arguments.
  # - For example, one or more file or folder names that need to be processed.
  # - If multiple values, they will be delimited by spaces.
  # - Command line * will result in expansion to matching files and folders.
  shift $((OPTIND-1))
  additionalOpts=$*
}
```

This function needs to be called by passing the original command line arguments:

```
parseCommandLine "$@"
```

[See the full working example that can be run on a Linux command line](resources/parse-command-line-getopt-command.txt)
(The link will display text file but can save as `.sh` or no extension to run on a computer.
If necessary, run with `sh parse-command-line-getopt-command.txt`).

## Set Terminal Title ##

It can be helpful to set the title of a terminal window, for example to indicate that the terminal
is configured for an environment.
For example, a script may be run to to configure the `PATH` and other environment variables.
To set the title of the terminal, use the `echo` command with extended characters.
For example, the following script illustrates a function that sets the terminal title:

```
#!/bin/bash

# example-termtitle

# Function to set the title of the terminal for the configured environment
# See:  https://askubuntu.com/questions/22413/how-to-change-gnome-terminal-title
setTerminalTitle () {
    local title
    title=$1
    echo -ne "\033]0;${1}\007"
}

# The function can also added to the $HOME/.bashrc file and then add an alias:
# alias termtitle=setTerminalTitle
# 
# Then run this script on the command line with:
#   example-termtitle title
#   example-termtitle "title title with spaces"

# Entry point into script

if [ ! -z "$1" ]; then
    # If an argument was provided, use it to set the terminal title
    setTerminalTitle "$1"
fi
```
