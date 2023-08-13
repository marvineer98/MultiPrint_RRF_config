; this is for measuring weight scales
; can be called with parameter S: Number of the tool the user wants to messure - standard: all
; can be called with parameter P: Verbose output (and debug info) - standard: off

;check if inputs are correct - if not: use standard behaviour for nested call
if (!exists(param.S) || param.S < 0 || param.S > 2)
	if {exists(param.P)}
		M610 S0 P"verbose"
		M610 S1 P"verbose"
		M610 S2 P"verbose"
	else
		M610 S0
		M610 S1
		M610 S2
	M99

; start messuring weight of the given tool sensor (param.S)
; add common offet to sensor number (T0: 8; T1: 9; T2: 10) --> 8 + param.S
var currentSensorNumber = 8 + param.S

; set spool weight according to loaded filament (in gram)
if move.extruders[param.S].filament == "PLA - Verbatim"
	var currentSpoolWeight = 240
elif move.extruders[param.S].filament == "PET - Innofil"
	var currentSpoolWeight = 200
else
	var currentSpoolWeight = 240


; create array to store n messurements
var n = 10
var readings = vector(var.n, 0.)

; output info
if {exists(param.P)}
	echo "load cell of Tool",param.S, "at sensor", var.currentSensorNumber, "will be read."

; iterate to save all n readings in array and build up a sum of all readings
var r_sum = 0
while (iterations < var.n)
	; output info
	if {exists(param.P)}
		echo "Measurement", iterations, "=", sensors.analog[var.currentSensorNumber].lastReading
	; get reading
	set var.readings[iterations] = sensors.analog[var.currentSensorNumber].lastReading
	; add value to sum
	set var.r_sum = var.r_sum + var.readings[iterations]
	; little delay to let rrf update the sensor
	G4 P5

; calc average over all n readings
var avr = var.r_sum / var.n

; output info
if {exists(param.P)}
	echo "Average after", var.n, "measurements: ", var.avr, "g"

; calc standard deviation for each reading
var sigma = vector(var.n, 0.)
var s_sum = 0
while (iterations < var.n)
	set var.sigma[iterations] = pow(var.readings[iterations] - var.avr, 2)
	set var.s_sum = var.s_sum + var.sigma[iterations]

; calc deviation for avr reading
var dev = sqrt(var.s_sum / var.n)

; output info
if {exists(param.P)}
	echo "standard deviation:", var.dev, "g"

; write values to global array
set global.FilamentScale[param.S] = {var.avr, var.dev}
