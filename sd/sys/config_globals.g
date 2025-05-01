; here we define all global vars
; NOTE: use save defne for vars because there could be defined allready

; ----- ----- Common variable declarations ----- ----- 

; IdlePos
if !exists(global.IdlePos_X)
	global IdlePos_X = -170
else
	set global.IdlePos_X = -170

if !exists(global.IdlePos_Y) 
	global IdlePos_Y = 100
else
	set global.IdlePos_Y = 100

if !exists(global.IdlePos_Z) 
	global IdlePos_Z = 5
else
	set global.IdlePos_Z = 5

; IdlePos
if !exists(global.IdlePos) 
	global IdlePos = {-170, 100, 5}
else
	set global.IdlePos = {-170, 100, 5}

; Z lift state
if !exists(global.ZisLifted)
	global ZisLifted = false
else
	set global.ZisLifted = false

; run daemon flag
if !exists(global.RunDaemon)
	global RunDaemon = true 
else
	set global.RunDaemon = true

; camPos and calibration
if !exists(global.camPos) 
	global camPos = {161.37, 79.44, 1}
else
	set global.camPos = {161.37, 79.44, 1}

if !exists(global.calibration_movement_step)
	global calibration_movement_step = 100  
else
	set global.calibration_movement_step = 100

; ToolDock Positions as an array
if !exists(global.ToolDock_X)
	; T0, T1, T2, T3
	global ToolDock_X = {-157.7, -67.5,  61.3, 170.0}
else
	set global.ToolDock_X = {-157.7, -67.5,  61.3, 170.0}
if !exists(global.ToolDock_Y)
	; T0, T1, T2, T3
	global ToolDock_Y = {115.5, 115.7, 115.3, 115.2}
else
	set global.ToolDock_Y = {115.5, 115.7, 115.3, 115.2}

if !exists(global.cam_positions)
	global cam_positions = 	{161.37, 79.44, 1}
else
	set global.cam_positions = 	{161.37, 79.44, 1}

; heightMap calibration temperatures
if !exists(global.heightmapTemps)
	global heightmapTemps = {20, 60, 80, 100}
else
	set global.heightmapTemps = {20, 60, 80, 100}

; create array for filament scale values (3 scales, each with value and standard deviation)
if (!exists(global.FilamentScale))
	global FilamentScale = {{0,0},{0,0},{0,0}}
