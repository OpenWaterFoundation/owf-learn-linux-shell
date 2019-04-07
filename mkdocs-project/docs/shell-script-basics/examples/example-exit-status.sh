#!/bin/sh

# Example of exit status.
# The following will always fail because the file does not exist.

fileToRemove="/tmp/some-file-that-does-not-exist"
# Redirect error to /dev/null so script message is used instead.
rm "$fileToRemove" 2> /dev/null
if [ $? -eq 0 ]; then
    echo "Success removing file:  $fileToRemove"
else
    echo "File does not exist:  $fileToRemove"
fi
