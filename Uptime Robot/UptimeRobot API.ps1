$outputfile = 'xxx.csv' #Where to output the data to csv or txt file

$offset = 0
do
{
    $Body = @{
    api_key = '' #Please set your API Key
    alert_contacts = 1
    offset = $offset
}

$data = Invoke-RestMethod -Method Post -UseBasicParsing -Uri 'https://api.uptimerobot.com/v2/getMonitors' -Body $Body -ContentType "application/x-www-form-urlencoded"

$data.monitors | select-object friendly_name,{$_.alert_contacts.value} | convertto-csv -NoTypeInformation | out-file -path $outputfile -append
$offset = $offset + 50

}
while($data)



