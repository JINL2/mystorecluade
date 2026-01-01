#!/usr/bin/env python3
"""
Dart Syntax Verification Script

Checks for common Dart syntax issues:
1. Balanced braces {} [] ()
2. Missing semicolons
3. @override annotations before methods
4. Proper class definitions
5. Import statement validity
"""

import os
import re
import sys
from pathlib import Path

def check_balanced_brackets(content: str, file_path: str) -> list:
    """Check for balanced brackets"""
    errors = []

    # Track brackets
    stack = []
    bracket_pairs = {'{': '}', '[': ']', '(': ')'}
    line_num = 1
    in_string = False
    in_multiline_string = False
    string_char = None

    i = 0
    while i < len(content):
        char = content[i]

        # Track line numbers
        if char == '\n':
            line_num += 1
            i += 1
            continue

        # Handle multiline strings '''
        if i + 2 < len(content) and content[i:i+3] in ["'''", '"""']:
            if in_multiline_string and content[i:i+3] == string_char:
                in_multiline_string = False
                string_char = None
            elif not in_string and not in_multiline_string:
                in_multiline_string = True
                string_char = content[i:i+3]
            i += 3
            continue

        # Handle single-line strings
        if char in ['"', "'"] and not in_multiline_string:
            if not in_string:
                in_string = True
                string_char = char
            elif char == string_char and (i == 0 or content[i-1] != '\\'):
                in_string = False
                string_char = None
            i += 1
            continue

        # Skip comments
        if i + 1 < len(content):
            two_chars = content[i:i+2]
            if two_chars == '//' and not in_string and not in_multiline_string:
                # Skip to end of line
                while i < len(content) and content[i] != '\n':
                    i += 1
                continue
            if two_chars == '/*' and not in_string and not in_multiline_string:
                # Skip to */
                i += 2
                while i + 1 < len(content) and content[i:i+2] != '*/':
                    if content[i] == '\n':
                        line_num += 1
                    i += 1
                i += 2
                continue

        if in_string or in_multiline_string:
            i += 1
            continue

        # Track brackets
        if char in bracket_pairs:
            stack.append((char, line_num))
        elif char in bracket_pairs.values():
            if not stack:
                errors.append(f"Line {line_num}: Unexpected closing bracket '{char}'")
            else:
                open_bracket, open_line = stack.pop()
                expected_close = bracket_pairs[open_bracket]
                if char != expected_close:
                    errors.append(f"Line {line_num}: Mismatched bracket. Expected '{expected_close}' but got '{char}' (opened at line {open_line})")

        i += 1

    # Check for unclosed brackets
    for bracket, line in stack:
        errors.append(f"Line {line}: Unclosed bracket '{bracket}'")

    return errors

def check_override_annotations(content: str, file_path: str) -> list:
    """Check for missing @override annotations"""
    errors = []

    # Common methods that should have @override
    override_methods = ['build', 'initState', 'dispose', 'didChangeDependencies',
                        'didUpdateWidget', 'createState', 'setState']

    lines = content.split('\n')
    for i, line in enumerate(lines):
        stripped = line.strip()

        # Check if this is a method definition
        for method in override_methods:
            pattern = rf'^\s*(Widget|void|State<\w+>)\s+{method}\s*\('
            if re.match(pattern, stripped):
                # Check if previous non-empty line has @override
                prev_line_idx = i - 1
                while prev_line_idx >= 0 and not lines[prev_line_idx].strip():
                    prev_line_idx -= 1

                if prev_line_idx >= 0:
                    prev_line = lines[prev_line_idx].strip()
                    if not prev_line.startswith('@override'):
                        errors.append(f"Line {i+1}: Method '{method}' might need @override annotation")

    return errors

def check_class_structure(content: str, file_path: str) -> list:
    """Check for proper class structure"""
    errors = []

    # Check for StatefulWidget without State class
    stateful_pattern = r'class\s+(\w+)\s+extends\s+(?:StatefulWidget|ConsumerStatefulWidget)'
    stateful_matches = re.finditer(stateful_pattern, content)

    for match in stateful_matches:
        class_name = match.group(1)
        # Skip private classes
        if class_name.startswith('_'):
            continue

        state_pattern = rf'class\s+_{class_name}State\s+extends'
        if not re.search(state_pattern, content):
            errors.append(f"StatefulWidget '{class_name}' is missing State class '_{class_name}State'")

    return errors

def check_import_statements(content: str, file_path: str) -> list:
    """Check for import statement issues"""
    errors = []

    lines = content.split('\n')
    library_found = False
    first_import_line = None

    for i, line in enumerate(lines):
        stripped = line.strip()

        if stripped.startswith('library'):
            library_found = True
            library_line = i + 1

        if stripped.startswith('import '):
            if first_import_line is None:
                first_import_line = i + 1

            # Check for library directive after import
            if library_found and i + 1 < library_line:
                errors.append(f"Line {i+1}: Import statement before library directive")

            # Check for missing semicolon
            if not stripped.endswith(';'):
                errors.append(f"Line {i+1}: Import statement missing semicolon")

    return errors

def analyze_file(file_path: str) -> tuple:
    """Analyze a single Dart file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        return ([f"Failed to read file: {e}"], [])

    errors = []
    warnings = []

    # Run all checks
    bracket_errors = check_balanced_brackets(content, file_path)
    errors.extend(bracket_errors)

    override_warnings = check_override_annotations(content, file_path)
    warnings.extend(override_warnings)

    class_errors = check_class_structure(content, file_path)
    errors.extend(class_errors)

    import_errors = check_import_statements(content, file_path)
    errors.extend(import_errors)

    return (errors, warnings)

def main():
    base_path = sys.argv[1] if len(sys.argv) > 1 else "lib/shared/widgets"

    if not os.path.exists(base_path):
        print(f"Error: {base_path} does not exist")
        return 1

    total_files = 0
    files_with_errors = 0
    total_errors = 0
    total_warnings = 0

    print("=" * 70)
    print("DART SYNTAX VERIFICATION REPORT")
    print("=" * 70)

    for root, dirs, files in os.walk(base_path):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                total_files += 1

                errors, warnings = analyze_file(file_path)

                if errors or warnings:
                    rel_path = file_path.replace(base_path + "/", "")

                    if errors:
                        files_with_errors += 1
                        total_errors += len(errors)
                        print(f"\n❌ {rel_path}")
                        for err in errors:
                            print(f"   🔴 ERROR: {err}")

                    if warnings:
                        total_warnings += len(warnings)
                        if not errors:
                            print(f"\n⚠️  {rel_path}")
                        for warn in warnings:
                            print(f"   🟡 WARNING: {warn}")

    print("\n" + "=" * 70)
    print("SUMMARY")
    print("=" * 70)
    print(f"📊 Total files analyzed: {total_files}")
    print(f"✅ Files OK: {total_files - files_with_errors}")
    print(f"❌ Files with errors: {files_with_errors}")
    print(f"🔴 Total errors: {total_errors}")
    print(f"🟡 Total warnings: {total_warnings}")
    print("=" * 70)

    return 0 if total_errors == 0 else 1

if __name__ == "__main__":
    sys.exit(main())
