import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/counterparty_provider.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Applicant (Buyer) selector section for LC form
class LCApplicantSection extends ConsumerWidget {
  final String? applicantId;
  final String? errorText;
  final ValueChanged<String?> onApplicantChanged;

  const LCApplicantSection({
    super.key,
    required this.applicantId,
    this.errorText,
    required this.onApplicantChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterpartiesAsync = ref.watch(currentCounterpartiesProvider);

    return counterpartiesAsync.when(
      loading: () => TossDropdown<String>(
        label: 'Applicant (Buyer)',
        items: const [],
        isLoading: true,
        isRequired: true,
      ),
      error: (e, _) => TossDropdown<String>(
        label: 'Applicant (Buyer)',
        items: const [],
        errorText: 'Failed to load',
        isRequired: true,
      ),
      data: (counterparties) {
        return TossDropdown<String>(
          label: 'Applicant (Buyer)',
          value: applicantId,
          hint: 'Select applicant',
          isRequired: true,
          errorText: errorText,
          items: counterparties
              .map((c) => TossDropdownItem<String>(
                    value: c.id,
                    label: c.name,
                    subtitle: c.additionalData?['country'] as String?,
                  ))
              .toList(),
          onChanged: onApplicantChanged,
        );
      },
    );
  }
}
