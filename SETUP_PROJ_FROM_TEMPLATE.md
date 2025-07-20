# 🚀 **SETUP PROJECT FROM TEMPLATE - COMPLETE GUIDE**

## 📋 **Quick Start - From Template to Production Ready Project**

This guide shows you how to convert the Python template into your personalized, production-ready development environment. Follow the **4-step process** for a complete setup in under 5 minutes.

---

## **🎯 Template Overview**

### **🔥 What You Get**
- ✅ **Python 3.11+** - Modern Python with latest features
- ✅ **VS Code Workspace** - Complete development environment  
- ✅ **11 Essential Extensions** - Curated, not overwhelming
- ✅ **8 Debug Configurations** - Covers all scenarios
- ✅ **Smart Dependencies** - Professional package management
- ✅ **Automated Conversion** - Template to project in one command

---

## **📋 Prerequisites (One-Time Machine Setup)**

### **1. Install Python 3.11+**
This template requires Python 3.11 or higher for compatibility with modern packages.

**Check your Python version:**
```powershell
python --version  # Should show 3.11 or higher
```

**Download Python 3.11+:**
- Visit: https://www.python.org/downloads/
- Download and install Python 3.11 or newer

### **2. Install VS Code Extensions**
Install the 11 essential extensions for optimal development experience:

```powershell
# Install all extensions from the template
Get-Content .vscode\extensions.json | ConvertFrom-Json | ForEach-Object { $_.recommendations | ForEach-Object { code --install-extension $_ } }

# Or install manually using VS Code Extensions panel
```

**Essential Extensions (11):**
- `ms-python.python` - Core Python support
- `ms-python.black-formatter` - Code formatting  
- `ms-python.flake8` - Code linting
- `ms-python.mypy-type-checker` - Type checking
- `ms-toolsai.jupyter` - Notebook support
- `ms-vscode.powershell` - PowerShell scripts
- `GitHub.copilot` - AI assistance
- `ms-vscode.vscode-json` - JSON support
- `redhat.vscode-yaml` - YAML support
- `mhutchie.git-graph` - Git visualization
- `yzhang.markdown-all-in-one` - Documentation

### **3. Install Poetry (Optional - for advanced dependency management)**
Poetry provides professional dependency management:

```powershell
# Recommended: Official installer
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

# Alternative: Using pip
pip install poetry

# Verify installation
poetry --version
```

---

## **🚀 4-Step Project Setup**

### **Step 1: Clone Template** 📁
```powershell
git clone <template-repository-url> my-new-project
cd my-new-project
```

> **📚 Detailed Instructions**: For comprehensive script documentation and troubleshooting, see `scripts\README.md` in your cloned project. It contains detailed explanations of each script, parameters, and advanced usage scenarios.

### **Step 2: Convert Template to Project** ⚙️
```powershell
.\scripts\change_from_template_to_project.ps1 -ProjectName "my_project_name"
```

**What this does:**
- ✅ Replaces all `TEMPLATE_PROJECT` placeholders with your project name
- ✅ Updates `template_project` with snake_case version  
- ✅ Converts author placeholders (`"Your Name"`, email)
- ✅ Creates VS Code workspace file
- ✅ Personalizes all template files

### **Step 3: Install Default Dependencies** 📦
```powershell
.\scripts\install_dependencies.ps1
```

> **📝 Note about poetry.lock**: This template includes a `poetry.lock` file, but **none of the template scripts use it**. The scripts use pip-based dependency management for simplicity. If you want to learn about Poetry workflow and exact reproducible builds, see `MANUAL_poetry.lock_README.md` for complete instructions on when and how to use Poetry instead of the template scripts.

**What gets installed from pyproject.toml:**

#### **Core Production Dependencies:**
- `numpy>=2.3.1` - Numerical computing
- `pandas>=2.3.1` - Data manipulation and analysis
- `requests>=2.32.4` - HTTP requests
- `click>=8.2.1` - Command-line interface creation
- `python-dotenv>=1.1.1` - Environment variable management
- `colorama>=0.4.6` - Cross-platform colored terminal output
- `matplotlib-inline>=0.1.7` - Inline plotting support
- Plus 60+ supporting packages for robust ecosystem

#### **Development Tools (dev dependencies):**
- `black>=25.1.0` - Code formatting (matches VS Code extension)
- `flake8>=7.3.0` - Code linting (matches VS Code extension)  
- `mypy>=1.17.0` - Type checking (matches VS Code extension)
- `pytest>=8.4.1` - Testing framework
- `ruff>=0.12.4` - Fast Python linter
- `debugpy>=1.8.15` - Python debugger
- `ipython>=9.4.0` - Enhanced interactive Python
- Jupyter suite for notebook development

### **Step 4: Check Environment Sync** 🔍
```powershell
.\scripts\sync_environment.ps1
```

**What this does:**
- ✅ Analyzes your current environment
- ✅ Compares with pyproject.toml dependencies
- ✅ **Interactive**: Prompts to add any missing packages
- ✅ Updates pyproject.toml if you have additional packages
- ✅ Ensures complete dependency tracking

### **Step 5: Install Any New Dependencies** 🔄
```powershell
.\scripts\install_dependencies.ps1
```

**Final step if Step 4 added packages:**
- ✅ Installs any newly added dependencies
- ✅ Ensures environment matches updated pyproject.toml
- ✅ Complete development environment ready!

---

## **🎯 Complete Setup Workflow**

```powershell
# Complete setup in one block
git clone <template-repo> my-project
cd my-project

# 1. Convert template to your project
.\scripts\change_from_template_to_project.ps1 -ProjectName "my_awesome_project"

# 2. Install default dependencies (60+ packages)
.\scripts\install_dependencies.ps1

# 3. Check for additional packages
.\scripts\sync_environment.ps1

# 4. Install any new dependencies (if Step 3 added packages)  
.\scripts\install_dependencies.ps1

# 5. Open in VS Code and start coding!
code .
```

**🎉 Result: Professional Python development environment ready in under 5 minutes!**

---

## **🔌 VS Code Integration**

### **Debug Configurations (8 Ready-to-Use)**
Press **F5** to debug immediately with these configurations:

1. **Python: Current File** - Debug the file you're editing
2. **Python: Main Module** - Debug src.main module
3. **Python: Module (src)** - Debug entire src package
4. **Python: Run Tests** - Debug all tests
5. **Python: Run Single Test** - Debug current test file
6. **Python: Debug with Arguments** - Debug with command-line args
7. **Python: FastAPI** - Debug FastAPI applications
8. **Python: Django** - Debug Django applications

### **Workspace Settings (Production Ready)**
- **Theme**: Atom One Dark + Material Icon Theme
- **Auto-save**: Enabled with 1-second delay
- **Python**: Configured for Black formatting, Flake8 linting, pytest testing
- **File exclusions**: Hide cache files and build artifacts
- **Encoding**: UTF-8 for cross-platform compatibility

---

## **📦 Dependency Management**

### **Extension ↔ pyproject.toml Perfect Alignment**
| VS Code Extension | pyproject.toml Package | Purpose |
|-------------------|------------------------|---------|
| `ms-python.black-formatter` | `black>=25.1.0` | Code formatting |
| `ms-python.flake8` | `flake8>=7.3.0` | Code linting |
| `ms-python.mypy-type-checker` | `mypy>=1.17.0` | Type checking |
| `ms-toolsai.jupyter` | Jupyter suite | Interactive development |
| `ms-python.python` | Core Python ecosystem | Language support |

### **Smart Scripts Features**
- ✅ **Dependency analysis** before installation
- ✅ **Progress indicators** for user feedback
- ✅ **Error handling** with clear messages
- ✅ **Cross-platform** PowerShell compatibility
- ✅ **Separation of concerns** (sync vs install)

---

## **📁 Final Project Structure**

```
🌟 YOUR_PROJECT/
├── src/
│   ├── __init__.py              # Your project package
│   └── main.py                  # Your main entry point
├── test/
│   ├── __init__.py              # Test package
│   ├── test_your_project.py     # Your project tests
│   └── README.md                # Testing documentation
├── scripts/
│   ├── change_from_template_to_project.ps1  # Conversion (used once)
│   ├── install_dependencies.ps1             # Dependency installer
│   └── sync_environment.ps1                 # Environment checker
├── .vscode/
│   ├── extensions.json          # 11 essential extensions
│   ├── launch.json              # 8 debug configurations
│   └── settings.json            # Production settings
├── your_project.code-workspace  # VS Code workspace
├── pyproject.toml               # Your project configuration
├── README.md                    # Your project documentation
├── .gitignore                   # Python gitignore
└── LICENSE                      # MIT License
```

---

## **🔄 Daily Development Workflow**

### **Adding New Dependencies**
```powershell
# Method 1: Using pip + sync
pip install new-package
.\scripts\sync_environment.ps1  # Add to pyproject.toml

# Method 2: Using Poetry (if installed)
poetry add new-package
```

### **Environment Maintenance**
```powershell
# Ensure environment matches pyproject.toml
.\scripts\install_dependencies.ps1

# Check for missing packages
.\scripts\sync_environment.ps1

# Keep VS Code extensions updated
code --list-extensions --show-versions
```

### **Testing & Quality**
```powershell
# Run tests (pytest configured)
python -m pytest

# Format code (Black configured)
python -m black src/ test/

# Lint code (Flake8 configured)
python -m flake8 src/ test/

# Type check (MyPy configured)  
python -m mypy src/
```

---

## **🚨 Troubleshooting**

### **Poetry not found**
```powershell
# Install Poetry
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -

# Verify installation
poetry --version
```

### **PowerShell execution policy**
```powershell
# Allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### **Python version issues**
```powershell
# Check Python version (must be 3.11+)
python --version

# Install Python 3.11+ if needed
# Download from: https://www.python.org/downloads/
```

### **VS Code extensions not working**
```powershell
# Reload VS Code window
# Ctrl+Shift+P -> "Developer: Reload Window"

# Check extension installation
code --list-extensions
```

### **Dependencies not installing**
```powershell
# Check if you're in correct directory
Get-Location  # Should contain pyproject.toml

# Try manual pip install
pip install -r requirements.txt

# Check Python executable
python -c "import sys; print(sys.executable)"
```

---

## **✨ Template Benefits**

### **🔧 Production Ready**
- ✅ **Battle-tested configuration** - real developer preferences
- ✅ **Professional tools** - Black, Flake8, MyPy, pytest
- ✅ **Complete ecosystem** - 60+ pre-configured packages
- ✅ **VS Code optimized** - 11 essential extensions, 8 debug configs

### **⚡ Immediate Productivity**
- ✅ **One-command conversion** - template to project instantly
- ✅ **Smart dependency management** - intelligent package handling
- ✅ **F5 debugging** - works immediately
- ✅ **Auto-formatting** on save
- ✅ **AI assistance** with GitHub Copilot

### **🎯 Developer Experience**
- ✅ **Professional appearance** - Atom One Dark theme
- ✅ **Comprehensive testing** - pytest with examples
- ✅ **Documentation ready** - Markdown support
- ✅ **Git integrated** - visualization and workflows
- ✅ **Cross-platform** - Windows, macOS, Linux compatible

---

## **🚀 Success! You Now Have:**

✅ **Complete Python development environment**  
✅ **Professional code formatting, linting, and type checking**  
✅ **Ready-to-use testing framework**  
✅ **AI-powered coding assistance**  
✅ **Comprehensive debugging configurations**  
✅ **Smart dependency management**  
✅ **Production-ready project structure**  

**Start coding immediately - your professional Python development environment is ready!** 🎉

---

## **📞 Need Help?**

- **Template Issues**: Check scripts/README.md for detailed script documentation
- **VS Code Problems**: Ensure all 11 extensions are installed
- **Python Issues**: Verify Python 3.11+ installation
- **Dependencies**: Run sync_environment.ps1 to check alignment

**Happy coding with your new professional Python development environment!** 🐍✨
