/**
 * ShipmentPage Component
 * Main page for shipment management
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import styles from './ShipmentPage.module.css';

export const ShipmentPage: React.FC = () => {
  // TODO: Implement component
  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          <h1>Shipment Page</h1>
          <p>TODO: Implement Shipment management</p>
        </div>
      </div>
    </>
  );
};
