unit brPesertaU;

interface
   uses Dialogs, Classes, brCommonsU, System.SysUtils, System.StrUtils;
type

  brPeserta = class(bridgeCommon)
    private
    procedure masukkanGetPeserta;
    procedure identifikasiPeserta(puskesmas : Integer; tanggal : TDateTime; sl : TStringList);
    public
    aScript : TStringList;
    function getPeserta (kataKunci : string) : Boolean;
    function cekPesertaAndro (puskesmas : Integer; tanggal : TDateTime) : Boolean;
    constructor Create;
    destructor destroy;
//    property Uri : string;
  end;


implementation
     uses SynCommons;

{ brPeserta }

function brPeserta.cekPesertaAndro(puskesmas : Integer; tanggal : TDateTime): Boolean;
var
  sql0 , sql1, sqlx0, sqlx1, tanggalStr : string;
  tSL, tSL1 : TStringList;
  I: Integer;
begin
DateTimeToString(tanggalStr, 'YYYY-MM-DD', tanggal);
sql0 := 'select kartu_bpjs from andro.daftar_andro where puskesmas = %s and tanggal = %s and ' +
        'biaya = ''JKN'' and alasan = '''' and fcm = false and cek_jkn = false;';
sql1 := Format(sql0, [IntToStr(puskesmas), QuotedStr(tanggalStr)]);

tSL := TStringList.Create;
try
fdQuery.Close;
fdQuery.SQL.Clear;
fdQuery.SQL.Add(sql1);
fdQuery.Open();

if not fdQuery.IsEmpty then
begin
   fdQuery.First;
   while not fdQuery.Eof do
   begin
     tSL.Add(fdQuery.FieldByName('kartu_bpjs').AsString);
     fdQuery.Next;
   end;
   fdQuery.Close;
end else fdQuery.Close;

if tSL.Count > 0 then
begin
  for I := 0 to tSL.Count - 1 do  getPeserta(tSL[i]);
end;

// update berdasarka hasil get peserta
if tSL.Count > 0 then identifikasiPeserta(puskesmas, tanggal, tSL);

finally
  tSL.Free;
end;

FDConn.Close;
end;

constructor brPeserta.Create;
begin
  inherited Create;
  aScript := TStringList.Create;
end;

destructor brPeserta.destroy;
begin
   aScript.Free;
   inherited;
end;

function brPeserta.getPeserta(kataKunci: string): Boolean;
var sql0, sql1 : string;
begin
Result := False;
parameter_bridging('PESERTA', 'GET');
//ShowMessage(uri);
Uri := StringReplace( Uri, '{keyword}', kataKunci,  []);
//Uri := StringReplace( Uri, '{start}', mulaiDari,  []);
//Uri := StringReplace(Uri, '{limit}', jumlahData, []);
//ShowMessage(uri);

Result:= httpGet(uri);

if Result then masukkanGetPeserta;
FDConn.Close;
end;

procedure brPeserta.identifikasiPeserta(puskesmas : Integer; tanggal : TDateTime; sl: TStringList);
var
  sql0, sql1, sqlx0, sqlx1, tanggalStr : string;
  tSL : TStringList;
  i : Integer;
begin
  DateTimeToString(tanggalStr, 'YYYY-MM-DD', tanggal);
  tSL := TStringList.Create;
  sqlx0 := 'update andro.daftar_andro set cek_jkn = true, jkn_aktif = %s where puskesmas = %s and tanggal = %s and kartu_bpjs = %s;';
  sql0 := 'SELECT (jkn.peserta.is_provider and jkn.peserta.is_aktif) as hasil FROM jkn.peserta where "noKartu" = %s;';
  try
    for I := 0 to sl.Count - 1 do
      begin
        sql1 := Format(sql0, [QuotedStr(sl[i])]);
        fdQuery.Close;
        fdQuery.SQL.Clear;
        fdQuery.SQL.Add(sql1);
        fdQuery.Open();
        sqlx1 := Format(sqlx0,[
                  upperCase(BoolToStr(fdQuery.FieldByName('hasil').AsBoolean, True)),
                  intToStr(puskesmas),
                  QuotedStr(tanggalStr),
                  QuotedStr(sl[i])
                  ]);
        tSL.Add(sqlx1);
        fdQuery.Close;
      end;
    jalankanScript(tSL);
  finally
    tSL.Free;
  end;
end;

procedure brPeserta.masukkanGetPeserta;
var dataResp, dataList : Variant;
    i : Integer;
    tSl : TStringList;
    sqlDel0, sqlDel1, sql0, sql1 : string;
    noKartu, nama, kdProvider, kdProviderGigi, noKtp, ketAktif, pstProl, pstPrb  : string;
    aktif : Boolean;
begin
//       ShowMessage('awal masukkan get');
if logRest('GET', 'PESERTA', tsResponse.Text) then
begin
   sqlDel0 := 'delete from jkn.peserta where no_kartu = %s;';
   sql0 := 'insert into jkn.peserta(no_kartu, kd_provider, no_ktp, aktif, ket_aktif, pst_prol, pst_prb) ' +
            'values(%s, %s, %s, %s, %s, %s, %s);';
   tsL := TStringList.Create;
   try
   dataResp := _jsonFast(tsResponse.Text);
// ShowMessage(tsResponse.Text);

       noKartu := dataResp.response.noKartu;
       nama := dataResp.response.nama;
       kdProvider := dataResp.response.kdProviderPst.kdProvider;

       if VarIsEmptyOrNull(dataResp.response.kdProviderGigi.kdProvider) then
           kdProviderGigi := '' else  kdProviderGigi := dataResp.response.kdProviderGigi.kdProvider;

       if VarIsEmptyOrNull(dataResp.response.noKTP) then
               noKTP := '' else noKTP := dataResp.response.noKTP;

       pstProl := dataResp.response.pstProl;
       pstPrb := dataResp.response.pstPrb;

       aktif := dataResp.response.aktif;
       ketAktif := dataResp.response.ketAktif;

//       ShowMessage('BooltoStr (nonSpesialis, True)');

       sqlDel1 := Format(sqlDel0,[QuotedStr(noKartu)]);
       tSl.Add(sqlDel1);

       sql1 := Format(sql0, [
                            quotedStr(noKartu),
                            quotedStr(kdProvider),
                            quotedStr(noKtp),
                            boolToStr(aktif, True),
                            quotedStr(ketAktif),
                            QuotedStr(pstProl),
                            QuotedStr(pstPrb)
                            ]);
       tSl.Add(sql1);
       //showMessage(sqlDel1);
       //showMessage(sql1);
   finally
     //aScript.Assign(tsl);
     jalankanScript(tSl);
     FreeAndNil(tSl);
   end;
end;
end;

end.
