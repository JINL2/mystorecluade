/// Template Basic Info Form - Name and description input for template creation
///
/// Purpose: Collects essential template information in Step 1:
/// - Template name (required) with real-time validation
/// - Optional description with multi-line support
/// - Consistent styling and behavior with Toss design system
/// - Proper keyboard navigation and text input actions
///
/// Usage: TemplateBasicInfoForm(nameController: controller, onChanged: callback)
import 'package:flutter/material.dart';
import '../../../../../widgets/toss/toss_text_field.dart';
import '../../../../../../core/themes/toss_colors.dart';
import '../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../core/themes/toss_spacing.dart';

class TemplateBasicInfoForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final VoidCallback? onChanged;
  final String? nameError;
  final String? descriptionError;
  final bool enabled;
  
  const TemplateBasicInfoForm({
    super.key,
    required this.nameController,
    required this.descriptionController,
    this.onChanged,
    this.nameError,
    this.descriptionError,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1: Basic Information',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: TossSpacing.space5),
          
          // Name field
          TossTextField(
            label: 'Template Name',
            hintText: 'Enter template name',
            controller: nameController,
            textInputAction: TextInputAction.next,
            enabled: enabled,
            onChanged: (_) => onChanged?.call(),
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Description field
          TossTextField(
            label: 'Description (Optional)',
            hintText: 'Enter template description',
            controller: descriptionController,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            enabled: enabled,
            onChanged: (_) => onChanged?.call(),
          ),
          
          // Add padding at bottom for better scroll experience
          SizedBox(height: TossSpacing.space5),
        ],
      ),
    );
  }
  
  /// Validate the form and return errors
  FormValidationResult validate() {
    final errors = <String, String>{};
    
    if (nameController.text.trim().isEmpty) {
      errors['name'] = 'Template name is required';
    } else if (nameController.text.trim().length < 2) {
      errors['name'] = 'Template name must be at least 2 characters';
    } else if (nameController.text.trim().length > 100) {
      errors['name'] = 'Template name cannot exceed 100 characters';
    }
    
    if (descriptionController.text.trim().length > 500) {
      errors['description'] = 'Description cannot exceed 500 characters';
    }
    
    return FormValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      name: nameController.text.trim(),
      description: descriptionController.text.trim().isEmpty 
          ? null 
          : descriptionController.text.trim(),
    );
  }
  
  /// Check if form has minimum required data
  bool get hasValidName => nameController.text.trim().isNotEmpty;
  
  /// Get cleaned form data
  TemplateBasicInfo get formData => TemplateBasicInfo(
    name: nameController.text.trim(),
    description: descriptionController.text.trim().isEmpty 
        ? null 
        : descriptionController.text.trim(),
  );
}

class FormValidationResult {
  final bool isValid;
  final Map<String, String> errors;
  final String name;
  final String? description;
  
  const FormValidationResult({
    required this.isValid,
    required this.errors,
    required this.name,
    this.description,
  });
}

class TemplateBasicInfo {
  final String name;
  final String? description;
  
  const TemplateBasicInfo({
    required this.name,
    this.description,
  });
}