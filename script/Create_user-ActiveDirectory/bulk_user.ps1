Import-Module activedirectory
  
$ADUsers = Import-csv C:\Temp\user_create\bulk_users1.csv

foreach ($User in $ADUsers)
{
	$Username 	= $User.username
	$Password 	= $User.password
	$Firstname 	= $User.firstname
	$Lastname 	= $User.lastname
    # Change the distinguished Name Which Ou you Want to Create the User
	$OU 		= "OU=Test-user,DC=boicorp,DC=net"
    $email      = $User.email
    $streetaddress = $User.streetaddress
    $city       = $User.city
    $zipcode    = $User.zipcode
    $state      = $User.state
    $country    = $User.country
    $telephone  = $User.telephone
    $jobtitle   = $User.jobtitle
    $company    = $User.company
    $department = $User.department
    $Password = $User.Password

	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		
		 Write-Warning "User account $Username already exist in Active Directory." 
       
	}
	else
	{
		New-ADUser  -SamAccountName $Username `
            -UserPrincipalName "$Username@test.com" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Lastname, $Firstname" `
            -Path $OU `
            -City $city `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $True
            
            Write-Host "User account $Username Create sucessfully in Active Directory." -ForegroundColor "green"
	}
}
