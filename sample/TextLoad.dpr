program TextLoad;

uses
  Vcl.Forms,
  TxtLoadUnit in 'TxtLoadUnit.pas' {TextLoadText},
  CheckCCode in 'CheckCCode.pas';

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown := True; ���������[�N�`�F�b�N�p
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTextLoadText, TextLoadText);
  Application.Run;
end.
