unit TxtLoadUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SaveDialogEx, Vcl.ExtCtrls, ShlObj;

type
  TTextLoadText = class(TForm)
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    SaveBtn: TButton;
    LoadBtn: TButton;
    Label2: TLabel;
    Label1: TLabel;
    FileSaveDialog1: TFileSaveDialog;
    procedure LoadBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FileSaveDialog1Execute(Sender: TObject);
  private
    { Private 宣言 }
    Fdc: IFileDialogCustomize;
  public
    { Public 宣言 }
  end;

var
  TextLoadText: TTextLoadText;

implementation

{$R *.dfm}

uses
  CheckCCode,
  MyFileDialogEvents;

var
  FileDialog: IFileDialog     = nil;
  MyEvents: IFileDialogEvents = nil;
  MyEventsCookie: DWORD       = 0;

const
  dwIDCtl = 19000;

// ファイルセーブダイアログに選択項目を追加する
procedure TTextLoadText.FileSaveDialog1Execute(Sender: TObject);
var
  fdevt: IFileDialogEvents;
  cookie: DWORD;
begin
  inherited;

  // IFileDialogCustomizeをサポートするかどうか問い合わせる
  if Supports(FileSaveDialog1.Dialog, IFileDialogCustomize, Fdc) then
  begin
    // 返されたFileSaveDialog1のIFileDialogCustomizeインターフェイスに対して
    // コントロールを追加する
    //
    // AddTextでラベルを追加すると文字が青色になることとComboBoxとのレイアウト
    // が思うようにならないため、StartVisualGroupでラベルと追加する(色はグレーだけど)
    Fdc.StartVisualGroup(dwIDCtl, PWideChar('文字コードセット：'));
    Fdc.AddComboBox(dwIDCtl + 1);
    Fdc.AddControlItem(dwIDCtl + 1, 0, 'Shift-JIS');  // ComboBoxにアイテムを追加する
    Fdc.AddControlItem(dwIDCtl + 1, 1, 'JIS');
    Fdc.AddControlItem(dwIDCtl + 1, 2, 'EUC-JP');
    Fdc.AddControlItem(dwIDCtl + 1, 3, 'Unicode(Little Endian)');
    Fdc.AddControlItem(dwIDCtl + 1, 4, 'Unicode(Big Endian)');
    Fdc.AddControlItem(dwIDCtl + 1, 5, 'UTF-8');
    Fdc.AddControlItem(dwIDCtl + 1, 6, 'UTF-8N');
    Fdc.SetSelectedControlItem(dwIDCtl + 1, 0);  // 0番目を選択
    Fdc.EndVisualGroup;

    Fdc.StartVisualGroup(dwIDCtl + 2, PWideChar('改行コード：'));
    Fdc.AddComboBox(dwIDCtl + 3);
    Fdc.AddControlItem(dwIDCtl + 3, 0, 'CR+LF');  // ComboBoxにアイテムを追加する
    Fdc.AddControlItem(dwIDCtl + 3, 1, 'CR');
    Fdc.AddControlItem(dwIDCtl + 3, 2, 'LF');
    Fdc.SetSelectedControlItem(dwIDCtl + 3, 0);   // 0番目を選択
    Fdc.EndVisualGroup;

    // イベントを登録(ボタンが押された等のイベントを処理しない場合は以下の登録は
    // しなくても良いようだ)
    fdevt := TMyFileDialogEvents.Create;
    if Succeeded(FileSaveDialog1.Dialog.Advise(fdevt, cookie)) then
    begin
      FileDialog     := FileSaveDialog1.Dialog;
      MyEvents       := fdevt;
      MyEventsCookie := cookie;
    end;
  end;
end;

procedure TTextLoadText.LoadBtnClick(Sender: TObject);
var
	info: string;
begin
	if OpenDialog1.Execute then
	begin
    Memo1.Lines.Text := AutoCovertLoadFromFile(OpenDialog1.FileName);
    case DETECTED_CODE of
			CP_ANSI:		info := 'Ansi';
  		CP_SJIS:		info := 'Shift-JIS';
  		CP_EUCJP:		info := 'EUC-JP';
  		CP_JIS:			info := 'JIS';
  		CP_UTF7:		info := 'UTF-7';
  		CP_UTF8:		info := 'UTF-8';
  		CP_UTF8N:		info := 'UTF-8N';
  		CP_UTF16LE:	info := 'Unicode(Little Endian)';
  		CP_UTF16BE:	info := 'Unicode(Big Endian)';
      else				info := 'Unknown'
    end;
    Label2.Caption := info;
    FileSaveDialog1.FileName := OpenDialog1.FileName;
  end;
end;

procedure TTextLoadText.SaveBtnClick(Sender: TObject);
var
  id1, id2: DWORD;
  s1, s2: string;
	code: integer;
  br: string;
begin
  FileDialog     := nil;
  MyEvents       := nil;
  MyEventsCookie := 0;

  if FileSaveDialog1.Execute then
  begin
    // dwIDCtl + 1のComboBoxのItemIndexを取得する
    Fdc.GetSelectedControlItem(dwIDCtl + 1, id1);
    // dwIDCtl + 3のComboBoxのItemIndexを取得する
    Fdc.GetSelectedControlItem(dwIDCtl + 3, id2);
    case id1 of
        0:  begin
              s1 := 'Shift-JIS';
              code := CP_SJIS;
            end;
        1:  begin
              s1 := 'JIS';
              code := CP_JIS;
            end;
        2:  begin
              s1 := 'EUC-JP';
              code := CP_EUCJP;
            end;
        3:  begin
              s1 := 'Unicode(Little Endian)';
              code := CP_UTF16LE;
            end;
        4:  begin
              s1 := 'Unicode(Big Endian)';
              code := CP_UTF16BE;
            end;
        5:  begin
              s1 := 'UTF-8';
              code := CP_UTF8;
            end;
        6:  begin
              s1 := 'UTF-8N';
              code := CP_UTF8N;
            end;
    end;
    case id2 of
        0:  begin
              s2 := 'CR+LF';
              br := #13#10;
            end;
        1:  begin
              s2 := 'CR';
              br := #13;
            end;
        2:  begin
              s2 := 'LF';
              br := #10;
            end;
    end;
    Label2.Caption := s1 + ' (' + s2 + ')';
    if (FileDialog <> nil) and (MyEventsCookie <> 0) then
      FileDialog.Unadvise(MyEventsCookie);
    FileDialog     := nil;
    MyEvents       := nil;
    MyEventsCookie := 0;
   	ConvertSaveToFIle(FileSaveDialog1.FileName, Memo1.Lines.Text, code, br);
  end;
end;

end.
