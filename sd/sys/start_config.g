; start_config.g
; handels start parameter of a print from slicer
; must be called with Parameter S: Initial Extruder for active print

; call this in slicer start code via:
; M98 P"start_config.g" S{initial_tool}

; abort if no initial extruder was given or the extruder num is not valid
if {!exists(param.S)} | param.S < 0 | param.S > 2
	abort "error - initial extruder not provided or value out of bound"

; abort if no print is running currently
if state.status != "processing" && state.status != "simulating"
	abort "lol error - start_config is only allowed in status processing or simulating"

; save first extruder
var initial_tool = param.S

; abort if tool has no filament loaded
if move.extruders[tools[var.initial_tool].filamentExtruder].filament == ""
	; TODO: ask user if he wants to load a filament
	abort "error - initial extruder has no filament loaded"

; switch to first tool without any macros running, save current tool before
var current_tool = state.currentTool
T{var.initial_tool} P0

; load filament and temps for first tool, this allready heats up the printer
M703

; switch back to current tool without any macros running
T{var.current_tool} P0

; make first extruder active again
M568 P{var.initial_tool} A2

; send absolute coordinates...
G90
; ...but relative extruder moves
M83

; home the printer
G28

; Bed compensation gets enabled
M98 P"/macros/Heightmap/loadBestFit.g"

; we wait in tpost for temp of current tool
;M116 S8
