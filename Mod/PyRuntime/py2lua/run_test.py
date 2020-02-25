#!/usr/bin/env python3

import sys
import os

from pythonlua.translator import Translator

def main():
    """Entry point function to the translator"""
    content = sys.stdin.read()
    translator = Translator()
    error, result = translator.translate(content)

    exit_code = 1 if error else 0
    sys.stdout.write(result)
    sys.stdout.flush()

    return exit_code

if __name__ == "__main__":
     sys.exit(main())
