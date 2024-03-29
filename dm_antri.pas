unit dm_antri;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.Comp.Client, Data.DB, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TdataAntri = class(TDataModule)
    fdTransaction2: TFDTransaction;
    fdpgdriver1: TFDPhysPgDriverLink;
    fdQNikCari: TFDQuery;
    fdQDaftar: TFDQuery;
    fdQJknCari: TFDQuery;
    fdQRmCari: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    fdQPoli: TFDQuery;
    fdQKunjunganAmbil: TFDQuery;
    fdQAntri: TFDQuery;
    fdQAntriAmbil: TFDQuery;
    FDConnection1: TFDConnection;
    fdQPuskesmas: TFDQuery;
    fdQ1: TFDQuery;
    fdQ2: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    tSL : TStringList;

    dbhost, dbname, dbuser, dbpasswd, serialX : WideString;
    pghost, pgport, pgdb, pguser, pgpasswd : WideString;

    procedure ambil_konfig;
    procedure getpg;
    procedure create_conn;
  public
    { Public declarations }
  end;

var
  dataAntri: TdataAntri;

implementation

  uses SynCommons, aaalicrypt;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ Tdm }

procedure TdataAntri.ambil_konfig;
var myJson : Variant;
  FUri, jsConsID, jsKeyID, jsUserid, jsPasswd : WideString;
begin
myJson := _JsonFast(StringFromFile('param.json'));
pghost := myJson.pg.pghost;
pgport := myJson.pg.pgport;
//ShowMessage('pghost = ' + pghost);
pgdb := myJson.pg.pgdb;
pgport := myJson.pg.pgport;
pguser := decodeData( myJson.pg.pguser, keyTototo);
pgpasswd := DecodeData( myJson.pg.pgpasswd , keyTototo);


  FUri := myJson.bpjs.base_uri;
  jsConsID := DecodeData( myJson.bpjs.consid, keyTototo);
  jsKeyID := DecodeData( myJson.bpjs.key, keyTototo);
  jsUserID := myJson.bpjs.userid;
  jsPasswd := DecodeData( myJson.bpjs.passwd, keyTototo);


//xml.Reload;
{
dbhost:=xml.ReadString('dbhost');
dbname:=xml.ReadString('dbname');
dbuser:=cipher1.DecodeString('15754', xml.ReadString('dbuser'));
dbpasswd:=cipher1.DecodeString('15754', xml.ReadString('dbpasswd'));
serialX:=cipher1.DecodeString('15754', xml.ReadString('key'));
}
{
pghost:=xml.ReadString('pghost');
pgdb:=xml.ReadString('pgdb');
pgport:=xml.ReadString('pgport');
pguser:=cipher1.DecodeString('15754', xml.ReadString('pguser'));
pgpasswd:=cipher1.DecodeString('15754', xml.ReadString('pgpasswd'));
serialX:=cipher1.DecodeString('15754', xml.ReadString('key'));
}
end;

procedure TdataAntri.create_conn;
begin

  tSL.Add('Server=' + pghost);
  tSL.Add('Port=' +  pgport);
  tSL.Add('Database= ' + pgdb);
  tSL.Add('User_name=' + pguser);
  tSL.Add('Password=' + pgpasswd);
  tSL.Add('Pooled=True');
  fdManager.AddConnectionDef('PGANTRI_CONN', 'PG', tSl, False);
  fdManager.Active := True;
  FDConnection1.ConnectionDefName := 'PGANTRI_CONN';
  FDConnection1.Connected := True;
end;

procedure TdataAntri.DataModuleCreate(Sender: TObject);
begin
try
tSL := TStringList.Create;
ambil_konfig;

finally
  create_conn;

  //FDConnection1.ConnectionDefName := 'PG_CONNECTION';
  //FDConnection1.Connected := True;
  //getpg;
  //FDConnection1.ConnectionName := fdManager1.
  //FDConnection1.ConnectionDefName :=  'PG_CONNECTION';
  //FDConnection1.Connected := True;
end;

end;

procedure TdataAntri.DataModuleDestroy(Sender: TObject);
begin
fdManager.Close;
tSL.Free;
end;

procedure TdataAntri.getpg;
begin
if FDConnection1.Connected then FDConnection1.Connected := false;

//FDConnection1.AutoReconnect := False;
{
pghost:=form1_kunci.pghost;
pgport := Form1_kunci.pgport;
pgdb:=form1_kunci.pgdb;
pguser:=form1_kunci.pguser;
pgpasswd:=form1_kunci.pgpasswd;
}

FDConnection1.Params.Clear;
FDConnection1.Params.Add('Server=' + pghost);
FDConnection1.Params.Add('Port=' +  pgport);
FDConnection1.Params.Add('Database= ' + pgdb);
FDConnection1.Params.Add('User_name=' + pguser);
FDConnection1.Params.Add('Password=' + pgpasswd);
FDConnection1.Params.Add('Pooled=True');
FDConnection1.Params.Add('Port=' + pgport);
FDConnection1.Params.Add('DriverID=PG');

FDConnection1.Connected := True;

end;

end.
