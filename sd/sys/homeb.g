; homeb.g
; called to home the B axis (Brush)

G91
M400                        ; make sure everything has stopped before we change the motor currents
M913 B40                    ; drop motor currents to 50%

G1 H1 B-25 F1000            ; move quickly to B axis endstop and stop there (first pass)
G0 B2                       ; go back a few mm
G1 H1 B-5 F300              ; move slowly to B axis endstop once more (second pass)

M400                        ; make sure everything has stopped before we change the motor currents
M913 B100                   ; reset motor currents to 100%
G90