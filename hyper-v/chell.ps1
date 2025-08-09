$ErrorActionPreference = "Inquire" # So I can see the error message

# Run as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Make sure Hyper-V is enabled
$feature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -ErrorAction SilentlyContinue
if (-not ($feature.State -eq "Enabled")) {
    Write-Host "Enabling Hyper-V..."
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
    Exit
}

# Configure host
if (-not (Get-VMSwitch -Name "Hyper-V Internal Network" -ErrorAction SilentlyContinue)) {
    Write-Host "Creating virtual switch..."
    New-VMSwitch -Name "Hyper-V Internal Network" -SwitchType Internal
}

if (-not (Get-NetIPAddress -InterfaceAlias "vEthernet (Hyper-V Internal Network)" -IPAddress 192.168.5.1 -ErrorAction SilentlyContinue)) {
    Write-Host "Assigning host IP address..."
    New-NetIPAddress `
        -InterfaceAlias "vEthernet (Hyper-V Internal Network)" `
        -IPAddress 192.168.5.1 `
        -PrefixLength 24
}

$Dropbox = Get-Content "$ENV:LOCALAPPDATA\Dropbox\info.json" | ConvertFrom-Json | % 'personal' | % 'path'

# Katniss
#Get-VMHardDiskDrive -VMName katniss.djm.me -ErrorAction SilentlyContinue | Remove-Item -ErrorAction SilentlyContinue
#Remove-VM -Name katniss.djm.me -Force -ErrorAction SilentlyContinue

if (-not (Get-VM katniss.djm.me -ErrorAction SilentlyContinue)) {
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

# Done
Write-Host "Done."
Pause
