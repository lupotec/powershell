Copy-Item -Path .\z99600L16 -Destination C:\Temp\z99600L16 -recurse -Force

# Get the driver file. Select the first, in case there are more
$inf = Get-ChildItem -Path "C:\Temp\z99600L16" -Recurse -Filter "*.inf" |
    Where-Object Name -NotLike "Autorun.inf" |
    Select-Object -First 1 |
    Select-Object -ExpandProperty FullName

# Check that the inf file is the one you're looking for
Write-Host "The inf file is '$inf'" -ForegroundColor Cyan

# Install the driver
PNPUtil.exe /add-driver $inf /install

# Retrieve driver info
$DismInfo = Dism.exe /online /Get-DriverInfo /driver:$inf

# Retrieve the printer driver name
#$DriverName = ( $DismInfo | Select-String -Pattern "Description" | Select-Object -Last 1 ) -split " : " |
    #Select-Object -Last 1

$DriverName="RICOH MP C4504ex PCL 6"

# Add driver to the list of available printers
#Add-PrinterDriver -Name $DriverName -Verbose


Add-PrinterDriver -Name $DriverName

# Add local printer port (SilentlyContinue skips without errors in case the port name already exists)
#Add-PrinterPort -Name "LocalPort:" -ErrorAction SilentlyContinue -Verbose

# Add a network printer port
#Add-PrinterPort -Name "TCPPort:10.115.0.50" -PrinterHostAddress "10.115.0.50" -ErrorAction SilentlyContinue

#Add the printer
#Add-Printer -DriverName $DriverName -Name $DriverName -PortName (Get-PrinterPort -Name LocalPort*).Name -Verbose




Add-Printer -Name $DriverName -DriverName $DriverName -PortName "TCPPort:10.115.0.50"







#C:\temp\z99600L16\RV_SETUP.exe
exit
#Start-Sleep -Seconds 10