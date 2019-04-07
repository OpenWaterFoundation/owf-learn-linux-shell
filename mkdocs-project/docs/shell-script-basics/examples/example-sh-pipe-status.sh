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
