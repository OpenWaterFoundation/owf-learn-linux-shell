# Linux Shell / Useful Command Examples #

This page provides examples of useful Linux commands.
The commands can be run from the command line or used in a shell scripts.
See also [Useful Script Examples](../useful-scripts/useful-scripts).

* [Search Files for a String](#search-files-for-a-string)
* [Search for Files](#search-for-files)

--------------

## Search Files for a String ##

The Linux `grep` command is useful for searching a file, for example, the following searches for the
pattern by ignoring case and recursively searching all files in the current and child folders:

```sh
$ grep -ir 'pattern'
$ grep -ir 'error'
```

The following finds finds including the string `error` and then lists that do not contain `help` using the `-v` option:

```sh
$ grep -ir 'error' | grep -v 'help'
```

## Search for Files ##

The Linux `find` command is used to search for files with name matching a literal string or pattern.
For example, use the following to find log files, searching the current folder (`.`) and below:

```
$ find . -name '*.log'
```

The following is used to find empty folders, which is useful when using Git for version control.
For example, Git may indicate that there are changes but `git status` does not list any changes.

```
$ find . -type d -empty
```

The `find` command options allow many other choices to match and filter files.
