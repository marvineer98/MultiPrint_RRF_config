; tpost.g
; called after a tool has been selected
; use state.currentTool to determine witch tool was selected

; set filament parameters
; this sets temps and other related settings for specific loaded filament
M703
; wait for heat up on active tool only
M116 P{state.currentTool}

; unretract
G11

;prime nozzle
M98 P"/macros/Brush/setHeightToActiveTool.g"

if state.status = "processing"
	M98 P"/macros/Brush/wipe_activeTool.g" S"ZisLifted"

M106 R1	; restore print cooling fan speed
