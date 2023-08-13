; homez.g
; called to home the Z axis
; can be called with parameter S: do not lift z befor traveling to probe position
; can be called with parameter L: home Z to max endstop instead

;  we need to home Z to the max endstop
if {exists(param.L)}
	; relative positioning
	G91
	; make sure everything has stopped before we change the motor currents
	M400
	; drop motor currents to 60%
	M913 Z60
	; move quickly to Z axis endstop and stop there (first pass)
	G1 H1 Z270 F600
	; go back a few mm
	G1 Z-2 F600
	; move slowly to Z axis endstop once more (second pass)
	G1 H1 Z5 F300
	
	; check if endstop is triggered
	if {!sensors.endstops[2].triggered}
		abort
	
	; back to absolute positioning
	G90
	; exit macro as we are done homing to max endstop
	M99

; --------------------------------------
; we home z with the standard probe

;abort if a tool is selected
if {(sensors.gpIn[5] != null && sensors.gpIn[5].value = 1) || state.currentTool != -1}
	M291 T5 P"Please return active tool to dock before homing" R"Cannot home"
	abort

; if Z is not lowerd allready
if {!exists(param.S)}
	G91
	G1 H4 Z5 F1200                 ; Lower the bed
	G90                            ; back to absolute positioning

G90
G1 X0 Y0 F40000                    ; Position the endstop above the bed centre

M400 				               ; make sure everything has stopped before we change the motor currents
M913 Z60 		                   ; drop motor currents to 60%

G30                                ; Probe the bed

M400 				               ; make sure everything has stopped before we change the motor currents
M913 Z100 		                   ; reset motor currents

; load height map if printing
; TODO: Load right map according to bed temp
if {state.status == "processing"}
	G29 S1

G1 Z5 F1200                        ; Lower the bed to absolute Z5

