# Script to update pyproject.toml with dependencies currently installed in the environment.
# This script scans the current Python environment and adds found packages to pyproject.toml.
# Use this script when:
# - You've installed packages manually and want to add them to pyproject.toml
# - Converting from a pip-based project to Poetry
# - You want to capture the current environment state in pyproject.toml
# WARNING: This will modify your pyproject.toml file
# Run from project root: .\scripts\sync_environment_to_pyproject.ps1

Write-Host "Checking current environment and pyproject.toml..."

# Check if pyproject.toml exists
if (-not (Test-Path "pyproject.toml")) {
    Write-Host "Error: The pyproject.toml file was not found in the current directory."
    exit
}

# Check if Poetry is available
try {
    poetry --version | Out-Null
} catch {
    Write-Host "Error: Poetry was not found. Please install Poetry."
    Write-Host "Installation instructions: https://python-poetry.org/docs/#installation"
    exit
}

$confirm = Read-Host "This will scan your environment and add packages to pyproject.toml. Proceed? (y/n)"

if ($confirm -eq "y" -or $confirm -eq "Y") {
    Write-Host "Scanning current environment..."
    
    # Get list of installed packages (excluding Poetry itself and common system packages)
    $installedPackages = poetry run pip list --format=freeze | Where-Object { 
        $_ -notmatch "^poetry" -and 
        $_ -notmatch "^pip" -and 
        $_ -notmatch "^setuptools" -and 
        $_ -notmatch "^wheel" -and
        $_ -notmatch "^virtualenv" -and
        $_ -ne ""
    }
    
    if ($installedPackages) {
        Write-Host "Found packages in environment:"
        $installedPackages | ForEach-Object { Write-Host "  - $_" }
        
        $addConfirm = Read-Host "Add these packages to pyproject.toml? (y/n)"
        
        if ($addConfirm -eq "y" -or $addConfirm -eq "Y") {
            Write-Host "Adding packages to pyproject.toml..."
            
            foreach ($package in $installedPackages) {
                $packageName = ($package -split "==")[0]
                Write-Host "Adding: $packageName"
                poetry add $packageName
                
                if ($LASTEXITCODE -ne 0) {
                    Write-Host "Warning: Failed to add $packageName"
                }
            }
            
            Write-Host "Environment sync completed!"
            Write-Host "You may want to run .\scripts\update_poetry_lock.ps1 to update the lock file."
        } else {
            Write-Host "Cancelled by user."
        }
    } else {
        Write-Host "No additional packages found in environment (or all packages are already managed by Poetry)."
    }
} else {
    Write-Host "Cancelled by user."
}
