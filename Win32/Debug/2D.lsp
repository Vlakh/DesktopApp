(defun C:MechanismUAD2D()
(command "_undo" 1000)
 ; Crank and Press

(setq XA 70.7106765732237
YA 70.7106796640857
Xb -70.7106830355541
Yb -70.7106732017551
HP 50
A 760
YP 409.649143089735
)
(command "_line" (list XA YA ) (list Xb Yb ) "")
(command "_circle" (list 0 0) 10)
(command "_circle" (list XA YA ) 10)
(command "_circle" (list Xb Yb ) 10)
(command "_line" '(0 0) '(-10 0) '(-25 -45) '(25 -45) '(10 0)"")
(command "_line" (list (/ A -2.0)YP ) (list (/ A  -2.0) (+ YP HP ))"")
(command "_line" (list (/ A -2.0) (+ YP HP )) (list (/ A 2.0) (+ YP HP ))"")
(command "_line" (list (/ A  2.0) (+ YP HP )) (list (/ A 2.0)YP )"") 
(command "_line" (list (/ A  2.0)YP ) (list (/ A -2.0)YP )"")
 ; Група Ассура 2

(setq 
XA2 70.7106765732237
YA2 70.7106796640857
XB2 464.411069996247
YB2 -1.80411241501588E-15
 ) 
(command "_line" (list XA2  YA2 ) (list XB2 YB2 ) "")
(command "_circle" (list XB2 YB2 ) 10)
(command "_line" (list (- XB2 40) (+ YB2 20)) (list (+ XB2 40) (+ YB2 20))"")
(command "_line" (list (+ XB2 40) (+ YB2 20)) (list (+ XB2 40) (- YB2 20))"")
(command "_line" (list (+ XB2 40) (- YB2 20)) (list (- XB2 40) (- YB2 20))"")
(command "_line" (list (- XB2 40) (- YB2 20)) (list (- XB2 40) (+ YB2 20))"")
(command "_line" (list (- XB2 100)YB2 ) (list (+ XB2 100) YB2 )"")

 ; Група Ассура 2

(setq 
XA3 -70.7106830355541
YA3 -70.7106732017551
XB3 -464.411077619246
YB3 -1.28508315100362E-14
 ) 
(command "_line" (list XA3  YA3 ) (list XB3 YB3 ) "")
(command "_circle" (list XB3 YB3 ) 10)
(command "_line" (list (- XB3 40) (+ YB3 20)) (list (+ XB3 40) (+ YB3 20))"")
(command "_line" (list (+ XB3 40) (+ YB3 20)) (list (+ XB3 40) (- YB3 20))"")
(command "_line" (list (+ XB3 40) (- YB3 20)) (list (- XB3 40) (- YB3 20))"")
(command "_line" (list (- XB3 40) (- YB3 20)) (list (- XB3 40) (+ YB3 20))"")
(command "_line" (list (- XB3 100)YB3 ) (list (+ XB3 100) YB3 )"")

 ; Група Ассура 2

(setq 
XA4 -464.411077619246
YA4 -1.28508315100362E-14
XB4 -300
YB4 364.649143089735
 ) 
(command "_line" (list XA4 YA4 ) (list XB4 YB4 ) "")
(command "_circle" (list XB4 YB4 ) 10)
(command "_line" (list (- XB4 10) YB4 ) (list (- XB4 25) (+ YB4 45))"")
(command "_line" (list (- XB4 25) (+ YB4 45)) (list (+ XB4 25) (+ YB4 45))"")
(command "_line" (list (+ XB4 25) (+ YB4 45)) (list (+ XB4 10)YB4 )"")
 ; Група Ассура 2

(setq 
XA5 464.411069996247
YA5 -1.80411241501588E-15
XB5 300
YB5 364.649146526753
 ) 
(command "_line" (list XA5 YA5 ) (list XB5 YB5 ) "")
(command "_circle" (list XB5 YB5 ) 10)
(command "_line" (list (- XB5 10) YB5 ) (list (- XB5 25) (+ YB5 45))"")
(command "_line" (list (- XB5 25) (+ YB5 45)) (list (+ XB5 25) (+ YB5 45))"")
(command "_line" (list (+ XB5 25) (+ YB5 45)) (list (+ XB5 10)YB5 )"")
)
