// lib/features/report_control/domain/entities/example_report_data.dart

import '../../report_detail.dart';

/// Example report data for Daily Financial Summary
///
/// Used for testing and demonstration
class ExampleReportData {
  static ReportDetail get dailyFinancialSummary => const ReportDetail(
        templateId: 'daily_fraud_detection',
        templateCode: 'daily_fraud_detection',
        reportDate: '2025-12-01',
        sessionId: 'example-session-123',
        keyMetrics: const KeyMetrics(
          totalRevenue: 51100000,
          totalRevenueFormatted: '51,100,000 ₫',
          revenueChangePercent: 12.5,
          isPositiveChange: true,
        ),
        performanceCards: const [
          PerformanceCard(
            label: 'Total Transactions',
            value: '213,166,000 ₫',
            icon: '💰',
            trend: '+11.2%',
          ),
          PerformanceCard(
            label: 'Cash Flow',
            value: '+50,614,000 ₫',
            icon: '💵',
            trend: '+8.5%',
          ),
          PerformanceCard(
            label: 'Issues Detected',
            value: '11',
            icon: '⚠️',
            severity: 'medium',
          ),
        ],
        balanceSheet: BalanceSheetSummary(
          // Current totals (example values)
          totalAssets: 500000000, // 500M
          totalLiabilities: 200000000, // 200M
          totalEquity: 300000000, // 300M
          // Changes from yesterday
          assetsChange: 17811701, // +17.8M (Cash +50.6M + Receivable +60.5M - Depreciation -93.3M)
          liabilitiesChange: -60510000, // -60.5M (decreased = good!)
          equityChange: 78321701, // +78.3M (Assets change - Liabilities change)
          // Formatted strings
          totalAssetsFormatted: '500,000,000 ₫',
          totalLiabilitiesFormatted: '200,000,000 ₫',
          totalEquityFormatted: '300,000,000 ₫',
          assetsChangeFormatted: '+17,811,701 ₫',
          liabilitiesChangeFormatted: '-60,510,000 ₫',
          equityChangeFormatted: '+78,321,701 ₫',
          // Direction
          assetsIncreased: true,
          liabilitiesIncreased: false, // Decreased = good
          equityIncreased: true,
        ),
        accountChanges: AccountChanges(
          companyWide: const [
            AccountCategory(
              category: 'Assets',
              accounts: [
                AccountItem(
                  name: 'Cash',
                  change: 50614000,
                  formatted: '+50,614,000 ₫',
                  isIncrease: true,
                ),
                AccountItem(
                  name: 'Note Receivable',
                  change: 60510000,
                  formatted: '+60,510,000 ₫',
                  isIncrease: true,
                ),
                AccountItem(
                  name: 'Accumulated Depreciation',
                  change: -93312299,
                  formatted: '-93,312,299 ₫',
                  isIncrease: false,
                ),
              ],
            ),
            AccountCategory(
              category: 'Liabilities',
              accounts: [
                AccountItem(
                  name: 'Notes Payable',
                  change: -60510000,
                  formatted: '-60,510,000 ₫',
                  isIncrease: false,
                ),
              ],
            ),
            AccountCategory(
              category: 'Income',
              accounts: [
                AccountItem(
                  name: 'Sales revenue',
                  amount: 51100000,
                  formatted: '51,100,000 ₫',
                ),
              ],
            ),
            AccountCategory(
              category: 'Expenses',
              accounts: [
                AccountItem(
                  name: 'Office supplies expenses',
                  amount: 476000,
                  formatted: '476,000 ₫',
                ),
                AccountItem(
                  name: 'Depreciation Expenses',
                  amount: 93312299,
                  formatted: '93,312,299 ₫',
                ),
                AccountItem(
                  name: 'Error',
                  amount: 10000,
                  formatted: '10,000 ₫',
                ),
              ],
            ),
          ],
          byStore: const [
            StoreAccountSummary(
              storeName: 'Cameraon Chua Boc',
              storeId: 'store-1',
              totalTransactions: 48730000,
              revenue: 14630000,
              categories: [
                AccountCategory(
                  category: 'Assets',
                  accounts: [
                    AccountItem(
                      name: 'Cash',
                      change: -6350000,
                      formatted: '-6,350,000 ₫',
                      isIncrease: false,
                    ),
                    AccountItem(
                      name: 'Note Receivable',
                      change: 20900000,
                      formatted: '+20,900,000 ₫',
                      isIncrease: true,
                    ),
                  ],
                ),
                AccountCategory(
                  category: 'Income',
                  accounts: [
                    AccountItem(
                      name: 'Sales revenue',
                      amount: 14630000,
                      formatted: '14,630,000 ₫',
                    ),
                  ],
                ),
                AccountCategory(
                  category: 'Expenses',
                  accounts: [
                    AccountItem(
                      name: 'Office supplies expenses',
                      amount: 80000,
                      formatted: '80,000 ₫',
                    ),
                  ],
                ),
              ],
            ),
            StoreAccountSummary(
              storeName: 'Cameraon Nhat Chieu',
              storeId: 'store-2',
              totalTransactions: 75570000,
              revenue: 14920000,
              categories: [
                AccountCategory(
                  category: 'Assets',
                  accounts: [
                    AccountItem(
                      name: 'Cash',
                      change: 75430000,
                      formatted: '+75,430,000 ₫',
                      isIncrease: true,
                    ),
                  ],
                ),
                AccountCategory(
                  category: 'Income',
                  accounts: [
                    AccountItem(
                      name: 'Sales revenue',
                      amount: 14920000,
                      formatted: '14,920,000 ₫',
                    ),
                  ],
                ),
              ],
            ),
            StoreAccountSummary(
              storeName: 'Headsup Hanoi',
              storeId: 'store-3',
              totalTransactions: 88481000,
              revenue: 21550000,
              categories: [
                AccountCategory(
                  category: 'Assets',
                  accounts: [
                    AccountItem(
                      name: 'Cash',
                      change: -18181000,
                      formatted: '-18,181,000 ₫',
                      isIncrease: false,
                    ),
                    AccountItem(
                      name: 'Note Receivable',
                      change: 39610000,
                      formatted: '+39,610,000 ₫',
                      isIncrease: true,
                    ),
                  ],
                ),
                AccountCategory(
                  category: 'Income',
                  accounts: [
                    AccountItem(
                      name: 'Sales revenue',
                      amount: 21550000,
                      formatted: '21,550,000 ₫',
                    ),
                  ],
                ),
                AccountCategory(
                  category: 'Expenses',
                  accounts: [
                    AccountItem(
                      name: 'Office supplies expenses',
                      amount: 121000,
                      formatted: '121,000 ₫',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        redFlags: const RedFlags(
          highValueTransactions: [
            TransactionFlag(
              amount: 39610000,
              formatted: '39,610,000 ₫',
              description: 'Cash / Notes Payable',
              employee: 'Trong Nghia Nguyen',
              store: 'Cameraon Nhat Chieu',
              severity: 'high',
            ),
            TransactionFlag(
              amount: 39610000,
              formatted: '39,610,000 ₫',
              description: 'Note Receivable / Cash',
              employee: 'Trong Nghia Nguyen',
              store: 'Headsup Hanoi',
              severity: 'high',
            ),
            TransactionFlag(
              amount: 21550000,
              formatted: '21,550,000 ₫',
              description: 'Cash / Sales revenue',
              employee: 'Jin2 Lee',
              store: 'Headsup Hanoi',
              severity: 'medium',
            ),
          ],
          missingDescriptions: [
            TransactionFlag(
              amount: 39610000,
              formatted: '39,610,000 ₫',
              description: 'Note Receivable / Cash',
              employee: 'Trong Nghia Nguyen',
              store: 'Headsup Hanoi',
            ),
            TransactionFlag(
              amount: 21550000,
              formatted: '21,550,000 ₫',
              description: 'Cash / Sales revenue',
              employee: 'Jin2 Lee',
              store: 'Headsup Hanoi',
            ),
            TransactionFlag(
              amount: 14920000,
              formatted: '14,920,000 ₫',
              description: 'Cash / Sales revenue',
              employee: 'Tran Thu Ha',
              store: 'Cameraon Nhat Chieu',
            ),
          ],
        ),
        aiInsights: const AiInsights(
          summary:
              'Overall good performance with revenue increase of 12.5% compared to yesterday. Total revenue reached 51.1M ₫ with strong cash flow improvements. However, 11 issues were detected that require attention.',
          trends: [
            'Cash flow improved significantly with +50.6M ₫ net change',
            'Receivables aging needs attention with +60.5M ₫ outstanding',
            'Sales performance is above target across all stores',
          ],
          recommendations: [
            'Review all high-value transactions for legitimacy and approval',
            'Require detailed descriptions for all transactions to improve audit trail',
            'Implement additional verification for cash transfers exceeding 10,000,000 ₫',
            'Train employees on proper transaction documentation practices',
            'Conduct a follow-up audit on transactions by Trong Nghia Nguyen across stores',
          ],
        ),
        markdownBody: '''# Daily Financial Summary (2025-12-01)

## 📊 Company-Wide Account Changes

### Assets
• Cash: +50,614,000 ₫ increased ✅
• Note Receivable: +60,510,000 ₫ increased ✅
• Accumulated Depreciation: -93,312,299 ₫ decreased ❌

### Income
• Sales revenue: 51,100,000 ₫ earned 💰

---

## ⚠️ Red Flags & Recommendations

**High-Value Transactions:**
• 39,610,000 ₫: Cash / Notes Payable by Trong Nghia Nguyen at Cameraon Nhat Chieu
• 21,550,000 ₫: Cash / Sales revenue by Jin2 Lee at Headsup Hanoi

**Recommendations:**
• Review all high-value transactions for legitimacy and approval
• Require detailed descriptions for all transactions to improve audit trail
• Implement additional verification for cash transfers exceeding 10,000,000 ₫
''',
      );
}
