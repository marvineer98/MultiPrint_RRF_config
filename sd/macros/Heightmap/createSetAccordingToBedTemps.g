; create best fit heightmap for each temp in global array
while iterations < #global.heightmapTemps
    M140 S{global.heightmapTemps[iterations]}
    M116 H0       ; wait for target temp
    G4 S120       ; wait some more to let temp settle
    G32           ; start creation of mesh for this temp

; switch off bed heater and reset active and standby temps
M140 S0 R0
M140 S-273.1
