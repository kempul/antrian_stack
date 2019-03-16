unit identitasU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvButton,
  JvTransparentButton, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  System.ImageList, Vcl.ImgList, JvNavigationPane, Vcl.Imaging.jpeg,
  JvStaticText, Vcl.Imaging.pngimage, JvgLabel;

type
  TForm1_Identitas = class(TForm)
    imageList1: TImageList;
    panel2: TPanel;
    panelDalam: TPanel;
    panel4: TPanel;
    img1: TImage;
    txt1: TJvStaticText;
    panel5: TPanel;
    img2: TImage;
    txt2: TJvStaticText;
    panel3: TPanel;
    img3: TImage;
    txt3: TJvStaticText;
    panel7: TPanel;
    panelBawah: TPanel;
    jvgLabel1: TJvStaticText;
    jvgLabel3: TJvStaticText;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure jvgLabel1Click(Sender: TObject);
    procedure txt3Click(Sender: TObject);
    procedure txt1Click(Sender: TObject);
    procedure img1Click(Sender: TObject);
    procedure img3Click(Sender: TObject);
    procedure img2Click(Sender: TObject);
    procedure txt2Click(Sender: TObject);
  private
    { Private declarations }
    var teks : string;
    procedure awal;
  public
    { Public declarations }
  end;

var
  Form1_Identitas: TForm1_Identitas;

implementation

{$R *.dfm}
     uses System.StrUtils, paddingU, Unit1Antrian, roundCornerU, pesan_enum;

procedure TForm1_Identitas.awal;
begin
RoundCornerOf(panel3);
RoundCornerOf(panel4);
RoundCornerOf(panel5);

end;

procedure TForm1_Identitas.FormResize(Sender: TObject);
begin
panel2.Left := (ClientWidth - panel2.Width) div 2;
panel2.Top := (ClientHeight - panel2.Height) div 2;
end;

procedure TForm1_Identitas.FormShow(Sender: TObject);
begin
awal;
end;

procedure TForm1_Identitas.img1Click(Sender: TObject);
begin
Form1.buka_menu(ord(entri_jkn));
end;

procedure TForm1_Identitas.img2Click(Sender: TObject);
begin
Form1.buka_menu(ord(entri_rm));
end;

procedure TForm1_Identitas.img3Click(Sender: TObject);
begin
Form1.buka_menu(ord(entri_ktp));

end;

procedure TForm1_Identitas.jvgLabel1Click(Sender: TObject);
begin
form1.buka_menu(0);

end;

procedure TForm1_Identitas.txt1Click(Sender: TObject);
begin
Form1.buka_menu(ord(entri_jkn));
end;

procedure TForm1_Identitas.txt2Click(Sender: TObject);
begin
Form1.buka_menu(ord(entri_rm));
end;

procedure TForm1_Identitas.txt3Click(Sender: TObject);
begin
Form1.buka_menu(ord(entri_ktp));
end;

end.
