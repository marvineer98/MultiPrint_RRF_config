; File "0:/gcodes/Rene_pic_v1_post.g" resume print after print paused at 2023-07-30 11:44
G21
G29 S1
G92 X2.708 Y32.330 Z-16.000 B0.000 C40.000
G60 S1
G10 P0 S0 R0
G10 P1 S0 R0
G10 P2 S0 R0
T4 P0
M98 P"resurrect-prologue.g"
M116
M290 X0.000 Y0.000 Z0.000 B0.000 C0.000 R0
T-1 P0
T4 P6
; Workplace coordinates
G10 L2 P1 X0.00 Y0.00 Z0.00 B0.00 C0.00
G10 L2 P2 X0.00 Y0.00 Z0.00 B0.00 C0.00
G10 L2 P3 X0.00 Y0.00 Z0.00 B0.00 C0.00
G10 L2 P4 X0.00 Y0.00 Z0.00 B0.00 C0.00
G10 L2 P5 X0.00 Y0.00 Z0.00 B0.00 C0.00
G10 L2 P6 X0.00 Y0.00 Z0.00 B0.00 C0.00
G10 L2 P7 X0.00 Y0.00 Z0.00 B0.00 C0.00
G10 L2 P8 X0.00 Y0.00 Z0.00 B0.00 C0.00
G10 L2 P9 X0.00 Y0.00 Z0.00 B0.00 C0.00
G54
M106 S0.00
M106 P0 S0.00
M106 P2 S0.00
M106 P4 S0.00
M106 P6 S0.50
M116
G92 E0.00000
M83
G94
M486 S-1
G17
M23 "0:/gcodes/Rene_pic_v1_post.g"
M26 S33717
G0 F6000 Z7.000
G0 F6000 X2.708 Y-17.670 B0.000 C40.000
G0 F6000 Z5.000
G1 F6000.0 P0
G21
M24