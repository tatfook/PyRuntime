#!/usr/bin/env python3

import sys
import os

from pythonlua.translator import Translator

def main():
    """Entry point function to the translator"""
    with open(sys.argv[1], 'r', encoding='utf-8') as f:
        content = f.read()

    translator = Translator()
    error, result = translator.translate(content)

    exit_code = 1 if error else 0
    sys.stdout.write(result)
    sys.stdout.flush()

    return exit_code

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit()

    sys.exit(main())
