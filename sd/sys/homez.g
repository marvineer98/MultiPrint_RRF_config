; homez.g
; called to home the Z axis
; can be called with parameter S: do not lift z befor traveling to probe position
; can be called with parameter L: home Z to max endstop instead

; abort if x or y axes are not homed: 0:X 1:Y 2:Z 4:C
if {!move.axes[0].homed || !move.axes[1].homed}
	M291 T5 P"Please home axes x and y before homing z" R"Cannot home"
	abort "Cannot home - Please home axes x and y before homing z"

; we need to home Z to the max endstop
if {exists(param.L)}
	G91                 ; relative positioning
	M400                ; make sure everything has stopped before we change the motor currents
	M913 Z60            ; drop motor currents to 60%
	G1 H1 Z270 F600     ; move quickly to Z axis endstop and stop there (first pass)
	G1 Z-1 F600         ; go back a few mm
	G1 H1 Z4 F300       ; move slowly to Z axis endstop once more (second pass)
    ; check if endstop is triggered
	if {!sensors.endstops[2].triggered}
		abort "z max end stop not triggered, but should"
	G90                 ; back to absolute positioning
else
; we home z with the standard probe
    ;abort if a tool is selected
	if {(sensors.gpIn[5] != null && sensors.gpIn[5].value = 1) || state.currentTool != -1}
		M291 T5 P"Please return active tool to dock before homing" R"Cannot home"
		abort "Cannot home - Please return active tool to dock before homing"
    ; if Z is not lowerd already
	if {!exists(param.S)}
		G91
		G0 H4 Z5       ; Lower the bed
		G90            ; back to absolute positioning
	G90
	G0 X0 Y0 F40000    ; Position the endstop above the bed centre
	M400               ; make sure everything has stopped before we change the motor currents
	M913 Z60           ; drop motor currents to 60%
	G30                ; Probe the bed
	M400               ; make sure everything has stopped before we change the motor currents
	M913 Z100          ; reset motor currents
	G0 Z5              ; Lower the bed to absolute Z5