REM      ~ DESERT RALLY ~
REM  P1X QBASIC DIVISION 2017
REM     Krzysztof Jankowski
REM ==========================

TYPE AppSettingsType
    w AS INTEGER
    h AS INTEGER
    halfw AS INTEGER
    halfh AS INTEGER
END TYPE

TYPE VehicleType
    x AS INTEGER
    y AS INTEGER
    size AS INTEGER
    direction AS INTEGER
    sprLeft AS LONG
    sprNormal AS LONG
    sprRight AS LONG
    sprShadow AS LONG
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

DIM SHARED Player AS VehicleType
Player.x = AppSettings.halfw
Player.y = AppSettings.h - 48
Player.size = 16
Player.direction = -1
Player.sprLeft = _LOADIMAGE("assets/vehicle.png", 32)
Player.sprNormal = _LOADIMAGE("assets/vehicle.png", 32)
Player.sprRight = _LOADIMAGE("assets/vehicle.png", 32)

REM =========================

InitMouse
DIM KeyPressed AS STRING

DO: _LIMIT 128
    DO WHILE _MOUSEINPUT: LOOP
    KeyPressed = INKEY$
    IF KeyPressed = "z" THEN Player.direction = -1
    IF KeyPressed = "x" THEN Player.direction = 1
    IF Player.x + Player.direction < Player.size THEN Player.direction = 1
    IF Player.x + Player.direction > AppSettings.w - Player.size THEN Player.direction = -1
    Player.x = Player.x + Player.direction


    RenderScreen

LOOP

SUB InitMouse
    ON TIMER(0.02) DrawMouse
    TIMER ON
END SUB

SUB DrawMouse
    DIM gap AS INTEGER
    gap = 4
    PCOPY _DISPLAY, 100
    PSET (_MOUSEX, _MOUSEY), _RGB(255, 255, 255)
    LINE (_MOUSEX - gap, _MOUSEY)-(_MOUSEX - gap * 2, _MOUSEY), _RGB(255, 255, 255)
    LINE (_MOUSEX + gap, _MOUSEY)-(_MOUSEX + gap * 2, _MOUSEY), _RGB(255, 255, 255)
    LINE (_MOUSEX, _MOUSEY - gap)-(_MOUSEX, _MOUSEY - gap * 2), _RGB(255, 255, 255)
    LINE (_MOUSEX, _MOUSEY + gap)-(_MOUSEX, _MOUSEY + gap * 2), _RGB(255, 255, 255)

    _DISPLAY
    PCOPY 100, _DISPLAY
END SUB

SUB RenderScreen
    _PUTIMAGE (Player.x - Player.size, Player.y), Player.sprNormal, Display
END SUB

REM =========================
REM   Visit http://p1x.in
REM =========================

