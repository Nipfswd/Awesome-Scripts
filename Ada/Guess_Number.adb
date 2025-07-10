with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Calendar; use Ada.Calendar;

procedure Guess_Number is

   -- Constants
   Max_Attempts : constant Integer := 7;
   Min_Number   : constant Integer := 1;
   Max_Number   : constant Integer := 100;

   -- Variables
   Secret_Number : Integer;
   Guess         : Integer;
   Attempts      : Integer := 0;
   Start_Time    : Time := Clock;
   End_Time      : Time;

   -- Generate a pseudo-random number between Min_Number and Max_Number
   function Random_Number return Integer is
      Seed : Integer := Integer(Clock.Time_Of_Day.Seconds * 1000.0);
      Rand : Integer;
   begin
      -- Simple linear congruential generator (LCG) for demo purposes
      Seed := (Seed * 1103515245 + 12345) mod 2147483647;
      Rand := Min_Number + (Seed mod (Max_Number - Min_Number + 1));
      return Rand;
   end Random_Number;

begin
   Put_Line("Welcome to the Guess-the-Number Game!");
   Put_Line("I'm thinking of a number between " & Integer'Image(Min_Number) &
            " and " & Integer'Image(Max_Number) & ".");
   Put_Line("You have " & Integer'Image(Max_Attempts) & " attempts to guess it.");

   Secret_Number := Random_Number;

   loop
      Put("Enter your guess: ");
      begin
         Get(Guess);
      exception
         when Data_Error =>
            Put_Line("Invalid input. Please enter an integer.");
            -- Clear input buffer
            declare
               Dummy : Character;
            begin
               loop
                  exit when not Ada.Text_IO.End_Of_Line;
                  Get(Dummy);
               end loop;
            end;
            continue;
      end;

      if Guess < Min_Number or else Guess > Max_Number then
         Put_Line("Your guess is out of range. Please guess between " &
                  Integer'Image(Min_Number) & " and " & Integer'Image(Max_Number) & ".");
         continue;
      end if;

      Attempts := Attempts + 1;

      if Guess = Secret_Number then
         Put_Line("Congratulations! You guessed the number in " & Integer'Image(Attempts) & " attempts.");
         exit;
      elsif Guess < Secret_Number then
         Put_Line("Too low!");
      else
         Put_Line("Too high!");
      end if;

      if Attempts >= Max_Attempts then
         Put_Line("Sorry, you've used all your attempts. The number was " & Integer'Image(Secret_Number) & ".");
         exit;
      else
         Put_Line("Attempts left: " & Integer'Image(Max_Attempts - Attempts));
      end if;
   end loop;

   End_Time := Clock;
   Put_Line("You took " & Integer'Image(Integer(Seconds(End_Time - Start_Time))) & " seconds.");

   Put_Line("Thanks for playing!");

end Guess_Number;
