import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/card_input_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'input_card.freezed.dart';

/// Input Card UseCase
///
/// Inputs comprehensive shift card data with confirmed times and tags.
class InputCard implements UseCase<CardInputResult, InputCardParams> {
  final TimeTableRepository _repository;

  InputCard(this._repository);

  @override
  Future<CardInputResult> call(InputCardParams params) async {
    if (params.managerId.isEmpty) {
      throw ArgumentError('Manager ID cannot be empty');
    }

    if (params.shiftRequestId.isEmpty) {
      throw ArgumentError('Shift request ID cannot be empty');
    }

    if (params.confirmStartTime.isEmpty) {
      throw ArgumentError('Confirm start time cannot be empty');
    }

    if (params.confirmEndTime.isEmpty) {
      throw ArgumentError('Confirm end time cannot be empty');
    }

    // Validate time format (HH:mm or HH:mm:ss)
    final timeRegex = RegExp(r'^\d{2}:\d{2}(:\d{2})?$');
    if (!timeRegex.hasMatch(params.confirmStartTime)) {
      throw ArgumentError('Invalid start time format. Expected HH:mm or HH:mm:ss');
    }

    if (!timeRegex.hasMatch(params.confirmEndTime)) {
      throw ArgumentError('Invalid end time format. Expected HH:mm or HH:mm:ss');
    }

    return await _repository.inputCard(
      managerId: params.managerId,
      shiftRequestId: params.shiftRequestId,
      confirmStartTime: params.confirmStartTime,
      confirmEndTime: params.confirmEndTime,
      newTagContent: params.newTagContent,
      newTagType: params.newTagType,
      isLate: params.isLate,
      isProblemSolved: params.isProblemSolved,
    );
  }
}

/// Parameters for InputCard UseCase
@freezed
class InputCardParams with _$InputCardParams {
  const factory InputCardParams({
    required String managerId,
    required String shiftRequestId,
    required String confirmStartTime,
    required String confirmEndTime,
    String? newTagContent,
    String? newTagType,
    required bool isLate,
    required bool isProblemSolved,
  }) = _InputCardParams;
}
