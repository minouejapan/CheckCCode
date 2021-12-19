program TextLoad;

uses
  Vcl.Forms,
  TxtLoadUnit in 'TxtLoadUnit.pas' {TextLoadText},
  CheckCCode in 'CheckCCode.pas';

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown := True; メモリリークチェック用
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTextLoadText, TextLoadText);
  Application.Run;
end.
