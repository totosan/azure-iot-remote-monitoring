 Param(
        [Parameter(Mandatory=$true,Position=0)] [string] $filePath
    )

	Add-Type -Path "C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.5\System.IO.Compression.FileSystem.dll"
   
    $zipfile = get-item $filePath
    $zip = [System.IO.Compression.ZipFile]::Open($zipfile.FullName, "Update")

    $entries = $zip.Entries.Where({$_.FullName.Contains("EventProcessor-WebJob/settings.job")})
    foreach ($entry in $entries) { $entry.Delete() }

    $entries = $zip.Entries.Where({$_.FullName.Contains("EventProcessor-WebJob/Simulator")})
    foreach ($entry in $entries) { $entry.Delete() }

    $entries = $zip.Entries.Where({$_.FullName.Contains("DeviceSimulator-WebJob/EventProcessor")})
    foreach ($entry in $entries) { $entry.Delete() }

    $zip.Dispose()
