{
  èÓïÒå≥ÅFstackoverflow
    Add a IFileDialogCustomize PushButton Event
    https://stackoverflow.com/questions/10888934/add-a-ifiledialogcustomize-pushbutton-event
}
unit MyFileDialogEvents;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, ShellAPI, ShlObj;


type
  TMyFileDialogEvents = class(TInterfacedObject, IFileDialogEvents, IFileDialogControlEvents)
  public
    { IFileDialogEvents }
    function OnFileOk(const pfd: IFileDialog): HResult; stdcall;
    function OnFolderChanging(const pfd: IFileDialog;
      const psiFolder: IShellItem): HResult; stdcall;
    function OnFolderChange(const pfd: IFileDialog): HResult; stdcall;
    function OnSelectionChange(const pfd: IFileDialog): HResult; stdcall;
    function OnShareViolation(const pfd: IFileDialog; const psi: IShellItem;
      out pResponse: DWORD): HResult; stdcall;
    function OnTypeChange(const pfd: IFileDialog): HResult; stdcall;
    function OnOverwrite(const pfd: IFileDialog; const psi: IShellItem;
      out pResponse: DWORD): HResult; stdcall;
    { IFileDialogControlEvents }
    function OnItemSelected(const pfdc: IFileDialogCustomize; dwIDCtl: DWORD;
      dwIDItem: DWORD): HResult; stdcall;
    function OnButtonClicked(const pfdc: IFileDialogCustomize;
      dwIDCtl: DWORD): HResult; stdcall;
    function OnCheckButtonToggled(const pfdc: IFileDialogCustomize;
      dwIDCtl: DWORD; bChecked: BOOL): HResult; stdcall;
    function OnControlActivating(const pfdc: IFileDialogCustomize;
      dwIDCtl: DWORD): HResult; stdcall;
  end;

const
  dwVisualGroup1ID: DWORD = 1900;

implementation

function TMyFileDialogEvents.OnFileOk(const pfd: IFileDialog): HResult;
begin
  Result := E_NOTIMPL;
end;

function TMyFileDialogEvents.OnFolderChange(const pfd: IFileDialog): HResult;
begin
  Result := E_NOTIMPL;
end;

function TMyFileDialogEvents.OnFolderChanging(const pfd: IFileDialog;
  const psiFolder: IShellItem): HResult;
begin
  Result := E_NOTIMPL;
end;

function TMyFileDialogEvents.OnOverwrite(const pfd: IFileDialog;
  const psi: IShellItem; out pResponse: DWORD): HResult;
begin
  Result := E_NOTIMPL;
end;

function TMyFileDialogEvents.OnSelectionChange(const pfd: IFileDialog): HResult;
begin
  Result := E_NOTIMPL;
end;

function TMyFileDialogEvents.OnShareViolation(const pfd: IFileDialog;
  const psi: IShellItem; out pResponse: DWORD): HResult;
begin
  Result := E_NOTIMPL;
end;

function TMyFileDialogEvents.OnTypeChange(const pfd: IFileDialog): HResult;
begin
  Result := E_NOTIMPL;
end;

function TMyFileDialogEvents.OnItemSelected(const pfdc: IFileDialogCustomize; dwIDCtl: DWORD; dwIDItem: DWORD): HResult;
begin
  Result := E_NOTIMPL;
end;

function TMyFileDialogEvents.OnButtonClicked(const pfdc: IFileDialogCustomize; dwIDCtl: DWORD): HResult;
begin
  if dwIDCtl = dwVisualGroup1ID then begin
    // ...
    Result := S_OK;
  end else begin
    Result := E_NOTIMPL;
  end;
end;

function TMyFileDialogEvents.OnCheckButtonToggled(const pfdc: IFileDialogCustomize; dwIDCtl: DWORD; bChecked: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

function TMyFileDialogEvents.OnControlActivating(const pfdc: IFileDialogCustomize; dwIDCtl: DWORD): HResult;
begin
  Result := E_NOTIMPL;
end;


end.
