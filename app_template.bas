REM    ~ QB64 APP ENGINE ~
REM  P1X QBASIC DIVISION 2017
REM     Krzysztof Jankowski
REM ==========================

TYPE AppSettingsType
    w AS INTEGER
    h AS INTEGER
    halfw AS INTEGER
    halfh AS INTEGER
END TYPE

DIM SHARED AppSettings AS AppSettingsType
AppSettings.w = 320
AppSettings.h = 240
AppSettings.halfw = AppSettings.w / 2
AppSettings.halfh = AppSettings.h / 2

DIM Display AS LONG
Display = _NEWIMAGE(AppSettings.w, AppSettings.h, 32)
SCREEN Display
_MOUSEHIDE
RANDOMIZE TIMER

DIM SHARED SprVehicle AS LONG
SprVehicle = _LOADIMAGE("vehicle.png", 32)

REM =========================

InitMouse

DO: _LIMIT 128
    DO WHILE _MOUSEINPUT: LOOP
    RenderScreen

LOOP

SUB InitMouse
    ON TIMER(0.02) DrawMouse
    TIMER ON
END SUB

SUB DrawMouse
    PCOPY _DISPLAY, 100
    PSET (_MOUSEX, _MOUSEY), _RGB(255, 255, 255)
    LINE -(_MOUSEX + 8, _MOUSEY + 4), _RGB(255, 255, 255)
    LINE -(_MOUSEX + 6, _MOUSEY + 8), _RGB(255, 255, 255)
    LINE -(_MOUSEX, _MOUSEY), _RGB(255, 255, 255)

    _DISPLAY
    PCOPY 100, _DISPLAY
END SUB

SUB RenderScreen

    _PUTIMAGE (_MOUSEX, AppSettings.halfh), SprVehicle, Display
END SUB
REM =========================
REM   Visit http://p1x.in
REM =========================

