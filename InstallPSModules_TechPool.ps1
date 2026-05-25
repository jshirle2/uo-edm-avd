$LogPath = 'C:\UO\logs'
$LogFile = "$LogPath\PSModules-install.log"

function Log {
    param ($Message)

    if (-not (test-path $LogFile)) {
        New-Item -Path $LogPath -ItemType Directory
    }
    

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "$timestamp  $Message" | Tee-Object -FilePath $LogFile -Append
    write-host $Message
} 

# Delete previous log
if (Test-Path $LogFile) {
    Remove-Item $LogFile -Force
}


if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Log "Installing NuGet provider because it is not already installed."
    Install-PackageProvider -Name NuGet -Force
    Get-PackageProvider -Name NuGet | Out-Null
}

Log "Starting PowerShell module installation."


$Modules = @(
    'Microsoft.Graph.Authentication',
    'Microsoft.Graph.Users',
    'Microsoft.Graph.Groups',
    'Microsoft.Entra',
    'Az.Accounts',
    'Az.Compute',
    'Az.DesktopVirtualization',
    'Az.Storage',
    'Az.Network',
    'Az.Resources',
    'Az.KeyVault',
    'AWS.Tools.Installer',
    'AWS.Tools.Common',
    'AWS.Tools.EC2',
    'AWS.Tools.S3',
    'AWS.Tools.IdentityManagement'
)

$Modules | ForEach-Object {
    if (-not (Get-InstalledModule -Name $_ -ErrorAction SilentlyContinue)) {
        Log "Installing PowerShell module: $_"
        Install-Module $_ -Scope AllUsers -Force -AllowClobber -Repository PSGallery -Verbose
    }
} 