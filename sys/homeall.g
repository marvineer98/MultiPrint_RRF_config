; homeall.g
; called to home all axes
; can be called with Parameter S: Do not move out of way after homing z
; can be called with parameter L: home Z to max endstop instead

M98 P"homec.g"                      ; home C (ToolHead)

;if we get here, there is no tool selected or the tool was removed manually, so its save to assume the probe is free
M98 P"homeb.g"                      ; home B (Brush)

G91
G1 H4 Z5 F1200   			        ; lift Z relative to current position
G90

M98 P"homex.g" S"ZisLifted"   		; home X and y

if {exists(param.L)} ;home to high End if seen L
	if {!exists(param.S)}
		M98 P"/macros/Movement/move-to-home.g" P"moveZ" S"DoNotLiftZ"
	
	M98 P"homez.g" L"highEnd"           ; home Z
else
	M98 P"homez.g" S"ZisLifted"			; home Z
	
	if {!exists(param.S)}
		M98 P"/macros/Movement/move-to-home.g" P"moveZ" S"DoNotLiftZ"
