# Template Conversion Script
# ========================
# Run this ONCE after cloning the template from GitHub
# This script converts template files to project files and configures your workspace
# 
# Usage: .\scripts\change_from_template_to_project.ps1 -ProjectName "project_name"
#.\scripts\change_from_template_to_project.ps1 -ProjectName "SHARED_UTILITIES"
#
# Requirements:
# - Run from project root directory
# - PowerShell 5.1+ or PowerShell Core
# - Template files (*_minimal) must exist

param(
    [Parameter(Mandatory=$true, HelpMessage="Project name (letters, numbers, underscore, hyphen only)")]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$false, HelpMessage="Author full name")]
    [string]$AuthorName = "Your Name",
    
    [Parameter(Mandatory=$false, HelpMessage="Author email address")]
    [string]$AuthorEmail = "your.email@example.com",
    
    [Parameter(Mandatory=$false, HelpMessage="Project description")]
    [string]$Description = ""
)

# Display banner
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Python Project Template Converter v1.0" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Converting template to project: $ProjectName" -ForegroundColor Green
Write-Host "Author: $AuthorName <$AuthorEmail>" -ForegroundColor Yellow
if ($Description) {
    Write-Host "Description: $Description" -ForegroundColor Yellow
}
Write-Host ""

# Validate project name
if ($ProjectName -notmatch '^[a-zA-Z][a-zA-Z0-9_-]*$') {
    Write-Host "ERROR: Project name must:" -ForegroundColor Red
    Write-Host "  - Start with a letter" -ForegroundColor Red
    Write-Host "  - Contain only letters, numbers, underscore, or hyphen" -ForegroundColor Red
    Write-Host "  - Example: MyProject, my_project, project-1" -ForegroundColor Red
    exit 1
}

# Validate we're in the right directory
if (-not (Test-Path "pyproject.toml") -or -not (Test-Path "scripts")) {
    Write-Host "ERROR: Please run this script from the project root directory." -ForegroundColor Red
    Write-Host "Expected files: pyproject.toml, scripts/" -ForegroundColor Red
    exit 1
}

# Check for available template files (flexible - skip missing files)
$possibleMinimalFiles = @(
    "pyproject_minimal.toml",
    "README_TEMPLATE.md", 
    ".gitignore_minimal",
    ".vscode_minimal\extensions.json",
    ".vscode_minimal\launch.json", 
    ".vscode_minimal\settings.json",
    ".copilot_minimal\prompts.md",
    "scripts\install_dependencies_minimal.ps1",
    "scripts\sync_environment_minimal.ps1"
)

Write-Host "Checking for template files..." -ForegroundColor Cyan
$foundFiles = @()
$missingFiles = @()

foreach ($file in $possibleMinimalFiles) {
    if (Test-Path $file) {
        $foundFiles += $file
        Write-Host "  SUCCESS: Found $file" -ForegroundColor Green
    } else {
        $missingFiles += $file
        Write-Host "  NOTE: Skipping missing file: $file" -ForegroundColor Yellow
    }
}

if ($foundFiles.Count -eq 0) {
    Write-Host ""
    Write-Host "ERROR: No template files found to convert." -ForegroundColor Red
    Write-Host "Expected at least some of these files in the current directory:" -ForegroundColor Red
    $possibleMinimalFiles | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "  SUCCESS: Found $($foundFiles.Count) template files to convert!" -ForegroundColor Green
if ($missingFiles.Count -gt 0) {
    Write-Host "  NOTE: Skipped $($missingFiles.Count) missing files" -ForegroundColor Yellow
}
Write-Host ""

# Create workspace folder name
$workspaceFolder = "${ProjectName}.code-workspace"

# Dynamic file conversion mapping based on found files
$fileConversions = @{}

# Add conversions for files that exist
if (Test-Path "pyproject_minimal.toml") { $fileConversions["pyproject_minimal.toml"] = "pyproject.toml" }
if (Test-Path "README_TEMPLATE.md") { $fileConversions["README_TEMPLATE.md"] = "README.md" }
if (Test-Path ".gitignore_minimal") { $fileConversions[".gitignore_minimal"] = ".gitignore" }
if (Test-Path ".vscode_minimal") { $fileConversions[".vscode_minimal"] = ".vscode" }
if (Test-Path ".copilot_minimal") { $fileConversions[".copilot_minimal"] = ".copilot" }

# Handle script files in scripts directory
if (Test-Path "scripts\install_dependencies_minimal.ps1") { 
    $fileConversions["scripts\install_dependencies_minimal.ps1"] = "scripts\install_dependencies.ps1" 
}
if (Test-Path "scripts\sync_environment_minimal.ps1") { 
    $fileConversions["scripts\sync_environment_minimal.ps1"] = "scripts\sync_environment.ps1" 
}

Write-Host "Converting template files..." -ForegroundColor Cyan

# Convert each file/directory that exists
foreach ($source in $fileConversions.Keys) {
    $target = $fileConversions[$source]
    
    try {
        if (Test-Path $source -PathType Container) {
            # Directory conversion
            Write-Host "  Converting directory: $source -> $target" -ForegroundColor Yellow
            
            # Create target directory if it doesn't exist
            if (-not (Test-Path $target)) {
                New-Item -ItemType Directory -Path $target -Force | Out-Null
            }
            
            # Copy all files from source to target
            $files = Get-ChildItem -Path $source -Recurse -File
            foreach ($file in $files) {
                $relativePath = $file.FullName.Substring((Get-Item $source).FullName.Length + 1)
                $targetFile = Join-Path $target $relativePath
                
                # Create target subdirectory if needed
                $targetDir = Split-Path $targetFile -Parent
                if ($targetDir -and -not (Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                }
                
                Copy-Item -Path $file.FullName -Destination $targetFile -Force
                Write-Host "    Copied: $relativePath" -ForegroundColor Gray
            }
            
        } else {
            # File conversion (including files that need directory creation)
            Write-Host "  Converting file: $source -> $target" -ForegroundColor Yellow
            
            # Create target directory if needed
            $targetDir = Split-Path $target -Parent
            if ($targetDir -and -not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                Write-Host "    Created directory: $targetDir" -ForegroundColor Gray
            }
            
            # For files in same directory (like scripts to scripts), just copy
            Copy-Item -Path $source -Destination $target -Force
        }
        
        Write-Host "    SUCCESS: $target created" -ForegroundColor Green
        
    } catch {
        Write-Host "    ERROR: Failed to convert $source -> $target" -ForegroundColor Red
        Write-Host "    Details: $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Updating project metadata..." -ForegroundColor Cyan

# Update pyproject.toml with project details (if it exists)
if (Test-Path "pyproject.toml") {
    try {
        $pyprojectContent = Get-Content "pyproject.toml" -Raw -Encoding UTF8
        
        # Replace placeholders
        $pyprojectContent = $pyprojectContent -replace 'name = "template_project"', "name = `"$ProjectName`""
        $pyprojectContent = $pyprojectContent -replace 'description = "Minimal Python project template"', "description = `"$Description`""
        $pyprojectContent = $pyprojectContent -replace 'authors = \[.*?\]', "authors = [`"$AuthorName <$AuthorEmail>`"]"
        $pyprojectContent = $pyprojectContent -replace 'TEMPLATE_PROJECT', $ProjectName.ToUpper()
        
        # Write back with proper encoding
        [System.IO.File]::WriteAllText("pyproject.toml", $pyprojectContent, [System.Text.UTF8Encoding]::new($false))
        Write-Host "  SUCCESS: Updated pyproject.toml" -ForegroundColor Green
    } catch {
        Write-Host "  ERROR: Failed to update pyproject.toml: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  NOTE: pyproject.toml not found, skipping metadata update" -ForegroundColor Yellow
}

# Update README.md with project details (if it exists)
if (Test-Path "README.md") {
    try {
        $readmeContent = Get-Content "README.md" -Raw -Encoding UTF8
        
        # Replace placeholders
        $readmeContent = $readmeContent -replace '# Template Project', "# $ProjectName"
        $readmeContent = $readmeContent -replace 'Template description goes here', $Description
        $readmeContent = $readmeContent -replace 'TEMPLATE_PROJECT', $ProjectName.ToUpper()
        $readmeContent = $readmeContent -replace 'template_project', $ProjectName.ToLower()
        
        # Write back with proper encoding
        [System.IO.File]::WriteAllText("README.md", $readmeContent, [System.Text.UTF8Encoding]::new($false))
        Write-Host "  SUCCESS: Updated README.md" -ForegroundColor Green
    } catch {
        Write-Host "  ERROR: Failed to update README.md: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  NOTE: README.md not found, skipping content update" -ForegroundColor Yellow
}

# Update src/__init__.py with project details (if it exists)
if (Test-Path "src\__init__.py") {
    try {
        $initContent = Get-Content "src\__init__.py" -Raw -Encoding UTF8
        
        # Replace placeholders
        $initContent = $initContent -replace 'TEMPLATE_PROJECT', $ProjectName.ToUpper()
        $initContent = $initContent -replace 'template_project', $ProjectName.ToLower()
        $initContent = $initContent -replace '"Your Name"', "`"$AuthorName`""
        $initContent = $initContent -replace '"your\.email@example\.com"', "`"$AuthorEmail`""
        $initContent = $initContent -replace 'A template description goes here', $Description
        
        # Write back with proper encoding
        [System.IO.File]::WriteAllText("src\__init__.py", $initContent, [System.Text.UTF8Encoding]::new($false))
        Write-Host "  SUCCESS: Updated src/__init__.py" -ForegroundColor Green
    } catch {
        Write-Host "  ERROR: Failed to update src/__init__.py: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  NOTE: src/__init__.py not found, skipping metadata update" -ForegroundColor Yellow
}

# Update src/main.py with project details (if it exists)
if (Test-Path "src\main.py") {
    try {
        $mainContent = Get-Content "src\main.py" -Raw -Encoding UTF8
        
        # Replace placeholders
        $mainContent = $mainContent -replace 'TEMPLATE_PROJECT', $ProjectName.ToUpper()
        $mainContent = $mainContent -replace 'template_project', $ProjectName.ToLower()
        
        # Write back with proper encoding
        [System.IO.File]::WriteAllText("src\main.py", $mainContent, [System.Text.UTF8Encoding]::new($false))
        Write-Host "  SUCCESS: Updated src/main.py" -ForegroundColor Green
    } catch {
        Write-Host "  ERROR: Failed to update src/main.py: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  NOTE: src/main.py not found, skipping content update" -ForegroundColor Yellow
}

# Create VS Code workspace file
try {
    $workspaceConfig = @{
        folders = @(
            @{ path = "." }
        )
        settings = @{
            "python.defaultInterpreterPath" = "python"
            "python.linting.enabled" = $true
            "python.linting.flake8Enabled" = $true
            "python.formatting.provider" = "black"
            "files.exclude" = @{
                "**/__pycache__" = $true
                "**/*.pyc" = $true
                "**/node_modules" = $true
                "**/.git" = $true
                "**/.DS_Store" = $true
            }
        }
        extensions = @{
            recommendations = @(
                "ms-python.python",
                "ms-python.black-formatter",
                "ms-python.flake8",
                "github.copilot",
                "github.copilot-chat"
            )
        }
    }
    
    $workspaceJson = $workspaceConfig | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText($workspaceFolder, $workspaceJson, [System.Text.UTF8Encoding]::new($false))
    Write-Host "  SUCCESS: Created workspace file: $workspaceFolder" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Failed to create workspace file: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Project initialization summary:" -ForegroundColor Cyan

# List what was created/found
$expectedFiles = @("pyproject.toml", "README.md", ".gitignore", ".vscode/", ".copilot/", "scripts/", $workspaceFolder)
$createdCount = 0
$skippedCount = 0

foreach ($file in $expectedFiles) {
    if (Test-Path $file) {
        Write-Host "  SUCCESS: $file" -ForegroundColor Green
        $createdCount++
    } else {
        Write-Host "  NOTE: $file (not created - source file missing)" -ForegroundColor Yellow
        $skippedCount++
    }
}

Write-Host ""
Write-Host "Conversion summary:" -ForegroundColor Cyan
Write-Host "  Created/Updated: $createdCount files" -ForegroundColor Green
Write-Host "  Skipped: $skippedCount files" -ForegroundColor Yellow

Write-Host ""
Write-Host "Cleanup options:" -ForegroundColor Yellow
Write-Host "The template files (*_minimal) are no longer needed." -ForegroundColor Gray
$cleanup = Read-Host "Remove template files? (y/n)"

if ($cleanup -eq "y" -or $cleanup -eq "Y") {
    Write-Host ""
    Write-Host "Removing template files..." -ForegroundColor Cyan
    
    # Clean up the files that were actually converted
    foreach ($source in $fileConversions.Keys) {
        try {
            if (Test-Path $source) {
                Remove-Item -Path $source -Recurse -Force
                Write-Host "  Removed: $source" -ForegroundColor Gray
            }
        } catch {
            Write-Host "  ERROR: Could not remove $source - $_" -ForegroundColor Red
        }
    }
    
    Write-Host "  SUCCESS: Template cleanup completed" -ForegroundColor Green
} else {
    Write-Host "  Template files preserved (you can delete them manually later)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  CONVERSION COMPLETED!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Project: $ProjectName" -ForegroundColor Yellow
Write-Host "Status: Ready for development" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open workspace: code $workspaceFolder" -ForegroundColor White
Write-Host "  2. Install dependencies: .\scripts\install_dependencies.ps1" -ForegroundColor White
Write-Host "  3. Initialize git repository: git init" -ForegroundColor White
Write-Host "  4. Start coding in src/ directory" -ForegroundColor White
Write-Host ""
Write-Host "Development commands:" -ForegroundColor Cyan
Write-Host "  Install deps:     .\scripts\install_dependencies.ps1" -ForegroundColor White
Write-Host "  Install dev deps: .\scripts\install_dependencies.ps1 -IncludeDev" -ForegroundColor White
Write-Host "  Sync environment: .\scripts\sync_environment.ps1" -ForegroundColor White
Write-Host ""
Write-Host "Happy coding!" -ForegroundColor Green
