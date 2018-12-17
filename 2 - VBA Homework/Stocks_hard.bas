Attribute VB_Name = "Module1"
Sub Stocks()
    

'*****************************************************
' Challenge - run multiple or one sheet              *
'*****************************************************

' Select year want to run or run all using inputbox
    
    inputData = InputBox("Which year do you want to run?" + vbCrLf + _
    vbCrLf + "Input: Enter Year in YYYY format or type All", "Data to run")
    Year_to_run = inputData
    
' Stop the screen updating for performance
'    Application.ScreenUpdating = False

' Set loop counter to 1, if running 1 year and to number of tabs if running all
    
    If Year_to_run = "All" Or Year_to_run = "all" Then
        loop_counter = ThisWorkbook.Worksheets.Count
    Else
        loop_counter = 1
    End If

'************************
' Loop                  *
'************************

' Loop once, unless running all tabs
    
    For h = 1 To loop_counter
        
    'Select sheet
        
        If loop_counter = 1 Then
            Sheets(Year_to_run).Select
        Else
            Sheets(h).Select
        End If
  
    'Headers for first four columns
        
        Range("I1").Value = "Ticker"
        Range("J1").Value = "Yearly Change"
        Range("K1").Value = "Percent Change"
        Range("L1").Value = "Total Stock Volume"
        
    '********
    ' col I *
    '********
    
    'In column I, starting in I2 have a list of all Tickers on sheet; tickers stored in column A
        
        Range("I2").Value = Range("A2")      'put first ticker in cell I2
        Lastrow = Cells(Rows.Count, "A").End(xlUp).Row     'set end of below loop
        col_i_row = 3      'next row to enter in a ticker for column i
        
        For i = 3 To Lastrow
            If Cells(i, 1).Value <> Cells(i - 1, 1).Value Then
                Cells(col_i_row, 9).Value = Cells(i, 1).Value
                col_i_row = col_i_row + 1
            End If
        Next i
    
    '************
    ' col J & K *
    '************
    
    ' In column J need yearly change, which equals what the stock opened at (value in col C for col b YYYY0101)
    ' minus the closing price (value in col F for col b = higher of YYYY1230 or YYYY1231)
    
    ' Need max value of column B because some years closing 1230 and some 1231; setting Min date as well, for consistency
    
    Max_date = Application.WorksheetFunction.Max(Range("b:b"))
    Min_date = Application.WorksheetFunction.Min(Range("b:b"))
    
    ' Loop thru date to get open and close values; open is first date col B and close is last date col F
    
    Lastrow_j = Cells(Rows.Count, "I").End(xlUp).Row
    
    For j = 2 To Lastrow_j
        For j2 = 2 To Lastrow
            If Cells(j2, 2).Value = Min_date And Cells(j2, 1).Value = Cells(j, 9) Then
                open_value = Cells(j2, 3).Value
            ElseIf Cells(j2, 2).Value = Max_date And Cells(j2, 1).Value = Cells(j, 9) Then
                close_value = Cells(j2, 6).Value
            End If
        Next j2
        
        Cells(j, 10).Value = close_value - open_value
        
        ' Col K = close/open - 1
        
        Cells(j, 11).Value = close_value / open_value - 1
        
    Next j
    
    ' Formatting column J to 5 decimals
    
    Range("J2:J100000").Select
    Selection.NumberFormat = "0.00000"
    
    ' In column J, yearly change, format positive change in green and negative change in red
    
        Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlGreater, _
        Formula1:="=0"
    Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 5287936
        .TintAndShade = 0
    End With
    
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlLess, _
        Formula1:="=0"
    Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 255
        .TintAndShade = 0
    End With
    
    ' Format column K to percent
    
    Range("K1:K100000").Select
    Selection.NumberFormat = "0.00%"
    
    '************
    ' col L     *
    '************
    ' In column L add up column G if matches ticker
    
    Total_Stock_Vol = 0
    
    For l = 2 To Lastrow_j
        For l2 = 2 To Lastrow
            If Cells(l2, 1).Value = Cells(l, 9) Then
                Total_Stock_Vol = Total_Stock_Vol + Cells(l2, 7)
            End If
        Next l2
        
        Cells(l, 12).Value = Total_Stock_Vol
        Total_Stock_Vol = 0
       
    Next l
    
'******************
' Greatest stats  *
'******************

    ' Headers: In cell O2 "Greatest % Increase", in cell O3 "Greatest % Decrease", and in cell O4 "Greatest Total volume"
    ' in cell P1 "Ticker" and in cell Q1 "Value"
        Range("O2").Value = "Greatest % Increase"
        Range("O3").Value = "Greatest % Decrease"
        Range("O4").Value = "Greatest Total Volume"
        Range("P1").Value = "Ticker"
        Range("Q1").Value = "Value"
    
    ' In cell Q2 have the Greatest % increase from column K, with the corresponding ticker in P2
    ' In cell Q3 have the Great % Decrease from column K, with the corresponding ticker in P3
    ' In cell Q4 have the greatest total volume from column L, with the corresponding ticker in P4
        
        Max_increase = Application.WorksheetFunction.Max(Range("k:k"))
        Max_decrease = Application.WorksheetFunction.Min(Range("k:k"))
        
        For q = 2 To Lastrow_j
            If Cells(q, 11).Value = Max_increase Then
                Range("Q2").Value = Cells(q, 11).Value
                Range("P2").Value = Cells(q, 9).Value
            ElseIf Cells(q, 11).Value = Min_increase Then
                Range("Q3").Value = Cells(q, 11).Value
                Range("P3").Value = Cells(q, 9).Value
            End If
        Next q
        
        Max_volume = Application.WorksheetFunction.Max(Range("l:l"))
        
        For q2 = 2 To Lastrow_j
            If Cells(q2, 12).Value = Max_volume Then
                Range("Q4").Value = Cells(q2, 12).Value
                Range("P4").Value = Cells(q2, 9).Value
            End If
        Next q2
                
    ' Format columns and set active cell to A1
        
        Range("Q2:Q3").Select
        Selection.NumberFormat = "0.00%"
        Columns("K:K").Select
        Selection.NumberFormat = "0.00%"
        Columns("I:P").Select
        Columns("I:P").EntireColumn.AutoFit

        Range("A1").Select
     
    Next h
    
' Turn screen updating back on
'    Application.ScreenUpdating = True
    
End Sub
