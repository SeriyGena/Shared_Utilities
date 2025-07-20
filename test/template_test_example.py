"""
Sample test file for the template_project package.

This file demonstrates basic test structure and can be used as a template.
Requires Python 3.11+ for modern testing features.
"""

import pytest
import sys
import os

# Verify Python version requirement
assert sys.version_info >= (3, 11), "This package requires Python 3.11 or higher"

# Add src to Python path for testing
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))

# Import your modules
# from src.user_IO_files_function import some_function


def test_example():
    """Example test function."""
    assert True


def test_package_import():
    """Test that the main package can be imported."""
    try:
        import src

        assert hasattr(src, "__version__")
        assert hasattr(src, "__python_requires__")
    except ImportError:
        pytest.fail("Could not import src package")


def test_python_version():
    """Test that we're running on Python 3.11+."""
    assert sys.version_info >= (3, 11), (
        f"Python 3.11+ required, but running {sys.version_info}"
    )


class TestExample:
    """Example test class."""

    def test_method_example(self):
        """Example test method."""
        assert 1 + 1 == 2

    def setup_method(self):
        """Setup method run before each test method."""
        pass

    def teardown_method(self):
        """Teardown method run after each test method."""
        pass


if __name__ == "__main__":
    # Allow running tests directly with python
    pytest.main([__file__])
