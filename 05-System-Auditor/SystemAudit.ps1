# ==========================================
# PROJEKT: System Auditor v1.0
# OPIS: Raport inwentaryzacyjny sprzętu (CSV)
# ==========================================

$RaportPath = "$env:USERPROFILE\Desktop\Inwentaryzacja_PC.csv"
Write-Host ">>> Zbieranie danych o sprzęcie..." -ForegroundColor Cyan

# 1. Pobieranie danych (WMI/CIM)
$BIOS = Get-CimInstance Win32_Bios
$PC   = Get-CimInstance Win32_ComputerSystem
$OS   = Get-CimInstance Win32_OperatingSystem
$Dysk = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DeviceID -eq "C:" }

# 2. Obliczanie RAM (Sumowanie kości pamięci)
$RAM_Sticks = Get-CimInstance Win32_PhysicalMemory
$TotalRAM   = [Math]::Round(($RAM_Sticks.Capacity | Measure-Object -Sum).Sum / 1GB, 2)

# 3. Tworzenie raportu
$Info = [PSCustomObject]@{
    Data_Audytu   = Get-Date -Format "yyyy-MM-dd HH:mm"
    Komputer      = $PC.Name
    Producent     = $PC.Manufacturer
    Model         = $PC.Model
    Nr_Seryjny    = $BIOS.SerialNumber
    System        = $OS.Caption
    RAM_GB        = $TotalRAM
    Dysk_C_Wolne  = [Math]::Round($Dysk.FreeSpace / 1GB, 2)
}

# 4. Wyświetlenie i Zapis
$Info | Format-List
$Info | Export-Csv -Path $RaportPath -NoTypeInformation -Encoding UTF8
Write-Host ">>> ZAPISANO: $RaportPath" -ForegroundColor Green