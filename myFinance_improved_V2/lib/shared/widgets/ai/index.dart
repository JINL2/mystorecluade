/// AI Widgets - Barrel Export
///
/// Shared widgets for displaying AI-generated content with consistent styling.
///
/// Usage:
/// ```dart
/// import 'package:myfinance_improved/shared/widgets/ai/index.dart';
///
/// // In list items (compact)
/// AiDescriptionRow(text: aiDescription)
///
/// // In detail sheets (full content)
/// AiDescriptionBox(text: aiDescription)
///
/// // For OCR analysis results
/// AiAnalysisDetailsBox(items: ocrTexts)
/// ```
library;

export 'ai_analysis_details_box.dart';
export 'ai_description_box.dart';
export 'ai_description_row.dart';
