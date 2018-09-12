# Learn Linux Shell / Tips and Tricks #

This page provides tips and tricks.

* [Ensure that script runs on Linux and Windows](#ensure-that-script-runs-on-linux-and-windows)

-----------------

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
