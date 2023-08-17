; trigger2.g - door opened
; trigger on rising edge of door sensor

; limit max speed
M203 X8000 Y8000

; led bright
M98 P"/macros/Lights/set.g" D"main" B0.75

;M118 S"Door opened"
