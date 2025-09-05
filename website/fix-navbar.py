#!/usr/bin/env python3

# Fix duplicate initCompanySelector method in navbar.js

file_path = '/Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website/components/navigation/navbar.js'

# Read the file
with open(file_path, 'r') as f:
    lines = f.readlines()

# Find and remove duplicate method definition
fixed_lines = []
skip_duplicate = False
duplicate_count = 0
brace_count = 0

for i, line in enumerate(lines):
    # Check for the duplicate method definition
    if 'initCompanySelector(companies, selectedId) {' in line:
        duplicate_count += 1
        if duplicate_count == 2:
            # Skip the second occurrence
            skip_duplicate = True
            brace_count = 1
            print(f"Found duplicate at line {i+1}, starting to skip...")
            continue
    
    # If we're skipping the duplicate, count braces
    if skip_duplicate:
        brace_count += line.count('{')
        brace_count -= line.count('}')
        
        # Skip this line
        if brace_count > 0:
            continue
        else:
            # End of duplicate method
            skip_duplicate = False
            print(f"Finished skipping duplicate at line {i+1}")
            continue
    
    # Add non-duplicate lines
    fixed_lines.append(line)

# Write the fixed file
with open(file_path, 'w') as f:
    f.writelines(fixed_lines)

print(f"File fixed! Removed duplicate method.")
print(f"New file has {len(fixed_lines)} lines (original had {len(lines)} lines)")
