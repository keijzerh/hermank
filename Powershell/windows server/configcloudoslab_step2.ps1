# config 2 run after config 1 (hyper-v must be installed"
#get computernumber
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$computernumber
)
# create vswitch
write-host "creating vmswitches for lab" 
write-host "removing existing switches"
get-vmswitch -Name * | ForEach-OBject { Remove-VMSwitch -Name $_.Name -Force:$True }
Write-Host "create internal switch Corpnet01" -ForegroundColor Green
new-VMswitch "CorpNet01" -SwitchType Internal
write-host "create external switch vext on the ethernet port" -ForegroundColor Green
$vadapter = get-netadapter -name "ethernet"
new-VMswitch "vExt" -NetAdapterName $vadapter.Name 


#network for the VM
$ipnumber = "192.168.1." +  $computernumber
write-host "set ipnumber to: " $ipnumber
#remove-netipaddress -IPAddress $ipnumber -Confirm:$false
New-NetIPAddress -InterfaceAlias "vEthernet (CorpNet01)" -IPAddress $ipnumber -DefaultGateway 192.168.1.1 -AddressFamily IPv4 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias "vEthernet (CorpNet01)" -ServerAddresses 192.168.1.4

#turn off firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False 

#turn off Ie enhanced
$AdminKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}”
#$UserKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}”
Set-ItemProperty -Path $AdminKey -Name “IsInstalled” -Value 0
#Set-ItemProperty -Path $UserKey -Name “IsInstalled” -Value 0
Stop-Process -Name Explorer
Write-Host “IE Enhanced Security Configuration (ESC) has been disabled.” -ForegroundColor Green


# turn off auto start server manager
$AdminKey = “HKLM:\SOFTWARE\Microsoft\ServerManager\”
#$UserKey = “HKLM:\SOFTWARE\Microsoft\ServerManager\”
Set-ItemProperty -Path $AdminKey -Name “DoNotOpenServerManagerAtLogon” -Value 1
#Set-ItemProperty -Path $UserKey -Name “DoNotOpenServerManagerAtLogon” -Value 1
Write-Host “Auto start server manager at logon disabled.” -ForegroundColor Green

#set admin accoun to never expires
#net user administrator /expires:never

$user = [adsi] "WinNT://$computername/administrator"
write-host "user " $user
$user.UserFlags.value = $user.UserFlags.value -bor 0x10000
$user.CommitChanges()

#install adobe reader
$Cmdline="D:\PDT\LABdesktopfiles\AdbeRdr1013_en_US.exe"
$arg = "/sAll /msi /norestart ALLUSERS=1 EULA_ACCEPT=YES"
#Start-Process $Cmdline
&$Cmdline $arg

#copy files to the desktop
copy-item D:\pdt\LABdesktopfiles\DD1\*.* C:\users\Administrator\Desktop
copy-item D:\pdt\LABdesktopfiles\DD2\*.* C:\users\Administrator\Desktop

#import vms

#create snapsot/checkpoint