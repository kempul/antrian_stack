unit Unit1Antrian;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvButton,
  JvTransparentButton, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, Pipes,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    imageList1: TImageList;
    pipeClient1: TPipeClient;
    pipeServer1: TPipeServer;
    panelUtama: TPanel;
    procedure pipeServer1PipeMessage(Sender: TObject; Pipe: HPIPE;
      Stream: TStream);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    formAktif : TForm;
    procedure loadForm( kelasForm : TFormClass);
    procedure settingMenu;
    procedure awal;

  public
    { Public declarations }
    dNik, dJkn, dRm, dPasien, dBiaya, dPoli : string;
    dSebelum : Integer;

    procedure buka_menu( iOrd : integer);

  end;

var
  Form1: TForm1;

implementation
      uses menuU, identitasU, entriNik, entriRm, entriJkn, formBiayaU, formEntriU;
{$R *.dfm}

{ TForm1 }

procedure TForm1.awal;
begin
caption := 'PowerSoft @ SIMPUS K@ng Bejo';
//form111.storageUmum.StoredValue['versi']:= getAppVersion;
//puskesmas := ambil_puskesmas;
PipeClient1.SendMessage('0');
//update_pulang;

end;

procedure TForm1.buka_menu(iOrd: integer);
var str0 : string;
//i : integer;
begin
str0 := intToStr(iOrd);
PipeClient1.SendMessage(str0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
PipeServer1.Active := True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
PipeServer1.Active := False;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
try
  PipeClient1.Connect(2000);
finally
  awal;
end;
end;

procedure TForm1.loadForm(kelasForm: TFormClass);
begin
if assigned(formAktif) then
begin
FreeAndNil(formAktif);
end;
formAktif := kelasForm.Create(self);
formAktif.Parent:=panelUtama;
formAktif.Width:=panelUtama.Width;
formAktif.Height:=panelUtama.Height;
formAktif.BorderStyle:=bsNone;
formAktif.Align:=alClient;
formAktif.Show;

end;

procedure TForm1.pipeServer1PipeMessage(Sender: TObject; Pipe: HPIPE;
  Stream: TStream);
var
    i : Integer;
    Msg : String;
begin
    SetLength(Msg, Stream.Size div SizeOf(Char));
    Stream.Position := 0;
    Stream.Read(Msg[1], Stream.Size);
//    Memo1.Lines.Add('Rcvd: "' + Msg + '" ' + IntToStr(Pipe));
// ShowMessage(Msg);
i:=StrToIntDef(Msg, 10000);
case i of
0 : loadForm(TForm1_pembuka);
1 : loadForm(TForm1_Identitas);
2 : loadForm(TForm1_entriNik);
3 : loadForm(TForm1_entriJkn);
4 : loadForm(TForm1_entriRm);
5 : loadForm(TForm1Biaya);
6 : loadForm(TForm1Entri);

else
//1001 dmLaporan qpasienKunjungan
//1002 : peringatan pada instalasi lab bahwa ada data baru
//1003 : hapus diagnosa pada dinkes
//ShowMessage(Msg);
//PipeServer1.BroadcastMessage(Msg, 0);
end;

settingMenu;
end;

procedure TForm1.settingMenu;
begin

end;

end.
