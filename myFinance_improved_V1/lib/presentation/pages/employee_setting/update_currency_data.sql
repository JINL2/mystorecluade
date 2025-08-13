-- Update Currency Data to match your actual Supabase database
-- Run this in your Supabase SQL editor

-- First, ensure the currency_types table exists with correct structure
CREATE TABLE IF NOT EXISTS currency_types (
  currency_id TEXT PRIMARY KEY,
  currency_name TEXT NOT NULL,
  symbol TEXT NOT NULL,
  decimal_places INTEGER DEFAULT 2,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clear any existing data and insert the correct currencies
DELETE FROM currency_types;

-- Insert the actual currencies you have (EUR, USD, VND, KRW)
INSERT INTO currency_types (currency_id, currency_name, symbol, decimal_places, is_active) VALUES
  ('USD', 'US Dollar', '$', 2, true),
  ('EUR', 'Euro', '€', 2, true),
  ('VND', 'Vietnamese Dong', '₫', 0, true),
  ('KRW', 'Korean Won', '₩', 0, true);

-- Verify the data was inserted correctly
SELECT * FROM currency_types ORDER BY currency_id;