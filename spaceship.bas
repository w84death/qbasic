REM      ~ SPACESHIP ~
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
    rows AS INTEGER
    cols AS INTEGER
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

TYPE WeaponType
    aim AS INTEGER
    heat AS INTEGER
    maxHeat AS INTEGER
    stall AS INTEGER
END TYPE

TYPE TerrainType
    row AS INTEGER
    zIndex AS INTEGER
    spr AS LONG
END TYPE

TYPE TerrainSpritesType
    starsa AS LONG
    starsb AS LONG
    black AS LONG
END TYPE

DIM SHARED AppSettings AS AppSettingsType
AppSettings.w = 320
AppSettings.h = 240
AppSettings.halfw = AppSettings.w / 2
AppSettings.halfh = AppSettings.h / 2
AppSettings.gameSpeed = 1
AppSettings.spriteSize = 32
AppSettings.rows = 10
AppSettings.cols = 8

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
Player.sprLeft = _LOADIMAGE("assets/ship.png", 32)
Player.sprNormal = _LOADIMAGE("assets/ship.png", 32)
Player.sprRight = _LOADIMAGE("assets/ship.png", 32)

DIM SHARED TerrainSprites AS TerrainSpritesType
TerrainSprites.starsa = _LOADIMAGE("assets/starsa.png", 32)
TerrainSprites.starsb = _LOADIMAGE("assets/starsb.png", 32)
TerrainSprites.black = _LOADIMAGE("assets/black.png", 32)


DIM SHARED Terrain(AppSettings.cols, AppSettings.rows) AS TerrainType
InitMap

DIM SHARED TerrainShift AS INTEGER
TerrainShift = 0

DIM SHARED Weapon AS WeaponType
Weapon.aim = 6
Weapon.heat = 0
Weapon.maxHeat = 32
Weapon.stall = 0
REM =========================

DO: _LIMIT 128
    DO WHILE _MOUSEINPUT: LOOP
    HandlePlayerMovement (INKEY$)
    RenderScreen
    DrawMouse
LOOP

SUB HandlePlayerMovement (KeyPressed AS STRING)
    IF _MOUSEX < Player.x THEN Player.direction = -1
    IF _MOUSEX > Player.x THEN Player.direction = 1
    IF _MOUSEX = Player.x THEN Player.direction = 0
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
    FOR z = 0 TO AppSettings.cols
        FOR row = 0 TO AppSettings.rows
            IF RND * 10 > 5 THEN
                t& = TerrainSprites.starsa
            ELSE
                IF RND * 10 > 5 THEN
                    t& = TerrainSprites.starsb
                ELSE
                    t& = TerrainSprites.black
                END IF
            END IF
            Terrain(z, row).spr = t&
        NEXT
    NEXT
END SUB

SUB ShiftMap
    DIM temp(AppSettings.rows) AS TerrainType
    FOR row = 0 TO AppSettings.rows
        temp(row) = Terrain(AppSettings.cols, row)
    NEXT
    FOR z = AppSettings.cols TO 1 STEP -1
        FOR row = 0 TO AppSettings.rows
            Terrain(z, row) = Terrain(z - 1, row)
        NEXT
    NEXT
    FOR row = 0 TO AppSettings.rows
        Terrain(0, row) = temp(row)
    NEXT

END SUB

SUB RenderScreen
    CLS
    DIM renderX AS INTEGER
    DIM renderY AS INTEGER
    FOR y = 0 TO AppSettings.cols
        FOR x = 0 TO AppSettings.rows
            renderX = x * AppSettings.spriteSize
            renderY = y * AppSettings.spriteSize + TerrainShif - AppSettings.spriteSize
            _PUTIMAGE (renderX, renderY), Terrain(y, x).spr
        NEXT
    NEXT

    TerrainShift = TerrainShift + AppSettings.gameSpeed
    IF TerrainShift > AppSettings.spriteSize THEN
        TerrainShift = 0
        ShiftMap
    END IF


    IF Player.direction < 0 THEN
        temp& = Player.sprLeft

    ELSEIF Player.direction > 0 THEN
        temp& = Player.sprRight
    ELSE
        temp& = Player.sprNormal
    END IF

    IF _MOUSEBUTTON(1) AND Weapon.stall = 0 THEN
        WeaponAim = Weapon.aim + Weapon.heat
        IF Weapon.heat < Weapon.maxHeat THEN
            Weapon.heat = Weapon.heat + 1
        ELSE
            Weapon.stall = 1
        END IF
        LINE (Player.x, Player.y)-(-WeaponAim / 2 + _MOUSEX + RND * WeaponAim, -WeaponAim / 2 + _MOUSEY + RND * WeaponAim), _RGB(255, 255, 255)
    ELSEIF Weapon.heat > 0 THEN Weapon.heat = Weapon.heat - 1
    END IF

    IF Weapon.heat = 0 AND Weapon.stall > 0 THEN Weapon.stall = 0

    _PUTIMAGE (Player.x - Player.size, Player.y - Player.size), temp&
END SUB

REM =========================
REM   Visit http://p1x.in
REM =========================

