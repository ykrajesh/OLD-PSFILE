################################################################################# 
## 
## Computer Find Script 
## Created by Rajesh Yadav
## Rectified & Tested by 
## Date : 1 July 2021 
## Version : 1.0 
## This scripts check the Computer Object and Export Distinguished Name  
################################################################################ 
#import active directory Module 
Import-Module ActiveDirectory
#Import Data From CSV File 
$serverlist = Import-Csv C:\Temp\computername.csv
$finalout = @()
$finalout1 = @()
foreach ($name in $serverlist) 
{
 $comp =$name.name 
 
 try {

         Write-Host "Collecting Data hostname : $comp" -ForegroundColor Green
         $ouname = Get-ADComputer -Identity $comp | select name , DistinguishedName 
         $obj = new-object psobject
         $obj | add-member -membertype noteproperty -Name "OUName" -value $ouname.name
         $obj | add-member -membertype noteproperty -Name "DistinguishedName" -value $ouname.DistinguishedName
         $finalOut +=$obj
     }
 catch
     {
        Write-Host "Computer Not Find : $comp" -ForegroundColor Red
        $obj = new-object psobject
        $obj | add-member -membertype noteproperty -Name "Hostname" -value $comp
        $finalOut1 +=$obj

     }
}
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "Computer-Path-$da" + '.csv'
$finalout | Export-Csv C:\Temp\$csv -NoTypeInformation -Encoding UTF8
$csv1 = "Computer-not-found-$da" + '.csv'
$finalOut1 | export-csv c:\Temp\$csv1  -notypeinformation -Encoding UTF8