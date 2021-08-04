object FrmRectangles: TFrmRectangles
  Left = 0
  Top = 0
  Caption = #1055#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082#1080
  ClientHeight = 405
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox: TPaintBox
    Left = 0
    Top = 54
    Width = 539
    Height = 351
    Align = alClient
    OnMouseDown = PaintBoxMouseDown
    OnMouseMove = PaintBoxMouseMove
    OnMouseUp = PaintBoxMouseUp
    OnPaint = PaintBoxPaint
    ExplicitTop = 0
    ExplicitWidth = 537
    ExplicitHeight = 481
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 0
    Width = 539
    Height = 54
    Align = alTop
    TabOrder = 0
    object btnAdd: TButton
      Left = 56
      Top = 14
      Width = 105
      Height = 25
      Caption = #1053#1072#1088#1080#1089#1086#1074#1072#1090#1100
      TabOrder = 0
      OnClick = btnAddClick
    end
  end
  object tmrMoving: TTimer
    Enabled = False
    OnTimer = tmrMovingTimer
    Left = 16
    Top = 8
  end
end
