# GitHub Copilot Prompts and Best Practices

## Context-Setting Prompts

### Project Context
```
This is a Python 3.11+ project with dependency management via pyproject.toml. The project follows PEP 621 standards and uses setuptools as build backend. Key tools: pytest for testing, black for formatting, flake8 for linting, mypy for type checking.
```

### Architecture Context
```
Project structure: src/ contains main code, test/ contains tests, scripts/ contains PowerShell automation. Uses f_ prefix for functions, g_ for globals, snake_case naming. All functions need docstrings and type hints.
```

## Code Generation Prompts

### Function Creation
```
Create a Python function that [specific task]. Requirements:
- Use f_ prefix for function name
- Include complete docstring with Args, Returns, Raises
- Add type hints for all parameters and return type
- Use snake_case for variable names
- Add input validation at function boundary
- Handle exceptions gracefully with logging
- Add GHCL comment
```

### Class Creation
```
Create a Python class that [specific functionality]. Requirements:
- Use proper docstring with class purpose
- Use 'self' for instance methods, 'cls' for class methods
- Add type hints for all methods
- Include __init__ with proper parameter validation
- Add GHCL comments for generated methods
```

## Testing Prompts

### Unit Test Creation
```
Create pytest unit tests for [function/class name]. Requirements:
- Test file should be in test/ directory
- Cover happy path, edge cases, and error conditions
- Use descriptive test function names with test_ prefix
- Include docstrings for complex test scenarios
- Mock external dependencies appropriately
- Add GHCL comments
```

## Best Practices for Copilot Interaction

### Effective Prompt Structure
1. **Start with context** - Describe the project and current situation
2. **Be specific** - Clearly state what you want to achieve
3. **Include constraints** - Mention requirements and limitations
4. **Reference existing patterns** - Point to similar code in the project
5. **Specify output format** - Define exactly what you want returned

### Context Sharing Tips
- Reference existing files and their patterns
- Mention coding standards from instructions.md
- Include relevant error messages or logs
- Specify the target audience (developers, end-users, etc.)
- Mention performance or security requirements

## Project-Specific Patterns

### Dependency Management
```
When working with dependencies:
- Always update pyproject.toml following PEP 621 format
- Use version ranges (>=X.Y) rather than exact versions
- Separate dev dependencies in [project.optional-dependencies]
- Consider Python 3.11+ compatibility for all packages
```

### File Operations
```
For file operations:
- Always use context managers (with statements)
- Include proper error handling for file not found, permissions
- Use pathlib for path operations when possible
- Add logging for file operations
- Validate file paths and contents
```

---

*Note: All generated code should follow the standards defined in instructions.md, including function prefixes (f_), global prefixes (g_), proper docstrings, type hints, and GHCL comments.*
