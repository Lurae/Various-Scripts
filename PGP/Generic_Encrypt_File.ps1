### Encrypt ###
$file = 'XXX\filetoencrypt.csv' #full directory + Filename
$key = 'XXX' #KeyID from gpg

$Archive = '0' #if you want to archive pre-encryption, set to '1'
$archivefolder = '' #only required if above is set to '1'

gpg -e -r $key $file

## archive file pre-encyption
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