if state.status != "processing"
	M291 R"SBC shutdown" P"SBC will be stopped and shut down.  You can turn off power afterwards." S0
	M81 S1
	M400
	M999 B-1 P"OFF"