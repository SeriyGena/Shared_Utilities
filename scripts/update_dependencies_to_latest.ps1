# Script to update all dependencies to their latest compatible versions.
# This script updates dependencies within the version constraints defined in pyproject.toml.
# Use this script when:
# - You want to get the latest versions of all dependencies
# - Monthly maintenance to keep dependencies current
# - Before major releases to ensure you have latest security updates
# WARNING: This may introduce breaking changes - test thoroughly after running
# Run from project root: .\scripts\update_dependencies_to_latest.ps1

# Prompt the user for confirmation before proceeding.
$confirm = Read-Host "Update dependencies in pyproject.toml? (y/n)"

if ($confirm -eq "y" -or $confirm -eq "Y") {
    # Check if pyproject.toml exists in the current directory.
    if (Test-Path "pyproject.toml") {
        Write-Host "Checking for Poetry..."
        # Check if Poetry is installed and available in the path.
        try {
            poetry --version | Out-Null
            Write-Host "Starting dependency update..."
            poetry update
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Update completed successfully."
            } else {
                Write-Host "An error occurred during the update. Please check the output."
            }
        } catch {
            Write-Host "Error: Poetry was not found. Please install Poetry."
            Write-Host "Installation instructions: https://python-poetry.org/docs/#installation"
        }
    } else {
        Write-Host "Error: The pyproject.toml file was not found in the current directory."
    }
} else {
    Write-Host "Update cancelled by user."
}