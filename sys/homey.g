; homey.g
; called to home the Y axis
; can be called with Parameter S: Do not lift z (because it is lifted in the macro we are coming from already)

;abort if a tool is selected
if {sensors.gpIn[5] != null && sensors.gpIn[5].value = 1}
	M291 T5 P"Please return active tool to dock before homing" R"Cannot home"
	abort

if {!exists(param.S)}
	G91
	G1 H4 Z5 F1200   			    ; lift Z relative to current position
	G90

G91               			; relative positioning
M400 				        ; make sure everything has stopped before we change the motor currents
M913 X20 Y20 		        ; drop motor currents to 20%
G1 H2 X2 F1800              ; move x so that the endstop is free to pass
G1 H1 Y-282 F1800 			; move quickly to Y axis endstop and stop there (first pass)
G1 Y2 F1000       			; go back a few mm
G1 H1 Y-5 F300    			; move slowly to Y axis endstop once more (second pass)

if {!sensors.endstops[1].triggered}
	abort

G90               			; absolute positioning

if {!exists(param.S) && move.axes[2].homed}
	G91
	G1 Z-5 F1200            ; lower Z again
	G90

M400 						; make sure everything has stopped before we reset the motor currents
M913 X100 Y100 				; motor currents back to 100%