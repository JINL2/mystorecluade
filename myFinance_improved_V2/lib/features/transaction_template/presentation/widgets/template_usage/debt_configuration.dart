/// Debt Configuration Model
///
/// Purpose: Model class for debt configuration in template usage
/// Contains debt-related settings like category, dates, and interest rate.
///
/// Clean Architecture: PRESENTATION LAYER - Model (Form State)
library;

import 'package:flutter/material.dart';

/// Debt configuration model for template usage
class DebtConfiguration {
  String category;
  DateTime issueDate;
  DateTime? dueDate;
  double interestRate;
  TextEditingController interestRateController;

  DebtConfiguration({
    this.category = 'note',
    DateTime? issueDate,
    this.dueDate,
    this.interestRate = 0.0,
  })  : issueDate = issueDate ?? DateTime.now(),
        interestRateController = TextEditingController(text: '0');

  void dispose() {
    interestRateController.dispose();
  }
}
