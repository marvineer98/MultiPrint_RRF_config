; Bed Mesh Leveling

;home Z to have a initial Z datum
G28 Z

; do the mesh bed leveling according to the M557 in config.g and enable it
G29 S0
; save the result according to current bed active temp
G29 S3 P{"heightmap_"^round(heat.heaters[0].active)^".csv"}

M98 P"/macros/Movement/move-to-home.g"
