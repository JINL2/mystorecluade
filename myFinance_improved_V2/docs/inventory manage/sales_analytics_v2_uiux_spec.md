# Sales Analytics V2 - UI/UX Specification

> **Version**: 1.0
> **Date**: 2026-01-09
> **Design System**: Toss Design System
> **Target**: Flutter Mobile App

---

## 1. Page Structure Overview

```
┌─────────────────────────────────────────┐
│  AppBar: "Sales Analytics"              │
│  [Store Selector Dropdown]              │
├─────────────────────────────────────────┤
│  Time Range Selector (Chips)            │
│  [Today][Week][Month][30D][90D][Year]   │
├─────────────────────────────────────────┤
│  Summary Cards (Horizontal Scroll)      │
│  ┌───────┐ ┌───────┐ ┌───────┐         │
│  │Revenue│ │Margin │ │ Qty  │          │
│  │$9.3B  │ │$7.0B  │ │ 1.2K │          │
│  │+12.5% │ │+15.2% │ │+8.3% │          │
│  └───────┘ └───────┘ └───────┘         │
├─────────────────────────────────────────┤
│  Time Series Chart                      │
│  ┌─────────────────────────────────────┐│
│  │  📈 Revenue Trend                   ││
│  │  [Revenue][Margin][Quantity] toggle ││
│  │  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   ││
│  │  |    /\      /\                    ││
│  │  |   /  \    /  \    /\            ││
│  │  |  /    \  /    \  /  \           ││
│  │  | /      \/      \/    \          ││
│  │  +------------------------→         ││
│  │  W1   W2   W3   W4   W5            ││
│  └─────────────────────────────────────┘│
├─────────────────────────────────────────┤
│  Top 10 Products                        │
│  ┌─────────────────────────────────────┐│
│  │ 1. 샤넬가방          $25M   +12%   ││
│  │ 2. 루이비통백        $22M   +8%    ││
│  │ 3. 에르메스버킨      $18M   +15%   ││
│  │ 4. 구찌토트          $15M   -3%    ││
│  │ 5. 프라다백          $12M   +5%    ││
│  │    ... (expandable)                 ││
│  └─────────────────────────────────────┘│
├─────────────────────────────────────────┤
│  Category Drill-down                    │
│  ┌─────────────────────────────────────┐│
│  │ Breadcrumb: All > Bag > Chanel      ││
│  │ ─────────────────────────────────── ││
│  │ ┌─────────┐ ┌─────────┐             ││
│  │ │  Bag    │ │Jewelry  │             ││
│  │ │ $356M   │ │ $120M   │             ││
│  │ │ 45 items│ │ 30 items│             ││
│  │ └─────────┘ └─────────┘             ││
│  └─────────────────────────────────────┘│
├─────────────────────────────────────────┤
│  BCG Matrix (Enhanced)                  │
│  (기존 BCG Matrix + Time Range 지원)    │
└─────────────────────────────────────────┘
```

---

## 2. Component Specifications

### 2.1 Time Range Selector

**Type**: Horizontal Chip Group (SingleChildScrollView)

**Design:**
```dart
┌────────────────────────────────────────────────────┐
│ [Today] [Week] [Month] [30D] [90D] [Year] [Custom] │
└────────────────────────────────────────────────────┘
```

**States:**
- Default: Gray background, dark text
- Selected: Primary color background, white text
- Custom: Opens DateRangePicker dialog

**Implementation:**
```dart
class TimeRangeSelector extends StatelessWidget {
  final TimeRange selected;
  final Function(TimeRange) onChanged;
  final Function(DateTimeRange)? onCustomRange;

  // Chip options
  final chips = [
    ('Today', TimeRange.today),
    ('This Week', TimeRange.thisWeek),
    ('This Month', TimeRange.thisMonth),
    ('Last 30D', TimeRange.last30Days),
    ('Last 90D', TimeRange.last90Days),
    ('This Year', TimeRange.thisYear),
  ];
}
```

**Toss Design Tokens:**
```dart
// Selected chip
backgroundColor: TossColors.blue500
textColor: TossColors.white

// Unselected chip
backgroundColor: TossColors.gray100
textColor: TossColors.gray700

// Chip padding
padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
borderRadius: BorderRadius.circular(20)
```

---

### 2.2 Summary Cards

**Type**: Horizontal ScrollView with 3 cards

**Design:**
```
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│   Revenue   │  │   Margin    │  │  Quantity   │
│   ───────   │  │   ───────   │  │   ───────   │
│   $9.3B     │  │   $7.0B     │  │   1,234     │
│   ▲ 12.5%   │  │   ▲ 15.2%   │  │   ▲ 8.3%   │
│   vs prev   │  │   vs prev   │  │   vs prev   │
└─────────────┘  └─────────────┘  └─────────────┘
```

**Card Structure:**
```dart
TossCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Label
      Text('Revenue', style: TossTextStyles.caption),
      SizedBox(height: 4),
      // Value
      Text('\$9.3B', style: TossTextStyles.h2.copyWith(fontWeight: FontWeight.bold)),
      SizedBox(height: 4),
      // Growth indicator
      Row(
        children: [
          Icon(Icons.arrow_upward, color: TossColors.green500, size: 14),
          Text('12.5%', style: TossTextStyles.caption.copyWith(color: TossColors.green500)),
          Text(' vs prev period', style: TossTextStyles.caption),
        ],
      ),
    ],
  ),
)
```

**Sizing:**
- Card width: 140px (fixed)
- Card height: 100px
- Gap between cards: 12px

---

### 2.3 Time Series Chart

**Type**: fl_chart LineChart

**Design:**
```
┌────────────────────────────────────────────────────┐
│  📈 Revenue Trend                                  │
│  ┌─────────────────────────────────────────────┐  │
│  │ [Revenue] [Margin] [Quantity]  ← SegmentedCtrl │
│  └─────────────────────────────────────────────┘  │
│                                                    │
│  ┌─────────────────────────────────────────────┐  │
│  │ $2M ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │  │
│  │      ●                                      │  │
│  │ $1.5M ─ ─ ─ ●─ ─ ─ ─ ─ ─ ─ ─ ●─ ─ ─ ─ ─ ─ │  │
│  │           ╱ ╲               ╱ ╲             │  │
│  │ $1M ─ ─ ●─ ─ ─●─ ─ ─ ─ ─ ●─ ─ ─●─ ─ ─ ─ ● │  │
│  │       ╱       ╲         ╱       ╲       ╱   │  │
│  │ $0.5M─● ─ ─ ─ ─ ● ─ ─ ● ─ ─ ─ ─ ─● ─ ● ─ ─ │  │
│  │                                             │  │
│  │  W1    W2    W3    W4    W5    W6    W7     │  │
│  └─────────────────────────────────────────────┘  │
│                                                    │
│  Period: Dec 1, 2025 - Jan 9, 2026                │
└────────────────────────────────────────────────────┘
```

**Chart Configuration:**
```dart
LineChartData(
  gridData: FlGridData(
    show: true,
    drawVerticalLine: false,
    horizontalInterval: calculateInterval(maxY),
    getDrawingHorizontalLine: (value) => FlLine(
      color: TossColors.gray200,
      strokeWidth: 1,
      dashArray: [5, 5],
    ),
  ),
  titlesData: FlTitlesData(
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 50,
        getTitlesWidget: (value, meta) => Text(
          formatCompact(value),
          style: TossTextStyles.caption,
        ),
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) => Text(
          formatPeriodLabel(value),
          style: TossTextStyles.caption,
        ),
      ),
    ),
  ),
  borderData: FlBorderData(show: false),
  lineBarsData: [
    LineChartBarData(
      spots: data.map((d) => FlSpot(d.x, d.y)).toList(),
      isCurved: true,
      color: TossColors.blue500,
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 4,
          color: TossColors.white,
          strokeWidth: 2,
          strokeColor: TossColors.blue500,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            TossColors.blue500.withOpacity(0.3),
            TossColors.blue500.withOpacity(0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    ),
  ],
)
```

**Metric Toggle:**
```dart
CupertinoSlidingSegmentedControl<Metric>(
  groupValue: selectedMetric,
  children: {
    Metric.revenue: Text('Revenue'),
    Metric.margin: Text('Margin'),
    Metric.quantity: Text('Quantity'),
  },
  onValueChanged: (value) => setState(() => selectedMetric = value!),
)
```

---

### 2.4 Top 10 Products

**Type**: Expandable List Card

**Design:**
```
┌────────────────────────────────────────────────────┐
│  🏆 Top 10 Products                    [Expand ▼]  │
├────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────┐  │
│  │ 1  샤넬가방                                  │  │
│  │    Chanel Shopping Bag                       │  │
│  │    $25,000,000            ▲ 12.5%           │  │
│  │    ████████████████████░░░░  Revenue share   │  │
│  └──────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────┐  │
│  │ 2  루이비통 네버풀                            │  │
│  │    Louis Vuitton Neverfull                   │  │
│  │    $22,000,000            ▲ 8.3%            │  │
│  │    ██████████████████░░░░░░  Revenue share   │  │
│  └──────────────────────────────────────────────┘  │
│  ... (shows 5 by default, expand for all 10)      │
└────────────────────────────────────────────────────┘
```

**List Item Widget:**
```dart
class TopProductItem extends StatelessWidget {
  final int rank;
  final String productName;
  final String? subtitle;
  final double revenue;
  final double? growthPct;
  final double shareRatio; // 0.0 ~ 1.0

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rank <= 3 ? TossColors.blue50 : TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Rank badge
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _getRankColor(rank),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Product name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName, style: TossTextStyles.body),
                    if (subtitle != null)
                      Text(subtitle!, style: TossTextStyles.caption),
                  ],
                ),
              ),
              // Growth indicator
              if (growthPct != null)
                _buildGrowthBadge(growthPct!),
            ],
          ),
          SizedBox(height: 8),
          // Revenue + Progress bar
          Row(
            children: [
              Text(
                formatCurrency(revenue),
                style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: shareRatio,
                    backgroundColor: TossColors.gray100,
                    valueColor: AlwaysStoppedAnimation(_getRankColor(rank)),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1: return TossColors.gold;
      case 2: return TossColors.silver;
      case 3: return TossColors.bronze;
      default: return TossColors.blue500;
    }
  }
}
```

---

### 2.5 Category Drill-down

**Type**: Breadcrumb + Grid Cards

**Design:**
```
┌────────────────────────────────────────────────────┐
│  📊 Category Analysis                              │
├────────────────────────────────────────────────────┤
│  Breadcrumb: [All] > [Bag] > [Chanel]             │
│              ^^^^^^^^^^^^^ (tappable)             │
├────────────────────────────────────────────────────┤
│  ┌───────────────┐  ┌───────────────┐             │
│  │     Bag       │  │   Jewelry     │             │
│  │   👜 Icon     │  │   💎 Icon     │             │
│  │               │  │               │             │
│  │   $356.4M     │  │   $120.5M     │             │
│  │   45 products │  │   30 products │             │
│  │   ▲ 15.2%     │  │   ▼ 3.1%     │             │
│  └───────────────┘  └───────────────┘             │
│  ┌───────────────┐  ┌───────────────┐             │
│  │    Watch      │  │   Clothing    │             │
│  │   ⌚ Icon     │  │   👔 Icon     │             │
│  │               │  │               │             │
│  │   $89.2M      │  │   $45.8M      │             │
│  │   25 products │  │   60 products │             │
│  │   ▲ 8.5%      │  │   ▲ 2.3%     │             │
│  └───────────────┘  └───────────────┘             │
└────────────────────────────────────────────────────┘
```

**Breadcrumb Widget:**
```dart
class DrillDownBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Row(
            children: [
              GestureDetector(
                onTap: isLast ? null : () => onTap(index),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isLast ? TossColors.blue500 : TossColors.gray100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    item.name,
                    style: TossTextStyles.caption.copyWith(
                      color: isLast ? TossColors.white : TossColors.gray700,
                      fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: TossColors.gray400,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
```

**Category Card:**
```dart
class CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final double revenue;
  final int productCount;
  final double? growthPct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TossCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: TossColors.blue50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: TossColors.blue500, size: 24),
            ),
            SizedBox(height: 12),
            // Name
            Text(
              name,
              style: TossTextStyles.body.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // Revenue
            Text(
              formatCurrency(revenue),
              style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            // Product count
            Text(
              '$productCount products',
              style: TossTextStyles.caption,
            ),
            SizedBox(height: 4),
            // Growth
            if (growthPct != null)
              _buildGrowthBadge(growthPct!),
          ],
        ),
      ),
    );
  }
}
```

---

## 3. Color Tokens

### 3.1 Primary Colors

```dart
// Toss Design System Colors
class TossColors {
  // Primary
  static const blue500 = Color(0xFF3182F6);
  static const blue50 = Color(0xFFE8F3FF);

  // Success/Growth
  static const green500 = Color(0xFF00C853);
  static const green50 = Color(0xFFE8F5E9);

  // Error/Decline
  static const red500 = Color(0xFFFF5252);
  static const red50 = Color(0xFFFFEBEE);

  // Neutral
  static const gray900 = Color(0xFF191F28);
  static const gray700 = Color(0xFF4E5968);
  static const gray500 = Color(0xFF8B95A1);
  static const gray400 = Color(0xFFB0B8C1);
  static const gray200 = Color(0xFFE5E8EB);
  static const gray100 = Color(0xFFF2F4F6);
  static const gray50 = Color(0xFFF9FAFB);
  static const white = Color(0xFFFFFFFF);

  // Rank colors
  static const gold = Color(0xFFFFD700);
  static const silver = Color(0xFFC0C0C0);
  static const bronze = Color(0xFFCD7F32);

  // BCG Quadrant colors (existing)
  static const starColor = Color(0xFFFFF9C4);      // Yellow
  static const cashCowColor = Color(0xFFC8E6C9);   // Green
  static const problemColor = Color(0xFFFFCDD2);   // Red
  static const dogColor = Color(0xFFE0E0E0);       // Gray
}
```

### 3.2 Growth Indicators

```dart
Widget _buildGrowthBadge(double growthPct) {
  final isPositive = growthPct >= 0;
  final color = isPositive ? TossColors.green500 : TossColors.red500;
  final bgColor = isPositive ? TossColors.green50 : TossColors.red50;
  final icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        SizedBox(width: 2),
        Text(
          '${growthPct.abs().toStringAsFixed(1)}%',
          style: TossTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
```

---

## 4. Animation Specifications

### 4.1 Page Transitions

```dart
// Fade + Slide transition for drill-down
PageRouteBuilder(
  pageBuilder: (_, __, ___) => DrillDownPage(),
  transitionsBuilder: (_, animation, __, child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      ),
    );
  },
  transitionDuration: Duration(milliseconds: 300),
)
```

### 4.2 Loading States

```dart
// Shimmer loading for cards
Shimmer.fromColors(
  baseColor: TossColors.gray200,
  highlightColor: TossColors.gray100,
  child: Container(
    width: double.infinity,
    height: 100,
    decoration: BoxDecoration(
      color: TossColors.white,
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

### 4.3 Chart Animations

```dart
// fl_chart animation
LineChart(
  LineChartData(...),
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOutCubic,
)
```

---

## 5. Responsive Layout

### 5.1 Breakpoints

```dart
// Screen sizes
const double kMobileBreakpoint = 600;
const double kTabletBreakpoint = 900;

// Grid columns
int getGridColumns(double width) {
  if (width < kMobileBreakpoint) return 2;
  if (width < kTabletBreakpoint) return 3;
  return 4;
}
```

### 5.2 Summary Cards Layout

```dart
// Mobile: Horizontal scroll
// Tablet: 3-column grid
Widget _buildSummaryCards(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < kMobileBreakpoint) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: summaryCards.map((card) =>
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: SizedBox(width: 140, child: card),
          ),
        ).toList(),
      ),
    );
  }

  return GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    crossAxisSpacing: 12,
    children: summaryCards,
  );
}
```

---

## 6. Interaction Patterns

### 6.1 Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () => ref.read(salesAnalyticsProvider.notifier).loadData(
    companyId: companyId,
    storeId: selectedStoreId,
  ),
  child: ListView(...),
)
```

### 6.2 Chart Touch Interactions

```dart
LineTouchData(
  enabled: true,
  touchTooltipData: LineTouchTooltipData(
    tooltipBgColor: TossColors.gray900,
    tooltipRoundedRadius: 8,
    getTooltipItems: (touchedSpots) {
      return touchedSpots.map((spot) {
        return LineTooltipItem(
          '${formatPeriodLabel(spot.x)}\n${formatCurrency(spot.y)}',
          TossTextStyles.caption.copyWith(color: TossColors.white),
        );
      }).toList();
    },
  ),
  handleBuiltInTouches: true,
)
```

### 6.3 Drill-down Navigation

```dart
// State management for drill-down
class DrillDownState {
  final List<BreadcrumbItem> breadcrumbs;
  final String currentLevel; // 'category', 'brand', 'product'
  final String? parentId;

  DrillDownState({
    this.breadcrumbs = const [BreadcrumbItem(id: null, name: 'All')],
    this.currentLevel = 'category',
    this.parentId,
  });

  DrillDownState drillDown(String id, String name) {
    final nextLevel = currentLevel == 'category' ? 'brand' : 'product';
    return DrillDownState(
      breadcrumbs: [...breadcrumbs, BreadcrumbItem(id: id, name: name)],
      currentLevel: nextLevel,
      parentId: id,
    );
  }

  DrillDownState navigateTo(int index) {
    if (index >= breadcrumbs.length) return this;
    final newBreadcrumbs = breadcrumbs.sublist(0, index + 1);
    final levels = ['category', 'brand', 'product'];
    return DrillDownState(
      breadcrumbs: newBreadcrumbs,
      currentLevel: levels[index],
      parentId: newBreadcrumbs.last.id,
    );
  }
}
```

---

## 7. Accessibility

### 7.1 Semantic Labels

```dart
Semantics(
  label: 'Revenue: \$9.3 billion, increased by 12.5% compared to previous period',
  child: SummaryCard(...),
)

Semantics(
  label: 'Rank 1, Chanel Shopping Bag, Revenue \$25 million, growth 12.5%',
  child: TopProductItem(...),
)
```

### 7.2 Touch Targets

```dart
// Minimum touch target: 48x48
GestureDetector(
  child: Container(
    constraints: BoxConstraints(minWidth: 48, minHeight: 48),
    child: chip,
  ),
)
```

---

## 8. File Structure

```
lib/features/inventory_analysis/
├── domain/
│   └── entities/
│       └── sales_analytics.dart        # Entities (TimeRange, Metric, etc.)
├── data/
│   ├── models/
│   │   └── sales_analytics_model.dart  # JSON serialization
│   └── repositories/
│       └── sales_analytics_repository.dart
├── presentation/
│   ├── providers/
│   │   └── sales_analytics_provider.dart
│   ├── pages/
│   │   └── sales_analytics_page.dart   # Main page (or extend sales_dashboard_page.dart)
│   └── widgets/
│       ├── time_range_selector.dart
│       ├── summary_cards.dart
│       ├── time_series_chart.dart
│       ├── top_products_list.dart
│       ├── drill_down_section.dart
│       └── drill_down_breadcrumb.dart
```

---

## 9. Implementation Checklist

### Phase 1: Data Layer
- [ ] Create `sales_analytics.dart` entity
- [ ] Create `sales_analytics_model.dart` model
- [ ] Create `sales_analytics_repository.dart`
- [ ] Run build_runner for freezed/json_serializable

### Phase 2: State Management
- [ ] Create `sales_analytics_provider.dart`
- [ ] Implement `TimeRange` state management
- [ ] Implement `DrillDown` state management
- [ ] Add error handling

### Phase 3: UI Components
- [ ] `TimeRangeSelector` widget
- [ ] `SummaryCards` widget
- [ ] `TimeSeriesChart` widget
- [ ] `TopProductsList` widget
- [ ] `DrillDownSection` widget
- [ ] `DrillDownBreadcrumb` widget

### Phase 4: Page Integration
- [ ] Create new page or extend `sales_dashboard_page.dart`
- [ ] Wire up providers
- [ ] Add loading states
- [ ] Add error states
- [ ] Add pull-to-refresh

### Phase 5: Testing
- [ ] Unit tests for repository
- [ ] Unit tests for providers
- [ ] Widget tests for components
- [ ] Integration test for full flow

---

**Document Created**: 2026-01-09
**Design System**: Toss Design System
**Target Platform**: Flutter (iOS/Android)
