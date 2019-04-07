#!/bin/sh
#
# example-here-doc-pipe

# Illustrate how to use a "here document" to pipe text to a command line program.

# Set variables to the values used in a query
queryVal1="something"
queryVal2="somethingElse"

# In the following example, cat just prints the text,
# but if a database query program is used it would actually query a database
# and return results, such as comma-separated-value result set.
# - note that the output string has been expanded with variable values
# - a simple awk program is used to print the expanded result and
#   in a more substantial program would process the query result
# - the receiving command is provided starting on the line immediately
#   after the trailing __HERE_DOC__ string.
    cat << __HERE_DOC__ |
SELECT * from table where val1=${queryVal1} and val2='${queryVal2}'
__HERE_DOC__
    awk '
    { print $0 }
    '
