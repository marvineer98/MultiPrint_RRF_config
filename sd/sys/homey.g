; homey.g
; called to home the Y axis
; can be called with Parameter S: Do not lift z (because it is lifted in the macro we are coming from already)

;abort if a tool is selected
if {sensors.gpIn[5] != null && sensors.gpIn[5].value = 1}
	M291 T5 P"Please return active tool to dock before homing" R"Cannot home"
	abort "Cannot home - Please return active tool to dock before homing"

if {!exists(param.S)}
	G91
	G0 H4 Z5   			    ; lift Z relative to current position
	G90

G91               			; relative positioning
M400 				        ; make sure everything has stopped before we change the motor currents
M913 X20 Y20 		        ; drop motor currents to 20%
G1 H2 X2 Y2 F1800           ; move in x so that the endstop is free to pass (individual motor mode)
G1 H1 Y-282 F1800           ; move quickly to Y axis endstop and stop there (first pass)
G0 Y2                       ; go back a few mm
G1 H1 Y-4 F300              ; move slowly to Y axis endstop once more (second pass)
G90               			; absolute positioning

if {!exists(param.S) && move.axes[2].homed}
	G91
	G0 Z-5                  ; lower Z again
	G90

M400 						; make sure everything has stopped before we reset the motor currents
M913 X100 Y100 				; motor currents back to 100%