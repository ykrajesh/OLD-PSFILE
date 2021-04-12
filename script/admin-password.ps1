#Administrator Account Check

$Username = "vmadmin"
$Password = "Welcome@1234"

$finduser = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue

if($Username -eq $finduser)
{
  Write-Host "Set  Administrator Password never expire" -ForegroundColor Cyan
  $finduser | Set-LocalUser -PasswordNeverExpires  $true
  Write-Host "Enable Administrator Account " -ForegroundColor Cyan
  $finduser | Enable-LocalUser 
  Write-Host "Administrator Password set " -ForegroundColor Cyan
  $finduser | Set-LocalUser -Password (convertto-securestring $Password -AsPlainText -Force)
  #compmgmt
}
else
{
  Write-Host " Creating Administrator Account And set password" -ForegroundColor Cyan
  New-LocalUser $Username -Password (convertto-securestring $Password -AsPlainText -Force) -FullName $Username -Description "Administrator Account" -ErrorAction SilentlyContinue
  Write-Host " Set  Administrator Password never expire" -ForegroundColor Cyan
  $Username | Set-LocalUser -PasswordNeverExpires  $true
  Write-Host " Administrator Account Enable " -ForegroundColor Cyan
  $Username | Enable-LocalUser
  Write-Host " Add In  Administrator Group " -ForegroundColor Cyan
  Add-LocalGroupMember -Group "Administrators" -Member $Username -ErrorAction SilentlyContinue
  #compmgmt
}
