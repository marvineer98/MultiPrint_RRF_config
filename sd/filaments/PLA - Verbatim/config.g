;NonLinear Extrusion 
;M92 E433.5 ;Adjusted for optimal curve fitting
;M592 D0 A-0.00051 B0.00061 ;Nonlinear Extrusion parameters
;M221 S101		;Flow(Diameter Compensation)

M302 S160 R90				    ; set limits for cold extrusion (Allow extrusion starting from 160°C and retractions already from 90°C)

; activate current tools heater if tool is selected and file printed - also set bed according to what this filament needs
if state.currentTool != -1 && state.status == "processing"
	M568 S200 R100 A2
	M140 S60 R40

	; turn on HEPA Filer
	M106 P6 S0.5

; set settings for firmware retraction
if state.currentTool == 0
	M207 P0 S4 F2600 T1200 Z1.25
elif state.currentTool == 1
	M207 P1 S5 F3000 T1400 Z0.25
elif state.currentTool == 2
	M207 P2 S0.8 F2200 T1100 Z0.25

M99

; code for filament weight scale
var SpoolWeight = 240           ; spool weight in g (empty spool)
	
if state.currentTool == 0
	set global.FilamentScaleT0SpoolWeight = var.SpoolWeight
		
if state.currentTool == 1
	set global.FilamentScaleT1SpoolWeight = var.SpoolWeight
	
if state.currentTool == 2
	set global.FilamentScaleT2SpoolWeight = var.SpoolWeight
