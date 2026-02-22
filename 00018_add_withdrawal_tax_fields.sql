-- Add tax fields to withdrawals table
ALTER TABLE withdrawals ADD COLUMN IF NOT EXISTS tax_amount NUMERIC(10,2) DEFAULT 0;
ALTER TABLE withdrawals ADD COLUMN IF NOT EXISTS net_amount NUMERIC(10,2) DEFAULT 0;

-- Update existing withdrawals (optional, but good for consistency)
UPDATE withdrawals SET net_amount = amount, tax_amount = 0 WHERE net_amount = 0;

-- Add tax settings to system_settings
INSERT INTO system_settings (key, value) VALUES 
('withdrawal_tax_percent', '2'),
('withdrawal_tax_enabled', 'true')
ON CONFLICT (key) DO NOTHING;
