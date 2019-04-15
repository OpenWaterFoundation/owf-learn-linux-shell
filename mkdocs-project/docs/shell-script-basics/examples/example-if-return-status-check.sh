#!/bin/sh

# example-if-return-status-check - example of checking return status

# Function to return the value passed as first argument
testFunction() {
    local returnValue
    returnValue=$1
    return $returnValue
}

# Main entry point

# Call the test function
# - could also call a program or built-in command
# - pass the value to return from the function
if testFunction 0; then
    echo "Function was successful (return value 0)"
fi
if testFunction 1; then
    # This will not called because 1 is considered false
    echo "Function was not successful (return value 1)"
fi
# Use ! to negate the logical check
# - therefore a failure causes the if to evaluate as true
if ! testFunction 1; then
    echo "Function was not successful (return value 1)"
fi
