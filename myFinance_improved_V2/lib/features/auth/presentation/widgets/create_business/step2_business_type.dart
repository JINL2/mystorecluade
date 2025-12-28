import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/value_objects/company_type.dart';

/// Step 2: Business Type Selection
///
/// Second step where user selects the type of business.
/// Supports predefined types and custom "Others" option.
class Step2BusinessType extends StatelessWidget {
  final List<CompanyType> companyTypes;
  final String? selectedTypeId;
  final bool isCustomTypeSelected;
  final TextEditingController customTypeController;
  final FocusNode customTypeFocusNode;
  final ValueChanged<String?> onTypeSelected;
  final ValueChanged<bool> onCustomTypeToggled;

  const Step2BusinessType({
    super.key,
    required this.companyTypes,
    required this.selectedTypeId,
    required this.isCustomTypeSelected,
    required this.customTypeController,
    required this.customTypeFocusNode,
    required this.onTypeSelected,
    required this.onCustomTypeToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What type of company?',
          style: TossTextStyles.h1.copyWith(
            fontWeight: FontWeight.w800,
            color: TossColors.textPrimary,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Choose the category that best describes your company',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        const SizedBox(height: TossSpacing.space6),
        ...companyTypes.map((type) => _buildTypeOption(type)),
      ],
    );
  }

  Widget _buildTypeOption(CompanyType type) {
    final isOthersType = type.typeName.toLowerCase() == 'others' ||
        type.typeName.toLowerCase() == 'other';
    final isSelected = selectedTypeId == type.companyTypeId;

    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTypeSelected(type.companyTypeId);
            if (isOthersType) {
              onCustomTypeToggled(true);
              Future.delayed(const Duration(milliseconds: 100), () {
                customTypeFocusNode.requestFocus();
              });
            } else {
              onCustomTypeToggled(false);
              customTypeController.clear();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? TossColors.primary : TossColors.gray300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: TossColors.white,
            ),
            child: Row(
              children: [
                if (!isOthersType || !isCustomTypeSelected)
                  Expanded(
                    child: Text(
                      type.typeName,
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? TossColors.primary : TossColors.textPrimary,
                        fontSize: TossTextStyles.h3.fontSize! * 0.7,
                      ),
                    ),
                  ),
                if (isOthersType && isCustomTypeSelected) ...[
                  Text(
                    type.typeName,
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.primary,
                      fontSize: TossTextStyles.h3.fontSize! * 0.7,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space6),
                  Expanded(
                    child: TextField(
                      controller: customTypeController,
                      focusNode: customTypeFocusNode,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your company type',
                        hintStyle: TossTextStyles.body.copyWith(
                          color: TossColors.textSecondary.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
