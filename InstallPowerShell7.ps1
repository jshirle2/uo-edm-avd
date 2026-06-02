$url = 'https://github.com/PowerShell/PowerShell/releases/download/v7.6.2/PowerShell-7.6.2-win-x64.msi'
$path = 'C:\Temp\pwsh.msi'

$LogPath = 'C:\UO\logs'
$LogFile = "$LogPath\Powershell-Install.log"

function Log {
    param ($Message)

    if (-not (Test-Path $LogPath)) {
        New-Item -Path $LogPath -ItemType Directory -Force | Out-Null
    }

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "$timestamp  $Message" | Tee-Object -FilePath $LogFile -Append
    Write-Host $Message
}

# Delete previous log
if (Test-Path $LogFile) {
    Remove-Item $LogFile -Force
}

Log "Install Powershell 7.6.2 from $url"


If (-Not (Test-Path -Path $path)) {
    New-Item -ItemType File -Path $path -Force | Out-Null
}

Log "Downloading Powershell 7.6.2 from $url"
Invoke-WebRequest -Uri $url -OutFile $path -Verbose
Log "Installing Powershell 7.6.2"
Start-Process msiexec.exe -wait -ArgumentList "/i $path /qn /norestart ADD_PATH=1 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1"
Remove-Item $path -Force
Log "Powershell 7.6.2 installation finished successfully."