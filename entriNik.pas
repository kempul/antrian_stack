unit entriNik;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Touch.Keyboard, Vcl.StdCtrls,
  Vcl.ExtCtrls, JvExControls, JvgLabel, JvStaticText;

type
  TForm1_entriNik = class(TForm)
    edit2: TEdit;
    touchKey1: TTouchKeyboard;
    panel2: TPanel;
    txt1: TJvStaticText;
    panelBawah: TPanel;
    jvgLabel3: TJvStaticText;
    jvgLabel1: TJvStaticText;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure jvgLabel3Click(Sender: TObject);
    procedure jvgLabel1Click(Sender: TObject);
  private
    { Private declarations }
    function cek_nik(nik : string) : Boolean;
  public
    { Public declarations }
  end;

var
  Form1_entriNik: TForm1_entriNik;

implementation

{$R *.dfm}

uses Unit1Antrian, pesan_enum, dm_antri;

function TForm1_entriNik.cek_nik(nik: string): Boolean;
begin
Form1.dPasien := '';
with dataAntri do
begin
  fdQNikCari.Close;
  fdQNikCari.ParamByName('nik').AsString := nik;
  fdQNikCari.Open();

  if not fdQNikCari.IsEmpty then
      begin
    Form1.dPasien := fdQNikCari.FieldByName('idxstr').AsString;
    Form1.dNik := fdQNikCari.FieldByName('nik').AsString;
    Form1.dJkn := fdQNikCari.FieldByName('kartu_bpjs').AsString;
    Form1.dRm := fdQNikCari.FieldByName('mr').AsString;
    end
 else
    Form1.dPasien := '';
  Result := Length(Form1.dPasien) > 3;
end;
end;

procedure TForm1_entriNik.FormResize(Sender: TObject);
begin
panel2.Left := (ClientWidth - panel2.Width) div 2;
panel2.Top := (ClientHeight - panel2.Height) div 2;
jvgLabel3.Width := panelBawah.Width div 2;
end;

procedure TForm1_entriNik.FormShow(Sender: TObject);
begin
edit2.Clear;
edit2.SetFocus;
end;

procedure TForm1_entriNik.jvgLabel1Click(Sender: TObject);
begin
if Length(edit2.Text) <> 16 then
begin
  ShowMessage('Jumlah digit harus 16!');
  Exit;
end;

if cek_nik(edit2.Text) then
begin
  Form1.dSebelum := Ord(entri_ktp);
  Form1.buka_menu(ord(entri_biaya));
end else ShowMessage('Sayangnya, Data tidak ditemukan!!');
end;

procedure TForm1_entriNik.jvgLabel3Click(Sender: TObject);
begin
Form1.buka_menu(ord(identitas_menu));
end;

end.
