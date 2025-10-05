class TemplateCreationResult {
  final bool isSuccess;
  final String? error;
  final Map<String, dynamic>? optimisticTemplate;
  
  const TemplateCreationResult._({
    required this.isSuccess,
    this.error,
    this.optimisticTemplate,
  });
  
  factory TemplateCreationResult.success(Map<String, dynamic> template) {
    return TemplateCreationResult._(
      isSuccess: true,
      optimisticTemplate: template,
    );
  }
  
  factory TemplateCreationResult.error(String error) {
    return TemplateCreationResult._(
      isSuccess: false,
      error: error,
    );
  }
}