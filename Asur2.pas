unit Asur2;

interface

uses
    Mehanism, kinematicPair, Math, System.SysUtils, Dialogs, Classes,
    GDIPAPI, GDIPOBJ, KinematicObjects, ObjectEdit, StdCtrls, MainOptions;

type

TAsur2 = class(TMehanism) //Група Ассура ІІ вид
public
  L1 : double;
  imax, imin : INTEGER;
  X : array [0..359] of double;
  Y : array [0..359] of double;
  Fiq, fi1, fi2 : array [0..359] of double;
  L1mass, L2mass : double;
  KPoint : array [0..100] of TKinematicPair;
  ifleft : boolean;
  zXe, ZyE : integer;
  Ksi, ze, eks  : double;
  Lm :array [0..360] of double;
  Fim :array [0..360] of double;
  Leh :array [0..360] of double;
  procedure calibration;
  procedure Calculate; override;
  function Lisp:string; override;
  function Lisp2D:string; override;
  procedure KinematicScheme (i : integer;G : TGPGraphics;
      GrayPen, BlackPen2, BlackPen1, PinkPen, RedPen, BluePen, GreenPen, OrangePen : TGPPen;
      GrayBrush, WhiteBrush, BlackBrush, BlueBrush : TGPSolidBrush;
      F6, F8 : TGPFont); override;
  constructor Create; overload;
end;

implementation

uses Main;

constructor TAsur2.Create;
var i : integer;
begin
  kind := 'Asur2_1';
  name := 'Group of Assur 2';
  S.index := S.index +1;
  index := S.index;
  points := 2;
  // Кинематическая пара 1
  kpoint[0] :=  TKinematicPair.Create;
  // Кинематическая пара 2
  kpoint[1] := TKinematicPair.Create;
  MainPointList.AddObject(kpoint[1].name + IntToStr(MainPointList.Count+1),kpoint[1]);
  kpoint[1].name := 'Point C';
  With FormMain.TreeObjects do
  begin
    Items.AddChildObject(Items[0],'Group of Assur 2', Self);
    Items.AddChildObject(Items.Item[0].Item[index -1],'Point ' + IntToStr(MainPointList.Count), kpoint[0]);
  end;
end;


procedure TAsur2.Calibration;
var
  I : integer;
  LmhMin, LmhMax : double;
  Lm, L4 : double;
begin
  with   FormMain do
    begin

    end;
end;


procedure TAsur2.Calculate;
var i, ii : integer;
X3max, Y3max, X3min, Y3min : double;
x1, y1, x2, y2, x3, y3, v1, a1, gama1, psi1, v2, a2, gama2, psi2,
v3, a3, gama3, psi3 : array [0..359] of double;
begin
  for i := 0 to 359 do
  begin
    calibration;
    L1:=s.L2;
    if index = 4 then
    begin
      eks := s.W/2;
      L1:=s.L3;
    end;
    if index = 5 then
    begin
      eks := -s.W/2;
      L1:=s.L3;
    end;
    X1[i] := Kpoint[0].X[i];
    Y1[i] := Kpoint[0].Y[i];
    Lm[i] := sqrt(sqr(X1[i])+sqr(Y1[i]));
    zXe := sign(eks*cos(Ksi+pi/2));
    zye := sign(eks*sin(Ksi+pi/2));
    ze := sign(sign(zyE*cos(ksi))-sign(zxE*sin(ksi)));
    Fim[i] := arctan2(Y1[i],X1[i]);
    try
      Fi1[i] := (arcsin((abs(eks)*ze-Lm[i]*sin(Fim[i]-Ksi))/L1))+ksi;
    except
      exit;
    end;
    Leh[i] := sqrt(sqr(Lm[i]*cos(Fim[i])+L1*cos(Fi1[i]))+sqr(Lm[i]*sin(fim[i])+L1*sin(Fi1[i])));
    if ifleft then
    X3[i]:=X1[i]-L1*cos(fi1[i])
      else
    X3[i]:=X1[i]+L1*cos(fi1[i]);
    Y3[i]:=Y1[i]+L1*sin(fi1[i]);
    Kpoint[1].X[i]:=X3[i];
    Kpoint[1].Y[i]:=Y3[i];
    X3min := X3[i];
    X3max := X3[i];
    Y3min := Y3[i];
    Y3max := Y3[i];
    if (ksi = DegToRad(0)) or (ksi = DegToRad(180)) or (ksi = DegToRad(360)) then
    for II := 0 to 359 do
    begin
        if X3[ii] > X3max then
        begin
           X3max := X3[ii];
           iMax := ii;
        end;
        if X3[ii] < X3min then
        begin
           X3min := X3[ii];
           iMin := ii;
        end;
    end
      else
    for II := 0 to 359 do
    begin
        if Y3[ii] > Y3max then
        begin
           Y3max := Y3[ii];
           iMax := ii;
        end;
        if Y3[ii] < Y3min then
        begin
           Y3min := Y3[ii];
           iMin := ii;
        end;
    end;
    s.YMAX :=Y3max;
    if index = 4 then
    begin
      s.Step :=  l1 - Y3[0];
      s.Y3[i] :=  Y3[i];
      s.X3[i] :=  X3[i];
    end;
    s.Xmin := X3min;
    if abs(X3max) > s.Xmax then
      s.Xmax := X3max;
  end;
end;
//=============================================================================
// ПРОРИСОВка
//=============================================================================
procedure TAsur2.KinematicScheme(i: Integer;
      G : TGPGraphics;
      GrayPen, BlackPen2, BlackPen1, PinkPen, RedPen, BluePen, GreenPen, OrangePen : TGPPen;
      GrayBrush, WhiteBrush, BlackBrush, BlueBrush : TGPSolidBrush;
      F6, F8 : TGPFont);
var
 // g : TGPGraphics;
  ii : Integer;
  P, GP, P2, P3 : TGPPen;
  angle : double;
  ifRight : boolean;
begin
  calculate;
  g := TGPGraphics.Create(cv.Handle);
  if Self.selected then
    begin
     P := BluePen;
     GP := RedPen;
    end
       else
    begin
     P := BlackPen2;
     GP := BlackPen2;
    end;
  P2 := BlackPen1;
  P3 := BlackPen2;
  g.TranslateTransform(s.X0, s.y0);

  X[0] := mmtopix(kpoint[0].X[i]*s.scale);
  Y[0] := -mmtopix(kpoint[0].Y[i]*s.scale);

  X[1] := mmtopix(kpoint[1].X[i]*s.scale);
  Y[1] := -mmtopix(kpoint[1].Y[i]*s.scale);

  X[3] := mmtopix(l1/3*cos(fi1[i])*s.scale);
  Y[3] := -mmtopix(l1/3*sin(fi1[i])*s.scale);

  X[5] := mmtopix(l1/3*cos(fi1[i])*s.scale);
  Y[5] := -mmtopix(l1/3*sin(fi1[i])*s.scale);

  X[6] := mmtopix(l1/3*cos(fi2[i])*s.scale);
  Y[6] := -mmtopix(l1/3*sin(fi2[i])*s.scale);

  X[7] := mmtopix(kpoint[1].X[imax]*s.scale);
  Y[7] := -mmtopix(kpoint[1].Y[imax]*s.scale);

  X[8] := mmtopix(kpoint[1].X[imin]*s.scale);
  Y[8] := -mmtopix(kpoint[1].Y[imin]*s.scale);


  G.DrawLine(p, x[0], y[0], x[1], y[1]);

  G.DrawLine(p2, x[7], y[7], x[8], y[8]);

  g.FillEllipse(whitebrush, x[0]-5, y[0]-5 ,10 ,10);
  g.DrawEllipse(P, x[0]-5, y[0]-5 ,10 ,10);

  if index >3 then
  begin
    g.FillEllipse(whitebrush, x[1]-5, y[1]-5 ,10 ,10);
    g.DrawEllipse(P, x[1]-5, y[1]-5 ,10 ,10);
    GroundUP(WhiteBrush, P,G ,x[1], y[1]);
  end
  else
  begin
    povzun(p,F8, WhiteBrush,g,x[1], y[1], -ksi);
    OporaPovzunNiz(p2,F8, WhiteBrush,g,x[8], y[8], -ksi);
    OporaPovzunVerh(p2,F8, WhiteBrush,g,x[7], y[7], -ksi);
  end;
  if index=4 then
  begin
    press(P3,G, Y[1]);
    P3.SetColor(MakeColor(205,92,92));
    form(P3,G);
    p3.SetWidth(3);
    p3.SetColor(MakeColor(0,100,0));
    if (kpoint[1].Y[i]) > (l1 - s.Step/2) then
      g.DrawLine(p3, mmtopix(-s.A/2*s.scale), y[1]-mmtopix(s.HP*s.scale)-18,
        mmtopix(s.A/2*s.scale), y[1]-mmtopix(s.HP*s.scale)-18)
    else
      g.DrawLine(p3, mmtopix(-s.A/2*s.scale), -mmtopix(l1*s.scale)-mmtopix(s.HP*s.scale)+mmtopix(s.Step/2*s.scale)-18,
        mmtopix(s.A/2*s.scale), -mmtopix(l1*s.scale)-mmtopix(s.HP*s.scale)+mmtopix(s.Step/2*s.scale)-18);
  end;
  for ii := 0 to 1 do
  begin
    if (kpoint[ii].selected)  then
       kpoint[ii].Scheme(i,G,BluePen,BlackPen1,PinkPen, GreenPen, OrangePen, WhiteBrush, BlueBrush,F8)
     else
  end;
  if dimensions then
  begin
    if fi1[i] < 0 then
      angle := 2*pi + fi1[i] else
      angle := fi1[i];
    if (angle > pi/2) and (angle < pi*3/2)
    then
      ifRight := true
        else
      ifRight := false;
    if  index > 3  then
    dimangle(BlackPen1,F8,BlackBrush, G, x[0],y[0], MMToPix(L1/3*s.scale), 0, X[3], Y[3],
        angle, MMToPix(L1/3*s.scale));
    if (index = 2) or (index = 4) then
    dimline(BlackPen1, F8,BlackBrush,G,x[0],y[0],x[1],y[1],
        MMToPix(L1*s.scale),angle, ifRight, 'L= ', 20);
    if index=4 then
    begin
    dimline(BlackPen1, F8, BlackBrush, G, mmtopix(-s.A/2*s.scale), y[1]-mmtopix(s.HP*s.scale)-18,
      mmtopix(-s.A/2*s.scale), y[1]-18, MMToPix(s.HP*s.scale), 3*pi/2, true, 'HP= ',
      + 20);
    dimline(BlackPen1, F8, BlackBrush, G, mmtopix(-s.A/2*s.scale), y[1]-18,
      mmtopix(s.A/2*s.scale), y[1]-18, MMToPix(s.A*s.scale), 0, false, 'A= ',
      - 20);
    end;
  end;
  g.free;
end;

function TAsur2.Lisp:string;
var
  L1_, Fii_, xA, yA, xb, yb, As2_1, As2_2, As2_3, As2_4, As2_5, As2_6,As2_7, As2_8, B,
  VL1, VFii, Vxb, Vyb, Vxa, Vya, VB: string;
i : integer;
begin
  L1_ := 'L'+IntToStr(index) + ' ';
  if (index = 2) or (index =3) then
    VL1 := FloattoStr(s.L2)
      else
    VL1 := FloattoStr(s.L3);
  for I := 0 to Length(VL1) do
     if VL1[i]=',' then VL1[i]:='.';
  Fii_ := 'Fi'+IntToStr(index) + ' ';
  if index =3 then
  begin
    VFii := FloattoStr(-RadToDeg(Fi1[s.fi])-180);
    for I := 0 to Length(VFii) do
      if VFii[i]=',' then VFii[i]:='.';
  end
    else
  begin
    VFii := FloattoStr(RadToDeg(Fi1[s.fi]));
    for I := 0 to Length(VFii) do
      if VFii[i]=',' then VFii[i]:='.';
  end;
  Xa := 'XA'+IntToStr(index) + ' ';
  VXa := FloattoStr(KPoint[0].x[s.fi]);
    for I := 0 to Length(VXa) do
      if VXa[i]=',' then VXa[i]:='.';
  Ya := 'YA'+IntToStr(index) + ' ';
  VYa := FloattoStr(KPoint[0].y[s.fi]);
    for I := 0 to Length(VYa) do
      if VYa[i]=',' then VYa[i]:='.';
  Xb := 'XB'+IntToStr(index) + ' ';
    VXb := FloattoStr(KPoint[1].x[s.fi]);
    for I := 0 to Length(VXb) do
      if VXb[i]=',' then VXb[i]:='.';
  Yb := 'YB'+IntToStr(index) + ' ';
    VYb := FloattoStr(KPoint[1].y[s.fi]);
    for I := 0 to Length(VYb) do
      if VYb[i]=',' then VYb[i]:='.';
  B := 'B ';
  AS2_1 := IntToStr(index) + 'A ';
  AS2_2 := IntToStr(index) + 'B ';
  AS2_3 := IntToStr(index) + 'C ';
  AS2_4 := IntToStr(index) + 'D ';
  AS2_5 := IntToStr(index) + 'E ';
  AS2_6 := IntToStr(index) + 'F ';
  AS2_7 := IntToStr(index) + 'G ';
  AS2_8 := IntToStr(index) + 'H ';
  if (index = 2) or (index =3) then

    result :=
    ' ; Група Ассура 2' + #$D#$A + #$D#$A +

    '(setq ' + L1_ + Vl1  + #$D#$A  +
    Fii_ + VFii  +  #$D#$A +
    Xb + VXb  +  #$D#$A +
    Yb + VYb  +  #$D#$A +
    Xa + VXa  +  #$D#$A +
    Ya + VYa  +  #$D#$A +
    ' )' +  #$D#$A +  #$D#$A +
    '(command "_Ucs" "_n" (list '+XA+ ' '+ YA+'  0) )'                  +  #$D#$A +
    '(command "_Ucs" "_n" "_z" '+fii_+')'                            +  #$D#$A +
    '(kor '+L1_+' 16. 28.)'                                          +  #$D#$A +
    '(setq '+AS2_1+'  (entlast))'                                      +  #$D#$A +
    '(command "_Cylinder" ''(0 0 30) 10. -60)'                  +  #$D#$A +
    '(setq '+AS2_2+'  (entlast))'                                      +  #$D#$A +
    '(command "_Cylinder" ''(0 0 30) 17.5 15)'                  +  #$D#$A +
    '(command "_Union" '+AS2_2+' (entlast) "")'                        +  #$D#$A +
    '(command "_Ucs" "_n" "_z" (- 0 '+fii_+'))'                      +  #$D#$A +
    '(command "_Ucs" "_n" (list (- 0 '+XA+') (- 0 '+YA+') 0))'        +  #$D#$A +
    '(command "_Ucs" "_n" (list '+XB+ ' ' +YB+'  0) )'                  +  #$D#$A +
    '(command "_Box" (list -100 -55 0) "_l" 200. 30. -60.)'     +  #$D#$A +
    '(setq '+AS2_3+'  (entlast))'                                      +  #$D#$A +
    '(command "_Box" (list -100 -40 -15) "_l" 200. 40. -30.)'   +  #$D#$A +
    '(setq '+AS2_4+'  (entlast))'                                      +  #$D#$A +
    '(command "_subtract" '+AS2_3+' "" '+AS2_4+' (entlast) "")'               +  #$D#$A +
    '(command "_Cylinder" ''(0 0 -15) 40 -30)'                  +  #$D#$A +
    '(setq '+AS2_5+'  (entlast))'                                      +  #$D#$A +
    '(command "_Cylinder" ''(0 0 -15) 8 -30)'                   +  #$D#$A +
    '(setq '+AS2_6+'  (entlast))'                                      +  #$D#$A +
    '(command "_subtract" '+AS2_5+' "" '+AS2_6+' (entlast) "")'               +  #$D#$A +
    '(command "_Cylinder" ''(0 0 20) 14. 20)'                   +  #$D#$A +
    '(setq '+AS2_7+'  (entlast))'                                       +  #$D#$A +
    '(command "_Cylinder" ''(0 0 20) 8. -80)'                   +  #$D#$A +
    '(command "_Union" '+AS2_7+'(entlast) "")'                         +  #$D#$A +
    '(command "_Cylinder" ''(0 0 0) 14. -15.)'                  +  #$D#$A +
    '(setq '+AS2_8+'  (entlast))'                                      +  #$D#$A +
    '(command "_Ucs" "_n" (list (- 0 '+XB+') (- 0 '+YB+')  0) )'      +  #$D#$A +
    '(command "_Ucs" "_n" (list  0 0 (- (/ '+B+' -2.) 30.)))'       +  #$D#$A +
    '(command "_Ucs" "_n" "_x" 270.)'                           +  #$D#$A +
    '(command "_MIRROR" '+AS2_1+ AS2_2 +AS2_3+ AS2_5+ AS2_7+ AS2_8+'"" (list 0 0  (/ '+B+' -2.)) (list 50 0 (/ '+B+' 2.)) "_n" )' +  #$D#$A +
    '(command "_Ucs" "_n" "_x" -270.)'       +  #$D#$A +
    '(command "_Ucs" "_n" (list  0 0 (+ (/ '+B+' 2.) 30.)))'   +  #$D#$A

  else

     result :=
    ' ; Група Ассура 2' + #$D#$A + #$D#$A +
    '(setq ' + L1_ + Vl1  + #$D#$A  +
    Fii_ + VFii  +  #$D#$A +
    Xb + VXb  +  #$D#$A +
    Yb + VYb  +  #$D#$A +
    Xa + VXa  +  #$D#$A +
    Ya + VYa  +  #$D#$A +
    ' )' +  #$D#$A +  #$D#$A +
    '(command "_Ucs" "_n" (list '+XA+' '+YA+'  -55) )' +  #$D#$A +
    '(command "_Ucs" "_n" "_z" '+fii_+')' +  #$D#$A +
    '(pov '+l1_+' 16. 28. 24.)'+  #$D#$A +
    '(setq '+AS2_1+'  (entlast))' +  #$D#$A +
    '(command "_Ucs" "_n" "_z" (- 0 '+fii_+'))' +  #$D#$A +
    '(command "_Ucs" "_n" (list (- 0 '+XA+') (- 0 '+YA+') 55))' +  #$D#$A +
    '(command "_Ucs" "_n" (list '+XB+' '+YB+'  0) )' +  #$D#$A +
    '(command "_Cylinder" ''(0 0 -15) 17.5 -15)' +  #$D#$A +
    '(setq '+AS2_2+'  (entlast))' +  #$D#$A +
    '(command "_Cylinder" ''(0 0 -30) 8. -45)' +  #$D#$A +
    '(command "_Union" '+AS2_2+'  (entlast) "")'  +  #$D#$A +
    '(command "_Box" (list -15 -20 -60) "_l" 30. 60. -15.)'+  #$D#$A +
    '(setq '+AS2_3+'  (entlast))' +  #$D#$A +
    '(command "_Ucs" "_n" (list (- 0 '+XB+') (- 0 '+YB+')  0) )'+  #$D#$A +
    '(command "_Ucs" "_n" (list  0 0 (- (/ '+B+' -2.) 30.)))'+  #$D#$A +
    '(command "_Ucs" "_n" "_x" 270.)' +  #$D#$A +
    '(command "_MIRROR" '+AS2_1+' '+AS2_2+' '+AS2_3+'"" (list 0 0  (/ '+B+' -2.)) (list 50 0 (/ '+B+' 2.)) "_n" )'+  #$D#$A +
    '(command "_Ucs" "_n" "_x" -270.)'+  #$D#$A +
    '(command "_Ucs" "_n" (list  0 0 (+ (/ '+B+' 2.) 30.)))';
end;

function TAsur2.Lisp2D:string;
var
  xA, yA, xb, yb,
  Vxb, Vyb, Vxa, Vya: string;
i : integer;
begin
  Xa := 'XA'+IntToStr(index) + ' ';
  VXa := FloattoStr(KPoint[0].x[s.fi]);
    for I := 0 to Length(VXa) do
      if VXa[i]=',' then VXa[i]:='.';
  Ya := 'YA'+IntToStr(index) + ' ';
  VYa := FloattoStr(KPoint[0].y[s.fi]);
    for I := 0 to Length(VYa) do
      if VYa[i]=',' then VYa[i]:='.';
  Xb := 'XB'+IntToStr(index) + ' ';
    VXb := FloattoStr(KPoint[1].x[s.fi]);
    for I := 0 to Length(VXb) do
      if VXb[i]=',' then VXb[i]:='.';
  Yb := 'YB'+IntToStr(index) + ' ';
    VYb := FloattoStr(KPoint[1].y[s.fi]);
    for I := 0 to Length(VYb) do
      if VYb[i]=',' then VYb[i]:='.';

  if (index = 2) or (index =3) then

    result :=
    ' ; Група Ассура 2' + #$D#$A + #$D#$A +

    '(setq '  + #$D#$A +

     Xa + VXA + #$D#$A +
    Ya + VYA + #$D#$A +
    XB + VXB + #$D#$A +
    YB + VYB  + #$D#$A +
    ' ) '              + #$D#$A +
    '(command "_line" (list '+ XA+' '+ YA+') (list '+Xb+ Yb+') "")' + #$D#$A +
    '(command "_circle" (list ' +Xb+ Yb+') 10)' + #$D#$A +
    '(command "_line" (list (- '+ Xb+ '40) (+ '+ Yb+ '20)) (list (+ '+ Xb +'40) (+ '+ Yb+ '20))"")' + #$D#$A +
    '(command "_line" (list (+ '+ Xb+ '40) (+ ' +Yb+ '20)) (list (+ ' +Xb +'40) (- ' +Yb +'20))"")' + #$D#$A +
    '(command "_line" (list (+ ' +Xb+ '40) (- ' +Yb+ '20)) (list (- ' +Xb+ '40) (- ' +Yb +'20))"")' + #$D#$A +
    '(command "_line" (list (- ' +Xb+ '40) (- ' +Yb+ '20)) (list (- ' +Xb +'40) (+ '+ Yb+ '20))"")' + #$D#$A +
    '(command "_line" (list (- ' +Xb+ '100)' +Yb+') (list (+ ' +Xb+ '100) '+Yb+')"")' + #$D#$A

  else

     result :=
    ' ; Група Ассура 2' + #$D#$A + #$D#$A +

    '(setq '  + #$D#$A +

     Xa + VXA + #$D#$A +
    Ya + VYA + #$D#$A +
    XB + VXB + #$D#$A +
    YB + VYB  + #$D#$A +
    ' ) '              + #$D#$A +
    '(command "_line" (list '+ XA +YA+') (list '+ Xb+ Yb+') "")' + #$D#$A +
    '(command "_circle" (list '+ Xb+ Yb+') 10)' + #$D#$A +
    '(command "_line" (list (- ' +Xb +'10) '+Yb+') (list (- ' +Xb+ '25) (+ ' +Yb +'45))"")' + #$D#$A +
    '(command "_line" (list (- ' +Xb+ '25) (+ '+Yb+ '45)) (list (+ '+ Xb+ '25) (+ '+ Yb +'45))"")' + #$D#$A +
    '(command "_line" (list (+ ' +Xb +'25) (+ '+Yb+ '45)) (list (+ '+Xb+ '10)' +Yb+')"")';
end;

end.
