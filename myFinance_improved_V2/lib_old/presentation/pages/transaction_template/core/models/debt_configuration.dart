import 'package:flutter/material.dart';

// Debt configuration model
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
  }) : issueDate = issueDate ?? DateTime.now(),
        interestRateController = TextEditingController(text: '0');
        
  void dispose() {
    interestRateController.dispose();
  }
}