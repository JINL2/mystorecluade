import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { supabaseService } from '@/core/services/supabase_service';

interface Store {
  store_id: string;
  store_name: string;
}

interface Role {
  role_id: string;
  role_name: string;
  permissions: string[]; // Array of feature_ids
}

interface Company {
  company_id: string;
  company_name: string;
  currency_symbol?: string;
  stores?: Store[];
  role?: Role;
}

interface User {
  user_id: string;
  email: string;
  name: string;
}

interface Feature {
  feature_id: string;
  feature_name: string;
  feature_route: string;
  feature_icon?: string;
  icon_key?: string;
  is_show_main?: boolean;
}

interface CategoryFeatures {
  category_id: string;
  category_name: string;
  features: Feature[];
}

interface AppState {
  currentCompany: Company | null;
  currentStore: Store | null;
  companies: Company[];
  currentUser: User | null;
  categoryFeatures: CategoryFeatures[];
  permissions: string[]; // Current company's permissions (feature_ids)
  setCurrentCompany: (company: Company | null) => void;
  setCurrentStore: (store: Store | null) => void;
  setCurrentUser: (user: User | null) => void;
  loadUserData: () => Promise<void>;
  loadCategoryFeatures: () => Promise<void>;
}

const AppStateContext = createContext<AppState | undefined>(undefined);

interface AppStateProviderProps {
  children: ReactNode;
}

export const AppStateProvider: React.FC<AppStateProviderProps> = ({ children }) => {
  // Initialize with null - will be loaded after login
  const [currentCompany, setCurrentCompany] = useState<Company | null>(null);
  const [currentStore, setCurrentStore] = useState<Store | null>(null);
  const [companies, setCompanies] = useState<Company[]>([]);
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [categoryFeatures, setCategoryFeatures] = useState<CategoryFeatures[]>([]);

  // Load user's companies and stores from Supabase
  const loadUserData = async () => {
    try {
      // Check if user is authenticated first
      const { data: { session }, error: sessionError } = await supabaseService.getClient().auth.getSession();

      if (sessionError || !session) {
        return;
      }

      // Call RPC with user_id parameter from session
      const { data, error } = await supabaseService.getClient().rpc('get_user_companies_and_stores', {
        p_user_id: session.user.id
      });

      if (error) {
        console.error('Failed to load user companies:', error);
        return;
      }

      // Store full response in localStorage like backup does
      if (data) {
        localStorage.setItem('user', JSON.stringify(data));

        // Set current user from RPC response
        if (data.user_id && data.email) {
          setCurrentUser({
            user_id: data.user_id,
            email: data.email,
            name: data.name || data.email
          });
        } else {
          // Fallback: use session user data
          setCurrentUser({
            user_id: session.user.id,
            email: session.user.email || '',
            name: session.user.user_metadata?.name || session.user.email || ''
          });
        }
      }

      // Check if data has companies array
      if (data && data.companies && data.companies.length > 0) {
        // Store all companies in state
        setCompanies(data.companies);

        // Get previously selected company or use first available
        const storedCompanyId = localStorage.getItem('companyChoosen');
        let selectedCompany = data.companies[0];

        if (storedCompanyId) {
          const found = data.companies.find((c: Company) => c.company_id === storedCompanyId);
          if (found) {
            selectedCompany = found;
          }
        }

        setCurrentCompany(selectedCompany);

        // Store company selection
        localStorage.setItem('companyChoosen', selectedCompany.company_id);

        // Set store: prioritize stored selection, fallback to first store
        if (selectedCompany.stores && selectedCompany.stores.length > 0) {
          const storedStoreId = localStorage.getItem('storeChoosen');
          let selectedStore = selectedCompany.stores[0]; // Default to first store

          // Try to find the stored store in current company's stores
          if (storedStoreId) {
            const foundStore = selectedCompany.stores.find((s) => s.store_id === storedStoreId);
            if (foundStore) {
              selectedStore = foundStore;
            }
          }

          setCurrentStore(selectedStore);
          localStorage.setItem('storeChoosen', selectedStore.store_id);
        }
      } else {
        setCompanies([]);
      }
    } catch (error) {
      console.error('Error loading user data:', error);
    }
  };

  // Load category features from Supabase
  const loadCategoryFeatures = async () => {
    try {
      // Check if user is authenticated first
      const { data: { session }, error: sessionError } = await supabaseService.getClient().auth.getSession();

      if (sessionError || !session) {
        return;
      }

      // Try to load from localStorage first
      const storedFeatures = localStorage.getItem('categoryFeatures');
      if (storedFeatures) {
        try {
          const features = JSON.parse(storedFeatures);
          setCategoryFeatures(features);
        } catch (e) {
          console.error('Failed to parse stored category features:', e);
        }
      }

      // Call RPC without parameters (no p_user_id needed)
      const { data, error } = await supabaseService.getClient().rpc('get_categories_with_features');

      if (error) {
        console.error('Failed to load category features:', error);
        return;
      }

      // Store in localStorage and state
      if (data) {
        localStorage.setItem('categoryFeatures', JSON.stringify(data));
        setCategoryFeatures(data);
      }
    } catch (error) {
      console.error('Error loading category features:', error);
    }
  };

  // Load user data on mount if authenticated
  useEffect(() => {
    const initializeUserData = async () => {
      const { data: { session } } = await supabaseService.getClient().auth.getSession();

      if (session) {
        // Try to load from localStorage first
        const storedCompanyId = localStorage.getItem('companyChoosen');
        const storedStoreId = localStorage.getItem('storeChoosen');
        const storedUser = localStorage.getItem('user');

        if (storedCompanyId && storedUser) {
          try {
            const userData = JSON.parse(storedUser);

            // Set current user from stored data
            if (userData.user_id && userData.email) {
              setCurrentUser({
                user_id: userData.user_id,
                email: userData.email,
                name: userData.name || userData.email
              });
            } else if (session) {
              // Fallback: use session user data
              setCurrentUser({
                user_id: session.user.id,
                email: session.user.email || '',
                name: session.user.user_metadata?.name || session.user.email || ''
              });
            }

            // Find the company that matches the stored company_id
            if (userData.companies && userData.companies.length > 0) {
              // Set all companies
              setCompanies(userData.companies);

              const company = userData.companies.find(
                (c: any) => c.company_id === storedCompanyId
              );
              if (company) {
                setCurrentCompany(company);

                // Find and set the stored store
                if (storedStoreId && company.stores && company.stores.length > 0) {
                  const store = company.stores.find(
                    (s: Store) => s.store_id === storedStoreId
                  );
                  if (store) {
                    setCurrentStore(store);
                  } else if (company.stores.length > 0) {
                    setCurrentStore(company.stores[0]);
                  }
                }
              } else {
                // If stored company not found, use first one
                const firstCompany = userData.companies[0];
                setCurrentCompany(firstCompany);
                if (firstCompany.stores && firstCompany.stores.length > 0) {
                  setCurrentStore(firstCompany.stores[0]);
                }
              }
            }
          } catch (e) {
            console.error('Failed to parse stored user data:', e);
          }
        }

        // Load fresh data from Supabase
        await loadUserData();
        // Load category features
        await loadCategoryFeatures();
      }
    };

    initializeUserData();
  }, []);

  // Wrapper for setCurrentStore to update localStorage
  const handleSetCurrentStore = (store: Store | null) => {
    setCurrentStore(store);
    if (store) {
      localStorage.setItem('storeChoosen', store.store_id);
    } else {
      localStorage.removeItem('storeChoosen');
    }
  };

  const value: AppState = {
    currentCompany,
    currentStore,
    companies,
    currentUser,
    categoryFeatures,
    permissions: currentCompany?.role?.permissions || [],
    setCurrentCompany,
    setCurrentStore: handleSetCurrentStore,
    setCurrentUser,
    loadUserData,
    loadCategoryFeatures,
  };

  return <AppStateContext.Provider value={value}>{children}</AppStateContext.Provider>;
};

export const useAppState = (): AppState => {
  const context = useContext(AppStateContext);
  if (!context) {
    throw new Error('useAppState must be used within AppStateProvider');
  }
  return context;
};
