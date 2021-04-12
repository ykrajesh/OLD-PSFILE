Import-Module Ac*

$info = Import-Csv Z:\script\hostname.csv
$finalout = @()
foreach($name in $info)

{ $comp =$name.name 
  $ouname = $name.OU
  $des1 = $name.des1
 
  $findcomp = Get-ADComputer -Identity $comp
  
  $movetarget = Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase 'OU=Computer,DC=boicorp,DC=net' -SearchScope Subtree | Where-Object {$_.name -eq "$ouname"} 
  
  if ($ouname -eq $movetarget.Name)
  {
  Set-ADComputer -Identity $findcomp -Description $Des1
  Move-ADObject -Identity $findcomp -TargetPath $movetarget 
  Write-Host "Sucessfull Move $movetarget" -ForegroundColor Cyan
  }
  else
  {
               $obj = new-object psobject
               $obj | add-member -membertype noteproperty -Name "Hostname" -value $comp
               $obj | add-member -membertype noteproperty -Name "Ouname" -value $Ouname
               $obj | add-member -membertype noteproperty -Name "Description" -value $des1
               $finalOut +=$obj
               Write-Host "Not Found |Hostname:= $comp " "|Ouname:=  $ouname" -ForegroundColor Red
}

  }

$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "Ou-not-found-$da" + '.csv'
$finalOut | export-csv c:\Temp\$csv  -notypeinformation -Encoding UTF8