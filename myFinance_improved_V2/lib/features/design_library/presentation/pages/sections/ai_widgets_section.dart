import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/ai/ai_description_row.dart';

/// AI Widgets Section - Showcases AI-related widgets
class AIWidgetsSection extends StatelessWidget {
  const AIWidgetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('AI Widgets', 'shared/widgets/ai/'),

          // AiDescriptionRow
          _ComponentShowcase(
            name: 'AiDescriptionRow',
            description: 'Compact AI description row with sparkle icon in amber color',
            filename: 'ai_description_row.dart',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AiDescriptionRow(
                  text: 'Office supplies purchase from vendor',
                ),
                SizedBox(height: TossSpacing.space2),
                AiDescriptionRow(
                  text: 'Recurring monthly expense - auto-categorized',
                  maxLines: 2,
                ),
                SizedBox(height: TossSpacing.space2),
                AiDescriptionRow(
                  text: 'AI detected: Similar to previous transactions',
                  fontSize: 14,
                  iconSize: 14,
                ),
              ],
            ),
          ),

          // AI Widgets Documentation
          _DocumentationCard(
            name: 'AI Widget Usage',
            description: 'AI widgets are used to display AI-generated content with visual indicators',
            features: const [
              'Sparkle icon indicates AI content',
              'Amber color theme for visibility',
              'Configurable text size and lines',
              'Used in transaction lists and details',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String path) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            path,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

/// Component showcase with visual example
class _ComponentShowcase extends StatelessWidget {
  const _ComponentShowcase({
    required this.name,
    required this.description,
    required this.filename,
    required this.child,
  });

  final String name;
  final String description;
  final String filename;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TossTextStyles.h4.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            description,
            style: TossTextStyles.body.copyWith(color: TossColors.textSecondary),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            filename,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Documentation card for widgets that can't be demoed
class _DocumentationCard extends StatelessWidget {
  const _DocumentationCard({
    required this.name,
    required this.description,
    required this.features,
  });

  final String name;
  final String description;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primarySurface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: TossColors.primary),
              const SizedBox(width: TossSpacing.space2),
              Text(
                name,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            description,
            style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
          ),
          const SizedBox(height: TossSpacing.space2),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: TossSpacing.space1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, size: 14, color: TossColors.success),
                    const SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: Text(
                        f,
                        style: TossTextStyles.caption.copyWith(color: TossColors.gray700),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
