(DEFUN asin (X)
(ATAN X (SQRT (- 1 (* X X)))))

(defun kor (lp dp dsp)
 (setq dw 20.0 dsw 35.0 bsw 30.0 bsp 20.0 bk 14.0)
(setq rw (/ dw 2.0)  rsw (/ dsw 2.)  rp (/ dp 2.)  rsp (/ dsp 2.) hbk (/ bk 2.) bfs (/ (- bsp bk) 2.0) )
(setq alfa (asin (/ (- rsw rsp) lp))
p1 (polar '(0 0 0) (- (* 0.5 pi) alfa) rsw)
p2 (polar (list lp 0 0) (- (* 0.5 pi) alfa) rsp)
p3 (polar '(0 0 0) (+ (* 1.5 pi) alfa) rsw)
p4 (polar (list lp 0 0) (+ (* 1.5 pi) alfa) rsp))
(command "_Pline" '(0 0 0) p1 p2 (list lp 0 0) p4 p3 "_c")
(command "_extrude" (entlast) ""  bk "") 
(setq o1 (entlast))
(command "_Cylinder" '(0 0 0) rsw bsw)
(command "_Union" o1 (entlast) "")
(command "_Cylinder" (list lp 0 0) rsp bsp)
(command "_Union" o1 (entlast) "")
(command "_Cylinder" '(0 0 0) rw bsw)
(setq o2 (entlast))
(command "_Cylinder" (list (+ 0 lp) 0 0) rp bsp)
(command "_Subtract" o1 "" o2 (entlast) "")
)

(defun pov (lp dp ds bs)
(setq  hpw 22. spw 12.)
(setq rp (/ dp 2.)  rs (/ ds 2.) )
(command "_Cylinder" '(0 0 0) rs bs)
(setq o1 (entlast))
(command "_Cylinder" (list lp 0 0) rs bs)
(setq o2 (entlast))
(command "_Box" (list 0 (/ spw -2.) (/ (- bs hpw) 2.)) "_l" lp spw hpw)
(command "_Union" o1 o2 (entlast) "")
(command "_Cylinder" '(0 0 0) rp bs)
(setq o3 (entlast))
(command "_Cylinder" (list lp 0 0) rp bs) 
(command "_subtract" o1 "" o3 (entlast) "") 
)

(defun C:MechanismUAD()
(command "_undo" 1000)
(setvar "osmode" 16384)
(setvar "CmdEcho" 0)
(setvar "BlipMode" 0)
(setvar "UcsIcon" 3)
 ; Кривошип

(setq LA 200
fi 45.0000012522391
Xb -70.7106830355541
Yb -70.7106732017551
Y 364.649143089735
A 760
B 560
HP 50
 )
(command "_Cylinder" '(0 0 -30) 25. (/ B  -2.))
(setq Val (entlast))
(command "_Cylinder" '(0 0 0) 10. -30)
(command "_Union" Val  (entlast) "")
(command "_Ucs" "_n" (list Xb  Yb  -30.) )
(command "_Ucs" "_n" "_z" fi )
(pov LA  20. 35. 30.)
(command "_Union" Val  (entlast) "")
(command "_Ucs" "_n" "_z" (- 0 fi ))
(command "_Ucs" "_n" (list (- 0 Xb ) (- 0 Yb )  30.))
(command "_Ucs" "_n" (list  0 0 (- (/ B  -2.) 30.)))
(command "_Ucs" "_n" "_x" 270.)
(command "_MIRROR" Val"" (list 0 0  (/ B  -2.)) (list 50 0 (/ B  2.)) "_n" )
(command "_Union" Val  (entlast) "")
(command "_Ucs" "_n" "_x" -270.)
(command "_Ucs" "_n" (list  0 0 (+ (/ B  2.) 30.)))
(command "_Box" (list (/ A  -2.) (+ Y  40) -30) "_l" A   HP  (- 0 B ))

 ; Група Ассура 2

(setq L2 400
Fi2 -10.1820676280677
XB2 464.411069996247
YB2 -1.80411241501588E-15
XA2 70.7106765732237
YA2 70.7106796640857
 )

(command "_Ucs" "_n" (list XA2  YA2   0) )
(command "_Ucs" "_n" "_z" Fi2 )
(kor L2  16. 28.)
(setq 2A   (entlast))
(command "_Cylinder" '(0 0 30) 10. -60)
(setq 2B   (entlast))
(command "_Cylinder" '(0 0 30) 17.5 15)
(command "_Union" 2B  (entlast) "")
(command "_Ucs" "_n" "_z" (- 0 Fi2 ))
(command "_Ucs" "_n" (list (- 0 XA2 ) (- 0 YA2 ) 0))
(command "_Ucs" "_n" (list XB2  YB2   0) )
(command "_Box" (list -100 -55 0) "_l" 200. 30. -60.)
(setq 2C   (entlast))
(command "_Box" (list -100 -40 -15) "_l" 200. 40. -30.)
(setq 2D   (entlast))
(command "_subtract" 2C  "" 2D  (entlast) "")
(command "_Cylinder" '(0 0 -15) 40 -30)
(setq 2E   (entlast))
(command "_Cylinder" '(0 0 -15) 8 -30)
(setq 2F   (entlast))
(command "_subtract" 2E  "" 2F  (entlast) "")
(command "_Cylinder" '(0 0 20) 14. 20)
(setq 2G   (entlast))
(command "_Cylinder" '(0 0 20) 8. -80)
(command "_Union" 2G (entlast) "")
(command "_Cylinder" '(0 0 0) 14. -15.)
(setq 2H   (entlast))
(command "_Ucs" "_n" (list (- 0 XB2 ) (- 0 YB2 )  0) )
(command "_Ucs" "_n" (list  0 0 (- (/ B  -2.) 30.)))
(command "_Ucs" "_n" "_x" 270.)
(command "_MIRROR" 2A 2B 2C 2E 2G 2H "" (list 0 0  (/ B  -2.)) (list 50 0 (/ B  2.)) "_n" )
(command "_Ucs" "_n" "_x" -270.)
(command "_Ucs" "_n" (list  0 0 (+ (/ B  2.) 30.)))

 ; Група Ассура 2

(setq L3 400
Fi3 -190.182066687595
XB3 -464.411077619246
YB3 -1.28508315100362E-14
XA3 -70.7106830355541
YA3 -70.7106732017551
 )

(command "_Ucs" "_n" (list XA3  YA3   0) )
(command "_Ucs" "_n" "_z" Fi3 )
(kor L3  16. 28.)
(setq 3A   (entlast))
(command "_Cylinder" '(0 0 30) 10. -60)
(setq 3B   (entlast))
(command "_Cylinder" '(0 0 30) 17.5 15)
(command "_Union" 3B  (entlast) "")
(command "_Ucs" "_n" "_z" (- 0 Fi3 ))
(command "_Ucs" "_n" (list (- 0 XA3 ) (- 0 YA3 ) 0))
(command "_Ucs" "_n" (list XB3  YB3   0) )
(command "_Box" (list -100 -55 0) "_l" 200. 30. -60.)
(setq 3C   (entlast))
(command "_Box" (list -100 -40 -15) "_l" 200. 40. -30.)
(setq 3D   (entlast))
(command "_subtract" 3C  "" 3D  (entlast) "")
(command "_Cylinder" '(0 0 -15) 40 -30)
(setq 3E   (entlast))
(command "_Cylinder" '(0 0 -15) 8 -30)
(setq 3F   (entlast))
(command "_subtract" 3E  "" 3F  (entlast) "")
(command "_Cylinder" '(0 0 20) 14. 20)
(setq 3G   (entlast))
(command "_Cylinder" '(0 0 20) 8. -80)
(command "_Union" 3G (entlast) "")
(command "_Cylinder" '(0 0 0) 14. -15.)
(setq 3H   (entlast))
(command "_Ucs" "_n" (list (- 0 XB3 ) (- 0 YB3 )  0) )
(command "_Ucs" "_n" (list  0 0 (- (/ B  -2.) 30.)))
(command "_Ucs" "_n" "_x" 270.)
(command "_MIRROR" 3A 3B 3C 3E 3G 3H "" (list 0 0  (/ B  -2.)) (list 50 0 (/ B  2.)) "_n" )
(command "_Ucs" "_n" "_x" -270.)
(command "_Ucs" "_n" (list  0 0 (+ (/ B  2.) 30.)))

 ; Група Ассура 2

(setq L4 400
Fi4 65.7305907018736
XB4 -300
YB4 364.649143089735
XA4 -464.411077619246
YA4 -1.28508315100362E-14
 )

(command "_Ucs" "_n" (list XA4  YA4   -55) )
(command "_Ucs" "_n" "_z" Fi4 )
(pov L4  16. 28. 24.)
(setq 4A   (entlast))
(command "_Ucs" "_n" "_z" (- 0 Fi4 ))
(command "_Ucs" "_n" (list (- 0 XA4 ) (- 0 YA4 ) 55))
(command "_Ucs" "_n" (list XB4  YB4   0) )
(command "_Cylinder" '(0 0 -15) 17.5 -15)
(setq 4B   (entlast))
(command "_Cylinder" '(0 0 -30) 8. -45)
(command "_Union" 4B   (entlast) "")
(command "_Box" (list -15 -20 -60) "_l" 30. 60. -15.)
(setq 4C   (entlast))
(command "_Ucs" "_n" (list (- 0 XB4 ) (- 0 YB4 )  0) )
(command "_Ucs" "_n" (list  0 0 (- (/ B  -2.) 30.)))
(command "_Ucs" "_n" "_x" 270.)
(command "_MIRROR" 4A  4B  4C "" (list 0 0  (/ B  -2.)) (list 50 0 (/ B  2.)) "_n" )
(command "_Ucs" "_n" "_x" -270.)
(command "_Ucs" "_n" (list  0 0 (+ (/ B  2.) 30.)))
 ; Група Ассура 2

(setq L5 400
Fi5 114.269408100357
XB5 300
YB5 364.649146526753
XA5 464.411069996247
YA5 -1.80411241501588E-15
 )

(command "_Ucs" "_n" (list XA5  YA5   -55) )
(command "_Ucs" "_n" "_z" Fi5 )
(pov L5  16. 28. 24.)
(setq 5A   (entlast))
(command "_Ucs" "_n" "_z" (- 0 Fi5 ))
(command "_Ucs" "_n" (list (- 0 XA5 ) (- 0 YA5 ) 55))
(command "_Ucs" "_n" (list XB5  YB5   0) )
(command "_Cylinder" '(0 0 -15) 17.5 -15)
(setq 5B   (entlast))
(command "_Cylinder" '(0 0 -30) 8. -45)
(command "_Union" 5B   (entlast) "")
(command "_Box" (list -15 -20 -60) "_l" 30. 60. -15.)
(setq 5C   (entlast))
(command "_Ucs" "_n" (list (- 0 XB5 ) (- 0 YB5 )  0) )
(command "_Ucs" "_n" (list  0 0 (- (/ B  -2.) 30.)))
(command "_Ucs" "_n" "_x" 270.)
(command "_MIRROR" 5A  5B  5C "" (list 0 0  (/ B  -2.)) (list 50 0 (/ B  2.)) "_n" )
(command "_Ucs" "_n" "_x" -270.)
(command "_Ucs" "_n" (list  0 0 (+ (/ B  2.) 30.)))
(command "_Shademode" "_G")
(command "_zoom" "_e") 
)
