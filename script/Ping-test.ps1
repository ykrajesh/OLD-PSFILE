$finalOut=@()
$names = Import-Csv D:\PowerShell-Script\hostname.csv
foreach ($name1 in $names)
{
  $name = $name1.hostname
  if (Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue)
  {


               $obj = new-object psobject
               $obj | add-member -membertype noteproperty -Name "Hostname" -value $name
               $obj | add-member -membertype noteproperty -Name "Status" -value "Running"
               $finalOut +=$obj
               Write-Host "Hostname:= $name " "Running " -ForegroundColor Green
  }
  else
  {
               $obj = new-object psobject
               $obj | add-member -membertype noteproperty -Name "Hostname" -value $name
               $obj | add-member -membertype noteproperty -Name "Status" -value "Stop"
               $finalOut +=$obj
               Write-Host "Hostname:= $name " "Is Not Running Please Check " -ForegroundColor Red
  }
}
$da = get-date -format dd_MM_yyyy-hh-mm-ss
$csv = "Ping-result-$da" + '.csv'
$finalOut | export-csv D:\PowerShell-Script\csvfiles\$csv  -notypeinformation -Encoding UTF8