B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
Sub Process_Globals
End Sub

Sub LoadImage (Img As ImageView , Link As String)
	Dim Glide As Amir_Glide
	Glide.Initializer.Default
	Dim Defualt As ColorDrawable
	Defualt.Initialize(Colors.RGB(238,238,238),0)
	
	Dim error As BitmapDrawable
	error.Initialize(LoadBitmap(File.DirAssets,"oops.jpg"))
	Dim df_pic As BitmapDrawable
	df_pic.Initialize(LoadBitmap(File.DirAssets,"loding.gif"))
	
	Glide.Load(Link).Apply(Glide.RO.CenterCrop.Placeholder(df_pic)).Into(Img)
'	Glide.Load(Link).ThumbnailRequest(Glide.As.Gif.LoadURI("file:///android_asset/loding.gif")).Apply(Glide.RO.ErrorDrawable(error).CenterInside).Into(Img)
'	Glide.Load(Link).ThumbnailRequest(Glide.As.Gif.LoadURI("file:///android_asset/loding.gif")).Apply(Glide.RO.ErrorDrawable(error).CenterCrop).Into(Img)
	LogColor(Link,Colors.Green)
End Sub

Sub RGB(colorName As String) As Int()
	Dim R = Bit.ParseInt(colorName.SubString2(1, 3), 16) As Int
	Dim G = Bit.ParseInt(colorName.SubString2(3, 5), 16) As Int
	Dim B = Bit.ParseInt(colorName.SubString2(5, 7), 16) As Int
	Return Array As Int(R, G, B)
End Sub

Sub MakeWordsList(txt As String) As List
	Dim word As String
	Dim startindex As Int = 0
	Dim endindex As Int = txt.IndexOf(" ")
	Dim lst As List
	lst.Initialize
	Do While endindex <> -1
		word = txt.SubString2(startindex, endindex)
		If word.Trim <> "" Then
			lst.Add(word.Trim)
		End If
		startindex = endindex
		endindex = txt.IndexOf2(" ", startindex + 1)
	Loop
	''	Log("lst: "&lst)
	Return lst
End Sub

Sub theme_number As Int
	Dim c1 As Cursor
	c1 = Main.sql1.ExecQuery("SELECT * FROM personalsetting")
	c1.Position = 0
'	Log(c1.GetInt("theme"))
	Return c1.GetInt("theme")
	
End Sub

Sub SearchToList(AllItems As List,Items As List,New As String)
	Items.clear
	For i = 0 To AllItems.Size-1
		Dim item As String = AllItems.get(i)
		If item.Contains(New) Then
			Items.Add(item)
		End If
	Next
End Sub

Sub SetStatusBarColor(color As Int)
	Try
		Dim p As Phone
		If p.SdkVersion >= 21 Then
			Dim jo As JavaObject
			jo.InitializeContext
			Dim window As JavaObject = jo.RunMethodJO("getWindow", Null)
			window.RunMethod("addFlags", Array (0x80000000))
			window.RunMethod("clearFlags", Array (0x04000000))
			window.RunMethod("setStatusBarColor", Array(color))
		End If
	Catch
		Log(LastException)
	End Try
  
End Sub
public Sub CountString(SearchMe As String, FindMe As String) As Int
   
	Dim NumFound As Int = 0
   
	Dim P As Int = SearchMe.IndexOf(FindMe)
	Do Until P < 0    'IndexOf functions return -1 if not found
		NumFound = NumFound + 1
		P = SearchMe.IndexOf2(FindMe, P + 1)    'continue search at next char after previous occurrence
	Loop
   
	Return NumFound
   
End Sub


public Sub getLineCount(TargetView As Label) As Int
	Dim su As StringUtils
	Dim OneLineHeight As Long = su.MeasureMultilineTextHeight(TargetView, "T"&Chr(13)&Chr(10)&"T")/2 ' Get the height of two lines, so line spacing is here, divide by 2
	Dim H As Long = su.MeasureMultilineTextHeight(TargetView, TargetView.Text)
	Return(Ceil(H/OneLineHeight))
End Sub



Sub IntToDIP(Integer As Int) As Int
	Dim r As Reflector
	Dim scale As Float
	r.Target = r.GetContext
	r.Target = r.RunMethod("getResources")
	r.Target = r.RunMethod("getDisplayMetrics")
	scale = r.GetField("density")
   
	Dim DIP As Int
	DIP = Integer * scale + 0.5
	Return DIP
End Sub

Sub FullScreen(active As Boolean,ActivityName As String)
	Dim obj1 As Reflector

	obj1.Target = obj1.GetMostCurrent(ActivityName)
	obj1.Target = obj1.RunMethod("getWindow")

	'remove previous parameters
	obj1.RunMethod2("clearFlags",1024,"java.lang.int")
	obj1.RunMethod2("clearFlags",2048,"java.lang.int")

	'add new parameter
	If active Then
		obj1.RunMethod2("addFlags",2048,"java.lang.int")  'FLAG_FORCE_NOT_FULLSCREEN
	Else
		obj1.RunMethod2("addFlags",1024,"java.lang.int")  'FLAG_FULLSCREEN
	End If
End Sub



Public Sub GetColor (Position As Int) As Int
	Dim ColorList As List
	ColorList.Initialize
	ColorList.Add(0xFFe74c3c)
	ColorList.Add(0xFFf1c40f)
	ColorList.Add(0xFF2ecc71)
	ColorList.Add(0xFFe67e22)
	ColorList.Add(0xFF34495e)
	ColorList.Add(0xFF3498db)
	ColorList.Add(0xFF1abc9c)
	ColorList.Add(0xFF9b59b6)
	Do While Position > ColorList.Size-1
		Position = Position - ColorList.Size
	Loop
	Return ColorList.Get(Position)
End Sub


Public Sub GetTextHeight(Label As Label) As Float
	Dim GetHeight As Amir_RVUtils
	Return GetHeight.GetTextHeight(Label,Label.Text)
End Sub

#Region  ' بارگزاری
'Sub ShowLoading(pLoad As Panel,li As LoadingIndicatorView) 'ignore
'	pLoad.Visible = True
'	pLoad.BringToFront
'	li.IndicatorId = 4
'	li.Visible = True
'	li.IndicatorColor = Colors.RGB(34,185,195)
'End Sub
'
'Sub HideLoading(pLoad As Panel,li As LoadingIndicatorView) 'ignore
'	li.Visible = False
'	pLoad.Visible = False
'End Sub
#end Region


'Change ListView divider line color
'Sub SetDivider(lv As ListView, Color As Int, Height As Int) 
'   Dim r As Reflector
'   r.Target = lv
'   Dim CD As ColorDrawable
'   CD.Initialize(Color, 0)
'   r.RunMethod4("setDivider", Array As Object(CD), Array As String("android.graphics.drawable.Drawable"))
'   r.RunMethod2("setDividerHeight", Height, "java.lang.int")
'End Sub

'Change LineSpacing
Sub TextHeight(v As View, txt As String) As Float
	Dim su As StringUtils
	Dim RLabel As Label :RLabel.Initialize("")
	Dim rowheight As Int = su.MeasureMultilineTextHeight(v,txt)
	Dim Obj1 As Reflector
	Obj1.Target = RLabel
	Dim before As Int = Obj1.RunMethod("getLineHeight")    'Get the height of line BEFORE you change it
	Obj1.Target = RLabel
	Obj1.RunMethod3("setLineSpacing", 1, "java.lang.float", 1.7, "java.lang.float")  'Change the space between lines
	Obj1.Target = RLabel
	Dim after As Int = Obj1.RunMethod("getLineHeight")    'Get the height of line AFTER  you change it
	Return ((after * rowheight)/before)
End Sub

Sub WebViewAssetFile_fonttype (FileName As String) As String
	Dim JO As JavaObject
	JO.InitializeStatic("anywheresoftware.b4a.objects.streams.File")
	If JO.GetField("virtualAssetsFolder") = Null Then
		Return "file:///android_asset/" & FileName.ToLowerCase
	Else
		Return "file://" & File.Combine(JO.GetField("virtualAssetsFolder"), _
       JO.RunMethod("getUnpackedVirtualAssetFile", Array As Object(FileName)))
	End If
End Sub

'Remove ScrollView items
'Sub ClearList(sv As ScrollView) 
'	Dim i As Int
'	For i = sv.Panel.NumberOfViews - 1 To 0 Step -1
'		sv.Panel.RemoveViewAt(i)
'	Next
'End Sub

'Search in Label and highlight the result
'Sub SearchAndHighlight(lbl As Label, key As String) As RichString 
'	Dim r1 As RichString
'	r1.Initialize(lbl.Text)
'	Dim positions As List
'	Dim cl As Int = Colors.Red
'	Dim txt As String
'	txt = lbl.Text
'	Dim pos As Int
'	pos = 0
'	positions.Initialize()
'	'''''''''''''''''''''''''''''''''''''
'	pos = txt.IndexOf2(key, pos)
'	positions.Add(pos)
'	Do While pos <> -1 				
'		pos = txt.IndexOf2(key, pos + key.Length)
'		positions.Add(pos)
'	Loop
'				
'	For i = 0 To positions.Size
'		If positions.Get(i) = -1 Then
'			Exit
'		End If
'		r1.Color(cl, positions.Get(i), positions.Get(i) + key.Length)
'	Next
'	'''''''''''''''''''''''''''''''''''''
'	Return r1
'End Sub

'Sub SearchAndHighlight2(lbl As Label, keys As List) As RichString 
'	Dim r1 As RichString
'	r1.Initialize(lbl.Text)
'	Dim positions As List
'	Dim cl As Int = Colors.Red
'	Dim txt, temp As String
'	txt = lbl.Text
'	Dim pos As Int
'	pos = 0
'	positions.Initialize
'	For i = 0 To keys.Size - 1
'		pos = txt.IndexOf2(keys.Get(i), pos)
'		positions.Add(pos)
'		Do While pos <> -1
'			temp = keys.Get(i)
'			pos = txt.IndexOf2(keys.Get(i), pos + temp.Length)
'			positions.Add(pos)
'		Loop
'		For j = 0 To positions.Size
'			If positions.Get(j) = -1 Then
'				Exit
'			End If
'			temp = keys.Get(i)
'			r1.Color(cl, positions.Get(j), positions.Get(j) + temp.Length)
'		Next
'	Next
'	Return r1
'End Sub

'Remove HTML tags from the text
Sub RemoveTags(Text As String) As String 'ignore

    Dim Pattern, Replacement As String
    Dim m As Matcher

    Pattern = "<[^>]*>"
    Replacement = " "

    m = Regex.Matcher2(Pattern, Regex.CASE_INSENSITIVE, Text)

    Dim r As Reflector
    
    r.Target = m
  
    Return r.RunMethod2("replaceAll", Replacement, "java.lang.String")

End Sub

 Sub ColorToHex(clr As Int) As String
	Dim bc As ByteConverter
	Return bc.HexFromBytes(bc.IntsToBytes(Array As Int(clr)))
End Sub
'Convert b4a colorpickerdialog color code to hexadecimal color code
Sub ConvertColors(MyColor As String) As String 'ignore
   Select MyColor
      Case "-16777216"
        Return "#000000"
      Case "-8388608"
        Return "#800000" 
      Case "-29696"
        Return "#f88c00"
      Case "-65281"
        Return "#f800f8" 
      Case "-65536"
        Return "#f80000"
      Case "-3355444"
        Return "#c8ccc8"
      Case "-16744448"
        Return "#008000"
	  Case "-16711809"
        Return "#00fc78"
	  Case "-256"
        Return "#f8fc00"
	  Case "-16711936"
        Return "#00fc00"
	  Case "-1"
        Return "#FFFFFF"
	  Case "-16777088"
        Return "#000080"
	  Case "-12490271"
        Return "#4068e0"
	  Case "-16711681"
        Return "#00fcf8"
	  Case "-16776961"
        Return "#0000f8"
	  
	End Select
End Sub

Sub HideKeyboard 'ignore
	Dim ime2 As IME
	ime2.Initialize("")
	ime2.HideKeyboard
End Sub

Sub GradientDrawable(col0 As Int, col1 As Int, Radius As Float, Style As String) As GradientDrawable 'ignore
	Dim gdw As GradientDrawable
	Dim Cols(2) As Int
	Cols(0) = col0
	Cols(1) = col1
	gdw.Initialize(Style, Cols)
	gdw.CornerRadius = Radius
	Return gdw
End Sub

Sub shortenText(str As String,count As Int) As String 'ignore
	If str.Length > count Then
		str= str.SubString2(0,count) & " ..."
		Return str
	Else
		Return str
	End If
End Sub


Sub DetectLaguge(word As String) As Boolean 'ignore
	Dim uper As String
	uper = word.SubString2(0,3)
	
	If uper.ToLowerCase =uper.ToUpperCase Then
		Return False ' persian
	Else
		Return True ' english
	End If
End Sub

Sub CloseActivities
	Dim jo As JavaObject
	jo.InitializeContext
	jo.RunMethod("finishAffinity", Null)
End Sub



Sub SetTextAndWidth(lbl As Label, txt As String) 'ignore
	Dim bmpTest As Bitmap
	Dim cvsTest As Canvas
	bmpTest.InitializeMutable(1dip, 1dip)
	cvsTest.Initialize2(bmpTest)
	Return cvsTest.MeasureStringWidth(txt, lbl.Typeface, lbl.TextSize) 'ignore
End Sub


Sub SetTextAndHeight(lbl As Label, txt As String) 'ignore
	Dim stu As StringUtils
	Return stu.MeasureMultilineTextHeight(lbl, txt) 'ignore
End Sub

Sub WebViewAssetFile (FileName As String) As String
	Dim jo As JavaObject
	jo.InitializeStatic("anywheresoftware.b4a.objects.streams.File")
	If jo.GetField("virtualAssetsFolder") = Null Then
		Return "file:///android_asset/" & FileName.ToLowerCase
	Else
		Return "file://" & File.Combine(jo.GetField("virtualAssetsFolder"), _
       jo.RunMethod("getUnpackedVirtualAssetFile", Array As Object(FileName)))
	End If
End Sub
Sub ForceRtlSupported4View(View As View)
	Dim jA,jos As JavaObject
	jos.InitializeStatic  ("android.view.View")
	If jA.InitializeStatic  ("android.os.Build$VERSION").GetField ("SDK_INT") > 16 Then
		jA = View
		jA.RunMethod ("setLayoutDirection",Array(jos.GetField ("LAYOUT_DIRECTION_RTL")))
	End If
End Sub
Sub SetPadding(v As View, Left As Int, Top As Int, Right As Int, Bottom As Int)
	Dim jo As JavaObject = v
	jo.RunMethod("setPadding", Array As Object(Left, Top, Right, Bottom))
End Sub

Sub Set_Color(index As Int)
	If Act_library.day_night = "day" Then
	
		Log("----------------->"&index)
		Select Case index
			Case 1
				Main.right_menu_cl =Colors.RGB(225,245,254)
				Main.header_cl = Colors.RGB(17,171,205)
				Main.background_cl =Colors.RGB(22,176,215)
				Main.footer_cl = Colors.RGB(17,171,205)
				Main.activity_cl = Colors.rgb(197,234,245)
				Main.item_cl = Colors.rgb(164,215,232)
				Main.text_cl = Colors.Black
			Case 2
				Main.activity_cl = Colors.White
				Main.header_cl = Colors.rgb(251,243,207)
				Main.footer_cl = (Colors.rgb(251,243,207))
				Main.background_cl = Colors.rgb(249,242,213)
				Main.text_cl = Colors.rgb(140,125,68)
				Main.item_cl = Colors.rgb(252,247,227)
				
				
				Main.right_menu_cl = Colors.rgb(251,243,207)
			Case 3
				Main.right_menu_cl = Colors.rgb(244,245,240)
				Main.header_cl = Colors.rgb(75,105,105)
				Main.background_cl =Colors.rgb(148,180,161)
				Main.footer_cl = (Colors.rgb(75,105,105))
				Main.item_cl = Colors.rgb(244,245,240)
				Main.activity_cl = Colors.White
				Main.text_cl = Colors.Black
			Case 4
				Main.right_menu_cl = Colors.RGB(141,148,176)
				Main.header_cl = Colors.RGB(76,82,104)
				Main.background_cl = Colors.RGB(86,92,124)
				Main.footer_cl = (Colors.RGB(76,82,104))
				Main.activity_cl = Colors.rgb(212,220,249)
				Main.item_cl = Colors.rgb(193,205,243)
				Main.text_cl = Colors.Black
			Case 5
				Main.right_menu_cl =Colors.RGB(217,235,250)
				Main.header_cl =Colors.RGB(0,57,102)
				Main.background_cl =Colors.RGB(10,67,122)
				Main.footer_cl = (Colors.RGB(0,57,102))
				Main.item_cl = Colors.rgb(152,197,230)
				Main.activity_cl = Colors.rgb(185,218,245)
				Main.text_cl = Colors.Black
		End Select
	Else
		Main.right_menu_cl = Colors.rgb(31,48,65)
		Main.header_cl = Colors.rgb(31,48,65)
		Main.background_cl = Colors.rgb(14,22,33)
		Main.footer_cl = (Colors.rgb(31,48,65))
		Main.activity_cl = Colors.rgb(23,33,43)
		Main.item_cl = Colors.rgb(46,53,63)
		Main.text_cl = Colors.White
	End If
End Sub






Sub setFont(TextSize As String,Text As String)As CSBuilder
	Dim CS As CSBuilder
	Return CS.Initialize.Typeface(Typeface.LoadFromAssets("اسم_فونت_درپوشه_فایل")).Size(TextSize).Append(Text).PopAll
End Sub

Public Sub setJustificationMode(target As View)
	Dim GetAndroidPhone As Phone
	If GetAndroidPhone.SdkVersion >= 26 Then
		Dim dirRTL As JavaObject = target
		dirRTL.RunMethod("setJustificationMode",Array(1))
	End If
End Sub

