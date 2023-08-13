; tfree.g
; called when a tool is freed
; use state.previousTool to determine witch tool was freed

;echo state.previousTool 

; abort if axes are not homed: 0:X 1:Y 2:Z 4:C
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed || !move.axes[4].homed
	M291 T5 P"Please home axes before a toolchange" R"Cannot change tool"
	abort

; check if toolDetectSwitch is not active, if not:abort
if sensors.gpIn[5] == null || sensors.gpIn[5].value == 0
	M291 T5 P"toolDetectSwitch is not active, but should" R"Cannot change tool"
	abort

; create vars and set ToolDock position accordingly (get specific tool dock offset from global array)
var dockXpos = 0
var dockYpos = 0
if state.previousTool < #global.ToolDock_X && state.previousTool < #global.ToolDock_Y && state.previousTool >= 0:
	set var.dockXpos = global.ToolDock_X[state.previousTool]
	set var.dockYpos = global.ToolDock_Y[state.previousTool]
else
	M291 "var.dockXpos and var.dockYpos was not set (unknown toolNum or toolNum out of bound)" R"Cannot change tool"
	abort
	
; free out of heat wait loop
M108

G91
G1 H4 Z5 F1200					    	; drop the bed
G90

M564 S0							    	; allow movement outside the normal limits

G53 G1 X{var.dockXpos} Y55 F40000		; move to location
G53 G1 Y110 F4000					    ; move in
G53 G1 Y{var.dockYpos} F2500            ; move in slow

M98 P"/macros/Coupler/unlock.g"		    ; open coupler

M106 P2 S0							    ; fan off

G53 G1 Y113 F2000					    ; move out a bit

;wait for all movements to stop and sync movement queues
M400

; check if toolDetectSwitch is active, if so:abort
if {sensors.gpIn[5] == null || sensors.gpIn[5].value == 1}
	M291 T5 P"toolDetectSwitch is active, but should not" R"Cannot change tool"
	T-1 P0
	abort

G53 G1 Y110 F4000					    ; move out a bit

G53 G1 Y100 F4000					    ; move Out

; set speeds, jerk and accel. for no active tool
M98 P"/macros/Speeds/set_speed.g"

; reset X and Y limits
M98 P"/macros/Boundaries/ToolHead.g"
; reset Z min limit
M208 S1 Z0

M564 S1								    ; apply the normal limits again
