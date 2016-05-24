#
# Script.ps1
#
set-ExecutionPolicy Unrestricted

$queryBase = "SELECT * FROM Win32_"

$processStartQuery = $queryBase+"ProcessStartTrace"
$processStopQuery = $queryBase+"ProcessStopTrace"
$threadStartQuery = $queryBase+"ThreadStartTrace"
$threadStopQuery = $queryBase+"ThreadStopTrace"

$queries = ($processStartQuery,$processStopQuery,$threadStartQuery,$threadStopQuery)




 Register-WmiEvent -Query $processStartQuery -Action { 
	$Host.UI.RawUI.ForegroundColor = 'Green'
	Write-Host "------------------------------------------"
    Write-Host "Win32_ProcessStartTrace event has occurred."
	Write-Host "ProcessName: " $event.SourceEventArgs.NewEvent.ProcessName
	Write-Host "ProcessID: " $event.SourceEventArgs.NewEvent.ProcessID
	Write-Host "ParentProcessID: " $event.SourceEventArgs.NewEvent.ParentProcessID
    Write-Host "SECURITY_DESCRIPTOR: " $event.SourceEventArgs.NewEvent.SECURITY_DESCRIPTOR
    Write-Host "SessionID: " $event.SourceEventArgs.NewEvent.SessionID
    Write-Host "TIME_CREATED: "  [datetime]::FromFileTime($event.SourceEventArgs.NewEvent.TIME_CREATED)
 } 


  Register-WmiEvent -Query $processStopQuery -Action { 
	 $Host.UI.RawUI.ForegroundColor = 'Yellow'
	Write-Host "------------------------------------------"
    Write-Host "Win32_ProcessStopTrace event has occurred."
	Write-Host "ProcessName: " $event.SourceEventArgs.NewEvent.ProcessName
	Write-Host "SessionID: " $event.SourceEventArgs.NewEvent.SessionID
	Write-Host "ExitStatus: " $event.SourceEventArgs.NewEvent.ExitStatus
	Write-Host "ProcessID: " $event.SourceEventArgs.NewEvent.ProcessID
	Write-Host "ParentProcessID: " $event.SourceEventArgs.NewEvent.ParentProcessID
    Write-Host "SECURITY_DESCRIPTOR: " $event.SourceEventArgs.NewEvent.SECURITY_DESCRIPTOR
    Write-Host "TIME_CREATED: "  [datetime]::FromFileTime($event.SourceEventArgs.NewEvent.TIME_CREATED)

 } 



  Register-WmiEvent -Query $threadStartQuery -Action { 
	 $Host.UI.RawUI.ForegroundColor = 'White'
	Write-Host "------------------------------------------"
    Write-Host "Win32_ThreadStartTrace event has occurred."
	Write-Host "ProcessID: " $event.SourceEventArgs.NewEvent.ProcessID
    Write-Host "SECURITY_DESCRIPTOR: " $event.SourceEventArgs.NewEvent.SECURITY_DESCRIPTOR
    Write-Host "StackBase: " $event.SourceEventArgs.NewEvent.StackBase
    Write-Host "StackLimit: " $event.SourceEventArgs.NewEvent.StackLimit
    Write-Host "StartAddr: " $event.SourceEventArgs.NewEvent.StartAddr
    Write-Host "ThreadID: " $event.SourceEventArgs.NewEvent.ThreadID
    Write-Host "TIME_CREATED: "  [datetime]::FromFileTime($event.SourceEventArgs.NewEvent.TIME_CREATED)
    Write-Host "UserStackBase: " $event.SourceEventArgs.NewEvent.UserStackBase
    Write-Host "UserStackLimit: " $event.SourceEventArgs.NewEvent.UserStackLimit
    Write-Host "WaitMode: " $event.SourceEventArgs.NewEvent.WaitMode
    Write-Host "Win32StartAddr: " $event.SourceEventArgs.NewEvent.Win32StartAddr
  } 


  Register-WmiEvent -Query $threadStopQuery -Action { 
	$Host.UI.RawUI.ForegroundColor = 'Magenta'
	Write-Host "------------------------------------------"
    Write-Host "Win32_ThreadStopTrace event has occurred."
	Write-Host "ProcessID: " $event.SourceEventArgs.NewEvent.ProcessID
    Write-Host "SECURITY_DESCRIPTOR: " $event.SourceEventArgs.NewEvent.SECURITY_DESCRIPTOR
    Write-Host "ThreadID: " $event.SourceEventArgs.NewEvent.ThreadID
    Write-Host "TIME_CREATED: "  [datetime]::FromFileTime($event.SourceEventArgs.NewEvent.TIME_CREATED)
  } 

#  Foreach ($query in $queries) {
  
# Register-WmiEvent -Query $query -Action { 
#                Write-Host "Log Event occurred" 
#                Write-Host "EVENT MESSAGE" 
#                Write-Host $event.SourceEventArgs.NewEvent.TargetInstance.Message} 
#  }



$continue = $true
while($continue)
{

    if ([console]::KeyAvailable)
    {
        echo "Toggle with F12";
        $x = [System.Console]::ReadKey() 

        switch ( $x.key)
        {
            F12 { $continue = $false }
        }
    } 
    else
    {
        $wsh = New-Object -ComObject WScript.Shell
        $wsh.SendKeys('{CAPSLOCK}')
        sleep 1
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($wsh)| out-null
        Remove-Variable wsh
    }    
}