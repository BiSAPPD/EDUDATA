Attribute VB_Name = "creat_ecad_data"

Sub creat_data()

Dim FilePatch As String
Dim ar_Data_EDU(), ar_Data_TR(), ar_JoinData()
Dim xxx As Integer
Dim patchTR$, nmBrand$, nm_Mreg$, nm_Sector$, nm_Mreg_ext$, nm_month_qnc$, nm_business$, nm_Salon$, nm_Salon_addr$, nm_Salon_city$, type_sln_rus$
Dim mag_min_price&, mag_max_price&, mag_hd_place&, ThisYear&, cd_year_qnc&, num_month&, sts_dn_cln&, cd_month_qnc&
Dim min_price As Variant, max_price As Variant

myLib.VBA_Start

ar_brand = Array("MX", "LP", "KR", "RD", "ES")
num_ar_brand = UBound(ar_brand)
ThisYear = 2016
in_data_EDU = "Educated"
yyy = 2
Sub creat_data()

Dim FilePatch As String
Dim ar_Data_EDU(), ar_Data_TR(), ar_JoinData()
Dim xxx As Integer
Dim patchTR$, nmBrand$, nm_Mreg$, nm_Sector$, nm_Mreg_ext$, nm_month_qnc$, nm_business$, nm_Salon$, nm_Salon_addr$, nm_Salon_city$, type_sln_rus$
Dim mag_min_price&, mag_max_price&, mag_hd_place&, ThisYear&, cd_year_qnc&, num_month&, sts_dn_cln&, cd_month_qnc&
Dim min_price As Variant, max_price As Variant

myLib.VBA_Start

ar_brand = Array("MX", "LP", "KR", "RD", "ES")
num_ar_brand = UBound(ar_brand)
ThisYear = 2016
in_data_EDU = "Educated"
yyy = 1

EDUDATA = ActiveWorkbook.name
in_edudata = "in_data"
myLib.CreateSh (in_edudata)

For f_brand = 0 To num_ar_brand
    nmBrand = ar_brand(f_brand)

    patchTR = "p:\DPP\Business development\Book commercial\" & nmBrand & "\Top Russia Total " & ThisYear & " " & nmBrand & ".xlsm"
    actTR = myLib.OpenFile(patchTR, nmBrand)

    tr_LastRow = fn_lastRow
    tr_count_row = tr_LastRow - 3
    ReDim ar_Data_TR(1 To tr_count_row, 1 To 100)
    
    Dim dic_idECAD: Set dic_idECAD = CreateObject("Scripting.Dictionary")
    Dim dic_City: Set dic_City = CreateObject("Scripting.Dictionary")
    Dim dic_Sec: Set dic_Sec = CreateObject("Scripting.Dictionary")
    Dim dic_Head: Set dic_Head = CreateObject("Scripting.Dictionary")

    start_row = 4

    iii = 0
    For f_i = start_row To tr_LastRow
        nm_Mreg = Cells(f_i, 4)

        Application.StatusBar = False
        Application.StatusBar = actTR & " row: " & iii & " in: " & tr_LastRow

        If Application.CountA(Rows(f_i)) <> 0 Then
            If InStr(LCase(nm_Mreg), "e-commerce") = 0 Then
            iii = iii + 1

            
            nm_Sector = Cells(f_i, 6)
            nm_Mreg_ext = fn_mreg_ext(nm_Mreg, nm_Sector)
            nm_Mreg_LT = fn_mreg_lat(nm_Mreg_ext)
            nm_REG = Cells(f_i, 5)
            nm_FLSM = Cells(f_i, 165)
            nm_Srep = Cells(f_i, 7)
            nm_Salon = Cells(f_i, 9)
            nm_Salon_addr = Cells(f_i, 12)
            nm_Salon_city = Cells(f_i, 11)
            nm_month_qnc = Cells(f_i, 64)
            cd_month_qnc = fn_month_num(nm_month_qnc)
            cd_year_qnc = fn_num2num0(Cells(f_i, 65))
            type_sln_rus = Cells(f_i, 18)
            nm_club_type = Cells(f_i, 40)
            nm_chain = Cells(f_i, 19)
            min_price = Cells(f_i, 23)
            mag_min_price = fn_rnd_num(min_price)
            max_price = Cells(f_i, 25)
            mag_max_price = fn_rnd_num(max_price)
            mag_hd_place = fn_rnd_num(Cells(f_i, 27))
            cnt_AVG_HD = fn_rnd_num(Cells(f_i, 28))
            nm_business = fn_type_business(nmBrand)

            vl_mag = fn_mag(mag_min_price, mag_max_price, mag_hd_place, nm_business) & fn_mag(mag_min_price, mag_max_price, mag_hd_place, "place")
            If Len(vl_mag) <> 2 Then vl_mag = Null

            sts_dn_cln = Cells(f_i, 8)
            id_ECAD = Cells(f_i, 29)
            nm_Partners = Cells(f_i, 167)
            cd_Partner = Cells(f_i, 173)
            nm_SLN_ADR_CITY = fn_salon_name(nm_Salon, nm_Salon_addr, nm_Salon_city)
        
            n = 1: ar_Data_TR(iii, n) = nmBrand: If iii = 1 Then dic_Head.Add n, "brand"
            n = n + 1: ar_Data_TR(iii, n) = nm_Mreg: If iii = 1 Then dic_Head.Add n, "mreg": clm_nm_mreg = n
            n = n + 1: ar_Data_TR(iii, n) = nm_Mreg_LT: If iii = 1 Then dic_Head.Add n, "mreg_EXT": clm_nm_mreg_ext = n
            n = n + 1: ar_Data_TR(iii, n) = nm_REG: If iii = 1 Then dic_Head.Add n, "REG"
            n = n + 1: ar_Data_TR(iii, n) = nm_FLSM: If iii = 1 Then dic_Head.Add n, "FLSM"
            n = n + 1: ar_Data_TR(iii, n) = nm_Sector: If iii = 1 Then dic_Head.Add n, "SEC"
            n = n + 1: ar_Data_TR(iii, n) = nm_Srep: If iii = 1 Then dic_Head.Add n, "SREP"
            n = n + 1: ar_Data_TR(iii, n) = nm_SLN_ADR_CITY: If iii = 1 Then dic_Head.Add n, "salon": clm_nm_salon = n
            n = n + 1: ar_Data_TR(iii, n) = nm_Salon_city: If iii = 1 Then dic_Head.Add n, "city": clm_nm_city = n
            n = n + 1: ar_Data_TR(iii, n) = type_sln_rus: If iii = 1 Then dic_Head.Add n, "type_SLN"
            n = n + 1: ar_Data_TR(iii, n) = fn_clnt_type(type_sln_rus, 2): If iii = 1 Then dic_Head.Add n, "salon_type_eng"
            n = n + 1: ar_Data_TR(iii, n) = fn_clnt_type(type_sln_rus, 3): If iii = 1 Then dic_Head.Add n, "salon_type_short_eng"
            n = n + 1: ar_Data_TR(iii, n) = fn_clnt_type(type_sln_rus, 4): If iii = 1 Then dic_Head.Add n, "salon_type_chain_eng"
            n = n + 1: ar_Data_TR(iii, n) = nm_club_type: If iii = 1 Then dic_Head.Add n, "type_CLUB"
            n = n + 1: ar_Data_TR(iii, n) = nm_chain: If iii = 1 Then dic_Head.Add n, "chain_name"
            n = n + 1: ar_Data_TR(iii, n) = cd_month_qnc: If iii = 1 Then dic_Head.Add n, "CNQ_month_num"
            n = n + 1: ar_Data_TR(iii, n) = fn_year_cnq(ThisYear, cd_year_qnc, 2): If iii = 1 Then dic_Head.Add n, "CNQ_year"
            n = n + 1: ar_Data_TR(iii, n) = fn_quartal(cd_month_qnc): If iii = 1 Then dic_Head.Add n, "cnq_Quarter"
            n = n + 1: ar_Data_TR(iii, n) = vl_mag: If iii = 1 Then dic_Head.Add n, "type_MAG"
            n = n + 1: ar_Data_TR(iii, n) = fn_type_active_DN(sts_dn_cln): If iii = 1 Then dic_Head.Add n, "status_DN_name"
            n = n + 1: ar_Data_TR(iii, n) = id_ECAD: If iii = 1 Then dic_Head.Add n, "EDU_id_ECAD": clm_id_ecad = n
            n = n + 1: ar_Data_TR(iii, n) = mag_hd_place: If iii = 1 Then dic_Head.Add n, "_place_HD"
            n = n + 1: ar_Data_TR(iii, n) = cnt_AVG_HD: If iii = 1 Then dic_Head.Add n, "cnt_AVG_HD"
            n = n + 1: ar_Data_TR(iii, n) = nm_Partners: If iii = 1 Then dic_Head.Add n, "nm_partner"
            n = n + 1: ar_Data_TR(iii, n) = cd_Partner: If iii = 1 Then dic_Head.Add n, "cd_partner"
            n = n + 1: ar_Data_TR(iii, n) = Empty: If iii = 1 Then dic_Head.Add n, "status_link": status_link = n
            n = n + 1: ar_Data_TR(iii, n) = Empty: If iii = 1 Then dic_Head.Add n, "status_educated": n_status_educated = n

            If Not dic_idECAD.Exists(id_ECAD) Then dic_idECAD.Add id_ECAD, id_ECAD
            If Not dic_City.Exists(nm_Salon_city) And Not IsEmpty(nm_Salon_city) Then dic_City.Add nm_Salon_city, nm_Mreg_LT
            If Not dic_Sec.Exists(nm_Sector) And Not IsEmpty(nm_Sector) Then dic_Sec.Add nm_Sector, nm_Mreg_LT
            
            End If
        End If
        Next f_i
    long_TR_ar = iii

    file_name = "salons_educated_" & nmBrand
    FilePatch = "p:\DPP\Business development\Statistics Service\EDU\Base\" & file_name & ".csv"
    Application.StatusBar = False
    Application.StatusBar = "Open file " & FilePatch
    fn_openFileCSV (FilePatch)
    actEDUBook = file_name
    Application.StatusBar = False
    Application.StatusBar = "Work file is: " & actEDUBook

    edu_LastRow = ActiveSheet.UsedRange.row + ActiveSheet.UsedRange.Rows.Count - 1
    edu_LastColumn = ActiveSheet.UsedRange.Column + ActiveSheet.UsedRange.Columns.Count - 1

    ReDim ar_Data_EDU(1 To edu_LastRow, 1 To edu_LastColumn)

    Dim dic_eduID: Set dic_eduID = CreateObject("Scripting.Dictionary")
    dic_eduID.RemoveAll

    For f_rw = 1 To edu_LastRow
        For f_clm = 1 To edu_LastColumn
            If f_clm = 1 Then
                edu_id = Cells(f_rw, 1)
                    If Not dic_eduID.Exists(edu_id) Then
                    dic_eduID.Add edu_id, f_rw
                    End If
            End If
        
        If Cells(f_rw, f_clm).Value = 0 Then
        vl_c = Empty
        Else
        vl_c = Cells(f_rw, f_clm).Value
        End If
        ar_Data_EDU(f_rw, f_clm) = vl_c
        Next f_clm
    Application.StatusBar = False
    Application.StatusBar = actEDUBook & " row: " & f_rw & " in: " & edu_LastRow & " clmn: " & f_clm & " in: " & edu_LastColumn
    Next f_rw
    Application.StatusBar = "Close file: " & actEDUBook
    Workbooks(actEDUBook).Close

    '--------------------------------------------
    Application.StatusBar = False
    Application.StatusBar = "Join ECAD & TR "
    ReDim ar_JoinData(1 To long_TR_ar + UBound(ar_Data_EDU), 1 To n + edu_LastColumn)

    iii = 1
    For f_tr_rw = 1 To long_TR_ar
    Application.StatusBar = False
    Application.StatusBar = "Work Array TR " & f_tr_clm & "to " & long_TR_ar
        For f_tr_clm = 1 To n
            ar_JoinData(iii, f_tr_clm) = ar_Data_TR(f_tr_rw, f_tr_clm)
        Next f_tr_clm
            tr_key = Empty
            tr_key = ar_Data_TR(f_tr_rw, clm_id_ecad)
                If dic_eduID.Exists(tr_key) Then
                    ar_JoinData(iii, status_link) = "LINK"
                    rw_edu_dataset = dic_eduID.Item(tr_key)
                    xxx = 1
                    strt_jd_edu_clmn = n
                        For f_edu_clm = strt_jd_edu_clmn To strt_jd_edu_clmn + edu_LastColumn - 1
                            ar_JoinData(iii, f_edu_clm) = ar_Data_EDU(rw_edu_dataset, xxx)
                            '---------------------------------------------------------------------------------------------------------
                            If ar_Data_EDU(rw_edu_dataset, 7) <> 0 Then
                            status_educated = "edu_TY"
                            Else
                                If ar_Data_EDU(rw_edu_dataset, 6) <> 0 Then
                                status_educated = "edu_PY"
                                Else
                                    If ar_Data_EDU(rw_edu_dataset, 5) <> 0 Then
                                    status_educated = "edu_ALLTIME"
                                    Else
                                
                                    status_educated = Empty
                                    End If
                                    End If
                                    End If
                            '---------------------------------------------------------------------------------------------------------
                            xxx = xxx + 1
                        Next f_edu_clm
                        Else
                        ar_JoinData(iii, status_link) = "UNLINK"
                        status_educated = Empty
                End If
                ar_JoinData(iii, n_status_educated) = status_educated
    iii = iii + 1

    Next f_tr_rw
    '---------------------------------------------------------------------------------------------------------
    end_ecad_row = UBound(ar_Data_EDU)

    For f_edu_rw = 1 To end_ecad_row
    Application.StatusBar = False
    Application.StatusBar = "Work Array ECAD whitout TR row " & f_edu_rw & "to " & end_ecad_row
        ecad_key = Empty
        ecad_key = ar_Data_EDU(f_edu_rw, 1)
        If Not dic_idECAD.Exists(ecad_key) And Not IsEmpty(ecad_key) Then
        
                
                    If dic_Sec.Exists(ar_Data_EDU(f_edu_rw, 3)) Then
                    ar_JoinData(iii, clm_nm_mreg_ext) = dic_Sec.Item(ar_Data_EDU(f_edu_rw, 3))
                    Else
                        If dic_City.Exists(ar_Data_EDU(f_edu_rw, 22)) Then
                        ar_JoinData(iii, clm_nm_mreg_ext) = dic_City.Item(ar_Data_EDU(f_edu_rw, 22))
                    
                        End If
                    End If
                    
            ar_JoinData(iii, status_link) = "UNLINK"
            ar_JoinData(iii, 1) = nmBrand
            ar_JoinData(iii, clm_nm_salon) = ar_Data_EDU(f_edu_rw, 2)
            
    '---------------------------------------------------------------------------------------------------------
                            If ar_Data_EDU(f_edu_rw, 7) <> 0 Then
                            status_educated = "edu_TY"
                            Else
                                If ar_Data_EDU(f_edu_rw, 6) <> 0 Then
                                status_educated = "edu_PY"
                                Else
                                    If ar_Data_EDU(f_edu_rw, 5) <> 0 Then
                                    status_educated = "edu_ALLTIME"
                                    Else
                                    status_educated = Empty
                                    End If
                                    End If
                                    End If
    '---------------------------------------------------------------------------------------------------------
            ar_JoinData(iii, n_status_educated) = status_educated
            rw_edu_dataset = dic_eduID.Item(ecad_key)
            xxx = 1
            strt_jd_edu_clmn = n
                For f_edu_clm = strt_jd_edu_clmn To strt_jd_edu_clmn + edu_LastColumn - 1
                    
                    If f_edu_rw = 1 Then
                    ar_JoinData(1, f_edu_clm) = ar_Data_EDU(rw_edu_dataset, xxx)
                    Else
                    ar_JoinData(iii, f_edu_clm) = ar_Data_EDU(rw_edu_dataset, xxx)
                    End If
                    xxx = xxx + 1
                    
                Next f_edu_clm
                If f_edu_rw <> 1 Then iii = iii + 1
                End If
    Next f_edu_rw
    Application.StatusBar = False
    Application.StatusBar = "TR activate"
    Workbooks(actTR).Activate
    Sheets(in_data_EDU).Select
    Application.StatusBar = False
    Application.StatusBar = "TR fill EDUCATED"
    ActiveSheet.UsedRange.Cells.ClearContents
    ActiveSheet.Cells(2, 1).Resize(iii - start_row, n + edu_LastColumn) = ar_JoinData
    Cells(1, 1).Select
    Selection.AutoFilter

    'Calculate

    Sheets(nmBrand).Select
    Application.StatusBar = False
    Application.StatusBar = nmBrand & " TR Save"
    Workbooks(actTR).Save
    Workbooks(actTR).Close

    full_row = iii + full_row

    Workbooks(EDUDATA).Activate
    Sheets(in_edudata).Select

    Select Case f_brand
        Case 0
            ActiveSheet.UsedRange.Cells.ClearContents
            strt_jd_rw = 1
        Case Else
            strt_jd_rw = 2
    End Select


    For f_rw_jd = strt_jd_rw To iii - 1

        For f_clm_jd = 1 To (n + edu_LastColumn)
        Cells(yyy, f_clm_jd) = ar_JoinData(f_rw_jd, f_clm_jd)
        Next f_clm_jd
    yyy = yyy + 1
    Next f_rw_jd

Next f_brand

fn_VBA_End
    
End Sub






