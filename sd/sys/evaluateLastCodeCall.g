; evaluateLastCodeCall.g
; called to test 'result' for its expected value
; can be called with Parameter N: test number or name, default ""
; can be called with parameter R: expected result (0: success, 1: warning, >2: error), default 0

; set tast name if provided
var name = "Test"
if exists(param.N)
    set var.name = "Test "^param.N

; set expected result
var expectedResult = 0
if exists(param.R)
    set var.expectedResult = param.R

; evaluate the last known result
var res = result
if {var.res != var.expectedResult}
    abort "'"^var.name^"' failed, result is'"^var.res^"' instead of the expected '"^var.expectedResult^"'."
