# 🚀 Quick Access Account Selector - Usage Guide

## ✨ **NEW FEATURE: Frequently Used Accounts**

The account selector now automatically shows your most frequently used accounts at the top for faster selection!

## 📱 How It Works

### **Default Behavior (Quick Access Enabled)**
When you open any account selector in the app, you'll see:

1. **⚡ Frequently Used** section at the top
   - Shows your 5 most used accounts
   - Visual indicators show usage frequency
   - Orange badges for highly used accounts (>5 uses)

2. **All Accounts** section below
   - Complete list of all available accounts
   - Searchable as before

### **Visual Design**
```
┌─────────────────────────────┐
│ Select Account              │
├─────────────────────────────┤
│ 🔍 Search accounts          │
├─────────────────────────────┤
│ ⚡ Frequently Used          │
│ ┌─────────────────────────┐ │
│ │ 💳 Cash Account    15× │ │  ← Usage count
│ │ 💳 Bank Account    12× │ │
│ │ 💳 Sales Revenue    8× │ │
│ └─────────────────────────┘ │
├─────────────────────────────┤
│ All Accounts                │
│ • Asset Account 1           │
│ • Asset Account 2           │
│ • Liability Account 1       │
│ • ...                       │
└─────────────────────────────┘
```

## 🎯 Key Features

### **1. Automatic Tracking**
- Every account selection is automatically tracked
- No manual configuration needed
- Works across all pages: Journal Entry, Templates, Transactions

### **2. Smart Sorting**
- Accounts sorted by usage frequency
- Recent usage gets bonus weight
- Updates in real-time as you use accounts

### **3. Visual Indicators**
- **Usage Badge**: Shows count (e.g., "15×")
- **Orange Dot**: High frequency indicator (>5 uses)
- **Bold Text**: Frequently used accounts are bold

### **4. Context Aware**
- Tracks WHERE accounts are used (journal, template, etc.)
- Can show different quick access based on context

## 💻 Implementation

### **Basic Usage (Quick Access Enabled by Default)**
```dart
AutonomousAccountSelector(
  selectedAccountId: currentAccountId,
  onChanged: (accountId) {
    // Handle selection
  },
  label: 'Select Account',
  contextType: 'journal_entry', // Tracks usage context
  showQuickAccess: true, // Default is true
)
```

### **Disable Quick Access (If Needed)**
```dart
AutonomousAccountSelector(
  selectedAccountId: currentAccountId,
  onChanged: (accountId) {
    // Handle selection
  },
  showQuickAccess: false, // Disables quick access
)
```

## 📊 How Usage is Tracked

### **Database Storage**
All usage data is stored in `accounts_preferences` table:
- Account ID
- Account Name  
- Usage Type (selected/used)
- Context (journal_entry/template/transaction)
- Timestamp
- Company ID

### **Scoring Algorithm**
```
Score = Usage Count + Recency Bonus
- Last 7 days: +10 points
- Last 30 days: +5 points
- Last 90 days: +2 points
```

## 🔍 Where It's Available

Quick access is now active in:
- ✅ **Journal Entry Page** - Add transaction dialog
- ✅ **Transaction Templates** - Template creation
- ✅ **Any Custom Implementation** - Using AutonomousAccountSelector

## 🎨 User Experience Benefits

1. **⚡ Faster Selection**: Most used accounts are immediately visible
2. **📈 Learning System**: Adapts to user behavior over time
3. **🎯 Reduced Scrolling**: No need to search for frequently used accounts
4. **💡 Smart Defaults**: Shows what you actually use, not just alphabetical
5. **🔄 Real-time Updates**: Quick access list updates as you work

## 🛠️ Technical Details

### **Components**
- `AutonomousAccountSelector` - Main selector with quick access
- `EnhancedAccountSelector` - Enhanced version with quick access UI
- `QuickAccessAccountsProvider` - Fetches frequently used accounts
- `log_account_usage` RPC - Tracks account usage
- `get_user_quick_access_accounts` RPC - Retrieves quick access data

### **Performance**
- Quick access data is cached per session
- Minimal database calls (one on selector open)
- No impact on regular account loading
- Background tracking (doesn't block UI)

## 📝 Notes

- Quick access shows maximum 5 accounts to keep UI clean
- Accounts must be used at least once to appear in quick access
- Data is company-specific (each company has its own quick access)
- Usage data older than 180 days is not considered for quick access

## 🚀 Future Enhancements

Potential improvements:
- Customizable quick access count (3-10 items)
- Pin/unpin specific accounts
- Different quick access per transaction type
- Export usage analytics
- Team-wide popular accounts

---

**The quick access feature is designed to be invisible yet powerful - it just works!** 🎉