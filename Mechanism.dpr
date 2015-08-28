program Mechanism;

uses
  Vcl.Forms,
  sysutils,
  ceflib,
  Windows,
  Main in 'Main.pas' {FormMain},
  Asur2 in 'Asur2.pas',
  Crank in 'Crank.pas',
  DGLUT in 'DGLUT.pas',
  GDIPAPI in 'GDIPAPI.pas',
  GDIPOBJ in 'GDIPOBJ.pas',
  GDIPUTIL in 'GDIPUTIL.pas',
  KinematicObjects in 'KinematicObjects.pas',
  kinematicPair in 'kinematicPair.pas',
  Mehanism in 'Mehanism.pas',
  MainOptions in 'MainOptions.pas',
  ObjectEdit in 'ObjectEdit.pas',
  pipes in 'pipes.pas',
  AutoCAD_TLB in 'AutoCAD_TLB.pas',
  ceferr in 'ceferr.pas',
  ceffilescheme in 'filescheme\ceffilescheme.pas';

{$R *.res}

procedure RegisterSchemes(const registrar: ICefSchemeRegistrar);
begin
  registrar.AddCustomScheme('local', True, True, False);
end;

begin
  CefCache := 'cache';
  CefOnRegisterCustomSchemes := RegisterSchemes;
  CefSingleProcess := False;
  if not CefLoadLibDefault then
    Exit;
  CefRegisterSchemeHandlerFactory('local', '', TFileScheme);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
