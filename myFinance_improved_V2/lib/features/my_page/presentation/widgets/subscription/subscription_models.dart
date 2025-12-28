import 'package:flutter/material.dart';

/// Data class for plan information
class PlanData {
  final String name;
  final int monthlyPrice;
  final int annualPrice;
  final String tagline;
  final List<String> features;
  final Color color;
  final bool isPopular;

  const PlanData({
    required this.name,
    required this.monthlyPrice,
    required this.annualPrice,
    required this.tagline,
    required this.features,
    required this.color,
    required this.isPopular,
  });
}

/// Data class for feature comparison row
class FeatureRowData {
  final String name;
  final String freePlan;
  final String freeValue;
  final String basicPlan;
  final String basicValue;
  final String proPlan;
  final String proValue;

  const FeatureRowData(
    this.name,
    this.freePlan,
    this.freeValue,
    this.basicPlan,
    this.basicValue,
    this.proPlan,
    this.proValue,
  );
}
