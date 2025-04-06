M98 P"homeall.g" L"highEnd"             ; Home all axes (Z to highEnd stop, not probe)
M116                                    ; wait for temperatures
M83                                     ; relative extrusion
G1 E4 F3600                             ; undo the retraction that was done in the M911 power fail script
