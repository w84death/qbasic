REM      ~ DESERT RALLY ~
REM  P1X QBASIC DIVISION 2017
REM     Krzysztof Jankowski
REM ==========================

TYPE AppSettingsType
    w AS INTEGER
    h AS INTEGER
    halfw AS INTEGER
    halfh AS INTEGER
    gameSpeed AS INTEGER
    spriteSize AS INTEGER
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

TYPE TerrainType
    row AS INTEGER
    zIndex AS INTEGER
    spr AS LONG
END TYPE

TYPE TerrainSpritesType
    grass AS LONG
    road AS LONG
    band_left AS LONG
    band_right AS LONG
END TYPE

DIM SHARED AppSettings AS AppSettingsType
AppSettings.w = 320
AppSettings.h = 240
AppSettings.halfw = AppSettings.w / 2
AppSettings.halfh = AppSettings.h / 2
AppSettings.gameSpeed = 1
AppSettings.spriteSize = 32

DIM Display AS LONG
Display = _NEWIMAGE(AppSettings.w, AppSettings.h, 32)
SCREEN Display
_MOUSEHIDE
RANDOMIZE TIMER

DIM SHARED Player AS VehicleType
Player.x = AppSettings.halfw
Player.y = AppSettings.h - 48
Player.size = 16
Player.direction = 0
Player.sprLeft = _LOADIMAGE("assets/vehicle_left.png", 32)
Player.sprNormal = _LOADIMAGE("assets/vehicle.png", 32)
Player.sprRight = _LOADIMAGE("assets/vehicle_right.png", 32)

DIM SHARED TerrainSprites AS TerrainSpritesType
TerrainSprites.grass = _LOADIMAGE("assets/grass.png", 32)
TerrainSprites.road = _LOADIMAGE("assets/road_normal.png", 32)
TerrainSprites.band_left = _LOADIMAGE("assets/road_band_left.png", 32)
TerrainSprites.band_right = _LOADIMAGE("assets/road_band_right.png", 32)

DIM SHARED Terrain(10, 8) AS TerrainType
InitMap

DIM SHARED TerrainShift AS INTEGER
TerrainShift = 0

REM =========================

DO: _LIMIT 128
    DO WHILE _MOUSEINPUT: LOOP
    HandlePlayerMovement (INKEY$)
    RenderScreen
    DrawMouse
LOOP

SUB HandlePlayerMovement (KeyPressed AS STRING)
    IF KeyPressed = "z" THEN Player.direction = -1
    IF KeyPressed = "x" THEN Player.direction = 1

    IF Player.x + Player.direction < Player.size THEN Player.direction = 1
    IF Player.x + Player.direction > AppSettings.w - Player.size THEN Player.direction = -1
    Player.x = Player.x + Player.direction
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

SUB InitMap
    FOR row = 0 TO 10
        FOR z = 0 TO 7
            IF row > 2 AND row < 7 THEN
                t& = TerrainSprites.road
            ELSEIF row = 2 THEN
                t& = TerrainSprites.band_left
            ELSEIF row = 7 THEN
                t& = TerrainSprites.band_right
            ELSE
                t& = TerrainSprites.grass
            END IF
            Terrain(row, z).spr = t&
        NEXT
    NEXT
END SUB

SUB RenderScreen
    CLS

    FOR row = 0 TO 10
        FOR z = 0 TO 7
            _PUTIMAGE (row * 32, z * 32 + TerrainShift), Terrain(row, z).spr
        NEXT
    NEXT

    TerrainShift = TerrainShift + 1
    IF TerrainShift > AppSettings.spriteSize THEN
        TerrainShift = 0
    END IF

    IF Player.direction < 0 THEN
        temp& = Player.sprLeft

    ELSEIF Player.direction > 0 THEN
        temp& = Player.sprRight
    ELSE
        temp& = Player.sprNormal
    END IF

    _PUTIMAGE (Player.x - Player.size, Player.y), temp&
END SUB

REM =========================
REM   Visit http://p1x.in
REM =========================

