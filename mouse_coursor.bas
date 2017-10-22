REM     ~ TEST ENGINE ~
REM P1X QBASIC DIVISION 2017
REM    Krzysztof Jankowski
REM =========================

TYPE AppSettingsType
    w AS INTEGER
    h AS INTEGER
    halfw AS INTEGER
    halfh AS INTEGER
END TYPE

DIM AppSettings AS AppSettingsType
AppSettings.w = 320
AppSettings.h = 240
AppSettings.halfw = AppSettings.w / 2
AppSettings.halfh = AppSettings.h / 2

SCREEN _NEWIMAGE(AppSettings.w, AppSettings.h, 32)
_MOUSEHIDE
RANDOMIZE TIMER

REM =========================

INITMOUSE
DO: _LIMIT 128
    DO WHILE _MOUSEINPUT: LOOP
    CIRCLE STEP(RND * 4, RND * 4), 4 + RND * 6, _RGB(_MOUSEX / 3, _MOUSEY / 2, _MOUSEY / 2)

LOOP

SUB INITMOUSE
    ON TIMER(0.02) DRAWMOUSE
    TIMER ON
END SUB

SUB DRAWMOUSE
    PCOPY _DISPLAY, 100
    PSET (_MOUSEX, _MOUSEY), _RGB(255, 255, 255)
    LINE -(_MOUSEX + 8, _MOUSEY + 4), _RGB(255, 255, 255)
    LINE -(_MOUSEX + 6, _MOUSEY + 8), _RGB(255, 255, 255)
    LINE -(_MOUSEX, _MOUSEY), _RGB(255, 255, 255)

    _DISPLAY
    PCOPY 100, _DISPLAY
END SUB

REM =========================
REM   Visit http://p1x.in
REM =========================

