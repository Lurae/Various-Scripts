$Hostname = 'XXX'
$Username = 'XXX'
$PPK = ''
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
$session.Open($sessionOptions)

    # Upload files
    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

    $transferResult = $session.PutFiles($F1Source, $F1Target, $False, $transferOptions)

    # Throw on any error
    $transferResult.Check()
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
