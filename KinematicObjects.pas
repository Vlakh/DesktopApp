unit KinematicObjects;

interface
uses GDIPAPI, GDIPOBJ, Math, System.SysUtils, MainOptions, objectedit;

Procedure coords (B: TGPSolidBrush; F : TGPFont; P: TGPPen; g : TGPGraphics; x, y, height, width : double);
Procedure Ground (B: TGPSolidBrush; P: TGPPen; g : TGPGraphics; x, y : double);
Procedure GroundUP (B: TGPSolidBrush; P: TGPPen; g : TGPGraphics; x, y : double);
procedure Arrow (P: TGPPen; g : TGPGraphics; x0, y0, x1, y1 : double);
procedure DimAngle (P: TGPPen;F : TGPFont; B: TGPSolidBrush; g : TGPGraphics;
                      x0, y0, x1, y1, x2, y2, angle, L : double);
procedure Povzun (P: TGPPen; F : TGPFont; B: TGPSolidBrush; g : TGPGraphics; x, y, fi : double);
procedure OporaPovzunNiz (P: TGPPen; F : TGPFont; B: TGPSolidBrush; g : TGPGraphics; x, y, fi : double);
procedure OporaPovzunVerh (P: TGPPen; F : TGPFont; B: TGPSolidBrush; g : TGPGraphics; x, y, fi : double);
procedure DimLine(P: TGPPen;F : TGPFont;B: TGPSolidBrush; g : TGPGraphics;
                      x0, y0, x1, y1, l, angle : double; Right : boolean;
                      St : String;H : double);
procedure KinemArc(P, P1: TGPPen; g : TGPGraphics;x, y, L, angle, value1, value2 : double);
procedure Press(P: TGPPen; g : TGPGraphics; y : double);
procedure Form(P: TGPPen; g : TGPGraphics);
function  PixToMM(pix: double) : double;
function  MMToPix(mm: double) : double;


implementation

uses Main, kinematicpair;

function  PixToMM(pix: double) : double;
begin
  result := (pix/FormMain.PixelsPerInch*25.4);
end;

function  MMToPix(mm: double) : double;
begin
  result := (mm*(FormMain.PixelsPerInch/25.4));
end;

procedure Coords (B: TGPSolidBrush; F : TGPFont; P: TGPPen; g : TGPGraphics; x, y, height, width : double);
var Xp, Xm, Yp, Ym , i : integer;
    PointF : TGPPointF;
    Str : string;
begin
  g.DrawLine(p, x, 0, x, Height);
	g.DrawLine(p, 0, y, width, y);

  Xp := round(PixToMM(width - x)/s.scale);
  if not (s.scale < 0.6) then
    for i := 1 to Xp do
       g.DrawLine(p, x + MMToPix(i*s.scale), y - 1, x + MMToPix(i*s.scale), y + 1);
  Xp := round(Xp/5);
  if not (s.scale < 0.5) then
    for i := 1 to Xp do
       g.DrawLine(p, x + MMToPix(i*s.scale*5), y - 2.5, x + MMToPix(i*s.scale*5), y + 2.5);
  Xp := round(Xp/2);
  for i := 1 to Xp do
  begin
     if not (s.scale < 0.2) then
     g.DrawLine(p, x + MMToPix(i*s.scale*10), y - 4, x + MMToPix(i*s.scale*10), y + 4);
     if s.scale < 0.1 then
     begin
       PointF.x := x + MMToPix(i*s.scale*1000) - 4  ;
       PointF.Y := y + 3 ;
       Str := FloatToStr(i*1000);
     end else
     if s.scale < 0.15 then
     begin
       PointF.x := x + MMToPix(i*s.scale*200) - 4  ;
       PointF.Y := y + 3 ;
       Str := FloatToStr(i*200);
     end
       else
     if s.scale < 0.35 then
     begin
       PointF.x := x + MMToPix(i*s.scale*50) - 4  ;
       PointF.Y := y + 3 ;
       Str := FloatToStr(i*50);
     end else
     begin
       PointF.x := x + MMToPix(i*s.scale*10) - 4  ;
       PointF.Y := y + 3 ;
       Str := FloatToStr(i*10);
     end;
     if o.linage then
       g.DrawString(Str, Str.Length, F, PointF,B );
  end;

  Xm := round(PixToMM(x)/s.scale);
  if not (s.scale < 0.6) then
  for i := 1 to Xm do
     g.DrawLine(p, x - MMToPix(i*s.scale), y - 1, x - MMToPix(i*s.scale), y + 1);
  Xm := round(Xm/5);
  if not (s.scale < 0.5) then
  for i := 1 to Xm do
     g.DrawLine(p, x - MMToPix(i*s.scale*5), y - 2.5, x - MMToPix(i*s.scale*5), y + 2.5);
  Xm := round(Xm/2);
  for i := 1 to Xm do
  begin
     if not (s.scale < 0.2) then
     g.DrawLine(p, x - MMToPix(i*s.scale*10), y - 4, x - MMToPix(i*s.scale*10), y + 4);
     if s.scale < 0.1 then
     begin
       PointF.x := x - MMToPix(i*s.scale*1000) - 4  ;
       PointF.Y := y + 3 ;
       Str := FloatToStr(-i*1000);
     end else
     if s.scale < 0.15 then
     begin
       PointF.x := x - MMToPix(i*s.scale*200) - 4  ;
       PointF.Y := y + 3 ;
       Str := FloatToStr(-i*200);
     end
       else
     if s.scale < 0.35 then
     begin
       PointF.x := x - MMToPix(i*s.scale*50) - 4  ;
       PointF.Y := y + 3 ;
       Str := FloatToStr(-i*50);
     end else
     begin
       PointF.x := x - MMToPix(i*s.scale*10) - 8  ;
       PointF.Y := y + 3 ;
       Str := IntToStr(-i*10);
     end;
     if o.linage then
       g.DrawString(Str,Str.Length,F, PointF,B );
  end;
  Yp := round(PixToMM(y/s.scale));
  if not (s.scale < 0.6) then
  for i := 1 to Yp do
     g.DrawLine(p, x - 1, y  - MMToPix(i*s.scale), x + 1, y  - MMToPix(i*s.scale));
  Yp := round(Yp/5);
  if not (s.scale < 0.5) then
  for i := 1 to Yp do
     g.DrawLine(p, x - 2.5 , y - MMToPix(i*s.scale*5), x + 2.5 , y - MMToPix(i*s.scale*5));
  Yp := round(Yp/2);
  for i := 1 to Yp do
  begin
     if not (s.scale < 0.2) then
     g.DrawLine(p, x - 4 , y - MMToPix(i*s.scale*10), x + 4 , y - MMToPix(i*s.scale*10));
     if s.scale < 0.1 then
     begin
       PointF.x := x + 3;
       PointF.Y := y - MMToPix(i*s.scale*1000) - 8;
       Str := IntToStr(i*1000);
     end else
     if s.scale < 0.15 then
     begin
       PointF.x := x + 3;
       PointF.Y := y - MMToPix(i*s.scale*200) - 8;
       Str := IntToStr(i*200);
     end
       else
     if s.scale < 0.35 then
     begin
       PointF.x := x + 3;
       PointF.Y := y - MMToPix(i*s.scale*50) - 8;
       Str := IntToStr(i*50);
     end else
     begin
       PointF.x := x + 3;
       PointF.Y := y - MMToPix(i*s.scale*10) - 8;
       Str := IntToStr(i*10);
     end;
     if o.linage then
       g.DrawString(Str,Str.Length,F, PointF,B );
  end;

  Yp := round(PixToMM(height - y)/s.scale);
  if not (s.scale < 0.6) then
  for i := 1 to Yp do
     g.DrawLine(p, x - 1, y  + MMToPix(i*s.scale), x + 1, y  + MMToPix(i*s.scale));
  Yp := round(Yp/5);
  if not (s.scale < 0.5) then
  for i := 1 to Yp do
     g.DrawLine(p, x - 2.5 , y + MMToPix(i*s.scale*5), x + 2.5 , y + MMToPix(i*s.scale*5));
  Yp := round(Yp/2);
  for i := 1 to Yp do
  begin
     if not (s.scale < 0.2) then
     g.DrawLine(p, x - 4 , y + MMToPix(i*s.scale*10), x + 4 , y + MMToPix(i*s.scale*10));
     if s.scale < 0.1 then
     begin
       PointF.x := x + 3;
       PointF.Y := y + MMToPix(i*s.scale*1000) - 8;
       Str := IntToStr(-i*1000);
     end else
     if s.scale < 0.15 then
     begin
       PointF.x := x + 3;
       PointF.Y := y + MMToPix(i*s.scale*200) - 8;
       Str := IntToStr(-i*200);
     end
       else
     if s.scale < 0.35 then
     begin
       PointF.x := x + 3;
       PointF.Y := y + MMToPix(i*s.scale*50) - 8;
       Str := IntToStr(-i*50);
     end else
     begin
       PointF.x := x + 3;
       PointF.Y := y + MMToPix(i*s.scale*10) - 8;
       Str := IntToStr(-i*10);
     end;
     if o.linage then
       g.DrawString(Str,Str.Length,F, PointF,B );
  end;
end;

procedure Grid(P: TGPPen; g : TGPGraphics; x, y, step, width, height : double);
var i : integer;
begin
  for I := 0 to Round((width-x)/step) do
    g.DrawLine(P, x + i*step, 0, x + i*step, height);
  for I := 0 to Round(x/step) do
    g.DrawLine(P, x - i*step, 0, x - i*step, height);
  for I := 0 to Round(y/step) do
    g.DrawLine(P, 0, y - i*step, width, y - i*step);
  for I := 0 to Round((height-y)/step) do
    g.DrawLine(P, 0, y + i*step, width, y + i*step);
end;

Procedure Ground (B: TGPSolidBrush; P: TGPPen; g : TGPGraphics; x, y : double);
begin
  g.DrawLine(p,  X- 5, Y,    X- 9, Y+18);
	g.DrawLine(p,  X-9,  Y+18, X+ 9, Y+18);
	g.DrawLine(p,  X+ 9, Y+18, X+ 5, Y);
	g.DrawLine(p,  X- 9, Y+18, X-13, Y+25);
	g.DrawLine(p,  X- 5, Y+18, X-9, Y+25);
	g.DrawLine(p,  X- 1, Y+18, X-5, Y+25);
	g.DrawLine(p,  X+3,  Y+18, X-1, Y+25);
	g.DrawLine(p,  X+7,  Y+18, X+3, Y+25);
  g.FillEllipse(B, x-5, y-5 ,10 ,10);
  g.DrawEllipse(p, x-5, y-5 ,10 ,10);
end;

Procedure GroundUP (B: TGPSolidBrush; P: TGPPen; g : TGPGraphics; x, y : double);
begin
  g.DrawLine(p,  X- 5, Y,    X- 9, Y-18);
	g.DrawLine(p,  X+ 9, Y-18, X+ 5, Y);
  g.FillEllipse(B, x-5, y-5 ,10 ,10);
  g.DrawEllipse(p, x-5, y-5 ,10 ,10);
end;

procedure Arrow(P: TGPPen; g : TGPGraphics; x0, y0, x1, y1 : double);
var angle : double;
begin
  angle := arctan2(X0-X1, Y0-Y1);
  g.DrawLine(P,x1, y1, X1+10*sin(0.13+angle), Y1 + 10*cos(0.13+angle));
  g.DrawLine(P,x1, y1, X1+10*sin(0.13-angle+PI), Y1 + 10*cos(0.13-angle));
end;

procedure DimAngle(P: TGPPen;F : TGPFont;B: TGPSolidBrush; g : TGPGraphics;
                x0, y0, x1, y1, x2, y2, angle, L : double);
var ArX1, ArY1, ArX2, ArY2 : double;
 PointF : TGPpointf;
 Str : String;
begin
  if s.EditZG then
  begin
    if s.zG = -1 then
    begin
      angle := Abs(2*pi -angle);
    end;
  end;
  ArX1 := x1 ;
  ArY1 := Y1 - 100;
  ArX2 := x2 + 100 * cos (angle - pi/2);
  ArY2 := Y2 - 100 * sin (angle - pi/2);
  g.TranslateTransform(X0, y0);
  g.DrawLine(P,0, 0 ,x1, y1 );
  arrow(p,g, ArX1, ArY1, x1, y1);
  arrow(p,g, ArX2, ArY2, x2, y2);
  g.DrawArc(P, -L, -L, 2*L, 2*L, 360 -radtodeg(angle), radtodeg(angle));
  g.RotateTransform(90-radtodeg(angle)+radtodeg(angle)/2);
  Str := FloatToStr(round(radtodeg(angle))) + '`';
  pointF.X := - 10 ;
  pointF.Y := -L - 15;
  g.DrawString(Str, Str.Length, F, PointF,B );
  g.RotateTransform(-90+radtodeg(angle)-radtodeg(angle)/2);
  g.TranslateTransform(-X0, -y0);
end;


procedure DimLine(P: TGPPen;F : TGPFont;B: TGPSolidBrush; g : TGPGraphics;
                  x0, y0, x1, y1, l, angle : double; Right : boolean;
                  St : String; H : double);
var
  eX0, eY0, bX0, bY0, eX1, eY1, bX1, bY1 : double;
  PointF : TGPpointf;
  Str : String;
begin
  if s.EditZG then
  begin
    if  s.zG = -1 then
      angle := 2*pi -angle;
  end;
  if Right then
  begin
    eX0 := x0 + H * cos (angle - pi/2);
    ey0 := y0 - H * sin (angle - pi/2);
    eX1 := x1 + H * cos (angle - pi/2);
    ey1 := y1 - H * sin (angle - pi/2);
    pointF.X := -L/2 - 10 ;
  end
    else
  begin
    eX0 := x0 + H * cos (angle + pi/2);
    ey0 := y0 - H * sin (angle + pi/2);
    eX1 := x1 + H * cos (angle + pi/2);
    ey1 := y1 - H * sin (angle + pi/2);
    pointF.X := L/2 - 10 ;
  end;
  pointF.Y := -(H+15);
  bX0 := ex0 + abs(H) * cos (angle);
  by0 := ey0 - abs(H) * sin (angle);
  bX1 := ex1 - abs(H) * cos (angle);
  by1 := ey1 + abs(H) * sin (angle);
  arrow(P,G,bX0,by0,eX0,ey0);
  arrow(P,G,bX1,by1,eX1,ey1);
  g.DrawLine(P, eX0, ey0, ex1, ey1);
  g.DrawLine(P, X0, y0, ex0, ey0);
  g.DrawLine(P, X1, y1, ex1, ey1);
  g.TranslateTransform(X0, y0);
  if Right then
    g.RotateTransform(180 - radtodeg(angle))
      else
    g.RotateTransform(-radtodeg(angle));
  Str := St + FloatToStr(round(PixToMM(L)/s.scale));
  g.DrawString(Str, Str.Length, F, PointF,B );
  if Right then
    g.RotateTransform(-180+radtodeg(angle))
      else
    g.RotateTransform(radtodeg(angle));
  g.TranslateTransform(-X0, -y0);
end;

procedure KinemArc(P, P1: TGPPen; g : TGPGraphics;x, y, L, angle, value1, value2  : double);
var
x1, x2, y1, y2 : double;
begin
  if s.EditZG then
  begin
    if s.zG = -1 then
     begin
      angle := Abs(2*pi -angle);
     end;
  end;
  x1 := l*cos(angle + degtorad(25)*SIGN(value1)) + x;
  y1 := -l*sin(angle + degtorad(25)*SIGN(VALUE1)) + y;
  x2 := x1 + 100*cos(angle + degtorad(25)*SIGN(VALUE1) - (pi/2+degtorad(7))*SIGN(VALUE1));
  y2 := y1  -100*sin(angle + degtorad(25)*SIGN(VALUE1) - (pi/2+degtorad(7))*SIGN(VALUE1));
  g.DrawArc(P, -L + x, -L + y, 2*L, 2*L, 360 -radtodeg(angle) - 25, 50);
  arrow(p,g, X2, Y2, x1, y1);
 if not (value2 = 0) then
 begin
    x1 := l*cos(angle + degtorad(25)*SIGN(value2))- l/2*cos(angle) + x;
    y1 := -l*sin(angle + degtorad(25)*SIGN(VALUE2))+ l/2*SIN(angle) + y;
    x2 := x1 + 100*cos(angle + degtorad(25)*SIGN(VALUE2) - (pi/2+degtorad(7))*SIGN(VALUE2));
    y2 := y1  -100*sin(angle + degtorad(25)*SIGN(VALUE2) - (pi/2+degtorad(7))*SIGN(VALUE2));
    g.DrawArc(P1, -L - l/2*cos(angle) + x, -L + l/2*sin(angle) + y, 2*L, 2*L, 360 -radtodeg(angle) - 25, 50);
    arrow(p1,g, X2, Y2, x1, y1);
 end;
end;

procedure Povzun (P: TGPPen; F : TGPFont; B: TGPSolidBrush; g : TGPGraphics; x, y, fi : double);
var X1, y1, X2, y2, X3, y3, X4, y4, X5, y5, X6, y6, X7, y7 : double;
begin
  X1 := X -25*cos(fi);
	Y1 := Y -25*sin(fi);
	X6 := X -50*cos(fi);
	Y6 := Y -50*sin(fi);
	X7 := X +50*cos(fi);
	Y7 := Y +50*sin(fi);
	X2 := X1 +12.5 *cos(fi+0.5*PI);
	Y2 := Y1 +12.5 *sin(fi+0.5*PI);
	X3 := X2 +50 *cos(fi);
	Y3 := Y2 +50 *sin(fi);
	X4 := X3 +25*cos(fi-0.5*PI);
	Y4 := Y3 +25*sin(fi-0.5*PI);
	X5 := X4 -50*cos(fi);
	Y5 := Y4 -50*sin(fi);
	g.DrawLine(p,  X2, Y2, X3, Y3);
	g.DrawLine(p,  X3, Y3, X4, Y4);
	g.DrawLine(p,  X4, Y4, X5, Y5);
	g.DrawLine(p,  X5, Y5, X2, Y2);
end;

procedure OporaPovzunNiz (P: TGPPen; F : TGPFont; B: TGPSolidBrush; g : TGPGraphics; x, y, fi : double);
var X1, y1, X2, y2, X3, y3, X4, y4, X5, y5, X6, y6, X7, y7, X8, y8, X9, y9 : double;
begin
  X1 := X - 25*cos(fi);
	Y1 := Y - 25*sin(fi);
	X2 := X - 35*cos(fi);
	Y2 := Y - 35*sin(fi);
	X3 := X - 45*cos(fi);
	Y3 := Y - 45*sin(fi);
  X4 := X - 55*cos(fi);
	Y4 := Y - 55*sin(fi);
  X5 := X - 65*cos(fi);
	Y5 := Y - 65*sin(fi);
	X6 := X2 +10 *cos(fi+degtorad(225));
	Y6 := Y2 -10 *sin(fi+degtorad(225));
	X7 := X3 +10 *cos(fi+degtorad(225));
	Y7 := Y3 -10 *sin(fi+degtorad(225));
  X8 := X4 +10 *cos(fi+degtorad(225));
	Y8 := Y4 -10 *sin(fi+degtorad(225));
	X9 := X5 +10 *cos(fi+degtorad(225));
	Y9 := Y5 -10 *sin(fi+degtorad(225));
	g.DrawLine(p,  X, Y, X1, Y1);
  g.DrawLine(p,  X1, Y1, X2, Y2);
  g.DrawLine(p,  X2, Y2, X3, Y3);
  g.DrawLine(p,  X3, Y3, X4, Y4);
  g.DrawLine(p,  X4, Y4, X5, Y5);
	g.DrawLine(p,  X2, Y2, X6, Y6);
	g.DrawLine(p,  X3, Y3, X7, Y7);
	g.DrawLine(p,  X4, Y4, X8, Y8);
  g.DrawLine(p,  X5, Y5, X9, Y9);
end;

procedure OporaPovzunVerh (P: TGPPen; F : TGPFont; B: TGPSolidBrush; g : TGPGraphics; x, y, fi : double);
var X1, y1, X2, y2, X3, y3, X4, y4, X5, y5, X6, y6, X7, y7, X8, y8, X9, y9 : double;
begin
  X1 := X + 25*cos(fi);
	Y1 := Y + 25*sin(fi);
	X2 := X + 35*cos(fi);
	Y2 := Y + 35*sin(fi);
	X3 := X + 45*cos(fi);
	Y3 := Y + 45*sin(fi);
  X4 := X + 55*cos(fi);
	Y4 := Y + 55*sin(fi);
  X5 := X + 65*cos(fi);
	Y5 := Y + 65*sin(fi);
	X6 := X2 +10 *cos(fi+degtorad(225));
	Y6 := Y2 -10 *sin(fi+degtorad(225));
	X7 := X3 +10 *cos(fi+degtorad(225));
	Y7 := Y3 -10 *sin(fi+degtorad(225));
  X8 := X4 +10 *cos(fi+degtorad(225));
	Y8 := Y4 -10 *sin(fi+degtorad(225));
	X9 := X5 +10 *cos(fi+degtorad(225));
	Y9 := Y5 -10 *sin(fi+degtorad(225));
	g.DrawLine(p,  X, Y, X1, Y1);
  g.DrawLine(p,  X1, Y1, X2, Y2);
  g.DrawLine(p,  X2, Y2, X3, Y3);
  g.DrawLine(p,  X3, Y3, X4, Y4);
  g.DrawLine(p,  X4, Y4, X5, Y5);
end;

procedure Press(P: TGPPen; g : TGPGraphics; y : double);
var x1, y1, x2, y2, x3, y3, x4, y4 : double;
begin
  x1 := mmtopix(-s.A/2*s.scale);
  y1 := y - 18;
  x2 := mmtopix(s.A/2*s.scale);
  y2 := y - 18;
  x3 := mmtopix(s.A/2*s.scale);
  y3 := y - mmtopix(s.HP*s.scale)-18;
  x4 := mmtopix(-s.A/2*s.scale);
  y4 := y - mmtopix(s.HP*s.scale)-18;
  g.DrawLine(p,  x1, y1, x2, y2);
  g.DrawLine(p,  x2, y2, x3, y3);
  g.DrawLine(p,  x3, y3, x4, y4);
  g.DrawLine(p,  x4, y4, x1, y1);
end;

procedure Form(P: TGPPen; g : TGPGraphics);
var x1, y1, x2, y2, x3, y3, x4, y4,
    x5, y5, x6, y6, x7, y7, x8, y8 : double;
begin
  x1 := mmtopix(-s.A/2*s.scale);
  s.FormX1 := -s.A/2;
  y1 := -mmtopix(s.Ymax*s.scale) - 18- mmtopix(s.HP*s.scale)-mmtopix(100*s.scale);
  s.FormY1 := s.l3;
  x2 := mmtopix(s.A/2*s.scale);
  y2 := -mmtopix(s.Ymax*s.scale) - 18- mmtopix(s.HP*s.scale)-mmtopix(100*s.scale);
  x3 := mmtopix(s.A/2*s.scale);
  y3 := -mmtopix(s.Ymax*s.scale) - 18- mmtopix(s.HP*s.scale)-mmtopix(30*s.scale);
  x4 := mmtopix(-s.A/2*s.scale);
  y4 := -mmtopix(s.Ymax*s.scale) - 18- mmtopix(s.HP*s.scale)-mmtopix(30*s.scale);
  x5 := mmtopix(-s.A/2*s.scale) + mmtopix(50*s.scale);
  y5 := -mmtopix(s.Ymax*s.scale) - 18- mmtopix(s.HP*s.scale)-mmtopix(30*s.scale);
  x6 := mmtopix(s.A/2*s.scale) - mmtopix(50*s.scale);;
  y6 := -mmtopix(s.Ymax*s.scale) - 18- mmtopix(s.HP*s.scale)-mmtopix(30*s.scale);
  x7 := mmtopix(s.A/2*s.scale) - mmtopix(50*s.scale);
  y7 := -mmtopix(s.Ymax*s.scale) - 18- mmtopix(s.HP*s.scale);
  x8 := mmtopix(-s.A/2*s.scale) + mmtopix(50*s.scale);
  y8 := -mmtopix(s.Ymax*s.scale) - 18- mmtopix(s.HP*s.scale);
  g.DrawLine(p,  x1, y1, x2, y2);
  g.DrawLine(p,  x2, y2, x3, y3);
  g.DrawLine(p,  x3, y3, x4, y4);
  g.DrawLine(p,  x4, y4, x1, y1);
  g.DrawLine(p,  x5, y5, x6, y6);
  g.DrawLine(p,  x6, y6, x7, y7);
  g.DrawLine(p,  x7, y7, x8, y8);
  g.DrawLine(p,  x8, y8, x5, y5);
end;

end.
