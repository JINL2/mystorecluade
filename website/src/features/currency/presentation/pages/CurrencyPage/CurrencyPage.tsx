import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useCurrency } from '../../hooks/useCurrency';
import styles from './CurrencyPage.module.css';

export const CurrencyPage: React.FC = () => {
  const { currentCompany } = useAppState();
  const { currencies, loading, setDefault } = useCurrency(currentCompany?.company_id || '');

  if (loading) return <><Navbar activeItem="setting" /><div className={styles.container}><div className={styles.spinner} /></div></>;
  if (!currentCompany) return <><Navbar activeItem="setting" /><div className={styles.container}><p>Select company</p></div></>;

  return (
    <>
      <Navbar activeItem="setting" />
      <div className={styles.container}>
      <div className={styles.header}>
        <h1 className={styles.title}>Currency Settings</h1>
        <p className={styles.subtitle}>Manage currency preferences</p>
      </div>
      <div className={styles.grid}>
        {currencies.map(c => (
          <div key={c.currencyId} className={`${styles.card} ${c.isDefault ? styles.default : ''}`}>
            <div className={styles.symbol}>{c.symbol}</div>
            <div className={styles.info}>
              <div className={styles.code}>{c.code}</div>
              <div className={styles.name}>{c.name}</div>
            </div>
            {!c.isDefault && <button onClick={() => setDefault(c.currencyId)} className={styles.setBtn}>Set Default</button>}
            {c.isDefault && <span className={styles.badge}>Default</span>}
          </div>
        ))}
      </div>
    </div>
    </>
  );
};
