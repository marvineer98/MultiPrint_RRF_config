; here we define all global vars
; NOTE: use save defne for vars because there could be defined allready

; ----- ----- Common variable declarations ----- ----- 

; IdlePos (X, Y, Z)
if !exists(global.IdlePos) 
	global IdlePos = {-170, 100, 5}
else
	set global.IdlePos = {-170, 100, 5}

; camPos and calibration (X, Y, Z)
if !exists(global.camPos) 
	global camPos = {161.37, 79.44, 1}
else
	set global.camPos = {161.37, 79.44, 1}

if !exists(global.calibration_movement_step)
	global calibration_movement_step = 100  
else
	set global.calibration_movement_step = 100

; ToolDock Positions (T0, T1, T2, T3)
if !exists(global.ToolDock_X)
	global ToolDock_X = {-157.7, -67.5,  61.3, 170.0}
else
	set global.ToolDock_X = {-157.7, -67.5,  61.3, 170.0}
if !exists(global.ToolDock_Y)
	global ToolDock_Y = {115.5, 115.7, 115.3, 115.2}
else
	set global.ToolDock_Y = {115.5, 115.7, 115.3, 115.2}

; Z lift state
if !exists(global.ZisLifted)
	global ZisLifted = false
else
	set global.ZisLifted = false

; heightMap calibration temperatures
if !exists(global.heightmapTemps)
	global heightmapTemps = {20, 60, 80, 100}
else
	set global.heightmapTemps = {20, 60, 80, 100}

; run daemon flag
if !exists(global.RunDaemon)
	global RunDaemon = true 
else
	set global.RunDaemon = true

; define number of RGB LEDs
if !exists(global.numLEDs)
	global numLEDs = 18 
else
	set global.numLEDs = 18

; create array for filament scale values (3 scales, each with value and standard deviation)
if (!exists(global.FilamentScale))
	global FilamentScale = {{0,0},{0,0},{0,0}}
