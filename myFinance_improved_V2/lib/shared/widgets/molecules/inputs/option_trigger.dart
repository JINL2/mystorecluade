import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// A reusable trigger button molecule for option selection
///
/// Displays a label, selected value text, and a chevron icon.
/// Can be used standalone or paired with bottom sheets for selection.
///
/// ## Example Usage:
/// ```dart
/// OptionTrigger(
///   label: 'Cash Location',
///   displayText: selectedLocation?.name ?? 'Select Cash Location',
///   onTap: () => showLocationBottomSheet(),
/// )
/// ```
class OptionTrigger extends StatelessWidget {
  /// The label displayed above the trigger field
  final String label;

  /// The text displayed inside the trigger (selected value or hint)
  final String displayText;

  /// Callback when the trigger is tapped
  final VoidCallback? onTap;

  /// Whether to show loading state
  final bool isLoading;

  /// Whether the field has an error
  final bool hasError;

  /// Error message to display below the field
  final String? errorText;

  /// Whether this field is required (shows asterisk)
  final bool isRequired;

  /// Whether the field is disabled
  final bool isDisabled;

  /// Whether a value has been selected (affects text styling)
  final bool hasSelection;

  // Constants
  static const double _iconSize = TossSpacing.iconMD;

  const OptionTrigger({
    super.key,
    required this.label,
    required this.displayText,
    this.onTap,
    this.isLoading = false,
    this.hasError = false,
    this.errorText,
    this.isRequired = false,
    this.isDisabled = false,
    this.hasSelection = false,
  });

  @override
  Widget build(BuildContext context) {
    final showError = hasError || (errorText != null && errorText!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (label.isNotEmpty) ...[
          _buildLabel(showError),
          const SizedBox(height: TossSpacing.space2),
        ],

        // Trigger Field
        _buildTriggerField(showError),

        // Error Text
        if (showError && errorText != null) ...[
          const SizedBox(height: TossSpacing.space1),
          _buildErrorText(),
        ],
      ],
    );
  }

  Widget _buildLabel(bool showError) {
    return Row(
      children: [
        Text(
          label,
          style: TossTextStyles.smallSectionTitle,
        ),
        if (isRequired) ...[
          SizedBox(width: TossSpacing.space1 / 2),
          Text(
            '*',
            style: TossTextStyles.smallSectionTitle.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTriggerField(bool showError) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        color: isDisabled ? TossColors.gray100 : TossColors.surface,
        border: Border.all(
          color: showError ? TossColors.error : TossColors.border,
          width: showError ? 2 : 1,
        ),
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: _canTap ? onTap : null,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            child: Row(
              children: [
                // Display text or loading indicator
                Expanded(
                  child: isLoading ? _buildLoadingIndicator() : _buildDisplayText(),
                ),

                // Chevron icon
                Icon(
                  LucideIcons.chevronDown,
                  color: isDisabled ? TossColors.gray400 : TossColors.gray700,
                  size: _iconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayText() {
    return Text(
      displayText,
      style: TossTextStyles.bodyLarge.copyWith(
        color: _getTextColor(),
        fontWeight: hasSelection ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Row(
      children: [
        SizedBox(
          width: TossSpacing.iconSM2,
          height: TossSpacing.iconSM2,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          'Loading...',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorText() {
    return Text(
      errorText!,
      style: TossTextStyles.caption.copyWith(
        color: TossColors.error,
      ),
    );
  }

  bool get _canTap => !isLoading && !isDisabled && onTap != null;

  Color _getTextColor() {
    if (isDisabled) return TossColors.textTertiary;
    return hasSelection ? TossColors.textPrimary : TossColors.textTertiary;
  }
}
