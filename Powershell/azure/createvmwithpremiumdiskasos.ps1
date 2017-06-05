# create vm with premium storage os os disk

$stName = "hspsstorage"
$locName = "West Europe"
$rgName = "AAhkdemo30"
#for standard blob use Standard_ZRS, Standard_GRS, Standard_RAGRS
$storagetype ="Premium_LRS"
New-AzureRmResourceGroup -Name $rgName -Location $locName
$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -Type $storagetype -Location $locName
$singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name singleSubnet -AddressPrefix 10.0.0.0/24
$vnet = New-AzureRmVirtualNetwork -Name TestNet -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/16 -Subnet $singleSubnet
$pip = New-AzureRmPublicIpAddress -Name TestPIP -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name TestNIC -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$cred = Get-Credential -Message "Type the name and password of the local administrator account."
$vm = New-AzureRmVMConfig -VMName WindowsVM -VMSize "Standard_DS2"
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName MyWindowsVM -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/WindowsVMosDisk.vhd"
$vm = Set-AzureRmVMOSDisk -VM $vm -Name "windowsvmosdisk" -VhdUri $osDiskUri -CreateOption fromImage
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm