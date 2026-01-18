# ==========================================
# PROJEKT: Event Hunter v1.0
# OPIS: Raport awarii z ostatnich 24h
# ==========================================

$RaportPath = "$env:USERPROFILE\Desktop\Raport_Incydentow.html"
$Data = Get-Date

# Styl HTML/CSS
$Header = @"
<style>
    body { font-family: sans-serif; background-color: #f4f4f4; }
    h2 { color: #c0392b; border-bottom: 2px solid #c0392b; }
    table { width: 100%; border-collapse: collapse; background: #fff; }
    th { background-color: #e74c3c; color: white; padding: 10px; }
    td { border: 1px solid #ddd; padding: 8px; }
</style>
"@

# Szukanie błędów (Level 2=Error, 3=Warning)
$Filter = @{ LogName='Application'; Level=2,3; StartTime=(Get-Date).AddDays(-1) }

Write-Host "Skanowanie logów..." -ForegroundColor Cyan

try {
    $Events = Get-WinEvent -FilterHashtable $Filter -ErrorAction Stop | 
              Select-Object TimeCreated, LevelDisplayName, Message | 
              Sort-Object TimeCreated -Descending
} catch { $Events = $null }

if ($Events) {
    $Events | ConvertTo-Html -Head $Header -Title "Raport" -PreContent "<h2>🚨 Raport Incydentów: $Data</h2>" | Out-File $RaportPath
    Write-Host "ZNALEZIONO INCYDENTY! Otwieram raport..." -ForegroundColor Red
    Invoke-Item $RaportPath
} else { Write-Host "System czysty." -ForegroundColor Green }