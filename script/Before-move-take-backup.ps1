#import active directory Module 
Import-Module ac*
$finalout = @()
for ($i=1; $i -le 6; $i++) 

{
 Write-Host "Ou Name  $i" -ForegroundColor Green
 Write-Progress "Please Wait Collecting Data"
 $hostname = "USER02-$i"
 $ouname = Get-ADComputer -Identity $hostname | select name , DistinguishedName 
 $obj = new-object psobject
 $obj | add-member -membertype noteproperty -Name "OUName" -value $ouname.name
 $obj | add-member -membertype noteproperty -Name "DistinguishedName" -value $ouname.DistinguishedName
 $finalOut +=$obj
 sleep 5
}
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "Before-movement-$da" + '.csv'
$finalout | Export-Csv C:\Temp\$csv -NoTypeInformation -Encoding UTF8