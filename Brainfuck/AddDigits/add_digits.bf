,                   Read first digit (ASCII)
-'0' is 48, so subtract 48:
----------[->++++++++++<]  Convert ASCII to int

> ,                 Move to new cell and read second digit
----------[->++++++++++<]  Convert ASCII to int

< +                 Add the two values together

> ++++++++++        Prepare 48 in next cell to convert back to ASCII
[<+>-]              Add 48 to the result cell

< .                 Output the result as a digit
