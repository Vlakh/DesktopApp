unit Mehanism;

interface
uses Classes, GDIPAPI, GDIPOBJ;
type

TMehanism = class(TObject)
  public
    name : string;
    kind : string;
    selected : boolean;
    index : integer;
    Points : integer;
    dimensions : boolean;
    constructor Create; overload;
    procedure Calculate; virtual;abstract;
    function LISP:string; virtual;abstract;
    function LISP2D:string; virtual;abstract;
    procedure KinematicScheme (i : integer; G : TGPGraphics;
      GrayPen, BlackPen2, BlackPen1, PinkPen,
      RedPen, BluePen, GreenPen, OrangePen : TGPPen;
      GrayBrush, WhiteBrush, BlackBrush, BlueBrush : TGPSolidBrush;
      F6, F8 : TGPFont); virtual;abstract;
end;

implementation

constructor TMehanism.Create;
begin

end;


end.
