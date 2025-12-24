/**
 * CashBalancePage Component
 * Excel-style spreadsheet view with left sidebar filter
 * Click on cell to see journal details
 */

import React, { useState, useMemo, useEffect, useCallback } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { supabaseService } from '@/core/services/supabase_service';
import type { CashBalancePageProps } from './CashBalancePage.types';
import styles from './CashBalancePage.module.css';

interface CashLocation {
  locationId: string;
  locationName: string;
  currencyCode: string;
  locationType: string;
  storeId: string | null;
  storeName: string | null;
}

interface CashEntry {
  date: string;
  locationId: string;
  inAmount: number;
  outAmount: number;
  originalInAmount: number;
  originalOutAmount: number;
  originalCurrencyCode: string;
}

interface JournalDetail {
  journalId: string;
  lineId: string;
  entryDate: string;
  description: string;
  journalType: string;
  lineDescription: string;
  debit: number;
  credit: number;
  accountName: string;
}

interface JournalEntryDetail {
  journalId: string;
  description: string;
  journalType: string;
  aiDescription: string | null;
  createdByName: string | null;
  createdAt: string | null;
  attachments: { attachmentId: string; fileUrl: string; thumbnailUrl: string; fileName: string; fileType: string | null }[];
  lines: { lineId: string; accountName: string; description: string | null; debit: number; credit: number }[];
}

interface LedgerBalance {
  currencyId: string;
  currencyCode: string;
  yesterdayBalance: number;
  todayBalance: number;
  balanceChange: number;
  isMultiCurrency: boolean;
}

interface DenominationChange {
  denominationId: string;
  currencyId: string;
  currencyCode: string;
  denominationValue: number;
  todayQuantity: number;
  yesterdayQuantity: number;
  quantityChange: number;
  todayAmount: number;
  yesterdayAmount: number;
  amountChange: number;
}

interface ModalState {
  isOpen: boolean;
  date: string;
  locationId: string;
  locationName: string;
  currencyCode: string;
  originalCurrencyCode: string;
  originalInAmount: number;
  originalOutAmount: number;
  baseInAmount: number;
  baseOutAmount: number;
}

const CURRENCY_SYMBOLS: Record<string, string> = {
  KRW: '₩',
  VND: '₫',
  CNY: '¥',
  USD: '$',
  JPY: '¥',
};

export const CashBalancePage: React.FC<CashBalancePageProps> = () => {
  const { currentCompany } = useAppState();
  const companyId = currentCompany?.company_id || '';

  // Filter state
  const [startDate, setStartDate] = useState(() => {
    const d = new Date();
    d.setDate(d.getDate() - 30);
    return d.toISOString().split('T')[0];
  });
  const [endDate, setEndDate] = useState(() => new Date().toISOString().split('T')[0]);
  const [selectedStores, setSelectedStores] = useState<string[]>([]);
  const [selectedTypes, setSelectedTypes] = useState<string[]>([]);
  const [selectedCurrencies, setSelectedCurrencies] = useState<string[]>([]);

  // Data state
  const [locations, setLocations] = useState<CashLocation[]>([]);
  const [entries, setEntries] = useState<CashEntry[]>([]);
  const [loading, setLoading] = useState(true);

  // Modal state for journal details
  const [modal, setModal] = useState<ModalState>({
    isOpen: false,
    date: '',
    locationId: '',
    locationName: '',
    currencyCode: '',
    originalCurrencyCode: '',
    originalInAmount: 0,
    originalOutAmount: 0,
    baseInAmount: 0,
    baseOutAmount: 0,
  });

  // Currency ID to Code mapping
  const [currencyIdToCode, setCurrencyIdToCode] = useState<Record<string, string>>({});
  const [currencyCodeToId, setCurrencyCodeToId] = useState<Record<string, string>>({});
  const [journalDetails, setJournalDetails] = useState<JournalDetail[]>([]);
  const [journalLoading, setJournalLoading] = useState(false);
  const [exchangeRate, setExchangeRate] = useState<number | null>(null);
  const [ledgerBalances, setLedgerBalances] = useState<LedgerBalance[]>([]);
  const [denominationChanges, setDenominationChanges] = useState<DenominationChange[]>([]);
  const [locationType, setLocationType] = useState<string>('');
  const [showDenominations, setShowDenominations] = useState(false);
  const [selectedJournalId, setSelectedJournalId] = useState<string | null>(null);
  const [journalEntryDetail, setJournalEntryDetail] = useState<JournalEntryDetail | null>(null);
  const [detailLoading, setDetailLoading] = useState(false);

  // Current balance for each location (latest balance_after)
  const [currentBalances, setCurrentBalances] = useState<Map<string, { balance: number; currencyCode: string }>>(new Map());

  // Fetch currency ID to code mapping
  useEffect(() => {
    const fetchCurrencies = async () => {
      const supabase = supabaseService.getClient();
      const { data, error } = await supabase
        .from('currency_types')
        .select('currency_id, currency_code');

      if (!error && data) {
        const idToCode: Record<string, string> = {};
        const codeToId: Record<string, string> = {};
        data.forEach(d => {
          idToCode[d.currency_id] = d.currency_code;
          codeToId[d.currency_code] = d.currency_id;
        });
        setCurrencyIdToCode(idToCode);
        setCurrencyCodeToId(codeToId);
      }
    };
    fetchCurrencies();
  }, []);

  // Fetch locations
  useEffect(() => {
    if (!companyId) return;

    const fetchLocations = async () => {
      const supabase = supabaseService.getClient();
      const { data, error } = await supabase
        .from('cash_locations')
        .select(`
          cash_location_id,
          location_name,
          currency_code,
          location_type,
          store_id,
          currency_id,
          stores!left(store_id, store_name),
          currency_types!left(currency_code)
        `)
        .eq('company_id', companyId)
        .or('is_deleted.is.null,is_deleted.eq.false');

      if (!error && data) {
        const mappedLocations = data.map(d => {
          // Priority: currency_code > currency_types.currency_code > 'VND'
          const currencyFromType = (d.currency_types as any)?.currency_code;
          const currencyCode = d.currency_code || currencyFromType || 'VND';
          return {
            locationId: d.cash_location_id,
            locationName: d.location_name,
            currencyCode,
            locationType: d.location_type || 'cash',
            storeId: d.store_id,
            storeName: (d.stores as any)?.store_name || null,
          };
        });
        // Sort by store name, then location name
        mappedLocations.sort((a, b) => {
          const storeA = a.storeName || 'zzz';
          const storeB = b.storeName || 'zzz';
          if (storeA !== storeB) return storeA.localeCompare(storeB);
          return a.locationName.localeCompare(b.locationName);
        });
        setLocations(mappedLocations);
      }
    };

    fetchLocations();
  }, [companyId]);

  // Fetch entries using RPC with timezone conversion
  useEffect(() => {
    if (!companyId || Object.keys(currencyIdToCode).length === 0) return;

    const fetchEntries = async () => {
      setLoading(true);
      const supabase = supabaseService.getClient();

      // Use RPC to get entries with local date conversion
      const { data, error } = await supabase.rpc('get_cash_entries_by_local_date', {
        p_company_id: companyId,
        p_start_date: startDate,
        p_end_date: endDate,
      });

      if (!error && data) {
        const entriesMap = new Map<string, CashEntry>();

        data.forEach((d: {
          local_date: string;
          location_id: string;
          net_cash_flow: string;
          original_change: string;
          original_currency_id: string;
        }) => {
          const key = `${d.local_date}|${d.location_id}`;
          const existing = entriesMap.get(key) || {
            date: d.local_date,
            locationId: d.location_id,
            inAmount: 0,
            outAmount: 0,
            originalInAmount: 0,
            originalOutAmount: 0,
            originalCurrencyCode: currencyIdToCode[d.original_currency_id] || 'VND',
          };

          // Base currency flow (VND)
          const flow = parseFloat(d.net_cash_flow) || 0;
          if (flow > 0) {
            existing.inAmount += flow;
          } else {
            existing.outAmount += Math.abs(flow);
          }

          // Original currency flow (KRW, VND, etc.)
          const originalFlow = parseFloat(d.original_change) || 0;
          if (originalFlow > 0) {
            existing.originalInAmount += originalFlow;
          } else {
            existing.originalOutAmount += Math.abs(originalFlow);
          }

          // Update currency code if we have it
          if (d.original_currency_id && currencyIdToCode[d.original_currency_id]) {
            existing.originalCurrencyCode = currencyIdToCode[d.original_currency_id];
          }

          entriesMap.set(key, existing);
        });

        setEntries(Array.from(entriesMap.values()));
      }
      setLoading(false);
    };

    fetchEntries();
  }, [companyId, startDate, endDate, currencyIdToCode]);

  // Fetch current balance for each location (latest balance_after)
  useEffect(() => {
    if (!companyId || locations.length === 0 || Object.keys(currencyIdToCode).length === 0) return;

    const fetchCurrentBalances = async () => {
      const supabase = supabaseService.getClient();

      // Build location type map from already fetched locations
      const locationTypeMap = new Map<string, string>();
      locations.forEach(l => locationTypeMap.set(l.locationId, l.locationType));

      // Get the latest entry for each location
      const locationIds = locations.map(l => l.locationId);

      // Query to get the latest balance for each location
      // Include denomination_summary for bank's original currency amount
      const { data, error } = await supabase
        .from('cash_amount_entries')
        .select('location_id, balance_after, currency_id, current_stock_snapshot, denomination_summary')
        .in('location_id', locationIds)
        .order('created_at_utc', { ascending: false });

      if (error) {
        console.error('Error fetching current balances:', error);
        return;
      }

      if (data) {
        const balancesMap = new Map<string, { balance: number; currencyCode: string }>();

        // Group by location_id and take the first (latest) entry
        data.forEach((d: any) => {
          if (!balancesMap.has(d.location_id)) {
            const locationType = locationTypeMap.get(d.location_id) || 'cash';
            let balance = 0;
            let currencyCode = 'VND';

            if (locationType === 'bank') {
              // For bank: use denomination_summary[0].amount (original currency)
              const denomSummary = d.denomination_summary;
              if (denomSummary && denomSummary.length > 0) {
                balance = parseFloat(denomSummary[0].amount) || 0;
                currencyCode = currencyIdToCode[denomSummary[0].currency_id] || 'VND';
              }
            } else {
              // For vault/cash: sum from snapshot (original currency)
              const snapshot = d.current_stock_snapshot;
              if (snapshot?.denominations && snapshot.denominations.length > 0) {
                let total = 0;
                snapshot.denominations.forEach((denom: any) => {
                  total += (parseFloat(denom.value) || 0) * (parseInt(denom.quantity) || 0);
                });
                balance = total;
                // Get currency code from first denomination
                currencyCode = currencyIdToCode[snapshot.denominations[0].currency_id] || 'VND';
              }
            }

            balancesMap.set(d.location_id, { balance, currencyCode });
          }
        });

        setCurrentBalances(balancesMap);
      }
    };

    fetchCurrentBalances();
  }, [companyId, locations, currencyIdToCode]);

  // Get unique stores, types, and currencies for filter
  const availableStores = useMemo(() => {
    const stores = new Set(locations.map(l => l.storeName || 'No Store'));
    return Array.from(stores).sort();
  }, [locations]);

  const availableTypes = useMemo(() => {
    const types = new Set(locations.map(l => l.locationType));
    return Array.from(types).sort();
  }, [locations]);

  const availableCurrencies = useMemo(() => {
    const currencies = new Set(locations.map(l => l.currencyCode));
    return Array.from(currencies).sort();
  }, [locations]);

  // Filter locations
  const filteredLocations = useMemo(() => {
    return locations.filter(loc => {
      const storeName = loc.storeName || 'No Store';
      if (selectedStores.length > 0 && !selectedStores.includes(storeName)) return false;
      if (selectedTypes.length > 0 && !selectedTypes.includes(loc.locationType)) return false;
      if (selectedCurrencies.length > 0 && !selectedCurrencies.includes(loc.currencyCode)) return false;
      return true;
    });
  }, [locations, selectedStores, selectedTypes, selectedCurrencies]);

  // Get unique dates
  const dates = useMemo(() => {
    const uniqueDates = [...new Set(entries.map(e => e.date))];
    return uniqueDates.sort();
  }, [entries]);

  // Build entry map
  const entryMap = useMemo(() => {
    const map = new Map<string, {
      in: number;
      out: number;
      originalIn: number;
      originalOut: number;
      originalCurrency: string;
    }>();
    entries.forEach(entry => {
      const key = `${entry.date}|${entry.locationId}`;
      const existing = map.get(key) || {
        in: 0,
        out: 0,
        originalIn: 0,
        originalOut: 0,
        originalCurrency: entry.originalCurrencyCode,
      };
      existing.in += entry.inAmount;
      existing.out += entry.outAmount;
      existing.originalIn += entry.originalInAmount;
      existing.originalOut += entry.originalOutAmount;
      existing.originalCurrency = entry.originalCurrencyCode;
      map.set(key, existing);
    });
    return map;
  }, [entries]);

  // Calculate totals
  const locationTotals = useMemo(() => {
    const totals = new Map<string, {
      in: number;
      out: number;
      originalIn: number;
      originalOut: number;
      originalCurrency: string;
    }>();
    filteredLocations.forEach(loc => totals.set(loc.locationId, {
      in: 0,
      out: 0,
      originalIn: 0,
      originalOut: 0,
      originalCurrency: loc.currencyCode,
    }));
    entries.forEach(entry => {
      if (totals.has(entry.locationId)) {
        const existing = totals.get(entry.locationId)!;
        existing.in += entry.inAmount;
        existing.out += entry.outAmount;
        existing.originalIn += entry.originalInAmount;
        existing.originalOut += entry.originalOutAmount;
        existing.originalCurrency = entry.originalCurrencyCode;
      }
    });
    return totals;
  }, [filteredLocations, entries]);

  // Group locations by store for header
  const storeGroups = useMemo(() => {
    const groups: { storeName: string; count: number }[] = [];
    let currentStore = '';
    let count = 0;

    filteredLocations.forEach(loc => {
      const store = loc.storeName || 'No Store';
      if (store !== currentStore) {
        if (count > 0) {
          groups.push({ storeName: currentStore, count });
        }
        currentStore = store;
        count = 1;
      } else {
        count++;
      }
    });
    if (count > 0) {
      groups.push({ storeName: currentStore, count });
    }
    return groups;
  }, [filteredLocations]);

  const formatNumber = (num: number, currency: string): string => {
    if (num === 0) return '';
    const symbol = CURRENCY_SYMBOLS[currency] || '';
    return `${symbol}${num.toLocaleString()}`;
  };

  const formatDate = (dateStr: string): string => {
    // dateStr is "YYYY-MM-DD" format, parse directly to avoid timezone issues
    const [year, month, day] = dateStr.split('-').map(Number);
    return `${month}/${day}`;
  };

  // Get subtle background color by location type (minimal, professional)
  const getLocationTypeStyle = (locationType: string): React.CSSProperties => {
    switch (locationType) {
      case 'bank':
        return { background: '#e8f5e9' }; // subtle green
      case 'vault':
        return { background: '#fff3e0' }; // subtle orange
      case 'wallet': // online wallet
        return { background: '#e3f2fd' }; // subtle blue
      default: // cashier/cash
        return { background: '#f5f5f5' }; // default gray
    }
  };

  const toggleStore = (store: string) => {
    setSelectedStores(prev =>
      prev.includes(store) ? prev.filter(s => s !== store) : [...prev, store]
    );
  };

  const toggleType = (type: string) => {
    setSelectedTypes(prev =>
      prev.includes(type) ? prev.filter(t => t !== type) : [...prev, type]
    );
  };

  const toggleCurrency = (currency: string) => {
    setSelectedCurrencies(prev =>
      prev.includes(currency) ? prev.filter(c => c !== currency) : [...prev, currency]
    );
  };

  // Handle cell click - fetch journal details, ledger balance, and denomination changes
  const handleCellClick = useCallback(async (date: string, location: CashLocation, entry: {
    in: number;
    out: number;
    originalIn: number;
    originalOut: number;
    originalCurrency: string;
  }) => {
    setModal({
      isOpen: true,
      date,
      locationId: location.locationId,
      locationName: location.locationName,
      currencyCode: location.currencyCode,
      originalCurrencyCode: entry.originalCurrency,
      originalInAmount: entry.originalIn,
      originalOutAmount: entry.originalOut,
      baseInAmount: entry.in,
      baseOutAmount: entry.out,
    });
    setJournalLoading(true);
    setJournalDetails([]);
    setExchangeRate(null);
    setLedgerBalances([]);
    setDenominationChanges([]);
    setLocationType(location.locationType);
    setShowDenominations(false);
    setSelectedJournalId(null);
    setJournalEntryDetail(null);

    try {
      const supabase = supabaseService.getClient();

      // Fetch all data in parallel
      const fromCurrencyId = currencyCodeToId[entry.originalCurrency];
      const toCurrencyId = currencyCodeToId['VND'];

      const [journalResult, rateResult, ledgerResult, denomResult] = await Promise.all([
        // Journal details
        supabase.rpc('get_journal_details_by_local_date', {
          p_company_id: companyId,
          p_cash_location_id: location.locationId,
          p_local_date: date,
        }),
        // Exchange rate (get closest rate on or before the date)
        fromCurrencyId && toCurrencyId && entry.originalCurrency !== 'VND'
          ? supabase
              .from('book_exchange_rates')
              .select('rate')
              .eq('company_id', companyId)
              .eq('from_currency_id', fromCurrencyId)
              .eq('to_currency_id', toCurrencyId)
              .lte('rate_date', date)
              .order('rate_date', { ascending: false })
              .limit(1)
          : Promise.resolve({ data: null, error: null }),
        // Ledger balance (yesterday, today, change by currency)
        supabase.rpc('get_real_balance_ledger', {
          p_company_id: companyId,
          p_location_id: location.locationId,
          p_local_date: date,
        }),
        // Denomination changes (for vault/cash only)
        location.locationType !== 'bank'
          ? supabase.rpc('get_denomination_changes', {
              p_company_id: companyId,
              p_location_id: location.locationId,
              p_local_date: date,
            })
          : Promise.resolve({ data: [], error: null }),
      ]);

      // Process journal details
      if (!journalResult.error && journalResult.data) {
        const details: JournalDetail[] = journalResult.data.map((d: any) => ({
          journalId: d.journal_id || '',
          lineId: d.line_id || '',
          entryDate: d.local_date || '',
          description: d.journal_description || '',
          journalType: d.journal_type || '',
          lineDescription: d.line_description || '',
          debit: parseFloat(d.debit) || 0,
          credit: parseFloat(d.credit) || 0,
          accountName: d.account_name || '',
        }));
        setJournalDetails(details);
      }

      // Process exchange rate
      if (!rateResult.error && rateResult.data && rateResult.data.length > 0) {
        setExchangeRate(parseFloat(rateResult.data[0].rate));
      }

      // Process ledger balances
      if (!ledgerResult.error && ledgerResult.data) {
        const balances: LedgerBalance[] = ledgerResult.data.map((d: any) => ({
          currencyId: d.currency_id || '',
          currencyCode: currencyIdToCode[d.currency_id] || 'VND',
          yesterdayBalance: parseFloat(d.yesterday_balance) || 0,
          todayBalance: parseFloat(d.today_balance) || 0,
          balanceChange: parseFloat(d.balance_change) || 0,
          isMultiCurrency: d.is_multi_currency || false,
        }));
        setLedgerBalances(balances);
      }

      // Process denomination changes
      if (!denomResult.error && denomResult.data) {
        const changes: DenominationChange[] = denomResult.data.map((d: any) => ({
          denominationId: d.denomination_id || '',
          currencyId: d.currency_id || '',
          currencyCode: currencyIdToCode[d.currency_id] || 'VND',
          denominationValue: parseFloat(d.denomination_value) || 0,
          todayQuantity: parseInt(d.today_quantity) || 0,
          yesterdayQuantity: parseInt(d.yesterday_quantity) || 0,
          quantityChange: parseInt(d.quantity_change) || 0,
          todayAmount: parseFloat(d.today_amount) || 0,
          yesterdayAmount: parseFloat(d.yesterday_amount) || 0,
          amountChange: parseFloat(d.amount_change) || 0,
        }));
        setDenominationChanges(changes);
      }
    } catch (err) {
      console.error('Error fetching data:', err);
    }

    setJournalLoading(false);
  }, [companyId, currencyCodeToId, currencyIdToCode]);

  // Handle journal row click - fetch detail by journal_id
  const handleJournalClick = useCallback(async (journalId: string) => {
    // Toggle off if already selected
    if (selectedJournalId === journalId) {
      setSelectedJournalId(null);
      setJournalEntryDetail(null);
      return;
    }

    setSelectedJournalId(journalId);
    setDetailLoading(true);
    setJournalEntryDetail(null);

    try {
      const supabase = supabaseService.getClient();

      // Fetch journal entry, lines, and attachments separately
      const [entryResult, linesResult, attachmentsResult] = await Promise.all([
        supabase
          .from('journal_entries')
          .select('journal_id, description, journal_type, ai_description, created_at_utc, created_by')
          .eq('journal_id', journalId)
          .single(),
        supabase
          .from('journal_lines')
          .select('line_id, description, debit, credit, account_id')
          .eq('journal_id', journalId)
          .or('is_deleted.is.null,is_deleted.eq.false'),
        supabase
          .from('journal_attachments')
          .select('attachment_id, file_url, file_name, file_type')
          .eq('journal_id', journalId),
      ]);

      if (entryResult.error) {
        console.error('Entry fetch error:', entryResult.error);
        setDetailLoading(false);
        return;
      }
      if (linesResult.error) {
        console.error('Lines fetch error:', linesResult.error);
      }
      if (attachmentsResult.error) {
        console.error('Attachments fetch error:', attachmentsResult.error);
      }

      const entry = entryResult.data;
      const lines = linesResult.data || [];

      // Fetch account names for all account_ids
      const accountIds = lines.map((l: any) => l.account_id).filter(Boolean);
      let accountMap: Record<string, string> = {};

      if (accountIds.length > 0) {
        const { data: accountsData } = await supabase
          .from('accounts')
          .select('account_id, account_name')
          .in('account_id', accountIds);

        if (accountsData) {
          accountsData.forEach((a: any) => {
            accountMap[a.account_id] = a.account_name;
          });
        }
      }

      // Fetch user name if created_by exists
      let createdByName: string | null = null;
      if (entry.created_by) {
        const { data: userData } = await supabase
          .from('users')
          .select('first_name, last_name, email')
          .eq('user_id', entry.created_by)
          .single();

        if (userData) {
          // Combine first_name and last_name, fallback to email
          const fullName = [userData.first_name, userData.last_name].filter(Boolean).join(' ');
          createdByName = fullName || userData.email || null;
        }
      }

      // Generate signed URLs for attachments
      const BUCKET_NAME = 'journal-attachments';
      const attachmentsWithSignedUrls = await Promise.all(
        (attachmentsResult.data || []).map(async (a: any) => {
          let signedUrl = a.file_url;

          if (a.file_url) {
            // Extract storage path from file_url
            const bucketIndex = a.file_url.indexOf(BUCKET_NAME);
            if (bucketIndex !== -1) {
              const storagePath = a.file_url.substring(bucketIndex + BUCKET_NAME.length + 1);

              // Create signed URL (1 hour expiry)
              const { data: signedData } = await supabase.storage
                .from(BUCKET_NAME)
                .createSignedUrl(storagePath, 3600);
              if (signedData?.signedUrl) {
                signedUrl = signedData.signedUrl;
              }
            }
          }

          return {
            attachmentId: a.attachment_id,
            fileUrl: signedUrl,
            thumbnailUrl: signedUrl, // Same as original, CSS handles sizing
            fileName: a.file_name,
            fileType: a.file_type,
          };
        })
      );

      const detail: JournalEntryDetail = {
        journalId: entry.journal_id,
        description: entry.description || '',
        journalType: entry.journal_type || '',
        aiDescription: entry.ai_description || null,
        createdByName,
        createdAt: entry.created_at_utc || null,
        attachments: attachmentsWithSignedUrls,
        lines: lines.map((l: any) => ({
          lineId: l.line_id,
          accountName: accountMap[l.account_id] || '',
          description: l.description || null,
          debit: parseFloat(l.debit) || 0,
          credit: parseFloat(l.credit) || 0,
        })),
      };
      setJournalEntryDetail(detail);
    } catch (err) {
      console.error('Error fetching journal detail:', err);
    }

    setDetailLoading(false);
  }, [selectedJournalId]);

  const closeModal = () => {
    setModal(prev => ({ ...prev, isOpen: false }));
    setJournalDetails([]);
  };

  const formatFullDate = (dateStr: string): string => {
    const date = new Date(dateStr);
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  };

  return (
    <>
      <Navbar activeItem="finance" />
      <div className={styles.page}>
        {/* Left Sidebar Filter */}
        <aside className={styles.sidebar}>
          <div className={styles.filterSection}>
            <h3>Store</h3>
            <ul className={styles.filterList}>
              {availableStores.map(store => (
                <li
                  key={store}
                  className={selectedStores.includes(store) ? styles.active : ''}
                  onClick={() => toggleStore(store)}
                >
                  {store}
                </li>
              ))}
            </ul>
          </div>

          <div className={styles.filterSection}>
            <h3>Location Type</h3>
            <ul className={styles.filterList}>
              {availableTypes.map(type => (
                <li
                  key={type}
                  className={selectedTypes.includes(type) ? styles.active : ''}
                  onClick={() => toggleType(type)}
                >
                  {type}
                </li>
              ))}
            </ul>
          </div>

          <div className={styles.filterSection}>
            <h3>Currency</h3>
            <ul className={styles.filterList}>
              {availableCurrencies.map(currency => (
                <li
                  key={currency}
                  className={selectedCurrencies.includes(currency) ? styles.active : ''}
                  onClick={() => toggleCurrency(currency)}
                >
                  {currency}
                </li>
              ))}
            </ul>
          </div>

          {(selectedStores.length > 0 || selectedTypes.length > 0 || selectedCurrencies.length > 0) && (
            <button
              className={styles.clearBtn}
              onClick={() => {
                setSelectedStores([]);
                setSelectedTypes([]);
                setSelectedCurrencies([]);
              }}
            >
              Clear Filters
            </button>
          )}
        </aside>

        {/* Main Content */}
        <main className={styles.main}>
          <div className={styles.header}>
            <h1>Cash Balance</h1>
            <div className={styles.dateFilter}>
              <input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
              <span>~</span>
              <input type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} />
            </div>
          </div>

          {loading ? (
            <div className={styles.loading}>Loading...</div>
          ) : (
            <div className={styles.tableWrapper}>
              <table className={styles.table}>
                <thead>
                  {/* Store group header row */}
                  <tr className={styles.storeRow}>
                    <th className={styles.dateCol}></th>
                    {storeGroups.map((group, idx) => (
                      <th
                        key={idx}
                        colSpan={group.count}
                        className={styles.storeHeader}
                      >
                        {group.storeName}
                      </th>
                    ))}
                  </tr>
                  {/* Location header row */}
                  <tr>
                    <th className={styles.dateCol}>DATE</th>
                    {filteredLocations.map(loc => (
                      <th key={loc.locationId} style={getLocationTypeStyle(loc.locationType)}>
                        {loc.locationName}
                        <span className={styles.currency}>{loc.currencyCode}</span>
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {dates.length === 0 ? (
                    <tr>
                      <td colSpan={filteredLocations.length + 1} className={styles.empty}>
                        No data for selected period
                      </td>
                    </tr>
                  ) : (
                    <>
                      {dates.map(date => (
                        <tr key={date}>
                          <td className={styles.dateCol}>{formatDate(date)}</td>
                          {filteredLocations.map(loc => {
                            const key = `${date}|${loc.locationId}`;
                            const entry = entryMap.get(key);
                            const originalInVal = entry?.originalIn || 0;
                            const originalOutVal = entry?.originalOut || 0;
                            const originalCurrency = entry?.originalCurrency || loc.currencyCode;
                            // Always make cells clickable to show journal data even when no cash entries
                            const cellEntry = entry || {
                              in: 0,
                              out: 0,
                              originalIn: 0,
                              originalOut: 0,
                              originalCurrency: loc.currencyCode,
                            };
                            return (
                              <td
                                key={loc.locationId}
                                className={styles.clickable}
                                onClick={() => handleCellClick(date, loc, cellEntry)}
                              >
                                {originalInVal > 0 && <span className={styles.in}>{formatNumber(originalInVal, originalCurrency)}</span>}
                                {originalOutVal > 0 && <span className={styles.out}>{formatNumber(originalOutVal, originalCurrency)}</span>}
                              </td>
                            );
                          })}
                        </tr>
                      ))}
                      <tr className={styles.totalRow}>
                        <td className={styles.dateCol}>TOTAL</td>
                        {filteredLocations.map(loc => {
                          const totals = locationTotals.get(loc.locationId);
                          const originalInVal = totals?.originalIn || 0;
                          const originalOutVal = totals?.originalOut || 0;
                          const originalCurrency = totals?.originalCurrency || loc.currencyCode;
                          return (
                            <td key={loc.locationId}>
                              {originalInVal > 0 && <span className={styles.in}>{formatNumber(originalInVal, originalCurrency)}</span>}
                              {originalOutVal > 0 && <span className={styles.out}>{formatNumber(originalOutVal, originalCurrency)}</span>}
                            </td>
                          );
                        })}
                      </tr>
                      <tr className={styles.balanceRow}>
                        <td className={styles.dateCol}>BALANCE</td>
                        {filteredLocations.map(loc => {
                          const balanceData = currentBalances.get(loc.locationId);
                          const balance = balanceData?.balance || 0;
                          const currencyCode = balanceData?.currencyCode || loc.currencyCode;
                          return (
                            <td key={loc.locationId}>
                              {balance !== 0 && (
                                <span className={balance >= 0 ? styles.balancePositive : styles.balanceNegative}>
                                  {formatNumber(balance, currencyCode)}
                                </span>
                              )}
                            </td>
                          );
                        })}
                      </tr>
                    </>
                  )}
                </tbody>
              </table>
            </div>
          )}
        </main>
      </div>

      {/* Journal Details Modal */}
      {modal.isOpen && (
        <div className={styles.modalOverlay} onClick={closeModal}>
          <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
            <div className={styles.modalHeader}>
              <h2>Journal Details</h2>
              <button className={styles.closeBtn} onClick={closeModal}>×</button>
            </div>
            <div className={styles.modalInfo}>
              <span><strong>Date:</strong> {formatFullDate(modal.date)}</span>
              <span><strong>Location:</strong> {modal.locationName}</span>
              <span><strong>Currency:</strong> {modal.currencyCode}</span>
            </div>
            <div className={styles.modalBody}>
              {journalLoading ? (
                <div className={styles.loading}>Loading journals...</div>
              ) : (
                <>
                  {/* 1. Discrepancy Check */}
                  {(() => {
                    const journalNetChange = journalDetails.reduce((sum, d) => sum + d.debit - d.credit, 0);
                    const isBank = locationType === 'bank';
                    const isVND = !modal.originalCurrencyCode || modal.originalCurrencyCode === 'VND';

                    // For vault/cash OR bank with base currency (VND): simple comparison
                    if (!isBank || isVND) {
                      // Real change = balance_after change (already in VND)
                      const realChangeVND = modal.baseInAmount - modal.baseOutAmount;
                      const difference = realChangeVND - journalNetChange;
                      const hasDifference = Math.abs(difference) > 0.01;

                      return (
                        <div className={styles.summarySection}>
                          <h3>Discrepancy Check (VND)</h3>
                          <table className={styles.summaryTable}>
                            <tbody>
                              <tr>
                                <td>Real Balance Change (VND)</td>
                                <td className={realChangeVND >= 0 ? styles.in : styles.out}>
                                  <strong>{formatNumber(realChangeVND, 'VND')}</strong>
                                </td>
                              </tr>
                              <tr>
                                <td>Journal Net Change (VND)</td>
                                <td className={journalNetChange >= 0 ? styles.in : styles.out}>
                                  <strong>{formatNumber(journalNetChange, 'VND')}</strong>
                                </td>
                              </tr>
                              <tr className={hasDifference ? styles.warningRow : styles.okRow}>
                                <td><strong>Difference (Real - Journal)</strong></td>
                                <td>
                                  <strong>{hasDifference ? '⚠️ ' : '✓ '}{formatNumber(difference, 'VND')}</strong>
                                </td>
                              </tr>
                            </tbody>
                          </table>
                        </div>
                      );
                    }

                    // For bank with foreign currency: use exchange rate conversion
                    const realOriginalChange = modal.originalInAmount - modal.originalOutAmount;
                    const rate = exchangeRate || 1;
                    const realChangeInVND = Math.round(realOriginalChange * rate);
                    const difference = realChangeInVND - journalNetChange;
                    const hasDifference = Math.abs(difference) > 0.01;

                    return (
                      <div className={styles.summarySection}>
                        <h3>Discrepancy Check</h3>
                        <table className={styles.summaryTable}>
                          <tbody>
                            <tr>
                              <td>Real Balance Change ({modal.originalCurrencyCode})</td>
                              <td className={realOriginalChange >= 0 ? styles.in : styles.out}>
                                <strong>{formatNumber(realOriginalChange, modal.originalCurrencyCode)}</strong>
                              </td>
                            </tr>
                            <tr>
                              <td>Exchange Rate ({modal.originalCurrencyCode} → VND)</td>
                              <td>
                                {exchangeRate
                                  ? <strong>1 {modal.originalCurrencyCode} = {formatNumber(exchangeRate, 'VND')}</strong>
                                  : <span style={{ color: '#999' }}>No rate found</span>
                                }
                              </td>
                            </tr>
                            <tr>
                              <td>Real Balance Change (Converted VND)</td>
                              <td className={realChangeInVND >= 0 ? styles.in : styles.out}>
                                <strong>{formatNumber(realChangeInVND, 'VND')}</strong>
                              </td>
                            </tr>
                            <tr>
                              <td>Journal Net Change (Base VND)</td>
                              <td className={journalNetChange >= 0 ? styles.in : styles.out}>
                                <strong>{formatNumber(journalNetChange, 'VND')}</strong>
                              </td>
                            </tr>
                            <tr className={hasDifference ? styles.warningRow : styles.okRow}>
                              <td><strong>Difference (Real - Journal)</strong></td>
                              <td>
                                <strong>{hasDifference ? '⚠️ ' : '✓ '}{formatNumber(difference, 'VND')}</strong>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                    );
                  })()}

                  {/* 2. Real Balance Ledger Format (Yesterday → Change → Today) */}
                  {ledgerBalances.length > 0 && (
                    <div className={styles.conversionSection}>
                      <h3>Real Balance (Ledger)</h3>
                      <table className={styles.conversionTable}>
                        <thead>
                          <tr>
                            <th>Currency</th>
                            <th>Yesterday</th>
                            <th>Change</th>
                            <th>Today</th>
                          </tr>
                        </thead>
                        <tbody>
                          {ledgerBalances.map((balance, idx) => (
                            <tr key={idx}>
                              <td>{balance.currencyCode}</td>
                              <td>{formatNumber(balance.yesterdayBalance, balance.currencyCode)}</td>
                              <td className={balance.balanceChange >= 0 ? styles.in : styles.out}>
                                {balance.balanceChange >= 0 ? '+' : ''}{formatNumber(balance.balanceChange, balance.currencyCode)}
                              </td>
                              <td><strong>{formatNumber(balance.todayBalance, balance.currencyCode)}</strong></td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                      {ledgerBalances.some(b => b.isMultiCurrency) && (
                        <div style={{ marginTop: '8px', fontSize: '11px', color: '#666' }}>
                          * Multi-currency location - balances shown per currency
                        </div>
                      )}
                    </div>
                  )}

                  {/* 3. Denomination Changes (for vault/cash only) - Hidden by default */}
                  {locationType !== 'bank' && denominationChanges.length > 0 && (
                    <div className={styles.conversionSection}>
                      <button
                        onClick={() => setShowDenominations(!showDenominations)}
                        style={{
                          background: 'none',
                          border: 'none',
                          color: '#1976d2',
                          cursor: 'pointer',
                          fontSize: '13px',
                          padding: '4px 0',
                          display: 'flex',
                          alignItems: 'center',
                          gap: '4px',
                        }}
                      >
                        <span style={{ fontSize: '10px' }}>{showDenominations ? '▼' : '▶'}</span>
                        {showDenominations ? 'Hide' : 'Show'} Denomination Changes
                      </button>

                      {showDenominations && (() => {
                        // Group by currency
                        const currencyGroups = denominationChanges.reduce((acc, change) => {
                          const key = change.currencyCode;
                          if (!acc[key]) acc[key] = [];
                          acc[key].push(change);
                          return acc;
                        }, {} as Record<string, DenominationChange[]>);

                        return (
                          <div style={{ marginTop: '12px' }}>
                            {Object.entries(currencyGroups).map(([currencyCode, changes]) => {
                              const totalYesterday = changes.reduce((sum, c) => sum + c.yesterdayAmount, 0);
                              const totalToday = changes.reduce((sum, c) => sum + c.todayAmount, 0);
                              const totalChange = changes.reduce((sum, c) => sum + c.amountChange, 0);

                              return (
                                <div key={currencyCode} style={{ marginBottom: '16px' }}>
                                  {Object.keys(currencyGroups).length > 1 && (
                                    <div style={{ fontWeight: 600, marginBottom: '8px', color: '#1976d2' }}>
                                      {currencyCode}
                                    </div>
                                  )}
                                  <table className={styles.conversionTable}>
                                    <thead>
                                      <tr>
                                        <th>Denomination</th>
                                        <th>Yesterday</th>
                                        <th>Change</th>
                                        <th>Today</th>
                                      </tr>
                                    </thead>
                                    <tbody>
                                      {changes.map((change, idx) => (
                                        <tr key={idx}>
                                          <td>{formatNumber(change.denominationValue, currencyCode)}</td>
                                          <td>{change.yesterdayQuantity} pcs</td>
                                          <td className={change.quantityChange >= 0 ? styles.in : styles.out}>
                                            {change.quantityChange >= 0 ? '+' : ''}{change.quantityChange} pcs
                                          </td>
                                          <td><strong>{change.todayQuantity} pcs</strong></td>
                                        </tr>
                                      ))}
                                    </tbody>
                                    <tfoot>
                                      <tr>
                                        <td><strong>Total</strong></td>
                                        <td>{formatNumber(totalYesterday, currencyCode)}</td>
                                        <td className={totalChange >= 0 ? styles.in : styles.out}>
                                          <strong>{totalChange >= 0 ? '+' : ''}{formatNumber(totalChange, currencyCode)}</strong>
                                        </td>
                                        <td><strong>{formatNumber(totalToday, currencyCode)}</strong></td>
                                      </tr>
                                    </tfoot>
                                  </table>
                                </div>
                              );
                            })}
                          </div>
                        );
                      })()}
                    </div>
                  )}

                  {/* 4. Journal Records + Net Change */}
                  <div className={styles.journalSection}>
                    <h3>Journal Entries (Base VND)</h3>
                    {journalDetails.length === 0 ? (
                      <div className={styles.empty}>No journal entries found</div>
                    ) : (
                      <table className={styles.journalTable}>
                        <thead>
                          <tr>
                            <th style={{ width: '40px', textAlign: 'center' }}></th>
                            <th>Account</th>
                            <th>Description</th>
                            <th>Debit</th>
                            <th>Credit</th>
                          </tr>
                        </thead>
                        <tbody>
                          {journalDetails.map((detail, idx) => (
                            <React.Fragment key={idx}>
                              <tr
                                style={{
                                  background: selectedJournalId === detail.journalId ? '#e3f2fd' : undefined,
                                  cursor: 'pointer',
                                }}
                                onClick={() => handleJournalClick(detail.journalId)}
                              >
                                <td style={{ textAlign: 'center', padding: '6px 4px' }}>
                                  <span style={{
                                    fontSize: '10px',
                                    color: selectedJournalId === detail.journalId ? '#1976d2' : '#999',
                                    transition: 'transform 0.2s',
                                    display: 'inline-block',
                                    transform: selectedJournalId === detail.journalId ? 'rotate(90deg)' : 'rotate(0deg)',
                                  }}>
                                    ▶
                                  </span>
                                </td>
                                <td>{detail.accountName}</td>
                                <td>{detail.lineDescription || detail.description}</td>
                                <td className={styles.in}>
                                  {detail.debit > 0 ? formatNumber(detail.debit, 'VND') : ''}
                                </td>
                                <td className={styles.out}>
                                  {detail.credit > 0 ? formatNumber(detail.credit, 'VND') : ''}
                                </td>
                              </tr>
                              {/* Expanded Detail Row */}
                              {selectedJournalId === detail.journalId && (
                                <tr>
                                  <td colSpan={5} style={{ padding: 0, background: '#f8f9fa' }}>
                                    <div style={{ padding: '12px 16px', borderTop: '1px solid #e0e0e0' }}>
                                      {detailLoading ? (
                                        <div style={{ color: '#666', fontSize: '12px', padding: '8px 0' }}>Loading...</div>
                                      ) : journalEntryDetail ? (
                                        <div style={{ fontSize: '12px' }}>
                                          {/* Meta info */}
                                          <div style={{ display: 'flex', gap: '16px', flexWrap: 'wrap', marginBottom: '10px', color: '#666' }}>
                                            {journalEntryDetail.createdByName && (
                                              <span><strong>By:</strong> {journalEntryDetail.createdByName}</span>
                                            )}
                                            {journalEntryDetail.createdAt && (
                                              <span><strong>Date:</strong> {new Date(journalEntryDetail.createdAt).toLocaleString('en-US')}</span>
                                            )}
                                            {journalEntryDetail.journalType && (
                                              <span><strong>Type:</strong> {journalEntryDetail.journalType}</span>
                                            )}
                                          </div>

                                          {/* AI Description - amber/orange theme */}
                                          {journalEntryDetail.aiDescription && (
                                            <div style={{
                                              padding: '10px 12px',
                                              background: '#fff8e1',
                                              borderRadius: '4px',
                                              marginBottom: '10px',
                                              border: '1px solid #ffcc80',
                                            }}>
                                              <strong style={{ color: '#e65100' }}>AI:</strong>{' '}
                                              <span style={{ color: '#5d4037' }}>{journalEntryDetail.aiDescription}</span>
                                            </div>
                                          )}

                                          {/* All Lines (Counter Accounts) */}
                                          {journalEntryDetail.lines.length > 0 && (
                                            <div style={{ marginBottom: '10px' }}>
                                              <strong style={{ color: '#666', marginBottom: '6px', display: 'block' }}>Journal Lines:</strong>
                                              <table style={{ width: '100%', fontSize: '11px', borderCollapse: 'collapse' }}>
                                                <thead>
                                                  <tr style={{ background: '#eee' }}>
                                                    <th style={{ padding: '5px 8px', textAlign: 'left', border: '1px solid #ddd' }}>Account</th>
                                                    <th style={{ padding: '5px 8px', textAlign: 'left', border: '1px solid #ddd' }}>Description</th>
                                                    <th style={{ padding: '5px 8px', textAlign: 'right', border: '1px solid #ddd', width: '100px' }}>Debit</th>
                                                    <th style={{ padding: '5px 8px', textAlign: 'right', border: '1px solid #ddd', width: '100px' }}>Credit</th>
                                                  </tr>
                                                </thead>
                                                <tbody>
                                                  {journalEntryDetail.lines.map((line, lineIdx) => (
                                                    <tr key={lineIdx} style={{ background: '#fff' }}>
                                                      <td style={{ padding: '5px 8px', border: '1px solid #ddd' }}>{line.accountName}</td>
                                                      <td style={{ padding: '5px 8px', border: '1px solid #ddd' }}>{line.description || '-'}</td>
                                                      <td style={{ padding: '5px 8px', textAlign: 'right', border: '1px solid #ddd' }} className={styles.in}>
                                                        {line.debit > 0 ? formatNumber(line.debit, 'VND') : ''}
                                                      </td>
                                                      <td style={{ padding: '5px 8px', textAlign: 'right', border: '1px solid #ddd' }} className={styles.out}>
                                                        {line.credit > 0 ? formatNumber(line.credit, 'VND') : ''}
                                                      </td>
                                                    </tr>
                                                  ))}
                                                </tbody>
                                              </table>
                                            </div>
                                          )}

                                          {/* Attachments */}
                                          {journalEntryDetail.attachments.length > 0 && (
                                            <div>
                                              <strong style={{ color: '#666', marginBottom: '6px', display: 'block' }}>Attachments:</strong>
                                              <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
                                                {journalEntryDetail.attachments.map((att, attIdx) => {
                                                  // Check if image by file_type OR file extension
                                                  const isImage = att.fileType?.startsWith('image/') ||
                                                    /\.(jpg|jpeg|png|gif|webp|bmp)$/i.test(att.fileName || '');
                                                  return isImage ? (
                                                    <a
                                                      key={attIdx}
                                                      href={att.fileUrl}
                                                      target="_blank"
                                                      rel="noopener noreferrer"
                                                      style={{ display: 'block' }}
                                                    >
                                                      <img
                                                        src={att.thumbnailUrl}
                                                        alt={att.fileName}
                                                        loading="lazy"
                                                        style={{
                                                          width: '120px',
                                                          height: '80px',
                                                          borderRadius: '4px',
                                                          border: '1px solid #ddd',
                                                          objectFit: 'cover',
                                                          background: '#f5f5f5',
                                                        }}
                                                      />
                                                    </a>
                                                  ) : (
                                                    <a
                                                      key={attIdx}
                                                      href={att.fileUrl}
                                                      target="_blank"
                                                      rel="noopener noreferrer"
                                                      style={{
                                                        display: 'inline-flex',
                                                        alignItems: 'center',
                                                        gap: '4px',
                                                        padding: '4px 8px',
                                                        background: '#fff',
                                                        border: '1px solid #ddd',
                                                        borderRadius: '4px',
                                                        color: '#1976d2',
                                                        textDecoration: 'none',
                                                        fontSize: '11px',
                                                      }}
                                                    >
                                                      📎 {att.fileName}
                                                    </a>
                                                  );
                                                })}
                                              </div>
                                            </div>
                                          )}

                                          {/* No extra info */}
                                          {!journalEntryDetail.aiDescription && journalEntryDetail.lines.length === 0 && journalEntryDetail.attachments.length === 0 && (
                                            <div style={{ color: '#999' }}>No additional information.</div>
                                          )}
                                        </div>
                                      ) : (
                                        <div style={{ color: '#c00', fontSize: '12px' }}>Failed to load data.</div>
                                      )}
                                    </div>
                                  </td>
                                </tr>
                              )}
                            </React.Fragment>
                          ))}
                        </tbody>
                        <tfoot>
                          <tr>
                            <td colSpan={3}><strong>Total</strong></td>
                            <td className={styles.in}>
                              <strong>
                                {formatNumber(
                                  journalDetails.reduce((sum, d) => sum + d.debit, 0),
                                  'VND'
                                )}
                              </strong>
                            </td>
                            <td className={styles.out}>
                              <strong>
                                {formatNumber(
                                  journalDetails.reduce((sum, d) => sum + d.credit, 0),
                                  'VND'
                                )}
                              </strong>
                            </td>
                          </tr>
                          <tr className={styles.netRow}>
                            <td colSpan={3}><strong>Net Change</strong></td>
                            <td colSpan={2}>
                              <strong className={
                                journalDetails.reduce((sum, d) => sum + d.debit - d.credit, 0) >= 0
                                  ? styles.in
                                  : styles.out
                              }>
                                {formatNumber(
                                  journalDetails.reduce((sum, d) => sum + d.debit - d.credit, 0),
                                  'VND'
                                )}
                              </strong>
                            </td>
                          </tr>
                        </tfoot>
                      </table>
                    )}
                  </div>
                </>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default CashBalancePage;
