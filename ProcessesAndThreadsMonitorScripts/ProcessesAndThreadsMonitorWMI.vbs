strComputer = "." 
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2") 


Set oWSH = CreateObject("WScript.Shell")
vbsInterpreter = "cscript.exe"

Call ForceConsole()


bdone = false

enableProcessTracing=true
enableThreadsTracing=true

If enableProcessTracing Then
	'Win32_ProcessStartTrace
	Set MySinkProcessStart = WScript.CreateObject( _
		"WbemScripting.SWbemSink","SINKProcessStart_")

	objWMIservice.ExecNotificationQueryAsync MySinkProcessStart, _
		"SELECT * FROM Win32_ProcessStartTrace"

	'Win32_ProcessStopTrace
	Set MySinkProcessStop = WScript.CreateObject( _
		"WbemScripting.SWbemSink","SINKProcessStop_")

	objWMIservice.ExecNotificationQueryAsync MySinkProcessStop, _
		"SELECT * FROM Win32_ProcessStopTrace"
End If
	
If enableThreadsTracing Then
	'Win32_ThreadStopTrace
	Set MySinkThreadStop = WScript.CreateObject( _
		"WbemScripting.SWbemSink","SINKThreadStop_")

	objWMIservice.ExecNotificationQueryAsync MySinkThreadStop, _
		"SELECT * FROM Win32_ThreadStopTrace"
	 
	'Win32_ThreadStartTrace
	Set MySink = WScript.CreateObject( _
		"WbemScripting.SWbemSink","SINK_")

	objWMIservice.ExecNotificationQueryAsync MySink, _
		"SELECT * FROM Win32_ThreadStartTrace"
End If
	
Wscript.Echo "Waiting for events ..."

while not bdone    
    wscript.sleep 1000
wend

 
 Function printl(txt)
    WScript.StdOut.WriteLine txt
 End Function

 Function printf(txt)
    WScript.StdOut.Write txt
 End Function

 Function scanf()
    scanf = LCase(WScript.StdIn.ReadLine)
 End Function

 Function wait(n)
    WScript.Sleep Int(n * 1000)
 End Function

 Function ForceConsole()
    If InStr(LCase(WScript.FullName), vbsInterpreter) = 0 Then
        oWSH.Run vbsInterpreter & " //NoLogo " & Chr(34) & WScript.ScriptFullName & Chr(34)
        WScript.Quit
    End If
 End Function

 Function cls()
    For i = 1 To 50
        printf ""
    Next
 End Function
 
 


Sub SINK_OnObjectReady(objObject, objAsyncContext)
	printl "------------------------------------------"
    printl "Win32_ThreadStartTrace event has occurred."
	printl "ProcessID: " & objObject.ProcessID
    printl "SECURITY_DESCRIPTOR: " & objObject.SECURITY_DESCRIPTOR
    printl "StackBase: " & objObject.StackBase
    printl "StackLimit: " & objObject.StackLimit
    printl "StartAddr: " & objObject.StartAddr
    printl "ThreadID: " & objObject.ThreadID
    printl "TIME_CREATED: " & objObject.TIME_CREATED
    printl "UserStackBase: " & objObject.UserStackBase
    printl "UserStackLimit: " & objObject.UserStackLimit
    printl "WaitMode: " & objObject.WaitMode
    printl "Win32StartAddr: " & objObject.Win32StartAddr
End Sub

Sub SINK_OnCompleted(objObject, objAsyncContext)
    printl "Event call complete."
End Sub


Sub SINKThreadStop_OnObjectReady(objObject, objAsyncContext)
	printl "------------------------------------------"
    printl "Win32_ThreadStopTrace event has occurred."
	printl "ProcessID: " & objObject.ProcessID
    printl "SECURITY_DESCRIPTOR: " & objObject.SECURITY_DESCRIPTOR
    'printl "StackBase: " & objObject.StackBase
    'printl "StackLimit: " & objObject.StackLimit
    'printl "StartAddr: " & objObject.StartAddr
    printl "ThreadID: " & objObject.ThreadID
    printl "TIME_CREATED: " & objObject.TIME_CREATED
    'printl "UserStackBase: " & objObject.UserStackBase
    'printl "UserStackLimit: " & objObject.UserStackLimit
    'printl "WaitMode: " & objObject.WaitMode
    'printl "Win32StartAddr: " & objObject.Win32StartAddr
End Sub

Sub SINKThreadStop_OnCompleted(objObject, objAsyncContext)
	printl "------------------------------------------"
    WScript.Echo "Event call complete."
End Sub

Sub SINKProcessStart_OnObjectReady(objObject, objAsyncContext)
	printl "------------------------------------------"
    printl "Win32_ProcessStartTrace event has occurred."
	printl "ProcessName: " & objObject.ProcessName
	printl "ProcessID: " & objObject.ProcessID
	printl "ParentProcessID: " & objObject.ParentProcessID
    printl "SECURITY_DESCRIPTOR: " & objObject.SECURITY_DESCRIPTOR
    'printl "Sid: " & objObject.Sid
    printl "SessionID: " & objObject.SessionID
    printl "TIME_CREATED: " & objObject.TIME_CREATED
End Sub

Sub SINKProcessStart_OnCompleted(objObject, objAsyncContext)
    WScript.Echo "Event call complete."
End Sub


Sub SINKProcessStop_OnObjectReady(objObject, objAsyncContext)
	printl "------------------------------------------"
    printl "Win32_ProcessStopTrace event has occurred."
	printl "ProcessName: " & objObject.ProcessName
	printl "SessionID: " & objObject.SessionID
	printl "ExitStatus: " & objObject.ExitStatus
	printl "ProcessID: " & objObject.ProcessID
	printl "ParentProcessID: " & objObject.ParentProcessID
    printl "SECURITY_DESCRIPTOR: " & objObject.SECURITY_DESCRIPTOR
    'printl "Sid: " & objObject.Sid  
    printl "TIME_CREATED: " & objObject.TIME_CREATED
End Sub

Sub SINKProcessStop_OnCompleted(objObject, objAsyncContext)
    WScript.Echo "Event call complete."
	'bdone = true
End Sub
