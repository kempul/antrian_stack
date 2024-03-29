unit menuU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvButton,
  JvTransparentButton, Vcl.ExtCtrls, JvBitmapButton, System.ImageList,
  Vcl.ImgList, Vcl.StdCtrls, JvNavigationPane, System.Actions, Vcl.ActnList,
  Vcl.Imaging.pngimage, JvStaticText, Vcl.Imaging.jpeg, frxClass, frxDBSet,
  frxDMPExport;

type
  TForm1_pembuka = class(TForm)
    imageList1: TImageList;
    panel3: TPanel;
    actlst1: TActionList;
    actAntri: TAction;
    frxdb1: TfrxDBDataset;
    frxReport1: TfrxReport;
    panel2: TPanel;
    txt3: TJvStaticText;
    panelDalam: TPanel;
    panel4: TPanel;
    img1: TImage;
    txt1: TJvStaticText;
    panel5: TPanel;
    img2: TImage;
    txt2: TJvStaticText;
    procedure FormResize(Sender: TObject);
    procedure img1Click(Sender: TObject);
    procedure actAntriExecute(Sender: TObject);
    procedure img2Click(Sender: TObject);
    procedure txt1Click(Sender: TObject);
    procedure txt2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    iDummi : Integer;
    iPuskesmas : Integer;
    procedure awal;
    function buat_sidikjari : string;
    procedure insert_antri(sidikjari : string);
    procedure cetak_antri;
    procedure proses_antri(puskesmas : Integer; tanggal : TDateTime; sidik : string);
  public
    { Public declarations }
  end;

var
  Form1_pembuka: TForm1_pembuka;

implementation

{$R *.dfm}

uses Unit1Antrian, pesan_enum, roundCornerU, dm_antri, OtlParallel;

{ TForm1_pembuka }

procedure TForm1_pembuka.actAntriExecute(Sender: TObject);
begin
ShowMessage('tes');
end;

procedure TForm1_pembuka.awal;
begin
RoundCornerOf(panel4);
RoundCornerOf(panel5);
with dataAntri do
begin
  fdQPuskesmas.Close;
  fdQPuskesmas.Open();

  iPuskesmas := fdQPuskesmas.FieldByName('kd_cabang').AsInteger;

  fdQPuskesmas.Close;
end;

dataAntri.FDConnection1.Connected := False;
end;

function TForm1_pembuka.buat_sidikjari: string;
var
  theGUID : TGUID;
begin
CreateGUID(theGUID);
Result := GUIDToString(theGUID);
end;

procedure TForm1_pembuka.cetak_antri;
var
  iSidik : string;
begin
iSidik := buat_sidikjari;
insert_antri(iSidik);
with dataAntri do
begin
  fdQAntriAmbil.Close;
  fdQAntriAmbil.ParamByName('sidik').AsString := iSidik;
  fdQAntriAmbil.Open();
end;
try
  frxReport1.PrepareReport();

  frxReport1.Print;
finally
  dataAntri.fdQAntriAmbil.Close;
end;
//proses_antri(iPuskesmas, Now, iSidik);
dataAntri.FDConnection1.Connected := False;
//ShowMessage('Terima Kasih, Silahkan Ambil Cetakan Antrian');
end;

procedure TForm1_pembuka.FormResize(Sender: TObject);
begin
panel2.Left := (ClientWidth - panel2.Width) div 2;
panel2.Top := (ClientHeight - panel2.Height) div 2;
end;

procedure TForm1_pembuka.FormShow(Sender: TObject);
begin
awal;
end;

procedure TForm1_pembuka.img1Click(Sender: TObject);
begin
cetak_antri;
end;

procedure TForm1_pembuka.img2Click(Sender: TObject);
begin
Form1.buka_menu(ord(identitas_menu));
end;

procedure TForm1_pembuka.insert_antri(sidikjari: string);
begin
with dataAntri do
begin
  fdQAntri.ParamByName('sidik').AsString := sidikjari;
  fdQAntri.ExecSQL;
end;
end;

procedure TForm1_pembuka.proses_antri(puskesmas: Integer; tanggal: TDateTime; sidik : string);
begin
end;

procedure TForm1_pembuka.txt1Click(Sender: TObject);
begin
cetak_antri;
end;

procedure TForm1_pembuka.txt2Click(Sender: TObject);
begin
Form1.buka_menu(ord(identitas_menu));
end;

end.
