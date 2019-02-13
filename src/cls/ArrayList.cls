VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ArrayList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByVal Destination As Long, ByVal Source As Long, ByVal Length As Long)

Dim mBuffer() As Variant
Dim mLength   As Long

Public Property Get Buffer() As Variant
    Buffer = mBuffer
End Property

Public Property Get First() As Variant
    First = mBuffer(0)
End Property

Public Property Let First(Value As Variant)
    mBuffer(0) = Value
End Property

Public Property Set First(Value As Object)
    Set mBuffer(0) = Value
End Property

Public Property Get Last() As Variant
    Last = mBuffer(mLength - 1)
End Property

Public Property Let Last(Value As Variant)
    mBuffer(mLength - 1) = Value
End Property

Public Property Set Last(Value As Object)
    Set mBuffer(mLength - 1) = Value
End Property

Public Property Get Length() As Long
    Length = mLength
End Property

'*******************************************
'Functions
'*******************************************

Public Sub Push(ParamArray v() As Variant)
    Dim u As Long
    Dim i As Long
    
    u = UBound(v)
    
    ReDim Preserve mBuffer(0 To mLength + u) As Variant
    
    For i = 0 To u
        If IsObject(v(i)) Then
            Set mBuffer(mLength + i) = v(i)
        Else
            mBuffer(mLength + i) = v(i)
        End If
    Next
    
    mLength = mLength + u + 1
End Sub

Public Sub Append(v As Variant)
    ReDim Preserve mBuffer(0 To mLength) As Variant
    
    If IsObject(v) Then
        Set mBuffer(mLength) = v
    Else
        mBuffer(mLength) = v
    End If
    
    mLength = mLength + 1
End Sub

Public Sub Pop()
    mLength = mLength - 1
    ReDim Preserve mBuffer(0 To mLength - 1) As Variant
End Sub

Public Function ToString(Optional Delimiter As String = ",") As String
    Dim i As Long
    Dim v As String
    Dim u As Long
    
    u = mLength - 1

    For i = 0 To u
        If IsObject(mBuffer(i)) Then
            v = v & "Object(" & TypeName(mBuffer(i)) & ")"
        Else
            v = v & mBuffer(i) & Delimiter
        End If
    Next
    
    If Len(v) > 0 Then
        ToString = Left$(v, Len(v) - Len(Delimiter))
    End If
End Function

Public Function ToArray() As Variant
    ToArray = mBuffer
End Function

Public Function ToStringArray() As String()
    Dim i As Long
    
    ReDim p(0 To mLength - 1) As String
    
    For i = 0 To mLength - 1
        p(i) = mBuffer(i)
    Next
    
    ToStringArray = p
End Function

'--��item��ʼ�����ɾ��count��Ԫ�أ�����item������
'--δָ��count��ֻɾ��item����
Public Sub Remove(ByRef Item As Variant, Optional Count As Long = 1)
    Dim p As Long
    
    If Count < 1 Then Exit Sub
    
    mLength = mLength - Count
    p = VarPtr(Item)
    CopyMemory p, p + 16, 16 * Count
    
    ReDim Preserve mBuffer(0 To mLength - 1) As Variant
End Sub

'--��index��ʼ�����ɾ��Count��Ԫ��
Public Sub RemoveByIndex(ByVal Index As Long, Optional Count As Long = 1)
    Dim p As Long
    
    If Count < 1 Then Exit Sub
    
    mLength = mLength - Count
    p = VarPtr(mBuffer(Index))
    CopyMemory p, p + 16, 16 * Count
    
    ReDim Preserve mBuffer(0 To mLength - 1) As Variant
End Sub

'--����newItem�������е�indexλ�ã�index֮���Ԫ�غ���
Public Sub Insert(ByVal Index As Long, NewItem As Variant)
    Dim l As Long
    Dim i As Long
    
    If Index >= mLength Then
        Err.Raise -1234, "fzCore.ArrayList", "Index�����߽�"
    End If
    
    ReDim Preserve mBuffer(0 To mLength) As Variant
    l = mLength - 1

    For i = l To Index Step -1

        If IsObject(mBuffer(i)) Then
            Set mBuffer(i + 1) = mBuffer(i)
        Else
            mBuffer(i + 1) = mBuffer(i)
        End If

    Next
    
    mLength = mLength + 1
        
    If IsObject(NewItem) Then
        Set mBuffer(Index) = NewItem
    Else
        mBuffer(Index) = NewItem
    End If
End Sub

'--��newItem���뵽relItem֮��
Public Sub InsertBefore(RelItem As Variant, NewItem As Variant)
    Dim idx As Long

    idx = IndexOf(RelItem)

    If idx = -1 Then Exit Sub
    
    Insert idx, NewItem
End Sub

'--��newItem����relItem֮ǰ
Public Sub InsertAfter(RelItem As Variant, NewItem As Variant)
    Dim idx As Long

    idx = IndexOf(RelItem)

    If idx = -1 Or idx = mLength - 1 Then Exit Sub
    
    Insert idx + 1, NewItem
End Sub

'--���������е�һ�����ֵ�item���±�
'--δ�ҵ�item������-1
Public Function IndexOf(Item As Variant) As Variant
    Dim i As Long
    Dim l As Long
    
    l = mLength - 1

    For i = 0 To l
        If Item = mBuffer(i) Then
            IndexOf = i

            Exit Function
        End If
    Next
    
    IndexOf = -1
End Function

'--�������������һ�����ֵ�item���±�
'--δ�ҵ�item������-1
Public Function LastIndexOf(Item As Variant) As Variant
    Dim i As Long
    Dim u As Long
    
    u = mLength - 1

    For i = u To 0 Step -1
        If Item = mBuffer(i) Then
            LastIndexOf = i

            Exit Function
        End If
    Next
    
    LastIndexOf = -1
End Function

'0,1,2,3,4,5
'Move(0,4)
'1,2,3,4,0,5
'Move 1,3
'1,3,4,2,0,5
'--��FromIndexλ�õ�Ԫ���ƶ���ToIndex��FromIndex֮��ToIndexλ�ü�֮ǰ��Ԫ�������ƶ�
Public Sub Move(ByVal FromIndex As Long, ByVal ToIndex As Long)
    Dim i As Long
    Dim t As Variant
    Dim u As Long
    
    If FromIndex < 0 Or FromIndex > mLength - 1 Or ToIndex < 0 Or ToIndex > mLength - 1 Or FromIndex = ToIndex Then Exit Sub
    
    t = mBuffer(FromIndex)
    
    If FromIndex < ToIndex Then
        u = ToIndex - 1

        For i = FromIndex To u
            mBuffer(i) = mBuffer(i + 1)
        Next
    Else
        For i = FromIndex To ToIndex Step -1
            mBuffer(i) = mBuffer(i - 1)
        Next
    End If
    
    mBuffer(ToIndex) = t
End Sub

'--����item����һ��Ԫ�أ����item�����һ��Ԫ�أ�����null
Public Function NextOf(Item As Variant) As Variant
    On Error Resume Next

    NextOf = mBuffer(IndexOf(Item) + 1)
End Function

'--����item��ǰһ��Ԫ�أ����item�ǵ�һ��Ԫ�أ�����null
Public Function PrevOf(Item As Variant) As Variant
    On Error Resume Next

    PrevOf = mBuffer(IndexOf(Item) - 1)
End Function

'--�����������Ƿ����item
Public Function Contains(ByVal Item As Variant, Optional ByVal IgnoreCase As Boolean = True) As Boolean
    Dim i As Long
    Dim l As Long
    
    l = mLength - 1

    If IgnoreCase Then
        For i = 0 To l
            If StrComp(Item, mBuffer(i), vbTextCompare) = 0 Then
                Contains = True

                Exit Function
            End If
        Next
    Else
        For i = 0 To l
            If Item = mBuffer(i) Then
                Contains = True

                Exit Function
            End If
        Next
    End If
End Function