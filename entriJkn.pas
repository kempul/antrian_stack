unit entriJkn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Touch.Keyboard, Vcl.StdCtrls,
  Vcl.ExtCtrls, JvExControls, JvgLabel, JvStaticText;

type
  TForm1_entriJkn = class(TForm)
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
    function cek_jkn(no_kartu : string) : Boolean;
  public
    { Public declarations }
  end;

var
  Form1_entriJkn: TForm1_entriJkn;

implementation

{$R *.dfm}

uses Unit1Antrian, pesan_enum, dm_antri;

function TForm1_entriJkn.cek_jkn(no_kartu: string): Boolean;
begin
Form1.dJkn := edit2.Text;
Form1.dPasien := '';
with dataAntri do
begin
  fdQJknCari.Close;
  fdQJknCari.ParamByName('bpjs').AsString := no_kartu;
  fdQJknCari.Open();

  if not fdQJknCari.IsEmpty then
    begin
    Form1.dPasien := fdQJknCari.FieldByName('idxstr').AsString;
    Form1.dNik := fdQJknCari.FieldByName('nik').AsString;
    Form1.dJkn := fdQJknCari.FieldByName('kartu_bpjs').AsString;
    Form1.dRm := fdQJknCari.FieldByName('mr').AsString;
    end
    else
    Form1.dPasien := '';
  Result := Length(Form1.dPasien) > 3;
end;

end;


procedure TForm1_entriJkn.FormResize(Sender: TObject);
begin
panel2.Left := (ClientWidth - panel2.Width) div 2;
panel2.Top := (ClientHeight - panel2.Height) div 2;
jvgLabel3.Width := panelBawah.Width div 2;
end;

procedure TForm1_entriJkn.FormShow(Sender: TObject);
begin

edit2.Clear;
edit2.SetFocus;
end;

procedure TForm1_entriJkn.jvgLabel1Click(Sender: TObject);
begin
if Length(edit2.Text) <> 13 then
begin
  ShowMessage('Jumlah digit harus 13!');
  Exit;
end;

if cek_jkn(edit2.Text) then
begin
  Form1.dSebelum := Ord(entri_jkn);
  Form1.buka_menu(ord(entri_biaya));
end else ShowMessage('Sayangnya, Data tidak ditemukan!!');


end;

procedure TForm1_entriJkn.jvgLabel3Click(Sender: TObject);
begin
Form1.buka_menu(ord(identitas_menu));
end;

end.
