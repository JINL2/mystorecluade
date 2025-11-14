/**
 * StoreValidator - 상점 검증 규칙 정의
 * Clean Architecture Domain Layer
 *
 * 역할: 검증 규칙만 정의 (static methods)
 * 실행: presentation/hooks/useStore.ts에서 호출
 */

export interface ValidationError {
  field: string;
  message: string;
}

export class StoreValidator {
  /**
   * 상점 이름 검증
   */
  static validateStoreName(name: string): ValidationError | null {
    if (!name || !name.trim()) {
      return { field: 'storeName', message: 'Store name is required' };
    }

    if (name.trim().length < 2) {
      return { field: 'storeName', message: 'Store name must be at least 2 characters' };
    }

    if (name.trim().length > 100) {
      return { field: 'storeName', message: 'Store name must not exceed 100 characters' };
    }

    return null;
  }

  /**
   * 전화번호 검증 (Optional)
   */
  static validatePhone(phone: string | null): ValidationError | null {
    if (!phone || !phone.trim()) {
      return null; // Optional field
    }

    // 기본적인 전화번호 형식 체크 (숫자, 하이픈, 괄호, 스페이스, + 허용)
    const phoneRegex = /^[0-9\-+() ]+$/;
    if (!phoneRegex.test(phone)) {
      return { field: 'phone', message: 'Invalid phone number format. Use numbers, spaces, hyphens, or parentheses.' };
    }

    // 전화번호는 최소 8자 이상
    const digitsOnly = phone.replace(/[^0-9]/g, '');
    if (digitsOnly.length < 8) {
      return { field: 'phone', message: 'Phone number must contain at least 8 digits' };
    }

    return null;
  }

  /**
   * 주소 검증 (Optional)
   */
  static validateAddress(address: string | null): ValidationError | null {
    if (!address || !address.trim()) {
      return null; // Optional field
    }

    if (address.trim().length > 255) {
      return { field: 'address', message: 'Address must not exceed 255 characters' };
    }

    return null;
  }

  /**
   * 상점 생성 전체 검증
   */
  static validateCreateStore(
    storeName: string,
    address: string | null,
    phone: string | null
  ): ValidationError[] {
    const errors: ValidationError[] = [];

    // 상점 이름 검증 (필수)
    const nameError = this.validateStoreName(storeName);
    if (nameError) {
      errors.push(nameError);
    }

    // 주소 검증 (선택)
    const addressError = this.validateAddress(address);
    if (addressError) {
      errors.push(addressError);
    }

    // 전화번호 검증 (선택)
    const phoneError = this.validatePhone(phone);
    if (phoneError) {
      errors.push(phoneError);
    }

    return errors;
  }

  /**
   * Huddle Time 검증 (분 단위)
   */
  static validateHuddleTime(minutes: number | null): ValidationError | null {
    if (minutes === null) return null; // Optional

    if (minutes < 0) {
      return { field: 'huddleTime', message: 'Huddle time cannot be negative' };
    }

    if (minutes > 1440) { // 24시간 = 1440분
      return { field: 'huddleTime', message: 'Huddle time cannot exceed 24 hours (1440 minutes)' };
    }

    return null;
  }

  /**
   * Payment Time 검증 (분 단위)
   */
  static validatePaymentTime(minutes: number | null): ValidationError | null {
    if (minutes === null) return null; // Optional

    if (minutes < 0) {
      return { field: 'paymentTime', message: 'Payment time cannot be negative' };
    }

    if (minutes > 1440) { // 24시간 = 1440분
      return { field: 'paymentTime', message: 'Payment time cannot exceed 24 hours (1440 minutes)' };
    }

    return null;
  }

  /**
   * Allowed Distance 검증 (미터 단위)
   */
  static validateAllowedDistance(meters: number | null): ValidationError | null {
    if (meters === null) return null; // Optional

    if (meters < 0) {
      return { field: 'allowedDistance', message: 'Allowed distance cannot be negative' };
    }

    if (meters > 10000) { // 10km 제한
      return { field: 'allowedDistance', message: 'Allowed distance cannot exceed 10,000 meters (10km)' };
    }

    return null;
  }
}
