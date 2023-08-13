;called to set the right speed, acceleration and jerk settings
;can be called with parameter S: startup --> check toolDetectSwitch to set speeds lower if tool is loaded at startup
;can be called with parameter L: Tool Presets --> determins wich speed value we should be using
;can be called with parameter V: verbose output --> echo out the variables (debug)

if exists(param.S) ; called in config.g
	;if there is a tool mounted
	if sensors.gpIn[5] == null || sensors.gpIn[5].value == 1
		; there is a tool, we assume its the heviest we have
		M98 P"/macros/Speeds/set_speed.g" L"spindleTool"
	else
		; there is no tool so we can set the speeds high
		M98 P"/macros/Speeds/set_speed.g"
else
	; no active tool --> high speeds
	var speed = 40000
	var xaccel = 6000
	var yaccel = 5400
	var xjerk = 450
	var yjerk = 405
	
	if exists(param.L)
		if param.L == "lightTool" ; light tool like V6 Bowden --> medium speeds
			set var.speed = 35000
			set var.xaccel = 5000
			set var.yaccel = 4500
			set var.xjerk = 450
			set var.yjerk = 405
		elif param.L == "heavyTool" ; heavy tool like Hemera Direct --> slow speeds
			set var.speed = 25000
			set var.xaccel = 3500
			set var.yaccel = 3150
			set var.xjerk = 250
			set var.yjerk = 225
		else ; spindle tool --> very slow speeds
			set var.speed = 10000
			set var.xaccel = 2500
			set var.yaccel = 2150
			set var.xjerk = 150
			set var.yjerk = 125
	
	;if door is open reduce max speed always
	set var.speed = sensors.gpIn[6].value == 1 ? 8000 : var.speed 
	
	if exists(param.V) ; echo out all values
		echo "speed X and Y: ", {var.speed}
		echo "accel X: ", {var.xaccel}
		echo "accel Y: ", {var.yaccel}
		echo "jerk X: ", {var.xjerk}
		echo "jerk Y: ", {var.yjerk}
	
	; write vars to the corresponding M-Code
	M203 X{var.speed} Y{var.speed}
	M201 X{var.xaccel} Y{var.yaccel}
	M566 X{var.xjerk} Y{var.yjerk}
