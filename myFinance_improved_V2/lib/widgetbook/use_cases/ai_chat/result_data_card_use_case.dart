import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/ai_chat/presentation/widgets/result_data_card.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final resultDataCardComponent = WidgetbookComponent(
  name: 'ResultDataCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: ResultDataCard(
          data: [
            {'name': 'Coffee', 'quantity': 50, 'revenue': 250000},
            {'name': 'Cake', 'quantity': 30, 'revenue': 180000},
          ],
          isLoading: context.knobs.boolean(
            label: 'Loading',
            initialValue: false,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Loading State',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: const ResultDataCard(
          data: [],
          isLoading: true,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Single Row',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: const ResultDataCard(
          data: [
            {
              'total_revenue': 2500000,
              'total_transactions': 150,
              'average_order': 16667,
            },
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Multiple Rows',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: const ResultDataCard(
          data: [
            {'product_name': 'Americano', 'category': 'Beverage', 'sold_qty': 120, 'revenue': 480000},
            {'product_name': 'Latte', 'category': 'Beverage', 'sold_qty': 95, 'revenue': 475000},
            {'product_name': 'Croissant', 'category': 'Bakery', 'sold_qty': 60, 'revenue': 240000},
            {'product_name': 'Sandwich', 'category': 'Food', 'sold_qty': 45, 'revenue': 270000},
            {'product_name': 'Cheesecake', 'category': 'Dessert', 'sold_qty': 35, 'revenue': 245000},
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Employee Data',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: const ResultDataCard(
          data: [
            {'employee_name': 'John Doe', 'role': 'Cashier', 'sales_count': 45, 'total_sales': 850000},
            {'employee_name': 'Jane Smith', 'role': 'Barista', 'sales_count': 38, 'total_sales': 720000},
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Empty State',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: const ResultDataCard(data: []),
      ),
    ),
  ],
);
