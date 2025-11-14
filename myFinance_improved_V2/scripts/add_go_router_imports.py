#!/usr/bin/env python3
"""
Add go_router import to all Dart files using context.pop()
"""

import os
import re
from pathlib import Path

def needs_go_router_import(file_path):
    """Check if file uses context.pop() and doesn't have go_router import"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            has_context_pop = 'context.pop()' in content
            has_import = "import 'package:go_router/go_router.dart';" in content
            return has_context_pop and not has_import
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return False

def add_import(file_path):
    """Add go_router import to file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        # Find first import line
        import_index = -1
        for i, line in enumerate(lines):
            if line.strip().startswith('import '):
                import_index = i
                break

        if import_index != -1:
            # Add after first import
            lines.insert(import_index + 1, "import 'package:go_router/go_router.dart';\n")

            with open(file_path, 'w', encoding='utf-8') as f:
                f.writelines(lines)
            return True
    except Exception as e:
        print(f"❌ Error modifying {file_path}: {e}")
        return False
    return False

def main():
    base_path = Path('lib/features')
    dart_files = list(base_path.rglob('*.dart'))

    modified_count = 0
    skipped_count = 0

    print("🔍 Scanning Dart files...")
    print(f"Found {len(dart_files)} files\n")

    for dart_file in dart_files:
        if needs_go_router_import(dart_file):
            if add_import(dart_file):
                print(f"✅ {dart_file.relative_to('lib')}")
                modified_count += 1
            else:
                print(f"⚠️  Failed: {dart_file.relative_to('lib')}")
                skipped_count += 1

    print(f"\n{'='*50}")
    print(f"✅ Complete!")
    print(f"{'='*50}")
    print(f"Modified: {modified_count} files")
    print(f"Skipped: {skipped_count} files")
    print(f"\n Next steps:")
    print(f"  1. dart analyze")
    print(f"  2. flutter run")
    print(f"  3. git add . && git commit")

if __name__ == '__main__':
    main()
