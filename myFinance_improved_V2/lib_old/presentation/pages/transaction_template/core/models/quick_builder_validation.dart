class QuickBuilderValidation {
  final bool canProcess;
  final List<String> errors;
  final List<String> warnings;
  final bool hasComplexDebt;
  
  const QuickBuilderValidation({
    required this.canProcess,
    required this.errors,
    required this.warnings,
    required this.hasComplexDebt,
  });
}