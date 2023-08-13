;this macro sets the brush to the height needed by the active tool
;if no tool is selected this macro drives the brush to B0 (home pos)

;if no tool or the wrong tool is active, drive to B0
if  state.currentTool == -1 | state.currentTool > 1
	G90
	G1 B0 F1000
	M99

; if there is a supported tool active --> set brush to the right height
G90
var brushZVal = 19.5
G1 B{(var.brushZVal - 2) + tools[state.currentTool].offsets[2]} F1000 ; set brush to travel height (so the tool can move over the brush)