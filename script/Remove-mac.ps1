# REMOVE MAC IDS FROM DHCP SERVER

#$list= Get-DhcpServerv4Filter -ComputerName "dc1.abc.com"
$ErrorActionPreference = 'silentlyContinue'
#$comp = "dc1.abc.com"
$comp = Read-Host "Enter DHCP Server FQDN ex. DC1.domain.com"
$compfile = $comp -replace "abc.com","HDFCCHUBBINDIA"

# Enter file location in proper csv format
$list = import-csv C:\macadd.csv
$finalout = @()
foreach ($i in $list)
{
$dhcplist = Get-DhcpServerv4Filter -ComputerName $comp
            foreach ($macid in $dhcplist)
           {
              if ($macid.macaddress -like $i.Macaddress)
             {
               $removed = $i.MacAddress
               $status = "Removed"
                Write-Host "`nRemoving:"$i.MacAddress
                Remove-DhcpServerv4Filter -MacAddress $removed 
            }
            else
                {
                #Write-host "`nNotfound"$i.MacAddress
                    $removed = $i.Macaddress
                        $Status = "Not-Found"
                 }
                 }
$obj = new-object psobject
$obj | add-member -membertype noteproperty -Name "Removed-MacAddress" -Force -value $removed
$obj | add-member -membertype noteproperty -Name "Status" -Force -value $status
$finalOut +=$obj 
         
         }
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "$Compfile-Remove-Status-$da" + '.csv'
$finalOut | export-csv $csv -notypeinformation -Encoding UTF8
