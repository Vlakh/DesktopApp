unit Crank;

interface
uses
    Mehanism, kinematicPair, Math, System.SysUtils, Dialogs, Classes,
    GDIPAPI, GDIPOBJ, KinematicObjects, ObjectEdit, StdCtrls, MainOptions;
type

TCrank = class(TMehanism)
public
  L : double; //Lenth of link (L)
  X : array [0..359] of double;
  Y : array [0..359] of double;
  fi :  double; // Angle (Fi1)
  KPoint : array [0..100] of TKinematicPair;
  procedure Calculate; override;
  function Lisp:string; override;
  function Lisp2D : string; override;
  procedure KinematicScheme (i : integer;  G : TGPGraphics;
      GrayPen, BlackPen2, BlackPen1, PinkPen, RedPen, BluePen, GreenPen, OrangePen : TGPPen;
      GrayBrush, WhiteBrush, BlackBrush, BlueBrush : TGPSolidBrush;
      F6, F8 : TGPFont); override;
  constructor Create; overload;
end;


implementation

uses Main, Asur2;


constructor TCrank.Create;
var i : integer;
begin
  kind := 'Crank';
  name := 'Crank';
  s.zG := 1;
  S.index := S.index +1;
  index := S.index;
  points := 2;
  s.points := points;
  // Опора
  kpoint[0] :=  TKinematicPair.Create;
  kpoint[1] := TKinematicPair.Create;
  kpoint[1].name := 'Point A';
  kpoint[2] := TKinematicPair.Create;
  kpoint[2].name := 'Point B';
  for I := 0 to 359 do
  begin
    kpoint[0].X[i] := 0;
    kpoint[0].Y[i] := 0;
  end;
  With FormMain.TreeObjects do
  begin
    Items.AddChildObject(Items[0],'Crank', Self);
    Items.AddChildObject(Items.Item[0].Item[index -1],'Point A', kpoint[1]);
    Items.AddChildObject(Items.Item[0].Item[index -1],'Point B', kpoint[2]);
  end;

  MainPointlist.AddObject(kpoint[1].name + ' (' + name + ')', kpoint[1]);
  MainPointlist.AddObject(kpoint[2].name + ' (' + name + ')', kpoint[2]);
end;

procedure TCrank.Calculate;
var i, ii : integer;
begin
  for i:=0 to 359 do
    begin
      L := s.L1;
      fi := degtorad(i);
      kpoint[1].X[i] := L/2*cos(fi);
      kpoint[1].Y[i] := L/2*sin(fi)*s.zG;
      kpoint[1].fi[i] := fi;
      //
      fi := degtorad(i+180);
      kpoint[2].X[i] := L/2*cos(fi);
      kpoint[2].Y[i] := L/2*sin(fi)*s.zG;
      kpoint[2].fi[i] := fi;
    end;
end;

procedure TCrank.KinematicScheme (i : integer;
      G : TGPGraphics;
      GrayPen, BlackPen2, BlackPen1, PinkPen, RedPen, BluePen, GreenPen, OrangePen : TGPPen;
      GrayBrush, WhiteBrush, BlackBrush, BlueBrush : TGPSolidBrush;
      F6, F8 : TGPFont);
var
  P, GP, PDash : TGPPen;
  angle : double;
  ifRight : boolean;
  ii : Integer;
begin
  calculate;
  g := TGPGraphics.Create(cv.Handle);
  with FormMain do
    begin
       g.TranslateTransform(s.X0, s.y0);

       X[0] := mmtopix(kpoint[1].X[i]*s.scale);
       Y[0] := -mmtopix(kpoint[1].Y[i]*s.scale);

       X[1] := mmtopix(kpoint[2].X[i]*s.scale);
       Y[1] := -mmtopix(kpoint[2].Y[i]*s.scale);

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
       PDash := RedPen;
       PDash.SetDashStyle(DashStyle.DashStyleDashDot);
       PDash.SetWidth(0.1);
       G.DrawLine(PDash, 0, 25, 0, -mmtopix(s.YMAX*s.scale)-150);
       G.DrawLine(PDash, -mmtopix(s.Xmin*s.scale), 0, mmtopix(s.Xmin*s.scale), 0);
       G.DrawLine(PDash, -mmtopix(s.Xmin*s.scale), 25, -mmtopix(s.Xmin*s.scale),
          -mmtopix(s.YMAX*s.scale));
       G.DrawLine(PDash, mmtopix(s.Xmin*s.scale), 25, mmtopix(s.Xmin*s.scale),
          -mmtopix(s.YMAX*s.scale));

       PDash.SetDashStyle(DashStyle.DashStyleDash);
       PDash.SetWidth(0.1);
       PDash.SetColor(MakeColor(255, 0, 0, 255));
       g.DrawEllipse(PDash, 0-mmtopix(L/2*s.scale), 0-mmtopix(L/2*s.scale) ,
         mmtopix(L*s.scale),mmtopix(L*s.scale));

       G.DrawLine(p, 0, 0, x[0], y[0]);

       G.DrawLine(p, 0, 0, x[1], y[1]);

       for ii := 1 to points do
       begin
          if  (kpoint[ii].selected) then
              kpoint[ii].Scheme(i,G,BluePen,BlackPen1,PinkPen, GreenPen, OrangePen, WhiteBrush, BlueBrush,F8)
            else
       end;

       s.EditZG := false;

       Ground(WhiteBrush, P,G ,0, 0);

       if dimensions then
       begin
         if s.zG = -1 then
         angle := 2*pi - DegToRad(s.fi) else
         angle := DegToRad(s.fi) ;
         if (angle > pi/2) and (angle < pi*3/2)
         then
           ifRight := true
             else
           ifRight := false;
         dimline(BlackPen1, F8,BlackBrush,G,x[1],y[1],x[0],y[0], MMToPix(L*s.scale),
            angle, ifRight, 'L1= ', 20);

         dimline(BlackPen1, F8,BlackBrush,G,-mmtopix(s.Xmin*s.scale),0,
            mmtopix(s.Xmin*s.scale),0, MMToPix(s.Xmin*2*s.scale), 0, false, 'W= ', -MMToPix(L/2*s.scale) -25);

         dimline(BlackPen1, F8,BlackBrush,G,mmtopix(s.Xmin*s.scale),-mmtopix(s.Ymax*s.scale),
            mmtopix(s.Xmin*s.scale),0, MMToPix(s.Ymax*s.scale), 3*pi/2, true, 'H= ',
            -MMToPix(((s.L1/2+s.L2)-s.Xmin)*s.scale) - MMToPix(s.l3/3*s.scale) - 15);
       end;

    g.Free;
    end;
end;

function TCrank.Lisp : string;
var l_, fi_, s1, s2, s3, s4, A, B, HP, Y,
    VA, VB, VHP, VY, VL, VFI, xb, yb, Vxb, Vyb : string;
    i : integer;
begin
  L_ := 'LA ';
  fi_ := 'fi ';
  s1 := '1A';
  S2 := '2A';
  s3 := '3B';
  s4 := '4B';
  A := 'A ';
  B := 'B ';
  HP := 'HP ';
  Y := 'Y ';

  Vl := FloattoStr(L);
  if s.zG = 1 then
    VFi := FloattoStr(RadToDeg(kpoint[1].fi[s.fi]))
  else
    VFi := FloattoStr(RadToDeg(-kpoint[1].fi[s.fi]));
  for I := 0 to Length(VL) do
    if VL[i]=',' then VL[i]:='.';
  for I := 0 to Length(VFi) do
    if VFi[i]=',' then VFi[i]:='.';
  Xb := 'Xb ';
  VXb := FloattoStr(kpoint[2].x[s.fi]);
    for I := 0 to Length(VXb) do
      if VXb[i]=',' then VXb[i]:='.';
  Yb := 'Yb ';
    VYb := FloattoStr(kpoint[2].y[s.fi]);
    for I := 0 to Length(VYb) do
      if VYb[i]=',' then VYb[i]:='.';
  VA := FloattoStr(s.A);
  for I := 0 to Length(VA) do
    if VA[i]=',' then VA[i]:='.';
  VB := FloattoStr(s.B);
  for I := 0 to Length(VB) do
    if VB[i]=',' then VB[i]:='.';
  VHP := FloattoStr(s.HP);
  for I := 0 to Length(VHP) do
    if VHP[i]=',' then VHP[i]:='.';
  VY := FloattoStr(s.Y3[s.fi]);
  for I := 0 to Length(VY) do
    if VY[i]=',' then VY[i]:='.';

  result :=
  ' ; Кривошип' + #$D#$A + #$D#$A +

  '(setq ' +
    L_ + Vl  + #$D#$A  +
    fi_ + VFi +  #$D#$A +
    Xb+ VXb  +  #$D#$A +
    Yb + VYb  +  #$D#$A +
    Y + VY  +  #$D#$A +
    A + VA  +  #$D#$A +
    B + VB  +  #$D#$A +
    HP + VHP  +  #$D#$A +
   ' )' +  #$D#$A +
    '(command "_Cylinder" ''(0 0 -30) 25. (/ '+B+' -2.))'  +  #$D#$A +
    '(setq Val (entlast))'                            +  #$D#$A +
    '(command "_Cylinder" ''(0 0 0) 10. -30)'          +  #$D#$A +
    '(command "_Union" Val  (entlast) "")'            +  #$D#$A +
    '(command "_Ucs" "_n" (list '+Xb+' '+Yb+' -30.) )'        +  #$D#$A +
    '(command "_Ucs" "_n" "_z" '+fi_+')'                   +  #$D#$A +
    '(pov '+l_+' 20. 35. 30.)'                            +  #$D#$A +
    '(command "_Union" Val  (entlast) "")'            +  #$D#$A +
    '(command "_Ucs" "_n" "_z" (- 0 '+fi_+'))'                        +  #$D#$A +
    '(command "_Ucs" "_n" (list (- 0 '+Xb+') (- 0 '+Yb+')  30.))'        +  #$D#$A +
    '(command "_Ucs" "_n" (list  0 0 (- (/ '+B+' -2.) 30.)))'        +  #$D#$A +
    '(command "_Ucs" "_n" "_x" 270.)'                            +  #$D#$A +
    '(command "_MIRROR" Val"" (list 0 0  (/ '+B+' -2.)) (list 50 0 (/ '+B+' 2.)) "_n" )' +  #$D#$A +
    '(command "_Union" Val  (entlast) "")'                                       +  #$D#$A +
    '(command "_Ucs" "_n" "_x" -270.)'                                           +  #$D#$A +
    '(command "_Ucs" "_n" (list  0 0 (+ (/ '+B+' 2.) 30.)))'                         +  #$D#$A +
    '(command "_Box" (list (/ '+A+' -2.) (+ '+Y+' 40) -30) "_l" '+A+'  '+HP+' (- 0 '+B+'))'+  #$D#$A;
end;

function TCrank.Lisp2D : string;
var
  xa, ya, Vxa, Vya, xb, yb, Vxb, Vyb : string;
  A, VA, HP, VHP, YP, VYP : string;
  i : integer;
begin
  Xa := 'XA ';
  VXa := FloattoStr(kpoint[1].x[s.fi]);
    for I := 0 to Length(VXa) do
      if VXa[i]=',' then VXa[i]:='.';
  Ya := 'YA ';
    VYa := FloattoStr(kpoint[1].y[s.fi]);
    for I := 0 to Length(VYa) do
      if VYa[i]=',' then VYa[i]:='.';
  Xb := 'Xb ';
  VXb := FloattoStr(kpoint[2].x[s.fi]);
    for I := 0 to Length(VXb) do
      if VXb[i]=',' then VXb[i]:='.';
  Yb := 'Yb ';
    VYb := FloattoStr(kpoint[2].y[s.fi]);
    for I := 0 to Length(VYb) do
      if VYb[i]=',' then VYb[i]:='.';
  A := 'A ';
    VA := FloattoStr(s.A);
    for I := 0 to Length(VA) do
      if VA[i]=',' then VA[i]:='.';
  HP := 'HP ';
    VHP := FloattoStr(s.HP);
    for I := 0 to Length(VHP) do
      if VHP[i]=',' then VHP[i]:='.';
  YP := 'YP ';
    VYP := FloattoStr(s.Y3[s.fi] + 45);
    for I := 0 to Length(VYP) do
      if VYP[i]=',' then VYP[i]:='.';
  result:=
  ' ; Crank and Press' + #$D#$A + #$D#$A +

  '(setq ' +
    Xa + VXa  +  #$D#$A +
    Ya + VYa  +  #$D#$A +
    Xb+ VXb  +  #$D#$A +
    Yb + VYb  +  #$D#$A +
    HP + VHP +  #$D#$A +
    A + VA +  #$D#$A +
    YP + VYP +  #$D#$A +
    ')' +  #$D#$A +
    '(command "_line" (list '+ XA+ YA + ') (list ' + Xb+ Yb + ') "")'+  #$D#$A +
    '(command "_circle" (list 0 0) 10)' +  #$D#$A +
    '(command "_circle" (list '+ XA +YA +') 10)' +  #$D#$A +
    '(command "_circle" (list ' +Xb +Yb+') 10)' +  #$D#$A +
    '(command "_line" ''(0 0) ''(-10 0) ''(-25 -45) ''(25 -45) ''(10 0)"")' +  #$D#$A +
    '(command "_line" (list (/ '+ A +'-2.0)'+ YP+') (list (/ '+ A+' -2.0) (+ '+ YP + HP +'))"")' +  #$D#$A +
    '(command "_line" (list (/ ' +A +'-2.0) (+ '+ YP + HP +')) (list (/ '+ A +'2.0) (+ ' +YP+ HP+'))"")'   +  #$D#$A +
    '(command "_line" (list (/ '+ A+' 2.0) (+ '+ YP + HP +')) (list (/ '+ A+ '2.0)' +YP+')"") ' +  #$D#$A +
    '(command "_line" (list (/ '+ A+' 2.0)'+ YP+') (list (/ '+A +'-2.0)' +YP+')"")' ;

end;

end.
