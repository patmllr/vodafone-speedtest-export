# --- Fenster-API laden, um MessageBox in den Vordergrund zu bringen ---
[console]::OutputEncoding = [System.Text.Encoding]::UTF8

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
"@

# --- GUI-Komponenten aktivieren ---
Add-Type -AssemblyName System.Windows.Forms

# --- Datei-Dialog zur HTML-Auswahl ---
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
$dialog.Filter = "HTML-Dateien (*.html)|*.html"
$dialog.Title = "Speedtest-HTML-Datei"

if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $HtmlPath = $dialog.FileName
    $CsvPath  = [System.IO.Path]::ChangeExtension($HtmlPath, ".csv")
    $html     = Get-Content -Path $HtmlPath -Raw

    # --- Regex-Pattern zum Extrahieren der Daten ---
    $pattern = '(?s)<div\s+data-cy="historyRowDesktop"[^>]*>.*?' +
               '<div\s+role="rowheader"[^>]*>(?<dateTime>[^<]+)<span>(?<speedtestID>[^<]+)</span>.*?' +
               '<div\s+data-cy="routerPrevDesktop"[^>]*>(?<downloadRouter>[^<]+)</div>.*?' +
               '<div\s+data-cy="downloadPrevDesktop"[^>]*>(?<downloadDevice>[^<]+)</div>.*?' +
               '<div\s+data-cy="uploadPrevDesktop"[^>]*>(?<upload>[^<]+)</div>.*?' +
               '<div\s+data-cy="pingPrevDesktop"[^>]*>(?<ping>[^<]+)</div>'

    $matches = [System.Text.RegularExpressions.Regex]::Matches($html, $pattern, "Singleline")
    $results = @()

    foreach ($m in $matches) {
        $parts = $m.Groups["dateTime"].Value.Trim() -split '\s*-\s*'
        $results += [PSCustomObject]@{
            Datum          = $parts[0]
            Uhrzeit        = if ($parts.Count -gt 1) { $parts[1] } else { "" }
            SpeedtestID    = $m.Groups["speedtestID"].Value.Trim()
            DownloadRouter = $m.Groups["downloadRouter"].Value.Trim()
            DownloadGeraet = $m.Groups["downloadDevice"].Value.Trim()
            Upload         = $m.Groups["upload"].Value.Trim()
            Ping           = $m.Groups["ping"].Value.Trim()
        }
    }

    $results | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8

    # --- Fenster erzeugen, damit MessageBox in den Vordergrund kommt ---
    $form = New-Object System.Windows.Forms.Form
    $form.TopMost = $true
    $form.ShowInTaskbar = $false
    $form.Opacity = 0
    $form.Show()
    [Win32]::SetForegroundWindow($form.Handle)

    # --- Erfolgsmeldung anzeigen ---
    [System.Windows.Forms.MessageBox]::Show(
        "Speedtest-Daten wurden erfolgreich gespeichert unter:`n$CsvPath",
        "Export abgeschlossen",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )

    $form.Close()
}
