B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=8.8
@EndOfDesignText@
 #Region  Activity Attributes 
	#FullScreen: True
	#IncludeTitle: False
#End Region

Sub Process_Globals
	Dim titlecontent As String
	Dim idchapters As Int
	Dim Is_ListContent As Boolean = False
	Dim listcontent_page As Boolean
End Sub

Sub Globals
	Private lbl_home_title As Label
	Public RV_listcontent As Amir_RecyclerView
	Dim Itemlistcontent As List
	Private cr_booklist As Cursor
	Private PnlHeader As Panel
	Dim mv As mv_SystemUI
	
	Private panel1 As Panel
	Private ED_search As EditText
	Dim avm As Amir_ViewManager
	Dim SpinKitView1 As SpinKitView
	Dim theme_int As Int
	
	Private lbl_back As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	
	SpinKitView1.Initialize("")
	SpinKitView1.SpinKitColor = Colors.RGB(42,86,135)
	SpinKitView1.SpinKitType = SpinKitView1.ROTATING_PLANE
	SpinKitView1.goForIt
	SpinKitView1.Visible = False
	Activity.AddView(SpinKitView1,50%x-(35dip/2),40%y-(35dip/2),35dip,35dip)
	Activity.LoadLayout("lyt_listcontent")
	lbl_home_title.Text = titlecontent
	Activity.Color=Colors.RGB(238,238,238)
	
	loadItemlistcontent
	Initialize_RV_listcontent
	intialize_header
	
	Functions.Set_Color(Functions.theme_number)
	Set_theme
	
End Sub

Sub Activity_Resume
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Sub Set_theme
	PnlHeader.Color = Main.header_cl
	Activity.Color = Main.activity_cl
	lbl_home_title.TextColor = Main.text_cl
	lbl_back.TextColor = Main.text_cl
	mv.setNavigationBarColor(Main.footer_cl)
End Sub

Sub intialize_header
	Dim ac As JK_AppCompat

	avm.Initialize(ED_search)
	avm.Radius = 13
	avm.BackgroundColor = Colors.White
	avm.BackgroundPressedColor = Colors.White
	avm.TextColor = Colors.Black
	avm.TextPressedColor  = Colors.Black
	avm.Start
	ac.SetElevation(ED_search,5)
	
	avm.Initialize(panel1)
	avm.Radius = 40
	avm.BackgroundColor = Colors.White
	avm.BackgroundPressedColor = Colors.LightGray
	avm.Start
	ac.SetElevation(panel1,5)
	

End Sub

Sub lbl_back_Click
	If act_search.isFromSearch Then
		StartActivity(act_search)
	Else
		StartActivity(Act_Contents_Book)
	End If
	
	Activity.Finish
End Sub


Private Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode=KeyCodes.KEYCODE_BACK  Then
		
		lbl_back_Click
		Return True
	End If
	Return False
End Sub

Sub loadItemlistcontent
	
	Itemlistcontent.Initialize
	Itemlistcontent.Clear
	
 	cr_booklist = Main.sql1.ExecQuery("SELECT * FROM b"&idchapters&"_chapters ORDER BY id ASC")
	For i=0 To cr_booklist.RowCount - 1
		cr_booklist.Position=i
		Itemlistcontent.Add(CreateMap("Idbook":idchapters,"Title":cr_booklist.GetString("title"),"PageNumber":cr_booklist.GetInt("page")))
	Next
	cr_booklist.Close
	
	
	If RV_listcontent.IsInitialized Then
		If RV_listcontent.Adapter<>Null Then RV_listcontent.Adapter2.NotifyDataSetChanged
	End If
		
	
End Sub


Public Sub Initialize_RV_listcontent
		
	RV_listcontent.Initializer("RV_listcontent").ListView.Vertical.Build
	Activity.AddView(RV_listcontent,0,140dip,100%x,100%y-140dip)
	RV_listcontent.BringToFront

	RV_listcontent.LayoutDirection=RV_listcontent.LAYOUT_DIRECTION_RTL
	RV_listcontent.DefaultAdapter
	RV_listcontent.ScrollSettings.OverScrollMode= _
	RV_listcontent.ScrollSettings.OVER_SCROLL_NEVER
	RV_listcontent.ScrollToEndListener(True)
	
End Sub



Sub RV_listcontent_onCreateViewHolder (Parentt As Panel,ViewType As Int)
	Card_listcontent_OnCreate(Parentt,RV_listcontent.LayoutSpanCount)
End Sub

Sub RV_listcontent_onBindViewHolder (Parentt As Panel,Position As Int)
	Card_listcontent_OnBind(Parentt,Itemlistcontent.Get(Position),Position)
End Sub

Sub RV_listcontent_GetItemCount As Int
	Return Itemlistcontent.Size
End Sub

Sub RV_listcontent_DividerColor (Position As Int) As Int
	Return  Functions.GetColor(Position)
End Sub

Sub RV_listcontent_DividerLeftMargin (Position As Int) As Int
	Return Position * 16dip
End Sub

Sub RV_listcontent_DividerRightMargin (Position As Int) As Int
	Return Position * 16dip
End Sub

Sub RV_listcontent_onScrolledToEnd
'	ToastMessageShow("End of List",False)
End Sub


Public Sub Card_listcontent_OnCreate (Holder As Panel, Span As Int)
	Dim SectionHolder As Panel
	SectionHolder.Initialize("SectionHolder")
	Holder.AddView(SectionHolder,12dip,6dip,Holder.Width - 24dip,50dip)
	Dim GD As GradientDrawable
	GD.Initialize("TOP_BOTTOM",Array As Int (Colors.White,Colors.White))
	GD.CornerRadius = 4dip
	SectionHolder.Background = GD
	SectionHolder.Elevation = 2dip
	
	
	
	
	Dim PageNumber As Label
	PageNumber.Initialize("PageNumber")
	PageNumber.Gravity = Bit.Or(Gravity.CENTER_VERTICAL,Gravity.CENTER_HORIZONTAL)
	PageNumber.TextColor = Colors.DarkGray
	PageNumber.Typeface = Typeface.DEFAULT_BOLD
	PageNumber.TextSize = 11
	SectionHolder.AddView(PageNumber,8dip,4dip,80dip,40dip)
	PageNumber.Typeface=Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	
	Dim Title As Label
	Title.Initialize("Title")
	Title.Gravity = Bit.Or(Gravity.CENTER_VERTICAL,Gravity.RIGHT)
	Title.TextColor = Colors.DarkGray
	Title.Typeface = Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	Title.TextSize = 14
	SectionHolder.AddView(Title,8dip+PageNumber.Left+PageNumber.Width,4dip,100%x-40dip-PageNumber.Left-PageNumber.Width,80dip)

End Sub


Public Sub Card_listcontent_OnBind (Holder As Panel, Data As Map, Position As Int)
	Dim SectionHolder = Holder.GetView(0) As Panel
	Dim PageNumber = SectionHolder.GetView(0) As Label
	Dim Title = SectionHolder.GetView(1) As Label
	
'	Dim SectionAction = SectionHolder.GetView(3) As Panel

	
	Dim str As String
	Dim rs As RichString
	If ED_search.Text <>"" Then
		str = Data.Get("Title")

		If ED_search.Text.Length > 2 Then
			
			str = str.Replace(ED_search.Text,"{BL}"&ED_search.Text&"{BL}")
		End If
		str = str.Replace(Data.Get("Title"),"{B}"&Data.Get("Title")&"{B}")
		rs.Initialize(str)
		rs.Color2(Colors.blue,"{BL}")
		rs.Color2(Colors.Black,"{B}")
		Title.Text = rs
	Else
		Title.Text = Data.Get("Title")
	End If


	PageNumber.Text = Data.Get("PageNumber")
	Title.Height =  Functions.GetTextHeight(Title)+15dip
'	PageNumber.top =  Title.Height+10dip
'	PageNumber.Height =  Functions.GetTextHeight(Title)

	
	
'	SectionAction.Tag = Position
'	SectionAction.Height = SectionHolder.Height
	Holder.Height = Title.Height + 20dip
	SectionHolder.Height = Title.Height +10dip
End Sub



Sub RV_listcontent_onItemClick (Parentt As Panel,Position As Int)
	Log(Position)
	Dim DataMap As Map = Itemlistcontent.Get(Position)
	Dim Idbook As String=DataMap.Get("Idbook")
	Dim PageNumber As String=DataMap.Get("PageNumber")
 
	Log("Idbook: "&Idbook)
	Log("PageNumber: "&PageNumber)
	Act_Contents_Book.Idbook = Idbook
	Log(GetPageNumberById(PageNumber))
	Act_Contents_Book.Idpage = GetPageNumberById(PageNumber)
	Is_ListContent = True
	listcontent_page = True
	StartActivity(Act_Contents_Book)
'	Activity.Finish
End Sub

Sub GetPageNumberById(id As Int) As Int
	Dim cursor_page As Cursor
	Dim page_num As Int
	If id = 0 Then
		id = 1
	End If
	Log("========"&id)
	cursor_page = Main.sql1.ExecQuery("SELECT page FROM b"&Act_Contents_Book.Idbook&"_pages WHERE page="&id&" ")
	cursor_page.Position = 0
	page_num = cursor_page.GetString("page")
	cursor_page.Close
	Return page_num
End Sub

Sub ED_search_TextChanged (Old As String, New As String)
'	ED_search.Text = ED_search..Replace("ی", "ي")
'	ED_search.Text = ED_search.Replace("ک", "ك")
	
'	If ED_search.Text ="" Then
'		ToastMessageShow("Lütfen axtarılan ibarəti daxil edin",False)
'	Else

	cr_booklist = Main.sql1.ExecQuery("SELECT * FROM b"&idchapters&"_chapters")
	Log(cr_booklist.RowCount)
'		If cr_booklist.RowCount = 0 Then
'			ToastMessageShow("Nəticə tapılmadı",False)
'		Else
'			Dim ime As IME
'			ime.Initialize("")
'			ime.HideKeyboard
	Itemlistcontent.Initialize
	Itemlistcontent.Clear
	
	'cr_booklist = Main.sql1.ExecQuery("SELECT * FROM b"&idchapters&"_chapters ORDER BY id ASC")
			
	If New.Length >2 Then
		Dim str(3) As String
		Dim nwfiled(10) As String
		
		str(0)=New.Replace("ک","ك")
		str(1)=str(0).Replace("ی","ي")
		str(2)=str(1).Replace("أ","ا")
		'schword(2)=schword(1).Replace("ي","ى")

		nwfiled(0) = "replace(title,'ِ','')"
		nwfiled(1) = "replace("& nwfiled(0) & ",'َ','')"
		nwfiled(2) = "replace("& nwfiled(1) & ",'ً','')"
		nwfiled(3) = "replace("& nwfiled(2) & ",'ُ','')"
		nwfiled(4) = "replace("& nwfiled(3) & ",'ٌ','')"
		nwfiled(5) = "replace("& nwfiled(4)& ",'ّ','')"
		nwfiled(6) = "replace("& nwfiled(5) & ",'ٍ','')"
		nwfiled(7) = "replace("& nwfiled(6) & ",'ْ','')"
		nwfiled(8) = "replace("& nwfiled(7) & ", 'ى' , 'ي')"
		nwfiled(9) = "replace("& nwfiled(8) & ", 'أ' , 'ا')"
		
'		lv.Initialize("lv")
		'pnl1.AddView(lbl2,0,0,pnl1.Width,pnl1.Height)
'		functions.SetDivider(lv, Colors.RGB(208,176,120), 1dip)
      
		cr_booklist = Main.sql1.ExecQuery("SELECT * FROM b"&idchapters&"_chapters WHERE "&nwfiled(9)&" LIKE '%"&str(2)&"%'")
		
		For i=0 To cr_booklist.RowCount - 1
			cr_booklist.Position=i
'			str=cr_booklist.GetString("title")
'			str = str.Replace("ِ","")
'			str = str.Replace("َ","")
'			str = str.Replace("ً","")
'			str = str.Replace("ُ","")
'			str = str.Replace("ٌ","")
'			str = str.Replace("ّ","")
'			str = str.Replace("ٍ","")
'			str = str.Replace("ْ","")
'			str = str.Replace("أ","ا")
			''			str = str.Replace("ي" , "ی")
'			str = str.Replace("إ","ا")

'			If str.Contains(New) = True Then
			Itemlistcontent.Add(CreateMap("Idbook":idchapters,"Title":cr_booklist.GetString("title"),"PageNumber":cr_booklist.GetInt("page")))
'			Else
'				Itemlistcontent.Add(CreateMap("Idbook":idchapters,"Title":cr_booklist.GetString("title"),"PageNumber":cr_booklist.GetInt("page")))
'			End If
		Next
		cr_booklist.Close
			
		If RV_listcontent.IsInitialized Then
			loading_search
			If RV_listcontent.Adapter<>Null Then RV_listcontent.Adapter2.NotifyDataSetChanged
		End If
	Else
		loadItemlistcontent
	End If
	

'		End If
'	End If
	
End Sub

Sub loading_search
	
	RV_listcontent.Visible = False
	SpinKitView1.Visible = True
	Sleep(550)
	SpinKitView1.Visible = False
	RV_listcontent.Visible = True
	
End Sub