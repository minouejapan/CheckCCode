# CheckCCode
文字コードの自動判別ルーチン

## 説明
Delphi用の文字コード自動判別テキストファイル読み込みと、文字コード・改行コードを指定したテキストファイル書き込みを行います。

## 公開ルーチン

// 文字コードを判別する
//
// SecText: 判定する文字列(元のコードが自動でStringにキャストされて変化
//												 しないようByteデータとして渡す)
// Size:    チェックする文字数を指定する(デフォルトは512Byte)
//          Sizeを省略した場合はCODE_CHK_LENのサイズでチェックする
// Result:  文字コードの種類
function CheckCharCode(SrcText: PByte; Size: integer): integer; overload;
function CheckCharCode(SrcText: PByte): integer; overload;

// BMP, JPG, GIF, PNG画像かどうかをチェックする
//
// SrcData: 判定するデータ列
// Result:  画像ファイルの種類
function CheckPictKind(SrcData: PByte): integer;

// 文字コード自動変換ロード
//
// FileName:読み込むファイル名
// Result:  自動変換されたテキスト文字列
function AutoCovertLoadFromFile(FileName: string): string;

// 文字コード変換ロード
//
// FileName:読み込むファイル名
// CodeType:変換する文字コードの種類
// Result:  自動変換されたテキスト文字列
function CovertLoadFromFile(FileName: string; CodeType: integer): string;

// 文字コード変換セーブ
//
// FileName:保存するファイル名
// CodeType:変換する文字コードの種類
// BreakChar:保存する改行コードの種類(省略した場合はBREAK_CHARとなる)
procedure ConvertSaveToFile(FileName: string; SrcText: string; CodeType: integer); overload;
procedure ConvertSaveToFile(FileName: string; SrcText: string; CodeType: integer; BreakChar: string); overload;
