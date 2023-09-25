B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=7.8
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: true
	#IncludeTitle: True
#End Region

Sub Process_Globals
	Dim FormAbout As Int
End Sub

Sub Globals

	Private lbl_home_title As Label
	Private wb_about As WebView
	Private PnlHeader As Panel
	Dim mv As mv_SystemUI
	Dim p As PhoneIntents
	Dim theme_int As Int
	Private lbl_back As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("lyt_about")
	If FormAbout = 1 Then
		lbl_home_title.Text = "حول التطبيق"
	else If FormAbout = 2 Then
		lbl_home_title.Text = "السيرة ذاتية"
	else If FormAbout = 3 Then
		lbl_home_title.Text = "حول التطبيق"
	End If
	theme_int  = Functions.theme_number

	Private xui As XUI
	wb_about.LoadUrl(xui.FileUri(File.DirAssets, "about1.htm"))
	wb_about.ZoomEnabled = False
	
	Functions.Set_Color(Functions.theme_number)
	Set_theme
	
End Sub


Sub Set_theme
	PnlHeader.Color = Main.header_cl
	Activity.Color = Main.activity_cl
	lbl_back.TextColor = Main.text_cl
	lbl_home_title.TextColor = Main.text_cl
	mv.setNavigationBarColor(Main.footer_cl)
End Sub

Sub wb_about_OverrideUrl (Url As String) As Boolean
	Dim i As Intent
	I.initialize(i.action_view,Url)
	StartActivity(i)

	Return True
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

Sub btn1_Click
'	youtube
	Dim i As Intent
	i.Initialize(i.ACTION_VIEW, "https://www.youtube.com/@Dijlah_it")
	StartActivity(i)

End Sub

Sub btn2_Click
	'instagram
	StartActivity(p.OpenBrowser("https://www.instagram.com/dijlah_it/"))
End Sub

Sub btn3_Click
'	telegram
	Dim i As Intent
	i.Initialize(i.ACTION_VIEW, "https://t.me/dijlah")
	StartActivity(i)
End Sub

Sub btn4_Click
	'facebook
	StartActivity(p.OpenBrowser("https://www.facebook.com/Dijlah.it/"))
End Sub

Sub btn5_Click
'	whatsapp
	Dim Intent1 As Intent
	Intent1.Initialize(Intent1.ACTION_VIEW, $"https://api.whatsapp.com/send?phone=+9647818100222"$)
	StartActivity(Intent1)
End Sub

Sub btn6_Click
	'tiktok
	StartActivity(p.OpenBrowser("https://www.tiktok.com/@dijlah.it"))
End Sub

Sub btn7_Click
	'twitter
	StartActivity(p.OpenBrowser("https://twitter.com/Dijlah_it"))
End Sub