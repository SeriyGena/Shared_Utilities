# What users do per project at the first time

1. **Clone template**
2. **Run** `update_poetry_from_pyproject.ps1`
3. **Start coding!**

---

## 🎯 Summary

### What's included in the template

- `pyproject.toml` with basic dev dependencies
- All Poetry management scripts
- `SETUP.md` with Poetry installation instructions
- Updated scripts `README.md` with prerequisites

### What users need to do once per machine

- **Install Poetry globally:**  
    `pip install poetry` or use the official installer
- **Verify:**  
    `poetry --version`

---

# Poetry Scripts Documentation

This directory contains PowerShell scripts to manage your Poetry-based Python project. All scripts should be run from the project root directory.

## Prerequisites

### Poetry Installation (Required)

Poetry must be installed on your system before using these scripts. Install it once per machine:

**Windows (PowerShell):**
```powershell
# Method 1: Using the official installer (recommended)
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

# Method 2: Using pip (if you prefer)
pip install poetry

# Method 3: Using pipx (isolated installation)
pipx install poetry
```

**Verify installation:**
```powershell
poetry --version
```

**Add Poetry to PATH** (if using official installer):  
Add `%APPDATA%\Python\Scripts` to your system PATH environment variable.

---

## Available Scripts

### 1. `update_poetry_from_pyproject.ps1`
**Purpose:** Install/sync dependencies from pyproject.toml  
**When to use:**
- Setting up the project for the first time
- Syncing your environment after pulling changes
- Ensuring your environment matches project requirements

**Command:**  
`.\scripts\update_poetry_from_pyproject.ps1`

---

### 2. `update_dependencies_to_latest.ps1`
**Purpose:** Update all dependencies to their latest compatible versions  
**When to use:**
- Monthly maintenance to keep dependencies current
- Before major releases for latest security updates
- When you want the newest versions within constraints

**Command:**  
`.\scripts\update_dependencies_to_latest.ps1`  
**Warning:** May introduce breaking changes - test thoroughly after running

---

### 3. `update_poetry_lock.ps1`
**Purpose:** Update poetry.lock file without changing dependency versions  
**When to use:**
- Before committing to ensure reproducible builds
- After manually editing pyproject.toml
- When poetry.lock is out of sync with pyproject.toml
- For deployment preparation

**Command:**  
`.\scripts\update_poetry_lock.ps1`

---

## Initial Project Setup (First Time)

1. **After cloning template:** Run `.\scripts\update_poetry_from_pyproject.ps1` to install dependencies
2. **Add your dependencies:** Use `poetry add package-name` commands
3. **Lock dependencies:** Run `.\scripts\update_poetry_lock.ps1` to create/update lock file

---

## Daily Workflow

1. **Daily development:** Use `update_poetry_from_pyproject.ps1` to keep environment in sync
2. **Monthly updates:** Use `update_dependencies_to_latest.ps1` to get latest versions
3. **Before deployment:** Use `update_poetry_lock.ps1` to ensure lock file is current

---

## Adding New Dependencies

⚠️ **IMPORTANT:** Always use `poetry add` instead of `pip install` in Poetry projects!

### Common Examples
```powershell
# Data science packages
poetry add pandas numpy matplotlib seaborn

# Web development
poetry add requests flask fastapi

# Development tools (use --group dev)
poetry add --group dev pytest black flake8 mypy

# Specific versions
poetry add pandas==1.5.0
poetry add "requests>=2.25.0,<3.0.0"

# Multiple packages at once
poetry add pandas requests matplotlib
```

### Remove dependencies
```powershell
poetry remove package-name
poetry remove --group dev package-name
```

After adding dependencies, run `.\scripts\update_poetry_lock.ps1` to update the lock file.
