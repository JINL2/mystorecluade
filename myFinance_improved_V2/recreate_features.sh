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

echo "=== 기존 Features 폴더 삭제 및 재생성 ===="
echo ""

# 기존 features 폴더 삭제
rm -rf lib_new/features

echo "✓ 기존 features 폴더 삭제 완료"
echo ""

for feature in "${features[@]}"; do
  echo "📁 Creating $feature..."
  
  # Domain layer (Riverpod 구조)
  mkdir -p "lib_new/features/$feature/domain/entities"
  mkdir -p "lib_new/features/$feature/domain/repositories"
  mkdir -p "lib_new/features/$feature/domain/usecases"
  mkdir -p "lib_new/features/$feature/domain/validators"
  mkdir -p "lib_new/features/$feature/domain/providers"
  mkdir -p "lib_new/features/$feature/domain/factories"
  mkdir -p "lib_new/features/$feature/domain/value_objects"
  mkdir -p "lib_new/features/$feature/domain/enums"
  mkdir -p "lib_new/features/$feature/domain/exceptions"
  mkdir -p "lib_new/features/$feature/domain/constants"
  
  # Data layer
  mkdir -p "lib_new/features/$feature/data/models"
  mkdir -p "lib_new/features/$feature/data/dtos"
  mkdir -p "lib_new/features/$feature/data/dtos/mappers"
  mkdir -p "lib_new/features/$feature/data/datasources"
  mkdir -p "lib_new/features/$feature/data/repositories"
  mkdir -p "lib_new/features/$feature/data/services"
  mkdir -p "lib_new/features/$feature/data/cache"
  
  # Presentation layer (Riverpod providers)
  mkdir -p "lib_new/features/$feature/presentation/pages"
  mkdir -p "lib_new/features/$feature/presentation/widgets"
  mkdir -p "lib_new/features/$feature/presentation/dialogs"
  mkdir -p "lib_new/features/$feature/presentation/modals"
  mkdir -p "lib_new/features/$feature/presentation/providers"
  mkdir -p "lib_new/features/$feature/presentation/providers/states"
done

echo ""
echo "✅ 모든 Features 폴더 구조 재생성 완료!"
echo ""
echo "생성된 Feature 수: ${#features[@]}"
