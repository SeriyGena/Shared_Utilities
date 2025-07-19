# Script to install/sync dependencies from pyproject.toml using Poetry.
# This script installs all dependencies defined in pyproject.toml and syncs your environment.
# Use this script when:
# - Setting up the project for the first time
# - Syncing your environment with pyproject.toml after pulling changes
# - Ensuring your environment matches the project requirements
# Run from project root: .\scripts\update_poetry_from_pyproject.ps1

Write-Host "Checking for pyproject.toml..."

if (-not (Test-Path "pyproject.toml")) {
    Write-Host "Error: The pyproject.toml file was not found in the current directory."
    exit
}

Write-Host "Starting dependency installation/update with Poetry..."
try {
    # Check if Poetry is available
    poetry --version | Out-Null
    
    # Use 'poetry install' to install dependencies and 'poetry update' to update them
    poetry install --sync
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Poetry install/update completed successfully."
    } else {
        Write-Host "An error occurred. Please check the output."
    }
} catch {
    Write-Host "Error: The 'poetry' command was not found. Is Poetry installed?"
    Write-Host "Visit https://python-poetry.org/docs/#installation for help."
}