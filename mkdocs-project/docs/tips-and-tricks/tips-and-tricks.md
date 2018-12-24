# Linux Shell / Tips and Tricks #

This page provides tips and tricks to use in shell scripts.
Most of these examples are for `sh` rather than `bash` or other shell because `sh`
is intended for faster-executing scripts rather than interactive login shells.
The examples shown should also work for `basn` and other shells in many cases.

* [Command to do nothing](#command-to-do-nothing)
* [Control echo of script commands as script runs](#control-echo-of-script-commands-as-script-runs)
* [Determine the folder where a script exists](#determine-the-folder-where-a-script-exists)
* [Determine the operating system](#determine-the-operating-system)
* [Echo colored text to console](#echo-colored-text-to-console)
* [Ensure that script runs on Linux and Windows](#ensure-that-script-runs-on-linux-and-windows)
* [Parsing command line options](#parsing-command-line-options)
	+ [Parsing command line options with built-in getopts](#parsing-command-line-options-with-built-in-getopts)
	+ [Parsing command line options with `getopt` command](#parsing-command-line-options-with-getopt-command)

-----------------

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
This is normally used only in troubleshooting.

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
The following illustrates how to turn on the echo for one command and
then turn it off:

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
scriptFolder=`cd $(dirname "$0") && pwd`
```
The `$0` command argument contains the script name, which can be a file or path.
The above logic therefore changes to the directory in which the script resides.
The `&&` indicates to run the second command after the first command, in this case the `pwd` command.
The output is assigned to the `scriptFolder` variable, which can be used in other logic.

Examples:

* [Open Water Foundation git-check-util](https://github.com/OpenWaterFoundation/owf-util-git/blob/master/build-util/git-check-util.sh)


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

* [Open Water Foundation git-check](https://github.com/OpenWaterFoundation/owf-app-geoprocessor-python/blob/master/build-util/git-util/git-check.sh)

## Echo colored text to console

It can be useful to print colored text to the console, for example to highlight warning or error messages.
The `echo` command can be used to print special characters.  See:

* [How to change RGB colors in Git Bash for windows](https://stackoverflow.com/questions/21243172/how-to-change-rgb-colors-in-git-bash-for-windows)
* [Bash: Using Colors](http://webhome.csc.uvic.ca/~sae/seng265/fall04/tips/s265s047-tips/bash-using-colors.html)
* [Unix escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code#Unix-like_systems)
* [Yellow "33" in Linux can show as brown](https://unix.stackexchange.com/questions/192660/yellow-appears-as-brown-in-konsole)

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

* [Open Water Foundation git-check](https://github.com/OpenWaterFoundation/owf-app-geoprocessor-python/blob/master/build-util/git-util/git-check.sh)


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

* [Open Water Foundation git-check.sh](https://github.com/OpenWaterFoundation/owf-util-git/blob/master/build-util/git-util/git-check.sh)

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
}
```

This function needs to be called by passing the original command line arguments:

```
parseCommandLine "$@"
```

[See the full working example that can be run on a Linux command line](resources/parse-command-line-getopts.txt)
(link will display text file but can save as `.sh` or no extension to run on a computer).

### Parsing command line options with `getopt` command ###

The built-in `getopts` syntax is limited in that it cannot handle long options.
This limitation can be overcome using the `getopts` Linux command (not built into the shell).

**Need to add an example.**
