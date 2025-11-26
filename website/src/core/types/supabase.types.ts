export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "12.2.3 (519615d)"
  }
  public: {
    Tables: {
      account_mappings: {
        Row: {
          counterparty_id: string
          created_at: string | null
          created_by: string | null
          direction: string
          is_deleted: boolean | null
          linked_account_id: string
          mapping_id: string
          my_account_id: string
          my_company_id: string
        }
        Insert: {
          counterparty_id: string
          created_at?: string | null
          created_by?: string | null
          direction: string
          is_deleted?: boolean | null
          linked_account_id: string
          mapping_id?: string
          my_account_id: string
          my_company_id: string
        }
        Update: {
          counterparty_id?: string
          created_at?: string | null
          created_by?: string | null
          direction?: string
          is_deleted?: boolean | null
          linked_account_id?: string
          mapping_id?: string
          my_account_id?: string
          my_company_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "account_mappings_counterparty_id_fkey"
            columns: ["counterparty_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
          {
            foreignKeyName: "account_mappings_linked_account_id_fkey"
            columns: ["linked_account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "account_mappings_linked_account_id_fkey"
            columns: ["linked_account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "account_mappings_my_account_id_fkey"
            columns: ["my_account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "account_mappings_my_account_id_fkey"
            columns: ["my_account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "account_mappings_my_company_id_fkey"
            columns: ["my_company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      accounts: {
        Row: {
          account_code: string | null
          account_id: string
          account_name: string
          account_type: string
          category_tag: string | null
          company_id: string | null
          created_at: string | null
          debt_tag: string | null
          description: string | null
          expense_nature: string | null
          is_default: boolean | null
          statement_category: string | null
          statement_detail_category: string | null
          updated_at: string | null
        }
        Insert: {
          account_code?: string | null
          account_id?: string
          account_name: string
          account_type: string
          category_tag?: string | null
          company_id?: string | null
          created_at?: string | null
          debt_tag?: string | null
          description?: string | null
          expense_nature?: string | null
          is_default?: boolean | null
          statement_category?: string | null
          statement_detail_category?: string | null
          updated_at?: string | null
        }
        Update: {
          account_code?: string | null
          account_id?: string
          account_name?: string
          account_type?: string
          category_tag?: string | null
          company_id?: string | null
          created_at?: string | null
          debt_tag?: string | null
          description?: string | null
          expense_nature?: string | null
          is_default?: boolean | null
          statement_category?: string | null
          statement_detail_category?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "accounts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      accounts_preferences: {
        Row: {
          account_id: string
          account_name: string
          account_type: string | null
          company_id: string
          created_at: string | null
          id: string
          metadata: Json | null
          usage_type: string
          used_at: string | null
          user_id: string
        }
        Insert: {
          account_id: string
          account_name: string
          account_type?: string | null
          company_id: string
          created_at?: string | null
          id?: string
          metadata?: Json | null
          usage_type?: string
          used_at?: string | null
          user_id: string
        }
        Update: {
          account_id?: string
          account_name?: string
          account_type?: string | null
          company_id?: string
          created_at?: string | null
          id?: string
          metadata?: Json | null
          usage_type?: string
          used_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "accounts_preferences_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      ai_chat_history: {
        Row: {
          created_at: string | null
          extracted_data: Json | null
          id: number
          intent_confidence: number | null
          matched_intent: string | null
          message: Json
          session_id: string
        }
        Insert: {
          created_at?: string | null
          extracted_data?: Json | null
          id?: number
          intent_confidence?: number | null
          matched_intent?: string | null
          message: Json
          session_id: string
        }
        Update: {
          created_at?: string | null
          extracted_data?: Json | null
          id?: number
          intent_confidence?: number | null
          matched_intent?: string | null
          message?: Json
          session_id?: string
        }
        Relationships: []
      }
      ai_conversation_state: {
        Row: {
          collected_data: Json | null
          current_intent: string | null
          expires_at: string | null
          intent_confidence: number | null
          last_updated: string | null
          missing_fields: string[] | null
          session_id: string
          status: string | null
        }
        Insert: {
          collected_data?: Json | null
          current_intent?: string | null
          expires_at?: string | null
          intent_confidence?: number | null
          last_updated?: string | null
          missing_fields?: string[] | null
          session_id: string
          status?: string | null
        }
        Update: {
          collected_data?: Json | null
          current_intent?: string | null
          expires_at?: string | null
          intent_confidence?: number | null
          last_updated?: string | null
          missing_fields?: string[] | null
          session_id?: string
          status?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_conversation_intent"
            columns: ["current_intent"]
            isOneToOne: false
            referencedRelation: "ai_intent_vectors"
            referencedColumns: ["intent"]
          },
        ]
      }
      ai_intent_vectors: {
        Row: {
          created_at: string | null
          description: string | null
          embedding: string
          embedding_text: string
          id: number
          intent: string
          intent_name: string
          is_active: boolean | null
          template_id: string
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          embedding: string
          embedding_text: string
          id?: number
          intent: string
          intent_name: string
          is_active?: boolean | null
          template_id: string
        }
        Update: {
          created_at?: string | null
          description?: string | null
          embedding?: string
          embedding_text?: string
          id?: number
          intent?: string
          intent_name?: string
          is_active?: boolean | null
          template_id?: string
        }
        Relationships: []
      }
      ai_intents: {
        Row: {
          config: Json | null
          content: string | null
          created_at: string | null
          description: string | null
          embedding: string | null
          id: number
          intent: string | null
          intent_name: string | null
          is_active: boolean | null
          metadata: Json | null
          updated_at: string | null
        }
        Insert: {
          config?: Json | null
          content?: string | null
          created_at?: string | null
          description?: string | null
          embedding?: string | null
          id?: number
          intent?: string | null
          intent_name?: string | null
          is_active?: boolean | null
          metadata?: Json | null
          updated_at?: string | null
        }
        Update: {
          config?: Json | null
          content?: string | null
          created_at?: string | null
          description?: string | null
          embedding?: string | null
          id?: number
          intent?: string | null
          intent_name?: string | null
          is_active?: boolean | null
          metadata?: Json | null
          updated_at?: string | null
        }
        Relationships: []
      }
      ai_schema_rules: {
        Row: {
          created_at: string | null
          default_values: Json | null
          intent: string
          optional_fields: Json | null
          questions: Json
          required_fields: Json
          updated_at: string | null
          validation_rules: Json | null
        }
        Insert: {
          created_at?: string | null
          default_values?: Json | null
          intent: string
          optional_fields?: Json | null
          questions?: Json
          required_fields?: Json
          updated_at?: string | null
          validation_rules?: Json | null
        }
        Update: {
          created_at?: string | null
          default_values?: Json | null
          intent?: string
          optional_fields?: Json | null
          questions?: Json
          required_fields?: Json
          updated_at?: string | null
          validation_rules?: Json | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_intent"
            columns: ["intent"]
            isOneToOne: true
            referencedRelation: "ai_intent_vectors"
            referencedColumns: ["intent"]
          },
        ]
      }
      ai_templates: {
        Row: {
          created_at: string | null
          description: string | null
          intent: string
          template_id: string
          template_json: Json
          updated_at: string | null
          version: string | null
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          intent: string
          template_id: string
          template_json: Json
          updated_at?: string | null
          version?: string | null
        }
        Update: {
          created_at?: string | null
          description?: string | null
          intent?: string
          template_id?: string
          template_json?: Json
          updated_at?: string | null
          version?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_template_intent"
            columns: ["intent"]
            isOneToOne: false
            referencedRelation: "ai_intent_vectors"
            referencedColumns: ["intent"]
          },
        ]
      }
      asset_impairments: {
        Row: {
          asset_id: string
          created_at: string | null
          impaired_value: number
          impairment_date: string
          impairment_id: string
          journal_id: string | null
          reason: string | null
        }
        Insert: {
          asset_id: string
          created_at?: string | null
          impaired_value: number
          impairment_date: string
          impairment_id?: string
          journal_id?: string | null
          reason?: string | null
        }
        Update: {
          asset_id?: string
          created_at?: string | null
          impaired_value?: number
          impairment_date?: string
          impairment_id?: string
          journal_id?: string | null
          reason?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "asset_impairments_asset_id_fkey"
            columns: ["asset_id"]
            isOneToOne: false
            referencedRelation: "fixed_assets"
            referencedColumns: ["asset_id"]
          },
          {
            foreignKeyName: "asset_impairments_asset_id_fkey"
            columns: ["asset_id"]
            isOneToOne: false
            referencedRelation: "v_depreciation_summary"
            referencedColumns: ["asset_id"]
          },
          {
            foreignKeyName: "asset_impairments_journal_id_fkey"
            columns: ["journal_id"]
            isOneToOne: false
            referencedRelation: "journal_entries"
            referencedColumns: ["journal_id"]
          },
        ]
      }
      bank_amount: {
        Row: {
          bank_amount_id: string
          company_id: string
          created_at: string | null
          created_by: string
          currency_id: string
          location_id: string
          record_date: string
          store_id: string | null
          total_amount: number
        }
        Insert: {
          bank_amount_id?: string
          company_id: string
          created_at?: string | null
          created_by: string
          currency_id: string
          location_id: string
          record_date: string
          store_id?: string | null
          total_amount?: number
        }
        Update: {
          bank_amount_id?: string
          company_id?: string
          created_at?: string | null
          created_by?: string
          currency_id?: string
          location_id?: string
          record_date?: string
          store_id?: string | null
          total_amount?: number
        }
        Relationships: [
          {
            foreignKeyName: "fk_company"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "fk_currency"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "fk_location"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_location"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_location"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      book_exchange_rates: {
        Row: {
          company_id: string
          created_at: string | null
          created_by: string
          from_currency_id: string
          rate: number
          rate_date: string
          rate_id: string
          to_currency_id: string
        }
        Insert: {
          company_id: string
          created_at?: string | null
          created_by: string
          from_currency_id: string
          rate: number
          rate_date: string
          rate_id?: string
          to_currency_id: string
        }
        Update: {
          company_id?: string
          created_at?: string | null
          created_by?: string
          from_currency_id?: string
          rate?: number
          rate_date?: string
          rate_id?: string
          to_currency_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "book_exchange_rates_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "book_exchange_rates_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "book_exchange_rates_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "book_exchange_rates_from_currency_id_fkey"
            columns: ["from_currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "book_exchange_rates_to_currency_id_fkey"
            columns: ["to_currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
        ]
      }
      cash_amount_stock_flow: {
        Row: {
          applied_exchange_rate: number | null
          balance_after: number
          balance_before: number
          base_currency_id: string | null
          cash_location_id: string
          company_id: string
          created_at: string
          created_by: string
          currency_id: string
          denomination_details: Json | null
          flow_amount: number
          flow_id: string
          location_type: string
          original_currency_amount: number | null
          store_id: string | null
          system_time: string
        }
        Insert: {
          applied_exchange_rate?: number | null
          balance_after: number
          balance_before?: number
          base_currency_id?: string | null
          cash_location_id: string
          company_id: string
          created_at: string
          created_by: string
          currency_id: string
          denomination_details?: Json | null
          flow_amount: number
          flow_id?: string
          location_type: string
          original_currency_amount?: number | null
          store_id?: string | null
          system_time?: string
        }
        Update: {
          applied_exchange_rate?: number | null
          balance_after?: number
          balance_before?: number
          base_currency_id?: string | null
          cash_location_id?: string
          company_id?: string
          created_at?: string
          created_by?: string
          currency_id?: string
          denomination_details?: Json | null
          flow_amount?: number
          flow_id?: string
          location_type?: string
          original_currency_amount?: number | null
          store_id?: string | null
          system_time?: string
        }
        Relationships: [
          {
            foreignKeyName: "cash_amount_stock_flow_base_currency_id_fkey"
            columns: ["base_currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_cash_location_id_fkey"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_cash_location_id_fkey"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_cash_location_id_fkey"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_currency_id_fkey"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_amount_stock_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      cash_amount_stock_flow_backup_20250828: {
        Row: {
          applied_exchange_rate: number | null
          balance_after: number | null
          balance_before: number | null
          base_currency_id: string | null
          cash_location_id: string | null
          company_id: string | null
          created_at: string | null
          created_by: string | null
          currency_id: string | null
          denomination_details: Json | null
          flow_amount: number | null
          flow_id: string | null
          location_type: string | null
          original_currency_amount: number | null
          store_id: string | null
          system_time: string | null
        }
        Insert: {
          applied_exchange_rate?: number | null
          balance_after?: number | null
          balance_before?: number | null
          base_currency_id?: string | null
          cash_location_id?: string | null
          company_id?: string | null
          created_at?: string | null
          created_by?: string | null
          currency_id?: string | null
          denomination_details?: Json | null
          flow_amount?: number | null
          flow_id?: string | null
          location_type?: string | null
          original_currency_amount?: number | null
          store_id?: string | null
          system_time?: string | null
        }
        Update: {
          applied_exchange_rate?: number | null
          balance_after?: number | null
          balance_before?: number | null
          base_currency_id?: string | null
          cash_location_id?: string | null
          company_id?: string | null
          created_at?: string | null
          created_by?: string | null
          currency_id?: string | null
          denomination_details?: Json | null
          flow_amount?: number | null
          flow_id?: string | null
          location_type?: string | null
          original_currency_amount?: number | null
          store_id?: string | null
          system_time?: string | null
        }
        Relationships: []
      }
      cash_amount_stock_flow_backup_20251110: {
        Row: {
          applied_exchange_rate: number | null
          balance_after: number | null
          balance_before: number | null
          base_currency_id: string | null
          cash_location_id: string | null
          company_id: string | null
          created_at: string | null
          created_by: string | null
          currency_id: string | null
          denomination_details: Json | null
          flow_amount: number | null
          flow_id: string | null
          location_type: string | null
          original_currency_amount: number | null
          store_id: string | null
          system_time: string | null
        }
        Insert: {
          applied_exchange_rate?: number | null
          balance_after?: number | null
          balance_before?: number | null
          base_currency_id?: string | null
          cash_location_id?: string | null
          company_id?: string | null
          created_at?: string | null
          created_by?: string | null
          currency_id?: string | null
          denomination_details?: Json | null
          flow_amount?: number | null
          flow_id?: string | null
          location_type?: string | null
          original_currency_amount?: number | null
          store_id?: string | null
          system_time?: string | null
        }
        Update: {
          applied_exchange_rate?: number | null
          balance_after?: number | null
          balance_before?: number | null
          base_currency_id?: string | null
          cash_location_id?: string | null
          company_id?: string | null
          created_at?: string | null
          created_by?: string | null
          currency_id?: string | null
          denomination_details?: Json | null
          flow_amount?: number | null
          flow_id?: string | null
          location_type?: string | null
          original_currency_amount?: number | null
          store_id?: string | null
          system_time?: string | null
        }
        Relationships: []
      }
      cash_control: {
        Row: {
          actual_amount: number
          company_id: string
          control_id: string
          created_at: string | null
          created_by: string
          location_id: string
          record_date: string
          store_id: string | null
        }
        Insert: {
          actual_amount?: number
          company_id: string
          control_id?: string
          created_at?: string | null
          created_by: string
          location_id: string
          record_date: string
          store_id?: string | null
        }
        Update: {
          actual_amount?: number
          company_id?: string
          control_id?: string
          created_at?: string | null
          created_by?: string
          location_id?: string
          record_date?: string
          store_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "cash_control_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "cash_control_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "cash_control_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "cash_control_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cash_control_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cash_control_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cash_control_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_control_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_control_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_control_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      cash_locations: {
        Row: {
          bank_account: string | null
          bank_name: string | null
          cash_location_id: string
          company_id: string
          created_at: string | null
          currency_code: string | null
          currency_id: string | null
          deleted_at: string | null
          icon: string | null
          is_deleted: boolean | null
          location_info: string | null
          location_name: string
          location_type: string
          main_cash_location: boolean | null
          note: string | null
          store_id: string | null
        }
        Insert: {
          bank_account?: string | null
          bank_name?: string | null
          cash_location_id?: string
          company_id: string
          created_at?: string | null
          currency_code?: string | null
          currency_id?: string | null
          deleted_at?: string | null
          icon?: string | null
          is_deleted?: boolean | null
          location_info?: string | null
          location_name: string
          location_type: string
          main_cash_location?: boolean | null
          note?: string | null
          store_id?: string | null
        }
        Update: {
          bank_account?: string | null
          bank_name?: string | null
          cash_location_id?: string
          company_id?: string
          created_at?: string | null
          currency_code?: string | null
          currency_id?: string | null
          deleted_at?: string | null
          icon?: string | null
          is_deleted?: boolean | null
          location_info?: string | null
          location_name?: string
          location_type?: string
          main_cash_location?: boolean | null
          note?: string | null
          store_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "cash_locations_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "cash_locations_currency_id_fkey"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      cashier_amount_lines: {
        Row: {
          company_id: string
          created_at: string | null
          created_by: string
          currency_id: string
          denomination_id: string
          line_id: string
          location_id: string
          quantity: number
          record_date: string
          store_id: string | null
        }
        Insert: {
          company_id: string
          created_at?: string | null
          created_by: string
          currency_id: string
          denomination_id: string
          line_id?: string
          location_id: string
          quantity: number
          record_date: string
          store_id?: string | null
        }
        Update: {
          company_id?: string
          created_at?: string | null
          created_by?: string
          currency_id?: string
          denomination_id?: string
          line_id?: string
          location_id?: string
          quantity?: number
          record_date?: string
          store_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "cashier_amount_lines_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_currency_id_fkey"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_denomination_id"
            columns: ["denomination_id"]
            isOneToOne: false
            referencedRelation: "currency_denominations"
            referencedColumns: ["denomination_id"]
          },
        ]
      }
      categories: {
        Row: {
          category_id: string
          created_at: string | null
          icon: string | null
          name: string
        }
        Insert: {
          category_id?: string
          created_at?: string | null
          icon?: string | null
          name: string
        }
        Update: {
          category_id?: string
          created_at?: string | null
          icon?: string | null
          name?: string
        }
        Relationships: []
      }
      companies: {
        Row: {
          base_currency_id: string | null
          company_code: string | null
          company_id: string
          company_name: string | null
          company_type_id: string | null
          created_at: string | null
          deleted_at: string | null
          inherited_plan_id: string | null
          is_deleted: boolean | null
          other_type_detail: string | null
          owner_id: string | null
          plan_updated_at: string | null
          timezone: string | null
          updated_at: string | null
        }
        Insert: {
          base_currency_id?: string | null
          company_code?: string | null
          company_id?: string
          company_name?: string | null
          company_type_id?: string | null
          created_at?: string | null
          deleted_at?: string | null
          inherited_plan_id?: string | null
          is_deleted?: boolean | null
          other_type_detail?: string | null
          owner_id?: string | null
          plan_updated_at?: string | null
          timezone?: string | null
          updated_at?: string | null
        }
        Update: {
          base_currency_id?: string | null
          company_code?: string | null
          company_id?: string
          company_name?: string | null
          company_type_id?: string | null
          created_at?: string | null
          deleted_at?: string | null
          inherited_plan_id?: string | null
          is_deleted?: boolean | null
          other_type_detail?: string | null
          owner_id?: string | null
          plan_updated_at?: string | null
          timezone?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "companies_base_currency_id_fkey"
            columns: ["base_currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "companies_company_type_id_fkey"
            columns: ["company_type_id"]
            isOneToOne: false
            referencedRelation: "company_types"
            referencedColumns: ["company_type_id"]
          },
          {
            foreignKeyName: "companies_inherited_plan_id_fkey"
            columns: ["inherited_plan_id"]
            isOneToOne: false
            referencedRelation: "subscription_plans"
            referencedColumns: ["plan_id"]
          },
          {
            foreignKeyName: "companies_owner_id_fkey"
            columns: ["owner_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "companies_owner_id_fkey"
            columns: ["owner_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      company_currency: {
        Row: {
          company_currency_id: string
          company_id: string
          created_at: string | null
          currency_id: string
          is_deleted: boolean | null
        }
        Insert: {
          company_currency_id?: string
          company_id: string
          created_at?: string | null
          currency_id: string
          is_deleted?: boolean | null
        }
        Update: {
          company_currency_id?: string
          company_id?: string
          created_at?: string | null
          currency_id?: string
          is_deleted?: boolean | null
        }
        Relationships: [
          {
            foreignKeyName: "company_currency_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "company_currency_currency_id_fkey"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
        ]
      }
      company_types: {
        Row: {
          company_type_id: string
          created_at: string | null
          detail: string | null
          type_name: string | null
          updated_at: string | null
        }
        Insert: {
          company_type_id?: string
          created_at?: string | null
          detail?: string | null
          type_name?: string | null
          updated_at?: string | null
        }
        Update: {
          company_type_id?: string
          created_at?: string | null
          detail?: string | null
          type_name?: string | null
          updated_at?: string | null
        }
        Relationships: []
      }
      counterparties: {
        Row: {
          address: string | null
          company_id: string
          counterparty_id: string
          created_at: string | null
          created_by: string | null
          email: string | null
          is_deleted: boolean
          is_internal: boolean
          linked_company_id: string | null
          name: string
          notes: string | null
          phone: string | null
          type: string | null
        }
        Insert: {
          address?: string | null
          company_id: string
          counterparty_id?: string
          created_at?: string | null
          created_by?: string | null
          email?: string | null
          is_deleted?: boolean
          is_internal?: boolean
          linked_company_id?: string | null
          name: string
          notes?: string | null
          phone?: string | null
          type?: string | null
        }
        Update: {
          address?: string | null
          company_id?: string
          counterparty_id?: string
          created_at?: string | null
          created_by?: string | null
          email?: string | null
          is_deleted?: boolean
          is_internal?: boolean
          linked_company_id?: string | null
          name?: string
          notes?: string | null
          phone?: string | null
          type?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "counterparties_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "fk_counterparty_created_by"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "fk_counterparty_created_by"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "fk_linked_company"
            columns: ["linked_company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      currency_denominations: {
        Row: {
          company_id: string | null
          created_at: string | null
          currency_id: string
          denomination_id: string
          is_deleted: boolean | null
          type: string | null
          value: number
        }
        Insert: {
          company_id?: string | null
          created_at?: string | null
          currency_id: string
          denomination_id?: string
          is_deleted?: boolean | null
          type?: string | null
          value: number
        }
        Update: {
          company_id?: string | null
          created_at?: string | null
          currency_id?: string
          denomination_id?: string
          is_deleted?: boolean | null
          type?: string | null
          value?: number
        }
        Relationships: [
          {
            foreignKeyName: "currency_denominations_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "currency_denominations_currency_id_fkey"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
        ]
      }
      currency_types: {
        Row: {
          created_at: string | null
          currency_code: string
          currency_id: string
          currency_name: string | null
          flag_emoji: string | null
          symbol: string | null
        }
        Insert: {
          created_at?: string | null
          currency_code: string
          currency_id?: string
          currency_name?: string | null
          flag_emoji?: string | null
          symbol?: string | null
        }
        Update: {
          created_at?: string | null
          currency_code?: string
          currency_id?: string
          currency_name?: string | null
          flag_emoji?: string | null
          symbol?: string | null
        }
        Relationships: []
      }
      debt_payments: {
        Row: {
          amount: number
          created_at: string | null
          debt_id: string
          description: string | null
          journal_id: string | null
          payment_date: string
          payment_id: string
        }
        Insert: {
          amount: number
          created_at?: string | null
          debt_id: string
          description?: string | null
          journal_id?: string | null
          payment_date: string
          payment_id?: string
        }
        Update: {
          amount?: number
          created_at?: string | null
          debt_id?: string
          description?: string | null
          journal_id?: string | null
          payment_date?: string
          payment_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "debt_payments_debt_id_fkey"
            columns: ["debt_id"]
            isOneToOne: false
            referencedRelation: "debts_receivable"
            referencedColumns: ["debt_id"]
          },
          {
            foreignKeyName: "debt_payments_journal_id_fkey"
            columns: ["journal_id"]
            isOneToOne: false
            referencedRelation: "journal_entries"
            referencedColumns: ["journal_id"]
          },
        ]
      }
      debts_receivable: {
        Row: {
          account_id: string
          category: string | null
          company_id: string
          counterparty_id: string
          created_at: string | null
          debt_id: string
          description: string | null
          direction: string
          due_date: string | null
          interest_account_id: string | null
          interest_due_day: number | null
          interest_rate: number | null
          is_active: boolean | null
          issue_date: string
          linked_company_id: string | null
          linked_company_store_id: string | null
          original_amount: number
          related_journal_id: string | null
          remaining_amount: number
          status: string | null
          store_id: string | null
        }
        Insert: {
          account_id: string
          category?: string | null
          company_id: string
          counterparty_id: string
          created_at?: string | null
          debt_id?: string
          description?: string | null
          direction: string
          due_date?: string | null
          interest_account_id?: string | null
          interest_due_day?: number | null
          interest_rate?: number | null
          is_active?: boolean | null
          issue_date: string
          linked_company_id?: string | null
          linked_company_store_id?: string | null
          original_amount: number
          related_journal_id?: string | null
          remaining_amount: number
          status?: string | null
          store_id?: string | null
        }
        Update: {
          account_id?: string
          category?: string | null
          company_id?: string
          counterparty_id?: string
          created_at?: string | null
          debt_id?: string
          description?: string | null
          direction?: string
          due_date?: string | null
          interest_account_id?: string | null
          interest_due_day?: number | null
          interest_rate?: number | null
          is_active?: boolean | null
          issue_date?: string
          linked_company_id?: string | null
          linked_company_store_id?: string | null
          original_amount?: number
          related_journal_id?: string | null
          remaining_amount?: number
          status?: string | null
          store_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "debts_receivable_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "debts_receivable_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "debts_receivable_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "debts_receivable_counterparty_id_fkey"
            columns: ["counterparty_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
          {
            foreignKeyName: "debts_receivable_interest_account_id_fkey"
            columns: ["interest_account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "debts_receivable_interest_account_id_fkey"
            columns: ["interest_account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "debts_receivable_related_journal_id_fkey"
            columns: ["related_journal_id"]
            isOneToOne: false
            referencedRelation: "journal_entries"
            referencedColumns: ["journal_id"]
          },
          {
            foreignKeyName: "debts_receivable_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "debts_receivable_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "debts_receivable_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "debts_receivable_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_linked_company"
            columns: ["linked_company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "fk_linked_company_store"
            columns: ["linked_company_store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_linked_company_store"
            columns: ["linked_company_store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_linked_company_store"
            columns: ["linked_company_store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_linked_company_store"
            columns: ["linked_company_store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      debug_join_user_logs: {
        Row: {
          code: string | null
          created_at: string | null
          id: string
          message: string | null
          step: string | null
          user_id: string | null
        }
        Insert: {
          code?: string | null
          created_at?: string | null
          id?: string
          message?: string | null
          step?: string | null
          user_id?: string | null
        }
        Update: {
          code?: string | null
          created_at?: string | null
          id?: string
          message?: string | null
          step?: string | null
          user_id?: string | null
        }
        Relationships: []
      }
      depreciation_methods: {
        Row: {
          created_at: string | null
          description: string | null
          formula: string | null
          is_active: boolean | null
          method_id: string
          method_name: string
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          formula?: string | null
          is_active?: boolean | null
          method_id?: string
          method_name: string
        }
        Update: {
          created_at?: string | null
          description?: string | null
          formula?: string | null
          is_active?: boolean | null
          method_id?: string
          method_name?: string
        }
        Relationships: []
      }
      depreciation_process_log: {
        Row: {
          asset_count: number | null
          company_id: string
          created_at: string | null
          error_message: string | null
          log_id: string
          process_date: string
          status: string
          total_amount: number | null
        }
        Insert: {
          asset_count?: number | null
          company_id: string
          created_at?: string | null
          error_message?: string | null
          log_id?: string
          process_date: string
          status: string
          total_amount?: number | null
        }
        Update: {
          asset_count?: number | null
          company_id?: string
          created_at?: string | null
          error_message?: string | null
          log_id?: string
          process_date?: string
          status?: string
          total_amount?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "depreciation_process_log_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      fcm_cleanup_logs: {
        Row: {
          details: Json | null
          error_message: string | null
          execution_time: string | null
          id: string
          job_name: string | null
          status: string | null
          tokens_processed: number | null
        }
        Insert: {
          details?: Json | null
          error_message?: string | null
          execution_time?: string | null
          id?: string
          job_name?: string | null
          status?: string | null
          tokens_processed?: number | null
        }
        Update: {
          details?: Json | null
          error_message?: string | null
          execution_time?: string | null
          id?: string
          job_name?: string | null
          status?: string | null
          tokens_processed?: number | null
        }
        Relationships: []
      }
      features: {
        Row: {
          category_id: string | null
          created_at: string | null
          custom_system_prompt: string | null
          feature_description: string | null
          feature_id: string
          feature_name: string
          icon: string | null
          icon_key: string | null
          is_show_main: boolean | null
          primary_tables: Json | null
          route: string | null
          sample_questions: Json | null
          store_filter_column: string | null
          tables_require_store_filter: Json | null
        }
        Insert: {
          category_id?: string | null
          created_at?: string | null
          custom_system_prompt?: string | null
          feature_description?: string | null
          feature_id?: string
          feature_name: string
          icon?: string | null
          icon_key?: string | null
          is_show_main?: boolean | null
          primary_tables?: Json | null
          route?: string | null
          sample_questions?: Json | null
          store_filter_column?: string | null
          tables_require_store_filter?: Json | null
        }
        Update: {
          category_id?: string | null
          created_at?: string | null
          custom_system_prompt?: string | null
          feature_description?: string | null
          feature_id?: string
          feature_name?: string
          icon?: string | null
          icon_key?: string | null
          is_show_main?: boolean | null
          primary_tables?: Json | null
          route?: string | null
          sample_questions?: Json | null
          store_filter_column?: string | null
          tables_require_store_filter?: Json | null
        }
        Relationships: [
          {
            foreignKeyName: "features_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "categories"
            referencedColumns: ["category_id"]
          },
        ]
      }
      fiscal_periods: {
        Row: {
          created_at: string | null
          end_date: string
          fiscal_year_id: string
          name: string
          period_id: string
          start_date: string
        }
        Insert: {
          created_at?: string | null
          end_date: string
          fiscal_year_id: string
          name: string
          period_id?: string
          start_date: string
        }
        Update: {
          created_at?: string | null
          end_date?: string
          fiscal_year_id?: string
          name?: string
          period_id?: string
          start_date?: string
        }
        Relationships: [
          {
            foreignKeyName: "fiscal_periods_fiscal_year_id_fkey"
            columns: ["fiscal_year_id"]
            isOneToOne: false
            referencedRelation: "fiscal_years"
            referencedColumns: ["fiscal_year_id"]
          },
        ]
      }
      fiscal_years: {
        Row: {
          company_id: string
          created_at: string | null
          end_date: string
          fiscal_year_id: string
          start_date: string
          year: number
        }
        Insert: {
          company_id: string
          created_at?: string | null
          end_date: string
          fiscal_year_id?: string
          start_date: string
          year: number
        }
        Update: {
          company_id?: string
          created_at?: string | null
          end_date?: string
          fiscal_year_id?: string
          start_date?: string
          year?: number
        }
        Relationships: [
          {
            foreignKeyName: "fiscal_years_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      fixed_assets: {
        Row: {
          account_id: string
          acquisition_cost: number
          acquisition_date: string
          asset_id: string
          asset_name: string
          company_id: string
          created_at: string | null
          depreciation_method_id: string | null
          impaired_at: string | null
          impaired_value: number | null
          impairment_reason: string | null
          is_active: boolean | null
          related_journal_line_id: string | null
          salvage_value: number | null
          store_id: string | null
          useful_life_years: number
        }
        Insert: {
          account_id: string
          acquisition_cost: number
          acquisition_date: string
          asset_id?: string
          asset_name: string
          company_id: string
          created_at?: string | null
          depreciation_method_id?: string | null
          impaired_at?: string | null
          impaired_value?: number | null
          impairment_reason?: string | null
          is_active?: boolean | null
          related_journal_line_id?: string | null
          salvage_value?: number | null
          store_id?: string | null
          useful_life_years: number
        }
        Update: {
          account_id?: string
          acquisition_cost?: number
          acquisition_date?: string
          asset_id?: string
          asset_name?: string
          company_id?: string
          created_at?: string | null
          depreciation_method_id?: string | null
          impaired_at?: string | null
          impaired_value?: number | null
          impairment_reason?: string | null
          is_active?: boolean | null
          related_journal_line_id?: string | null
          salvage_value?: number | null
          store_id?: string | null
          useful_life_years?: number
        }
        Relationships: [
          {
            foreignKeyName: "fixed_assets_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "fixed_assets_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "fixed_assets_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "fixed_assets_depreciation_method_id_fkey"
            columns: ["depreciation_method_id"]
            isOneToOne: false
            referencedRelation: "depreciation_methods"
            referencedColumns: ["method_id"]
          },
          {
            foreignKeyName: "fixed_assets_related_journal_line_id_fkey"
            columns: ["related_journal_line_id"]
            isOneToOne: false
            referencedRelation: "journal_lines"
            referencedColumns: ["line_id"]
          },
          {
            foreignKeyName: "fixed_assets_related_journal_line_id_fkey"
            columns: ["related_journal_line_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["line_id"]
          },
          {
            foreignKeyName: "fixed_assets_related_journal_line_id_fkey"
            columns: ["related_journal_line_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["line_id"]
          },
          {
            foreignKeyName: "fixed_assets_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fixed_assets_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fixed_assets_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fixed_assets_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      inventory_brands: {
        Row: {
          brand_code: string | null
          brand_id: string
          brand_name: string
          company_id: string
          created_at: string | null
          is_active: boolean | null
        }
        Insert: {
          brand_code?: string | null
          brand_id?: string
          brand_name: string
          company_id: string
          created_at?: string | null
          is_active?: boolean | null
        }
        Update: {
          brand_code?: string | null
          brand_id?: string
          brand_name?: string
          company_id?: string
          created_at?: string | null
          is_active?: boolean | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_brands_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      inventory_count_items: {
        Row: {
          actual_quantity: number | null
          adjustment_reason: string | null
          count_id: string
          created_at: string | null
          difference: number | null
          item_id: string
          product_id: string
          system_quantity: number | null
        }
        Insert: {
          actual_quantity?: number | null
          adjustment_reason?: string | null
          count_id: string
          created_at?: string | null
          difference?: number | null
          item_id?: string
          product_id: string
          system_quantity?: number | null
        }
        Update: {
          actual_quantity?: number | null
          adjustment_reason?: string | null
          count_id?: string
          created_at?: string | null
          difference?: number | null
          item_id?: string
          product_id?: string
          system_quantity?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_count_items_count_id_fkey"
            columns: ["count_id"]
            isOneToOne: false
            referencedRelation: "inventory_counts"
            referencedColumns: ["count_id"]
          },
          {
            foreignKeyName: "inventory_count_items_count_id_fkey"
            columns: ["count_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_flow_with_references"
            referencedColumns: ["count_session_id"]
          },
          {
            foreignKeyName: "inventory_count_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_count_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
        ]
      }
      inventory_counts: {
        Row: {
          approved_at: string | null
          approved_by: string | null
          company_id: string
          count_date: string
          count_id: string
          count_number: string
          created_at: string | null
          created_by: string | null
          notes: string | null
          status: string | null
          store_id: string | null
        }
        Insert: {
          approved_at?: string | null
          approved_by?: string | null
          company_id: string
          count_date: string
          count_id?: string
          count_number: string
          created_at?: string | null
          created_by?: string | null
          notes?: string | null
          status?: string | null
          store_id?: string | null
        }
        Update: {
          approved_at?: string | null
          approved_by?: string | null
          company_id?: string
          count_date?: string
          count_id?: string
          count_number?: string
          created_at?: string | null
          created_by?: string | null
          notes?: string | null
          status?: string | null
          store_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_counts_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "inventory_counts_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "inventory_counts_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "inventory_counts_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "inventory_counts_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "inventory_counts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_counts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_counts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_counts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      inventory_current_stock: {
        Row: {
          average_cost: number | null
          company_id: string
          last_counted_date: string | null
          last_received_date: string | null
          last_sold_date: string | null
          location_code: string | null
          product_id: string
          quantity_available: number | null
          quantity_on_hand: number | null
          quantity_reserved: number | null
          stock_id: string
          store_id: string | null
          total_value: number | null
          updated_at: string | null
        }
        Insert: {
          average_cost?: number | null
          company_id: string
          last_counted_date?: string | null
          last_received_date?: string | null
          last_sold_date?: string | null
          location_code?: string | null
          product_id: string
          quantity_available?: number | null
          quantity_on_hand?: number | null
          quantity_reserved?: number | null
          stock_id?: string
          store_id?: string | null
          total_value?: number | null
          updated_at?: string | null
        }
        Update: {
          average_cost?: number | null
          company_id?: string
          last_counted_date?: string | null
          last_received_date?: string | null
          last_sold_date?: string | null
          location_code?: string | null
          product_id?: string
          quantity_available?: number | null
          quantity_on_hand?: number | null
          quantity_reserved?: number | null
          stock_id?: string
          store_id?: string | null
          total_value?: number | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_current_stock_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "inventory_current_stock_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_current_stock_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_current_stock_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_current_stock_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_current_stock_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_current_stock_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      inventory_fifo_layers: {
        Row: {
          created_at: string | null
          is_depleted: boolean | null
          layer_date: string
          layer_id: string
          product_id: string
          quantity_original: number
          quantity_remaining: number
          receipt_id: string | null
          unit_cost: number
        }
        Insert: {
          created_at?: string | null
          is_depleted?: boolean | null
          layer_date: string
          layer_id?: string
          product_id: string
          quantity_original: number
          quantity_remaining: number
          receipt_id?: string | null
          unit_cost: number
        }
        Update: {
          created_at?: string | null
          is_depleted?: boolean | null
          layer_date?: string
          layer_id?: string
          product_id?: string
          quantity_original?: number
          quantity_remaining?: number
          receipt_id?: string | null
          unit_cost?: number
        }
        Relationships: [
          {
            foreignKeyName: "inventory_fifo_layers_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_fifo_layers_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_fifo_layers_receipt_id_fkey"
            columns: ["receipt_id"]
            isOneToOne: false
            referencedRelation: "inventory_receipts"
            referencedColumns: ["receipt_id"]
          },
        ]
      }
      inventory_flow: {
        Row: {
          company_id: string
          count_id: string | null
          created_at: string | null
          created_by: string | null
          event_date: string
          flow_id: string
          flow_type: string | null
          invoice_id: string | null
          notes: string | null
          product_id: string
          purchase_order_id: string | null
          quantity_change: number
          receipt_id: string | null
          reference_id_old: string | null
          reference_type_old: string | null
          shipment_id: string | null
          stock_after: number | null
          stock_before: number | null
          store_id: string | null
          total_value: number | null
          transfer_id: string | null
          unit_cost: number | null
        }
        Insert: {
          company_id: string
          count_id?: string | null
          created_at?: string | null
          created_by?: string | null
          event_date?: string
          flow_id?: string
          flow_type?: string | null
          invoice_id?: string | null
          notes?: string | null
          product_id: string
          purchase_order_id?: string | null
          quantity_change: number
          receipt_id?: string | null
          reference_id_old?: string | null
          reference_type_old?: string | null
          shipment_id?: string | null
          stock_after?: number | null
          stock_before?: number | null
          store_id?: string | null
          total_value?: number | null
          transfer_id?: string | null
          unit_cost?: number | null
        }
        Update: {
          company_id?: string
          count_id?: string | null
          created_at?: string | null
          created_by?: string | null
          event_date?: string
          flow_id?: string
          flow_type?: string | null
          invoice_id?: string | null
          notes?: string | null
          product_id?: string
          purchase_order_id?: string | null
          quantity_change?: number
          receipt_id?: string | null
          reference_id_old?: string | null
          reference_type_old?: string | null
          shipment_id?: string | null
          stock_after?: number | null
          stock_before?: number | null
          store_id?: string | null
          total_value?: number | null
          transfer_id?: string | null
          unit_cost?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_inventory_flow_count"
            columns: ["count_id"]
            isOneToOne: false
            referencedRelation: "inventory_counts"
            referencedColumns: ["count_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_count"
            columns: ["count_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_flow_with_references"
            referencedColumns: ["count_session_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_invoice"
            columns: ["invoice_id"]
            isOneToOne: false
            referencedRelation: "inventory_invoice"
            referencedColumns: ["invoice_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_purchase_order"
            columns: ["purchase_order_id"]
            isOneToOne: false
            referencedRelation: "inventory_purchase_orders"
            referencedColumns: ["order_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_receipt"
            columns: ["receipt_id"]
            isOneToOne: false
            referencedRelation: "inventory_receipts"
            referencedColumns: ["receipt_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_shipment"
            columns: ["shipment_id"]
            isOneToOne: false
            referencedRelation: "inventory_shipments"
            referencedColumns: ["shipment_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_transfer"
            columns: ["transfer_id"]
            isOneToOne: false
            referencedRelation: "inventory_transfers"
            referencedColumns: ["transfer_id"]
          },
          {
            foreignKeyName: "inventory_flow_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "inventory_flow_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "inventory_flow_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "inventory_flow_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_flow_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      inventory_invoice: {
        Row: {
          company_id: string
          created_at: string | null
          created_by: string | null
          customer_id: string | null
          discount_amount: number | null
          invoice_id: string
          invoice_number: string
          is_deleted: boolean | null
          payment_method: string | null
          refund_date: string | null
          refund_reason: string | null
          refunded_by: string | null
          sale_date: string
          status: string | null
          store_id: string | null
          subtotal: number | null
          tax_amount: number | null
          total_amount: number | null
        }
        Insert: {
          company_id: string
          created_at?: string | null
          created_by?: string | null
          customer_id?: string | null
          discount_amount?: number | null
          invoice_id?: string
          invoice_number: string
          is_deleted?: boolean | null
          payment_method?: string | null
          refund_date?: string | null
          refund_reason?: string | null
          refunded_by?: string | null
          sale_date: string
          status?: string | null
          store_id?: string | null
          subtotal?: number | null
          tax_amount?: number | null
          total_amount?: number | null
        }
        Update: {
          company_id?: string
          created_at?: string | null
          created_by?: string | null
          customer_id?: string | null
          discount_amount?: number | null
          invoice_id?: string
          invoice_number?: string
          is_deleted?: boolean | null
          payment_method?: string | null
          refund_date?: string | null
          refund_reason?: string | null
          refunded_by?: string | null
          sale_date?: string
          status?: string | null
          store_id?: string | null
          subtotal?: number | null
          tax_amount?: number | null
          total_amount?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_invoice_refunded_by_fkey"
            columns: ["refunded_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "inventory_invoice_refunded_by_fkey"
            columns: ["refunded_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "inventory_sales_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "inventory_sales_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "inventory_sales_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "inventory_sales_customer_id_fkey"
            columns: ["customer_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
          {
            foreignKeyName: "inventory_sales_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_sales_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_sales_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_sales_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      inventory_invoice_items: {
        Row: {
          created_at: string | null
          discount_amount: number | null
          invoice_id: string
          item_id: string
          product_id: string
          quantity_sold: number
          total_amount: number | null
          unit_cost: number | null
          unit_price: number | null
        }
        Insert: {
          created_at?: string | null
          discount_amount?: number | null
          invoice_id: string
          item_id?: string
          product_id: string
          quantity_sold: number
          total_amount?: number | null
          unit_cost?: number | null
          unit_price?: number | null
        }
        Update: {
          created_at?: string | null
          discount_amount?: number | null
          invoice_id?: string
          item_id?: string
          product_id?: string
          quantity_sold?: number
          total_amount?: number | null
          unit_cost?: number | null
          unit_price?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_invoice_items_invoice_id_fkey"
            columns: ["invoice_id"]
            isOneToOne: false
            referencedRelation: "inventory_invoice"
            referencedColumns: ["invoice_id"]
          },
          {
            foreignKeyName: "inventory_invoice_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_invoice_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_sale_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_sale_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
        ]
      }
      inventory_order_fulfillment: {
        Row: {
          allocated_quantity: number
          allocation_date: string
          created_at: string | null
          fulfillment_id: string
          order_id: string
          receipt_id: string
        }
        Insert: {
          allocated_quantity: number
          allocation_date?: string
          created_at?: string | null
          fulfillment_id?: string
          order_id: string
          receipt_id: string
        }
        Update: {
          allocated_quantity?: number
          allocation_date?: string
          created_at?: string | null
          fulfillment_id?: string
          order_id?: string
          receipt_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "inventory_order_fulfillment_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "inventory_purchase_orders"
            referencedColumns: ["order_id"]
          },
          {
            foreignKeyName: "inventory_order_fulfillment_receipt_id_fkey"
            columns: ["receipt_id"]
            isOneToOne: false
            referencedRelation: "inventory_receipts"
            referencedColumns: ["receipt_id"]
          },
        ]
      }
      inventory_product_categories: {
        Row: {
          category_id: string
          category_name: string
          company_id: string
          created_at: string | null
          icon: string | null
          is_active: boolean | null
          level: number | null
          parent_category_id: string | null
          path: string | null
          updated_at: string | null
        }
        Insert: {
          category_id?: string
          category_name: string
          company_id: string
          created_at?: string | null
          icon?: string | null
          is_active?: boolean | null
          level?: number | null
          parent_category_id?: string | null
          path?: string | null
          updated_at?: string | null
        }
        Update: {
          category_id?: string
          category_name?: string
          company_id?: string
          created_at?: string | null
          icon?: string | null
          is_active?: boolean | null
          level?: number | null
          parent_category_id?: string | null
          path?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_product_categories_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "inventory_product_categories_parent_category_id_fkey"
            columns: ["parent_category_id"]
            isOneToOne: false
            referencedRelation: "inventory_product_categories"
            referencedColumns: ["category_id"]
          },
        ]
      }
      inventory_products: {
        Row: {
          barcode: string | null
          brand_id: string | null
          category_id: string | null
          company_id: string
          cost_price: number | null
          created_at: string | null
          image_url: string | null
          image_urls: Json | null
          is_active: boolean | null
          is_deleted: boolean | null
          max_stock: number | null
          min_price: number | null
          min_stock: number | null
          position: string | null
          product_id: string
          product_name: string
          product_type: string | null
          reorder_point: number | null
          reorder_quantity: number | null
          selling_price: number | null
          sku: string
          thumbnail_url: string | null
          unit: string | null
          updated_at: string | null
          weight_g: number | null
        }
        Insert: {
          barcode?: string | null
          brand_id?: string | null
          category_id?: string | null
          company_id: string
          cost_price?: number | null
          created_at?: string | null
          image_url?: string | null
          image_urls?: Json | null
          is_active?: boolean | null
          is_deleted?: boolean | null
          max_stock?: number | null
          min_price?: number | null
          min_stock?: number | null
          position?: string | null
          product_id?: string
          product_name: string
          product_type?: string | null
          reorder_point?: number | null
          reorder_quantity?: number | null
          selling_price?: number | null
          sku: string
          thumbnail_url?: string | null
          unit?: string | null
          updated_at?: string | null
          weight_g?: number | null
        }
        Update: {
          barcode?: string | null
          brand_id?: string | null
          category_id?: string | null
          company_id?: string
          cost_price?: number | null
          created_at?: string | null
          image_url?: string | null
          image_urls?: Json | null
          is_active?: boolean | null
          is_deleted?: boolean | null
          max_stock?: number | null
          min_price?: number | null
          min_stock?: number | null
          position?: string | null
          product_id?: string
          product_name?: string
          product_type?: string | null
          reorder_point?: number | null
          reorder_quantity?: number | null
          selling_price?: number | null
          sku?: string
          thumbnail_url?: string | null
          unit?: string | null
          updated_at?: string | null
          weight_g?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_products_brand_id_fkey"
            columns: ["brand_id"]
            isOneToOne: false
            referencedRelation: "inventory_brands"
            referencedColumns: ["brand_id"]
          },
          {
            foreignKeyName: "inventory_products_category_id_fkey"
            columns: ["category_id"]
            isOneToOne: false
            referencedRelation: "inventory_product_categories"
            referencedColumns: ["category_id"]
          },
          {
            foreignKeyName: "inventory_products_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      inventory_purchase_order_items: {
        Row: {
          created_at: string | null
          item_id: string
          order_id: string
          product_id: string
          quantity_fulfilled: number | null
          quantity_ordered: number
          total_amount: number | null
          unit_price: number | null
        }
        Insert: {
          created_at?: string | null
          item_id?: string
          order_id: string
          product_id: string
          quantity_fulfilled?: number | null
          quantity_ordered: number
          total_amount?: number | null
          unit_price?: number | null
        }
        Update: {
          created_at?: string | null
          item_id?: string
          order_id?: string
          product_id?: string
          quantity_fulfilled?: number | null
          quantity_ordered?: number
          total_amount?: number | null
          unit_price?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_purchase_order_items_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "inventory_purchase_orders"
            referencedColumns: ["order_id"]
          },
          {
            foreignKeyName: "inventory_purchase_order_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_purchase_order_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
        ]
      }
      inventory_purchase_orders: {
        Row: {
          company_id: string
          created_at: string | null
          created_by: string | null
          discrepancy_notes: string | null
          expected_date: string | null
          notes: string | null
          order_date: string
          order_id: string
          order_number: string
          receiving_completed_at: string | null
          receiving_status: string | null
          receiving_verified_at: string | null
          status: string | null
          supplier_id: string | null
          supplier_info: Json | null
          total_amount: number | null
          updated_at: string | null
        }
        Insert: {
          company_id: string
          created_at?: string | null
          created_by?: string | null
          discrepancy_notes?: string | null
          expected_date?: string | null
          notes?: string | null
          order_date: string
          order_id?: string
          order_number: string
          receiving_completed_at?: string | null
          receiving_status?: string | null
          receiving_verified_at?: string | null
          status?: string | null
          supplier_id?: string | null
          supplier_info?: Json | null
          total_amount?: number | null
          updated_at?: string | null
        }
        Update: {
          company_id?: string
          created_at?: string | null
          created_by?: string | null
          discrepancy_notes?: string | null
          expected_date?: string | null
          notes?: string | null
          order_date?: string
          order_id?: string
          order_number?: string
          receiving_completed_at?: string | null
          receiving_status?: string | null
          receiving_verified_at?: string | null
          status?: string | null
          supplier_id?: string | null
          supplier_info?: Json | null
          total_amount?: number | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_purchase_orders_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "inventory_purchase_orders_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "inventory_purchase_orders_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "inventory_purchase_orders_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
        ]
      }
      inventory_receipt_items: {
        Row: {
          created_at: string | null
          item_id: string
          product_id: string
          quantity_accepted: number
          quantity_received: number
          quantity_rejected: number | null
          receipt_id: string
          rejection_reason: string | null
          unit_cost: number | null
        }
        Insert: {
          created_at?: string | null
          item_id?: string
          product_id: string
          quantity_accepted: number
          quantity_received: number
          quantity_rejected?: number | null
          receipt_id: string
          rejection_reason?: string | null
          unit_cost?: number | null
        }
        Update: {
          created_at?: string | null
          item_id?: string
          product_id?: string
          quantity_accepted?: number
          quantity_received?: number
          quantity_rejected?: number | null
          receipt_id?: string
          rejection_reason?: string | null
          unit_cost?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_receipt_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_receipt_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_receipt_items_receipt_id_fkey"
            columns: ["receipt_id"]
            isOneToOne: false
            referencedRelation: "inventory_receipts"
            referencedColumns: ["receipt_id"]
          },
        ]
      }
      inventory_receipts: {
        Row: {
          created_at: string | null
          notes: string | null
          order_id: string
          receipt_id: string
          receipt_number: string
          received_by: string | null
          received_date: string
          shipment_id: string | null
          store_id: string
        }
        Insert: {
          created_at?: string | null
          notes?: string | null
          order_id: string
          receipt_id?: string
          receipt_number: string
          received_by?: string | null
          received_date: string
          shipment_id?: string | null
          store_id: string
        }
        Update: {
          created_at?: string | null
          notes?: string | null
          order_id?: string
          receipt_id?: string
          receipt_number?: string
          received_by?: string | null
          received_date?: string
          shipment_id?: string | null
          store_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "inventory_receipts_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "inventory_purchase_orders"
            referencedColumns: ["order_id"]
          },
          {
            foreignKeyName: "inventory_receipts_received_by_fkey"
            columns: ["received_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "inventory_receipts_received_by_fkey"
            columns: ["received_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "inventory_receipts_shipment_id_fkey"
            columns: ["shipment_id"]
            isOneToOne: false
            referencedRelation: "inventory_shipments"
            referencedColumns: ["shipment_id"]
          },
          {
            foreignKeyName: "inventory_receipts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_receipts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_receipts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_receipts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      inventory_shipment_items: {
        Row: {
          created_at: string | null
          item_id: string
          product_id: string
          quantity_shipped: number
          shipment_id: string
        }
        Insert: {
          created_at?: string | null
          item_id?: string
          product_id: string
          quantity_shipped: number
          shipment_id: string
        }
        Update: {
          created_at?: string | null
          item_id?: string
          product_id?: string
          quantity_shipped?: number
          shipment_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "inventory_shipment_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_shipment_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_shipment_items_shipment_id_fkey"
            columns: ["shipment_id"]
            isOneToOne: false
            referencedRelation: "inventory_shipments"
            referencedColumns: ["shipment_id"]
          },
        ]
      }
      inventory_shipments: {
        Row: {
          created_at: string | null
          expected_arrival: string | null
          order_id: string | null
          shipment_id: string
          shipped_date: string | null
          status: string | null
          supplier_id: string | null
          tracking_number: string | null
        }
        Insert: {
          created_at?: string | null
          expected_arrival?: string | null
          order_id?: string | null
          shipment_id?: string
          shipped_date?: string | null
          status?: string | null
          supplier_id?: string | null
          tracking_number?: string | null
        }
        Update: {
          created_at?: string | null
          expected_arrival?: string | null
          order_id?: string | null
          shipment_id?: string
          shipped_date?: string | null
          status?: string | null
          supplier_id?: string | null
          tracking_number?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_shipments_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "inventory_purchase_orders"
            referencedColumns: ["order_id"]
          },
          {
            foreignKeyName: "inventory_shipments_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
        ]
      }
      inventory_transfer_items: {
        Row: {
          created_at: string | null
          from_location: string | null
          item_id: string
          notes: string | null
          product_id: string
          quantity: number
          to_location: string | null
          transfer_id: string
        }
        Insert: {
          created_at?: string | null
          from_location?: string | null
          item_id?: string
          notes?: string | null
          product_id: string
          quantity: number
          to_location?: string | null
          transfer_id: string
        }
        Update: {
          created_at?: string | null
          from_location?: string | null
          item_id?: string
          notes?: string | null
          product_id?: string
          quantity?: number
          to_location?: string | null
          transfer_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "inventory_transfer_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_transfer_items_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_transfer_items_transfer_id_fkey"
            columns: ["transfer_id"]
            isOneToOne: false
            referencedRelation: "inventory_transfers"
            referencedColumns: ["transfer_id"]
          },
        ]
      }
      inventory_transfers: {
        Row: {
          cancel_reason: string | null
          cancelled_at: string | null
          cancelled_by: string | null
          company_id: string
          created_at: string | null
          from_store_id: string
          is_cancelled: boolean | null
          notes: string | null
          reason: string | null
          to_store_id: string
          transfer_date: string
          transfer_id: string
          transfer_number: string
          transferred_at: string | null
          transferred_by: string | null
          updated_at: string | null
        }
        Insert: {
          cancel_reason?: string | null
          cancelled_at?: string | null
          cancelled_by?: string | null
          company_id: string
          created_at?: string | null
          from_store_id: string
          is_cancelled?: boolean | null
          notes?: string | null
          reason?: string | null
          to_store_id: string
          transfer_date?: string
          transfer_id?: string
          transfer_number: string
          transferred_at?: string | null
          transferred_by?: string | null
          updated_at?: string | null
        }
        Update: {
          cancel_reason?: string | null
          cancelled_at?: string | null
          cancelled_by?: string | null
          company_id?: string
          created_at?: string | null
          from_store_id?: string
          is_cancelled?: boolean | null
          notes?: string | null
          reason?: string | null
          to_store_id?: string
          transfer_date?: string
          transfer_id?: string
          transfer_number?: string
          transferred_at?: string | null
          transferred_by?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_transfers_cancelled_by_fkey"
            columns: ["cancelled_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "inventory_transfers_cancelled_by_fkey"
            columns: ["cancelled_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "inventory_transfers_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "inventory_transfers_from_store_id_fkey"
            columns: ["from_store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_transfers_from_store_id_fkey"
            columns: ["from_store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_transfers_from_store_id_fkey"
            columns: ["from_store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_transfers_from_store_id_fkey"
            columns: ["from_store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_transfers_to_store_id_fkey"
            columns: ["to_store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_transfers_to_store_id_fkey"
            columns: ["to_store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_transfers_to_store_id_fkey"
            columns: ["to_store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_transfers_to_store_id_fkey"
            columns: ["to_store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_transfers_transferred_by_fkey"
            columns: ["transferred_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "inventory_transfers_transferred_by_fkey"
            columns: ["transferred_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      journal_amount_stock_flow: {
        Row: {
          account_id: string
          balance_after: number
          balance_before: number
          cash_location_id: string
          company_id: string
          created_at: string
          created_by: string
          flow_amount: number
          flow_id: string
          journal_id: string
          location_type: string
          store_id: string | null
          system_time: string
        }
        Insert: {
          account_id: string
          balance_after: number
          balance_before?: number
          cash_location_id: string
          company_id: string
          created_at: string
          created_by: string
          flow_amount: number
          flow_id?: string
          journal_id: string
          location_type: string
          store_id?: string | null
          system_time?: string
        }
        Update: {
          account_id?: string
          balance_after?: number
          balance_before?: number
          cash_location_id?: string
          company_id?: string
          created_at?: string
          created_by?: string
          flow_amount?: number
          flow_id?: string
          journal_id?: string
          location_type?: string
          store_id?: string | null
          system_time?: string
        }
        Relationships: [
          {
            foreignKeyName: "fk_journal_flow_account"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_account"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_cash_location"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_cash_location"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_cash_location"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_company"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_journal"
            columns: ["journal_id"]
            isOneToOne: false
            referencedRelation: "journal_entries"
            referencedColumns: ["journal_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      journal_attachments: {
        Row: {
          attachment_id: string
          file_name: string | null
          file_url: string
          journal_id: string
          uploaded_at: string | null
          uploaded_by: string | null
        }
        Insert: {
          attachment_id?: string
          file_name?: string | null
          file_url: string
          journal_id: string
          uploaded_at?: string | null
          uploaded_by?: string | null
        }
        Update: {
          attachment_id?: string
          file_name?: string | null
          file_url?: string
          journal_id?: string
          uploaded_at?: string | null
          uploaded_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "journal_attachments_journal_id_fkey"
            columns: ["journal_id"]
            isOneToOne: false
            referencedRelation: "journal_entries"
            referencedColumns: ["journal_id"]
          },
          {
            foreignKeyName: "journal_attachments_uploaded_by_fkey"
            columns: ["uploaded_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "journal_attachments_uploaded_by_fkey"
            columns: ["uploaded_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      journal_entries: {
        Row: {
          approved_at: string | null
          approved_by: string | null
          base_amount: number | null
          company_id: string
          counterparty_id: string | null
          created_at: string | null
          created_by: string | null
          currency_id: string | null
          description: string | null
          entry_date: string
          exchange_rate: number | null
          is_auto_created: boolean | null
          is_deleted: boolean
          is_draft: boolean | null
          journal_id: string
          journal_type: string | null
          period_id: string | null
          reference_number: string | null
          store_id: string | null
        }
        Insert: {
          approved_at?: string | null
          approved_by?: string | null
          base_amount?: number | null
          company_id: string
          counterparty_id?: string | null
          created_at?: string | null
          created_by?: string | null
          currency_id?: string | null
          description?: string | null
          entry_date: string
          exchange_rate?: number | null
          is_auto_created?: boolean | null
          is_deleted?: boolean
          is_draft?: boolean | null
          journal_id?: string
          journal_type?: string | null
          period_id?: string | null
          reference_number?: string | null
          store_id?: string | null
        }
        Update: {
          approved_at?: string | null
          approved_by?: string | null
          base_amount?: number | null
          company_id?: string
          counterparty_id?: string | null
          created_at?: string | null
          created_by?: string | null
          currency_id?: string | null
          description?: string | null
          entry_date?: string
          exchange_rate?: number | null
          is_auto_created?: boolean | null
          is_deleted?: boolean
          is_draft?: boolean | null
          journal_id?: string
          journal_type?: string | null
          period_id?: string | null
          reference_number?: string | null
          store_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "journal_entries_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "journal_entries_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "journal_entries_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "journal_entries_counterparty_id_fkey"
            columns: ["counterparty_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
          {
            foreignKeyName: "journal_entries_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "journal_entries_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "journal_entries_currency_id_fkey"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "journal_entries_period_id_fkey"
            columns: ["period_id"]
            isOneToOne: false
            referencedRelation: "fiscal_periods"
            referencedColumns: ["period_id"]
          },
          {
            foreignKeyName: "journal_entries_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_entries_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_entries_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_entries_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      journal_lines: {
        Row: {
          account_id: string
          cash_location_id: string | null
          counterparty_id: string | null
          created_at: string | null
          credit: number | null
          debit: number | null
          debt_id: string | null
          description: string | null
          fixed_asset_id: string | null
          is_deleted: boolean
          journal_id: string
          line_id: string
          store_id: string | null
        }
        Insert: {
          account_id: string
          cash_location_id?: string | null
          counterparty_id?: string | null
          created_at?: string | null
          credit?: number | null
          debit?: number | null
          debt_id?: string | null
          description?: string | null
          fixed_asset_id?: string | null
          is_deleted?: boolean
          journal_id: string
          line_id?: string
          store_id?: string | null
        }
        Update: {
          account_id?: string
          cash_location_id?: string | null
          counterparty_id?: string | null
          created_at?: string | null
          credit?: number | null
          debit?: number | null
          debt_id?: string | null
          description?: string | null
          fixed_asset_id?: string | null
          is_deleted?: boolean
          journal_id?: string
          line_id?: string
          store_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_counterparty_id"
            columns: ["counterparty_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
          {
            foreignKeyName: "journal_lines_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "journal_lines_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "journal_lines_cash_location_id_fkey"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "journal_lines_cash_location_id_fkey"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "journal_lines_cash_location_id_fkey"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "journal_lines_debt_id_fkey"
            columns: ["debt_id"]
            isOneToOne: false
            referencedRelation: "debts_receivable"
            referencedColumns: ["debt_id"]
          },
          {
            foreignKeyName: "journal_lines_fixed_asset_id_fkey"
            columns: ["fixed_asset_id"]
            isOneToOne: false
            referencedRelation: "fixed_assets"
            referencedColumns: ["asset_id"]
          },
          {
            foreignKeyName: "journal_lines_fixed_asset_id_fkey"
            columns: ["fixed_asset_id"]
            isOneToOne: false
            referencedRelation: "v_depreciation_summary"
            referencedColumns: ["asset_id"]
          },
          {
            foreignKeyName: "journal_lines_journal_id_fkey"
            columns: ["journal_id"]
            isOneToOne: false
            referencedRelation: "journal_entries"
            referencedColumns: ["journal_id"]
          },
          {
            foreignKeyName: "journal_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      journal_templates: {
        Row: {
          company_id: string
          created_at: string | null
          template_data: Json
          template_id: string
          template_name: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          company_id: string
          created_at?: string | null
          template_data: Json
          template_id?: string
          template_name: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          company_id?: string
          created_at?: string | null
          template_data?: Json
          template_id?: string
          template_name?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: []
      }
      notifications: {
        Row: {
          action_url: string | null
          body: string
          category: string | null
          created_at: string | null
          data: Json | null
          id: string
          image_url: string | null
          is_read: boolean | null
          read_at: string | null
          scheduled_time: string | null
          sent_at: string | null
          title: string
          updated_at: string | null
          user_id: string | null
        }
        Insert: {
          action_url?: string | null
          body: string
          category?: string | null
          created_at?: string | null
          data?: Json | null
          id?: string
          image_url?: string | null
          is_read?: boolean | null
          read_at?: string | null
          scheduled_time?: string | null
          sent_at?: string | null
          title: string
          updated_at?: string | null
          user_id?: string | null
        }
        Update: {
          action_url?: string | null
          body?: string
          category?: string | null
          created_at?: string | null
          data?: Json | null
          id?: string
          image_url?: string | null
          is_read?: boolean | null
          read_at?: string | null
          scheduled_time?: string | null
          sent_at?: string | null
          title?: string
          updated_at?: string | null
          user_id?: string | null
        }
        Relationships: []
      }
      recurring_journal_lines: {
        Row: {
          account_id: string
          created_at: string | null
          credit: number | null
          debit: number | null
          description: string | null
          fixed_asset_id: string | null
          line_id: string
          recurring_id: string
          updated_at: string | null
        }
        Insert: {
          account_id: string
          created_at?: string | null
          credit?: number | null
          debit?: number | null
          description?: string | null
          fixed_asset_id?: string | null
          line_id?: string
          recurring_id: string
          updated_at?: string | null
        }
        Update: {
          account_id?: string
          created_at?: string | null
          credit?: number | null
          debit?: number | null
          description?: string | null
          fixed_asset_id?: string | null
          line_id?: string
          recurring_id?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "recurring_journal_lines_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "recurring_journal_lines_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "recurring_journal_lines_fixed_asset_id_fkey"
            columns: ["fixed_asset_id"]
            isOneToOne: false
            referencedRelation: "fixed_assets"
            referencedColumns: ["asset_id"]
          },
          {
            foreignKeyName: "recurring_journal_lines_fixed_asset_id_fkey"
            columns: ["fixed_asset_id"]
            isOneToOne: false
            referencedRelation: "v_depreciation_summary"
            referencedColumns: ["asset_id"]
          },
          {
            foreignKeyName: "recurring_journal_lines_recurring_id_fkey"
            columns: ["recurring_id"]
            isOneToOne: false
            referencedRelation: "recurring_journals"
            referencedColumns: ["recurring_id"]
          },
        ]
      }
      recurring_journals: {
        Row: {
          company_id: string
          created_at: string | null
          description: string | null
          enabled: boolean | null
          next_run_date: string | null
          recurring_id: string
          repeat_cycle: string | null
          updated_at: string | null
        }
        Insert: {
          company_id: string
          created_at?: string | null
          description?: string | null
          enabled?: boolean | null
          next_run_date?: string | null
          recurring_id?: string
          repeat_cycle?: string | null
          updated_at?: string | null
        }
        Update: {
          company_id?: string
          created_at?: string | null
          description?: string | null
          enabled?: boolean | null
          next_run_date?: string | null
          recurring_id?: string
          repeat_cycle?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "recurring_journals_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      role_permissions: {
        Row: {
          can_access: boolean | null
          created_at: string | null
          feature_id: string | null
          role_id: string | null
          role_permission_id: string
          updated_at: string | null
        }
        Insert: {
          can_access?: boolean | null
          created_at?: string | null
          feature_id?: string | null
          role_id?: string | null
          role_permission_id?: string
          updated_at?: string | null
        }
        Update: {
          can_access?: boolean | null
          created_at?: string | null
          feature_id?: string | null
          role_id?: string | null
          role_permission_id?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "role_permissions_feature_id_fkey"
            columns: ["feature_id"]
            isOneToOne: false
            referencedRelation: "features"
            referencedColumns: ["feature_id"]
          },
          {
            foreignKeyName: "role_permissions_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["role_id"]
          },
          {
            foreignKeyName: "role_permissions_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "view_roles_with_permissions"
            referencedColumns: ["role_id"]
          },
        ]
      }
      roles: {
        Row: {
          company_id: string | null
          created_at: string | null
          description: string | null
          icon: string | null
          is_deletable: boolean | null
          parent_role_id: string | null
          role_id: string
          role_name: string | null
          role_type: string | null
          tags: Json | null
          updated_at: string | null
        }
        Insert: {
          company_id?: string | null
          created_at?: string | null
          description?: string | null
          icon?: string | null
          is_deletable?: boolean | null
          parent_role_id?: string | null
          role_id?: string
          role_name?: string | null
          role_type?: string | null
          tags?: Json | null
          updated_at?: string | null
        }
        Update: {
          company_id?: string | null
          created_at?: string | null
          description?: string | null
          icon?: string | null
          is_deletable?: boolean | null
          parent_role_id?: string | null
          role_id?: string
          role_name?: string | null
          role_type?: string | null
          tags?: Json | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "roles_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "roles_parent_role_id_fkey"
            columns: ["parent_role_id"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["role_id"]
          },
          {
            foreignKeyName: "roles_parent_role_id_fkey"
            columns: ["parent_role_id"]
            isOneToOne: false
            referencedRelation: "view_roles_with_permissions"
            referencedColumns: ["role_id"]
          },
        ]
      }
      sent_shift_notifications: {
        Row: {
          id: string
          notification_type: string | null
          sent_at: string | null
          shift_request_id: string | null
        }
        Insert: {
          id?: string
          notification_type?: string | null
          sent_at?: string | null
          shift_request_id?: string | null
        }
        Update: {
          id?: string
          notification_type?: string | null
          sent_at?: string | null
          shift_request_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "sent_shift_notifications_shift_request_id_fkey"
            columns: ["shift_request_id"]
            isOneToOne: false
            referencedRelation: "shift_requests"
            referencedColumns: ["shift_request_id"]
          },
          {
            foreignKeyName: "sent_shift_notifications_shift_request_id_fkey"
            columns: ["shift_request_id"]
            isOneToOne: false
            referencedRelation: "v_shift_request"
            referencedColumns: ["shift_request_id"]
          },
          {
            foreignKeyName: "sent_shift_notifications_shift_request_id_fkey"
            columns: ["shift_request_id"]
            isOneToOne: false
            referencedRelation: "v_shift_request_with_realtime_problem"
            referencedColumns: ["shift_request_id"]
          },
          {
            foreignKeyName: "sent_shift_notifications_shift_request_id_fkey"
            columns: ["shift_request_id"]
            isOneToOne: false
            referencedRelation: "v_shift_request_with_user"
            referencedColumns: ["shift_request_id"]
          },
        ]
      }
      shift_edit_logs: {
        Row: {
          created_at: string | null
          edit_type: string | null
          edited_by: string | null
          log_id: string
          new_value: Json | null
          old_value: Json | null
          reason: string | null
          shift_request_id: string | null
        }
        Insert: {
          created_at?: string | null
          edit_type?: string | null
          edited_by?: string | null
          log_id?: string
          new_value?: Json | null
          old_value?: Json | null
          reason?: string | null
          shift_request_id?: string | null
        }
        Update: {
          created_at?: string | null
          edit_type?: string | null
          edited_by?: string | null
          log_id?: string
          new_value?: Json | null
          old_value?: Json | null
          reason?: string | null
          shift_request_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "shift_edit_logs_edited_by_fkey"
            columns: ["edited_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "shift_edit_logs_edited_by_fkey"
            columns: ["edited_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "shift_edit_logs_shift_request_id_fkey"
            columns: ["shift_request_id"]
            isOneToOne: false
            referencedRelation: "shift_requests"
            referencedColumns: ["shift_request_id"]
          },
          {
            foreignKeyName: "shift_edit_logs_shift_request_id_fkey"
            columns: ["shift_request_id"]
            isOneToOne: false
            referencedRelation: "v_shift_request"
            referencedColumns: ["shift_request_id"]
          },
          {
            foreignKeyName: "shift_edit_logs_shift_request_id_fkey"
            columns: ["shift_request_id"]
            isOneToOne: false
            referencedRelation: "v_shift_request_with_realtime_problem"
            referencedColumns: ["shift_request_id"]
          },
          {
            foreignKeyName: "shift_edit_logs_shift_request_id_fkey"
            columns: ["shift_request_id"]
            isOneToOne: false
            referencedRelation: "v_shift_request_with_user"
            referencedColumns: ["shift_request_id"]
          },
        ]
      }
      shift_requests: {
        Row: {
          actual_end_time: string | null
          actual_start_time: string | null
          approved_by: string | null
          bonus_amount: number | null
          checkin_distance_from_store: number | null
          checkin_location: unknown
          checkout_distance_from_store: number | null
          checkout_location: unknown
          confirm_end_time: string | null
          confirm_start_time: string | null
          created_at: string | null
          end_time: string | null
          is_approved: boolean | null
          is_extratime: boolean | null
          is_late: boolean | null
          is_problem: boolean | null
          is_problem_solved: boolean
          is_reported: boolean | null
          is_valid_checkin_location: boolean | null
          is_valid_checkout_location: boolean | null
          late_deducut_amount: number | null
          notice_tag: Json | null
          overtime_amount: number | null
          problem_type: string | null
          report_reason: string | null
          report_time: string | null
          request_date: string
          shift_id: string
          shift_request_id: string
          start_time: string | null
          store_id: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          actual_end_time?: string | null
          actual_start_time?: string | null
          approved_by?: string | null
          bonus_amount?: number | null
          checkin_distance_from_store?: number | null
          checkin_location?: unknown
          checkout_distance_from_store?: number | null
          checkout_location?: unknown
          confirm_end_time?: string | null
          confirm_start_time?: string | null
          created_at?: string | null
          end_time?: string | null
          is_approved?: boolean | null
          is_extratime?: boolean | null
          is_late?: boolean | null
          is_problem?: boolean | null
          is_problem_solved?: boolean
          is_reported?: boolean | null
          is_valid_checkin_location?: boolean | null
          is_valid_checkout_location?: boolean | null
          late_deducut_amount?: number | null
          notice_tag?: Json | null
          overtime_amount?: number | null
          problem_type?: string | null
          report_reason?: string | null
          report_time?: string | null
          request_date: string
          shift_id: string
          shift_request_id?: string
          start_time?: string | null
          store_id: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          actual_end_time?: string | null
          actual_start_time?: string | null
          approved_by?: string | null
          bonus_amount?: number | null
          checkin_distance_from_store?: number | null
          checkin_location?: unknown
          checkout_distance_from_store?: number | null
          checkout_location?: unknown
          confirm_end_time?: string | null
          confirm_start_time?: string | null
          created_at?: string | null
          end_time?: string | null
          is_approved?: boolean | null
          is_extratime?: boolean | null
          is_late?: boolean | null
          is_problem?: boolean | null
          is_problem_solved?: boolean
          is_reported?: boolean | null
          is_valid_checkin_location?: boolean | null
          is_valid_checkout_location?: boolean | null
          late_deducut_amount?: number | null
          notice_tag?: Json | null
          overtime_amount?: number | null
          problem_type?: string | null
          report_reason?: string | null
          report_time?: string | null
          request_date?: string
          shift_id?: string
          shift_request_id?: string
          start_time?: string | null
          store_id?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "shift_requests_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "shift_requests_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "shift_requests_shift_id_fkey"
            columns: ["shift_id"]
            isOneToOne: false
            referencedRelation: "store_shifts"
            referencedColumns: ["shift_id"]
          },
          {
            foreignKeyName: "shift_requests_shift_id_fkey"
            columns: ["shift_id"]
            isOneToOne: false
            referencedRelation: "v_store_shifts"
            referencedColumns: ["shift_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "shift_requests_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      spatial_ref_sys: {
        Row: {
          auth_name: string | null
          auth_srid: number | null
          proj4text: string | null
          srid: number
          srtext: string | null
        }
        Insert: {
          auth_name?: string | null
          auth_srid?: number | null
          proj4text?: string | null
          srid: number
          srtext?: string | null
        }
        Update: {
          auth_name?: string | null
          auth_srid?: number | null
          proj4text?: string | null
          srid?: number
          srtext?: string | null
        }
        Relationships: []
      }
      store_shifts: {
        Row: {
          created_at: string | null
          end_time: string
          is_active: boolean | null
          is_can_overtime: boolean
          number_shift: number | null
          shift_bonus: number | null
          shift_id: string
          shift_name: string
          start_time: string
          store_id: string
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          end_time: string
          is_active?: boolean | null
          is_can_overtime?: boolean
          number_shift?: number | null
          shift_bonus?: number | null
          shift_id?: string
          shift_name: string
          start_time: string
          store_id: string
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          end_time?: string
          is_active?: boolean | null
          is_can_overtime?: boolean
          number_shift?: number | null
          shift_bonus?: number | null
          shift_id?: string
          shift_name?: string
          start_time?: string
          store_id?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "store_shifts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "store_shifts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "store_shifts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "store_shifts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      stores: {
        Row: {
          allowed_distance: number | null
          company_id: string | null
          created_at: string | null
          deleted_at: string | null
          huddle_time: number | null
          is_deleted: boolean | null
          payment_time: number | null
          store_address: string | null
          store_code: string | null
          store_id: string
          store_location: unknown
          store_name: string | null
          store_phone: string | null
          store_qrcode: string | null
          updated_at: string | null
        }
        Insert: {
          allowed_distance?: number | null
          company_id?: string | null
          created_at?: string | null
          deleted_at?: string | null
          huddle_time?: number | null
          is_deleted?: boolean | null
          payment_time?: number | null
          store_address?: string | null
          store_code?: string | null
          store_id?: string
          store_location?: unknown
          store_name?: string | null
          store_phone?: string | null
          store_qrcode?: string | null
          updated_at?: string | null
        }
        Update: {
          allowed_distance?: number | null
          company_id?: string | null
          created_at?: string | null
          deleted_at?: string | null
          huddle_time?: number | null
          is_deleted?: boolean | null
          payment_time?: number | null
          store_address?: string | null
          store_code?: string | null
          store_id?: string
          store_location?: unknown
          store_name?: string | null
          store_phone?: string | null
          store_qrcode?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "stores_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      subscription_plans: {
        Row: {
          allowed_features: Json | null
          created_at: string | null
          is_active: boolean | null
          max_companies: number | null
          max_employees_per_company: number | null
          max_stores_per_company: number | null
          monthly_price: number | null
          plan_description: string | null
          plan_id: string
          plan_name: string
          plan_type: string
          updated_at: string | null
          yearly_price: number | null
        }
        Insert: {
          allowed_features?: Json | null
          created_at?: string | null
          is_active?: boolean | null
          max_companies?: number | null
          max_employees_per_company?: number | null
          max_stores_per_company?: number | null
          monthly_price?: number | null
          plan_description?: string | null
          plan_id?: string
          plan_name: string
          plan_type: string
          updated_at?: string | null
          yearly_price?: number | null
        }
        Update: {
          allowed_features?: Json | null
          created_at?: string | null
          is_active?: boolean | null
          max_companies?: number | null
          max_employees_per_company?: number | null
          max_stores_per_company?: number | null
          monthly_price?: number | null
          plan_description?: string | null
          plan_id?: string
          plan_name?: string
          plan_type?: string
          updated_at?: string | null
          yearly_price?: number | null
        }
        Relationships: []
      }
      subscription_usage: {
        Row: {
          created_at: string | null
          current_plan_id: string | null
          last_updated: string | null
          owned_companies_count: number | null
          owner_id: string
          total_employees_count: number | null
          total_stores_count: number | null
          usage_id: string
        }
        Insert: {
          created_at?: string | null
          current_plan_id?: string | null
          last_updated?: string | null
          owned_companies_count?: number | null
          owner_id: string
          total_employees_count?: number | null
          total_stores_count?: number | null
          usage_id?: string
        }
        Update: {
          created_at?: string | null
          current_plan_id?: string | null
          last_updated?: string | null
          owned_companies_count?: number | null
          owner_id?: string
          total_employees_count?: number | null
          total_stores_count?: number | null
          usage_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "subscription_usage_current_plan_id_fkey"
            columns: ["current_plan_id"]
            isOneToOne: false
            referencedRelation: "subscription_plans"
            referencedColumns: ["plan_id"]
          },
          {
            foreignKeyName: "subscription_usage_owner_id_fkey"
            columns: ["owner_id"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "subscription_usage_owner_id_fkey"
            columns: ["owner_id"]
            isOneToOne: true
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      table_business_rules: {
        Row: {
          calculation_logic: string | null
          created_at: string | null
          description: string | null
          fraud_rules: string | null
          id: string
          table_name: string
          updated_at: string | null
          workflow: string | null
        }
        Insert: {
          calculation_logic?: string | null
          created_at?: string | null
          description?: string | null
          fraud_rules?: string | null
          id?: string
          table_name: string
          updated_at?: string | null
          workflow?: string | null
        }
        Update: {
          calculation_logic?: string | null
          created_at?: string | null
          description?: string | null
          fraud_rules?: string | null
          id?: string
          table_name?: string
          updated_at?: string | null
          workflow?: string | null
        }
        Relationships: []
      }
      table_metadata: {
        Row: {
          business_rules: string | null
          calculation_formula: string | null
          column_name: string
          created_at: string | null
          fraud_detection_rules: Json | null
          id: string
          meaning: string | null
          normal_range: string | null
          severity: string | null
          table_name: string
          updated_at: string | null
        }
        Insert: {
          business_rules?: string | null
          calculation_formula?: string | null
          column_name: string
          created_at?: string | null
          fraud_detection_rules?: Json | null
          id?: string
          meaning?: string | null
          normal_range?: string | null
          severity?: string | null
          table_name: string
          updated_at?: string | null
        }
        Update: {
          business_rules?: string | null
          calculation_formula?: string | null
          column_name?: string
          created_at?: string | null
          fraud_detection_rules?: Json | null
          id?: string
          meaning?: string | null
          normal_range?: string | null
          severity?: string | null
          table_name?: string
          updated_at?: string | null
        }
        Relationships: []
      }
      transaction_templates: {
        Row: {
          company_id: string | null
          counterparty_cash_location_id: string | null
          counterparty_id: string | null
          created_at: string | null
          created_by: string | null
          data: Json
          is_active: boolean | null
          name: string
          permission: string | null
          store_id: string | null
          tags: Json | null
          template_description: string | null
          template_id: string
          updated_at: string | null
          updated_by: string | null
          visibility_level: string | null
        }
        Insert: {
          company_id?: string | null
          counterparty_cash_location_id?: string | null
          counterparty_id?: string | null
          created_at?: string | null
          created_by?: string | null
          data: Json
          is_active?: boolean | null
          name: string
          permission?: string | null
          store_id?: string | null
          tags?: Json | null
          template_description?: string | null
          template_id?: string
          updated_at?: string | null
          updated_by?: string | null
          visibility_level?: string | null
        }
        Update: {
          company_id?: string | null
          counterparty_cash_location_id?: string | null
          counterparty_id?: string | null
          created_at?: string | null
          created_by?: string | null
          data?: Json
          is_active?: boolean | null
          name?: string
          permission?: string | null
          store_id?: string | null
          tags?: Json | null
          template_description?: string | null
          template_id?: string
          updated_at?: string | null
          updated_by?: string | null
          visibility_level?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_counterparty"
            columns: ["counterparty_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
          {
            foreignKeyName: "fk_counterparty_cash_location"
            columns: ["counterparty_cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_counterparty_cash_location"
            columns: ["counterparty_cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_counterparty_cash_location"
            columns: ["counterparty_cash_location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "transaction_templates_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "transaction_templates_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      transaction_templates_preferences: {
        Row: {
          company_id: string
          created_at: string | null
          id: string
          metadata: Json | null
          template_id: string
          template_name: string
          template_type: string | null
          usage_type: string
          used_at: string | null
          user_id: string
        }
        Insert: {
          company_id: string
          created_at?: string | null
          id?: string
          metadata?: Json | null
          template_id: string
          template_name: string
          template_type?: string | null
          usage_type?: string
          used_at?: string | null
          user_id: string
        }
        Update: {
          company_id?: string
          created_at?: string | null
          id?: string
          metadata?: Json | null
          template_id?: string
          template_name?: string
          template_type?: string | null
          usage_type?: string
          used_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "transaction_templates_preferences_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      user_companies: {
        Row: {
          company_id: string | null
          created_at: string | null
          deleted_at: string | null
          is_deleted: boolean | null
          updated_at: string | null
          user_company_id: string
          user_id: string | null
        }
        Insert: {
          company_id?: string | null
          created_at?: string | null
          deleted_at?: string | null
          is_deleted?: boolean | null
          updated_at?: string | null
          user_company_id?: string
          user_id?: string | null
        }
        Update: {
          company_id?: string | null
          created_at?: string | null
          deleted_at?: string | null
          is_deleted?: boolean | null
          updated_at?: string | null
          user_company_id?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "user_companies_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "user_companies_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_companies_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      user_fcm_tokens: {
        Row: {
          app_version: string | null
          created_at: string | null
          device_id: string | null
          device_model: string | null
          id: string
          is_active: boolean | null
          last_used_at: string | null
          platform: string
          token: string
          updated_at: string | null
          user_id: string | null
        }
        Insert: {
          app_version?: string | null
          created_at?: string | null
          device_id?: string | null
          device_model?: string | null
          id?: string
          is_active?: boolean | null
          last_used_at?: string | null
          platform: string
          token: string
          updated_at?: string | null
          user_id?: string | null
        }
        Update: {
          app_version?: string | null
          created_at?: string | null
          device_id?: string | null
          device_model?: string | null
          id?: string
          is_active?: boolean | null
          last_used_at?: string | null
          platform?: string
          token?: string
          updated_at?: string | null
          user_id?: string | null
        }
        Relationships: []
      }
      user_notification_settings: {
        Row: {
          category_preferences: Json | null
          created_at: string | null
          email_enabled: boolean | null
          id: string
          marketing_messages: boolean | null
          push_enabled: boolean | null
          reminders: boolean | null
          sound_preference: string | null
          transaction_alerts: boolean | null
          updated_at: string | null
          user_id: string | null
          vibration_enabled: boolean | null
        }
        Insert: {
          category_preferences?: Json | null
          created_at?: string | null
          email_enabled?: boolean | null
          id?: string
          marketing_messages?: boolean | null
          push_enabled?: boolean | null
          reminders?: boolean | null
          sound_preference?: string | null
          transaction_alerts?: boolean | null
          updated_at?: string | null
          user_id?: string | null
          vibration_enabled?: boolean | null
        }
        Update: {
          category_preferences?: Json | null
          created_at?: string | null
          email_enabled?: boolean | null
          id?: string
          marketing_messages?: boolean | null
          push_enabled?: boolean | null
          reminders?: boolean | null
          sound_preference?: string | null
          transaction_alerts?: boolean | null
          updated_at?: string | null
          user_id?: string | null
          vibration_enabled?: boolean | null
        }
        Relationships: []
      }
      user_preferences: {
        Row: {
          category_id: string | null
          clicked_at: string | null
          company_id: string
          created_at: string | null
          feature_id: string
          feature_name: string
          id: string
          user_id: string
        }
        Insert: {
          category_id?: string | null
          clicked_at?: string | null
          company_id: string
          created_at?: string | null
          feature_id: string
          feature_name: string
          id?: string
          user_id: string
        }
        Update: {
          category_id?: string | null
          clicked_at?: string | null
          company_id?: string
          created_at?: string | null
          feature_id?: string
          feature_name?: string
          id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fk_user_preferences_company"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      user_roles: {
        Row: {
          created_at: string | null
          deleted_at: string | null
          is_deleted: boolean | null
          role_id: string | null
          updated_at: string | null
          user_id: string | null
          user_role_id: string
        }
        Insert: {
          created_at?: string | null
          deleted_at?: string | null
          is_deleted?: boolean | null
          role_id?: string | null
          updated_at?: string | null
          user_id?: string | null
          user_role_id?: string
        }
        Update: {
          created_at?: string | null
          deleted_at?: string | null
          is_deleted?: boolean | null
          role_id?: string | null
          updated_at?: string | null
          user_id?: string | null
          user_role_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_roles_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["role_id"]
          },
          {
            foreignKeyName: "user_roles_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "view_roles_with_permissions"
            referencedColumns: ["role_id"]
          },
          {
            foreignKeyName: "user_roles_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_roles_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      user_salaries: {
        Row: {
          account_id: string
          bonus_amount: number | null
          company_id: string
          created_at: string | null
          currency_id: string | null
          edited_by: string | null
          salary_amount: number
          salary_id: string
          salary_type: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          account_id: string
          bonus_amount?: number | null
          company_id: string
          created_at?: string | null
          currency_id?: string | null
          edited_by?: string | null
          salary_amount: number
          salary_id?: string
          salary_type: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          account_id?: string
          bonus_amount?: number | null
          company_id?: string
          created_at?: string | null
          currency_id?: string | null
          edited_by?: string | null
          salary_amount?: number
          salary_id?: string
          salary_type?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fk_currency"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "user_salaries_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "user_salaries_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "user_salaries_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "user_salaries_edited_by_fkey"
            columns: ["edited_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_salaries_edited_by_fkey"
            columns: ["edited_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "user_salaries_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_salaries_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      user_stores: {
        Row: {
          created_at: string | null
          deleted_at: string | null
          is_deleted: boolean | null
          store_id: string | null
          updated_at: string | null
          user_id: string | null
          user_store_id: string
        }
        Insert: {
          created_at?: string | null
          deleted_at?: string | null
          is_deleted?: boolean | null
          store_id?: string | null
          updated_at?: string | null
          user_id?: string | null
          user_store_id?: string
        }
        Update: {
          created_at?: string | null
          deleted_at?: string | null
          is_deleted?: boolean | null
          store_id?: string | null
          updated_at?: string | null
          user_id?: string | null
          user_store_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_stores_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "user_stores_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "user_stores_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "user_stores_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "user_stores_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_stores_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      user_subscriptions: {
        Row: {
          actual_charged_amount: number | null
          applied_credit: number | null
          auto_renewal: boolean | null
          billing_cycle: string | null
          billing_cycle_count: number | null
          cancellation_reason: string | null
          cancelled_at: string | null
          change_type: string | null
          created_at: string | null
          end_date: string | null
          last_payment_date: string | null
          next_payment_date: string | null
          original_price: number | null
          payment_method: string | null
          plan_id: string
          proration_credit: number | null
          scheduled_change_date: string | null
          scheduled_change_plan_id: string | null
          start_date: string
          status: string
          subscription_id: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          actual_charged_amount?: number | null
          applied_credit?: number | null
          auto_renewal?: boolean | null
          billing_cycle?: string | null
          billing_cycle_count?: number | null
          cancellation_reason?: string | null
          cancelled_at?: string | null
          change_type?: string | null
          created_at?: string | null
          end_date?: string | null
          last_payment_date?: string | null
          next_payment_date?: string | null
          original_price?: number | null
          payment_method?: string | null
          plan_id: string
          proration_credit?: number | null
          scheduled_change_date?: string | null
          scheduled_change_plan_id?: string | null
          start_date: string
          status?: string
          subscription_id?: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          actual_charged_amount?: number | null
          applied_credit?: number | null
          auto_renewal?: boolean | null
          billing_cycle?: string | null
          billing_cycle_count?: number | null
          cancellation_reason?: string | null
          cancelled_at?: string | null
          change_type?: string | null
          created_at?: string | null
          end_date?: string | null
          last_payment_date?: string | null
          next_payment_date?: string | null
          original_price?: number | null
          payment_method?: string | null
          plan_id?: string
          proration_credit?: number | null
          scheduled_change_date?: string | null
          scheduled_change_plan_id?: string | null
          start_date?: string
          status?: string
          subscription_id?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_subscriptions_plan_id_fkey"
            columns: ["plan_id"]
            isOneToOne: false
            referencedRelation: "subscription_plans"
            referencedColumns: ["plan_id"]
          },
          {
            foreignKeyName: "user_subscriptions_scheduled_change_plan_id_fkey"
            columns: ["scheduled_change_plan_id"]
            isOneToOne: false
            referencedRelation: "subscription_plans"
            referencedColumns: ["plan_id"]
          },
          {
            foreignKeyName: "user_subscriptions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_subscriptions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      users: {
        Row: {
          created_at: string | null
          current_subscription_id: string | null
          deleted_at: string | null
          email: string | null
          fcm_token: string | null
          first_name: string | null
          is_deleted: boolean | null
          is_email_verified: boolean | null
          last_login_at: string | null
          last_name: string | null
          password_hash: string | null
          preferred_timezone: string | null
          profile_image: string | null
          subscription_status: string | null
          trial_end_date: string | null
          trial_started_at: string | null
          updated_at: string | null
          user_id: string
          user_phone_number: string | null
        }
        Insert: {
          created_at?: string | null
          current_subscription_id?: string | null
          deleted_at?: string | null
          email?: string | null
          fcm_token?: string | null
          first_name?: string | null
          is_deleted?: boolean | null
          is_email_verified?: boolean | null
          last_login_at?: string | null
          last_name?: string | null
          password_hash?: string | null
          preferred_timezone?: string | null
          profile_image?: string | null
          subscription_status?: string | null
          trial_end_date?: string | null
          trial_started_at?: string | null
          updated_at?: string | null
          user_id?: string
          user_phone_number?: string | null
        }
        Update: {
          created_at?: string | null
          current_subscription_id?: string | null
          deleted_at?: string | null
          email?: string | null
          fcm_token?: string | null
          first_name?: string | null
          is_deleted?: boolean | null
          is_email_verified?: boolean | null
          last_login_at?: string | null
          last_name?: string | null
          password_hash?: string | null
          preferred_timezone?: string | null
          profile_image?: string | null
          subscription_status?: string | null
          trial_end_date?: string | null
          trial_started_at?: string | null
          updated_at?: string | null
          user_id?: string
          user_phone_number?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "users_current_subscription_id_fkey"
            columns: ["current_subscription_id"]
            isOneToOne: false
            referencedRelation: "user_subscriptions"
            referencedColumns: ["subscription_id"]
          },
        ]
      }
      users_bank_account: {
        Row: {
          company_id: string | null
          created_at: string | null
          description: string | null
          id: string
          updated_at: string | null
          user_account_number: string | null
          user_bank_name: string | null
          user_id: string
        }
        Insert: {
          company_id?: string | null
          created_at?: string | null
          description?: string | null
          id?: string
          updated_at?: string | null
          user_account_number?: string | null
          user_bank_name?: string | null
          user_id: string
        }
        Update: {
          company_id?: string | null
          created_at?: string | null
          description?: string | null
          id?: string
          updated_at?: string | null
          user_account_number?: string | null
          user_bank_name?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fk_company_id"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "fk_user_id"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "fk_user_id"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      vault_amount_line: {
        Row: {
          company_id: string
          created_at: string | null
          created_by: string
          credit: number | null
          currency_id: string
          debit: number | null
          denomination_id: string | null
          location_id: string
          record_date: string
          store_id: string | null
          vault_amount_id: string
        }
        Insert: {
          company_id: string
          created_at?: string | null
          created_by: string
          credit?: number | null
          currency_id: string
          debit?: number | null
          denomination_id?: string | null
          location_id: string
          record_date: string
          store_id?: string | null
          vault_amount_id?: string
        }
        Update: {
          company_id?: string
          created_at?: string | null
          created_by?: string
          credit?: number | null
          currency_id?: string
          debit?: number | null
          denomination_id?: string | null
          location_id?: string
          record_date?: string
          store_id?: string | null
          vault_amount_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fk_company"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "fk_created_by"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "fk_created_by"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "fk_currency"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "fk_denomination"
            columns: ["denomination_id"]
            isOneToOne: false
            referencedRelation: "currency_denominations"
            referencedColumns: ["denomination_id"]
          },
          {
            foreignKeyName: "fk_location"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_location"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_location"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      vault_amount_line_backup_20251110: {
        Row: {
          company_id: string | null
          created_at: string | null
          created_by: string | null
          credit: number | null
          currency_id: string | null
          debit: number | null
          denomination_id: string | null
          location_id: string | null
          record_date: string | null
          store_id: string | null
          vault_amount_id: string | null
        }
        Insert: {
          company_id?: string | null
          created_at?: string | null
          created_by?: string | null
          credit?: number | null
          currency_id?: string | null
          debit?: number | null
          denomination_id?: string | null
          location_id?: string | null
          record_date?: string | null
          store_id?: string | null
          vault_amount_id?: string | null
        }
        Update: {
          company_id?: string | null
          created_at?: string | null
          created_by?: string | null
          credit?: number | null
          currency_id?: string | null
          debit?: number | null
          denomination_id?: string | null
          location_id?: string | null
          record_date?: string | null
          store_id?: string | null
          vault_amount_id?: string | null
        }
        Relationships: []
      }
    }
    Views: {
      cash_locations_with_total_amount: {
        Row: {
          cash_difference: number | null
          cash_location_id: string | null
          company_id: string | null
          created_at: string | null
          location_info: string | null
          location_name: string | null
          location_type: string | null
          store_id: string | null
          total_journal_cash_amount: number | null
          total_real_cash_amount: number | null
        }
        Relationships: [
          {
            foreignKeyName: "cash_locations_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      geography_columns: {
        Row: {
          coord_dimension: number | null
          f_geography_column: unknown
          f_table_catalog: unknown
          f_table_name: unknown
          f_table_schema: unknown
          srid: number | null
          type: string | null
        }
        Relationships: []
      }
      geometry_columns: {
        Row: {
          coord_dimension: number | null
          f_geometry_column: unknown
          f_table_catalog: string | null
          f_table_name: unknown
          f_table_schema: unknown
          srid: number | null
          type: string | null
        }
        Insert: {
          coord_dimension?: number | null
          f_geometry_column?: unknown
          f_table_catalog?: string | null
          f_table_name?: unknown
          f_table_schema?: unknown
          srid?: number | null
          type?: string | null
        }
        Update: {
          coord_dimension?: number | null
          f_geometry_column?: unknown
          f_table_catalog?: string | null
          f_table_name?: unknown
          f_table_schema?: unknown
          srid?: number | null
          type?: string | null
        }
        Relationships: []
      }
      top_accounts_by_user: {
        Row: {
          company_id: string | null
          top_accounts: Json | null
          user_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "accounts_preferences_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      top_features_by_user: {
        Row: {
          company_id: string | null
          top_features: Json | null
          user_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_user_preferences_company"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      top_templates_by_user: {
        Row: {
          company_id: string | null
          top_templates: Json | null
          user_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "transaction_templates_preferences_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      v_account_mappings_with_linked_company: {
        Row: {
          counterparty_id: string | null
          created_at: string | null
          created_by: string | null
          direction: string | null
          is_deleted: boolean | null
          linked_account_id: string | null
          linked_company_id: string | null
          mapping_id: string | null
          my_account_id: string | null
          my_company_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "account_mappings_counterparty_id_fkey"
            columns: ["counterparty_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
          {
            foreignKeyName: "account_mappings_linked_account_id_fkey"
            columns: ["linked_account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "account_mappings_linked_account_id_fkey"
            columns: ["linked_account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "account_mappings_my_account_id_fkey"
            columns: ["my_account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "account_mappings_my_account_id_fkey"
            columns: ["my_account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "account_mappings_my_company_id_fkey"
            columns: ["my_company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "fk_linked_company"
            columns: ["linked_company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      v_balance_integrity_check: {
        Row: {
          balance_after: number | null
          balance_before: number | null
          cash_location_id: string | null
          created_at: string | null
          flow_amount: number | null
          gap: number | null
          location_name: string | null
          status: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_journal_flow_cash_location"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_cash_location"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_journal_flow_cash_location"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
        ]
      }
      v_balance_sheet_by_store: {
        Row: {
          account_name: string | null
          account_type: string | null
          amount: number | null
          company_id: string | null
          store_id: string | null
          store_name: string | null
        }
        Relationships: []
      }
      v_bank_amount: {
        Row: {
          bank_amount_id: string | null
          company_id: string | null
          created_at: string | null
          created_by: string | null
          currency_id: string | null
          full_name: string | null
          location_id: string | null
          record_date: string | null
          store_id: string | null
          total_amount: number | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_company"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "fk_currency"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
          {
            foreignKeyName: "fk_location"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_location"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_location"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "fk_store"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      v_cash_location: {
        Row: {
          cash_difference: number | null
          cash_location_id: string | null
          company_id: string | null
          created_at: string | null
          is_deleted: boolean | null
          location_info: string | null
          location_name: string | null
          location_type: string | null
          primary_currency_code: string | null
          primary_currency_symbol: string | null
          store_id: string | null
          total_journal_cash_amount: number | null
          total_real_cash_amount: number | null
        }
        Relationships: [
          {
            foreignKeyName: "cash_locations_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cash_locations_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      v_cron_job_status: {
        Row: {
          active: boolean | null
          command: string | null
          execution_method: string | null
          jobname: string | null
          schedule: string | null
          schedule_description: string | null
        }
        Insert: {
          active?: boolean | null
          command?: string | null
          execution_method?: never
          jobname?: string | null
          schedule?: string | null
          schedule_description?: never
        }
        Update: {
          active?: boolean | null
          command?: string | null
          execution_method?: never
          jobname?: string | null
          schedule?: string | null
          schedule_description?: never
        }
        Relationships: []
      }
      v_depreciation_process_status: {
        Row: {
          asset_count: number | null
          company_name: string | null
          created_at: string | null
          error_message: string | null
          process_date: string | null
          status: string | null
          total_amount: number | null
        }
        Relationships: []
      }
      v_depreciation_summary: {
        Row: {
          accumulated_depreciation: number | null
          acquisition_cost: number | null
          acquisition_date: string | null
          asset_id: string | null
          asset_name: string | null
          book_value: number | null
          company_id: string | null
          company_name: string | null
          depreciable_amount: number | null
          depreciation_count: number | null
          depreciation_rate_percent: number | null
          depreciation_status: string | null
          is_active: boolean | null
          last_depreciation_date: string | null
          salvage_value: number | null
          useful_life_years: number | null
        }
        Relationships: [
          {
            foreignKeyName: "fixed_assets_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      v_fcm_cleanup_status: {
        Row: {
          metric: string | null
          value: string | null
        }
        Relationships: []
      }
      v_income_statement_by_store: {
        Row: {
          account_name: string | null
          account_type: string | null
          amount: number | null
          company_id: string | null
          store_id: string | null
          store_name: string | null
        }
        Relationships: [
          {
            foreignKeyName: "stores_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      v_inventory_flow_with_references: {
        Row: {
          company_id: string | null
          count_id: string | null
          count_session_id: string | null
          created_at: string | null
          created_by: string | null
          event_date: string | null
          flow_id: string | null
          flow_type: string | null
          invoice_id: string | null
          invoice_number: string | null
          notes: string | null
          product_id: string | null
          purchase_order_id: string | null
          purchase_order_number: string | null
          quantity_change: number | null
          receipt_id: string | null
          receipt_number: string | null
          reference_id_old: string | null
          reference_source: string | null
          reference_type_old: string | null
          shipment_id: string | null
          shipment_tracking: string | null
          stock_after: number | null
          stock_before: number | null
          store_id: string | null
          total_value: number | null
          transfer_id: string | null
          transfer_number: string | null
          unit_cost: number | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_inventory_flow_count"
            columns: ["count_id"]
            isOneToOne: false
            referencedRelation: "inventory_counts"
            referencedColumns: ["count_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_count"
            columns: ["count_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_flow_with_references"
            referencedColumns: ["count_session_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_invoice"
            columns: ["invoice_id"]
            isOneToOne: false
            referencedRelation: "inventory_invoice"
            referencedColumns: ["invoice_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_purchase_order"
            columns: ["purchase_order_id"]
            isOneToOne: false
            referencedRelation: "inventory_purchase_orders"
            referencedColumns: ["order_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_receipt"
            columns: ["receipt_id"]
            isOneToOne: false
            referencedRelation: "inventory_receipts"
            referencedColumns: ["receipt_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_shipment"
            columns: ["shipment_id"]
            isOneToOne: false
            referencedRelation: "inventory_shipments"
            referencedColumns: ["shipment_id"]
          },
          {
            foreignKeyName: "fk_inventory_flow_transfer"
            columns: ["transfer_id"]
            isOneToOne: false
            referencedRelation: "inventory_transfers"
            referencedColumns: ["transfer_id"]
          },
          {
            foreignKeyName: "inventory_flow_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "inventory_flow_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "inventory_flow_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "inventory_flow_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "inventory_products"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_flow_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "v_inventory_order_risk_analysis"
            referencedColumns: ["product_id"]
          },
          {
            foreignKeyName: "inventory_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_flow_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      v_inventory_order_risk_analysis: {
        Row: {
          company_id: string | null
          current_stock: number | null
          cv_percentage: number | null
          days_of_stock: number | null
          monthly_avg: number | null
          monthly_stddev: number | null
          product_id: string | null
          product_name: string | null
          quantity_available: number | null
          risk_level: string | null
          sku: string | null
          store_id: string | null
          trend_percentage: number | null
        }
        Relationships: [
          {
            foreignKeyName: "inventory_current_stock_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_current_stock_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_current_stock_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_current_stock_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "inventory_products_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      v_inventory_unified_flow: {
        Row: {
          brand_name: string | null
          category_name: string | null
          company_id: string | null
          counterparty_id: string | null
          counterparty_name: string | null
          flow_date: string | null
          flow_type: string | null
          product_id: string | null
          product_name: string | null
          quantity: number | null
          sku: string | null
          store_id: string | null
          value: number | null
        }
        Relationships: []
      }
      v_journal_lines_complete: {
        Row: {
          account_id: string | null
          account_name: string | null
          account_type: string | null
          cash_location_id: string | null
          cash_location_name: string | null
          company_id: string | null
          company_name: string | null
          counterparty_name: string | null
          created_by_email: string | null
          created_by_id: string | null
          created_by_name: string | null
          credit: number | null
          debit: number | null
          entry_date: string | null
          final_counterparty_id: string | null
          journal_counterparty_id: string | null
          journal_counterparty_name: string | null
          journal_created_at: string | null
          journal_created_by: string | null
          journal_description: string | null
          journal_id: string | null
          line_counterparty_id: string | null
          line_counterparty_name: string | null
          line_created_at: string | null
          line_description: string | null
          line_id: string | null
          store_id: string | null
          store_name: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_counterparty_id"
            columns: ["line_counterparty_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
          {
            foreignKeyName: "journal_entries_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "journal_entries_counterparty_id_fkey"
            columns: ["journal_counterparty_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
          {
            foreignKeyName: "journal_entries_created_by_fkey"
            columns: ["journal_created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "journal_entries_created_by_fkey"
            columns: ["journal_created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "journal_lines_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "accounts"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "journal_lines_account_id_fkey"
            columns: ["account_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_readable"
            referencedColumns: ["account_id"]
          },
          {
            foreignKeyName: "journal_lines_cash_location_id_fkey"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "journal_lines_cash_location_id_fkey"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "journal_lines_cash_location_id_fkey"
            columns: ["cash_location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "journal_lines_journal_id_fkey"
            columns: ["journal_id"]
            isOneToOne: false
            referencedRelation: "journal_entries"
            referencedColumns: ["journal_id"]
          },
          {
            foreignKeyName: "journal_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      v_journal_lines_readable: {
        Row: {
          account_id: string | null
          account_name: string | null
          cash_location_name: string | null
          company_id: string | null
          company_name: string | null
          counterparty_id: string | null
          counterparty_name: string | null
          created_at: string | null
          created_by: string | null
          credit: number | null
          debit: number | null
          description: string | null
          entry_date: string | null
          full_name: string | null
          journal_id: string | null
          journal_type: string | null
          line_id: string | null
          store_id: string | null
          store_name: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_counterparty_id"
            columns: ["counterparty_id"]
            isOneToOne: false
            referencedRelation: "counterparties"
            referencedColumns: ["counterparty_id"]
          },
          {
            foreignKeyName: "journal_entries_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "journal_entries_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "journal_entries_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "journal_entries_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_entries_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_entries_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_entries_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "journal_lines_journal_id_fkey"
            columns: ["journal_id"]
            isOneToOne: false
            referencedRelation: "journal_entries"
            referencedColumns: ["journal_id"]
          },
        ]
      }
      v_monthly_depreciation_summary: {
        Row: {
          asset_count: number | null
          company_name: string | null
          month: string | null
          total_depreciation: number | null
        }
        Relationships: []
      }
      v_shift_request: {
        Row: {
          actual_end_time: string | null
          actual_start_time: string | null
          actual_worked_hours: number | null
          allowed_distance: number | null
          approved_by: string | null
          bonus_amount: number | null
          checkin_distance_from_store: number | null
          checkin_location: unknown
          checkout_distance_from_store: number | null
          checkout_location: unknown
          confirm_end_time: string | null
          confirm_start_time: string | null
          created_at: string | null
          end_time: string | null
          first_name: string | null
          has_unsolved_problem: boolean | null
          huddle_time: number | null
          is_approved: boolean | null
          is_can_overtime: boolean | null
          is_extratime: boolean | null
          is_late: boolean | null
          is_problem: boolean | null
          is_problem_solved: boolean | null
          is_reported: boolean | null
          is_valid_checkin_location: boolean | null
          is_valid_checkout_location: boolean | null
          last_name: string | null
          late_deduct_minute: number | null
          late_deduction_krw: number | null
          late_deducut_amount: number | null
          late_minutes: number | null
          notice_tag: Json | null
          order_number: number | null
          original_confirm_end_time: string | null
          original_confirm_start_time: string | null
          overtime_amount: number | null
          overtime_minutes: number | null
          overtime_plus_minute: number | null
          paid_hours: number | null
          payment_time: number | null
          problem_type: string | null
          profile_image: string | null
          report_reason: string | null
          report_time: string | null
          request_date: string | null
          salary_amount: number | null
          salary_type: string | null
          scheduled_hours: number | null
          shift_id: string | null
          shift_name: string | null
          shift_request_id: string | null
          start_time: string | null
          store_code: string | null
          store_id: string | null
          store_name: string | null
          total_pay_with_bonus: number | null
          total_salary_pay: number | null
          updated_at: string | null
          user_email: string | null
          user_id: string | null
          user_name: string | null
        }
        Relationships: [
          {
            foreignKeyName: "shift_requests_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "shift_requests_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "shift_requests_shift_id_fkey"
            columns: ["shift_id"]
            isOneToOne: false
            referencedRelation: "store_shifts"
            referencedColumns: ["shift_id"]
          },
          {
            foreignKeyName: "shift_requests_shift_id_fkey"
            columns: ["shift_id"]
            isOneToOne: false
            referencedRelation: "v_store_shifts"
            referencedColumns: ["shift_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "shift_requests_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      v_shift_request_with_realtime_problem: {
        Row: {
          actual_end_time: string | null
          actual_start_time: string | null
          approved_by: string | null
          bonus_amount: number | null
          checkin_distance_from_store: number | null
          checkin_location: unknown
          checkout_distance_from_store: number | null
          checkout_location: unknown
          confirm_end_time: string | null
          confirm_start_time: string | null
          created_at: string | null
          end_time: string | null
          is_approved: boolean | null
          is_extratime: boolean | null
          is_late: boolean | null
          is_problem: boolean | null
          is_reported: boolean | null
          is_valid_checkin_location: boolean | null
          is_valid_checkout_location: boolean | null
          late_deducut_amount: number | null
          notice_tag: Json | null
          overtime_amount: number | null
          problem_type: string | null
          realtime_is_problem: boolean | null
          report_time: string | null
          report_type: string | null
          request_date: string | null
          shift_id: string | null
          shift_request_id: string | null
          start_time: string | null
          store_id: string | null
          updated_at: string | null
          user_id: string | null
        }
        Insert: {
          actual_end_time?: string | null
          actual_start_time?: string | null
          approved_by?: string | null
          bonus_amount?: number | null
          checkin_distance_from_store?: number | null
          checkin_location?: unknown
          checkout_distance_from_store?: number | null
          checkout_location?: unknown
          confirm_end_time?: string | null
          confirm_start_time?: string | null
          created_at?: string | null
          end_time?: string | null
          is_approved?: boolean | null
          is_extratime?: boolean | null
          is_late?: boolean | null
          is_problem?: boolean | null
          is_reported?: boolean | null
          is_valid_checkin_location?: boolean | null
          is_valid_checkout_location?: boolean | null
          late_deducut_amount?: number | null
          notice_tag?: Json | null
          overtime_amount?: number | null
          problem_type?: never
          realtime_is_problem?: never
          report_time?: string | null
          report_type?: string | null
          request_date?: string | null
          shift_id?: string | null
          shift_request_id?: string | null
          start_time?: string | null
          store_id?: string | null
          updated_at?: string | null
          user_id?: string | null
        }
        Update: {
          actual_end_time?: string | null
          actual_start_time?: string | null
          approved_by?: string | null
          bonus_amount?: number | null
          checkin_distance_from_store?: number | null
          checkin_location?: unknown
          checkout_distance_from_store?: number | null
          checkout_location?: unknown
          confirm_end_time?: string | null
          confirm_start_time?: string | null
          created_at?: string | null
          end_time?: string | null
          is_approved?: boolean | null
          is_extratime?: boolean | null
          is_late?: boolean | null
          is_problem?: boolean | null
          is_reported?: boolean | null
          is_valid_checkin_location?: boolean | null
          is_valid_checkout_location?: boolean | null
          late_deducut_amount?: number | null
          notice_tag?: Json | null
          overtime_amount?: number | null
          problem_type?: never
          realtime_is_problem?: never
          report_time?: string | null
          report_type?: string | null
          request_date?: string | null
          shift_id?: string | null
          shift_request_id?: string | null
          start_time?: string | null
          store_id?: string | null
          updated_at?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "shift_requests_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "shift_requests_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
          {
            foreignKeyName: "shift_requests_shift_id_fkey"
            columns: ["shift_id"]
            isOneToOne: false
            referencedRelation: "store_shifts"
            referencedColumns: ["shift_id"]
          },
          {
            foreignKeyName: "shift_requests_shift_id_fkey"
            columns: ["shift_id"]
            isOneToOne: false
            referencedRelation: "v_store_shifts"
            referencedColumns: ["shift_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "shift_requests_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "shift_requests_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      v_shift_request_with_user: {
        Row: {
          created_at: string | null
          full_name: string | null
          is_approved: boolean | null
          profile_image: string | null
          request_date: string | null
          shift_id: string | null
          shift_request_id: string | null
          user_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "shift_requests_shift_id_fkey"
            columns: ["shift_id"]
            isOneToOne: false
            referencedRelation: "store_shifts"
            referencedColumns: ["shift_id"]
          },
          {
            foreignKeyName: "shift_requests_shift_id_fkey"
            columns: ["shift_id"]
            isOneToOne: false
            referencedRelation: "v_store_shifts"
            referencedColumns: ["shift_id"]
          },
          {
            foreignKeyName: "shift_requests_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "shift_requests_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      v_store_balance_summary: {
        Row: {
          balance_difference: number | null
          company_id: string | null
          store_id: string | null
          store_name: string | null
          total_credit: number | null
          total_debit: number | null
        }
        Relationships: [
          {
            foreignKeyName: "stores_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      v_store_income_summary: {
        Row: {
          company_id: string | null
          net_income: number | null
          store_id: string | null
          store_name: string | null
          total_expense: number | null
          total_income: number | null
        }
        Relationships: [
          {
            foreignKeyName: "stores_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
        ]
      }
      v_store_shifts: {
        Row: {
          created_at: string | null
          end_time: string | null
          is_active: boolean | null
          is_can_overtime: boolean | null
          order_number: number | null
          shift_id: string | null
          shift_name: string | null
          start_time: string | null
          store_id: string | null
          updated_at: string | null
        }
        Relationships: [
          {
            foreignKeyName: "store_shifts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "store_shifts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "store_shifts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "store_shifts_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      v_user_role_info: {
        Row: {
          company_id: string | null
          created_at: string | null
          deleted_at: string | null
          email: string | null
          full_name: string | null
          is_deleted: boolean | null
          profile_image: string | null
          role_id: string | null
          role_name: string | null
          updated_at: string | null
          user_id: string | null
          user_role_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "roles_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "user_roles_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["role_id"]
          },
          {
            foreignKeyName: "user_roles_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "view_roles_with_permissions"
            referencedColumns: ["role_id"]
          },
          {
            foreignKeyName: "user_roles_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_roles_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      v_user_salary: {
        Row: {
          bonus_amount: number | null
          company_id: string | null
          created_at: string | null
          currency_code: string | null
          currency_name: string | null
          first_name: string | null
          full_name: string | null
          last_name: string | null
          profile_image: string | null
          role_id: string | null
          role_name: string | null
          salary_amount: number | null
          salary_id: string | null
          salary_type: string | null
          symbol: string | null
          user_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "user_roles_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["role_id"]
          },
          {
            foreignKeyName: "user_roles_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "view_roles_with_permissions"
            referencedColumns: ["role_id"]
          },
          {
            foreignKeyName: "user_salaries_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "user_salaries_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_salaries_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      v_user_stores: {
        Row: {
          created_at: string | null
          deleted_at: string | null
          is_deleted: boolean | null
          profile_image: string | null
          store_id: string | null
          updated_at: string | null
          user_fullname: string | null
          user_id: string | null
          user_store_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "user_stores_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "user_stores_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "user_stores_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "user_stores_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "user_stores_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["user_id"]
          },
          {
            foreignKeyName: "user_stores_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "v_journal_lines_complete"
            referencedColumns: ["created_by_id"]
          },
        ]
      }
      view_cashier_real_latest_total: {
        Row: {
          company_id: string | null
          location_id: string | null
          record_date: string | null
          store_id: string | null
          total_real_amount_converted: number | null
        }
        Relationships: [
          {
            foreignKeyName: "cashier_amount_lines_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "cash_locations_with_total_amount"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_location_id_fkey"
            columns: ["location_id"]
            isOneToOne: false
            referencedRelation: "v_cash_location"
            referencedColumns: ["cash_location_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_income_statement_by_store"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_balance_summary"
            referencedColumns: ["store_id"]
          },
          {
            foreignKeyName: "cashier_amount_lines_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "v_store_income_summary"
            referencedColumns: ["store_id"]
          },
        ]
      }
      view_company_currency: {
        Row: {
          company_currency_id: string | null
          company_id: string | null
          created_at: string | null
          currency_id: string | null
          currency_name: string | null
        }
        Relationships: [
          {
            foreignKeyName: "company_currency_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "company_currency_currency_id_fkey"
            columns: ["currency_id"]
            isOneToOne: false
            referencedRelation: "currency_types"
            referencedColumns: ["currency_id"]
          },
        ]
      }
      view_roles_with_permissions: {
        Row: {
          company_id: string | null
          created_at: string | null
          is_deletable: boolean | null
          parent_role_id: string | null
          permissions: Json | null
          role_id: string | null
          role_name: string | null
          role_type: string | null
          updated_at: string | null
        }
        Insert: {
          company_id?: string | null
          created_at?: string | null
          is_deletable?: boolean | null
          parent_role_id?: string | null
          permissions?: never
          role_id?: string | null
          role_name?: string | null
          role_type?: string | null
          updated_at?: string | null
        }
        Update: {
          company_id?: string | null
          created_at?: string | null
          is_deletable?: boolean | null
          parent_role_id?: string | null
          permissions?: never
          role_id?: string | null
          role_name?: string | null
          role_type?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "roles_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["company_id"]
          },
          {
            foreignKeyName: "roles_parent_role_id_fkey"
            columns: ["parent_role_id"]
            isOneToOne: false
            referencedRelation: "roles"
            referencedColumns: ["role_id"]
          },
          {
            foreignKeyName: "roles_parent_role_id_fkey"
            columns: ["parent_role_id"]
            isOneToOne: false
            referencedRelation: "view_roles_with_permissions"
            referencedColumns: ["role_id"]
          },
        ]
      }
    }
    Functions: {
      _postgis_deprecate: {
        Args: { newname: string; oldname: string; version: string }
        Returns: undefined
      }
      _postgis_index_extent: {
        Args: { col: string; tbl: unknown }
        Returns: unknown
      }
      _postgis_pgsql_version: { Args: never; Returns: string }
      _postgis_scripts_pgsql_version: { Args: never; Returns: string }
      _postgis_selectivity: {
        Args: { att_name: string; geom: unknown; mode?: string; tbl: unknown }
        Returns: number
      }
      _postgis_stats: {
        Args: { ""?: string; att_name: string; tbl: unknown }
        Returns: string
      }
      _st_3dintersects: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      _st_contains: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      _st_containsproperly: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      _st_coveredby:
        | { Args: { geog1: unknown; geog2: unknown }; Returns: boolean }
        | { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      _st_covers:
        | { Args: { geog1: unknown; geog2: unknown }; Returns: boolean }
        | { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      _st_crosses: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      _st_dwithin: {
        Args: {
          geog1: unknown
          geog2: unknown
          tolerance: number
          use_spheroid?: boolean
        }
        Returns: boolean
      }
      _st_equals: { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      _st_intersects: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      _st_linecrossingdirection: {
        Args: { line1: unknown; line2: unknown }
        Returns: number
      }
      _st_longestline: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      _st_maxdistance: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: number
      }
      _st_orderingequals: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      _st_overlaps: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      _st_sortablehash: { Args: { geom: unknown }; Returns: number }
      _st_touches: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      _st_voronoi: {
        Args: {
          clip?: unknown
          g1: unknown
          return_polygons?: boolean
          tolerance?: number
        }
        Returns: unknown
      }
      _st_within: { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      add_product_image: {
        Args: {
          p_caption?: string
          p_image_url: string
          p_order?: number
          p_product_id: string
        }
        Returns: boolean
      }
      addauth: { Args: { "": string }; Returns: boolean }
      addgeometrycolumn:
        | {
            Args: {
              column_name: string
              new_dim: number
              new_srid: number
              new_type: string
              schema_name: string
              table_name: string
              use_typmod?: boolean
            }
            Returns: string
          }
        | {
            Args: {
              column_name: string
              new_dim: number
              new_srid: number
              new_type: string
              table_name: string
              use_typmod?: boolean
            }
            Returns: string
          }
        | {
            Args: {
              catalog_name: string
              column_name: string
              new_dim: number
              new_srid_in: number
              new_type: string
              schema_name: string
              table_name: string
              use_typmod?: boolean
            }
            Returns: string
          }
      api_update_shift_request: {
        Args: {
          p_actual_end_time?: string
          p_actual_start_time?: string
          p_checkin_latitude?: number
          p_checkin_longitude?: number
          p_checkout_latitude?: number
          p_checkout_longitude?: number
          p_shift_request_id: string
        }
        Returns: undefined
      }
      bank_amount_insert_v2: {
        Args: {
          p_company_id: string
          p_created_at: string
          p_created_by: string
          p_currency_id: string
          p_location_id: string
          p_record_date: string
          p_store_id: string
          p_total_amount: number
        }
        Returns: Json
      }
      bytea_to_text: { Args: { data: string }; Returns: string }
      calculate_supply_chain_integral: {
        Args: {
          p_company_id: string
          p_end_date?: string
          p_product_ids?: string[]
          p_start_date?: string
          p_store_id?: string
        }
        Returns: {
          out_bottleneck_days: number
          out_bottleneck_integral: number
          out_bottleneck_stage: string
          out_brand: string
          out_category: string
          out_company_id: string
          out_order_to_receive_integral: number
          out_order_to_sale_integral: number
          out_order_to_ship_gap: number
          out_order_to_ship_integral: number
          out_problem_score: number
          out_product_id: string
          out_product_name: string
          out_receive_to_sale_gap: number
          out_receive_to_sale_integral: number
          out_ship_to_receive_gap: number
          out_ship_to_receive_integral: number
          out_sku: string
          out_stage_details: Json
          out_store_id: string
          out_store_name: string
          out_total_integral: number
        }[]
      }
      cash_location_create: {
        Args: {
          p_bank_account?: string
          p_bank_name?: string
          p_company_id: string
          p_currency_code?: string
          p_location_info?: string
          p_location_name: string
          p_location_type: string
          p_store_id?: string
        }
        Returns: string
      }
      cash_location_delete: {
        Args: { p_cash_location_id: string }
        Returns: boolean
      }
      cash_location_edit: {
        Args: {
          p_bank_account?: string
          p_bank_name?: string
          p_cash_location_id: string
          p_company_id: string
          p_currency_code?: string
          p_location_info?: string
          p_location_name: string
          p_location_type: string
          p_store_id?: string
        }
        Returns: boolean
      }
      check_account_mapping_exists: {
        Args: {
          p_counterparty_id: string
          p_my_account_id: string
          p_my_company_id: string
        }
        Returns: boolean
      }
      check_and_send_shift_notifications: { Args: never; Returns: undefined }
      check_and_update_missing_checkouts: {
        Args: { p_date?: string; p_store_id?: string }
        Returns: {
          problem_shifts: Json
          updated_count: number
        }[]
      }
      check_balance_continuity: {
        Args: { p_cash_location_id: string }
        Returns: {
          balance_error: number
          created_at: string
          error_message: string
          flow_id: string
        }[]
      }
      check_jasf_integrity: {
        Args: never
        Returns: {
          cash_location_id: string
          flow_count: number
          flow_total: number
          issue_type: string
          journal_id: string
          lines_net: number
          location_name: string
        }[]
      }
      check_missing_checkouts: { Args: never; Returns: undefined }
      check_notification_logs: {
        Args: { p_date?: string }
        Returns: {
          notification_body: string
          notification_title: string
          notification_type: string
          sent_time: string
          shift_time: string
          store_name: string
          user_email: string
        }[]
      }
      check_timezone_status: {
        Args: never
        Returns: {
          current_utc: string
          local_time: string
          local_time_formatted: string
          next_00_minutes: string
          next_30_minutes: string
          timezone: string
        }[]
      }
      check_vault_integrity: {
        Args: never
        Returns: {
          balance_vs_denomination_diff: number
          cash_flow_balance: number
          denomination_total: number
          location_id: string
          location_name: string
          status: string
          vault_total: number
          vault_vs_balance_diff: number
        }[]
      }
      clean_feature_routes: { Args: never; Returns: undefined }
      cleanup_all_orphaned_preferences: {
        Args: never
        Returns: {
          accounts_deleted: number
          cleanup_date: string
          features_deleted: number
          templates_deleted: number
        }[]
      }
      cleanup_expired_sessions: { Args: never; Returns: undefined }
      cleanup_inactive_tokens: { Args: never; Returns: undefined }
      cleanup_old_fcm_tokens: { Args: never; Returns: number }
      cleanup_old_financial_preferences: {
        Args: never
        Returns: {
          accounts_deleted: number
          cleanup_date: string
          templates_deleted: number
        }[]
      }
      cleanup_orphaned_account_preferences: {
        Args: never
        Returns: {
          deleted_count: number
        }[]
      }
      cleanup_orphaned_feature_preferences: {
        Args: never
        Returns: {
          deleted_count: number
        }[]
      }
      cleanup_orphaned_template_preferences: {
        Args: never
        Returns: {
          deleted_count: number
        }[]
      }
      create_account_mapping: {
        Args: {
          p_counterparty_id: string
          p_direction?: string
          p_linked_account_id: string
          p_my_account_id: string
          p_my_company_id: string
        }
        Returns: {
          mapping_id: string
          message: string
          success: boolean
        }[]
      }
      create_corresponding_journal: {
        Args: { p_mapping_id: string; p_source_entry_id: string }
        Returns: {
          message: string
          new_entry_id: string
          success: boolean
        }[]
      }
      create_debt_record: {
        Args: {
          p_account_id: string
          p_amount: number
          p_company_id: string
          p_debt_info: Json
          p_entry_date: string
          p_journal_id: string
          p_store_id: string
        }
        Returns: string
      }
      create_fiscal_periods_for_year: {
        Args: { p_fiscal_year_id: string; p_year: number }
        Returns: undefined
      }
      create_fixed_asset_record: {
        Args: {
          p_account_id: string
          p_amount: number
          p_asset_info: Json
          p_company_id: string
          p_entry_date: string
          p_line_id: string
          p_store_id: string
        }
        Returns: string
      }
      create_mirror_journal_for_counterparty: {
        Args: {
          p_company_id: string
          p_created_by: string
          p_debt: Json
          p_description: string
          p_entry_date: string
          p_if_cash_location_id?: string
          p_lines: Json
          p_store_id: string
        }
        Returns: undefined
      }
      create_role: {
        Args: {
          p_company_id: string
          p_permissions: Json
          p_role_name: string
          p_role_type: string
        }
        Returns: undefined
      }
      daily_checkout_cleanup: { Args: never; Returns: undefined }
      deactivate_old_fcm_tokens: { Args: never; Returns: number }
      debug_date_format: { Args: { input_date: string }; Returns: Json }
      delete_account_mapping: {
        Args: { p_mapping_id: string }
        Returns: {
          message: string
          success: boolean
        }[]
      }
      delete_cash_location: {
        Args: { p_cash_location_id: string }
        Returns: Json
      }
      delete_company: { Args: { p_company_id: string }; Returns: undefined }
      delete_employee_user: { Args: { p_user_id: string }; Returns: undefined }
      delete_null_store_cashier_lines:
        | {
            Args: { p_company_id: string; p_record_date: string }
            Returns: undefined
          }
        | {
            Args: {
              p_company_id: string
              p_location_id: string
              p_record_date: string
            }
            Returns: undefined
          }
      delete_owner_user: { Args: { p_user_id: string }; Returns: undefined }
      delete_role: { Args: { p_role_id: string }; Returns: undefined }
      delete_store: { Args: { p_store_id: string }; Returns: undefined }
      disablelongtransactions: { Args: never; Returns: string }
      drop_v_user_stores_view: { Args: never; Returns: undefined }
      dropgeometrycolumn:
        | {
            Args: {
              column_name: string
              schema_name: string
              table_name: string
            }
            Returns: string
          }
        | { Args: { column_name: string; table_name: string }; Returns: string }
        | {
            Args: {
              catalog_name: string
              column_name: string
              schema_name: string
              table_name: string
            }
            Returns: string
          }
      dropgeometrytable:
        | { Args: { schema_name: string; table_name: string }; Returns: string }
        | { Args: { table_name: string }; Returns: string }
        | {
            Args: {
              catalog_name: string
              schema_name: string
              table_name: string
            }
            Returns: string
          }
      employee_salary_store: {
        Args: {
          p_company_id: string
          p_request_date: string
          p_store_id?: string
        }
        Returns: Json
      }
      enablelongtransactions: { Args: never; Returns: string }
      equals: { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      execute_sql: { Args: { query_text: string }; Returns: Json }
      find_business_by_code: {
        Args: { p_business_code: string }
        Returns: Json
      }
      find_inter_company_journals: {
        Args: { p_days_back?: number; p_target_company_id: string }
        Returns: {
          account_mappings: Json
          amount: number
          counterparty_id: string
          reference_number: string
          source_company_id: string
          source_entry_id: string
          transaction_date: string
        }[]
      }
      fire_employee: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: undefined
      }
      geometry: { Args: { "": string }; Returns: unknown }
      geometry_above: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_below: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_cmp: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: number
      }
      geometry_contained_3d: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_contains: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_contains_3d: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_distance_box: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: number
      }
      geometry_distance_centroid: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: number
      }
      geometry_eq: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_ge: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_gt: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_le: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_left: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_lt: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_overabove: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_overbelow: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_overlaps: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_overlaps_3d: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_overleft: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_overright: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_right: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_same: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_same_3d: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geometry_within: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      geomfromewkt: { Args: { "": string }; Returns: unknown }
      get_account_mapping_page: {
        Args: { p_company_id: string }
        Returns: Json
      }
      get_account_mappings_with_company: {
        Args: { p_counterparty_id: string }
        Returns: {
          counterparty_id: string
          created_at: string
          created_by: string
          direction: string
          linked_account_id: string
          linked_account_name: string
          linked_account_type: string
          linked_company_id: string
          linked_company_name: string
          mapping_id: string
          my_account_id: string
          my_account_name: string
          my_account_type: string
          my_company_id: string
        }[]
      }
      get_accounts: { Args: { p_account_type?: string }; Returns: Json }
      get_balance_sheet: {
        Args: {
          p_company_id: string
          p_end_date: string
          p_start_date: string
          p_store_id?: string
        }
        Returns: Json
      }
      get_bank_real: {
        Args: {
          p_company_id: string
          p_limit?: number
          p_offset?: number
          p_store_id: string
        }
        Returns: Json
      }
      get_base_currency: { Args: { p_company_id: string }; Returns: Json }
      get_cash_balance_amounts: {
        Args: { p_company_id: string; p_store_id?: string }
        Returns: Json
      }
      get_cash_ending: {
        Args: { p_company_id: string; p_store_id?: string }
        Returns: Json
      }
      get_cash_journal: {
        Args: {
          p_company_id: string
          p_limit?: number
          p_offset?: number
          p_store_id: string
        }
        Returns: Json
      }
      get_cash_locations: {
        Args: {
          p_company_id: string
          p_location_type?: string
          p_store_id?: string
        }
        Returns: Json
      }
      get_cash_locations_nested: {
        Args: { p_company_id: string; p_store_id?: string }
        Returns: Json
      }
      get_cash_real: {
        Args: {
          p_company_id: string
          p_limit?: number
          p_offset?: number
          p_store_id: string
        }
        Returns: Json
      }
      get_categories_with_features: { Args: never; Returns: Json }
      get_company_debt_summary: {
        Args: { input_company_id: string }
        Returns: {
          counterparty_id: string
          is_company_debt: boolean
          is_inner: boolean
          name: string
          net_value: number
        }[]
      }
      get_company_roles_optimized: {
        Args: { p_company_id: string; p_current_user_id?: string }
        Returns: Json
      }
      get_company_users: {
        Args: { p_company_id: string }
        Returns: {
          full_name: string
          user_id: string
        }[]
      }
      get_company_users_with_roles: {
        Args: { p_company_id: string }
        Returns: {
          email: string
          first_name: string
          last_name: string
          role_assigned_at: string
          role_name: string
          user_id: string
        }[]
      }
      get_counterparties: {
        Args: {
          p_company_id: string
          p_counterparty_type?: string
          p_store_id?: string
        }
        Returns: Json
      }
      get_counterparties_for_transaction: {
        Args: { p_company_id: string; p_search_term?: string }
        Returns: Json
      }
      get_counterparty_info_batch: {
        Args: { p_counterparty_ids: string[] }
        Returns: {
          counterparty_id: string
          linked_company_id: string
        }[]
      }
      get_counterparty_matrix_all: {
        Args: {
          p_company_id: string
          p_page_size?: number
          p_store_id?: string
        }
        Returns: Json
      }
      get_counterparty_matrix_edit: {
        Args: {
          p_company_id: string
          p_page_size?: number
          p_store_id?: string
        }
        Returns: Json
      }
      get_counterparty_matrix_edit_old: {
        Args: {
          p_company_id: string
          p_page_size?: number
          p_store_id?: string
        }
        Returns: Json
      }
      get_counterparty_matrix_with_pagination: {
        Args: {
          p_company_id: string
          p_filter_type?: string
          p_limit?: number
          p_offset?: number
          p_store_id?: string
          p_view_mode?: string
        }
        Returns: Json
      }
      get_dashboard_page: {
        Args: { p_company_id: string; p_date?: string }
        Returns: Json
      }
      get_dashboard_revenue: {
        Args: { p_company_id: string; p_date?: string; p_store_id?: string }
        Returns: Json
      }
      get_debt_accounts_for_company: {
        Args: { p_company_id: string }
        Returns: {
          account_id: string
          account_name: string
          account_type: string
          category_tag: string
          expense_nature: string
          is_debt_account: boolean
        }[]
      }
      get_debt_control_data_v2: {
        Args: {
          p_company_id: string
          p_filter?: string
          p_show_all?: boolean
          p_store_id?: string
        }
        Returns: Json
      }
      get_debt_summary_all_modes: {
        Args: { p_company_id: string; p_store_id?: string }
        Returns: Json
      }
      get_debt_transactions_v3: {
        Args: {
          p_company_id: string
          p_counterparty_id: string
          p_end_date?: string
          p_limit?: number
          p_offset?: number
          p_start_date?: string
          p_store_id?: string
          p_transaction_type?: string
        }
        Returns: Json
      }
      get_debt_with_inner_company: {
        Args: {
          input_company_id: string
          input_linked_company_id: string
          input_store_id: string
        }
        Returns: {
          linked_company_store_id: string
          net_value: number
          store_name: string
        }[]
      }
      get_debt_with_linked_company:
        | {
            Args: {
              input_company_id: string
              input_linked_company_id: string
              input_store_id?: string
            }
            Returns: {
              is_head_office: boolean
              net_value: number
              store_id: string
              store_name: string
            }[]
          }
        | {
            Args: { input_company_id: string; input_linked_company_id: string }
            Returns: {
              is_head_office: boolean
              net_value: number
              store_id: string
              store_name: string
            }[]
          }
      get_employee_info: {
        Args: { p_company_id: string; p_store_id?: string }
        Returns: {
          account_id: string
          bonus_amount: number
          company_id: string
          company_name: string
          currency_code: string
          currency_id: string
          email: string
          full_name: string
          role_ids: string[]
          role_names: string[]
          salary_amount: number
          salary_id: string
          salary_type: string
          stores: Json
          user_id: string
        }[]
      }
      get_employee_salary: {
        Args: { p_company_id: string; p_month: string }
        Returns: Json
      }
      get_employee_salary_excel: {
        Args: {
          p_company_id: string
          p_request_month: string
          p_store_id?: string
        }
        Returns: {
          actual_end_time: string
          actual_start_time: string
          actual_worked_hours: number
          bonus_amount: number
          confirm_end_time: string
          confirm_start_time: string
          end_time: string
          first_name: string
          is_approved: boolean
          is_extratime: boolean
          is_late: boolean
          is_problem: boolean
          last_name: string
          late_deduction_krw: number
          late_minutes: number
          overtime_amount: number
          overtime_minutes: number
          paid_hours: number
          problem_type: string
          report_reason: string
          request_date: string
          salary_amount: number
          salary_type: string
          scheduled_hours: number
          shift_name: string
          shift_request_id: string
          start_time: string
          store_code: string
          store_name: string
          total_pay_with_bonus: number
          total_salary_pay: number
          user_email: string
          user_id: string
          user_name: string
        }[]
      }
      get_exchange_rate: {
        Args: { p_company_id: string }
        Returns: {
          from_currency_code: string
          from_currency_id: string
          from_currency_name: string
          rate: number
          rate_date: string
          rate_id: string
          to_currency_code: string
          to_currency_id: string
          to_currency_name: string
        }[]
      }
      get_exchange_rate_v2: { Args: { p_company_id: string }; Returns: Json }
      get_income_statement_monthly: {
        Args: {
          p_company_id: string
          p_end_date: string
          p_start_date: string
          p_store_id?: string
        }
        Returns: Json
      }
      get_income_statement_summary: {
        Args: {
          p_company_id: string
          p_request_date: string
          p_store_id?: string
        }
        Returns: Json
      }
      get_income_statement_v2: {
        Args: {
          p_company_id: string
          p_end_date: string
          p_start_date: string
          p_store_id?: string
        }
        Returns: {
          section: string
          section_total: number
          subcategories: Json
        }[]
      }
      get_intent_config: { Args: { p_intent: string }; Returns: Json }
      get_intent_schema: { Args: { p_intent: string }; Returns: Json }
      get_intent_template: { Args: { p_intent: string }; Returns: Json }
      get_internal_counterparties_with_companies: {
        Args: { p_company_id: string }
        Returns: {
          counterparty_id: string
          counterparty_name: string
          is_internal: boolean
          linked_company_id: string
          linked_company_name: string
        }[]
      }
      get_inventory_metadata: {
        Args: { p_company_id: string; p_store_id: string }
        Returns: Json
      }
      get_inventory_order_list: {
        Args: { p_company_id: string }
        Returns: Json
      }
      get_inventory_page: {
        Args: {
          p_company_id: string
          p_limit?: number
          p_page?: number
          p_search?: string
          p_store_id: string
        }
        Returns: Json
      }
      get_inventory_product_list_company: {
        Args: { p_company_id: string }
        Returns: Json
      }
      get_invoice_detail: { Args: { p_invoice_id: string }; Returns: Json }
      get_invoice_page: {
        Args: {
          p_company_id: string
          p_end_date?: string
          p_limit: number
          p_page: number
          p_search?: string
          p_start_date?: string
          p_store_id: string
        }
        Returns: Json
      }
      get_latest_cashier_amount_lines: {
        Args: {
          p_company_id?: string
          p_request_date?: string
          p_store_id?: string
        }
        Returns: Json
      }
      get_location_stock_flow: {
        Args: {
          p_cash_location_id: string
          p_company_id: string
          p_limit?: number
          p_offset?: number
          p_store_id: string
        }
        Returns: Json
      }
      get_monthly_payroll: {
        Args: { p_month: number; p_store_id: string; p_year: number }
        Returns: {
          final_payment: number
          total_bonus: number
          total_late_deduction: number
          total_overtime_pay: number
          total_paid_hours: number
          total_salary_pay: number
          total_shift_requests: number
          unique_work_days: number
          user_email: string
          user_id: string
          user_name: string
        }[]
      }
      get_monthly_shift_status: {
        Args: { p_request_date: string; p_store_id: string; p_user_id: string }
        Returns: {
          is_approved: boolean
          is_registered_by_me: boolean
          other_staffs: Json
          request_date: string
          shift_id: string
          shift_request_id: string
          store_id: string
          total_other_staffs: number
          total_registered: number
        }[]
      }
      get_monthly_shift_status_manager: {
        Args: { p_request_date: string; p_store_id: string }
        Returns: {
          request_date: string
          shifts: Json
          store_id: string
          total_approved: number
          total_pending: number
          total_required: number
        }[]
      }
      get_my_shift_cards:
        | {
            Args: { p_request_date: string; p_store_id: string }
            Returns: Json
          }
        | {
            Args: { p_request_date: string; p_store_id: string }
            Returns: Json
          }
      get_my_shift_overview: {
        Args: { p_request_date: string; p_store_id: string }
        Returns: Json
      }
      get_net_debt_summary: {
        Args: { input_company_id: string; input_store_id?: string }
        Returns: {
          counterparty_id: string
          is_inner: boolean
          name: string
          net_value: number
        }[]
      }
      get_shift_checkout_status: {
        Args: { p_shift_request_id: string }
        Returns: {
          checkout_problem: string
          is_checked_out: boolean
          suggested_action: string
        }[]
      }
      get_shift_metadata: {
        Args: { p_store_id: string }
        Returns: {
          end_time: string
          is_active: boolean
          number_shift: number
          shift_id: string
          shift_name: string
          start_time: string
          store_id: string
        }[]
      }
      get_shift_request_monthly: {
        Args: { p_request_date: string; p_store_id: string; p_user_id: string }
        Returns: {
          actual_end_time: string
          actual_start_time: string
          bonus_amount: string
          confirm_end_time: string
          confirm_start_time: string
          end_time: string
          is_approved: boolean
          is_late: boolean
          is_valid_checkin_location: boolean
          is_valid_checkout_location: boolean
          late_deducut_amount: string
          overtime_amount: string
          paid_hour: string
          request_date: string
          salary_amount: string
          salary_type: string
          shift_id: string
          shift_request_id: string
          start_time: string
          total_salary_pay: string
        }[]
      }
      get_shift_schedule_info: {
        Args: {
          p_company_id: string
          p_end_date: string
          p_start_date: string
          p_store_id: string
        }
        Returns: Json
      }
      get_shift_schedule_info_v2: {
        Args: {
          p_company_id: string
          p_end_date: string
          p_start_date: string
          p_store_id: string
          p_timezone: string
        }
        Returns: Json
      }
      get_single_counterparty: {
        Args: {
          p_company_id: string
          p_counterparty_id: string
          p_store_id?: string
        }
        Returns: Json
      }
      get_store_debt_summary: {
        Args: { input_company_id: string; input_store_id: string }
        Returns: {
          counterparty_id: string
          is_company_debt: boolean
          is_inner: boolean
          name: string
          net_value: number
        }[]
      }
      get_stores_dashboard: {
        Args: { p_company_id: string; p_end_date: string; p_start_date: string }
        Returns: Json
      }
      get_stores_for_transaction: {
        Args: { p_company_id: string; p_include_headquarters?: boolean }
        Returns: Json
      }
      get_transaction_details: {
        Args: { p_company_id: string; p_counterparty_id: string }
        Returns: {
          amount: number
          debt_id: string
          description: string
          direction: string
          due_date: string
          from_entity: string
          from_type: string
          issue_date: string
          status: string
          to_entity: string
          to_type: string
        }[]
      }
      get_transaction_filter_options: {
        Args: { p_company_id: string; p_store_id?: string }
        Returns: Json
      }
      get_transaction_history: {
        Args: {
          p_account_id?: string
          p_account_ids?: string
          p_cash_location_id?: string
          p_company_id: string
          p_counterparty_id?: string
          p_created_by?: string
          p_date_from?: string
          p_date_to?: string
          p_journal_type?: string
          p_limit?: number
          p_offset?: number
          p_store_id?: string
        }
        Returns: Json
      }
      get_transactions_as_json: {
        Args: {
          p_account_id?: string
          p_company_id: string
          p_date_from?: string
          p_date_to?: string
          p_keyword?: string
          p_limit?: number
          p_offset?: number
          p_store_filter_type?: string
          p_store_id?: string
        }
        Returns: Json
      }
      get_transactions_optimized: {
        Args: {
          p_company_id: string
          p_date_from: string
          p_date_to: string
          p_limit?: number
          p_offset?: number
          p_store_filter_type?: string
          p_store_id?: string
        }
        Returns: {
          created_by: string
          created_by_name: string
          entry_date: string
          journal_description: string
          journal_id: string
          lines: Json
          total_credit: number
          total_debit: number
        }[]
      }
      get_transactions_optimized_v2: {
        Args: {
          p_account_id?: string
          p_company_id: string
          p_date_from: string
          p_date_to: string
          p_keyword?: string
          p_limit?: number
          p_offset?: number
          p_store_filter_type?: string
          p_store_id?: string
        }
        Returns: {
          created_by: string
          created_by_name: string
          entry_date: string
          journal_description: string
          journal_id: string
          lines: Json
          row_count: number
          total_credit: number
          total_debit: number
        }[]
      }
      get_transactions_with_full_entries: {
        Args: {
          p_account_id?: string
          p_company_id: string
          p_date_from?: string
          p_date_to?: string
          p_keyword?: string
          p_limit?: number
          p_offset?: number
          p_store_filter_type?: string
          p_store_id?: string
        }
        Returns: {
          created_by: string
          created_by_name: string
          entry_date: string
          journal_description: string
          journal_id: string
          lines: Json
          row_count: number
          total_credit: number
          total_debit: number
        }[]
      }
      get_unlinked_companies:
        | {
            Args: { p_company_id: string; p_user_id: string }
            Returns: {
              company_id: string
              company_name: string
            }[]
          }
        | {
            Args: { p_company_id: number; p_user_id: number }
            Returns: {
              company_id: number
              company_name: string
            }[]
          }
      get_upcoming_shifts: {
        Args: never
        Returns: {
          is_approved: boolean
          minutes_until_shift: number
          shift_name: string
          start_time: string
          store_name: string
          user_email: string
        }[]
      }
      get_upcoming_shifts_with_timezone: {
        Args: never
        Returns: {
          company_name: string
          is_approved: boolean
          local_time: string
          minutes_until_shift: number
          shift_name: string
          start_time: string
          store_name: string
          timezone: string
          user_email: string
        }[]
      }
      get_user_companies_and_stores: {
        Args: { p_user_id: string }
        Returns: Json
      }
      get_user_financial_quick_access: {
        Args: {
          p_account_limit?: number
          p_company_id: string
          p_template_limit?: number
          p_user_id: string
        }
        Returns: Json
      }
      get_user_names_by_store_id: {
        Args: { p_store_id: string }
        Returns: {
          full_name: string
          user_id: string
        }[]
      }
      get_user_quick_access_accounts: {
        Args: { p_company_id: string; p_limit?: number; p_user_id: string }
        Returns: Json
      }
      get_user_quick_access_features: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: Json
      }
      get_user_quick_access_templates: {
        Args: { p_company_id: string; p_limit?: number; p_user_id: string }
        Returns: Json
      }
      get_user_salary_individual: {
        Args: { p_request_date: string; p_store_id: string; p_user_id: string }
        Returns: {
          finished_work: boolean
          request_date: string
          salary_request_id: string
          salary_type: string
          store_id: string
          total_salary: string
          total_work_hour: string
          user_id: string
          user_salary: string
        }[]
      }
      get_user_shift_quantity: {
        Args: { p_request_date: string; p_store_id: string; p_user_id: string }
        Returns: {
          request_date: string
          shift_quantity: string
        }[]
      }
      get_user_used_templates: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: Json
      }
      get_vault_amount_line_history: {
        Args: { p_company_id: string; p_store_id?: string }
        Returns: Json
      }
      get_vault_real: {
        Args: {
          p_company_id: string
          p_limit?: number
          p_offset?: number
          p_store_id: string
        }
        Returns: Json
      }
      gettransactionid: { Args: never; Returns: unknown }
      http: {
        Args: { request: Database["public"]["CompositeTypes"]["http_request"] }
        Returns: Database["public"]["CompositeTypes"]["http_response"]
        SetofOptions: {
          from: "http_request"
          to: "http_response"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      http_delete:
        | {
            Args: { uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
        | {
            Args: { content: string; content_type: string; uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
      http_get:
        | {
            Args: { uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
        | {
            Args: { data: Json; uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
      http_head: {
        Args: { uri: string }
        Returns: Database["public"]["CompositeTypes"]["http_response"]
        SetofOptions: {
          from: "*"
          to: "http_response"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      http_header: {
        Args: { field: string; value: string }
        Returns: Database["public"]["CompositeTypes"]["http_header"]
        SetofOptions: {
          from: "*"
          to: "http_header"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      http_list_curlopt: {
        Args: never
        Returns: {
          curlopt: string
          value: string
        }[]
      }
      http_patch: {
        Args: { content: string; content_type: string; uri: string }
        Returns: Database["public"]["CompositeTypes"]["http_response"]
        SetofOptions: {
          from: "*"
          to: "http_response"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      http_post:
        | {
            Args: { content: string; content_type: string; uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
        | {
            Args: { data: Json; uri: string }
            Returns: Database["public"]["CompositeTypes"]["http_response"]
            SetofOptions: {
              from: "*"
              to: "http_response"
              isOneToOne: true
              isSetofReturn: false
            }
          }
      http_put: {
        Args: { content: string; content_type: string; uri: string }
        Returns: Database["public"]["CompositeTypes"]["http_response"]
        SetofOptions: {
          from: "*"
          to: "http_response"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      http_reset_curlopt: { Args: never; Returns: boolean }
      http_set_curlopt: {
        Args: { curlopt: string; value: string }
        Returns: boolean
      }
      insert_account_mapping_with_company: {
        Args: {
          p_counterparty_company_id: string
          p_created_by: string
          p_direction: string
          p_linked_account_id: string
          p_my_account_id: string
          p_my_company_id: string
        }
        Returns: string
      }
      insert_cashier_amount_lines: {
        Args: {
          p_company_id: string
          p_created_at?: string
          p_created_by?: string
          p_currencies: Json
          p_location_id: string
          p_record_date: string
          p_store_id?: string
        }
        Returns: undefined
      }
      insert_journal_with_everything: {
        Args: {
          p_base_amount: number
          p_company_id: string
          p_counterparty_id?: string
          p_created_by: string
          p_description: string
          p_entry_date: string
          p_if_cash_location_id?: string
          p_lines: Json
          p_store_id?: string
        }
        Returns: string
      }
      insert_shift_request_v2: {
        Args: {
          p_request_date: string
          p_shift_id: string
          p_store_id: string
          p_user_id: string
        }
        Returns: Json
      }
      insert_transaction_template:
        | {
            Args: { p_data: Json; p_name: string; p_user_id: string }
            Returns: undefined
          }
        | {
            Args: {
              p_company_id: string
              p_data: Json
              p_name: string
              p_store_id: string
            }
            Returns: undefined
          }
      inventory_create_brand: {
        Args: {
          p_brand_code?: string
          p_brand_name: string
          p_company_id: string
        }
        Returns: Json
      }
      inventory_create_category: {
        Args: {
          p_category_name: string
          p_company_id: string
          p_parent_category_id?: string
        }
        Returns: Json
      }
      inventory_create_invoice: {
        Args: {
          p_company_id: string
          p_created_by: string
          p_customer_id?: string
          p_discount_amount?: number
          p_items?: Json
          p_notes?: string
          p_payment_method?: string
          p_sale_date?: string
          p_store_id: string
          p_tax_rate?: number
        }
        Returns: Json
      }
      inventory_create_order: {
        Args: {
          p_company_id: string
          p_counterparty_id?: string
          p_expected_date?: string
          p_items: Json
          p_notes?: string
          p_order_date?: string
          p_supplier_info?: Json
          p_user_id: string
        }
        Returns: Json
      }
      inventory_create_product: {
        Args: {
          p_barcode?: string
          p_brand_id?: string
          p_category_id?: string
          p_company_id: string
          p_cost_price?: number
          p_image_url?: string
          p_image_urls?: Json
          p_initial_quantity?: number
          p_product_name: string
          p_selling_price?: number
          p_sku?: string
          p_store_id?: string
          p_thumbnail_url?: string
          p_unit?: string
        }
        Returns: Json
      }
      inventory_delete_product: {
        Args: { p_company_id: string; p_product_ids: string[] }
        Returns: Json
      }
      inventory_edit_product: {
        Args: {
          p_brand_id?: string
          p_category_id?: string
          p_company_id: string
          p_cost_price?: number
          p_new_quantity?: number
          p_product_id: string
          p_product_name?: string
          p_product_type?: string
          p_selling_price?: number
          p_sku?: string
          p_store_id: string
          p_unit?: string
        }
        Returns: Json
      }
      inventory_import_excel: {
        Args: {
          p_company_id: string
          p_products: Json
          p_store_id: string
          p_user_id: string
        }
        Returns: Json
      }
      inventory_order_calculate_reorder_point: {
        Args: {
          p_company_id: string
          p_lead_time_days?: number
          p_product_id: string
          p_service_level?: number
          p_store_id?: string
        }
        Returns: {
          current_stock: number
          daily_avg_demand: number
          daily_stddev: number
          lead_time_days: number
          lead_time_demand: number
          max_stock_level: number
          product_id: string
          product_name: string
          recommended_order_qty: number
          reorder_point: number
          safety_stock: number
          stock_status: string
        }[]
      }
      inventory_order_calculate_sales_statistics: {
        Args: {
          p_company_id: string
          p_end_date?: string
          p_months?: number
          p_product_id: string
          p_store_id?: string
        }
        Returns: {
          analysis_months: number
          cv_percentage: number
          daily_avg: number
          daily_stddev: number
          max_monthly: number
          min_monthly: number
          monthly_avg: number
          monthly_stddev: number
          product_id: string
          product_name: string
          total_sales_quantity: number
          trend_percentage: number
        }[]
      }
      inventory_order_calculate_stockout_probability: {
        Args: {
          p_company_id: string
          p_current_stock: number
          p_days_ahead?: number
          p_product_id: string
          p_service_levels?: number[]
          p_store_id?: string
        }
        Returns: {
          current_stock: number
          days_ahead: number
          demand_stddev: number
          expected_demand: number
          product_id: string
          safety_days: number
          service_level_50: number
          service_level_90: number
          service_level_95: number
          service_level_99: number
          stockout_probability: number
        }[]
      }
      inventory_order_receive: {
        Args: {
          p_company_id: string
          p_items: Json
          p_notes?: string
          p_order_id: string
          p_store_id: string
          p_user_id: string
        }
        Returns: Json
      }
      inventory_refund_invoice: {
        Args: {
          p_created_by?: string
          p_invoice_id: string
          p_refund_date?: string
          p_refund_reason?: string
        }
        Returns: Json
      }
      join_business_by_code: {
        Args: { p_business_code: string; p_user_id: string }
        Returns: Json
      }
      join_user_by_code: {
        Args: { p_code: string; p_user_id: string }
        Returns: Json
      }
      leave_company: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: undefined
      }
      log_account_usage: {
        Args: {
          p_account_id: string
          p_account_name: string
          p_account_type?: string
          p_company_id: string
          p_metadata?: Json
          p_usage_type?: string
        }
        Returns: undefined
      }
      log_feature_click: {
        Args: {
          p_category_id?: string
          p_company_id: string
          p_feature_id: string
          p_feature_name: string
        }
        Returns: undefined
      }
      log_template_usage: {
        Args: {
          p_company_id: string
          p_metadata?: Json
          p_template_id: string
          p_template_name: string
          p_template_type?: string
          p_usage_type?: string
        }
        Returns: undefined
      }
      longtransactionsenabled: { Args: never; Returns: boolean }
      manager_shift_delete_tag: {
        Args: { p_tag_id: string; p_user_id: string }
        Returns: Json
      }
      manager_shift_get_cards: {
        Args: {
          p_company_id: string
          p_end_date: string
          p_start_date: string
          p_store_id?: string
        }
        Returns: Json
      }
      manager_shift_get_detail:
        | {
            Args: { p_shift_request_id: string }
            Returns: {
              error: true
            } & "Could not choose the best candidate function between: public.manager_shift_get_detail(p_shift_request_id => text), public.manager_shift_get_detail(p_shift_request_id => uuid). Try renaming the parameters or the function itself in the database so function overloading can be resolved"
          }
        | {
            Args: { p_shift_request_id: string }
            Returns: {
              error: true
            } & "Could not choose the best candidate function between: public.manager_shift_get_detail(p_shift_request_id => text), public.manager_shift_get_detail(p_shift_request_id => uuid). Try renaming the parameters or the function itself in the database so function overloading can be resolved"
          }
      manager_shift_get_overview: {
        Args: {
          p_company_id: string
          p_end_date: string
          p_start_date: string
          p_store_id?: string
        }
        Returns: Json
      }
      manager_shift_get_schedule: {
        Args: { p_store_id: string }
        Returns: Json
      }
      manager_shift_input_card: {
        Args: {
          p_confirm_end_time: string
          p_confirm_start_time: string
          p_is_late: boolean
          p_is_problem_solved: boolean
          p_manager_id: string
          p_new_tag_content: string
          p_new_tag_type: string
          p_shift_request_id: string
        }
        Returns: Json
      }
      manager_shift_insert_schedule: {
        Args: {
          p_approved_by: string
          p_request_date: string
          p_shift_id: string
          p_store_id: string
          p_user_id: string
        }
        Returns: Json
      }
      manager_shift_insert_schedule_v2: {
        Args: {
          p_approved_by: string
          p_request_time: string
          p_shift_id: string
          p_store_id: string
          p_timezone: string
          p_user_id: string
        }
        Returns: Json
      }
      manager_shift_notapprove: {
        Args: {
          p_removal_reason?: string
          p_removed_by: string
          p_shift_request_id: string
        }
        Returns: Json
      }
      mark_notification_as_read: {
        Args: { p_notification_id: string }
        Returns: boolean
      }
      mark_notification_read: {
        Args: { notification_id: string }
        Returns: undefined
      }
      mark_notifications_as_read: {
        Args: { p_notification_ids: string[] }
        Returns: number
      }
      match_documents: {
        Args: { filter?: Json; match_count?: number; query_embedding: string }
        Returns: {
          embedding: string
          id: number
          intent: string
          intent_name: string
          metadata: Json
          similarity: number
          text: string
        }[]
      }
      n8n_find_user_id: { Args: { params: Json }; Returns: Json }
      n8n_get_employee_data: { Args: { params: Json }; Returns: Json }
      populate_geometry_columns:
        | { Args: { use_typmod?: boolean }; Returns: string }
        | { Args: { tbl_oid: unknown; use_typmod?: boolean }; Returns: number }
      postgis_constraint_dims: {
        Args: { geomcolumn: string; geomschema: string; geomtable: string }
        Returns: number
      }
      postgis_constraint_srid: {
        Args: { geomcolumn: string; geomschema: string; geomtable: string }
        Returns: number
      }
      postgis_constraint_type: {
        Args: { geomcolumn: string; geomschema: string; geomtable: string }
        Returns: string
      }
      postgis_extensions_upgrade: { Args: never; Returns: string }
      postgis_full_version: { Args: never; Returns: string }
      postgis_geos_version: { Args: never; Returns: string }
      postgis_lib_build_date: { Args: never; Returns: string }
      postgis_lib_revision: { Args: never; Returns: string }
      postgis_lib_version: { Args: never; Returns: string }
      postgis_libjson_version: { Args: never; Returns: string }
      postgis_liblwgeom_version: { Args: never; Returns: string }
      postgis_libprotobuf_version: { Args: never; Returns: string }
      postgis_libxml_version: { Args: never; Returns: string }
      postgis_proj_version: { Args: never; Returns: string }
      postgis_scripts_build_date: { Args: never; Returns: string }
      postgis_scripts_installed: { Args: never; Returns: string }
      postgis_scripts_released: { Args: never; Returns: string }
      postgis_svn_version: { Args: never; Returns: string }
      postgis_type_name: {
        Args: {
          coord_dimension: number
          geomname: string
          use_new_name?: boolean
        }
        Returns: string
      }
      postgis_version: { Args: never; Returns: string }
      postgis_wagyu_version: { Args: never; Returns: string }
      preview_upcoming_notifications: {
        Args: { p_minutes_ahead?: number }
        Returns: {
          company: string
          minutes_until: number
          notification_status: string
          shift_name: string
          shift_time: string
          store_name: string
          timezone: string
          user_email: string
        }[]
      }
      process_all_currencies_batch: {
        Args: {
          p_company_id: string
          p_created_at: string
          p_currency_ids: string[]
          p_location_id: string
        }
        Returns: undefined
      }
      process_all_depreciation: {
        Args: never
        Returns: {
          asset_count: number
          company_name: string
          status: string
          total_amount: number
        }[]
      }
      process_cashier_batch: {
        Args: {
          p_company_id: string
          p_created_at: string
          p_currency_id: string
          p_location_id: string
        }
        Returns: undefined
      }
      quick_test_notification: { Args: never; Returns: string }
      recalculate_denomination_details: {
        Args: { p_location_id: string; p_up_to_time: string }
        Returns: Json
      }
      register_fcm_token: {
        Args: { p_platform?: string; p_token: string; p_user_id: string }
        Returns: boolean
      }
      register_fcm_token_simple: {
        Args: { p_email: string; p_token: string }
        Returns: string
      }
      register_my_fcm_token: {
        Args: { p_email: string; p_fcm_token: string; p_platform?: string }
        Returns: string
      }
      register_user_stores: {
        Args: { p_company_id: string; p_user_id: string }
        Returns: Json
      }
      remove_product_image: {
        Args: { p_image_url: string; p_product_id: string }
        Returns: boolean
      }
      rpc_get_income_statement_monthly_comparison: {
        Args: {
          p_company_id: string
          p_end_date: string
          p_start_date: string
          p_store_id?: string
        }
        Returns: {
          account_id: string
          account_name: string
          account_type: string
          amount: number
          month_key: string
          statement_category: string
          statement_detail_category: string
        }[]
      }
      rpc_get_income_statement_v2: {
        Args: {
          p_company_id: string
          p_currency_id?: string
          p_end_date: string
          p_start_date: string
          p_store_id?: string
        }
        Returns: {
          account_id: string
          account_name: string
          account_type: string
          base_currency_amount: number
          expense_nature: string
          is_subtotal: boolean
          net_amount: number
          section: string
          sort_order: number
          statement_detail_category: string
          transaction_count: number
        }[]
      }
      safe_to_uuid: { Args: { p_value: string }; Returns: string }
      schedule_fcm_cleanup: { Args: never; Returns: undefined }
      search_intent: {
        Args: {
          match_count?: number
          match_threshold?: number
          query_embedding: string
        }
        Returns: {
          description: string
          intent: string
          intent_name: string
          similarity: number
          template_id: string
        }[]
      }
      search_intent_unified: {
        Args: {
          match_count?: number
          match_threshold?: number
          query_embedding: string
        }
        Returns: {
          config: Json
          intent: string
          intent_name: string
          similarity: number
        }[]
      }
      send_broadcast_notification: {
        Args: { p_body: string; p_category?: string; p_title: string }
        Returns: number
      }
      send_company_notification: {
        Args: {
          p_body: string
          p_category?: string
          p_company_id: string
          p_title: string
        }
        Returns: number
      }
      send_notification: {
        Args: {
          p_body: string
          p_category?: string
          p_data?: Json
          p_title: string
          p_user_id: string
        }
        Returns: string
      }
      send_notification_to_user: {
        Args: {
          p_action_url?: string
          p_body: string
          p_category?: string
          p_data?: Json
          p_image_url?: string
          p_scheduled_time?: string
          p_title: string
          p_user_id: string
        }
        Returns: string
      }
      send_push_notification: {
        Args: {
          p_body: string
          p_category?: string
          p_title: string
          p_user_id: string
        }
        Returns: string
      }
      send_push_notification_via_edge: {
        Args: { p_notification_id: string }
        Returns: Json
      }
      send_test_notification: {
        Args: { p_body?: string; p_email: string; p_title?: string }
        Returns: string
      }
      shift_request_filter_number:
        | {
            Args: { p_request_date: string; p_user_id: string }
            Returns: number
          }
        | {
            Args: {
              p_request_date: string
              p_store_id: string
              p_user_id: string
            }
            Returns: number
          }
      simple_send_notification: {
        Args: { p_body: string; p_email: string; p_title: string }
        Returns: string
      }
      simulate_shift_notification: {
        Args: { p_simulate_date: string; p_simulate_time: string }
        Returns: {
          reason: string
          shift_name: string
          shift_time: string
          store_name: string
          user_email: string
          would_notify: boolean
        }[]
      }
      st_3dclosestpoint: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_3ddistance: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: number
      }
      st_3dintersects: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      st_3dlongestline: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_3dmakebox: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_3dmaxdistance: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: number
      }
      st_3dshortestline: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_addpoint: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_angle:
        | { Args: { line1: unknown; line2: unknown }; Returns: number }
        | {
            Args: { pt1: unknown; pt2: unknown; pt3: unknown; pt4?: unknown }
            Returns: number
          }
      st_area:
        | { Args: { geog: unknown; use_spheroid?: boolean }; Returns: number }
        | { Args: { "": string }; Returns: number }
      st_asencodedpolyline: {
        Args: { geom: unknown; nprecision?: number }
        Returns: string
      }
      st_asewkt: { Args: { "": string }; Returns: string }
      st_asgeojson:
        | {
            Args: {
              geom_column?: string
              maxdecimaldigits?: number
              pretty_bool?: boolean
              r: Record<string, unknown>
            }
            Returns: string
          }
        | {
            Args: { geom: unknown; maxdecimaldigits?: number; options?: number }
            Returns: string
          }
        | {
            Args: { geog: unknown; maxdecimaldigits?: number; options?: number }
            Returns: string
          }
        | { Args: { "": string }; Returns: string }
      st_asgml:
        | {
            Args: {
              geom: unknown
              id?: string
              maxdecimaldigits?: number
              nprefix?: string
              options?: number
              version: number
            }
            Returns: string
          }
        | {
            Args: { geom: unknown; maxdecimaldigits?: number; options?: number }
            Returns: string
          }
        | {
            Args: {
              geog: unknown
              id?: string
              maxdecimaldigits?: number
              nprefix?: string
              options?: number
              version: number
            }
            Returns: string
          }
        | {
            Args: {
              geog: unknown
              id?: string
              maxdecimaldigits?: number
              nprefix?: string
              options?: number
            }
            Returns: string
          }
        | { Args: { "": string }; Returns: string }
      st_askml:
        | {
            Args: { geom: unknown; maxdecimaldigits?: number; nprefix?: string }
            Returns: string
          }
        | {
            Args: { geog: unknown; maxdecimaldigits?: number; nprefix?: string }
            Returns: string
          }
        | { Args: { "": string }; Returns: string }
      st_aslatlontext: {
        Args: { geom: unknown; tmpl?: string }
        Returns: string
      }
      st_asmarc21: { Args: { format?: string; geom: unknown }; Returns: string }
      st_asmvtgeom: {
        Args: {
          bounds: unknown
          buffer?: number
          clip_geom?: boolean
          extent?: number
          geom: unknown
        }
        Returns: unknown
      }
      st_assvg:
        | {
            Args: { geom: unknown; maxdecimaldigits?: number; rel?: number }
            Returns: string
          }
        | {
            Args: { geog: unknown; maxdecimaldigits?: number; rel?: number }
            Returns: string
          }
        | { Args: { "": string }; Returns: string }
      st_astext: { Args: { "": string }; Returns: string }
      st_astwkb:
        | {
            Args: {
              geom: unknown[]
              ids: number[]
              prec?: number
              prec_m?: number
              prec_z?: number
              with_boxes?: boolean
              with_sizes?: boolean
            }
            Returns: string
          }
        | {
            Args: {
              geom: unknown
              prec?: number
              prec_m?: number
              prec_z?: number
              with_boxes?: boolean
              with_sizes?: boolean
            }
            Returns: string
          }
      st_asx3d: {
        Args: { geom: unknown; maxdecimaldigits?: number; options?: number }
        Returns: string
      }
      st_azimuth:
        | { Args: { geom1: unknown; geom2: unknown }; Returns: number }
        | { Args: { geog1: unknown; geog2: unknown }; Returns: number }
      st_boundingdiagonal: {
        Args: { fits?: boolean; geom: unknown }
        Returns: unknown
      }
      st_buffer:
        | {
            Args: { geom: unknown; options?: string; radius: number }
            Returns: unknown
          }
        | {
            Args: { geom: unknown; quadsegs: number; radius: number }
            Returns: unknown
          }
      st_centroid: { Args: { "": string }; Returns: unknown }
      st_clipbybox2d: {
        Args: { box: unknown; geom: unknown }
        Returns: unknown
      }
      st_closestpoint: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_collect: { Args: { geom1: unknown; geom2: unknown }; Returns: unknown }
      st_concavehull: {
        Args: {
          param_allow_holes?: boolean
          param_geom: unknown
          param_pctconvex: number
        }
        Returns: unknown
      }
      st_contains: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      st_containsproperly: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      st_coorddim: { Args: { geometry: unknown }; Returns: number }
      st_coveredby:
        | { Args: { geog1: unknown; geog2: unknown }; Returns: boolean }
        | { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      st_covers:
        | { Args: { geog1: unknown; geog2: unknown }; Returns: boolean }
        | { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      st_crosses: { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      st_curvetoline: {
        Args: { flags?: number; geom: unknown; tol?: number; toltype?: number }
        Returns: unknown
      }
      st_delaunaytriangles: {
        Args: { flags?: number; g1: unknown; tolerance?: number }
        Returns: unknown
      }
      st_difference: {
        Args: { geom1: unknown; geom2: unknown; gridsize?: number }
        Returns: unknown
      }
      st_disjoint: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      st_distance:
        | { Args: { geom1: unknown; geom2: unknown }; Returns: number }
        | {
            Args: { geog1: unknown; geog2: unknown; use_spheroid?: boolean }
            Returns: number
          }
      st_distancesphere:
        | { Args: { geom1: unknown; geom2: unknown }; Returns: number }
        | {
            Args: { geom1: unknown; geom2: unknown; radius: number }
            Returns: number
          }
      st_distancespheroid: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: number
      }
      st_dwithin: {
        Args: {
          geog1: unknown
          geog2: unknown
          tolerance: number
          use_spheroid?: boolean
        }
        Returns: boolean
      }
      st_equals: { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      st_expand:
        | {
            Args: {
              dm?: number
              dx: number
              dy: number
              dz?: number
              geom: unknown
            }
            Returns: unknown
          }
        | {
            Args: { box: unknown; dx: number; dy: number; dz?: number }
            Returns: unknown
          }
        | { Args: { box: unknown; dx: number; dy: number }; Returns: unknown }
      st_force3d: { Args: { geom: unknown; zvalue?: number }; Returns: unknown }
      st_force3dm: {
        Args: { geom: unknown; mvalue?: number }
        Returns: unknown
      }
      st_force3dz: {
        Args: { geom: unknown; zvalue?: number }
        Returns: unknown
      }
      st_force4d: {
        Args: { geom: unknown; mvalue?: number; zvalue?: number }
        Returns: unknown
      }
      st_generatepoints:
        | { Args: { area: unknown; npoints: number }; Returns: unknown }
        | {
            Args: { area: unknown; npoints: number; seed: number }
            Returns: unknown
          }
      st_geogfromtext: { Args: { "": string }; Returns: unknown }
      st_geographyfromtext: { Args: { "": string }; Returns: unknown }
      st_geohash:
        | { Args: { geog: unknown; maxchars?: number }; Returns: string }
        | { Args: { geom: unknown; maxchars?: number }; Returns: string }
      st_geomcollfromtext: { Args: { "": string }; Returns: unknown }
      st_geometricmedian: {
        Args: {
          fail_if_not_converged?: boolean
          g: unknown
          max_iter?: number
          tolerance?: number
        }
        Returns: unknown
      }
      st_geometryfromtext: { Args: { "": string }; Returns: unknown }
      st_geomfromewkt: { Args: { "": string }; Returns: unknown }
      st_geomfromgeojson:
        | { Args: { "": Json }; Returns: unknown }
        | { Args: { "": Json }; Returns: unknown }
        | { Args: { "": string }; Returns: unknown }
      st_geomfromgml: { Args: { "": string }; Returns: unknown }
      st_geomfromkml: { Args: { "": string }; Returns: unknown }
      st_geomfrommarc21: { Args: { marc21xml: string }; Returns: unknown }
      st_geomfromtext: { Args: { "": string }; Returns: unknown }
      st_gmltosql: { Args: { "": string }; Returns: unknown }
      st_hasarc: { Args: { geometry: unknown }; Returns: boolean }
      st_hausdorffdistance: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: number
      }
      st_hexagon: {
        Args: { cell_i: number; cell_j: number; origin?: unknown; size: number }
        Returns: unknown
      }
      st_hexagongrid: {
        Args: { bounds: unknown; size: number }
        Returns: Record<string, unknown>[]
      }
      st_interpolatepoint: {
        Args: { line: unknown; point: unknown }
        Returns: number
      }
      st_intersection: {
        Args: { geom1: unknown; geom2: unknown; gridsize?: number }
        Returns: unknown
      }
      st_intersects:
        | { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
        | { Args: { geog1: unknown; geog2: unknown }; Returns: boolean }
      st_isvaliddetail: {
        Args: { flags?: number; geom: unknown }
        Returns: Database["public"]["CompositeTypes"]["valid_detail"]
        SetofOptions: {
          from: "*"
          to: "valid_detail"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      st_length:
        | { Args: { geog: unknown; use_spheroid?: boolean }; Returns: number }
        | { Args: { "": string }; Returns: number }
      st_letters: { Args: { font?: Json; letters: string }; Returns: unknown }
      st_linecrossingdirection: {
        Args: { line1: unknown; line2: unknown }
        Returns: number
      }
      st_linefromencodedpolyline: {
        Args: { nprecision?: number; txtin: string }
        Returns: unknown
      }
      st_linefromtext: { Args: { "": string }; Returns: unknown }
      st_linelocatepoint: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: number
      }
      st_linetocurve: { Args: { geometry: unknown }; Returns: unknown }
      st_locatealong: {
        Args: { geometry: unknown; leftrightoffset?: number; measure: number }
        Returns: unknown
      }
      st_locatebetween: {
        Args: {
          frommeasure: number
          geometry: unknown
          leftrightoffset?: number
          tomeasure: number
        }
        Returns: unknown
      }
      st_locatebetweenelevations: {
        Args: { fromelevation: number; geometry: unknown; toelevation: number }
        Returns: unknown
      }
      st_longestline: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_makebox2d: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_makeline: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_makevalid: {
        Args: { geom: unknown; params: string }
        Returns: unknown
      }
      st_maxdistance: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: number
      }
      st_minimumboundingcircle: {
        Args: { inputgeom: unknown; segs_per_quarter?: number }
        Returns: unknown
      }
      st_mlinefromtext: { Args: { "": string }; Returns: unknown }
      st_mpointfromtext: { Args: { "": string }; Returns: unknown }
      st_mpolyfromtext: { Args: { "": string }; Returns: unknown }
      st_multilinestringfromtext: { Args: { "": string }; Returns: unknown }
      st_multipointfromtext: { Args: { "": string }; Returns: unknown }
      st_multipolygonfromtext: { Args: { "": string }; Returns: unknown }
      st_node: { Args: { g: unknown }; Returns: unknown }
      st_normalize: { Args: { geom: unknown }; Returns: unknown }
      st_offsetcurve: {
        Args: { distance: number; line: unknown; params?: string }
        Returns: unknown
      }
      st_orderingequals: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      st_overlaps: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: boolean
      }
      st_perimeter: {
        Args: { geog: unknown; use_spheroid?: boolean }
        Returns: number
      }
      st_pointfromtext: { Args: { "": string }; Returns: unknown }
      st_pointm: {
        Args: {
          mcoordinate: number
          srid?: number
          xcoordinate: number
          ycoordinate: number
        }
        Returns: unknown
      }
      st_pointz: {
        Args: {
          srid?: number
          xcoordinate: number
          ycoordinate: number
          zcoordinate: number
        }
        Returns: unknown
      }
      st_pointzm: {
        Args: {
          mcoordinate: number
          srid?: number
          xcoordinate: number
          ycoordinate: number
          zcoordinate: number
        }
        Returns: unknown
      }
      st_polyfromtext: { Args: { "": string }; Returns: unknown }
      st_polygonfromtext: { Args: { "": string }; Returns: unknown }
      st_project: {
        Args: { azimuth: number; distance: number; geog: unknown }
        Returns: unknown
      }
      st_quantizecoordinates: {
        Args: {
          g: unknown
          prec_m?: number
          prec_x: number
          prec_y?: number
          prec_z?: number
        }
        Returns: unknown
      }
      st_reduceprecision: {
        Args: { geom: unknown; gridsize: number }
        Returns: unknown
      }
      st_relate: { Args: { geom1: unknown; geom2: unknown }; Returns: string }
      st_removerepeatedpoints: {
        Args: { geom: unknown; tolerance?: number }
        Returns: unknown
      }
      st_segmentize: {
        Args: { geog: unknown; max_segment_length: number }
        Returns: unknown
      }
      st_setsrid:
        | { Args: { geom: unknown; srid: number }; Returns: unknown }
        | { Args: { geog: unknown; srid: number }; Returns: unknown }
      st_sharedpaths: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_shortestline: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_simplifypolygonhull: {
        Args: { geom: unknown; is_outer?: boolean; vertex_fraction: number }
        Returns: unknown
      }
      st_split: { Args: { geom1: unknown; geom2: unknown }; Returns: unknown }
      st_square: {
        Args: { cell_i: number; cell_j: number; origin?: unknown; size: number }
        Returns: unknown
      }
      st_squaregrid: {
        Args: { bounds: unknown; size: number }
        Returns: Record<string, unknown>[]
      }
      st_srid:
        | { Args: { geog: unknown }; Returns: number }
        | { Args: { geom: unknown }; Returns: number }
      st_subdivide: {
        Args: { geom: unknown; gridsize?: number; maxvertices?: number }
        Returns: unknown[]
      }
      st_swapordinates: {
        Args: { geom: unknown; ords: unknown }
        Returns: unknown
      }
      st_symdifference: {
        Args: { geom1: unknown; geom2: unknown; gridsize?: number }
        Returns: unknown
      }
      st_symmetricdifference: {
        Args: { geom1: unknown; geom2: unknown }
        Returns: unknown
      }
      st_tileenvelope: {
        Args: {
          bounds?: unknown
          margin?: number
          x: number
          y: number
          zoom: number
        }
        Returns: unknown
      }
      st_touches: { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      st_transform:
        | { Args: { geom: unknown; to_proj: string }; Returns: unknown }
        | {
            Args: { from_proj: string; geom: unknown; to_srid: number }
            Returns: unknown
          }
        | {
            Args: { from_proj: string; geom: unknown; to_proj: string }
            Returns: unknown
          }
      st_triangulatepolygon: { Args: { g1: unknown }; Returns: unknown }
      st_union:
        | { Args: { geom1: unknown; geom2: unknown }; Returns: unknown }
        | {
            Args: { geom1: unknown; geom2: unknown; gridsize: number }
            Returns: unknown
          }
      st_voronoilines: {
        Args: { extend_to?: unknown; g1: unknown; tolerance?: number }
        Returns: unknown
      }
      st_voronoipolygons: {
        Args: { extend_to?: unknown; g1: unknown; tolerance?: number }
        Returns: unknown
      }
      st_within: { Args: { geom1: unknown; geom2: unknown }; Returns: boolean }
      st_wkbtosql: { Args: { wkb: string }; Returns: unknown }
      st_wkttosql: { Args: { "": string }; Returns: unknown }
      st_wrapx: {
        Args: { geom: unknown; move: number; wrap: number }
        Returns: unknown
      }
      test_send_notification: {
        Args: { p_body?: string; p_email: string; p_title?: string }
        Returns: string
      }
      test_shift_continuity_analysis: {
        Args: { p_request_date: string; p_store_id: string; p_user_id: string }
        Returns: {
          group_end_time: string
          group_id: number
          group_start_time: string
          group_type: string
          processing_logic: string
          shift_ids: string
          shifts_count: number
        }[]
      }
      test_shift_notification: {
        Args: { p_minutes_from_now?: number }
        Returns: {
          ret_notification_sent: boolean
          ret_shift_name: string
          ret_start_time: string
          ret_store_name: string
          ret_user_id: string
        }[]
      }
      test_shift_notification_with_timezone: {
        Args: { p_test_time?: string }
        Returns: {
          company_timezone: string
          shift_name: string
          start_time: string
          store_name: string
          user_id: string
          would_send_notification: boolean
        }[]
      }
      test_transaction_filters: {
        Args: { p_company_id: string; p_store_filter_type?: string }
        Returns: {
          entry_count: number
          filter_type: string
          sample_entries: string[]
        }[]
      }
      test_update_shift_requests_v3: {
        Args: { p_store_id?: string; p_test_date?: string; p_user_id?: string }
        Returns: {
          details: string
          result: string
          test_name: string
        }[]
      }
      text_to_bytea: { Args: { data: string }; Returns: string }
      toggle_shift_approval: {
        Args: { p_shift_request_ids: string[]; p_user_id: string }
        Returns: undefined
      }
      unlockrows: { Args: { "": string }; Returns: number }
      update_account_mapping: {
        Args: {
          p_direction?: string
          p_linked_account_id: string
          p_mapping_id: string
          p_my_account_id: string
        }
        Returns: {
          message: string
          success: boolean
        }[]
      }
      update_mirror_journal_cash_location: {
        Args: { p_counterparty_cash_location_id: string; p_journal_id: string }
        Returns: Json
      }
      update_role: {
        Args: {
          p_company_id: string
          p_description?: string
          p_permissions: Json
          p_role_id: string
          p_role_name: string
          p_role_type: string
          p_tags?: Json
        }
        Returns: undefined
      }
      update_shift_request_end: {
        Args: {
          p_actual_end_time?: string
          p_end_lat?: number
          p_end_lng?: number
          p_shift_request_id: string
        }
        Returns: undefined
      }
      update_shift_request_fields:
        | {
            Args: {
              p_actual_end_time?: string
              p_actual_start_time?: string
              p_checkin_latitude?: number
              p_checkin_longitude?: number
              p_checkout_latitude?: number
              p_checkout_longitude?: number
              p_shift_request_id: string
            }
            Returns: undefined
          }
        | {
            Args: {
              p_actual_end_time?: string
              p_actual_start_time?: string
              p_latitude?: number
              p_longitude?: number
              p_shift_request_id: string
            }
            Returns: undefined
          }
      update_shift_requests: {
        Args: {
          p_lat: number
          p_lng: number
          p_request_date: string
          p_store_id: string
          p_time: string
          p_user_id: string
        }
        Returns: undefined
      }
      update_shift_requests_old: {
        Args: {
          p_actual_end_time_text?: string
          p_actual_start_time_text?: string
          p_end_lat?: number
          p_end_lng?: number
          p_shift_request_id: string
          p_start_lat?: number
          p_start_lng?: number
        }
        Returns: undefined
      }
      update_shift_requests_v2: {
        Args: {
          p_lat: number
          p_lng: number
          p_request_date: string
          p_store_id: string
          p_time: string
          p_user_id: string
        }
        Returns: undefined
      }
      update_shift_requests_v2_original_logic: {
        Args: {
          p_lat: number
          p_lng: number
          p_request_date: string
          p_store_id: string
          p_time: string
          p_user_id: string
        }
        Returns: undefined
      }
      update_shift_requests_v3: {
        Args: {
          p_lat?: number
          p_lng?: number
          p_request_date: string
          p_store_id: string
          p_time: string
          p_user_id: string
        }
        Returns: Json
      }
      update_shift_requests_v3_original_logic: {
        Args: {
          p_lat?: number
          p_lng?: number
          p_request_date: string
          p_store_id: string
          p_time: string
          p_user_id: string
        }
        Returns: string
      }
      update_shift_requests_v4: {
        Args: {
          p_lat?: number
          p_lng?: number
          p_request_date: string
          p_store_id: string
          p_time: string
          p_user_id: string
        }
        Returns: Json
      }
      update_shift_requests_v4_original_logic: {
        Args: {
          p_lat?: number
          p_lng?: number
          p_request_date: string
          p_store_id: string
          p_time: string
          p_user_id: string
        }
        Returns: string
      }
      update_store_location: {
        Args: { p_store_id: string; p_store_lat: number; p_store_lng: number }
        Returns: undefined
      }
      update_user_salary:
        | {
            Args: {
              p_salary_amount: number
              p_salary_id: string
              p_salary_type: string
            }
            Returns: undefined
          }
        | {
            Args: {
              p_currency_id: string
              p_salary_amount: number
              p_salary_id: string
              p_salary_type: string
            }
            Returns: undefined
          }
      updategeometrysrid: {
        Args: {
          catalogn_name: string
          column_name: string
          new_srid_in: number
          schema_name: string
          table_name: string
        }
        Returns: string
      }
      urlencode:
        | { Args: { data: Json }; Returns: string }
        | {
            Args: { string: string }
            Returns: {
              error: true
            } & "Could not choose the best candidate function between: public.urlencode(string => bytea), public.urlencode(string => varchar). Try renaming the parameters or the function itself in the database so function overloading can be resolved"
          }
        | {
            Args: { string: string }
            Returns: {
              error: true
            } & "Could not choose the best candidate function between: public.urlencode(string => bytea), public.urlencode(string => varchar). Try renaming the parameters or the function itself in the database so function overloading can be resolved"
          }
      user_shift_cards: {
        Args: {
          p_company_id: string
          p_request_date: string
          p_store_id: string
          p_user_id: string
        }
        Returns: Json
      }
      user_shift_monthly_summary: {
        Args: {
          p_company_id: string
          p_request_date: string
          p_store_id: string
          p_user_id: string
        }
        Returns: Json
      }
      user_shift_overview: {
        Args: {
          p_company_id: string
          p_request_date: string
          p_store_id: string
          p_user_id: string
        }
        Returns: Json
      }
      user_shift_overview_single: {
        Args: {
          p_company_id: string
          p_request_date: string
          p_store_id: string
          p_user_id: string
        }
        Returns: Json
      }
      validate_business_code_format: {
        Args: { p_business_code: string }
        Returns: Json
      }
      validate_journal_balance: {
        Args: { p_lines: Json }
        Returns: Record<string, unknown>
      }
      vault_amount_insert: {
        Args: {
          p_company_id: string
          p_created_at: string
          p_created_by: string
          p_credit: boolean
          p_currency_id: string
          p_debit: boolean
          p_location_id: string
          p_record_date: string
          p_store_id: string
          p_vault_amount_line_json: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      geometry_dump: {
        path: number[] | null
        geom: unknown
      }
      http_header: {
        field: string | null
        value: string | null
      }
      http_request: {
        method: unknown
        uri: string | null
        headers: Database["public"]["CompositeTypes"]["http_header"][] | null
        content_type: string | null
        content: string | null
      }
      http_response: {
        status: number | null
        content_type: string | null
        headers: Database["public"]["CompositeTypes"]["http_header"][] | null
        content: string | null
      }
      valid_detail: {
        valid: boolean | null
        reason: string | null
        location: unknown
      }
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
