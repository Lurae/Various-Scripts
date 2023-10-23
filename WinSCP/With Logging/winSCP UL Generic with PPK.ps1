$Hostname = 'XXX'
$Username = 'XXX'
$PPK = 'XXX'
$SSHKey = 'XXX'

$F1Source = 'XXX'
$F1Target = 'XXX'

try
{# Load WinSCP .NET assembly
    Add-Type -Path XXX\WinSCPnet.dll
    
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = $HostName
        UserName = $UserName
		SshPrivateKeyPath= $PPK
        SshHostKeyFingerprint = $SSHKey
}

$session = New-Object WinSCP.Session

try
{
# Connect
$session.XmlLogPath = "XXX\winSCPlog.xml"
$session.Open($sessionOptions)

    # Upload files
    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

    $transferResult = $session.PutFiles($F1Source, $F1Target, $False, $transferOptions)

    # Throw on any error
    $transferResult.Check()
	
        #xml parsing
        copy-item XXX\winSCPlog.xml -Destination XXX\Archive\winSCPlog.xml

        add-content 'XXX\Archive\winSCPlog.xml' -value "</session>"
        $xmldoc = [xml](Get-Content 'XXX\Archive\winSCPlog.xml')
        foreach ($node in $xmldoc.session.group | ? name -like 'put*')
        {
            $DT = get-date -Format "dd/MM/yy HH:mm"
			$Fdate = get-date -Format "ddMMyy"
			
			if ($node.upload.filename.value -match "\S")
			{			
            Add-Content XXX\Archive\winSCPlog_$Fdate.txt -Value ($DT + ' ' + $node.upload.filename.value + ' To ' + $node.upload.destination.value + ' Completed =  ' + $node.upload.result.success)
			}
        }
		remove-item 'XXX\Archive\winSCPlog.xml'
}
finally
{
    # Disconnect, clean up
    $session.Dispose()
}
    exit 0
}
catch [Exception]
{
    exit 1
}
