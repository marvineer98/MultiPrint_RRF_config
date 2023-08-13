; start.g
; called automatically before every print

;abort if power is not present
if state.atxPower == false
	M291 P"CAN connected boards are not responding. Reset Machine and start again!" R"No Power on CAN" S1 ; Display new message
	M300
	abort

;abort if allready printing
; if state.status == "processing" || state.status == "paused" || state.status == "pausing"
; 	M291 P"Print is allready running. Aborting!" R"Allready printing" S1 ; Display new message
; 	M300
; 	M99

;turn on PSU (stop timer to turn off after cool down)
M80

;turn on HEPA filter fan
; TODO: make this a parameter of currently loaded filament (therfore move this in slicer start gcode) 
M106 P6 S0.5
