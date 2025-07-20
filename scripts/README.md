# 🚀 Template Setup Scripts

## 📋 **Quick Start - Template to Project Conversion**

After cloning this template, follow these **4 simple steps** to convert it to your project:

### **Step 1: Convert Template to Project** ⚙️
```powershell
.\scripts\change_from_template_to_project.ps1 -ProjectName "your_project_name"
```
- **Purpose**: Converts template placeholders to your project name
- **What it does**: Updates all files with your project-specific information
- **Required**: Must be run first before any other setup

### **Step 2: Install Default Dependencies** 📦
```powershell
.\scripts\install_dependencies.ps1
```
- **Purpose**: Installs all dependencies from pyproject.toml
- **What it does**: Sets up the complete development environment
- **Includes**: Core packages + development tools (black, flake8, mypy, pytest)

### **Step 3: Check Environment Sync** 🔍
```powershell
.\scripts\sync_environment.ps1
```
- **Purpose**: Compares your environment with pyproject.toml
- **What it does**: Identifies any additional packages that should be added
- **Interactive**: Prompts to add missing packages to pyproject.toml

### **Step 4: Install Any New Dependencies** 🔄
```powershell
.\scripts\install_dependencies.ps1
```
- **Purpose**: Installs any newly added dependencies
- **What it does**: Ensures your environment matches the updated pyproject.toml
- **Complete**: Your project is now ready for development!

---

## 🎯 **Complete Workflow Summary**

```powershell
# 1. Clone the template
git clone <template-repo> my-new-project
cd my-new-project

# 2. Convert to your project
.\scripts\change_from_template_to_project.ps1 -ProjectName "my_project"

# 3. Install default dependencies  
.\scripts\install_dependencies.ps1

# 4. Check for additional dependencies
.\scripts\sync_environment.ps1

# 5. Install any new dependencies (if Step 4 added packages)
.\scripts\install_dependencies.ps1

# 6. Start coding!
code .
```

**🎉 You now have a fully configured Python development environment!**

---

## 📚 **Script Documentation**

This directory contains PowerShell scripts for managing your Python project. All scripts should be run from the project root directory.

**Python Requirements: 3.11+** - This template is optimized for Python 3.11 and above.

## Prerequisites

### Python 3.11+ Installation (Required)
```powershell
python --version  # Should show 3.11 or higher
```

### Poetry Installation (Required)
Install Poetry once per machine:

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

---

## 🔧 **Available Scripts**

### 1. `change_from_template_to_project.ps1` 🎯
**Purpose:** Convert template placeholders to your project  
**When to use:**
- **FIRST STEP** after cloning the template
- One-time conversion from template to personalized project

**Command:**  
```powershell
.\scripts\change_from_template_to_project.ps1 -ProjectName "your_project"
```

**What it does:**
- Replaces `TEMPLATE_PROJECT` with your project name
- Updates `template_project` with snake_case version
- Converts `"Your Name"` and email placeholders
- Creates VS Code workspace file

---

### 2. `install_dependencies.ps1` 📦
**Purpose:** Install dependencies from pyproject.toml  
**When to use:**
- After template conversion (Step 2)
- After sync_environment adds new packages (Step 4)
- Setting up development environment
- After pulling changes with new dependencies

**Command:**  
```powershell
.\scripts\install_dependencies.ps1
```

**Features:**
- Smart dependency analysis before installation
- Supports both Poetry and pip workflows
- Shows what will be installed before proceeding
- Handles dev dependencies separately

---

### 3. `sync_environment.ps1` 🔍
**Purpose:** Compare environment with pyproject.toml and add missing packages  
**When to use:**
- After installing template dependencies (Step 3)
- When you've manually installed packages
- Converting from pip-based project
- Periodic environment auditing

**Command:**  
```powershell
.\scripts\sync_environment.ps1
```

**What it does:**
- Analyzes currently installed packages
- Compares with pyproject.toml dependencies
- **Interactive**: Prompts to add missing packages
- Updates pyproject.toml with new dependencies
- **Note**: Only updates file, doesn't install packages

---

## 🔄 **Daily Development Workflow**

### Adding New Dependencies
```powershell
# Method 1: Using Poetry (recommended)
poetry add package-name

# Method 2: Manual install + sync
pip install package-name
.\scripts\sync_environment.ps1  # Add to pyproject.toml
```

### Updating Dependencies
```powershell
# Update specific package
poetry add package-name@latest

# Update all packages (use with caution)
poetry update
```

### Environment Maintenance
```powershell
# Ensure environment matches pyproject.toml
.\scripts\install_dependencies.ps1

# Check for missing packages
.\scripts\sync_environment.ps1
```

---

## 🚨 **Important Notes**

### **Script Execution Order Matters**
1. **First**: `change_from_template_to_project.ps1` (one-time only)
2. **Then**: `install_dependencies.ps1` 
3. **Check**: `sync_environment.ps1`
4. **Finally**: `install_dependencies.ps1` (if Step 3 added packages)

### **Separation of Concerns**
- **`sync_environment.ps1`**: Only updates pyproject.toml file
- **`install_dependencies.ps1`**: Only installs packages
- **Clean workflow**: Update file first, then install

### **Cross-Platform Compatibility**
- Scripts use ASCII-only output for PowerShell compatibility
- UTF-8 encoding without BOM for Poetry compatibility
- Proper error handling and validation

---

## 🔧 **Troubleshooting**

### Poetry not found
```powershell
# Check if Poetry is installed
poetry --version

# If not found, install Poetry
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
```

### Permission errors
```powershell
# Run PowerShell as Administrator
# Or set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Python version issues
```powershell
# Check Python version (must be 3.11+)
python --version

# Use specific Python version
poetry env use python3.11
```

---

## 📝 **Template Benefits**

✅ **One-command setup** - Automated template conversion  
✅ **Smart dependency management** - Intelligent package handling  
✅ **Professional configuration** - VS Code workspace included  
✅ **Cross-platform compatible** - Works on Windows, macOS, Linux  
✅ **Development ready** - Testing, linting, formatting pre-configured  

**Result: Professional Python development environment in under 5 minutes!** 🚀

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
