Import-Module ac*
$user = Import-Csv C:\Users\iam\Desktop\userdata.csv
$Groupname = "Local Admin Access -lucknow"
$finalout = @()
$finalout1 = @()
foreach($name in $user)
{
$name1 = $name.Name
    
  try{

              $userfind = Get-ADUser -Identity $name1
              if ($userfind -notlike $null)
              {
               Add-ADGroupMember -Identity $Groupname -Members $name1
               Write-Host "User Add Sucessfully " $name1 -ForegroundColor Cyan
               $obj = new-object psobject
               $obj | add-member -membertype noteproperty -Name "User Name" -value $name1
               $obj | add-member -membertype noteproperty -Name "Group Name" -value $Groupname
               $finalOut +=$obj
               }
        }
        
       catch{
                Write-Host "User Not Find "$name1  -ForegroundColor Red
                $obj = new-object psobject
                $obj | add-member -membertype noteproperty -Name "User Name" -value $name1
                $finalOut1 +=$obj
              }
              
}
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "Add-User-$da" + '.csv'
$finalOut | export-csv c:\Temp\$csv  -notypeinformation -Encoding UTF8
$csv1 = "User-not-found-$da" + '.csv'
$finalOut1 | export-csv c:\Temp\$csv1  -notypeinformation -Encoding UTF8