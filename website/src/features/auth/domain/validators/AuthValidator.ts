/**
 * Auth Validator
 * Domain layer - Authentication validation logic
 */

export interface ValidationError {
  field: string;
  message: string;
}

export class AuthValidator {
  /**
   * Validate email format
   */
  static validateEmail(email: string): ValidationError | null {
    if (!email || email.trim() === '') {
      return { field: 'email', message: 'Email is required' };
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return { field: 'email', message: 'Invalid email format' };
    }

    return null;
  }

  /**
   * Validate password strength
   */
  static validatePassword(password: string): ValidationError | null {
    if (!password || password.trim() === '') {
      return { field: 'password', message: 'Password is required' };
    }

    if (password.length < 6) {
      return { field: 'password', message: 'Password must be at least 6 characters' };
    }

    return null;
  }

  /**
   * Validate password confirmation
   */
  static validatePasswordConfirmation(
    password: string,
    confirmation: string
  ): ValidationError | null {
    if (password !== confirmation) {
      return { field: 'passwordConfirmation', message: 'Passwords do not match' };
    }

    return null;
  }

  /**
   * Validate name (first name or last name)
   */
  static validateName(name: string, fieldName: string): ValidationError | null {
    if (!name || name.trim() === '') {
      return { field: fieldName.toLowerCase().replace(' ', ''), message: `${fieldName} is required` };
    }

    if (name.trim().length < 2) {
      return { field: fieldName.toLowerCase().replace(' ', ''), message: `${fieldName} must be at least 2 characters` };
    }

    return null;
  }

  /**
   * Validate login credentials
   */
  static validateLoginCredentials(email: string, password: string): ValidationError[] {
    const errors: ValidationError[] = [];

    const emailError = this.validateEmail(email);
    if (emailError) errors.push(emailError);

    const passwordError = this.validatePassword(password);
    if (passwordError) errors.push(passwordError);

    return errors;
  }

  /**
   * Validate signup credentials
   */
  static validateSignupCredentials(
    email: string,
    password: string,
    passwordConfirmation: string,
    firstName: string,
    lastName: string
  ): ValidationError[] {
    const errors: ValidationError[] = [];

    const emailError = this.validateEmail(email);
    if (emailError) errors.push(emailError);

    const passwordError = this.validatePassword(password);
    if (passwordError) errors.push(passwordError);

    const confirmationError = this.validatePasswordConfirmation(password, passwordConfirmation);
    if (confirmationError) errors.push(confirmationError);

    const firstNameError = this.validateName(firstName, 'First name');
    if (firstNameError) errors.push(firstNameError);

    const lastNameError = this.validateName(lastName, 'Last name');
    if (lastNameError) errors.push(lastNameError);

    return errors;
  }
}
