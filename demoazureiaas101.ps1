<<<<<<< HEAD
#demo cheat sheet 05 Azure IAAS
#sampple powershell
#slide 8
#show github 
#https://github.com/Azure/azure-quickstart-templates
$IE=new-object -com internetexplorer.application
$IE.navigate2("https://github.com/Azure/azure-quickstart-templates")
$IE.visible=$true

#slide 9
#installation Azure arm powershell
#eerst installatie powershell webplatform installer
$IE=new-object -com internetexplorer.application
$IE.navigate2("https://www.microsoft.com/web/downloads/platform.aspx")
$IE.visible=$true

#in powershell in adminmode!!!! for updating powershell
Install-module azurerm –allowclobber –force

get-module -ListAvailable Azure*

  

#slide 10
#Login in to azure
Login-AzureRmAccount
$subscrName="Microsoft Azure Internal Consumption"
Select-AzureRmSubscription -SubscriptionName $subscrName

#slide 10
Get-AzureRmResourceProvider -ListAvailable

#extra
get-azurermvmusage -location westeurope
Get-AzureRmStorageUsage


#slide 15
(Get-azureRMlocation | out-gridview -Title "Azure locations")

#slide20
New-AzureRmResourceGroup -Name Azure101 -Location "West Europe" 



#slide 23
New-AzureRmTag -Name "Demo" -Value "Hello"

#slide51
#storageaccount
$stName = “workshopbin124"
$locName = "West Europe"
$rgName = “Azure101“
$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -Type "Standard_LRS" -Location $locName

#retrieve acceskey
$key=Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -AccountName $stName
$Sas=$key[0].Value
$Sas

#upload file
### Use the Azure.Storage module to create a Storage Authentication Context
$StorageContext = New-AzureStorageContext -StorageAccountName $stName -StorageAccountKey $Sas

### Create a Blob Container in the Storage Account
New-AzureStorageContainer -Context $StorageContext -Permission Container -Name media

### Upload a file to the Microsoft Azure Storage Blob Container
$UploadFile = @{
    Context = $StorageContext
    Container = 'media'
    File = "C:\Users\hermank\OneDrive\Pictures\cloudanothercomputer.jpg"
    }
Set-AzureStorageBlobContent @UploadFile


#slide 58 show portal storage explorer on source
#https://azurestorageexplorer.codeplex.com/
$IE=new-object -com internetexplorer.application
$IE.navigate2("http://storageexplorer.com/")
$IE.visible=$true



#slide 84 built de VM
$stName = "azws21blb26"
$locName = "West Europe"
$rgName = "AzureWS21"
New-AzureRmResourceGroup -Name $rgName -Location $locName
$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -Type "Standard_GRS" -Location $locName
$singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name singleSubnet -AddressPrefix 10.0.0.0/24
$vnet = New-AzureRmVirtualNetwork -Name TestNet -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/16 -Subnet $singleSubnet
$pip = New-AzureRmPublicIpAddress -Name TestPIP -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name TestNIC -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$cred = Get-Credential -Message "Type the name and password of the local administrator account."
$vm = New-AzureRmVMConfig -VMName WindowsVM -VMSize "Standard_A1"
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName MyWindowsVM -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/WindowsVMosDisk.vhd"
$vm = Set-AzureRmVMOSDisk -VM $vm -Name "windowsvmosdisk" -VhdUri $osDiskUri -CreateOption fromImage
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm



#github
# built vm using ARM
$IE=new-object -com internetexplorer.application
$IE.navigate2("https://github.com/Azure/azure-quickstart-templates")
$IE.visible=$true


#arm deployment
New-AzureRmResourceGroupDeployment -Name testDeployment -ResourceGroupName $rgname -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-windows/azuredeploy.json -Mode Incremental 


#cleanup
Remove-AzureRmResourceGroup -Name Azure101 -Verbose -Force
Remove-AzureRmResourceGroup -Name $rgName -Verbose -Force

=======
#demo cheat sheet 05 Azure IAAS

#slide 8
#show github 
#https://github.com/Azure/azure-quickstart-templates
$IE=new-object -com internetexplorer.application
$IE.navigate2("https://github.com/Azure/azure-quickstart-templates")
$IE.visible=$true

#slide 9
#installation Azure arm powershell
#eerst installatie powershell webplatform installer
$IE=new-object -com internetexplorer.application
$IE.navigate2("https://www.microsoft.com/web/downloads/platform.aspx")
$IE.visible=$true

#in powershell in adminmode!!!! for updating powershell
Install-module azurerm –allowclobber –force

get-module -ListAvailable Azure*

  

#slide 10
#Login in to azure
Login-AzureRmAccount
$subscrName="Microsoft Azure Internal Consumption"
Select-AzureRmSubscription -SubscriptionName $subscrName

#slide 10
Get-AzureRmResourceProvider -ListAvailable

#extra
get-azurermvmusage -location westeurope


#slide 15
(Get-azureRMlocation | out-gridview -Title "Azure locations")

#slide20
New-AzureRmResourceGroup -Name Azure101 -Location "West Europe" 



#slide 23
New-AzureRmTag -Name "Demo" -Value "Hello"

#slide51
#storageaccount
$stName = “workshopbin124"
$locName = "West Europe"
$rgName = “Azure101“
$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -Type "Standard_LRS" -Location $locName

#retrieve acceskey
$key=Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -AccountName $stName
$Sas=$key[0].Value
$Sas

#upload file
### Use the Azure.Storage module to create a Storage Authentication Context
$StorageContext = New-AzureStorageContext -StorageAccountName $stName -StorageAccountKey $Sas

### Create a Blob Container in the Storage Account
New-AzureStorageContainer -Context $StorageContext -Permission Container -Name media

### Upload a file to the Microsoft Azure Storage Blob Container
$UploadFile = @{
    Context = $StorageContext
    Container = 'media'
    File = "C:\Users\hermank\OneDrive\Pictures\cloudanothercomputer.jpg"
    }
Set-AzureStorageBlobContent @UploadFile


#slide 58 show portal storage explorer on source
#https://azurestorageexplorer.codeplex.com/
$IE=new-object -com internetexplorer.application
$IE.navigate2("http://storageexplorer.com/")
$IE.visible=$true



#slide 84 built de VM
$stName = "azws21blb26"
$locName = "West Europe"
$rgName = "AzureWS21"
New-AzureRmResourceGroup -Name $rgName -Location $locName
$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $stName -Type "Standard_GRS" -Location $locName
$singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name singleSubnet -AddressPrefix 10.0.0.0/24
$vnet = New-AzureRmVirtualNetwork -Name TestNet -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/16 -Subnet $singleSubnet
$pip = New-AzureRmPublicIpAddress -Name TestPIP -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name TestNIC -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$cred = Get-Credential -Message "Type the name and password of the local administrator account."
$vm = New-AzureRmVMConfig -VMName WindowsVM -VMSize "Standard_A1"
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName MyWindowsVM -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/WindowsVMosDisk.vhd"
$vm = Set-AzureRmVMOSDisk -VM $vm -Name "windowsvmosdisk" -VhdUri $osDiskUri -CreateOption fromImage
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm



#github
# built vm using ARM
$IE=new-object -com internetexplorer.application
$IE.navigate2("https://github.com/Azure/azure-quickstart-templates")
$IE.visible=$true


#arm deployment
New-AzureRmResourceGroupDeployment -Name testDeployment -ResourceGroupName $rgname -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-windows/azuredeploy.json -Mode Incremental 


#cleanup
Remove-AzureRmResourceGroup -Name Azure101 -Verbose -Force
Remove-AzureRmResourceGroup -Name $rgName -Verbose -Force

>>>>>>> a88b6ace48af3bb89959932bb3b50cd3feaf261b
