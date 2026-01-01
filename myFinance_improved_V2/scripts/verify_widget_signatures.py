#!/usr/bin/env python3
"""
Widget Signature Verification Script

Checks all shared widgets for:
1. Valid class definitions
2. Constructor parameters
3. Callback types (VoidCallback, Function types)
4. Required vs optional parameters
5. Atomic Design dependency rules
"""

import os
import re
import sys
from pathlib import Path
from dataclasses import dataclass
from typing import List, Optional, Set

@dataclass
class WidgetInfo:
    file_path: str
    class_name: str
    parameters: List[str]
    callbacks: List[str]
    imports: List[str]
    has_build_method: bool
    has_state_class: bool
    errors: List[str]

def extract_class_info(content: str, file_path: str) -> List[WidgetInfo]:
    """Extract widget class information from file content"""
    widgets = []

    # Find all class definitions
    class_pattern = r'class\s+(\w+)\s+extends\s+(StatelessWidget|StatefulWidget|ConsumerWidget|ConsumerStatefulWidget|HookConsumerWidget)'
    class_matches = re.finditer(class_pattern, content)

    # Extract imports
    import_pattern = r"import\s+'([^']+)';"
    imports = re.findall(import_pattern, content)

    for match in class_matches:
        class_name = match.group(1)
        widget_type = match.group(2)

        errors = []
        parameters = []
        callbacks = []
        has_build = False
        has_state = False

        # Find constructor
        constructor_pattern = rf'const\s+{class_name}\s*\(([^)]*\{{[^}}]*\}}[^)]*)\)'
        constructor_match = re.search(constructor_pattern, content, re.DOTALL)

        if not constructor_match:
            # Try non-const constructor
            constructor_pattern = rf'{class_name}\s*\(([^)]*\{{[^}}]*\}}[^)]*)\)'
            constructor_match = re.search(constructor_pattern, content, re.DOTALL)

        if constructor_match:
            constructor_body = constructor_match.group(1)

            # Extract parameters
            param_pattern = r'(?:required\s+)?(?:this\.)?(\w+)'
            params = re.findall(param_pattern, constructor_body)
            parameters = [p for p in params if p not in ['key', 'super', 'const']]

            # Find callback parameters
            callback_pattern = r'((?:required\s+)?(?:VoidCallback|Function|void\s+Function\([^)]*\)|\w+Callback)\??\s+\w+)'
            callback_matches = re.findall(callback_pattern, constructor_body)
            callbacks = callback_matches
        else:
            errors.append("Constructor not found or malformed")

        # Check for build method
        if 'Widget build(' in content or '@override' in content:
            has_build = True
        else:
            errors.append("Missing build method")

        # Check for State class if StatefulWidget
        if widget_type in ['StatefulWidget', 'ConsumerStatefulWidget']:
            state_pattern = rf'class\s+_{class_name}State\s+extends'
            if re.search(state_pattern, content):
                has_state = True
            else:
                errors.append(f"Missing State class for {widget_type}")

        widgets.append(WidgetInfo(
            file_path=file_path,
            class_name=class_name,
            parameters=parameters,
            callbacks=callbacks,
            imports=imports,
            has_build_method=has_build,
            has_state_class=has_state,
            errors=errors
        ))

    return widgets

def check_atomic_design_rules(file_path: str, imports: List[str]) -> List[str]:
    """Check Atomic Design dependency rules"""
    errors = []

    if '/atoms/' in file_path:
        # Atoms should not import molecules or organisms
        for imp in imports:
            if 'molecules/' in imp or 'organisms/' in imp:
                errors.append(f"ATOMIC VIOLATION: Atom imports from higher level: {imp}")

    elif '/molecules/' in file_path:
        # Molecules should not import organisms
        for imp in imports:
            if 'organisms/' in imp:
                errors.append(f"ATOMIC VIOLATION: Molecule imports from organisms: {imp}")

    return errors

def analyze_file(file_path: str) -> List[WidgetInfo]:
    """Analyze a single Dart file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        return [WidgetInfo(
            file_path=file_path,
            class_name="ERROR",
            parameters=[],
            callbacks=[],
            imports=[],
            has_build_method=False,
            has_state_class=False,
            errors=[f"Failed to read file: {e}"]
        )]

    # Skip index files
    if file_path.endswith('index.dart'):
        return []

    widgets = extract_class_info(content, file_path)

    # Check atomic design rules for each widget
    for widget in widgets:
        atomic_errors = check_atomic_design_rules(file_path, widget.imports)
        widget.errors.extend(atomic_errors)

    return widgets

def main():
    base_path = sys.argv[1] if len(sys.argv) > 1 else "lib/shared/widgets"

    if not os.path.exists(base_path):
        print(f"Error: {base_path} does not exist")
        return 1

    all_widgets = []
    error_count = 0
    warning_count = 0

    # Categories to check
    categories = ['atoms', 'molecules', 'organisms', 'selectors', 'templates']

    print("=" * 70)
    print("WIDGET SIGNATURE VERIFICATION REPORT")
    print("=" * 70)

    for category in categories:
        category_path = os.path.join(base_path, category)
        if not os.path.exists(category_path):
            continue

        print(f"\n{'─' * 70}")
        print(f"📁 {category.upper()}")
        print(f"{'─' * 70}")

        category_widgets = []

        for root, dirs, files in os.walk(category_path):
            for file in files:
                if file.endswith('.dart') and not file.startswith('_'):
                    file_path = os.path.join(root, file)
                    widgets = analyze_file(file_path)
                    category_widgets.extend(widgets)

        if not category_widgets:
            print("  (no widgets found)")
            continue

        for widget in category_widgets:
            status = "✅" if not widget.errors else "❌"
            rel_path = widget.file_path.replace(base_path + "/", "")

            print(f"\n  {status} {widget.class_name}")
            print(f"     📄 {rel_path}")

            if widget.parameters:
                param_str = ", ".join(widget.parameters[:5])
                if len(widget.parameters) > 5:
                    param_str += f"... (+{len(widget.parameters) - 5} more)"
                print(f"     📦 Parameters: {param_str}")

            if widget.callbacks:
                print(f"     🔄 Callbacks: {len(widget.callbacks)} found")
                for cb in widget.callbacks[:3]:
                    print(f"        - {cb}")

            if widget.errors:
                error_count += len(widget.errors)
                for err in widget.errors:
                    print(f"     ⚠️  {err}")

        all_widgets.extend(category_widgets)

    # Summary
    print("\n" + "=" * 70)
    print("SUMMARY")
    print("=" * 70)

    total_widgets = len(all_widgets)
    widgets_with_errors = sum(1 for w in all_widgets if w.errors)

    print(f"📊 Total widgets analyzed: {total_widgets}")
    print(f"✅ Widgets OK: {total_widgets - widgets_with_errors}")
    print(f"❌ Widgets with issues: {widgets_with_errors}")
    print(f"⚠️  Total errors: {error_count}")

    # Atomic Design Stats
    print("\n📐 Atomic Design Structure:")
    for category in categories:
        count = sum(1 for w in all_widgets if f'/{category}/' in w.file_path)
        print(f"   {category}: {count} widgets")

    # Callback Analysis
    all_callbacks = []
    for w in all_widgets:
        all_callbacks.extend(w.callbacks)

    if all_callbacks:
        print(f"\n🔄 Callback Types Found: {len(all_callbacks)}")
        callback_types = {}
        for cb in all_callbacks:
            cb_type = cb.split()[0] if ' ' in cb else cb
            callback_types[cb_type] = callback_types.get(cb_type, 0) + 1
        for cb_type, count in sorted(callback_types.items(), key=lambda x: -x[1])[:5]:
            print(f"   {cb_type}: {count}")

    print("\n" + "=" * 70)

    return 0 if error_count == 0 else 1

if __name__ == "__main__":
    sys.exit(main())
