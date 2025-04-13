; /macros/Filament/unload.g
; macro for unloading generic filaments from active tool
; is called in each filament unload script
; Parameter R: filaments standby temp

; abort if no standby temp was given
if {!exists(param.R)} | param.R < 0 | param.R > 200
	M291 T5 P"standby temp not provided or out of bound for filament unloading" R"error"
	abort "standby temp not provided or out of bound for filament unloading"

if state.currentTool == -1
	abort "no tool selected for filament unload"

; set current tools heater to standby
M568 R{param.R} A1

; Wait for the temperatures to be reached within 10C
M116 P{state.currentTool} S10

M291 P"Press ok to start feeding filament... Make sure to spin the spool manually" R"Unload Filament" S3 ; Display new message

; Extruder to relative mode
M83
G1 E-10 F300			; Retract 10 mm of filament at 300mm/min
G1 E-20 F600			; Retract 20 mm of filament at 600mm/min

if state.currentTool < 2
	G1 E-700 F3000			; Retract 500 mm of filament at 3000mm/min
	G1 E-100 F1200			; Retract 100 mm of filament at 1200mm/min
	G1 E-100 F600			; Retract 50 mm of filament at 600mm/min

M568 S0 R0 A0 			; turn off heater and set active and standby temp to 0C

T-1
