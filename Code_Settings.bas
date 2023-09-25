B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.8
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	Private PM As PreferenceManager

End Sub

Public Sub AppDayOrNight_En
	PM.SetBoolean("AppDayNight",True)
End Sub

Public Sub AppDayOrNight_Dis
	PM.SetBoolean("AppDayNight",False)
End Sub

Public Sub IsAppDayOrNight As Boolean
	Return PM.GetBoolean("AppDayNight")
End Sub