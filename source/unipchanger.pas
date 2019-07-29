unit unipchanger;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DividerBevel, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Menus, ActnList, Buttons, ExtCtrls, IniFiles, windows, winsock,
  ShellApi,resource,versiontypes, versionresource,lclintf;
const
  KEYWORD_INTERFACE: array [0..1] of string =('Configuration for interface','Konfiguration der Schnittstelle');
  KEYWORD_IP: array [0..1] of string =('IP Address:','IP-Adresse:');
  OUTPUT_FILE ='output.txt';
  PC_DATA_FILE ='pclist.csv';
  DELIMITTYPE = #9;
  CMD_PATH = 'cmd';
  ERROR_OUT = ' 2>&1';
type

  { Tfrmainform }

  Tfrmainform = class(TForm)
    btngetdata: TButton;
    btnpingoldip: TButton;
    btnpingnewip: TButton;
    btnlogin: TButton;
    btnipconfig: TButton;
    btnping: TButton;
    btndns: TButton;
    btnresetnewip: TButton;
    btnsave: TButton;
    btnOpen: TButton;
    cbinterfaces: TComboBox;
    cbauto: TCheckBox;
    divold: TDividerBevel;
    divnew: TDividerBevel;
    DividerBevel3: TDividerBevel;
    edip: TEdit;
    eduser: TEdit;
    edpassword: TEdit;
    ednewIP: TEdit;
    ednewMask: TEdit;
    edNewGateway: TEdit;
    imgvncold: TImage;
    imgvncnew: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbgit: TLabel;
    lbinfo: TLabel;
    lbusername: TLabel;
    lbpassword: TLabel;
    lbversion: TLabel;
    lbdns1: TLabel;
    lbdns2: TLabel;
    lboldIP: TLabel;
    lbip: TLabel;
    lbinterface: TLabel;
    MainMenu1: TMainMenu;
    Memo: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    mndomain: TMenuItem;
    mndot3svc: TMenuItem;
    mnservices: TMenuItem;
    mnnetshmac: TMenuItem;
    mnpsinfo: TMenuItem;
    mncopyselected: TMenuItem;
    mnnetsh: TMenuItem;
    mnfirewallstatus: TMenuItem;
    mnflush: TMenuItem;
    mnnetshactive: TMenuItem;
    mnlocalcommands: TMenuItem;
    mncommandsremote: TMenuItem;
    mnclose: TMenuItem;
    mnfile: TMenuItem;
    PopupMemo: TPopupMenu;
    procedure btndnsClick(Sender: TObject);
    procedure btngetdataClick(Sender: TObject);
    procedure btnloginClick(Sender: TObject);
    procedure btnipconfigClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnpingClick(Sender: TObject);
    procedure btnpingnewipClick(Sender: TObject);
    procedure btnpingoldipClick(Sender: TObject);
    procedure btnresetnewipClick(Sender: TObject);
    procedure btnsaveClick(Sender: TObject);
    procedure cbautoClick(Sender: TObject);
    procedure cbinterfacesChange(Sender: TObject);
    procedure edipChange(Sender: TObject);
    procedure edipKeyPress(Sender: TObject; var Key: char);
    procedure edNewGatewayChange(Sender: TObject);
    procedure ednewIPChange(Sender: TObject);
    procedure ednewMaskChange(Sender: TObject);
    procedure edpasswordKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgvncnewClick(Sender: TObject);
    procedure imgvncoldClick(Sender: TObject);
    procedure lbgitClick(Sender: TObject);
    procedure lbgitMouseEnter(Sender: TObject);
    procedure lbgitMouseLeave(Sender: TObject);
    procedure mncloseClick(Sender: TObject);
    procedure mncopyselectedClick(Sender: TObject);
    procedure mndomainClick(Sender: TObject);
    procedure mndot3svcClick(Sender: TObject);
    procedure mnfirewallstatusClick(Sender: TObject);
    procedure mnflushClick(Sender: TObject);
    procedure mnnetshactiveClick(Sender: TObject);
    procedure mnnetshClick(Sender: TObject);
    procedure mnnetshmacClick(Sender: TObject);
  private
    { private declarations }
    FIpHost:string;
    FDefaultInterface:string;
    FOldIP:string;
    FNewIP:string;
    FNewMask:string;
    FNewGateway:string;
    FDns1:string;
    FDns2:string;
    FDomain:string;
    FUser:string;
    FPassword:string;
    FDefaultIP:string;
    FDefaultMask:string;
    FVNC:string;
   procedure ParseOutputTextInterfaces(filename:string;OutputList:TStringList);
   procedure ParseOutputTextAndIP(filename:string;OutputList:TStringList;interfaceName:string);
   procedure GetPreferences(ini: TiniFile);
   procedure SetPreferences(ini: TiniFile);
  public
    { public declarations }
   property IpHost:string read FIpHost write FIpHost;
   property DefaultInterface:string read FDefaultInterface write FDefaultInterface;
   property OldIP:string read FOldIP write FOldIP;
   property NewIP:string read FNewIP write FNewIP;
   property NewMask:string read FNewMask write FNewMask;
   property NewGateway:string read FNewGateway write FNewGateway;
   property Dns1:string read FDns1 write FDns1;
   property Dns2:string read FDns2 write FDns2;
   property Domain:string read FDomain write FDomain;
   property User:string read FUser write FUser;
   property Password:string read FPassword write FPassword;
   property DefaultIP:string read FDefaultIP write FDefaultIP;
   property DefaultMask:string read FDefaultMask write FDefaultMask;
   property VNC:string read FVNC write FVNC;


  end;

var
  frmainform: Tfrmainform;
  OutputText:TstringList;
  ini:TIniFile;
  psexecpath:string;
  CUSTOM_MESSAGE:string;

implementation

{$R *.lfm}

{ Tfrmainform }
FUNCTION resourceVersionInfo: STRING;
 VAR     Stream: TResourceStream;
         vr: TVersionResource;
         fi: TVersionFixedInfo;

 BEGIN
   RESULT:= '';
   TRY
     Stream:= TResourceStream.CreateFromID(HINSTANCE, 1, PChar(RT_VERSION));
     TRY
       vr:= TVersionResource.Create;
       TRY
         vr.SetCustomRawDataStream(Stream);
         fi:= vr.FixedInfo;
         RESULT :=IntToStr(fi.FileVersion[0]) + '.' + IntToStr(fi.FileVersion[1])+ '.'
        + IntToStr(fi.FileVersion[2]) ;
         vr.SetCustomRawDataStream(nil)
       FINALLY
         vr.Free
       END
     FINALLY
       Stream.Free
     END
   EXCEPT
   END
 END { resourceVersionInfo } ;
 
procedure Split (const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.StrictDelimiter := true;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;

function GetIP(const HostName: string): string;
var
  WSAData: TWSAData;
  R: PHostEnt;
  A: TInAddr;
begin
  Result := '0.0.0.0' ;
  WSAStartup($101, WSAData);
  R := Winsock.GetHostByName(PAnsiChar(AnsiString(HostName)));
  if Assigned(R) then
  begin
    A := PInAddr(r^.h_Addr_List^)^;
    Result := WinSock.inet_ntoa(A);
  end;
end;
function IsValidIP(Ip: string): Boolean;
const
  Z = ['0'..'9', '.'];
var
  I, J, P: Integer;
  W: string;
begin
  Result := False;
  if (Length(Ip) > 15) or (Ip[1] = '.') then Exit;
  I := 1;
  J := 0;
  P := 0;
  W := '';
  repeat
    if (Ip[I] in Z) and (J < 4) then
    begin
      if Ip[I] = '.' then
      begin
        Inc(P);
        J := 0;
        try
          StrToInt(Ip[I + 1]);
        except
          Exit;
        end;
        W := '';
      end
      else
      begin
        W := W + Ip[I];
        if (StrToInt(W) > 255) or (Length(W) > 3) then Exit;
        Inc(J);
      end;
    end
    else
      Exit;
    Inc(I);
  until I > Length(Ip);
  if P < 3 then Exit;
  Result := True;
end;

procedure Tfrmainform.mncloseClick(Sender: TObject);
begin
  close;
end;

procedure Tfrmainform.mncopyselectedClick(Sender: TObject);
var
  s:string;
begin
  s:=Memo.SelText;
  if length(s)=0 then exit;
  if (s[1]='"') and (s[length(s)]='"') then begin
    cbinterfaces.Clear;
    cbinterfaces.Items.Add(s);
    cbinterfaces.ItemIndex:=0;
    FDefaultInterface:=cbinterfaces.Text;
  end else
if IsValidIP(s) then begin
  FOldIP:=s;
  lboldIP.Caption:='IP: '+OldIP;

  end;
  Memo.CopyToClipboard;
end;

procedure Tfrmainform.mndomainClick(Sender: TObject);
var
  newdomain:string;
begin
newdomain:=InputBox('Set default domain','Would you like to change domain from '+QuotedStr(Domain)+'?',Domain);
if newdomain='' then begin MessageDlg('Domain connot be empty string!',mtError,[mbCancel],0);exit;end;
if newdomain<>'' then
   FDomain:=newdomain;
end;

procedure Tfrmainform.mndot3svcClick(Sender: TObject);
begin
   btngetdataclick(mndot3svc);
end;

procedure Tfrmainform.mnfirewallstatusClick(Sender: TObject);
begin
  btngetdataclick(mnfirewallstatus);
end;

procedure Tfrmainform.mnflushClick(Sender: TObject);
begin
   ShellExecute(0,nil, PChar('cmd'),PChar('/k ipconfig /flushdns'),nil,1) ;
end;

procedure Tfrmainform.mnnetshactiveClick(Sender: TObject);
begin
   btngetdataClick(mnnetshactive);
end;

procedure Tfrmainform.mnnetshClick(Sender: TObject);
begin
    btngetdataClick(mnnetsh);
end;

procedure Tfrmainform.mnnetshmacClick(Sender: TObject);
begin
  btngetdataClick(mnnetshmac);
end;

procedure Tfrmainform.ParseOutputTextInterfaces(filename: string; OutputList: TStringList);
var
  i,a:integer;
begin
  if not FileExists(filename)then begin
    Memo.Clear;
 Memo.Lines.Add(QuotedStr(filename)+' does not exists!');
   exit;
  end;
  OutputList.Clear;
  cbinterfaces.Clear;
  OutputList.LoadFromFile(filename);
  for i:=0 to OutputList.Count-1 do begin
    for a:=0 to Length(KEYWORD_INTERFACE) do
  if AnsiPos(KEYWORD_INTERFACE[a],OutputList[i])>0 then begin
  cbinterfaces.Items.Add(RightStr(OutputList[i],Length(OutputList[i])-(Length(KEYWORD_INTERFACE[a])+1)));
     if cbinterfaces.Items.Count>0 then begin
   cbinterfaces.ItemIndex:=0;
   FDefaultInterface:=cbinterfaces.Text;
  end
  end;

  end;

  if cbinterfaces.Items.Count= 0 then begin
  Memo.Clear;
  Memo.Text:=OutputList.Text;

  end;


end;

procedure Tfrmainform.ParseOutputTextAndIP(filename: string; OutputList: TStringList; interfaceName: string);
var
  i,posend,a:integer;
  adaptertext:string;
begin
   if not FileExists(filename)then begin
   Memo.Lines.Add(QuotedStr(filename)+' does not exists!');
   exit;
  end;
  adaptertext:='';
  for i:=0 to OutputList.Count-1 do begin
  if AnsiPos(interfaceName,OutputList[i])>0 then begin
  posend:=i;
 while OutputList[posend]<>'' do begin
 adaptertext:=adaptertext+OutputList[posend]+#13#10;
 for a:=0 to Length(KEYWORD_IP) do
 if AnsiPos(KEYWORD_IP[a],OutputList[posend])>0  then begin
FOldIP:=StringReplace(OutputList[posend],KEYWORD_IP[a],'',[]);
FOldIP:=StringReplace(FOldIP,' ','',[rfReplaceAll]);
FOldIP:=StringReplace(FOldIP,#13#10,'',[rfReplaceAll]);
 end;

  inc(posend);
  end;
Memo.Clear;
Memo.Text:=adaptertext;
lboldIP.Caption:='IP: '+OldIP;
FDefaultInterface:=cbinterfaces.Text;
 break;
 end;

  end;
end;

procedure Tfrmainform.GetPreferences(ini: TiniFile);
begin
  ini:= Tinifile.Create(Extractfilepath(application.exename) + 'settings.ini');
  try
ednewIP.Text:= ini.ReadString('General','DefaultIP','192.168.');
FDefaultIP:=ednewIP.Text;
ednewMask.Text:= ini.ReadString('General','DefaultMask','255.255.255.0');
FDefaultMask:=ednewMask.Text;
edNewGateway.Text:=FDefaultIP;
lbdns1.Caption:=ini.ReadString('General','DNS1','192.168.1.1');
FDns1:=lbdns1.Caption;
lbdns2.Caption:=ini.ReadString('General','DNS2','192.168.1.2');
FDns2:=lbdns2.Caption;
eduser.Text:=ini.ReadString('General','User','admin');
FUser:=eduser.Text;
FVNC:=ini.ReadString('General','VNC','C:\Program Files\RealVNC\VNC Viewer\vncviewer.exe');
cbauto.Checked:=ini.readBool('General','AutoGateway',false);
FDomain:=ini.ReadString('General','Domain','mydomain');


finally
ini.free;
end;

end;

procedure Tfrmainform.SetPreferences(ini: TiniFile);
begin
ini:= Tinifile.Create(Extractfilepath(application.exename) + 'settings.ini');
 try
ini.WriteString('General','DefaultIP',FDefaultIP);
ini.WriteString('General','DefaultMask',FDefaultMask);
ini.writeString('General','DNS1',FDns1);
ini.writeString('General','DNS2',FDns2);
ini.writeString('General','User',FUser);
ini.WriteBool('General','AutoGateway',cbauto.Checked);
ini.WriteString('General','Domain',Domain);
 finally
   ini.free;
 end;
end;

procedure Tfrmainform.FormCreate(Sender: TObject);
begin
psexecpath:=ExtractFilePath(Application.ExeName);
  OutputText:=TstringList.Create;
 GetPreferences(ini);
 CUSTOM_MESSAGE:='';
 lbversion.Caption:='v.'+resourceVersionInfo;
end;

procedure Tfrmainform.btnloginClick(Sender: TObject);
begin

  FUser:=eduser.Text;
  FPassword:=edpassword.Text;
  if Password='' then messagedlg('Set Password!',mtWarning,[mbcancel],0);
  SetPreferences(ini);
end;

procedure Tfrmainform.btngetdataClick(Sender: TObject);
var
  command:string;
begin
  if IpHost='' then begin messagedlg('Set IP address ot hostname!',mtWarning,[mbcancel],0);exit;end;
 if User='' then begin messagedlg('Set User and Login!',mtWarning,[mbcancel],0);exit;end;
 if Password='' then begin messagedlg('Set Password and Login!',mtWarning,[mbcancel],0);exit;end;
    if GetIP(IpHost)='0.0.0.0' then begin
    MessageDlg('Resolving error','Ping request could not find host '+IpHost+'. Please check the name and try again.',mtWarning,[mbCancel],0);
        exit;
       end;
 try
 btnresetnewipClick(nil);
FNewIP:=DefaultIP;
lboldIP.Caption:='IP:';
CUSTOM_MESSAGE:=' | ECHO. Connecting to '+IpHost+' and starting netsh as '+User+'...';
   if FileExists(OUTPUT_FILE) then
    DeleteFile(OUTPUT_FILE);
   if (sender is TButton) then begin
      if (sender as TButton).Name='btngetdata' then
  command:='/c '+psexecpath+ '\psexec \\'+IpHost+' -h -u '+Domain+'\'+User+' -p '+Password +' netsh interface ip show config  > '+OUTPUT_FILE+ERROR_OUT+CUSTOM_MESSAGE;
     end;
  if (Sender is TMenuItem) then begin
  if (sender as TMenuItem).Name='mnnetshactive' then
  command:='/c '+psexecpath+ '\psexec \\'+IpHost+' -h -u '+Domain+'\'+User+' -p '+Password +' -r network_interfaces_request netsh interface show interface > '+OUTPUT_FILE+ERROR_OUT+CUSTOM_MESSAGE;
   if (sender as TMenuItem).Name='mnfirewallstatus' then
 command:='/c '+psexecpath+ '\psexec \\'+IpHost+' -h -u '+Domain+'\'+User+' -p '+Password +' -r request_firewall_status netsh advfirewall show currentprofile > '+OUTPUT_FILE+ERROR_OUT+CUSTOM_MESSAGE;
     if (sender as TMenuItem).Name='mnpsinfo' then
 command:='/c '+psexecpath+ '\psinfo \\'+IpHost+' -u '+Domain+'\'+User+' -p '+Password +' -h -s -d > '+OUTPUT_FILE+ERROR_OUT+CUSTOM_MESSAGE;
     if (sender as TMenuItem).Name='mnnetshmac' then
 command:='/c '+psexecpath+ '\psexec \\'+IpHost+' -u '+Domain+'\'+User+' -p '+Password +' netsh lan show interfaces > '+OUTPUT_FILE+ERROR_OUT+CUSTOM_MESSAGE;
    if (sender as TMenuItem).Name='mnnetsh' then
   command:='/k '+psexecpath+ '\psexec \\'+IpHost+' -h -u '+Domain+'\'+User+' -p '+Password +' netsh ';


  //services
         if (sender as TMenuItem).Name='mndot3svc' then
 command:='/c '+psexecpath+ '\psservice \\'+IpHost+' -u '+Domain+'\'+User+' -p '+Password +' start dot3svc > '+OUTPUT_FILE+ERROR_OUT+CUSTOM_MESSAGE;

  end;

  SysUtils.ExecuteProcess(CMD_PATH,command,[]);
   sleep(1000);
   if (sender as TComponent).Name<>'mnnetsh' then
  ParseOutputTextInterfaces(OUTPUT_FILE,OutputText);
  if cbinterfaces.Items.Count>0 then
  ParseOutputTextAndIP(OUTPUT_FILE,OutputText,cbinterfaces.Text);

except
  on e:exception do
  exit;
 end;

end;

procedure Tfrmainform.btndnsClick(Sender: TObject);
var
  command:string;
  list:TStringList;
begin
 FNewIP:=ednewIP.Text;
 FNewMask:=ednewMask.Text;
 FNewGateway:=edNewGateway.Text;
 if  DefaultInterface='' then begin messagedlg('Interface is not selected, get data and select interface.',mtWarning,[mbcancel],0);exit;end;
  if LeftStr(NewIP,Length(DefaultIP))<>DefaultIP then  begin messagedlg('New IP not starting with '+DefaultIP+', set IP address!',mtWarning,[mbcancel],0);exit;end;
 if not IsValidIP(NewIP) then begin messagedlg('IP address is not valid!',mtWarning,[mbcancel],0);exit;end;
  list:=TStringList.Create;
   try
  CUSTOM_MESSAGE:=' | ECHO. Connecting to '+NewIP+' and starting netsh as '+User+'...';
 command:='/c '+psexecpath+ '\psexec \\'+NewIP+' -h -u '+Domain+'\'+User+' -p '+Password +' -r change_DNS1 netsh interface ipv4 add dnsservers '+DefaultInterface+' address='+Dns1+' index=1 > '+OUTPUT_FILE+ERROR_OUT+CUSTOM_MESSAGE;
  SysUtils.ExecuteProcess(CMD_PATH,command,[]);
   sleep(1000);
  if FileExists(OUTPUT_FILE) then begin
  Memo.Clear;
   list.LoadFromFile(OUTPUT_FILE);
   Memo.Lines.Add(list.Text);
     end;
  CUSTOM_MESSAGE:=' | ECHO. Connecting to '+NewIP+' and starting netsh as '+User+'...';
  command:='/c '+psexecpath+ '\psexec \\'+NewIP+' -h -u '+Domain+'\'+User+' -p '+Password +' -r change_DNS2 netsh interface ipv4 add dnsservers '+DefaultInterface+' address='+Dns2+' index=2 > '+OUTPUT_FILE+ERROR_OUT+CUSTOM_MESSAGE;
  SysUtils.ExecuteProcess(CMD_PATH,command,[]);
     sleep(1000);
   if FileExists(OUTPUT_FILE) then begin
     list.Clear;
     list.LoadFromFile(OUTPUT_FILE);
     Memo.Lines.Add(list.Text);
     end;

   finally
     list.free;
   end;
end;

procedure Tfrmainform.btnipconfigClick(Sender: TObject);
var
  command:string;
begin
 FNewIP:=ednewIP.Text;
 FNewMask:=ednewMask.Text;
 FNewGateway:=edNewGateway.Text;
 if (NewIP='')or(NewMask='')or(NewGateway='') then exit;

 if  DefaultInterface='' then begin messagedlg('Interface is not selected, get data and select interface.',mtWarning,[mbcancel],0);exit;end;
  if LeftStr(OldIP,Length(DefaultIP))<>DefaultIP then  begin messagedlg('OLD IP not starting with '+DefaultIP+', select other Interface',mtWarning,[mbcancel],0);exit;end;
 if not IsValidIP(NewIP) then begin messagedlg('IP address is not valid!',mtWarning,[mbcancel],0);exit;end;
  if not IsValidIP(NewMask) then begin messagedlg('Mask is not valid!',mtWarning,[mbcancel],0);exit;end;
  if not IsValidIP(NewGateway) then begin messagedlg('Gateway is not valid!!',mtWarning,[mbcancel],0);exit;end;
  if LeftStr(NewIP,Length(DefaultIP))<>DefaultIP then  begin messagedlg('New IP not starting with '+DefaultIP,mtWarning,[mbcancel],0);exit;end;
  CUSTOM_MESSAGE:=' | ECHO. Connecting to '+OldIP+' and starting netsh change_ip_address as '+User+'...';
   command:='/c '+psexecpath+ '\psexec \\'+OldIP+' -h -u '+Domain+'\'+User+' -p '+Password +' -r change_ip_address netsh interface ip set address name='+DefaultInterface+' static ' +NewIP+' '+NewMask+' '+NewGateway+' > '+OUTPUT_FILE+ERROR_OUT+CUSTOM_MESSAGE;
  // showmessage(command);
  SysUtils.ExecuteProcess(CMD_PATH,command,[]);
   sleep(1000);

   if FileExists(OUTPUT_FILE) then begin
   Memo.Clear;
  Memo.Lines.LoadFromFile(OUTPUT_FILE);
   end;
   if Memo.Lines.Count=0 then begin
 Memo.Lines.Add('Before saving new PC data check:'+#13#10);
 Memo.Lines.Add('PING OLD ip address '+OldIP);
 Memo.Lines.Add('PING NEW IP address '+NewIP);
 Memo.Lines.Add('Try to connect over VNC with NEW IP '+NewIP);
 Memo.Lines.Add('Save data to file');
   end;


end;

procedure Tfrmainform.btnOpenClick(Sender: TObject);
begin
   if fileexists(PC_DATA_FILE) then
  ShellApi.ShellExecute(0,'open','notepad',PChar(PC_DATA_FILE),nil,1) ;
end;

procedure Tfrmainform.btnpingClick(Sender: TObject);
var
  IP:string;
begin
    IP:=edip.Text;
  if ip='' then ip:='192.168.1.1';
    if GetIP(IP)='0.0.0.0' then begin
    MessageDlg('Resolving error','Ping request could not find host '+ip+'. Please check the name and try again.',mtWarning,[mbCancel],0);
        exit;
       end;
   ShellExecute(0,nil, PChar('cmd'),PChar('/c  ping '+IP+' -t'),nil,1) ;
end;

procedure Tfrmainform.btnpingnewipClick(Sender: TObject);
begin
  ednewIPChange(nil);
 if NewIP='' then exit;
   if IsValidIP(NewIP) then
  ShellExecute(0,nil, PChar('cmd'),PChar('/c  ping '+NewIP+' -t'),nil,1) ;
end;

procedure Tfrmainform.btnpingoldipClick(Sender: TObject);
begin
 if OldIP='' then exit;
 if IsValidIP(OldIP) then
  ShellExecute(0,nil, PChar('cmd'),PChar('/c  ping '+OldIP+' -t'),nil,1) ;
end;

procedure Tfrmainform.btnresetnewipClick(Sender: TObject);
begin
  FNewIP:=DefaultIP;
  ednewIP.Text:=NewIP;
  FNewMask:=DefaultMask;
  ednewMask.Text:=NewMask;
  FNewGateway:=FDefaultIP;
  edNewGateway.Text:=NewGateway;
end;

procedure Tfrmainform.btnsaveClick(Sender: TObject);
var
  pclist:TStringList;
begin
   pclist:=TStringList.Create;
   try
  if fileexists(PC_DATA_FILE) then
  pclist.LoadFromFile(PC_DATA_FILE);
  if IpHost='' then begin messagedlg('Save PC data to CSV file','PC name or IP address is empty',mtWarning,[mbcancel],0);exit;end;
  if OldIP='' then begin messagedlg('Save PC data to CSV file','OLD IP address is empty',mtWarning,[mbcancel],0);exit;end;
  if NewIP='' then begin messagedlg('Save PC data to CSV file','NEW IP address is empty',mtWarning,[mbcancel],0);exit;end;
  if not IsValidIP(NewIP) then begin messagedlg('Save PC data to CSV file','NEW IP '+NewIP+' address is not valid',mtWarning,[mbcancel],0);exit;end;
  if MessageDlg('Save PC data to CSV file','PC name: '+IpHost+#13#10+'OLD IP: '+OldIP+#13#10+'NEW IP '+ NewIP+#13#10+'Save data to file?',mtConfirmation, mbYesNo,0)=mrno then exit;
  if AnsiPos(NewIP+';',pclist.Text)>0 then
  if  MessageDlg('Save PC data to CSV file',NewIP +' is already saved in file. Continue?',mtConfirmation, mbYesNo,0)=mrno then exit;
  if AnsiPos('Date'+DELIMITTYPE+'PC name'+DELIMITTYPE+'OLD IP'+DELIMITTYPE+'NEW IP',pclist.Text)=0 then
  pclist.Insert(0,'Date'+DELIMITTYPE+'PC name'+DELIMITTYPE+'OLD IP'+DELIMITTYPE+'NEW IP');
  pclist.Add(DateToStr(now)+DELIMITTYPE+IpHost+DELIMITTYPE+OldIP+DELIMITTYPE+NewIP+';');
  pclist.SaveToFile(PC_DATA_FILE);

   finally
      pclist.Free;
   end;
end;

procedure Tfrmainform.cbautoClick(Sender: TObject);
begin
if cbauto.Checked then
   ednewIPChange(nil);
SetPreferences(ini);
   end;

procedure Tfrmainform.cbinterfacesChange(Sender: TObject);
begin
  if cbinterfaces.Items.Count=0 then exit;
   ParseOutputTextAndIP(OUTPUT_FILE,OutputText,cbinterfaces.Text);
end;

procedure Tfrmainform.edipChange(Sender: TObject);
begin
  FIpHost:=edip.Text;
end;

procedure Tfrmainform.edipKeyPress(Sender: TObject; var Key: char);
begin
    if Key = #13 then begin
       btngetdataClick(btngetdata);
    Key := #0;
  end;
end;

procedure Tfrmainform.edNewGatewayChange(Sender: TObject);
begin
  FNewGateway:=edNewGateway.Text;
end;

procedure Tfrmainform.ednewIPChange(Sender: TObject);
var
  GatewayIP:TStringList;
begin
  FNewIP:=ednewIP.text;
  if cbauto.Checked then begin
   if ednewIP.Text='' then exit;
   if Length(NewIP)<10 then exit;
   if IsValidIP(NewIP) then begin
    GatewayIP:=TStringList.Create;
    try
   Split('.',NewIP,GatewayIP);
   if GatewayIP.Count=4 then begin
   edNewGateway.Text:=GatewayIP[0]+'.'+GatewayIP[1]+'.'+GatewayIP[2]+'.1';
       end;

    finally
    GatewayIP.Free;
    end;
   end;
  end;
end;

procedure Tfrmainform.ednewMaskChange(Sender: TObject);
begin
  FNewMask:=ednewMask.Text;
end;

procedure Tfrmainform.edpasswordKeyPress(Sender: TObject; var Key: char);
begin
   if Key = #13 then begin
       btnlogin.Click;
    Key := #0;
  end;
end;

procedure Tfrmainform.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SetPreferences(ini);
end;

procedure Tfrmainform.FormDestroy(Sender: TObject);
begin
  OutputText.Free;
end;

procedure Tfrmainform.FormShow(Sender: TObject);
begin
  ednewIPChange(nil);
ednewMaskChange(nil);
edNewGatewayChange(nil);
end;

procedure Tfrmainform.imgvncnewClick(Sender: TObject);
begin
   if not FileExists(VNC) then begin MessageDlg('VNC viewer on '+quotedstr(vnc)+' path does not exists!'+#13#10+'Change path in *.ini file',mtWarning,[mbCancel],0);exit;end;
  ednewIPChange(nil);
   ShellApi.ShellExecute(0,'open',PChar(VNC),PChar('-UserName '+ User + ' '+NewIP),nil,1) ;
end;

procedure Tfrmainform.imgvncoldClick(Sender: TObject);
begin
if not FileExists(VNC) then begin MessageDlg('VNC viewer on '+quotedstr(vnc)+' path does not exists!'+#13#10+'Change path in *.ini file',mtWarning,[mbCancel],0);exit;end;
   ShellApi.ShellExecute(0,'open',PChar(VNC),PChar('-UserName '+ User +' '+ OldIP),nil,1) ;
end;

procedure Tfrmainform.lbgitClick(Sender: TObject);
begin
  ShellApi.ShellExecute(0,'open',PChar(lbgit.Caption),nil,nil,1) ;
end;

procedure Tfrmainform.lbgitMouseEnter(Sender: TObject);
begin
  lbgit.Font.Style:=[fsUnderline];
  lbgit.Cursor:=crHandPoint;
end;

procedure Tfrmainform.lbgitMouseLeave(Sender: TObject);
begin
 lbgit.Font.Style:=[];
 lbgit.Cursor:=crDefault;
end;

end.

