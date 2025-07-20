# Test Directory Documentation

This directory contains all tests for the **TEMPLATE_PROJECT** package. The testing framework is built around **pytest** and follows Python testing best practices.

## 📁 Directory Structure

```
test/
├── __init__.py                 # Makes test/ a Python package
├── template_test_example.py    # Example test file (template)
├── README_TEMPLATE.md          # This documentation
└── conftest.py                 # Shared pytest fixtures (optional)
```

## 🎯 Purpose of `__init__.py`

The `__init__.py` file in the test directory serves several critical functions:

### 1. **Package Marker** 📦
- Makes `test/` a proper Python package
- Enables test organization and imports
- Required for pytest to discover tests properly

### 2. **Shared Test Configuration** ⚙️
```python
# Common setup for all tests
import sys
import os

# Add src to Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))
```

### 3. **Test Utilities** 🛠️
```python
# Shared test helpers available to all test files
def setup_test_database():
    """Common database setup for tests"""
    pass

@pytest.fixture
def sample_data():
    """Shared test data"""
    return {"key": "value"}
```

### 4. **Test Organization** 📋
Enables advanced test organization:
```
test/
├── __init__.py
├── unit/
│   ├── __init__.py
│   └── test_functions.py
├── integration/
│   ├── __init__.py
│   └── test_workflows.py
└── e2e/
    ├── __init__.py
    └── test_complete_flows.py
```

## 🚀 Running Tests

### Basic Test Execution
```bash
# Run all tests
pytest test/

# Run with verbose output
pytest test/ -v

# Run specific test file
pytest test/template_test_example.py

# Run specific test function
pytest test/template_test_example.py::test_package_import

# Run specific test class
pytest test/template_test_example.py::TestExample
```

### Advanced Test Options
```bash
# Run with coverage
pytest test/ --cov=src --cov-report=html

# Run tests in parallel
pytest test/ -n auto

# Run only failed tests
pytest test/ --lf

# Run tests matching pattern
pytest test/ -k "test_package"

# Stop on first failure
pytest test/ -x
```

## 📝 Test File Examples

### Example 1: Basic Function Tests
```python
# test/test_basic_functions.py
"""Test basic utility functions."""

import pytest
from src.utils import add_numbers, format_string

def test_add_numbers():
    """Test number addition function."""
    assert add_numbers(2, 3) == 5
    assert add_numbers(-1, 1) == 0
    assert add_numbers(0, 0) == 0

def test_format_string():
    """Test string formatting function."""
    assert format_string("hello") == "Hello"
    assert format_string("") == ""
    
def test_add_numbers_invalid_input():
    """Test error handling."""
    with pytest.raises(TypeError):
        add_numbers("a", "b")
```

### Example 2: Class-Based Tests
```python
# test/test_data_processor.py
"""Test DataProcessor class."""

import pytest
from src.processor import DataProcessor

class TestDataProcessor:
    """Test class for DataProcessor."""
    
    def setup_method(self):
        """Setup before each test method."""
        self.processor = DataProcessor()
        self.sample_data = [1, 2, 3, 4, 5]
    
    def teardown_method(self):
        """Cleanup after each test method."""
        self.processor = None
    
    def test_process_data(self):
        """Test data processing."""
        result = self.processor.process(self.sample_data)
        assert len(result) == 5
        assert all(isinstance(x, int) for x in result)
    
    def test_empty_data(self):
        """Test processing empty data."""
        result = self.processor.process([])
        assert result == []
    
    @pytest.mark.parametrize("input_data,expected", [
        ([1, 2, 3], [2, 4, 6]),
        ([0], [0]),
        ([-1, -2], [-2, -4]),
    ])
    def test_parametrized_processing(self, input_data, expected):
        """Test with multiple parameter sets."""
        result = self.processor.double_values(input_data)
        assert result == expected
```

### Example 3: Integration Tests
```python
# test/test_integration.py
"""Integration tests for TEMPLATE_PROJECT."""

import pytest
import tempfile
import os
from src.file_handler import FileHandler
from src.processor import DataProcessor

class TestIntegration:
    """Integration tests."""
    
    def setup_method(self):
        """Setup test environment."""
        self.temp_dir = tempfile.mkdtemp()
        self.file_handler = FileHandler(self.temp_dir)
        self.processor = DataProcessor()
    
    def teardown_method(self):
        """Cleanup test environment."""
        import shutil
        shutil.rmtree(self.temp_dir)
    
    def test_file_processing_workflow(self):
        """Test complete file processing workflow."""
        # Create test file
        test_file = os.path.join(self.temp_dir, "test.txt")
        with open(test_file, "w") as f:
            f.write("1,2,3,4,5")
        
        # Process file
        data = self.file_handler.read_csv(test_file)
        processed = self.processor.process(data)
        
        # Verify results
        assert len(processed) == 5
        assert processed[0] == 1
```

### Example 4: Fixture Usage
```python
# test/test_with_fixtures.py
"""Tests using pytest fixtures."""

import pytest

@pytest.fixture
def sample_user():
    """Fixture providing sample user data."""
    return {
        "id": 1,
        "name": "Test User",
        "email": "test@example.com"
    }

@pytest.fixture
def database_connection():
    """Fixture providing database connection."""
    # Setup
    connection = create_test_database()
    yield connection
    # Teardown
    connection.close()

def test_user_creation(sample_user):
    """Test user creation with fixture."""
    from src.user import User
    user = User(**sample_user)
    assert user.name == "Test User"
    assert user.email == "test@example.com"

def test_user_persistence(sample_user, database_connection):
    """Test user database persistence."""
    from src.user import User
    user = User(**sample_user)
    user.save(database_connection)
    
    # Verify user was saved
    saved_user = User.get_by_id(1, database_connection)
    assert saved_user.name == user.name
```

## 🧪 Why `__init__.py` is Essential

### Without `__init__.py`:
❌ **Cannot import test utilities between files**
❌ **pytest discovery may be unreliable**
❌ **Cannot organize tests in subpackages**
❌ **No shared configuration**

### With `__init__.py`:
✅ **Clean test imports**: `from test.helpers import utility`
✅ **Reliable test discovery**: pytest finds all tests consistently
✅ **Test organization**: Support for test subpackages
✅ **Shared setup**: Common configuration for all tests
✅ **Professional structure**: Industry-standard test layout

## 📦 Template Files Explained

### `template_test_example.py`
- **Purpose**: Demonstrates basic test patterns
- **Features**: Function tests, class tests, fixtures, parametrization
- **Usage**: Copy and modify for your own tests
- **Requirements**: Python 3.11+, pytest

### `__init__.py`
- **Purpose**: Makes test directory a Python package
- **Features**: Shared configuration, test utilities
- **Usage**: Add common fixtures and helpers here
- **Benefits**: Enables advanced test organization

## 🎨 Best Practices

### 1. **Test Naming**
```python
# Good test names
def test_user_login_with_valid_credentials():
def test_data_processing_handles_empty_input():
def test_api_returns_404_for_missing_resource():

# Bad test names
def test_user():
def test_function():
def test_1():
```

### 2. **Test Organization**
```python
# Organize by functionality
class TestUserAuthentication:
    def test_login_success(self):
    def test_login_failure(self):
    def test_logout(self):

class TestUserProfile:
    def test_profile_update(self):
    def test_profile_deletion(self):
```

### 3. **Use Fixtures for Setup**
```python
@pytest.fixture
def clean_database():
    """Provide clean database for each test."""
    setup_database()
    yield
    cleanup_database()
```

### 4. **Test Edge Cases**
```python
def test_function_with_edge_cases():
    """Test function with various edge cases."""
    # Normal case
    assert process_data([1, 2, 3]) == [2, 4, 6]
    
    # Edge cases
    assert process_data([]) == []
    assert process_data([0]) == [0]
    assert process_data([-1]) == [-2]
    
    # Error cases
    with pytest.raises(TypeError):
        process_data("invalid")
```

## 🔧 Configuration

### `pytest.ini` (optional)
```ini
[tool:pytest]
testpaths = test
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = -v --tb=short
```

### `conftest.py` (optional)
```python
"""Shared pytest configuration and fixtures."""

import pytest
import sys
import os

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

@pytest.fixture(scope="session")
def app_config():
    """Application configuration for tests."""
    return {
        "debug": True,
        "testing": True,
        "database_url": "sqlite:///:memory:"
    }
```

## 🚀 Getting Started

1. **Install pytest**:
   ```bash
   pip install pytest
   # or
   ./scripts/install_dependencies.ps1 -IncludeDev
   ```

2. **Run the example test**:
   ```bash
   pytest test/template_test_example.py -v
   ```

3. **Create your first test**:
   - Copy `template_test_example.py`
   - Rename to `test_your_feature.py`
   - Replace example tests with your own

4. **Add test utilities to `__init__.py`**:
   - Common fixtures
   - Shared helper functions
   - Test configuration

## 📚 Additional Resources

- [pytest Documentation](https://docs.pytest.org/)
- [Python Testing Best Practices](https://docs.python-guide.org/writing/tests/)
- [Test-Driven Development (TDD)](https://en.wikipedia.org/wiki/Test-driven_development)

---

**Happy Testing!** 🎉

*This template provides a solid foundation for testing your TEMPLATE_PROJECT package. Modify and expand as needed for your specific requirements.*
