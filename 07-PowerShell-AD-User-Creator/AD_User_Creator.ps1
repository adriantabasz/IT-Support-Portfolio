# ==========================================
# PROJEKT: AD User Creator - Wersja MODERN GUI
# AUTOR: Adrian Tabasz
# ==========================================

# Włączenie stylów wizualnych (żeby przyciski nie wyglądały jak z Windows 95)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# --- KONFIGURACJA ---
$TestMode = $true 

# --- FUNKCJE LOGICZNE (Bez zmian) ---
Function Stworz-Uzytkownika {
    $Imie = $txtImie.Text
    $Nazwisko = $txtNazwisko.Text
    $Dzial = $cmbDzial.Text

    if ([string]::IsNullOrWhiteSpace($Imie) -or [string]::IsNullOrWhiteSpace($Nazwisko) -or [string]::IsNullOrWhiteSpace($Dzial)) {
        [System.Windows.Forms.MessageBox]::Show("Uzupełnij wszystkie pola!", "Błąd walidacji", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    $Login = ($Imie.Substring(0,1) + $Nazwisko).ToLower()
    $HasloStartowe = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

    # Logika logowania w oknie
    $LogBox.AppendText("--------------------------------`n")
    $LogBox.SelectionColor = 'Gray'
    $LogBox.AppendText("$(Get-Date -Format 'HH:mm:ss') - Przetwarzanie: $Imie $Nazwisko...`n")
    
    if ($TestMode) {
        # Symulacja z lekkim opóźnieniem (by wyglądało, że "pracuje")
        $Form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
        Start-Sleep -Milliseconds 800 
        
        $LogBox.SelectionColor = '#0078D7' # Niebieski
        $LogBox.AppendText(" -> [SUKCES] Utworzono login: $Login`n")
        $LogBox.AppendText(" -> [INFO] Grupa: $Dzial | Folder: \\Home\$Login`n")
        
        $Form.Cursor = [System.Windows.Forms.Cursors]::Default
        [System.Windows.Forms.MessageBox]::Show("Pomyślnie utworzono użytkownika: $Login", "Sukces", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    else {
        # Prawdziwe AD
        Try {
            New-ADUser -Name "$Imie $Nazwisko" -SamAccountName $Login -UserPrincipalName "$Login@twojadomena.local" -Department $Dzial -AccountPassword $HasloStartowe -Enabled $true -ErrorAction Stop
            $LogBox.SelectionColor = 'Green'
            $LogBox.AppendText(" -> [SUKCES] Konto AD gotowe: $Login`n")
        }
        Catch {
            $LogBox.SelectionColor = 'Red'
            $LogBox.AppendText(" -> [BŁĄD] $_`n")
        }
    }
    $LogBox.ScrollToCaret()
}

# --- GUI (DESIGN NOWOCZESNY) ---

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Narzędzia Administratora - User Creator"
$Form.Size = New-Object System.Drawing.Size(500, 580)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = "White" # Czysta biel
$Form.FormBorderStyle = "FixedSingle" # Blokada rozciągania okna
$Form.MaximizeBox = $false

# 1. Górny panel (Header) - Ciemny granat
$HeaderPanel = New-Object System.Windows.Forms.Panel
$HeaderPanel.Size = New-Object System.Drawing.Size(500, 80)
$HeaderPanel.Location = New-Object System.Drawing.Point(0, 0)
$HeaderPanel.BackColor = "#2d3e50" # Nowoczesny ciemny kolor
$Form.Controls.Add($HeaderPanel)

# Tytuł w nagłówku
$lblHeader = New-Object System.Windows.Forms.Label
$lblHeader.Text = "AD USER CREATOR"
$lblHeader.ForeColor = "White"
$lblHeader.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblHeader.AutoSize = $true
$lblHeader.Location = New-Object System.Drawing.Point(20, 25)
$HeaderPanel.Controls.Add($lblHeader)

# Podtytuł (wersja)
$lblSubHeader = New-Object System.Windows.Forms.Label
$lblSubHeader.Text = "v2.0 PRO"
$lblSubHeader.ForeColor = "#a0a0a0"
$lblSubHeader.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$lblSubHeader.AutoSize = $true
$lblSubHeader.Location = New-Object System.Drawing.Point(400, 32)
$HeaderPanel.Controls.Add($lblSubHeader)


# --- SEKCJA DANYCH ---

# Wspólna czcionka dla etykiet
$LabelFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$InputFont = New-Object System.Drawing.Font("Segoe UI", 11) # Nieco większa dla wygody

# Imię
$lblImie = New-Object System.Windows.Forms.Label
$lblImie.Text = "Imię pracownika"
$lblImie.Font = $LabelFont
$lblImie.ForeColor = "#444444"
$lblImie.Location = New-Object System.Drawing.Point(40, 110)
$lblImie.AutoSize = $true
$Form.Controls.Add($lblImie)

$txtImie = New-Object System.Windows.Forms.TextBox
$txtImie.Location = New-Object System.Drawing.Point(43, 135)
$txtImie.Size = New-Object System.Drawing.Size(400, 30)
$txtImie.Font = $InputFont
$Form.Controls.Add($txtImie)

# Nazwisko
$lblNazwisko = New-Object System.Windows.Forms.Label
$lblNazwisko.Text = "Nazwisko pracownika"
$lblNazwisko.Font = $LabelFont
$lblNazwisko.ForeColor = "#444444"
$lblNazwisko.Location = New-Object System.Drawing.Point(40, 180)
$lblNazwisko.AutoSize = $true
$Form.Controls.Add($lblNazwisko)

$txtNazwisko = New-Object System.Windows.Forms.TextBox
$txtNazwisko.Location = New-Object System.Drawing.Point(43, 205)
$txtNazwisko.Size = New-Object System.Drawing.Size(400, 30)
$txtNazwisko.Font = $InputFont
$Form.Controls.Add($txtNazwisko)

# Dział
$lblDzial = New-Object System.Windows.Forms.Label
$lblDzial.Text = "Przypisz do działu (OU)"
$lblDzial.Font = $LabelFont
$lblDzial.ForeColor = "#444444"
$lblDzial.Location = New-Object System.Drawing.Point(40, 250)
$lblDzial.AutoSize = $true
$Form.Controls.Add($lblDzial)

$cmbDzial = New-Object System.Windows.Forms.ComboBox
$cmbDzial.Location = New-Object System.Drawing.Point(43, 275)
$cmbDzial.Size = New-Object System.Drawing.Size(400, 30)
$cmbDzial.Font = $InputFont
$cmbDzial.DropDownStyle = "DropDownList" # Blokada wpisywania głupot, tylko wybór
$cmbDzial.Items.AddRange(@("HR", "IT Support", "Finanse", "Sprzedaż", "Zarząd"))
$Form.Controls.Add($cmbDzial)


# --- PRZYCISK AKCJI ---

$btnCreate = New-Object System.Windows.Forms.Button
$btnCreate.Text = "UTWÓRZ KONTO UŻYTKOWNIKA"
$btnCreate.Location = New-Object System.Drawing.Point(43, 330)
$btnCreate.Size = New-Object System.Drawing.Size(400, 45)
$btnCreate.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btnCreate.BackColor = "#0078D7" # Niebieski "Windowsowy"
$btnCreate.ForeColor = "White"
$btnCreate.FlatStyle = "Flat"    # Płaski styl
$btnCreate.FlatAppearance.BorderSize = 0
$btnCreate.Cursor = [System.Windows.Forms.Cursors]::Hand # Kursor rączka
$btnCreate.Add_Click({ Stworz-Uzytkownika })
$Form.Controls.Add($btnCreate)


# --- KONSOLA LOGÓW ---

$lblLog = New-Object System.Windows.Forms.Label
$lblLog.Text = "Logi operacji:"
$lblLog.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$lblLog.ForeColor = "Gray"
$lblLog.Location = New-Object System.Drawing.Point(40, 390)
$lblLog.AutoSize = $true
$Form.Controls.Add($lblLog)

$LogBox = New-Object System.Windows.Forms.RichTextBox
$LogBox.Location = New-Object System.Drawing.Point(43, 410)
$LogBox.Size = New-Object System.Drawing.Size(400, 100)
$LogBox.ReadOnly = $true
$LogBox.BackColor = "#f9f9f9" # Bardzo jasny szary
$LogBox.BorderStyle = "None"
$LogBox.Font = New-Object System.Drawing.Font("Consolas", 9) # Czcionka konsolowa
$Form.Controls.Add($LogBox)

# Stopka
$lblFooter = New-Object System.Windows.Forms.Label
$lblFooter.Text = "System gotowy. Połączono z symulatorem AD."
$lblFooter.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$lblFooter.ForeColor = "#aaaaaa"
$lblFooter.Location = New-Object System.Drawing.Point(43, 515)
$lblFooter.AutoSize = $true
$Form.Controls.Add($lblFooter)


$Form.ShowDialog()
