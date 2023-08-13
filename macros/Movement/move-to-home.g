; move print head to home position
;can be called with parameter S: Do not lift z
;can be called with parameter R: Move Z to home too
var Zlift = !exists(param.S)

if state.status != "processing"
	if {exists(global.IdlePos_X) && exists(global.IdlePos_Y) && exists(global.IdlePos_Z)}
	
		; abort if axes are not homed: 0:X 1:Y 2:Z 4:C
		if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
			M291 T5 P"Please home axes before any movement" R"Cannot move to home"
			abort
		
		if state.currentTool != -1
			T-1
			set var.Zlift = false
		
		if var.Zlift
			if {abs(move.axes[0].userPosition - global.IdlePos_X) > 1 || abs(move.axes[1].userPosition - global.IdlePos_Y) > 1}
				G91
				G1 H4 Z5 F1200   			                  ; lift Z relative to current position
				G90
			
		G1 X{global.IdlePos_X} Y{global.IdlePos_Y} F40000     ; move out of way
		
		if {exists(param.R)}
			G1 Z{global.IdlePos_Z} F1200                      ; move Z out of way
