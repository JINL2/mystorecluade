#!/usr/bin/env python3
"""
Widget Import Consolidation Script

Replaces individual widget imports with a single index.dart import.
Example:
  BEFORE:
    import '../../../../shared/widgets/atoms/buttons/toss_button.dart';
    import '../../../../shared/widgets/molecules/cards/toss_expandable_card.dart';
    import '../../../../shared/widgets/organisms/dialogs/toss_success_error_dialog.dart';

  AFTER:
    import 'package:myfinance_improved/shared/widgets/index.dart';
"""

import os
import re
import sys

# Patterns to match widget imports
WIDGET_IMPORT_PATTERNS = [
    # Relative imports
    r"import\s+'[\.\/]+shared/widgets/(atoms|molecules|organisms|templates|selectors)/[^']+';",
    # Package imports
    r"import\s+'package:myfinance_improved/shared/widgets/(atoms|molecules|organisms|templates|selectors)/[^']+';",
]

# The consolidated import
CONSOLIDATED_IMPORT = "import 'package:myfinance_improved/shared/widgets/index.dart';"

# Skip these folders
SKIP_FOLDERS = ['widgetbook', 'design_library']

def should_skip_file(filepath):
    """Check if file should be skipped"""
    for folder in SKIP_FOLDERS:
        if folder in filepath:
            return True
    # Skip index.dart files
    if filepath.endswith('index.dart'):
        return True
    # Skip files inside shared/widgets
    if 'shared/widgets/' in filepath:
        return True
    return False

def process_file(filepath):
    """Process a single Dart file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return False, 0

    original = content
    widget_imports = []

    # Find all widget imports
    for pattern in WIDGET_IMPORT_PATTERNS:
        matches = re.findall(pattern, content)
        widget_imports.extend(matches)
        # Remove matched imports
        content = re.sub(pattern + r'\n?', '', content)

    if not widget_imports:
        return False, 0

    # Check if consolidated import already exists
    if CONSOLIDATED_IMPORT in content:
        # Just remove duplicates
        if content != original:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True, len(widget_imports)
        return False, 0

    # Add consolidated import after package imports
    # Find the last package import or first relative import
    lines = content.split('\n')
    insert_index = 0

    for i, line in enumerate(lines):
        if line.startswith('import '):
            insert_index = i + 1
        elif line.startswith('part ') or (line.strip() and not line.startswith('//') and not line.startswith('import ') and not line.startswith("'")):
            break

    # Insert the consolidated import
    lines.insert(insert_index, CONSOLIDATED_IMPORT)
    content = '\n'.join(lines)

    # Clean up multiple blank lines
    content = re.sub(r'\n{3,}', '\n\n', content)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

    return True, len(widget_imports)

def main():
    lib_path = sys.argv[1] if len(sys.argv) > 1 else "lib"

    if not os.path.exists(lib_path):
        print(f"Error: {lib_path} does not exist")
        return

    total_files = 0
    total_imports = 0

    for root, dirs, files in os.walk(lib_path):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)

                if should_skip_file(filepath):
                    continue

                modified, count = process_file(filepath)
                if modified:
                    print(f"✓ {filepath} ({count} imports consolidated)")
                    total_files += 1
                    total_imports += count

    print(f"\n{'='*50}")
    print(f"✅ Consolidated {total_imports} imports in {total_files} files")
    print(f"{'='*50}")

if __name__ == "__main__":
    main()
