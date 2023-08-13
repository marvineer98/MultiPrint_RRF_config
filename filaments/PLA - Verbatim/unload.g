; Set current tool standby temperature to 100C
M568 R100 A1

; start unloading filament
M98 P"/macros/Filament/unload.g"
