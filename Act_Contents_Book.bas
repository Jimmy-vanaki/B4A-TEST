B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=8.8
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: true
	#IncludeTitle: false
#End Region

Sub Process_Globals
	Dim statusListView As Int
	Dim Idbook As Int
	Dim Idpage As Int
	Dim search_list As List
	Dim book_name As String
	Dim tag As Int
	Dim time11 As Timer
	Dim time1 As Timer
	Dim time As Timer
	Dim old_page_num As Int
End Sub

Sub Globals
	Dim lblfavorite As Label
	Dim PnlHeader As Panel
	Public RV_Contentbook As Amir_RecyclerView
	Dim ItemContentbook As List
	Dim text As String
	
	
	Dim ClickFull As Boolean
	ClickFull = True
	Dim stylebackground,stylefont As String

'	Dim GD As GradientDrawable
	
	Private cr_page As Cursor

	Dim lblTitleBook As Label
	Dim PnlFooter As Panel
	Dim rs As RichString

	
	Dim lastpage , firstpage As Int
	Dim mnuPanelAnimation As ICOSSlideAnimation 'ignore
	Dim pnl_settings As Panel
	Dim pnl_search As Panel
	Dim edsearch As EditText
	Dim btnsearch As Label
	Private sblineFonts As SeekBar
	Private sbsizeFonts As SeekBar
	Private pnlcolor1,pnlcolor2,pnlcolor3 As Panel
	Private fonttype,fontsize,fontline As String
	
	Dim c1 As ColorDrawable
	Dim c2 As ColorDrawable
	Dim c3 As ColorDrawable
	
	Dim RTLSeekBar As SeekBar
	Private spFonts As Spinner
	Dim iconlistcontent As Label
	Dim settingsCur As Cursor
	Dim minfontline , minfontsize As Int
	Dim lbllast As Label
	Dim mv As mv_SystemUI
	Dim userQuery As String
	Dim user_change As Boolean
	
'	//////// 
	Dim WebView As WebView
	Dim WebViewExtras1 As WebViewExtras
	Dim page_content As String
	Dim cr_setting As Cursor
	Dim cr As Cursor
'	Dim timer_load_more As Timer
	
'	Ehsan Var

	
'	///////////search
	Dim pnl_move As Panel
	Dim map_counter As Map
	Dim search_move As Boolean = False
	Dim m1 As Map
	
	
	Dim SpinKitView1 As SpinKitView
	Dim loading As SpinKitView
	Dim lbl_mesage As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Functions.Set_Color(Functions.theme_number)
	Activity.Color= Main.activity_cl
	
	lbl_mesage.Initialize("")
	lbl_mesage.Text = "التحقق من المزامنة.."
	lbl_mesage.Typeface = Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	lbl_mesage.TextColor = Main.text_cl
	lbl_mesage.TextSize = 15
	lbl_mesage.Gravity = Gravity.CENTER
	Activity.AddView (lbl_mesage,25%x,52%y,50%x,10%y)
	lbl_mesage.BringToFront
	lbl_mesage.Visible = True
	
	loading.Initialize("")
	loading.SpinKitType = loading.THREE_BOUNCE
	loading.SpinKitColor = Main.text_cl
	Activity.AddView (loading,45%x,45%y,10%x,10%y)
	loading.BringToFront
	loading.Visible = True

	time11.Initialize("time11",500)
	time11.Enabled = True

End Sub

Sub time11_Tick
	Activity.RemoveAllViews

	Log(Idbook)
'	sql.Initialize(File.DirInternal&"/download"& Main.OfflineSoundsFolderPath,"b"&Idbook&".sqlite",False)
	
	
	loadsearch
	InitializeHeader
	GetFirstAndLastPageId
	
	loadstyle
	
	Dim load As SpinKitView
	load.Initialize(5)
	load.Visible = True
	load.SpinKitColor = Colors.RGB(255,255,255)
	load.SpinKitType = load.FADING_CIRCLE
	load.goForIt
	Activity.AddView(load,45%x,50%y-5%x,10%x,10%x)
	InitializeFooter

	loadItemContentbook(Idbook)
	Initialize_RV_Contentbook
	load.Visible = False
	
	
	GetSettings
	Log(search_list.Size)
	If search_list.Size <> 0 Then
		create_movepnl
	End If
	
	Set_theme
	If act_search.isFromSearch And statusListView = 1 Then
		m1 = search_list.Get(tag)
		RV_Contentbook.ScrollToPosition(m1.Get("id"))
		RTLSeekBar.Value = m1.Get("id")
	End If
	
	
	If act_listcontent.listcontent_page And statusListView = 1 Then
		RV_Contentbook.ScrollToPosition(Idpage-1)
	End If
	
	
	time11.Enabled = False
	loading.Visible = False
	
End Sub

Sub Activity_Resume
	
End Sub

Sub Activity_Pause (UserClosed As Boolean)


End Sub

#Region list-search

Sub create_movepnl
	LogColor(tag,Colors.Yellow)
	map_counter.Initialize
	pnl_move.Initialize("")
	m1 = search_list.Get(tag)
'	old_bid = m1.Get("book_id")
	old_page_num = m1.Get("id")
'	make_serach_item(m1.Get("bid"),m1.Get("id"))
	
	Activity.AddView(pnl_move,(50%x-50dip),88%y,100dip,40dip)
	Dim btn_next As Label : btn_next.Initialize("btn_next") : btn_next.color = Colors.white : btn_next.text = Chr(0xF064) : btn_next.textcolor = Colors.gray
	Dim btn_prev As Label : btn_prev.Initialize("btn_prev") : btn_prev.color = Colors.white : btn_prev.text = Chr(0xF112) : btn_prev.textcolor = Colors.gray
	btn_next.Typeface = Typeface.FONTAWESOME
	btn_prev.Typeface = Typeface.FONTAWESOME
'	btn_next.Color = Colors.White
'	btn_prev.Color = Colors.White
	btn_prev.Gravity = Gravity.CENTER
	btn_next.Gravity = Gravity.CENTER
	btn_next.TextSize = 25
	btn_prev.TextSize = 25
	btn_next.Color = Colors.Blue
	btn_prev.Color = Colors.Red
	Dim avm As Amir_ViewManager
	avm.Initialize(btn_next)
	avm.BottomRightRadius = 20
	avm.TopRightRadius = 20
	avm.BackgroundColor = Colors.LightGray
	avm.TextColor = Colors.Gray
	avm.TextPressedColor =Colors.Gray
	avm.BackgroundPressedColor = Colors.LightGray
	avm.Start
	Dim avm As Amir_ViewManager
	avm.Initialize(btn_prev)
	avm.BottomLeftRadius = 20
	avm.TopLeftRadius = 20
	avm.BackgroundColor = Colors.LightGray
	avm.TextColor = Colors.Gray
	avm.TextPressedColor =Colors.Gray
	avm.BackgroundPressedColor = Colors.LightGray
	avm.Start
	pnl_move.AddView(btn_prev,5dip,5dip,40dip,30dip)
	pnl_move.AddView(btn_next,55dip,5dip,40dip,30dip)
End Sub

Sub make_serach_item (bookid As Int , page1 As Int )
	search_move = True
	map_counter = search_list.Get(page1)
	Dim main_id As Int
	main_id = (map_counter.Get("id"))
	LogColor(main_id,Colors.Yellow)
	
	If statusListView = 1 Then
		RV_Contentbook.ScrollToPosition(main_id-1)
		If RV_Contentbook.IsInitialized Then
			If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
		End If
	Else
		WebViewExtras1.executeJavascript(WebView,"window.scrollTo(0, 0);var y = getOffset( document.getElementById('book-mark_"&(main_id-1)&"') ).top;window.scrollTo(0, y); initAndSetupTheSliders("&(main_id)&");")
	
	End If

	
	old_page_num = main_id
End Sub

Sub  btn_prev_Click
	act_listcontent.listcontent_page = False
	If tag > -1 Then
		tag = tag-1
	End If

	LogColor(tag,Colors.Yellow)
	LogColor("search_list.Size   ::"&search_list.Size,Colors.Yellow)
	If  tag > 0 Or tag =0 Then
		m1 = search_list.Get(tag)
		Log("-----------------book_id :::"&Idbook)
'		If act_search.isFromSearch = False Then
			make_serach_item(Idbook,tag)
'		End If
		
	Else
		ToastMessageShow("لا توجد نتائج سابقة",False)
	End If
End Sub

Sub  btn_next_Click
	act_listcontent.listcontent_page = False
	Log("tag________----------------->"&tag)
	If tag < search_list.Size Then
		tag = tag+1
	End If
	
	If tag < search_list.Size  Then
		m1 = search_list.Get(tag)
		Log("-----------------"&m1.Get("main_id"))
'		If act_search.isFromSearch = False Then
			make_serach_item(Idbook,tag)
'		End If
	Else
		ToastMessageShow("لا توجد نتائج اضافية",False)
	End If
	
End Sub

#End Region

Sub Set_theme
	
'	PnlHeader.Color = Main.header_cl
	Activity.Color = Main.activity_cl
	If statusListView = 0 Then
		PnlFooter.Color = Colors.Transparent
	Else
		PnlFooter.Color = Main.footer_cl
	End If
	mv.setNavigationBarColor(Main.footer_cl)
	mv.setStatusBarColor(Main.header_cl)
	If Act_library.day_night = "night" Then
		stylebackground= "#000000"
		stylefont="#ffffff"
	End If
End Sub

Sub GetSettings
	settingsCur = Main.sql1.ExecQuery("SELECT * FROM personalsetting")
	settingsCur.Position = 0
	
	Select settingsCur.GetString("fonttype")
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
	
	minfontline = 24
	minfontsize = 17
	
	
	stylefont = Functions.ConvertColors(settingsCur.GetString("fontcolorQ"))
	stylebackground = settingsCur.GetString("fontcolor")
	fontsize = settingsCur.GetInt("fontsize")
	sbsizeFonts.Value = fontsize - minfontsize
	
	fontline = settingsCur.GetInt("fontline")


	sblineFonts.Value = fontline - minfontline
	statusListView = settingsCur.GetString("displaytype")

	Dim c As ColorDrawable
	If settingsCur.GetString("fontcolor") = "#000" Then
		c.Initialize2(Colors.rgb(46,53,63),35dip,3dip,Colors.Red)
		pnlcolor1.Background = c
	Else If settingsCur.GetString("fontcolor") = "#fff" Then
		c.Initialize2(Colors.RGB(255,255,255),35dip,3dip,Colors.Red)
		pnlcolor3.Background = c
	Else If settingsCur.GetString("fontcolor") = "#FAF3DA" Then
		c.Initialize2(Colors.RGB(219,207,181),35dip,3dip,Colors.Red)
		pnlcolor2.Background = c
	End If

End Sub

Sub style_Click
	Log("style "&pnl_settings.Visible)
	
	If statusListView = 1 Then
		
		If pnl_settings.Visible = True Then
			hidesettings
		Else
			pnl_settings.Top = 25%y
			pnl_settings.Visible = True
			mnuPanelAnimation.SlideFromBottom("ic",600,400)
			mnuPanelAnimation.StartAnim(pnl_settings)
			
		End If
	Else
		WebViewExtras1.executeJavascript(WebView,"function clear_classbg() {$('.set_bg').removeClass('bg-active');}$('.set_bg').each(function (index) {clear_classbg();switch ('"&cr_setting.GetString("bg_color")&"') {case '#ffffff':$('#bg-white').addClass('bg-active');break;case '#ebdca4':$('#bg-cream').addClass('bg-active');break;case '#2e353f' :$('#bg-black').addClass('bg-active');break;}});")
		WebViewExtras1.executeJavascript(WebView,"$('.radio-label').removeClass('active-font');  switch('"&cr_setting.GetInt("font_type")&"')  {case '0': $('.marker').css('top', '7px'); document.getElementById('font1').classList.add('active-font');  break;   case '1': $('.marker').css('top', '45px');  document.getElementById('font2').classList.add('active-font');break;   case '2': $('.marker').css('top', '81px'); document.getElementById('font3').classList.add('active-font');  break;  }")
		WebViewExtras1.executeJavascript(WebView,$"$(".overlay-setting").addClass("show_setting");"$)
	End If
End Sub

Sub BackClick_Click
	If act_search.isFromSearch Then
		StartActivity(act_search)
	Else if act_listcontent.Is_ListContent Then
		search_list.Clear
		act_listcontent.Is_ListContent =False
		StartActivity(act_listcontent)
	Else
		search_list.Clear
		StartActivity(Act_library)
	End If

	time.Enabled = False

	Activity.Finish
	If pnl_move.IsInitialized Then
		pnl_move.Visible = False
		Log("working!!!")
	End If
End Sub

Private Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode=KeyCodes.KEYCODE_BACK  Then
		If pnl_settings.IsInitialized And pnl_settings.Visible Then
			pnl_settings.Visible = False
		Else
			BackClick_Click
		End If
		
		Return True
	End If
	Return False
End Sub

Sub loadsearch
	
	pnl_search.Initialize("pnl_search")
	Activity.AddView(pnl_search,0,0,100%x,52dip)
	pnl_search.Visible = False
	pnl_search.Color= Main.header_cl
	btnsearch.Initialize("btnsearch")
	edsearch.Initialize("edsearch")
	pnl_search.AddView(edsearch,56dip,3dip,pnl_search.Width-61dip,pnl_search.Height-6dip)
	pnl_search.AddView(btnsearch,3dip,3dip,55dip,pnl_search.Height-6dip)
	
	btnsearch.Gravity =Gravity.CENTER
	btnsearch.TextSize = 25
	btnsearch.TextColor = Colors.White
	btnsearch.Typeface = Typeface.FONTAWESOME
	btnsearch.Text = Chr(0xf002)
	Dim Color As ColorDrawable
	Color.Initialize2(Colors.RGB(255,255,255),3dip,1dip,Colors.White)
	edsearch.Background=Color
	edsearch.Padding = Array As Int (30dip, 10dip, 10dip, 10dip)
	edsearch.Typeface =Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	edsearch.TextSize =14
End Sub

Sub btnsearch_Click
	Log("btnsearch_Click")
	search_list.Clear
	Dim cr_search As Cursor
	Log(Idbook)
	
	Dim nwfiled(10) As String
	nwfiled(0) = "replace(_text,'ِ','')"
	nwfiled(1) = "replace("& nwfiled(0) & ",'َ','')"
	nwfiled(2) = "replace("& nwfiled(1) & ",'ً','')"
	nwfiled(3) = "replace("& nwfiled(2) & ",'ُ','')"
	nwfiled(4) = "replace("& nwfiled(3) & ",'ٌ','')"
	nwfiled(5) = "replace("& nwfiled(4)& ",'ّ','')"
	nwfiled(6) = "replace("& nwfiled(5) & ",'ٍ','')"
	nwfiled(7) = "replace("& nwfiled(6) & ",'ْ','')"
	nwfiled(8) = "replace("& nwfiled(7) & ", 'ى' , 'ي')"
	nwfiled(9) = "replace("& nwfiled(8) & ", 'أ' , 'ا')"
	
	cr_search = Main.sql1.ExecQuery("SELECT * FROM b"&Idbook&"_pages WHERE "&nwfiled(9)&" LIKE '%"& edsearch.Text &"%'")
	Log(cr_search.RowCount)

	For i=0 To cr_search.RowCount-1
		Dim map_recycler As Map
		map_recycler.Initialize
		cr_search.Position=i
		map_recycler.Put("id",cr_search.GetInt("id"))
'		map_recycler.Put("main_id",cr_search.GetInt("main_id"))
		map_recycler.Put("title",cr_search.GetString("_text"))
		map_recycler.Put("fav",cr_search.GetInt("fav"))
		map_recycler.Put("tag", i)
		search_list.Add(map_recycler)
	Next
	tag = 0
	
	Dim p As Phone
	p.HideKeyboard(Activity)
	If edsearch.Text.Length > 2 Then
		If cr_search.RowCount > 0 Then
		
			map_recycler = search_list.Get(0)
			Log("------------>"&map_recycler.Get("main_id"))
			userQuery = edsearch.Text
			hidesearch
			create_movepnl
			If statusListView = 1 Then
		
				RV_Contentbook.ScrollToPosition(map_recycler.Get("id")-1)
				If RV_Contentbook.IsInitialized Then
					If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
				End If
		
			Else
				
				WebViewExtras1.executeJavascript(WebView,"search('"&edsearch.Text&"')")
'				WebViewExtras1.executeJavascript(WebView,"  $('.book_text').each(function(){ $(this).html($(this).text()) });  search('"&edsearch.Text&"')")
				WebViewExtras1.executeJavascript(WebView,"window.scrollTo(0, 0);var y = getOffset( document.getElementById('book-mark_"&(map_recycler.Get("id")-1)&"') ).top;window.scrollTo(0, y); initAndSetupTheSliders("&(map_recycler.Get("id"))&")")
			End If
		Else
			ToastMessageShow("لا توجد نتائج!",False)
		End If
	Else
		ToastMessageShow("لابد ان تتجاوز كلمة البحث  ٣ حروف !",False)
	End If

	cr_search.Close

End Sub

Sub hidesearch
	If pnl_search.Visible=True Then
		mnuPanelAnimation.SlideFadeToTop("icS",600,400)
		mnuPanelAnimation.StartAnim(pnl_search)
		pnl_search.Top = -56dip
		pnl_search.Visible=False
	End If
	
End Sub

Sub icS_animationend
	pnl_search.Top=-56dip
	pnl_search.Visible=False
End Sub

Sub loadstyle
	fonttype ="lotus-light.ttf"
	fontsize = 21
	fontline = 27
	
	pnl_settings.Initialize("pnl_settings")
	Activity.AddView(pnl_settings,15%x,25%y,70%x,45dip*8)
	pnl_settings.Visible = False
	Dim Color As ColorDrawable
	Color.Initialize2(Colors.RGB(255,255,255),10dip,1dip,Colors.RGB(42,86,135))
	pnl_settings.Background=Color
	
	spFonts.Initialize("spFonts")
	pnl_settings.AddView(spFonts,5dip,15dip,pnl_settings.Width-10dip,40dip)
	spFonts.Add("طاهر")
	spFonts.Add("البهيج")
	spFonts.Add("دجلة")
	
	'//////////اندازه فونت//////////////
	Private lblsizeleft As Label
	lblsizeleft.Initialize("lblsizeleft")
	pnl_settings.AddView(lblsizeleft,5dip,spFonts.Top+spFonts.Height+15dip,40dip,40dip)
	lblsizeleft.Text = Chr(0xE148)
	lblsizeleft.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	lblsizeleft.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	lblsizeleft.TextSize=25
	lblsizeleft.textColor=Colors.RGB(42,86,135)
	
	sbsizeFonts.Initialize("sbsizeFonts")
	pnl_settings.AddView(sbsizeFonts,40dip,lblsizeleft.Top,pnl_settings.Width-80dip,40dip)
	sbsizeFonts.Max = 12
	sbsizeFonts.Value = fontsize - minfontsize
	
	Private lblsizeright As Label
	lblsizeright.Initialize("lblsizeright")
	pnl_settings.AddView(lblsizeright,lblsizeleft.Width+sbsizeFonts.Width,lblsizeleft.Top,40dip,40dip)
	lblsizeright.Text = Chr(0xE15D)
	lblsizeright.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	lblsizeright.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	lblsizeright.TextSize=25
	lblsizeright.textColor=Colors.RGB(42,86,135)
	
	'////////////ارتفاع متون////////////
	Private lbllinespaceL As Label
	lbllinespaceL.Initialize("lbllinespaceL")
	pnl_settings.AddView(lbllinespaceL,5dip,lblsizeright.Top+lblsizeright.Height+15dip,40dip,40dip)
	lbllinespaceL.Text = Chr(0xE5D7)
	lbllinespaceL.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	lbllinespaceL.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	lbllinespaceL.TextSize=25
	lbllinespaceL.textColor=Colors.RGB(42,86,135)
	
	sblineFonts.Initialize("sblineFonts")
	pnl_settings.AddView(sblineFonts,40dip,lbllinespaceL.Top,pnl_settings.Width-80dip,40dip)
	sblineFonts.Max= 6
	sblineFonts.Value = fontline - minfontline

	Private lbllinespaceR As Label
	lbllinespaceR.Initialize("lbllinespaceR")
	pnl_settings.AddView(lbllinespaceR,lblsizeleft.Width+sblineFonts.Width,lbllinespaceL.top,40dip,40dip)
	lbllinespaceR.Text = Chr(0xE5D6)
	lbllinespaceR.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	lbllinespaceR.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	lbllinespaceR.TextSize=25
	lbllinespaceR.textColor=Colors.RGB(42,86,135)
	
	'/////////////بک گراند///////////
	pnlcolor1.Initialize("pnlcolor1")
	pnl_settings.AddView(pnlcolor1,pnl_settings.Width/2-70dip,lbllinespaceR.Top+lbllinespaceR.Height+25dip,40dip,40dip)
	c1.Initialize2(Colors.rgb(46,53,63),35dip,1dip,Colors.RGB(150,150,150))
	pnlcolor1.Background = c1
	
	
	pnlcolor2.Initialize("pnlcolor2")
	pnl_settings.AddView(pnlcolor2,pnlcolor1.Left+pnlcolor1.Width+10dip,pnlcolor1.top,40dip,40dip)
	c2.Initialize2(Colors.RGB(219,207,181),35dip,1dip,Colors.RGB(255,196,182))
	pnlcolor2.Background = c2
	
	pnlcolor3.Initialize("pnlcolor3")
	pnl_settings.AddView(pnlcolor3,pnlcolor2.Left+pnlcolor2.Width+10dip,pnlcolor1.top,40dip,40dip)
	c3.Initialize2(Colors.RGB(255,255,255),35dip,1dip,Colors.RGB(218,218,218))
	pnlcolor3.Background = c3
	
	
End Sub

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
	
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub sbsizeFonts_ValueChanged (Value As Int, UserChanged As Boolean)
	If UserChanged = True Then
		fontsize = Value + minfontsize
		Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontsize="&fontsize)
		If RV_Contentbook.IsInitialized Then
			If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
		End If
		
	End If
End Sub

Sub lblsizeleft_Click
'	Log("lblsizeleft")
	sbsizeFonts.Value = sbsizeFonts.Value+1
	fontsize =sbsizeFonts.Value + minfontsize
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontsize="&fontsize)
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub lblsizeright_Click
'	Log("lblsizeright")
	sbsizeFonts.Value = sbsizeFonts.Value-1
	fontsize =sbsizeFonts.Value + minfontsize
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontsize="&fontsize)
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub sblineFonts_ValueChanged (Value As Int, UserChanged As Boolean)
'	Log("sblineFonts: "&Value)
'	Log("UserChanged: "&UserChanged)
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
'	Log("lbllinespaceL")
	sblineFonts.Value = sblineFonts.Value+1
	fontline= sblineFonts.Value + minfontline
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontline="&fontline)
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub lbllinespaceR_Click
'	Log("lbllinespaceR")
	sblineFonts.Value = sblineFonts.Value-1
	fontline = sblineFonts.Value + minfontline
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontline="&fontline)
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub pnlcolor1_Click
'	AppNight
	stylebackground="#000000"
	stylefont="#fff"
	
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontcolor='#000000',fontcolorQ='-1'  ")
	c1.Initialize2(Colors.RGB(0,0,0),35dip,3dip,Colors.Red)
	pnlcolor1.Background = c1
	
	c2.Initialize2(Colors.RGB(219,207,181),35dip,1dip,Colors.RGB(255,196,182))
	pnlcolor2.Background = c2
	c3.Initialize2(Colors.RGB(255,255,255),35dip,1dip,Colors.RGB(218,218,218))
	pnlcolor3.Background = c3
	
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
	
	
	c1.Initialize2(Colors.RGB(0,0,0),35dip,1dip,Colors.RGB(218,218,218))
	pnlcolor1.Background = c1
	c3.Initialize2(Colors.RGB(255,255,255),35dip,1dip,Colors.RGB(218,218,218))
	pnlcolor3.Background = c3
	
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub pnlcolor3_Click
'	AppDay
	stylebackground="#ffffff"
	stylefont="#000"
	
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontcolor='#ffffff',fontcolorQ='-16777216'  ")
	c3.Initialize2(Colors.RGB(255,255,255),35dip,3dip,Colors.Red)
	pnlcolor3.Background = c3
	
	c1.Initialize2(Colors.RGB(0,0,0),35dip,1dip,Colors.RGB(218,218,218))
	pnlcolor1.Background = c1
	c2.Initialize2(Colors.RGB(219,207,181),35dip,1dip,Colors.RGB(255,196,182))
	pnlcolor2.Background = c2
	
	If RV_Contentbook.IsInitialized Then
		If RV_Contentbook.Adapter<>Null Then RV_Contentbook.Adapter2.NotifyDataSetChanged
	End If
End Sub

Sub hidesettings
	If pnl_settings.Visible=True Then
		mnuPanelAnimation.SlideFadeToBottom("ic2",600,400)
		mnuPanelAnimation.StartAnim(pnl_settings)
		pnl_settings.Top=100%y
		pnl_settings.Visible=False
	End If
	
End Sub

Sub ic2_animationend
	pnl_settings.Top=100%y
	pnl_settings.Visible=False
End Sub


#Region  InitializeFooter

Sub GetFirstAndLastPageId
	Dim c As Cursor
	c = Main.sql1.ExecQuery("SELECT * FROM b"&Idbook&"_pages")
	c.Position = 0
	firstpage = c.GetInt("id")
'	RTLSeekBar.PopupLabel.Text = "sss"
'	Dim JO As JavaObject = RTLSeekBar
'	JO.RunMethod("setMin",Array(firstpage))
	
	c.Position = c.RowCount - 1
	lastpage = c.GetInt("id")
'	Log("lastpage: "&lastpage )
'	paging.SetMaxVal(lastpage)
	

	c.Close
End Sub

Private Sub InitializeFooter
	

	PnlFooter.Initialize("")
	PnlFooter.Color=Colors.RGB(34,185,195)
	lblfavorite.Initialize("lblfavorite")
	lblfavorite.TextColor=Colors.White
	lblfavorite.Text= Chr(0xE83A)
	lblfavorite.TextSize=22
	lblfavorite.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	lblfavorite.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)

	If statusListView = 0 Then
'		Activity.AddView(PnlFooter,0,52dip,32dip,Activity.Height)
'		PnlHeader.AddView(lblfavorite,70dip,0,35dip,52dip)
'		PnlFooter.Color = Colors.Transparent
	Else
		Activity.AddView(PnlFooter,0,100%y-52dip,100%x,52dip)
		PnlFooter.Color = Colors.rgb(75,105,105)
		PnlFooter.AddView(lblfavorite,100%x-52dip,0,52dip,52dip)
	End If

	loadlabellast
	loadRTLSeekBar
End Sub

Sub loadlabellast
	
	lbllast.Initialize("lbllast")
	If statusListView = 1 Then
		PnlFooter.AddView(lbllast,5dip,0,70dip,PnlFooter.Height)
	End If
	lbllast.TextColor=Colors.White
	lbllast.Text = GetPageNumberById(firstpage)&" / "&GetPageNumberById(lastpage)
	lbllast.Typeface=Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
'	lbllast.TextColor = Colors.Red
	lbllast.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
End Sub

Sub loadRTLSeekBar
	
	If statusListView = 1 Then
		RTLSeekBar.Initialize("RTLSeekBar")
		PnlFooter.AddView(RTLSeekBar,lbllast.Width,0,100%x-lbllast.Width-iconlistcontent.Width,PnlFooter.Height)
		RTLSeekBar.SendToBack
		RTLSeekBar.Value = Idpage
		RTLSeekBar.Max = lastpage
		Functions.ForceRtlSupported4View(RTLSeekBar)
		Dim jo As JavaObject
		jo.InitializeContext
		jo.RunMethod("ChangeColor",Array As Object(RTLSeekBar,Colors.White))
	End If

End Sub


Sub RTLSeekBar_Click(returnValue)
	RV_Contentbook.ScrollToPosition(returnValue-1)
'	RTLSeekBar.setValue(returnValue)
	LogColor(returnValue,Colors.red)
End Sub

Sub RTLSeekBar_ValueChanged (Value As Int, UserChanged As Boolean)

	user_change = UserChanged
	
	
'	ToastMessageShow("RTLSeekBar_ValueChanged = "& (Idpage -1),False)
	If UserChanged = False Then
		If search_move = False Then
			If act_listcontent.listcontent_page = False Then
				lbllast.Text = (GetPageNumberById(Value)+1)&" / "&(GetPageNumberById(lastpage)+1)
			Else
				RV_Contentbook.ScrollToPosition(Idpage)
				If statusListView = 1 Then
					RTLSeekBar.Value = Idpage
				End If
				lbllast.Text =  (GetPageNumberById(firstpage))&" / "&lastpage
			End If

		Else

			If statusListView = 1 Then
			
				RTLSeekBar.Value = Idpage
			End If
			lbllast.Text = (map_counter.Get("id"))&" / "&lastpage
			search_move = False
'			End If
			LogColor(map_counter.Get("id"),Colors.red)
			LogColor(map_counter.Get("id"),Colors.red)
		End If
	Else
'		Value = Idpage
		LogColor (Value,Colors.Red)
		lbllast.Text = GetPageNumberById(Value+1)&" / "&lastpage
		RV_Contentbook.ScrollToPosition(Value)

	End If

End Sub

Sub iconlistcontent_Click
'	Log("iconlistcontent")
	act_listcontent.titlecontent = lblTitleBook.Text
	act_listcontent.idchapters = Idbook
	StartActivity(act_listcontent)
	Activity.Finish
End Sub

#End Region

#Region  InitializeHeader

Private Sub InitializeHeader
	
	PnlHeader.Initialize("")
	Activity.AddView(PnlHeader,0,0,100%x,52dip)
	

	mv.setNavigationBarColor(Main.footer_cl)
	Dim Gradient1 As GradientDrawable
	Dim clrs(2) As Int
	clrs(0) = Main.header_cl
	clrs(1) =  Colors.White

	Gradient1.Initialize("TOP_BOTTOM",clrs)
	
	PnlHeader.Background = Gradient1
	Activity.Color = Main.activity_cl

	
	
	iconlistcontent.Initialize("iconlistcontent")
	iconlistcontent.TextColor=Main.text_cl
	iconlistcontent.Text= Chr(0xE5d2)
	iconlistcontent.TextSize=25
	iconlistcontent.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	iconlistcontent.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	

	
	Dim style As Label
	style.Initialize("style")
	style.TextColor=Main.text_cl
'	style.Color=Colors.red
	style.Text=Chr(0xE8b8)
	style.TextSize=22
	style.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	style.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	PnlHeader.AddView(style,35dip,0,35dip,52dip)

	
	lblTitleBook.Initialize("lblTitleBook")
	PnlHeader.AddView(lblTitleBook,37dip*3,12dip,PnlHeader.Width-(70dip*3),24dip)
	lblTitleBook.TextColor= Main.text_cl
	lblTitleBook.TextSize=15
	lblTitleBook.Padding = Array As Int (0dip,5dip,0dip,0dip)
	lblTitleBook.Typeface=Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	lblTitleBook.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	lblTitleBook.Text = book_name
'	lblTitleBook.Color = Colors.Red
	
	Dim BackClick As Label
	BackClick.Initialize("BackClick")
	BackClick.TextColor=Main.text_cl
'	BackClick.Color=Colors.red
	BackClick.Text=Chr(0xE5C4)
	BackClick.TextSize=22
	BackClick.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	BackClick.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)

	Dim searchClick As Label
	searchClick.Initialize("searchClick")
	searchClick.TextColor=Main.text_cl
	searchClick.Text=Chr(0xE8B6)
	searchClick.TextSize=22
	searchClick.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	searchClick.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	
	
	PnlHeader.AddView(searchClick,PnlHeader.Width-(35dip*2),0,35dip,52dip)
	PnlHeader.AddView(BackClick,0,0,35dip,52dip)
	PnlHeader.AddView(iconlistcontent,PnlHeader.Width-35dip,0,35dip,52dip)


End Sub

Sub searchClick_Click
	If pnl_search.Visible = True Then
		hidesearch
	Else
		pnl_search.Top = 52dip
		pnl_search.Visible = True
		mnuPanelAnimation.SlideFadeFromTop("ic",600,500)
		mnuPanelAnimation.StartAnim(pnl_search)
'		pnl_search.BringToFront
'		PnlHeader.BringToFront
	End If
End Sub

Sub lblfavorite_Click
	Dim lbl_fav As Label = Sender
	If lbl_fav.Text = Chr(0xE83A) Then
		lbl_fav.TextColor=Colors.Yellow
		lbl_fav.Text =Chr(0xE838)
		ToastMessageShow("تمت الاضافة للمفضلة .",False)
		Main.sql1.ExecNonQuery("UPDATE booklist SET fav =1 WHERE id = "&Idbook)
	Else
		lbl_fav.TextColor=Colors.White
		lbl_fav.Text =Chr(0xE83A)
		ToastMessageShow("تم الالغاء من المفضلة .",False)
		Main.sql1.ExecNonQuery("UPDATE booklist SET fav =1 WHERE id = "&Idbook)
	End If
End Sub

#End Region



#Region RV_Contentbook 

Sub loadItemContentbook(id As Int)
	ItemContentbook.Initialize
'	If act_search.isFromSearch = False Then
		cr_page = Main.sql1.ExecQuery("SELECT * FROM b"&id&"_pages  ORDER BY id ASC")
'	Else
'		cr_page = Main.sql1.ExecQuery("SELECT * FROM b"&id&"_pages")
'	End If
	
	For i=0 To cr_page.RowCount - 1
		cr_page.Position=i
		ItemContentbook.Add(CreateMap("id":cr_page.GetInt("id"),"page":cr_page.GetString("page"),"Description":cr_page.GetString("_text")))
	Next
	cr_page.Close
	
End Sub

Public Sub Initialize_RV_Contentbook
	Log(statusListView)
	If statusListView = 0 Then
		make_webView
		make_pages
	Else
		RV_Contentbook.Initializer("RV_Contentbook").ListView.Horizontal.Build
		RV_Contentbook.LinearSnapHelper2(Gravity.LEFT,False)
		RV_Contentbook.ScrollToEndListener(True)
		RV_Contentbook.LayoutDirection=RV_Contentbook.LAYOUT_DIRECTION_RTL
		RV_Contentbook.DefaultAdapter
		Activity.AddView(RV_Contentbook,8dip,56dip,100%x-16dip,100%y-112dip)
		RV_Contentbook.SendToBack
		RV_Contentbook.ScrollSettings.OverScrollMode= _
	RV_Contentbook.ScrollSettings.OVER_SCROLL_NEVER
	End If
	
End Sub

Private Sub RV_Contentbook_GetItemOffsets (OutRect As Rect,Item As Object,Position As Int)


	If statusListView = 1 Then
'		OutRect.Left= 5dip
'		OutRect.Right= 5dip
	Else
		OutRect.Top= 5dip
		If Position = RV_Contentbook.Adapter2.ItemCount-1 Then
			OutRect.Bottom=5dip
		End If
	End If
	
End Sub

Sub RV_Contentbook_onCreateViewHolder (Parentt As Panel,ViewType As Int)
	Card_ListBook_OnCreate(Parentt,RV_Contentbook.LayoutSpanCount)
End Sub

Sub RV_Contentbook_onBindViewHolder (Parentt As Panel,Position As Int)
	Card_ListBook_OnBind(Parentt,ItemContentbook.Get(Position),Position)
'	Parentt.top = Parentt.Top +20dip
	If user_change = False Then
		If statusListView = 1 Then
			RTLSeekBar.Value = RV_Contentbook.CenterItemPosition
		End If
	End If
	Functions.SetPadding(Parentt,0,5dip,0,5dip)
	user_change = False
End Sub

Sub RV_Contentbook_GetItemCount As Int
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
'	RV_Contentbook.Adapter2.NotifyDataSetChanged
End Sub

Sub RV_Contentbook_onScrollStateChanged (NewState As Int)
	act_listcontent.listcontent_page = False
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
	
'	If statusListView = 1 Then
'		Holder.Height = (100%y -200dip)
'	End If
	
	Dim SectionHolder As Panel
	SectionHolder.Initialize("SectionHolder")
'	If statusListView = 0 Then
	Holder.AddView(SectionHolder,0dip,6dip,Holder.Width,98dip)
'	Else
'		Holder.AddView(SectionHolder,10dip,6dip,Holder.Width-20dip,98dip)
'	End If
	Dim c As ColorDrawable
	c.Initialize2(Colors.White,5dip,1dip,Colors.ARGB(170,170,170,170))
	Holder.Background = c
'	SectionHolder.Background = GD
'	SectionHolder.Elevation = 2dip
	
	Dim bookmark As Label
	bookmark.Initialize("bookmark")
	SectionHolder.AddView(bookmark,10dip,10dip,50dip,30dip)
	bookmark.TextSize=22
	bookmark.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	bookmark.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	
	
	Dim wvdescription As WebView
	wvdescription.Initialize("wvdescription")
	'wvdescription.Color = Colors.Red
	SectionHolder.AddView(wvdescription,10dip,45dip,SectionHolder.Width-20dip,100%y-50dip)
	wvdescription.ZoomEnabled = False
	wvdescription.JavaScriptEnabled=True
	

	Dim Hedescription As JK_JustifyTextView
	Hedescription.Initialize("Hedescription")
	If statusListView = 0 Then
		SectionHolder.AddView(Hedescription,5dip,50dip,SectionHolder.Width-10dip,-2)
	Else
		SectionHolder.AddView(Hedescription,5dip,50dip,SectionHolder.Width-30dip,-2)
	End If
	
	Dim label_counter As Label
	label_counter.Initialize("")
	SectionHolder.AddView(label_counter,SectionHolder.Width-60dip,10dip,50dip,30dip)
End Sub

Public Sub Card_ListBook_OnBind (Holder As Panel, Data As Map, Position As Int)
	Position = Idpage

	Dim SectionHolder = Holder.GetView(0) As Panel
	Dim bookmark = SectionHolder.GetView(0) As Label
	Dim wvdescription = SectionHolder.GetView(1) As WebView
	Dim Hedescription = SectionHolder.GetView(2) As JK_JustifyTextView
	Dim label_counter = SectionHolder.GetView(3) As Label
	
	
'	Dim wvx As WebViewExtras
'	wvx.Initialize(wvdescription)
'	wvx.addJavascriptInterface(wvdescription,"B4A")
'	wvx.JavaScriptEnabled = True
'	wvx.ZoomEnabled = False
	
	Dim RowFind As Int
	RowFind = Main.sql1.ExecQuerySingleResult("SELECT count(id) FROM bookmark WHERE idpage="&Data.Get("id")&" AND idbook="&Idbook&" ")
	
	
	Dim avm As Amir_ViewManager
	avm.Initialize(bookmark)
	avm.Radius = 5
	avm.BackgroundColor = Colors.RGB(240,240,240)
	avm.BackgroundPressedColor = Colors.RGB(240,240,240)
	avm.TextColor = Colors.Red
	avm.TextPressedColor = Colors.Red
	avm.Start
	If RowFind  = 1 Then
		bookmark.TextColor=Colors.rgb(172,34,36)
		bookmark.Text = Chr(0xE866)
	Else
		bookmark.TextColor=Colors.Gray
		bookmark.Text = Chr(0xE867)
	End If
	
	label_counter.Text = Data.Get("id")
	label_counter.Gravity = Gravity.CENTER
	label_counter.TextSize = 17
	Dim avm As Amir_ViewManager
	avm.Initialize(label_counter)
	avm.Radius = 5
	avm.BackgroundColor = Colors.RGB(240,240,240)
	avm.BackgroundPressedColor = Colors.RGB(240,240,240)
	avm.TextColor = Colors.rgb(172,34,36)
	avm.TextPressedColor = Colors.Red
	avm.Start
	bookmark.Tag = Data.Get("page")
	Dim txt As String : txt = ""
'	Log("userQuery: "&userQuery) 
'	Log("usersearch: "&act_search.usersearch)
	Dim matncontent As String = Data.Get("Description")
	Dim matns As String =  Data.Get("Description") &"<br>"
	'height:"&wvdescription.Height &"px
	If statusListView = 1 Then
		txt = "<html ><body style='overflow-y:auto; max-height:"&RV_Contentbook.Height&"'>"
	Else
		txt = ""
	End If

	
	matncontent = matncontent.Replace("ِ","")
	matncontent = matncontent.Replace("َ","")
	matncontent = matncontent.Replace("ً","")
	matncontent = matncontent.Replace("ُ","")
	matncontent = matncontent.Replace("ٌ","")
	matncontent = matncontent.Replace("ّ","")
	matncontent = matncontent.Replace("ٍ","")
	matncontent = matncontent.Replace("ْ","")
	matncontent = matncontent.Replace("إ" , "ا")
	matncontent = matncontent.Replace("ى" , "ي")
	If userQuery <> "" Then
		Log("1111111111")
		LogColor(Data.Get("id"),Colors.RGB(240,190,150))
		matncontent = matncontent.Replace(userQuery,"<b style='color:red;background-color:yellow'>" & userQuery & "</b>")
		
		txt =  txt & "<html ><link rel='stylesheet' type='text/css' href='" & Functions.WebViewAssetFile("mhebooks.css") & "'><style>@font-face {font-family: samim;src: url(' " & Functions.WebViewAssetFile_fonttype(fonttype) & " ') format('truetype');}p,br,h1,h2,h3,h4,h5,h6,div{padding:0;margin:0}* {font-family:samim !important;font-size:"&fontsize&"px !important;line-height:"&((fontline / minfontline )*100)&"% !important;direction: rtl;}</style>"& _
		 "<div style='font-family:samim;direction: rtl;padding: 0 5px;text-align:justify;color:"&stylefont&"'>" &matncontent&"<br/><br/></div><br><br>"
	
	else If act_search.isFromSearch Then
		Log("222222222")
		matncontent = matncontent.Replace(act_search.usersearch,"<b style='color:red;background-color:yellow'>" & act_search.usersearch & "</b>")
		
		txt =  txt & "<html ><link rel='stylesheet' type='text/css' href='" & Functions.WebViewAssetFile("mhebooks.css") & "'><style>@font-face {font-family: samim;src: url(' " & Functions.WebViewAssetFile_fonttype(fonttype) & " ') format('truetype');}p,br,h1,h2,h3,h4,h5,h6,div{padding:0;margin:0}* {font-family:samim !important;font-size:"&fontsize&"px !important;line-height: "&((fontline / minfontline )*100)&"% !important;direction: rtl;}</style>"& _
		 "<div style='font-family:samim;direction: rtl;padding:  0 5px;text-align:justify;color:"&stylefont&"'>" &matncontent&"<br/><br/></div><br><br>"
	
	Else
		Log(fonttype&" ----33333333333333")
		txt =  txt & "<html ><link rel='stylesheet' type='text/css' href='" & Functions.WebViewAssetFile("mhebooks.css") & "'><style>@font-face {font-family: samim;src: url(' " & Functions.WebViewAssetFile_fonttype(fonttype) & " ') format('truetype');}p,br,h1,h2,h3,h4,h5,h6,div{padding:0;margin:0}* {font-family:samim !important;font-size:"&fontsize&"px !important;line-height: "&((fontline / minfontline )*100)&"% !important;direction: rtl;}</style>"& _
		 "<div ><div style='font-family:samim;direction: rtl;padding: 0 5px;text-align:justify;color:"&stylefont&"'>" &Data.Get("Description")&"<br/><br/></div><br><br>"
	End If
'		<div style='text-align:center;color:red'>"&Data.Get("id")& "</div>
	txt =  txt & "</body></html>"
	Log (txt)
	wvdescription.LoadHtml(txt)

	Hedescription.Visible = False
	wvdescription.Visible = True
	wvdescription.Color = Colors.Transparent
	Select Case stylebackground
		Case "#000000"
			Holder.Color = Colors.rgb(46,53,63)
			Hedescription.Color = Colors.rgb(46,53,63)
			Hedescription.TextColor = Colors.White
'				wvx.Color = Colors.rgb(46,53,63)
'				SectionHolder.Color = Colors.rgb(46,53,63)
		Case "#ffffff"
			Hedescription.Color = Colors.White
			Holder.Color = Colors.White
'				wvx.Color = Colors.White
				
		Case "#FAF3DA"
			Hedescription.Color = Colors.rgb(250,243,218)
			Holder.Color = Colors.rgb(250,243,218)
'				wvx.Color = Colors.rgb(250,243,218)
				
	End Select

	Holder.Height =  RV_Contentbook.Height
	wvdescription.Height = RV_Contentbook.Height - 60dip
	SectionHolder.Height =  RV_Contentbook.Height
End Sub

Sub Hedescription_Click
	If pnl_settings.Visible = True Then
		hidesettings
	End If
End Sub

Sub Marker_SearchWord(s1 As String)
	text = text.Replace(s1," "&"{R}{G}"&s1&"{G}{R}"&" ")
	rs.Initialize(text)
	rs.BackColor2(Colors.RGB(240,240,240),"{G}")
	rs.Color2(Colors.Red,"{R}")
End Sub

Sub bookmark_Click
	Dim idmark As Int
	Dim lbl_bookmark As Label = Sender
	idmark = lbl_bookmark.Tag
'	Log("idmark: "&idmark)
	If lbl_bookmark.Text = Chr(0xE867) Then
		lbl_bookmark.TextColor=Colors.rgb(172,34,36)
		lbl_bookmark.Text =Chr(0xE866)
		ToastMessageShow("تمت الاضافة للإشارات المرجعية .",False)
		Log(Idbook &"******"&idmark&book_name)
		Main.sql1.ExecNonQuery2("INSERT INTO bookmark(idbook,idpage) VALUES(?,?)",Array(Idbook,idmark))
	Else
		lbl_bookmark.TextColor=Colors.Gray
		lbl_bookmark.Text =Chr(0xE867)
		ToastMessageShow("تم الإلغاء من الإشارات المرجعية .",False)

		Main.sql1.ExecNonQuery("DELETE FROM bookmark WHERE idbook = "& Idbook &" and idpage = "&idmark)
	End If

End Sub

Sub RV_Contentbook_onItemClick (Parentt As Panel,Position As Int)
'	Log(Position)
	Dim DataMap As Map = ItemContentbook.Get(Position)
	Dim Idbook1 As String = DataMap.Get("Idbook")
 
'	Log("Idbook: "&Idbook1)


End Sub

Sub GetPageNumberById(id As Int) As Int
	Dim cursor_page As Cursor
	Dim page_num As Int
	If id = 0 Then
		id = 1
	End If
	Log("========"&id)
	
	cursor_page = Main.sql1.ExecQuery("SELECT id FROM b"&Idbook&"_pages WHERE page="&id&" ")
	cursor_page.Position=0
	page_num = cursor_page.GetInt("id")
	cursor_page.Close
	Return page_num
End Sub
#End Region



#Region WebView

Sub make_webView
	WebView.Initialize("WebView")
	WebView.ZoomEnabled = False
	Activity.AddView(WebView,0,52dip,100%x,100%y-52dip)
	WebViewExtras1.clearCache(WebView,True)
	WebViewExtras1.addJavascriptInterface(WebView,"B4A")
	WebViewExtras1.addWebChromeClient(WebView,"")
	WebView.SendToBack
	WebView.Color=  Colors.White
End Sub

Sub make_pages
'	SpinKitView1.SpinKitColor = Main.header_cl
'	SpinKitView1.SpinKitType = SpinKitView1.CIRCLE
'	SpinKitView1.goForIt
	
'	pnl_loading.BringToFront
	Dim fonttype As String
	
	cr = Main.sql1.ExecQuery("SELECT fav FROM b"&Idbook&"_pages")
	cr_setting = Main.sql1.ExecQuery("SELECT * FROM personalsetting")
	cr_setting.Position = 0
	
	Select cr_setting.GetString("font_type")
		Case 0
			fonttype ="lotus-light.ttf"
		Case 1
			fonttype = "bahij_muna-bold.ttf"
		Case 2
			fonttype ="dijalhregular.ttf"
	End Select
	
'	{font-family:samim !important;font-size:"&fontsize&"px !important;direction: rtl;}
	page_content = "<html ><link rel='stylesheet' type='text/css' href='" & Functions.WebViewAssetFile("nouislider.min.css") & "'><link rel='stylesheet' type='text/css' href='" & Functions.WebViewAssetFile("mhebooks.css") & "'><style>@font-face {font-family: samim;src: url(' " & Functions.WebViewAssetFile_fonttype(fonttype) & " ') format('truetype');}p,br,h1,h2,h3,h4,h5,h6,div{padding:0;margin:0}* {;font-size: 20px !important;line-height: 1.4 !important;direction: rtl;}</style><body>   <div id='book_content'> <div id='my-slider' class='slider'></div> "
	For i= 0 To cr.RowCount-1
		cr.Position = i
		If cr.GetInt("fav") = 0 Then
			page_content =  page_content &"<div class='BookPage' data-page='"&i&"' style=' color:"&cr_setting.GetString("text_color")&" !important;background-color:"&cr_setting.GetString("bg_color")&"!important'  id='page_"&i&"'><div class='book-mark'  id='book-mark_"&i&"'></div><span class='page-number'>"&(i+1)&"</span> <br> <div   class='book_text' style='font-family:samim;direction: rtl;padding: 0 5px;text-align:justify;font-size:"&cr_setting.GetInt("fontsize")&"!important' id='page___"&i&"'><div style='text-align:center;'><img class='pageLoading' src='"&Functions.WebViewAssetFile("loader.gif") &"'></div></div></div>"
		Else
			page_content =  page_content &"<div class='BookPage' data-page='"&i&"' style=' color:"&cr_setting.GetString("text_color")&" !important;background-color:"&cr_setting.GetString("bg_color")&"!important'  id='page_"&i&"'><div class='book-mark add_fav'  id='book-mark_"&i&"'></div><span class='page-number'>"&(i+1)&"</span> <br> <div class='book_text' style='font-family:samim;direction: rtl;padding: 0 5px;text-align:justify;font-size:"&cr_setting.GetInt("fontsize")&"!important' id='page___"&i&"'><div style='text-align:center;'><img class='pageLoading' src='"&Functions.WebViewAssetFile("loader.gif") &"'></div></div></div>"
		End If
		
	Next
	
	page_content =  page_content & "</div><div class='overlay-setting'><div class='setting-Collapse animate__animated'><!-- set font-size --><div class='setting-part-title'>حجم الخط</div><div class='range'><div class='field'><span class='min-value'>ع</span><input id='font-input' Type='range' Min='15' Max='35' value='"&cr_setting.GetInt("fontsize")&"' Step='1'/><span class='max-value'>ع</span><div class='sliderValue'><span id='font-value'>100</span></div></div></div><!-- choice font --><div class='setting-part-title'>نوع الخط</div><div class='radio-box w-100'><input class='radio-btn' Type='radio' name='model1' checked /><label id='font1' class='radio-label active-font'>طاهر</label><input class='radio-btn' Type='radio' name='model1' /><label id='font2' class='radio-label'>البهیج</label><input class='radio-btn' Type='radio' name='model1' /><label id='font3' class='radio-label'>دجله</label><span class='marker'></span></div><!-- set background --><div class='setting-part-title'>لون الخلفية</div><div class='bg-change'><a class='set_bg' id='bg-white' href='javascript:void(0)'><i class='fa-thin fa-check checked'></i></a><a class='set_bg animate__animated' id='bg-cream' href='javascript:void(0)'><i class='fa-thin fa-check checked'></i></a><a class='set_bg animate__animated' id='bg-black' href='javascript:void(0)'><i class='fa-thin fa-check checked'></i></a></div><div class='box-print'><div class='print'></div><div class='Qr-code'></div></div></div></div><div class='container_loading'><div class='loading'><svg height='200' width='200'><circle class='ring' cx='100' cy='102' r='70' stroke='white' fill='none' stroke-linecap='round'/><filter id='blurMe'><feGaussianBlur in='SourceGraphic' stdDeviation='4'/></filter><circle class='ring' cx='100' cy='102' r='70' stroke='white' fill='none' stroke-linecap='round' filter='url(#blurMe)'/></svg></div></div></body><script src='"&Functions.WebViewAssetFile("jquery-3.5.1.min.js") &"'></script><script src='"&Functions.WebViewAssetFile("wNumb.min.js") &"'></script><script src='"&Functions.WebViewAssetFile("nouislider.min.js") &"'></script> <script src='"&Functions.WebViewAssetFile("main.js") &"'></script> </html>"
	WebView.LoadHtml(page_content)
	

	
End Sub

Sub WebView_PageFinished (Url As String)
'	pnl_loading.Visible = False
	
	Log("WebView_PageFinished")
	WebViewExtras1.executeJavascript(WebView,$"
		ChangeSliderPage()
		slider.noUiSlider.max(200);
	"$)
	

	

	
	executeJavascript
	
	WebViewExtras1.executeJavascript(WebView,$"
		function BookmarkStatus(){
 var bookmark_elems = $('.book-mark');
		  bookmark_elems.each(function(index){
				$(this).click(() => {
				B4A.CallSub('book_mark', true ,(index+1))
				item = $(this);
					if (item.hasClass("add_fav")) {
					  item.removeClass("add_fav");
					} else {
					  item.addClass("add_fav");
					}
				});
		  });
}
BookmarkStatus();
	"$)

	
'	GET ITEM POSITION (SCROLL SPY)
	WebViewExtras1.executeJavascript(WebView,$"
	
				$(window).bind('scroll', function() {
		  var currentTop = $(window).scrollTop();
		  var elems = $('.BookPage');
		  elems.each(function(index){
		    var elemTop 	= $(this).offset().top;
		    var elemBottom 	= elemTop + $(this).height();
		    if(currentTop >= elemTop && currentTop <= elemBottom){
		      var page 		= $(this).attr('data-page');
		      		console.log(page)
		 	  custom_slider.noUiSlider.set(page);
		    }
		  })
		}); 
	"$)
	
	If act_search.isFromSearch Then
		Log(search_list.Size)
		m1 = search_list.Get(tag)
		Log("isFromSearch"&m1.Get("id"))
		WebViewExtras1.executeJavascript(WebView,"window.scrollTo(0, 0);var y = getOffset( document.getElementById('book-mark_"&(m1.Get("id")-1)&"') ).top;window.scrollTo(0, y); initAndSetupTheSliders("&(m1.Get("id"))&")")
	End If
	

	
	
	
	If act_listcontent.listcontent_page  Then
		WebViewExtras1.executeJavascript(WebView,"window.scrollTo(0, 0);var y = getOffset( document.getElementById('book-mark_"&(Idpage-1)&"') ).top;window.scrollTo(0, y); 				initAndSetupTheSliders("&(Idpage)&")")
	End If
	
	cr = Main.sql1.ExecQuery("SELECT * FROM b"&Idbook&"_pages")

	For i= 0 To cr.RowCount-1
		Dim ss As String
		cr.Position = i
		ss = cr.GetString("_text")
		If act_search.usersearch <> "" And act_search.isFromSearch And ss.Contains(act_search.usersearch) Then
			Log("act_search.usersearch  --- >"&act_search.usersearch)
			ss = ss.Replace("&nbsp;"," ")
			ss = ss.Replace("ِ","")
			ss = ss.Replace("َ","")
			ss = ss.Replace("ً","")
			ss = ss.Replace("ُ","")
			ss = ss.Replace("ٌ","")
			ss = ss.Replace("ّ","")
			ss = ss.Replace("ٍ","")
			ss = ss.Replace("ْ","")
			ss = ss.Replace("إ" , "ا")
			ss = ss.Replace("ى" , "ي")
			ss = ss.Replace($"'"$,"").Replace($"""$,"").replace(CRLF, "")
			ss = ss.Replace(act_search.usersearch,"<b style=\'color:red;background-color:yellow\'>" & act_search.usersearch & "</b>")
		End If
		WebViewExtras1.executeJavascript(WebView," document.getElementById('page___"&i&"').innerHTML = '"& ss &"'")
	Next
	WebViewExtras1.executeJavascript(WebView,$"
		  custom_slider.noUiSlider.updateOptions({
	    range: {
	      min: 1,
	      max: ${cr.RowCount}
	    }
	  }, false);
	"$)
	
	
	Dim hex_bc As String
	hex_bc = Functions.ColorToHex(Main.background_cl)
	hex_bc = hex_bc.SubString(2)
	hex_bc = "#"&hex_bc
	WebViewExtras1.executeJavascript(WebView,$"
			var style = document.querySelector('.noUi-tooltip').style;
		style.setProperty('--border-color', '${hex_bc}');
			$(".noUi-connect").css('background-color', '${hex_bc}');
			$(".noUi-tooltip").css('background-color', '${hex_bc}');
	"$)

	
	cr.Close
End Sub

Sub executeJavascript
	
	WebViewExtras1.executeJavascript(WebView,$"
		Close_Setting();
	"$)
	
	
	
	
	'	FONT SIZE
	WebViewExtras1.executeJavascript(WebView,$"
			if ($("#font-input").length > 0) {
	  const sliderValue = document.getElementById("font-value");
	  const inputSlider = document.getElementById("font-input");
	  inputSlider.oninput = () => {
	    let value = inputSlider.value;
	    sliderValue.textContent = value;
	    $(".book-page > div").css("font-size", value + "px");
	    sliderValue.style.right = 20 + (value - 15) * 5.9 + "px";
	    sliderValue.classList.add("show");
	  };
	  inputSlider.onblur = () => {
	    sliderValue.classList.remove("show");
	  };

	  $("#font-input").on("change", function () {
	    var value = document.getElementById("font-input").value;
		B4A.CallSub('Set_fontSize', true ,value)
	  });
	}
	"$)
'	SET BACKGROUND
	WebViewExtras1.executeJavascript(WebView,$"
	ChangeBackground();
			function ChangeBackground(){
					let btn_bg = $(".set_bg");
				  btn_bg.each(function (index) {
				  $(this).click(() => {
				    p_bg = $(".book-page");
				    clear_classbg();
				    $(this).addClass("bg-active");
				    $(this).addClass("animate__jello");
				    $(this).children(".checked").css("opacity", "1");
				    B4A.CallSub('Set_backGround', true ,index)
				    switch (index) {
				      case 0:
				        p_bg.css("background-color", "rgb(255,255,255) ");
				        p_bg.css("color", "rgb(0,0,0)");
				        break;
				      case 1:
				        p_bg.css("background-color", "rgb(235,220,164)");
				        p_bg.css("color", "rgb(0,0,0)");
				        break;
				      case 2:
				        p_bg.css("background-color", "rgb(97,97,97)");
				        p_bg.css("color", "rgb(255,255,255)");
				        break;
				    }
				  });
				});
			}
	
		
	"$)
	
	'	SET BOOKPAGE FONTTYPE
	WebViewExtras1.executeJavascript(WebView,$"
		$(".radio-btn").each(function (index, value) {
		  $(this).click(() => {
		    B4A.CallSub('Font_type', true ,index)
		  
		    let p_font = $(".book-page > div");
		    clear_classfont(p_font);
	
		  });
		});
	"$)

	
End Sub


Sub Set_backGround (value As String)
	Log("Set_backGround -->"&value)
	Select value
		Case 0
			WebViewExtras1.executeJavascript(WebView,"$('.BookPage').css({'background-color': '#ffffff', 'color': '#000000'});")
			Main.sql1.ExecNonQuery("UPDATE personalsetting SET bg_color= '#ffffff'")
			Main.sql1.ExecNonQuery("UPDATE personalsetting SET text_color= '#000000'")
		Case 1
			WebViewExtras1.executeJavascript(WebView,"$('.BookPage').css({'background-color': '#ebdca4', 'color': '#000000'});")
			Main.sql1.ExecNonQuery("UPDATE personalsetting SET bg_color= '#ebdca4'")
			Main.sql1.ExecNonQuery("UPDATE personalsetting SET text_color= '#000000'")
		Case 2
			WebViewExtras1.executeJavascript(WebView,"$('.BookPage').css({'background-color': '#2e353f', 'color': '#ffffff'});")
			Main.sql1.ExecNonQuery("UPDATE personalsetting SET bg_color= '#2e353f'")
			Main.sql1.ExecNonQuery("UPDATE personalsetting SET text_color= '#ffffff'")
	End Select
	
End Sub

Sub Set_fontSize(value As String)
	Log("Set_fontSize -->"&value)
	
	
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET fontsize="&value&"")
	WebViewExtras1.executeJavascript(WebView,"	$('.book_text').attr('style', 'font-size:  "&value&"px !important');")
	
End Sub

Sub Font_type (value As String)
	Log("Font_type--->"&value)
	Select value
		Case 0
			fonttype ="lotus-light"
		Case 1
			fonttype = "bahij_muna-bold"
		Case 2
			fonttype ="dijalhregular"
	End Select
	
	
	Main.sql1.ExecNonQuery("UPDATE personalsetting SET font_type="&value&"")
	WebViewExtras1.executeJavascript(WebView,"	$('.book_text').css('font-family', '"&fonttype&"');")
	WebViewExtras1.executeJavascript(WebView,"$('.radio-label').removeClass('active-font');  switch('"&value&"')  {case '0': $('.marker').css('top', '7px'); document.getElementById('font1').classList.add('active-font');  break;   case '1': $('.marker').css('top', '45px');  document.getElementById('font2').classList.add('active-font');break;   case '2': $('.marker').css('top', '81px'); document.getElementById('font3').classList.add('active-font');  break;  }")
	
End Sub

Sub book_mark( idmark As String)
	Log("book_mark -->"&idmark)
	Dim c As Cursor
	c = Main.sql1.ExecQuery("SELECT * FROM bookmark WHERE idpage = '"&idmark &"' AND idbook ='"&Idbook&"'")
	c.Position = 0
	If c.RowCount <= 0 Then
		ToastMessageShow("تمت الاضافة للإشارات المرجعية .",False)
		Log(Idbook &"******"&idmark&book_name)
'		Main.sql1.ExecNonQuery2("INSERT INTO bookmark(idbook,idpage,book_name) VALUES(?,?,?)",Array(Idbook,idmark,book_name))
		Main.sql1.ExecNonQuery2("INSERT INTO bookmark(idbook,idpage) VALUES(?,?)",Array(Idbook,idmark))
	Else
		ToastMessageShow("تم الإلغاء من الإشارات المرجعية .",False)
		Main.sql1.ExecNonQuery("DELETE FROM bookmark WHERE idbook = "& Idbook &" and idpage = "&idmark)
	End If
	
	
End Sub

Sub Refresh
	WebViewExtras1.executeJavascript(WebView,$"
	$(".container_loading").css("display", "block");
	"$)
	make_pages
End Sub

Sub Scroll_postion(ii As String)
	Dim value As Int = (ii.SubString(10)+1)
	Log("Scroll_postion -->"&(value))
	WebViewExtras1.executeJavascript(WebView,"document.getElementById('my-range').value ="&value&";")
	WebViewExtras1.executeJavascript(WebView,"(function initAndSetupTheSliders() {const inputs = [].slice.call(document.querySelectorAll('.range-slider input'));inputs.forEach(input => input.setAttribute('value', '"&value&"'));inputs.forEach(input => app.updateSlider(input));inputs.forEach(input => input.addEventListener('input', element => app.updateSlider(input)));inputs.forEach(input => input.addEventListener('change', element => app.updateSlider(input)));})();")
End Sub

#End Region

#if java
import android.graphics.PorterDuff;
import android.widget.SeekBar;
public void ChangeColor(SeekBar seekbar,int Color) {
seekbar.getProgressDrawable().setColorFilter(Color, PorterDuff.Mode.SRC_IN);
seekbar.getThumb().setColorFilter(Color, PorterDuff.Mode.SRC_IN);
}
#End If
