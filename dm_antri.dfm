object dataAntri: TdataAntri
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 403
  Width = 754
  object fdTransaction2: TFDTransaction
    Connection = FDConnection1
    Left = 448
    Top = 152
  end
  object fdpgdriver1: TFDPhysPgDriverLink
    Left = 340
    Top = 16
  end
  object fdQNikCari: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'select idxstr, nik, mr, kartu_bpjs from capil.capil_nik where ni' +
        'k = :nik')
    Left = 16
    Top = 152
    ParamData = <
      item
        Name = 'NIK'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdQDaftar: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'INSERT INTO simpus.pasien_kunjungan ("tanggal", "id_pasien", "bi' +
        'aya", "datang_rujukan", "datang_sebab", "datang_sebab_ket", "pol' +
        'i_tujuan", "lama", "instalasi", "jenis_kunjungan", antri)'
      
        'VALUES (CURRENT_DATE, :pasien, :biaya, E'#39'SENDIRI'#39', E'#39'tes'#39', NULL,' +
        ' :poli, 1, E'#39'RAWAT JALAN'#39', E'#39'Kunjungan Sakit'#39', :antri);')
    Left = 448
    Top = 84
    ParamData = <
      item
        Name = 'PASIEN'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'BIAYA'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'POLI'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ANTRI'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdQJknCari: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'select idxstr, nik, mr, kartu_bpjs from capil.capil_nik  where k' +
        'artu_bpjs = :bpjs')
    Left = 124
    Top = 152
    ParamData = <
      item
        Name = 'BPJS'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdQRmCari: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'select idxstr, nik, mr, kartu_bpjs from capil.capil_nik  where m' +
        'r = :mr')
    Left = 340
    Top = 152
    ParamData = <
      item
        Name = 'MR'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 232
    Top = 16
  end
  object fdQPoli: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'select poli from simpus.m_poli where poli_sakit = true and adl_a' +
        'ktif = true order by upper(poli)')
    Left = 232
    Top = 152
  end
  object fdQKunjunganAmbil: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'select max(idxstr) idxstr from simpus.pasien_kunjungan where tan' +
        'ggal = current_date and id_pasien = :pasien')
    Left = 340
    Top = 84
    ParamData = <
      item
        Name = 'PASIEN'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdQAntri: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO simpus.antri (tanggal, sidik)'
      'VALUES (current_date, :sidik);')
    Left = 448
    Top = 16
    ParamData = <
      item
        Name = 'SIDIK'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdQAntriAmbil: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT '
      '  simpus.puskesmas.nama,'
      '  simpus.antri.tanggal,'
      '  simpus.antri.nomor'
      'FROM'
      '  simpus.antri'
      
        '  INNER JOIN simpus.puskesmas ON (simpus.antri.puskesmas = simpu' +
        's.puskesmas.kd_cabang) '
      
        'where tanggal = current_date and nomor = (select max(nomor) from' +
        ' simpus.antri where tanggal = current_date and sidik = :sidik)')
    Left = 16
    Top = 84
    ParamData = <
      item
        Name = 'SIDIK'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDConnection1: TFDConnection
    LoginPrompt = False
    Left = 16
    Top = 16
  end
  object fdQPuskesmas: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'select kd_cabang from simpus.puskesmas where adl_aktif = 1 limit' +
        ' 1')
    Left = 232
    Top = 84
  end
  object fdQ1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'select count(*) as jumlah from jkn.peserta where no_kartu = :no_' +
        'kartu and adl_aktif = true and is_provider = true')
    Left = 124
    Top = 84
    ParamData = <
      item
        Name = 'NO_KARTU'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdQ2: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'select count(*) as jml from simpus.pasien_kunjungan where tangga' +
        'l = current_date and id_pasien = :pasien and poli_tujuan = :poli' +
        '  ')
    Left = 360
    Top = 256
    ParamData = <
      item
        Name = 'PASIEN'
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'POLI'
        ParamType = ptInput
      end>
  end
end
