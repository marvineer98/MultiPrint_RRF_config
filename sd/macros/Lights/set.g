; call this to set any light to a given value or call this to turn off all lights
; can be called with parameter D: String of the device (light) you want to control ("main", "head"), all if permitted
; can be called with parameter B: Power the given light is set to, 0 if permitted

; create var for power and check input for out of bound
var power = 0
if exists(param.B) && param.B >= 0 && param.B <= 1
    set var.power = param.B

; set each light accordingly
if !exists(param.D) || param.D == "main"
    M42 P0 S{var.power}

if !exists(param.D) || param.D == "head"
    M42 P1 S{var.power}
