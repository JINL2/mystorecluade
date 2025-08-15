// Mock data for Register Denomination page
class MockCurrency {
  final String id;
  final String code;
  final String name;
  final String fullName;
  final String symbol;
  final String flagEmoji;
  final List<MockDenomination> denominations;

  const MockCurrency({
    required this.id,
    required this.code,
    required this.name,
    required this.fullName,
    required this.symbol,
    required this.flagEmoji,
    required this.denominations,
  });
}

class MockDenomination {
  final String id;
  final double value;
  final String type; // 'coin' or 'bill'
  final String displayName;
  final String emoji;

  const MockDenomination({
    required this.id,
    required this.value,
    required this.type,
    required this.displayName,
    required this.emoji,
  });
  
  String get formattedValue {
    if (value < 1.0) {
      return '${(value * 100).toInt()}¢';
    }
    return '\$${value.toInt()}';
  }
}

// Mock data for demonstration
class MockData {
  static const List<MockCurrency> currencies = [
    MockCurrency(
      id: 'usd',
      code: 'USD',
      name: 'US Dollar',
      fullName: 'United States Dollar',
      symbol: '\$',
      flagEmoji: '🇺🇸',
      denominations: [
        MockDenomination(
          id: 'usd_001',
          value: 0.01,
          type: 'coin',
          displayName: 'Penny',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'usd_005',
          value: 0.05,
          type: 'coin',
          displayName: 'Nickel',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'usd_010',
          value: 0.10,
          type: 'coin',
          displayName: 'Dime',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'usd_025',
          value: 0.25,
          type: 'coin',
          displayName: 'Quarter',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'usd_100',
          value: 1.00,
          type: 'bill',
          displayName: 'Dollar',
          emoji: '💵',
        ),
        MockDenomination(
          id: 'usd_500',
          value: 5.00,
          type: 'bill',
          displayName: 'Five',
          emoji: '💵',
        ),
        MockDenomination(
          id: 'usd_1000',
          value: 10.00,
          type: 'bill',
          displayName: 'Ten',
          emoji: '💵',
        ),
        MockDenomination(
          id: 'usd_2000',
          value: 20.00,
          type: 'bill',
          displayName: 'Twenty',
          emoji: '💵',
        ),
      ],
    ),
    MockCurrency(
      id: 'eur',
      code: 'EUR',
      name: 'Euro',
      fullName: 'European Euro',
      symbol: '€',
      flagEmoji: '🇪🇺',
      denominations: [
        MockDenomination(
          id: 'eur_001',
          value: 0.01,
          type: 'coin',
          displayName: 'Cent',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'eur_002',
          value: 0.02,
          type: 'coin',
          displayName: 'Cent',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'eur_005',
          value: 0.05,
          type: 'coin',
          displayName: 'Cent',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'eur_010',
          value: 0.10,
          type: 'coin',
          displayName: 'Cent',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'eur_020',
          value: 0.20,
          type: 'coin',
          displayName: 'Cent',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'eur_050',
          value: 0.50,
          type: 'coin',
          displayName: 'Cent',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'eur_100',
          value: 1.00,
          type: 'coin',
          displayName: 'Euro',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'eur_200',
          value: 2.00,
          type: 'coin',
          displayName: 'Euro',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'eur_500',
          value: 5.00,
          type: 'bill',
          displayName: 'Euro',
          emoji: '💶',
        ),
        MockDenomination(
          id: 'eur_1000',
          value: 10.00,
          type: 'bill',
          displayName: 'Euro',
          emoji: '💶',
        ),
      ],
    ),
    MockCurrency(
      id: 'krw',
      code: 'KRW',
      name: 'Korean Won',
      fullName: 'South Korean Won',
      symbol: '₩',
      flagEmoji: '🇰🇷',
      denominations: [
        MockDenomination(
          id: 'krw_10',
          value: 10,
          type: 'coin',
          displayName: 'Won',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'krw_50',
          value: 50,
          type: 'coin',
          displayName: 'Won',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'krw_100',
          value: 100,
          type: 'coin',
          displayName: 'Won',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'krw_500',
          value: 500,
          type: 'coin',
          displayName: 'Won',
          emoji: '🪙',
        ),
        MockDenomination(
          id: 'krw_1000',
          value: 1000,
          type: 'bill',
          displayName: 'Won',
          emoji: '💴',
        ),
        MockDenomination(
          id: 'krw_5000',
          value: 5000,
          type: 'bill',
          displayName: 'Won',
          emoji: '💴',
        ),
        MockDenomination(
          id: 'krw_10000',
          value: 10000,
          type: 'bill',
          displayName: 'Won',
          emoji: '💴',
        ),
        MockDenomination(
          id: 'krw_50000',
          value: 50000,
          type: 'bill',
          displayName: 'Won',
          emoji: '💴',
        ),
      ],
    ),
  ];
}