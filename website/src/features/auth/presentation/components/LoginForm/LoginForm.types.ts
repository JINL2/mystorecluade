/**
 * LoginForm Component Types
 */

export interface LoginFormProps {
  /**
   * Callback when login is successful
   */
  onSuccess?: () => void;

  /**
   * Callback when login fails
   */
  onError?: (error: string) => void;

  /**
   * Show remember me checkbox
   * @default true
   */
  showRememberMe?: boolean;

  /**
   * Show forgot password link
   * @default true
   */
  showForgotPassword?: boolean;
}

export interface LoginFormData {
  email: string;
  password: string;
  rememberMe: boolean;
}
