B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: true
	#IncludeTitle: True
#End Region

Sub Process_Globals
	Dim timerexit , tback As Timer
	Dim day_night As String
	
End Sub

Sub Globals
	
	Dim mnuPanelAnimation As ICOSSlideAnimation 'ignore
	Dim label_exit As Label
	Dim HeaderPanel As Panel
	Dim VP As AHViewPager
	Dim PC As AHPageContainer
	Dim TabLayout As Hitex_AhMaterialTabLayout
	Public RV_listbook As Amir_RecyclerView
	Dim ItemListbook As List
	Public RV_Content As Amir_RecyclerView
	Dim ItemContent As List
	Public RV_bookmark As Amir_RecyclerView
	Dim Itembookmark As List
	
	Private cr_booklist As Cursor
	Private cr_bookmark As Cursor
	Private crtitle As Cursor
	
	Private Parent As Panel
	Public SearchBarBackground As Panel
	Private SearchBarPreview As Panel
	Private SearchBarPreviewParent As Panel
	Private Divider As Label
	Dim menu1 As MorphButton
	Dim Search As Label
	Dim MenuSearch As Label

'	Private GooglePlayPreviewImage As ImageView
	Public EdSearchTop As JK_ACEditText
	Dim closesearch As Label
'	Dim AllData As List
	Dim AllData As List
	Dim SearchParent As Panel
	
	Private Shadow As Panel
	Public IsShowed As Boolean
	
	Dim objUISwitch As UISwitch
	
	Dim pActivity As Panel
	Dim navi As AHNavigationDrawer

	Private pnlhomemenu As Panel
	Private lbl_item_menu_01 As Label
'	Private lbl_item_menu_02 As Label
	Private lbl_item_menu_03 As Label
	Private lbl_item_menu_04 As Label
	Private lbl_item_menu_05 As Label
	Private lbl_item_menu_06 As Label
	Private lbl_item_menu_07 As Label
	Private icon_01 As Label
'	Private icon_02 As Label
	Private icon_03 As Label
	Private icon_04 As Label
	Private icon_05 As Label
	Private icon_06 As Label
	Private icon_07 As Label
	Private pnl_item_menu_07 As Panel
	
	Dim book_scroll As ScrollView
	Dim settingsCur As Cursor
	Dim displaytype As String
	Dim mv As mv_SystemUI
	Dim map_library As Map
	Dim spin As Spinner
	Private img_book1 As ImageView
	Private img_book2 As ImageView
	Private img_book3 As ImageView
	Dim theme_int As Int
	Private pnl_center As Panel
	Dim anime As SAnimation
	Private img_item_header_menu As ImageView
	Dim WhichFever,Subgroup As String
	Dim scroll As ScrollView
	
	Dim MenuClick As Label
	Dim lblNameApp As Label
	
End Sub


Sub Activity_Create(FirstTime As Boolean)
	Functions.Set_Color(Functions.theme_number)
	Log(Functions.theme_number)
	Log(day_night)
	
	WhichFever ="one"
	book_scroll.Initialize2(75%y,"")
	SearchParent.Initialize("")
	book_scroll.Visible = False
	scroll.Initialize(180%y)
	scroll.Visible =False
	settingsCur = Main.sql1.ExecQuery("SELECT * FROM personalsetting")
	settingsCur.Position = 0
	
	
'	If FirstTime = True Then
'		day_night = "day"
'	End If
'	Activity.Color = Colors.White
	LoadpActivity
	InitializeTab
	InitializeHeader
	menuright
	makeExit
	loadItemListbook
	make_library
	
	pActivity.AddView(scroll,0,110dip,100%x,100%y-110dip)
	pActivity.AddView(book_scroll,0,56dip*2,100%x,100%y-56dip*2)
	tback.Initialize("tback",2000)
End Sub

Sub theme
	img_item_header_menu.Bitmap = LoadBitmap(File.DirAssets,"header.png")
	pnlhomemenu.Color= Main.right_menu_cl
	HeaderPanel.Color= Main.header_cl
	SearchParent.Color= Main.background_cl
	mv.setNavigationBarColor(Main.footer_cl)
	TabLayout.Color = Main.header_cl

	pActivity.Color = Main.activity_cl
	Activity.Color = Main.activity_cl
	lbl_item_menu_01.TextColor = Main.text_cl
	lbl_item_menu_03.TextColor = Main.text_cl
	lbl_item_menu_04.TextColor = Main.text_cl
	lbl_item_menu_05.TextColor = Main.text_cl
	lbl_item_menu_06.TextColor = Main.text_cl
	lbl_item_menu_07.TextColor = Main.text_cl
	icon_01.TextColor = Main.text_cl
	icon_03.TextColor = Main.text_cl
	icon_04.TextColor = Main.text_cl
	icon_05.TextColor = Main.text_cl
	icon_06.TextColor = Main.text_cl
	icon_07.TextColor = Main.text_cl
	TabLayout.SetTabTextColors(Main.text_cl,Colors.DarkGray)
	TabLayout.SelectedTabIndicatorColor = Colors.DarkGray
	MenuClick.TextColor = Main.text_cl
	Search.TextColor = Main.text_cl
	lblNameApp.TextColor = Main.text_cl
End Sub

Sub set_pictuer (n As Int)
	
	Dim filename As String
	filename = map_library.Get("Image")
	
	Select n
		Case 0
			img_book3.Bitmap = LoadBitmap(File.DirAssets,"book_img/"& filename)
		Case 1
			img_book2.Bitmap = LoadBitmap(File.DirAssets,"book_img/"& filename)
		Case 2
			img_book1.Bitmap = LoadBitmap(File.DirAssets,"book_img/"& filename)
	End Select
	
End Sub


Sub LoadpActivity
	pActivity.Initialize("")
	pActivity.Color = Main.item_cl
	pActivity.SendToBack
End Sub


Sub Activity_Resume
	theme_int  = Functions.theme_number
	If day_night = "day" Then
		objUISwitch.SetPosition(1)
	Else If day_night = "night" Then
		objUISwitch.SetPosition(0)
	End If
	Functions.Set_Color(theme_int)
	theme
	pActivity.Color = Main.activity_cl
	If book_scroll.IsInitialized Then
		book_scroll.Color = Main.activity_cl
	End If
End Sub

Sub Activity_Pause (UserClosed As Boolean)
'	Activity.Finish
End Sub

Sub InitializeHeader
	HeaderPanel.Initialize("")

	HeaderPanel.Color=Colors.RGB(17,171,205)
	pActivity.AddView(HeaderPanel,0,0,100%x,56dip)
	
	
	Dim Left As Int = 8dip
	If 100%x>100%y Then Left=16dip
	pActivity.AddView(SearchParent,Left,8dip,100%x-(Left*2),48dip)
	
	Dim Color As GradientDrawable
	Color.Initialize("TOP_BOTTOM",Array As Int(Colors.RGB(255,255,255),Colors.Transparent))
	Color.CornerRadius=2dip
	SearchParent.Background=Color
	SearchParent.Elevation=2dip
	MakeDefaultViews(SearchParent)
End Sub

Private Sub MakeDefaultViews (SearchParent1 As Panel)
	Parent.Initialize("background")
	Parent.Enabled=False
	Parent.Visible=False
	pActivity.AddView(Parent,0,0,100%x,100%y)
	Parent.Color=Colors.ARGB(0,255,255,255)
	Parent.Elevation=8dip
	
	SearchBarBackground.Initialize("")
	Dim Left As Int = 8dip
	If 100%x>100%y Then Left=16dip
	Parent.AddView(SearchBarBackground,Left,8dip,100%x-(Left*2),48dip)
	SearchBarBackground.Visible=False
	SearchBarPreview=SearchParent1
	SearchBarPreviewParent=SearchBarPreview.Parent
	Dim Color As GradientDrawable
	Color.Initialize("TOP_BOTTOM",Array As Int(Colors.White,Colors.White))
	Color.CornerRadius=2dip
	SearchBarBackground.Background=Color
	SearchBarBackground.Elevation=2dip
	
	Divider.Initialize("")
	Divider.Color=Colors.LightGray
	Divider.Visible=False
	SearchBarBackground.AddView(Divider,0, _
	SearchBarBackground.Height-1dip,SearchBarBackground.Width,1dip)
	
	MenuClick.Initialize("MenuClick")
	MenuClick.TextColor=Colors.White
	MenuClick.Text=Chr(0xE5D2)
	MenuClick.TextSize=22
	MenuClick.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	MenuClick.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	SearchParent1.AddView(MenuClick,SearchParent1.Width-48dip,0,64dip,48dip)
	
	

	menu1.Initialize("Menu")
	menu1.StartDrawable = "ic_drawer_to_arrow"
	menu1.EndDrawable = "ic_arrow_to_drawer"
	SearchBarBackground.AddView(menu1,SearchParent1.Width-28dip,12dip,24dip,24dip)
	
	Dim SearchClick1 As Label
	SearchClick1.Initialize("SearchClick1")
	SearchBarBackground.AddView(SearchClick1,100%x-48dip,0,64dip,48dip)
	
	Search.Initialize("Search")
	Search.TextColor=Colors.White
	Search.Text=Chr(0xE8B6)
	Search.TextSize=22
	Search.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	Search.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	SearchParent1.AddView(Search,0,0,48dip,48dip)
	
	MenuSearch.Initialize("MenuSearch")
	MenuSearch.TextColor=Colors.DarkGray
	MenuSearch.Text=Chr(0xE8B6)
	MenuSearch.TextSize=22
	MenuSearch.Tag=0
	MenuSearch.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	MenuSearch.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	SearchBarBackground.AddView(MenuSearch,0,0,48dip,48dip)
	

	
	lblNameApp.Initialize("lblNameApp")
	SearchParent1.AddView(lblNameApp,35%x,12dip,30%x,24dip)
	lblNameApp.Text = Application.LabelName
	lblNameApp.TextColor=Colors.White
'	lblNameApp.Color=Colors.red
	lblNameApp.TextSize=15
	lblNameApp.Typeface=Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	lblNameApp.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	
	
	Dim SearchClick2 As Label
	SearchClick2.Initialize("SearchClick2")
	SearchParent1.AddView(SearchClick2,64dip,0,Search.Left-64dip,48dip)
	

	
	EdSearchTop.Initialize("EdSearchTop")
	EdSearchTop.Hint="البحث ..."
	EdSearchTop.Text=""
	EdSearchTop.TextSize=13
	EdSearchTop.Typeface=Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	EdSearchTop.Gravity=Bit.Or(Gravity.RIGHT,Gravity.CENTER_VERTICAL)
	EdSearchTop.HintColor=Colors.Gray
	EdSearchTop.TextColor=Colors.Black
	EdSearchTop.Color=Colors.Transparent
	EdSearchTop.SingleLine=True
	
	Dim Ime As IME
	Ime.Initialize("ime")
	Ime.AddHeightChangedEvent
	SearchBarBackground.AddView(EdSearchTop,48dip,0,SearchBarBackground.Width-96dip,48dip)
	Dim Jo As JavaObject = EdSearchTop
	Jo.RunMethod("setImeOptions", Array (268435456))
	
	
	Shadow.Initialize("")
	Shadow.Color=Colors.ARGB(125,0,0,0)
	Shadow.Visible=False
'	Shadow.Elevation = 10dip
'	Shadow.SendToBack 
	
	Dim P As Phone
	If P.SdkVersion >= 21 Then
		Parent.AddView(Shadow,0,0,100%x,100%y)
	End If
		
	
	
	
End Sub

Sub objUISwitch_Click(pPosition As Int,pTag As String)
	theme_int  = Functions.theme_number
	Log("(day_night) :"&day_night)
	If day_night = "night" Then
		day_night = "day"
		Main.sql1.ExecNonQuery("UPDATE personalsetting SET day_night= 0")
	Else
		day_night = "night"
		Main.sql1.ExecNonQuery("UPDATE personalsetting SET day_night= 1")
	End If
	Functions.Set_Color(theme_int)
	theme
	Select VP.CurrentPage
		Case 0
			book_scroll.Panel.Color = Main.item_cl
			book_scroll.Color = Main.item_cl
			pActivity.Color = Main.item_cl

		Case 1
			If day_night = "night" Then
				If RV_Content.IsInitialized Then
					If RV_Content.Adapter<>Null Then RV_Content.Adapter2.NotifyDataSetChanged
					RV_Content.Color =  Colors.LightGray
				End If
			Else
				If RV_Content.IsInitialized Then
					If RV_Content.Adapter<>Null Then RV_Content.Adapter2.NotifyDataSetChanged
					RV_Content.Color =  Colors.White
				End If
			End If
		Case 2
			If day_night = "night" Then
				If RV_bookmark.IsInitialized Then
					If RV_bookmark.Adapter<>Null Then RV_bookmark.Adapter2.NotifyDataSetChanged
					RV_bookmark.Color =  Colors.LightGray
				End If
			Else
				If RV_bookmark.IsInitialized Then
					If RV_bookmark.Adapter<>Null Then RV_bookmark.Adapter2.NotifyDataSetChanged
					RV_bookmark.Color =  Colors.White
				End If
			End If
	End Select
	
End Sub

'Sub AppDay
'	theme	
'End Sub

Sub rdDay_CheckedChange(Checked As Boolean)
	Log(Checked)
	If Checked Then
		HeaderPanel.Color = Colors.DarkGray
		TabLayout.Color = Colors.DarkGray
		Activity.Color = Colors.LightGray
	Else
		HeaderPanel.Color=Colors.RGB(17,171,205)
		TabLayout.Color = Colors.RGB(17,171,205)
		Activity.Color=Colors.RGB(238,238,238)
	End If
End Sub


Private Sub IME_HeightChanged (NewHeight As Int, OldHeight As Int)
	If NewHeight=100%Y And IsShowed Then
		HideSearchBar
	End If
End Sub

Private Sub lblNameApp_Click
	SearchClick_Click
End Sub

Private Sub Search_Click
	SearchClick_Click
End Sub

Private Sub MenuSearch_Click
	Log(MenuSearch.Tag)
	Select MenuSearch.Tag
		Case 0
			Search_Click
		Case 1
			MenuSearch.Text=Chr(0xE8B6)
			MenuSearch.Tag=0
			EdSearchTop.Text=""
	End Select
End Sub
Private Sub SearchClick_Click
	Log(EdSearchTop.Text)
	Log("SearchClick")
	If SearchBarBackground.Visible Then
		HideSearchBar
		
		act_search.usersearch = EdSearchTop.Text
		StartActivity(act_search)
	Else
		ShowSearchBar
	End If
	
	
End Sub

Sub EdSearchTop_EnterPressed
	SearchClick_Click
End Sub

Sub SearchLbl_Click
	If EdSearchTop.Visible=True Or EdSearchTop.Text<>""  Then
		Log("HideSearchBar")
		Log("EdSearchTop: "&EdSearchTop.Text)
		HideSearchBar
	Else
		Log("ShowSearchBar")
		ShowSearchBar
	End If
	
End Sub


Public Sub ShowSearchBar
	IsShowed=True
	SetViewVisibles(0)
	
	If menu1.State=menu1.MorphStates(0) Then
		menu1.StateAnimated=menu1.MorphStates(1)
	End If
	
	Dim ime As IME
	ime.Initialize("")
	Sleep(0)
	ime.ShowKeyboard(EdSearchTop)
End Sub

Public Sub HideSearchBar
	IsShowed=False
	Dim ime As IME
	ime.Initialize("")
	ime.HideKeyboard
	
	SetViewVisibles(1)
	
	If menu1.State=menu1.MorphStates(1) Then
		menu1.StateAnimated=menu1.MorphStates(0)
	End If
	
'	EdSearchTop.Text=""
End Sub

Private Sub Menu_onstatechanged(changedTo As Object, animated As Boolean)
	Dim timerBack As Timer
	timerBack.Initialize("tback",150)
	timerBack.Enabled=True
	Wait For (timerBack) tback_Tick
	timerBack.Enabled=False
	If changedTo=menu1.MorphStates(0) Then
		SetViewVisibles(2)
	End If
End Sub


Private Sub SetViewVisibles (Visible As Int)
	If Visible=0 Then
'		GooglePlayPreviewImage.Visible=False
		Parent.Enabled=True
		Parent.Visible=True
		EdSearchTop.Visible=True
		SearchBarPreviewParent.SendToBack
		SearchBarBackground.BringToFront
		Parent.BringToFront
		SearchBarBackground.Visible=True
	
		Divider.Visible=True
		SearchBarPreview.Visible=Not(SearchBarBackground.Visible)
		Shadow.BringToFront
		Shadow.SetVisibleAnimated(150,True)
	
	Else If Visible=1 Then
		Parent.Enabled=True
		Parent.Visible=True
'		GooglePlayPreviewImage.Visible=True
		Parent.BringToFront
		Shadow.SetVisibleAnimated(150,False)
		EdSearchTop.Visible=False
		SearchBarPreviewParent.SendToBack
		
	
	Else if Visible=2 Then
		SearchBarBackground.BringToFront
		Parent.Enabled=False
		Parent.Visible=False
		SearchBarBackground.Visible=False
		Divider.Visible=False
		SearchBarPreview.Visible=Not(SearchBarBackground.Visible)
		Shadow.BringToFront
'		GooglePlayPreviewImage.Visible=False
		EdSearchTop.Visible=True
	End If
End Sub


Sub InitializeTab
	PC.Initialize
	
	
	
	Dim p(3) As Panel
	Dim Titles() As String =  Array As String("عرض الكتب","عرض العناوين","العلامات المرجعية")
	For i = 0 To 2 Step 1

		p(i).Initialize("")
'		p(i).LoadLayout("pnl_list_categorys")
		PC.AddPage(p(i),Titles(i))
'		PC.notifyDataSetChanged
		
	Next


	VP.Initialize2(PC, "VP")
	pActivity.AddView(VP,0,100dip,100%x,100%y)
'	VP.Color=Colors.Blue
	VP.PageContainer = PC
	VP.CurrentPage = 0
	VP.SendToBack
	
	
	TabLayout.Initialize(VP, "TabLayout")
'	TabLayout.Color = Colors.RGB(17,171,205)
	TabLayout.TabMode = TabLayout.MODE_FIXED
	TabLayout.SetTabTextColors(Colors.Black,Colors.RGB(216,231,144))
	
'	TabLayout.SetTabTextColors(Colors.White,Colors.RGB(216,231,144))
'	TabLayout.SelectedTabIndicatorColor = Colors.RGB(216,231,144)
	TabLayout.TabGravity = Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	TabLayout.Typeface=Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	TabLayout.TextSize = 12
'	TabLayout.SetScrollPosition(i,0,True)

'	TabLayout.GetTabAt(0).SetText("").SetIcon2(LoadBitmap(File.DirAssets,"github_64x64.png"))
'	TabLayout.GetTabAt(1).SetText("").SetIcon2(LoadBitmap(File.DirAssets,"abc_ic_menu_cut_mtrl_alpha.png"))
'	TabLayout.GetTabAt(2).SetText("").SetIcon2(LoadBitmap(File.DirAssets,"abc_ic_menu_cut_mtrl_alpha.png"))
	
	pActivity.AddView(TabLayout,0,56dip,100%x,56dip)
	
End Sub


Sub TabLayout_TabSelected (Tabs As Hitex_Tab)
	
	If book_scroll.IsInitialized Then
		book_scroll.Visible = False
	End If
	
	If scroll.IsInitialized  Then
		scroll.Visible = False
	End If
	
	If Itembookmark.IsInitialized Then
		RV_bookmark.Visible=False
	End If
	
	If ItemContent.IsInitialized Then
		RV_Content.Visible=False
	End If


	
	WhichFever ="null"
	If Tabs.position = 0 Then
		' تب اول
		book_scroll.Panel.RemoveAllViews
		loadItemListbook
		make_library
	
	Else If Tabs.Position = 1 Then
		' تب دوم
		book_scroll.Visible = False
		
		If RV_Content.IsInitialized=False Then
			Initialize_RV_Content
		End If
		pActivity.Color = Main.item_cl
		loadItemContent
		RV_Content.Visible=True
		RV_Content.ScrollToPosition(0)
	Else If Tabs.Position = 2 Then
		' تب سوم
		pActivity.Color = Main.item_cl
		book_scroll.Visible = False
		If RV_bookmark.IsInitialized=False Then
			Initialize_RV_bookmark
		End If
		loadItembookmark
		
		RV_bookmark.Visible=True
		RV_bookmark.ScrollToPosition(0)
		
	End If
		
	
End Sub

#Region RV_listbook 'تب دوم

Sub loadItemListbook
	ItemListbook.Initialize
	ItemListbook.Clear
	
	
	cr_booklist = Main.sql1.ExecQuery("SELECT * FROM booklist ORDER BY id_show ASC")
	For i=0 To cr_booklist.RowCount - 1
		cr_booklist.Position=i
		ItemListbook.Add(CreateMap("id":cr_booklist.GetInt("id"),"Idbook":cr_booklist.GetInt("id_show"),"Title":cr_booklist.GetString("title"),"Description":cr_booklist.GetString("wid"),"Image":cr_booklist.GetInt("id_show")&".jpg"))
'		LogColor(("Image":"file:///android_asset/book_img/"&cr_booklist.GetInt("id")&".jpg"),colors.Magenta)
	Next
	cr_booklist.Close

'	Log(ItemListbook.Size)
	
	If RV_listbook.IsInitialized Then
		If RV_listbook.Adapter<>Null Then RV_listbook.Adapter2.NotifyDataSetChanged
	End If
		
End Sub

Sub make_library
	Dim mode As Int
	If book_scroll.Visible = False Then
		book_scroll.Visible = True
		Log("scrool.visible")
	End If
	
	Dim position As Int
	Dim s_top As Int = 2%x
	For i =0 To cr_booklist.RowCount-1 Step 3
'		Log("i1 :"&i)
		Dim p1 As Panel

		p1.Initialize("")
		p1.Width = 100%x
		p1.Height = 100%y
		p1.LoadLayout("cart")
		position = i
		
		If position <= cr_booklist.RowCount-1 Then
			position = i
			mode = position Mod 3
'			Log("mod :"&mode)
			map_library = ItemListbook.Get(position)
			img_book3.Tag = map_library.Get("id")&"/"&map_library.Get("Title")
			set_pictuer(mode)
		Else
			img_book3.Visible =False
		End If
		
		If position < cr_booklist.RowCount-1 Then
			position = i+1
			mode = position Mod 3
'			Log("mod :"&mode)
			map_library = ItemListbook.Get(position)

			img_book2.Tag = map_library.Get("id")&"/"&map_library.Get("Title")
			set_pictuer(mode)
		Else
			img_book2.Visible =False
		End If
		
		
		If position < cr_booklist.RowCount-1 Then
			position = i+2
			mode = position Mod 3
'			Log("mod :"&mode)
			map_library = ItemListbook.Get(position)
			img_book1.Tag = map_library.Get("id")&"/"&map_library.Get("Title")
			set_pictuer(mode)
		Else
			img_book1.Visible =False
		End If

		
		
		book_scroll.Panel.AddView(p1,0%x,s_top,100%x,23%y)
		s_top = s_top +p1.Height
		pnl_center.Color = Colors.Transparent

	Next
	
	If day_night = "day" Then
		book_scroll.Panel.Color = Main.item_cl
		book_scroll.Color = Main.item_cl
		pActivity.Color = Main.item_cl
	Else
		book_scroll.Panel.Color = Main.background_cl
		book_scroll.Color = Main.background_cl
		pActivity.Color = Main.background_cl
	End If

	book_scroll.Panel.Height = s_top+1%x
End Sub


Sub img_book_Click
'	Log(Position)
	Dim img As ImageView
	img.Initialize("")
	img = Sender
	Log("img.Tag: "&img.Tag)
	Dim split() As String = Regex.Split("/",img.Tag)
	
	Act_Contents_Book.Idbook = split(0)
	Act_Contents_Book.Idpage = 1
	Act_Contents_Book.book_name = split(1)
	settingsCur = Main.sql1.ExecQuery("SELECT * FROM personalsetting")
	settingsCur.Position = 0
	displaytype = settingsCur.GetString("displaytype")
	
	If displaytype = "1" Then
		Act_Contents_Book.statusListView = 1
	Else
		Act_Contents_Book.statusListView = 0
	End If
	StartActivity(Act_Contents_Book)

End Sub

#End Region

#Region loadContents 'تب سوم
Sub loadItemContent
	ItemContent.Initialize
	cr_booklist = Main.sql1.ExecQuery("SELECT * FROM booklist ORDER BY id_show ASC")
	For i=0 To cr_booklist.RowCount - 1
		cr_booklist.Position=i
		ItemContent.Add(CreateMap("id":cr_booklist.GetInt("id"),"Idbook":cr_booklist.GetInt("id"),"Title":cr_booklist.GetString("title"),"Image":cr_booklist.GetInt("id_show")&".jpg","Description":cr_booklist.GetString("wid"),"listContent":"مجله 1"))
		
	Next
	cr_booklist.Close
	
	AllData.Initialize
	AllData.AddAll(ItemContent)
	

	If RV_Content.IsInitialized Then
		If RV_Content.Adapter<>Null Then RV_Content.Adapter2.NotifyDataSetChanged
	End If
		
	
End Sub


Public Sub Initialize_RV_Content
		
	RV_Content.Initializer("RV_Content").ListView.Vertical.Build
'	Scroll1.Panel.AddView(RV_Content,0,0,100%x,100%y)
	pActivity.AddView(RV_Content,0,56dip*2,100%x,100%y-56dip*2)
	RV_Content.ScrollToEndListener(True)
	RV_Content.BringToFront
	RV_Content.LayoutDirection=RV_Content.LAYOUT_DIRECTION_RTL
	RV_Content.DefaultAdapter
	
	RV_Content.ScrollSettings.OverScrollMode= _
	RV_Content.ScrollSettings.OVER_SCROLL_NEVER
	
End Sub



Sub RV_Content_onCreateViewHolder (Parentt As Panel,ViewType As Int)
	Card_Content_OnCreate(Parentt,RV_Content.LayoutSpanCount)
End Sub

Sub RV_Content_onBindViewHolder (Parentt As Panel,Position As Int)
	Card_Content_OnBind(Parentt,ItemContent.Get(Position),Position)
End Sub

Sub RV_Content_GetItemCount As Int
	Return ItemContent.Size
End Sub

Sub RV_Content_DividerColor (Position As Int) As Int
	Return  Functions.GetColor(Position)
End Sub

Sub RV_Content_DividerLeftMargin (Position As Int) As Int
	Return Position * 16dip
End Sub

Sub RV_Content_DividerRightMargin (Position As Int) As Int
	Return Position * 16dip
End Sub

Sub RV_Content_onScrolledToEnd
'	ToastMessageShow("End of List",False)
End Sub


Public Sub Card_Content_OnCreate (Holder As Panel, Span As Int)
	Dim SectionHolder As Panel
	SectionHolder.Initialize("SectionHolder")
	Holder.AddView(SectionHolder,12dip,6dip,Holder.Width - 24dip,50dip)
	Dim GD As GradientDrawable
	GD.Initialize("TOP_BOTTOM",Array As Int (Colors.White,Colors.White))
	GD.CornerRadius = 4dip
	SectionHolder.Background = GD
	SectionHolder.Elevation = 2dip
	
	
	Dim Title As Label
	Title.Initialize("Title")
	Title.Gravity = Bit.Or(Gravity.CENTER_VERTICAL,Gravity.RIGHT)
	Title.TextColor = Colors.DarkGray
	Title.Typeface = Typeface.DEFAULT_BOLD
	Title.TextSize = 14
	SectionHolder.AddView(Title,2dip,2dip,100%x-120dip,125dip)
	Title.Typeface=Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
'	Title.Color =Colors.Red
	
	Dim btm_img As Button
	btm_img.Initialize("")
	btm_img.Gravity = Gravity.FILL
	SectionHolder.AddView(btm_img,100%x-114dip,3dip,86dip,130dip)

	
	
	
End Sub
  

Public Sub Card_Content_OnBind (Holder As Panel,Data As Map, Position As Int)
	Dim SectionHolder = Holder.GetView(0) As Panel
	Dim Title = SectionHolder.GetView(0) As Label
	Dim btn = SectionHolder.GetView(1) As Button

	Title.Text = Data.Get("Title")
	
	Holder.Height = Title.Height + 20dip
	SectionHolder.Height =  Title.Height +10dip
	
	Dim btm As Bitmap
'	LoadBitmap(File.DirAssets,"book_img/"& filename)
	btm.Initialize(File.DirAssets,"book_img/"&Data.Get("Image"))
	btn.SetBackgroundImage(btm)
	
	
'	Dim avm As Amir_ViewManager
'	avm.Initialize(btm)
'	avm.BottomRightRadius = 5
'	avm.TopRightRadius = 5
''	avm.BackgroundColor = Colors.Blackq
'	avm.Start
	

	
End Sub




Sub RV_Content_onItemClick (Parentt As Panel,Position As Int)
	Log(Position)
	Dim DataMap As Map = ItemContent.Get(Position)
	Dim Idbook As String=DataMap.Get("id")

	Log("Idbook: "&Idbook)


	Act_Contents_Book.Idbook = Idbook
	Act_Contents_Book.Idpage = 1
	Act_Contents_Book.book_name = DataMap.Get("Title")

	Act_Contents_Book.statusListView = 0

	If displaytype = "1" Then
		Act_Contents_Book.statusListView = 1
	Else
		Act_Contents_Book.statusListView = 0
	End If
	StartActivity(Act_Contents_Book)

End Sub

#End Region

#Region RV_bookmark ' تب چهارم

Sub loadItembookmark
	
	Itembookmark.Initialize
	Itembookmark.Clear
	
	
	
	cr_booklist = Main.sql1.ExecQuery("SELECT * FROM bookmark ORDER BY id DESC")
	LogColor("RowCount: "&cr_booklist.RowCount,Colors.Blue)
	For i=0 To cr_booklist.RowCount - 1
		cr_booklist.Position=i

		Log("idbook: "&cr_booklist.GetInt("idbook"))
		Log("idpage: "&cr_booklist.GetInt("idpage"))


		Log("SELECT * FROM b"&cr_booklist.GetInt("idbook")&"_pages WHERE id="&cr_booklist.GetInt("idpage")&" ")
		cr_bookmark = Main.sql1.ExecQuery("SELECT * FROM b"&(cr_booklist.GetInt("idbook"))&"_pages WHERE id="&cr_booklist.GetInt("idpage")&" ")
		For j=0 To cr_bookmark.RowCount - 1
			cr_bookmark.Position=j

			Log("SELECT * FROM booklist WHERE id_show="&cr_booklist.GetInt("idbook")&" ")
			crtitle = Main.sql1.ExecQuery("SELECT * FROM booklist WHERE id="&cr_booklist.GetInt("idbook")&" ")
			crtitle.Position=0
'			LogColor(crtitle.GetString("title"),Colors.Magenta)
			Itembookmark.Add(CreateMap("id":crtitle.GetInt("id"),"Idbook":crtitle.GetInt("id_show"),"Title":crtitle.GetString("title"),"PageNumber":cr_bookmark.GetInt("id")))

			crtitle.Close
			
			
		Next
		cr_bookmark.Close
		
		

	Next
	cr_booklist.Close
	
	
	If RV_bookmark.IsInitialized Then
		If RV_bookmark.Adapter<>Null Then RV_bookmark.Adapter2.NotifyDataSetChanged
	End If
		
	
End Sub



Public Sub Initialize_RV_bookmark
		
	RV_bookmark.Initializer("RV_bookmark").ListView.Vertical.Build
'	Scroll1.Panel.AddView(RV_bookmark,0,0,100%x,100%y)
	pActivity.AddView(RV_bookmark,0,56dip*2,100%x,100%y-56dip*2)
	RV_bookmark.ScrollToEndListener(True)
	RV_bookmark.BringToFront
	RV_bookmark.LayoutDirection=RV_bookmark.LAYOUT_DIRECTION_RTL
	RV_bookmark.DefaultAdapter
	
'	Dim R,G,B As Int
'	R = Rnd( 0, 256)
'	G = Rnd( 0, 256)
'	B = Rnd( 0, 256)
'	RV_bookmark.Color=Colors.RGB(R,G,B)

	RV_bookmark.ScrollSettings.OverScrollMode= _
	RV_bookmark.ScrollSettings.OVER_SCROLL_NEVER


End Sub



Sub RV_bookmark_onCreateViewHolder (Parentt As Panel,ViewType As Int)
	Card_bookmark_OnCreate(Parentt,RV_bookmark.LayoutSpanCount)
End Sub

Sub RV_bookmark_onBindViewHolder (Parentt As Panel,Position As Int)
	Card_bookmark_OnBind(Parentt,Itembookmark.Get(Position),Position)
End Sub

Sub RV_bookmark_GetItemCount As Int
	Return Itembookmark.Size
End Sub

Sub RV_bookmark_DividerColor (Position As Int) As Int
	Return  Functions.GetColor(Position)
End Sub

Sub RV_bookmark_DividerLeftMargin (Position As Int) As Int
	Return Position * 16dip
End Sub

Sub RV_bookmark_DividerRightMargin (Position As Int) As Int
	Return Position * 16dip
End Sub

Sub RV_bookmark_onScrolledToEnd
'	ToastMessageShow("End of List",False)
End Sub


Public Sub Card_bookmark_OnCreate (Holder As Panel, Span As Int)
	Dim SectionHolder As Panel
	SectionHolder.Initialize("SectionHolder")
	Holder.AddView(SectionHolder,12dip,6dip,Holder.Width - 24dip,50dip)
	Dim GD As GradientDrawable
	GD.Initialize("TOP_BOTTOM",Array As Int (Colors.White,Colors.White))
	GD.CornerRadius = 4dip
	SectionHolder.Background = GD
	SectionHolder.Elevation = 2dip
	
	
	Dim delitem As Label
	delitem.Initialize("delitem")
	delitem.TextColor=Colors.DarkGray
	delitem.Text=Chr(0xE92B)
	delitem.TextSize=25
	delitem.Typeface=Typeface.LoadFromAssets("MaterialIcons.ttf")
	delitem.Gravity=Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	SectionHolder.AddView(delitem,0,0,48dip,48dip)
	
	
	Dim PageNumber As Label
	PageNumber.Initialize("PageNumber")
	PageNumber.Gravity = Bit.Or(Gravity.CENTER_VERTICAL,Gravity.CENTER_HORIZONTAL)
	PageNumber.TextColor = Colors.DarkGray
	PageNumber.Typeface = Typeface.DEFAULT_BOLD
	PageNumber.TextSize = 11
	SectionHolder.AddView(PageNumber,8dip+delitem.Width,4dip,80dip,40dip)
	PageNumber.Typeface=Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
'	PageNumber.Color=Colors.red
	
	Dim Title As Label
	Title.Initialize("Title")
	Title.Gravity = Bit.Or(Gravity.CENTER_VERTICAL,Gravity.RIGHT)
	Title.TextColor = Colors.DarkGray
	Title.Typeface = Typeface.DEFAULT_BOLD
	Title.TextSize = 14
	SectionHolder.AddView(Title,8dip+PageNumber.Left+PageNumber.Width,4dip,100%x-40dip-PageNumber.Left-PageNumber.Width,80dip)
	Title.Typeface=Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
'	Title.Color=Colors.Blue


	
	
'	Dim SectionAction As Panel
'	SectionAction.Initialize("ItemAction")
'	SectionHolder.AddView(SectionAction,0,0,SectionHolder.Width,SectionHolder.Height)
'	Dim ac As AppCompat
'	ac.SetClickEffect(SectionAction,True)
	
End Sub


Public Sub Card_bookmark_OnBind (Holder As Panel, Data As Map, Position As Int)
	Dim SectionHolder = Holder.GetView(0) As Panel
	Dim delitem = SectionHolder.GetView(0) As Label
	delitem.Tag = Position
	Dim PageNumber = SectionHolder.GetView(1) As Label
	Dim Title = SectionHolder.GetView(2) As Label
	
'	Dim SectionAction = SectionHolder.GetView(3) As Panel
	Title.Text = Data.Get("Title")
	PageNumber.Text = Data.Get("PageNumber")

	Title.Height =  Functions.GetTextHeight(Title)+15dip
'	PageNumber.top =  Title.Height+10dip
'	PageNumber.Height =  Functions.GetTextHeight(Title)

	
	
'	SectionAction.Tag = Position
'	SectionAction.Height = SectionHolder.Height
	Holder.Height = Title.Height + 20dip
	SectionHolder.Height = Title.Height +10dip
End Sub

Sub delitem_Click
	Dim lbldel As Label = Sender
	Dim Position As Int = lbldel.Tag
	Dim Map As Map = Itembookmark.Get(Position)
	Dim PageNumber As String=Map.Get("PageNumber")
	
	If Msgbox2("هل أنت متأكد من عملية الحذف؟","","نعم","لا","",Null) = DialogResponse.POSITIVE Then
		ToastMessageShow("تم الالغاء من المفضلة .",False)
		Log(Map.Get("id"))
		Main.sql1.ExecNonQuery("DELETE FROM bookmark WHERE idpage = "&PageNumber&" AND idbook="&Map.Get("id"))
		
		If RV_bookmark.IsInitialized=False Then
			Initialize_RV_bookmark
		End If
		loadItembookmark
	End If
End Sub


Sub RV_bookmark_onItemClick (Parentt As Panel,Position As Int)
	Log(Position)
	Dim DataMap As Map = Itembookmark.Get(Position)
	Dim Idbook As String=DataMap.Get("id")
	Dim PageNumber As String=DataMap.Get("PageNumber")
 
	Log("Idbook: "&Idbook)
	Log("PageNumber: "&PageNumber)
	Act_Contents_Book.Idbook = Idbook
	
	
	
	Act_Contents_Book.statusListView = 0
	crtitle = Main.sql1.ExecQuery("SELECT page FROM b"&Idbook&"_pages WHERE id="&PageNumber)
	crtitle.Position=0
	Act_Contents_Book.Idpage = crtitle.GetInt("page")

	act_listcontent.listcontent_page = True
	StartActivity(Act_Contents_Book)
'	Activity.Finish
End Sub
#End Region

#Region menuright

Sub	menuright
	
	navi.Initialize2("navi",Activity,290dip,navi.GRAVITY_RIGHT)
	navi.NavigationPanel.Color = Colors.ARGB(255,236,239,241)
	navi.NavigationPanel.LoadLayout("menu")
	navi.ContentPanel.AddView(pActivity,0,0,100%x,100%y)
	
	Dim objBmp0 As Bitmap = LoadBitmap(File.DirAssets, "switchOne_on@2x.png")
	Dim objBmp1 As Bitmap = LoadBitmap(File.DirAssets, "switchOne_off@2x.png")
	objUISwitch.Initialize(Me,"objUISwitch","1",55dip,20dip,objBmp0,objBmp1)
	pnl_item_menu_07.AddView(objUISwitch.asView,20dip,1.2%y,55dip,48dip)
	

	If day_night = "day" Then
		objUISwitch.SetPosition(1)
	Else
		objUISwitch.SetPosition(0)
	End If

End Sub

Sub Panelmenu_Touch (Action As Int, X As Float, Y As Float)
'	Log(X)
End Sub



Private Sub MenuClick_Click
	Log("Menu Button Clicked!")
	navi.OpenDrawer2(navi.GRAVITY_RIGHT)
End Sub



Sub pnl_item_menu_01_Click

	navi.CloseDrawer2(navi.GRAVITY_RIGHT)
End Sub

Sub pnl_item_menu_02_Click
'	StartActivity(questions_groups)
	act_about.FormAbout = 2
	navi.CloseDrawer2(navi.GRAVITY_RIGHT)
End Sub

Sub pnl_item_menu_03_Click
	StartActivity(act_about)
	act_about.FormAbout = 1
	navi.CloseDrawer2(navi.GRAVITY_RIGHT)
End Sub

Sub pnl_item_menu_04_Click
	navi.CloseDrawer2(navi.GRAVITY_RIGHT)
	StartActivity(act_favorite)
End Sub

Sub pnl_item_menu_05_Click
	Activity.Finish
	navi.CloseDrawer2(navi.GRAVITY_RIGHT)
	StartActivity(act_settings)
End Sub

Sub pnl_item_menu_08_Click
	Dim Message As Email
	Message.To.Add("almaerifa1234@gmail.com")
	StartActivity(Message.GetIntent)
End Sub

Sub pnl_item_menu_06_Click
	Dim Arialib As AriaLib
	StartActivity( Arialib.ShareText(""& CRLF & "أدعوك للاطلاع على تطبيق (ميزان الحكمة) وذلك عبر الرابط التالي: " & CRLF & "https://play.google.com/store/apps/details?id=" & Application.PackageName ,"المشاركة ضمن:"))
	'StartActivity( Arialib.ShareApplication(Application.PackageName,"أدعوك للاطلاع على تطبيق (المعرفة الدينية) وذلك عبر الرابط التالي:"))
	navi.CloseDrawer2(navi.GRAVITY_RIGHT)
End Sub

#End Region



Sub tback_Tick
	tback.Enabled = False
End Sub

								#Region exit	
Sub makeExit
	label_exit.Initialize("")
	
	Dim avm As Amir_ViewManager
	avm.Initialize(label_exit)
	avm.BackgroundColor = Colors.aRGB(230,45,45,45)
	avm.BackgroundPressedColor  = Colors.aRGB(230,45,45,45)
	avm.Radius = 11
	avm.StrokeColor = Colors.DarkGray
	avm.StrokeWidth =1
	avm.StrokePressedColor = Colors.DarkGray
	avm.TextColor = Colors.White
	avm.TextPressedColor = Colors.White
	avm.Start
	label_exit.Gravity =Gravity.CENTER
	label_exit.TextSize = 17
'	label_exit.Typeface = Typeface.LoadFromAssets("Al-Jazeera-Arabic-Regular.ttf")
	label_exit.Text =  "اضغط مرة اخرى للخروج من التطبيق.!"
	
	Activity.AddView(label_exit,15%x,88%y,70%x,7%y)
	label_exit.Visible =False
	timerexit.Initialize("timerexit",1500)
	
End Sub

Sub timerexit_Tick
	label_exit.Visible = False
	timerexit.Enabled =False
End Sub
								#End Region


Private Sub Activity_KeyPress (KeyCode As Int) As Boolean

	
	If KeyCode=KeyCodes.KEYCODE_BACK  Then
		If label_exit.Visible = False Then
			
			If Subgroup = "true" And WhichFever = "one" Then
				book_scroll.Panel.RemoveAllViews
				book_scroll.Visible = False
				loadItemListbook
			Else
				anime.FadeIn("",label_exit,1000)
				timerexit.Enabled = True
			End If

		Else
			ExitApplication
		End If
		Return True
	End If
	Return False
End Sub



