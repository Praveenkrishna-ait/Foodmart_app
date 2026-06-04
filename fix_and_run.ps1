Write-Host "=== Step 1: Killing all Gradle/Java daemon processes ===" -ForegroundColor Cyan
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name "gradle" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
Write-Host "Done." -ForegroundColor Green

Write-Host ""
Write-Host "=== Step 2: Setting GRADLE_USER_HOME to a clean local path ===" -ForegroundColor Cyan
$projectRoot = $PSScriptRoot
$env:GRADLE_USER_HOME = "$projectRoot\android\.gradle_home"
Write-Host "GRADLE_USER_HOME = $env:GRADLE_USER_HOME" -ForegroundColor Green

Write-Host ""
Write-Host "=== Step 3: Pre-downloading Gradle using PowerShell (bypasses Java SSL) ===" -ForegroundColor Cyan

$gradleUrl = "https://services.gradle.org/distributions/gradle-8.14-all.zip"
$gradleVersion = "gradle-8.14-all"

# Compute MD5 hash exactly the same way Gradle wrapper does internally
$md5 = [System.Security.Cryptography.MD5]::Create()
$urlBytes = [System.Text.Encoding]::UTF8.GetBytes($gradleUrl)
$hashBytes = $md5.ComputeHash($urlBytes)
$hash = [System.BitConverter]::ToString($hashBytes).Replace("-", "").ToLower()

$distDir = "$env:GRADLE_USER_HOME\wrapper\dists\$gradleVersion\$hash"
$zipPath = "$distDir\$gradleVersion.zip"
$okPath  = "$distDir\$gradleVersion.zip.ok"

if (Test-Path $okPath) {
    Write-Host "Gradle $gradleVersion already downloaded. Skipping." -ForegroundColor Green
} else {
    New-Item -ItemType Directory -Force -Path $distDir | Out-Null
    Write-Host "Downloading $gradleVersion from Gradle servers using PowerShell..." -ForegroundColor Yellow
    Write-Host "(This uses .NET HTTP - no Java SSL involved)" -ForegroundColor Gray

    try {
        # Use .NET WebClient for faster download with progress
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($gradleUrl, $zipPath)
        # Create the .ok marker file so Gradle wrapper knows the zip is valid
        "" | Out-File -FilePath $okPath -Encoding ASCII
        Write-Host "Download successful!" -ForegroundColor Green
    } catch {
        Write-Host "Download failed: $_" -ForegroundColor Red
        Write-Host "Trying alternate method..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $gradleUrl -OutFile $zipPath -UseBasicParsing
        "" | Out-File -FilePath $okPath -Encoding ASCII
        Write-Host "Download successful via alternate method!" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=== Step 4: Running flutter clean ===" -ForegroundColor Cyan
Set-Location $projectRoot
& flutter clean
Write-Host "Done." -ForegroundColor Green

Write-Host ""
Write-Host "=== Step 5: Getting dependencies ===" -ForegroundColor Cyan
& flutter pub get
Write-Host "Done." -ForegroundColor Green

Write-Host ""
Write-Host "=== Step 6: Building and running the app on your phone ===" -ForegroundColor Cyan
Write-Host "Gradle will now use the pre-downloaded zip - no Java SSL download needed!" -ForegroundColor Green
& flutter run
