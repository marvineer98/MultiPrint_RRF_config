; homeall.g
; called to home all axes
; can be called with Parameter S: Do not move out of way after homing z
; can be called with parameter L: home Z to max endstop instead

M98 P"homec.g"                             ; home C (ToolHead)

;abort if a tool is selected or there is a tool active
if {sensors.gpIn[5] == null || sensors.gpIn[5].value = 1 || state.currentTool != -1}
	abort

M98 P"homeb.g"                             ; home B (Brush)

G91
G0 H4 Z5                                   ; lift Z relative to current position
G90

M98 P"homex.g" S"ZisLifted"   		       ; home X and y

if {exists(param.L)}                       ; home to high End if seen L
	M98 P"homez.g" L"highEnd" S"ZisLifted" ; home Z with max end stop (part on bed)
else
	M98 P"homez.g" S"ZisLifted"	           ; home Z with probe (normal start)
	
if {!exists(param.S)}
	M98 P"/macros/Movement/move-to-home.g" S"DoNotLiftZ"
