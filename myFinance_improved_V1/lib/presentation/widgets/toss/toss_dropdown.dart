import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

/// Toss-style dropdown with bottom sheet selection
class TossDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<TossDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final String? errorText;
  final bool isLoading;

  const TossDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.errorText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (only show if not empty)
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: hasError ? TossColors.error : TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
        ],
        
        // Dropdown Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            color: Colors.white,
            border: Border.all(
              color: hasError
                ? TossColors.error
                : value != null 
                  ? TossColors.primary
                  : TossColors.gray200,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading || onChanged == null 
                ? null 
                : () => _showSelectionBottomSheet(context),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              child: Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                child: Row(
                  children: [
                    
                    // Selected value or hint
                    Expanded(
                      child: isLoading
                        ? _buildLoadingIndicator(context)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                value != null 
                                  ? items.where((item) => item.value == value).isNotEmpty
                                    ? items.firstWhere((item) => item.value == value).label
                                    : 'Invalid selection'
                                  : hint ?? 'Select $label',
                                style: TossTextStyles.body.copyWith(
                                  color: value != null
                                    ? TossColors.gray900
                                    : TossColors.gray400,
                                  fontWeight: value != null ? FontWeight.w600 : FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              // Remove subtitle display in main field for cleaner look
                            ],
                          ),
                    ),
                    
                    // Dropdown icon
                    Icon(
                      Icons.arrow_drop_down,
                      color: TossColors.gray600,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Error text
        if (hasError) ...[
          SizedBox(height: TossSpacing.space1),
          Text(
            errorText!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildLoadingIndicator(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizedBox(width: TossSpacing.space2),
        Text(
          'Loading...',
          style: TossTextStyles.caption.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
  
  void _showSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          minHeight: 200,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            
            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TossTextStyles.h3.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${items.length} ${items.length == 1 ? 'option' : 'options'} available',
                        style: TossTextStyles.caption.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Options
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item.value == value;
                  
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected 
                        ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                        : Colors.transparent,
                      border: isSelected 
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            width: 1,
                          )
                        : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          onChanged?.call(item.value);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space3,
                            vertical: TossSpacing.space3,
                          ),
                          child: Row(
                            children: [
                              
                              // Option content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.label,
                                      style: TossTextStyles.body.copyWith(
                                        color: isSelected
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.onSurface,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (item.subtitle != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        item.subtitle!,
                                        style: TossTextStyles.caption.copyWith(
                                          color: isSelected
                                            ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                                            : Theme.of(context).colorScheme.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              
                              // Check icon if selected
                              if (isSelected)
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dropdown item with label and optional subtitle
class TossDropdownItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  
  const TossDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
  });
}