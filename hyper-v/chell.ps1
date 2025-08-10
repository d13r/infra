# Virtual switch
if (-Not (Get-VMSwitch -Name "Hyper-V Internal Network" -ErrorAction SilentlyContinue))
{
    Write-Host "Creating virtual switch..."
    New-VMSwitch -Name "Hyper-V Internal Network" -SwitchType Internal
}

if (-Not (Get-NetIPAddress -InterfaceAlias "vEthernet (Hyper-V Internal Network)" -IPAddress 192.168.5.1 -ErrorAction SilentlyContinue))
{
    Write-Host "Assigning host IP address..."
    New-NetIPAddress `
        -InterfaceAlias "vEthernet (Hyper-V Internal Network)" `
        -IPAddress 192.168.5.1 `
        -PrefixLength 24
}

$Dropbox = Get-Content "$ENV:LOCALAPPDATA\Dropbox\info.json" | ConvertFrom-Json | % 'personal' | % 'path'

# Katniss VM
#Get-VMHardDiskDrive -VMName katniss.djm.me -ErrorAction SilentlyContinue | Remove-Item -ErrorAction SilentlyContinue
#Remove-VM -Name katniss.djm.me -Force -ErrorAction SilentlyContinue

if (-Not (Get-VM katniss.djm.me -ErrorAction SilentlyContinue))
{
    Write-Host "Creating katniss.djm.me..."

    New-VM `
        -Name katniss.djm.me `
        -Generation 2 `
        -MemoryStartupBytes 16GB `
        -NewVHDPath katniss.djm.me.vhdx `
        -NewVHDSizeBytes 100GB `
        -SwitchName "Default Switch"

    Set-VMProcessor `
        -VMName katniss.djm.me `
        -Count 8

    Set-VMMemory `
        -VMName katniss.djm.me `
        -MinimumBytes 16GB

    Add-VMNetworkAdapter `
        -VMName katniss.djm.me `
        -SwitchName "Hyper-V Internal Network"

    $BootOrder = (Get-VMFirmware -VMName katniss.djm.me).BootOrder

    Add-VMDvdDrive `
        -VMName katniss.djm.me `
        -Path "$Dropbox\ISOs\ubuntu-24.04.2-live-server-amd64.iso"

    $DVD = Get-VMDvdDrive -VMName katniss.djm.me

    Set-VMFirmware `
        -VMName katniss.djm.me `
        -BootOrder (@($DVD) + $BootOrder) `
        -SecureBootTemplate MicrosoftUEFICertificateAuthority
}
