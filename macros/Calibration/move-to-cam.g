; abort if axes are not homed: 0:X 1:Y 2:Z 4:C
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
	M291 T5 P"Please home axes before any movement" R"Cannot move to camera"
	abort

if state.status != "processing"
	var camX = 161.37
	var camY = 79.44
	var camZ = 1
	
	if exists(param.S)
		if {param.S >= -1 && param.S <= 2}
			T{param.S}
		else
			M117 "abort move-to-cam, wrong Tool-Parameter P"
			M99

	if {abs(move.axes[0].userPosition - var.camX) > 1 || abs(move.axes[1].userPosition - var.camY) > 1 || abs(move.axes[2].userPosition - var.camZ) > 1}
		; lift Z relative to current position
		G91
		G1 H4 Z5 F1200
		G90
	
	;Move to CAM
	G90
	G1 X{var.camX - 1} Y{var.camY - 1} F40000
	G1 X{var.camX} Y{var.camY} F2000
	G1 Z{var.camZ}
