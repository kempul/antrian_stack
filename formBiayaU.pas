unit formBiayaU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Touch.Keyboard, Vcl.StdCtrls,
  Vcl.ExtCtrls, JvExControls, JvgLabel, JvStaticText, JvExStdCtrls, JvCombobox,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TForm1Biaya = class(TForm)
    panel2: TPanel;
    txt3: TJvStaticText;
    panelDalam: TPanel;
    panel5: TPanel;
    cbb2: TComboBox;
    panel6: TPanel;
    img2: TImage;
    txt2: TJvStaticText;
    panelBawah: TPanel;
    jvgLabel3: TJvStaticText;
    jvgLabel1: TJvStaticText;
    procedure FormResize(Sender: TObject);
    procedure jvgLabel3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure jvgLabel1Click(Sender: TObject);
  private
    { Private declarations }
    idKunjungan : string;
    isBpjsValid : Boolean;
    function cek_aktif(no_kartu : string) : Boolean;
    procedure ambil_poli;
    procedure validasi_jkn(no_kartu : string);
    procedure daftarkan;
    procedure kirim_dinkes;
    function ambil_kunjungan : string;
    procedure awal;

  public
    { Public declarations }
  end;

var
  Form1Biaya: TForm1Biaya;

implementation

{$R *.dfm}

uses Unit1Antrian, pesan_enum, roundCornerU, dm_antri, OtlParallel, brPesertaU;

function TForm1Biaya.ambil_kunjungan: string;
begin
idKunjungan := '';
with dataAntri do
begin
  fdQKunjunganAmbil.Close;
  fdQKunjunganAmbil.ParamByName('pasien').AsString := Form1.dPasien;
  fdQKunjunganAmbil.Open();

  if not fdQKunjunganAmbil.IsEmpty then
    idKunjungan := fdQKunjunganAmbil.FieldByName('idxstr').AsString;
  Result := idKunjungan;
end;
end;

procedure TForm1Biaya.ambil_poli;
begin
{
with dataAntri do
begin
  fdQPoli.Close;
  fdQPoli.Open();

  cbb1.Clear;
  while not fdQPoli.Eof do
  begin
    cbb1.Items.Add(fdQPoli.FieldByName('poli').AsString);
    fdQPoli.Next;
  end;
  fdQPoli.Close;
  cbb1.ItemIndex := 0;
  cbb1.SetFocus;
end;
}
end;

procedure TForm1Biaya.awal;
begin
dataAntri.FDConnection1.Connected := False;
isBpjsValid := False;
cbb2.ItemIndex := 0;
//RoundCornerOf(panel4);
RoundCornerOf(panel5);


end;

function TForm1Biaya.cek_aktif(no_kartu: string): Boolean;
begin
    with dataAntri do
    begin
      Result := False;
      fdQ1.Close;
      fdQ1.ParamByName('no_kartu').AsString := no_kartu;
      fdQ1.Open();

      Result := fdQ1.FieldByName('jumlah').AsInteger > 0;

    //  ShowMessage(IntToStr(fdQ1.FieldByName('jumlah').AsInteger));
      fdQ1.Close;
    end;
end;

procedure TForm1Biaya.daftarkan;
var
  vbiaya : string;
begin
if cbb2.ItemIndex = 0 then vbiaya := 'BAYAR' else vbiaya := 'JKN';

if cbb2.ItemIndex = 1 then
begin
  if not isBpjsValid then
  begin
    ShowMessage('Maaf, Gagal Validasi Kartu Bpjs di Server Bpjs');
    Exit;
  end;
end;
{
with dataAntri do
begin
  fdQDaftar.ParamByName('pasien').AsString := Form1.dPasien;
  fdQDaftar.ParamByName('poli').AsString := cbb1.Items[cbb1.ItemIndex];
  fdQDaftar.ParamByName('biaya').AsString := vbiaya;
  fdQDaftar.ExecSQL;
end;
}
end;

procedure TForm1Biaya.FormResize(Sender: TObject);
begin
panel2.Left := (ClientWidth - panel2.Width) div 2;
panel2.Top := (ClientHeight - panel2.Height) div 2;
jvgLabel3.Width := panelBawah.Width div 2;
end;

procedure TForm1Biaya.FormShow(Sender: TObject);
begin
awal;
end;

procedure TForm1Biaya.jvgLabel1Click(Sender: TObject);
begin
if cbb2.ItemIndex = 0 then Form1.dBiaya := 'BAYAR' else Form1.dBiaya := 'JKN';

Form1.buka_menu(ord(entri_daftar));
end;

procedure TForm1Biaya.jvgLabel3Click(Sender: TObject);
begin
Form1.buka_menu(Form1.dSebelum);

end;

procedure TForm1Biaya.kirim_dinkes;
begin
end;

procedure TForm1Biaya.validasi_jkn(no_kartu: string);
var adl_berhasil : Boolean;
    aPeserta : brPeserta;
    sql0, sql1 : string;
begin
aPeserta := brPeserta.create;
try
  if aPeserta.getPeserta(no_kartu) then
    // berhasil get
    begin
      isBpjsValid := True;
    end else
    begin
      //get peserta gagal
     // ShowMessage('koneksi ke server PCARE BPJS gagal');
      isBpjsValid := False;
    end;
finally
  aPeserta.Free;
end;
   isBpjsValid := cek_aktif(no_kartu);
   //ShowMessage();
end;

end.
