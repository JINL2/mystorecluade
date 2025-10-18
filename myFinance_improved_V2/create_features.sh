#!/bin/bash

# Feature 목록
features=(
  "add_fix_asset"
  "admin"
  "attendance"
  "auth"
  "balance_sheet"
  "cash_ending"
  "cash_location"
  "component_test"
  "counter_party"
  "debt_account_settings"
  "debt_control"
  "debug"
  "delegate_role"
  "employee_setting"
  "homepage"
  "inventory_analysis"
  "inventory_management"
  "journal_input"
  "my_page"
  "notifications"
  "register_denomination"
  "role_permission"
  "sale_product"
  "sales_invoice"
  "store_shift"
  "time_table_manage"
  "timetable"
  "transaction_template"
  "transaction_template_refectore"
  "transactions"
)

echo "=== Features 폴더 구조 생성 시작 ==="
echo ""

for feature in "${features[@]}"; do
  echo "📁 Creating $feature..."
  
  # Domain layer
  mkdir -p "lib_new/features/$feature/domain/entities"
  mkdir -p "lib_new/features/$feature/domain/repositories"
  mkdir -p "lib_new/features/$feature/domain/services"
  mkdir -p "lib_new/features/$feature/domain/usecases"
  mkdir -p "lib_new/features/$feature/domain/validators"
  
  # Data layer
  mkdir -p "lib_new/features/$feature/data/models"
  mkdir -p "lib_new/features/$feature/data/datasources"
  mkdir -p "lib_new/features/$feature/data/repositories"
  
  # Application layer
  mkdir -p "lib_new/features/$feature/application/state"
  mkdir -p "lib_new/features/$feature/application/controllers"
  
  # Presentation layer
  mkdir -p "lib_new/features/$feature/presentation/pages"
  mkdir -p "lib_new/features/$feature/presentation/widgets"
  mkdir -p "lib_new/features/$feature/presentation/dialogs"
  mkdir -p "lib_new/features/$feature/presentation/modals"
done

echo ""
echo "✅ 모든 Features 폴더 구조 생성 완료!"
echo ""
echo "생성된 Feature 수: ${#features[@]}"
