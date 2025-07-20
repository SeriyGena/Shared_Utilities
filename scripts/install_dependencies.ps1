# Install dependencies from pyproject.toml
# Checks for missing packages and installs only what's needed
# Works with both Poetry and pip
# Run from project root: .\scripts\install_dependencies.ps1

param(
    [Parameter(Mandatory=$false, HelpMessage="Install development dependencies")]
    [switch]$IncludeDev,
    
    [Parameter(Mandatory=$false, HelpMessage="Force reinstall all dependencies")]
    [switch]$Force,
    
    [Parameter(Mandatory=$false, HelpMessage="Skip dependency check, just install")]
    [switch]$SkipCheck
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Python Dependencies Installer" -ForegroundColor Green  
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if pyproject.toml exists
if (-not (Test-Path "pyproject.toml")) {
    Write-Host "ERROR: pyproject.toml not found in current directory." -ForegroundColor Red
    Write-Host "Please run this script from the project root directory." -ForegroundColor Red
    exit 1
}

# Check Python version
Write-Host "Checking Python version..." -ForegroundColor Cyan
$pythonVersion = & python --version 2>&1
if ($pythonVersion -match "Python (\d+)\.(\d+)\.(\d+)") {
    $major = [int]$matches[1]
    $minor = [int]$matches[2]
    $patch = [int]$matches[3]
    Write-Host "  Python version: $pythonVersion" -ForegroundColor Green
    
    if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 11)) {
        Write-Host "ERROR: Python 3.11+ required. Current: $pythonVersion" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "ERROR: Could not determine Python version." -ForegroundColor Red
    Write-Host "Output: $pythonVersion" -ForegroundColor Red
    exit 1
}

# Check Poetry availability
$usePoetry = $false
try {
    $poetryVersion = poetry --version 2>&1
    if ($poetryVersion -match "Poetry") {
        $usePoetry = $true
        Write-Host "  Poetry version: $poetryVersion" -ForegroundColor Green
    }
} catch {
    Write-Host "  Poetry not found, using pip" -ForegroundColor Yellow
}

Write-Host ""

# Function to get installed packages
function Get-InstalledPackages {
    $installed = @{}
    try {
        $pipList = python -m pip list --format=freeze 2>&1
        foreach ($line in $pipList) {
            if ($line -match "^([^=]+)==(.+)$") {
                $installed[$matches[1].ToLower()] = $matches[2]
            }
        }
    } catch {
        Write-Host "Warning: Could not get installed package list" -ForegroundColor Yellow
    }
    return $installed
}

# Function to parse dependencies from pyproject.toml
function Get-ProjectDependencies {
    param([string]$content)
    
    $mainDeps = @()
    $devDeps = @()
    
    # Extract main dependencies
    if ($content -match '(?s)dependencies\s*=\s*\[(.*?)\]') {
        $depsSection = $matches[1]
        $mainDeps = $depsSection -split ',' | ForEach-Object {
            $dep = $_.Trim() -replace '["\s]', ''
            if ($dep) { $dep }
        }
    }
    
    # Extract dev dependencies
    if ($content -match '(?s)\[project\.optional-dependencies\]\s*dev\s*=\s*\[(.*?)\]') {
        $devSection = $matches[1]
        $devDeps = $devSection -split ',' | ForEach-Object {
            $dep = $_.Trim() -replace '["\s]', ''
            if ($dep) { $dep }
        }
    }
    
    return @{
        main = $mainDeps
        dev = $devDeps
    }
}

# Read and parse pyproject.toml
Write-Host "Reading pyproject.toml..." -ForegroundColor Cyan
try {
    $content = Get-Content "pyproject.toml" -Raw -Encoding UTF8
    $projectDeps = Get-ProjectDependencies $content
    
    Write-Host "  Main dependencies: $($projectDeps.main.Count)" -ForegroundColor Green
    Write-Host "  Dev dependencies: $($projectDeps.dev.Count)" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Could not read or parse pyproject.toml" -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
    exit 1
}

if (-not $SkipCheck) {
    # Check what's missing
    Write-Host ""
    Write-Host "Checking installed packages..." -ForegroundColor Cyan
    $installedPackages = Get-InstalledPackages
    Write-Host "  Currently installed: $($installedPackages.Count) packages" -ForegroundColor Green
    
    # Check missing main dependencies
    $missingMain = @()
    foreach ($dep in $projectDeps.main) {
        if ($dep -match "^([^>=<]+)") {
            $pkgName = $matches[1].ToLower()
            if (-not $installedPackages.ContainsKey($pkgName) -or $Force) {
                $missingMain += $dep
            }
        }
    }
    
    # Check missing dev dependencies (if requested)
    $missingDev = @()
    if ($IncludeDev) {
        foreach ($dep in $projectDeps.dev) {
            if ($dep -match "^([^>=<]+)") {
                $pkgName = $matches[1].ToLower()
                if (-not $installedPackages.ContainsKey($pkgName) -or $Force) {
                    $missingDev += $dep
                }
            }
        }
    }
    
    Write-Host ""
    Write-Host "Dependency analysis:" -ForegroundColor Cyan
    Write-Host "  Missing main dependencies: $($missingMain.Count)" -ForegroundColor $(if ($missingMain.Count -gt 0) { "Yellow" } else { "Green" })
    if ($IncludeDev) {
        Write-Host "  Missing dev dependencies: $($missingDev.Count)" -ForegroundColor $(if ($missingDev.Count -gt 0) { "Yellow" } else { "Green" })
    }
    
    if ($missingMain.Count -eq 0 -and $missingDev.Count -eq 0) {
        Write-Host ""
        Write-Host "SUCCESS: All required dependencies are already installed!" -ForegroundColor Green
        Write-Host "Use -Force to reinstall or -IncludeDev to check dev dependencies" -ForegroundColor Gray
        exit 0
    }
}

Write-Host ""
Write-Host "Installing dependencies..." -ForegroundColor Cyan

if ($usePoetry) {
    # Use Poetry
    Write-Host "Using Poetry for installation..." -ForegroundColor Green
    
    if ($Force) {
        Write-Host "  Forcing reinstall of all dependencies..."
        poetry install --sync
    } else {
        poetry install
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  SUCCESS: Dependencies installed successfully with Poetry" -ForegroundColor Green
    } else {
        Write-Host "  ERROR: Poetry install failed" -ForegroundColor Red
        exit 1
    }
    
    if ($IncludeDev) {
        Write-Host "  SUCCESS: Development dependencies included" -ForegroundColor Green
    }
    
} else {
    # Use pip
    Write-Host "Using pip for installation..." -ForegroundColor Green
    
    # Install main package in editable mode
    Write-Host "  Installing main package..."
    python -m pip install -e .
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ERROR: Main package installation failed" -ForegroundColor Red
        exit 1
    }
    
    # Install dev dependencies if requested
    if ($IncludeDev) {
        Write-Host "  Installing development dependencies..."
        python -m pip install -e ".[dev]" 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  SUCCESS: Dev dependencies installed" -ForegroundColor Green
        } else {
            Write-Host "  WARNING: Dev dependencies install failed or not available" -ForegroundColor Yellow
        }
    }
    
    Write-Host "  SUCCESS: Dependencies installed successfully with pip" -ForegroundColor Green
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  INSTALLATION COMPLETED!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  SUCCESS: Python version: $pythonVersion" -ForegroundColor White
Write-Host "  SUCCESS: Package manager: $(if ($usePoetry) { 'Poetry' } else { 'pip' })" -ForegroundColor White
Write-Host "  SUCCESS: Dev dependencies: $(if ($IncludeDev) { 'Included' } else { 'Skipped' })" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Test your installation: python -c 'import src; print(\"Package imported successfully\")'" -ForegroundColor White
Write-Host "  2. Run tests (if available): python -m pytest" -ForegroundColor White
Write-Host "  3. Start developing in the src/ directory" -ForegroundColor White
Write-Host ""
