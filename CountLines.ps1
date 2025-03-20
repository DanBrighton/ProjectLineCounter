param (
    [Parameter(Mandatory = $false)]
    [string]$Path = "."
)

if (-not (Test-Path $Path)) {
    Write-Error "The specified path '$Path' does not exist."
    exit 1
}

$excludedExtensions = @(
    ".jpg", ".png", ".jpeg", ".gif", ".bmp", ".tiff",
    ".pdf", ".webp", ".img",
    ".exe",
    ".mp3", ".mp4", ".avi", ".mov", ".wmv", ".mkv", ".flv",
    ".wav", ".aac", ".ogg", ".flac",
    ".zip", ".rar", ".7z", ".tar", ".gz", ".bz2",
    ".dll", ".so", ".bin", ".iso",
    ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx"
)

Write-Host "Counting lines of code in repository at: $Path`n"

$files = Get-ChildItem -Path $Path -Recurse -File | Where-Object { 
    $_.FullName -notmatch "\\\.git\\" -and 
    $excludedExtensions -notcontains $_.Extension.ToLower()
}
$totalLines = 0

foreach ($file in $files) {
    try {
        $lines = (Get-Content $file.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines
        $totalLines += $lines
    }
    catch {
        Write-Warning "Could not read file: $($file.FullName)"
    }
}

Write-Host "`nTotal lines of code: $totalLines"