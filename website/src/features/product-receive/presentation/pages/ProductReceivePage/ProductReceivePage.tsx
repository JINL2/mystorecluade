/**
 * ProductReceivePage
 * Main page for product receiving
 */

import React from 'react';
import { Navbar } from '@/shared/components/common/Navbar';
import styles from './ProductReceivePage.module.css';

export const ProductReceivePage: React.FC = () => {
  // TODO: Implement component
  return (
    <>
      <Navbar activeItem="product" />
      <div className={styles.pageLayout}>
        <div className={styles.container}>
          <h1>Product Receive Page</h1>
          <p>TODO: Implement Product Receive management</p>
        </div>
      </div>
    </>
  );
};
