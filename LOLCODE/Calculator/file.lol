HAI 1.2

VISIBLE "ENTER FIRST NUMBER:"
GIMMEH NUM1

VISIBLE "ENTER SECOND NUMBER:"
GIMMEH NUM2

VISIBLE "CHOOSE OPERATION (+, -, *, /):"
GIMMEH OP

BOTH SAEM OP AN "+" O RLY?
    YA RLY
        VISIBLE "RESULT: " AN SUM OF NUM1 AN NUM2
    NO WAI
        BOTH SAEM OP AN "-" O RLY?
            YA RLY
                VISIBLE "RESULT: " AN DIFF OF NUM1 AN NUM2
            NO WAI
                BOTH SAEM OP AN "*" O RLY?
                    YA RLY
                        VISIBLE "RESULT: " AN PRODUKT OF NUM1 AN NUM2
                    NO WAI
                        BOTH SAEM OP AN "/" O RLY?
                            YA RLY
                                VISIBLE "RESULT: " AN QUOSHUNT OF NUM1 AN NUM2
                            NO WAI
                                VISIBLE "INVALID OPERATION"
                        OIC
                OIC
        OIC
OIC

KTHXBYE
