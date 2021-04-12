#$imp = Import-Csv D:\services1.csv  stop-services1
$imp = Import-Csv D:\stop-services.csv
$finalout = @()
$finalout1 = @()
foreach ( $data in $imp )
{
$find = get-service -Name $data.Name 
if ($find.Status -eq "Running")
{
 Write-Host "Services Running "$data.Name -ForegroundColor Green

  $obj1 = new-object psobject
               $obj1 | add-member -membertype noteproperty -Name "Name" -value $data.Name
               $obj1 | add-member -membertype noteproperty -Name "Status" -value $find.Status
               $finalOut1 +=$obj1
}
else
{
 
 Write-Host "Services Stoped Please check " $data.Name -ForegroundColor Cyan
               $obj = new-object psobject
               $obj | add-member -membertype noteproperty -Name "Name" -value $data.Name
               $obj | add-member -membertype noteproperty -Name "Status" -value $find.Status
               $finalOut +=$obj
              
}

}
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "Services-Stop-$da" + '.csv'
$finalOut | export-csv D:\$csv  -notypeinformation -Encoding UTF8

$csv1 = "Services-Running-$da" + '.csv'
$finalOut1 | export-csv D:\$csv1  -notypeinformation -Encoding UTF8