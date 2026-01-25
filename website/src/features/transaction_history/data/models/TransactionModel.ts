/**
 * TransactionModel
 * Data Transfer Object (DTO) and Mapper for Transaction entity
 * Handles conversion between database format and domain entity
 */

import { Transaction } from '../../domain/entities/Transaction';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class TransactionModel {
  /**
   * Convert raw database JSON to Transaction domain entity
   */
  static fromJson(json: any, journalData?: any): Transaction {
    // Convert UTC entry_date from DB to local time
    const entryDateString = journalData?.entry_date || json.entry_date;
    const entryDate = entryDateString
      ? DateTimeUtils.toLocal(entryDateString).toISOString()
      : '';

    return new Transaction(
      json.line_id || json.journal_id,
      entryDate,
      json.account_name || '',
      json.description || journalData?.description || '',
      json.debit || 0,
      json.credit || 0,
      0, // Balance calculation would need to be done separately
      null, // category_tag not in current line structure
      json.counterparty?.name || json.display_counterparty || null,
      journalData?.currency_symbol || json.currency_symbol || '₩'
    );
  }

  /**
   * Convert Transaction domain entity to database JSON format
   */
  static toJson(transaction: Transaction): any {
    return {
      line_id: transaction.transactionId,
      entry_date: transaction.date,
      account_name: transaction.accountName,
      description: transaction.description,
      debit: transaction.debitAmount,
      credit: transaction.creditAmount,
      balance: transaction.balance,
      category_tag: transaction.categoryTag,
      counterparty: transaction.counterpartyName ? {
        name: transaction.counterpartyName
      } : null,
      display_counterparty: transaction.counterpartyName,
      currency_symbol: transaction.currencySymbol
    };
  }

  /**
   * Flatten journal entries with their lines into individual transactions
   * This is a utility method for converting journal-based data to transaction list
   */
  static fromJournalLines(journalData: any): Transaction[] {
    const transactions: Transaction[] = [];

    if (journalData.lines && Array.isArray(journalData.lines)) {
      journalData.lines.forEach((line: any) => {
        transactions.push(
          TransactionModel.fromJson(line, {
            entry_date: journalData.entry_date,
            description: journalData.description,
            currency_symbol: journalData.currency_symbol
          })
        );
      });
    }

    return transactions;
  }
}
