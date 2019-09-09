unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm4 = class(TForm)
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Button5: TButton;
    Button6: TButton;
    Label1: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Button2: TButton;
    Button1: TButton;
    Button3: TButton;
    Panel4: TPanel;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

uses Unit1, Unit3;


procedure TForm4.Button1Click(Sender: TObject);
begin
  Form1.OpenDialog1.Execute();
  ListBox1.Items.Add(Form1.OpenDialog1.Filename);
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  ListBox1.ClearSelection;
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
 BorderIcons := [biMinimize,biMaximize];
 Panel1.Visible := True;
 ListBox1.Enabled := False;
 Button1.Enabled := False;
 Button2.Enabled := False;
 Button3.Enabled := False;
 Button4.Enabled := False;
end;

procedure TForm4.Button4Click(Sender: TObject);
var A:integer;
var fPosition: string;
var fLength: string;
begin
 Form1.MediaPlayer1.FileName := ListBox1.Items[ListBox1.ItemIndex];
 Form1.MediaPlayer1.Open;
 Form1.MediaPlayer1.Play;
 while A<>100 do;
 begin
   fPosition := TimeToStr(Form1.MediaPlayer1.Position / 100000 / 1000);
   fLength := TimeToStr(Form1.MediaPlayer1.Length / 100000 / 1000);
   Form1.Label3.Caption := fPosition + ' / ' + fLength;
   Application.ProcessMessages;
   sleep(1000)
 end;
end;

procedure TForm4.Button5Click(Sender: TObject);
begin
  Form4.BorderIcons := [biSystemMenu,biMinimize,biMaximize];
  ListBox1.Clear;
  Panel1.Visible := False;
  ListBox1.Enabled := True;
  Button1.Enabled := True;
  Button2.Enabled := True;
  Button3.Enabled := True;
  Button4.Enabled := True;
end;

procedure TForm4.Button6Click(Sender: TObject);
begin
  Form4.BorderIcons := [biSystemMenu,biMinimize,biMaximize];
  Panel1.Visible := False;
  ListBox1.Enabled := True;
  Button1.Enabled := True;
  Button2.Enabled := True;
  Button3.Enabled := True;
  Button4.Enabled := True;
end;

procedure TForm4.FormActivate(Sender: TObject);
begin
  if Form4.ClientWidth < 450 then Form4.ClientWidth := 450;
  if Form4.ClientHeight < 305 then Form4.ClientHeight := 305;
end;

end.
