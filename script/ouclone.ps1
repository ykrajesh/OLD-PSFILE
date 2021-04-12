#$target = "OU=office2,DC=boicorp,DC=net"
#Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase $target -SearchScope Subtree | select name ,DistinguishedName | Export-Csv c:\ouname.csv -NoTypeInformation

$name = Import-Csv C:\ouname.csv
foreach($ou in $name)
{
 $DNList = $ou.DistinguishedName
 $DNList1 = $DNList|foreach{($_ -split ',')[1..20] -join ','}
 
 New-ADOrganizationalUnit -Name $ou.name -Path $DNList1

 Write-Host "create Sucessfuly "$ou.name -ForegroundColor Cyan 
 sleep 01
}
