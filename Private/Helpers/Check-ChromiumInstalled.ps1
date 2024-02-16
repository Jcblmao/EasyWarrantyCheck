function Check-ChromiumInstalled {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$Browser = "All"
    )
    $ChromeInstalled = $false
    $EdgeInstalled = $false

    # Check for Google Chrome
    if ($Browser -eq "Chrome" -or $Browser -eq "All") {
        $chromePaths = @(
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe',
            'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe',
            'HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe'
        )
        foreach ($path in $chromePaths) {
            if (Test-Path $path) {
                $ChromeInstalled = $true
                break
            }
        }
    }

    # Check for Microsoft Edge
    if ($Browser -eq "Edge" -or $Browser -eq "All") {
        $edgePaths = @(
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe',
            'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe',
            'HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe'
        )
        foreach ($path in $edgePaths) {
            if (Test-Path $path) {
                $EdgeInstalled = $true
                break
            }
        }
    }

    # If no Chromium browser is installed, download and install Google Chrome
    if (-not ($ChromeInstalled -or $EdgeInstalled)) {
        Write-Host "No Chromium-based browser found. Installing Google Chrome..." -ForegroundColor Cyan
        $Path = $env:TEMP
        $Installer = "chrome_installer.exe"

        # Download the installer
        Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile "$Path\$Installer"

        # Run the installer
        Start-Process -FilePath "$Path\$Installer" -Args "/silent /install" -Verb RunAs -Wait
    }
}