### Decrypt ###
$file = get-item "XXX\*.pgp" | Select-Object -first 1 #full directory + Filename
$ext = '.csv' #what extension should the decrypted file be?
$output = $file.DirectoryName + '\' + $file.BaseName + $ext #decrypts to the folder the file currently sits in
$passphrase = '' #if left empty it is assumed the key has no passphrase attached

#PLEASE SET PASSPHRASE AS A SECURESTRING!!!!!!!!!!!!!!

$Archive = '0' #if you want to archive encrypted files, set to '1'
$archivefolder = '' #only required if above is set to '1'

if([string]::IsNullOrEmpty($passphrase))
    {
        gpg --batch --yes --pinentry-mode=loopback --ignore-mdc-error --output $output --decrypt $file
    }else {
        gpg --batch --yes --pinentry-mode=loopback --ignore-mdc-error --passphrase $passphrase --output $output  --decrypt $file
    }

## archive encrypted file?
if ($Archive -eq '1')
    {

        $file | move-item $archivefolder -force

        $date = get-date
        $currentday = $date.toshortdatestring()
        foreach ($File in (get-childitem $archivefolder -File))
            {
                $span = New-TimeSpan -Start $file.LastWriteTime.ToShortDateString() -End $currentday
                IF ($span.Days -gt "14") #adjust the number for how many days to keep
                    {
                        remove-item $file.FullName
                    }
            } #Checks your Archiving Directory for any files > X Days old and removes them

    }else{

        $file | remove-item -force
        
    }


