program matrix_multiply
    implicit none
    integer, parameter :: n = 3
    integer :: i, j, k
    real :: A(n,n), B(n,n), C(n,n)

    ! Initialize matrices A and B
    A = reshape([1.0, 2.0, 3.0, &
                 4.0, 5.0, 6.0, &
                 7.0, 8.0, 9.0], shape(A))

    B = reshape([9.0, 8.0, 7.0, &
                 6.0, 5.0, 4.0, &
                 3.0, 2.0, 1.0], shape(B))

    ! Initialize matrix C with zeros
    C = 0.0

    ! Multiply A and B into C
    do i = 1, n
        do j = 1, n
            do k = 1, n
                C(i,j) = C(i,j) + A(i,k) * B(k,j)
            end do
        end do
    end do

    ! Print the result
    print *, "Matrix A:"
    do i = 1, n
        print "(3F6.1)", A(i,:)
    end do

    print *, "Matrix B:"
    do i = 1, n
        print "(3F6.1)", B(i,:)
    end do

    print *, "Matrix C = A * B:"
    do i = 1, n
        print "(3F6.1)", C(i,:)
    end do

end program matrix_multiply
