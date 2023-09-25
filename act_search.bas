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
	Dim usersearch As String
'	Dim usersearch1  As  String
	Dim isFromSearch As Boolean
	Private cr As Cursor
	Private crg,cr_books As Cursor
	Dim cr_gid As Cursor
	Private timerload As Timer
End Sub

Sub Globals
	Dim search_item As Int
	Private lbl_home_title As Label
	Dim counters As Int = 0
	Private edsearch As EditText
	Dim t As Int = 5dip
	Private choptiontitle As CheckBox
	Private choptiondescription As CheckBox
	Dim Recycler,Recycler2 As Amir_RecyclerView
	Dim var1 As String
	Dim res_count As Int
	Dim start As Int
	Dim limit As Int
	Dim limit_Total	As Int
	Private sp_g As Spinner
	Dim Tid As Int
	Dim gid As Int
	Private PnlHeader As Panel
	Private pnloption_f As Panel
	Dim mv As mv_SystemUI
	Dim ls As List
	Dim ISSubGroup As Boolean = False
	Dim theme_int As Int
	Private pnl_search As Panel
	Dim list_recycler , list_books_recycler As List
	Private lbl_simple_search As Label
	Private lbl_advanced_search As Label
	Dim simple As Boolean = True
	Dim parallax1 ,parallax2 As Amir_RVToolbarParallax
	Private pnl_tab As Panel
	Private Panel1 As Panel
	Private lbl_search_result As Label
	
	Private lbl_back As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	list_recycler.Initialize
	list_recycler.Clear
	list_books_recycler.Initialize
	list_books_recycler.Clear
	
	Activity.LoadLayout("lyt_search")
	lbl_home_title.Text = "البحث"
	
	
	Log("usersearch: "&usersearch)
	theme_int  = Functions.theme_number
	

	edsearch.Text = usersearch
	usersearch = edsearch.Text

	Recycler.Initializer("Amir").ListView.Build
	Recycler.ItemOffsetsListener(True)
	Activity.AddView(Recycler,0%x,150dip,100%x,100%y-150dip)
	Recycler.BringToFront
	
	
	Recycler2.Initializer("Amir_Advance").ListView.Build
	Recycler2.ItemOffsetsListener(True)
	Activity.AddView(Recycler2,0%x,150dip,100%x,100%y-150dip)
	Recycler2.BringToFront
	
	
		parallax1.Initialize(Recycler,Panel1,-50dip)
		parallax1.AddFirstItemSpace(50dip)
		parallax1.Duration=Panel1.Height
		parallax1.IDLEHideSize=parallax1.Duration/2
		parallax1.MinComputeScrollOffset=56dip
		parallax1.ScrollSpeed=1.1
		parallax1.ChangeOnIDLEState=True
		parallax1.StartScrollListener
		
		parallax2.Initialize(Recycler2,Panel1,-110dip)
		parallax2.AddFirstItemSpace(110dip)
		parallax2.Duration=Panel1.Height
		parallax2.IDLEHideSize=parallax2.Duration/2
		parallax2.MinComputeScrollOffset=56dip
		parallax2.ScrollSpeed=1.1
		parallax2.ChangeOnIDLEState=True
		parallax2.StartScrollListener

	
	
	
	make_search_item_tabs(simple)
	lbl_simple_search_Click
'	Log("mmd search"& edsearch.Text)
	load_bookgroups
	btnsearch_Click

	Functions.Set_Color(Functions.theme_number)
	Set_theme
	Panel1.BringToFront
End Sub

Sub make_search_item_tabs (active As Boolean)
	Dim bg_color , Stroke_color As Int
	Dim avm As Amir_ViewManager
	Dim avm2 As Amir_ViewManager


	Stroke_color = Main.header_cl
	bg_color = Main.background_cl
	Recycler.Color = Main.background_cl
	Recycler2.Color = Main.background_cl
	pnl_tab.Color = Main.background_cl
	
	
	
	Panel1.Color = bg_color
	avm.Initialize(lbl_simple_search)
	avm.TopRightRadius = 4dip
	avm.BottomRightRadius = 4dip
	avm.TextColor = Main.text_cl
	avm.TextPressedColor = Colors.LightGray
	avm.StrokeWidth = 1dip
	avm2.Initialize(lbl_advanced_search)
	avm2.TopLeftRadius = 4dip
	avm2.BottomLeftRadius = 4dip
	avm2.TextColor = Main.text_cl
	avm2.TextPressedColor = Colors.LightGray
	avm2.StrokeWidth = 1dip
	
	If active = False Then
		avm2.BackgroundColor = Stroke_color
		avm2.BackgroundPressedColor = Stroke_color
		avm2.StrokeColor = Stroke_color
		avm.BackgroundColor = bg_color
		avm.BackgroundPressedColor = bg_color
		avm.StrokeColor = Stroke_color
		avm.StrokePressedColor = Stroke_color
	Else
		avm.BackgroundColor = Stroke_color
		avm.BackgroundPressedColor = Stroke_color
		avm.StrokeColor = Stroke_color
		avm2.BackgroundColor = bg_color
		avm2.BackgroundPressedColor = bg_color
		avm2.StrokeColor = Stroke_color
		avm2.StrokePressedColor = Stroke_color
	End If
	
	avm.Start
	avm2.Start
	
	
End Sub

Sub lbl_simple_search_Click
	choptiontitle.Checked =  True
	choptiondescription.Checked = True
	gid = 0
	lbl_search_result. Text = ""
	lbl_search_result.SendToBack
	simple = True
	make_search_item_tabs(True)
	list_recycler.Clear
	list_books_recycler.Clear
	search_item = 0
	gid = 0
	Recycler2.Visible = False
	Recycler.Visible = True
	pnloption_f.Visible = False
	pnl_search.Top = 0
	Panel1.Height = pnl_search.Height + lbl_search_result.Height + 6dip
	Panel1.Top =PnlHeader.Height + pnl_tab.Height + 3dip
	lbl_search_result.Top = pnl_search.Height + 3dip
	ISSubGroup = True
End Sub

Sub lbl_advanced_search_Click
	simple = False
	lbl_search_result. Text = ""
	lbl_search_result.SendToBack
	make_search_item_tabs(False)
	list_recycler.Clear
	list_books_recycler.Clear
	search_item = 0
	Recycler.Visible = False
	Recycler2.Visible = True
	
	pnloption_f.Visible = True
	pnl_search.Top = pnloption_f.Height +3dip
	lbl_search_result.Top =pnl_search.Height + pnloption_f.Height + 5dip
	Panel1.Height = 150dip
	ISSubGroup = False
End Sub

Sub Set_theme
	PnlHeader.Color = Main.header_cl
	Activity.Color = Main.activity_cl
	mv.setNavigationBarColor(Main.footer_cl)
	mv.setStatusBarColor(Main.header_cl)
	lbl_back.TextColor = Main.text_cl
	lbl_home_title.TextColor = Main.text_cl

End Sub

Sub Activity_Resume
	Log("log :"&list_recycler.size)
	Log("log :"&list_books_recycler.size)
End Sub

Sub Activity_Pause (UserClosed As Boolean)
	Log("loooooooooooooog :"&list_recycler.size)
	Log("loooooooooooooog :"&list_books_recycler.size)
 End Sub

Sub Activity_KeyPress (KeyCode As Int) As Boolean 'Return True to consume the event
	If KeyCode = KeyCodes.KEYCODE_BACK Then
		If ISSubGroup = True And list_books_recycler.IsInitialized And simple = False Then
			ISSubGroup = False
			search_item = list_books_recycler.Size
			If Recycler2.IsInitialized Then
				If Recycler2.Adapter<>Null Then Recycler2.Adapter2.NotifyDataSetChanged
			End If
			Act_Contents_Book.search_list.Clear
		Else
			lbl_back_Click
		End If
		Return True
	Else
		Return False
	End If
End Sub

Sub lbl_back_Click
	Act_Contents_Book.search_list.Clear
	Activity.Finish
	StartActivity(Act_library)
	isFromSearch=False
End Sub

Sub btnsearch_Click
	counters = 0
	clearscroll
	Act_Contents_Book.search_list.Clear
	list_recycler.Clear
	list_books_recycler.Clear
	If edsearch.Text = "" Then
		ToastMessageShow("يرجى اضافة عبارة البحث ...",False)
		Return
	End If
	
	If edsearch.Text.Length < 3 Then
		ToastMessageShow("لابد ان تتجاوز كلمة البحث  ٣ حروف !",False)
		Return
	End If
	
	If choptiontitle.Checked =  False And choptiondescription.Checked = False Then
		ToastMessageShow("يرجى تحديد نطاق البحث : العنوان او المتن او كليهما ...",False)
		Return
	End If
	ProgressDialogShow2("جاري البحث ...",False)
	usersearch = edsearch.Text
	
	
	
	timerload.Initialize("timerload", 1000)
	timerload.Enabled = True
	
	If choptiondescription.Checked = True Then
		LogColor("choptiondescription.Checked = true",Colors.Red)
	Else
		LogColor("choptiondescription.Checked = false",Colors.Red)
	End If

	If choptiontitle.Checked = True Then
		LogColor("choptiontitle.Checked = true",Colors.Red)
	Else
		LogColor("choptiontitle.Checked = false",Colors.Red)
	End If
	
	Functions.HideKeyboard
	
End Sub

Sub timerload_Tick
	timerload.Enabled = False
	cr_books = Main.sql1.ExecQuery("SELECT * FROM booklist  ORDER BY id ASC")
	Refresh
	cr_books.Close
End Sub

Sub clearscroll
'	Scroll1.Panel.RemoveAllViews
	t = 5dip
'	Scroll1.Panel.Height = 3dip
	start = 0
'	limit=Round(scroll1.Height/50)+5
	limit=6
	res_count=0
End Sub

Public Sub load_bookgroups
	sp_g.Clear
'	If rdo_b.Checked Then
'		sp_g.Add("كافة الاقسام")
'	crg = Main.sql1.ExecQuery("SELECT * FROM bookgroups  ORDER BY id ASC") 
'	End If
'	
'	If rdo_f.Checked Then
		sp_g.Add("كل")
		crg = Main.sql1.ExecQuery("SELECT * FROM booklist  ORDER BY id_show ASC")
'	End If
	
	limit_Total = crg.RowCount
	For i=0 To crg.RowCount-1
		crg.Position=i
		sp_g.Add(Functions.shortenText(Functions.RemoveTags(crg.GetString("title")),35))
	Next
	sp_g.SelectedIndex=0
	crg.Close

End Sub

Sub sp_g_ItemClick (Position As Int, Value As Object)
	Log(Position)
	gid = Position
'	act_text.pageId = gid
End Sub

Public Sub Refresh
	
	Dim list_page As List
	list_page.Initialize

'	Dim q As String = Chr(34)
	var1 = edsearch.Text
	
	var1 = var1.Trim
	var1 = var1.Replace("ی", "ي")
	var1 = var1.Replace("ک", "ك")
	var1 = var1 & " "
	
	Log(var1)
	ls.Initialize

	Dim new_titleFiled(9) As String
	Dim new_textFiled(9) As String
	new_textFiled(0) = "replace(pages._text,'ِ','')"
	new_textFiled(1) = "replace("& new_textFiled(0) & ",'َ','')"
	new_textFiled(2) = "replace("& new_textFiled(1) & ",'ً','')"
	new_textFiled(3) = "replace("& new_textFiled(2) & ",'ُ','')"
	new_textFiled(4) = "replace("& new_textFiled(3) & ",'ٌ','')"
	new_textFiled(5) = "replace("& new_textFiled(4)& ",'ّ','')"
	new_textFiled(6) = "replace("& new_textFiled(5) & ",'ٍ','')"
	new_textFiled(7) = "replace("& new_textFiled(6) & ",'ْ','')"
	new_textFiled(8) = "replace("& new_textFiled(7) & ",'إ','ا')"
					
	new_titleFiled(0) = "replace(chapters.title,'ِ','')"
	new_titleFiled(1) = "replace("& new_titleFiled(0) & ",'َ','')"
	new_titleFiled(2) = "replace("& new_titleFiled(1) & ",'ً','')"
	new_titleFiled(3) = "replace("& new_titleFiled(2) & ",'ُ','')"
	new_titleFiled(4) = "replace("& new_titleFiled(3) & ",'ٌ','')"
	new_titleFiled(5) = "replace("& new_titleFiled(4)& ",'ّ','')"
	new_titleFiled(6) = "replace("& new_titleFiled(5) & ",'ٍ','')"
	new_titleFiled(7) = "replace("& new_titleFiled(6) & ",'ْ','')"
	new_titleFiled(8) = "replace("& new_titleFiled(7) & ",'إ','ا')"

	LogColor(gid,Colors.Yellow)
	ls = Functions.MakeWordsList(var1)
		
	If gid = 0 Then
				
		For iAll = 1 To limit_Total
				
			If iAll > limit_Total Then
				start = limit + 1
				Return
			Else
					
				If choptiontitle.Checked And choptiondescription.Checked Then
					Dim queryTitle As String = " "
				Else
					If choptiontitle.Checked Then
						Dim queryTitle As String = " chapters.title "
						
					Else If choptiondescription.Checked Then
						Dim queryTitle As String = " pages._text "
					End If
						
				End If
				cr_books.Position = iAll - 1
'					Log("mmd :"&cr_books.GetInt("id"))
'					Dim query As String = "Select chapters.did,chapters.page,chapters.title,pages._text,pages.id FROM b"&cr_books.GetInt("id")&"_chapters As chapters	INNER JOIN b"&cr_books.GetInt("id")&"_pages As pages ON chapters.id = pages.id  WHERE "&queryTitle&" "
					
				Dim query As String = " SELECT chapters.page,chapters.title,chapters.bid,pages._text,pages.id,pages.page FROM  b"&cr_books.GetInt("id")&"_pages As pages      LEFT JOIN  b"&cr_books.GetInt("id")&"_chapters As chapters ON  chapters.page = pages.page  WHERE "
				If choptiontitle.Checked And choptiondescription.Checked = False Then
					query = query & " ("&new_titleFiled(8)&" LIKE '%" & var1 & "%' ) "
				Else If choptiondescription.Checked And choptiontitle.Checked = False Then
					query =query & "( "&new_textFiled(8)&" LIKE '%" & var1 & "%' ) "
				Else If choptiontitle.Checked And choptiondescription.Checked Then
					query = query & " ("&new_titleFiled(8)&" LIKE '%" & var1 & "%' OR "&new_textFiled(8)&" LIKE '%" & var1 & "%' ) "
				End If
				
'	
				Log("query: "&query)
	
'				For i = 0 To ls.Size -1
'						
'					If i+1  < ls.Size Then
'							
'						LogColor(ls.Get(i),Colors.Green)
			
'							
''							query = query & " LIKE '%" & ls.Get(i) & "%' AND chapters.title "
'					Else
'							
''							LogColor(ls.Get(i),Colors.Green)
'						If choptiontitle.Checked And choptiondescription.Checked = False Then
'							Log(1111)
'							query = query & "  LIKE '%" & ls.Get(i) & "%'   "
'						Else If choptiondescription.Checked And choptiontitle.Checked = False Then
'							Log(2222)
'							query = query & "  LIKE '%" & ls.Get(i) & "%'  "
'						Else If choptiontitle.Checked And choptiondescription.Checked Then
'							Log(3333)
'							query = query & " ("&new_titleFiled(8)&" LIKE '%" & ls.Get(i) & "%' OR "&new_textFiled(8)&" LIKE '%" & ls.Get(i) & "%' ) "
'						End If
''							query = query & " LIKE '%" & ls.Get(i) & "%' "
'					End If
'						
'				Next
					
				cr= Main.sql1.ExecQuery(query)
			
				For i=0 To cr.RowCount-1
					Dim map_recycler As Map
					map_recycler.Initialize
					cr.Position=i
					res_count = res_count+cr.RowCount
'						LogColor(cr_books.GetInt("id")&"=="&cr.GetInt("id"),Colors.Red)
					map_recycler.Put("id",cr.GetInt("id"))
					map_recycler.Put("page",cr.GetInt("page"))
					map_recycler.Put("book_id",cr_books.GetInt("id"))
					map_recycler.Put("title",cr.GetString("_text"))
					If i = 0 Then
						Log("cr.RowCount ::"&cr.RowCount &"**"&cr_books.GetInt("id"))
					End If
					list_recycler.Add(map_recycler)
						  
				Next
				
						
			End If
			If cr.RowCount <> 0 Then
				Dim map_book_recycler As Map
				map_book_recycler.Initialize
				map_book_recycler.Put("book_id",cr_books.GetInt("id"))
				map_book_recycler.Put("counter",cr.RowCount)
				list_books_recycler.Add(map_book_recycler)
			End If
		Next
			
		Log(res_count)
		start = limit + 1
		limit = start + 9
			
'			If res_count < 10 Then
'			Refresh
'			End If
	Else
		If choptiontitle.Checked And choptiondescription.Checked Then
			Dim queryTitle As String = " "
		Else
			If choptiontitle.Checked Then
				Dim queryTitle As String = " chapters.title "
			Else If choptiondescription.Checked Then
				Dim queryTitle As String = " pages._text "
			End If
		End If
		Log(("SELECT * FROM booklist WHERE id_show ="&gid ))
		cr_gid = Main.sql1.ExecQuery("SELECT * FROM booklist WHERE id_show ="&gid)
			
		Log("cr_gid.RowCount  :"&cr_gid.RowCount)
		If cr_gid.RowCount <> 0 Then
			cr_gid.Position =0
			gid = cr_gid.GetInt("id")
		End If
			
		Log(gid)
		Dim query As String = " SELECT chapters.page,chapters.title,chapters.bid,pages._text,pages.id,pages.page FROM  b"&gid&"_pages As pages      LEFT JOIN  b"&gid&"_chapters As chapters ON  chapters.page = pages.page  WHERE "
		If choptiontitle.Checked And choptiondescription.Checked = False Then
			query = query & " ("&new_titleFiled(8)&" LIKE '%" & var1 & "%' ) "
		Else If choptiondescription.Checked And choptiontitle.Checked = False Then
			query =query & "( "&new_textFiled(8)&" LIKE '%" & var1 & "%' ) "
		Else If choptiontitle.Checked And choptiondescription.Checked Then
			query = query & " ("&new_titleFiled(8)&" LIKE '%" & var1 & "%' OR "&new_textFiled(8)&" LIKE '%" & var1 & "%' ) "
		End If
		
'			Dim query As String = "SELECT chapters.page,chapters.title,chapters.bid,pages._text,pages.id FROM  b"&gid&"_chapters As chapters INNER JOIN b"&gid&"_pages As pages ON chapters.page = pages.page WHERE "&queryTitle&" "
 
'		Log(ls.Size)
'		For i = 0 To ls.Size - 1
'			If i + 1 < ls.Size Then
'					
'				LogColor(ls.Get(i),Colors.Green)
'				If choptiontitle.Checked And choptiondescription.Checked = False Then
'					query = query & "  LIKE '%" & ls.Get(i) & "%' AND "&new_titleFiled(8)
'				Else If choptiondescription.Checked And choptiontitle.Checked = False Then
'					query = query & "  LIKE '%" & ls.Get(i) & "%' AND "&new_textFiled(8)
'				Else If choptiontitle.Checked And choptiondescription.Checked Then
'					query = query &"  ("& new_titleFiled(8)&" LIKE '%" & ls.Get(i) & "%' OR "&new_textFiled(8)&" LIKE '%" & ls.Get(i) & "%' ) AND "
'				End If
'							
''							query = query & " LIKE '%" & ls.Get(i) & "%' AND chapters.title "
'			Else
'							
''							LogColor(ls.Get(i),Colors.Green)
'		If choptiontitle.Checked And choptiondescription.Checked = False Then
'			Log(1111)
'			query = query & "  LIKE '%" & ls.Get(i) & "%'   "
'		Else If choptiondescription.Checked And choptiontitle.Checked = False Then
'			Log(2222)
'			query = query & "  LIKE '%" & ls.Get(i) & "%'  "
'		Else If choptiontitle.Checked And choptiondescription.Checked Then
'			Log(3333)
'			query = query & " ("&new_titleFiled(8)&" LIKE '%" & ls.Get(i) & "%' OR "&new_textFiled(8)&" LIKE '%" & ls.Get(i) & "%' ) "
'		End If
'	End If
'						
'		Next
		
		cr = Main.sql1.ExecQuery(query)
		Log(cr.RowCount)
		For i=0 To cr.RowCount-1
			Dim map_recycler As Map
			map_recycler.Initialize
			cr.Position=i
'				LogColor("query: "&query,Colors.red)
			res_count = res_count+cr.RowCount
			map_recycler.Put("id",cr.GetInt("id"))
			map_recycler.Put("page",cr.GetInt("page"))
			map_recycler.Put("book_id",gid)
			map_recycler.Put("title",cr.GetString("_text"))
			list_recycler.Add(map_recycler)
		
		Next
		If cr.RowCount <> 0 Then
			Dim map_book_recycler As Map
			map_book_recycler.Initialize
			map_book_recycler.Put("book_id",gid)
			map_book_recycler.Put("counter",cr.RowCount)
			list_books_recycler.Add(map_book_recycler)
		End If
		ISSubGroup = False
		
	End If
'	End If
	If simple =True Then
		recycler_Build
	Else
		recycler_Build_advance
	End If
	If res_count = 0 Then
		ToastMessageShow("لم يتم الحصول على نتيجة!",False)
		lbl_search_result.Visible = False
	Else
		lbl_search_result.Visible = True
		lbl_search_result. Text  = "نتائج البحث عن «"&edsearch.Text&"» "&res_count&" نتيجة"
	End If
	
	cr.Close

'	Act_Contents_Book.userQuery = edsearch.Text
'	start = start + limit
	ProgressDialogHide
End Sub

#Region recycler

Sub recycler_Build
	If ISSubGroup = True Then
		search_item = list_recycler.Size
	Else
		search_item = list_books_recycler.Size
	End If
	Dim Adapter As Amir_RVAdapter
	Adapter.Initialize("Amir",Adapter.LOOP_NEVER)
	Recycler.DefaultAdapter
	Recycler.DefaultAdapter.SetLayout(100%x-10dip,56dip)
End Sub

Private Sub Amir_GetItemOffsets (OutRect As Rect,Item As Object,Position As Int)
	OutRect.Top= 5dip
	If Position = Recycler.Adapter2.ItemCount-1 Then
		OutRect.Bottom=5dip
	End If
	OutRect.Left= 5dip
	OutRect.Right= 5dip
End Sub

Private Sub Amir_onCreateViewHolder (Parent As Panel,ViewType As Int)
	Dim main_pnl As Panel
	main_pnl.Initialize("SectionHolder")
	Parent.AddView(main_pnl,2%x,0%y,94%x,Parent.Height)
	
	Dim lbl_title As Label
	lbl_title.Initialize("lbl_title")
	main_pnl.AddView(lbl_title,8%x,10dip,82%x,30dip)
'	lbl_title.Color = Colors.Red
	
	Dim lbl_conter1 As Label
	lbl_conter1.Initialize("")
	main_pnl.AddView(lbl_conter1,4dip,8dip,30dip,30dip)
	
	Dim book_icon As Label
	book_icon.Initialize("")
	main_pnl.AddView(book_icon,85%x,lbl_title.Top+5dip,30dip,25dip)

	Dim list_style As Label
	list_style.Initialize("list_style")
	main_pnl.AddView(list_style,89%x,lbl_title.Top+6dip,25dip,25dip)
'	list_style.Color = Colors.Blue
End Sub

Private Sub Amir_onBindViewHolder (Parent As Panel,Position As Int)
	LogColor(Position,Colors.Cyan)
	
'	If Position = 0 Then
'		lbl_search_result.Visible = True
'	Else
'		lbl_search_result.Visible = False
'	End If
	
	Dim map_get , map_items As Map
	If ISSubGroup = False Then
		map_items  = list_books_recycler.Get(Position)
		Log("*********"&map_items.Get("book_id"))
		Dim c As Cursor
		c = Main.sql1.ExecQuery("SELECT * FROM booklist WHERE id = "&map_items.Get("book_id"))
		c.Position = 0
	Else
		map_get = list_recycler.Get(Position+counters)
	End If
	
	Dim ViewManager As Amir_ViewManager
	ViewManager.Initialize(Parent)
	ViewManager.BackgroundColor=Colors.White
	ViewManager.BackgroundEnabledColor=Colors.White
	ViewManager.Radius= 1dip
	ViewManager.Start
	Parent.Elevation=2dip
	setClipToOutline(Parent)
	
	

	
	Dim pnl As Panel
	pnl = Parent.GetView(0)
	Dim lbl_title As Label = pnl.GetView(0)

	
	lbl_title.TextSize = 16
	lbl_title.TextColor = Colors.DarkGray
	lbl_title.Typeface = Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	lbl_title.Padding = Array As Int (0dip, 10dip, 0dip, 0dip)
	lbl_title.Gravity = Bit.Or(Gravity.RIGHT,Gravity.CENTER_VERTICAL)
	
	Dim lbl_conter1 As Label = pnl.GetView(1)
	lbl_conter1.TextSize = 16
	lbl_conter1.TextColor = Colors.DarkGray
	lbl_conter1.Padding = Array As Int (0dip, 10dip, 0dip, 0dip)
	lbl_conter1.Typeface = Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	
	Dim book_icon As Label= pnl.GetView(2)
	book_icon.Typeface = Typeface.FONTAWESOME
	book_icon.Text = Chr(0xf02d)
	book_icon.TextSize = 19
	book_icon.Padding = Array As Int (0dip, 5dip, 0dip, 0dip)
	book_icon.TextColor  = Colors.DarkGray
	book_icon.Gravity = Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	
	Dim list_style As Label = pnl.GetView(3)
	list_style.Text = Chr(0xe3a6)
	list_style.Typeface = Typeface.MATERIALICONS
	list_style.Gravity = Gravity.CENTER
	list_style.TextColor = Colors.White
	list_style.TextSize = 8
	
	If Act_library.day_night = "day" Then
		Select theme_int
			Case 1
				list_style.TextColor = Colors.RGB(17,171,205)
				Parent.Color = Colors.rgb(232,243,249)
			Case 2
				list_style.TextColor = Colors.RGB(103,75,25)
				Parent.Color = Colors.rgb(239,224,202)
			Case 3
				list_style.TextColor = Colors.RGB(0,100,102)
				Parent.Color = Colors.rgb(217,252,253)
			Case 4
				list_style.TextColor = Colors.RGB(76,82,104)
				Parent.Color = Colors.rgb(215,224,245)
			Case 5
				list_style.TextColor = Colors.RGB(0,57,102)
				Parent.Color = Colors.rgb(230,240,247)
		End Select
	Else
		list_style.TextColor = Colors.White
		Parent.Color = Colors.DarkGray
		lbl_title.TextColor = Colors.White
	End If
	
	If simple Then
		lbl_conter1.Visible = False
	Else
		lbl_conter1.Visible = True
	End If
	Dim rs As RichString
	Dim s As String
	Log ("edsearch.Text ::"&edsearch.Text)
	If ISSubGroup = False Then
		list_style.Visible = False
		book_icon.Visible = True
		lbl_conter1.Text = map_items.Get("counter")
		s = Functions.shortenText(Functions.RemoveTags(c.GetString("title")),35)
		s = s.Replace("&nbsp;"," ")
		If edsearch.Text.Length > 2 Then
			s = s.Replace(edsearch.Text,"{BL}"&edsearch.Text&"{BL}")
		End If
		rs.Initialize(s)
		rs.Color2(Colors.red,"{BL}")
		lbl_title.Text = rs
		lbl_title.Tag = map_items.Get("counter")&"/"&Position
		lbl_title.Left = 3%x
		
	Else
		list_style.Visible = True
		book_icon.Visible = False
		s = Functions.RemoveTags(map_get.Get("title"))
		s = s.Replace("&nbsp;"," ")
		s = s.Replace("ِ","")
		s = s.Replace("َ","")
		s = s.Replace("ً","")
		s = s.Replace("ُ","")
		s = s.Replace("ٌ","")
		s = s.Replace("ّ","")
		s = s.Replace("ٍ","")
		s = s.Replace("ْ","")
		s = s.Replace("إ" , "ا")
		s = s.Replace("ى" , "ي")
'		s = Functions.shortenText(Functions.RemoveTags(c.GetString("title")),35)
		Dim tt As Int
		tt = (s.IndexOf(edsearch.Text) +edsearch.Text.Length)
		
		If (s.Length - tt) > 35 Then
			s = s.SubString2(s.IndexOf(edsearch.Text),(tt+35))&"..."
		Else
			s = s.SubString2(s.IndexOf(edsearch.Text),s.IndexOf(edsearch.Text)+s.Length - tt)&"..."
		End If
		If edsearch.Text.Length > 2 Then
			s = s.Replace(edsearch.Text,"{BL}"&edsearch.Text&"{BL}")
		End If
		LogColor(s.IndexOf(edsearch.Text),Colors.Red)
		rs.Initialize(s)
		rs.Color2(Colors.Red,"{BL}")
		lbl_title.Text = rs
		
		t = t +  pnl.Height + 3dip
		lbl_conter1.Text = map_get.Get("id")
		lbl_title.Tag = map_get.Get("page")&"/"&map_get.Get("book_id")&"/"&Position
		
	End If
	
'	lbl_title.Text = lbl_title.Text.
	
End Sub

Sub lbl_title_Click
	Dim p2 As Label = Sender
	Dim sgid As String = p2.Tag
	Dim sgid_arr() As String
	sgid_arr  = Regex.Split("/",sgid)
	Act_Contents_Book.old_page_num = sgid_arr(0)

	LogColor(sgid_arr(0),Colors.Blue)
	LogColor(sgid_arr(1),Colors.Magenta)
	LogColor(sgid_arr(2),Colors.Cyan)
	
	Tid = sgid_arr(0)
	Act_Contents_Book.Idbook= sgid_arr(1)
	Act_Contents_Book.tag= sgid_arr(2)
	Act_Contents_Book.Idpage=Tid
		
	Act_Contents_Book.search_list.Clear
	For i= 0 To list_recycler.Size-1
		Act_Contents_Book.search_list.Add(list_recycler.Get(i))
	Next

	isFromSearch = True
	act_listcontent.listcontent_page = True
	StartActivity(Act_Contents_Book)
End Sub

Public Sub setClipToOutline (Panel As Panel)
	Dim P As Phone
	If P.SdkVersion >= 21 Then
		Dim jo As JavaObject = Panel
		jo.RunMethod("setClipToOutline",Array(True))
	End If
End Sub

Private Sub Amir_GetItemCount As Int
	Return search_item
End Sub

Sub Amir_onScrolled (Dx As Int,Dy As Int)
'	Log(Dy)
End Sub

Sub Amir_onUpdateViews (Item As Object,Position As Int)
	Log("Position ----->"&Position)
End Sub
	
#End Region

Sub edsearch_EnterPressed
	btnsearch_Click
End Sub

Sub rdo_b_CheckedChange(Checked As Boolean)
	clearscroll
	sp_g.Width = 99%x
	choptiontitle.Visible = False
	choptiondescription.Visible = False
	load_bookgroups
End Sub

Sub rdo_f_CheckedChange(Checked As Boolean)
	clearscroll
	sp_g.Width = pnloption_f.Width/2.5
	choptiontitle.Visible = True
	choptiondescription.Visible = True
	load_bookgroups
End Sub











'/////////////////////////////////////////////////////////////////////////


















#Region recyclerAmir_Advance

Sub recycler_Build_advance
	If ISSubGroup = True Then
		search_item = list_recycler.Size
	Else
		search_item = list_books_recycler.Size
	End If
	Dim Adapter As Amir_RVAdapter
	Adapter.Initialize("Amir_Advance",Adapter.LOOP_NEVER)
	Recycler2.DefaultAdapter
	Recycler2.DefaultAdapter.SetLayout(100%x-10dip,56dip)
End Sub

Private Sub Amir_Advance_GetItemOffsets (OutRect As Rect,Item As Object,Position As Int)
	OutRect.Top= 5dip
	If Position = Recycler2.Adapter2.ItemCount-1 Then
		OutRect.Bottom=5dip
	End If
	OutRect.Left= 5dip
	OutRect.Right= 5dip
End Sub

Private Sub Amir_Advance_onCreateViewHolder (Parent As Panel,ViewType As Int)
	Dim main_pnl As Panel
	main_pnl.Initialize("SectionHolder")
	Parent.AddView(main_pnl,2%x,0%y,94%x,Parent.Height)
	
	Dim lbl_title As Label
	lbl_title.Initialize("lbl_title1")
	main_pnl.AddView(lbl_title,8%x,10dip,82%x,30dip)
'	lbl_title.Color = Colors.Red
	
	Dim lbl_conter1 As Label
	lbl_conter1.Initialize("")
	main_pnl.AddView(lbl_conter1,4dip,8dip,30dip,30dip)
	
	Dim book_icon As Label
	book_icon.Initialize("")
	main_pnl.AddView(book_icon,85%x,lbl_title.Top+5dip,30dip,25dip)

	Dim list_style As Label
	list_style.Initialize("list_style")
	main_pnl.AddView(list_style,89%x,lbl_title.Top+6dip,25dip,25dip)
'	list_style.Color = Colors.Blue
End Sub

Private Sub Amir_Advance_onBindViewHolder (Parent As Panel,Position As Int)
	LogColor(Position,Colors.Cyan)
	
'	If Position = 0 Then
'		lbl_search_result.Visible = True
'	Else
'		lbl_search_result.Visible = False
'	End If
	
	Dim map_get , map_items As Map
	If ISSubGroup = False Then
		map_items  = list_books_recycler.Get(Position)
		Log("*********"&map_items.Get("book_id"))
		Dim c As Cursor
		c = Main.sql1.ExecQuery("SELECT * FROM booklist WHERE id = "&map_items.Get("book_id"))
		c.Position = 0
	Else
		map_get = list_recycler.Get(Position+counters)
	End If
	
	Dim ViewManager As Amir_ViewManager
	ViewManager.Initialize(Parent)
	ViewManager.BackgroundColor=Colors.White
	ViewManager.BackgroundEnabledColor=Colors.White
	ViewManager.Radius= 1dip
	ViewManager.Start
	Parent.Elevation=2dip
	setClipToOutline(Parent)
	
	

	
	Dim pnl As Panel
	pnl = Parent.GetView(0)
	Dim lbl_title As Label = pnl.GetView(0)

	
	lbl_title.TextSize = 16
	lbl_title.TextColor = Colors.DarkGray
	lbl_title.Typeface = Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	lbl_title.Padding = Array As Int (0dip, 10dip, 0dip, 0dip)
	lbl_title.Gravity = Bit.Or(Gravity.RIGHT,Gravity.CENTER_VERTICAL)
	
	Dim lbl_conter1 As Label = pnl.GetView(1)
	lbl_conter1.TextSize = 16
	lbl_conter1.TextColor = Colors.DarkGray
	lbl_conter1.Padding = Array As Int (0dip, 10dip, 0dip, 0dip)
	lbl_conter1.Typeface = Typeface.LoadFromAssets("BloombergArabicBetav4-Regular(1).ttf")
	
	Dim book_icon As Label= pnl.GetView(2)
	book_icon.Typeface = Typeface.FONTAWESOME
	book_icon.Text = Chr(0xf02d)
	book_icon.TextSize = 19
	book_icon.Padding = Array As Int (0dip, 5dip, 0dip, 0dip)
	book_icon.TextColor  = Colors.DarkGray
	book_icon.Gravity = Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
	
	Dim list_style As Label = pnl.GetView(3)
	list_style.Text = Chr(0xe3a6)
	list_style.Typeface = Typeface.MATERIALICONS
	list_style.Gravity = Gravity.CENTER
	list_style.TextColor = Colors.White
	list_style.TextSize = 8
	
	If Act_library.day_night = "day" Then
		Select theme_int
			Case 1
				list_style.TextColor = Colors.RGB(17,171,205)
				Parent.Color = Colors.rgb(232,243,249)
			Case 2
				list_style.TextColor = Colors.RGB(103,75,25)
				Parent.Color = Colors.rgb(239,224,202)
			Case 3
				list_style.TextColor = Colors.RGB(0,100,102)
				Parent.Color = Colors.rgb(217,252,253)
			Case 4
				list_style.TextColor = Colors.RGB(76,82,104)
				Parent.Color = Colors.rgb(215,224,245)
			Case 5
				list_style.TextColor = Colors.RGB(0,57,102)
				Parent.Color = Colors.rgb(230,240,247)
		End Select
	Else
		list_style.TextColor = Colors.White
		Parent.Color = Colors.DarkGray
		lbl_title.TextColor = Colors.White
	End If
	
	If simple Then
		lbl_conter1.Visible = False
	Else
		lbl_conter1.Visible = True
	End If
	Dim rs As RichString
	Dim s As String
	Log ("edsearch.Text ::"&edsearch.Text)
	If ISSubGroup = False Then
		list_style.Visible = False
		book_icon.Visible = True
		lbl_conter1.Text = map_items.Get("counter")
		s = Functions.shortenText(Functions.RemoveTags(c.GetString("title")),35)
		s = s.Replace("&nbsp;"," ")
		If edsearch.Text.Length > 2 Then
			s = s.Replace(edsearch.Text,"{BL}"&edsearch.Text&"{BL}")
		End If
		rs.Initialize(s)
		rs.Color2(Colors.red,"{BL}")
		lbl_title.Text = rs
		lbl_title.Tag = map_items.Get("counter")&"/"&Position
		lbl_title.Left = 3%x
	Else
		list_style.Visible = True
		book_icon.Visible = False
		s = Functions.RemoveTags(map_get.Get("title"))
		s = s.Replace("&nbsp;"," ")
		s = s.Replace("ِ","")
		s = s.Replace("َ","")
		s = s.Replace("ً","")
		s = s.Replace("ُ","")
		s = s.Replace("ٌ","")
		s = s.Replace("ّ","")
		s = s.Replace("ٍ","")
		s = s.Replace("ْ","")
		s = s.Replace("إ" , "ا")
		s = s.Replace("ى" , "ي")
	Dim tt As Int
		tt = (s.IndexOf(edsearch.Text) +edsearch.Text.Length)
		
		If (s.Length - tt) > 35 Then
			s = s.SubString2(s.IndexOf(edsearch.Text),(tt+35))&"..."
		Else
			s = s.SubString2(s.IndexOf(edsearch.Text),s.IndexOf(edsearch.Text)+s.Length - tt)&"..."
		End If
		If edsearch.Text.Length > 2 Then
			s = s.Replace(edsearch.Text,"{BL}"&edsearch.Text&"{BL}")
		End If
		LogColor(s.IndexOf(edsearch.Text),Colors.Red)
		rs.Initialize(s)
		rs.Color2(Colors.Red,"{BL}")
		lbl_title.Text = rs
		
		t = t +  pnl.Height + 3dip
		lbl_conter1.Text = map_get.Get("id")
		lbl_title.Tag = map_get.Get("page")&"/"&map_get.Get("book_id")&"/"&Position
		
	End If
	
'	lbl_title.Text = lbl_title.Text.
	
End Sub

Sub lbl_title1_Click
	Dim p2 As Label = Sender
	Dim sgid As String = p2.Tag
	LogColor(p2.Tag,Colors.RGB(90,90,90))
	Dim sgid_arr() As String
	sgid_arr  = Regex.Split("/",sgid)
	LogColor(sgid_arr(0),Colors.Blue)
	Act_Contents_Book.old_page_num = sgid_arr(0)
	LogColor(sgid_arr(1),Colors.Red)
	If ISSubGroup Then

		LogColor(sgid_arr(1),Colors.Magenta)
		Tid = sgid_arr(0)
		LogColor(sgid_arr(2),Colors.Cyan)
		
		Act_Contents_Book.Idbook= sgid_arr(1)
		Act_Contents_Book.tag= sgid_arr(2)
		Act_Contents_Book.Idpage=Tid
		
		Log("pageId: "&gid)
		Log("Tid: "&Tid)
		isFromSearch = True
		act_listcontent.listcontent_page = True
		StartActivity(Act_Contents_Book)
	Else
		Log("sgid_arr(0)     :::"&sgid_arr(0))
		
		counters = 0
		ISSubGroup = True
		search_item = sgid_arr(0)
		For i= 0 To (sgid_arr(1)-1)
		Dim map_items As Map
		map_items  = list_books_recycler.Get(i)
		counters = counters+ map_items.Get("counter")
			Next
'		Log(counters)
			Act_Contents_Book.search_list.Clear
			For i= 0 To sgid_arr(0)-1
'		Log(list_recycler.Get(i+counters))
		Act_Contents_Book.search_list.Add(list_recycler.Get(i+counters))
		Next
			If Recycler2.IsInitialized Then
		If Recycler2.Adapter<>Null Then Recycler2.Adapter2.NotifyDataSetChanged
	End If
	End If
	
	
End Sub


Private Sub Amir_Advance_GetItemCount As Int
	Return search_item
End Sub

Sub Amir_Advance_onScrolled (Dx As Int,Dy As Int)
'	Log(Dy)
End Sub

Sub Amir_Advance_onUpdateViews (Item As Object,Position As Int)
	Log("Position ----->"&Position)
End Sub
	
#End Region
