unit kinematicPair;

interface

uses Mehanism, ObjectEdit, SysUtils, Math, GDIPAPI, GDIPOBJ,
  KinematicObjects, MainOptions;


type
TKinematicPair = class(TMehanism)
  public
    X : array [0..359] of double;
    Y : array [0..359] of double;
    fi : array [0..359] of double;
    procedure Scheme ( i : integer; G:TGPGraphics;
        P, P1, P2, P3, P4 :TGPPen;
        WB, B :TGPSolidBrush;
        F : TGPFont
      );
    constructor Create;
end;

implementation

uses Main;

constructor TKinematicPair.Create;
begin
  kind := 'point';
  index := S.index;
end;

procedure TKinematicPair.Scheme
  ( i : integer;
    G:TGPGraphics;
    P, P1, P2, P3, P4 :TGPPen;
    WB, B :TGPSolidBrush;
    F : TGPFont
  );
var
 ii : integer;
 xv, yv, xa, yA, angle : double;
begin
    g.FillEllipse(WB, mmtopix(x[i]*s.scale)-5, -mmtopix(y[i]*s.scale)-5 ,10 ,10);
    g.DrawEllipse(p, mmtopix(x[i]*s.scale)-5, -mmtopix(y[i]*s.scale)-5 ,10 ,10);
end;
end.
