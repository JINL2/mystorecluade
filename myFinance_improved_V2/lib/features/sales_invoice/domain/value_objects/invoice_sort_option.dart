import 'package:flutter/material.dart';

/// Invoice sort option enum
enum InvoiceSortOption {
  date,
  invoiceId,
  user,
  products,
  amount;

  String get displayName {
    switch (this) {
      case InvoiceSortOption.date:
        return 'Date';
      case InvoiceSortOption.invoiceId:
        return 'Invoice ID';
      case InvoiceSortOption.user:
        return 'Customer';
      case InvoiceSortOption.products:
        return 'Products';
      case InvoiceSortOption.amount:
        return 'Amount';
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
      case InvoiceSortOption.amount:
        return Icons.attach_money;
    }
  }
}
