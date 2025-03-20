param (
    [Parameter(Mandatory = $false)]
    [string]$Path = "."
)

if (-not (Test-Path $Path)) {
    Write-Error "The specified path '$Path' does not exist."
    exit 1
}

Write-Host "Counting lines of code in repository at: $Path`n"

$files = Get-ChildItem -Path $Path -Recurse -File | Where-Object { $_.FullName -notmatch "\\\.git\\" }
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