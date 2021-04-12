Import-Module ac*
$user = Import-Csv C:\Temp\MemberofTestuserGroup.csv
$Groupname = "Test"
foreach($name in $user)
{
$name1 = $name.Name

               Add-ADGroupMember -Identity $Groupname -Members $name1 
               Write-Host "Members add sucessfully " $name1 -ForegroundColor Cyan
             
               $obj = new-object psobject
               $obj | add-member -membertype noteproperty -Name "User Name" -value $name1
               $obj | add-member -membertype noteproperty -Name "Group Name" -value $Groupname
               $finalOut +=$obj
               
}
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "Gruopmember-$da" + '.csv'
$finalOut | export-csv c:\Temp\$csv  -notypeinformation -Encoding UTF8
