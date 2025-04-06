; tpre4.g
; called before the pen tool is selected
; use state.nextTool to determine witch tool is selected

; abort if axes are not homed: 0:X 1:Y 2:Z 4:C
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed || !move.axes[4].homed
	M291 T5 P"Please home axes before a toolchange" R"Cannot change tool"
	T-1 P0
	abort

; check if toolDetectSwitch is active, if so:abort
if sensors.gpIn[5] == null || sensors.gpIn[5].value == 1
	M291 T5 P"toolDetectSwitch is active, but should not" R"Cannot change tool"
	T-1 P0
	abort

G91
G1 H4 Z{-tools[state.nextTool].offsets[2] + 5} F1200 ; drop the bed
G90

set global.ZisLifted = false

M98 P"/macros/Coupler/unlock.g"                      ; unlock Coupler

; move to location
G1 X-50 Y-100 F40000

M291 R"Manual tool change" P"Put Tool 4 to the ToolHead" S3

M98 P"/macros/Coupler/lock.g"                        ; close Coupler

;wait for all movement to stop
M400

; check if toolDetectSwitch is inactive, if so:abort
if sensors.gpIn[5] == null || sensors.gpIn[5].value == 0
	M291 T5 P"toolDetectSwitch is not active, but should" R"Cannot change tool"
	T-1 P0
	abort

; set speed and axes limits for this new tool
M98 P"/macros/Speeds/set_speed.g" L"lightTool"       ; set speeds, jerk and accel. for light weight bowden tool
M98 P"/macros/Boundaries/V6-and-Volcano.g"           ; set new limits for this tool

;wait for all movement to stop
M400

; check if toolDetectSwitch is inactive, if so:abort
if sensors.gpIn[5] == null || sensors.gpIn[5].value == 0
	M291 T5 P"toolDetectSwitch is not active, but should" R"Cannot change tool"
	T-1 P0
	abort

; apply new min limit for z axis so we cannot crash into bed
M208 S1 Z{-tools[state.nextTool].offsets[2]}