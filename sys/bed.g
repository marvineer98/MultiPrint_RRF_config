; Bed Mesh Leveling

;home Z to have a initial Z datum
G28 Z

; do the mesh bed leveling according to the M557 in config.g
G29

; disable mesh leveling
; gets anabled in the slicer start gcode and disabled again in stop.g
G29 S2

; relative positioning
G91
; lift Z relative to current position
G1 H4 Z5 F1200
; absolute positioning		              
G90

; move Head to Home Position if position is defined
if {exists(global.IdlePos_X) && exists(global.IdlePos_Y)}
	G1 X{global.IdlePos_X} Y{global.IdlePos_Y} F40000  ; move out of way