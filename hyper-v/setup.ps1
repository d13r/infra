$ErrorActionPreference = "Stop"

try
{
    # Make sure Hyper-V is enabled
    $feature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -ErrorAction SilentlyContinue
    if (-not ($feature.State -eq "Enabled"))
    {
        Write-Host "Enabling Hyper-V..."
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
        Write-Host "Please reboot and run this script again."
        Exit
    }

    # Run host-specific setup
    . "$PSScriptRoot/$($env:COMPUTERNAME.ToLower() ).ps1"

    # Confirm it was successful
    Write-Host "Done."
}
catch
{
    Write-Host -Foreground Red -Background Black ($_ | Out-String)
}
finally
{
    Pause
}
