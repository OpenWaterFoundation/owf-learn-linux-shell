# Learn Linux Shell / Common Tasks #

This page provides examples for common shell script tasks.
Some of the examples are simply useful Linux commands, but can be placed in shell scripts for reuse.

* [Search Files for a String](#search-files-for-a-string)

--------------

## Search Files for a String ##

The Linux `grep` command is useful for searching a file, for example, the following searches for the
pattern by ignoring case and recursively searching all files in the current and child folders:

```sh
$ grep -ir 'pattern'
```

More examples will be added.
