# StoreBase Website

Private repository for StoreBase financial management system.

## ⚠️ Important Security Notice

This is a **PRIVATE** repository containing sensitive configuration. 
- Do NOT make this repository public without removing credentials
- Do NOT share access without authorization

## Setup Instructions

### Prerequisites
- XAMPP or similar web server
- Modern web browser
- Supabase account

### Local Development Setup

1. Clone this repository:
```bash
git clone https://github.com/JINL2/storebase_website.git
```

2. Place in your web server directory:
- XAMPP: `/Applications/XAMPP/xamppfiles/htdocs/`
- WAMP: `C:\wamp64\www\`

3. Start your web server (Apache)

4. Access the website:
```
http://localhost/storebase_website/
```

### First Time Setup

1. Navigate to login page
2. Use existing credentials or create new account
3. Set up company and store information

## Project Structure

```
website/
├── core/               # Core functionality
│   ├── config/        # Configuration files (contains credentials)
│   ├── templates/     # Page templates
│   └── utils/         # Utility functions
├── pages/             # Application pages
│   ├── auth/          # Authentication
│   ├── dashboard/     # Main dashboard
│   ├── finance/       # Financial modules
│   ├── employee/      # Employee management
│   └── settings/      # System settings
└── components/        # Reusable components
```

## Features

- Multi-company management
- Financial tracking (Balance Sheet, Income Statement)
- Employee management
- Journal entries
- Transaction history
- Multi-currency support

## Technology Stack

- Frontend: HTML, CSS, JavaScript
- Database: Supabase
- Authentication: Supabase Auth
- Hosting: Local development (XAMPP)

## Security Notes

This repository contains:
- Supabase configuration
- Authentication logic
- Business logic

**Keep this repository PRIVATE unless credentials are properly secured.**

## Team Access

To request access to this repository, contact the repository owner.

## Future Improvements

- [ ] Move credentials to environment variables
- [ ] Add automated testing
- [ ] Implement CI/CD pipeline
- [ ] Create demo version for public testing

---

© 2024 StoreBase - Private Project