Import-Module ActiveDirectory
#Import Data From CSV File 
$serverlist = Import-Csv C:\Temp\computername.csv
$finalout = @()
$finalout1 = @()
foreach ($name in $serverlist) 
{
     try{
               $findcomp = Get-ADComputer -Identity $name.name -Properties * | select name , CanonicalName  -ErrorAction Stop
               $obj = new-object psobject
               $obj | add-member -membertype noteproperty -Name "Hostname" -value $findcomp.name
               $obj | add-member -membertype noteproperty -Name "Ouname" -value $findcomp.CanonicalName
               $finalOut +=$obj
               Write-Host "Computer Find "$name.name -ForegroundColor Green
           }
    catch
         {
            Write-Host "Computer Not Found: "$name.name  -ForegroundColor Red
            $obj = new-object psobject
            $obj | add-member -membertype noteproperty -Name "Hostname" -value $findcomp.name
            $finalOut1 +=$obj
         }
}
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "Computer-Location-$da" + '.csv'
$finalOut | export-csv c:\Temp\$csv  -notypeinformation -Encoding UTF8
$csv1 = "Computer-not-found-$da" + '.csv'
$finalOut1 | export-csv c:\Temp\$csv1  -notypeinformation -Encoding UTF8