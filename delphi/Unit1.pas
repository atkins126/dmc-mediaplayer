unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
  Vcl.ComCtrls, Vcl.Menus;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    MediaPlayer1: TMediaPlayer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    N9: TMenuItem;
    N10: TMenuItem;
    PopupMenu1: TPopupMenu;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    procedure Image1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Unit2, Unit3, Unit4;

procedure TForm1.Image1Click(Sender: TObject);
begin
 OpenDialog1.Execute()
end;

procedure TForm1.N10Click(Sender: TObject);
begin
Form1.Enabled:=False;
Form3.Show;
end;

procedure TForm1.N11Click(Sender: TObject);
var A:integer;
var fPosition: string;
var fLength: string;
begin
   OpenDialog1.Execute();
   MediaPlayer1.Enabled:=True;
   MediaPlayer1.FileName:=OpenDialog1.FileName;
   MediaPlayer1.Open;
   MediaPlayer1.Play;
   Form4.ListBox1.Items.Add(OpenDialog1.FileName);
   Label1.Caption:='Воспроизв. ' + OpenDialog1.FileName;
   while A<>100 do
   begin
   fPosition := TimeToStr(MediaPlayer1.Position / 100000 / 1000);
   fLength := TimeToStr(MediaPlayer1.Length / 100000 / 1000);
   Label3.Caption := fPosition + ' / ' + fLength;
   Application.ProcessMessages;
   sleep(400)
   end;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
  Form4.Show
end;

procedure TForm1.N14Click(Sender: TObject);
begin
MediaPlayer1.Play;
end;

procedure TForm1.N15Click(Sender: TObject);
begin
MediaPlayer1.Pause;
end;

procedure TForm1.N16Click(Sender: TObject);
begin
MediaPlayer1.Stop;
end;

procedure TForm1.N18Click(Sender: TObject);
begin
Form1.Enabled:=False;
Form3.Show;
end;

procedure TForm1.N19Click(Sender: TObject);
begin
MediaPlayer1.Stop;
end;

procedure TForm1.N2Click(Sender: TObject);
var A:integer;
var fPosition: string;
var fLength: string;
begin
   if OpenDialog1.Execute then
   begin
   MediaPlayer1.Enabled:=True;
   MediaPlayer1.FileName:=OpenDialog1.FileName;
   MediaPlayer1.Open;
   MediaPlayer1.Play;
   Form4.ListBox1.Items.Add(OpenDialog1.FileName);
   Label1.Caption:='Воспроизв. ' + OpenDialog1.FileName;
   while A<>100 do
   begin
   fPosition := TimeToStr(MediaPlayer1.Position / 100000 / 1000);
   fLength := TimeToStr(MediaPlayer1.Length / 100000 / 1000);
   Label3.Caption := fPosition + ' / ' + fLength;
   Application.ProcessMessages;
   sleep(400)
   end;
   end;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
MediaPlayer1.Play;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
   MediaPlayer1.Pause;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
Form4.Show;
end;

procedure TForm1.N8Click(Sender: TObject);
begin
 MediaPlayer1.Close;
 Application.Terminate;
end;

end.
