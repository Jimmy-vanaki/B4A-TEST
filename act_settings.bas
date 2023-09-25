B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=8.8
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: true
	#IncludeTitle: True
#End Region

Sub Process_Globals
	Private TscrollRV As Timer
	Dim countScroll As Int = 1
End Sub

Sub Globals
	Private lbl_home_title As Label
	Private psetting As Panel
	Private svSetting As ScrollView
'	Dim fontlist As List
	Private lbl_sample As Label
'	Dim ics1 As ICOSSeekBar
	
	Private pnl_fontsize As Panel
	Private pnl_fontline As Panel
	Private pnl_fonttype As Panel
	Private btnColorQ As Panel
	Private lblWhiteQ As Label
	Private mpnl As Panel
'	Dim SBT1 As mbHSeekBar
'	Dim SBT2 As mbHSeekBar

	Private sblineFonts As SeekBar
	Private sbsizeFonts As SeekBar
	
	Dim FColor As ColorPickerDialog
	Dim cur As Cursor
	Private pnlcolor1,pnlcolor2,pnlcolor3 As Panel
'	Private imgEnabled3, imgDisabled3, imgEnabled4, imgDisabled4 As ImageView
	Private lblDisplayType1 As RadioButton
	Private lblDisplayType2 As RadioButton
	Dim c1 As ColorDrawable
	Dim c2 As ColorDrawable
	Dim c3 As ColorDrawable
	Private fonttype,fontsize,fontline As String
	Private spFonts As Spinner
	Private lbl_preview As Label
	Private pnl_preview As Panel
	
	
	Public RV_Contentbook As Amir_RecyclerView
'	Private sv_show_RV As ScrollView
	Dim ItemContentbook As List
	Dim GD As GradientDrawable
	Dim pActivity As Panel
	Dim stylebackground,stylefont As String
	Dim statusListView As Int = 0
	Dim minfontline,minfontsize As Int
	Private PnlHeader As Panel
	Dim mv As mv_SystemUI
	Dim amv As Amir_ViewManager
	
	Private Button1 As Button
	Private Button2 As Button
	Private Button3 As Button
	Private Button4 As Button
	Private Button5 As Button
	
	Dim theme_int As Int
	Dim btn_list As List
	Private lbl_back As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("lyt_settings")
	lbl_home_title.Text = "الاعدادات"
	
	minfontline = 24
	minfontsize = 16
	
	theme_int  = Functions.theme_number

	

	load_setting
	LoadpActivity
	Initialize_RV_Contentbook
	loadItemContentbook
	 
	
	active_theme
	If Act_library.day_night = "night" Then
		AppNight
	Else
		theme
	End If
End Sub

Sub AppNight
	PnlHeader.Color = Colors.rgb(31,48,65)
	Activity.Color = Colors.rgb(23,33,43)
	svSetting.Panel.Color = Colors.rgb(23,33,43)
	mpnl.Color = Colors.rgb(46,53,63)
	mv.setNavigationBarColor(Colors.rgb(31,48,65))
	Functions.SetStatusBarColor(0xFF8C8C8C)
End Sub

Sub theme
	
	Log("theme_int :"&theme_int)
	If theme_int = 1 Then
		PnlHeader.Color=Colors.RGB(17,171,205)
		Activity.Color=Colors.RGB(225,245,254)
		svSetting.Panel.Color = Colors.RGB(225,245,254)
		mpnl.Color=Colors.RGB(225,245,254)
		mv.setNavigationBarColor(Colors.RGB(17,171,205))
	Else if theme_int = 2 Then
		PnlHeader.Color = Colors.rgb(251,243,207)
		Activity.Color = Colors.White
		svSetting.Panel.Color = Colors.rgb(253,250,235)
		mpnl.Color = Colors.rgb(251,243,207)
		mv.setNavigationBarColor((Colors.rgb(251,243,207)))
		lbl_back.TextColor = Colors.rgb(140,125,68)
		lbl_home_title.TextColor = Colors.rgb(140,125,68)
		
	Else if theme_int = 3 Then
		PnlHeader.Color=Colors.rgb(75,105,105)
		Activity.Color=Colors.rgb(148,179,161)
		svSetting.Panel.Color = Colors.rgb(148,179,161)
		mpnl.Color=Colors.rgb(242,245,238)
		mv.setNavigationBarColor(Colors.rgb(75,105,105))
	Else if theme_int = 4 Then
		PnlHeader.Color=Colors.RGB(76,82,104)
		Activity.Color=Colors.RGB(141,148,176)
		svSetting.Panel.Color = Colors.RGB(141,148,176)
		mpnl.Color=Colors.RGB(141,148,176)
		mv.setNavigationBarColor(Colors.RGB(76,82,104))
	Else if theme_int = 5 Then
		PnlHeader.Color=Colors.RGB(0,57,102)
		Activity.Color=Colors.RGB(217,235,250)
		svSetting.Panel.Color = Colors.RGB(217,235,250)
		mpnl.Color=Colors.RGB(217,235,250)
		mv.setNavigationBarColor(Colors.RGB(0,57,102))
	End If
	
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub LoadpActivity
'	pActivity.Initialize("")
'	mpnl.AddView(pActivity,0,505dip,100%x,160dip)
	pActivity.Color = Colors.Transparent
	pActivity.SendToBack
	
End Sub

Sub lbl_back_Click
	Activity.Finish
	StartActivity(Act_library)
End Sub

#Region  settings

Public Sub load_setting
	psetting.Initialize("psetting")
	svSetting.Panel.AddView(psetting,0,0,100%x,-2)
	psetting.LoadLayout("list_setting")
	
	btn_list.Initialize
	btn_list.Clear
	btn_list.AddAll(Array(Button1,Button2,Button3,Button4,Button5))
	
	For i =0 To btn_list.Size-1
		Dim btn_tag As Button
		btn_tag =btn_list.Get(i)
		btn_tag.Tag = i+1
	Next
	refresh_button
'	Button1_Click
	
	'////////////////////// settings ////////////////

	cur = Main.sql1.ExecQuery("SELECT * FROM personalsetting")
	cur.Position = 0
	
	
	spFonts.Add("طاهر")
	spFonts.Add("البهيج")
	spFonts.Add("دجلة")
	
	Select cur.GetString("fonttype")
		Case 0
			fonttype ="lotus-light.ttf"
			spFonts.SelectedIndex = 0
		Case 1
			fonttype = "bahij_muna-bold.ttf"
			spFonts.SelectedIndex = 1
		Case 2
			fonttype ="dijalhregular.ttf"
			spFonts.SelectedIndex = 2
	End Select

'	btnColorQ.Color = cur.GetString("fontcolorQ")
'	lblWhiteQ.TextColor = cur.GetString("fontcolorQ")

	Dim c As ColorDrawable
	If cur.GetString("fontcolor") = "#2E353F" Then
		c.Initialize2(Colors.rgb(46,53,63),35dip,3dip,Colors.Red)
		pnlcolor1.Background = c
	Else If cur.GetString("fontcolor") = "#ffffff" Then
		c.Initialize2(Colors.RGB(255,255,255),35dip,3dip,Colors.Red)
		pnlcolor3.Background = c
	Else If cur.GetString("fontcolor") = "#FAF3DA" Then
		c.Initialize2(Colors.RGB(219,207,181),35dip,3dip,Colors.Red)
		pnlcolor2.Background = c
	End If
	

'	If  cur.GetString("notification") = 1 Then
'		ch_noti.Checked = True
'	Else
'		ch_noti.Checked = False
'	End If
	Log("fonttype"&cur.GetString("fonttype"))
	Select cur.GetString("fonttype")
		Case 0
			fonttype ="lotus-light.ttf"
		Case 1
			fonttype = "bahij_muna-bold.ttf"
		Case 2
			fonttype ="dijalhregular.ttf"
	End Select
	
	sbsizeFonts.Max = 12
	sbsizeFonts.Value = cur.GetString("fontsize") - minfontsize
	
	sblineFonts.Max= 6
	sblineFonts.Value = cur.GetString("fontline") - minfontline
	
	stylefont = Functions.ConvertColors(cur.GetString("fontcolorQ"))
	stylebackground = cur.GetString("fontcolor")
	statusListView =  cur.GetString("displaytype")
	
	If cur.GetString("displaytype") = 1 Then
		lblDisplayType1.Checked = True
		lblDisplayType2.Checked = False
'		imgEnabled3.Visible = False
'		imgDisabled3.Visible = True
'		imgEnabled4.Visible = True
'		imgDisabled4.Visible = False
	Else
		lblDisplayType2.Checked = True
		lblDisplayType1.Checked = False
'		imgEnabled3.Visible = True
'		imgDisabled3.Visible = False
'		imgEnabled4.Visible = False
'		imgDisabled4.Visible = True
	End If
	
	
'	imgDisabled3.Top = lblDisplayType1.Top+ 2%y
'	imgEnabled3.Top = imgDisabled3.Top
	
	
'	imgDisabled4.Top = lblDisplayType2.Top+ 2%y
'	imgEnabled4.Top = imgDisabled4.Top
	
	svSetting.Panel.Height = mpnl.Height+5%y
	cur.Close
End Sub


'Sub ics1_ValueChanged(Value As Int , FromUser As Boolean)
'	lbl_sample.Typeface = Typeface.LoadFromAssets(fontlist.Get(Value))
'	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fonttype="&Value&"")
'End Sub

Sub spFonts_ItemClick (Position As Int, Value As Object)
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fonttype="&Position&"")
	
	Select Position
		Case 0
			fonttype ="lotus-light.ttf"
		Case 1
			fonttype = "bahij_muna-bold.ttf"
		Case 2
			fonttype ="dijalhregular.ttf"
	End Select
	
	lbl_preview.Typeface= Typeface.LoadFromAssets(fonttype)
	
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub


Sub btnColorQ_Click
	FColor.Show("اختيار اللون المطلوب", "اختيار", "الغاء", "", Null)
	If FColor.Response = -1 Then
		btnColorQ.Color = FColor.RGB
		lblWhiteQ.TextColor = FColor.RGB
		Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontcolorQ=" & FColor.RGB)
	End If
End Sub



Sub sbsizeFonts_ValueChanged (Value As Int, UserChanged As Boolean)

	
	If UserChanged = True Then
		fontsize = Value + minfontsize
		Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontsize="&fontsize)
		Log("UPDATE personalsetting SET fontsize="&fontsize)
		If RV_Contentbook.IsInitialized Then
			If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
		End If
		
	End If
End Sub

Sub lblsizeleft_Click
	Log("lblsizeleft")
	sbsizeFonts.Value = sbsizeFonts.Value+1
	fontsize = sbsizeFonts.Value + minfontsize
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontsize="&fontsize)
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub lblsizeright_Click
	Log("lblsizeright")
	sbsizeFonts.Value = sbsizeFonts.Value-1
	fontsize =sbsizeFonts.Value + minfontsize
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontsize="&fontsize)
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
	Log("value :" &sbsizeFonts.Value)
End Sub

Sub sblineFonts_ValueChanged (Value As Int, UserChanged As Boolean)
	Log("sblineFonts: "&Value)
	Log("UserChanged: "&UserChanged)
	If UserChanged = True Then
		fontline = Value + minfontline
		Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontline="&fontline)
		Log("UPDATE personalsetting SET fontline="&fontline)
		If RV_Contentbook.IsInitialized Then
			If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
		End If
		
	End If
End Sub

Sub lbllinespaceL_Click
	Log("lbllinespaceL")
	sblineFonts.Value = sblineFonts.Value+1
	fontline = sblineFonts.Value + minfontline
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontline="&fontline)
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub lbllinespaceR_Click
	Log("lbllinespaceR")
	sblineFonts.Value = sblineFonts.Value-1
	fontline = sblineFonts.Value + minfontline
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontline="&fontline)
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
	
End Sub


Sub SBT2_Click(returnValue)
	Log(returnValue)
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontline=" & (returnValue + 5))
'	lbl_preview.Typeface= Typeface.LoadFromAssets(fonttype)

	fontline = returnValue + 20
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub SBT_Click(returnValue)
	Log(returnValue)
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontsize=" & (returnValue + 5))
	lbl_preview.TextSize= returnValue + 5
	
	fontsize = returnValue + 5
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub


Sub lblDisplayType1_Click
	Log(11)
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET displaytype='1'")
'	imgEnabled4.Visible = True
'	imgDisabled4.Visible = False
'	imgEnabled3.Visible = False
'	imgDisabled3.Visible = True
	
	statusListView = 1
	
	RV_Contentbook.RemoveView
	Initialize_RV_Contentbook
	
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub lblDisplayType2_Click
	Log(22)
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET displaytype='0'")
'	imgEnabled3.Visible = True
'	imgDisabled3.Visible = False
'	imgEnabled4.Visible = False
'	imgDisabled4.Visible = True
	
	statusListView = 0
	
	RV_Contentbook.RemoveView
	Initialize_RV_Contentbook
	
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub






Sub pnlcolor1_Click
	stylebackground="#2E353F"
	stylefont="#fff"
	
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontcolor='#2E353F',fontcolorQ='-1'  ")
	c1.Initialize2(Colors.rgb(46,53,63),35dip,3dip,Colors.Red)
	pnlcolor1.Background = c1
	
	c2.Initialize2(Colors.RGB(219,207,181),35dip,1dip,Colors.RGB(255,196,182))
	pnlcolor2.Background = c2
	c3.Initialize2(Colors.RGB(255,255,255),35dip,1dip,Colors.RGB(218,218,218))
	pnlcolor3.Background = c3
	
	pnl_preview.Color=Colors.Black
	lbl_preview.TextColor=Colors.White
	
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub pnlcolor2_Click
	stylebackground="#FAF3DA"
	stylefont="#000"
	
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontcolor='#FAF3DA',fontcolorQ='-16777216'  ")
	c2.Initialize2(Colors.RGB(219,207,181),35dip,3dip,Colors.Red)
	pnlcolor2.Background = c2
	
	
	c1.Initialize2(Colors.rgb(46,53,63),35dip,1dip,Colors.RGB(218,218,218))
	pnlcolor1.Background = c1
	c3.Initialize2(Colors.RGB(255,255,255),35dip,1dip,Colors.RGB(218,218,218))
	pnlcolor3.Background = c3
	
	pnl_preview.Color=Colors.RGB(219,207,181)
	lbl_preview.TextColor=Colors.Black
	
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub pnlcolor3_Click
	stylebackground="#ffffff"
	stylefont="#000"
	
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontcolor='#fff',fontcolorQ='-16777216'  ")
	c3.Initialize2(Colors.RGB(255,255,255),35dip,3dip,Colors.Red)
	pnlcolor3.Background = c3
	
	c1.Initialize2(Colors.rgb(46,53,63),35dip,1dip,Colors.RGB(218,218,218))
	pnlcolor1.Background = c1
	c2.Initialize2(Colors.RGB(219,207,181),35dip,1dip,Colors.RGB(255,196,182))
	pnlcolor2.Background = c2
	
	pnl_preview.Color=Colors.White
	lbl_preview.TextColor=Colors.Black
	
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub
#End Region







#Region RV_Contentbook

Sub loadItemContentbook
	ItemContentbook.Initialize
	
	Dim text As String
	text = "بسم الله الرحمن الرحيم <br/>الحمد لله رب العالمين والصلاة والسلام على سيدنا محمد وعلى آله الطيبين الطاهرين"
	ItemContentbook.Add(CreateMap("id":"1","Description":text))
	ItemContentbook.Add(CreateMap("id":"2","Description":text))

	TscrollRV.Initialize("TscrollRV", 3000)
	TscrollRV.Enabled = True


End Sub

Sub TscrollRV_Tick
	
'	Log("count1: "&countScroll)
	If countScroll=1 Then
		RV_Contentbook.SmoothScrollToPosition2(countScroll,15000,13000)
		countScroll=countScroll-1
	Else
		RV_Contentbook.SmoothScrollToPosition2(countScroll,15000,13000)
		countScroll=countScroll+1
	End If
'	Log("count2: "&countScroll)
'	TscrollRV.Enabled = False
End Sub

Public Sub Initialize_RV_Contentbook
	
	If statusListView = 0 Then
		RV_Contentbook.Initializer("RV_Contentbook").ListView.Vertical.Build
	Else
		RV_Contentbook.Initializer("RV_Contentbook").ListView.Horizontal.Build
		RV_Contentbook.LinearSnapHelper2(Gravity.LEFT,False)
	End If
			

	pActivity.AddView(RV_Contentbook,0,0,100%x,150dip)
	RV_Contentbook.ScrollToEndListener(True)
	RV_Contentbook.SendToBack
	RV_Contentbook.LayoutDirection=RV_Contentbook.LAYOUT_DIRECTION_RTL
	RV_Contentbook.DefaultAdapter


	RV_Contentbook.ScrollSettings.OverScrollMode= _
	RV_Contentbook.ScrollSettings.OVER_SCROLL_NEVER

End Sub



Sub RV_Contentbook_onCreateViewHolder (Parentt As Panel,ViewType As Int)
	Card_ListBook_OnCreate(Parentt,RV_Contentbook.LayoutSpanCount)
End Sub

Sub RV_Contentbook_onBindViewHolder (Parentt As Panel,Position As Int)
	Card_ListBook_OnBind(Parentt,ItemContentbook.Get(Position),Position)
End Sub

Sub RV_Contentbook_GetItemCount As Int
'	Log("Size: "&ItemContentbook.Size)
	Return ItemContentbook.Size
End Sub

Sub RV_Contentbook_DividerColor (Position As Int) As Int
	Return  Functions.GetColor(Position)
End Sub

Sub RV_Contentbook_DividerLeftMargin (Position As Int) As Int
	Return Position * 16dip
End Sub

Sub RV_Contentbook_DividerRightMargin (Position As Int) As Int
	Return Position * 16dip
End Sub

Sub RV_Contentbook_onScrolledToEnd
'	Log("End of List")
End Sub

Sub RV_Contentbook_onScrollStateChanged (NewState As Int)
'	Log("NewState: "&NewState)
End Sub

Sub RV_Contentbook_onScrolled (Dx As Int,Dy As Int)
'	Log("Dx  "&Dx)
'	Log("Dy "&Dy)
	If Dy>0 Then
'		LogColor("Dy>0 ",Colors.Magenta)
'		RTLSeekBar.Value = RTLSeekBar.Value-1
	Else
'		LogColor("Dy<0 ",Colors.red)
'		RTLSeekBar.Value = RTLSeekBar.Value+1
	End If
End Sub

Sub RV_Contentbook_onUpdateViews (Item As Object,Position As Int)
	Log("Position: "&Position)
End Sub

Public Sub Card_ListBook_OnCreate (Holder As Panel, Span As Int)
	Holder.Height = 100dip
	Dim SectionHolder As Panel
	SectionHolder.Initialize("SectionHolder")
	Holder.AddView(SectionHolder,0dip,6dip,Holder.Width,98dip)
'	GD.Initialize("TOP_BOTTOM",Array As Int (Colors.Black,Colors.Black))
'	GD.CornerRadius = 4dip
'	SectionHolder.Background = GD
'	SectionHolder.Elevation = 2dip
	

	Dim wvdescription As WebView
	wvdescription.Initialize("wvdescription")
	SectionHolder.AddView(wvdescription,5dip,0,100%x-45dip,150dip)
	wvdescription.ZoomEnabled=False
	wvdescription.JavaScriptEnabled=False
	Dim g As GestureDetector
	g.SetOnGestureListener(wvdescription, "wvdescription")



	Dim Hedescription As Label
	Hedescription.Initialize("Hedescription")
	SectionHolder.AddView(Hedescription,8dip,8dip,100%x-50dip,80dip)

End Sub



Public Sub Card_ListBook_OnBind (Holder As Panel, Data As Map, Position As Int)
	Dim SectionHolder = Holder.GetView(0) As Panel
	Dim wvdescription = SectionHolder.GetView(0) As WebView
	Dim Hedescription = SectionHolder.GetView(1) As Label


	Dim txt As String
	
	
	Log("stylebackground  "& stylebackground)
	txt =  "<style>@font-face {font-family: samim;src: url(' " & WebViewAssetFile_fonttype(fonttype) & " ') format('truetype');}p{padding:0;margin:0}* {font-family:samim !important;font-size:"&fontsize&"px !important;line-height:"&fontline&"px !important;direction: rtl;text-align:justify;}body{background-color:"&stylebackground&"}</style>"& _
	 "<div style='font-family:samim;line-height: 25px;direction: rtl;padding: 5px;text-align:justify;color:"&stylefont&"'>" &Data.Get("Description")&"<br/><div style='text-align:center'>"&Data.Get("id")& "</div></div><br><br>"
	
	wvdescription.LoadHtml(txt)
	Hedescription.Text = Data.Get("Description")
	Hedescription.Visible = False

	
	Holder.Height = wvdescription.Height
	SectionHolder.Height = wvdescription.Height
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
#End Region

Sub active_theme
	If theme_int = 1 Then
		amv.Initialize(Button1)
		amv.BackgroundColor = Colors.RGB(17,171,205)
		amv.StrokeWidth =2
		amv.StrokeColor =  Colors.Red
		amv.Radius = 50
		amv.Start
	Else if  theme_int = 2 Then
		amv.Initialize(Button2)
		amv.BackgroundColor = Colors.RGB(103,76,25)
		amv.StrokeWidth =2
		amv.StrokeColor =  Colors.Red
		amv.Radius = 50
		amv.Start
	Else if  theme_int = 3 Then
		amv.Initialize(Button3)
		amv.BackgroundColor =  Colors.rgb(75,105,105)
		amv.StrokeWidth =2
		amv.StrokeColor =  Colors.Red
		amv.Radius = 50
		amv.Start
	Else if  theme_int = 4 Then
		amv.Initialize(Button4)
		amv.BackgroundColor =Colors.RGB(77,86,104)
		amv.StrokeWidth =2
		amv.StrokeColor =  Colors.Red
		amv.Radius = 50
		amv.Start
	Else if  theme_int = 5 Then
		amv.Initialize(Button5)
		amv.BackgroundColor = Colors.RGB(0,57,102)
		amv.StrokeWidth =2
		amv.StrokeColor =  Colors.Red
		amv.Radius = 50
		amv.Start
	End If
End Sub

Sub refresh_button
	
	For i =0 To btn_list.Size-1
		amv.Initialize(btn_list.Get(i))
		If i=0 Then
			amv.BackgroundColor = Colors.RGB(17,171,205)
		Else If i = 1 Then
			amv.BackgroundColor = Colors.RGB(103,76,25)
		Else If i = 2 Then
			amv.BackgroundColor = Colors.RGB(1,99,102)
		Else If i = 3 Then
			amv.BackgroundColor = Colors.RGB(77,86,104)
		Else If i = 4 Then
			amv.BackgroundColor = Colors.RGB(0,57,102)
		End If
		amv.StrokeWidth =1
		amv.StrokeColor =  Colors.Black
		amv.Radius = 50
		amv.Start
	Next

End Sub

Sub Button1_Click
	If Act_library.day_night <> "day" Then
		Act_library.day_night = "day"
	End If
	Dim btn_sender As Button
	btn_sender = Sender
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET theme = "& btn_sender.Tag )
	refresh_button

	If btn_sender.Tag = "1" Then
		amv.Initialize(Button1)
		amv.BackgroundColor = Colors.RGB(17,171,205)
		amv.StrokeWidth =2
		amv.StrokeColor =  Colors.Red
		amv.Radius = 50
		amv.Start
	Else if  btn_sender.Tag = "2" Then
		amv.Initialize(Button2)
		amv.BackgroundColor = Colors.RGB(103,76,25)
		amv.StrokeWidth =2
		amv.StrokeColor =  Colors.Red
		amv.Radius = 50
		amv.Start
	Else if  btn_sender.Tag = "3" Then
		amv.Initialize(Button3)
		amv.BackgroundColor =  Colors.RGB(1,99,102)
		amv.StrokeWidth =2
		amv.StrokeColor =  Colors.Red
		amv.Radius = 50
		amv.Start
	Else if  btn_sender.Tag = "4" Then
		amv.Initialize(Button4)
		amv.BackgroundColor = Colors.RGB(77,86,104)
		amv.StrokeWidth =2
		amv.StrokeColor =  Colors.Red
		amv.Radius = 50
		amv.Start
	Else if  btn_sender.Tag = "5" Then
		amv.Initialize(Button5)
		amv.BackgroundColor = Colors.RGB(0,57,102)
		amv.StrokeWidth =2
		amv.StrokeColor =  Colors.Red
		amv.Radius = 50
		amv.Start
	End If
	
	theme_int  = Functions.theme_number
	theme
End Sub

Private Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode=KeyCodes.KEYCODE_BACK  Then
		lbl_back_Click
		Return True
	End If
	Return False
End Sub