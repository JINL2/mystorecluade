# Toss-Style Component Library

## Core Toss Components

### 1. TossBottomSheet
Toss's signature action sheets with smooth animations.

```dart
// lib/presentation/widgets/toss/toss_bottom_sheet.dart

class TossBottomSheet extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<TossActionItem>? actions;
  final bool showHandle;
  
  const TossBottomSheet({
    this.title,
    required this.content,
    this.actions,
    this.showHandle = true,
  });
  
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<TossActionItem>? actions,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TossBottomSheet(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xxl),
          topRight: Radius.circular(TossBorderRadius.xxl),
        ),
        boxShadow: TossShadows.bottomSheetShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            SizedBox(height: TossSpacing.space3),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
          if (title != null) ...[
            SizedBox(height: TossSpacing.space5),
            Text(
              title!,
              style: TossTextStyles.h3,
              textAlign: TextAlign.center,
            ),
          ],
          Padding(
            padding: EdgeInsets.all(TossSpacing.space5),
            child: content,
          ),
          if (actions != null) ...[
            Divider(color: TossColors.gray200, height: 1),
            ...actions!.map((action) => _buildActionItem(context, action)),
          ],
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
  
  Widget _buildActionItem(BuildContext context, TossActionItem action) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        action.onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        child: Row(
          children: [
            if (action.icon != null) ...[
              Icon(
                action.icon,
                size: 24,
                color: action.isDestructive ? TossColors.error : TossColors.gray700,
              ),
              SizedBox(width: TossSpacing.space4),
            ],
            Expanded(
              child: Text(
                action.title,
                style: TossTextStyles.body.copyWith(
                  color: action.isDestructive ? TossColors.error : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: TossColors.gray400,
            ),
          ],
        ),
      ),
    );
  }
}

class TossActionItem {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isDestructive;
  
  const TossActionItem({
    required this.title,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
  });
}
```

### 2. TossAmountInput
Beautiful amount input with animations.

```dart
// lib/presentation/widgets/toss/toss_amount_input.dart

class TossAmountInput extends StatefulWidget {
  final TextEditingController controller;
  final String currency;
  final String? label;
  final Function(double)? onChanged;
  
  const TossAmountInput({
    required this.controller,
    this.currency = '원',
    this.label,
    this.onChanged,
  });
  
  @override
  State<TossAmountInput> createState() => _TossAmountInputState();
}

class _TossAmountInputState extends State<TossAmountInput> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final FocusNode _focusNode = FocusNode();
  bool _hasValue = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    widget.controller.addListener(_onValueChanged);
    _focusNode.addListener(_onFocusChanged);
  }
  
  void _onValueChanged() {
    final hasValue = widget.controller.text.isNotEmpty && 
                     widget.controller.text != '0';
    if (hasValue != _hasValue) {
      setState(() {
        _hasValue = hasValue;
      });
      
      if (hasValue) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
    
    if (widget.onChanged != null) {
      final value = double.tryParse(
        widget.controller.text.replaceAll(',', '')
      ) ?? 0;
      widget.onChanged!(value);
    }
  }
  
  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TossTextStyles.h2,
          ),
          SizedBox(height: TossSpacing.space4),
        ],
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TossTextStyles.display.copyWith(
                      color: _hasValue ? TossColors.gray900 : TossColors.gray300,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TossTextStyles.display.copyWith(
                        color: TossColors.gray300,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ThousandsSeparatorInputFormatter(),
                    ],
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  style: TossTextStyles.h1.copyWith(
                    color: _hasValue ? TossColors.gray700 : TossColors.gray400,
                  ),
                  child: Text(widget.currency),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: TossSpacing.space3),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: 2,
          decoration: BoxDecoration(
            color: _focusNode.hasFocus 
                ? TossColors.primary 
                : TossColors.gray200,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    widget.controller.removeListener(_onValueChanged);
    super.dispose();
  }
}
```

### 3. TossCard
Interactive card with micro-animations.

```dart
// lib/presentation/widgets/toss/toss_card.dart

class TossCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double borderRadius;
  
  const TossCard({
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius = 16.0,
  });
  
  @override
  State<TossCard> createState() => _TossCardState();
}

class _TossCardState extends State<TossCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _shadowAnimation = Tween<double>(
      begin: 0.08,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onTap != null ? (_) => _controller.reverse() : null,
      onTapCancel: widget.onTap != null ? () => _controller.reverse() : null,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: widget.padding ?? EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, _shadowAnimation.value),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 4. TossTransactionItem
Beautiful transaction list item.

```dart
// lib/presentation/widgets/toss/toss_transaction_item.dart

class TossTransactionItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final Widget? leading;
  final VoidCallback? onTap;
  
  const TossTransactionItem({
    required this.title,
    this.subtitle,
    required this.amount,
    required this.date,
    required this.type,
    this.leading,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final isIncome = type == TransactionType.income;
    final amountColor = isIncome ? TossColors.profit : TossColors.gray900;
    final amountSign = isIncome ? '+' : '-';
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Center(child: leading),
              ),
              SizedBox(width: TossSpacing.space4),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      subtitle!,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$amountSign${NumberFormat('#,###').format(amount.abs())}원',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: amountColor,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  DateFormat('MM.dd').format(date),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### 5. TossPrimaryButton
Large CTA button with loading state.

```dart
// lib/presentation/widgets/toss/toss_primary_button.dart

class TossPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  
  const TossPrimaryButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
  });
  
  @override
  State<TossPrimaryButton> createState() => _TossPrimaryButtonState();
}

class _TossPrimaryButtonState extends State<TossPrimaryButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  bool get _isDisabled => !widget.isEnabled || widget.isLoading;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: !_isDisabled ? (_) => _controller.forward() : null,
      onTapUp: !_isDisabled ? (_) => _controller.reverse() : null,
      onTapCancel: !_isDisabled ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isDisabled ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isDisabled 
                    ? TossColors.gray200 
                    : TossColors.primary,
                foregroundColor: _isDisabled 
                    ? TossColors.gray400 
                    : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.leadingIcon != null) ...[
                          widget.leadingIcon!,
                          SizedBox(width: TossSpacing.space2),
                        ],
                        Text(
                          widget.text,
                          style: TossTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _isDisabled 
                                ? TossColors.gray400 
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 6. TossInfoCard
Information display card.

```dart
// lib/presentation/widgets/toss/toss_info_card.dart

class TossInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  
  const TossInfoCard({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return TossCard(
      onTap: onTap,
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (iconColor ?? TossColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? TossColors.primary,
                ),
              ),
            ),
            SizedBox(width: TossSpacing.space4),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  value,
                  style: TossTextStyles.h3,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    subtitle!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
          if (onTap != null && trailing == null)
            Icon(
              Icons.chevron_right,
              size: 20,
              color: TossColors.gray400,
            ),
        ],
      ),
    );
  }
}
```

### 7. TossSegmentedControl
Beautiful segmented control.

```dart
// lib/presentation/widgets/toss/toss_segmented_control.dart

class TossSegmentedControl<T> extends StatefulWidget {
  final List<TossSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;
  
  const TossSegmentedControl({
    required this.segments,
    required this.value,
    required this.onChanged,
  });
  
  @override
  State<TossSegmentedControl<T>> createState() => 
      _TossSegmentedControlState<T>();
}

class _TossSegmentedControlState<T> extends State<TossSegmentedControl<T>> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.segments.indexWhere(
      (segment) => segment.value == widget.value,
    );
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: _selectedIndex.toDouble(),
      end: _selectedIndex.toDouble(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }
  
  void _onSegmentTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _slideAnimation = Tween<double>(
          begin: _selectedIndex.toDouble(),
          end: index.toDouble(),
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ));
        _selectedIndex = index;
      });
      _animationController.forward(from: 0);
      widget.onChanged(widget.segments[index].value);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = 
              (constraints.maxWidth - 4) / widget.segments.length;
          
          return Stack(
            children: [
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) => Positioned(
                  left: _slideAnimation.value * segmentWidth + 2,
                  top: 0,
                  bottom: 0,
                  width: segmentWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      boxShadow: TossShadows.shadow1,
                    ),
                  ),
                ),
              ),
              Row(
                children: widget.segments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final segment = entry.value;
                  final isSelected = index == _selectedIndex;
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onSegmentTapped(index),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 200),
                          style: TossTextStyles.label.copyWith(
                            color: isSelected 
                                ? TossColors.gray900 
                                : TossColors.gray500,
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.w500,
                          ),
                          child: Text(segment.label),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class TossSegment<T> {
  final String label;
  final T value;
  
  const TossSegment({
    required this.label,
    required this.value,
  });
}
```

## Usage Examples

### Transaction List Screen
```dart
class TransactionListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: Text('거래 내역', style: TossTextStyles.h2),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Summary Card
          Padding(
            padding: EdgeInsets.all(TossSpacing.space5),
            child: TossInfoCard(
              title: '이번 달 지출',
              value: '₩1,234,560',
              subtitle: '지난달 대비 12% 감소',
              icon: Icons.trending_down,
              iconColor: TossColors.profit,
            ),
          ),
          
          // Segmented Control
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: TossSegmentedControl<String>(
              segments: [
                TossSegment(label: '전체', value: 'all'),
                TossSegment(label: '수입', value: 'income'),
                TossSegment(label: '지출', value: 'expense'),
              ],
              value: 'all',
              onChanged: (value) {
                // Handle change
              },
            ),
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Transaction List
          ...transactions.map((transaction) => TossTransactionItem(
            title: transaction.title,
            subtitle: transaction.category,
            amount: transaction.amount,
            date: transaction.date,
            type: transaction.type,
            leading: Icon(
              transaction.icon,
              color: TossColors.gray600,
            ),
            onTap: () {
              // Show detail
            },
          )),
        ],
      ),
    );
  }
}
```

### Send Money Screen
```dart
class SendMoneyScreen extends StatefulWidget {
  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _amountController = TextEditingController();
  bool _isButtonEnabled = false;
  
  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      final hasValue = _amountController.text.isNotEmpty && 
                       _amountController.text != '0';
      if (hasValue != _isButtonEnabled) {
        setState(() {
          _isButtonEnabled = hasValue;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('송금하기', style: TossTextStyles.h3),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(TossSpacing.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TossCard(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: TossColors.gray100,
                            child: Icon(Icons.person, color: TossColors.gray600),
                          ),
                          SizedBox(width: TossSpacing.space3),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '김토스',
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '토스뱅크 1234-5678',
                                style: TossTextStyles.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space8),
                    
                    TossAmountInput(
                      controller: _amountController,
                      label: '얼마를 보낼까요?',
                      currency: '원',
                    ),
                    
                    SizedBox(height: TossSpacing.space4),
                    
                    // Quick amount buttons
                    Wrap(
                      spacing: TossSpacing.space2,
                      children: [
                        '+1만', '+5만', '+10만', '전액'
                      ].map((amount) => 
                        OutlinedButton(
                          onPressed: () {
                            // Add amount
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: TossColors.gray300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                TossBorderRadius.sm,
                              ),
                            ),
                          ),
                          child: Text(
                            amount,
                            style: TossTextStyles.label.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(TossSpacing.space5),
              child: TossPrimaryButton(
                text: '다음',
                isEnabled: _isButtonEnabled,
                onPressed: () {
                  // Continue to next step
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```