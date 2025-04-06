; Bed Mesh Leveling

;home Z to have a initial Z datum
G28 Z

; do the mesh bed leveling according to the M557 in config.g and enable it
G29 S0
; save the result according to current bed active temp
G29 S3 P{"heightmap_"^floor(heat.heaters[0].active)^".csv"}

; relative positioning
G91
; lift Z relative to current position
G0 H4 Z5
; absolute positioning		              
G90

; move Head to Home Position if position is defined
if {exists(global.IdlePos_X) && exists(global.IdlePos_Y)}
	G0 X{global.IdlePos_X} Y{global.IdlePos_Y} F40000  ; move out of way