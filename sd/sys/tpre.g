; tpre.g
; called before a tool is selected
; use state.nextTool to determine witch tool is selected

; abort if axes are not homed: 0:X 1:Y 2:Z 4:C
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed || !move.axes[4].homed
	M291 T5 P"Please home axes before a toolchange" R"Cannot change tool"
	T-1 P0
	abort "Cannot change tool - Please home axes before a tool change"

; check if toolDetectSwitch is active, if so:abort
if sensors.gpIn[5] == null || sensors.gpIn[5].value == 1
	M291 T5 P"toolDetectSwitch is active, but should not" R"Cannot change tool"
	T-1 P0
	abort "Cannot change tool - toolDetectSwitch is active, but should not"

; temp check for filament
; TODO: ask user wich filament he wants, start loading of filament, continue with macro
if tools[state.nextTool].filamentExtruder > -1 && move.extruders[state.nextTool].filament == "" && state.status == "processing"
    M117 "No filament in extruder!"

G91
G0 H4 Z5  ; drop the bed
G90

set global.ZisLifted = false

M98 P"/macros/Coupler/unlock.g"	                ; unlock Coupler

; create vars and set ToolDock position accordingly (get specific tool dock offset from global array)
var dockXpos = 0
var dockYpos = 0
if state.nextTool < #global.ToolDock_X && state.nextTool < #global.ToolDock_Y && state.nextTool >= 0
	set var.dockXpos = global.ToolDock_X[state.nextTool]
	set var.dockYpos = global.ToolDock_Y[state.nextTool]
	
	M564 S0                                         ; allow movement outside the normal limits
	
	; move to location
	G0 X{var.dockXpos} Y100 F40000
	; move in faster
	G1 Y110 F4000
	; move in slowly to final position
	G1 Y{var.dockYpos} F2500
else
	; move to location for manual change
	G1 X-50 Y-100 F40000
	M291 R"Manual tool change" P{"Put Tool "^state.nextTool^" to the ToolHead"} K{"Ok","Abort"} S4
	if (input == 1)
    	T-1 P0
		abort "Cannot change tool - user aborted"

M98 P"/macros/Coupler/lock.g"	                    ; close Coupler

;wait for all movement to stop
M400

; check if toolDetectSwitch is inactive, if so: abort
if sensors.gpIn[5] == null || sensors.gpIn[5].value == 0
	M291 T5 P"toolDetectSwitch is not active, but should" R"Cannot change tool"
	T-1 P0
	abort "Cannot change tool - toolDetectSwitch is not active, but should"

; set speed and axes limits for this new tool
if state.nextTool == 0 || state.nextTool == 1 || state.nextTool == 4
	M98 P"/macros/Speeds/set_speed.g" L"lightTool"  ; set speeds, jerk and accel. for light weight bowden tool
	M98 P"/macros/Boundaries/V6-and-Volcano.g"      ; set new limits for this tool
elif state.nextTool == 2
	M98 P"/macros/Speeds/set_speed.g" L"heavyTool" ; set speeds, jerk and accel. for heavy direct tool
	M98 P"/macros/Boundaries/Hemera-Direct.g"      ; set new limits for this tool
elif state.nextTool == 3
	M98 P"/macros/Speeds/set_speed.g" L"spindleTool" ; set speeds, jerk and accel. for very heavy spindle
	M98 P"/macros/Boundaries/Mill.g"      ; set new limits for this tool
else
	M291 P"speed and limits where not set (unknown toolNum)" R"Cannot change tool"
	abort "Cannot change tool - speed and limits where not set (unknown toolNum)"

	
; check if toolDetectSwitch is inactive, if so: abort
if sensors.gpIn[5] == null || sensors.gpIn[5].value == 0
	M291 T5 P"toolDetectSwitch is not active, but should" R"Cannot change tool"
	T-1 P0
	abort "Cannot change tool - toolDetectSwitch is not active, but should"

if state.nextTool < #global.ToolDock_X && state.nextTool < #global.ToolDock_Y && state.nextTool >= 0
	; lower the bed
	G91
	G0 H4 Z{-tools[state.nextTool].offsets[2]}
	G90
	
	G1 Y113 F2000					                ; move out a bit
	
	G1 Y110 F4000					                ; move out a bit
	
	G1 Y55 F4000					                ; move out
	
	; apply new min limit for z axis so we cannot crash into bed
	M208 S1 Z{-tools[state.nextTool].offsets[2]}
	
	; apply the normal limits again
	M564 S1
