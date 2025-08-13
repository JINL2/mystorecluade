# 🚀 MyFinance - Toss-Style Financial Management App

A modern Flutter financial management application with Toss-inspired UI/UX, built with clean architecture and powered by **Supabase** (NOT local SQL).

## 📖 Quick Start by Role - READ THIS FIRST!

### 🎨 Frontend Developer
**You MUST read these documents in order:**

1. **[App State Structure Guide](READMEAppState.md)** ⭐ CRITICAL - Mandatory app state structure
2. **[Page Setup Guide](docs/getting-started/PAGE_SETUP_GUIDE.md)** ⭐ REQUIRED - How to create new pages
3. **[Theme System](docs/design-system/THEME_SYSTEM.md)** ⭐ REQUIRED - Colors, typography, spacing
4. **[Toss Component Library](docs/components/TOSS_COMPONENT_LIBRARY.md)** ⭐ REQUIRED - Pre-built components
5. **[Toss Style Analysis](docs/design-system/TOSS_STYLE_ANALYSIS.md)** - Design principles
6. **[Feature Example](docs/getting-started/FEATURE_EXAMPLE.md)** - Complete implementation reference

**🚨 IMPORTANT Frontend Rules:**
- ✅ ALWAYS use components from `lib/presentation/widgets/toss/` first
- ✅ Use OKLCH colors: Primary `#5B5FCF`, Error `#EF4444`
- ✅ Follow 2-5% shadow opacity for Toss style
- ✅ Use TossSpacing constants (never hardcode spacing)
- ❌ DON'T create new components without checking existing ones
- ❌ DON'T use setState - use Riverpod providers

### 💾 Backend Developer
**You MUST read these documents in order:**

1. **[App State Structure Guide](READMEAppState.md)** ⭐ CRITICAL - Mandatory app state structure
2. **[Architecture Overview](docs/architecture/ARCHITECTURE.md)** ⭐ REQUIRED - Clean architecture
3. **[Supabase Database Structure](docs/database/SUPABASE_datastructure.md)** ⭐ REQUIRED - Database schema
4. **[State Management](docs/architecture/STATE_MANAGEMENT.md)** ⭐ REQUIRED - Riverpod patterns
5. **[Feature Example](docs/getting-started/FEATURE_EXAMPLE.md)** - Full implementation example

**🚨 IMPORTANT Backend Rules:**
- ✅ MUST use **Supabase** for ALL data persistence
- ✅ Follow repository pattern for data operations
- ✅ Use Freezed for models with JSON serialization
- ✅ Implement proper error handling
- ❌ NO local SQL databases - ONLY Supabase
- ❌ NO direct database calls from UI layer

### 🛠 Full-Stack Developer
**Read everything! Start with these core documents:**

1. **[App State Structure Guide](READMEAppState.md)** ⭐ CRITICAL - Mandatory app state structure
2. **[Architecture Overview](docs/architecture/ARCHITECTURE.md)** ⭐ REQUIRED
3. **[Page Setup Guide](docs/getting-started/PAGE_SETUP_GUIDE.md)** ⭐ REQUIRED
4. **[Feature Example](docs/getting-started/FEATURE_EXAMPLE.md)** ⭐ REQUIRED
5. **[Supabase Database Structure](docs/database/SUPABASE_datastructure.md)** ⭐ REQUIRED

Then dive into specific areas as needed.

### 🏗 DevOps / Infrastructure
**Focus on these documents:**

1. **[Supabase Database Structure](docs/database/SUPABASE_datastructure.md)** - Database setup
2. Environment configuration guides (coming soon)
3. Build and deployment guides (coming soon)

## Key Improvements

### 1. **Toss-Style UI/UX** ✨
- **Minimalist Design**: Clean, white-space focused interface
- **Micro-interactions**: Delightful animations and feedback
- **Typography-First**: Bold, clear visual hierarchy
- **Single Actions**: One primary CTA per screen
- **OKLCH Colors**: Your custom color system integrated

### 2. **Clean Architecture**
- **Domain Layer**: Business logic and entities
- **Data Layer**: Repository implementations and data sources
- **Presentation Layer**: UI components and state management
- Clear separation of concerns for better maintainability

### 3. **Modern State Management**
- **Unified App State**: **[📋 App State Structure Guide](READMEAppState.md)** - MANDATORY for all developers ⭐
- **Riverpod**: Type-safe, testable state management
- **Provider-based Architecture**: Modular state organization
- **Reactive Updates**: Automatic UI updates on state changes
- **State Persistence**: Automatic state saving and restoration

### 4. **Toss-Style Theme System**
- **OKLCH Color Space**: Modern perceptual color system
- **Subtle Shadows**: 2-5% opacity for depth
- **Rounded Design**: Friendly border radius (12-16px)
- **Typography**: Inter + JetBrains Mono for numbers
- **Micro-animations**: 100-300ms smooth transitions

### 5. **Toss Component Library**
- **TossBottomSheet**: Signature action sheets
- **TossAmountInput**: Beautiful number inputs
- **TossCard**: Interactive cards with animations
- **TossPrimaryButton**: Large CTAs with feedback
- **Financial Components**: Transaction items, info cards

### 6. **Improved App State**
- **Standardized Structure**: Unified app state across all features - **[📋 CRITICAL: App State Structure Guide](READMEAppState.md)** ⭐ MUST READ
- **Modular State**: Feature-based state organization
- **Type Safety**: Strongly typed state models
- **Permission System**: Role-based access control
- **Offline Support**: Local data persistence

**🚨 CRITICAL**: All developers MUST follow the **[App State Structure](READMEAppState.md)** exactly for consistency across all pages and features.

## Architecture Benefits

### Developer Experience
- ✅ Clear code organization
- ✅ Easy to test and maintain
- ✅ Type-safe development
- ✅ Reusable components
- ✅ Consistent patterns

### Performance
- ✅ Optimized rendering
- ✅ Efficient state management
- ✅ Lazy loading support
- ✅ Minimal rebuilds
- ✅ Fast navigation

### Scalability
- ✅ Modular architecture
- ✅ Easy feature addition
- ✅ Team collaboration friendly
- ✅ Clean dependency management
- ✅ Future-proof design

## Project Structure
```
myFinance_improved/
├── 📄 INDEX.md                      # 🎯 START HERE - Documentation hub
├── 📄 README.md                     # This file - Project overview
├── 📄 FOLDER_STRUCTURE.md           # Visual folder structure
├── 📂 docs/                         # 📚 All documentation organized
│   ├── 📂 getting-started/          # Quick start guides
│   ├── 📂 design-system/            # Toss design & themes
│   ├── 📂 components/               # Component documentation
│   ├── 📂 architecture/             # System architecture
│   └── 📂 implementation/           # Implementation guides
└── 📂 lib/                          # 💻 Flutter source code
```

**👉 New to the project? Start with [INDEX.md](INDEX.md) for role-based navigation!**

## Quick Start

### For Frontend Designers 🎨
1. Read [INDEX.md](INDEX.md) → Navigate to Designer section
2. Study [Toss Design Principles](docs/design-system/TOSS_STYLE_ANALYSIS.md)
3. Review [Component Library](docs/components/TOSS_COMPONENT_LIBRARY.md)
4. Check [Design Tokens](docs/design-system/DESIGN_TOKENS.md)

### For Developers 👩‍💻
1. Start with [INDEX.md](INDEX.md) → Navigate to Developer section
2. Follow [Quick Start Guide](docs/getting-started/QUICK_START.md)
3. Understand [Project Structure](docs/getting-started/PROJECT_STRUCTURE.md)
4. Build components using [Component Guide](docs/components/COMPONENT_GUIDE.md)

## 🏗 Project Structure

```
myFinance_improved/
├── lib/
│   ├── core/                    # App configuration and theme
│   │   ├── themes/             # Toss design system
│   │   ├── constants/          # App constants
│   │   └── utils/              # Helper functions
│   │
│   ├── domain/                  # Business logic (USE CASES)
│   │   ├── entities/           # Business objects
│   │   ├── repositories/       # Repository interfaces
│   │   └── usecases/           # Business rules
│   │
│   ├── data/                    # Data layer (SUPABASE)
│   │   ├── models/             # Data models with JSON
│   │   ├── datasources/        # Supabase client
│   │   └── repositories/       # Repository implementations
│   │
│   └── presentation/            # UI layer
│       ├── providers/          # Riverpod state management
│       ├── pages/              # App screens
│       └── widgets/            # UI components
│           ├── common/         # Shared widgets
│           ├── toss/           # Toss design components
│           └── specific/       # Feature-specific widgets
```

## 🚫 Critical Rules - MUST FOLLOW

### ❌ NEVER DO THESE
1. **NO App State Deviation** - MUST follow **[App State Structure](READMEAppState.md)** exactly
2. **NO Local SQL** - Use ONLY Supabase for database
3. **NO Custom UI First** - Check `widgets/toss/` before creating new components
4. **NO Business Logic in UI** - Keep logic in domain/usecases
5. **NO setState** - Use Riverpod providers for ALL state
6. **NO Hardcoded Values** - Use constants and theme values
7. **NO Direct DB Calls** - Always use repository pattern

### ✅ ALWAYS DO THESE
1. **Follow App State Structure** - Use **[App State Guide](READMEAppState.md)** exactly for ALL pages
2. **Use Supabase** - For ALL data persistence and auth
3. **Follow Architecture** - domain → data → presentation layers
4. **Use Toss Components** - Pre-built components for consistency
5. **Handle All States** - Loading, error, empty, success
6. **Use Type Safety** - Proper types, avoid dynamic
7. **Test Your Code** - Unit tests for business logic

## 🎯 Technology Stack

- **Flutter**: 3.0.0+ (Latest stable)
- **State**: Riverpod 2.5+ (with code generation)
- **Backend**: **Supabase** (Database, Auth, Storage)
- **Navigation**: GoRouter 13.0+
- **Models**: Freezed + JSON Serializable
- **HTTP**: Dio (for non-Supabase APIs)
- **Architecture**: Clean Architecture

## Migration Path

### Phase 1: Setup (Week 1)
- Project initialization
- Dependency configuration
- Structure setup

### Phase 2: Core (Week 2-3)
- Theme implementation
- Navigation setup
- Authentication system

### Phase 3: Features (Week 4-9)
- Core feature migration
- Component library
- Advanced features

### Phase 4: Polish (Week 10-11)
- Testing
- Optimization
- Deployment prep

## 🚀 Getting Started

### Prerequisites
```bash
# Flutter SDK (3.0.0 or higher)
flutter --version

# Dart SDK
dart --version
```

### Installation
```bash
# Clone the repository
git clone [repository-url]

# Navigate to project
cd myFinance_improved

# Install dependencies
flutter pub get

# Generate code (Freezed, Riverpod)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Supabase Setup - REQUIRED!
```bash
# 1. Create Supabase project at https://supabase.com
# 2. Get your project URL and anon key
# 3. Create .env file:
echo "SUPABASE_URL=your_project_url" > .env
echo "SUPABASE_ANON_KEY=your_anon_key" >> .env

# 4. Run database migrations (see docs/database/SUPABASE_datastructure.md)
```

### Run the App
```bash
# Development
flutter run

# With specific device
flutter run -d chrome  # Web
flutter run -d iPhone  # iOS Simulator

# Production build
flutter build apk --release  # Android
flutter build ios --release  # iOS
flutter build web --release  # Web
```

## Toss-Style Color Palette (OKLCH-Based)

### Brand Colors
- **Primary**: `#5B5FCF` - Your OKLCH blue/purple
- **Error**: `#EF4444` - Alert actions
- **Background**: `#FFFFFF` - Clean white
- **Surface**: `#FBFBFB` - Subtle gray

### Toss Gray Scale
- **Gray 50**: `#FAFAFA` - Lightest
- **Gray 100**: `#F5F5F5` - Light backgrounds
- **Gray 200**: `#E5E5E5` - Borders
- **Gray 500**: `#737373` - Secondary text
- **Gray 900**: `#171717` - Primary text

### Financial Indicators
- **Profit**: `#22C55E` 📈 - Softer green
- **Loss**: `#EF4444` 📉 - Clear red
- **Neutral**: `#737373` ➡️ - Muted gray

## Toss Component Examples

### Primary Button
```dart
TossPrimaryButton(
  text: '다음',
  onPressed: () {},
  isEnabled: true,
)
```

### Amount Input
```dart
TossAmountInput(
  controller: _amountController,
  label: '얼마를 보낼까요?',
  currency: '원',
  onChanged: (amount) {},
)
```

### Transaction Item
```dart
TossTransactionItem(
  title: 'Sales Revenue',
  subtitle: 'Business Income',
  amount: 1234560,
  date: DateTime.now(),
  type: TransactionType.income,
  onTap: () {},
)
```

### Bottom Sheet
```dart
TossBottomSheet.show(
  context: context,
  title: 'Select Action',
  actions: [
    TossActionItem(
      title: 'Send Money',
      icon: Icons.send,
      onTap: () {},
    ),
  ],
)
```



## 📚 Complete Documentation Index

### 🚨 CRITICAL - Read First
- **[App State Structure Guide](READMEAppState.md)** - **MANDATORY** app state structure for ALL developers ⭐

### 📱 Getting Started
- [Page Setup Guide](docs/getting-started/PAGE_SETUP_GUIDE.md) - **Frontend MUST READ**
- [Feature Example](docs/getting-started/FEATURE_EXAMPLE.md) - Complete feature implementation
- [Quick Start Guide](docs/getting-started/QUICK_START.md) - Project setup
- [Project Structure](docs/getting-started/PROJECT_STRUCTURE.md) - Folder organization

### 🏛 Architecture
- [Architecture Overview](docs/architecture/ARCHITECTURE.md) - **Backend MUST READ**
- [State Management](docs/architecture/STATE_MANAGEMENT.md) - Riverpod patterns

### 🎨 Design System
- [Theme System](docs/design-system/THEME_SYSTEM.md) - **Frontend MUST READ**
- [Toss Style Analysis](docs/design-system/TOSS_STYLE_ANALYSIS.md) - Design principles
- [Design Tokens](docs/design-system/DESIGN_TOKENS.md) - Design values

### 🧩 Components
- [Toss Component Library](docs/components/TOSS_COMPONENT_LIBRARY.md) - **Frontend MUST READ**
- [Component Guide](docs/components/COMPONENT_GUIDE.md) - How to build components
- [Component Library](docs/components/COMPONENT_LIBRARY.md) - All available components

### 💾 Database
- [Supabase Database Structure](docs/database/SUPABASE_datastructure.md) - **Backend MUST READ**

### 📋 Implementation
- [Implementation Plan](docs/implementation/IMPLEMENTATION_PLAN.md) - Development roadmap
- [Toss Style Implementation](docs/implementation/IMPLEMENTATION_PLAN_TOSS_STYLE.md) - UI implementation

## 🆘 Common Issues & Solutions

### Frontend Issues
- **Q: How should I manage app state?**
  - A: Follow **[App State Structure Guide](READMEAppState.md)** exactly - MANDATORY for consistency

- **Q: Where do I put my new page?**
  - A: `lib/presentation/pages/[feature]/` - See [Page Setup Guide](docs/getting-started/PAGE_SETUP_GUIDE.md)

- **Q: How do I create a button?**
  - A: Use `TossPrimaryButton` from `widgets/toss/` - See [Component Library](docs/components/TOSS_COMPONENT_LIBRARY.md)

- **Q: What colors should I use?**
  - A: Use `TossColors` class - Primary: `#5B5FCF`, Error: `#EF4444`

### Backend Issues
- **Q: What app state structure should I use?**
  - A: Follow **[App State Structure Guide](READMEAppState.md)** exactly - CRITICAL for team consistency

- **Q: How do I connect to database?**
  - A: Use Supabase ONLY - See [Supabase Structure](docs/database/SUPABASE_datastructure.md)

- **Q: Where do I put business logic?**
  - A: `lib/domain/usecases/` - Never in UI layer

- **Q: How do I manage state?**
  - A: Use Riverpod providers - See [State Management](docs/architecture/STATE_MANAGEMENT.md)

## 🤝 Contributing Guidelines

1. **Follow App State Structure** - MUST use **[App State Guide](READMEAppState.md)** exactly
2. **Read the docs** - Especially for your role
3. **Follow the architecture** - Don't break patterns
4. **Use existing components** - Don't recreate
5. **Test your code** - Especially business logic
6. **Update docs** - If you change something

## 📞 Need Help?

1. Check documentation first
2. Look at [Feature Example](docs/getting-started/FEATURE_EXAMPLE.md)
3. Ask team lead for clarification

---

**Remember: Supabase ONLY for database, Toss components for UI, Clean Architecture for structure!** 🚀
