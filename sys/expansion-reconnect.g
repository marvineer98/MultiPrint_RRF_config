; runs if an expansion board reconnected to the system
; D parameter (non-negative integer): the device number associated with the event. For events relating to stepper drivers this is just the local driver number, not including the CAN address of the board.
; B parameter (non-negative integer): the CAN address of the board that the device is on
; P parameter (non-negative integer): additional information about the event, e.g. the subtype of a heater fault or a filament error
; S parameter: the full text string describing the fault

echo {param.S}
; test
; run the main config file again
M98 P"config_main.g"
