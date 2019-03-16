unit brCommonsU;

interface
uses Forms, Dialogs, Classes, httpsend, ssl_openssl, ssl_openssl_lib, blcksock,
  flcHash, flcUtils, System.SysUtils, System.json,
  System.DateUtils, JclTimeZones, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Phys.PG,
  FireDAC.Comp.Script, FireDAC.Comp.ScriptCommands;
type
  bridgeCommon = class
     private
      TSLConn : TStringList;
      FBaseUri : string;
      FUri : string;
      FFormatJson : string;
      FJejak : string;

      FFDQuery : TFDQuery;
      FFDConnection : TFDConnection;
      FFDCommand : TFDCommand;
      FFDScript : TFDScript;

     FkeyID : string;
     FconsId : string;
     FuserId : string;
     Fpasswd : string;

     Fpghost, Fpgport, Fpgdb, Fpguser, Fpgpasswd : string;

     FResultCode : Integer;
     FtsHeader : TStringList;
     FtsResponse : TStringList;

     function buatSignature(unixTs : string) : string;
     public
     adl_berhasil : Boolean;
     constructor Create;
     destructor destroy;

     property jejakIdxstr: string read FJejak write FJejak;
     property FDConn: TFDConnection read FFDConnection write FFDConnection;
     property pghost : string read fpghost write fpghost;
     property pgport : string read Fpgport write Fpgport;
     property pgdb : string read Fpgdb write Fpgdb;
     property pguser : string read Fpguser write Fpguser;
     property pgpasswd : string read Fpgpasswd write Fpgpasswd;
     property userid : string read FuserId write FuserId;

     property tsHeader : TStringList read FtsHeader write FtsHeader;
     property ResultCode : Integer read FResultCode write FResultCode;
     property tsResponse : TStringList read FtsResponse write FtsResponse;
     property FormatJson : string  read FFormatJson write FFormatJson;
     property Uri: string read FUri write Furi;
     property fdQuery: TFDQuery  read FFDQuery write FFDQuery;

     function httpGet(aurl : string) :Boolean;
     function httpPost(aurl : string; aData : TStream) :Boolean;
     function httpPut(aurl : string; aData : TStream) :Boolean;
     function httpDelete(aurl : string) :Boolean;
     procedure parameter_bridging(aTransaksi : string; aMetode : string);
     procedure jalankanScript(script : TStringList);
     function logRest(metode, transaksi, response : string) : Boolean;
     procedure buatHeader;


  end;

implementation
  uses SynCommons, aaaliCrypt;

{ bridge }

procedure bridgeCommon.buatHeader;
var unixTs : string;
begin
   unixTS := IntToStr(DateTimeToUnix(utcNow));

FtsHeader.Clear;
FtsHeader.Add('x-cons-id:' + FconsID);
//memoHeader.Lines.Add('x-timestamp:' + IntToStr(DateTimeToUnix(now)));
FtsHeader.Add('x-timestamp:' + unixTs);
FtsHeader.Add('x-signature:' + buatSignature(unixTs));
FtsHeader.Add('x-authorization:Basic '+ MIMEBase64Encode(FUserID + ':' + FPasswd + ':095'));

end;

function bridgeCommon.buatSignature(unixTs : string): string;
var sig : T256BitDigest;

begin
   sig := CalcHMAC_SHA256(FkeyID, FConsID + '&' + unixTS);
   Result := MIMEBase64Encode(SHA256DigestToStrA(sig));
end;


constructor bridgeCommon.Create;
var myConf : Variant;
    rootDir : string;

begin

  TSLConn := TStringList.Create;
  FBaseUri := 'https://new-api.bpjs-kesehatan.go.id';

  FtsHeader := TStringList.Create;
  FtsResponse := TStringList.Create;



//  rootDir := ExtractFilePath(Application.ExeName) + 'param.json';
  myConf :=  _JSonFast(StringFromFile('param.json'));


  FuserId := myConf.bpjs.userId;
  Fpasswd := decodeData(myConf.bpjs.passwd, keyTototo);
  FkeyID := decodeData(myConf.bpjs.key, keyTototo);
  FconsId := decodeData(myConf.bpjs.consId, keyTotoTo);

  Fpghost := myConf.pg.pghost;
  Fpgport := myConf.pg.pgport;
  Fpgdb := myConf.pg.pgdb;
  Fpguser := decodeData( myConf.pg.pguser, keyTototo);
  Fpgpasswd := DecodeData( myConf.pg.pgpasswd , keyTototo);

    FFDConnection := TFDConnection.Create(nil);
  
    TSLConn.Clear;
    TSLConn.Add('User_Name=' + pguser);
    TSLConn.Add('Password=' + pgpasswd);
    TSLConn.Add('Database=' + pgdb);
    TSLConn.Add('Server=' + pghost);
    TSLConn.Add('Port=' + pgport);
    TSLConn.Add('Pooled=True');
//    FFDConnection.Params.Add('DriverID=PG');
    FDManager.AddConnectionDef('PGBR_CONNECTION', 'PG', TSLConn);
    FDManager.Active := True;
    FFDConnection.ConnectionDefName := 'PGBR_CONNECTION';
    FFDConnection.Connected:=true;

    FFDQuery := TFDQuery.Create(nil);
    FFDQuery.Connection := FFDConnection;

    FFDCommand := TFDCommand.Create(nil);
    FFDCommand.Connection := FFDConnection;

    FFDScript := TFDScript.Create(nil);
    FFDScript.Connection := FFDConnection;


  buatHeader;
end;

destructor bridgeCommon.destroy;
begin
if Assigned(FtsResponse) then FreeAndNil(FtsResponse);
if Assigned(FtsHeader) then FreeAndNil(FtsHeader);

  FFDConnection.Close;
  FDManager.Close;
  FFDScript.Free;
  FFDCommand.Free;
  FFDQuery.Free;
  FFDConnection.Free;

  TSLConn.Free;
inherited;
end;


function bridgeCommon.httpDelete(aurl: string): Boolean;
var http : THTTPSend;
    berhasil : Boolean;
begin
   FJejak := '-';
   Result := False;
   FtsResponse.Clear;
   http := THTTPSend.Create;
   http.Headers.Clear;
   http.Headers.AddStrings(FtsHeader);
   try
     berhasil := http.HTTPMethod('DELETE', aurl);
     if berhasil then
     begin
      FResultCode := http.ResultCode;
      FtsResponse.LoadFromStream(http.Document);

      Result := true; //(FResultCode >= 200) and (FResultCode < 300);
     end;

   finally
      http.Free;
   end;
end;

function bridgeCommon.httpGet(aurl: string): Boolean;
var http : THTTPSend;
    berhasil : Boolean;
    V1 : Variant;
    strM, strJudul : string;
begin
    FJejak := '-';
    Result := False;
   FtsResponse.Clear;
   http := THTTPSend.Create;
   if http.Sock.LastError > 0 then
   begin
   ShowMessage('Salah : ' + http.Sock.LastErrorDesc);
   Exit;
   end;
   http.Headers.Clear;
   http.Headers.AddStrings(FtsHeader);
   try
     berhasil := http.HTTPMethod('GET', aurl);
     if berhasil then
     begin
        FResultCode := http.ResultCode;
        FtsResponse.LoadFromStream(http.Document);
        Result := True;

     end;
   finally
      http.Free;
   end;
end;

function bridgeCommon.httpPost(aurl: string; aData: TStream): Boolean;
var http : THTTPSend;
    berhasil : Boolean;
begin
   FJejak := '-';
   Result := False;
   FtsResponse.Clear;
   http := THTTPSend.Create;
   http.MimeType := 'application/json';
   http.Headers.Clear;
   http.Headers.AddStrings(FtsHeader);
   //http.Headers.Add('Content-Type:application/json');
   http.Document.Clear;
   http.Document.CopyFrom(aData, 0);
   try
     berhasil := http.HTTPMethod('POST', aurl);
     if berhasil then
     begin
      FResultCode := http.ResultCode;
      FtsResponse.LoadFromStream(http.Document);
      Result := True; //(FResultCode >= 200) and (FResultCode < 300);
     end;
   finally
      http.Free;
   end;
end;

function bridgeCommon.httpPut(aurl: string; aData: TStream): Boolean;
var http : THTTPSend;
    berhasil : Boolean;
begin
   FJejak := '-';
   Result := False;
   FtsResponse.Clear;
   http := THTTPSend.Create;
   http.MimeType := 'application/json';
   http.Headers.Clear;
   http.Headers.AddStrings(FtsHeader);
   http.Headers.Add('Content-Type:application/json');

   http.Document.Clear;
   http.Document.CopyFrom(aData, 0);

   try
     berhasil := http.HTTPMethod('PUT', aurl);
     if berhasil then
     begin
      FResultCode := http.ResultCode;
      FtsResponse.LoadFromStream(http.Document);
      Result := True; //(FResultCode >= 200) and (FResultCode < 300);
     end;

   finally
      http.Free;
   end;
end;

procedure bridgeCommon.jalankanScript(script: TStringList);
begin
//FFDScript.ExecuteScript .SQL.Clear;
with FFDScript do begin
  SQLScripts.Clear;
  SQLScripts.Add;
  SQLScripts[0].SQL.Assign(script);
  ValidateAll;
  ExecuteAll;
end;
end;

function bridgeCommon.logRest(metode, transaksi, response: string): Boolean;
var sqlx0, sqlx1 : string;
    V1 : Variant;
    kode : Integer;
    tSL : TStringList;
    pesan, pesan1, judul1 : string;

begin
//   ShowMessage('logRest');
   Result := False;
   kode := FResultCode;

   sqlx0 := 'insert into jkn.a_bpjs_resp(jejak, metode, transaksi, uri, terkirim, terjawab, kode) values( %s, %s, %s, %s, %s, %s, %s);';
   sqlx1 := Format(sqlx0,[quotedStr(jejakIdxstr), quotedStr(metode), quotedStr(transaksi), quotedStr(uri), quotedStr(FormatJson), quotedStr(tsResponse.Text), intTostr(kode)]);
   tSL := TStringList.Create;
   try
     tSL.Add(sqlx1);
     jalankanScript(tSL);
   finally
     tSL.Free;
   end;

   //FileFromString(response, 'aerror1.txt');
   //ShowMessage(response);
   if TJSONObject.ParseJSONValue(response) = nil then
   begin
     ShowMessage('BPJS Server Error -- Unknown');
     Result := False;
   end else
   begin
   V1 := _Json(response);
   if V1.Exists('metaData') then
     begin

        kode := V1.metaData.code;
        pesan := V1.metaData.message;

        if metode = 'POST' then Result := pesan = 'CREATED' else Result := pesan = 'OK';

        if not Result then
        begin
           if VarIsEmptyOrNull(V1.response) then
           begin
             ShowMessage(pesan);
           end else
           begin
             //ShowMessage('tes');
             if kode = 428 then
             begin
               judul1 := V1.metaData.message;
               pesan1 := V1.response;

               Application.MessageBox(PWideChar(pesan1), PWideChar(judul1), 0);
               //ShowMessage(judul1 + ' ' + pesan1);

             end else
             begin
             //ShowMessage('tes2');
             judul1 := V1.response.Value(0).field;
             pesan1 := V1.response.Value(0).message;

             ShowMessage(judul1 + ' ' + pesan1);
             end;
           end;
        end;

     end;
     //ShowMessage('sampai sini? akhir LogRest');
   end;

adl_berhasil := Result;
end;

procedure bridgeCommon.parameter_bridging(aTransaksi, aMetode: string);
    var sql0, sql1 : string;

begin
sql0 := 'select format_json::TEXT, uri_tujuan from jkn.a_json where kelompok = ''JKN'' and transaksi = %s and metode = %s;';
sql1 := Format(sql0, [
          quotedStr(aTransaksi),
          quotedStr(aMetode)
          ]);

FFDQuery.SQL.Clear;
FFDQuery.SQL.Add(sql1);
FFDQuery.Open;
Furi := FBaseUri + FFDQuery.FieldByName('uri_tujuan').AsString;
FFormatJson := FFDQuery.FieldByName('format_json').AsString;
FFDQuery.Close;

end;

end.
