for($i = 1; $i -lt 5000 ; $i++)
{
 $username = "Test$i"
 
 if (Get-ADUser -F {SamAccountName -eq $Username})
	{
	  Write-Warning "User account $Username already exist in Active Directory." 
   	}
	else
	{
 $fuser= New-ADUser -Name "$username"  -Path "OU=Test-user,DC=boicorp,DC=net" 
 #Add-ADGroupMember -Identity "testuser" -Members "test$i"
 #Add-ADGroupMember -Identity "laptop" -Members "test$i"
 #Get-ADGroupMember -Identity "testuser"
 Write-Host "User added Successully $username" -ForegroundColor "Green"
}
}

    