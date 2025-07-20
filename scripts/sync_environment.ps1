# Sync current environment packages to pyproject.toml
# Works with both Poetry and pip
# Run from project root: .\scripts\sync_environment.ps1

Write-Host "Syncing environment packages to pyproject.toml..."

# Check if pyproject.toml exists
if (-not (Test-Path "pyproject.toml")) {
    Write-Host "Error: pyproject.toml not found in current directory."
    exit 1
}

# Get current packages
Write-Host "Scanning current environment..."
$installedPackages = python -m pip list --format=freeze | Where-Object { 
    $_ -notmatch "^pip" -and 
    $_ -notmatch "^setuptools" -and 
    $_ -notmatch "^wheel" -and
    $_ -notmatch "^poetry" -and
    $_ -ne ""
}

if (-not $installedPackages) {
    Write-Host "No packages found in environment."
    exit 0
}

Write-Host "Found packages:"
$installedPackages | ForEach-Object { Write-Host "  - $_" }

$confirm = Read-Host "Add these packages to pyproject.toml? (y/n)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Cancelled."
    exit 0
}

# Update pyproject.toml file directly (NO installation)
Write-Host "Updating pyproject.toml file..."

# Read current pyproject.toml with proper encoding
try {
    $content = Get-Content "pyproject.toml" -Raw -Encoding UTF8
} catch {
    Write-Host "Error: Could not read pyproject.toml file."
    exit 1
}

# Filter packages and extract names/versions
$filteredPackages = @()
$developmentPackages = @()

foreach ($package in $installedPackages) {
    $parts = $package -split "=="
    $name = $parts[0].ToLower()
    $version = $parts[1]
    
    # Categorize packages
    if ($name -match "(test|debug|jupyter|ipython|mypy|black|flake8|ruff|pytest)" -or 
        $name -match "(build|setuptools|wheel|poetry|pip)" -or
        $name -match "(dev|lint|format)") {
        # Development/build tools go to dev dependencies
        $developmentPackages += "`"$($parts[0])>=$version`""
    } else {
        # Production packages go to main dependencies
        $filteredPackages += "`"$($parts[0])>=$version`""
    }
}

Write-Host "Categorized packages:"
Write-Host "  Production dependencies: $($filteredPackages.Count)"
Write-Host "  Development dependencies: $($developmentPackages.Count)"

# Update main dependencies
if ($filteredPackages.Count -gt 0) {
    $dependencyString = $filteredPackages -join ",`n    "
    
    if ($content -match '(?s)dependencies\s*=\s*\[(.*?)\]') {
        $newDeps = "dependencies = [`n    $dependencyString`n]"
        $content = $content -replace '(?s)dependencies\s*=\s*\[.*?\]', $newDeps
        Write-Host "  SUCCESS: Updated main dependencies section"
    } else {
        Write-Host "  ERROR: Could not find dependencies section in pyproject.toml"
        exit 1
    }
}

# Update dev dependencies
if ($developmentPackages.Count -gt 0) {
    $devDependencyString = $developmentPackages -join ",`n    "
    
    # Look for existing dev dependencies section
    if ($content -match '(?s)\[project\.optional-dependencies\]\s*dev\s*=\s*\[(.*?)\]') {
        $newDevDeps = "[project.optional-dependencies]`ndev = [`n    $devDependencyString`n]"
        $content = $content -replace '(?s)\[project\.optional-dependencies\]\s*dev\s*=\s*\[.*?\]', $newDevDeps
        Write-Host "  SUCCESS: Updated dev dependencies section"
    } else {
        # Add dev dependencies section if it doesn't exist
        $devSection = "`n`n[project.optional-dependencies]`ndev = [`n    $devDependencyString`n]"
        $content += $devSection
        Write-Host "  SUCCESS: Added dev dependencies section"
    }
}

# Write back to file with proper encoding (no BOM)
try {
    [System.IO.File]::WriteAllText("pyproject.toml", $content, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  SUCCESS: Successfully wrote pyproject.toml"
} catch {
    Write-Host "  ERROR: Error writing pyproject.toml: $_"
    exit 1
}

Write-Host ""
Write-Host "Environment sync completed!" -ForegroundColor Green
Write-Host "pyproject.toml has been updated with current environment packages" -ForegroundColor Yellow
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "   1. Review the updated pyproject.toml file" -ForegroundColor White
Write-Host "   2. Run .\scripts\install_dependencies.ps1 to install in a fresh environment" -ForegroundColor White
Write-Host "   3. Commit the changes to version control" -ForegroundColor White
