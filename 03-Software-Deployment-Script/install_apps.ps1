# ==========================================
# SKRYPT INSTALACYJNY "NEW EMPLOYEE STARTER"
# Autor: [Adrian Tabasz]
# Cel: Automatyczna instalacja podstawowych narzędzi
# ==========================================

Write-Host ">>> Rozpoczynam przygotowanie stanowiska pracy..." -ForegroundColor Green

# 1. Sprawdzenie czy Winget działa
Write-Host "1. Weryfikacja menedżera pakietów..."
winget --version

# 2. Instalacja Google Chrome
Write-Host "2. Instalacja przeglądarki Google Chrome..." -ForegroundColor Yellow
winget install -e --id Google.Chrome --accept-source-agreements --accept-package-agreements

# 3. Instalacja Notepad++ (Narzędzie dla IT)
Write-Host "3. Instalacja edytora Notepad++..." -ForegroundColor Yellow
winget install -e --id Notepad++.Notepad++ --accept-source-agreements --accept-package-agreements

# 4. Instalacja 7-Zip (Archiwizator)
Write-Host "4. Instalacja 7-Zip..." -ForegroundColor Yellow
winget install -e --id 7zip.7zip --accept-source-agreements --accept-package-agreements

Write-Host ">>> ZAKOŃCZONO! Wszystkie aplikacje zainstalowane." -ForegroundColor Green
Write-Host "Naciśnij Enter, aby zamknąć..."
Read-Host