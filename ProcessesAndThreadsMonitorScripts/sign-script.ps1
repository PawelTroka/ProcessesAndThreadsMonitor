New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -codesign -dnsname dk.fizyka
$pwd = ConvertTo-SecureString -String "password" -Force -AsPlainText
Export-PfxCertificate -cert cert:\localMachine\my\6136EE827FEA32BAFD292B0E51B6947E6C50F73A -FilePath D:\PawelTroka-Projects\ProcessesAndThreadsMonitor\cert.pfx -Password $pwd


Export-PfxCertificate -cert Microsoft.PowerShell.Security\Certificate::LocalMachine\my\6136EE827FEA32BAFD292B0E51B6947E6C50F73A -FilePath D:\PawelTroka-Projects\ProcessesAndThreadsMonitor\cert.pfx -Password $pwd

Set-AuthenticodeSignature ProcessesAndThreadsMonitorPS.ps1 @(Get-ChildItem cert:\CurrentUser\my)[0]


$Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2("D:\PawelTroka-Projects\ProcessesAndThreadsMonitor\ProcessesAndThreadsMonitorScripts\cert.pfx", "password")
Set-AuthenticodeSignature -Certificate $Cert -TimeStampServer http://timestamp.verisign.com/scripts/timstamp.dll -FilePath ProcessesAndThreadsMonitorPS.ps1