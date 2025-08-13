import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';

class EmploymentStatusBadge extends StatelessWidget {
  final String status;
  final double? size;

  const EmploymentStatusBadge({
    super.key,
    required this.status,
    this.size,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return TossColors.success;
      case 'on leave':
        return TossColors.warning;
      case 'terminated':
        return TossColors.error;
      default:
        return TossColors.gray400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TossTextStyles.labelSmall.copyWith(
          color: color,
          fontSize: size ?? 10,
        ),
      ),
    );
  }
}

class PerformanceRatingBadge extends StatelessWidget {
  final String? rating;

  const PerformanceRatingBadge({
    super.key,
    this.rating,
  });

  Color _getRatingColor(String rating) {
    switch (rating.toUpperCase()) {
      case 'A+':
        return const Color(0xFFFFD700); // Gold
      case 'A':
        return TossColors.success;
      case 'B':
        return TossColors.info;
      case 'C':
        return TossColors.warning;
      case 'NEEDS IMPROVEMENT':
        return TossColors.error;
      default:
        return TossColors.gray400;
    }
  }

  IconData _getRatingIcon(String rating) {
    switch (rating.toUpperCase()) {
      case 'A+':
        return Icons.star;
      case 'A':
        return Icons.trending_up;
      case 'B':
        return Icons.horizontal_rule;
      case 'C':
        return Icons.trending_down;
      case 'NEEDS IMPROVEMENT':
        return Icons.warning_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (rating == null || rating!.isEmpty) {
      return const SizedBox.shrink();
    }

    final color = _getRatingColor(rating!);
    final icon = _getRatingIcon(rating!);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space1,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          SizedBox(width: 2),
          Text(
            rating!,
            style: TossTextStyles.labelSmall.copyWith(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkLocationIcon extends StatelessWidget {
  final String? location;

  const WorkLocationIcon({
    super.key,
    this.location,
  });

  IconData _getLocationIcon(String location) {
    switch (location.toLowerCase()) {
      case 'remote':
        return Icons.home_work_outlined;
      case 'office':
        return Icons.business_outlined;
      case 'hybrid':
        return Icons.compare_arrows_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  Color _getLocationColor(String location) {
    switch (location.toLowerCase()) {
      case 'remote':
        return TossColors.success;
      case 'office':
        return TossColors.primary;
      case 'hybrid':
        return TossColors.warning;
      default:
        return TossColors.gray400;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (location == null || location!.isEmpty) {
      return const SizedBox.shrink();
    }

    final color = _getLocationColor(location!);
    final icon = _getLocationIcon(location!);
    
    return Tooltip(
      message: location!,
      child: Icon(
        icon,
        size: 14,
        color: color,
      ),
    );
  }
}

class ReviewStatusIndicator extends StatelessWidget {
  final bool isOverdue;
  final bool isDue;
  final DateTime? nextReviewDate;

  const ReviewStatusIndicator({
    super.key,
    required this.isOverdue,
    required this.isDue,
    this.nextReviewDate,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOverdue && !isDue) {
      return const SizedBox.shrink();
    }

    final color = isOverdue ? TossColors.error : TossColors.warning;
    final icon = isOverdue ? Icons.error_outline : Icons.schedule_outlined;
    final text = isOverdue ? 'Overdue' : 'Due Soon';
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space1,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: color,
          ),
          SizedBox(width: 2),
          Text(
            text,
            style: TossTextStyles.labelSmall.copyWith(
              color: color,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class SalaryTrendIndicator extends StatelessWidget {
  final double? increasePercentage;
  final double? increase;
  final String currencySymbol;

  const SalaryTrendIndicator({
    super.key,
    this.increasePercentage,
    this.increase,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    if (increasePercentage == null || increase == null) {
      return const SizedBox.shrink();
    }

    final isIncrease = increase! > 0;
    final color = isIncrease ? TossColors.success : TossColors.error;
    final icon = isIncrease ? Icons.trending_up : Icons.trending_down;
    final sign = isIncrease ? '+' : '';
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: color,
        ),
        SizedBox(width: 2),
        Text(
          '$sign${increasePercentage!.toStringAsFixed(1)}%',
          style: TossTextStyles.labelSmall.copyWith(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class DepartmentChip extends StatelessWidget {
  final String department;
  
  const DepartmentChip({
    super.key,
    required this.department,
  });

  Color _getDepartmentColor(String department) {
    // Generate consistent colors based on department name
    final hash = department.toLowerCase().hashCode;
    final colors = [
      TossColors.primary,
      TossColors.success,
      TossColors.warning,
      TossColors.info,
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF795548), // Brown
      const Color(0xFF607D8B), // Blue Grey
    ];
    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _getDepartmentColor(department);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        department,
        style: TossTextStyles.labelSmall.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}