#!/bin/sh
#
# example-here-doc-redirect

# Illustrate how to use a "here document" to populate a file that is needed for a system update.
# - this demonstrates how to redirect the here document to a file

# First might get the operating system and parse the returned string to determine specifics
operatingSystem=$(uname -a)
# Would have some logic to check for different operating systems
# - for this example just check for empty string
if [ ! -z "$operatingSystem" ]; then
    # Need to make sure that the patch file is in place
    # - use a here document to create the output file
    # - for this example just use a temporary file
    # - the __HERE_DOC__ string can be anything, as long as it bounds the text
    #   and is not found in the text
    # - using single quotes around __HERE_DOC indicates to the shell to NOT expand variables
    #   (for example don't convert $variable to its value)
    patchFile="$(mktemp).patch"
    cat << '__HERE_DOC__' > $patchFile
This is text that is part of the patch.
Because single quotes were used around the here doc string,
a variable like $PATH won't be expanded.
There are other modifiers to the here doc string that can be used
(see reference documentation).
__HERE_DOC__
fi

echo "Created patch file $patchFile:"
cat $patchFile
