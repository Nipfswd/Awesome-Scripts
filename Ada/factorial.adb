with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Factorial_Demo is

   function Factorial(N : Integer) return Integer is
   begin
      if N = 0 then
         return 1;
      else
         return N * Factorial(N - 1);
      end if;
   end Factorial;

   N : Integer;
   Result : Integer;

begin
   Put_Line("Enter a non-negative integer:");
   Get(Item => N);

   if N < 0 then
      Put_Line("Factorial is not defined for negative numbers.");
   else
      Result := Factorial(N);
      Put("Factorial of ");
      Put(Integer'Image(N));
      Put(" is ");
      Put_Line(Integer'Image(Result));
   end if;

end Factorial_Demo;
