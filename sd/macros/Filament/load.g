; /macros/Filament/load.g
; macro for loading generic filaments into active tool
; is called in each filament load script

M568 A2					; activate current tools heater
M116 P{state.currentTool} S30       ; Wait for the temperatures to be reached within 30C margin

M291 P"Press ok to start feeding filament..." R"Load Filament" S3 ; Display new message

; Extruder to relative mode
M83

G1 E10 F300				; Feed 10 mm of filament at 300mm/min

if state.currentTool < 2
	G1 E20 F600				; Feed 20 mm of filament at 600mm/min
	G1 E700 F3000			; Feed 500 mm of filament at 3000mm/min
	G1 E100 F1000			; Feed 100 mm of filament at 1000mm/min

M116 P{state.currentTool} S5 ; Wait for the temperatures to be reached

G1 E33 F300				; Feed additional 33 mm of filament at 300mm/min

G4 P1000				; Wait one second

if state.currentTool < 2
	G1 E-5 F1200 			; Retract 5 mm of filament at 1200mm/min
else
	G1 E-1 F1000 			; Retract 1 mm of filament at 1000mm/min
M400					; Wait for moves to complete


;wipe nozzle of active tool
M98 P"/macros/Brush/wipe_activeTool.g" S"ZisLifted"

M568 A0 				; turn heater off

; custom G-Code: setup filament weight scale (call M610.g in sys folder)
M610 S{state.currentTool}