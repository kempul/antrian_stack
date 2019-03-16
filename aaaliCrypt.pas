unit aaaliCrypt;

interface
uses sysutils;
var
DefaultKey : WideString = 'TK7IWlj1Ly+Y6DOe';
keyTototo : WideString = 'wsL3RStCVOgXh06x';
InternalPassword : string = 'haidarfaz';
function GenerateKey: string;
function CreateRandomString(Chars: string; Count: Integer): string;
function EncodeData(Data, Key: WideString; MinV: Word=0; MaxV: Word=5): WideString;
function DecodeData(Data, Key: WideString): WideString;
Function GenerateSerialNumber( AUserName: String ): String;

implementation
{ ---------------------------------------------------------------------
  Password encryption
  ---------------------------------------------------------------------}

{ Based on code found on Torry's pages by Jurii Zhukow}

const
  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

{ Function to create an encryption key }

function GenerateKey: string;

var
  i, x: integer;
  s1, s2: string;

begin
  s1:=Codes64;
  s2:='';
  for i := 0 to 15 do
    begin
    x:=Random(Length(s1));
    x:=Length(s1)-x;
    s2:=s2+s1[x];
    s1:=Copy(s1,1,x-1)+Copy(s1,x+1,Length(s1));
    end;
  Result:=s2;
end;

{ Noise function }

function CreateRandomString(Chars: string; Count: Integer): string;
var
  i,X: integer;

begin
  Result:='';
  If Count>Length(Chars) then
    Count:=Length(Chars);
  for i:=1 to Count do
    begin
    X:=Length(Chars)-Random(Length(Chars));
    Result:=Result+Chars[X];
    Delete(Chars,X,1);
    end;
end;

{ Encode Data  }

{
 "Key" _must_ be generated using above function.
 "Data" is data to be encoded.
 "MinV" - minimum quantity of "noise" chars before each encoded data char.
 "MaxV" - maximum quantity of "noise" chars before each encoded data char.
}

function EncodeData(Data, Key: WideString; MinV: Word=0; MaxV: Word=5): WideString;
var
  i, x: integer;
  s1, s2, ss: string;
begin
  if (MinV>MaxV) then
    begin
    i:=minv;
    minv:=maxv;
    maxv:=i;
    end;
  if (MaxV>100) then
    MaxV:=100;
  Result:='';
  if Length(Key)<16 then
    Exit;
  for i:=1 to Length(Key) do
    begin
    s1:=Copy(Key,i+1,Length(Key));
    if (Pos(Key[i],s1)>0) or (Pos(Key[i],Codes64)<=0) then
      Exit;
    end;
  s1:=Codes64;
  s2:='';
  for i:=1 to Length(Key) do
    begin
    x:=Pos(Key[i],s1);
    if (x>0) then
      s1:=Copy(s1,1,x-1)+Copy(s1,x+1,Length(s1));
    end;
  ss:=Key;
  for i:=1 to Length(Data) do
    begin
    s2:=s2+ss[Ord(Data[i]) mod 16 + 1];
    ss:=Copy(ss,Length(ss),1)+Copy(ss,1,Length(ss)-1);
    s2:=s2+ss[Ord(Data[i]) div 16 + 1];
    ss:=Copy(ss,Length(ss),1)+Copy(ss,1,Length(ss)-1);
    end;
  Result:=CreateRandomString(s1,Random(MaxV-MinV)+minV+1);
  for i:=1 to Length(s2) do
    Result:=Result+s2[i]+CreateRandomString(s1,Random(MaxV-MinV)+minV);
end;

{ Decode data }
{
 "Key" _must_ be same key as used to encrypt data.
 "Data" is encoded data
}

function DecodeData(Data, Key: WideString): WideString;

var
  i, x, x2: integer;
  s1, s2, ss: string;

begin
  Result := #1;
  if (Length(Key)<16) then
    Exit;
  for i := 1 to Length(Key) do
    begin
    s1 := Copy(Key, i + 1,Length(Key));
    if (Pos(Key[i],s1)>0) or (Pos(Key[i],Codes64)<=0) then
      Exit;
    end;
  s1:=Codes64;
  s2:='';
  ss:=Key;
  for i:=1 to Length(Data) do
    if (Pos(Data[i],ss)>0) then
      s2:=s2+Data[i];
  Data:=s2;
  s2:='';
  if ((Length(Data) mod 2)<>0) then
    Exit;
  for i := 0 to Length(Data) div 2 - 1 do
    begin
    x:=Pos(Data[i*2+1],ss)-1;
    if (x<0) then
      Exit;
    ss:=Copy(ss,Length(ss),1)+Copy(ss,1,Length(ss)-1);
    x2:=Pos(Data[i*2+2],ss)-1;
    if (x2<0) then
      Exit;
    x:=x+x2*16;
    s2:=s2+chr(x);
    ss:=Copy(ss,Length(ss),1)+Copy(ss,1,Length(ss)-1);
    end;
  Result:=s2;
end;

Function GenerateSerialNumber( AUserName: String ): String;
Var
     I: Integer;
     Index: Integer;
     IntIndex: Integer;
     Serial: String;
     TempStr: String;
     TempStr1: String;
     Addon: Integer;
Begin
     Result := '';

     If AUserName = '' Then
     Begin
          //MessageDlg( 'User name is empty. Please set this propery before!', mtInformation, [ mbOK ], 0 );
          Exit;
     End;

     AUserName := UpperCase( AUserName );

     Index := 1;
     IntIndex := 1;
     Addon := 0;

     For I := 1 To Length( AUserName ) Do
     Begin
          Inc( AddOn, ( Ord( AUserName[ I ] ) * I ) );
     End;


     For I := 1 To 12 Do
     Begin
          Serial := Serial +
               IntToHex(

               ( (
               Ord( DefaultKey[ I * 2 ] ) Xor Ord( DefaultKey[ I ] )
               )
               Xor Ord( AUserName[ Index ] )
               )
               Xor
               (
               ( Addon + I ) Mod 200
               )
               , 2 );

          Inc( Addon, Ord( AUserName[ Index ] ) Xor I );


          Inc( Index );
          Inc( IntIndex );
          If Index > Length( AUserName ) Then Index := 1;
          If IntIndex > Length( InternalPassword ) Then IntIndex := 1;
     End;

     If Length( Serial ) > 24 Then Serial := Copy( Serial, 1, 24 );
     Result := Copy( Serial, 1, 8 ) + '-' + Copy( Serial, 9, 8 ) + '-' + Copy( Serial, 17, 8 );
End;

end.
 