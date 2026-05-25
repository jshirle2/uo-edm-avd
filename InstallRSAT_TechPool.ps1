$LogPath = 'C:\UO\logs'
$LogFile = "$LogPath\RSAT-install.log"

function Log {
    param ($Message)

    if (-not (Test-Path $LogPath)) {
    New-Item -Path $LogPath -ItemType Directory -Force | Out-Null
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


$Capabilities = @(
    'Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0',
    'Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0'
)

foreach ($capability in $Capabilities) {

    try {
        $cap = Get-WindowsCapability -Online -Name $capability -ErrorAction Stop

        if ($cap.State -eq 'Installed') {
            Log "$capability already installed"
            continue
        }

        Log "Installing $capability"

        # Attempt install
        Add-WindowsCapability -Online -Name $capability -ErrorAction Stop | Out-Null

        # Validate installation
        $capAfter = Get-WindowsCapability -Online -Name $capability

        if ($capAfter.State -eq 'Installed') {
            Log "$capability installation succeeded"
        }
        else {
            Log "WARNING: $capability installation did not complete successfully (State: $($capAfter.State))"
        }
    }
    catch {
        Log "ERROR installing $capability : $($_.Exception.Message)"
    }
}


Log "RSAT installation finished successfully."