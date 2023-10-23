[xml]$pass = get-content 'XXX\settings.xml'
$Hostname = 'XXX'
$Username = 'XXX'
$Password = convertto-securestring $pass.configuration.Password
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
		SecurePassword = $Password
        SshHostKeyFingerprint = $SSHKey
}

$session = New-Object WinSCP.Session

try
{
# Connect
$session.XmlLogPath = "XXX\winSCPlog.xml"
$session.Open($sessionOptions)

    # Download files
    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

    $transferResult = $session.GetFiles($F1Source, $F1Target, $False, $transferOptions)

    # Throw on any error
    $transferResult.Check()
	
        #xml parsing
        copy-item XXX\winSCPlog.xml -Destination XXX\Archive\winSCPlog.xml

        add-content 'XXX\Archive\winSCPlog.xml' -value "</session>"
        $xmldoc = [xml](Get-Content 'XXX\Archive\winSCPlog.xml')
        foreach ($node in $xmldoc.session.group | ? name -like 'get*')
        {
            $DT = get-date -Format "dd/MM/yy HH:mm"
			$Fdate = get-date -Format "ddMMyy"
			
			if ($node.download.filename.value -match "\S")
			{			
            Add-Content XXX\Archive\winSCPlog_$Fdate.txt -Value ($DT + ' ' + $node.download.filename.value + ' To ' + $node.download.destination.value + ' Completed =  ' + $node.download.result.success)
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
