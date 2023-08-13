if {state.gpOut[1].pwm == {0}}
	M42 P1 S5
elif {state.gpOut[1].pwm == {5/255}}
	M42 P1 S100
else
	M42 P1 S0