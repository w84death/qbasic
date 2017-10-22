REM     ~ TEST ENGINE ~
REM P1X QBASIC DIVISION 2017
REM    Krzysztof Jankowski
REM =========================

SCREEN 7, 0, 0, 1
CONST W = 320
CONST H = 200
CONST HW = W / 2
CONST HH = H / 2
CONST FPS = 24

RANDOMIZE TIMER

REM =========================

R# = 0.0
DIM S AS SINGLE
S = 0
MARGIN = (W - H) / 2
SWARMSPEED = 48
RSPEED# = 1 / 360
SSPEED# = 1
LINECOLOR = 15

REM =========================

DO
    S = S + SSPEED#
    Z = 0

    DO
        TW = MARGIN + RND * H
        TH = RND * H
        P = POINT(TW, TH)
        IF P > 0 THEN
            PSET (TW, TH), P - 1
        END IF
        Z = Z + 1
    LOOP UNTIL Z > SWARMSPEED

    IF S > FPS THEN
        LINE (HW, HH)-(HW - SIN(R#) * HH, HH + COS(R#) * HH), LINECOLOR
        R# = R# + RSPEED#
        IF R# > 360.0 THEN R# = 0.0
        S = 0

    END IF

    PCOPY 0, 1

LOOP UNTIL (INKEY$ = CHR$(27))

REM =========================
REM   Visit http://p1x.in
REM =========================

