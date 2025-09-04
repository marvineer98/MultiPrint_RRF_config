; call this to set the rgb LED strip to a given color or call this without params to turn off all LEDs
; can be called with parameter T: tool number that lights should be controlled, all if permitted (0 ... 3)
; can be called with parameter B: Power the given light is set to, 0 if permitted (0 ... 255)
; can be called with parameter C: Color, the lights should be set to, "black" if permitted (white, red, green, blue)

; set LEDs color
var color = {0,0,0}
if {exists(param.C)}
    if param.C == "white"
        set var.color = {255, 255, 255}
    if param.C == "red"
        set var.color = {255, 0, 0}
    if param.C == "green"
        set var.color = {0, 255, 0}
    if param.C == "blue"
        set var.color = {0, 0, 255}

; power factor
var power = 0
if {exists(param.B)}
    set var.power = param.B

;set the light according to user
M150 E0 R{var.color[0]} U{var.color[1]} B{var.color[2]} P{var.power} S{global.numLEDs}
;M150 E0 R255 U255 B255 P255 S18