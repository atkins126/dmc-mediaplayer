unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, StrUtils, Registry, ActiveX, ComObj;


type
  TForm3 = class(TForm)
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Button1: TButton;
    Image1: TImage;
    Image2: TImage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  type TCPUInfo = packed record
  IDString: array [0..11] of Char;
  Stepping: Integer;
  Model: Integer;
  Family: Integer;
  FPU: Boolean;
  VirtualModeExtensions: Boolean;
  DebuggingExtenslons: Boolean;
  PageSizeExtensions: Boolean;
  TimeStampCounter: Boolean;
  K86ModelSpecificRegisters: Boolean;
  MachineCheckExceptlon: Boolean;
  CMPXCHG8B: Boolean;
  APIC: Boolean;
  MemoryTypeRangeRegisters: Boolean;
  GlobalPagingExtension: Boolean;
  ConditionalMovelnstruction: Boolean;
  MMX: Boolean;
  SYSCALLandSYSRET, FPConditionalMovelnstruction, AMD3DNow: Boolean;
  CPUName: String;
end;

var
  Form3: TForm3;

function ExistCPUID: Boolean;
function CPUIDInfo(out info: TCPUInfo): Boolean;
function ExistMMX: Boolean;
function Exist3DNow: Boolean;
function ExistKNI: Boolean;
procedure EMMS;
procedure FEMMS;
procedure PREFETCH(p: Pointer); register;

implementation

{$R *.dfm}

uses Unit1;

function GetTotalMemory: String;
var
  MS: TMemoryStatus;
  mmb:Cardinal;
begin
    MS.dwLength:=SizeOf(MS);
    GlobalMemoryStatus(MS);
    mmb:=MS.dwTotalPhys;
    mmb:=Round((mmb / 1024) / 1024);
    Result :='всего ' + IntToStr(mmb)+ ' MB';
end;

function GetFreeMemory: String;
var
  MS: TMemoryStatus;
  mmb:Cardinal;
begin
    MS.dwLength:=SizeOf(MS);
    GlobalMemoryStatus(MS);
    mmb:=MS.dwTotalPhys;
    mmb:=Round((mmb / 1024) / 1024);
    Result := 'свободно ' + IntToStr(mmb)+ ' MB';
end;

function ExistCPUID: Boolean;
asm
  pushfd
  pop eax
  mov ebx, eax
  xor eax, 00200000h
  push eax
  popfd
  pushfd
  pop ecx
  mov eax, 0
  cmp ecx, ebx
  jz @NO_CPUID
  inc eax
@NO_CPUID:
end;

function CPUIDInfo(out info: TCPUInfo): boolean;
  function ExistExtendedCPUIDFunctions: boolean;
  asm
    mov eax, 080000000h
    db $0F, $A2
  end;
var
  name: array [0..47] of Char;
  p: Pointer;
begin
  if ExistCPUID then
  asm
    jmp @Start
@BitLoop:
    mov al, dl
    and al, 1
    mov [edi], al
    shr edx, 1
    inc edi
    loop @BitLoop
    ret
@Start:
    mov edi, info
    mov eax, 0
    db $0F, $A2
    mov [edi],ebx
    mov [edi + 4], edx
    mov [edi + 8], ecx
    mov eax, 1
    db $0F, $A2
    mov ebx, eax
    and eax, 0fh;
    mov [edi + 12], eax;
    shr ebx, 4
    mov eax, ebx
    and eax, 0fh
    mov [edi + 12 + 4], eax
    shr ebx, 4
    mov eax, ebx
    and eax, 0fh
    mov [edi + 12 +8 ], eax
    add edi, 24
    mov ecx, 6
    call @BitLoop
    shr edx, 1
    mov ecx, 3
    call @BitLoop
    shr edx, 2
    mov ecx, 2
    call @BitLoop
    shr edx, 1
    mov ecx, 1
    call @BitLoop
    shr edx, 7
    mov ecx, 1
    call @BitLoop
    mov p, edi
  end;
  if (info.IDString = 'AuthenticAMD') and ExistExtendedCPUIDFunctions then
  begin asm
    mov edi, p
    mov eax, 080000001h
    db $0F, $A2
    mov eax, edx
    shr eax, 11
    and al, 1
    mov [edi], al
    mov eax, edx
    shr eax, 16
    and al, 1
    mov [edi + 1], al
    mov eax, edx
    shr eax, 31
    and al, 1
    mov [edi + 2], al
    lea edi, name
    mov eax, 0
    mov [edi], eax
    mov eax, 080000000h
    db $0F, $A2
    cmp eax, 080000004h
    jl @NoString
    mov eax, 080000002h
    db $0F, $A2
    mov [edi], eax
    mov [edi + 4], ebx
    mov [edi +8], ecx
    mov [edi + 12], edx
    add edi, 16
    mov eax, 080000003h
    db $0F, $A2
    mov [edi] , eax
    mov [edi + 4], ebx
    mov [edi + 8], ecx
    mov [edi + 12], edx
    add edi, 16
    mov eax, 080000004h
    db $0F, $A2
    mov [edi] , eax
    mov [edi + 4], ebx
    mov [edi + 8], ecx
    mov [edi + 12], edx
@NoString:
  end;
    info.CPUName := name;
  end
  else
    with info do
    begin
      SYSCALLandSYSRET := False;
      FPConditionalMovelnstruction := False;
      AMD3DNow := False;
      CPUName := '(Неизвестно)';
    end;
  Result := ExistCPUID;
end;

function ExistMMX: Boolean;
var info: TCPUInfo;
begin
  if CPUIDInfo(info) then Result := info.MMX
  else Result := False;
end;

function Exist3DNow: Boolean;
var info: TCPUInfo;
begin
  if CPUIDInfo(info) then Result := info.AMD3DNow
  else Result := False;
end;

function ExistKNI: Boolean;
begin
  Result := False;
end;

procedure EMMS;
asm
  db $0F, $77
end;

procedure FEMMS;
asm
  db $0F, $03
end;

procedure PREFETCH(p: Pointer); register;
asm
  PREFETCH byte ptr [eax]
end;


function BoolToStr(b:Boolean):String;
begin
  if b then Result:='Присутствует'
  else Result:='Отсутствует';
end;

function GetRAM: Cardinal;
var MS: TMemoryStatus;
begin
    MS.dwLength:=SizeOf(MS);
    Result:=MS.dwTotalPhys;
end;

function GetCPUSpeed: double;
const
  DelayTime = 500; // время измерения в миллисекундах
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
    dw 310Fh // rdtsc
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
    dw 310Fh // rdtsc
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  Result := TimerLo / (1000.0 * DelayTime);
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
Form3.Close;
Form1.Enabled:=True;
Form1.Show;
end;

procedure TForm3.FormActivate(Sender: TObject);
 var winver: string;
     MemStatus: TMemoryStatusEx;
     info:TCPUInfo;
     MS: TMemoryStatus;
begin
     MemStatus.dwLength := SizeOf(MemStatus);
CPUIDInfo(info);
 begin
   if CheckWin32Version(10, 0) then
     winver:='Windows 10 (NT 10.0)'
     else
   if CheckWin32Version(6, 3) then
     winver:='Windows 8.1 (NT 6.3)'
   else
   if CheckWin32Version(6, 2) then
      winver:='Windows 8 (NT 6.2)'
   else
   if CheckWin32Version(6, 1) then
      winver:='Windows 7 (NT 6.1)'
   else
   if CheckWin32Version(6, 0) then
     winver:='Windows Vista (NT 6.0)'
   else
   if CheckWin32Version(5, 1) then
     winver:='Windows XP (NT 5.1)'
   else
   if CheckWin32Version(5, 0) then
     winver:='Windows 2000 (NT 5.0)'
   else
   if CheckWin32Version(4, 0) then
     winver:='Windows NT 4.0 Workstation/Server';
 end;

Label2.Caption:=winver;
Label3.Caption:=info.CPUName + ' ' + Format('%f MHz', [GetCPUSpeed]);
Label5.Caption:=GetFreeMemory + ', ' + GetTotalMemory
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.Enabled:=True;
Form1.Show;
end;

end.
