unit ObjectEdit;

interface

uses  System.Classes;

type TSaving=record

  MehanismName : string;
  X : integer;
  Y : integer;
  fi : integer;
  scale : double;
  scaleMeh : double;
  index : integer;
  zG : integer;
  X0 : double;
  Y0 : double;
  points : integer;
  IsDraggingMode : boolean;
  IsDragging : boolean;
  X_Drag_Start : double;
  Y_Drag_Start : double;
  X_Drag_Start_ : double;
  Y_Drag_Start_ : double;
  X_Drag : double;
  Y_Drag : double;
  Click : boolean;
  EditZG : boolean;
  reverse : boolean;
  Ymax, Step : double;
  Xmin, Xmax : double;
  A,B: integer;
  L1, L2, L3, W, H, HP  : double;
  PressX1, PressX2,PressX3,PressX4,
  PressY1,PressY2,PressY3,PressY4 : double;
  FormX1, FormX2, FormX3, FormX4, FormX5, FormX6, FormX7, FormX8,
  FormY1, FormY2, FormY3, FormY4, Formy5, FormY6, FormY7, FormY8 : double;
  Y3, X3 : array [0..360] of double;
  calc, ACADFileNAme:string;
  Address : string;
  filePath, ClientfilePath : string;
  SiteUAD, if3D : boolean;
end;

var
  S : TSaving;
  MainPointList : TStringList;

implementation




initialization
  MainPointList := TStringList.Create;
finalization

end.
