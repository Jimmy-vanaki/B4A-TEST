B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
'**********************************
'*** Horizontal ICSLike Seekbar ***
'***  version 1.0 - by mabool   ***
'**********************************
Sub Class_Globals
	Private mbBackground As Panel 
	Private mbBtn As Panel
	Private mbActivity As Activity
	Private mbEventName As String
	Private mbModule As Object
	Private mbLabel As Label	
	Private textVisible As Boolean
	Private bgPaint As ABPaint
	Private mbLine As ABExtDrawing
	Private cvs_disabled As Canvas
	Private cvs_normal As Canvas
	Private cvs_pressed As Canvas
	Private lineColor As Int
	Private btnColor As Int
	Private  radius As Double
	Private cvsmbBackground As Canvas
	Private areaRect As Rect

	Public  maxValue As Int
	Public stepValue As Int = 1 'default is 1
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(myActivity As Activity,Module As Object,EventName As String,myLeft As Int,myTop As Int,myWidth As Int,myHeight As Int,myStrokewidth As Double,myStrokecolor As Int,myBtncolor As Int,myTextvisible As Boolean,initValue As Int,myMax As Int) As Object

	mbActivity = myActivity
	mbEventName = EventName
	mbModule = Module
	textVisible = myTextvisible
	maxValue = myMax
	lineColor = myStrokecolor
	btnColor = myBtncolor
	radius = myHeight/2
	
'   *** background ***	
	mbBackground.Initialize("mbBackground")
	mbBackground.color = Colors.Transparent
	mbBackground.Tag ="mbhs"
	mbActivity.AddView(mbBackground,myLeft,myTop,myWidth,myHeight)
	areaRect.Initialize(0,0,mbBackground.Width, mbBackground.Height)
	cvsmbBackground.Initialize(mbBackground)

	bgPaint.Initialize
	bgPaint.SetAntiAlias(True)
	bgPaint.SetStyle(bgPaint.Style_STROKE)
	bgPaint.SetStrokeWidth(myStrokewidth)
	bgPaint.SetAlpha(145)
	bgPaint.SetColor(lineColor)
	mbLine.drawLine(cvsmbBackground,radius, radius, mbBackground.Width-radius, radius, bgPaint)
'   *** end background ***	

'   *** button ***	
	mbBtn.Initialize("mbBtn")
	mbBtn.color = Colors.Transparent

	mbBackground.AddView(mbBtn, 0,0, myHeight, myHeight)

'   *** painting canvas ***	
	Dim btnDrawing As ABExtDrawing
	Dim btnPaint As ABPaint
	btnPaint.Initialize
	btnPaint.SetAntiAlias(True)

'	*** create bitmap disabled ***	
	Dim bmp_disabled As Bitmap
	bmp_disabled.InitializeMutable(myHeight,myHeight)
	cvs_disabled.Initialize2(bmp_disabled)
	btnPaint.SetStyle(btnPaint.Style_FILL)
	btnPaint.SetColor(Colors.RGB(136,136,136))
	btnPaint.SetAlpha(77)
	btnDrawing.drawCircle(cvs_disabled,radius,radius,radius ,btnPaint)
	btnPaint.SetColor(myBtncolor)
	btnPaint.SetAlpha(255)
	btnDrawing.drawCircle(cvs_disabled,radius,radius,myHeight/9 ,btnPaint)


'	*** create bitmap pressed ***	
	Dim bmp_pressed As Bitmap
	bmp_pressed.InitializeMutable(myHeight,myHeight)
	cvs_pressed.Initialize2(bmp_pressed)
	btnPaint.SetStyle(btnPaint.Style_FILL)
	btnPaint.SetColor(myBtncolor)
	btnPaint.SetAlpha(154)
	btnDrawing.drawCircle(cvs_pressed,radius,radius,radius ,btnPaint)
	btnPaint.SetStyle(btnPaint.Style_STROKE)
	btnPaint.SetStrokeWidth(2dip)
	btnDrawing.drawCircle(cvs_pressed,radius,radius,radius-2dip ,btnPaint)
	If myTextvisible = False Then
		btnPaint.SetAlpha(255)
		btnPaint.SetStyle(btnPaint.Style_FILL)
		btnDrawing.drawCircle(cvs_pressed,radius,radius,myHeight/6 ,btnPaint)
	End If
'	*** create bitmap normal ***	
	cvs_normal.Initialize(mbBtn)
	btnPaint.SetStyle(btnPaint.Style_FILL)
	btnPaint.SetColor(myBtncolor)
	btnPaint.SetAlpha(154)
	btnDrawing.drawCircle(cvs_normal,radius,radius,radius ,btnPaint)
'	*** draw center only if no text
	If myTextvisible = False Then
		btnPaint.SetAlpha(255)
		btnDrawing.drawCircle(cvs_normal,radius,radius,myHeight/6 ,btnPaint)
	End If
'   *** end painting canvas ***	

	mbActivity.Invalidate
	
	If textVisible = True Then
		mbLabel.Initialize("")
		mbBtn.AddView(mbLabel,0,0,mbBtn.Width,mbBtn.Height)	
		mbLabel.Gravity = Bit.Or(Gravity.CENTER_HORIZONTAL, Gravity.CENTER_VERTICAL)
		CustomizeText(Colors.White,14,Typeface.DEFAULT)
		mbLabel.Text = returnValue
	End If

	setValue (initValue)

End Sub

Private Sub mbBackground_Touch (Action As Int, X As Float, Y As Float)
	mbBtn.Left = X - radius
	Dim r As Reflector
    r.Target = Sender
    r.RunMethod2("requestDisallowInterceptTouchEvent", True, "java.lang.boolean")
	Select Action
		Case mbActivity.ACTION_DOWN
			mbBtn.SetBackgroundImage(cvs_pressed.Bitmap)
		Case mbActivity.ACTION_UP
			mbBtn.SetBackgroundImage(cvs_normal.Bitmap)
			'setValue(Round(returnValue/stepValue) * stepValue)
	End Select	
' *** check limits ***
			If mbBtn.Left < 0 Then
				mbBtn.Left = 0
			End If
			If (mbBtn.Left + mbBtn.Width) > mbBackground.Width Then
				mbBtn.Left =  mbBackground.Width - mbBtn.Width 	
			End If
' *** clear lines in background ***
		
				
				Redraw_Background(True)
	
			If textVisible = True Then
				mbLabel.Text = returnValue
				If returnValue Mod 10 = 0 Then
					'Sleep(100)
				End If
			End If
			If SubExists(mbModule, mbEventName) Then
				CallSub2(mbModule, mbEventName,returnValue)
			End If
End Sub
Private Sub Redraw_Background(Enabled As Boolean)
	cvsmbBackground.drawRect(areaRect, Colors.Transparent, True, 0)
	mbBackground.Invalidate
	bgPaint.SetColor(lineColor)
	bgPaint.SetAlpha(145)
	mbLine.drawLine(cvsmbBackground, radius, radius, mbBackground.Width - radius, radius, bgPaint)
	If Enabled = True Then
		bgPaint.SetColor(btnColor)
		bgPaint.SetAlpha(255)
			If (textVisible = True) Then
				If mbBtn.Left > radius Then
					mbLine.drawLine(cvsmbBackground, radius, radius, mbBtn.Left, radius, bgPaint)
				End If
			Else
				mbLine.drawLine(cvsmbBackground, radius, radius, mbBtn.Left + radius, radius, bgPaint)
			End If
	End If
End Sub
Public Sub CustomizeText(fontColor As Int,FontSize As Int,myTypeface As Typeface)
	If textVisible = True Then
		mbLabel.Typeface = myTypeface
		mbLabel.TextColor = fontColor
		mbLabel.TextSize = FontSize
	End If	
	End Sub
Public Sub returnValue 
	Return Round(mbBtn.Left /((mbBackground.Width-mbBtn.Width) / maxValue))
End Sub
Public Sub setValue(Value As Int)
	mbBtn.Left = Round (Value * ((mbBackground.Width-mbBtn.Width) / maxValue))
	Redraw_Background(True)
	If textVisible = True Then
		mbLabel.Text = Value
	End If
End Sub
Public Sub Enable
	mbBtn.SetBackgroundImage(cvs_normal.Bitmap)
	Redraw_Background(True)
	mbBackground.Enabled = True
	If textVisible = True Then
		mbLabel.Visible = True
	End If	
End Sub
Public Sub Disable
	mbBtn.SetBackgroundImage(cvs_disabled.Bitmap)
	Redraw_Background(False)
	mbBackground.Enabled = False
	If textVisible = True Then
		mbLabel.Visible = False
	End If
End Sub

Private Sub Sleep1(ms As Long)
Dim now As Long
  If ms > 1000 Then ms =1000  'avoid application not responding error
  now=DateTime.now
  Do Until (DateTime.now>now+ms)
    DoEvents
  Loop
End Sub

Public Sub Freeze
   mbBackground.Enabled = False
   If textVisible = True Then
      mbLabel.Visible = False
   End If
End Sub

Public Sub UnFreeze
   mbBackground.Enabled = True
   If textVisible = True Then
      mbLabel.Visible = True
   End If   
End Sub