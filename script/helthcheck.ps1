################################################################################# 
## 
## Server Health Check 
## Created by Rajesh Yadav
## Rectified & Tested by 
## Date : 1 July 2021 
## Version : 1.0 
## This scripts check the server Avrg CPU and Memory utlization along with C drive 
## disk utilization and sends an email to the receipents included in the script

################################################################################ 


Write-Progress "Please Wait Data Collecting"
#Import Server List 
$ServerListFile = "C:\Temp\AD-Support\Servers.txt"
$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue 
$Result = @()

ForEach($computername in $ServerList) 
{

$IPresult = [System.Net.Dns]::GetHostAddresses($computername)
$InstalledRAM = Get-WmiObject -Class Win32_ComputerSystem -Computername $computername 
$PhyMEM = [Math]::Round(($InstalledRAM.TotalPhysicalMemory/1GB),2)
$OS = Get-WmiObject -Class win32_operatingsystem -computername $computername |Select-Object @{Name = "MemoryUsage"; Expression = {“{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }}
$AVGProc = Get-WmiObject -computername $computername win32_processor | Measure-Object -property LoadPercentage -Average | Select Average
$vol = Get-WmiObject -Class win32_Volume -ComputerName $computername -Filter "DriveLetter = 'C:'" | Select-object @{Name = "C PercentFree"; Expression = {“{0:N2}” -f  (($_.FreeSpace / $_.Capacity)*100) } }
$cdrive = Get-WmiObject -Class win32_Volume -ComputerName $computername -Filter "DriveLetter = 'C:'" | Select @{Name="C Drive(GB)";Expression={"{0:N1}" -f($_.Capacity/1gb)}},@{Name="FreeSpace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}}
$vol1 = Get-WmiObject -Class win32_Volume -ComputerName $computername -Filter "DriveLetter = 'E:'" | Select-object @{Name = "D PercentFree"; Expression = {“{0:N2}” -f  (($_.FreeSpace / $_.Capacity)*100) } }
$ddrive = Get-WmiObject -Class win32_Volume -ComputerName $computername -Filter "DriveLetter = 'E:'" | Select @{Name="D Drive(GB)";Expression={"{0:N1}" -f($_.Capacity/1gb)}},@{Name="FreeSpace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}}
$WmiUptime = Get-WmiObject -Class win32_operatingsystem -ComputerName $computername
$LocalTime = $WmiUpTime.ConvertToDateTime($WmiUpTime.LocalDateTime)
$Uptime = $WmiUpTime.ConvertToDateTime($WmiUpTime.LastBootUpTime)
$Uptime = ((get-date) - $Uptime).days


$result += [PSCustomObject] @{
    ServerName = "$computername"
	IPAdd = $IPresult
	MEM = $PhyMEM
	MemLoad = "$($OS.MemoryUsage)%"
    CPULoad = "$($AVGProc.Average)%"
        
    # C Drive INfo 
    CDrive = "$($vol.'C PercentFree')%"
    CDriveCapacity = $cdrive.'C Drive(GB)'
    CDrivefree = $cdrive.'FreeSpace(GB)'
    
    # D Drive Info       	
    DDrive = "$($vol1.'D PercentFree')%"
    DDriveCapacity = $ddrive.'D Drive(GB)'
    DDrivefree = $ddrive.'FreeSpace(GB)'

	Uptime = $Uptime}
	


    $Outputreport = "<HTML><TITLE>AD Server Health Report</TITLE>
                     <BODY background-color=violet>
                     <H3><font color=Darkblue><B>AD Server Health Report</b></font></H3>
		             <Table border=2 cellpadding=1 cellspacing=2>
                     <TR align=center>
                     <td align=center><B>AD Server Name</B></TD>
		             <td align=center><b>IP Address</B></TD>
		             <td align=center><b>MEM in GB</B></TD>
		             <td align=center><B>Memory Utilization</B></TD>
                     <td align=center><B>Avrg. CPU Utilization</B></TD> 
                     <td align=center><B>C Drive Capacity</B></TD>
                     <td align=center><B>C Drive Free in GB</B></TD>
                     <td align=center><B>C Drive Free in  % </B></TD>
                     <td align=center><B>D Drive Free Capacity</B></TD>
                     <td align=center><B>D Drive Free in GB</B></TD>
                     <td align=center><B>D Drive Free in  % </B></TD>
                     <td align=center><b>Uptime-Days</B></TD></TR>"
		      

    Foreach($Entry in $Result)
    
        { 
          if(($Entry.CpuLoad) -ge "90") 
 
	{ 
            $Outputreport += "<TR bgcolor=RED>"
	}
	 else

	          
 	{
            $Outputreport += "<TR bgcolor=Silver>"
          }
          $Outputreport += "<TD align=center>$($Entry.ServerName)</TD>
          <TD align=center>$($Entry.IPAdd)</TD><TD align=center>$($Entry.MEM)</TD>
          <TD align=center>$($Entry.MemLoad)</TD><TD align=center>$($Entry.CPULoad)</TD>
          <TD align=center>$($Entry.CDriveCapacity)</TD>
          <TD align=center>$($Entry.CDrivefree)</TD>
          <TD align=center>$($Entry.Cdrive)</TD>
          <TD align=center>$($Entry.DDriveCapacity)</TD>
          <TD align=center>$($Entry.DDrivefree)</TD>
          <TD align=center>$($Entry.Ddrive)</TD>
          <TD align=center>$($Entry.Uptime)</TD></TR>"
	}
     $Outputreport += "</Table></BODY></HTML>" 
}

$messageSubject = "AD Server Health Checklist"
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$report = "AD-Health-Report-$da" + '.htm'
$Outputreport | out-file C:\Temp\AD-Support\output\$report
 





