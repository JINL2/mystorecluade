import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useStore } from '../../hooks/useStore';
import styles from './StoreSettingPage.module.css';

export const StoreSettingPage: React.FC = () => {
  const { currentCompany } = useAppState();
  const { stores, loading, create, remove } = useStore(currentCompany?.company_id || '');
  const [showModal, setShowModal] = useState(false);
  const [newName, setNewName] = useState('');
  const [newAddress, setNewAddress] = useState('');
  const [newPhone, setNewPhone] = useState('');

  const handleAdd = async () => {
    if (!newName) return alert('Store name required');
    const result = await create(newName, newAddress || null, newPhone || null);
    if (result.success) {
      setShowModal(false);
      setNewName('');
      setNewAddress('');
      setNewPhone('');
    }
  };

  if (loading) return <><Navbar activeItem="setting" /><div className={styles.container}><div className={styles.spinner} /></div></>;
  if (!currentCompany) return <><Navbar activeItem="setting" /><div className={styles.container}><p>Select company</p></div></>;

  return (
    <>
      <Navbar activeItem="setting" />
      <div className={styles.container}>
      <div className={styles.header}>
        <div><h1 className={styles.title}>Store Settings</h1><p className={styles.subtitle}>Manage store locations</p></div>
        <button onClick={() => setShowModal(true)} className={styles.addBtn}>Add Store</button>
      </div>
      <div className={styles.grid}>
        {stores.map(s => (
          <div key={s.storeId} className={styles.card}>
            <div className={styles.storeIcon}>🏪</div>
            <div className={styles.info}>
              <div className={styles.name}>{s.storeName}</div>
              {s.address && <div className={styles.detail}>{s.address}</div>}
              {s.phone && <div className={styles.detail}>{s.phone}</div>}
            </div>
            <button onClick={() => confirm('Delete?') && remove(s.storeId)} className={styles.deleteBtn}>×</button>
          </div>
        ))}
      </div>
      {showModal && (
        <div className={styles.modal} onClick={() => setShowModal(false)}>
          <div className={styles.modalContent} onClick={e => e.stopPropagation()}>
            <h2>Add Store</h2>
            <input placeholder="Store Name *" value={newName} onChange={e => setNewName(e.target.value)} />
            <input placeholder="Address" value={newAddress} onChange={e => setNewAddress(e.target.value)} />
            <input placeholder="Phone" value={newPhone} onChange={e => setNewPhone(e.target.value)} />
            <div className={styles.actions}>
              <button onClick={() => setShowModal(false)}>Cancel</button>
              <button onClick={handleAdd}>Add</button>
            </div>
          </div>
        </div>
      )}
    </div>
    </>
  );
};
