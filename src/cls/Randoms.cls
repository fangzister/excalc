VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Randoms"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'================================================================================
'����:
'RandomGenerator
'
'����:
'���������
'
'����:
'fangzi
'
'RandDateTime   '�����������ʱ��   09:52 2009-9-26
'RandCnName     '������ռ90%        10:22 2009-9-28
'
'������:10:22 2009-9-28
'================================================================================

Option Explicit

Private Const BAIJIAXING             As String = "������������Ǯ����¬���ⷽ��֣����������������������������޺������߲̹����ﺫκ��ʩ���������ȿײܸ�" & "�ս���л������ˮ������˸��ɷ���³Τ����ﻨ����Ԭ��ۺ��ʷ�Ʒ����Ѧ�׺���������Ϻ½�������������ʱ" & "Ƥ���뿵����Ԫ������ƽ�ƺ�������Ҧ��տ����ë�����ױ���갼Ʒ��ɴ�̸��é���ܼ�������ף������ϯ������ǿ" & "��·¦Σ��ͯ��ʢ�������������֧���ù�Ī�������Ѹɽ�Ӧ�����ڵ���������÷������ʯ��ť�������ϻ���½��" & "������춻������ҷ����ഢ���������ɾ��θ����ڽ��͹�����ɽ�ȳ������ȫۭ�����������������ﱩ����������" & "�����ղ����Ҷ��˾��۬�輻��ӡ�ް׻���ۢ�Ӷ����̼���׿�����ɳ����������ܲ�˫��ݷ����̷�����̼������" & "Ƚ��۪Ӻ�S�ɣ���ţ��ͨ�����༽ۣ����ũ�±�ׯ�̲����ֳ�Ľ��"
Private Const COMMON_NAME_1          As String = "��ΰ�¾������η���Ƽǿ���������Ừƽ�������쵤�Գ�����վ��������ӱ��Ӣ�۷�ϼ�ƿ������ּ���Ө�Ⱦ�" & "������������������������������ٽ����ؽ�ٻ÷��������������ޱѩ�����ٽ�쿳������������������Ρά" & "��������Ⱥ���ô����������ˬ�����ʹ�˧調������������������־����������������������᰺��ɺ�㾸��" & "���������Ϸƽ����������ʤݼ�Ʒ�¶Խͮ��������ܿ����������Դ����ɯ���������������ǿ��质������Ȼ"
Private Const COMMON_NAME_2_1        As String = "��С����־�����������������µ������ΰѩ������������ѧ���������ƻ�������쳤�޻�������������̼�" & "����˼ά�ٸ��ұ��ӳ��º鶫һ���ִ��������ǽ������Ų��䴫�������������ι��Ԫ���徲�����׵��˲���ϲԶ" & "������ʤ���Ⱦ�ʿ������������ҫ��Ӣ������Т÷������ˮ���濪���˹����෼����������˳˫������Ծ�����걣" & "���ٺ�ƼӶ��������ط����������主ƽȫ����ï��ʫ������λ��������ϣ��Ӧ�����ػ῭�����豾����������"
Private Const COMMON_NAME_2_2        As String = "��ƽ��Ӣ����Ƽ�������ϼ÷��������������ƻԶ�����ΰǿ�����������������������÷������·����¸���" & "Ԫ��������������������ɽ������˹�����㿡����۲ź�Ⱥ��ʤ��������ɽ���������󸣷�����ϲ�����־ȫ" & "��Ȩ���ս������ǵ������鿵������Ȫ�ﾲ��˳Դɺ������Ө�º���������֥�����λݺ�����Զ��ɭ�������潡��" & "�罿������������������ѧ����������Ȼ����ӱ�������������ѩ�辧������������������ͷ��������������"
Private Const COMMON_NAME_MALE_1     As String = "ΰ�¾����ǿ�����ڻ�ƽ�������Գ��շ����ɺƿ������ֱ��������񽣽������������ٽ�쿳��춫�������Ρ��" & "����������ʹ�˧調������������־���������������ܺ�ݺ��������Ͻ�ʤݼ�Ʒ�¶Խͮ��������������" & "��������������������Ǵ����ν���������������������������Ⱥˬ����������Ȼ��Դ����ά"
Private Const COMMON_NAME_FEMALE_1   As String = "��������Ƽ����쵤�������ӱ��Ӣ��ϼ��Ө�Ⱦ�������ٺ���ٻ÷ޱѩ����������������������ɺ���������" & "�ν���������������������������Ⱥˬ����������Ȼ��Դ����ά��ܿɯ�ݿ�����"
Private Const COMMON_NAME_MALE_2_1   As String = "��־�������µ���ΰ����������ѧ����������쳤�����ټ̼���˼ά�ٸ��ұ��ɺ鶫һ���ִ������ǽ�����������" & "�������й��Ԫ���������׵�����ϲԶ����ʤ����ʿ����������ҫ������Т����ˮ���濪���˹���������˳˫����" & "��Ծ���屣���ٺ�ƼӶ��������ط����������主ƽȫ����ï�����������ϣ��Ӧ�����ػ῭�����豾��������С" & "������������ѩ���ƻ����������"
Private Const COMMON_NAME_FEMALE_2_1 As String = "��������������޻ۼѷ�����÷�����û��������δ���������Ӣ��ʫ����������С������������ѩ���ƻ����������"
Private Const COMMON_NAME_MALE_2_2   As String = "ƽ�������ٷ�Զ���ΰǿ������������������·���¸���Ԫ������������������ɽ��˹���信�۲ź�Ⱥ��" & "ʤ������ɽ�����󸣷������־ȫ��Ȩ���Ǹ��Ϳ���Ȫ˳Դ���º������Ѻ��κ�����Զɭ���潡��������������ѧ" & "�������趰����������������跲���������������ͷ�������������ֺ�����Ȼӱ����ϲ����ѩ�崺����"
Private Const COMMON_NAME_FEMALE_2_2 As String = "��ӢƼ����ϼ÷�����������������ɺ�����Ө�����·��������֥���ﾲ���������յ������������÷�������" & "��������ֺ�����Ȼӱ����ϲ����ѩ�崺����"
Private Const BAIJIAXING_LENGTH      As Integer = 330
Private Const COMMON_NAME_LENGTH     As Integer = 200
Private Const ALL_LETTERS            As String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
Private Const ALL_ABC                As String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
Private Const LOWER_LETTERS          As String = "abcdefghijklmnopqrstuvwxyz"
Private Const UPPER_LETTERS          As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Private Const ALL_NUMBERS            As String = "0123456789"
Private Const UNI_START              As Long = 19968
Private Const UNI_END                As Long = 40896
    
Enum LetterStyleConstants
    [LettersLower] = 4&
    [LettersUpper] = 2&
    [Numbers] = 1&
End Enum

Private Sub Class_Initialize()
    Randomize
End Sub

'--------------------------------------------------------------------------------
'������
'����String1�е�һ������ַ�
'
'���ߣ�fangzi
'���ڣ�2010-04-05 17:55:44
'--------------------------------------------------------------------------------
Public Function RandCharOfString(String1 As String) As String
Attribute RandCharOfString.VB_Description = "����String1�е�һ������ַ�"
    If Len(String1) = 0 Then Exit Function
    
    RandCharOfString = Mid$(String1, RandLong(Len(String1), 1), 1)
End Function

'--------------------------------------------------------------------------------
'������
'�����������֤��
'
'���ߣ�fangzi
'���ڣ�2010-04-05 17:54:52
'--------------------------------------------------------------------------------
Public Function RandIDNumber() As String
Attribute RandIDNumber.VB_Description = "�����������֤�ţ�Ŀǰ��������ʡ"
    Dim sAreaCode As String
    Dim sBirthday As String
    Dim sSequence As String
    Dim sValidate As String
    
    sAreaCode = "530" & RandNumberString(3)
    sBirthday = Format$(RandDate(#12/31/1990#, #1/1/1970#), "yyyyMMdd")
    sSequence = Format$(RandInt(999, 1), "000")
    sValidate = IIf(RandBoolean(0.01), "X", RandCharOfString("1234567890"))
    
    RandIDNumber = sAreaCode & sBirthday & sSequence & sValidate
End Function

'����lst�����е�Ԫ��֮һ
Public Function RandOfArray(lst As Variant) As Variant
Attribute RandOfArray.VB_Description = "����lst�����е�Ԫ��֮һ"
    Dim i As Long

    If Not IsArray(lst) Then Exit Function
    i = RandInt(UBound(lst), LBound(lst))
    RandOfArray = lst(i)
End Function

'--------------------------------------------------------------------------------
'������
'����ComboBox��ListBox���б�����֮һ���ַ���
'
'���ߣ�fangzi
'���ڣ�2010-04-03 15:11:31
'--------------------------------------------------------------------------------
Public Function RandOfList(ListControl As Object) As String
Attribute RandOfList.VB_Description = "����ComboBox��ListBox���б�����֮һ���ַ���"
    If TypeOf ListControl Is ListBox Or TypeOf ListControl Is ComboBox Then
        RandOfList = ListControl.List(RandInt(ListControl.ListCount - 1, 0))
    End If
End Function

'--------------------------------------------------------------------------------
'������
'�������,����������Ҳ����������.5
'
'������
'FullMark�� �����Ƕ���
'PointRate���õ�0.5�ļ����Ƕ���
'PassMark�� �������
'PassRate�� ����ļ���
'
'���ߣ�fangzi
'���ڣ�2010-04-03 15:12:00
'--------------------------------------------------------------------------------
Public Function RandMark(Optional FullMark As Integer = 100, Optional PointRate As Single = 0.8, Optional PassMark As Integer = 60, Optional PassRate As Single = 0.9) As Single
Attribute RandMark.VB_Description = "���ر�ʾ�÷ֵ��������,����������Ҳ����������.5��FullMark:���֣�PointRate:�õ�0.5�ļ��ʣ�PassMark:���������PassRate:����ļ���"
    Dim mark As Single
    
    If RandBoolean(PassRate) Then
        mark = RandInt(FullMark, PassMark)
    Else
        mark = RandInt(PassMark - 1, 0)
    End If
    
    '������
    If RandBoolean(PointRate) Then
        If mark = FullMark Then
            RandMark = FullMark
        Else
            RandMark = mark + 0.5
        End If
    Else
        '��������
        RandMark = mark
    End If
End Function

'����С�ڵ���Upper�Ҵ��ڵ���Lower������
Public Function RandDate(ByVal Upper As Date, Optional ByVal Lower As Date = #1/1/1900#) As Date
Attribute RandDate.VB_Description = "����С�ڵ���Upper�Ҵ��ڵ���Lower������"
    Dim diff As Long
    Dim nd   As Long

    diff = DateDiff("d", Lower, Upper)
    
    nd = RandLong(diff, 0)
    RandDate = DateAdd("d", nd, Lower)
End Function

'����С�ڵ���Upper�Ҵ��ڵ���Lower�����ں�ʱ��
Public Function RandDateTime(ByVal Upper As Date, Optional ByVal Lower As Date = #1/1/1900#) As String
Attribute RandDateTime.VB_Description = "����С�ڵ���Upper�Ҵ��ڵ���Lower�����ں�ʱ��"
    Dim diff As Long
    Dim nd   As Long

    diff = DateDiff("s", Lower, Upper)
    
    nd = RandLong(diff, 0)
    RandDateTime = Format$(DateAdd("s", nd, Lower), "yyyy-MM-dd")
    RandDateTime = RandDateTime & " " & Format$(RandInt(23, 0), "00") & ":" & Format$(RandInt(59, 0), "00") & ":" & Format$(RandInt(59, 0), "00")
End Function

'��������Variant֮һ
Public Function RandOf2(ByVal v1 As Variant, ByVal v2 As Variant, Optional ByVal v1Rate As Single = 0.5) As Variant
Attribute RandOf2.VB_Description = "��������Variant֮һ��v1Rate��ʾ����ֵ�ǵ�һ��ֵ�ļ��ʡ�"
    RandOf2 = IIf(Rnd < v1Rate, v1, v2)
End Function

'���������ַ���֮һ
Public Function RandOf2String(ByVal str1 As String, ByVal str2 As String, Optional ByVal str1Rate As Single = 0.5)
Attribute RandOf2String.VB_Description = "���������ַ���֮һ"
    RandOf2String = IIf(Rnd < str1Rate, str1, str2)
End Function

'����boolean
Public Function RandBoolean(Optional trueRate As Single = 0.5) As Boolean
Attribute RandBoolean.VB_Description = "����boolean"
    RandBoolean = (Rnd < trueRate)
End Function

'����С�ڵ���Upper�Ҵ��ڵ���Lower������
Public Function RandInt(ByVal Upper As Integer, Optional ByVal Lower As Integer) As Integer
Attribute RandInt.VB_Description = "����С�ڵ���Upper�Ҵ��ڵ���Lower������"
    RandInt = Int((Upper - Lower + 1) * Rnd + Lower)
End Function

'����int1��int2֮һ
Public Function RandOf2Integer(ByVal int1 As Integer, ByVal int2 As Integer, Optional ByVal int1Rate As Single = 0.5) As Integer
Attribute RandOf2Integer.VB_Description = "����int1��int2֮һ"
    RandOf2Integer = IIf(Rnd >= int1Rate, int2, int1)
End Function

'����С�ڵ���Upper�Ҵ��ڵ���Lower�ĳ�����
Public Function RandLong(ByVal Upper As Long, Optional ByVal Lower As Long) As Long
Attribute RandLong.VB_Description = "����С�ڵ���Upper�Ҵ��ڵ���Lower�ĳ�����"
    RandLong = Int((Upper - Lower + 1) * Rnd + Lower)
End Function

'���س���ΪLength���ַ���
Public Function RandString(ByVal Length As Long) As String
Attribute RandString.VB_Description = "���س���ΪLength���ַ�����"
    Dim nIndex As Integer
    Dim i      As Long
    Dim ret    As String
    
    ret = String$(Length, Chr$(0))

    For i = 1 To Length
        nIndex = RandInt(Len(ALL_LETTERS), 1)
        Mid$(ret, i, 1) = Mid$(ALL_LETTERS, nIndex, 1)
    Next

    RandString = ret
End Function

'Public Function RandLetter(ByVal Lower As Integer, ByVal Upper As Integer)
'
'End Function

'������������ɵĳ���ΪLength���ַ���
Public Function RandNumberString(ByVal Length As Long) As String
Attribute RandNumberString.VB_Description = "������������ɵĳ���ΪLength���ַ���"
    Dim nIndex As Integer
    Dim i      As Long
    Dim ret    As String
    
    ret = String$(Length, Chr$(0))

    For i = 1 To Length
        nIndex = RandInt(Len(ALL_NUMBERS), 1)
        Mid$(ret, i, 1) = Mid$(ALL_NUMBERS, nIndex, 1)
    Next

    RandNumberString = ret
End Function

'���س���ΪLength��unicode����
Public Function RandUnicodeCnString(ByVal Length As Long) As String
Attribute RandUnicodeCnString.VB_Description = "���س���ΪLength��unicode����"
    Dim unicode As Long
    Dim ret     As String
    Dim i       As Long

    ret = String$(Length, Chr$(0))
    
    For i = 1 To Length
        unicode = RandLong(UNI_END, UNI_START)
        Mid$(ret, i, 1) = ChrW$(unicode)
    Next

    RandUnicodeCnString = ret
End Function

'Public Function RandCommonCnString(ByVal Length As Long) As String
'    Dim index As String
'    Dim ret As String
'    Dim s1  As String
'    Dim s2  As String
'    Dim s3  As String
'    Dim s4  As String
'    Dim i   As Long
'
'    ret = String(Length, Chr$(0))
'
'    For i = 1 To Length
'        s1 = RandLetter(2, 4)
'        s2 = Hex$(RandInt(15))
'        s3 = Hex$(RandInt(15, 10))
'        If s3 = "A" Then
'            s4 = Hex$(RandInt(15, 1))
'        ElseIf s3 = "F" Then
'            s4 = Hex$(RandInt(14, 0))
'        Else
'            s4 = Hex$(RandInt(15, 0))
'        End If
'        Mid$(ret, i, 1) = Chr$("&H" & s1 & s2 & s3 & s4)
'    Next
'
'    RandCommonCnString = ret
'End Function
  
'--------------------------------------------------------------------------------
'������
'��������й�����
'
'������
'Gender: 1 �� 2 Ů ���� �����Ա�
'
'���أ�
'
'���ߣ�fangzi
'���ڣ�2010-04-03 16:49:53
'--------------------------------------------------------------------------------
Public Function RandName(Optional ByVal Gender As Long = 0) As String
    Dim nameLen   As Integer
    Dim Index     As Integer
    Dim firstName As String
    Dim midName   As String
    Dim lastName  As String
    Dim isCommon  As Boolean

    isCommon = RandBoolean(0.9)
    
    nameLen = RandOf2Integer(2, 3, 0.4)
    
    If isCommon Then
        firstName = Mid$(Left$(BAIJIAXING, 50), RandInt(50, 1), 1)
    Else
        firstName = Mid$(BAIJIAXING, RandInt(BAIJIAXING_LENGTH, 1), 1)
    End If

    Select Case Gender
    Case 1  '��
        If nameLen = 3 Then
            Index = RandInt(Len(COMMON_NAME_MALE_2_1), 1)
            midName = Mid$(COMMON_NAME_MALE_2_1, Index, 1)
            Index = RandInt(Len(COMMON_NAME_MALE_2_2), 1)
            lastName = Mid$(COMMON_NAME_MALE_2_2, Index, 1)
            RandName = firstName & midName & lastName
        Else
            Index = RandInt(Len(COMMON_NAME_MALE_1), 1)
            lastName = Mid$(COMMON_NAME_MALE_1, Index, 1)
            RandName = firstName & lastName
        End If
    Case 2  'Ů
        If nameLen = 3 Then
            Index = RandInt(Len(COMMON_NAME_FEMALE_2_1), 1)
            midName = Mid$(COMMON_NAME_FEMALE_2_1, Index, 1)
            Index = RandInt(Len(COMMON_NAME_FEMALE_2_2), 1)
            lastName = Mid$(COMMON_NAME_FEMALE_2_2, Index, 1)
            RandName = firstName & midName & lastName
        Else
            Index = RandInt(Len(COMMON_NAME_FEMALE_1), 1)
            lastName = Mid$(COMMON_NAME_FEMALE_1, Index, 1)
            RandName = firstName & lastName
        End If
    Case Else  '����
        If nameLen = 3 Then
            Index = RandInt(COMMON_NAME_LENGTH, 1)
            midName = Mid$(COMMON_NAME_2_1, Index, 1)
            Index = RandInt(COMMON_NAME_LENGTH, 1)
            lastName = Mid$(COMMON_NAME_2_2, Index, 1)
            RandName = firstName & midName & lastName
        Else
            Index = RandInt(COMMON_NAME_LENGTH, 1)
            lastName = Mid$(COMMON_NAME_1, Index, 1)
            RandName = firstName & lastName
        End If
    End Select
End Function

'����RGB��ɫ
Public Function RandColor() As Long
Attribute RandColor.VB_Description = "����RGB��ɫ"
    RandColor = RGB(RandInt(255, 0), RandInt(255, 0), RandInt(255, 0))
End Function

'--------------------------------------------------------------------------------
'������
'��������Ա�MaleRateָ����ȡ���Եļ���
'���ߣ�fangzi
'���ڣ�2009-12-24 20:58:28
'--------------------------------------------------------------------------------
Public Function RandGender(Optional ByVal MaleRate As Single = 0.5) As String
Attribute RandGender.VB_Description = "��������Ա�MaleRateָ����ȡ���Եļ���"
    RandGender = IIf(Rnd > MaleRate, "��", "Ů")
End Function

'--------------------------------------------------------------------------------
'������
'����������䣬MinAge��MaxAgeָ�����ص����䷶Χ
'���ߣ�fangzi
'���ڣ�2009-12-24 20:59:44
'--------------------------------------------------------------------------------
Public Function RandAge(Optional MinAge As Integer = 1, Optional MaxAge As Integer = 100) As Integer
Attribute RandAge.VB_Description = "����������䣬MinAge��MaxAgeָ�����ص����䷶Χ"
    RandAge = RandInt(MaxAge, MinAge)
End Function

'--------------------------------------------------------------------------------
'������
'�����������
'���ߣ�fangzi
'���ڣ�2009-12-24 21:00:27
'--------------------------------------------------------------------------------
Public Function RandBirthday(Optional DateFormat As String = "yyyy-MM-dd") As String
Attribute RandBirthday.VB_Description = "����������գ�DateFormatָ�����ڸ�ʽ"
    Dim d As Date

    d = RandDate(Now, DateAdd("yyyy", -99, Now))
    RandBirthday = Format$(d, DateFormat)
End Function

'--------------------------------------------------------------------------------
'������
'�������Сд��ĸ
'���ߣ�fangzi
'���ڣ�2009-12-24 21:16:38
'--------------------------------------------------------------------------------
Public Function RandLetterLower()
Attribute RandLetterLower.VB_Description = "�������Сд��ĸ"
    RandLetterLower = Mid$(LOWER_LETTERS, RandInt(26, 1), 1)
End Function

'--------------------------------------------------------------------------------
'������
'���������д��ĸ
'���ߣ�fangzi
'���ڣ�2009-12-24 21:16:38
'--------------------------------------------------------------------------------
Public Function RandLetterUpper()
Attribute RandLetterUpper.VB_Description = "���������д��ĸ"
    RandLetterUpper = Mid$(UPPER_LETTERS, RandInt(26, 1), 1)
End Function

'--------------------------------------------------------------------------------
'������
'���������ĸ�����ִ�Сд
'���ߣ�fangzi
'���ڣ�2009-12-24 21:16:38
'--------------------------------------------------------------------------------
Public Function RandLetter()
Attribute RandLetter.VB_Description = "���������ĸ�����ִ�Сд"
    RandLetter = Mid$(ALL_ABC, RandInt(52, 1), 1)
End Function

'--------------------------------------------------------------------------------
'������
'�������Ascii�ɼ��ַ�
'���ߣ�fangzi
'���ڣ�2009-12-24 21:20:02
'--------------------------------------------------------------------------------
Public Function RandChar()
Attribute RandChar.VB_Description = "�������Ascii�ɼ��ַ�"
    RandChar = Chr$(RandInt(126, 32))
End Function

'--------------------------------------------------------------------------------
'������
'��������ĸ�ʽ���ַ���
'FormatString:
'   A����ʾA~Z
'   a����ʾa~z
'   f: ��ʾa~Z
'   0����ʾ0~9
'   ?����ʾ���ⵥ���ַ�
'   ������ʾ���⺺��
'   �����ַ�������ԭ��
'
'   ʾ����Ҫ�õ�asd-124-ASD����-a
'         debug.print RandFormatString("aaa-000-AAA����-?")
'���ߣ�fangzi
'���ڣ�2009-12-24 21:04:57
'--------------------------------------------------------------------------------
Public Function RandFormatString(Optional FormatString As String = "A-a~f/0?��")
Attribute RandFormatString.VB_Description = "��������ĸ�ʽ���ַ�����\r\n[A:��ʾA~Z | a:��ʾa~z | f:��ʾa~Z | 0:��ʾ0~9 | ?:��ʾ���ⵥ���ַ� | ��:��ʾ���⺺�� | �����ַ�:����ԭ��"
    Dim i    As Long
    Dim s    As String
    Dim c    As String
    Dim sRet As String
    Dim u    As Long
   
    u = Len(FormatString)

    If u = 0 Then Exit Function
    
    sRet = String$(u, Chr$(0))
    
    For i = 1 To u
        c = Mid$(FormatString, i, 1)

        Select Case c
        Case "a":  Mid$(sRet, i, 1) = RandLetterLower
        Case "A":  Mid$(sRet, i, 1) = RandLetterUpper
        Case "f":  Mid$(sRet, i, 1) = RandLetter
        Case "?":  Mid$(sRet, i, 1) = RandChar
        Case "0":  Mid$(sRet, i, 1) = RandInt(9, 0)
        Case "��": Mid$(sRet, i, 1) = RandUnicodeCnString(1)
        Case Else: Mid$(sRet, i, 1) = c
        End Select
    Next
    
    RandFormatString = sRet
End Function

'--------------------------------------------------------------------------------
'������
'���ش���1�����������
'������
'Max:���ֵ
'PointNumber: ������С����λ��
'���ߣ�fangzi
'���ڣ�2009-12-24 22:02:02
'--------------------------------------------------------------------------------
Public Function RandFloat(Max As Long, Optional Min As Long = 0, Optional PointReserved As Integer = 2) As Double
Attribute RandFloat.VB_Description = "���ش���1�������������Max��ʾ���ֵ��Min��ʾ��Сֵ��PointReserved��ʾ������С��λ��"
    If PointReserved < 0 Then Exit Function
    
    RandFloat = Format$(RandLong(Max, Min) + Rnd, "#." & String$(PointReserved, "0"))
End Function
