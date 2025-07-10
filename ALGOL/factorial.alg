begin
    integer procedure factorial(n);
    value n;
    integer n;
    begin
        if n = 0 then
            factorial := 1
        else
            factorial := n * factorial(n - 1)
    end;

    integer n, result;

    outstring("Enter a non-negative integer: ");
    readint(n);

    if n < 0 then
        outstring("Factorial is not defined for negative numbers.")
    else
        begin
            result := factorial(n);
            outstring("Factorial of ");
            writeint(n, 0);
            outstring(" is ");
            writeint(result, 0)
        end
end.
