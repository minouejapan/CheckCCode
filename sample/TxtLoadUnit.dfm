object TextLoadText: TTextLoadText
  Left = 0
  Top = 0
  Caption = 'TextLoadText'
  ClientHeight = 406
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 578
    Height = 372
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 372
    Width = 578
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      578
      34)
    object Label2: TLabel
      Left = 76
      Top = 8
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
    object Label1: TLabel
      Left = 12
      Top = 8
      Width = 51
      Height = 13
      Caption = #25991#23383#12467#12540#12489
    end
    object SaveBtn: TButton
      Left = 406
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #20445#23384'(&S)'
      TabOrder = 0
      OnClick = SaveBtnClick
    end
    object LoadBtn: TButton
      Left = 495
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #35501#12415#36796#12415'(&L)'
      TabOrder = 1
      OnClick = LoadBtnClick
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text Files(*.txt)|*.txt|All Files(*.*)|*.*'
    Left = 248
    Top = 260
  end
  object FileSaveDialog1: TFileSaveDialog
    DefaultExtension = 'txt'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = #12486#12461#12473#12488#12501#12449#12452#12523'(*.txt)'
        FileMask = '*.txt'
      end
      item
        DisplayName = #12377#12409#12390#12398#12501#12449#12452#12523'(*.*)'
      end>
    Options = []
    OnExecute = FileSaveDialog1Execute
    Left = 164
    Top = 256
  end
end
