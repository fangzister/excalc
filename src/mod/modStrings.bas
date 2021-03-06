Attribute VB_Name = "modStrings"
Option Explicit

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByVal Destination As Any, Source As Any, ByVal Length As Long)
Private Declare Function WideCharToMultiByte Lib "kernel32" (ByVal CodePage As Long, ByVal dwFlags As Long, ByVal lpWideCharStr As Long, ByVal cchWideChar As Long, ByRef lpMultiByteStr As Any, ByVal cchMultiByte As Long, ByVal lpDefaultChar As String, ByVal lpUsedDefaultChar As Long) As Long
Private Declare Function MultiByteToWideChar Lib "kernel32" (ByVal CodePage As Long, ByVal dwFlags As Long, ByVal lpMultiByteStr As Long, ByVal cchMultiByte As Long, ByVal lpWideCharStr As Long, ByVal cchWideChar As Long) As Long

Private Const CP_UTF8 = 65001

'正则替换
Public Function RegReplace(ByVal Source As String, ByVal Find As String, ByVal ReplaceText As String, Optional IgnoreCase As Boolean = True) As String
    Dim reg As RegExp
    
    Set reg = New RegExp
    reg.Pattern = Find
    reg.Global = True
    reg.IgnoreCase = IgnoreCase
    
    If reg.Test(Source) Then
        RegReplace = reg.Replace(Source, ReplaceText)
    End If
End Function

'支持将最长五位数的汉字数值转换为数字形式
Public Function CNSerial2Albert(ByVal CN As String) As String
    Dim n As Long
    Dim s As String
    Dim l As String
    Dim R As String
    Dim v As Long
    Dim tIndex As Long
    Dim hIndex As Long
    Dim mIndex As Long
    
    n = Len(CN)
    
    If n = 0 Then Exit Function
    If n > 5 Then Exit Function
    
    CNSerial2Albert = CN
    
    s = "一二三四五六七八九"
    
    '一位数的情况
    If n = 1 Then
        If CN = "零" Or CN = "〇" Then
            CNSerial2Albert = "0"
        ElseIf CN = "十" Then
            CNSerial2Albert = 10
        Else
            v = InStr(s, CN)
            If v < 1 Then Exit Function
            CNSerial2Albert = v
        End If
        
        Exit Function
    End If

    l = Left$(CN, 1)
    hIndex = InStr(s, l)
    
    If n = 2 Then
        If l = "十" Then
            R = Right$(CN, 1)
            tIndex = InStr(s, R)
            
            '首位是10，末位必须是1-9
            If tIndex > 0 And tIndex < 10 Then
                CNSerial2Albert = 10 + tIndex
            End If
        Else
            
            If hIndex < 1 Then Exit Function
            R = Right(CN, 1)
            '首位是1-9，末位必须是十或者百
            If R = "十" Then
                CNSerial2Albert = hIndex * 10
            ElseIf R = "百" Then
                CNSerial2Albert = hIndex * 100
            End If
        End If
        
        Exit Function
    End If
    
    If n = 3 Then
        '首位必须是2-9
        If hIndex < 2 Or hIndex > 9 Then Exit Function
        
        R = Mid$(CN, 2, 1)
        
        '中间必须是十
        If R <> "十" Then Exit Function
        
        '末位必须是1-9
        R = Right$(CN, 1)
        tIndex = InStr(s, R)
        If tIndex > 0 Then
            CNSerial2Albert = hIndex * 10 + tIndex
        End If
        
        Exit Function
    End If
        
    '超过三位数，首位必须是1-9
    If hIndex < 1 Or hIndex > 9 Then Exit Function
    
    R = Mid$(CN, 2, 1)
    
    '第二位必须是百
    If R <> "百" Then Exit Function
    
    '第四位必须是十
    l = Mid$(CN, 4, 1)
    If l <> "十" Then Exit Function
    
    If n = 4 Then
        R = Mid$(CN, 3, 1)
        If R = "零" Or R = "〇" Then
            '第三位是零
            mIndex = 0
            '第四位必须是1-9
            R = Right$(CN, 1)
            tIndex = InStr(s, R)
            If tIndex > 0 Then
                CNSerial2Albert = hIndex * 100 + tIndex
            End If
        Else
            '否则第三位必须是0-9
            mIndex = InStr(s, R)
            If mIndex > 0 Then
                R = Right$(CN, 1)
                tIndex = InStr(s, R)
                CNSerial2Albert = hIndex * 100 + mIndex * 10 + tIndex
            End If
        End If
                        
        Exit Function
    End If
    
    '三百四十五,一百六十八,三百零二十
    If n = 5 Then
        l = Mid$(CN, 3, 1)
        mIndex = InStr(s, l)
        '第三位必须是1-9
        If mIndex < 1 Then Exit Function
        
        '第五位必须是1-9
        R = Right$(CN, 1)
        tIndex = InStr(s, R)
        If tIndex > 0 Then
            CNSerial2Albert = hIndex * 100 + mIndex * 10 + tIndex
        End If
    End If
End Function


'--------------------------------------------------
' Description : 进制转换为 UTF8/GB2312 源码
'--------------------------------------------------
Public Function ByteTosHTML(ByRef BinBuff() As Byte) As String
    Dim objStream As Object

    Set objStream = CreateObject("adodb.stream")

    With objStream
        .Type = 1
        .Mode = 3
        .Open
        .Write BinBuff
        .Position = 0
        .Type = 2
        .Charset = IIf(IsUTF8(BinBuff) = True, "UTF-8", "GB2312")
        ByteTosHTML = .ReadText
        .Close
    End With

    Set objStream = Nothing
End Function

'--------------------------------------------------
' Procedure   : CharAt
' Description : 返回在str中的第index个字符
' CreateTime  : 2010-11-16-09:43:58
'
' ParamList   : Str (String)    目标String
'               Index (Long)    位置
' Return      : 返回Str中第Index个字符，若无，返回""
'--------------------------------------------------
Public Function CharAt(ByVal str As String, ByVal Index As Long) As String
    On Error GoTo Err

    CharAt = Mid$(str, Index + 1, 1)
Err:
End Function

'--------------------------------------------------
' Procedure   : Contains
' Description : 测试Str中是否包含chars
' CreateTime  : 2010-11-16-09:44:19
'
' ParamList   : Str (String)
'               chars (String)
' Return      : 当且仅当str包含chars时，才返回 true
'--------------------------------------------------
Public Function Contains(ByVal str As String, ByVal Chars As String) As Boolean
    Contains = (InStr(1, str, Chars, vbBinaryCompare) > 0)
End Function

'--------------------------------------------------
' Procedure   : ContainString
' Description : 检测Str中是否包含Check中的任一字符
' CreateTime  : 2010-04-03 21:26:29
'
' ParamList   : Str (String)                    被检测的字符串
'               Check (String)                  要检测的字符
'               [ByRef] FirstContainedString (String)   如果包含，则将第一个包含的字符赋值，否则返回False
' Return      : 包含，返回True，并将包含的字符串赋值到 FirstContainedString
'--------------------------------------------------
Public Function ContainString(str As String, Check As String, Optional ByRef FirstContainedString As String = "") As Boolean
    Dim i As Long
    Dim c As String
    Dim l As Long
    
    l = Len(Check)
    
    If Len(str) = 0 Or l = 0 Then
        Exit Function
    End If
    
    For i = 1 To l
        c = Mid$(Check, i, 1)

        If InStr(1, str, c) > 0 Then
            FirstContainedString = c
            ContainString = True

            Exit Function
        End If
    Next
End Function

'--------------------------------------------------
' Procedure   : DeleteBlankLines
' Description : 删除目标字符串中的空白行
' CreateTime  : 2016-01-12 11:22
'
' ParamList   : Source (String)    目标字符串
'             : District (Boolean) 设为False时，将仅含空格和tab的行也作为空行处理
' Return      : 返回新的字符串
'--------------------------------------------------
Public Function DeleteBlankLines(Source As String, Optional ByVal District As Boolean = True) As String
    Dim s   As String
    Dim p() As String
    Dim R() As String
    Dim i   As Long
    Dim j   As Long
    Dim u   As Long
    
    DeleteBlankLines = Source
    
    If Len(Source) = 0 Then
        Exit Function
    End If
    
    If Len(Trim$(Source)) = 0 Then
        Exit Function
    End If
    
    p = Split(Source, vbCrLf)
    u = UBound(p)
    ReDim R(0 To u) As String
    
    If District Then
        For i = 0 To u
            If Len(p(i)) > 0 Then
                R(j) = p(i)
                j = j + 1
            End If
        Next
    Else
        For i = 0 To u
            If Len(p(i)) > 0 Then
                If Len(Trim$(Replace$(p(i), vbTab, ""))) > 0 Then
                    R(j) = p(i)
                    j = j + 1
                End If
            End If
        Next
    End If
    
    If j > 0 Then
        ReDim Preserve R(0 To j - 1) As String
        DeleteBlankLines = Join(R, vbCrLf)
    End If
End Function

'--------------------------------------------------
' Procedure   : DeleteBlankLines
' Description : 删除目标字符串中的重复行（不含空行）
' CreateTime  : 2016-01-12 11:22
'
' ParamList   : Source (String)    目标字符串
' Return      : 返回新的字符串
'--------------------------------------------------
Public Function DeleteDuplicateLines(Source As String) As String
    Dim p() As String
    Dim t   As String
    Dim i   As Long
    Dim u   As Long
    Dim s   As String
    
    If InStr(Source, vbCrLf) = 0 Then
        DeleteDuplicateLines = Source

        Exit Function
    End If
    
    t = Replace$(Source, vbCrLf, Chr$(0))
    p = Split(t, Chr$(0))
    
    u = UBound(p)

    For i = 0 To u
        If InStr(t, p(i)) > 0 Then
            t = Replace$(t, p(i), "")
            s = s & p(i) & vbCrLf
        End If
    Next

    If Right$(s, 2) = vbCrLf Then
        s = Left$(s, Len(s) - 2)
    End If

    DeleteDuplicateLines = s
End Function

'--------------------------------------------------
' Procedure   : DeleteFrom
' Description : 将Str从第pos个位置开始删除length个字符
' CreateTime  : 2010-11-16-09:46:03
'
' ParamList   : Str (String)    目标字符串
'               Pos (Long)      起始位置
'               Length (Long)   删除的长度
' Return      : 返回新的字符串
'--------------------------------------------------
Public Sub DeleteFrom(ByRef str As String, ByVal Pos As Long, ByVal Length As Long)
    Dim l  As String
    Dim ln As Long
    
    ln = Len(str)

    If Pos > ln Or Pos < 0 Then
        Exit Sub
    End If
    
    l = Left$(str, Pos)

    If (ln - Pos - Length) <= 0 Then
        str = l
    Else
        str = l & Right$(str, ln - Pos - Length)
    End If
End Sub

'--------------------------------------------------
' Procedure   : DeleteFromReverse
' Description : 将str从倒数第pos个位置开始删除length个字符
' CreateTime  : 2010-11-16-09:47:04
'
' ParamList   : [ByRef] str (String)
'               Pos (Long)
'               Length (Long)
'--------------------------------------------------
Public Sub DeleteFromReverse(ByRef str As String, ByVal Pos As Long, ByVal Length As Long)
    Dim l  As String
    Dim R  As String
    Dim ln As Long
    
    ln = Len(str)

    If Pos > ln Or Pos < 0 Then
        Exit Sub
    End If
    
    l = Left$(str, ln - Pos)
    
    If (Pos - Length) <= 0 Then
        str = l
    Else
        R = Right$(str, Pos - Length)
        str = l & R
    End If
End Sub

'--------------------------------------------------
' Procedure   : EndsWith
' Description : 测试str是否以suffix结束
' CreateTime  : 2010-11-16-09:48:06
'
' ParamList   : Str (String)        目标字符串
'               suffix (String)     要测试的后缀
'               ignoreCase (Boolean = True)  是否忽略大小写
' Return      : 以Suffix结束 返回true，否则返回False
'--------------------------------------------------
Public Function EndsWith(ByVal str As String, ByVal Suffix As String, Optional IgnoreCase As Boolean = True) As Boolean
    On Error GoTo Err

    If IgnoreCase Then
        EndsWith = (StrComp(Right$(str, Len(Suffix)), Suffix, vbTextCompare) = 0)
    Else
        EndsWith = (Right$(str, Len(Suffix)) = Suffix)
    End If

Err:
End Function

'--------------------------------------------------
' Procedure   : FillSpace
' Description : 向字符串填充空格
' CreateTime  : 2010-11-16-09:49:05
'
' ParamList   : Str (String)
'               Length (Integer)
'               FillAtLeft (Boolean = False)    是否将空格填充到左边
' Return      : 返回将Str格式化为长度为length个字节、以空格向前或向后填充的字符串
'--------------------------------------------------
Public Function FillSpace(ByVal str As String, ByVal Length As Integer, Optional ByVal FillAtLeft As Boolean = False) As String
    FillSpace = IIf(FillAtLeft, Space$(Length - StrLen(str)) & str, str & Space$(Length - StrLen(str)))
End Function

'--------------------------------------------------
' Procedure   : FormatLong
' Description : 格式化一个长整形
' CreateTime  : 2010-11-16-09:51:24
'
' ParamList   : lng (Long)
'               Length (Integer)
'               FillAtLeft (Boolean = True)
' Return      : 返回将lng格式化为长度为length个字节、以空格向前或向后填充的字符串
'--------------------------------------------------
Public Function FormatLong(ByVal LongValue As Long, ByVal Length As Integer, Optional ByVal FillAtLeft As Boolean = True) As String
    FormatLong = IIf(FillAtLeft, Space$(Length - StrLen(LongValue)) & LongValue, LongValue & Space$(Length - StrLen(LongValue)))
End Function

'--------------------------------------------------
' Procedure   : FormatString
' Description : 返回格式化字符串，源字符串中的{x}将被替换为Formats(x)对应的值
' CreateTime  : 2010-11-16-10:38:11
'
' ParamList   : Str (String)
'               Formats() (Variant)
' Return      :
'--------------------------------------------------
Public Function FormatString(str As String, ParamArray Formats() As Variant) As String
    Dim s As String
    Dim i As Long
    Dim u As Long
    
    If Len(str) = 0 Then
        Exit Function
    End If
    
    s = str
    u = UBound(Formats)

    For i = 0 To u
        s = Replace(s, "{" & i & "}", Formats(i))
    Next
    
    FormatString = s
End Function

'将网页上显示的时间转换为标准格式
Public Function FormatWebTime(ByVal sTime As String, ByVal CurrentTime As Date) As String
    Dim s As String
    Dim v As Long
    Dim w As Date
    Dim t As String
    
    If InStr(1, sTime, "秒前") > 0 Then
        s = Replace$(sTime, "秒前", "")

        FormatWebTime = Format$(CurrentTime, "yyyy-MM-dd HH:mm")

        Exit Function
    ElseIf InStr(1, sTime, "分钟前") > 0 Then
        s = Replace$(sTime, "分钟前", "")
        v = Trim$(s)
        w = DateAdd("n", -v, CurrentTime)
    ElseIf InStr(1, sTime, "小时前") > 0 Then
        s = Replace$(sTime, "小时前", "")
        v = Trim$(s)
        w = DateAdd("h", -v, CurrentTime)
    ElseIf InStr(1, sTime, "今天") > 0 Then
        s = Replace$(sTime, "今天", "")
        t = Trim$(s)

        FormatWebTime = Format$(CurrentTime, "yyyy-MM-dd") & " " & t

        Exit Function
    ElseIf InStr(1, sTime, "昨天") > 0 Then
        s = Replace$(sTime, "昨天", "")
        t = Trim$(s)
        w = DateAdd("d", -1, CurrentTime)

        FormatWebTime = Format$(w, "yyyy-MM-dd") & " " & t

        Exit Function
    ElseIf InStr(1, sTime, "前天") > 0 Then
        s = Replace$(sTime, "前天", "")
        t = Trim$(s)
        w = DateAdd("d", -2, CurrentTime)

        FormatWebTime = Format$(w, "yyyy-MM-dd") & " " & t

        Exit Function
    Else
        FormatWebTime = sTime

        Exit Function
    End If
    
    FormatWebTime = Format$(w, "yyyy-MM-dd HH:mm")
End Function

'--------------------------------------------------
' Procedure   : GetAgeByBirthday
' Description : 通过生日得到年龄。参数若非日期则返回0，否则返回参数日期表示的年龄
' CreateTime  : 2010-11-16-09:52:13
'
' ParamList   : Birthday (String)
' Return      : 参数不是日期，返回0，否则返回参数日期表示的年龄
'--------------------------------------------------
Public Function GetAgeByBirthday(Birthday As String) As Long
    If IsDate(Birthday) Then
        If CDate(Birthday) > Now Then
            Exit Function '--出生日期大于现在 出错
        End If
        
        GetAgeByBirthday = DateDiff("yyyy", Birthday, Now) + 1
    End If
End Function

'--------------------------------------------------
' Procedure   : GetBirthdayByIdCard
' Description : 从身份证号码中读取生日
' CreateTime  : 2010-11-16-09:53:01
'
' ParamList   : IdCardNumber (String)
' Return      :
'--------------------------------------------------
Public Function GetBirthdayByIdCard(IdCardNumber As String) As String
    GetBirthdayByIdCard = Mid$(IdCardNumber, 7, 4) & "-" & Mid$(IdCardNumber, 11, 2) & "-" & Mid$(IdCardNumber, 13, 2)
End Function

'--------------------------------------------------
' Procedure   : GetCNSpell
' Description : 获取汉字拼音首字母
' CreateTime  : 2010-11-16-09:53:11
'
' ParamList   : Str (String)
' Return      :
'--------------------------------------------------
Public Function GetCNSpell(ByVal str As String) As String
    If Len(str) = 0 Then
        GetCNSpell = ""
        Exit Function
    End If
    
    If Asc(str) < 0 Then
        If Asc(Left$(str, 1)) < Asc("啊") Then
            GetCNSpell = "0"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("啊") And Asc(Left$(str, 1)) < Asc("芭") Then
            GetCNSpell = "A"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("芭") And Asc(Left$(str, 1)) < Asc("擦") Then
            GetCNSpell = "B"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("擦") And Asc(Left$(str, 1)) < Asc("搭") Then
            GetCNSpell = "C"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("搭") And Asc(Left$(str, 1)) < Asc("蛾") Then
            GetCNSpell = "D"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("蛾") And Asc(Left$(str, 1)) < Asc("发") Then
            GetCNSpell = "E"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("发") And Asc(Left$(str, 1)) < Asc("噶") Then
            GetCNSpell = "F"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("噶") And Asc(Left$(str, 1)) < Asc("哈") Then
            GetCNSpell = "G"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("哈") And Asc(Left$(str, 1)) < Asc("击") Then
            GetCNSpell = "H"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("击") And Asc(Left$(str, 1)) < Asc("喀") Then
            GetCNSpell = "J"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("喀") And Asc(Left$(str, 1)) < Asc("垃") Then
            GetCNSpell = "K"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("垃") And Asc(Left$(str, 1)) < Asc("妈") Then
            GetCNSpell = "L"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("妈") And Asc(Left$(str, 1)) < Asc("拿") Then
            GetCNSpell = "M"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("拿") And Asc(Left$(str, 1)) < Asc("哦") Then
            GetCNSpell = "N"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("哦") And Asc(Left$(str, 1)) < Asc("啪") Then
            GetCNSpell = "O"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("啪") And Asc(Left$(str, 1)) < Asc("期") Then
            GetCNSpell = "P"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("期") And Asc(Left$(str, 1)) < Asc("然") Then
            GetCNSpell = "Q"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("然") And Asc(Left$(str, 1)) < Asc("撒") Then
            GetCNSpell = "R"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("撒") And Asc(Left$(str, 1)) < Asc("塌") Then
            GetCNSpell = "S"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("塌") And Asc(Left$(str, 1)) < Asc("挖") Then
            GetCNSpell = "T"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("挖") And Asc(Left$(str, 1)) < Asc("昔") Then
            GetCNSpell = "W"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("昔") And Asc(Left$(str, 1)) < Asc("压") Then
            GetCNSpell = "X"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("压") And Asc(Left$(str, 1)) < Asc("匝") Then
            GetCNSpell = "Y"
            Exit Function
        End If
        If Asc(Left$(str, 1)) >= Asc("匝") Then
            GetCNSpell = "Z"
            Exit Function
        End If
    ElseIf UCase$(str) <= "Z" And UCase$(str) >= "A" Then
        GetCNSpell = UCase$(Left$(str, 1))
    Else
        GetCNSpell = str
    End If
End Function

'--------------------------------------------------
' Procedure   : GetCNSpells
' Description : 获取字符串的所有字符串拼音
' CreateTime  : 2010-11-16-09:53:22
'
' ParamList   : mystr (String)
' Return      :
'--------------------------------------------------
Public Function GetCNSpells(ByVal str As String) As String
    Dim i As Integer
    Dim a As Integer
    Dim l As Long
    Dim R As String
    
    l = Len(str)

    If l = 0 Then
        GetCNSpells = ""
        Exit Function
    End If
    
    R = Space$(l)
    
    For i = 1 To l
        a = Asc(Mid$(str, i, 1))

        If a < 0 Then
            If a < Asc("啊") Then
                Mid$(R, i, 1) = "0"
            ElseIf a >= Asc("啊") And a < Asc("芭") Then
                Mid$(R, i, 1) = "A"
            ElseIf a >= Asc("芭") And a < Asc("擦") Then
                Mid$(R, i, 1) = "B"
            ElseIf a >= Asc("擦") And a < Asc("搭") Then
                Mid$(R, i, 1) = "C"
            ElseIf a >= Asc("搭") And a < Asc("蛾") Then
                Mid$(R, i, 1) = "D"
            ElseIf a >= Asc("蛾") And a < Asc("发") Then
                Mid$(R, i, 1) = "E"
            ElseIf a >= Asc("发") And a < Asc("噶") Then
                Mid$(R, i, 1) = "F"
            ElseIf a >= Asc("噶") And a < Asc("哈") Then
                Mid$(R, i, 1) = "G"
            ElseIf a >= Asc("哈") And a < Asc("击") Then
                Mid$(R, i, 1) = "H"
            ElseIf a >= Asc("击") And a < Asc("喀") Then
                Mid$(R, i, 1) = "J"
            ElseIf a >= Asc("喀") And a < Asc("垃") Then
                Mid$(R, i, 1) = "K"
            ElseIf a >= Asc("垃") And a < Asc("妈") Then
                Mid$(R, i, 1) = "L"
            ElseIf a >= Asc("妈") And a < Asc("拿") Then
                Mid$(R, i, 1) = "M"
            ElseIf a >= Asc("拿") And a < Asc("哦") Then
                Mid$(R, i, 1) = "N"
            ElseIf a >= Asc("哦") And a < Asc("啪") Then
                Mid$(R, i, 1) = "O"
            ElseIf a >= Asc("啪") And a < Asc("期") Then
                Mid$(R, i, 1) = "P"
            ElseIf a >= Asc("期") And a < Asc("然") Then
                Mid$(R, i, 1) = "Q"
            ElseIf a >= Asc("然") And a < Asc("撒") Then
                Mid$(R, i, 1) = "R"
            ElseIf a >= Asc("撒") And a < Asc("塌") Then
                Mid$(R, i, 1) = "S"
            ElseIf a >= Asc("塌") And a < Asc("挖") Then
                Mid$(R, i, 1) = "T"
            ElseIf a >= Asc("挖") And a < Asc("昔") Then
                Mid$(R, i, 1) = "W"
            ElseIf a >= Asc("昔") And a < Asc("压") Then
                Mid$(R, i, 1) = "X"
            ElseIf a >= Asc("压") And a < Asc("匝") Then
                Mid$(R, i, 1) = "Y"
            ElseIf a >= Asc("匝") And a <= Asc("座") Then
                Mid$(R, i, 1) = "Z"
            Else
                On Error Resume Next
                Mid$(R, i, 1) = Mid$(GetCNSpellSecondEng, InStr(1, GetCNSpellSecondChn, Mid$(str, i, 1), vbBinaryCompare), 1)
            End If
        ElseIf UCase$(str) <= "Z" And UCase$(str) >= "A" Then
            Mid$(R, i, 1) = UCase$(Left$(str, 1))
        Else
            Mid$(R, i, 1) = Mid$(str, i, 1)
        End If
    Next
    
    GetCNSpells = R
End Function

'--------------------------------------------------
' Procedure   : GetGenderByIdCard
' Description : 从身份证号码判断性别
' CreateTime  : 2010-11-16-09:57:11
'
' ParamList   : IdCardNumber (String)
' Return      : 返回1表示男 返回2表示女 返回0表示解析错误
'--------------------------------------------------
Public Function GetGenderByIdCard(IdCardNumber As String) As Long
    On Error GoTo ErrHandle

    If Mid$(IdCardNumber, 17, 1) Mod 2 = 1 Then
        GetGenderByIdCard = 1   '--奇数为男
    Else
        GetGenderByIdCard = 2   '--偶数为女
    End If

ErrHandle:  '--错误为0
End Function

'获取Text中长度大于等于Length的连续数字，数字序列中包含的IgnoreChars中的任意字符将被忽略
'全角将自动转换成半角
'若获取到多个数字序列，则用|分隔后返回
Public Function GetNumberSerial(ByVal Text As String, Optional ByVal Length As Long = 5, Optional ByVal IgnoreChars As String = " -/\_:;,.", Optional ByVal JoinBy As String = "|") As String
    Dim p()    As String
    Dim i      As Long
    Dim lStart As Long
    Dim lLen   As Long
    Dim str1   As String
    Dim n      As Long
    Dim t      As Long
    
    p = Split("")
    Text = StrConv(Text, vbNarrow)
    
    n = Len(IgnoreChars)

    For i = 1 To n
        Text = Replace$(Text, Mid$(IgnoreChars, i, 1), "")
    Next
    
    t = Len(Text)

    For i = 1 To t
        str1 = Mid$(Text, i, 1)

        If InStr("0123456789", str1) > 0 Then
            If lStart = 0 Then
                lStart = i
                lLen = 1
            Else
                lLen = lLen + 1
            End If
        Else
            If lLen >= Length Then
                ReDim Preserve p(UBound(p) + 1)
                p(UBound(p)) = Mid$(Text, lStart, lLen)
            End If

            lStart = 0
            lLen = 0
        End If
    Next

    If lLen >= Length Then
        ReDim Preserve p(UBound(p) + 1)
        p(UBound(p)) = Mid$(Text, lStart, lLen)
    End If

    GetNumberSerial = Join(p, JoinBy)
End Function

'获取字符串中子字符串
Public Function GetSubString(ByVal SourceString As String, _
                             Optional ByVal ParentStart As String = "", _
                             Optional ByVal ParentCenter As String = "", _
                             Optional ByVal ParentEnd As String = "", _
                             Optional ByVal SubStart As String = "", _
                             Optional ByVal SubCenter As String = "", _
                             Optional ByVal SubEnd As String = "", _
                             Optional ByVal ArrayIndex As Long = 0) As String
    Dim sText     As String
    Dim str1      As String
    Dim OKCount   As Long
    Dim lBegin    As Long
    Dim CurBegin  As Long
    Dim pResult() As String
    Dim k         As Long

    If Len(SourceString) = 0 Then Exit Function
    If ArrayIndex < -1 Then ArrayIndex = -1

    sText = LCase$(SourceString)

    ParentStart = LCase$(ParentStart)
    ParentCenter = LCase$(ParentCenter)
    ParentEnd = LCase$(ParentEnd)
    
    SubStart = LCase$(SubStart)
    SubCenter = LCase$(SubCenter)
    SubEnd = LCase$(SubEnd)

    pResult = Split("")

    If Len(ParentStart) = 0 Then
        ParentStart = SubStart
        SubStart = ""
    End If

    Do
        lBegin = InStr(lBegin + 1, sText, ParentStart)

        If lBegin = 0 Then Exit Do

        lBegin = lBegin + Len(ParentStart)
        CurBegin = lBegin

        str1 = Right$(sText, Len(sText) - lBegin + 1)

        If Len(ParentEnd) > 0 Then '判断尾部字符
            k = InStr(str1, ParentEnd)

            If k = 0 Then Exit Do

            str1 = Left$(str1, k - 1)
            lBegin = lBegin + k + Len(ParentEnd) - 2
        End If
        
        If Len(ParentCenter) > 0 Then '判断中间是否存在关键词
            k = InStr(str1, ParentCenter)

            If k = 0 Then GoTo ToNext
        End If

        If Len(SubStart) > 0 Then '判断开始字符
            k = InStr(str1, SubStart)

            If k = 0 Then GoTo ToNext

            CurBegin = CurBegin + k + Len(SubStart) - 1
            str1 = Right$(str1, Len(str1) - k - Len(SubStart) + 1)
        End If

        If Len(SubEnd) > 0 Then '判断结束字符
            k = InStr(str1, SubEnd)

            If k = 0 Then GoTo ToNext

            str1 = Left$(str1, k - 1)
        End If

        If Len(SubCenter) > 0 Then '判断中间是否存在关键词
            k = InStr(str1, SubCenter)

            If k = 0 Then GoTo ToNext
        End If

        If OKCount = ArrayIndex Or ArrayIndex = -1 Then
            If Len(str1) > 0 Then
                str1 = Mid$(SourceString, CurBegin, Len(str1))

                If ArrayIndex = -1 Then
                    ReDim Preserve pResult(UBound(pResult) + 1)
                    pResult(UBound(pResult)) = str1

                Else
                    ReDim pResult(0)
                    pResult(0) = str1

                    Exit Do

                End If
            End If
        End If

        OKCount = OKCount + 1

ToNext:
        DoEvents
    Loop

    str1 = Join(pResult, vbCrLf)
    GetSubString = str1
End Function

'HTML解密
Public Function HTMLDecode(ByVal sText As String)
    Dim i As Long
    
    sText = Replace$(sText, "&quot;", Chr$(34))
    sText = Replace$(sText, "&lt;", Chr$(60))
    sText = Replace$(sText, "&gt;", Chr$(62))
    sText = Replace$(sText, "&amp;", Chr$(38))
    sText = Replace$(sText, "&nbsp;", Chr$(32))
    
    For i = 1 To 255
        sText = Replace$(sText, "&#" & i & ";", Chr$(i))
    Next

    HTMLDecode = sText
End Function

'--------------------------------------------------
' Procedure   : IndexOf
' Description : 返回char在str中第一次出现处的索引
' CreateTime  : 2010-11-16-09:57:45
'
' ParamList   : Str (String)
'               char (String)
' Return      :
'--------------------------------------------------
Public Function IndexOf(ByVal str As String, ByVal Chars As String) As Long
    IndexOf = InStr(1, str, Chars, vbBinaryCompare) - 1
End Function

'--------------------------------------------------
' Procedure   : InsertTo
' Description : 插入一个字符串到目标字符串中
' CreateTime  : 2010-11-16-09:58:00
'
' ParamList   : [ByRef] Str (String)
'               Pos (Long)
'               Insert (String)
' Return      : 在str中pos位置插入insert
'--------------------------------------------------
Public Sub InsertTo(ByRef str As String, ByVal Pos As Long, ByVal Insert As String)
    Dim sl As String
    Dim sr As String
    
    sl = Left$(str, Pos)
    sr = Right$(str, Len(str) - Pos)
    
    str = sl & Insert & sr
End Sub

'--------------------------------------------------
' Procedure   : InsertToReverse
' Description : 插入一个字符串到目标字符串中
' CreateTime  : 2010-11-16-09:58:30
'
' ParamList   : Str (String)
'               Pos (Long)
'               Insert (String)
' Return      : 在str中倒数pos位置插入insert
'--------------------------------------------------
Public Sub InsertToReverse(ByRef str As String, ByVal Pos As Long, ByVal Insert As String)
    Dim sl As String
    Dim sr As String

    sl = Left$(str, Len(str) - Pos)
    sr = Right$(str, Pos)
    
    str = sl & Insert & sr
End Sub

'--------------------------------------------------
' Procedure   : IsChineseChar
' Description : 测试AscII代表的字符是否为汉字
' CreateTime  : 2010-11-16-09:58:48
'
' ParamList   : AscII (Integer)
' Return      :
'--------------------------------------------------
Public Function IsChineseChar(ByVal AscII As Integer) As Boolean
    If Len(Hex$(AscII)) > 2 Then
        IsChineseChar = True
    Else
        IsChineseChar = False
    End If
End Function

'--------------------------------------------------
' Procedure   : IsIdentifier
' Description : 测试字符串是否是合法的标示符
' CreateTime  : 2010-11-16-09:59:31
'
' ParamList   : Str (String)
' Return      :
'--------------------------------------------------
Public Function IsIdentifier(str As String) As Boolean
    Dim i As Long
    Dim s As Boolean
    Dim l As Long
    
    If str = "" Then Exit Function
    
    str = LCase$(str)
    l = Len(str)

    For i = 1 To l
        If Not s Then
            If InStr(i, "abcdefghijklmnopqrstuvwxyz_", Mid$(str, i, 1), VbCompareMethod.vbBinaryCompare) > 0 Then
                s = True
            Else
                '"开头不合法"
                Exit Function
            End If
        End If
        
        If s Then
            If InStr(1, "abcdefghijklmnopqrstuvwxyz0123456789_", Mid$(str, i, 1), vbBinaryCompare) = 0 Then
                '"中间不合法"
                Exit Function
            End If
        End If
    Next

    IsIdentifier = True
End Function


'--------------------------------------------------
' Procedure   : IsLetter
' Description : 测试字符是否为A~Z
' CreateTime  : 2010-11-16-10:00:41
'
' ParamList   : Str (String)
' Return      :
'--------------------------------------------------
Public Function IsLetter(str As String) As Boolean
    Dim c As Integer

    c = Asc(LCase$(str))

    If c >= Asc("a") And c <= Asc("z") Then IsLetter = True
End Function

'判断二进制网页编码是否utf8
Public Function IsUTF8(ByRef Bytes() As Byte) As Boolean
    Dim i As Long
    Dim AscN As Long
    Dim Length As Long

    Length = UBound(Bytes) + 1

    If Length < 3 Then
        IsUTF8 = False
        Exit Function
    ElseIf Bytes(0) = &HEF And Bytes(1) = &HBB And Bytes(2) = &HBF Then
        IsUTF8 = True
        Exit Function
    End If

    Do While i <= Length - 1
        If Bytes(i) < 128 Then
            i = i + 1
            AscN = AscN + 1
        ElseIf (Bytes(i) And &HE0) = &HC0 And (Bytes(i + 1) And &HC0) = &H80 Then
            i = i + 2
        ElseIf i + 2 < Length Then
            If (Bytes(i) And &HF0) = &HE0 And (Bytes(i + 1) And &HC0) = &H80 And (Bytes(i + 2) And &HC0) = &H80 Then
                i = i + 3
            Else
                IsUTF8 = False
                Exit Function
            End If
        Else
            IsUTF8 = False
            Exit Function
        End If
    Loop

    IsUTF8 = IIf(AscN = Length, False, True)
End Function

'--------------------------------------------------
' Procedure   : LastIndexOf
' Description : 返回char在str中最后一次出现处的索引
' CreateTime  : 2010-11-16-10:00:54
'
' ParamList   : Str (String)
'               char (String)
' Return      :
'--------------------------------------------------
Public Function LastIndexOf(ByVal str As String, ByVal Chars As String) As Long
    LastIndexOf = InStrRev(str, Chars, , vbBinaryCompare) - 1
End Function

'快速读取文件文件
Public Function LoadText(ByVal FilePath As String) As String
    Dim str1 As String
    Dim fn   As Long
    Dim k    As Long

    On Error GoTo IsErr

    If Mid$(FilePath, 2, 2) <> ":\" Then FilePath = Replace$(App.Path & "\", "\\", "\") & FilePath
    If Len(Dir$(FilePath, vbHidden Or vbNormal)) = 0 Then Exit Function

    fn = FreeFile
    Open FilePath For Binary As #fn
    str1 = Space$(LOF(fn))
    Get #fn, , str1
    Close #fn
    k = InStr(str1, Chr$(0))

    If k > 0 Then str1 = Left$(str1, k - 1)

    LoadText = str1
IsErr:

    If Err Then Err.Clear
End Function

'获取源字符串中两个字符串中间的子字符串
Public Function MidOf(ByVal Source As String, ByVal Prefix As String, ByVal Suffix As String) As String
    Dim nLft As Long
    Dim nRgt As Long
    Dim nLen As Long
    
    nLen = Len(Prefix)

    If nLen > 0 Then
        nLft = InStr(1, Source, Prefix)

        If nLft > 0 Then
            nLft = nLft + nLen
        End If
    End If
    
    If nLft > 0 Then
        nRgt = InStr(nLft, Source, Suffix)
        
        If nRgt > nLft Then
            MidOf = Mid$(Source, nLft, nRgt - nLft)
        End If
    End If
End Function

'输出文本文件
Public Function OutText(ByVal Path As String, ByVal Text As String, Optional ByVal bAppend As Boolean = False) As Boolean
    Dim k As Long

    On Error GoTo ToExit

    If Mid$(Path, 2, 2) <> ":\" Then Path = Replace$(App.Path & "\", "\\", "\") & Path
    k = FreeFile

    If bAppend = True Then
        Open Path For Append As #k
    Else
        Open Path For Output As #k
    End If

    If bAppend = True Then
        Print #k, Text
    Else
        Print #k, Text;
    End If

    Close #k

    OutText = True

    Exit Function
ToExit:
    On Error GoTo 0
End Function

'--------------------------------------------------
' Procedure   : RemoveQuotedString
' Description : 删除成对出现的符号及其中包含的字符串
' CreateTime  : 2010-11-16-10:01:23
'
' ParamList   : sString (String)                输入的字符串
'               QuotationMark (String = "'")    要检测的符号
' Return      : 操作后得到的字符串
'--------------------------------------------------
Public Function RemoveQuotedString(sString As String, Optional QuotationMark As String = "'") As String
    Dim i       As Long
    Dim j       As Long
    Dim buf     As String
    Dim c       As String
    Dim Length  As Long
    Dim inQuote As Boolean
    
    Length = Len(sString)

    If Length = 0 Or Len(QuotationMark) = 0 Then
        RemoveQuotedString = sString
        Exit Function
    End If
    
    If InStr(1, sString, QuotationMark) = 0 Then
        RemoveQuotedString = sString
        Exit Function
    End If
    
    buf = String$(Length, vbNullChar)
    
    For i = 1 To Length
        c = Mid$(sString, i, 1)
        
        If inQuote Then
            If c = QuotationMark Then
                inQuote = False
            End If
        Else
            If c = QuotationMark Then
                inQuote = True
            Else
                j = j + 1
                Mid$(buf, j, 1) = c
            End If
        End If
    Next
    
    RemoveQuotedString = Left$(buf, InStr(buf, vbNullChar))
End Function

'*************************************************************************
'功能描述：替换两个关键字之间的字符
'函 数 名：ReplaceMidKey
'sText(String) - 要清除的字符串
'Optional ByVal BeginKey(String) - [开始字符]
'Optional ByVal MidKey(String) - [中间包含字符]
'Optional ByVal EndKey(String) - [结束字符]
'Optional ByVal KeepKey(Boolean = False) - [是否保留 开始/结束 字符]
'输 出：(String) - 去除后的字符串
'例 子： ReplaceMidKey("<a>1</a><a>2</a><a>3</a>","<a>","1","</a>") 返回 "<a>2</a><a>3</a>"
'作 者：格式化 QQ:65464145
'日 期：2010-04-23 15:39:56
'*************************************************************************
Public Function ReplaceMidKey(ByVal Text As String, Optional ByVal BeginKey As String = "", Optional ByVal MidKey As String = "", Optional ByVal EndKey As String = "", Optional ByVal KeepKey As Boolean = False) As String
    Dim pResult()    As String
    Dim k            As Long
    Dim k1           As Long
    Dim k2           As Long
    Dim lText        As String
    Dim str1         As String
    Dim bInstrMidKey As Boolean
    Dim lBeginKey    As Long
    Dim lEndKey      As Long
    Dim lCount       As Long
    Dim lMax         As Long
    
    '========= 小写处理
    lText = LCase$(Text)
    BeginKey = LCase$(BeginKey)
    MidKey = LCase$(MidKey)

    EndKey = LCase$(EndKey)
    
    '========= 初始化
    If Len(MidKey) > 0 Then
        bInstrMidKey = True
    End If
    
    lBeginKey = Len(BeginKey)
    lEndKey = Len(EndKey)
    
    lMax = 1000
    ReDim pResult(lMax)
    lCount = -1
    
    If Len(BeginKey) > 0 Or Len(EndKey) > 0 Then
        k = 1
        
        Do
            '===== 开始位置
            k1 = InStr(k, lText, BeginKey)

            If k1 = 0 Then Exit Do
            
            '===== 结束位置
            k2 = InStr(k1 + lBeginKey, lText, EndKey)

            If k2 = 0 Then Exit Do
            
            k2 = k2 + lEndKey ' 加上结束字符长度
            
            '===== 是否查找包含字符
            If bInstrMidKey = True Then
                str1 = Mid$(lText, k1 + lBeginKey, k2 - k1 - lBeginKey - lEndKey)
                
                If InStr(str1, MidKey) = 0 Then
                    k1 = k2
                End If
            End If
            
            '===== 结果
            str1 = Mid$(Text, k, k1 - k)

            If KeepKey = True And k1 <> k2 Then
                str1 = str1 & BeginKey & EndKey
            End If
            
            lCount = lCount + 1

            If lCount >= lMax Then
                lMax = lMax + 1000
                ReDim Preserve pResult(lMax)
            End If
            
            pResult(lCount) = str1
            
            k = k2

            DoEvents
        Loop
    
        '===== 扫尾
        lCount = lCount + 1
        pResult(lCount) = pResult(lCount) & Mid$(Text, k, Len(Text) - k + 1)
    End If
    
    If lCount >= 0 Then
        ReDim Preserve pResult(lCount)
        ReplaceMidKey = Join(pResult, "")
    End If
End Function

'替换HTML字符实体
Public Function ReplaceHTMLEntity(ByVal Text As String) As String
    Dim i As Long
    Dim p() As String
    Dim en As Long
    Dim c As String
    Dim f As Long
    Dim m As Long
    Dim s As String
    Dim d As Long
    Dim w As String
    
    f = InStr(1, Text, "&#x")
    
    If f > 0 Then
        m = Len(Text)
        For i = 1 To m
            en = InStr(i, Text, "&#x")
            If en = 0 Then Exit For
            If i <> en Then
                s = s & Mid$(Text, i, en - i)
            End If
            d = InStr(en, Text, ";")
            c = Mid$(Text, en + 3, d - en - 3)
            w = ChrW("&H" & c)
            s = s & w
            
            i = d
            
            If m - i < 3 Then
                s = s & Right$(Text, m - d)
                Exit For
            End If
            
        Next
        ReplaceHTMLEntity = s
        Exit Function
    Else
        f = InStr(1, Text, "&#")
        If f > 0 Then
            m = Len(Text)
            For i = 1 To m
                en = InStr(i, Text, "&#")
                If en = 0 Then Exit For
                If i <> en Then
                    s = s & Mid$(Text, i, en - i)
                End If
                
                d = InStr(en, Text, ";")
                c = Mid$(Text, en + 2, d - en - 2)
                w = ChrW(c)
                s = s & w
                i = d
                If m - i < 2 Then
                    s = s & Right$(Text, m - d)
                    Exit For
                End If
            Next
            
            ReplaceHTMLEntity = s
            Exit Function
        End If
    End If
    
    ReplaceHTMLEntity = Text
End Function

'字符串数组去重
Public Function DistinctStringArray(StringArray As Variant) As String()
    Dim i    As Long
    Dim j    As Long
    Dim c    As Long
    Dim u    As Long
    Dim k    As Long
    Dim n    As Long
    Dim arr2 As Variant
    
    If IsArray(StringArray) = False Then Exit Function
    
    c = LBound(StringArray)
    u = UBound(StringArray)
    ReDim arr2(c To u) As String
    k = c
    
    For i = 0 To u
        n = i - 1

        For j = 0 To n
            If StringArray(i) = StringArray(j) Then Exit For
        Next

        If j = i Then
            arr2(k) = StringArray(i)
            k = k + 1
        End If
    Next
    
    ReDim Preserve arr2(c To k - 1) As String
    DistinctStringArray = arr2
End Function

'将毫秒数格式化为秒数,精确到小数点后Point位
Public Function FormatTime(ByVal MsCount As Long, Optional ByVal POINT As Long = 2) As String
    Dim c As Double
    Dim m As Long
    
    c = MsCount / 1000
    c = Math.Round(c, POINT)
    
    If c < 60 Then
        FormatTime = c
    Else
        m = c \ 60
        c = c - (m * 60)
        c = Math.Round(c, 2)

        FormatTime = m & "分" & c
    End If
End Function

'--------------------------------------------------
' Procedure   : SaveAs
' Description : 将字符串另存为文件
' CreateTime  : 2010-11-16-10:02:03
'
' ParamList   : SourceString (String)
'               Path (String)
' Return      :
'--------------------------------------------------
Public Function SaveAs(SourceString As String, Path As String, Optional Append As Boolean = False) As Boolean
    Dim k As Long

    On Error GoTo ToExit

    If Mid$(Path, 2, 2) <> ":\" Then Path = Replace$(App.Path & "\", "\\", "\") & Path
    k = FreeFile

    If Append Then
        Open Path For Append As #k
    Else
        Open Path For Output As #k
    End If

    If Append Then
        Print #k, SourceString
    Else
        Print #k, SourceString;
    End If

    Close #k

    SaveAs = True

    Exit Function
ToExit:
    On Error GoTo 0
End Function

'--------------------------------------------------
' Procedure   : SplitEx
' Description : 快速分割字符串
' CreateTime  : 2016-01-21 11:24
'
' ParamList   : Source (String)
'               Delimiter (String)
' Return      :
'--------------------------------------------------
Public Function SplitEx(ByVal Source As String, Optional ByVal Delimiter As String = vbCrLf) As String()
    Dim k             As Long
    Dim k1            As Long
    Dim Count         As Long
    Dim str1          As String
    Dim bExit         As Boolean
    Dim pResult()     As String
    Dim lLenDelimiter As Long

    If Len(Delimiter) > 1 Then
        lLenDelimiter = Len(Delimiter) - 1
    End If

    pResult = Split("")

    Do
        k = k + 1
        k1 = InStr(k, Source, Delimiter)

        If k1 = 0 Then
            k1 = Len(Source) - k + 1

            If k1 <= 0 Then
                str1 = ""
            Else
                str1 = Mid$(Source, k, Len(Source) - k + 1)
            End If

            bExit = True
        Else
            str1 = Mid$(Source, k, k1 - k)
        End If

        If Len(str1) > 0 Then
            ReDim Preserve pResult(Count)
            pResult(Count) = str1

            Count = Count + 1
        End If

        If bExit = True Then Exit Do
        k = k1 + lLenDelimiter

        DoEvents
    Loop

    SplitEx = pResult
End Function

'--------------------------------------------------
' Procedure   : StartsWith
' Description : 测试str是否以prefix开始
' CreateTime  : 2010-11-16-10:02:09
'
' ParamList   : Str (String)
'               prefix (String)
'               ignoreCase (Boolean = True)
' Return      :
'--------------------------------------------------
Public Function StartsWith(ByVal str As String, ByVal Prefix As String, Optional IgnoreCase As Boolean = True) As Boolean
    On Error GoTo Err

    If IgnoreCase Then
        StartsWith = (StrComp(Left$(str, Len(Prefix)), Prefix, vbTextCompare) = 0)
    Else
        StartsWith = (Left$(str, Len(Prefix)) = Prefix)
    End If
Err:
End Function

'--------------------------------------------------
' Procedure   : StrLeft
' Description : 返回字符串左边的Length个字节
' CreateTime  : 2010-11-16-10:02:21
'
' ParamList   : str5 (String)
'               len5 (Long)
' Return      :
'--------------------------------------------------
Public Function StrLeft(ByVal str As String, ByVal Length As Long) As String
    Dim tmpstr As String

    tmpstr = StrConv(str, vbFromUnicode)
    tmpstr = LeftB$(tmpstr, Length)
    StrLeft = StrConv(tmpstr, vbUnicode)
End Function

'--------------------------------------------------
' Procedure   : Strlen
' Description : 返回Str的字节数
' CreateTime  : 2010-11-16-10:02:39
'
' ParamList   : tstr (String)
' Return      :
'--------------------------------------------------
Public Function StrLen(ByVal str As String) As Integer
    StrLen = LenB(StrConv(str, vbFromUnicode))
End Function

'--------------------------------------------------
' Procedure   : StrRight
' Description : 返回字符串右边的length个字节
' CreateTime  : 2010-11-16-10:03:07
'
' ParamList   : str5 (String)
'               len5 (Long)
' Return      :
'--------------------------------------------------
Public Function StrRight(ByVal str As String, ByVal Length As Long) As String
    Dim tmpstr As String

    tmpstr = StrConv(str, vbFromUnicode)
    tmpstr = RightB$(tmpstr, Length)
    StrRight = StrConv(tmpstr, vbUnicode)
End Function

'--------------------------------------------------------------------------------
' Procedure  :       SubStr
' Description:       返回字符串中从Start之后的length个字符
' Created by :       fangzi
' Date-Time  :       2010-11-16-10:03:29
'
' Parameters :       Str (String)
'                    Start (Long)
'                    Length (Long = 0)
'--------------------------------------------------------------------------------
Public Function SubStr(ByVal str As String, ByVal Start As Long, Optional Length As Long = 0) As String
    Dim tmpstr As String

    If Length = 0 Then
        tmpstr = StrConv(MidB$(StrConv(str, vbFromUnicode), Start), vbUnicode)
    Else
        tmpstr = StrConv(MidB$(StrConv(str, vbFromUnicode), Start, Length), vbUnicode)
    End If

    SubStr = tmpstr
End Function

'--------------------------------------------------
' Procedure   : ToBinaryString
' Description : 转换字符串为字节数组
' CreateTime  : 2010-11-16-10:04:25
'
' ParamList   : txt (String)
'               ret (String)
' Return      : 将参数转换为二进制形式，存放到ret中的字符串并返回长度
'--------------------------------------------------
Public Function ToBinaryString(ByVal txt As String, ret As String) As Long
    Dim b()    As Byte         '存放参数的字节数组
    Dim Length As Long      '字节数
        
    '将参数转换为字节,存入字节数组数组
    b = StrConv(txt, vbFromUnicode)
    
    '得到字节数
    Length = UBound(b) + 1
    
    '生成由字节数个空格组成的字符串
    ret = Space$(Length)
        
    '字节数组长度+1
    ReDim Preserve b(0 To Length + 1) As Byte
    
    '在末尾补上&H0
    b(Length) = &H0
        
    '将字节数组复制到ret
    CopyMemory ret, b(0), Length + 1
    
    '输出ret
    ToBinaryString = Length + 1
End Function

'--------------------------------------------------
' Procedure   : ToSQL
' Description : 将字符串转换为SQL语句格式
' CreateTime  : 2010-11-16-10:04:45
'
' ParamList   : Str (String)
' Return      : 格式化后的字符串
'--------------------------------------------------
Public Function ToSQL(str As String) As Variant
    Dim s     As String
    Dim tks   As Variant
    Dim First As String
    Dim i     As Long
    Dim j     As Long
    Dim heads As Variant
    Dim keys  As Variant
    Dim isKey As Boolean
    Dim u     As Long
    Dim uk    As Long
    Dim ret   As String
    
    heads = Array("SELECT", "UPDATE", "INSERT", "DELETE", "ALTER", "DROP", "CREATE", "PROCEDURE")
    keys = Array("SELECT", "UPDATE", "INSERT", "DELETE", "ALTER", "DROP", "CREATE", "PROCEDURE", "AS", "INTO", "FROM", "GROUP", "BY", "ORDER", "ASC", "DESC", "SET", "JOIN", "LEFT", "INNER", "RIGHT", "UNION", "TOP", "DESTINCT", "MAX", "MIN", "AVG", "COUNT", "HAVING", "NOT", "IN", "AND", "OR", "IS", "NULL", "IIF", "CASE", "WHEN", "WHERE")
    s = Trim$(str)
    s = Replace(str, vbTab, " ")
    s = Replace(str, vbCrLf, " " & vbCrLf)
    tks = Split(s, " ")
    
    First = UCase$(tks(0))
    
    u = UBound(heads)

    For i = 0 To u
        If First = heads(i) Then
            Exit For
        End If
    Next
    
    If i > UBound(heads) Then
        ToSQL = False
        Debug.Print "不是sql语句"
        Exit Function
    End If
    
    ret = First
    
    u = UBound(tks)
    uk = UBound(keys)

    For i = 1 To u
        isKey = False
        
        If Left$(tks(i), 1) = vbCrLf Then
            
            For j = 0 To uk

                If StrComp(tks(i), vbCrLf & keys(j), vbTextCompare) = 0 Then
                    ret = ret & " " & vbCrLf & keys(j)
                    isKey = True

                    Exit For
                End If
            Next
        Else
            For j = 0 To uk
                If StrComp(tks(i), keys(j), vbTextCompare) = 0 Then
                    ret = ret & " " & keys(j)
                    isKey = True

                    Exit For
                End If
            Next
        End If

        If Not isKey Then
            If ret <> " " Then
                ret = ret & " " & tks(i)
            End If
        End If
    Next
    
    ToSQL = ret
End Function

'--------------------------------------------------
' Procedure   : TrimEx
' Description : 去除前后的不可见字符
' CreateTime  : 2011-04-08-14:33:35
'
' ParamList   : Source (String)
' Return      :
'--------------------------------------------------
Public Function TrimEx(Source As String) As String
    Dim s As String
    Dim c As String
    
    s = Trim$(Source)
      
    c = Right$(s, 1)

    While c = vbCr Or c = vbLf Or c = vbTab Or c = " "
        s = Left$(s, Len(s) - 1)
        c = Right$(s, 1)
    Wend
    
    c = Left$(s, 1)
    
    While c = vbCr Or c = vbLf Or c = vbTab Or c = " "
        s = Right$(s, Len(s) - 1)
        c = Left$(s, 1)
    Wend
    
    TrimEx = s
End Function

'Unicode解码
Public Function UnicodeDecode(ByVal sText As String) As String
    Dim i    As Long
    Dim p()  As String
    Dim k    As Long
    Dim str1 As String
    Dim str2 As String
    
    p = Split(sText, "\u")
    k = UBound(p)

    For i = 1 To k
        str1 = p(i)

        If Len(str1) >= 4 Then
            str2 = Right$(str1, Len(str1) - 4)
            str1 = Left$(str1, 4)
            p(i) = ChrW$("&H" & str1) & str2
        Else
            p(i) = "\u" & p(i)
        End If
    Next

    UnicodeDecode = Join(p, "")
End Function

'Unicode编码
Public Function UnicodeEncode(ByVal sText As String) As String
    Dim i    As Long
    Dim k    As Long
    Dim str1 As String
    Dim u    As Long
    
    If Len(sText) = 0 Then Exit Function
    ReDim p(Len(sText) - 1)
    
    u = Len(sText)

    For i = 1 To u
        str1 = Mid$(sText, i, 1)
        k = Asc(str1)

        If k >= 0 And k <= 254 Then

        Else
            str1 = "\u" & Hex$(AscW(str1))
        End If

        p(i - 1) = str1
    Next

    UnicodeEncode = Join(p, "")
End Function

'Unicode转UFT8
Public Function UnicodeToUTF8(ByVal sText As String) As Byte()
    Dim lLength     As Long
    Dim lBufferSize As Long
    Dim lResult     As Long
    Dim abUTF8()    As Byte

    lLength = Len(sText)
    abUTF8 = ""

    If lLength = 0 Then GoTo ToExit

    lBufferSize = lLength * 3 + 1

    ReDim abUTF8(lBufferSize - 1)
    lResult = WideCharToMultiByte(CP_UTF8, 0, StrPtr(sText), lLength, abUTF8(0), lBufferSize, vbNullString, 0)

    If lResult <> 0 Then
        lResult = lResult - 1
        ReDim Preserve abUTF8(lResult)
    Else
        abUTF8 = ""
    End If

ToExit:
    If Err Then Err.Clear
    UnicodeToUTF8 = abUTF8
End Function

'URL解码
Public Function URLDecode(ByVal sText As String, Optional ByVal bUTF8 As Boolean = True) As String
    Dim i         As Long
    Dim k         As Long
    Dim str1      As String
    Dim str2      As String
    Dim UtfB      As Integer
    Dim UtfB1     As String
    Dim UtfB2     As String
    Dim UtfB3     As String   'Utf-8单个字节 1-3字节
    Dim En1       As String
    Dim En2       As String
    Dim En3       As String
    Dim sResult   As String
    Dim pResult() As String
    Dim bOK       As Boolean
    Dim u         As Long
    
    On Error Resume Next

    k = UBound(Split(sText, "%"))

    If k Mod 2 <> 0 Then bUTF8 = True

    pResult = Split("")
    
    If bUTF8 = False Then
        i = 1

        Do Until i > Len(sText)
            sResult = Mid$(sText, i, 1)
            i = i + 1

            Select Case sResult
            Case "+"
                sResult = " "
            Case "%"
                UtfB1 = Mid$(sText, i, 2)
                k = Val("&H" & UtfB1)

                Select Case k
                Case Is > 128
                    UtfB2 = Mid$(sText, i + 3, 2)
                    k = k * 256 + Val("&H" & UtfB2)
                    i = i + 5
                Case Else
                    i = i + 2
                End Select

                sResult = Chr$(k)
            End Select

            ReDim Preserve pResult(UBound(pResult) + 1)
            pResult(UBound(pResult)) = sResult
        Loop
        '这是解密的
    Else 'UTF8
        u = Len(sText)

        For i = 1 To u
            sResult = Mid$(sText, i, 1)

            Select Case sResult
            Case "+"
                sResult = " "
            Case "%"
                str2 = Mid$(sText, i + 1, 2)
                UtfB = CInt("&H" & str2)

                If UtfB < 128 Then
                    bOK = True

                    Select Case UtfB
                    Case 38 '&
                        '======= 判断 "
                        If bOK = True Then
                            str1 = LCase$(Mid$(sText, i, 10))

                            If str1 = "%26quot%3b" Then
                                i = i + 9
                                bOK = False
                                sResult = """"
                            End If
                        End If

                        '======= 判断 <
                        If bOK = True Then
                            str1 = LCase$(Mid$(sText, i, 8))

                            If str1 = "%26lt%3b" Then
                                i = i + 7
                                bOK = False
                                sResult = "<"
                            End If
                        End If
                        
                        '======= 判断 >
                        If bOK = True Then
                            str1 = LCase$(Mid$(sText, i, 8))

                            If str1 = "%26gt%3b" Then
                                i = i + 7
                                bOK = False
                                sResult = ">"
                            End If
                        End If
                        
                        '======= 判断 '
                        If bOK = True Then
                            str1 = LCase$(Mid$(sText, i, 11))

                            If str1 = "%26%2339%3b" Then
                                i = i + 10
                                bOK = False
                                sResult = "'"
                            End If
                        End If
                    Case Else
                    End Select

                    If bOK = True Then
                        i = i + 2
                        sResult = ChrW$(UtfB)
                    End If
                Else
                    En1 = Hex$(UtfB)
                    En2 = Mid$(sText, i + 4, 2)
                    En3 = Mid$(sText, i + 7, 2)

                    If Len(En3) = 0 Then En3 = 0

                    'UtfB1 = (UtfB And &HF) * &H1000   '取第1个Utf-8字节的二进制后4位
                    UtfB1 = (UtfB And &HF) * 4096!   '取第1个Utf-8字节的二进制后4位

                    UtfB2 = (Val("&H" & En2) And &H3F) * &H40      '取第2个Utf-8字节的二进制后6位
                    UtfB3 = Val("&H" & En3) And &H3F      '取第3个Utf-8字节的二进制后6位

                    If Err Then
                        Debug.Assert False
                        bUTF8 = False
                        sResult = URLDecode(sText, bUTF8)

                        Exit For
                    End If

                    sResult = ChrW$(UtfB1 Or UtfB2 Or UtfB3)

                    If i = 1 Then
                        str2 = URLEncode(sResult, True)
                        str2 = Replace$(str2, "%", "")

                        If LCase$(str2) <> LCase$(En1 & En2 & En3) Then
                            bUTF8 = False
                            URLDecode = URLDecode(sText, False)

                            Exit Function
                        End If
                    End If

                    i = i + 8
                End If
            Case Else 'Ascii码
            End Select

            ReDim Preserve pResult(UBound(pResult) + 1)
            pResult(UBound(pResult)) = sResult
        Next
    End If

    URLDecode = Join(pResult, "")
End Function

'文本转URL编码
'EnMode = 0  encodeURIComponent 传递参数时使用      不编码字符有71个(!'()*-._~0-9a-zA-Z)
'EnMode = 1  encodeURI          进行 URL 跳转时使用 不编码字符有82个(!#$&'()*+-./:;=?@_~0-9a-zA-Z)
'EnMode = 2  escape             使用数据时          不编码字符有69个(*+-./@_0-9a-zA-Z)
Public Function URLEncode(ByVal sText As String, _
                          Optional ByVal bUTF8 As Boolean = False, _
                          Optional ByVal EnMode As Long = 0) As String

    Dim szChar   As String

    Dim szTemp   As String

    Dim szCode   As String

    Dim szHex    As String

    Dim szBin    As String

    Dim iCount1  As Long

    Dim iCount2  As Long

    Dim iStrLen1 As Long

    Dim iStrLen2 As Long

    Dim lResult  As Long

    Dim lAscVal  As Long

    Dim k        As Long

    Dim pCode()  As String

    sText = Trim$(sText)
    iStrLen1 = Len(sText)
    pCode = Split("")

    For iCount1 = 1 To iStrLen1
        szChar = Mid$(sText, iCount1, 1)
        lAscVal = IIf(bUTF8 = True, AscW(szChar), Asc(szChar))

        If lAscVal >= Asc("0") And lAscVal <= Asc("9") Or lAscVal >= Asc("a") And lAscVal <= Asc("z") Or lAscVal >= Asc("A") And lAscVal <= Asc("Z") Or (EnMode = 0 And InStr("!'()*-._~", szChar) > 0) Or (EnMode = 1 And InStr("!#$&'()*+-./:;=?@_~", szChar) > 0) Or (EnMode = 2 And InStr("*+-./@_", szChar) > 0) Then
            szCode = szCode & "%" & Right$("00" & Hex$(lAscVal), 2)
        ElseIf szChar = " " Then
            szChar = "%20"
        ElseIf bUTF8 = False Or InStr(""",", szChar) > 0 Then
            szHex = Hex$(Asc(szChar))

            If Len(szHex) = 4 Then
                szChar = "%" & Left$(szHex, 2) & "%" & Right$(szHex, 2)
            Else
                szChar = "%" & szHex
            End If

        Else
            szHex = Hex$(AscW(szChar))
            iStrLen2 = Len(szHex)

            For iCount2 = 1 To iStrLen2
                szChar = Mid$(szHex, iCount2, 1)

                Select Case szChar

                Case Is = "0"
                    szBin = szBin & "0000"

                Case Is = "1"
                    szBin = szBin & "0001"

                Case Is = "2"
                    szBin = szBin & "0010"

                Case Is = "3"
                    szBin = szBin & "0011"

                Case Is = "4"
                    szBin = szBin & "0100"

                Case Is = "5"
                    szBin = szBin & "0101"

                Case Is = "6"
                    szBin = szBin & "0110"

                Case Is = "7"
                    szBin = szBin & "0111"

                Case Is = "8"
                    szBin = szBin & "1000"

                Case Is = "9"
                    szBin = szBin & "1001"

                Case Is = "A"
                    szBin = szBin & "1010"

                Case Is = "B"
                    szBin = szBin & "1011"

                Case Is = "C"
                    szBin = szBin & "1100"

                Case Is = "D"
                    szBin = szBin & "1101"

                Case Is = "E"
                    szBin = szBin & "1110"

                Case Is = "F"
                    szBin = szBin & "1111"

                Case Else
                End Select

            Next

            szTemp = "1110" & Left$(szBin, 4) & "10" & Mid$(szBin, 5, 6) & "10" & Right$(szBin, 6)
            k = Len(szTemp)

            For iCount2 = 1 To k

                If Mid$(szTemp, iCount2, 1) = "1" Then
                    lResult = lResult + 1 * 2 ^ (k - iCount2)
                Else
                    lResult = lResult + 0 * 2 ^ (k - iCount2)
                End If

            Next iCount2

            szTemp = Hex$(lResult)
            szChar = "%" & Left$(szTemp, 2) & "%" & Mid$(szTemp, 3, 2) & "%" & Right$(szTemp, 2)
        End If

        ReDim Preserve pCode(UBound(pCode) + 1)
        pCode(UBound(pCode)) = szChar

        szBin = vbNullString
        lResult = 0
    Next

    URLEncode = Join(pCode, "")
End Function

'UTF8转Unicode
Public Function UTF8ToUnicode(ByRef BinBuff() As Byte) As String

    Dim lRet        As Long

    Dim lLength     As Long

    Dim lBufferSize As Long

    On Error GoTo ToExit

    lLength = UBound(BinBuff) - LBound(BinBuff) + 1

    If lLength <= 0 Then Exit Function

    lBufferSize = lLength * 2
    UTF8ToUnicode = String$(lBufferSize, Chr$(0))
    lRet = MultiByteToWideChar(CP_UTF8, 0, VarPtr(BinBuff(0)), lLength, StrPtr(UTF8ToUnicode), lBufferSize)

    If lRet <> 0 Then
        UTF8ToUnicode = Left$(UTF8ToUnicode, lRet)
    End If

ToExit:

    If Err Then Err.Clear
End Function

Private Function GetCNSpellSecondChn() As String
    GetCNSpellSecondChn = "亍丌兀丐廿卅丕亘丞鬲孬噩丨禺丿匕乇夭爻卮氐囟胤馗毓睾鼗丶亟" & _
       "鼐乜乩亓芈孛啬嘏仄厍厝厣厥厮靥赝匚叵匦匮匾赜卦卣刂刈刎刭刳刿剀剌剞剡剜蒯剽劂劁劐劓冂罔亻仃仉仂仨仡仫仞伛仳伢佤仵伥伧伉伫佞佧攸佚佝佟佗伲伽佶佴侑侉侃侏佾佻侪佼侬侔俦俨俪俅俚俣俜俑俟俸倩偌俳倬倏倮倭俾倜倌倥倨偾偃偕偈偎偬偻傥傧傩傺僖儆僭僬僦僮儇儋仝氽佘佥俎龠汆籴兮巽黉馘冁夔勹匍訇匐凫夙兕亠兖亳衮袤亵脔裒禀嬴蠃羸冫冱冽冼凇冖冢冥讠讦讧讪讴讵讷诂诃诋诏诎诒诓诔诖诘诙诜诟诠诤诨诩诮诰诳诶诹诼诿谀谂谄谇谌谏谑谒谔谕谖谙谛谘谝谟谠谡谥谧谪谫谮谯谲谳谵谶卩卺阝阢阡阱阪阽阼" & _
       "陂陉陔陟陧陬陲陴隈隍隗隰邗邛邝邙邬邡邴邳邶邺邸邰郏郅邾郐郄郇郓郦郢郜郗郛郫郯郾鄄鄢鄞鄣鄱鄯鄹酃酆刍奂劢劬劭劾哿勐勖勰叟燮矍廴凵凼鬯厶弁畚巯坌垩垡塾墼壅壑圩圬圪圳圹圮圯坜圻坂坩垅坫垆坼坻坨坭坶坳垭垤垌垲埏垧垴垓垠埕埘埚埙埒垸埴埯埸埤埝堋堍埽埭堀堞堙塄堠塥塬墁墉墚墀馨鼙懿艹艽艿芏芊芨芄芎芑芗芙芫芸芾芰苈苊苣芘芷芮苋苌苁芩芴芡芪芟苄苎芤苡茉苷苤茏茇苜苴苒苘茌苻苓茑茚茆茔茕苠苕茜荑荛荜茈莒茼茴茱莛荞茯荏荇荃荟荀茗荠茭茺茳荦荥荨茛荩荬荪荭荮莰荸莳莴莠莪莓莜莅荼莶莩荽莸荻" & _
       "莘莞莨莺莼菁萁菥菘堇萘萋菝菽菖萜萸萑萆菔菟萏萃菸菹菪菅菀萦菰菡葜葑葚葙葳蒇蒈葺蒉葸萼葆葩葶蒌蒎萱葭蓁蓍蓐蓦蒽蓓蓊蒿蒺蓠蒡蒹蒴蒗蓥蓣蔌甍蔸蓰蔹蔟蔺蕖蔻蓿蓼蕙蕈蕨蕤蕞蕺瞢蕃蕲蕻薤薨薇薏蕹薮薜薅薹薷薰藓藁藜藿蘧蘅蘩蘖蘼廾弈夼奁耷奕奚奘匏尢尥尬尴扌扪抟抻拊拚拗拮挢拶挹捋捃掭揶捱捺掎掴捭掬掊捩掮掼揲揸揠揿揄揞揎摒揆掾摅摁搋搛搠搌搦搡摞撄摭撖摺撷撸撙撺擀擐擗擤擢攉攥攮弋忒甙弑卟叱叽叩叨叻吒吖吆呋呒呓呔呖呃吡呗呙吣吲咂咔呷呱呤咚咛咄呶呦咝哐咭哂咴哒咧咦哓哔呲咣哕咻咿哌哙哚哜咩" & _
       "咪咤哝哏哞唛哧唠哽唔哳唢唣唏唑唧唪啧喏喵啉啭啁啕唿啐唼唷啖啵啶啷唳唰啜喋嗒喃喱喹喈喁喟啾嗖喑啻嗟喽喾喔喙嗪嗷嗉嘟嗑嗫嗬嗔嗦嗝嗄嗯嗥嗲嗳嗌嗍嗨嗵嗤辔嘞嘈嘌嘁嘤嘣嗾嘀嘧嘭噘嘹噗嘬噍噢噙噜噌噔嚆噤噱噫噻噼嚅嚓嚯囔囗囝囡囵囫囹囿圄圊圉圜帏帙帔帑帱帻帼帷幄幔幛幞幡岌屺岍岐岖岈岘岙岑岚岜岵岢岽岬岫岱岣峁岷峄峒峤峋峥崂崃崧崦崮崤崞崆崛嵘崾崴崽嵬嵛嵯嵝嵫嵋嵊嵩嵴嶂嶙嶝豳嶷巅彳彷徂徇徉後徕徙徜徨徭徵徼衢彡犭犰犴犷犸狃狁狎狍狒狨狯狩狲狴狷猁狳猃狺狻猗猓猡猊猞猝猕猢猹猥猬猸猱獐獍獗獠獬獯獾" & _
       "舛夥飧夤夂饣饧饨饩饪饫饬饴饷饽馀馄馇馊馍馐馑馓馔馕庀庑庋庖庥庠庹庵庾庳赓廒廑廛廨廪膺忄忉忖忏怃忮怄忡忤忾怅怆忪忭忸怙怵怦怛怏怍怩怫怊怿怡恸恹恻恺恂恪恽悖悚悭悝悃悒悌悛惬悻悱惝惘惆惚悴愠愦愕愣惴愀愎愫慊慵憬憔憧憷懔懵忝隳闩闫闱闳闵闶闼闾阃阄阆阈阊阋阌阍阏阒阕阖阗阙阚丬爿戕氵汔汜汊沣沅沐沔沌汨汩汴汶沆沩泐泔沭泷泸泱泗沲泠泖泺泫泮沱泓泯泾洹洧洌浃浈洇洄洙洎洫浍洮洵洚浏浒浔洳涑浯涞涠浞涓涔浜浠浼浣渚淇淅淞渎涿淠渑淦淝淙渖涫渌涮渫湮湎湫溲湟溆湓湔渲渥湄滟溱溘滠漭滢溥溧溽溻溷滗溴滏溏滂" & _
       "溟潢潆潇漤漕滹漯漶潋潴漪漉漩澉澍澌潸潲潼潺濑濉澧澹澶濂濡濮濞濠濯瀚瀣瀛瀹瀵灏灞宀宄宕宓宥宸甯骞搴寤寮褰寰蹇謇辶迓迕迥迮迤迩迦迳迨逅逄逋逦逑逍逖逡逵逶逭逯遄遑遒遐遨遘遢遛暹遴遽邂邈邃邋彐彗彖彘尻咫屐屙孱屣屦羼弪弩弭艴弼鬻屮妁妃妍妩妪妣妗姊妫妞妤姒妲妯姗妾娅娆姝娈姣姘姹娌娉娲娴娑娣娓婀婧婊婕娼婢婵胬媪媛婷婺媾嫫媲嫒嫔媸嫠嫣嫱嫖嫦嫘嫜嬉嬗嬖嬲嬷孀尕尜孚孥孳孑孓孢驵驷驸驺驿驽骀骁骅骈骊骐骒骓骖骘骛骜骝骟骠骢骣骥骧纟纡纣纥纨纩纭纰纾绀绁绂绉绋绌绐绔绗绛绠绡绨绫绮绯绱绲缍绶绺绻绾缁缂缃" & _
       "缇缈缋缌缏缑缒缗缙缜缛缟缡缢缣缤缥缦缧缪缫缬缭缯缰缱缲缳缵幺畿巛甾邕玎玑玮玢玟珏珂珑玷玳珀珉珈珥珙顼琊珩珧珞玺珲琏琪瑛琦琥琨琰琮琬琛琚瑁瑜瑗瑕瑙瑷瑭瑾璜璎璀璁璇璋璞璨璩璐璧瓒璺韪韫韬杌杓杞杈杩枥枇杪杳枘枧杵枨枞枭枋杷杼柰栉柘栊柩枰栌柙枵柚枳柝栀柃枸柢栎柁柽栲栳桠桡桎桢桄桤梃栝桕桦桁桧桀栾桊桉栩梵梏桴桷梓桫棂楮棼椟椠棹椤棰椋椁楗棣椐楱椹楠楂楝榄楫榀榘楸椴槌榇榈槎榉楦楣楹榛榧榻榫榭槔榱槁槊槟榕槠榍槿樯槭樗樘橥槲橄樾檠橐橛樵檎橹樽樨橘橼檑檐檩檗檫猷獒殁殂殇殄殒殓殍殚殛殡殪轫轭轱轲轳轵轶" & _
       "轸轷轹轺轼轾辁辂辄辇辋辍辎辏辘辚軎戋戗戛戟戢戡戥戤戬臧瓯瓴瓿甏甑甓攴旮旯旰昊昙杲昃昕昀炅曷昝昴昱昶昵耆晟晔晁晏晖晡晗晷暄暌暧暝暾曛曜曦曩贲贳贶贻贽赀赅赆赈赉赇赍赕赙觇觊觋觌觎觏觐觑牮犟牝牦牯牾牿犄犋犍犏犒挈挲掰搿擘耄毪毳毽毵毹氅氇氆氍氕氘氙氚氡氩氤氪氲攵敕敫牍牒牖爰虢刖肟肜肓肼朊肽肱肫肭肴肷胧胨胩胪胛胂胄胙胍胗朐胝胫胱胴胭脍脎胲胼朕脒豚脶脞脬脘脲腈腌腓腴腙腚腱腠腩腼腽腭腧塍媵膈膂膑滕膣膪臌朦臊膻臁膦欤欷欹歃歆歙飑飒飓飕飙飚殳彀毂觳斐齑斓於旆旄旃旌旎旒旖炀炜炖炝炻烀炷炫炱烨烊焐焓焖焯焱" & _
       "煳煜煨煅煲煊煸煺熘熳熵熨熠燠燔燧燹爝爨灬焘煦熹戾戽扃扈扉礻祀祆祉祛祜祓祚祢祗祠祯祧祺禅禊禚禧禳忑忐怼恝恚恧恁恙恣悫愆愍慝憩憝懋懑戆肀聿沓泶淼矶矸砀砉砗砘砑斫砭砜砝砹砺砻砟砼砥砬砣砩硎硭硖硗砦硐硇硌硪碛碓碚碇碜碡碣碲碹碥磔磙磉磬磲礅磴礓礤礞礴龛黹黻黼盱眄眍盹眇眈眚眢眙眭眦眵眸睐睑睇睃睚睨睢睥睿瞍睽瞀瞌瞑瞟瞠瞰瞵瞽町畀畎畋畈畛畲畹疃罘罡罟詈罨罴罱罹羁罾盍盥蠲钅钆钇钋钊钌钍钏钐钔钗钕钚钛钜钣钤钫钪钭钬钯钰钲钴钶钷钸钹钺钼钽钿铄铈铉铊铋铌铍铎铐铑铒铕铖铗铙铘铛铞铟铠铢铤铥铧铨铪铩铫铮铯铳铴铵铷铹铼" & _
       "铽铿锃锂锆锇锉锊锍锎锏锒锓锔锕锖锘锛锝锞锟锢锪锫锩锬锱锲锴锶锷锸锼锾锿镂锵镄镅镆镉镌镎镏镒镓镔镖镗镘镙镛镞镟镝镡镢镤镥镦镧镨镩镪镫镬镯镱镲镳锺矧矬雉秕秭秣秫稆嵇稃稂稞稔稹稷穑黏馥穰皈皎皓皙皤瓞瓠甬鸠鸢鸨鸩鸪鸫鸬鸲鸱鸶鸸鸷鸹鸺鸾鹁鹂鹄鹆鹇鹈鹉鹋鹌鹎鹑鹕鹗鹚鹛鹜鹞鹣鹦鹧鹨鹩鹪鹫鹬鹱鹭鹳疒疔疖疠疝疬疣疳疴疸痄疱疰痃痂痖痍痣痨痦痤痫痧瘃痱痼痿瘐瘀瘅瘌瘗瘊瘥瘘瘕瘙瘛瘼瘢瘠癀瘭瘰瘿瘵癃瘾瘳癍癞癔癜癖癫癯翊竦穸穹窀窆窈窕窦窠窬窨窭窳衤衩衲衽衿袂裆袷袼裉裢裎裣裥裱褚裼裨裾裰褡褙褓褛褊褴褫褶襁襦疋胥皲皴矜耒" & _
       "耔耖耜耠耢耥耦耧耩耨耱耋耵聃聆聍聒聩聱覃顸颀颃颉颌颍颏颔颚颛颞颟颡颢颥颦虍虔虬虮虿虺虼虻蚨蚍蚋蚬蚝蚧蚣蚪蚓蚩蚶蛄蚵蛎蚰蚺蚱蚯蛉蛏蚴蛩蛱蛲蛭蛳蛐蜓蛞蛴蛟蛘蛑蜃蜇蛸蜈蜊蜍蜉蜣蜻蜞蜥蜮蜚蜾蝈蜴蜱蜩蜷蜿螂蜢蝽蝾蝻蝠蝰蝌蝮螋蝓蝣蝼蝤蝙蝥螓螯螨蟒蟆螈螅螭螗螃螫蟥螬螵螳蟋蟓螽蟑蟀蟊蟛蟪蟠蟮蠖蠓蟾蠊蠛蠡蠹蠼缶罂罄罅舐竺竽笈笃笄笕笊笫笏筇笸笪笙笮笱笠笥笤笳笾笞筘筚筅筵筌筝筠筮筻筢筲筱箐箦箧箸箬箝箨箅箪箜箢箫箴篑篁篌篝篚篥篦篪簌篾篼簏簖簋簟簪簦簸籁籀臾舁舂舄臬衄舡舢舣舭舯舨舫舸舻舳舴舾艄艉艋艏艚艟艨衾袅袈裘裟襞羝羟" & _
       "羧羯羰羲籼敉粑粝粜粞粢粲粼粽糁糇糌糍糈糅糗糨艮暨羿翎翕翥翡翦翩翮翳糸絷綦綮繇纛麸麴赳趄趔趑趱赧赭豇豉酊酐酎酏酤酢酡酰酩酯酽酾酲酴酹醌醅醐醍醑醢醣醪醭醮醯醵醴醺豕鹾趸跫踅蹙蹩趵趿趼趺跄跖跗跚跞跎跏跛跆跬跷跸跣跹跻跤踉跽踔踝踟踬踮踣踯踺蹀踹踵踽踱蹉蹁蹂蹑蹒蹊蹰蹶蹼蹯蹴躅躏躔躐躜躞豸貂貊貅貘貔斛觖觞觚觜觥觫觯訾謦靓雩雳雯霆霁霈霏霎霪霭霰霾龀龃龅龆龇龈龉龊龌黾鼋鼍隹隼隽雎雒瞿雠銎銮鋈錾鍪鏊鎏鐾鑫鱿鲂鲅鲆鲇鲈稣鲋鲎鲐鲑鲒鲔鲕鲚鲛鲞鲟鲠鲡鲢鲣鲥鲦鲧鲨鲩鲫鲭鲮鲰鲱鲲鲳鲴鲵鲶鲷鲺鲻鲼鲽鳄鳅鳆鳇鳊鳋鳌鳍鳎鳏鳐鳓鳔" & _
       "鳕鳗鳘鳙鳜鳝鳟鳢靼鞅鞑鞒鞔鞯鞫鞣鞲鞴骱骰骷鹘骶骺骼髁髀髅髂髋髌髑魅魃魇魉魈魍魑飨餍餮饕饔髟髡髦髯髫髻髭髹鬈鬏鬓鬟鬣麽麾縻麂麇麈麋麒鏖麝麟黛黜黝黠黟黢黩黧黥黪黯鼢鼬鼯鼹鼷鼽鼾齄钰"
End Function

Private Function GetCNSpellSecondEng() As String
    GetCNSpellSecondEng = "CJWGNSPGCGNESYPBTYYZDXYKYGTDJNNJQMBSGZSCYJSYYQPGKBZGYCYWJKGKLJSWKPJQHYTWDDZLSGMRYPYWWCCKZNKYDGTTNGJEYKKZYTCJNMCYLQLYPYQFQRPZSLWBTGKJFYXJWZLTBNCXJJJJZXDTTSQZYCDXXHGCKBPHFFSSWYBGMXLPBYLLLHLXSPZMYJHSOJNGHDZQYKLGJHSGQZHXQGKEZZWYSCSCJXYEYXADZPMDSSMZJZQJYZCDJZWQJBDZBXGZNZCPWHKXHQKMWFBPBYDTJZZKQHYLYGXFPTYJYYZPSZLFCHMQSHGMXXSXJJSDCSBBQBEFSJYHWWGZKPYLQBGLDLCCTNMAYDDKSSNGYCSGXLYZAYBNPTSDKDYLHGYMYLCXPYCJNDQJWXQXFYYFJLEJBZRXCCQWQQSBNKYMGPLBMJRQCFLNYMYQMSQTRBCJTHZTQFRXQ" & _
       "HXMJJCJLXQGJMSHZKBSWYEMYLTXFSYDSGLYCJQXSJNQBSCTYHBFTDCYZDJWYGHQFRXWCKQKXEBPTLPXJZSRMEBWHJLBJSLYYSMDXLCLQKXLHXJRZJMFQHXHWYWSBHTRXXGLHQHFNMNYKLDYXZPWLGGTMTCFPAJJZYLJTYANJGBJPLQGDZYQYAXBKYSECJSZNSLYZHZXLZCGHPXZHZNYTDSBCJKDLZAYFMYDLEBBGQYZKXGLDNDNYSKJSHDLYXBCGHXYPKDJMMZNGMMCLGWZSZXZJFZNMLZZTHCSYDBDLLSCDDNLKJYKJSYCJLKOHQASDKNHCSGANHDAASHTCPLCPQYBSDMPJLPCJOQLCDHJJYSPRCHNWJNLHLYYQYYWZPTCZGWWMZFFJQQQQYXACLBHKDJXDGMMYDJXZLLSYGXGKJRYWZWYCLZMSSJZLDBYDCFCXYHLXCHYZJQSFQAGMNYXPFRKSSB" & _
       "JLYXYSYGLNSCMHCWWMNZJJLXXHCHSYDSTTXRYCYXBYHCSMXJSZNPWGPXXTAYBGAJCXLYSDCCWZOCWKCCSBNHCPDYZNFCYYTYCKXKYBSQKKYTQQXFCWCHCYKELZQBSQYJQCCLMTHSYWHMKTLKJLYCXWHEQQHTQHZPQSQSCFYMMDMGBWHWLGSSLYSDLMLXPTHMJHWLJZYHZJXHTXJLHXRSWLWZJCBXMHZQXSDZPMGFCSGLSXYMJSHXPJXWMYQKSMYPLRTHBXFTPMHYXLCHLHLZYLXGSSSSTCLSLDCLRPBHZHXYYFHBBGDMYCNQQWLQHJJZYWJZYEJJDHPBLQXTQKWHLCHQXAGTLXLJXMSLXHTZKZJECXJCJNMFBYCSFYWYBJZGNYSDZSQYRSLJPCLPWXSDWEJBJCBCNAYTWGMPAPCLYQPCLZXSBNMSGGFNZJJBZSFZYNDXHPLQKZCZWALSBCCJXJYZGWKYP" & _
       "SGXFZFCDKHJGXDLQFSGDSLQWZKXTMHSBGZMJZRGLYJBPMLMSXLZJQQHZYJCZYDJWBMJKLDDPMJEGXYHYLXHLQYQHKYCWCJMYYXNATJHYCCXZPCQLBZWWYTWBQCMLPMYRJCCCXFPZNZZLJPLXXYZTZLGDLDCKLYRZZGQTGJHHHJLJAXFGFJZSLCFDQZLCLGJDJCSNCLLJPJQDCCLCJXMYZFTSXGCGSBRZXJQQCTZHGYQTJQQLZXJYLYLBCYAMCSTYLPDJBYREGKLZYZHLYSZQLZNWCZCLLWJQJJJKDGJZOLBBZPPGLGHTGZXYGHZMYCNQSYCYHBHGXKAMTXYXNBSKYZZGJZLQJDFCJXDYGJQJJPMGWGJJJPKQSBGBMMCJSSCLPQPDXCDYYKYFCJDDYYGYWRHJRTGZNYQLDKLJSZZGZQZJGDYKSHPZMTLCPWNJAFYZDJCNMWESCYGLBTZCGMSSLLYXQSXSBSJS" & _
       "BBSGGHFJLWPMZJNLYYWDQSHZXTYYWHMCYHYWDBXBTLMSYYYFSXJCSDXXLHJHFSSXZQHFZMZCZTQCXZXRTTDJHNNYZQQMNQDMMGYYDXMJGDHCDYZBFFALLZTDLTFXMXQZDNGWQDBDCZJDXBZGSQQDDJCMBKZFFXMKDMDSYYSZCMLJDSYNSPRSKMKMPCKLGDBQTFZSWTFGGLYPLLJZHGJJGYPZLTCSMCNBTJBQFKTHBYZGKPBBYMTTSSXTBNPDKLEYCJNYCDYKZDDHQHSDZSCTARLLTKZLGECLLKJLQJAQNBDKKGHPJTZQKSECSHALQFMMGJNLYJBBTMLYZXDCJPLDLPCQDHZYCBZSCZBZMSLJFLKRZJSNFRGJHXPDHYJYBZGDLQCSEZGXLBLGYXTWMABCHECMWYJYZLLJJYHLGBDJLSLYGKDZPZXJYYZLWCXSZFGWYYDLYHCLJSCMBJHBLYZLYCBLYDPDQYSXQZB" & _
       "YTDKYXJYYCNRJMDJGKLCLJBCTBJDDBBLBLCZQRPXJCGLZCSHLTOLJNMDDDLNGKAQHQHJGYKHEZNMSHRPHQQJCHGMFPRXHJGDYCHGHLYRZQLCYQJNZSQTKQJYMSZSWLCFQQQXYFGGYPTQWLMCRNFKKFSYYLQBMQAMMMYXCTPSHCPTXXZZSMPHPSHMCLMLDQFYQXSZYJDJJZZHQPDSZGLSTJBCKBXYQZJSGPSXQZQZRQTBDKYXZKHHGFLBCSMDLDGDZDBLZYYCXNNCSYBZBFGLZZXSWMSCCMQNJQSBDQSJTXXMBLTXZCLZSHZCXRQJGJYLXZFJPHYMZQQYDFQJJLZZNZJCDGZYGCTXMZYSCTLKPHTXHTLBJXJLXSCDQXCBBTJFQZFSLTJBTKQBXXJJLJCHCZDBZJDCZJDCPRNPQCJPFCZLCLZXZDMXMPHJSGZGSZZQJYLWTJPFSYASMCJBTZKYCWMYTCSJJLJCQLWZM" & _
       "ALBXYFBPNLSFHTGJWEJJXXGLLJSTGSHJQLZFKCGNNDSZFDEQFHBSAQTGLLBXMMYGSZLDYDQMJJRGBJTKGDHGKBLQKBDMBYLXWCXYTTYBKMRTJZXQJBHLMHMJJZMQASLDCYXYQDLQCAFYWYXQHZY"
End Function

'--------------------------------------------------
' Procedure   : SubCount
' Description : 计算SourceText中SubText出现的次数
' CreateTime  : 2010-11-16-09:43:58
'
' ParamList   : Str (String)    目标String
'               Index (Long)    位置
' Return      : 返回Str中第Index个字符，若无，返回""
'--------------------------------------------------
Public Function SubCount(ByVal SourceText As String, _
                         ByVal SubText As String, _
                         Optional ByVal IgnoreCase As Boolean = True) As Long

    Dim c           As Long

    Dim i           As Long

    Dim CompareMode As VbCompareMethod

    Dim n           As Long
    
    n = Len(SubText)

    If Len(n) = 0 Then Exit Function
    If Len(SourceText) = 0 Then Exit Function
    
    CompareMode = IIf(IgnoreCase, vbTextCompare, vbBinaryCompare)
    
    i = 1

    Do
        i = InStr(i, SourceText, SubText, CompareMode)

        If i = 0 Then
            SubCount = c

            Exit Function

        Else
            c = c + 1
        End If

        i = i + n
    Loop

End Function

'--------------------------------------------------------------------------------
' Procedure  :  ContainsCharOf
' Description:  测试SourceText是否包含CharList中的任一字符
' Created by :  fangzi
' Date-Time  :  6/14/2017-08:56:28
'
' Parameters :  SourceText (String)
'               CharList (String)
'               IgnoreCase (Boolean = True)
'--------------------------------------------------------------------------------
Public Function ContainsCharOf(ByVal SourceText As String, _
                               ByVal CharList As String, _
                               Optional ByVal IgnoreCase As Boolean = True) As Boolean

    Dim i           As Long

    Dim c           As String

    Dim uSource     As Long

    Dim uList       As Long

    Dim CompareMode As VbCompareMethod
    
    uSource = Len(SourceText)
    uList = Len(CharList)
    
    CompareMode = IIf(IgnoreCase, vbTextCompare, vbBinaryCompare)
    
    '列表比较短时，看列表中的字符是否在源字符串中出现
    If uSource > uList Then

        For i = 1 To uList
            c = Mid$(CharList, i, 1)

            If InStr(SourceText, c, CompareMode) > 0 Then
                ContainsCharOf = True

                Exit Function

            End If

        Next

    Else    '源字符串比列表短时，看源字符串中的字符是否在列表中出现

        For i = 1 To uSource
            c = Mid$(SourceText, i, 1)

            If InStr(CharList, c, CompareMode) > 0 Then
                ContainsCharOf = True

                Exit Function

            End If

        Next

    End If

End Function
