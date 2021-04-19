# Collect the eventlog 
# Sent the mail in admin team 
# make sure turn OFF the two step verification 
# also Enable the the less security app Access in gmail account this setting under the security option 

[CmdletBinding()]
param
(
 [Parameter(mandatory=$true , position=0)]
 $logname ="Application",
 $Entry = "SuccessAudit" ,
 $computername = "localhost"

)
$time = (Get-Date).AddMinutes(-10)

$event = Get-EventLog -LogName $logname -EntryType $Entry -After $time | `
select TimeGenerated , EventID , Source , @{label='Message';Expression={($_.Message).Substring(0,80)}}
$event | Export-Csv d:\emailsent.csv -NoTypeInformation

##########################SMPT Details ########################
$from = 'XXXXXXXXXXX@gmail.com'
$to ='XXXXXXXXXXX@gmail.com'
$Cc = "XXXXXXXXXXX@outlook.com"
$subject = "Error Found Admin Please Check "
$body = $event | ConvertTo-Html | Out-String
$attached = "d:\emailsent.csv"
$smpt = "smtp.gmail.com"
Write-Host "event collect Please Wait "-ForegroundColor Cyan
#####################################################

if ($event)
{
############################Account Id and Password ##################
 $userName = 'ykrajesh054'#type you gmail user id 
 $password = 'XXXXXXXXXXX'
 $pwdSecureString = ConvertTo-SecureString -Force -AsPlainText $password
 $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $pwdSecureString
 ########################## Sent Mail #####################################
 
 Send-MailMessage -From $from -To $to -Cc $Cc -Subject $subject -Body $body -Attachments $attached -Port 587 -SmtpServer $smpt -BodyAsHtml `
 -Credential $credential -UseSsl
 Write-Host "Event Find And mail sent to "$to -ForegroundColor Green
}
