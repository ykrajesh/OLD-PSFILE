$rg = Import-Csv -Path D:\Temp\rgname.csv
$finalout = @()
foreach($rgname in $rg)
{

$nicname1 = Get-AzNetworkInterface -ResourceGroupName $rgname.ResourceGroupName
$nicname2 = $nicname1.name
$finalout = @()
foreach($nic1 in $nicname2)

{
$nic = Get-AzNetworkInterface -Name $nic1
$nsg = $nic.NetworkSecurityGroup.Id.Split("/")[-1]
$vmname = $nic.VirtualMachine.Id.Split("/")[-1]
$privateip = $nic.IpConfigurations[0].PrivateIpAddress
$mac =$nic.MacAddress

Write-Host "Network Security $nsg |VM Name $vmname| Private ip address $privateip "`
-ForegroundColor Green
############### Public Ip Address #########
 $pipname = $nic.IpConfigurations[0].PublicIpAddress.Id.Split("/")[-1]
 $pip = (Get-AzPublicIpAddress -Name $pipname | select IpAddress).IpAddress
 Write-Host "PUblic ip address $pip" -ForegroundColor Cyan

               $obj = new-object psobject
               $obj | add-member -membertype noteproperty -Name "VM" -value $vmname
               $obj | add-member -membertype noteproperty -Name "NIC" -value $nic1
               $obj | add-member -membertype noteproperty -Name "NSG" -value $nsg
               $obj | add-member -membertype noteproperty -Name "PRIVATE IP" -value $privateip
               $obj | add-member -membertype noteproperty -Name "PUBLIC IP" -value $pip
               $obj | add-member -membertype noteproperty -Name "MAC ADDRESS" -value $mac
               $finalOut +=$obj
  }  
  }           
               ############ Export File ######################3
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "AZURE-VM-details-$da" + '.csv'
$finalOut | export-csv D:\Temp\$csv  -notypeinformation -Encoding UTF8