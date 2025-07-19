# Project Setup Guide

## Prerequisites (First-time setup)

### 1. Install Poetry (if not already installed)

Poetry is a dependency management tool for Python. Install it once per machine:

**Windows:**
```powershell
# Recommended: Official installer
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

# Alternative: Using pip
pip install poetry
```

**Verify installation:**
```powershell
poetry --version
```

### 2. Install Python 3.8+
Ensure you have Python 3.8 or higher installed on your system.

## Project Setup

### 1. Clone this repository
```powershell
git clone <your-repo-url>
cd <project-name>
```

### 2. Set up the project environment
```powershell
# Install all dependencies from pyproject.toml
.\scripts\update_poetry_from_pyproject.ps1
```

### 3. Activate the virtual environment
```powershell
poetry shell
```

### 4. Verify setup
```powershell
# Check installed packages
poetry show

# Run tests (if any)
poetry run pytest
```

## Daily Development

- **Start development**: `poetry shell` (activate virtual environment)
- **Add dependencies**: `poetry add package-name`
- **Install new dependencies**: `.\scripts\update_poetry_from_pyproject.ps1`
- **Update dependencies**: `.\scripts\update_dependencies_to_latest.ps1`
- **Lock dependencies**: `.\scripts\update_poetry_lock.ps1`

## Troubleshooting

### Poetry not found
- Ensure Poetry is installed: `poetry --version`
- Check PATH environment variable includes Poetry location
- Restart terminal after Poetry installation

### Dependencies not syncing
- Run `.\scripts\update_poetry_from_pyproject.ps1`
- Check if you're in the correct directory (should contain pyproject.toml)
- Ensure virtual environment is activated: `poetry shell`
