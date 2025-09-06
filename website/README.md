# MyFinance Website - Modern Finance Management System

A secure, modern web application for comprehensive finance management built with vanilla JavaScript and Supabase backend.

## ⚠️ IMPORTANT SECURITY NOTICE

This repository contains a web application that requires Supabase credentials to function. For security reasons, these credentials are NOT included in the repository. You must configure your own credentials before running the application.

## 🚀 Quick Start (3 minutes)

Get the application running in just a few steps:

```bash
# 1. Clone the repository
git clone [your-repo-url]
cd myFinance_claude/website

# 2. Copy the environment configuration template
cp core/config/env-config.example.js core/config/env-config.js

# 3. Edit env-config.js with your Supabase credentials
# (See detailed instructions below)

# 4. Start a local web server (choose one):
# Option A: Python
python -m http.server 8000

# Option B: Node.js
npx http-server -p 8000

# Option C: VS Code Live Server
# Right-click index.html → "Open with Live Server"

# 5. Open in browser
# http://localhost:8000/
```

Need Supabase credentials? Jump to [Getting Your Supabase Credentials](#3-getting-your-supabase-credentials)

## 📋 Prerequisites

Before you begin, ensure you have:
- ✅ A local web server (Python, Node.js, XAMPP, or VS Code Live Server)
- ✅ A Supabase account with a project ([create free account](https://supabase.com))
- ✅ A modern web browser (Chrome 60+, Firefox 55+, Safari 10.1+)
- ✅ Basic familiarity with JavaScript and environment variables

## 🔧 Detailed Setup Instructions

### 1. Environment Configuration

Before running the application, you need to configure your Supabase credentials:

1. Copy the example configuration file:
   ```bash
   cp core/config/env-config.example.js core/config/env-config.js
   ```

2. Edit `core/config/env-config.js` and add your Supabase credentials:
   ```javascript
   window.ENV = {
       SUPABASE_URL: 'your_supabase_url_here',
       SUPABASE_ANON_KEY: 'your_supabase_anon_key_here',
       ENVIRONMENT: 'development',
       DEBUG_MODE: true
   };
   ```

3. **IMPORTANT**: Never commit `env-config.js` to version control!

### 2. Files to Never Commit

The following files contain sensitive information and are already in `.gitignore`:

- `.env`
- `.env.local`
- `.env.production`
- `core/config/env-config.js`
- `core/config/supabase-config.js`
- `core/config/supabase-original.js` (backup file)

### 3. Getting Your Supabase Credentials

1. Log in to your [Supabase Dashboard](https://app.supabase.com)
2. Select your project
3. Go to Settings → API
4. Copy:
   - **Project URL** → Use as `SUPABASE_URL`
   - **Anon/Public Key** → Use as `SUPABASE_ANON_KEY`

### 4. Security Best Practices

1. **Never hardcode credentials** in your source files
2. **Always use environment variables** for sensitive data
3. **Rotate your keys regularly** if they get exposed
4. **Use Row Level Security (RLS)** in Supabase for data protection
5. **Review your git history** before pushing to ensure no credentials are included

### 5. For Production Deployment

For production environments, you should:

1. Use environment variables provided by your hosting service
2. Never use the development `env-config.js` file
3. Consider using a build process that injects credentials at build time
4. Use more restrictive Supabase policies and roles

## Project Structure

```
website/
├── .gitignore                    # Excludes sensitive files
├── .env.example                  # Template for environment variables
├── core/
│   ├── config/
│   │   ├── env-loader.js        # Environment loader (safe to commit)
│   │   ├── env-config.example.js # Example configuration (safe to commit)
│   │   ├── env-config.js        # Your actual config (DO NOT COMMIT)
│   │   └── supabase.js          # Supabase client setup (uses env vars)
│   └── ...
├── pages/
│   └── ...
└── README.md                     # This file
```

## 💻 Local Development Server Options

Since this is a static website, you need a local web server to run it properly (to avoid CORS issues).

### Option 1: XAMPP (Recommended for this project structure)
```bash
# Place project in XAMPP htdocs folder
# Start Apache from XAMPP Control Panel
# Access: http://localhost/mcparrange-main/myFinance_claude/website/
```

### Option 2: Python HTTP Server (Simplest)
```bash
cd website/
python -m http.server 8000
# Access: http://localhost:8000/
```

### Option 3: Node.js HTTP Server
```bash
# Install globally (once)
npm install -g http-server

# Run from website directory
cd website/
http-server -p 8000
# Access: http://localhost:8000/
```

### Option 4: VS Code Live Server Extension
1. Install "Live Server" extension in VS Code
2. Right-click on `index.html`
3. Select "Open with Live Server"
4. Browser opens automatically

## 🐛 Troubleshooting

### Common Issues and Solutions

#### "Supabase credentials not configured" Error
**Cause**: The `env-config.js` file is missing or incorrectly configured.

**Solution**:
1. Verify `core/config/env-config.js` exists (not just the .example file)
2. Check that both `SUPABASE_URL` and `SUPABASE_ANON_KEY` are filled in
3. Ensure there are no typos in the credentials
4. Clear browser cache and reload

#### "Supabase client not available" Error
**Cause**: Supabase library not loading or credentials invalid.

**Solution**:
1. Check internet connection (Supabase loads from CDN)
2. Verify credentials are correct in Supabase dashboard
3. Open browser console (F12) and check for JavaScript errors
4. Ensure you're accessing via `http://localhost` (not `file://`)

#### "404 Not Found" or "Module not found" Errors
**Cause**: Incorrect file paths or server configuration.

**Solution**:
1. Verify your local server is serving from the correct directory
2. Check that you're accessing the correct URL path
3. Ensure all file paths in the code match your directory structure

#### "CORS Policy" Errors
**Cause**: Trying to open HTML files directly in browser.

**Solution**:
1. Always use a local web server (see options above)
2. Never open files with `file://` protocol
3. Use `http://localhost` or `http://127.0.0.1`

#### Login Not Working
**Cause**: Invalid credentials or Supabase configuration issues.

**Solution**:
1. Verify Supabase project is active (not paused)
2. Check that authentication is enabled in Supabase dashboard
3. Ensure user exists in Supabase Auth → Users
4. Check browser console for specific error messages

## ✅ Verifying Your Setup

After completing the setup, verify everything is working:

### Success Checklist:
- [ ] Browser shows login page (not error messages)
- [ ] No red errors in browser console (F12 → Console tab)
- [ ] "Supabase initialized successfully" message in console
- [ ] Can successfully log in with valid credentials
- [ ] Dashboard loads after authentication

### What You Should See:
1. **On First Load**: Clean login page with email/password fields
2. **In Console**: "✅ Local development environment loaded" (if DEBUG_MODE is true)
3. **After Login**: Redirect to dashboard with user data

## 📦 Technology Stack

- **Frontend**: Vanilla JavaScript (ES6+), Custom Component System
- **Styling**: Toss Design System (Custom CSS Framework)
- **Backend**: Supabase (PostgreSQL + Auth + Realtime)
- **Icons**: Custom SVG icons
- **Charts**: Chart.js for data visualization
- **No Build Process**: Pure static files, no bundling required

## 🤝 Contributing

Contributions are welcome! Please ensure:
1. Never commit credentials or sensitive data
2. Test your changes with proper Supabase configuration
3. Follow the existing code style and patterns
4. Update documentation as needed

## 📞 Support

For issues related to:
- **Supabase Setup**: Check [Supabase Documentation](https://supabase.com/docs)
- **Application Bugs**: Create an issue in this repository (without including credentials!)
- **Security Issues**: Please report privately to maintainers

## 📄 License

[Your License Here]

---

## 🔐 Security Reminder

**NEVER commit these files:**
- `env-config.js` (your actual configuration)
- `.env` (environment variables)
- Any file containing real API keys or credentials

**ALWAYS commit these files:**
- `env-config.example.js` (template for others)
- `.env.example` (template for environment variables)
- Documentation updates

**If you accidentally commit credentials:**
1. Immediately rotate your Supabase keys in the dashboard
2. Remove the commit from history using `git rebase` or `BFG Repo-Cleaner`
3. Force push the cleaned history
4. Verify credentials are no longer in the repository

---

*Built with security and simplicity in mind. Happy coding! 🚀*
