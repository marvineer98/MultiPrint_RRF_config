if {state.gpOut[0].pwm == {0}}
	M42 P0 S10
elif {state.gpOut[0].pwm == {10/255}}
	M42 P0 S100
elif {state.gpOut[0].pwm == {100/255}}
	M42 P0 S255
else
	M42 P0 S0