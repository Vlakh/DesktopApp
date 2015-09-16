unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ActiveX,ComObj, Vcl.StdCtrls,
  Vcl.ExtCtrls,ceflib, cefvcl,XPMan, Registry, ShellApi, SyncObjs,progress,

  MainOptions, OpenGL, DGLUT, ObjectEdit, AutoCAD_TLB, OleCtrls, pipes,
  GDIPAPI, GDIPOBJ, Mehanism, Crank, Asur2,  KinematicPair,
  kinematicObjects, VclTee.TeeGDIPlus, Vcl.ComCtrls, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart, Vcl.Samples.Spin, Vcl.Buttons,
  Vcl.Menus, Vcl.OleServer, SHDocVw, Vcl.ImgList, Vcl.Imaging.pngimage,
  System.Actions, Vcl.ActnList, IdBaseComponent, IdAntiFreezeBase,
  Vcl.IdAntiFreeze, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP;

type
  TFormMain = class(TForm)
    PanelParams: TPanel;
    GroupBoxParams: TGroupBox;
    TabParams: TTabControl;
    PropertyPages: TNotebook;
    GroupBoxStep: TGroupBox;
    CBoxFi: TComboBox;
    PlayPause: TButton;
    GroupBoxSpeed: TGroupBox;
    Speed: TTrackBar;
    ButtonZG: TButton;
    GroupBoxGraph: TGroupBox;
    GroupBox7: TGroupBox;
    LabelScale: TLabel;
    ButtonScale: TButton;
    ButtonONScreen: TButton;
    GroupBox1: TGroupBox;
    TreeObjects: TTreeView;
    PipeConsole1: TPipeConsole;
    Panel: TPanel;
    Memo: TMemo;
    Splitter1: TSplitter;
    Timer: TTimer;
    PlayImages: TImageList;
    PanelMenu: TPanel;
    CBoxDimensions: TCheckBox;
    GroupBoxFormat: TGroupBox;
    CBoxFormat: TComboBox;
    GroupBox2: TGroupBox;
    EdL1: TEdit;
    EdL2: TEdit;
    EdWidth: TEdit;
    EdHeight: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EdHP: TEdit;
    Label5: TLabel;
    Image1: TImage;
    Image2: TImage;
    BtnAutodesk: TBitBtn;
    BtnUAD: TBitBtn;
    DrawBox: TPaintBox;
    GroupBox3: TGroupBox;
    CBox3D: TComboBox;
    crm: TChromium;
    CBoxAutoLisp: TCheckBox;
    EdAdress: TEdit;
    BtnRefresh: TButton;
    PipeConsoleAcad: TPipeConsole;
    procedure BtnRefreshClick(Sender: TObject);
    procedure PipeConsole1Output(Sender: TObject; Stream: TStream);
    procedure PipeConsole1Stop(Sender: TObject; ExitValue: Cardinal);
    procedure PipeConsole1Error(Sender: TObject; Stream: TStream);
    procedure TabParamsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure DrawBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DrawBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayPauseClick(Sender: TObject);
    procedure ButtonZGClick(Sender: TObject);
    procedure CBoxFiChange(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ButtonScaleClick(Sender: TObject);
    procedure TreeObjectsChange(Sender: TObject; Node: TTreeNode);
    procedure CBoxDimensionsClick(Sender: TObject);
    procedure ButtonONScreenClik(Sender: TObject);
    procedure EdL1Exit(Sender: TObject);
    procedure EdL1Enter(Sender: TObject);
    procedure EdL1KeyPress(Sender: TObject; var Key: Char);
    procedure EdL2Exit(Sender: TObject);
    procedure EdL2KeyPress(Sender: TObject; var Key: Char);
    procedure EdWidthKeyPress(Sender: TObject; var Key: Char);
    procedure EdWidthExit(Sender: TObject);
    procedure EdHeightExit(Sender: TObject);
    procedure EdHeightKeyPress(Sender: TObject; var Key: Char);
    procedure CBoxFormatChange(Sender: TObject);
    procedure EdHPExit(Sender: TObject);
    procedure EdHPKeyPress(Sender: TObject; var Key: Char);
    procedure CBox3DChange(Sender: TObject);
    procedure actGoToExecute(Sender: TObject);
    procedure CBoxAutoLispClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnUADClick(Sender: TObject);
    procedure BtnAutodeskClick(Sender: TObject);
    procedure EdAdressChange(Sender: TObject);
    procedure crmBeforeDownload(Sender: TObject; const browser: ICefBrowser;
      const downloadItem: ICefDownloadItem; const suggestedName: ustring;
      const callback: ICefBeforeDownloadCallback);
    procedure crmBeforeResourceLoad(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const request: ICefRequest; out Result: Boolean);
    procedure PipeConsoleAcadError(Sender: TObject; Stream: TStream);
    procedure PipeConsoleAcadStop(Sender: TObject; ExitValue: Cardinal);

  private
     procedure LispSTART;
     procedure Lisp2DSTART;
     procedure LispEND;
     procedure Lisp2DEND;
     function RandomPassword(PLen: Integer): string;
     procedure RunConsole;
     procedure AcadProcess;
  public
    { Public declarations }
  end;

  TCustomRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
  protected
    procedure OnWebKitInitialized; override;
    function OnProcessMessageReceived(const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage): Boolean; override;
  end;

var
  FormMain: TFormMain;
  ModelSpace, AcadApp : Variant;
  bm: TBitmap;
  cv: TCanvas;

const
  CUSTOMMENUCOMMAND_INSPECTELEMENT = 7241221;

implementation

{$R *.dfm}

procedure TFormMain.AcadProcess;
var
  hK: HKey;
  Value: PWideChar;
  L: Longint;
  str : string;
  OleStr: PWideChar;
  Registry : TRegistry;
  i : integer;
  bytes: TBytes;
begin
  FormProg.Show;
  //=====================   5%
  FormProg.progressbar.Position := 5;
  FormProg.LabelString.Caption := 'Cоздается AutoLISP программа: 5%';
  //=====================
  Memo.Lines.Clear;
  LispSTART;
  for I := 0 to 4 do
    Memo.Lines.Add(TMehanism(TreeObjects.Items.Item[0].Item[i].Data).Lisp);
  LispEND;
  if not DirectoryExists('c:\Temp') then
    ForceDirectories('c:\Temp');
  Memo.Lines.SaveToFile('C:\Temp\3D.lsp');
  s.ACADFileNAme := RandomPassword(10)+'.dwg';
  //=====================   15%
  FormProg.progressbar.Position := 15;
  FormProg.LabelString.Caption := 'Запуск консольного AutoCAD AcCoreConsole.exe: 15%';
  //=====================

//=========================================
//  ВАРИАНТ СОЗДАНИЯ 3D модели с помощью OLE и COM
//=========================================
  // ЗАПУСК АКАД

//  try
//    AcadApp := GetActiveOleObject('AutoCAD.Application');
//  except
//    AcadApp := CreateOleObject('AutoCAD.Application');
//  end;
//  progressbar1.Position := 30;

  // РАБОТА АКАДА

//  AcadApp.Visible := false;
//  try
//    AcadApp.ActiveDocument.SendCommand('(setvar "SECURELOAD" 0)' +  #$D#$A);
//    AcadApp.ActiveDocument.SendCommand('(load "'+s.FilePath +'3D.lsp")' +  #$D#$A);
//    progressbar1.Position := 50;
//    AcadApp.ActiveDocument.SendCommand(s.calc +  #$D#$A);
//    progressbar1.Position := 66;
//    sleep(5000);
//    AcadApp.ActiveDocument.SaveAs(ExtractFilePath(Application.ExeName)+s.ACADFileNAme,emptyparam,emptyparam);
//    progressbar1.Position := 74;
//    AcadApp.quit;
//  except
//    AcadApp.quit;
//    Cbox3D.ItemIndex := 0;
//    progressbar1.Position := 100;
//    progressbar1.visible := false;
//    exit;
//  end;
//  FormMain.Cursor := crDefault;
//  DrawBox.Cursor := crDefault;
  // Поиск консольного акада

  try
    RegOpenKey(HKEY_CLASSES_ROOT, 'AutoCAD.Application\CLSID', hK);
    L:=1024;
    GetMem(Value,L);
    RegQueryValue(hK, NIL, Value, L);
    str := 'CLSID\'+Value+'\LocalServer32\';
    Try
      Registry := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
    except
      Registry := TRegistry.Create;
    End;
    Registry.RootKey :=  HKEY_CLASSES_ROOT;
    Registry.OpenKey(str,false);
    str:= Registry.ReadString('');
    for I := 0 to str.Length do
       if str[i] = '/' then
    Delete(Str, I-9,str.Length-9);
    str := Str + 'AcCoreConsole.exe';
    Registry.CloseKey;
    Registry.Free;
    FreeMem(Value);
  except
    ShowMessage('Программа не может найти консольную версию AutoCAD :(');
    FormProg.Close;
    Registry.CloseKey;
    Registry.Free;
    FreeMem(Value);
    exit;
  end;
  //=====================   35%
  FormProg.progressbar.Position := 35;
  FormProg.LabelString.Caption := 'Загрузка AutoLISP программы в AcCoreConsole.exe: 35%';
  //=====================
  //консольный акад
  try
    PipeConsoleAcad.Start(str, '');
    bytes := TEncoding.GetEncoding('Windows-1251').GetBytes('(setvar "SECURELOAD" 0)' + #13#10);
    PipeConsoleAcad.Write(bytes[0], Length(bytes));
    bytes := TEncoding.GetEncoding('Windows-1251').GetBytes('(load "C:/Temp/3d.lsp")' + #13#10);
    PipeConsoleAcad.Write(bytes[0], Length(bytes));
    bytes := TEncoding.GetEncoding('Windows-1251').GetBytes('mechanismuad' + #13#10);
    PipeConsoleAcad.Write(bytes[0], Length(bytes));
    bytes := TEncoding.GetEncoding('Windows-1251').GetBytes('_save' + #13#10);
    PipeConsoleAcad.Write(bytes[0], Length(bytes));
    bytes := TEncoding.GetEncoding('Windows-1251').GetBytes('C:\Temp\'+s.ACADFileNAme + #13#10);
    PipeConsoleAcad.Write(bytes[0], Length(bytes));
    bytes := TEncoding.GetEncoding('Windows-1251').GetBytes('_quit' + #13#10);
    PipeConsoleAcad.Write(bytes[0], Length(bytes));
  except
    ShowMessage('AutoCAD не отвечает :(');
    FormProg.Close;
    exit;
  end;
  //=====================   65%
  FormProg.progressbar.Position := 65;
  FormProg.LabelString.Caption := 'Сохранение файла DWG: 65%';
  //=====================
end;

procedure TFormMain.RunConsole;
var
  bytes: TBytes;
begin
  Memo.Lines.Text :=Memo.Lines.Text + 'View and Data API' + #13#10;
  PipeConsole1.Start('ConsoleApp.exe', '');
  While FileExists('C:\Temp\'+s.ACADFileNAme)=false do
  begin
    //ShowMessage('файла пока не существует не существует');
  end;
  //=====================   80%
  FormProg.progressbar.Position := 80;
  FormProg.LabelString.Caption := 'Выгрузка файла DWG на сервер Autodesk: 80%';
  //=====================
  bytes := TEncoding.GetEncoding('Windows-1251').GetBytes('C:\Temp\'+s.ACADFileNAme + #13#10);
  PipeConsole1.Write(bytes[0], Length(bytes));
end;

function TFormMain.RandomPassword(PLen: Integer): string;
   var
   str: string;
 begin
   Randomize;
   //string with all possible chars
  str    := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
   Result := '';
   repeat
     Result := Result + str[Random(Length(str)) + 1];
   until (Length(Result) = PLen);
 end;

procedure TFormMain.actGoToExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl(s.Address);

end;

procedure TFormMain.BtnAutodeskClick(Sender: TObject);
begin
  if edadress.Text = '' then
  begin
    FormMain.Cursor := crHourGlass;
    DrawBox.Cursor := crHourGlass;
    //Application.Minimize;
      showmessage('Для просмотра 3D модели браузер по умолчанию должен иметь WebGL (например Google Chrome)!');
    acadprocess;
    s.siteUAD := false;
    Runconsole;
    DeleteFile(ExtractFilePath(Application.ExeName)+s.ACADFileNAme);
    DeleteFile(ExtractFilePath(Application.ExeName)+'3D.lsp');
  end
  else
    ShellExecute(Handle, nil, PWideChar(edadress.Text), nil, nil, SW_SHOW);
end;

procedure TFormMain.BtnUADClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, 'http://mechanism.hol.es', nil, nil, SW_SHOW);
end;

procedure TFormMain.BtnRefreshClick(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.Reload;
end;

procedure TFormMain.ButtonONScreenClik(Sender: TObject);
begin
  if ((drawbox.Width/mmtopix(s.L1+2*s.l2+s.l2/3)) < (drawbox.Height/mmtopix(s.L3+s.HP+s.L1/2))) or
     (drawbox.Width/mmtopix(s.A) < (drawbox.Height/mmtopix(s.L3+s.HP+s.L1/2)))
    then
      begin
      if drawbox.Width/mmtopix(s.A) < drawbox.Width/mmtopix(s.L1+2*s.l2+s.l2/3) then
        s.scale := drawbox.Width/(mmtopix(s.A)+150)
      else
        s.scale := drawbox.Width/(mmtopix(s.L1+2*s.l2+s.l2/3)+50)
      end
    else
      s.scale := drawbox.Height/(mmtopix(s.L3+s.HP+s.L1/2)+150);
  s.X0 := DrawBox.width/2;
  s.Y0 := DrawBox.height - mmtopix(s.L1/2*s.scale)-35;
  labelscale.Caption :='1 : ' + FloatToStr(1/s.scale);
end;

procedure TFormMain.ButtonScaleClick(Sender: TObject);
begin
  s.scale := 1;
  LabelScale.Caption := '1 : ' + FloatToStr(1/s.scale);
end;

procedure TFormMain.ButtonZGClick(Sender: TObject);
begin
  if s.zG = 1 then
  begin
    s.zG := - 1;
    ButtonZG.ImageIndex := 2
  end else
  begin
    s.zG := 1;
    ButtonZG.ImageIndex := 3
  end;
  s.fi := 360 - s.fi;
  s.reverse := true;
end;

procedure TFormMain.CBox3DChange(Sender: TObject);
begin
  if CBox3D.ItemIndex=0 then
  begin
    crm.visible := false;
    crm.Enabled := false;
    DrawBox.visible := true;
    timer.Enabled := true;
  end
  else
  begin
    crm.Enabled := true;
    acadprocess;
    s.if3D := true;
//    Runconsole;
    DrawBox.visible := false;
    crm.visible := true;
    timer.Enabled := false;
  end;
  FormMain.SetFocus;
end;

procedure TFormMain.CBoxAutoLispClick(Sender: TObject);
begin
  if CBoxAutoLisp.Checked = true then
    Memo.Visible := true
    else
    Memo.Visible := false;

end;

procedure TFormMain.CBoxDimensionsClick(Sender: TObject);
begin
  if CBoxDimensions.Checked then
  begin
    TCrank(TreeObjects.Items[0].Item[0].Data).dimensions := true;
    TAsur2(TreeObjects.Items[0].Item[1].Data).dimensions := true;
    TAsur2(TreeObjects.Items[0].Item[2].Data).dimensions := true;
    TAsur2(TreeObjects.Items[0].Item[3].Data).dimensions := true;
    TAsur2(TreeObjects.Items[0].Item[4].Data).dimensions := true;
  end
    else
  begin
    TCrank(TreeObjects.Items[0].Item[0].Data).dimensions := false;
    TAsur2(TreeObjects.Items[0].Item[1].Data).dimensions := false;
    TAsur2(TreeObjects.Items[0].Item[2].Data).dimensions := false;
    TAsur2(TreeObjects.Items[0].Item[3].Data).dimensions := false;
    TAsur2(TreeObjects.Items[0].Item[4].Data).dimensions := false;
  end;
end;

procedure TFormMain.CBoxFiChange(Sender: TObject);
begin
  if s.zG = -1 then
    s.fi := 360 - cboxfi.ItemIndex
  else
    s.fi := cboxfi.ItemIndex;
end;

procedure TFormMain.CBoxFormatChange(Sender: TObject);
begin
  if CBoxFormat.itemindex=0 then
  begin
    s.A := 760;
    s.B := 550;
  end;
  if CBoxFormat.itemindex=1 then
  begin
    s.A := 1020;
    s.B := 720;
  end;
  if CBoxFormat.itemindex=2 then
  begin
    s.A := 1030;
    s.B := 720;
  end;
  if CBoxFormat.itemindex=3 then
  begin
    s.A := 1300;
    s.B := 920;
  end;
  if CBoxFormat.itemindex=4 then
  begin
    s.A := 1420;
    s.B := 1020;
  end;
  if CBoxFormat.itemindex=5 then
  begin
    s.A := 1620;
    s.B := 1120;
  end;

end;

procedure TFormMain.crmBeforeDownload(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring; const callback: ICefBeforeDownloadCallback);
begin
  callback.Cont(ExtractFilePath(ParamStr(0)) + suggestedName, True);
end;

procedure TFormMain.crmBeforeResourceLoad(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; out Result: Boolean);
var
  u: TUrlParts;
begin
  // redirect home to google
  if CefParseUrl(request.Url, u) then
    if (u.host = 'home') then
    begin
      u.host := 'www.google.com';
      request.Url := CefCreateUrl(u);
    end;
end;

procedure TFormMain.DrawBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbMiddle then
   begin
     S.IsDraggingMode:= true;
     DrawBox.Cursor := crHandPoint;
   end;
  if S.IsDraggingMode then
  begin
    S.IsDragging := true;
    S.X_Drag_Start := X;
    S.Y_Drag_Start := Y;
    S.X_Drag_Start_ := S.X0;
    S.Y_Drag_Start_ := S.Y0;
  end;
end;

procedure TFormMain.DrawBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  S.X := X;
  S.Y := Y;
  if S.IsDragging then
  begin
    S.X_Drag :=  x - S.X_Drag_Start;
    S.Y_Drag :=  y - S.Y_Drag_Start;
    S.X0 := S.X_Drag_Start_ + s.X_Drag;
    S.Y0 := S.Y_Drag_Start_ + s.Y_Drag;
  end;
end;

procedure TFormMain.DrawBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  s.IsDragging := false;
  S.IsDraggingMode := false;
  DrawBox.Cursor := crCross;
end;

procedure TFormMain.EdAdressChange(Sender: TObject);
begin
  if not Length(EdAdress.Text) = 0 then
    ShellExecute(Handle, nil, PWideChar(s.Address), nil, nil, SW_SHOW);
end;

procedure TFormMain.EdHeightExit(Sender: TObject);
begin
  try
    s.L3 := strtofloat(EdHeight.Text);
  except
    EdHeight.Text := FloatToStr(s.L3 );
    EdHeight.SelectAll;;
  end;
end;

procedure TFormMain.EdHeightKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    try
      s.L3 := strtofloat(EdHeight.Text);
    except
      EdHeight.Text := FloatToStr(s.L3 );
      EdHeight.SelectAll;;
    end;
end;

procedure TFormMain.EdHPExit(Sender: TObject);
begin
  try
    s.HP := strtofloat(EdHP.Text);
  except
    EdHP.Text := FloatToStr(s.HP);
    EdHP.SelectAll;;
  end;
end;

procedure TFormMain.EdHPKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  try
    s.HP := strtofloat(EdHP.Text);
  except
    EdHP.Text := FloatToStr(s.HP);
    EdHP.SelectAll;;
  end;
end;

procedure TFormMain.EdL1Enter(Sender: TObject);
begin
  try
    s.L1 := strtofloat(EdL1.Text);
  except
    EdL1.Text := FloatToStr(s.L1);
    EdL1.SelectAll;;
  end;
end;

procedure TFormMain.EdL1Exit(Sender: TObject);
begin
  try
    s.L1 := strtofloat(EdL1.Text);
  except
    EdL1.Text := FloatToStr(s.L1);
    EdL1.SelectAll;;
  end;
end;

procedure TFormMain.EdL1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    try
      s.L1 := strtofloat(EdL1.Text);
    except
      EdL1.Text := FloatToStr(s.L1);
      EdL1.SelectAll;;
    end;

end;

procedure TFormMain.EdL2Exit(Sender: TObject);
begin
  try
    s.L2 := strtofloat(EdL2.Text);
  except
    EdL2.Text := FloatToStr(s.L2);
    EdL2.SelectAll;;
  end;
end;

procedure TFormMain.EdL2KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    try
      s.L2 := strtofloat(EdL2.Text);
    except
      EdL2.Text := FloatToStr(s.L2);
      EdL2.SelectAll;;
    end;
end;

procedure TFormMain.EdWidthExit(Sender: TObject);
begin
  try
    s.W := strtofloat(EdWidth.Text);
  except
    EdWidth.Text := FloatToStr(s.w);
    EdWidth.SelectAll;;
  end;
end;

procedure TFormMain.EdWidthKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    try
      s.W := strtofloat(EdWidth.Text);
    except
      EdWidth.Text := FloatToStr(s.w);
      EdWidth.SelectAll;;
    end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var i : integer;
begin
  crm.visible := false;
  for I := 0 to 359 do
      cboxfi.Items.Add(inttostr(i));
  s.fi := 45;
  cboxfi.ItemIndex := 45;
  s.scale := 1;
  s.index := 0;
  s.X0 := DrawBox.width/2;
  s.Y0 := DrawBox.height - 80;
  s.L1 := 200;
  s.L2 := 400;
  s.L3 := 400;
  S.A := 760;
  s.B := 560;
  s.W := 600;
  s.HP := 50;
  s.scale := drawbox.Width/(mmtopix(s.L1+2*s.l2+2*s.l2/3)+100);
  labelscale.Caption :='1 : ' + FloatToStr(1/s.scale);
  edL1.Text := FloattoStr(s.L1);
  edL2.Text := FloattoStr(s.L2);
  edHeight.Text := FloattoStr(s.L3);
  edWidth.Text := FloattoStr(s.W);
  edHP.Text := FloattoStr(s.HP);
  PropertyPages.ActivePage := 'View';
  o.linage := false;
  // Кривошип
  TreeObjects.Items.Add(nil,'Mechanism');
  TCrank.Create;
  TreeObjects.Items[0].Expand(False);
  TreeObjects.Items[0].Item[s.index -1].Expand(False);
  // Группа Ассура ІІ вида (справа снизу)
  TAsur2.Create;
  TkinematicPair(TAsur2(TreeObjects.Items.Item[0].Item[1].Data).Kpoint[0]) :=
    TkinematicPair(MainPointList.Objects[0]);
  TreeObjects.Items.Item[0].Item[1].Text := 'Asur II RB';
    TreeObjects.Items.Item[0].Item[1].Item[0].Text := 'Point C';
  TreeObjects.Items[0].Item[s.index -1].Expand(False);
  TAsur2(TreeObjects.Items.Item[0].Item[1].Data).ifleft := false;
 //   Группа Ассура ІІ вида (слева снизу)
  TAsur2.Create;
  TkinematicPair(TAsur2(TreeObjects.Items.Item[0].Item[2].Data).Kpoint[0]) :=
    TkinematicPair(MainPointList.Objects[1]);
  TreeObjects.Items.Item[0].Item[2].Text := 'Asur II LB';
  TreeObjects.Items.Item[0].Item[2].Item[0].Text := 'Point D';
  TreeObjects.Items[0].Item[s.index -1].Expand(False);
  TAsur2(TreeObjects.Items.Item[0].Item[2].Data).ifleft := true;
  // Группа Ассура ІІ вида (справа сверху)
  TAsur2.Create;
  TkinematicPair(TAsur2(TreeObjects.Items.Item[0].Item[3].Data).Kpoint[0]) :=
    TkinematicPair(MainPointList.Objects[3]);
  TreeObjects.Items.Item[0].Item[3].Text := 'Asur II RT';
  TreeObjects.Items.Item[0].Item[3].Item[0].Text := 'Point E';
  TreeObjects.Items[0].Item[s.index -1].Expand(False);
  TAsur2(TreeObjects.Items.Item[0].Item[3].Data).ifleft := false;
  TAsur2(TreeObjects.Items.Item[0].Item[3].Data).eks := 50;
  TAsur2(TreeObjects.Items.Item[0].Item[3].Data).ksi := pi/2;
  // Группа Ассура ІІ вида (слева сверху)
  TAsur2.Create;
  TkinematicPair(TAsur2(TreeObjects.Items.Item[0].Item[4].Data).Kpoint[0]) :=
    TkinematicPair(MainPointList.Objects[2]);
  TreeObjects.Items.Item[0].Item[4].Text := 'Asur II LT';
  TreeObjects.Items.Item[0].Item[4].Item[0].Text := 'Point F';
  TreeObjects.Items[0].Item[s.index -1].Expand(False);
  TAsur2(TreeObjects.Items.Item[0].Item[4].Data).ifleft := false;
  TAsur2(TreeObjects.Items.Item[0].Item[4].Data).eks := -50;
  TAsur2(TreeObjects.Items.Item[0].Item[4].Data).ksi := pi/2;
  TreeObjects.Items.AddChild(TreeObjects.Items.Item[0], 'Press');
  bm := TBitmap.Create;
  cv := bm.Canvas;
end;

procedure TFormMain.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if not (CboxFi.Focused) and not (Cbox3D.Focused) and not (Memo.Focused)
  then
  begin
    s.scale := s.scale - 0.01;
    if s.scale <= 0
     then s.scale := 0.001;
    LabelScale.Caption := '1 : ' + FloatToStr(1/s.scale);
  end;
end;

procedure TFormMain.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if not (CboxFi.Focused) and not (Cbox3D.Focused) and not (Memo.Focused)
  then
  begin
    s.scale := s.scale + 0.01;
    LabelScale.Caption := '1 : ' + FloatToStr(1/s.scale);
  end;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  if ((drawbox.Width/mmtopix(s.L1+2*s.l2+s.l2/3)) < (drawbox.Height/mmtopix(s.L3+s.HP+s.L1/2))) or
     (drawbox.Width/mmtopix(s.A) < (drawbox.Height/mmtopix(s.L3+s.HP+s.L1/2)))
    then
      begin
      if drawbox.Width/mmtopix(s.A) < drawbox.Width/mmtopix(s.L1+2*s.l2+s.l2/3) then
        s.scale := drawbox.Width/(mmtopix(s.A)+150)
      else
        s.scale := drawbox.Width/(mmtopix(s.L1+2*s.l2+s.l2/3)+50)
      end
    else
      s.scale := drawbox.Height/(mmtopix(s.L3+s.HP+s.L1/2)+150);
  s.X0 := DrawBox.width/2;
  s.Y0 := DrawBox.height - mmtopix(s.L1/2*s.scale)-35;
  labelscale.Caption :='1 : ' + FloatToStr(1/s.scale);
  edadress.Width := panelmenu.Width - 310;
end;

procedure TFormMain.PipeConsole1Error(Sender: TObject; Stream: TStream);
var
   bytes: TBytes;
begin
   //Вывод сообщений об ошибке
   SetLength(bytes, Stream.Size);
   Stream.Read(bytes, Stream.Size);
end;

procedure TFormMain.PipeConsole1Output(Sender: TObject; Stream: TStream);
var
   bytes: TBytes;
begin
   //Вывод обычных сообщений
   SetLength(bytes, Stream.Size);
   Stream.Read(bytes, Stream.Size);
   Memo.Lines.Text := Memo.Lines.Text + TEncoding.GetEncoding('Windows-1251').GetString(bytes);
end;

procedure TFormMain.PipeConsole1Stop(Sender: TObject; ExitValue: Cardinal);
var
  List:TStringList;
  i,n : integer;
  position : integer;
begin
  s.Address := '';
  for i := 0 to Memo.Lines.Count-1 do
  begin
    position := AnsiPos('http:',Memo.Lines.Strings[i]);
    if position = 1 then
    begin
     for n := i to Memo.Lines.Count-1 do
       s.Address :=s.Address + Memo.Lines.Strings[n];
    end;
  end;
  edAdress.Text := s.Address;
  if s.if3D then
  begin
  sleep(6000);
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl(s.Address);
  end
  else
  begin
    sleep(6000);
    ShellExecute(Handle, nil, PWideChar(s.Address), nil, nil, SW_SHOW);
  end;
  s.if3D := false;
  //=====================   100%
  FormProg.progressbar.Position := 100;
  FormProg.LabelString.Caption := 'Выполнено: 100%';
  FormProg.Close;
  //=====================
end;

procedure TFormMain.PipeConsoleAcadError(Sender: TObject; Stream: TStream);
var
   bytes: TBytes;
begin
   //Вывод сообщений об ошибке
   SetLength(bytes, Stream.Size);
   Stream.Read(bytes, Stream.Size);
end;

procedure TFormMain.PipeConsoleAcadStop(Sender: TObject; ExitValue: Cardinal);
begin
  RunConsole;
end;

procedure TFormMain.PlayPauseClick(Sender: TObject);
begin
  if o.animation then
  begin
    o.animation := false;
    PlayPause.ImageIndex := 0;
  end else
  begin
    o.animation := true;
    PlayPause.ImageIndex := 1;
    PlayPause.Tag := 1;
  end;
end;

procedure TFormMain.TabParamsChange(Sender: TObject);
begin
  if TabParams.TabIndex = 0 then
   PropertyPages.ActivePage := 'view'
  else
  begin
   PropertyPages.ActivePage := 'geometry' ;
   CBox3D.ItemIndex := 0;
   crm.visible := false;
   crm.Enabled := false;
   DrawBox.visible := true;
   timer.Enabled := true;
  end;
end;

procedure TFormMain.TimerTimer(Sender: TObject);
var
  i, step : integer;
  G : TGPGraphics;
  GrayPen, BlackPen2, BlackPen1, PinkPen, RedPen, BluePen, GreenPen, OrangePen: TGPPen;
  GrayBrush, WhiteBrush, BlackBrush, BlueBrush : TGPSolidBrush;
  F6, F8 : TGPFont;
  str : string;
begin
  bm.SetSize(DrawBox.Width, DrawBox.Height);
  cv.Pen.Color := clWhite;
  cv.Rectangle(0,0,DrawBox.width, DrawBox.Height);
    if not (S.index = 0) then
      for i := 0 to S.index - 1 do
      begin
        G := TGPGraphics.Create(cv.Handle);
        // Pens
        GrayPen := TGPPen.Create(MakeColor(255, 100, 100, 100), 0.1); //создаем pen
        BlackPen2 :=TGPPen.Create(MakeColor(255, 0, 0, 0), 2); //создаем pen
        BlackPen1 :=TGPPen.Create(MakeColor(255, 0, 0, 0), 0.1);
        PinkPen :=TGPPen.Create(MakeColor(255, 255, 0, 216), 0.1);
        RedPen := TGPPen.Create(MakeColor(255, 255, 0, 0),2);
        BluePen := TGPPen.Create(MakeColor(255, 0, 0, 255),2);
        GreenPen := TGPPen.Create(MakeColor(255, 0, 255, 0), 0.1);
        OrangePen  := TGPPen.Create(MakeColor(255, 255, 210, 0), 0.1);
        // Fonts
        F6 := TGPFont.Create('Arial',6);
        F8 := TGPFont.Create('Arial',8);
        // Brushes
        WhiteBrush := TGPSolidBrush.Create(MakeColor(255, 255, 255, 255));
        BlackBrush := TGPSolidBrush.Create(MakeColor(255, 0, 0, 0));
        BlueBrush := TGPSolidBrush.Create(MakeColor(255, 0, 0, 255));
        GrayBrush := TGPSolidBrush.Create(MakeColor(255, 100, 100, 100));
        if o.animation then
          begin
            timer.Interval := speed.Max - speed.Position + 1;
            if PlayPause.Tag = 1 then
            begin
              if s.zG = -1 then
              begin
                s.fi := 360 - cboxfi.itemindex;
              end
                else
              s.fi := cboxfi.itemindex;
              PlayPause.Tag := 0;
            end;
            s.fi := s.fi + 1;
            if s.fi >= 360 then
               s.fi := 0;

            TMehanism(TreeObjects.Items.Item[0].Item[i].Data).KinematicScheme(s.fi, g,
              GrayPen, BlackPen2, BlackPen1, PinkPen, RedPen, BluePen, GreenPen, OrangePen,
              GrayBrush, WhiteBrush, BlackBrush, BlueBrush, F6, F8);

            if s.zG = -1 then
              cboxfi.ItemIndex := 360 - s.fi
                else
              cboxfi.ItemIndex := s.fi;
          end else
          // просто схема
          begin
            if s.fi >= 360 then
               s.fi := 0;
            timer.Interval := 50;
            step := s.fi;
            TMehanism(TreeObjects.Items.Item[0].Item[i].Data).KinematicScheme(step, g,
              GrayPen, BlackPen2, BlackPen1, PinkPen, RedPen, BluePen, GreenPen, OrangePen,
              GrayBrush, WhiteBrush, BlackBrush, BlueBrush, F6, F8);
          end;
        // Pens
        GrayPen.Free;  //освобождаем память
        BlackPen2.Free;
        BlackPen1.Free;
        PinkPen.Free;
        RedPen.Free;
        BluePen.Free;
        GreenPen.Free;
        OrangePen.Free;

        // Brushes
        WhiteBrush.Free;
        BlackBrush.Free;
        BlueBrush.Free;
        GrayBrush.Free;

        // Fonts
        F6.Free;
        F8.Free;
        G.Free; //освобождаем память
      end;
  DrawBox.Canvas.Draw(0, 0, bm);
  DrawBox.Canvas.Refresh;
end;

procedure TFormMain.TreeObjectsChange(Sender: TObject; Node: TTreeNode);
var I,n :  integer;
begin
  for I := 0 to s.index -1 do
  begin
    TMehanism(TreeObjects.Items.Item[0].Item[i].Data).selected := false;
    TMehanism(TreeObjects.Items.Item[0].Item[i].Item[0].Data).selected := false;
  end;
  TMehanism(TreeObjects.Items.Item[0].Item[0].Item[1].Data).selected := false;
  if not TreeObjects.Items[0].Selected and not TreeObjects.Items.Item[0].Item[5].Selected then
    TMehanism(TreeObjects.Selected.Data).selected := true
  else
  PropertyPages.ActivePage := 'View';
end;

procedure TFormMain.Lisp2dSTART;
begin
  s.calc := 'MechanismUAD2D';
  Memo.Lines.Add('(defun C:' + s.calc + '()');
  Memo.Lines.Add('(command "_undo" 1000)');
end;

procedure TFormMain.LispSTART;
begin
  s.calc := 'MechanismUAD';
  Memo.Lines.Add('(DEFUN asin (X)');
  Memo.Lines.Add('(ATAN X (SQRT (- 1 (* X X)))))'+ #$D#$A);
  Memo.Lines.Add('(defun kor (lp dp dsp)');
  Memo.Lines.Add(' (setq dw 20.0 dsw 35.0 bsw 30.0 bsp 20.0 bk 14.0)');
  Memo.Lines.Add('(setq rw (/ dw 2.0)  rsw (/ dsw 2.)  rp (/ dp 2.)  rsp (/ dsp 2.) hbk (/ bk 2.) bfs (/ (- bsp bk) 2.0) )');
  Memo.Lines.Add('(setq alfa (asin (/ (- rsw rsp) lp))');
  Memo.Lines.Add('p1 (polar ''(0 0 0) (- (* 0.5 pi) alfa) rsw)');
  Memo.Lines.Add('p2 (polar (list lp 0 0) (- (* 0.5 pi) alfa) rsp)');
  Memo.Lines.Add('p3 (polar ''(0 0 0) (+ (* 1.5 pi) alfa) rsw)');
  Memo.Lines.Add('p4 (polar (list lp 0 0) (+ (* 1.5 pi) alfa) rsp))');
  Memo.Lines.Add('(command "_Pline" ''(0 0 0) p1 p2 (list lp 0 0) p4 p3 "_c")');
  Memo.Lines.Add('(command "_extrude" (entlast) ""  bk "") ');
  Memo.Lines.Add('(setq o1 (entlast))');
  Memo.Lines.Add('(command "_Cylinder" ''(0 0 0) rsw bsw)');
  Memo.Lines.Add('(command "_Union" o1 (entlast) "")');
  Memo.Lines.Add('(command "_Cylinder" (list lp 0 0) rsp bsp)');
  Memo.Lines.Add('(command "_Union" o1 (entlast) "")');
  Memo.Lines.Add('(command "_Cylinder" ''(0 0 0) rw bsw)');
  Memo.Lines.Add('(setq o2 (entlast))');
  Memo.Lines.Add('(command "_Cylinder" (list (+ 0 lp) 0 0) rp bsp)');
  Memo.Lines.Add('(command "_Subtract" o1 "" o2 (entlast) "")');
  Memo.Lines.Add(')'+ #$D#$A);
  Memo.Lines.Add('(defun pov (lp dp ds bs)');
  Memo.Lines.Add('(setq  hpw 22. spw 12.)');
  Memo.Lines.Add('(setq rp (/ dp 2.)  rs (/ ds 2.) )');
  Memo.Lines.Add('(command "_Cylinder" ''(0 0 0) rs bs)');
  Memo.Lines.Add('(setq o1 (entlast))');
  Memo.Lines.Add('(command "_Cylinder" (list lp 0 0) rs bs)');
  Memo.Lines.Add('(setq o2 (entlast))');
  Memo.Lines.Add('(command "_Box" (list 0 (/ spw -2.) (/ (- bs hpw) 2.)) "_l" lp spw hpw)');
  Memo.Lines.Add('(command "_Union" o1 o2 (entlast) "")');
  Memo.Lines.Add('(command "_Cylinder" ''(0 0 0) rp bs)');
  Memo.Lines.Add('(setq o3 (entlast))');
  Memo.Lines.Add('(command "_Cylinder" (list lp 0 0) rp bs) ');
  Memo.Lines.Add('(command "_subtract" o1 "" o3 (entlast) "") ');
  Memo.Lines.Add(')'+ #$D#$A);
  Memo.Lines.Add('(defun C:' + s.calc + '()');
  Memo.Lines.Add('(command "_undo" 1000)');
  Memo.Lines.Add('(setvar "osmode" 16384)');
  Memo.Lines.Add('(setvar "CmdEcho" 0)');
  Memo.Lines.Add('(setvar "BlipMode" 0)');
  Memo.Lines.Add('(setvar "UcsIcon" 3)');
end;

procedure TFormMain.LispEND;
begin
  Memo.Lines.Add('(command "_Shademode" "_G")');
  Memo.Lines.Add('(command "_zoom" "_e") ');
  Memo.Lines.Add(')');
end;

procedure TFormMain.Lisp2DEND;
begin
  Memo.Lines.Add(')');
end;

function TCustomRenderProcessHandler.OnProcessMessageReceived(
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage): Boolean;
begin
    Result := False;
end;

procedure TCustomRenderProcessHandler.OnWebKitInitialized;
begin
{$IFDEF DELPHI14_UP}
  TCefRTTIExtension.Register('app', TTestExtension);
{$ENDIF}
end;


initialization
  CefRemoteDebuggingPort := 9000;
  CefRenderProcessHandler := TCustomRenderProcessHandler.Create;
  CefBrowserProcessHandler := TCefBrowserProcessHandlerOwn.Create;

end.
