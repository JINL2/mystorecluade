# MyFinance Web Application - Pages Directory

## 📁 Page Organization Structure

This directory contains all the individual pages of the MyFinance web application, organized by functionality and purpose.

```
pages/
├── README.md                 # This file - page organization guide
├── index.html               # Landing/welcome page
├── auth/                    # Authentication pages
│   └── login.html          # Login and signup page
└── dashboard/              # Dashboard and main app pages
    └── dashboard.html      # Main dashboard page
```

---

## 🚀 Getting Started

### **Direct Access URLs:**

When running on XAMPP, access the pages using these URLs:

**🏠 Landing Page:**
```
http://localhost/mcparrange-main/myFinance_claude/website/pages/index.html
```

**🔐 Login Page:**
```
http://localhost/mcparrange-main/myFinance_claude/website/pages/auth/login.html
```

**📊 Dashboard:**
```
http://localhost/mcparrange-main/myFinance_claude/website/pages/dashboard/dashboard.html
```

---

## 📄 Page Details

### **🏠 Landing Page** (`/pages/index.html`)

**Purpose**: Welcome page and entry point for new users

**Features**:
- Modern gradient background design
- Feature showcase with icons
- Call-to-action buttons (Get Started, View Demo)
- Auto-redirect if user already logged in
- Responsive design for mobile/desktop

**Components Used**:
- Toss buttons (primary, outline)
- Toast notifications
- Loading spinners

**Navigation**:
- **Get Started** → Redirects to login page
- **View Demo** → Shows demo info then redirects to login

---

### **🔐 Authentication Pages** (`/pages/auth/`)

#### **Login Page** (`auth/login.html`)

**Purpose**: User authentication (login and signup)

**Features**:
- Login and signup mode toggle
- Form validation with real-time feedback
- Password visibility toggle
- Demo credentials for testing
- Supabase authentication integration
- Forgot password functionality
- Loading states and error handling

**Components Used**:
- Toss input components (email, password)
- Toss buttons (primary, outline, loading states)
- Alert/toast notifications for feedback
- Form validation with error messages

**Demo Credentials** (for testing):
- **Email**: demo@myfinance.com
- **Password**: demo123456

**Navigation**:
- **Successful Login** → Redirects to dashboard
- **Create Account** → Toggles to signup mode
- **Forgot Password** → Sends reset email

---

### **📊 Dashboard Pages** (`/pages/dashboard/`)

#### **Main Dashboard** (`dashboard/dashboard.html`)

**Purpose**: Post-login main application interface

**Features**:
- User info display (name, email, login time)
- Authentication status indicator
- Feature overview cards
- Sign out functionality
- Coming soon placeholders for future features

**Components Used**:
- Navigation header with user info
- Feature cards with hover effects
- Button components
- Alert notifications

**Navigation**:
- **Sign Out** → Redirects to login page
- **Feature Buttons** → Show "coming soon" messages

---

## 🔗 Page Navigation Flow

```
Landing Page (index.html)
    ↓ [Get Started / View Demo]
Login Page (auth/login.html)
    ↓ [Successful Login]
Dashboard (dashboard/dashboard.html)
    ↓ [Sign Out]
Login Page (auth/login.html)
```

---

## 🎯 Component Integration

### **Required CSS Files** (for all pages):
```html
<!-- Theme CSS -->
<link rel="stylesheet" href="../../css/theme/toss-variables.css">
<link rel="stylesheet" href="../../css/theme/toss-base.css">
<link rel="stylesheet" href="../../css/theme/toss-typography.css">

<!-- Component CSS -->
<link rel="stylesheet" href="../../components/base/toss-button.css">
<link rel="stylesheet" href="../../components/form/toss-input.css">
<link rel="stylesheet" href="../../components/feedback/toss-alert.css">
```

### **Required JavaScript Files**:
```html
<!-- Supabase CDN -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<!-- Component JavaScript -->
<script src="../../components/base/toss-button.js"></script>
<script src="../../components/form/toss-input.js"></script>
<script src="../../components/feedback/toss-alert.js"></script>

<!-- Supabase Configuration -->
<script src="../../js/config/supabase.js"></script>
```

---

## 🛠️ Development Notes

### **Path References**:
All pages use **relative paths** to reference components and assets:
- **From auth/ pages**: `../../` to reach website root
- **From dashboard/ pages**: `../../` to reach website root
- **From root pages/**: `../` to reach website root

### **Supabase Integration**:
All pages that require authentication include:
1. Supabase CDN script
2. Local Supabase configuration (`js/config/supabase.js`)
3. Authentication state checking
4. Proper redirect handling

### **Responsive Design**:
All pages are mobile-first responsive:
- **Mobile** (< 768px): Optimized layout and navigation
- **Tablet** (768px - 1023px): Balanced layout
- **Desktop** (≥ 1024px): Full featured layout

---

## 🚧 Future Pages to Add

As the application grows, add new page folders:

```
pages/
├── transactions/           # Transaction management
│   ├── list.html          # Transaction listing
│   ├── create.html        # Create new transaction
│   └── detail.html        # Transaction details
├── reports/               # Financial reports
│   ├── balance-sheet.html # Balance sheet report
│   ├── income.html        # Income statement
│   └── cash-flow.html     # Cash flow report
├── settings/              # User and system settings
│   ├── profile.html       # User profile
│   ├── companies.html     # Company management
│   └── preferences.html   # User preferences
└── help/                  # Help and documentation
    ├── guide.html         # User guide
    └── support.html       # Support contact
```

---

## 🔧 Testing Guidelines

### **Local Testing Checklist**:

1. **Start XAMPP** and ensure Apache is running
2. **Configure Supabase** credentials in `/js/config/supabase.js`
3. **Test Landing Page**:
   - Visit `http://localhost/mcparrange-main/myFinance_claude/website/pages/index.html`
   - Check responsive design
   - Test navigation buttons

4. **Test Authentication**:
   - Click "Get Started" to reach login page
   - Test with demo credentials
   - Test form validation
   - Test signup flow
   - Test password reset

5. **Test Dashboard**:
   - Verify successful login redirect
   - Check user info display
   - Test sign out functionality
   - Verify responsive design

### **Browser Testing**:
- **Chrome** (Primary)
- **Firefox** 
- **Safari** (if on Mac)
- **Mobile devices** (Chrome DevTools)

---

## 📱 Mobile Optimization

All pages are optimized for mobile devices:

- **Touch-friendly buttons** (minimum 44px touch targets)
- **Readable text** (minimum 16px font size to prevent zoom)
- **Proper viewport** meta tag
- **Responsive layouts** with mobile-first CSS
- **Fast loading** with optimized assets

---

This page organization structure provides a solid foundation for building out the complete MyFinance web application with proper separation of concerns and scalable architecture.