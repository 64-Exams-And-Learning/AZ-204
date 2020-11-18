# login - this will prompt through a browser
Connect-AzAccount

# working through the tutorial at https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm
New-AzResourceGroup `
  -ResourceGroupName "AZ204-tutorial" `
  -Location "CanadaCentral"

# get and store the credentials
$cred = Get-Credential

# create and start a new VM - by default this is a _Windows (Windows Server 2016 Datacenter)_ image
New-AzVm `
  -ResourceGroupName "AZ204-tutorial" `
  -Name "myVM" `
  -Location "CanadaCentral" `
  -VirtualNetworkName "mySubnet" `
  -SecurityGroupName "myNetworkSecurityGroup" `
  -PublicIpAddressName "myPublicIpAddress" `
  -Credential $cred

# connect
Get-AzPublicIpAddress `
  -ResourceGroupName "AZ204-tutorial" | Select IpAddress.IpAddress

# open an RDP session
# `mstsc /v:<ip address>

# returna big list of vm images
Get-AzVMImagePublisher -Location "CanadaCentral"

# return a filtered list of vm images
Get-AzVMImageOffer `
  -Location "CanadaCentral" `
  -PublisherName "MicrosoftWindowsServer"

# return a different filtered list - I'ved added a `Select-Object -First 5`
Get-AzVMImageSku `
  -Location "CanadaCentral" `
  -PublisherName "MicrosoftWindowsServer" `
  -Offer "WindowsServer" | Select-Object -First 5

# deply a vm with a specific image, adding a subnet
New-AzVm `
  -ResourceGroupName "AZ204-tutorial" `
  -Name "myVM" `
  -Location "CanadaCentral" `
  -VirtualNetworkName "mySubnet" `
  -SecurityGroupName "myNetworkSecurityGroup" `
  -PublicIpAddressName "myPublicIpAddress_2" `
  -Credential $cred `
  -SubnetName "mySubnet" `
  -ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter-with-Containers:latest" `
  -AsJob

# use this to view jobs
Get-Job

# getting vm sizes
Get-AzVMSize -Location "CanadaCentral" | Select-Object -First 5

#changing a size aof a running VM - this returns the available sizes in this cluster
Get-AzVMSize -ResourceGroupName "AZ204-tutorial" -VMName "myVM"

# this resizes
$vm = Get-AzVM `
  -ResourceGroupName "AZ204-tutorial" `
  -VMName "myVM"
$vm.HardwareProfile.VmSize = "Standard_B1ls"
Update-AzVM `
  -VM $vm `
  -ResourceGroupName "AZ204-tutorial"

# getting the running state of a VM
Get-AzVM `
  -ResourceGroupName "AZ204-tutorial" `
  -Name "myVM" `
  -Status | Select @{n="Status"; e={$_.Statuses[1].Code}}

# Stopping a VM
Stop-AzVm `
  -ResourceGroupName "AZ204-tutorial" `
  -Name "myVM" `
  -Force

# check the status again

# start a de-allocated VM
Start-AzVM `
  -ResourceGroupName "AZ204-tutorial"
  -Name "myVM"
