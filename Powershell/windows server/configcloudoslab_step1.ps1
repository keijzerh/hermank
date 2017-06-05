# install script cloudosacademy vm part 1
#get computernumber
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$computernumber
)

$hostname=get-wmiobject win32_Computersystem | Select-Object -ExpandProperty name
if ($hostname -eq $null)
{
    $hostname = "unknown"
}
# rename computer
if ($hostname.StartsWith("CLOUDOS"))
	{
   	write-host "Hostname already changed: " $hostname -ForegroundColor Red
	}
else
	{
	$computername="CloudOSlab" + $computernumber
	write-host "rename computer to: "  $computername -ForegroundColor Green
	Rename-Computer -NewName $computername
	Restart-Computer
	}


# install hyper-v
$featurelist=Get-WindowsFeature -Name Hyper-v 
if ($featurelist.Installed -match "True")
	{
	write-host "hyper-v already installed" -ForegroundColor Red
	}
else
	{
	write-host "install hyper-v" -ForegroundColor Green
	Install-WindowsFeature Hyper-V -IncludeManagementTools -Restart
	
	}


