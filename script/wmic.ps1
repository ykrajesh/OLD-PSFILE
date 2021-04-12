#Get System Information
Write-Host "System Info File Generate" -ForegroundColor Cyan
$date = get-date
wmic csproduct | Format-Table –AutoSize > "E:\Script\System-info.txt"
ipconfig | Format-Table –AutoSize > "D:\ipinfo-info.txt"
