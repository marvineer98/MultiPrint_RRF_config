; tfree4.g
; called when the pen tool is freed
; use state.previousTool to determine witch tool was freed

; abort if axes are not homed: 0:X 1:Y 2:Z 4:C
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed || !move.axes[4].homed
	M291 T5 P"Please home axes before a toolchange" R"Cannot change tool"
	abort

; check if toolDetectSwitch is not active, if not:abort
if sensors.gpIn[5] == null || sensors.gpIn[5].value == 0
	M291 T5 P"toolDetectSwitch is not active, but should" R"Cannot change tool"
	abort
	
; free out of heat wait loop
M108

G91
G0 H4 Z{-tools[state.nextTool].offsets[2] + 5}       ; drop the bed
G90


G53 G1 X-50 Y-100 F40000                             ; move to location

; wait for the user
; TODO: Wrap around while loop to be certan (check against tool detect switch)
M291 R"Manual tool change" P"Please remove Tool 4 from the ToolHead" S3

M98 P"/macros/Coupler/unlock.g"                      ; open coupler


;wait for all movements to stop and sync movement queues
M400

; check if toolDetectSwitch is active, if so: abort
if {sensors.gpIn[5] == null || sensors.gpIn[5].value == 1}
	M291 T5 P"toolDetectSwitch is active, but should not" R"Cannot change tool"
	T-1 P0
	abort

; set speeds, jerk and accel. for no active tool
M98 P"/macros/Speeds/set_speed.g"

; reset X and Y limits
M98 P"/macros/Boundaries/ToolHead.g"
; reset Z min limit
M208 S1 Z0