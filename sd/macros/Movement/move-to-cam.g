; macro to move the given tool to the camera for measurement of the X/Y tool offsets
; must be called with parameter S: Tool number 

; abort if axes are not homed: 0:X 1:Y 2:Z 4:C
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
	abort "Please home axes before any movement"

if state.status != "processing"
	var camX = global.cam_positions[0]
	var camY = global.cam_positions[1]
	var camZ = global.cam_positions[2]
	
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
