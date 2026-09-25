#!/bin/bash
# Validate Roman numerals
# Usage: ./roman-validate.sh <roman_numeral>
# Example: ./roman-validate.sh XIV
# Exit code: 0 if valid, 1 if invalid
# Author: Grok 3

validate_roman() {
    local input=$1
    # Make input case insensitive
    local input=$(echo "$input" | tr '[:upper:]' '[:lower:]')
    # Regex for valid Roman numeral pattern
    local regex='^m{0,3}(cm|cd|d?c{0,3})(xc|xl|l?x{0,3})(ix|iv|v?i{0,3})$'

    if [[ $input =~ $regex && -n $input ]]; then
        echo "Valid Roman numeral"
        return 0
    else
        echo "Invalid Roman numeral"
        return 1
    fi
}

# Test the function
if [ $# -eq 1 ]; then
    validate_roman "$1"
else
    echo "Usage: $0 <roman_numeral>"
    exit 1
fi
