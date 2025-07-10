program factorial_demo
    implicit none
    integer :: n
    integer :: result

    print *, "Enter a non-negative integer:"
    read *, n

    if (n < 0) then
        print *, "Factorial is not defined for negative numbers."
    else
        result = factorial(n)
        print *, "Factorial of", n, "is", result
    end if

contains

    recursive function factorial(x) result(res)
        integer, intent(in) :: x
        integer :: res

        if (x == 0) then
            res = 1
        else
            res = x * factorial(x - 1)
        end if
    end function factorial

end program factorial_demo
