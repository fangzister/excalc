VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "INIProfile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'--------------------------------------------------------------------------------
'    Component  : INIProfile
'    Project    : fzCore
'
'    Description: Ini�ļ�������
'
'    Modified   : 2012.7.4
'--------------------------------------------------------------------------------
Option Explicit

Private mProfileName   As String
Private mExeFolderPath As String

Private Declare Function GetPrivateProfileInt Lib "kernel32" Alias "GetPrivateProfileIntA" (ByVal lpApplicationName As String, ByVal lpKeyName As String, ByVal nDefault As Long, ByVal lpFileName As String) As Long
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
Private Const STRING_BUFFER_SIZE = 99999 '�ַ��������С

'ini�ļ���
Public Property Get Name() As String
Attribute Name.VB_Description = "����/����ini�ļ���"
    Name = mProfileName
End Property

Public Property Let Name(ByVal Value As String)
    mProfileName = Value
End Property

'exe�ļ�������Ŀ¼·��
Public Property Get ExeFolderPath() As String
Attribute ExeFolderPath.VB_Description = "����/����exe�ļ�������Ŀ¼·��"
    ExeFolderPath = mExeFolderPath
End Property

Public Property Let ExeFolderPath(ByVal Value As String)
    mExeFolderPath = Value
End Property

'���������ļ�·��
Public Property Get ProfilePath() As String
Attribute ProfilePath.VB_Description = "���������ļ�·��"
    ProfilePath = mExeFolderPath & "\" & mProfileName & ".ini"
End Property

'���Ե�ǰSection�Ƿ����ĳ��ֵ
Public Function IsValueExists(ByVal Section As String, ByVal Value As Variant, Optional ByVal CompareMode As VbCompareMethod = VbCompareMethod.vbTextCompare) As Boolean
    Dim p() As String
    Dim i As Long
    Dim v As String
    Dim u As Long
    
    p = GetAllKeys(Section)
    
    u = UBound(p)
    If u = -1 Then
        Exit Function
    End If
    
    Select Case TypeName(Value)
    Case "String"
        For i = 0 To u
            If StrComp(Value, GetString(Section, p(i)), CompareMode) = 0 Then
                IsValueExists = True
                Exit Function
            End If
        Next
    Case Else
        For i = 0 To u
            If Value = GetLong(Section, p(i)) Then
                IsValueExists = True
                Exit Function
            End If
        Next
    End Select
    
End Function

'��ȡֵ��Ӧ��Key
Public Function GetKeyByValue(ByVal Section As String, ByVal Value As Variant, Optional ByVal CompareMode As VbCompareMethod = vbTextCompare) As String
    Dim s As String
    Dim p() As String
    Dim u As Long
    Dim i As Long
    
    p = GetAllKeys(Section)
    u = UBound(p)
    
    If u = -1 Then
        Exit Function
    End If
    
    Select Case TypeName(Value)
    Case "String"
        For i = 0 To u
            If StrComp(Value, GetString(Section, p(i)), CompareMode) = 0 Then
                GetKeyByValue = p(i)
                Exit Function
            End If
        Next
    Case Else
        For i = 0 To u
            If Value = GetLong(Section, p(i)) Then
                GetKeyByValue = p(i)
                Exit Function
            End If
        Next
    End Select
End Function

'��ȡ��ǰSection�е���һ����ֵ
Public Function GetNextKey(ByVal Section As String) As String
    Dim c As Long
    Dim k As Long
    Dim p() As String
    Dim sLastKey As String
    Dim u As Long
    
    p = GetAllKeys(Section)
    u = UBound(p)
    If u = -1 Then
        GetNextKey = "a"
        Exit Function
    End If
    
    sLastKey = p(UBound(p))
    c = Asc(sLastKey)
    If c < 122 Then 'Asc("z")
        GetNextKey = Chr(c + 1)
    Else
        MsgBox "TODO"
    End If
End Function

'��ȡIni�ַ���ֵ
Public Function GetString(ByVal SectionName As String, ByVal KeyWord As String, Optional ByVal DefString As String = "") As String
Attribute GetString.VB_Description = "��ȡIni�ַ���ֵ"
    Dim ret  As String * 144
    Dim temp As Long
    Dim s    As String
    Dim i    As Integer

    temp = GetPrivateProfileString(SectionName, KeyWord, "", ret, 144, ProfilePath)

    '�����ؼ��ʵ�ֵ
    If temp > 0 Then '�ؼ��ʵ�ֵ��Ϊ��
        s = ""

        For i = 1 To 144
            If Asc(Mid$(ret, i, 1)) = 0 Then
                Exit For
            Else
                s = s & Mid$(ret, i, 1)
            End If
        Next
    Else
        temp = WritePrivateProfileString(SectionName, KeyWord, DefString, ProfilePath)
        '��ȱʡֵд��INI�ļ�
        s = DefString
    End If

    GetString = s
End Function

'��ȡIni��ֵ
Public Function GetLong(ByVal SectionName As String, ByVal KeyWord As String, Optional ByVal DefaultValue As Long = 0) As Long
Attribute GetLong.VB_Description = "��ȡIni��ֵ"
    Dim d As Long
    Dim s As String
    
    d = DefaultValue
    GetLong = GetPrivateProfileInt(SectionName, KeyWord, DefaultValue, ProfilePath)

    If d <> DefaultValue Then
        s = "" & d
        d = WritePrivateProfileString(SectionName, KeyWord, s, ProfilePath)
    End If
End Function

'д���ַ���ֵ
Public Sub SetString(ByVal SectionName As String, ByVal KeyWord As String, ByVal ValStr As String)
Attribute SetString.VB_Description = "д���ַ���ֵ"
    Dim ret As Long

    ret = WritePrivateProfileString(SectionName, KeyWord, ValStr, ProfilePath)
End Sub

'д����ֵ
Public Sub SetLong(ByVal SectionName As String, ByVal KeyWord As String, ByVal Value As Long)
Attribute SetLong.VB_Description = "д����ֵ"
    Dim ret As Long
    Dim s   As String

    s = str$(Value)
    ret = WritePrivateProfileString(SectionName, KeyWord, s, ProfilePath)
End Sub

'���KeyWord��
Public Sub DeleteKey(ByVal SectionName As String, ByVal KeyWord As String)
Attribute DeleteKey.VB_Description = "���KeyWord��"
    Dim ret As Long

    ret = WritePrivateProfileString(SectionName, KeyWord, 0&, ProfilePath)
End Sub

'��� Section"��"(Sub)����������section����дһ��Key��һ��""��
Public Sub DeleteSection(ByVal SectionName As String)
Attribute DeleteSection.VB_Description = "��� Section""��""(Sub)����������section����дһ��Key��һ��""""��"
    Dim ret As Long

    ret = WritePrivateProfileString(SectionName, 0&, "", ProfilePath)
End Sub


'��ȡ С�� ������ �Ӽ���
Public Function GetAllKeys(ByVal AppName As String) As String()
    Dim str1 As String, str2 As String
    Dim i As Long, k As Long
    Dim p() As String
    Dim Rec As Long

    str1 = Space$(STRING_BUFFER_SIZE)
    Rec = GetPrivateProfileString(AppName, 0&, "", str1, STRING_BUFFER_SIZE, ProfilePath)

    k = InStr(str1 & Chr$(0), String$(2, Chr$(0)))
    If k > 0 Then
        str1 = Left$(str1, k - 1)
    Else
        str1 = ""
    End If
    p = Split(str1, Chr$(0))
    GetAllKeys = p
End Function

'��ȡ���� С����
Public Function GetAllSections() As String()
    Dim str1 As String, str2 As String
    Dim i As Long, k As Long, Rec As Long
    Dim p() As String

    str1 = Space$(STRING_BUFFER_SIZE)
    Rec = GetPrivateProfileString(vbNullString, 0&, "", str1, STRING_BUFFER_SIZE, ProfilePath)

    k = InStr(str1 & Chr$(0), String$(2, Chr$(0)))
    If k > 0 Then
        str1 = Left$(str1, k - 1)
    Else
        str1 = ""
    End If
    
    p = Split(str1, Chr$(0))
    
    GetAllSections = p
End Function
