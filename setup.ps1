# Prépare le projet : dossiers Android, dépendances, AndroidManifest.xml
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "1/4 Sauvegarde de lib et pubspec.yaml..." -ForegroundColor Cyan
$bak = Join-Path $env:TEMP "cv_flutter_bak"
if (Test-Path $bak) { Remove-Item $bak -Recurse -Force }
New-Item -ItemType Directory $bak | Out-Null
Copy-Item "lib" (Join-Path $bak "lib") -Recurse
Copy-Item "pubspec.yaml" (Join-Path $bak "pubspec.yaml")

Write-Host "2/4 Generation des dossiers Android (flutter create)..." -ForegroundColor Cyan
flutter create --platforms=android .

# Restauration de notre code (flutter create ne doit rien ecraser)
Copy-Item (Join-Path $bak "lib\*") "lib" -Recurse -Force
Copy-Item (Join-Path $bak "pubspec.yaml") "pubspec.yaml" -Force
if (Test-Path "test") { Remove-Item "test" -Recurse -Force }

Write-Host "3/4 Configuration d'AndroidManifest.xml..." -ForegroundColor Cyan
$f = Join-Path $PSScriptRoot "android\app\src\main\AndroidManifest.xml"
$c = [System.IO.File]::ReadAllText($f)
if ($c -notmatch "android.permission.INTERNET") {
  $insert = @"
<uses-permission android:name="android.permission.INTERNET"/>
    <queries>
        <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
        <intent><action android:name="android.intent.action.DIAL"/><data android:scheme="tel"/></intent>
        <intent><action android:name="android.intent.action.SENDTO"/><data android:scheme="mailto"/></intent>
    </queries>
    <application android:usesCleartextTraffic="true"
"@
  $c = ([regex]'<application').Replace($c, $insert.TrimEnd(), 1)
  [System.IO.File]::WriteAllText($f, $c, (New-Object System.Text.UTF8Encoding $false))
  Write-Host "   Manifest mis a jour." -ForegroundColor Green
} else {
  Write-Host "   Manifest deja configure." -ForegroundColor Yellow
}

Write-Host "4/4 Installation des dependances (flutter pub get)..." -ForegroundColor Cyan
flutter pub get

Write-Host ""
Write-Host "Termine ! Ouvrez ce dossier dans Android Studio et lancez l'application." -ForegroundColor Green
