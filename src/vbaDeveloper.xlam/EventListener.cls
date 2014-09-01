VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "EventListener"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'This class receives and acts upon events from the excel application.

Option Explicit

Private WithEvents App As Application
Attribute App.VB_VarHelpID = -1


Private Sub Class_Initialize()
    Set App = Application
End Sub

Private Sub App_WorkbookAfterSave(ByVal wb As Workbook, ByVal success As Boolean)
   On Error GoTo App_WorkbookAfterSave_Error
   
    'Export all the modules for this work book if save was successful
    If success Then
        Build.exportVbaCode wb.VBProject
        MsgBox "Finished saving workbook: " & wb.name & " . Code is exported."
    Else
        MsgBox "Saving workbook: " & wb.name & " was not successful. Code is not exported."
    End If

   On Error GoTo 0
   Exit Sub
App_WorkbookAfterSave_Error:
    ErrorHandling.handleError "vbaDeveloper.EventListener afterSave"
End Sub

Private Sub App_WorkbookBeforeSave(ByVal wb As Workbook, ByVal SaveAsUI As Boolean, Cancel As Boolean)
    'MsgBox "Before saving workbook: " & wb.name & " (cancel is " & Cancel
End Sub

Private Sub App_WorkbookOpen(ByVal wb As Workbook)
   On Error GoTo App_WorkbookOpen_Error
    
    'Import all the modules for this workbook
    Dim importNow As Integer
    importNow = MsgBox("Import the code for " & wb.name & " now?", vbYesNo, "EventListener Workbook open event")
    If importNow = vbYes Then
        Build.importVbaCode wb.VBProject
    End If

   On Error GoTo 0
   Exit Sub
App_WorkbookOpen_Error:
    ErrorHandling.handleError "vbaDeveloper.EventListener WorkbookOpen"
End Sub

Private Sub Class_Terminate()
    Set App = Nothing
End Sub