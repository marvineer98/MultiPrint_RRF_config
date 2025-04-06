; start.g
; called automatically before every print

;abort if power is not present
if state.atxPower == false
	M291 P"CAN connected boards are not responding. Reset Machine and start again!" R"No Power on CAN" S1 ; Display new message
	M300
	abort "No Power on CAN - CAN connected boards are not responding. Reset Machine and start again!"

;turn on PSU (stop timer to turn off after cool down)
M80

; set light on
if sensors.gpIn[6].value == 1
	; door is closed
	M98 P"/macros/Lights/set.g" D"main" B0.75                           ; turn on main light
else
	M98 P"/macros/Lights/set.g" D"main" B0.05
