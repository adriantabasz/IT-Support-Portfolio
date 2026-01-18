import socket
import os
import platform
import datetime
import hashlib
import sys
import time

# --- KOLORY (Wymaga Windows 10/11 dla poprawnego działania w CMD) ---
os.system('') # Magiczna komenda włączająca kolory w Windows CMD

class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

# --- BAZA ZAGROŻEŃ ---
RISKY_PORTS = {
    21: "FTP (Nieszyfrowany transfer)",
    23: "Telnet (Niebezpieczny)",
    80: "HTTP (Serwer WWW)",
    445: "SMB (Ryzyko WannaCry/Ransomware)",
    3389: "RDP (Zdalny Pulpit)"
}

SUSPICIOUS_PROCESSES = ["miner", "keygen", "crack", "torrent", "mimikatz", "keylogger"]

# --- GŁÓWNE FUNKCJE ---

def print_banner():
    os.system('cls') # Komenda czyszcząca ekran w Windows
    print(Colors.HEADER + """
    #################################################
      S E N T I N E L   S E C U R I T Y   A U D I T
    #################################################
    [!] SYSTEM: WINDOWS ENDPOINT PROTECTION
    [!] STATUS: ACTIVE SCANNING...
    """ + Colors.ENDC)

def scan_ports():
    print(Colors.BLUE + "[*] Faza 1: Skanowanie portów (Localhost)..." + Colors.ENDC)
    open_ports = []
    
    for port, name in RISKY_PORTS.items():
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(0.1)
        result = sock.connect_ex(('127.0.0.1', port))
        
        if result == 0:
            print(f"    {Colors.FAIL}[!] ALARM: Otwarty port {port} ({name}){Colors.ENDC}")
            open_ports.append(port)
        sock.close()
        
    if not open_ports:
        print(f"    {Colors.GREEN}>>> SIEĆ BEZPIECZNA{Colors.ENDC}")
    return open_ports

def scan_processes():
    print(Colors.BLUE + "\n[*] Faza 2: Analiza procesów..." + Colors.ENDC)
    time.sleep(1)
    
    # Przykładowe procesy Windowsowe
    running_processes = ["svchost.exe", "explorer.exe", "chrome.exe", "taskmgr.exe"]
    
    # --- TRYB DEMO (Symulacja wirusa) ---
    if len(sys.argv) > 1 and sys.argv[1] == "test":
        running_processes.append("crypto_miner_v2.exe")
        running_processes.append("keygen.exe")

    found_threats = []
    for proc in running_processes:
        for threat in SUSPICIOUS_PROCESSES:
            if threat in proc:
                print(f"    {Colors.FAIL}[CRITICAL] Wykryto malware: '{proc}'{Colors.ENDC}")
                found_threats.append(proc)
    
    if not found_threats:
        print(f"    {Colors.GREEN}>>> PROCESY CZYSTE{Colors.ENDC}")
    
    return found_threats

def generate_report(open_ports, threats):
    print(Colors.BLUE + "\n[*] Faza 3: Raport końcowy..." + Colors.ENDC)
    
    is_safe = (len(open_ports) == 0) and (len(threats) == 0)
    status = "SECURE" if is_safe else "COMPROMISED"
    color_status = Colors.GREEN if is_safe else Colors.FAIL
    
    audit_data = f"{datetime.datetime.now()}|{status}|{len(threats)}"
    audit_hash = hashlib.sha256(audit_data.encode()).hexdigest()[:16]
    
    print("-" * 40)
    print(f" AUDIT ID: {audit_hash.upper()}")
    print(f" DATA:     {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f" SYSTEM:   {platform.system()} {platform.release()}")
    print(f" WYNIK:    {color_status}{status}{Colors.ENDC}")
    print("-" * 40)
    
    if not is_safe:
        print(f"\n{Colors.WARNING}[!!!] SYSTEM ZABLOKOWANY PRZEZ POLITYKĘ BEZPIECZEŃSTWA.{Colors.ENDC}")

if __name__ == "__main__":
    print_banner()
    ports = scan_ports()
    threats = scan_processes()
    generate_report(ports, threats)
    input("\nNaciśnij Enter, aby zamknąć...") # Żeby okno nie zniknęło od razu na Windowsie