import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Feedback: Dialogs
import 'package:myfinance_improved/shared/widgets/feedback/dialogs/index.dart';

// Feedback: States
import 'package:myfinance_improved/shared/widgets/feedback/states/index.dart';

// Feedback: Indicators
import 'package:myfinance_improved/shared/widgets/feedback/indicators/index.dart';

// Buttons for demos
import 'package:myfinance_improved/shared/widgets/core/buttons/index.dart';

import '../component_showcase.dart';

/// Feedback Widgets Page - Dialogs, States, Indicators
class FeedbackWidgetsPage extends StatelessWidget {
  const FeedbackWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      children: [
        // Section: Dialogs
        _buildSectionHeader('Dialogs', Icons.chat_bubble_outline),

        // TossInfoDialog
        ComponentShowcase(
          name: 'TossInfoDialog',
          filename: 'toss_info_dialog.dart',
          child: TossPrimaryButton(
            text: 'Show Info Dialog',
            onPressed: () {
              TossInfoDialog.show(
                context: context,
                title: 'What is an SKU?',
                bulletPoints: [
                  'An SKU is a unique code to identify items.',
                  'You can enter your own or auto-generate.',
                  'SKUs help find items quickly.',
                ],
              );
            },
          ),
        ),

        // Section: States
        _buildSectionHeader('States', Icons.layers_outlined),

        // TossEmptyView
        ComponentShowcase(
          name: 'TossEmptyView',
          filename: 'toss_empty_view.dart',
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const TossEmptyView(
              icon: Icon(Icons.inbox_outlined, size: 48, color: TossColors.gray400),
              title: 'No items found',
              description: 'Try adjusting your filters',
            ),
          ),
        ),

        // TossLoadingView
        ComponentShowcase(
          name: 'TossLoadingView',
          filename: 'toss_loading_view.dart',
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const TossLoadingView(),
          ),
        ),

        // TossErrorView
        ComponentShowcase(
          name: 'TossErrorView',
          filename: 'toss_error_view.dart',
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: TossErrorView(
              error: Exception('Failed to load data'),
              onRetry: () {},
              title: 'Error',
            ),
          ),
        ),

        // Section: Indicators
        _buildSectionHeader('Indicators', Icons.refresh),

        // TossRefreshIndicator
        ComponentShowcase(
          name: 'TossRefreshIndicator',
          filename: 'toss_refresh_indicator.dart',
          child: SizedBox(
            height: 80,
            child: TossRefreshIndicator(
              onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
              child: ListView(
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Pull down to refresh'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space8),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: TossSpacing.space4, bottom: TossSpacing.space2),
      child: Row(
        children: [
          Icon(icon, size: 20, color: TossColors.primary),
          const SizedBox(width: TossSpacing.space2),
          Text(
            title,
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
