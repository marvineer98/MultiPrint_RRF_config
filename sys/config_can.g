; here we define all that is connected to a can board
; can be called with parameter B: Board to configure
; if not provided, all boards will be configured

; Lights
M950 P0 C"1.out1" Q500
M98 P"/macros/Light-Control/MainLight_ON.g"

M950 P1 C"1.out0" Q500
;M98 P"/macros/Light-Control/HeadLight_toggle.g"