/**
 * Application Routes
 * Centralized route definitions with authentication and authorization
 */

import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { ProtectedRoute } from './ProtectedRoute';
import { PublicRoute } from './PublicRoute';

// Feature Pages
import { LoginPage } from '@/features/auth/presentation/pages/LoginPage';
import { RegisterPage } from '@/features/auth/presentation/pages/RegisterPage';
import { DashboardPage } from '@/features/dashboard/presentation/pages/DashboardPage';
import { AccountMappingPage } from '@/features/account-mapping/presentation/pages/AccountMappingPage';
import { BalanceSheetPage } from '@/features/balance-sheet/presentation/pages/BalanceSheetPage';
import { CashEndingPage } from '@/features/cash-ending/presentation/pages/CashEndingPage';
import { CounterpartyPage } from '@/features/counterparty/presentation/pages/CounterpartyPage';
import { CurrencyPage } from '@/features/currency/presentation/pages/CurrencyPage';
import { SalaryPage } from '@/features/employee-salary/presentation/pages/SalaryPage';
import { SchedulePage } from '@/features/employee-schedule/presentation/pages/SchedulePage';
import { EmployeeSettingPage } from '@/features/employee-setting/presentation/pages/EmployeeSettingPage';
import { IncomeStatementPage } from '@/features/income-statement/presentation/pages/IncomeStatementPage';
import { InventoryPage } from '@/features/inventory/presentation/pages/InventoryPage';
import { InvoicePage } from '@/features/invoice/presentation/pages/InvoicePage';
import { SaleProductPage } from '@/features/sale-product/presentation/pages/SaleProductPage';
import { JournalInputPage } from '@/features/journal-input/presentation/pages/JournalInputPage';
import { MarketingPlanPage } from '@/features/marketing-plan/presentation/pages/MarketingPlanPage';
import { OrderPage } from '@/features/order/presentation/pages/OrderPage';
import { ProductReceivePage } from '@/features/product-receive/presentation/pages/ProductReceivePage';
import { StoreSettingPage } from '@/features/store-setting/presentation/pages/StoreSettingPage';
import { TrackingPage } from '@/features/tracking/presentation/pages/TrackingPage';
import { TransactionHistoryPage } from '@/features/transaction-history/presentation/pages/TransactionHistoryPage';

export const AppRoutes: React.FC = () => {
  return (
    <Routes>
      {/* Public Routes */}
      <Route
        path="/login"
        element={
          <PublicRoute>
            <LoginPage />
          </PublicRoute>
        }
      />
      <Route
        path="/register"
        element={
          <PublicRoute>
            <RegisterPage />
          </PublicRoute>
        }
      />

      {/* Protected Routes - Dashboard (no specific permission check) */}
      <Route
        path="/dashboard"
        element={
          <ProtectedRoute>
            <DashboardPage />
          </ProtectedRoute>
        }
      />

      {/* Protected Routes - Product Management */}
      <Route
        path="/product/inventory"
        element={
          <ProtectedRoute requiredFeatureId="ced86713-e046-457a-b3c9-775304b31557">
            <InventoryPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/product/invoice"
        element={
          <ProtectedRoute requiredFeatureId="b5affc71-32e5-481b-932a-77a743253ddc">
            <InvoicePage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/product/create-invoice"
        element={
          <ProtectedRoute requiredFeatureId="5f622ea0-ede7-4b24-a203-92d5c9f31a6b">
            <SaleProductPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/product/order"
        element={
          <ProtectedRoute requiredFeatureId="5f622ea0-ede7-4b24-a203-92d5c9f31a6b">
            <OrderPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/product/product-receive"
        element={
          <ProtectedRoute requiredFeatureId="ced86713-e046-457a-b3c9-775304b31557">
            <ProductReceivePage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/product/tracking"
        element={
          <ProtectedRoute requiredFeatureId="98cc610a-9dff-4276-91f2-d900cdf00ba7">
            <TrackingPage />
          </ProtectedRoute>
        }
      />

      {/* Protected Routes - Finance */}
      <Route
        path="/finance/journal-input"
        element={
          <ProtectedRoute requiredFeatureId="58fddce6-6b45-4735-8c59-9d80ccc1928e">
            <JournalInputPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/finance/balance-sheet"
        element={
          <ProtectedRoute requiredFeatureId="bdd46e64-5a59-4001-b70f-b9f4b23da33d">
            <BalanceSheetPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/finance/income-statement"
        element={
          <ProtectedRoute requiredFeatureId="247a7896-ea5c-49b7-afec-94b500093cd4">
            <IncomeStatementPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/finance/cash-ending"
        element={
          <ProtectedRoute requiredFeatureId="582171a8-6a92-42e7-99ed-f8233169a652">
            <CashEndingPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/finance/transaction-history"
        element={
          <ProtectedRoute requiredFeatureId="7e1fd11a-f632-427d-aefc-8b3dd6734faa">
            <TransactionHistoryPage />
          </ProtectedRoute>
        }
      />
      {/* Alias route for backward compatibility */}
      <Route
        path="/transactions"
        element={
          <ProtectedRoute requiredFeatureId="7e1fd11a-f632-427d-aefc-8b3dd6734faa">
            <TransactionHistoryPage />
          </ProtectedRoute>
        }
      />

      {/* Protected Routes - Employee */}
      <Route
        path="/employee/employee-setting"
        element={
          <ProtectedRoute requiredFeatureId="4a0c90b6-7099-4d76-88b2-783302e1248f">
            <EmployeeSettingPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/employee/schedule"
        element={
          <ProtectedRoute requiredFeatureId="eaf85f06-b708-4c29-b35f-d39d234d1b60">
            <SchedulePage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/employee/salary"
        element={
          <ProtectedRoute requiredFeatureId="4a0c90b6-7099-4d76-88b2-783302e1248f">
            <SalaryPage />
          </ProtectedRoute>
        }
      />

      {/* Protected Routes - Marketing */}
      <Route
        path="/marketing/marketing-plan"
        element={
          <ProtectedRoute requiredFeatureId="069fc24c-915b-43a0-8c27-6872badfc4a1">
            <MarketingPlanPage />
          </ProtectedRoute>
        }
      />

      {/* Protected Routes - Settings */}
      <Route
        path="/settings/account-mapping"
        element={
          <ProtectedRoute requiredFeatureId="6e527ba2-9421-4243-a0f9-2497f5ed9772">
            <AccountMappingPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/settings/counterparty"
        element={
          <ProtectedRoute requiredFeatureId="57b2972a-d2d4-478e-ab10-83e1f429b94b">
            <CounterpartyPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/settings/currency"
        element={
          <ProtectedRoute requiredFeatureId="95310d59-24ae-4d8b-9474-c536ed8b0584">
            <CurrencyPage />
          </ProtectedRoute>
        }
      />
      <Route
        path="/settings/store-setting"
        element={
          <ProtectedRoute requiredFeatureId="7b767def-41bb-420c-a548-807e4336e738">
            <StoreSettingPage />
          </ProtectedRoute>
        }
      />

      {/* Default redirect */}
      <Route path="/" element={<Navigate to="/login" replace />} />
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
};

export default AppRoutes;
