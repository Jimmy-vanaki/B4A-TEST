B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Private Sub Class_Globals
	Private MDB As MSMaterialDrawerBuilder
End Sub

Public Sub Initialize(MaterialDrawer As MSMaterialDrawerBuilder)
	MDB = MaterialDrawer
End Sub

Public Sub AddItemToDrawer(Item As Object)
	Dim j,jo = MDB As JavaObject
	j.InitializeArray("com.mikepenz.materialdrawer.model.interfaces.IDrawerItem",Array(Item))
	jo.RunMethod("addDrawerItems",Array(j))
End Sub

Public Sub AddPrimaryDrawerItem(Name As String,Icon As Object,SelectedIcon As Object _
	,Badge As String,Enabled As Boolean,Identifier As Int,Description As String,Font As Typeface)
	Dim pi As MSPrimaryDrawerItem
	pi.Initialize
	Dim j = pi As JavaObject
	pi.Name = Name
	If Description <> "" Then j.RunMethod("setDescription",Array(Description))
	If Icon <> Null Then pi.Icon = Icon
	If SelectedIcon <> Null Then j.RunMethod("withSelectedIcon",Array(SelectedIcon))
	pi.Badge = Badge
	pi.Enabled = Enabled
	pi.Identifier = Identifier
	If Font <> Null Then j.RunMethod("withTypeface",Array(Font))
	AddItemToDrawer(pi)
End Sub

Public Sub AddSectionDrawerItem(Name As String,Divider As Boolean,Font As Typeface)
	Dim j As JavaObject
	j.InitializeNewInstance("com.mikepenz.materialdrawer.model.SectionDrawerItem",Null)
	j.RunMethod("setName",Array(Name))
	j.RunMethod("setDivider",Array(Divider))
	If Font <> Null Then j.RunMethod("withTypeface",Array(Font))
	AddItemToDrawer(j)
End Sub

Public Sub AddSecondaryDrawerItem(Name As String,Icon As Object,SelectedIcon As Object _
	,Badge As String,Enabled As Boolean,Identifier As Int,Font As Typeface)
	Dim si As MSSecondaryDrawerItem
	si.Initialize
	si.Name = Name
	If Icon <> Null Then si.Icon = Icon
	Dim j As JavaObject = si
	If SelectedIcon <> Null Then j.RunMethod("withSelectedIcon",Array(SelectedIcon))
	si.Badge = Badge
	si.Enabled = Enabled
	si.Identifier = Identifier
	If Font <> Null Then j.RunMethod("withTypeface",Array(Font))
	AddItemToDrawer(si)
End Sub