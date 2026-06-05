10 REM ===============================================
20 REM  a number guessing demo -- NOJUO,INC.
30 REM   This program picks a random number between
40 REM   1 and 100. The player tries to guess it.
50 REM   Each guess receives feedback: too high or low.
60 REM ================================================

70 RANDOMIZE TIMER      'Seed the random number generator
80 TARGET = INT(RND * 100) + 1      'Pick a number from 1 to 100
90 GUESSES = 0          ' How many guesses has the player made? 0 by default

100 PRINT "NUMBER GUESSING GAME, DEMO! BY NOJUO, INC."
110 PRINT "I am thinking of a number between 1 and 100."
120 PRINT "Try to guess it!"
130 PRINT

140 INPUT "Your guess: ", GUESS   'Ask the player for a guess
150 GUESSES = GUESSES + 1         'Increase guess counter

160 IF GUESS < TARGET THEN PRINT "Too low! Try again.": GOTO 140
170 IF GUESS > TARGET THEN PRINT "Too high! Try again.": GOTO 140

180 REM If we reach here, the guess must be correct
190 PRINT
200 PRINT "Correct! The number was"; TARGET; "."
210 PRINT "You guessed it in"; GUESSES; "tries."
220 PRINT "Thanks for playing!"
230 END