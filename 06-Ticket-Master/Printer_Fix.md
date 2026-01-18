# Baza Wiedzy: Rozwiązywanie problemów z drukarką sieciową

**ID Artykułu:** KB-1024
**Dotyczy:** Drukarki HP LaserJet / Konica Minolta
**Ostatnia aktualizacja:** 2023-10-25

###  Symptomy
Użytkownik wysyła plik do druku, ale drukarka nie reaguje lub dioda stanu mruga na czerwono.

### Krok 1: Sprawdzenie Kolejki Wydruku
Często problemem jest "zawieszony" dokument, który blokuje pozostałe.
1. Kliknij **Start** i wpisz `Drukarki`.
2. Wybierz swoją drukarkę i kliknij **Otwórz kolejkę**.
3. Jeśli widzisz stare dokumenty ze statusem "Błąd", kliknij prawym przyciskiem myszy -> **Anuluj wszystkie dokumenty**.

### Krok 2: Restart Usługi Bufora (Dla zaawansowanych)
Jeśli czyszczenie kolejki nie pomaga, zrestartuj usługę systemową (wymaga uprawnień Admina).
1. Otwórz PowerShell jako Administrator.
2. Wpisz komendę:
   `Restart-Service Spooler -Force`
3. Spróbuj wydrukować ponownie.

###  Nadal nie działa?
Jeśli powyższe kroki nie pomogły, zgłoś ticket do Helpdesku L2/L3 podając numer inwentarzowy urządzenia (naklejka z kodem kreskowym).
