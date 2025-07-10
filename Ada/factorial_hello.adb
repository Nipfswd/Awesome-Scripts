with Ada.Text_IO; use Ada.Text_IO;

procedure Hello_Factorial is

   function Factorial(N : Integer) return Integer is
   begin
      if N <= 1 then
         return 1;
      else
         return N * Factorial(N - 1);
      end if;
   end Factorial;

   Number : Integer := 5;
begin
   Put_Line("Hello, World!");
   Put_Line("Factorial of " & Integer'Image(Number) & " is " & Integer'Image(Factorial(Number)));
end Hello_Factorial;
