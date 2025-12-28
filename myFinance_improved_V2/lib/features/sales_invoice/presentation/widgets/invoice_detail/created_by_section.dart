import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/entities/invoice_detail.dart';

/// Created By Section for invoice detail
class CreatedBySection extends StatelessWidget {
  final Invoice invoice;
  final InvoiceDetail? detail;

  const CreatedBySection({
    super.key,
    required this.invoice,
    this.detail,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final createdByName =
        detail?.createdByName ?? invoice.createdByName ?? 'Unknown';
    final profileImage = detail?.createdByProfileImage;
    final initials = _getInitials(createdByName);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section title
          Text(
            'Created by',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          // Avatar and name
          Row(
            children: [
              // Avatar - show profile image if available, otherwise initials
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  shape: BoxShape.circle,
                  image: profileImage != null && profileImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(profileImage),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                clipBehavior: Clip.antiAlias,
                child: profileImage == null || profileImage.isEmpty
                    ? Center(
                        child: Text(
                          initials,
                          style: TossTextStyles.small.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.white,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: TossSpacing.space2),
              // Name
              Text(
                createdByName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
