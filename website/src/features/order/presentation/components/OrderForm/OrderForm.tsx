/**
 * OrderForm Component
 * New purchase order creation form
 */

import React from 'react';

interface OrderFormProps {
  onSuccess?: () => void;
  onCancel?: () => void;
}

export const OrderForm: React.FC<OrderFormProps> = () => {
  // TODO: Implement component
  return (
    <div>
      <p>Order Form - TODO</p>
    </div>
  );
};
