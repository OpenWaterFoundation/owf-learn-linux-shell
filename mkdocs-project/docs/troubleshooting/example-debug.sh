#!/bin/sh

# Example of using debug messaging

debug="true"

# Simple function
abc () {
	if [ "${debug}"=="true" ]; then
		echo "DEBUG:  Starting function abc"
	fi
}

# Call function abc
abc
