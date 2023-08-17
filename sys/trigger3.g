; trigger3.g - door closed
; trigger on falling edge of door sensor

; limit max speed according to tool
if state.currentTool == -1
	M203 X40000 Y40000
elif state.currentTool <= 1
	M203 X35000 Y35000
elif state.currentTool == 2
	M203 X25000 Y25000
elif state.currentTool == 4
	M203 X35000 Y35000
else
	M203 X10000 Y10000

; led dimm
M98 P"/macros/Lights/set.g" D"main" B0.05

;M118 S"Door closed"
