set global.RunDaemon = false
M471 S"0:/sys/daemon.g" T"0:/sys/daemon.g.bak" ; rename dameon.g
if result = 0
	M291 R"Daemon.g stopped" P"Daemon.g has been stopped and renamed.  Hit F5 to refresh browser" S2
else
	M291 R"Error" P"Could not rename daemon.g" S2