/**
 * CompanySelector Component Types
 * Searchable company dropdown selector
 */

export interface Company {
  company_id: string;
  company_name: string;
  stores?: Store[];
}

export interface Store {
  store_id: string;
  store_name: string;
}

export interface CompanySelectorProps {
  companies: Company[];
  selectedCompanyId: string;
  onChange: (companyId: string, company: Company) => void;
  className?: string;
}
