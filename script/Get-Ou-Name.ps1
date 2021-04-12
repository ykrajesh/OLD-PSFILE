# change the DistinguishedName Which Ou you want to export name 
Import-Module ac*
$ouname = Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase "DC=boicorp,DC=net" -SearchScope Subtree | select DistinguishedName
$finalout = @()
foreach ($ou in $ouname)
{

$DNList = $ou.DistinguishedName
$DNList = $DNList.Split(',')[0].Split('=')[-1]
$obj = new-object psobject
$obj | add-member -membertype noteproperty -Name "OUName" -value $DNList
$finalOut +=$obj
Write-Host "Data Collecting Plese wait $DNList" -ForegroundColor Cyan
}

$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "Ou_Name_Report-$da" + '.csv'
#Change the Path Where You want to save csv file .
$finalOut | export-csv Z:\Study_material\$csv  -notypeinformation -Encoding UTF8