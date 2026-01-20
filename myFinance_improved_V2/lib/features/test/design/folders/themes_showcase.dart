/// Themes Showcase
///
/// Displays all theme-related constants from shared/themes folder.
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

class ThemesShowcase extends StatefulWidget {
  const ThemesShowcase({super.key});

  @override
  State<ThemesShowcase> createState() => _ThemesShowcaseState();
}

class _ThemesShowcaseState extends State<ThemesShowcase>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'Colors',
    'Spacing',
    'Typography',
    'Border Radius',
    'Shadows',
    'Icons',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: TossColors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: TossColors.primary,
            unselectedLabelColor: TossColors.gray600,
            indicatorColor: TossColors.primary,
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _ColorsTab(),
              _SpacingTab(),
              _TypographyTab(),
              _BorderRadiusTab(),
              _ShadowsTab(),
              _IconsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Colors Tab ====================
class _ColorsTab extends StatelessWidget {
  const _ColorsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildSection('Brand Colors', [
          _ColorItem('primary', TossColors.primary, 'Brand Blue'),
          _ColorItem('primarySurface', TossColors.primarySurface, 'Accent Blue'),
        ]),
        _buildSection('The Simple 4 Grays', [
          _ColorItem('white', TossColors.white, 'Background'),
          _ColorItem('gray100 (borderGray)', TossColors.gray100, '⚠️ BORDER ONLY'),
          _ColorItem('gray200 (lightGray)', TossColors.gray200, 'Light BG/Fills'),
          _ColorItem('gray600 (darkGray)', TossColors.gray600, 'Secondary Text'),
          _ColorItem('gray900 (charcoal)', TossColors.gray900, 'Main Text'),
          _ColorItem('black', TossColors.black, 'Pure Black'),
        ]),
        _buildSection('Semantic Colors', [
          _ColorItem('success', TossColors.success, 'Pastel Green'),
          _ColorItem('successLight', TossColors.successLight, 'Success BG'),
          _ColorItem('error', TossColors.error, 'Danger Red'),
          _ColorItem('errorLight', TossColors.errorLight, 'Error BG'),
        ]),
        _buildSection('Financial Colors', [
          _ColorItem('profit', TossColors.profit, 'Dark Green'),
          _ColorItem('loss', TossColors.loss, 'Red'),
        ]),
        _buildSection('Text Colors', [
          _ColorItem('textPrimary', TossColors.textPrimary, 'Charcoal'),
          _ColorItem('textSecondary', TossColors.textSecondary, 'Cool Grey'),
          _ColorItem('textInverse', TossColors.textInverse, 'White'),
        ]),
        _buildSection('Extended (Charts)', [
          _ColorItem('purple', TossColors.purple, 'Purple'),
          _ColorItem('amber', TossColors.amber, 'Amber'),
          _ColorItem('teal', TossColors.teal, 'Teal'),
        ]),
      ],
    );
  }

  Widget _buildSection(String title, List<_ColorItem> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          child: Text(
            title,
            style: TossTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          spacing: TossSpacing.space3,
          runSpacing: TossSpacing.space3,
          children: colors.map((item) => _buildColorCard(item)).toList(),
        ),
        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildColorCard(_ColorItem item) {
    final hexColor =
        '#${item.color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(TossBorderRadius.md - 1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TossTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  hexColor,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    fontFamily: 'monospace',
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorItem {
  final String name;
  final Color color;
  final String description;
  _ColorItem(this.name, this.color, this.description);
}

// ==================== Spacing Tab ====================
class _SpacingTab extends StatelessWidget {
  const _SpacingTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildSection('Base Spacing (4px grid)', [
          _SpacingItem('space0', TossSpacing.space0),
          _SpacingItem('space1', TossSpacing.space1),
          _SpacingItem('space2', TossSpacing.space2),
          _SpacingItem('space3', TossSpacing.space3),
          _SpacingItem('space4', TossSpacing.space4),
          _SpacingItem('space5', TossSpacing.space5),
          _SpacingItem('space6', TossSpacing.space6),
          _SpacingItem('space8', TossSpacing.space8),
          _SpacingItem('space10', TossSpacing.space10),
          _SpacingItem('space12', TossSpacing.space12),
          _SpacingItem('space16', TossSpacing.space16),
          _SpacingItem('space20', TossSpacing.space20),
        ]),
        _buildSection('Component Padding', [
          _SpacingItem('paddingXS', TossSpacing.paddingXS),
          _SpacingItem('paddingSM', TossSpacing.paddingSM),
          _SpacingItem('paddingMD', TossSpacing.paddingMD),
          _SpacingItem('paddingLG', TossSpacing.paddingLG),
          _SpacingItem('paddingXL', TossSpacing.paddingXL),
        ]),
        _buildSection('Icon Sizes', [
          _SpacingItem('iconXS', TossSpacing.iconXS),
          _SpacingItem('iconSM', TossSpacing.iconSM),
          _SpacingItem('iconMD', TossSpacing.iconMD),
          _SpacingItem('iconLG', TossSpacing.iconLG),
          _SpacingItem('iconXL', TossSpacing.iconXL),
        ]),
        _buildSection('Button Heights', [
          _SpacingItem('buttonHeightSM', TossSpacing.buttonHeightSM),
          _SpacingItem('buttonHeightMD', TossSpacing.buttonHeightMD),
          _SpacingItem('buttonHeightLG', TossSpacing.buttonHeightLG),
          _SpacingItem('buttonHeightXL', TossSpacing.buttonHeightXL),
        ]),
      ],
    );
  }

  Widget _buildSection(String title, List<_SpacingItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          child: Text(
            title,
            style: TossTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map((item) => _buildSpacingRow(item)),
        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildSpacingRow(_SpacingItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              item.name,
              style: TossTextStyles.labelSmall.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ),
          Text(
            '${item.value.toInt()}px',
            style: TossTextStyles.labelSmall.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Container(
              height: 20,
              alignment: Alignment.centerLeft,
              child: Container(
                width: item.value,
                height: 16,
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpacingItem {
  final String name;
  final double value;
  _SpacingItem(this.name, this.value);
}

// ==================== Typography Tab ====================
class _TypographyTab extends StatelessWidget {
  const _TypographyTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildSection('Headings', [
          _TypoItem('display', TossTextStyles.display),
          _TypoItem('h1', TossTextStyles.h1),
          _TypoItem('h2', TossTextStyles.h2),
          _TypoItem('h3', TossTextStyles.h3),
          _TypoItem('h4', TossTextStyles.h4),
        ]),
        _buildSection('Titles', [
          _TypoItem('titleLarge', TossTextStyles.titleLarge),
          _TypoItem('titleMedium', TossTextStyles.titleMedium),
          _TypoItem('subtitle', TossTextStyles.subtitle),
        ]),
        _buildSection('Body', [
          _TypoItem('body', TossTextStyles.body),
          _TypoItem('bodyLarge', TossTextStyles.bodyLarge),
          _TypoItem('bodyMedium', TossTextStyles.bodyMedium),
          _TypoItem('bodySmall', TossTextStyles.bodySmall),
        ]),
        _buildSection('Labels & Captions', [
          _TypoItem('label', TossTextStyles.label),
          _TypoItem('labelSmall', TossTextStyles.labelSmall),
          _TypoItem('caption', TossTextStyles.caption),
          _TypoItem('small', TossTextStyles.small),
        ]),
        _buildSection('Special', [
          _TypoItem('button', TossTextStyles.button),
          _TypoItem('amount', TossTextStyles.amount),
          _TypoItem('sheetTitle', TossTextStyles.sheetTitle),
          _TypoItem('linkText', TossTextStyles.linkText),
        ]),
      ],
    );
  }

  Widget _buildSection(String title, List<_TypoItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          child: Text(
            title,
            style: TossTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: items
                .asMap()
                .entries
                .map((entry) => _buildTypoRow(entry.value, entry.key == items.length - 1))
                .toList(),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  String _getFontWeightName(FontWeight? weight) {
    if (weight == null) return 'normal';
    switch (weight) {
      case FontWeight.w100: return 'w100';
      case FontWeight.w200: return 'w200';
      case FontWeight.w300: return 'w300';
      case FontWeight.w400: return 'w400';
      case FontWeight.w500: return 'w500';
      case FontWeight.w600: return 'w600';
      case FontWeight.w700: return 'w700';
      case FontWeight.w800: return 'w800';
      case FontWeight.w900: return 'w900';
      default: return 'normal';
    }
  }

  Widget _buildTypoRow(_TypoItem item, bool isLast) {
    final fontSize = item.style.fontSize?.toInt() ?? 14;
    final fontWeight = _getFontWeightName(item.style.fontWeight);

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: TossColors.gray100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TossTextStyles.labelSmall.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${fontSize}px • $fontWeight',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              'The quick brown fox',
              style: item.style,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypoItem {
  final String name;
  final TextStyle style;
  _TypoItem(this.name, this.style);
}

// ==================== Border Radius Tab ====================
class _BorderRadiusTab extends StatelessWidget {
  const _BorderRadiusTab();

  @override
  Widget build(BuildContext context) {
    final items = [
      _RadiusItem('none', TossBorderRadius.none),
      _RadiusItem('xs', TossBorderRadius.xs),
      _RadiusItem('sm', TossBorderRadius.sm),
      _RadiusItem('md', TossBorderRadius.md),
      _RadiusItem('lg', TossBorderRadius.lg),
      _RadiusItem('xl', TossBorderRadius.xl),
      _RadiusItem('xxl', TossBorderRadius.xxl),
      _RadiusItem('full', TossBorderRadius.full),
    ];

    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        Text(
          'Border Radius',
          style: TossTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        Wrap(
          spacing: TossSpacing.space4,
          runSpacing: TossSpacing.space4,
          children: items.map((item) => _buildRadiusCard(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildRadiusCard(_RadiusItem item) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(item.value),
              border: Border.all(color: TossColors.primary, width: 2),
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            item.name,
            style: TossTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${item.value.toInt()}px',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadiusItem {
  final String name;
  final double value;
  _RadiusItem(this.name, this.value);
}

// ==================== Shadows Tab ====================
class _ShadowsTab extends StatelessWidget {
  const _ShadowsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        Text(
          'Box Shadows',
          style: TossTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        Wrap(
          spacing: TossSpacing.space6,
          runSpacing: TossSpacing.space6,
          children: [
            _buildShadowCard('none', TossShadows.none),
            _buildShadowCard('elevation1', TossShadows.elevation1),
            _buildShadowCard('elevation2', TossShadows.elevation2),
            _buildShadowCard('elevation3', TossShadows.elevation3),
            _buildShadowCard('elevation4', TossShadows.elevation4),
            _buildShadowCard('card', TossShadows.card),
            _buildShadowCard('fab', TossShadows.fab),
            _buildShadowCard('dropdown', TossShadows.dropdown),
          ],
        ),
      ],
    );
  }

  Widget _buildShadowCard(String name, List<BoxShadow> shadow) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: shadow,
      ),
      child: Column(
        children: [
          const SizedBox(height: TossSpacing.space6),
          Text(
            name,
            style: TossTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'TossShadows.$name',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
  }
}

// ==================== Icons Tab ====================
class _IconsTab extends StatelessWidget {
  const _IconsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildSection('Lucide Icons', 'LucideIcons.xxx', _lucideIcons),
        _buildSection('Material Icons (Common)', 'Icons.xxx', _materialIcons),
      ],
    );
  }

  Widget _buildSection(String title, String usage, List<_IconItem> icons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TossTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Usage: $usage',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: icons.map((icon) => _buildIconCard(icon)).toList(),
        ),
        const SizedBox(height: TossSpacing.space6),
      ],
    );
  }

  Widget _buildIconCard(_IconItem item) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 24, color: TossColors.textPrimary),
          const SizedBox(height: TossSpacing.space1),
          Text(
            item.name,
            style: TossTextStyles.caption.copyWith(
              fontSize: 9,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Lucide Icons - commonly used
  static final List<_IconItem> _lucideIcons = [
    // Navigation
    _IconItem('home', LucideIcons.home),
    _IconItem('arrowLeft', LucideIcons.arrowLeft),
    _IconItem('arrowRight', LucideIcons.arrowRight),
    _IconItem('chevronDown', LucideIcons.chevronDown),
    _IconItem('chevronUp', LucideIcons.chevronUp),
    _IconItem('chevronLeft', LucideIcons.chevronLeft),
    _IconItem('chevronRight', LucideIcons.chevronRight),
    _IconItem('menu', LucideIcons.menu),
    _IconItem('x', LucideIcons.x),
    // Actions
    _IconItem('plus', LucideIcons.plus),
    _IconItem('minus', LucideIcons.minus),
    _IconItem('edit', LucideIcons.edit),
    _IconItem('trash2', LucideIcons.trash2),
    _IconItem('save', LucideIcons.save),
    _IconItem('copy', LucideIcons.copy),
    _IconItem('check', LucideIcons.check),
    _IconItem('search', LucideIcons.search),
    _IconItem('filter', LucideIcons.filter),
    _IconItem('download', LucideIcons.download),
    _IconItem('upload', LucideIcons.upload),
    _IconItem('share', LucideIcons.share),
    _IconItem('refresh', LucideIcons.refreshCw),
    // User & Account
    _IconItem('user', LucideIcons.user),
    _IconItem('users', LucideIcons.users),
    _IconItem('settings', LucideIcons.settings),
    _IconItem('logOut', LucideIcons.logOut),
    _IconItem('logIn', LucideIcons.logIn),
    // Finance
    _IconItem('wallet', LucideIcons.wallet),
    _IconItem('creditCard', LucideIcons.creditCard),
    _IconItem('dollarSign', LucideIcons.dollarSign),
    _IconItem('trendUp', LucideIcons.trendingUp),
    _IconItem('trendDown', LucideIcons.trendingDown),
    _IconItem('receipt', LucideIcons.receipt),
    _IconItem('calculator', LucideIcons.calculator),
    _IconItem('banknote', LucideIcons.banknote),
    _IconItem('coins', LucideIcons.coins),
    // Communication
    _IconItem('bell', LucideIcons.bell),
    _IconItem('mail', LucideIcons.mail),
    _IconItem('messageSquare', LucideIcons.messageSquare),
    _IconItem('phone', LucideIcons.phone),
    // Data & Content
    _IconItem('file', LucideIcons.file),
    _IconItem('fileText', LucideIcons.fileText),
    _IconItem('folder', LucideIcons.folder),
    _IconItem('image', LucideIcons.image),
    _IconItem('calendar', LucideIcons.calendar),
    _IconItem('clock', LucideIcons.clock),
    _IconItem('barChart', LucideIcons.barChart2),
    _IconItem('pieChart', LucideIcons.pieChart),
    // Status
    _IconItem('alertCircle', LucideIcons.alertCircle),
    _IconItem('alertTriangle', LucideIcons.alertTriangle),
    _IconItem('info', LucideIcons.info),
    _IconItem('checkCircle', LucideIcons.checkCircle),
    _IconItem('xCircle', LucideIcons.xCircle),
    _IconItem('helpCircle', LucideIcons.helpCircle),
    // Misc
    _IconItem('star', LucideIcons.star),
    _IconItem('heart', LucideIcons.heart),
    _IconItem('eye', LucideIcons.eye),
    _IconItem('eyeOff', LucideIcons.eyeOff),
    _IconItem('lock', LucideIcons.lock),
    _IconItem('unlock', LucideIcons.unlock),
    _IconItem('moreVertical', LucideIcons.moreVertical),
    _IconItem('moreHorizontal', LucideIcons.moreHorizontal),
    _IconItem('externalLink', LucideIcons.externalLink),
    _IconItem('link', LucideIcons.link),
    _IconItem('qrCode', LucideIcons.qrCode),
    _IconItem('scan', LucideIcons.scan),
  ];

  // Material Icons - commonly used
  static final List<_IconItem> _materialIcons = [
    _IconItem('home', Icons.home),
    _IconItem('arrow_back', Icons.arrow_back),
    _IconItem('arrow_forward', Icons.arrow_forward),
    _IconItem('close', Icons.close),
    _IconItem('add', Icons.add),
    _IconItem('remove', Icons.remove),
    _IconItem('edit', Icons.edit),
    _IconItem('delete', Icons.delete),
    _IconItem('save', Icons.save),
    _IconItem('check', Icons.check),
    _IconItem('search', Icons.search),
    _IconItem('settings', Icons.settings),
    _IconItem('person', Icons.person),
    _IconItem('notifications', Icons.notifications),
    _IconItem('more_vert', Icons.more_vert),
    _IconItem('more_horiz', Icons.more_horiz),
    _IconItem('visibility', Icons.visibility),
    _IconItem('visibility_off', Icons.visibility_off),
  ];
}

class _IconItem {
  final String name;
  final IconData icon;
  _IconItem(this.name, this.icon);
}
