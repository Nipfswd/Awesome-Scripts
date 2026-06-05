10 REM ================================================
20 REM   NUMBER GUESSING GAME by NOJUO, INC.
30 REM   This program chooses a random number between
40 REM   1 and 100. The player tries to guess it.
50 REM   Dartmouth BASIC uses RND(1) for randomness.
60 REM ================================================

70 LET TARGET = INT(RND(1) * 100) + 1   REM Pick number 1-100
80 LET GUESSES = 0                      REM Count guesses

90 PRINT "NUMBER GUESSING GAME! BY NOJUO, INC."
100 PRINT "I AM THINKING OF A NUMBER BETWEEN 1 AND 100."
110 PRINT "TRY TO GUESS IT."
120 PRINT

130 PRINT "YOUR GUESS";
140 INPUT GUESS
150 LET GUESSES = GUESSES + 1

160 IF GUESS < TARGET THEN PRINT "TOO LOW. TRY AGAIN.": GOTO 130
170 IF GUESS > TARGET THEN PRINT "TOO HIGH. TRY AGAIN.": GOTO 130

180 REM If we reach this line, the guess is correct
190 PRINT
200 PRINT "CORRECT! THE NUMBER WAS"; TARGET
210 PRINT "YOU GUESSED IT IN"; GUESSES; "TRIES."
220 PRINT "THANKS FOR PLAYING."
230 END
