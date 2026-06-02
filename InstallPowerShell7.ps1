$url = 'https://github.com/PowerShell/PowerShell/releases/download/v7.6.2/PowerShell-7.6.2-win-x64.msi'
$path = 'C:\Temp\pwsh.msi'

If (-Not (Test-Path -Path $path)) {
    New-Item -ItemType File -Path $path -Force | Out-Null
}

Invoke-WebRequest -Uri $url -OutFile $path -Verbose
Start-Process msiexec.exe -wait -ArgumentList "/i $path /qn /norestart"
Remove-Item $path -Force