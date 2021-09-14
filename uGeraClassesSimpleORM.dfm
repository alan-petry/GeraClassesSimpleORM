object frmGeradorClassesSimpleORM: TfrmGeradorClassesSimpleORM
  Left = 0
  Top = 0
  Caption = 'Gerador de Classes para SimpleORM'
  ClientHeight = 614
  ClientWidth = 878
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 878
    Height = 614
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 41
      Width = 878
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Alan Petry - alanpetry@alnet.eti.br - Fone: (54)98415-0888'
      Color = 6045984
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object Panel3: TPanel
      Left = 0
      Top = 81
      Width = 878
      Height = 144
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object btnGerarClasses: TButton
        Left = 488
        Top = 104
        Width = 121
        Height = 25
        Caption = 'Gerar Classes'
        TabOrder = 0
        OnClick = btnGerarClassesClick
      end
      object edtCaminhoArquivos: TLabeledEdit
        Left = 488
        Top = 30
        Width = 345
        Height = 21
        EditLabel.Width = 106
        EditLabel.Height = 13
        EditLabel.Caption = 'Caminho dos Arquivos'
        TabOrder = 1
      end
      object edtPrefixoEntidades: TLabeledEdit
        Left = 488
        Top = 77
        Width = 121
        Height = 21
        EditLabel.Width = 84
        EditLabel.Height = 13
        EditLabel.Caption = 'Prefixo Entidades'
        TabOrder = 2
        Text = 'Gerador.Entidades'
      end
      object edtCaminhoBanco: TLabeledEdit
        Left = 24
        Top = 30
        Width = 393
        Height = 21
        EditLabel.Width = 136
        EditLabel.Height = 13
        EditLabel.Caption = 'Caminho do Banco de Dados'
        TabOrder = 3
      end
      object edtUsuario: TLabeledEdit
        Left = 24
        Top = 70
        Width = 121
        Height = 21
        EditLabel.Width = 36
        EditLabel.Height = 13
        EditLabel.Caption = 'Usu'#225'rio'
        TabOrder = 4
        Text = 'sysdba'
      end
      object edtSenha: TLabeledEdit
        Left = 24
        Top = 109
        Width = 121
        Height = 21
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Senha'
        TabOrder = 5
        Text = 'masterkey'
      end
      object btnConectar: TButton
        Left = 176
        Top = 104
        Width = 91
        Height = 25
        Caption = 'Conectar'
        TabOrder = 6
        OnClick = btnConectarClick
      end
      object Button3: TButton
        Left = 342
        Top = 57
        Width = 75
        Height = 25
        Caption = 'TESTES'
        TabOrder = 7
        Visible = False
        OnClick = Button3Click
      end
      object btnModelController: TButton
        Left = 695
        Top = 104
        Width = 138
        Height = 25
        Caption = 'Gerar Model e Controller'
        TabOrder = 8
        OnClick = btnModelControllerClick
      end
      object edtPrefixoModel: TLabeledEdit
        Left = 695
        Top = 77
        Width = 138
        Height = 21
        EditLabel.Width = 124
        EditLabel.Height = 13
        EditLabel.Caption = 'Prefixo Model e Controller'
        TabOrder = 9
        Text = 'Gerador'
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 225
      Width = 878
      Height = 389
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object script: TMemo
        Left = 241
        Top = 0
        Width = 637
        Height = 389
        Align = alClient
        TabOrder = 0
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 241
        Height = 389
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object chkListaTabelas: TCheckListBox
          AlignWithMargins = True
          Left = 0
          Top = 57
          Width = 241
          Height = 332
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          ItemHeight = 13
          TabOrder = 0
        end
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 241
          Height = 57
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object Button1: TButton
            Left = 16
            Top = 16
            Width = 97
            Height = 25
            Caption = 'Marcar Todas'
            TabOrder = 0
            OnClick = Button1Click
          end
          object Button2: TButton
            Left = 128
            Top = 16
            Width = 99
            Height = 25
            Caption = 'Desmarcar Todas'
            TabOrder = 1
            OnClick = Button2Click
          end
        end
      end
    end
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 878
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Gerador de Classes para SimpleORM'
      Color = 6045984
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
    end
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 608
    Top = 281
  end
end
