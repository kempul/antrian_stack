unit antrikanU;

interface
   uses System.Classes, Winapi.MMSystem, System.SysUtils, System.StrUtils, Vcl.Dialogs;
   type
    Antrian = class
      private
      fAntri : Integer;
      fLoket : Integer;
      suaraFile : TStringList;
      dbFile : TStringList;
      procedure masukkan_bawah12(angka : Integer);
      procedure masukkan_belasan(angka : Integer);
      procedure masukkan_bawah100(angka : Integer);
      procedure masukkan_bawah200(angka : Integer);
      procedure masukkan_bawah1000(angka : Integer);
      procedure susunFileAntri(i : integer);
      public
      procedure mainkan;
      constructor create(antri : Integer; loket : Integer);
      destructor destroy;
    end;
implementation

{ Antrian }

procedure Antrian.masukkan_bawah200(angka: Integer);
  var sisa : Integer;
begin
  sisa := angka - 100;
  if angka = 100 then suaraFile.Add('seratus.wav') else
  begin
  suaraFile.Add('seratus.wav');
  if sisa < 12 then masukkan_bawah12(sisa) else
  if sisa < 20 then masukkan_belasan(sisa) else masukkan_bawah100(sisa);
  end;
end;

procedure Antrian.masukkan_bawah12(angka: Integer);
begin
suaraFile.Add(dbFile[angka-1]);
end;

procedure Antrian.masukkan_bawah100(angka: Integer);
var satuan : Integer;
    puluhan : Integer;
    strAngka : string;
begin
  puluhan := angka div 10;
  masukkan_bawah12(puluhan);
  suaraFile.Add('puluh.wav');
  satuan := angka mod 10;
  if (satuan > 0) then masukkan_bawah12(satuan);


end;

procedure Antrian.masukkan_bawah1000(angka: Integer);
var ratusan, sisa : Integer;
begin
ratusan := angka div 100;
masukkan_bawah12(ratusan);
suaraFile.Add('ratus.wav');
sisa := angka mod 100;
if sisa > 0 then
begin
if sisa < 12 then masukkan_bawah12(sisa) else
if sisa < 20 then masukkan_belasan(sisa) else
if sisa < 100  then masukkan_bawah100(sisa) else
if sisa < 200 then masukkan_bawah200(sisa);

end;
end;

procedure Antrian.masukkan_belasan(angka: Integer);
begin
masukkan_bawah12(angka - 10);
suaraFile.Add('belas.wav');
end;



constructor Antrian.create(antri, loket: Integer);
begin
  inherited create();
  fAntri := antri;
  fLoket := loket;
  suaraFile := TStringList.Create;
  suaraFile.Add('nomor-urut.wav');

  dbFile := TStringList.Create;
  dbFile.Add('satu.wav');
  dbFile.Add('dua.wav');
  dbFile.Add('tiga.wav');
  dbFile.Add('empat.wav');
  dbFile.Add('lima.wav');
  dbFile.Add('enam.wav');
  dbFile.Add('tujuh.wav');
  dbFile.Add('delapan.wav');
  dbFile.Add('sembilan.wav');
  dbFile.Add('sepuluh.wav');
  dbFile.Add('sebelas.wav');
  dbFile.Add('belas.wav');
  dbFile.Add('puluh.wav');
  dbFile.Add('ratus.wav');

  susunFileAntri(fAntri);
  suaraFile.Add('loket.wav');
  susunFileAntri(fLoket);
end;

destructor Antrian.destroy;
begin
suaraFile.Free;
inherited destroy;
end;

procedure Antrian.mainkan;
var i : Integer;
begin
   //ShowMessage(IntToStr(suaraFile.Count));
   for I := 0 to suaraFile.Count-1 do
        begin
          //ShowMessage(suaraFile[i]);
          sndPlaySound(PWideChar(suaraFile[i]), SND_NOSTOP);
          //Sleep(1000);
        end;
end;



procedure Antrian.susunFileAntri(i: integer);
begin
if i < 12 then masukkan_bawah12(i) else
if i < 20 then masukkan_belasan(i) else
if i < 100 then masukkan_bawah100(i) else
if i < 200 then masukkan_bawah200(i) else
masukkan_bawah1000(i);
end;


end.
