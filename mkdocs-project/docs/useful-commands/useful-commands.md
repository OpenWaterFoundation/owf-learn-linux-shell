# Linux Shell / Useful Command Examples #

This page provides examples of useful Linux commands.
The commands can be run from the command line or used in a shell scripts.
See also [Useful Script Examples](../useful-scripts/useful-scripts).

* [Count Matching String in Files](#count-matching-string-in-files)
* [Find File Differences](#find-file-differences)
* [Search Files for a String](#search-files-for-a-string)
* [Search for Files](#search-for-files)

--------------

## Count Matching String in Files ##

It is often helpful to count instances of a match,
for example how many files contain a string.
This can be used to search code for a pattern that needs attention.
The following uses the `grep` command to search for a string and count the number of matching files,
for all files in the current folder.
The `wc` (word count) command is used with `-l` to count the number of lines.
See the examples of search commands to modify the search.

```
$ grep 'somestring' * | wc -l
```

To search for a string, ignoring case and recursively searching all sub-folders:

```
$ grep -ir 'somestring' | wc -l
```

To search for a string, ignoring case and recursively searching all sub-folders,
and ignoring lines that also contain 'somestring2':

```
$ grep -ir 'somestring' | grep -v 'somestring2' | wc -l
```

## Find File Differences ##

The Linux `diff` command provides a text representation of file differences.
See the [`diff` man page](https://linux.die.net/man/1/diff) for full usage.

```
$ diff file1 file2
```

### Compare Files Ignoring Line Endings ###

Linux uses `LF` for line endings whereas Windows uses `CR` `LF`.
Running `diff` on files from different operating systems will show every line being different.
To ignore line endings:

```
$ diff --strip-trailing-cr file1 file2
```

## Search Files for a String ##

The Linux `grep` command is useful for searching a file, for example, the following searches for the
pattern by ignoring case (`-i`) and recursively searching (`-r`) all files in the current and child folders:

```sh
$ grep -ir 'pattern'
$ grep -ir 'error'
```

The following finds finds including the string `error` and then filters the
list to files that do not contain `help` using the `-v` option.

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
