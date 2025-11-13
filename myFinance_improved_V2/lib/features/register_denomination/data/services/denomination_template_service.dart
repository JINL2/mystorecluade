import '../../domain/entities/denomination.dart';

class DenominationTemplateService {
  static const DenominationTemplateService _instance = DenominationTemplateService._internal();
  factory DenominationTemplateService() => _instance;
  const DenominationTemplateService._internal();

  /// Get template denominations for a currency code
  List<DenominationTemplateItem> getTemplate(String currencyCode) {
    return _templates[currencyCode.toUpperCase()] ?? [];
  }

  /// Get all available template currency codes
  List<String> getAvailableTemplates() {
    return _templates.keys.toList();
  }

  /// Check if a template exists for a currency
  bool hasTemplate(String currencyCode) {
    return _templates.containsKey(currencyCode.toUpperCase());
  }

  static const Map<String, List<DenominationTemplateItem>> _templates = {
    'USD': [
      DenominationTemplateItem(value: 0.01, type: DenominationType.coin, displayName: 'Penny', emoji: '🪙'),
      DenominationTemplateItem(value: 0.05, type: DenominationType.coin, displayName: 'Nickel', emoji: '🪙'),
      DenominationTemplateItem(value: 0.10, type: DenominationType.coin, displayName: 'Dime', emoji: '🪙'),
      DenominationTemplateItem(value: 0.25, type: DenominationType.coin, displayName: 'Quarter', emoji: '🪙'),
      DenominationTemplateItem(value: 1.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
      DenominationTemplateItem(value: 5.00, type: DenominationType.bill, displayName: 'Five', emoji: '💵'),
      DenominationTemplateItem(value: 10.00, type: DenominationType.bill, displayName: 'Ten', emoji: '💵'),
      DenominationTemplateItem(value: 20.00, type: DenominationType.bill, displayName: 'Twenty', emoji: '💵'),
      DenominationTemplateItem(value: 50.00, type: DenominationType.bill, displayName: 'Fifty', emoji: '💵'),
      DenominationTemplateItem(value: 100.00, type: DenominationType.bill, displayName: 'Hundred', emoji: '💵'),
    ],
    'EUR': [
      DenominationTemplateItem(value: 0.01, type: DenominationType.coin, displayName: 'Cent', emoji: '🪙'),
      DenominationTemplateItem(value: 0.02, type: DenominationType.coin, displayName: 'Cent', emoji: '🪙'),
      DenominationTemplateItem(value: 0.05, type: DenominationType.coin, displayName: 'Cent', emoji: '🪙'),
      DenominationTemplateItem(value: 0.10, type: DenominationType.coin, displayName: 'Cent', emoji: '🪙'),
      DenominationTemplateItem(value: 0.20, type: DenominationType.coin, displayName: 'Cent', emoji: '🪙'),
      DenominationTemplateItem(value: 0.50, type: DenominationType.coin, displayName: 'Cent', emoji: '🪙'),
      DenominationTemplateItem(value: 1.00, type: DenominationType.coin, displayName: 'Euro', emoji: '🪙'),
      DenominationTemplateItem(value: 2.00, type: DenominationType.coin, displayName: 'Euro', emoji: '🪙'),
      DenominationTemplateItem(value: 5.00, type: DenominationType.bill, displayName: 'Euro', emoji: '💶'),
      DenominationTemplateItem(value: 10.00, type: DenominationType.bill, displayName: 'Euro', emoji: '💶'),
      DenominationTemplateItem(value: 20.00, type: DenominationType.bill, displayName: 'Euro', emoji: '💶'),
      DenominationTemplateItem(value: 50.00, type: DenominationType.bill, displayName: 'Euro', emoji: '💶'),
      DenominationTemplateItem(value: 100.00, type: DenominationType.bill, displayName: 'Euro', emoji: '💶'),
      DenominationTemplateItem(value: 200.00, type: DenominationType.bill, displayName: 'Euro', emoji: '💶'),
      DenominationTemplateItem(value: 500.00, type: DenominationType.bill, displayName: 'Euro', emoji: '💶'),
    ],
    'KRW': [
      DenominationTemplateItem(value: 10.0, type: DenominationType.coin, displayName: 'Won', emoji: '🪙'),
      DenominationTemplateItem(value: 50.0, type: DenominationType.coin, displayName: 'Won', emoji: '🪙'),
      DenominationTemplateItem(value: 100.0, type: DenominationType.coin, displayName: 'Won', emoji: '🪙'),
      DenominationTemplateItem(value: 500.0, type: DenominationType.coin, displayName: 'Won', emoji: '🪙'),
      DenominationTemplateItem(value: 1000.0, type: DenominationType.bill, displayName: 'Won', emoji: '💴'),
      DenominationTemplateItem(value: 5000.0, type: DenominationType.bill, displayName: 'Won', emoji: '💴'),
      DenominationTemplateItem(value: 10000.0, type: DenominationType.bill, displayName: 'Won', emoji: '💴'),
      DenominationTemplateItem(value: 50000.0, type: DenominationType.bill, displayName: 'Won', emoji: '💴'),
    ],
    'JPY': [
      DenominationTemplateItem(value: 1.0, type: DenominationType.coin, displayName: 'Yen', emoji: '🪙'),
      DenominationTemplateItem(value: 5.0, type: DenominationType.coin, displayName: 'Yen', emoji: '🪙'),
      DenominationTemplateItem(value: 10.0, type: DenominationType.coin, displayName: 'Yen', emoji: '🪙'),
      DenominationTemplateItem(value: 50.0, type: DenominationType.coin, displayName: 'Yen', emoji: '🪙'),
      DenominationTemplateItem(value: 100.0, type: DenominationType.coin, displayName: 'Yen', emoji: '🪙'),
      DenominationTemplateItem(value: 500.0, type: DenominationType.coin, displayName: 'Yen', emoji: '🪙'),
      DenominationTemplateItem(value: 1000.0, type: DenominationType.bill, displayName: 'Yen', emoji: '💴'),
      DenominationTemplateItem(value: 2000.0, type: DenominationType.bill, displayName: 'Yen', emoji: '💴'),
      DenominationTemplateItem(value: 5000.0, type: DenominationType.bill, displayName: 'Yen', emoji: '💴'),
      DenominationTemplateItem(value: 10000.0, type: DenominationType.bill, displayName: 'Yen', emoji: '💴'),
    ],
    'GBP': [
      DenominationTemplateItem(value: 0.01, type: DenominationType.coin, displayName: 'Penny', emoji: '🪙'),
      DenominationTemplateItem(value: 0.02, type: DenominationType.coin, displayName: 'Pence', emoji: '🪙'),
      DenominationTemplateItem(value: 0.05, type: DenominationType.coin, displayName: 'Pence', emoji: '🪙'),
      DenominationTemplateItem(value: 0.10, type: DenominationType.coin, displayName: 'Pence', emoji: '🪙'),
      DenominationTemplateItem(value: 0.20, type: DenominationType.coin, displayName: 'Pence', emoji: '🪙'),
      DenominationTemplateItem(value: 0.50, type: DenominationType.coin, displayName: 'Pence', emoji: '🪙'),
      DenominationTemplateItem(value: 1.00, type: DenominationType.coin, displayName: 'Pound', emoji: '🪙'),
      DenominationTemplateItem(value: 2.00, type: DenominationType.coin, displayName: 'Pound', emoji: '🪙'),
      DenominationTemplateItem(value: 5.00, type: DenominationType.bill, displayName: 'Pound', emoji: '💷'),
      DenominationTemplateItem(value: 10.00, type: DenominationType.bill, displayName: 'Pound', emoji: '💷'),
      DenominationTemplateItem(value: 20.00, type: DenominationType.bill, displayName: 'Pound', emoji: '💷'),
      DenominationTemplateItem(value: 50.00, type: DenominationType.bill, displayName: 'Pound', emoji: '💷'),
    ],
    'CAD': [
      DenominationTemplateItem(value: 0.05, type: DenominationType.coin, displayName: 'Nickel', emoji: '🪙'),
      DenominationTemplateItem(value: 0.10, type: DenominationType.coin, displayName: 'Dime', emoji: '🪙'),
      DenominationTemplateItem(value: 0.25, type: DenominationType.coin, displayName: 'Quarter', emoji: '🪙'),
      DenominationTemplateItem(value: 1.00, type: DenominationType.coin, displayName: 'Loonie', emoji: '🪙'),
      DenominationTemplateItem(value: 2.00, type: DenominationType.coin, displayName: 'Toonie', emoji: '🪙'),
      DenominationTemplateItem(value: 5.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
      DenominationTemplateItem(value: 10.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
      DenominationTemplateItem(value: 20.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
      DenominationTemplateItem(value: 50.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
      DenominationTemplateItem(value: 100.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
    ],
    'AUD': [
      DenominationTemplateItem(value: 0.05, type: DenominationType.coin, displayName: 'Cent', emoji: '🪙'),
      DenominationTemplateItem(value: 0.10, type: DenominationType.coin, displayName: 'Cent', emoji: '🪙'),
      DenominationTemplateItem(value: 0.20, type: DenominationType.coin, displayName: 'Cent', emoji: '🪙'),
      DenominationTemplateItem(value: 0.50, type: DenominationType.coin, displayName: 'Cent', emoji: '🪙'),
      DenominationTemplateItem(value: 1.00, type: DenominationType.coin, displayName: 'Dollar', emoji: '🪙'),
      DenominationTemplateItem(value: 2.00, type: DenominationType.coin, displayName: 'Dollar', emoji: '🪙'),
      DenominationTemplateItem(value: 5.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
      DenominationTemplateItem(value: 10.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
      DenominationTemplateItem(value: 20.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
      DenominationTemplateItem(value: 50.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
      DenominationTemplateItem(value: 100.00, type: DenominationType.bill, displayName: 'Dollar', emoji: '💵'),
    ],
  };
}