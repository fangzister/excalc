VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Mesurement"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const A4_WIDTH_TWIPS   As Single = 11906
Private Const A4_HEIGHT_TWIPS  As Single = 16838
Private Const A4_WIDTH_PIXELS  As Single = 793.733
Private Const A4_HEIGHT_PIXELS As Single = 1122.533

'��Himetricsת��ΪPixels
Public Function HimetrixToPixel(HiMetrix As Long, Horizontally As Boolean) As Long
    If Horizontally Then
        HimetrixToPixel = HiMetrix * 1440 / 2540 / Screen.TwipsPerPixelX
    Else
        HimetrixToPixel = HiMetrix * 1440 / 2540 / Screen.TwipsPerPixelY
    End If
End Function

'��Himetricsת��ΪPixels��X
Public Function HimetrixToPixelX(HiMetrix As Long) As Long
    HimetrixToPixelX = HiMetrix * 1440 / 2540 / Screen.TwipsPerPixelX
End Function

'��Himetricsת��ΪPixels��Y
Public Function HimetrixToPixelY(HiMetrix As Long) As Long
    HimetrixToPixelY = HiMetrix * 1440 / 2540 / Screen.TwipsPerPixelY
End Function

'��Himetricsת��ΪTwips
Public Function HimetrixToTwips(HiMetrix As Long, Horizontally As Boolean) As Long
    If Horizontally Then
        HimetrixToTwips = HiMetrix * 1440 / 2540
    Else
        HimetrixToTwips = HiMetrix * 1440 / 2540
    End If
End Function

'��Himetricsת��ΪTwips��X
Public Function HimetrixToTwipsX(HiMetrix As Long) As Long
    HimetrixToTwipsX = HiMetrix * 1440 / 2540
End Function

'��Himetricsת��ΪTwips��Y
Public Function HimetrixToTwipsY(HiMetrix As Long) As Long
    HimetrixToTwipsY = HiMetrix * 1440 / 2540
End Function

'��ȡA4ֽ�ųߴ�Ŀ�������ֵ
Public Function GetA4WidthPixels() As Single
    GetA4WidthPixels = A4_WIDTH_PIXELS
End Function

'��ȡA4ֽ�ųߴ�ĸ߶�����ֵ
Public Function GetA4HeightPixels() As Single
    GetA4HeightPixels = A4_HEIGHT_PIXELS
End Function

'��ȡA4ֽ�ųߴ�Ŀ����ֵ
Public Function GetA4WidthTwips() As Single
    GetA4WidthTwips = A4_WIDTH_TWIPS
End Function

'��ȡA4ֽ�ųߴ�ĸ߶��ֵ
Public Function GetA4HeightTwips() As Single
    GetA4HeightTwips = A4_HEIGHT_TWIPS
End Function

'�ת��Ϊ����
Public Function TwipToPixel(ByVal Value As Single) As Single
    TwipToPixel = Value / Screen.TwipsPerPixelX
End Function

'�ת��Ϊ��
Public Function TwipToPoint(ByVal Value As Single) As Single
    TwipToPoint = Value * 20
End Function

'�ת��ΪӢ��
Public Function TwipToInch(ByVal Value As Single) As Single
    TwipToInch = Value / 1440
End Function

'�ת��Ϊ����
Public Function TwipToCentimeter(ByVal Value As Single) As Single
    TwipToCentimeter = TwipToInch(Value) * 2.54
End Function

'����ת��Ϊ�
Public Function PixelToTwip(ByVal Value As Single) As Single
    PixelToTwip = Value * Screen.TwipsPerPixelX
End Function

'����ת��Ϊ��
Public Function PixelToPoint(ByVal Value As Single) As Single
    PixelToPoint = TwipToPoint(PixelToTwip(Value))
End Function

'����ת��ΪӢ��
Public Function PixelToInch(ByVal Value As Single) As Single
    PixelToInch = TwipToInch(PixelToTwip(Value))
End Function

'����ת��Ϊ����
Public Function PixelToCentimeter(ByVal Value As Single) As Single
    PixelToCentimeter = InchToCentimeter(PixelToInch(Value))
End Function

'Ӣ��ת��Ϊ�
Public Function InchToTwip(ByVal Value As Single) As Single
    InchToTwip = Value * 1440
End Function

'Ӣ��ת��Ϊ����
Public Function InchToCentimeter(ByVal Value As Single) As Single
    InchToCentimeter = Value * 2.54
End Function

'����ת��ΪӢ��
Public Function CentimeterToInch(ByVal Value As Single) As Single
    CentimeterToInch = Value / 2.54
End Function

'����ת��Ϊ�
Public Function CentimeterToTwip(ByVal Value As Single) As Single
    CentimeterToTwip = InchToTwip(CentimeterToInch(Value))
End Function

'����ת��Ϊ����
Public Function CentimeterToPixel(ByVal Value As Single) As Single
    CentimeterToPixel = TwipToPixel(InchToTwip(CentimeterToInch(Value)))
End Function

'��ת����
Public Function PoundToPixel(ByVal Value As Single) As Single
    PoundToPixel = (Value / 72) * 96
End Function

'����ת��
Public Function PixelToPound(ByVal Value As Single) As Single
    PixelToPound = (Value * 72) / 96
End Function
