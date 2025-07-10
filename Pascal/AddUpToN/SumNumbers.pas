program SumNumbers;

var
  N, i, sum: integer;

begin
  sum := 0;
  writeln('Enter a positive integer: ');
  readln(N);

  if N < 1 then
  begin
    writeln('Please enter a positive integer.');
    halt(1);
  end;

  for i := 1 to N do
    sum := sum + i;

  writeln('The sum of numbers from 1 to ', N, ' is ', sum);
end.
