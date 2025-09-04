; move print head to home position
;can be called with parameter S: Do not lift z
;can be called with parameter L: Move Z to home too
var Zlift = !exists(param.S)

if {exists(global.IdlePos) && #global.IdlePos > 2}

	; abort if axes are not homed: 0:X 1:Y 2:Z 4:C
	if {!move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed}
		M291 T5 P"Please home axes before any movement" R"Cannot move to home"
		abort "Please home axes before any movement"
	
	if {state.currentTool != -1}
		T-1
		set var.Zlift = false
	
	if var.Zlift
		if {abs(move.axes[0].userPosition - global.IdlePos[0]) > 1 || abs(move.axes[1].userPosition - global.IdlePos[1]) > 1}
			G91
			G1 H4 Z5 F1200   			                  ; lift Z relative to current position
			G90
		
	G0 X{global.IdlePos[0]} Y{global.IdlePos[1]} F40000     ; move out of way
	
	if {exists(param.L)}
		G1 Z{global.IdlePos[3]} F1200                      ; move Z out of way
