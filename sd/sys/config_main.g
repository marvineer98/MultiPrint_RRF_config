; here we define everything connected to the main board

; General preferences
G90                                                                  ; send absolute coordinates...
M83                                                                  ; ...but relative extruder moves
M550 P"MultiPrint"                                                   ; set printer name
;M551 P"rniaMvPrinter01"
M669 K1                                                              ; select CoreXY mode
M80 C"!pson"                                                         ; invert the PS_ON output for Meanwell power supply


; Network
;M552 P0.0.0.0 S1                                                    ; enable network and set IP address
;M553 P255.255.255.0                                                 ; set netmask
;M554 P192.168.1.254                                                 ; set gateway
;M586 P0 S1                                                          ; enable HTTP
;M586 P1 S0                                                          ; disable FTP
;M586 P2 S0                                                          ; disable Telnet


; PanelDue 5.0i with custom logo
M575 P1 S1 B115200


; wait for expansion boards to start
G4 S1

; lower SPI transfer max wait Time for quicker system respone (default 25 ms and 5ms if file open)
; ignore this if 3 or more events are in queue
M576 S6 F3 P3


; Define inputs and their trigger if necessary
M950 J5 C"^io5.in"                                                   ; input 5 - ActiveToolDetect (Tool Detect Switch)

M950 J6 C"^io7.in"                                                   ; input 6 - OpenDoorDetect
M581 P6 T2 S1 R0                                                     ; define rising edge trigger --> door opened (trigger2.g)
M581 P6 T3 S0 R0                                                     ; define falling edge trigger --> door closed (trigger3.g)
M582 T2                                                              ; check for trigger (necessary, we might start with door open)

M950 J7 C"^io8.in"                                                   ; input 7 - E-Stop (trigger 0)
M581 P7 T0 S1 R0                                                     ; define rising edge trigger --> emergency stop (M112) (NOT-HALT)

; check if e-stop is triggerd at startup
if sensors.gpIn[7].value == 1
	M291 T0 P"pull e-stop and reset machine to continue" R"e-stop is active"
	M300
	M582 T0
	abort "e-stop is active - pull e-stop and reset machine to continue"

; Lights
M950 P0 C"1.out1" Q500                                               ; main
M950 P1 C"1.out0" Q500                                               ; head
if sensors.gpIn[6].value == 1
	; door is closed
	M98 P"/macros/Lights/set.g" D"main" B0.75                           ; turn on main light
else
	M98 P"/macros/Lights/set.g" D"main" B0.05

; LED Strip
M950 E0 U18 T1 C"0.led"
; drive LED strip all white at low power
M150 R255 U255 B255 P10 S18


; Drives                   D3: stealthChop2            V4000: switch from stealthChop to to spreadCycle mode at 0.1 mm/sec speed (quiet at standstill) 
M569 P0.2 S0                                                         ; physical drive 0.2 goes backwards   (X  - Axis)
M569 P0.1 S0                                                         ; physical drive 0.1 goes backwards   (Y  - Axis)
M569 P0.0 S1                                                         ; physical drive 0.0 goes forwards    (Z  - Axis)
M569 P0.3 S0                                                         ; physical drive 0.3 goes backwards   (C  - COUPLER)
M569 P1.0 S1                                                         ; physical drive 1.0 goes forwards    (B  - BRUSH)
M569 P0.4 S1                                                         ; physical drive 0.4 goes forwards    (E0 - V6)
M569 P0.5 S1                                                         ; physical drive 0.5 goes forwards    (E1 - Volcano)
M569 P121.0 S0                                                       ; physical drive 121.0 goes forwards  (E2 - HighTemp Direct)

M584 X0.2 Y0.1 Z0.0 C0.3 B1.0 E0.4:0.5:121.0                         ; set drive mapping
M350 X16 Y16 Z16 B16 E16:16:16    I1                                 ; configure microstepping with interpolation
M350 C16 I0                                                          ; configure microstepping without interpolation
M92 X100 Y100 Z1600 C91.022 B128 E400:400:400                        ; set steps per mm
M98 P"/macros/Speeds/set_speed.g" S"startup"                         ; set speeds, jerk and accel. for the beginning
M566 Z20 C2 B8 E450:900:450                                          ; set maximum instantaneous speed changes (mm/min)
M203 Z800 C8000 B1000 E4500:5500:4500                                ; set maximum speeds (mm/min)
M201 Z400 C500 B500 E10000:23000:6000                                ; set accelerations (mm/s^2)
M906 X1800 Y1800 Z1130 B500 I20                                      ; set motor currents (mA) and motor idle factor in per cent (X Y Z B)
M906 C500 E1000:1000:1000 I10                                        ; set motor currents (mA) and motor idle extruder motors to 10%
M84 S15                                                              ; Set idle timeout


;spindle
M950 R0 C"^vfd" Q900 L10000                                          ; Spindle 0 uses out9/vfd as RPM pin with 200 Hz PWM freq and has a max RPM of 10000

; limits
M98 P"/macros/Boundaries/ToolHead.g"                                 ; set dynamic axis Limits
M208 Z0:264.6 C-45:360 B0:23                                         ; set static axis limits (min:max)


; Endstops
M574 X1 S1 P"^io3.in"                                                ; configure active-high endstop for low end on X via pin ^io1.in
M574 Y1 S1 P"^io4.in"                                                ; configure active-high endstop for low end on Y via pin ^io2.in
M574 Z2 S1 P"^io2.in"                                                ; configure active-high endstop for high end on Z via pin ^io7.in
M574 C0                                                              ; No C endstop
M574 B1 S1 P"^1.io3.in"                                              ; configure active-high endstop for low end on B via pin ^io5.in

; Z-Probe
M558 P8 C"io1.in" H2.5:0.7 F600:300 I0 A8 S0.003 T20000              ; set Z probe type to switch and the dive height + speeds
G31 P200 X0 Y0 Z0                                                    ; set Z probe trigger value, offset and trigger height
M557 X-140:140 Y-90:90 S20:30                                        ; Define mesh grid


;Stall Detection
M915 X S4 F1 R1                                                    ; X Axes
M915 Y S7 F1 R1                                                    ; Y Axes


; Heaters
M308 S0 P"temp0" Y"thermistor" A"Bed" T100000 B4138                  ; configure sensor 0 as thermistor on pin temp0
; BED                                                                ; correction val for port "temp0": H=-19; L=0
M950 H0 C"out0" T0 Q5                                                ; create bed heater output on out0 and map it to sensor 0 with a PWM freq of 5 Hz
M307 H0 B0 R1.240 C413.8 D3.17 S1                                    ; disable bang-bang mode for the bed heater and set PWM limit
M140 H0                                                              ; map heated bed to heater 0
M143 H0 S200                                                         ; set temperature limit for bed heater 0 to 200C

M308 S1 P"temp1" Y"thermistor" A"T0" T100000 B4138                   ; configure sensor 1 as thermistor on pin temp3
; TOOL 0                                                             ; correction val for port "temp3": H=-7; L=13
M950 H1 C"out1" T1                                                   ; create nozzle heater output on out3 and map it to sensor 1 
M307 H1 R2.320 K0.406:0.085 D5.66 E1.35 S1.00 B0 V24.0               ; disable bang-bang mode for heater and set PWM limit
M143 H1 S285                                                         ; set temperature limit for heater 1 to 285C

M308 S2 P"temp2" Y"thermistor" A"T1" T100000 B4138                   ; configure sensor 2 as thermistor on pin temp3
; TOOL 1                                                             ; correction val for port "1.temp0": H=-6; L=3
M950 H2 C"out2" T2                                                   ; create nozzle heater output on 1.out1 and map it to sensor 2    
M307 H2 R2.016 K0.366:0.030 D5.70 E1.35 S1.00 B0 V24.5               ; disable bang-bang mode for heater and set PWM limit
M143 H2 S285                                                         ; set temperature limit for heater 2 to 285C

M308 S3 P"121.temp0" Y"thermistor" A"T2" T100000 B4138               ;configure sensor 3 as thermistor on pin 121.temp0
; TOOL 2                                                             ; correction val for port "121.temp0": H=-13; L=0
M950 H3 C"121.out0" T3                                               ; create nozzle heater output on 121.out0 and map it to sensor 3
M307 H3 R2.409 K0.350:0.180 D5.36 E1.35 S1.00 B0 V23.9               ; disable bang-bang mode for heater  and set PWM limit
M143 H3 S250                                                         ; set temperature limit for heater 3 to 250C


; Fans
M950 F0 C"out4" Q500                                                 ; create fan 0 on pin out9 and set its frequency
M106 P0 S0 H-1 L0.2 C"T0"                                            ; set fan 0 value. Thermostatic control is turned off
M950 F1 C"out7" Q500                                                 ; create fan 1 on pin out8 and set its frequency
M106 P1 S1 H1 T60                                                    ; set fan 1 value. Thermostatic control is turned on

M950 F2 C"out5" Q500                                                 ; create fan 2 on pin 1.out6 and set its frequency
M106 P2 S0 H-1 L0.2 C"T1"                                            ; set fan 2 value. Thermostatic control is turned off
M950 F3 C"out8" Q500                                                 ; create fan 3 on pin 1.out7 and set its frequency
M106 P3 S1 H2 T60                                                    ; set fan 3 value. Thermostatic control is turned on

M950 F4 C"121.out1" Q500                                             ; create fan 4 on pin 121.out1 and set its frequency
M106 P4 S0 H-1 L0.4 C"T2"                                            ; set fan 4 value. Thermostatic control is turned off
M950 F5 C"121.out2" Q500                                             ; create fan 5 on pin 121.out2 and set its frequency
M106 P5 S1 H3 T60                                                    ; set fan 5 value. Thermostatic control is turned on

M950 F6 C"!out6+out6.tach" Q500                                      ; create fan 6 on pin out4, this is a PWM fan so the output needs to be inverted, and using out4.tach as a tacho input
M106 P6 S0 H-1 C"Filterbox"                                          ; set fan 6 value. Thermostatic control is turned off
M106 P6 S0

; Input Shaping
;M593 P"zvdd" F42.2						                             ; cancel ringing at 42.2Hz
                                                                     ;(https://forum.e3d-online.com/threads/accelerometer-and-resonance-measurements-of-the-motion-system.3445/)

; Tools
M563 P0 S"V6 Bowden" D0 H1 F0                                        ; define tool 0
G10 P0 X-8.02 Y38.97 Z-4.68                                          ; set tool 0 axis offsets
G10 P0 R0 S0                                                         ; set initial tool 0 active and standby temperatures to 0C
M572 D0 S0.2                                                         ; pressure advance T0
M308 S8 Y"linear-analog" P"1.io0.in" A"T0FilamentScale" B-65 C3240   ; Filament Weight Scale for tool 0

M563 P1 S"Volcano Bowden" D1 H2 F2                                   ; define tool 1
G10 P1 X-7.92 Y38.96 Z-13.2                                          ; set tool 1 axis offsets
G10 P1 R0 S0                                                         ; set initial tool 1 active and standby temperatures to 0C
M572 D1 S0.3                                                         ; pressure advance T1
M308 S9 Y"linear-analog" P"1.io1.in" A"T1FilamentScale" B45 C4100    ; Filament Weight Scale for tool 1

M563 P2 S"Hemera Direct" D2 H3 F4                                    ; define tool 2
G10 P2 X21.05 Y43.75 Z-5.7                                           ; set tool 2 axis offsets
G10 P2 R0 S0                                                         ; set initial tool 2 active and standby temperatures to 0C
M591 D2 P3 C"121.io1.in"                                             ; Configure filament sensing for tool 2
M572 D2 S0.05                                                        ; pressure advance T2
M308 S10 Y"linear-analog" P"1.io2.in" A"T2FilamentScale" B-233 C8500 ; Filament Weight Scale for tool 2

M563 P3 S"Spindle" R0                                                ; define tool 3
G10 P3 X0 Y52.50 Z-78.7                                              ; set tool 3 axis offsets

M563 P4 S"Pen"                                                       ; define tool 4
G10 P4 X0 Y50.0 Z-21.0                                               ; set tool 4 axis offsets

;some notes about PA:
;the large bowden tool should need a value of 2.0 or 2.1, but the system gets ridiculously slow without cranking up E jerk

; PowerFail Script (use M916 to resume the print from where it stopped)
M911 S23.6 R23.8 P"M913 X0 Y0 G91 M83 G1 E-5 F1000"                  ; set voltage thresholds and actions to run on power loss


;MCU Temp Calibration
M912 P0 S8                                                           ;room temp: 20°C (reportet MCU temp right after startup: 12°C)
M308 S5 Y"mcu-temp" A"6HC MCU"                                       ;show MCU-temp of Mainboard (MB6HC) in DWC (Tools -> Extra) Graph
M308 S6 Y"mcu-temp" P"1.dummy" A"3HC MCU"                            ;show MCU-temp of CAN expansion board 1 (3HC) in DWC (Tools -> Extra) Graph
M308 S7 Y"mcu-temp" P"121.dummy" A"1LC MCU"                          ;show MCU-temp of CAN expansion board 121 (1LC) in DWC (Tools -> Extra) Graph

;DHT Sensor (temp and humidity)
M308 S11 P"io6.out" Y"dht22" A"Chamber"                              ; define DHT22 temperature sensor
M308 S12 P"S11.1" Y"dhthumidity" A"Rel. Humidity[%]"                 ; attach DHT22 humidity sensor to secondary output of temperature sensor
