# 🔒 **POETRY.LOCK MANUAL - Complete Guide**

## 📋 **Important Note**
**This template's scripts do NOT use poetry.lock**. They use pip-based dependency management. This manual explains poetry.lock for future reference if you decide to switch to Poetry workflow.

---

## **🎯 What is poetry.lock?**

Think of `poetry.lock` as a **"snapshot" of your exact environment**. It's like taking a photo of every single package version that's working perfectly in your project right now.

## **📚 Simple Analogy**

Imagine you're cooking a recipe:
- **`pyproject.toml`** = Recipe ingredients list ("flour", "sugar", "eggs")
- **`poetry.lock`** = Exact brands and quantities ("King Arthur flour 2.5 cups", "Domino sugar 1 cup", "Grade A large eggs 3")

## **🔍 Real Example**

### **In pyproject.toml you write:**
```toml
[project]
dependencies = [
    "requests>=2.25.0",
    "pandas>=1.3.0"
]
```

### **poetry.lock records the EXACT versions installed:**
```toml
[[package]]
name = "requests"
version = "2.32.4"
description = "Python HTTP for Humans."
# Plus 50+ lines of exact dependency details

[[package]]
name = "pandas" 
version = "2.3.1"
description = "Powerful data structures for data analysis"
# Plus exact versions of numpy, pytz, etc.
```

---

## **🤔 Why Does This Matter?**

### **The Problem Without poetry.lock:**
```powershell
# Developer A installs (January 2024)
pip install pandas>=1.3.0
# Gets pandas 1.5.3

# Developer B installs (June 2024)  
pip install pandas>=1.3.0
# Gets pandas 2.1.0 (newer version!)

# 😱 Same project, different versions = different bugs!
```

### **The Solution With poetry.lock:**
```powershell
# Both developers get EXACTLY the same versions
# pandas 2.3.1, numpy 2.3.1, etc.
# 🎉 Guaranteed identical environments!
```

---

## **📋 Current Template vs Poetry Workflow**

### **Your Template Scripts (Current - Pip-based):**
```powershell
# ✅ install_dependencies.ps1 - Uses pip, not Poetry
pip install package-name

# ✅ sync_environment.ps1 - Updates pyproject.toml only  
# Doesn't use poetry.lock

# ✅ change_from_template_to_project.ps1 - File conversion
# Doesn't touch dependencies
```

**Result:** Your scripts get "latest compatible versions" but NOT exact reproducible builds.

### **Poetry Workflow (If You Switch):**
```powershell
# 🔒 Poetry commands use poetry.lock
poetry install    # Installs EXACT versions from poetry.lock
poetry add pkg    # Updates both pyproject.toml AND poetry.lock
poetry update     # Updates poetry.lock with newer versions
```

**Result:** Guaranteed identical environments across all machines.

---

## **🔄 Real-World Scenarios**

### **Scenario 1: Team Development**
```powershell
# Developer adds new dependency
poetry add requests

# poetry.lock automatically updates with EXACT versions
# Other developers run:
poetry install  # Gets identical environment

# 🎉 Everyone has exactly the same setup!
```

### **Scenario 2: Production Deployment**
```powershell
# Deploy server runs:
poetry install --only=main

# Gets EXACT same versions that worked in development
# 🚀 No "works on my machine" problems!
```

### **Scenario 3: Your Template (Current)**
```powershell
# User runs your scripts:
.\scripts\install_dependencies.ps1

# Uses pip, ignores poetry.lock
# Gets "latest compatible versions"
# 📦 Works, but not guaranteed identical environments
```

---

## **🛠️ How to Switch to Poetry Workflow**

### **Prerequisites**
```powershell
# Install Poetry (if not already installed)
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

# Verify installation
poetry --version
```

### **Step 1: Initialize Poetry in Your Project**
```powershell
# Navigate to your project directory
cd your-project

# Poetry will read your existing pyproject.toml
# and create/update poetry.lock
poetry install
```

### **Step 2: Daily Poetry Commands**

#### **Installing Dependencies**
```powershell
# Install all dependencies (uses poetry.lock)
poetry install

# Install only production dependencies
poetry install --only=main

# Install including development dependencies
poetry install --with=dev
```

#### **Adding New Dependencies**
```powershell
# Add production dependency
poetry add requests

# Add development dependency
poetry add --group=dev pytest

# Add with version constraint
poetry add "pandas>=2.0.0"
```

#### **Updating Dependencies**
```powershell
# Update all dependencies to latest compatible versions
poetry update

# Update specific package
poetry update pandas

# Update and regenerate poetry.lock
poetry lock --no-update
```

#### **Managing Virtual Environment**
```powershell
# Activate Poetry virtual environment
poetry shell

# Run commands in Poetry environment
poetry run python src/main.py
poetry run pytest
poetry run black src/
```

### **Step 3: Replace Template Scripts (If Desired)**

Instead of using template scripts, you'd use Poetry commands:

#### **Replace install_dependencies.ps1:**
```powershell
# Old way (template script)
.\scripts\install_dependencies.ps1

# New way (Poetry)
poetry install
```

#### **Replace sync_environment.ps1:**
```powershell
# Old way (template script)  
.\scripts\sync_environment.ps1

# New way (Poetry) - Add packages individually
poetry add package-name
```

---

## **📊 Poetry Commands Reference**

### **Environment Management**
| Command | Purpose |
|---------|---------|
| `poetry install` | Install all dependencies from poetry.lock |
| `poetry install --only=main` | Install only production dependencies |
| `poetry shell` | Activate virtual environment |
| `poetry run <command>` | Run command in Poetry environment |

### **Dependency Management**
| Command | Purpose |
|---------|---------|
| `poetry add <package>` | Add production dependency |
| `poetry add --group=dev <package>` | Add development dependency |
| `poetry remove <package>` | Remove dependency |
| `poetry update` | Update all dependencies |
| `poetry update <package>` | Update specific package |

### **Lock File Management**
| Command | Purpose |
|---------|---------|
| `poetry lock` | Regenerate poetry.lock |
| `poetry lock --no-update` | Update lock without changing versions |
| `poetry show` | List installed packages |
| `poetry show --tree` | Show dependency tree |

### **Export and Integration**
| Command | Purpose |
|---------|---------|
| `poetry export -f requirements.txt --output requirements.txt` | Generate requirements.txt |
| `poetry export --only=main -f requirements.txt --output requirements.txt` | Production requirements only |

---

## **🎯 When to Use Poetry vs Template Scripts**

### **Use Template Scripts (Current) When:**
- ✅ **Simple projects** - Quick setup, don't need exact reproducibility
- ✅ **Learning Python** - Less complexity, easier to understand
- ✅ **CI/CD with pip** - Existing workflows use pip
- ✅ **Corporate environments** - Poetry not available/approved

### **Switch to Poetry When:**
- 🔒 **Team development** - Need identical environments
- 🔒 **Production deployments** - Need reproducible builds
- 🔒 **Complex dependencies** - Managing many packages with conflicts
- 🔒 **Professional projects** - Industry standard practice

---

## **⚠️ Important Notes**

### **poetry.lock File Management:**
- ✅ **Commit to Git** - Include in version control
- ✅ **Don't edit manually** - Let Poetry manage it
- ✅ **Keep updated** - Regular `poetry update` runs

### **Mixed Workflows (Not Recommended):**
```powershell
# ❌ Don't mix pip and Poetry
pip install something          # Updates pip environment
poetry add something-else      # Updates Poetry environment
# Result: Confusion and conflicts!
```

### **Migrating from Template Scripts:**
If you decide to switch to Poetry:

1. **Backup current setup**
2. **Run `poetry install`** to sync with poetry.lock
3. **Test everything works**
4. **Stop using template scripts**
5. **Use Poetry commands going forward**

---

## **🚀 Benefits of poetry.lock**

### **Reproducible Builds**
- ✅ Exact same environment on all machines
- ✅ Deployment matches development exactly
- ✅ No "works on my machine" issues

### **Security**
- ✅ Known working versions
- ✅ Security updates controlled
- ✅ No surprise breaking changes

### **Team Collaboration**
- ✅ Everyone has identical setup
- ✅ Dependency conflicts resolved once
- ✅ Onboarding new developers easier

---

## **📞 Troubleshooting Poetry**

### **Poetry not found**
```powershell
# Install Poetry
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

# Add to PATH if needed
# Check: echo $env:PATH
```

### **Lock file conflicts**
```powershell
# Regenerate lock file
poetry lock --no-update

# Force update if corrupted
rm poetry.lock
poetry install
```

### **Virtual environment issues**
```powershell
# Remove Poetry virtual environment
poetry env remove python

# Recreate environment
poetry install
```

### **Dependency conflicts**
```powershell
# Check dependency tree
poetry show --tree

# Update conflicting packages
poetry update package-name

# Force resolve conflicts
poetry lock --no-update
```

---

## **📋 Summary**

**Current State:**
- ✅ poetry.lock exists in your template
- ✅ Template scripts use pip (ignore poetry.lock)
- ✅ Works perfectly for simple/learning projects

**Future Option:**
- 🔒 Switch to Poetry for professional/team projects
- 🔒 Use poetry.lock for exact reproducible builds
- 🔒 Follow commands in this manual

**Recommendation:** Keep using template scripts unless you specifically need the reproducibility guarantees that Poetry provides! 🚀
