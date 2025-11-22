/**
 * Navbar Component
 * Reusable navigation bar for all pages
 */

import React, { useEffect, useState, useRef } from 'react';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import { CompanySelector } from '@/shared/components/selectors/CompanySelector';
import type { NavbarProps, NavItem, Company } from './Navbar.types';
import styles from './Navbar.module.css';

export const Navbar: React.FC<NavbarProps> = ({ activeItem = 'dashboard', user, onSignOut }) => {
  const { currentCompany, companies, setCurrentCompany } = useAppState();
  const [userName, setUserName] = useState<string>(user?.name || 'Loading...');
  const [userEmail, setUserEmail] = useState<string>(user?.email || 'Loading...');
  const [openDropdown, setOpenDropdown] = useState<string | null>(null);
  const [currentPageAction, setCurrentPageAction] = useState<string | null>(null);
  const [isSellPageActive, setIsSellPageActive] = useState(false);
  const dropdownRefs = useRef<{ [key: string]: HTMLDivElement | null }>({});

  const navItems: NavItem[] = [
    {
      id: 'dashboard',
      label: 'Dashboard',
      href: '/dashboard',
      active: activeItem === 'dashboard',
    },
    {
      id: 'product',
      label: 'Product',
      href: '#',
      dropdown: [
        {
          section: 'Product Management',
          items: [
            { label: 'Inventory', href: '/product/inventory', action: 'Inventory' },
            { label: 'Invoice', href: '/product/invoice', action: 'Invoice' },
            { label: 'Sale Product', href: '/product/create-invoice', action: 'Sale Product' },
            { label: 'Order', href: '/product/order', action: 'Order' },
            { label: 'Product Receive', href: '/product/product-receive', action: 'Product Receive' },
            { label: 'Tracking', href: '/product/tracking', action: 'Tracking' },
          ],
        },
      ],
    },
    {
      id: 'marketing',
      label: 'Marketing',
      href: '#',
      dropdown: [
        {
          section: 'Marketing Tools',
          items: [{ label: 'Marketing Plan', href: '/marketing/marketing-plan', action: 'Marketing Plan' }],
        },
      ],
    },
    {
      id: 'finance',
      label: 'Finance',
      href: '#',
      dropdown: [
        {
          section: 'Financial Reports',
          items: [
            { label: 'Balance Sheet', href: '/finance/balance-sheet', action: 'Balance Sheet' },
            { label: 'Income Statement', href: '/finance/income-statement', action: 'Income Statement' },
          ],
        },
        {
          section: 'Transactions',
          items: [
            { label: 'Journal Input', href: '/finance/journal-input', action: 'Journal Input' },
            { label: 'Transaction History', href: '/finance/transaction-history', action: 'Transaction History' },
            { label: 'Cash Ending', href: '/finance/cash-ending', action: 'Cash Ending' },
          ],
        },
      ],
    },
    {
      id: 'employee',
      label: 'Employee',
      href: '#',
      dropdown: [
        {
          section: 'Employee Management',
          items: [
            { label: 'Schedule', href: '/employee/schedule', action: 'Schedule' },
            { label: 'Employee Setting', href: '/employee/employee-setting', action: 'Employee Setting' },
            { label: 'Salary', href: '/employee/salary', action: 'Salary' },
          ],
        },
      ],
    },
    {
      id: 'setting',
      label: 'Setting',
      href: '#',
      dropdown: [
        {
          section: 'General Settings',
          items: [
            { label: 'Currency', href: '/settings/currency', action: 'Currency' },
            { label: 'Company & Store Setting', href: '/settings/store-setting', action: 'Company & Store Setting' },
          ],
        },
        {
          section: 'Financial Settings',
          items: [
            { label: 'Account Mapping', href: '/settings/account-mapping', action: 'Account Mapping' },
            { label: 'Counterparty', href: '/settings/counterparty', action: 'Counterparty' },
          ],
        },
      ],
    },
  ];

  // Detect current page action from URL
  useEffect(() => {
    const detectPageAction = () => {
      const currentPath = window.location.pathname;
      const pathMappings: { [key: string]: string } = {
        'product/inventory': 'Inventory',
        'product/invoice': 'Invoice',
        'product/create-invoice': 'Sale Product',
        'product/order': 'Order',
        'product/product-receive': 'Product Receive',
        'product/tracking': 'Tracking',
        'finance/balance-sheet': 'Balance Sheet',
        'finance/income-statement': 'Income Statement',
        'finance/journal-input': 'Journal Input',
        'finance/transaction-history': 'Transaction History',
        'finance/cash-ending': 'Cash Ending',
        'employee/schedule': 'Schedule',
        'employee/employee-setting': 'Employee Setting',
        'employee/salary': 'Salary',
        'marketing/marketing-plan': 'Marketing Plan',
        'settings/currency': 'Currency',
        'settings/store-setting': 'Company & Store Setting',
        'settings/account-mapping': 'Account Mapping',
        'settings/counterparty': 'Counterparty',
        dashboard: 'Dashboard',
      };

      for (const [pathPattern, action] of Object.entries(pathMappings)) {
        if (currentPath.includes(pathPattern)) {
          setCurrentPageAction(action);
          // Check if it's the sell page
          if (pathPattern === 'product/create-invoice') {
            setIsSellPageActive(true);
          }
          return action;
        }
      }
      setIsSellPageActive(false);
      return null;
    };

    detectPageAction();
  }, []);

  // Load user info from session
  useEffect(() => {
    const loadUserInfo = async () => {
      try {
        const supabase = supabaseService.getClient();
        const {
          data: { session },
        } = await supabase.auth.getSession();

        if (session && session.user) {
          let name =
            session.user.user_metadata?.full_name ||
            session.user.user_metadata?.name ||
            session.user.user_metadata?.display_name;

          if (!name && session.user.email) {
            const emailName = session.user.email.split('@')[0];
            name = emailName
              .replace(/[._]/g, ' ')
              .split(' ')
              .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
              .join(' ');
          }

          setUserName(name || 'User');
          setUserEmail(session.user.email || '');
        }
      } catch (error) {
        console.error('Error loading user info:', error);
      }
    };

    if (!user) {
      loadUserInfo();
    }
  }, [user]);

  // Close dropdowns when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as HTMLElement;
      if (!target.closest(`.${styles.navbarNavItem}`)) {
        setOpenDropdown(null);
      }
    };

    document.addEventListener('click', handleClickOutside);
    return () => document.removeEventListener('click', handleClickOutside);
  }, []);

  const handleNavClick = (navId: string, label: string, hasDropdown: boolean) => {
    if (navId === 'dashboard') {
      window.location.href = '/dashboard';
    } else if (!hasDropdown) {
      console.log(`Navigation clicked: ${label}`);
    }
  };

  const handleDropdownToggle = (navId: string) => {
    setOpenDropdown(openDropdown === navId ? null : navId);
  };

  const handleDropdownItemClick = (action: string, href: string) => {
    console.log(`Dropdown action: ${action}`);
    window.location.href = href;
  };

  const handleSignOut = async () => {
    try {
      const supabase = supabaseService.getClient();
      await supabase.auth.signOut();

      // Clear local storage
      localStorage.removeItem('user');
      localStorage.removeItem('session');
      localStorage.removeItem('companyChoosen');
      localStorage.removeItem('storeChoosen');

      if (onSignOut) {
        onSignOut();
      } else {
        window.location.href = '/login';
      }
    } catch (error) {
      console.error('Sign out error:', error);
    }
  };

  const handleCompanyChange = (companyId: string, company: Company) => {
    // Save selected company
    localStorage.setItem('companyChoosen', companyId);

    // Update first store for the selected company
    if (company.stores && company.stores.length > 0) {
      localStorage.setItem('storeChoosen', company.stores[0].store_id);
    } else {
      // Clear store if no stores available
      localStorage.removeItem('storeChoosen');
    }

    // Update current company in app state
    setCurrentCompany(company);

    // Trigger company change event for other components to listen
    window.dispatchEvent(
      new CustomEvent('companyChanged', {
        detail: {
          companyId: companyId,
          companyName: company.company_name,
          company: company,
        },
      })
    );

    // Optional: call global callback if exists
    if (typeof (window as any).onCompanyChange === 'function') {
      (window as any).onCompanyChange(companyId);
    }
  };

  const isDropdownItemActive = (action: string) => {
    return currentPageAction === action;
  };

  const getActiveNavItem = () => {
    // Check if current page action matches any dropdown item
    for (const item of navItems) {
      if (item.dropdown) {
        for (const section of item.dropdown) {
          for (const dropdownItem of section.items) {
            if (dropdownItem.action === currentPageAction) {
              return item.id;
            }
          }
        }
      }
    }
    return activeItem;
  };

  const activeNavId = getActiveNavItem();

  return (
    <nav className={styles.navbarComponent}>
      <div className={styles.navbarInner}>
        {/* Logo */}
        <a href="/dashboard" className={styles.navbarBrand}>
          <div className={styles.navbarLogo}>
            <img src="/assets/app icon.png" alt="Store Base" style={{ height: '30px', objectFit: 'contain' }} />
          </div>
          <h1 className={styles.navbarTitle}>Store Base</h1>
        </a>

        {/* Navigation Menu */}
        <div className={styles.navbarMenu}>
          {navItems.map((item) => {
            const hasDropdown = item.dropdown && item.dropdown.length > 0;
            const isActive = item.id === activeNavId;

            return (
              <div
                key={item.id}
                className={styles.navbarNavItem}
                onMouseEnter={() => hasDropdown && setOpenDropdown(item.id)}
                onMouseLeave={() => hasDropdown && setOpenDropdown(null)}
              >
                <a
                  href={item.href}
                  className={`${styles.navbarNavLink} ${isActive ? styles.active : ''}`}
                  onClick={(e) => {
                    if (hasDropdown) {
                      e.preventDefault();
                      handleDropdownToggle(item.id);
                    } else {
                      handleNavClick(item.id, item.label, hasDropdown);
                    }
                  }}
                >
                  {item.label}
                </a>

                {hasDropdown && (
                  <div
                    className={`${styles.navbarDropdownMenu} ${openDropdown === item.id ? styles.show : ''}`}
                    ref={(el) => (dropdownRefs.current[item.id] = el)}
                  >
                    {item.dropdown!.map((section, sectionIdx) => (
                      <div key={sectionIdx} className={styles.navbarDropdownSection}>
                        <div className={styles.navbarDropdownTitle}>{section.section}</div>
                        {section.items.map((dropdownItem, itemIdx) => {
                          const isItemActive = isDropdownItemActive(dropdownItem.action);
                          return (
                            <a
                              key={itemIdx}
                              href={dropdownItem.href}
                              className={`${styles.navbarDropdownLink} ${isItemActive ? styles.active : ''}`}
                              onClick={(e) => {
                                e.preventDefault();
                                handleDropdownItemClick(dropdownItem.action, dropdownItem.href);
                              }}
                            >
                              {dropdownItem.label}
                            </a>
                          );
                        })}
                      </div>
                    ))}
                  </div>
                )}
              </div>
            );
          })}
        </div>

        {/* User Section */}
        <div className={styles.navbarUser}>
          {/* Sell Button */}
          <button
            className={`${styles.navbarBtnSell} ${isSellPageActive ? styles.navbarBtnSellActive : ''}`}
            onClick={() => (window.location.href = '/product/create-invoice')}
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
              <path d="M17,18C15.89,18 15,18.89 15,20A2,2 0 0,0 17,22A2,2 0 0,0 19,20C19,18.89 18.1,18 17,18M1,2V4H3L6.6,11.59L5.24,14.04C5.09,14.32 5,14.65 5,15A2,2 0 0,0 7,17H19V15H7.42A0.25,0.25 0 0,1 7.17,14.75C7.17,14.7 7.18,14.66 7.2,14.63L8.1,13H15.55C16.3,13 16.96,12.58 17.3,11.97L20.88,5.5C20.95,5.34 21,5.17 21,5A1,1 0 0,0 20,4H5.21L4.27,2M7,18C5.89,18 5,18.89 5,20A2,2 0 0,0 7,22A2,2 0 0,0 9,20C9,18.89 8.1,18 7,18Z" />
            </svg>
            Sell
          </button>

          {/* Company Selector */}
          {companies && companies.length > 0 && (
            <CompanySelector
              companies={companies}
              selectedCompanyId={currentCompany?.company_id || ''}
              onChange={(companyId, company) => {
                handleCompanyChange(companyId, company);
              }}
            />
          )}

          {/* User Profile */}
          <div className={styles.navbarUserProfile}>
            <div className={styles.navbarUserAvatar}>{userName.charAt(0).toUpperCase()}</div>
            <div className={styles.navbarUserInfo}>
              <h4>{userName}</h4>
              <p>{userEmail}</p>
            </div>
          </div>

          {/* Sign Out Button */}
          <button className={styles.navbarBtnSignout} onClick={handleSignOut}>
            Sign Out
          </button>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
