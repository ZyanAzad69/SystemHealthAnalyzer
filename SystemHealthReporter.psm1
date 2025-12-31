function Get-SystemHealthReport {
    <#
    .SYNOPSIS
        Creates a system health report
    .DESCRIPTION
        Generates HTML and CSV reports about your system
    .EXAMPLE
        Get-SystemHealthReport
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$OutputPath = "C:\System-Health-Report"
    )
    
    # Create output directory
    if (-not (Test-Path -Path $OutputPath)) {
        New-Item -Path $OutputPath -ItemType Directory
        Write-Host "Created Output Directory: $OutputPath" -ForegroundColor Green
    }
    
    # Get system information
    $computerName = $env:COMPUTERNAME
    $timestamp = Get-Date -Format "dd-MM-yyyy"
    
    Write-Host "Starting system health check on $computerName...." -ForegroundColor Cyan
    
    # Get OS info (simplified)
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $computerName = $os.CSName
    $osName = $os.Caption
    $osVersion = $os.Version
    $lastBoot = $os.LastBootUpTime
    $totalRam = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $freeRam = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    
    # Get disk info
    $disks = @()
    $diskObjects = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
    foreach ($disk in $diskObjects) {
        $freePercent = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)
        $disks += [PSCustomObject]@{
            Drive = $disk.DeviceID
            SizeGB = [math]::Round($disk.Size / 1GB, 2)
            FreeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
            FreePercent = $freePercent
            Status = if ($freePercent -lt 10) { "CRITICAL" } elseif ($freePercent -lt 20) { "WARNING" } else { "OK" }
        }
    }
    
    # Get service info (with error handling)
    $services = @()
    try {
        $serviceObjects = Get-Service -ErrorAction Stop | Where-Object {
            $_.StartType -eq "Automatic" -and $_.Status -ne "Running"
        }
        foreach ($service in $serviceObjects) {
            $services += [PSCustomObject]@{
                Name = $service.DisplayName
                Status = $service.Status
                StartType = $service.StartType
            }
        }
    }
    catch {
        Write-Host "Could not get service information (continuing anyway)" -ForegroundColor Yellow
    }
    
    # Get process info
    $processes = Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name,
    @{Name = "CPU"; Expression = { [math]::Round($_.CPU, 2) } },
    @{Name = "MemoryMB"; Expression = { [math]::Round($_.WorkingSet / 1MB, 2) } }
    
    # Create HTML report
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>System Health Report - $computerName</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #2c3e50; }
        h2 { color: #3498db; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #3498db; color: white; }
        .critical { background-color: #e74c3c; color: white; }
        .warning { background-color: #f39c12; color: white; }
        .OK { background-color: #3ce779; color: white; }
    </style>
</head>
<body>
    <h1>System Health Report</h1>
    <p><strong>Computer:</strong> $computerName</p>
    <p><strong>Generated:</strong> $(Get-Date)</p>
    
    <h2>System Information</h2>
    <table>
        <tr><td><strong>OS</strong></td><td>$osName (Version: $osVersion)</td></tr>
        <tr><td><strong>Last Boot</strong></td><td>$lastBoot</td></tr>
        <tr><td><strong>Total RAM</strong></td><td>$totalRam GB</td></tr>
        <tr><td><strong>Free RAM</strong></td><td>$freeRam GB</td></tr>
    </table>
    
    <h2>Disk Information</h2>
    <table>
        <tr>
            <th>Drive</th>
            <th>Size (GB)</th>
            <th>Free (GB)</th>
            <th>Free %</th>
            <th>Status</th>
        </tr>
"@

    # Add disk rows
    foreach ($disk in $disks) {
        $cssClass = if ($disk.Status -eq "CRITICAL") { "critical" }  elseif ($disk.Status -eq "WARNING") { "warning" } else { "OK" }
        $html += @"
        <tr class="$cssClass">
            <td>$($disk.Drive)</td>
            <td>$($disk.SizeGB)</td>
            <td>$($disk.FreeGB)</td>
            <td>$($disk.FreePercent)%</td>
            <td>$($disk.Status)</td>
        </tr>
"@
    }

    $html += @"
    </table>
    
    <h2>Services Not Running (Auto-start)</h2>
"@

    if ($services.Count -gt 0) {
        $html += @"
    <table>
        <tr><th>Service Name</th><th>Status</th><th>Start Type</th></tr>
"@
        foreach ($service in $services) {
            $html += @"
        <tr class="warning">
            <td>$($service.Name)</td>
            <td>$($service.Status)</td>
            <td>$($service.StartType)</td>
        </tr>
"@
        }
        $html += "</table>"
    } else {
        $html += "<p>All automatic services are running.</p>"
    }

    $html += @"
    
    <h2>Top 10 Processes (CPU Usage)</h2>
    <table>
        <tr><th>Process</th><th>CPU %</th><th>Memory (MB)</th></tr>
"@

    foreach ($process in $processes) {
        $html += @"
        <tr>
            <td>$($process.Name)</td>
            <td>$($process.CPU)</td>
            <td>$($process.MemoryMB)</td>
        </tr>
"@
    }

    $html += @"
    </table>
</body>
</html>
"@

    # Save HTML report
    $htmlPath = Join-Path -Path $OutputPath -ChildPath "SystemHealth_$timestamp.html"
    $html | Out-File -FilePath $htmlPath -Encoding UTF8
    
    # Save CSV report
    $csvData = [PSCustomObject]@{
        ReportDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        ComputerName = $computerName
        OS = $osName
        OSVersion = $osVersion
        TotalRAMGB = $totalRam
        FreeRAMGB = $freeRam
        StoppedServices = $services.Count
        LowDiskCount = ($disks | Where-Object { $_.Status -ne "OK" }).Count
    }
    
    $csvPath = Join-Path -Path $OutputPath -ChildPath "SystemHealth_$timestamp.csv"
    $csvData | Export-Csv -Path $csvPath -NoTypeInformation
    
    # Show summary
    Write-Host ""
    Write-Host "=== REPORT COMPLETE ===" -ForegroundColor Green
    Write-Host "HTML Report: $htmlPath" -ForegroundColor Yellow
    Write-Host "CSV Report: $csvPath" -ForegroundColor Yellow
    Write-Host "Services not running: $($services.Count)" -ForegroundColor Cyan
    Write-Host "Disks with issues: $(($disks | Where-Object { $_.Status -ne "OK" }).Count)" -ForegroundColor Cyan
    
    # Ask to open report
    $choice = Read-Host "Open HTML report? (Y/N)"
    if ($choice -eq 'Y') {
        Start-Process $htmlPath
    }
    
    # Return object
    [PSCustomObject]@{
        ComputerName = $computerName
        ReportDate = Get-Date
        HTMLPath = $htmlPath
        CSVPath = $csvPath
        StoppedServices = $services.Count
        DiskIssues = ($disks | Where-Object { $_.Status -ne "OK" }).Count
    }
}

# Export the function
Export-ModuleMember -Function Get-SystemHealthReport