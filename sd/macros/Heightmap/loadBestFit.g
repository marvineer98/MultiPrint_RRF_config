var targetTemp = heat.heaters[0].active
var nearest = global.heightmapTemps[0]
var min_diff = 9999

; find best fit heightmap
while iterations < #global.heightmapTemps
    var diff = abs(global.heightmapTemps[iterations] - var.targetTemp)
    if var.diff < var.min_diff
        set var.min_diff = var.diff
        set var.nearest = global.heightmapTemps[iterations]

; load best fit heightmap
var fileName = "heightmap_"^var.nearest^".csv"
if fileexists(var.fileName)
    echo "loading best fit heightmap for "^var.targetTemp^" °C: "^var.fileName
    G29 S1 P{var.fileName}
else
    echo "loading generic heightmap because best fit "^var.fileName^" does not exist."
    G29 S1
