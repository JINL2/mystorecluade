import 'package:flutter/material.dart';

class SalesInvoice {
  final String id;
  final DateTime date;
  final String userId;
  final String userName;
  final int productCount;
  final bool isCompleted;
  final String? notes;

  SalesInvoice({
    required this.id,
    required this.date,
    required this.userId,
    required this.userName,
    required this.productCount,
    required this.isCompleted,
    this.notes,
  });

  String get timeString {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get dateString {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final invoiceDay = DateTime(date.year, date.month, date.day);
    
    if (invoiceDay == today) {
      return 'Today, ${_formatDate(date)}';
    } else if (invoiceDay == today.subtract(Duration(days: 1))) {
      return 'Yesterday, ${_formatDate(date)}';
    } else {
      return '${_getDayName(date)}, ${_formatDate(date)}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }
}

enum InvoicePeriod {
  today,
  thisWeek,
  thisMonth,
  lastMonth,
  allTime;

  String get displayName {
    switch (this) {
      case InvoicePeriod.today:
        return 'Today';
      case InvoicePeriod.thisWeek:
        return 'This week';
      case InvoicePeriod.thisMonth:
        return 'This month';
      case InvoicePeriod.lastMonth:
        return 'Last month';
      case InvoicePeriod.allTime:
        return 'All time';
    }
  }
}

enum InvoiceSortOption {
  date,
  invoiceId,
  user,
  products;

  String get displayName {
    switch (this) {
      case InvoiceSortOption.date:
        return 'Date';
      case InvoiceSortOption.invoiceId:
        return 'Invoice ID';
      case InvoiceSortOption.user:
        return 'User';
      case InvoiceSortOption.products:
        return 'Products';
    }
  }

  IconData get icon {
    switch (this) {
      case InvoiceSortOption.date:
        return Icons.calendar_today;
      case InvoiceSortOption.invoiceId:
        return Icons.tag;
      case InvoiceSortOption.user:
        return Icons.person;
      case InvoiceSortOption.products:
        return Icons.inventory_2;
    }
  }
}