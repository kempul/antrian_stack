program Project1AntrianStak;

uses
  Vcl.Forms,
  Unit1Antrian in 'Unit1Antrian.pas' {Form1},
  menuU in 'menuU.pas' {Form1_pembuka},
  identitasU in 'identitasU.pas' {Form1_Identitas},
  pesan_enum in 'pesan_enum.pas',
  paddingU in 'paddingU.pas',
  roundCornerU in 'roundCornerU.pas',
  entriJkn in 'entriJkn.pas' {Form1_entriJkn},
  entriNik in 'entriNik.pas' {Form1_entriNik},
  entriRm in 'entriRm.pas' {Form1_entriRm},
  dm_antri in 'dm_antri.pas' {dataAntri: TDataModule},
  aaaliCrypt in 'aaaliCrypt.pas',
  brPesertaU in 'brPesertaU.pas',
  brCommonsU in 'brCommonsU.pas',
  formBiayaU in 'formBiayaU.pas' {Form1Biaya},
  formEntriU in 'formEntriU.pas' {Form1Entri};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdataAntri, dataAntri);
  Application.Run;
end.
