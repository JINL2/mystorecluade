import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// 선택 카드 - 아이콘과 타이틀이 있는 선택 가능한 카드
class SelectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: TossColors.gray600,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// 매장 선택 카드
class StoreSelectionCard extends StatelessWidget {
  final String storeId;
  final String storeName;
  final bool isSelected;
  final VoidCallback onTap;

  const StoreSelectionCard({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: const Center(
                child: Icon(
                  Icons.store,
                  color: TossColors.gray600,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                storeName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// 회사 선택 카드
class CompanySelectionCard extends StatelessWidget {
  final String companyId;
  final String companyName;
  final int storeCount;
  final bool isSelected;
  final VoidCallback onTap;

  const CompanySelectionCard({
    super.key,
    required this.companyId,
    required this.companyName,
    required this.storeCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: const Center(
                child: Icon(
                  Icons.business,
                  color: TossColors.gray600,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: TossColors.gray900,
                    ),
                  ),
                  Text(
                    '$storeCount store${storeCount > 1 ? 's' : ''}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// 요약 카드 - 선택된 정보를 요약해서 보여주는 카드
class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: TossColors.gray500),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                Text(
                  value,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Text(
                'Change',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 부채 거래 안내 위젯
class DebtTransactionNotice extends StatelessWidget {
  const DebtTransactionNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.amber.shade700,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'This transfer will create a debt entry between stores/companies.',
              style: TossTextStyles.caption.copyWith(
                color: Colors.amber.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 화살표 구분자 위젯
class TransferArrow extends StatelessWidget {
  const TransferArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: const Center(
        child: Icon(
          Icons.arrow_downward,
          color: TossColors.gray400,
          size: 20,
        ),
      ),
    );
  }
}
