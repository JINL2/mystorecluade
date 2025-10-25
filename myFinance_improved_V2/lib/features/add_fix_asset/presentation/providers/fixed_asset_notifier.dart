import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/fixed_asset.dart';
import '../../domain/repositories/fixed_asset_repository.dart';
import 'states/fixed_asset_state.dart';

/// Fixed Asset Notifier - 상태 관리 + 비즈니스 로직 조율
///
/// Flutter 표준 구조: Notifier가 직접 Repository 호출
/// Simple feature이므로 UseCase 없이 Repository 직접 사용
class FixedAssetNotifier extends StateNotifier<FixedAssetState> {
  final FixedAssetRepository _repository;

  FixedAssetNotifier({
    required FixedAssetRepository repository,
  })  : _repository = repository,
        super(const FixedAssetState());

  /// 고정자산 목록 로드
  Future<void> loadAssets({
    required String companyId,
    String? storeId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final assets = await _repository.getFixedAssets(
        companyId: companyId,
        storeId: storeId,
      );

      state = state.copyWith(
        isLoading: false,
        assets: assets,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 고정자산 생성
  Future<bool> createAsset(FixedAsset asset) async {
    state = state.copyWith(isCreating: true, errorMessage: null);

    try {
      await _repository.createFixedAsset(asset);

      state = state.copyWith(isCreating: false);

      // 자동 새로고침
      await loadAssets(
        companyId: asset.companyId,
        storeId: asset.storeId,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// 고정자산 수정
  Future<bool> updateAsset(FixedAsset asset) async {
    state = state.copyWith(errorMessage: null);

    try {
      await _repository.updateFixedAsset(asset);

      // 로컬 상태에서 수정된 자산 업데이트
      final updatedAssets = state.assets.map((a) {
        return a.assetId == asset.assetId ? asset : a;
      }).toList();

      state = state.copyWith(
        assets: updatedAssets,
        errorMessage: null,
      );

      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// 고정자산 삭제
  Future<bool> deleteAsset(String assetId) async {
    state = state.copyWith(errorMessage: null);

    try {
      await _repository.deleteFixedAsset(assetId);

      // 로컬 상태에서 삭제된 자산 제거
      final updatedAssets = state.assets
          .where((asset) => asset.assetId != assetId)
          .toList();

      state = state.copyWith(
        assets: updatedAssets,
        errorMessage: null,
      );

      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Store 선택 변경
  void updateSelectedStore(String? storeId) {
    state = state.copyWith(selectedStoreId: storeId);
  }

  /// 통화 정보 업데이트
  void updateCurrency({
    String? baseCurrencyId,
    String? currencySymbol,
  }) {
    state = state.copyWith(
      baseCurrencyId: baseCurrencyId ?? state.baseCurrencyId,
      currencySymbol: currencySymbol ?? state.currencySymbol,
    );
  }

  /// 에러 메시지 지우기
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 상태 초기화
  void reset() {
    state = const FixedAssetState();
  }
}

/// Fixed Asset Form Notifier - 폼 생성/수정 전용 상태 관리
class FixedAssetFormNotifier extends StateNotifier<FixedAssetFormState> {
  FixedAssetFormNotifier() : super(const FixedAssetFormState());

  /// 필드 에러 설정
  void setFieldError(String fieldName, String error) {
    final updatedErrors = Map<String, String>.from(state.fieldErrors);
    updatedErrors[fieldName] = error;
    state = state.copyWith(fieldErrors: updatedErrors);
  }

  /// 필드 에러 지우기
  void clearFieldError(String fieldName) {
    final updatedErrors = Map<String, String>.from(state.fieldErrors);
    updatedErrors.remove(fieldName);
    state = state.copyWith(fieldErrors: updatedErrors);
  }

  /// 모든 에러 지우기
  void clearAllErrors() {
    state = state.copyWith(fieldErrors: {}, errorMessage: null);
  }

  /// 에러 메시지 설정
  void setError(String message) {
    state = state.copyWith(errorMessage: message);
  }

  /// 상태 초기화
  void reset() {
    state = const FixedAssetFormState();
  }
}
