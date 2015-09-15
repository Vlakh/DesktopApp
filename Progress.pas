unit Progress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFormProg = class(TForm)
    ProgressBar: TProgressBar;
    LabelString: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormProg: TFormProg;

implementation

{$R *.dfm}

end.
