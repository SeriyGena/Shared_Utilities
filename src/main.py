"""
Main module for template_project.
Add your main functionality here.
"""

import sys
from . import __version__


def main():
    """Main entry point for the application."""
    print(f"TEMPLATE_PROJECT v{__version__}")
    print(f"Python version: {sys.version}")
    print("Ready to start coding!")


if __name__ == "__main__":
    main()
