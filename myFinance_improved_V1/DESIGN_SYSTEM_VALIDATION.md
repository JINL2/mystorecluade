# Design System Validation Guide

## Overview
This document prevents design system inconsistency and enforces single-point-of-change architecture.

## ✅ REQUIRED PATTERNS

### Colors
```dart
// ✅ CORRECT - Use TossColors only
color: TossColors.primary,
backgroundColor: TossColors.surface,

// ❌ WRONG - Never hardcode colors
color: Color(0xFF3B82F6),
color: Colors.blue,
```

### Border Radius
```dart
// ✅ CORRECT - Use TossBorderRadius constants
borderRadius: BorderRadius.circular(TossBorderRadius.lg),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.xl)),

// ❌ WRONG - Never hardcode radius
borderRadius: BorderRadius.circular(12),
borderRadius: BorderRadius.circular(16),
```

### Typography
```dart
// ✅ CORRECT - Use TossTextStyles semantically
style: TossTextStyles.body,
style: TossTextStyles.h3.copyWith(color: TossColors.primary),

// ❌ WRONG - Never use direct fontSize
style: TextStyle(fontSize: 16),
style: GoogleFonts.inter(fontSize: 14),
```

### Spacing
```dart
// ✅ CORRECT - Use TossSpacing system
padding: EdgeInsets.all(TossSpacing.space4),
margin: EdgeInsets.symmetric(horizontal: TossSpacing.space6),

// ❌ WRONG - Never hardcode spacing
padding: EdgeInsets.all(16.0),
margin: EdgeInsets.symmetric(horizontal: 24.0),
```

## 🔍 VALIDATION COMMANDS

### Check Violations
```bash
# Colors
rg "Color\(0x[A-F0-9]+\)" lib/presentation/ --count-matches
rg "Colors\.(blue|red|green|grey)" lib/presentation/ --count-matches

# BorderRadius  
rg "BorderRadius\.circular\([0-9]+\)" lib/presentation/ --count-matches

# Typography
rg "TextStyle\([^)]*fontSize:" lib/presentation/ --count-matches
rg "GoogleFonts\.[^(]*\([^)]*fontSize:" lib/presentation/ --count-matches

# Spacing
rg "EdgeInsets\.[^(]*\([^)]*[0-9]+\.0" lib/presentation/ --count-matches
```

### Expected Results (Target State)
- **Colors**: 0 hardcoded Color() or Colors.* violations
- **BorderRadius**: 0 hardcoded BorderRadius.circular() violations  
- **Typography**: 0 direct fontSize in TextStyle/GoogleFonts
- **Spacing**: <50 hardcoded EdgeInsets (some exceptions allowed)

## 🎯 SINGLE-POINT-OF-CHANGE VERIFICATION

### Test Core Changes Propagate
```bash
# Change core color and verify propagation
# Before: TossColors.primary = Color(0xFF3B82F6)  
# After:  TossColors.primary = Color(0xFF8B5CF6)
# Expected: ALL UI elements using TossColors.primary change automatically

# Change core radius and verify propagation  
# Before: TossBorderRadius.lg = 12.0
# After:  TossBorderRadius.lg = 14.0
# Expected: ALL cards/containers using .lg change simultaneously
```

## 🚨 ENFORCEMENT

### Pre-commit Hook (Recommended)
```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "Validating design system consistency..."

# Check for hardcoded colors
VIOLATIONS=$(rg "Color\(0x[A-F0-9]+\)" lib/presentation/ --count-matches | awk '{sum += $1} END {print sum}')
if [ "$VIOLATIONS" -gt 0 ]; then
  echo "❌ Found $VIOLATIONS hardcoded Color() violations"
  echo "Use TossColors instead"
  exit 1
fi

# Check for hardcoded BorderRadius
VIOLATIONS=$(rg "BorderRadius\.circular\([0-9]+\)" lib/presentation/ --count-matches | awk '{sum += $1} END {print sum}')
if [ "$VIOLATIONS" -gt 0 ]; then
  echo "❌ Found $VIOLATIONS hardcoded BorderRadius violations"  
  echo "Use TossBorderRadius constants"
  exit 1
fi

echo "✅ Design system validation passed"
```

### Manual Review Checklist
- [ ] No hardcoded Color(0x...) in new code
- [ ] No BorderRadius.circular(number) without TossBorderRadius
- [ ] No TextStyle(fontSize: ...) constructors  
- [ ] Spacing uses TossSpacing when possible
- [ ] Imports include required design system files

## 📋 MAINTENANCE

### Monthly Audits
Run full validation to catch any new violations:
```bash
./validate_design_system.sh
```

### New Component Guidelines
1. Always import design system themes
2. Use semantic styles over hardcoded values
3. Test single-point-of-change by modifying core constants
4. Validate with design system validation commands