unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;


type
  TForm3 = class(TForm)
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Button1: TButton;
    Image1: TImage;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form3: TForm3;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm3.Button1Click(Sender: TObject);
begin
Form3.Close;
Form1.Enabled:=True;
Form1.Show;
end;

end.
