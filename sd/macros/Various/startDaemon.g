;0:/macros/startDaemon.g
set global.RunDaemon = true
M38 "0:/sys/daemon.g" ; check if  dameon.g exists by trying to calculate hash
if result = 2 ; file not found
	M38 "0:/sys/daemon.g.bak" ; check if  dameon.g.bak exists by trying to calculate hash
	if result = 0
		M291 P"No daemon.g found" R"Daemon.g not found but daemon.g.bak found.  Rename now?" S3
		M471 S"0:/sys/daemon.g.bak" T"0:/sys/daemon.g" ; rename dameon.g.bak to daemon.g
		if result = 0
			echo "Daemon successfully renamed.  Hit F5 on browser to refresh"
		else
			M291 P"Error" R"Unable to rename file" S2
	else
		M291 P"No daemon found" R"Daemon.g not found." S2