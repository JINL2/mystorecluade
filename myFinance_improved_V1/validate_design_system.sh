#!/bin/bash
# Design System Consistency Validator
# Enforces single-point-of-change architecture

echo "🎨 Design System Consistency Validator"
echo "======================================"

VIOLATIONS=0

echo ""
echo "🎨 Checking Colors..."
COLOR_VIOLATIONS=$(rg "Color\(0x[A-F0-9]+\)" lib/presentation/ --count-matches 2>/dev/null | awk '{sum += $1} END {print sum+0}')
if [ "$COLOR_VIOLATIONS" -gt 0 ]; then
  echo "❌ Found $COLOR_VIOLATIONS hardcoded Color() violations"
  echo "   Use TossColors instead"
  VIOLATIONS=$((VIOLATIONS + COLOR_VIOLATIONS))
else
  echo "✅ Colors: Perfect consistency (0 violations)"
fi

echo ""
echo "🔘 Checking Border Radius..."
RADIUS_VIOLATIONS=$(rg "BorderRadius\.circular\([0-9]+\)" lib/presentation/ --count-matches 2>/dev/null | awk '{sum += $1} END {print sum+0}')
if [ "$RADIUS_VIOLATIONS" -gt 0 ]; then
  echo "❌ Found $RADIUS_VIOLATIONS hardcoded BorderRadius violations"
  echo "   Use TossBorderRadius constants"
  VIOLATIONS=$((VIOLATIONS + RADIUS_VIOLATIONS))
else
  echo "✅ BorderRadius: Perfect consistency (0 violations)"
fi

echo ""
echo "📝 Checking Typography..."
TYPO_VIOLATIONS=$(rg "TextStyle\([^)]*fontSize:" lib/presentation/ --count-matches 2>/dev/null | awk '{sum += $1} END {print sum+0}')
if [ "$TYPO_VIOLATIONS" -gt 0 ]; then
  echo "❌ Found $TYPO_VIOLATIONS direct TextStyle fontSize violations"
  echo "   Use TossTextStyles instead"
  VIOLATIONS=$((VIOLATIONS + TYPO_VIOLATIONS))
else
  echo "✅ Typography: Perfect consistency (0 violations)"
fi

echo ""
echo "📏 Checking Spacing..."
SPACING_VIOLATIONS=$(rg "EdgeInsets\.[^(]*\([^)]*[0-9]+\.0" lib/presentation/ --count-matches 2>/dev/null | awk '{sum += $1} END {print sum+0}')
SPACING_ACCEPTABLE=50  # Some hardcoded spacing acceptable
if [ "$SPACING_VIOLATIONS" -gt $SPACING_ACCEPTABLE ]; then
  echo "⚠️  Found $SPACING_VIOLATIONS hardcoded EdgeInsets (>${SPACING_ACCEPTABLE} threshold)"
  echo "   Consider using TossSpacing system"
  echo "   Note: Some hardcoded spacing is acceptable for specific use cases"
else
  echo "✅ Spacing: Within acceptable limits ($SPACING_VIOLATIONS/$SPACING_ACCEPTABLE)"
fi

echo ""
echo "📊 DESIGN SYSTEM HEALTH REPORT"
echo "=============================="

if [ "$VIOLATIONS" -eq 0 ]; then
  echo "🎉 PERFECT CONSISTENCY ACHIEVED!"
  echo ""
  echo "📈 Benefits:"
  echo "   • Single-point-of-change: Modify core → everything updates"
  echo "   • Perfect consistency: No visual inconsistencies"  
  echo "   • Maintainable: Easy to update design across entire app"
  echo ""
  echo "🔧 Usage:"
  echo "   • Colors: Change TossColors.primary → all blues update"
  echo "   • Radius: Change TossBorderRadius.lg → all cards update"
  echo "   • Typography: Change TossTextStyles.body → all body text updates"
else
  echo "⚠️  Found $VIOLATIONS total violations requiring attention"
  echo ""
  echo "🔧 Next Steps:"
  echo "   1. Review violations shown above"
  echo "   2. Migrate hardcoded values to design system"
  echo "   3. Re-run validation: ./validate_design_system.sh"
fi

echo ""
echo "Last validated: $(date)"

exit $VIOLATIONS