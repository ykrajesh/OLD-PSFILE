####################################################################################################
#Read List of servers from a Text file and fetch all local users from the servers mentioned in it. #
#List of local users from servers is exported in CSV file at the same location.                    #
#Written by Rajesh Yadav Monday, June 22, 2020 3:22:03 PM                                                        #
####################################################################################################
$da = Get-Date -Format dd_MM_yyyy_hh_mm_ss
$exp = "Local_user_report_$da" +'.csv'
get-content "C:\host.txt" | foreach-object {
    $Comp = $_
	if (test-connection -computername $Comp -count 1 -quiet)
{
                    ([ADSI]"WinNT://$comp").Children | ?{$_.SchemaClassName -eq 'user'} | %{
                    $groups = $_.Groups() | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}
                    $_ | Select @{n='Server';e={$comp}},
                    @{n='UserName';e={$_.Name}},
                    @{n='Active';e={if($_.PasswordAge -like 0){$false} else{$true}}},
                    @{n='PasswordExpired';e={if($_.PasswordExpired){$true} else{$false}}},
                    @{n='PasswordAgeDays';e={[math]::Round($_.PasswordAge[0]/86400,0)}},
                    @{n='LastLogin';e={$_.LastLogin}},
                    @{n='Groups';e={$groups -join ';'}},
                    @{n='Description';e={$_.Description}}

Write-Progress "Please Wait Data Collecting in Progress"  
                 } 
           } Else {Write-Warning "Server\Computer '$Comp' is Unreachable hence Could not fetch data"}
     }|Export-Csv -NoTypeInformation C:\$exp

