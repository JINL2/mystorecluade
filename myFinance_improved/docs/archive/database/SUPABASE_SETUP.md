# 🔥 Supabase Setup Guide - REQUIRED READING

**IMPORTANT**: MyFinance uses **Supabase** exclusively. NO local SQL databases are allowed.

## 🚨 Critical Rules

1. **ONLY Supabase** - No SQLite, MySQL, PostgreSQL local instances
2. **Use Supabase Auth** - Don't implement custom authentication
3. **Row Level Security (RLS)** - Enable on ALL tables
4. **Real-time subscriptions** - Use for live updates
5. **Edge Functions** - For complex business logic

## 📋 Initial Setup

### Step 1: Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up / Sign in
3. Click "New Project"
4. Configure:
   ```
   Project name: myfinance-prod (or myfinance-dev)
   Database Password: [Strong password - SAVE THIS!]
   Region: Choose closest to your users
   Pricing: Free tier is fine for development
   ```

### Step 2: Get Your Credentials

After project creation, go to Settings → API:

```env
# Save these in .env file (NEVER commit this!)
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... # Only for admin tasks
```

### Step 3: Configure Flutter App

```dart
// lib/main.dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );
  
  runApp(const MyApp());
}

// Get Supabase client anywhere
final supabase = Supabase.instance.client;
```

## 🗄️ Database Schema

Run these SQL commands in Supabase SQL Editor:

### 1. Enable UUID Extension
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

### 2. Users Profile Table
```sql
-- User profiles (extends Supabase auth.users)
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  username TEXT UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);
```

### 3. Companies Table
```sql
CREATE TABLE public.companies (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own companies" ON public.companies
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create companies" ON public.companies
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own companies" ON public.companies
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own companies" ON public.companies
  FOR DELETE USING (auth.uid() = user_id);
```

### 4. Transactions Table
```sql
CREATE TABLE public.transactions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  company_id UUID REFERENCES public.companies(id) ON DELETE CASCADE NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
  category TEXT NOT NULL,
  description TEXT,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  attachment_url TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX idx_transactions_company_id ON public.transactions(company_id);
CREATE INDEX idx_transactions_date ON public.transactions(date DESC);
CREATE INDEX idx_transactions_type ON public.transactions(type);

-- Enable RLS
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own transactions" ON public.transactions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create transactions" ON public.transactions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own transactions" ON public.transactions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own transactions" ON public.transactions
  FOR DELETE USING (auth.uid() = user_id);
```

### 5. Categories Table
```sql
CREATE TABLE public.categories (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('income', 'expense', 'both')),
  icon TEXT,
  color TEXT,
  is_system BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own and system categories" ON public.categories
  FOR SELECT USING (auth.uid() = user_id OR is_system = true);

CREATE POLICY "Users can create categories" ON public.categories
  FOR INSERT WITH CHECK (auth.uid() = user_id AND is_system = false);

CREATE POLICY "Users can update own categories" ON public.categories
  FOR UPDATE USING (auth.uid() = user_id AND is_system = false);

CREATE POLICY "Users can delete own categories" ON public.categories
  FOR DELETE USING (auth.uid() = user_id AND is_system = false);

-- Insert default system categories
INSERT INTO public.categories (user_id, name, type, icon, color, is_system) VALUES
  (uuid_nil(), 'Salary', 'income', 'account_balance', '#22C55E', true),
  (uuid_nil(), 'Freelance', 'income', 'work', '#10B981', true),
  (uuid_nil(), 'Investment', 'income', 'trending_up', '#06B6D4', true),
  (uuid_nil(), 'Food', 'expense', 'restaurant', '#F59E0B', true),
  (uuid_nil(), 'Transport', 'expense', 'directions_car', '#8B5CF6', true),
  (uuid_nil(), 'Shopping', 'expense', 'shopping_bag', '#EC4899', true),
  (uuid_nil(), 'Bills', 'expense', 'receipt', '#EF4444', true),
  (uuid_nil(), 'Entertainment', 'expense', 'movie', '#3B82F6', true);
```

### 6. Functions and Triggers

```sql
-- Update updated_at timestamp automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply to all tables with updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_companies_updated_at BEFORE UPDATE ON public.companies
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON public.transactions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

## 🔐 Authentication Setup

### Enable Authentication Providers

1. Go to Authentication → Providers
2. Enable:
   - Email/Password (required)
   - Google OAuth (optional)
   - Apple OAuth (optional for iOS)

### Configure Auth Settings

```dart
// lib/data/datasources/remote/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  
  // Sign up
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? username,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
    
    if (response.user != null) {
      // Create profile
      await _client.from('profiles').insert({
        'id': response.user!.id,
        'username': username,
      });
    }
    
    return response;
  }
  
  // Sign in
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  // Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  // Get current user
  User? get currentUser => _client.auth.currentUser;
  
  // Auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
```

## 🚀 Real-time Subscriptions

### Listen to Transaction Changes

```dart
// lib/data/datasources/remote/transaction_api.dart
class TransactionApi {
  final SupabaseClient _client = Supabase.instance.client;
  
  // Real-time subscription
  Stream<List<Map<String, dynamic>>> watchTransactions() {
    return _client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', _client.auth.currentUser!.id)
        .order('date', ascending: false);
  }
  
  // CRUD operations
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final response = await _client
        .from('transactions')
        .select('*, company:companies(*)')
        .eq('user_id', _client.auth.currentUser!.id)
        .order('date', ascending: false);
    
    return List<Map<String, dynamic>>.from(response);
  }
  
  Future<Map<String, dynamic>> createTransaction(Map<String, dynamic> data) async {
    final response = await _client
        .from('transactions')
        .insert({
          ...data,
          'user_id': _client.auth.currentUser!.id,
        })
        .select()
        .single();
    
    return response;
  }
}
```

## 🛡️ Security Best Practices

### 1. Always Use RLS
```sql
-- Check RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

### 2. Validate Data
```dart
// Always validate on client AND server
class TransactionValidator {
  static bool isValidAmount(double amount) {
    return amount > 0 && amount < 1000000;
  }
  
  static bool isValidType(String type) {
    return ['income', 'expense', 'transfer'].contains(type);
  }
}
```

### 3. Use Environment Variables
```bash
# Never hardcode keys!
flutter run --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

## 📊 Storage Setup

For file uploads (receipts, avatars):

```dart
// Upload file
final avatarFile = File('path/to/avatar.png');
final String path = await supabase.storage
  .from('avatars')
  .upload(
    'public/${user.id}/avatar.png',
    avatarFile,
    fileOptions: const FileOptions(upsert: true),
  );

// Get public URL
final String publicUrl = supabase.storage
  .from('avatars')
  .getPublicUrl('public/${user.id}/avatar.png');
```

## 🔧 Troubleshooting

### Common Issues

1. **RLS Policy Errors**
   - Check if RLS is enabled
   - Verify auth.uid() matches user_id
   - Test policies in SQL editor

2. **Connection Issues**
   - Verify URL and keys are correct
   - Check network connectivity
   - Ensure project is not paused

3. **Auth Errors**
   - Check email confirmation settings
   - Verify redirect URLs
   - Test with SQL editor first

### Debug Queries

```sql
-- Check current user in SQL editor
SELECT auth.uid();

-- Test RLS policies
SET request.jwt.claim.sub = 'user-uuid-here';
SELECT * FROM transactions;
```

## 📚 Additional Resources

- [Supabase Docs](https://supabase.com/docs)
- [Flutter Client Library](https://supabase.com/docs/reference/dart/introduction)
- [SQL Editor](https://supabase.com/dashboard/project/_/sql)
- [Auth Docs](https://supabase.com/docs/guides/auth)

---

**Remember: ONLY use Supabase. No local databases allowed!** 🚀