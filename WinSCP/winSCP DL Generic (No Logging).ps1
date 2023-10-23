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
$session.Open($sessionOptions)

    # Download files
    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

    $transferResult = $session.GetFiles($F1Source, $F1Target, $False, $transferOptions)

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
