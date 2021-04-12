
#Connect-MSOLService
 
#Get all users with the Old User Principal
 
#$users = Get-MSoluser -All |? {$_.UserPrincipalName -like "*onmicrosoft*"} | select UserPrincipalName
$users = Get-MSoluser -All |? {$_.UserPrincipalName -like "*onmicrosoft*" -and $_.UserPrincipalName -notlike "*Sync_ADSERVER_2f5ce25a14e0@labintra1122.onmicrosoft.com*"}
 

 foreach ($user in $users) {
 
   #Create New User Principal Name
   $newUser = $user.UserPrincipalName -replace "oldDomainName.com", "newDomainName.com"
 
   #Set New User Principal Name
   Set-MsolUserPrincipalName -UserPrincipalName $user.UserPrincipalName -NewUserPrincipalName $newUser
 
   #Display New User Principal Name
   $newUser
 }