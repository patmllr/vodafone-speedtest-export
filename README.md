# Vodafone Speedtest HTML-Export Parser

## ✨ Funktionsübersicht

* ✔ Automatische Auswertung von HTML-Speedtest-Dateien
* ✔ Export in CSV (inkl. Datum, Uhrzeit, Download/Upload/Ping)
* ✔ Einfache grafische Dateiauswahl
* ✔ Portable .exe
* ✔ Keine Installation notwendig

---

## 📦 Verwendung (als Endnutzer)

### 1. HTML-Datei herunterladen

Speichere deine Vodafone-Speedtest-Historie als `.html`-Datei:

* Website aufrufen: https://speedtest.vodafone.de
* Speedtests ausführen
* Seite speichern unter z. B. `speedtest.html`

### 2. Tool herunterladen

* Lade die neueste Version von GitHub herunter: [Releases](https://github.com/patmllr/vodafone-speedtest-export/releases/tag/v1.0.0)
* Alternativ: Repository klonen oder ZIP herunterladen:

  ```bash
  git clone https://github.com/patmllr/vodafone-speedtest-export.git
  ```

### 2. `launcher.exe` starten

Ein Doppelklick öffnet den Datei-Dialog. Wähle die gespeicherte HTML-Datei aus.

### 3. Fertig

Die CSV wird im selben Ordner erzeugt. Es erscheint eine Bestätigungsmeldung.

---

## 📁 Projektstruktur

```plaintext
vodafone-speedtest-export/
├── assets/
│   └── vodafone.ico            # Icon für die .exe
├── src/
│   ├── launcher.py             # Startet das Tool
│   ├── launcher-run.vbs        # Startet PowerShell aus der .exe heraus
│   ├── export.ps1              # Parst HTML und erzeugt CSV
│   └── run.vbs                 # Manuelle Einzelstart-Version
```

---

## 💪 Selbst bauen (Dev-Setup)

### Voraussetzungen

* Windows 10/11
* Python 3.11 
* [PyInstaller](https://pyinstaller.org/):

```bash
pip install pyinstaller
```

### Virtuelle Umgebung erstellen (optional, empfohlen)

```bash
python -m venv .venv
.venv\Scripts\activate
```

### Build-Befehl

```bash
pyinstaller --onefile --noconsole \
  --icon=assets/vodafone.ico \
  --add-data "src/launcher-run.vbs;." \
  --add-data "src/export.ps1;." \
  src/launcher.py
```

### Ergebnis

* Die Datei `dist/launcher.exe` ist dein fertiges Tool.

---

## 🔎 Debug & Analyse

### Inhalt der .exe anzeigen

Wenn du prüfen willst, ob alle gewünschten Dateien in der .exe enthalten sind:

```bash
pyi-archive_viewer dist\launcher.exe
```

Im Viewer `l` drücken, um die eingebetteten Dateien aufzulisten (z. B. `export.ps1`, `run.vbs`).

### Logdateien zur Fehlersuche

Falls beim Start oder der Ausführung etwas schiefläuft, erstellt `launcher.py` zwei optionale Logs im Ausführverzeichnis:

* `launcher-debug.log` → Zeigt den Pfad zur eingebetteten `.vbs` und ob sie gestartet wurde
* `launcher-error.log` → Wird erzeugt, wenn ein Python-Fehler auftritt

---

## 📅 Bekannte Besonderheiten / Hinweise

### Doppelte Prozesse

* Durch `--onefile` entpackt sich die .exe zur Laufzeit in `C:\Users\...\AppData\Local\Temp\_MEIxxxx`
* Daher erscheinen **zwei `launcher.exe` Prozesse** im Task-Manager (völlig normal)

### Antivirenprogramme

* Die .exe kann wegen PowerShell-Nutzung **falsch-positiv blockiert werden**
* Empfehlung: `.exe` lokal freigeben oder ZIP verteilen

---

## 🚀 Roadmap / Ideen

* [ ] CSV überschreibschutz / Bestätigung bei existierender Datei
* [ ] Mehrere Dateien gleichzeitig auswählen
* [ ] Direktes Öffnen des Speicherorts nach Export
* [ ] Optionales Logging (für Fehlerdiagnose)

---

## 📁 Lizenz

Dieses Projekt steht unter der MIT-Lizenz.