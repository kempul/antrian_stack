unit formEntriU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Touch.Keyboard, Vcl.StdCtrls,
  Vcl.ExtCtrls, JvExControls, JvgLabel, JvStaticText, JvExStdCtrls, JvCombobox,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, frxClass, frxDBSet;

type
  TForm1Entri = class(TForm)
    panel2: TPanel;
    txt3: TJvStaticText;
    panelBawah: TPanel;
    jvgLabel3: TJvStaticText;
    jvgLabel1: TJvStaticText;
    panel4: TPanel;
    cbb1: TComboBox;
    panel3: TPanel;
    img1: TImage;
    txt1: TJvStaticText;
    frxdb1: TfrxDBDataset;
    frxReport1: TfrxReport;
    procedure FormResize(Sender: TObject);
    procedure jvgLabel3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure jvgLabel1Click(Sender: TObject);
  private
    { Private declarations }
    idKunjungan : string;
    isBpjsValid : Boolean;
    iNomorAntri : Integer;
    procedure ambil_poli;
    procedure validasi_jkn(no_kartu : string);
    procedure daftarkan;
    procedure kirim_dinkes(pasien : string; kunjungan : string);
    procedure kirim_dinkes_nunggu(pasien : string; kunjungan : string);
    function ambil_kunjungan : string;
    procedure awal;
    function cek_aktif(no_kartu : string) : Boolean;

    procedure cetak_antri;
    function buat_sidikjari : string;
    procedure insert_antri(sidikJari : String);

  public
    { Public declarations }
  end;

var
  Form1Entri: TForm1Entri;

implementation

{$R *.dfm}

uses Unit1Antrian, pesan_enum, roundCornerU, dm_antri, OtlParallel, brPesertaU;

function TForm1Entri.ambil_kunjungan: string;
begin
idKunjungan := '';
//ShowMessage('sebelum ambil kunjungan');
with dataAntri do
begin
  fdQKunjunganAmbil.Close;
  fdQKunjunganAmbil.ParamByName('pasien').AsString := Form1.dPasien;
  fdQKunjunganAmbil.Open();

  if not fdQKunjunganAmbil.IsEmpty then
    idKunjungan := fdQKunjunganAmbil.FieldByName('idxstr').AsString;
  Result := idKunjungan;
end;
//ShowMessage('id Kunjungan : ' + idKunjungan);
end;

procedure TForm1Entri.ambil_poli;
begin
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
end;

procedure TForm1Entri.awal;
begin
dataAntri.FDConnection1.Connected := False;
isBpjsValid := False;

if Form1.dBiaya = 'JKN' then
begin
  //harus cek aktif atau tidaknya kartu
  //nanti akan dipakai kalau biaya dipilih adalah jkn, jika bayar, abaikan
   Parallel.Async(
   procedure
   begin
      validasi_jkn(Form1.dJkn);
   end
   );
end;

RoundCornerOf(panel4);
//RoundCornerOf(panel5);

ambil_poli;

end;

function TForm1Entri.buat_sidikjari: string;
var
  theGUID : TGUID;
begin
CreateGUID(theGUID);
Result := GUIDToString(theGUID);
end;

function TForm1Entri.cek_aktif(no_kartu: string): Boolean;
begin
    with dataAntri do
    begin
      Result := False;
      fdQ1.Close;
      fdQ1.ParamByName('no_kartu').AsString := no_kartu;
      fdQ1.Open();

      Result := fdQ1.FieldByName('jumlah').AsInteger > 0;

     // ShowMessage(IntToStr(fdQ1.FieldByName('jumlah').AsInteger));
      fdQ1.Close;
    end;

end;

procedure TForm1Entri.cetak_antri;
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

  iNomorAntri := fdQAntriAmbil.FieldByName('nomor').AsInteger;
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

procedure TForm1Entri.daftarkan;
var
  sdhAda : Boolean;
begin
sdhAda := False;
if Form1.dBiaya = 'JKN' then
  if not isBpjsValid then
  begin
    ShowMessage('Sayangnya validasi Kartu Bpjs gagal!!');
    Exit;
  end;
//ShowMessage('sebelum qdaftar');

  with dataAntri do
begin
  fdQ2.Close;
  fdQ2.ParamByName('pasien').AsString := Form1.dPasien;
  fdQ2.ParamByName('poli').AsString := cbb1.Items[cbb1.ItemIndex];
  fdQ2.Open();

  sdhAda := fdQ2.FieldByName('jml').AsInteger > 0;
  fdQ2.Close;
end;

if sdhAda then
begin
  ShowMessage('Pasien sudah didaftar pada tanggal dan poli yang sama');
  Exit;
end;

try
  cetak_antri;
finally
  with dataAntri do
begin
  fdQDaftar.ParamByName('pasien').AsString := Form1.dPasien;
  fdQDaftar.ParamByName('poli').AsString := cbb1.Items[cbb1.ItemIndex];
  fdQDaftar.ParamByName('biaya').AsString := Form1.dBiaya;
  fdQDaftar.ParamByName('antri').AsInteger := iNomorAntri;
  fdQDaftar.ExecSQL;
end;

end;
//ShowMessage('setelah qdaftar');
end;

procedure TForm1Entri.FormResize(Sender: TObject);
begin
panel2.Left := (ClientWidth - panel2.Width) div 2;
panel2.Top := (ClientHeight - panel2.Height) div 2;
jvgLabel3.Width := panelBawah.Width div 2;
end;

procedure TForm1Entri.FormShow(Sender: TObject);
begin
awal;
end;

procedure TForm1Entri.insert_antri(sidikJari: String);
begin
with dataAntri do
begin
  fdQAntri.ParamByName('sidik').AsString := sidikjari;
  fdQAntri.ExecSQL;
end;

end;

procedure TForm1Entri.jvgLabel1Click(Sender: TObject);
var tes : string;
begin
try
daftarkan;
finally
//ShowMessage('Terima Kasih');
  tes := ambil_kunjungan;
//ShowMessage(tes);
  //if Length(idKunjungan) > 3 then kirim_dinkes(Form1.dPasien, idKunjungan);
//ShowMessage('akhir');
  dataAntri.FDConnection1.Connected := False;
  ShowMessage('Terima Kasih');

Form1.buka_menu(ord(tutup));

end;
end;

procedure TForm1Entri.jvgLabel3Click(Sender: TObject);
begin
Form1.buka_menu(Form1.dSebelum);

end;

procedure TForm1Entri.kirim_dinkes(pasien : string; kunjungan: string);
begin

end;

procedure TForm1Entri.kirim_dinkes_nunggu(pasien, kunjungan: string);
begin
end;

procedure TForm1Entri.validasi_jkn(no_kartu: string);
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
end;

end.
