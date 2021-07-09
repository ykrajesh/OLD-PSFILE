################################################################################# 
## 
## Computer Movement Script 
## Created by Rajesh Yadav
## Rectified & Tested by 
## Date : 1 July 2021 
## Version : 1.0 
## This scripts check the Computer Object and Move the respetive ou 
################################################################################ 
#import Module 
Import-Module ActiveDirectory
#Import Data From CSV File 
$serverlist = Import-Csv C:\Temp\computername.csv
$finalout = @()
$finalout1 = @()
foreach ($name in $serverlist) 
{
          $comp =$name.name 
          $ouname = $name.OU
          $des1 = $name.des1
    try
    {

          $findcomp = Get-ADComputer -Identity $comp -ErrorAction Stop
          $movetarget = Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase 'OU=Computer,DC=boicorp,DC=net' -SearchScope Subtree | Where-Object {$_.name -eq "$ouname"} 
  
          if ($ouname -eq $movetarget.Name)
             {
                  Set-ADComputer -Identity $findcomp -Description $Des1
                  Move-ADObject -Identity $findcomp -TargetPath $movetarget 
                  Write-Host "Sucessfull Move $comp in OU :$movetarget" -ForegroundColor Green
              }
         else
             {
               $obj = new-object psobject
               $obj | add-member -membertype noteproperty -Name "Hostname" -value $comp
               $obj | add-member -membertype noteproperty -Name "Ouname" -value $Ouname
               $obj | add-member -membertype noteproperty -Name "Description" -value $des1

               $finalOut +=$obj
               Write-Host "OU ($ouname) Not Found But Computer Exist" -ForegroundColor Yellow
             }   
                 
     }
    catch
      {
        
        Write-Host "Computer object Not Found: $comp" -ForegroundColor Cyan
        $obj = new-object psobject
        $obj | add-member -membertype noteproperty -Name "Hostname" -value $comp
        $obj | add-member -membertype noteproperty -Name "Ouname" -value $Ouname
        $obj | add-member -membertype noteproperty -Name "Description" -value $des1
        $finalOut1 +=$obj
      
      }
}
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "Ou-not-found-$da" + '.csv'
$finalOut | export-csv c:\Temp\$csv  -notypeinformation -Encoding UTF8
$csv1 = "Computer-not-found-$da" + '.csv'
$finalOut1 | export-csv c:\Temp\$csv1  -notypeinformation -Encoding UTF8