$Results = @()
$servers = Get-Content C:\host.txt
foreach ($servers in $servers)
{ 
Write-Host "Patches Detail Collection In "$servers "Server" -ForegroundColor Green
$Properties = @{
                Hostname =  Get-WmiObject Win32_OperatingSystem -ComputerName $servers | select -ExpandProperty CSName 
                Description = gwmi win32_quickfixengineering -computer $servers | ?{ $_.installedon }| sort @{e={[datetime]$_.InstalledOn}} | select -last 1 | select -ExpandProperty Description 
                HotFixID = gwmi win32_quickfixengineering -computer $servers | ?{ $_.installedon }| sort @{e={[datetime]$_.InstalledOn}} | select -last 1 | select -ExpandProperty HotFixID 
                InstalledBy = gwmi win32_quickfixengineering -computer $servers | ?{ $_.installedon }| sort @{e={[datetime]$_.InstalledOn}} | select -last 1 | select -ExpandProperty InstalledBy 
                Date = gwmi win32_quickfixengineering -computer $servers | ?{ $_.installedon }| sort @{e={[datetime]$_.InstalledOn}} | select -last 1 | select -ExpandProperty InstalledOn
              }
$Results += New-object psobject -Property $Properties

} 
$Results | Select-Object Hostname , HotFixID , Description , InstalledBy, Date | Export-csv -Path C:\Last_Patch_Installed_$((Get-date).ToString('dd-MM-yyyy')).csv -NoTypeInformation 
