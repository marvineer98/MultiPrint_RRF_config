; homec.g
; called to home the C axis (Coupler)
var waitTimeSeconds = 0

;abort if a tool is selected or there is a tool active
if {sensors.gpIn[5] == null || sensors.gpIn[5].value = 1 || state.currentTool != -1}
	M291 P"Please hold active tool tight. Otherwise it will fall off the mount!" R"Attention needed" S3
	set var.waitTimeSeconds = 4
	T-1 P0
	M98 P"/macros/Speeds/set_speed.g"       ; set speeds, jerk and accel. for no active tool
	M98 P"/macros/Boundaries/ToolHead.g"    ; reset limits
	M564 S1								    ; apply the normal limits

G91
M400
M913 C70					; C MOTOR TO 60% CURRENT
G1 H2 C-500 F5000
G92 C-45
G90
M913 C100					;  C MOTOR TO 100% CURRENT

;Open Coupler
M98 P"/macros/Coupler/unlock.g"

if var.waitTimeSeconds > 0
	G4 S{var.waitTimeSeconds}