# Auth Feature - Workflow Documentation

## 📁 Folder Structure (Clean Architecture)

```
lib/features/auth/
├── data/                          # Data Layer
│   ├── datasources/               # External data sources
│   │   └── supabase_auth_datasource.dart   # Supabase Auth API calls
│   ├── models/                    # Data transfer objects
│   │   └── freezed/               # Freezed DTOs
│   └── repositories/              # Repository implementations
│       └── auth_repository_impl.dart
│
├── domain/                        # Domain Layer (Business Logic)
│   ├── entities/                  # Business entities
│   │   └── user_entity.dart
│   ├── repositories/              # Repository interfaces
│   │   └── auth_repository.dart
│   ├── usecases/                  # Use cases
│   │   ├── login_usecase.dart
│   │   ├── signup_usecase.dart
│   │   ├── logout_usecase.dart
│   │   ├── send_password_otp_usecase.dart
│   │   ├── verify_password_otp_usecase.dart
│   │   ├── update_password_usecase.dart
│   │   ├── resend_signup_otp_usecase.dart
│   │   └── verify_signup_otp_usecase.dart
│   └── exceptions/                # Domain exceptions
│
└── presentation/                  # Presentation Layer
    ├── pages/                     # UI Pages
    │   ├── auth_welcome_page.dart
    │   ├── login_page.dart
    │   ├── signup_page.dart
    │   ├── verify_email_otp_page.dart    # Email verification after signup
    │   ├── forgot_password_page.dart
    │   ├── verify_otp_page.dart          # OTP verification for password reset
    │   ├── reset_password_page.dart
    │   └── choose_role_page.dart
    └── providers/                 # Riverpod providers
        ├── auth_service.dart      # AuthService facade
        ├── usecase_providers.dart # UseCase providers
        └── repository_providers.dart
```

---

## 🔐 Authentication Workflows

### 1. Sign Up Flow (Email OTP Verification)

```
┌─────────────────┐     ┌────────────────────┐     ┌───────────────────┐
│   SignupPage    │────>│ VerifyEmailOtpPage │────>│  ChooseRolePage   │
└─────────────────┘     └────────────────────┘     └───────────────────┘
        │                        │                          │
   [Create Account]         [Verify OTP]            [Select Role]
   authService.signUp()   authService.verifySignupOtp()
```

**Steps:**
1. User enters email, password, first/last name
2. SignupPage calls `authService.signUp()`
3. Supabase sends 6-digit OTP to email
4. Navigate to `/auth/verify-email`
5. User enters OTP code
6. VerifyEmailOtpPage calls `authService.verifySignupOtp()`
7. On success, navigate to `/onboarding/choose-role`

**Supabase Settings:**
- Dashboard → Authentication → Sign In / Providers → Email
- Enable "Confirm email" ✅
- Use "Confirm sign up" email template with `{{ .Token }}`

---

### 2. Login Flow

```
┌─────────────────┐     ┌───────────────────────────────────────────┐
│   LoginPage     │────>│ Homepage (has company) OR ChooseRolePage  │
└─────────────────┘     └───────────────────────────────────────────┘
        │
   [Sign In]
   authService.signIn()
```

**Steps:**
1. User enters email and password
2. LoginPage calls `authService.signIn()`
3. Router redirect checks if user has companies
   - Has companies → `/` (Homepage)
   - No companies → `/onboarding/choose-role`

---

### 3. Password Recovery Flow (OTP Method)

```
┌─────────────────────┐     ┌───────────────┐     ┌───────────────────┐     ┌─────────────┐
│ ForgotPasswordPage  │────>│ VerifyOtpPage │────>│ ResetPasswordPage │────>│  LoginPage  │
└─────────────────────┘     └───────────────┘     └───────────────────┘     └─────────────┘
         │                         │                       │
    [Send OTP]              [Verify OTP]            [Set New Password]
 authService.sendPasswordOtp()  authService.verifyPasswordOtp()  authService.updatePassword()
```

**Steps:**
1. User enters email on ForgotPasswordPage
2. Calls `authService.sendPasswordOtp()`
3. Supabase sends 6-digit OTP to email
4. Navigate to `/auth/verify-otp`
5. User enters OTP code
6. Calls `authService.verifyPasswordOtp()`
7. On success, navigate to `/auth/reset-password`
8. User enters new password
9. Calls `authService.updatePassword()`
10. Navigate to `/auth/login`

**Supabase Settings:**
- Use "Magic Link" email template with `{{ .Token }}`

---

## 🛣️ Routes

| Path | Page | Description |
|------|------|-------------|
| `/auth` | AuthWelcomePage | Welcome screen with login/signup options |
| `/auth/login` | LoginPage | Email/password login |
| `/auth/signup` | SignupPage | Create new account |
| `/auth/verify-email` | VerifyEmailOtpPage | Verify email after signup |
| `/auth/forgot-password` | ForgotPasswordPage | Request password reset |
| `/auth/verify-otp` | VerifyOtpPage | Enter OTP for password reset |
| `/auth/reset-password` | ResetPasswordPage | Set new password |
| `/onboarding/choose-role` | ChooseRolePage | Select owner/employee role |

---

## 📧 Supabase Email Templates

### Confirm sign up (Email Verification)
```html
Subject: Your Verification Code

<h2>Verify Your Email</h2>
<p>Your verification code is:</p>
<h1 style="font-size: 32px; letter-spacing: 8px; text-align: center;
    background: #f5f5f5; padding: 20px; border-radius: 8px;">
  {{ .Token }}
</h1>
<p>Enter this 6-digit code in the app to complete your registration.</p>
<p>This code expires in 1 hour.</p>
```

### Magic Link (Password Recovery OTP)
```html
Subject: Your Password Reset Code

<h2>Reset Your Password</h2>
<p>Your password reset code is:</p>
<h1 style="font-size: 32px; letter-spacing: 8px; text-align: center;
    background: #f5f5f5; padding: 20px; border-radius: 8px;">
  {{ .Token }}
</h1>
<p>Enter this 6-digit code in the app to reset your password.</p>
<p>This code expires in 1 hour.</p>
```

---

## 🔄 AuthService Methods

| Method | Description |
|--------|-------------|
| `signIn()` | Login with email/password |
| `signUp()` | Create account (sends verification email) |
| `signOut()` | Logout and clear session |
| `resendSignupOtp()` | Resend email verification OTP |
| `verifySignupOtp()` | Verify email after signup |
| `sendPasswordOtp()` | Send password recovery OTP |
| `verifyPasswordOtp()` | Verify OTP for password reset |
| `updatePassword()` | Set new password |

---

## 📝 Notes

1. **OTP vs Deep Link**: Deep links didn't work reliably from email clients (Safari showed "address is invalid"), so we switched to OTP code method.

2. **Email Confirmation Required**: Supabase "Confirm email" must be enabled for signup OTP to work.

3. **Session Management**: After successful OTP verification, `SessionManager.recordLogin()` is called to establish session.
