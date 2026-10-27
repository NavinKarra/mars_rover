[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $AppArguments
)

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repository = if ($env:MARS_ROVER_REPOSITORY) { $env:MARS_ROVER_REPOSITORY } else { 'NavinKarra/mars_rover' }
$installDir = if ($env:MARS_ROVER_INSTALL_DIR) { $env:MARS_ROVER_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'mars-rover' }

if ($repository -eq 'OWNER/REPOSITORY') {
    throw 'Set MARS_ROVER_REPOSITORY to the public GitHub owner/repository.'
}
if ($repository -notmatch '^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$' -or $repository -match '(^|/)\.\.?(/|$)') {
    throw 'Invalid GitHub repository.'
}
if ($env:PROCESSOR_ARCHITECTURE -ne 'AMD64' -and $env:PROCESSOR_ARCHITEW6432 -ne 'AMD64') {
    throw 'Unsupported processor architecture. Only Windows x86-64 is published.'
}

$asset = 'mars-rover-windows-x86_64.exe'
$url = "https://github.com/$repository/releases/latest/download/$asset"
$binary = Join-Path $installDir 'mars-rover.exe'
$lockDir = Join-Path $installDir '.update-lock'

New-Item -ItemType Directory -Force -Path $installDir | Out-Null

function Update-Application {
    $temporaryDir = Join-Path $installDir ('.download-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $temporaryDir | Out-Null
    try {
        $download = Join-Path $temporaryDir 'rover.exe'
        $checksumFile = Join-Path $temporaryDir 'checksum'
        Invoke-WebRequest -Uri $url -OutFile $download -UseBasicParsing -TimeoutSec 120 -MaximumRedirection 10
        Invoke-WebRequest -Uri "$url.sha256" -OutFile $checksumFile -UseBasicParsing -TimeoutSec 30

        $expected = ((Get-Content -Path $checksumFile -TotalCount 1) -split '\s+')[0]
        if ($expected -cnotmatch '^[0-9a-f]{64}$') { throw 'Invalid release checksum.' }
        $actual = (Get-FileHash -Algorithm SHA256 -Path $download).Hash.ToLowerInvariant()
        if ($expected -ne $actual) { throw 'Downloaded application failed checksum verification.' }

        if ((Test-Path $binary) -and ((Get-FileHash -Algorithm SHA256 -Path $binary).Hash.ToLowerInvariant() -eq $actual)) {
            Write-Host 'Application is up to date.'
            return
        }
        Move-Item -Force -Path $download -Destination $binary
        Write-Host 'Installed the latest application.'
    }
    finally {
        Remove-Item -Recurse -Force -Path $temporaryDir -ErrorAction SilentlyContinue
    }
}

try {
    New-Item -ItemType Directory -Path $lockDir -ErrorAction Stop | Out-Null
}
catch {
    throw 'Another launcher is updating the application.'
}

try {
    Update-Application
}
catch {
    if (-not (Test-Path $binary)) {
        throw 'Installation failed. Check your connection and published release assets.'
    }
    Write-Warning "Update failed ($($_.Exception.Message)); launching the previously installed application."
}
finally {
    Remove-Item -Force -Path $lockDir -ErrorAction SilentlyContinue
}

& $binary @AppArguments
exit $LASTEXITCODE
