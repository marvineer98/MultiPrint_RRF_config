; resume.g
; called before a print from SD card is resumed
;
; generated by RepRapFirmware Configuration Tool v3.2.3 on Sun Apr 04 2021 16:43:44 GMT+0200 (Mitteleuropäische Sommerzeit)

; set temperature for the last used tool to active temp
M568 P{state.previousTool} A2

; set bed to active temp again
M144 S1

; select last active tool
T{state.previousTool}

;turn on HEPA filter fan
if state.previousTool < 4
	if move.extruders[tools[state.previousTool].filamentExtruder].filament = "PET - Innofil"
		M106 P6 S0.75
	elif state.previousTool != 4
		M106 P6 S0.5

; restore last fan speed
M106 R1

; wait for all temps
M116 S5

; relative extruder move: extrude 1.25 mm of filament
M83
G1 E1.25 F1500

; brush current tool
M98 P"/macros/Brush/wipe_activeTool.g"

; go to 5mm above position of the last print move and then to the position
G1 R1 X0 Y0 Z5 F12000
G1 R1 X0 Y0

;unrectract filament
G11
