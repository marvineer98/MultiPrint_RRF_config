; SBCTrigger config file
; Version 0.0.1
; see https://github.com/marvineer98/SBCTrigger for further info
;
; How to use this file:
; 1. Define at least one Action with M583.1:
;    M583.1 A0 P"example_trigger.g"
; 2. Define at least one Trigger and connect it to the Action
;    M583.2 R0 A0 P"state.status" C"==" S"busy"
