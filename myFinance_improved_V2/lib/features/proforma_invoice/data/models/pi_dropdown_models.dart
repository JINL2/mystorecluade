/// Counterparty model for dropdown
class CounterpartyDropdownItem {
  final String id;
  final String name;
  final String? address;
  final String? city;
  final String? country;
  final String? email;
  final String? phone;

  CounterpartyDropdownItem({
    required this.id,
    required this.name,
    this.address,
    this.city,
    this.country,
    this.email,
    this.phone,
  });

  factory CounterpartyDropdownItem.fromJson(Map<String, dynamic> json) {
    return CounterpartyDropdownItem(
      id: json['counterparty_id'] as String,
      name: json['name'] as String? ?? '',
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }
}

/// Currency model for dropdown
class CurrencyDropdownItem {
  final String currencyId;
  final String currencyCode;
  final String symbol;
  final String? currencyName;

  CurrencyDropdownItem({
    required this.currencyId,
    required this.currencyCode,
    required this.symbol,
    this.currencyName,
  });

  factory CurrencyDropdownItem.fromJson(Map<String, dynamic> json) {
    return CurrencyDropdownItem(
      currencyId: json['currency_id'] as String,
      currencyCode: json['currency_code'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      currencyName: json['currency_name'] as String?,
    );
  }
}

/// Terms template model for dropdown
class TermsTemplateItem {
  final String templateId;
  final String templateName;
  final String content;
  final bool isDefault;
  final int sortOrder;

  TermsTemplateItem({
    required this.templateId,
    required this.templateName,
    required this.content,
    this.isDefault = false,
    this.sortOrder = 0,
  });

  factory TermsTemplateItem.fromJson(Map<String, dynamic> json) {
    return TermsTemplateItem(
      templateId: json['template_id'] as String,
      templateName: json['template_name'] as String? ?? '',
      content: json['content'] as String? ?? '',
      isDefault: json['is_default'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}
