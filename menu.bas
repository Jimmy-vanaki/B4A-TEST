B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=9.01
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: true
	#IncludeTitle: false
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Dim time_exit As Timer

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private cr_booklist As Cursor
	Private btn_book As Button
	Dim mv As mv_SystemUI
	Private img_menu As ImageView
	Private btn_ques As Button
	Dim amv As Amir_ViewManager
	Dim theme_int As Int
	Private lbl_exit As Label
	Dim anime As SAnimation
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	mv.setNavigationBarColor(Colors.RGB(1,185,231))

	Activity.LoadLayout("lyt_Menu")
	
	lbl_exit.Visible = False
	time_exit.Initialize("time_exit",3000)

	amv.Initialize(lbl_exit)
	amv.BackgroundColor = Colors.RGB(235,235,235)
	amv.TextColor = Colors.DarkGray
	amv.Radius = 20
	amv.Start
	
	
	
End Sub

Sub theme
	
	If theme_int = 1 Then
		img_menu.Bitmap = LoadBitmap(File.DirAssets,"1/"&"app001-7-23.jpg")
		mv.setNavigationBarColor(Colors.RGB(17,171,205))

	Else if theme_int = 2 Then
		img_menu.Bitmap = LoadBitmap(File.DirAssets,"2/"&"app001-7-23.jpg")
		mv.setNavigationBarColor(Colors.RGB(103,75,25))
		
	Else if theme_int = 3 Then
		
		img_menu.Bitmap = LoadBitmap(File.DirAssets,"3/"&"app001-7-23.jpg")
		mv.setNavigationBarColor(Colors.RGB(0,100,102))
		
	Else if theme_int = 4 Then
		img_menu.Bitmap = LoadBitmap(File.DirAssets,"4/"&"app001-7-23.jpg")
		mv.setNavigationBarColor(Colors.RGB(76,82,104))
		
	Else if theme_int = 5 Then
		img_menu.Bitmap = LoadBitmap(File.DirAssets,"5/"&"app001-7-23.jpg")
		mv.setNavigationBarColor(Colors.RGB(0,57,102))
	End If
	
End Sub

Sub time_exit_Tick

	anime.FadeOut("",lbl_exit,1000)
	time_exit.Enabled = False
End Sub

Sub Activity_Resume
'	mv.HideNavigationBar
	theme_int = Functions.theme_number
	theme
End Sub

Sub Activity_Pause (UserClosed As Boolean)
'	Activity.Finis
End Sub

Private Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode=KeyCodes.KEYCODE_BACK  Then
		
		If lbl_exit.Visible = False Then
			anime.FadeIn("",lbl_exit,1000)
'			lbl_exit.Visible = True
			time_exit.Enabled = True
		Else
			ExitApplication
		End If
		Return True
	End If
	Return False
End Sub

Sub btn_book_Click
	StartActivity(home)
End Sub

Sub btn_ques_Click
'	StartActivity(questions_groups)
End Sub

Sub btn_about_Click
	StartActivity(act_about)
	act_about.FormAbout = 3
	
End Sub



Sub btn_fav_Click
	cr_booklist = Main.sql1.ExecQuery("SELECT * FROM books WHERE fav=1 ORDER BY id ASC")
	If cr_booklist.RowCount = 0 Then
		ToastMessageShow("قائمة المفضلة فارغة  ",False)
	Else
		StartActivity(act_favorite)
		
	End If
End Sub

Sub btn_search_Click
	act_search.usersearch = ""
	StartActivity(act_search)
End Sub

Sub btn_wel_Click

End Sub

Sub btn_exitt_Click
	ExitApplication
End Sub

Sub btn_setting_Click
'	Activity.Finish
	StartActivity(act_settings)
End Sub