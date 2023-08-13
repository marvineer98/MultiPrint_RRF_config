; pause.g
; called when a print from SD card is paused

G10          ; retract filament

; set tool to standby temp
if state.currentTool >= 0
	M568 A1

; set bed to standby temp
M144

; move platform out of the way
if {move.axes[2].machinePosition < 90 && move.axes[2].homed}
	G90
	G0 Z90 F1200                                       ; move bed to conveniently get to the plate
else
	G91               	                               ; relative positioning
	G1 H4 Z5 F1200    		                           ; lift Z relative to current position
	G90

if state.currentTool == 0 || state.currentTool == 1
	M98 P"/macros/Brush/wipe_activeTool.g" S"ZisLifted"

M98 P"/macros/Movement/move-to-home.g" S"DoNotLiftZ"   ; put current tool away and move to home position

;turn down HEPA filter fan
M106 P6 S0.3
