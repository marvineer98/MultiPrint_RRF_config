; stop.g
; called when M0 (Stop) is run (e.g. when a print from SD card is finished)
; can be called with parameter S: do not turn off power after thermostatic fan turns off

; Fans off
M106 S0
; HEPA Filter fan off
M106 P6 S0

; Disable bed compensation
G29 S2

; turn off tools
M568 P0 S0 R0 A0
M568 P1 S0 R0 A0
M568 P2 S0 R0 A0

; switch off bed heater and reset active and standby temps
M140 S0 R0
M140 S-273.1

if {move.axes[2].machinePosition < 90 && move.axes[2].homed}
	G90
	G0 Z90 F1200                                       ; move bed to conveniently get to the plate
elif {state.currentTool != -1}
	G91               	                               ; relative positioning
	G1 H4 Z5 F1200    		                           ; lift Z relative to current position
	G90

if state.currentTool >= 0
	M98 P"/macros/Brush/wipe_activeTool.g"

; put current tool away and move to home position
M98 P"/macros/Movement/move-to-home.g"

; turn off tools ones more
M568 P0 A0
M568 P1 A0
M568 P2 A0

; disable following features
M99 ; end macro and return

if {!exists(param.S)}
	; Motors off
	M84

	; BEEP
	M300 P200                                              

	; turn off all Lights
	M98 P"/macros/Lights/set.g"
	
	; turn power off when all thermostatic fans have turned off
	M81 S1
