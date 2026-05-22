$LogPath = 'C:\UO\logs'
$LogFile = "$LogPath\RSAT-install.log"

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

Log "Starting RSAT installation."

@(
    'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0',
    'Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0'
) | ForEach-Object {

    $cap = Get-WindowsCapability -Online -Name $_

    if ($cap.State -eq 'Installed') {
        Log "$_ already installed."
    }
    else {
        Log "Installing $_ ..."
        Add-WindowsCapability -Online -Name $_ | Out-Null
        Log "$_ installation completed."
    }
}

Log "RSAT installation finished successfully."