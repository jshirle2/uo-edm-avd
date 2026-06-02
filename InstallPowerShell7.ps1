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

Log "Installing NuGet provider."


If (-Not (Test-Path -Path $path)) {
    New-Item -ItemType File -Path $path -Force | Out-Null
}

Invoke-WebRequest -Uri $url -OutFile $path -Verbose
Start-Process msiexec.exe -wait -ArgumentList "/i $path /qn /norestart"
Remove-Item $path -Force