       IDENTIFICATION DIVISION.
       PROGRAM-ID. AddTwoNumbers.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 Num1        PIC 9(4) VALUE 0.
       01 Num2        PIC 9(4) VALUE 0.
       01 Sum         PIC 9(5) VALUE 0.

       PROCEDURE DIVISION.
           DISPLAY "Enter first number: ".
           ACCEPT Num1.

           DISPLAY "Enter second number: ".
           ACCEPT Num2.

           ADD Num1 TO Num2 GIVING Sum.

           DISPLAY "Sum is: " Sum.

           STOP RUN.
