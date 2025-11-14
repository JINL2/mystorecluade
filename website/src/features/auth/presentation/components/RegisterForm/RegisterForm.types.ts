/**
 * RegisterForm Component Types
 */

export interface RegisterFormProps {
  /**
   * Callback when registration is successful
   */
  onSuccess?: () => void;

  /**
   * Callback when registration fails
   */
  onError?: (error: string) => void;

  /**
   * Show login link
   * @default true
   */
  showLoginLink?: boolean;
}

export interface RegisterFormData {
  email: string;
  password: string;
  passwordConfirmation: string;
  firstName: string;
  lastName: string;
}
