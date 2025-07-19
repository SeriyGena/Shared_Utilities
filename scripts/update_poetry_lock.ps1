# Script to update the poetry.lock file to reflect current dependency versions.
# This script regenerates the lock file without changing dependency versions in pyproject.toml.
# Use this script when:
# - You want to lock current dependency versions for deployment
# - Before committing changes to ensure reproducible builds
# - After manually editing pyproject.toml to update the lock file
# - When poetry.lock is out of sync with pyproject.toml
# Run from project root: .\scripts\update_poetry_lock.ps1

Write-Host "Checking for pyproject.toml..."

if (-not (Test-Path "pyproject.toml")) {
    Write-Host "Error: The pyproject.toml file was not found in the current directory."
    exit
}

$confirm = Read-Host "This will update the poetry.lock file. Proceed? (y/n)"

if ($confirm -eq "y" -or $confirm -eq "Y") {
    Write-Host "Updating poetry.lock file..."
    
    # 'poetry lock' command updates the lock file with exact versions
    poetry lock
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "poetry.lock file updated successfully."
    } else {
        Write-Host "Error occurred while running 'poetry lock'. Please check the output."
    }
} else {
    Write-Host "Update cancelled."
}