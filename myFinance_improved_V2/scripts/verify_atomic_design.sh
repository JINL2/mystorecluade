#!/bin/bash
# verify_atomic_design.sh - Atomic Design 아키텍처 규칙 검증
# Usage: ./scripts/verify_atomic_design.sh

set -e

cd "$(dirname "$0")/.."

echo "=========================================="
echo "  Atomic Design Architecture Verification"
echo "=========================================="
echo ""

ERRORS=0
WARNINGS=0

# ============================================
# Rule 1: Atoms should not import other Atoms
# ============================================
echo "📋 Rule 1: Atoms should not import other Atoms..."
ATOM_IMPORTS=$(grep -r "import.*widgets/atoms/" lib/shared/widgets/atoms --include="*.dart" 2>/dev/null | grep -v "index.dart" || true)
if [ -n "$ATOM_IMPORTS" ]; then
  echo "❌ VIOLATION: Atoms importing other Atoms:"
  echo "$ATOM_IMPORTS"
  echo ""
  ERRORS=$((ERRORS + 1))
else
  echo "✅ Passed"
fi
echo ""

# ============================================
# Rule 2: Atoms should not import Molecules
# ============================================
echo "📋 Rule 2: Atoms should not import Molecules..."
ATOM_MOLECULE_IMPORTS=$(grep -r "import.*widgets/molecules/" lib/shared/widgets/atoms --include="*.dart" 2>/dev/null || true)
if [ -n "$ATOM_MOLECULE_IMPORTS" ]; then
  echo "❌ VIOLATION: Atoms importing Molecules:"
  echo "$ATOM_MOLECULE_IMPORTS"
  echo ""
  ERRORS=$((ERRORS + 1))
else
  echo "✅ Passed"
fi
echo ""

# ============================================
# Rule 3: Atoms should not import Organisms
# ============================================
echo "📋 Rule 3: Atoms should not import Organisms..."
ATOM_ORGANISM_IMPORTS=$(grep -r "import.*widgets/organisms/" lib/shared/widgets/atoms --include="*.dart" 2>/dev/null || true)
if [ -n "$ATOM_ORGANISM_IMPORTS" ]; then
  echo "❌ VIOLATION: Atoms importing Organisms:"
  echo "$ATOM_ORGANISM_IMPORTS"
  echo ""
  ERRORS=$((ERRORS + 1))
else
  echo "✅ Passed"
fi
echo ""

# ============================================
# Rule 4: No direct Flutter Colors usage
# ============================================
echo "📋 Rule 4: No direct Flutter Colors usage (should use TossColors)..."
COLORS_VIOLATIONS=$(grep -rn "Colors\." lib/shared/widgets --include="*.dart" 2>/dev/null | grep -v "TossColors" | grep -v "// ignore-atomic" || true)
if [ -n "$COLORS_VIOLATIONS" ]; then
  echo "⚠️  WARNING: Direct Colors usage found:"
  echo "$COLORS_VIOLATIONS"
  echo ""
  WARNINGS=$((WARNINGS + 1))
else
  echo "✅ Passed"
fi
echo ""

# ============================================
# Rule 5: No hardcoded BorderRadius values
# ============================================
echo "📋 Rule 5: No hardcoded BorderRadius values..."
BORDER_RADIUS_VIOLATIONS=$(grep -rn "BorderRadius.circular([0-9]" lib/shared/widgets --include="*.dart" 2>/dev/null | grep -v "TossBorderRadius" | grep -v "// ignore-atomic" || true)
if [ -n "$BORDER_RADIUS_VIOLATIONS" ]; then
  echo "⚠️  WARNING: Hardcoded BorderRadius found:"
  echo "$BORDER_RADIUS_VIOLATIONS"
  echo ""
  WARNINGS=$((WARNINGS + 1))
else
  echo "✅ Passed"
fi
echo ""

# ============================================
# Rule 6: No hardcoded icon sizes in atoms/molecules
# ============================================
echo "📋 Rule 6: No magic number icon sizes..."
ICON_SIZE_VIOLATIONS=$(grep -rn "size: [0-9]" lib/shared/widgets/atoms lib/shared/widgets/molecules --include="*.dart" 2>/dev/null | grep -v "TossSpacing" | grep -v "// ignore-atomic" || true)
if [ -n "$ICON_SIZE_VIOLATIONS" ]; then
  echo "⚠️  WARNING: Hardcoded icon sizes found:"
  echo "$ICON_SIZE_VIOLATIONS"
  echo ""
  WARNINGS=$((WARNINGS + 1))
else
  echo "✅ Passed"
fi
echo ""

# ============================================
# Rule 7: Check _legacy imports outside _legacy folder
# ============================================
echo "📋 Rule 7: No _legacy imports in production code..."
LEGACY_IMPORTS=$(grep -r "widgets/_legacy" lib --include="*.dart" 2>/dev/null | grep -v "lib/shared/widgets/_legacy" | grep -v "lib/shared/widgets/index.dart" || true)
if [ -n "$LEGACY_IMPORTS" ]; then
  echo "⚠️  WARNING: _legacy imports found in production code:"
  echo "$LEGACY_IMPORTS"
  echo ""
  WARNINGS=$((WARNINGS + 1))
else
  echo "✅ Passed"
fi
echo ""

# ============================================
# Summary
# ============================================
echo "=========================================="
echo "  Verification Summary"
echo "=========================================="
echo ""
echo "Critical Errors: $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [ $ERRORS -gt 0 ]; then
  echo "❌ FAILED: $ERRORS critical violations found!"
  echo "   These MUST be fixed before proceeding."
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  echo "⚠️  PASSED with $WARNINGS warnings"
  echo "   Consider fixing these for better architecture."
  exit 0
else
  echo "✅ ALL PASSED: No violations found!"
  exit 0
fi
