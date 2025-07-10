&:                            Read first number and duplicate
>~:                           Read operator, duplicate
-48g                          Get char code of operator (0=+)
1-`!#v_                       Is it '+'? If yes, go down, else continue
 >+v
 ^_                          (ADD)
-49g1-`!#v_                   Is it '-'?
 >-v
 ^_                          (SUB)
-42g1-`!#v_                   Is it '*'?
 >*v
 ^_                          (MUL)
/v
^                            (DIV)
.:@                          Output result and end
