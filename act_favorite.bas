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

End Sub

Sub Globals
	Private lbl_home_title As Label
	Public RV_favorite As Amir_RecyclerView
	Dim Itemfavorite As List
	Private cr_booklist As Cursor
	Private PnlHeader As Panel
	Dim mv As mv_SystemUI
	Dim theme_int As Int
	
	Private lbl_back As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("lyt_favorite")
	lbl_home_title.Text = "المفضلة"
	Activity.Color=Colors.RGB(238,238,238)
	loadItemfavorite
	Initialize_RV_favorite
	
	Functions.Set_Color(Functions.theme_number)
	Set_theme

End Sub

Sub Set_theme
	lbl_home_title.TextColor= Main.text_cl
	lbl_back.TextColor = Main.text_cl
	PnlHeader.Color = Main.header_cl
	Activity.Color = Main.activity_cl
	mv.setNavigationBarColor(Main.footer_cl)
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub lbl_back_Click
	StartActivity(Act_library)
	Activity.Finish
End Sub

Private Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode=KeyCodes.KEYCODE_BACK  Then
		lbl_back_Click
		Return True
	End If
	Return False
End Sub

Sub loadItemfavorite
	
	Itemfavorite.Initialize
	Itemfavorite.Clear
	
	cr_booklist = Main.sql1.ExecQuery("SELECT * FROM booklist WHERE fav=1 ORDER BY id ASC")
	For i=0 To cr_booklist.RowCount - 1
		cr_booklist.Position=i
		Itemfavorite.Add(CreateMap("Idbook":cr_booklist.GetInt("id"),"Title":cr_booklist.GetString("title"),"PageNumber":cr_booklist.GetInt("id")))
	Next
	cr_booklist.Close
	
	
	If RV_favorite.IsInitialized Then
		If RV_favorite.Adapter<>Null Then RV_favorite.Adapter2.NotifyDataSetChanged
	End If
		
	
End Sub


Public Sub Initialize_RV_favorite
		
	RV_favorite.Initializer("RV_favorite").ListView.Vertical.Build
	Activity.AddView(RV_favorite,0,60dip,100%x,100%y-56dip*2)
	RV_favorite.ScrollToEndListener(True)
	RV_favorite.BringToFront
	RV_favorite.LayoutDirection=RV_favorite.LAYOUT_DIRECTION_RTL
	RV_favorite.DefaultAdapter
	
'	Dim R,G,B As Int
'	R = Rnd( 0, 256)
'	G = Rnd( 0, 256)
'	B = Rnd( 0, 256)
'	RV_favorite.Color=Colors.RGB(R,G,B)

	RV_favorite.ScrollSettings.OverScrollMode= _
	RV_favorite.ScrollSettings.OVER_SCROLL_NEVER


End Sub



Sub RV_favorite_onCreateViewHolder (Parentt As Panel,ViewType As Int)
	Card_favorite_OnCreate(Parentt,RV_favorite.LayoutSpanCount)
End Sub

Sub RV_favorite_onBindViewHolder (Parentt As Panel,Position As Int)
	Card_favorite_OnBind(Parentt,Itemfavorite.Get(Position),Position)
End Sub

Sub RV_favorite_GetItemCount As Int
	Return Itemfavorite.Size
End Sub

Sub RV_favorite_DividerColor (Position As Int) As Int
	Return  Functions.GetColor(Position)
End Sub

Sub RV_favorite_DividerLeftMargin (Position As Int) As Int
	Return Position * 16dip
End Sub

Sub RV_favorite_DividerRightMargin (Position As Int) As Int
	Return Position * 16dip
End Sub

Sub RV_favorite_onScrolledToEnd
'	ToastMessageShow("End of List",False)
End Sub


Public Sub Card_favorite_OnCreate (Holder As Panel, Span As Int)
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


Public Sub Card_favorite_OnBind (Holder As Panel, Data As Map, Position As Int)
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
	Dim Map As Map = Itemfavorite.Get(Position)
	Dim Idbook As String=Map.Get("Idbook")
	
	If Msgbox2("هل أنت متأكد من عملية الحذف؟","","نعم","لا","",Null) = DialogResponse.POSITIVE Then
		ToastMessageShow("تم الالغاء من المفضلة .",False)
		Log (Idbook)
		Main.sql1.ExecNonQuery("UPDATE booklist SET fav =0 WHERE id = "& Idbook)
	
		If RV_favorite.IsInitialized=False Then
			Initialize_RV_favorite
		End If
		loadItemfavorite
		
	End If
	
	
	
End Sub


Sub RV_favorite_onItemClick (Parentt As Panel,Position As Int)
	Log(Position)
	Dim DataMap As Map = Itemfavorite.Get(Position)
	Dim Idbook As String=DataMap.Get("Idbook")
 
	Log("Idbook: "&Idbook)
	Act_Contents_Book.Idbook = Idbook '+373
	Act_Contents_Book.Idpage = 1
	
'	Act_List_Product.catid = idbook
'	Act_List_Product.sendMoretag = 1
'	Dim result As Int
'	result = Msgbox2("This is the message", "status", "Vertical", "", "Horizontal", Null)
'	If result = DialogResponse.Positive Then
'		Act_Contents_Book.statusListView = 0
'	Else
'		Act_Contents_Book.statusListView = 1
'	End If

	StartActivity(Act_Contents_Book)

End Sub