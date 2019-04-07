#!/bin/sh
#
# example-braces-while-return-string.sh
#
# Example showing how while loop variable can be shared with calling code.
# - generating input with "printf" requires \n to terminate each line
# - generating input with "echo" requires -e to convert \n to newline, but does not need \n at end
# - the curly braces group commands in the same shell (or sub-shell),
#   in this case ensuring that "joined" variable has a final value

# Notes
#joined2=$(printf "line1\nline2\n" |
joined2=$(echo -e "line1\nline2" |
{
     while read line; do
       if [ -z "$joined" ]; then
         joined="$line"
       else
         joined="$joined,$line"
       fi
     done
     echo $joined
}
)
# Will echo "line1,line2"
echo $joined2
