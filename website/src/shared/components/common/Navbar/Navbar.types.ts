/**
 * Navbar Component Types
 * Type definitions for the navigation bar
 */

export interface NavbarUser {
  name: string;
  email: string;
}

export interface DropdownItem {
  label: string;
  href: string;
  action: string;
}

export interface DropdownSection {
  section: string;
  items: DropdownItem[];
}

export interface NavItem {
  id: string;
  label: string;
  href: string;
  active?: boolean;
  dropdown?: DropdownSection[];
}

export interface Company {
  company_id: string;
  company_name: string;
  stores?: Store[];
}

export interface Store {
  store_id: string;
  store_name: string;
}

export interface NavbarProps {
  activeItem?: string;
  user?: NavbarUser;
  onSignOut?: () => void;
}
