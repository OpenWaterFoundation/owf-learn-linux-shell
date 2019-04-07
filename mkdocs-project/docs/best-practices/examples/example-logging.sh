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
