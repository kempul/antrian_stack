object Form1_entriJkn: TForm1_entriJkn
  Left = 0
  Top = 0
  Caption = 'Form1_entriJkn'
  ClientHeight = 481
  ClientWidth = 780
  Color = clBtnText
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object panel2: TPanel
    AlignWithMargins = True
    Left = 64
    Top = 8
    Width = 593
    Height = 401
    BevelOuter = bvNone
    Caption = 'panel2'
    TabOrder = 0
    object edit2: TEdit
      AlignWithMargins = True
      Left = 3
      Top = 40
      Width = 587
      Height = 56
      Margins.Bottom = 20
      Align = alTop
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'edit2'
    end
    object touchKey1: TTouchKeyboard
      AlignWithMargins = True
      Left = 3
      Top = 119
      Width = 587
      Height = 224
      Align = alClient
      Color = clWhite
      GradientEnd = clSkyBlue
      GradientStart = clHighlight
      Layout = 'NumPad'
      ParentColor = False
    end
    object txt1: TJvStaticText
      Left = 0
      Top = 0
      Width = 593
      Height = 37
      Align = alTop
      Alignment = taCenter
      Caption = 'Masukkan Nomor Bpjs / Jkn / Askes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -27
      HotTrackFont.Name = 'Tahoma'
      HotTrackFont.Style = []
      Layout = tlTop
      ParentFont = False
      TabOrder = 2
      TextMargins.X = 0
      TextMargins.Y = 0
      WordWrap = False
    end
    object panelBawah: TPanel
      Left = 0
      Top = 346
      Width = 593
      Height = 55
      Margins.Bottom = 20
      Align = alBottom
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object jvgLabel3: TJvStaticText
        Left = 0
        Top = 0
        Width = 101
        Height = 55
        Align = alLeft
        Alignment = taCenter
        Caption = 'Kembali'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInfoBk
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = []
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -27
        HotTrackFont.Name = 'Arial'
        HotTrackFont.Style = []
        Layout = tlBottom
        ParentFont = False
        TabOrder = 0
        TextMargins.X = 0
        TextMargins.Y = 0
        WordWrap = False
        OnClick = jvgLabel3Click
      end
      object jvgLabel1: TJvStaticText
        Left = 101
        Top = 0
        Width = 492
        Height = 55
        Align = alClient
        Alignment = taCenter
        Caption = 'Lanjut'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInfoBk
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = []
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -27
        HotTrackFont.Name = 'Arial'
        HotTrackFont.Style = []
        Layout = tlBottom
        ParentFont = False
        TabOrder = 1
        TextMargins.X = 0
        TextMargins.Y = 0
        WordWrap = False
        OnClick = jvgLabel1Click
      end
    end
  end
end