import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

int? simplePlus(
  int? inputNumber,
  int? plusHowMany,
) {
  if (inputNumber == null || plusHowMany == null) return null;
  return inputNumber + plusHowMany;
}

List<CounterPartyDebtStruct> addDebtControlList(
  List<CounterPartyDebtStruct> current,
  List<CounterPartyDebtStruct> newList,
) {
  return [...current, ...newList];
}

String? formatNumberWithComma(double? number) {
  if (number == null) return '';
  return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
}

String? formatTimeOnly(DateTime? time) {
  if (time == null) return '시간 없음';
  return DateFormat('hh:mm a').format(time);
}

int? hRcomparison(
  int? requiredHRNumber,
  int? currentHRNumber,
) {
  if (requiredHRNumber == null || currentHRNumber == null) {
    return null;
  }

  return requiredHRNumber - currentHRNumber;
}

List<VaultAmountLineStruct>? removeValuefromVaultData(
  String? denominationId,
  List<VaultAmountLineStruct>? vaultAmountLine,
  int? quantity,
) {
  if (denominationId == null || vaultAmountLine == null || quantity == null) {
    return vaultAmountLine;
  }

  return vaultAmountLine.map((item) {
    if (item.denominationId == denominationId) {
      return VaultAmountLineStruct(
        denominationId: item.denominationId,
        quantity: quantity,
      );
    }
    return item;
  }).toList();
}

bool? isListHaveCurrnencies(
  List<CurrenciesStruct>? currenciesDataType,
  String? currencyId,
) {
  if (currenciesDataType == null || currencyId == null) return false;

  final currencyIdSet = currenciesDataType
      .map((item) => item.currencyId)
      .whereType<String>() // null 안전 처리
      .toSet();

  return currencyIdSet.contains(currencyId);
}

dynamic convertListToJson(List<String> items) {
  if (items == null) return [];
  return jsonDecode(jsonEncode(items));
}

int checkAmountDebitCredit(
  List<TransactionDetailStruct>? list,
  String? debitOrCredit,
) {
  if (list == null || debitOrCredit == null) return 0;

  int count = 0;

  for (final item in list) {
    if (item == null) continue;

    final value = debitOrCredit == 'debit' ? item.debit : item.credit;

    if (value != null && value != '0') {
      count++;
    }
  }

  return count;
}

double convertToInt(String stringSalaryAmount) {
  return double.tryParse(stringSalaryAmount) ?? 0;
}

List<DenominationsStruct>? removeValuefromDenominationData(
  String? denominationId,
  int? value,
  List<DenominationsStruct>? denominationInput,
) {
  if (denominationId == null || value == null || denominationInput == null) {
    return denominationInput;
  }

  return denominationInput.map((item) {
    if (item.denominationId == denominationId) {
      return DenominationsStruct(
        denominationId: item.denominationId,
        quantity: value,
      );
    }
    return item;
  }).toList();
}

double getTotalCredit(List<dynamic> transactionDetail) {
  double totalCredit = 0;

  for (final item in transactionDetail) {
    if (item is Map<String, dynamic>) {
      final value = item['credit'];
      double credit = 0.0;

      if (value != null) {
        if (value is String) {
          credit = double.tryParse(value) ?? 0.0;
        } else if (value is int) {
          credit = value.toDouble();
        } else if (value is double) {
          credit = value;
        }
      }

      totalCredit += credit;
    }
  }

  return totalCredit;
}

bool? isListHaveDenominationDatatype(
  List<DenominationsStruct>? denominations,
  String? denominationId,
) {
  if (denominations == null || denominationId == null) return false;

  final denominationSet = denominations
      .map((item) => item.denominationId)
      .whereType<String>() // null 값 제거
      .toSet();

  return denominationSet.contains(denominationId);
}

bool? isListHaveDatatypeList(
  String? string,
  List<ShiftMetaDataStruct>? datatype,
) {
  if (string == null || datatype == null) return false;

  // store_id 필드를 비교
  return datatype.any((e) => e.storeId == string);
}

String? changeDateTimeToString(DateTime? dateTime) {
  if (dateTime == null) return null;
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

List<String> cleanStringList(List<String> inputList) {
  return inputList.map((item) {
    // 양쪽 쌍따옴표 제거
    return item.replaceAll(RegExp(r'^"|"$'), '');
  }).toList();
}

bool managerShiftIsHaveData(
  List<ManagerShiftDetailStruct>? managerShiftList,
  String? requestDate,
  String? shiftId,
  String? userId,
  String? storeId,
) {
  if (managerShiftList == null ||
      requestDate == null ||
      shiftId == null ||
      userId == null ||
      storeId == null) return false;

  for (final detail in managerShiftList) {
    if (detail.requestDate != requestDate || detail.storeId != storeId)
      continue;

    for (final shift in detail.shifts) {
      if (shift.shiftId != shiftId) continue;

      final pending = shift.pendingEmployees ?? [];
      final approved = shift.approvedEmployees ?? [];

      final foundInPending = pending.any((e) => e.userId == userId);
      final foundInApproved = approved.any((e) => e.userId == userId);

      if (foundInPending || foundInApproved) return true;
    }
  }

  return false;
}

DateTime? changeStringToDateTime(String? date) {
  if (date == null || date.isEmpty) {
    return null; // 입력이 null 또는 빈 문자열일 경우 null 반환
  }

  try {
    // 문자열이 시간만 있는 경우, 현재 날짜와 결합하여 DateTime으로 변환
    if (date.length == 8) {
      // 현재 날짜를 가져와서 시간과 결합
      String currentDate = DateTime.now()
          .toIso8601String()
          .substring(0, 10); // 현재 날짜 (예: "2025-05-05")
      date = "$currentDate $date"; // 현재 날짜와 시간 결합 (예: "2025-05-05 16:00:00")
    }

    return DateTime.tryParse(date); // 결합된 문자열을 DateTime으로 변환
  } catch (e) {
    return null; // 변환 실패 시 null 반환
  }
}

String? combineSystimeWithMunite(
  String? systemTime,
  String? munite,
) {
  if (systemTime == null) return null;

  try {
    final minuteValue =
        (munite == null || munite.isEmpty) ? 0 : int.parse(munite);

    final inputFormat = DateFormat('HH:mm:ss');
    final outputFormat = DateFormat('HH:mm');

    final baseTime = inputFormat.parse(systemTime);
    final newTime = baseTime.add(Duration(minutes: minuteValue));

    return outputFormat.format(newTime);
  } catch (e) {
    return null;
  }
}

double? lat(
  LatLng? location,
  bool? trueLatFalstLng,
) {
  if (location == null || trueLatFalstLng == null) return null;

  return trueLatFalstLng ? location.latitude : location.longitude;
}

bool isAnyApprovedForDate(
  List<ShiftStatusStruct>? shiftStatus,
  String? requestDate,
) {
  /// null 값 예외 처리
  if (shiftStatus == null ||
      shiftStatus.isEmpty ||
      requestDate == null ||
      requestDate.isEmpty) {
    return false;
  }

  for (final shift in shiftStatus) {
    if (shift == null) continue;

    final date = shift.requestDate;
    final isApproved = shift.isApproved ?? false;

    if (date == requestDate && isApproved) {
      return true;
    }
  }

  return false;
}

DateTime getLastMonthDateTime(DateTime inputDate) {
  int year = inputDate.year;
  int month = inputDate.month;

  if (month == 1) {
    year--;
    month = 12;
  } else {
    month--;
  }
  return DateTime(year, month);
}

dynamic mapListDatatoJsonb(List<CurrenciesStruct> list) {
  return list
      .map((currency) => {
            "currency_id": currency.currencyId,
            "denominations": currency.denominations
                .map((denom) => {
                      "denomination_id": denom.denominationId,
                      "quantity": denom.quantity
                    })
                .toList()
          })
      .toList();
}

List<dynamic>? mapListJasonVaultAmountLine(
    List<VaultAmountLineStruct>? vaultAmountLineData) {
  if (vaultAmountLineData == null) return null;

  return vaultAmountLineData
      .map((item) => {
            "denomination_id": item.denominationId,
            "quantity": item.quantity,
          })
      .toList();
}

List<CalendarDayStruct> getCalendarForMonth(DateTime inputDate) {
  List<CalendarDayStruct> calendar = [];

  // Start by finding the first day of the current month
  DateTime firstOfMonth = DateTime(inputDate.year, inputDate.month, 1);

  // Find the last day of the current month
  DateTime lastOfMonth = DateTime(inputDate.year, inputDate.month + 1, 0);

  // Find the first Monday on or before the first of the month
  DateTime startCalendar =
      firstOfMonth.subtract(Duration(days: firstOfMonth.weekday - 1));

  // Find the last Sunday after the end of the month
  DateTime endCalendar = lastOfMonth.weekday == 7
      ? lastOfMonth
      : lastOfMonth.add(Duration(days: 7 - lastOfMonth.weekday));

  // Populate the calendar
  for (DateTime date = startCalendar;
      date.isBefore(endCalendar.add(Duration(days: 1)));
      date = date.add(Duration(days: 1))) {
    bool isPreviousMonth = date.isBefore(firstOfMonth);
    bool isNextMonth = date.isAfter(lastOfMonth);

    CalendarDayStruct dayStruct = CalendarDayStruct(
        calendarDate: date,
        isPreviousMonth: isPreviousMonth,
        isNextMonth: isNextMonth);

    calendar.add(dayStruct);
  }

  return calendar;
}

bool? isListHaveCurrnecyid(
  List<CompanyCurrencyRow>? supabaseCurrency,
  String? currencyId,
) {
  if (supabaseCurrency == null || currencyId == null) {
    return false;
  }

  return supabaseCurrency.any((row) => row.currencyId == currencyId);
}

dynamic mapTransactionDetailtoObject(List<TransactionDetailStruct> list) {
  return list
      .map((item) => {
            "account_id": item.accountId,
            "description": item.description,
            "debit": item.debit,
            "credit": item.credit,
            "counterparty_id": item.counterpartyId,
            "amount": item.amount,
            if (item.cash != null &&
                item.cash.cashLocationId != null &&
                item.cash.cashLocationId != "")
              "cash": {"cash_location_id": item.cash.cashLocationId}
          })
      .toList();
}

int? extratimeIntCalculator(
  String? systemTime,
  DateTime? dateTime,
) {
  if (systemTime == null || dateTime == null) return null;

  try {
    final format = DateFormat('HH:mm:ss');
    final baseTime = format.parse(systemTime);

    final nowTime = DateTime(2000, 1, 1, dateTime.hour, dateTime.minute, 0);
    final compareTime = DateTime(2000, 1, 1, baseTime.hour, baseTime.minute, 0);

    final diff = nowTime.difference(compareTime);

    return diff.inMinutes;
  } catch (e) {
    return null;
  }
}

/// findstorename
String? getStoreNameByIdFromList(
  List<StoresStruct>? dataInput,
  String? storeId,
) {
  if (dataInput == null) return null;

  for (final store in dataInput) {
    if (store.storeId == storeId) {
      return store.storeName;
    }
  }

  return null;
}

List<String> mergeStringListToStringList(
  List<String> originalList,
  List<String> newList,
) {
  return [...originalList, ...newList];
}

bool? isListHaveVaultAmountLineData(
  List<VaultAmountLineStruct>? vaultAmountLineData,
  String? denominationId,
) {
  if (vaultAmountLineData == null || denominationId == null) return false;

  return vaultAmountLineData.any(
    (item) => item.denominationId == denominationId,
  );
}

List<CompaniesStruct>? addtoListInUserCompanyStore(
  List<StoresStruct>? inputStoreData,
  UserStruct? inputUserData,
  String? inputCompanyid,
) {
  if (inputStoreData == null ||
      inputUserData == null ||
      inputCompanyid == null) {
    return null;
  }

  final companies = inputUserData.companies;

  return companies.map((company) {
    if (company.companyId == inputCompanyid) {
      final updatedStores = [...company.stores, ...inputStoreData];
      return CompaniesStruct(
        companyId: company.companyId,
        companyName: company.companyName,
        companyCode: company.companyCode,
        storeCount: updatedStores.length,
        role: company.role,
        stores: updatedStores,
      );
    }
    return company;
  }).toList();
}

bool? isListHave(
  String? item,
  List<dynamic>? list,
) {
  if (list == null || item == null) return false;

  // list가 List<dynamic>이면 List<String>으로 변환
  List<String> stringList = List<String>.from(list);

  return stringList.contains(item);
}

String? getYesterdayFormat(DateTime? dateTime) {
  if (dateTime == null) return null;

  try {
    final yesterday = dateTime.subtract(Duration(days: 1));
    return DateFormat('yyyy-MM-dd').format(yesterday);
  } catch (e) {
    return null;
  }
}

List<String> convertJsonToList(dynamic jsonItems) {
  if (jsonItems == null) return [];

  // JSON이 List가 아닌 경우 대비
  if (jsonItems is! List) {
    return [];
  }

  // 각 항목을 String으로 캐스팅
  return jsonItems.map((item) => item.toString()).toList();
}

int? countIfApproved(
  List? list,
  DateTime? dateAndTime,
  String? storeId,
) {
  if (list == null || dateAndTime == null || storeId == null) {
    return 0;
  }

  final filteredList = list.where((item) {
    final isSameDate =
        item.requestDate == DateFormat('yyyy-MM-dd').format(dateAndTime);
    final isSameStore = item.storeId == storeId;
    return isSameDate && isSameStore && item.isApproved == true;
  }).toList();

  return filteredList.length;
}

int? companyCount(List? myCompanies) {
  if (myCompanies == null) return 0;
  return myCompanies.length;
}

/// findstorename
String? getAccountNameByIdFromList(
  List<FinanceAccountStruct>? dataInput,
  String? accountId,
) {
  if (dataInput == null || accountId == null) return null;

  for (final account in dataInput) {
    if (account.accountId == accountId) {
      return account.accountName;
    }
  }

  return null;
}

DateTime? getMaxCreateAt2(
  List<VBankAmountRow>? vBankAmount,
  String? recorddate,
) {
  if (vBankAmount == null || recorddate == null || recorddate.isEmpty)
    return null;

  // dateTime을 DateTime 타입으로 파싱
  DateTime? targetDate;
  try {
    targetDate = DateTime.parse(recorddate);
  } catch (e) {
    return null; // 파싱 실패 시 null 반환
  }

  // record_date가 동일한 row들만 필터
  final filtered = vBankAmount.where((row) {
    return row.recordDate != null &&
        row.recordDate!.year == targetDate!.year &&
        row.recordDate!.month == targetDate.month &&
        row.recordDate!.day == targetDate.day;
  }).toList();

  if (filtered.isEmpty) return null;

  // 필터된 row들의 created_at 중 최대값 반환
  filtered.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  return filtered.first.createdAt;
}

String? changeLocationToString(LatLng? location) {
  if (location == null) return null;
  return 'POINT(${location.longitude} ${location.latitude})';
}

bool? isListHaveString(
  String? item,
  List<String>? list,
) {
  if (list == null || item == null) return false;

  final set = list.toSet(); // 리스트 → Set으로 변환 (O(n), 한 번만)
  return set.contains(item); // 이후 O(1) 탐색
}

List<dynamic>? removeFromList(
  List<dynamic> originalList,
  String? requestId,
  String? fieldName,
) {
  if (originalList == null || fieldName == null || requestId == null) {
    return [];
  }

  return originalList.where((item) {
    final value = item[fieldName]?.toString(); // 필드 이름도 동적으로 접근
    return value != requestId;
  }).toList();
}

List<String> getUniqueDatesFromShiftList(List shiftList) {
  final uniqueDates = <String>{}; // set을 이용해 중복 제거
  for (final shift in shiftList) {
    uniqueDates.add(shift.requestDate); // 날짜만 추출
  }
  return uniqueDates.toList()..sort(); // 정렬도 해줌 (옵션)
}

double getTotalDebit(List<dynamic> transactionDetail) {
  double totalDebit = 0;

  for (final item in transactionDetail) {
    dynamic value = item['debit'];
    double debit = 0.0;

    if (value != null) {
      if (value is String) {
        debit = double.tryParse(value) ?? 0.0;
      } else if (value is int) {
        debit = value.toDouble();
      } else if (value is double) {
        debit = value;
      }
    }

    totalDebit += debit;
  }

  return totalDebit;
}

String generateRangeHeader(
  int offset,
  int limit,
) {
  int start = offset;
  int end = offset + limit - 1;
  return '$start-$end';
}

bool? isListHaveDenomination(
  List<CurrencyDenominationsRow>? currnecyDenominationSupabase,
  int? value,
) {
  if (currnecyDenominationSupabase == null || value == null) {
    return false;
  }

  return currnecyDenominationSupabase.any((row) => row.value == value);
}

String? simplePlusString(
  String? plusData1,
  String? plusData2,
) {
  try {
    final num1 =
        (plusData1 == null || plusData1.isEmpty) ? 0 : int.parse(plusData1);
    final num2 =
        (plusData2 == null || plusData2.isEmpty) ? 0 : int.parse(plusData2);

    final sum = num1 + num2;

    return sum.toString();
  } catch (e) {
    return null;
  }
}

String? formatTimeForSupabase(DateTime? time) {
  if (time == null) return '00:00:00';
  return DateFormat('HH:mm:ss').format(time);
}

List<dynamic>? mergeJsonListsRemoveDuplicates(
  dynamic existingList,
  dynamic newList,
  String? keyField,
) {
  final Map<dynamic, Map<String, dynamic>> uniqueMap = {};

  // 기존 리스트 넣기
  for (var item in existingList) {
    uniqueMap[item[keyField]] = item;
  }

  // 새로운 리스트 넣기 (덮어쓰기 방식)
  for (var item in newList) {
    uniqueMap[item[keyField]] = item;
  }

  // 결과값: 중복 없는 리스트 반환
  return uniqueMap.values.toList();
}

DateTime getNextMonthDateTime(DateTime inputDate) {
  int year = inputDate.year;
  int month = inputDate.month;

  if (month == 12) {
    year++;
    month = 1;
  } else {
    month++;
  }
  return DateTime(year, month);
}

List<CurrenciesStruct>? removeCurrencies(
  List<CurrenciesStruct>? initialData,
  String? currencyId,
  CurrenciesStruct? inputData,
) {
  if (initialData == null || currencyId == null || inputData == null)
    return null;

  final updatedList =
      initialData.where((item) => item.currencyId != currencyId).toList();

  updatedList.add(inputData);

  return updatedList;
}

String? changeDateTimeToStringtYesterday(DateTime? dateTime) {
  if (dateTime == null) return null;
  final yesterday = dateTime.subtract(Duration(days: 1));
  return DateFormat('yyyy-MM-dd').format(yesterday);
}

List<dynamic> getCurrentCounterparties(
  dynamic counterpartyMatrix,
  String viewMode,
  String filterType,
) {
  if (counterpartyMatrix == null) return [];

  // viewMode와 filterType을 조합하여 key 생성
  // 예: 'company_all', 'headquarters_group', 'store_external' 등
  final key = '${viewMode}_${filterType}';

  // get_counterparty_matrix_edit 함수는 바로 9개 조합을 반환하므로
  // data_matrix가 아닌 직접 접근
  final currentData = counterpartyMatrix[key];
  if (currentData == null) return [];

  // counterparties 리스트 반환
  final counterparties = currentData['counterparties'];
  return counterparties ?? [];
}

String convertJsonToString(dynamic jsonData) {
  final encoded = json.encode(jsonData);

  // 따옴표로 감싸진 문자열이면 제거
  if (encoded.startsWith('"') && encoded.endsWith('"')) {
    return encoded.substring(1, encoded.length - 1);
  }
  return encoded;
}

String? getCounterpartyNumber(dynamic counterpartyData) {
  final hasHQ = counterpartyData['counterparty_headquarters_breakdown'] != null;
  final storeList = counterpartyData['counterparty_stores_breakdown'];
  final storeCount = storeList is List ? storeList.length : 0;

  if (!hasHQ && storeCount == 0) {
    return '';
  }

  String label = '';

  if (hasHQ) {
    label += 'HQ';
  }

  if (storeCount > 0) {
    if (label.isNotEmpty) {
      label += ' and ';
    }
    label += '$storeCount ${storeCount == 1 ? "store" : "stores"}';
  }

  return label;
}

int changeStringToInt(String value) {
  try {
    return int.parse(value);
  } catch (e) {
    return 0; // 변환 실패 시 기본값
  }
}

List<CalenderHorizontalStruct> getCalenderHorizontal(DateTime date) {
  final List<CalenderHorizontalStruct> calendar = [];

  // 해당 월의 첫 날과 마지막 날
  final firstDay = DateTime(date.year, date.month, 1);
  final lastDay = DateTime(date.year, date.month + 1, 0);

  for (DateTime current = firstDay;
      !current.isAfter(lastDay);
      current = current.add(Duration(days: 1))) {
    calendar.add(CalenderHorizontalStruct(
      calenderDate: current,
      calenderDay: DateFormat('E').format(current), // 예: "Mon", "Tue"
    ));
  }

  return calendar;
}

dynamic returnCashLocationJsonObjective(
  dynamic jsonObject,
  String cashLocationId,
) {
  if (jsonObject == null || cashLocationId == null) return null;

  try {
    final Map<String, dynamic> data = Map<String, dynamic>.from(jsonObject);

    if (data.containsKey("data")) {
      for (final entry in data["data"]) {
        final List<dynamic> items = entry["items"];
        for (final item in items) {
          if (item["cash_location_id"] == cashLocationId) {
            return item; // ✅ 오직 이 객체 하나만 리턴
          }
        }
      }
    }

    return null;
  } catch (e) {
    return null;
  }
}

List<dynamic> generateDebtJournalLines(
  String transactionType,
  String transactionWay,
  String counterpartyId,
  double amount,
  String myCashLocationId,
  String cashAccountId,
  String payableAccountId,
  String payableNoteAccountId,
  String receivableAccountId,
  String receivableNoteAccountId,
  bool isInternalCompany,
  String? counterpartyCashLocationId,
  String? linkedCompanyStoreId,
  String? description,
  double? interestRate,
  String? interestAccountId,
  int? interestDueDay,
  String? issueDate,
  String? dueDate,
) {
  // transactionType에 따라 direction 설정
  final direction = transactionType == 'borrow' ? 'payable' : 'receivable';

  String debtAccountId;
  if (direction == 'payable') {
    debtAccountId =
        transactionWay == 'note' ? payableNoteAccountId : payableAccountId;
  } else {
    debtAccountId = transactionWay == 'note'
        ? receivableNoteAccountId
        : receivableAccountId;
  }

  final debtInfo = <String, dynamic>{
    'direction': direction,
    'category': transactionWay,
    'counterparty_id': counterpartyId,
  };

  if (interestRate != null && interestRate > 0) {
    debtInfo['interest_rate'] = interestRate;
  }

  if (interestAccountId != null && interestAccountId.isNotEmpty) {
    debtInfo['interest_account_id'] = interestAccountId;
  }

  // interest_due_day는 항상 null로 처리 (이전 요청사항)

  // issue_date 처리 - 값이 없으면 현재 날짜 사용
  if (issueDate != null && issueDate.isNotEmpty) {
    debtInfo['issue_date'] = issueDate;
  } else {
    debtInfo['issue_date'] = DateTime.now().toIso8601String();
  }

  if (dueDate != null && dueDate.isNotEmpty) {
    debtInfo['due_date'] = dueDate;
  }

  if (description != null && description.isNotEmpty) {
    debtInfo['description'] = description;
  }

  // 내부 회사 거래시 linkedCounterparty_store_id만 설정
  // linked_company_id는 DB 함수에서 자동으로 조회함
  if (isInternalCompany &&
      linkedCompanyStoreId != null &&
      linkedCompanyStoreId.isNotEmpty) {
    debtInfo['linkedCounterparty_store_id'] = linkedCompanyStoreId;
  }

  final transactionTypeKr = transactionType == 'borrow' ? '차입' : '상환';
  final transactionWayKr = transactionWay == 'note' ? '어음' : '현금';

  final lines = <Map<String, dynamic>>[];

  if (transactionType == 'borrow') {
    // 차입: 현금 들어옴(차변), 부채 발생(대변)
    lines.add({
      'account_id': cashAccountId,
      'description': description ?? '$transactionWayKr $transactionTypeKr - 수령',
      'debit': amount,
      'credit': 0,
      'cash': {
        'cash_location_id': myCashLocationId,
      },
    });

    lines.add({
      'account_id': debtAccountId,
      'description': description ?? '$transactionWayKr $transactionTypeKr - 발생',
      'debit': 0,
      'credit': amount,
      'debt': debtInfo,
    });
  } else {
    // 상환: 채권 감소(차변), 현금 나감(대변)
    lines.add({
      'account_id': debtAccountId,
      'description': description ?? '$transactionWayKr $transactionTypeKr',
      'debit': amount,
      'credit': 0,
      'debt': debtInfo,
    });

    lines.add({
      'account_id': cashAccountId,
      'description': description ?? '$transactionWayKr $transactionTypeKr - 지급',
      'debit': 0,
      'credit': amount,
      'cash': {
        'cash_location_id': myCashLocationId,
      },
    });
  }

  return lines;
}

GetTodayPlusMinusStruct? getTodayPlusMinus(
  DateTime? date,
  int? number,
) {
  if (date == null || number == null) return null;

  // 기준일 = 입력된 날짜 + number 일
  final baseDate = date.add(Duration(days: number));

  // 날짜 이동 및 요일 구하기 helper 함수
  DateTime getShiftedDate(int shift) => baseDate.add(Duration(days: shift));
  String getDayString(DateTime date) =>
      DateFormat('E').format(date); // Mon, Tue 등

  return GetTodayPlusMinusStruct(
    date0: getShiftedDate(0),
    day0: getDayString(getShiftedDate(0)),
    dateM1: getShiftedDate(-1),
    dayM1: getDayString(getShiftedDate(-1)),
    dateM2: getShiftedDate(-2),
    dayM2: getDayString(getShiftedDate(-2)),
    datetmw: getShiftedDate(1),
    daytmw: getDayString(getShiftedDate(1)),
    datetmw2: getShiftedDate(2),
    daytmw2: getDayString(getShiftedDate(2)),
  );
}

DateTime? insertStartEndTime(
  String? scheduledTime,
  String? date,
) {
  if (scheduledTime == null || scheduledTime.isEmpty) {
    return null;
  }
  if (date == null || date.isEmpty) {
    return null;
  }

  try {
    final combined = "$date $scheduledTime";
    return DateTime.tryParse(combined);
  } catch (e) {
    return null;
  }
}

bool? booldateinjson(
  List<dynamic>? json,
  String? date,
) {
  if (json == null || date == null) return false;

  // 입력 날짜에서 "yyyy-MM" 추출
  final inputMonth = date.substring(0, 7);

  // month 값만 뽑아서 문자열 리스트로 변환
  final monthList = json
      .map((item) {
        try {
          final map = Map<String, dynamic>.from(item);
          return map['month']?.toString();
        } catch (_) {
          return null;
        }
      })
      .where((m) => m != null)
      .cast<String>()
      .toList();

  return monthList.contains(inputMonth);
}

double jsonToDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is double) {
    return value;
  }

  if (value is int) {
    return value.toDouble();
  }

  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }

  return 0.0;
}

List<VShiftRequestMonthStruct>? updateShiftRequestMonth(
  List<VShiftRequestMonthStruct>? vshiftRequestData,
  String? shiftRequestId,
  String? time,
  bool? trueStartFalseEnd,
) {
  if (vshiftRequestData == null ||
      shiftRequestId == null ||
      time == null ||
      trueStartFalseEnd == null) {
    return vshiftRequestData;
  }

  return vshiftRequestData.map((item) {
    if (item.shiftRequestId != shiftRequestId) {
      return item;
    }

    return VShiftRequestMonthStruct(
      shiftRequestId: item.shiftRequestId,
      shiftId: item.shiftId,
      actualStartTime: trueStartFalseEnd ? time : item.actualStartTime,
      actualEndTime: !trueStartFalseEnd ? time : item.actualEndTime,
      requestDate: item.requestDate,
      totalSalaryPay: item.totalSalaryPay,
      salaryType: item.salaryType,
      paidHour: item.paidHour,
      salaryAmount: item.salaryAmount,
      lateDeducutAmount: item.lateDeducutAmount,
      overtimeAmount: item.overtimeAmount,
      isLate: item.isLate,
      isValidCheckoutLocation: item.isValidCheckoutLocation,
      isValidCheckinLocation: item.isValidCheckinLocation,
      bonusAmount: item.bonusAmount,
      startTime: item.startTime,
      endTime: item.endTime,
      isApproved: item.isApproved,
      confirmStartTime: item.confirmStartTime,
      confirmEndTime: item.confirmEndTime,
    );
  }).toList();
}

DateTime? getMonthFirstLast(
  String? date,
  bool? trueFirstFalseLast,
) {
  if (date == null || trueFirstFalseLast == null) return null;

  try {
    final parsedDate = DateTime.parse(date);
    if (trueFirstFalseLast) {
      // 해당 월의 첫 날
      return DateTime(parsedDate.year, parsedDate.month, 1);
    } else {
      // 다음 달의 첫 날에서 하루 빼기 = 해당 월의 마지막 날
      final nextMonth = DateTime(parsedDate.year, parsedDate.month + 1, 1);
      return nextMonth.subtract(Duration(days: 1));
    }
  } catch (e) {
    return null;
  }
}

dynamic convertStringToJson(String? string) {
// null 체크
  if (string == null || string.isEmpty) {
    return null;
  }

  try {
    // JSON 문자열을 dynamic 객체로 파싱
    return jsonDecode(string);
  } catch (e) {
    // JSON 파싱 실패 시 null 반환
    print('JSON parsing error: $e');
    return null;
  }
}

DateTime convertJsonToTime(dynamic jsonTime) {
  try {
    return DateTime.parse(jsonTime); // ISO8601 형식 변환
  } catch (e) {
    // 잘못된 형식이면 현재 시간 반환 (혹은 null 처리도 가능)
    return DateTime.now();
  }
}

String? generateExternalUrl(
  String? userId,
  String? userName,
  String? companyId,
  String? storeId,
) {
  final baseUrl = 'https://jinl2.github.io/contentsCreation/';
  final encodedUserName = Uri.encodeComponent(userName ?? '');

  final url =
      '$baseUrl?user_id=$userId&user_name=$encodedUserName&company_id=$companyId&store_id=$storeId';

  return url;
}

List<dynamic>? overviewMonthlyStat(
  dynamic overviewJson,
  List<dynamic>? monthlyStat,
) {
  try {
    // 입력값 유효성 검사
    if (overviewJson == null) {
      return monthlyStat;
    }

    // overviewJson을 Map으로 변환
    Map<String, dynamic> overviewData;
    if (overviewJson is String) {
      overviewData = jsonDecode(overviewJson);
    } else if (overviewJson is Map<String, dynamic>) {
      overviewData = overviewJson;
    } else {
      return monthlyStat;
    }

    // stores 배열 확인
    if (!overviewData.containsKey('stores') ||
        overviewData['stores'] == null ||
        !(overviewData['stores'] is List)) {
      return monthlyStat;
    }

    List<dynamic> stores = overviewData['stores'];

    // 결과 리스트 초기화
    List<dynamic> result = monthlyStat != null ? List.from(monthlyStat) : [];

    // 각 store의 monthly_stats 추출하여 결과에 추가
    for (var store in stores) {
      if (store is Map<String, dynamic> &&
          store.containsKey('monthly_stats') &&
          store['monthly_stats'] != null &&
          store['monthly_stats'] is List) {
        List<dynamic> monthlyStats = store['monthly_stats'];

        // monthly_stats의 각 항목을 결과에 추가
        for (var stat in monthlyStats) {
          if (stat is Map<String, dynamic>) {
            result.add(stat);
          }
        }
      }
    }

    return result;
  } catch (e) {
    // 에러 발생 시 기존 monthlyStat 반환
    return monthlyStat;
  }
}

List<dynamic>? managerCard(
  dynamic apiShiftCard,
  List<dynamic>? storeData,
) {
  try {
    // 1단계: storeData 검증 및 처리
    Map<String, dynamic>? baseStore;

    if (storeData != null && storeData.isNotEmpty) {
      final firstItem = storeData[0];

      if (firstItem is String) {
        try {
          baseStore = jsonDecode(firstItem);
        } catch (e) {
          return null; // 잘못된 JSON이면 null 반환
        }
      } else if (firstItem is Map<String, dynamic>) {
        baseStore = Map<String, dynamic>.from(firstItem);
      } else {
        return null;
      }
    }

    // baseStore가 없으면 null 반환 (가상 데이터 생성 안 함)
    if (baseStore == null) {
      return null;
    }

    // 2단계: baseStore 구조 검증
    final requiredFields = [
      'store_id',
      'store_name',
      'request_count',
      'approved_count',
      'problem_count'
    ];
    for (final field in requiredFields) {
      if (!baseStore.containsKey(field)) {
        return null;
      }
    }

    // cards 필드 초기화
    if (!baseStore.containsKey('cards') || baseStore['cards'] is! List) {
      baseStore['cards'] = [];
    }

    List<dynamic> existingCards = List.from(baseStore['cards']);

    // 3단계: apiShiftCard 처리
    if (apiShiftCard == null) {
      baseStore['cards'] = existingCards;
      return [baseStore];
    }

    Map<String, dynamic> apiData;
    if (apiShiftCard is String) {
      try {
        apiData = jsonDecode(apiShiftCard);
      } catch (e) {
        baseStore['cards'] = existingCards;
        return [baseStore];
      }
    } else if (apiShiftCard is Map<String, dynamic>) {
      apiData = apiShiftCard;
    } else {
      baseStore['cards'] = existingCards;
      return [baseStore];
    }

    // 4단계: API에서 cards 추출
    if (apiData.containsKey('cards') && apiData['cards'] is List) {
      final newCards = apiData['cards'] as List;

      // 각 카드 유효성 검증
      for (final card in newCards) {
        if (card is Map<String, dynamic>) {
          // 필수 필드 체크
          final cardRequiredFields = ['shift_request_id', 'user_name'];
          bool isValidCard = true;

          for (final field in cardRequiredFields) {
            if (!card.containsKey(field)) {
              isValidCard = false;
              break;
            }
          }

          if (isValidCard) {
            existingCards.add(card);
          }
        }
      }
    }

    // 5단계: 최종 결과 생성
    baseStore['cards'] = existingCards;
    return [baseStore];
  } catch (error) {
    return null; // 오류 시 null 반환
  }
}

bool? getDateEarlyLate(
  DateTime? date1,
  DateTime? date2,
) {
  try {
    // 입력값 유효성 검사
    if (date1 == null || date2 == null) {
      return null;
    }

    // DateTime을 yyyy-MM-dd 형식으로 변환하여 비교
    final formatter = DateFormat('yyyy-MM-dd');

    final date1String = formatter.format(date1);
    final date2String = formatter.format(date2);

    // 문자열로 변환된 날짜를 다시 DateTime으로 파싱 (시간 정보 제거)
    final date1Only = DateTime.parse(date1String);
    final date2Only = DateTime.parse(date2String);

    // date1이 date2보다 빠른 날짜면 true, 아니면 false
    return date1Only.isBefore(date2Only);
  } catch (e) {
    // 오류 발생 시 null 반환
    return null;
  }
}

String? makeInitial(String? name) {
  if (name == null || name.trim().isEmpty) {
    return null;
  }

// 공백으로 분리하여 첫 번째 단어 가져오기
  List<String> words = name.trim().split(' ');
  if (words.isEmpty) {
    return null;
  }

  String firstWord = words[0];
  if (firstWord.isEmpty) {
    return null;
  }

// 첫 번째 글자 추출 및 대문자 변환
  String firstLetter = firstWord.substring(0, 1);
  return firstLetter.toUpperCase();
}

List<dynamic>? changeTotalProblems(
  List<dynamic>? json,
  String? month,
  int? integer,
) {
  // null 체크
  if (json == null || month == null || integer == null) {
    return json;
  }

  // 원본 리스트를 복사하여 수정
  List<dynamic> result = List<dynamic>.from(json);

  // 해당 month를 찾아서 total_problems 값 수정
  for (int i = 0; i < result.length; i++) {
    if (result[i] is Map<String, dynamic>) {
      Map<String, dynamic> item = Map<String, dynamic>.from(result[i]);

      // month가 일치하는 경우 total_problems 값 수정
      if (item['month'] == month) {
        int currentProblems = item['total_problems'] ?? 0;
        item['total_problems'] = currentProblems + integer;
        result[i] = item;
        break; // 해당 month를 찾았으므로 반복 중단
      }
    }
  }

  return result;
}

List<dynamic>? managerTagFilter(
  dynamic managerCardApi,
  List<dynamic>? tagFilter,
) {
  try {
    // 1단계: 새로운 API 응답에서 available_contents 추출
    List<dynamic> newContents = [];

    if (managerCardApi != null) {
      Map<String, dynamic> apiData;

      if (managerCardApi is String) {
        try {
          apiData = jsonDecode(managerCardApi);
        } catch (e) {
          apiData = {};
        }
      } else if (managerCardApi is Map<String, dynamic>) {
        apiData = managerCardApi;
      } else {
        apiData = {};
      }

      // API에서 available_contents 추출
      if (apiData.containsKey('available_contents') &&
          apiData['available_contents'] is List) {
        newContents = List.from(apiData['available_contents']);
      }
    }

    // 2단계: 기존 tagFilter에서 available_contents 추출
    List<dynamic> existingContents = [];

    if (tagFilter != null && tagFilter.isNotEmpty) {
      existingContents = List.from(tagFilter);
    }

    // 3단계: 두 리스트 합치기
    List<dynamic> combinedContents = [];
    combinedContents.addAll(existingContents);
    combinedContents.addAll(newContents);

    // 4단계: 중복 제거 (content 기준으로)
    List<dynamic> uniqueContents = [];
    Set<String> seenContents = {};

    for (final item in combinedContents) {
      if (item is Map<String, dynamic> && item.containsKey('content')) {
        final content = item['content']?.toString() ?? '';

        if (content.isNotEmpty && !seenContents.contains(content)) {
          seenContents.add(content);
          uniqueContents
              .add({'content': item['content'], 'type': item['type'] ?? ''});
        }
      }
    }

    // 5단계: content 기준으로 알파벳 순 정렬
    uniqueContents.sort((a, b) {
      final contentA = a['content']?.toString() ?? '';
      final contentB = b['content']?.toString() ?? '';
      return contentA.compareTo(contentB);
    });

    return uniqueContents;
  } catch (error) {
    // 오류 발생 시 기존 tagFilter 반환 (없으면 빈 리스트)
    return tagFilter ?? [];
  }
}

bool? filterCardTags(
  List<dynamic>? noticeTag,
  String? content,
) {
  try {
    // 1단계: 입력값 검증
    if (content == null || content.isEmpty) {
      return false;
    }

    // 2단계: "all" 체크 - 대소문자 구분 없이
    if (content.toLowerCase() == 'all') {
      return true;
    }

    // 3단계: noticeTag가 null이거나 비어있으면 false
    if (noticeTag == null || noticeTag.isEmpty) {
      return false;
    }

    // 4단계: noticeTag 리스트에서 content 검색
    for (final tag in noticeTag) {
      if (tag is Map<String, dynamic>) {
        // tag에서 content 필드 추출
        final tagContent = tag['content']?.toString();

        if (tagContent != null && tagContent.isNotEmpty) {
          // 정확한 일치 검사
          if (tagContent == content) {
            return true;
          }
        }
      }
    }

    // 5단계: 일치하는 content가 없으면 false
    return false;
  } catch (error) {
    // 오류 발생 시 false 반환
    return false;
  }
}
