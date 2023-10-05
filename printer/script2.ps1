Copy-Item -Path .\z99600L16 -Destination C:\Temp\z99600L16 -recurse -Force
$driverPath = "C:\Temp\z99600L16\disk1\oemsetup.inf"
#$driverName = "Brother MFC-J6945DW Printer 2"





$inf = Get-ChildItem -Path "C:\Temp\z99600L16" -Recurse -Filter "*.inf" |
    Where-Object Name -NotLike "Autorun.inf" |
    Select-Object -First 1 |
    Select-Object -ExpandProperty FullName
$DismInfo = Dism.exe /online /Get-DriverInfo /driver:$inf
# Retrieve the printer driver name
$DriverName = ( $DismInfo | Select-String -Pattern "Description" | Select-Object -Last 1 ) -split " : " |
    Select-Object -Last 1




$printerName = "Lazy Printer"
$printerPort = "10.115.0.50"
$printerPortName = "TCPPort:10.115.0.50"

if ($null -eq (Get-Printer -name $printerName)) {
    # Check if driver is not already installed
    if ($null -eq (Get-PrinterDriver -name $driverName -ErrorAction SilentlyContinue)) {
      # Add the driver to the Windows Driver Store
      pnputil.exe /a $driverPath

      # Install the driver
      Add-PrinterDriver -Name $driverName
    } else {
      Write-Warning "Printer driver already installed"
    }

    # Check if printerport doesn't exist
    if ($null -eq (Get-PrinterPort -name $printerPortName)) {
      # Add printerPort
      Add-PrinterPort -Name $printerPortName -PrinterHostAddress $printerPort
    } else {
      Write-Warning "Printer port with name $($printerPortName) already exists"
    }

    try {
      # Add the printer
      Add-Printer -Name $printerName -DriverName $driverName -PortName $printerPortName -ErrorAction stop
    } catch {
      Write-Host $_.Exception.Message -ForegroundColor Red
      break
    }

    Write-Host "Printer successfully installed" -ForegroundColor Green
} else {
 Write-Warning "Printer already installed"
}