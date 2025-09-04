;called to wipe the active tool with the brush
; can be called with Parameter S: Do not lift z (because it is lifted in the macro we are coming from already)


if state.currentTool == -1 | state.currentTool == 4
	M291 T5 P"No or wrong Tool to brush" R"Cannot wipe nozzle"
	M99
	
; abort if axes are not homed: 0:X 1:Y 2:Z 3:B
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed || !move.axes[3].homed
	M291 T5 P"Nozzle can`t be brushed - home all axes" R"Cannot wipe nozzle"
	M99
	
elif state.currentTool <= 1
	if !exists(param.S)
		G91
		G1 H2 Z5    			    ; lift Z relative to current position
		G90
	
	var startPointX = -177
	var startPointY = 15
	
	var brushHeight = 45 
	var brushWidth = 17
	var teiler = 5 ; es wird gerechnet: height mod teiler --> Anzahl der Richtungswechsel (Beispiel: Height: 45; teiler = 5; Ergibt: 9 Segmente entlang der Höhe)
	var brushZVal = 19.5
	
	G90
	M98 P"/macros/Brush/setHeightToActiveTool.g" ; set brush to travel height (so the tool can move over the brush, depends on tool-z-offset)
	G0 X{var.startPointX - 10} Y{var.startPointY} F40000
	G91
	G1 B2 F1000 ; set brush to the correct height (2 mm travel height is set in /Macros/brush/setHeightToActiveTool.g)
	G90
	G1 X{var.startPointX} F3000
	G91
	
	;brush in
	G1 Y{var.brushHeight + 2} F3500
	
	G1 Y{-1 * var.teiler}
	G1 X{var.brushWidth / 2}
	G1 Y{-1 * var.teiler}
	G1 X{-1 * var.brushWidth}
	G1 Y{-1 * var.teiler}
	G1 X{var.brushWidth}
	G1 Y{-1 * var.teiler}
	G1 X{-1 * var.brushWidth}
	G1 Y{-1 * var.teiler}
	G1 X{var.brushWidth}
	G1 Y{-1 * var.teiler}
	G1 X{-1 * var.brushWidth}
	G1 Y{-1 * var.teiler}
	G1 X{var.brushWidth}
	G1 Y{-1 * var.teiler}
	G1 X{-1 * var.brushWidth / 3}
	G1 Y{-1 * var.teiler - 5}
	
	;brush out
	G1 Y{var.brushHeight + 2} F3500
	
	G91
	G1 B-2 F1000 ; set brush to the trevel height again
	G90
	
	if !exists(param.S)
		G91
		G1 H2 Z-5  	    ; lower Z again
		G90
	
elif state.currentTool > 1
	;the active tool is not supported yet
	M99