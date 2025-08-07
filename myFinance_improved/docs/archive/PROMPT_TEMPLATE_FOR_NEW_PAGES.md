# 📝 Prompt Template for Creating New Pages

Use this template when asking AI to create new pages in the MyFinance project.

## 🎯 Complete Prompt Template

```
I need to create a [PAGE_NAME] page for MyFinance app.

## Context:
- Project: MyFinance (Toss-style financial app)
- Location: /Applications/XAMPP/xamppfiles/htdocs/mysite/myFinance_claude/myFinance_improved
- Role: Frontend Developer

## Page Requirements:
1. Page Name: [PAGE_NAME]
2. Purpose: [DESCRIBE WHAT THIS PAGE DOES]
3. Features needed:
   - [FEATURE 1]
   - [FEATURE 2]
   - [FEATURE 3]

## Data Requirements:
- Entities needed: [e.g., Transaction, Company, Category]
- State management: [What state needs to be managed]
- API calls: [What data to fetch from Supabase]

## UI Components Needed:
- [e.g., List view, form inputs, cards, bottom sheets]
- [Specific interactions like swipe, pull-to-refresh]

## Follow These Rules:
1. You are a FRONTEND developer - read README.md frontend section
2. Use ONLY Toss components from lib/presentation/widgets/toss/
3. Follow Page Setup Guide in docs/getting-started/PAGE_SETUP_GUIDE.md
4. Use Toss design system:
   - Primary color: #5B5FCF
   - Error color: #EF4444
   - Use TossColors, TossTextStyles, TossSpacing
   - 2-5% shadow opacity
   - 12px border radius
5. Use Riverpod for state (NO setState)
6. Create in lib/presentation/pages/[feature]/
7. Update router in app_router.dart
8. Use Korean text for UI labels (like Toss)
9. Handle loading, error, and empty states
10. Must use Supabase (no local SQL)

## Additional Requirements:
[ANY SPECIFIC REQUIREMENTS]

Please create this page following all the guidelines above.
```

## 📋 Example Filled Prompt

```
I need to create a Transaction History page for MyFinance app.

## Context:
- Project: MyFinance (Toss-style financial app)
- Location: /Applications/XAMPP/xamppfiles/htdocs/mysite/myFinance_claude/myFinance_improved
- Role: Frontend Developer

## Page Requirements:
1. Page Name: TransactionHistoryPage
2. Purpose: Display list of all user transactions with filtering and search
3. Features needed:
   - Scrollable transaction list
   - Search bar
   - Filter by date/category/type
   - Pull to refresh
   - Show transaction details on tap

## Data Requirements:
- Entities needed: Transaction, Company, Category
- State management: Transaction list, filters, search query
- API calls: Fetch transactions from Supabase with filters

## UI Components Needed:
- Search bar at top
- Filter chips below search
- Transaction list items with amount, date, description
- Empty state when no transactions
- Loading shimmer effect
- Error state with retry

## Follow These Rules:
1. You are a FRONTEND developer - read README.md frontend section
2. Use ONLY Toss components from lib/presentation/widgets/toss/
3. Follow Page Setup Guide in docs/getting-started/PAGE_SETUP_GUIDE.md
4. Use Toss design system:
   - Primary color: #5B5FCF
   - Error color: #EF4444
   - Use TossColors, TossTextStyles, TossSpacing
   - 2-5% shadow opacity
   - 12px border radius
5. Use Riverpod for state (NO setState)
6. Create in lib/presentation/pages/transaction/
7. Update router in app_router.dart
8. Use Korean text for UI labels (like Toss)
9. Handle loading, error, and empty states
10. Must use Supabase (no local SQL)

## Additional Requirements:
- Group transactions by date
- Show income in green (#22C55E), expense in red (#EF4444)
- Add floating action button for creating new transaction
- Implement infinite scroll pagination

Please create this page following all the guidelines above.
```

## 🚀 Quick Copy-Paste Version

```
Create [PAGE_NAME] page as FRONTEND developer for MyFinance Toss-style app at /Applications/XAMPP/xamppfiles/htdocs/mysite/myFinance_claude/myFinance_improved.

Requirements: [DESCRIBE FEATURES]

MUST follow:
- Read README.md frontend section first
- Use ONLY existing Toss components from widgets/toss/
- Follow PAGE_SETUP_GUIDE.md structure
- Toss design: Primary #5B5FCF, Error #EF4444, 2-5% shadows, 12px radius
- Use Riverpod (NO setState)
- Place in pages/[feature]/
- Update app_router.dart
- Korean UI text
- Handle loading/error/empty states
- Use Supabase only

Create all necessary files following the architecture.
```

## 💡 Pro Tips

1. **Be Specific**: The more details you provide, the better the result
2. **Reference Existing Code**: Mention similar pages to follow (e.g., "like the login_page.dart")
3. **Include Mock Data**: Provide sample data structure if needed
4. **Specify Interactions**: Describe user interactions clearly
5. **List All States**: Don't forget edge cases (empty, error, loading)

## 🎨 Common UI Patterns to Request

- **List Page**: "Create scrollable list with pull-to-refresh and infinite scroll"
- **Detail Page**: "Show single item details with edit/delete actions"
- **Form Page**: "Multi-field form with validation and submission"
- **Dashboard**: "Cards showing summary statistics with charts"
- **Settings Page**: "List of settings with toggles and navigation items"
- **Profile Page**: "User info display with edit capability"
- **Search Page**: "Real-time search with filters and results"

## 📁 Files AI Should Create

When using this prompt, AI should create:
1. The main page file in `pages/[feature]/`
2. Any specific widgets in `widgets/specific/`
3. Provider file in `providers/` if needed
4. Update the router file
5. Create or update any required models/entities

---

Save this template and customize it for each new page you need!