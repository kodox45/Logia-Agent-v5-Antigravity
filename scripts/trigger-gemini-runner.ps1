param(
    [Parameter(Mandatory=$true)]
    [string]$Workspace
)

$Workspace = $Workspace.Trim('"').Trim("'")

# --- Auto-detect Gemini CLI ---
$geminiPath = $null

# 1. Check PATH
$pathResult = Get-Command "gemini" -ErrorAction SilentlyContinue
if ($pathResult) {
    $geminiPath = $pathResult.Source
}

# 2. Fallback: known install locations
if (-not $geminiPath) {
    $knownPaths = @(
        "$env:USERPROFILE\.local\bin\gemini.exe",
        "$env:LOCALAPPDATA\Programs\gemini\gemini.exe",
        "$env:APPDATA\npm\gemini.cmd"
    )
    foreach ($p in $knownPaths) {
        if (Test-Path $p) {
            $geminiPath = $p
            break
        }
    }
}

# --- Validate ---
if (-not $geminiPath) {
    Write-Host "ERROR: Gemini CLI not found." -ForegroundColor Red
    Write-Host "  Install: npm install -g @google/gemini-cli" -ForegroundColor Red
    Write-Host "  Checked: PATH, ~/.local/bin/, LocalAppData, npm global" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

if (-not (Test-Path $Workspace)) {
    Write-Host "ERROR: Workspace not found: $Workspace" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Set-Location $Workspace

# --- Read prompt from file ---
$promptFile = Join-Path $Workspace ".ba/triggers/.gemini-prompt"

if (-not (Test-Path $promptFile)) {
    Write-Host "ERROR: Prompt file not found: $promptFile" -ForegroundColor Red
    Write-Host "  BA skill must write the prompt before triggering." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$PromptText = (Get-Content $promptFile -Raw).Trim()
Remove-Item $promptFile -Force

if ([string]::IsNullOrWhiteSpace($PromptText)) {
    Write-Host "ERROR: Prompt file was empty." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# --- Header ---
Write-Host ""
Write-Host "========================================" -ForegroundColor DarkCyan
Write-Host "  Logia Agent V5 - Gemini CLI Trigger" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor DarkCyan
Write-Host "  Workspace : $Workspace" -ForegroundColor Gray
Write-Host "  Gemini    : $geminiPath" -ForegroundColor Gray
Write-Host "  Prompt    : $PromptText" -ForegroundColor Gray
Write-Host "  Started   : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor DarkCyan
Write-Host ""

# --- Launch Gemini CLI in interactive TUI mode ---
# Uses -i (--prompt-interactive) to execute initial prompt AND keep TUI open.
# This is the equivalent of Claude Code's positional arg: `claude "prompt"`.
# --prompt would run headless (non-interactive) which hides the TUI.
Write-Host "[Launch] Starting Gemini CLI with prompt..." -ForegroundColor Yellow
Write-Host "  TUI will appear below. Type /quit or Ctrl+C when done." -ForegroundColor Gray
Write-Host ""

& $geminiPath -i $PromptText --yolo

Write-Host ""
Write-Host "========================================" -ForegroundColor DarkCyan
Write-Host "  Session ended at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor DarkCyan
Read-Host "Press Enter to close"
