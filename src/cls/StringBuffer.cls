VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StringBuffer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'--------------------------------------------------------
' Component  :  StringBuffer
' Project    :  fzCore
'
' Description:  �ַ���������
'
' CreateBy   :  fangzi
' Modified   :
'--------------------------------------------------------

Option Explicit

Public Size          As Long

Private Buffer       As String
Private InitCapacity As Long

'--------------------------------------------------
' Procedure  :  Add
' Description:  ���Ӳ���������
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :  Values() (Variant)
'--------------------------------------------------
Public Sub Add(ParamArray Values() As Variant)
Attribute Add.VB_Description = "���Ӳ���������"
    Dim i As Long
    Dim l As Long
    
    l = UBound(Values)

    For i = 0 To l
        AddText Values(i)
    Next
End Sub

'--------------------------------------------------
' Procedure  :  AddLine
' Description:  �����ı������棬�����뻻�з�
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :  Value (Variant)
'--------------------------------------------------
Public Sub AddLine(Value)
Attribute AddLine.VB_Description = "�����ı������棬�����뻻�з�"
    AddText Value
    AddText vbCrLf
End Sub

'--------------------------------------------------
' Procedure  :  AddLines
' Description:  ���Ӷ����ı������棬�����뻻�з�
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :  Values() (Variant)
'--------------------------------------------------
Public Sub AddLines(ParamArray Values() As Variant)
Attribute AddLines.VB_Description = "���Ӷ����ı������棬�����뻻�з�"
    Dim i As Long
    Dim u As Long
    
    u = UBound(Values)

    For i = 0 To u
        AddText Values(i)
    Next

    AddText vbCrLf
End Sub

'--------------------------------------------------
' Procedure  :  AddText
' Description:  �����ı�������
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :  Value (Variant)
'--------------------------------------------------
Public Sub AddText(Value)
Attribute AddText.VB_Description = "�����ı�������"
    Dim nLen As Long

    nLen = Len(Value)

    If Size + nLen >= Len(Buffer) Then
        Buffer = Buffer & String$(GetInitCapacity, Chr$(0))
    End If
    
    Mid$(Buffer, Size + 1, nLen) = Value
    Size = Size + nLen
End Sub

'--------------------------------------------------
' Procedure  :  BufferSize
' Description:  ����StringBuffer�Ļ�������С
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :
'--------------------------------------------------
Public Function BufferSize() As Long
Attribute BufferSize.VB_Description = "����StringBuffer�Ļ�������С"
    BufferSize = Len(Buffer)
End Function

'--------------------------------------------------
' Procedure  :  CharAt
' Description:  ����Indexλ���ϵ��ַ�
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :  Index (Long)
'--------------------------------------------------
Public Function CharAt(ByVal Index As Long) As String
Attribute CharAt.VB_Description = "����Indexλ���ϵ��ַ�"
    CharAt = Mid$(Buffer, Index, 1)
End Function

'--------------------------------------------------
' Procedure  :  NewLine
' Description:  �ڻ���ĩβ׷��һ���س�����
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :
'--------------------------------------------------
Public Sub NewLine()
Attribute NewLine.VB_Description = "�ڻ���ĩβ׷��һ���س�����"
    AddText vbCrLf
End Sub

'--------------------------------------------------
' Procedure  :  Remove
' Description:  ��startSize��ʼɾ��length���ַ�
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :  StartSize (Long)
'               Length (Long)
'--------------------------------------------------
Public Sub Remove(StartSize As Long, Length As Long)
Attribute Remove.VB_Description = "��startSize��ʼɾ��length���ַ�"
    Mid$(Buffer, StartSize + 1, Length) = Chr$(0)
    Size = Size - Length
End Sub

'--------------------------------------------------
' Procedure  :  RemoveReverse
' Description:  �ӵ�ǰSize��ʼ����ǰɾ��length���ַ�
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :  Length (Long)
'--------------------------------------------------
Public Sub RemoveReverse(Length As Long)
Attribute RemoveReverse.VB_Description = "�ӵ�ǰSize��ʼ����ǰɾ��length���ַ�"
    Mid$(Buffer, Size - Length + 1, Length) = Chr$(0)
    Size = Size - Length
End Sub

'--------------------------------------------------
' Procedure  :  ReplaceFrom
' Description:  ��SizeFrom��ʼ����replacement�滻�����ַ�
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :  SizeFrom (Long)
'               Replacement (String)
'--------------------------------------------------
Public Sub ReplaceFrom(SizeFrom As Long, Replacement As String)
    Mid$(Buffer, SizeFrom + 1, Len(Replacement)) = Replacement
    Size = SizeFrom + Len(Replacement)
End Sub

'--------------------------------------------------
' Procedure  :  ReplaceLast
' Description:  ��Replacement�滻���һ���ַ�
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :  Replacement (String)
'--------------------------------------------------
Public Sub ReplaceLast(Replacement As String)
Attribute ReplaceLast.VB_Description = "��Replacement�滻���һ���ַ�"
    Mid$(Buffer, Size, Len(Replacement)) = Replacement
    Size = Size + Len(Replacement) - 1
End Sub

'--------------------------------------------------
' Procedure  :  ReplaceReverse
' Description:  ��Replacement����Length���ַ�
' Date-Time  :  2010-11-14-21:00:18
'
' Parameters :  Replacement (String)
'               Length (Long)
'--------------------------------------------------
Public Sub ReplaceReverse(Replacement As String, Length As Long)
Attribute ReplaceReverse.VB_Description = "��Replacement����Length���ַ�"
    Mid$(Buffer, Size - Length + 1, Len(Replacement)) = Replacement
    Size = Size + Len(Replacement) - Length
End Sub

'--------------------------------------------------
' Procedure  :  Reset
' Description:  ��ջ��棬�������С����ΪCapacity
' Date-Time  :  2010-11-14-21:00:17
'
' Parameters :  Capacity (Long)
'--------------------------------------------------
Public Sub Reset(ByVal Capacity As Long)
Attribute Reset.VB_Description = "��ջ��棬�������С����ΪCapacity"
    InitCapacity = Capacity
    Buffer = String$(Capacity, Chr$(0))
    Size = 0
End Sub

'--------------------------------------------------
' Procedure  :  SetCapacity
' Description:  ���û����С
' Date-Time  :  2010-11-14-21:00:17
'
' Parameters :  Value (Long = 1024&)
'--------------------------------------------------
Public Sub SetCapacity(Optional Value As Long = 1024&)
Attribute SetCapacity.VB_Description = "���û����С"
    InitCapacity = Value
    Buffer = String$(Value, Chr$(0))
End Sub

'--------------------------------------------------
' Procedure  :  ToString
' Description:  ���ػ����е��ַ���
' Date-Time  :  2010-11-14-21:00:17
'
' Parameters :
'--------------------------------------------------
Public Function ToString() As String
Attribute ToString.VB_Description = "���ػ����е��ַ���"
    ToString = Left$(Buffer, Size)
End Function

'��ȡ��ʼ�����С
Private Function GetInitCapacity() As Long
    GetInitCapacity = IIf((InitCapacity = 0), 1024, InitCapacity)
End Function

Private Sub Class_Initialize()
    Buffer = String$(GetInitCapacity, Chr$(0))
End Sub

Private Sub Class_Terminate()
    Buffer = ""
End Sub