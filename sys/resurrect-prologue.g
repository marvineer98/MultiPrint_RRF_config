;G28 B C X Y           ; home X and Y, hope that Z hasn't moved

M98 P"homec.g"                                     ; Home C (ToolHead)

M98 P"homeb.g"                                     ; Home B (Brush)

M98 P"homex.g" S"ZisLifted"                        ; Home X and y

if {!exists(param.S) && exists(global.IdlePos_X) && exists(global.IdlePos_Y)}
	G1 X{global.IdlePos_X} Y{global.IdlePos_Y} F40000 ; move out of way
	
M98 P"homez.g" L"highEnd"                          ; Home Z to its high End 

M116                                               ; wait for temperatures
M83                                                ; relative extrusion
G1 E4 F3600                                        ; undo the retraction that was done in the M911 power fail script