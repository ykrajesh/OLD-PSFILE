#Get-ADUser -Filter * -Properties * | ? {$_.Enabled -notlike "True"} | select samaccountname ,displayname |Export-Csv C:\Temp\Disable_user.csv -NoTypeInformation -Verbose
$user = Import-Csv C:\Temp\Disable_user.csv
$finalout = @()
foreach($name in $user)
{
$name1 = $name.samaccountname
#Set the new password in existing user
#Set-ADAccountPassword -Identity $name1 -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force)
#Enable-ADAccount -Identity $name1

#Write-Host "Username" $name1 -ForegroundColor Cyan

#This Code is given output When  object was changed
$username = Get-ADUser -Identity $name1 -Properties * | select Samaccountname, whenChanged 

               $obj = new-object psobject
               $obj | add-member -membertype noteproperty -Name "Samaccountname" -value $username.Samaccountname
               $obj | add-member -membertype noteproperty -Name "Last Modification" -value $username.whenChanged
               $finalOut +=$obj
               #Write-Host "Not Found |Hostname:= $comp " "|Ouname:=  $ouname" -ForegroundColor Red
}
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "last-modification-$da" + '.csv'
$finalOut | export-csv c:\Temp\$csv  -notypeinformation -Encoding UTF8