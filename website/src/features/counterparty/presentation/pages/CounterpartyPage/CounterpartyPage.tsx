/**
 * CounterpartyPage Component
 */

import React, { useState } from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import { useAppState } from '@/app/providers/app_state_provider';
import { useCounterparty } from '../../hooks/useCounterparty';
import { CounterpartyType } from '../../../domain/entities/Counterparty';
import styles from './CounterpartyPage.module.css';

export const CounterpartyPage: React.FC = () => {
  const { currentCompany } = useAppState();
  const { counterparties, loading, createCounterparty, deleteCounterparty } = useCounterparty(currentCompany?.company_id || '');
  const [showModal, setShowModal] = useState(false);
  const [newName, setNewName] = useState('');
  const [newType, setNewType] = useState<CounterpartyType>('external');
  const [newContact, setNewContact] = useState('');
  const [newEmail, setNewEmail] = useState('');
  const [newPhone, setNewPhone] = useState('');

  const handleAdd = async () => {
    if (!newName) return alert('Name is required');
    const result = await createCounterparty(newName, newType, newContact || null, newEmail || null, newPhone || null, null);
    if (result.success) {
      setShowModal(false);
      setNewName('');
      setNewContact('');
      setNewEmail('');
      setNewPhone('');
    }
  };

  const internal = counterparties.filter(c => c.type === 'internal');
  const external = counterparties.filter(c => c.type === 'external');

  if (loading) return <><Navbar activeItem="setting" /><div className={styles.container}><div className={styles.spinner} /></div></>;
  if (!currentCompany) return <><Navbar activeItem="setting" /><div className={styles.container}><p>Select company</p></div></>;

  return (
    <>
      <Navbar activeItem="setting" />
      <div className={styles.container}>
      <div className={styles.header}>
        <div><h1 className={styles.title}>Counterparty</h1><p className={styles.subtitle}>Manage customers and suppliers</p></div>
        <button onClick={() => setShowModal(true)} className={styles.addBtn}>Add Counterparty</button>
      </div>
      <div className={styles.section}>
        <h2>Internal ({internal.length})</h2>
        <div className={styles.grid}>
          {internal.map(c => (
            <div key={c.counterpartyId} className={styles.card}>
              <div className={styles.avatar}>{c.initials}</div>
              <div className={styles.info}>
                <div className={styles.name}>{c.name}</div>
                {c.email && <div className={styles.detail}>{c.email}</div>}
                {c.phone && <div className={styles.detail}>{c.phone}</div>}
              </div>
              <button onClick={() => confirm('Delete?') && deleteCounterparty(c.counterpartyId)} className={styles.deleteBtn}>×</button>
            </div>
          ))}
        </div>
      </div>
      <div className={styles.section}>
        <h2>External ({external.length})</h2>
        <div className={styles.grid}>
          {external.map(c => (
            <div key={c.counterpartyId} className={styles.card}>
              <div className={styles.avatar}>{c.initials}</div>
              <div className={styles.info}>
                <div className={styles.name}>{c.name}</div>
                {c.email && <div className={styles.detail}>{c.email}</div>}
                {c.phone && <div className={styles.detail}>{c.phone}</div>}
              </div>
              <button onClick={() => confirm('Delete?') && deleteCounterparty(c.counterpartyId)} className={styles.deleteBtn}>×</button>
            </div>
          ))}
        </div>
      </div>
      {showModal && (
        <div className={styles.modal} onClick={() => setShowModal(false)}>
          <div className={styles.modalContent} onClick={e => e.stopPropagation()}>
            <h2>Add Counterparty</h2>
            <input placeholder="Name *" value={newName} onChange={e => setNewName(e.target.value)} />
            <select value={newType} onChange={e => setNewType(e.target.value as CounterpartyType)}>
              <option value="internal">Internal</option>
              <option value="external">External</option>
            </select>
            <input placeholder="Contact" value={newContact} onChange={e => setNewContact(e.target.value)} />
            <input placeholder="Email" value={newEmail} onChange={e => setNewEmail(e.target.value)} />
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
