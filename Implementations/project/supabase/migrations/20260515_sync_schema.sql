-- Migration to synchronize database with DESIGN.md schema
-- Run this in Supabase SQL Editor

-- 1. Update Users Table
ALTER TABLE users ADD COLUMN IF NOT EXISTS national_id text;
ALTER TABLE users ADD COLUMN IF NOT EXISTS "Fname" text;
ALTER TABLE users ADD COLUMN IF NOT EXISTS "Mname" text;
ALTER TABLE users ADD COLUMN IF NOT EXISTS "Lname" text;
ALTER TABLE users ADD COLUMN IF NOT EXISTS "Is_Deleted" boolean DEFAULT false;

-- 2. Update Drug Table
ALTER TABLE drug ADD COLUMN IF NOT EXISTS rate_unit character varying(10);
ALTER TABLE drug ADD COLUMN IF NOT EXISTS hard_limit_high numeric;
ALTER TABLE drug ADD COLUMN IF NOT EXISTS soft_limit_high numeric;
ALTER TABLE drug ADD COLUMN IF NOT EXISTS "Is_Deleted" boolean DEFAULT false;

-- 3. Update Infusion Session Table
ALTER TABLE infusion_session ADD COLUMN IF NOT EXISTS "Patient_id" uuid;
ALTER TABLE infusion_session ADD COLUMN IF NOT EXISTS patient_weight numeric DEFAULT 70.0;
ALTER TABLE infusion_session ADD COLUMN IF NOT EXISTS target_dose numeric;
ALTER TABLE infusion_session ADD COLUMN IF NOT EXISTS dose_unit text DEFAULT 'mcg/kg/min';

-- 4. Create Alarms Definitions Table
CREATE TABLE IF NOT EXISTS alarms (
    alarm_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    alarm_name text UNIQUE NOT NULL,
    severity text NOT NULL,
    description text NOT NULL
);

-- 5. Refactor Alarm Table
DO $$ 
BEGIN
    -- Rename only if it hasn't been renamed yet
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='alarm' AND column_name='alarm_id' AND data_type='uuid') THEN
        ALTER TABLE alarm RENAME COLUMN alarm_id TO event_id;
    END IF;
END $$;

ALTER TABLE alarm ADD COLUMN IF NOT EXISTS alarm_id uuid REFERENCES alarms(alarm_id);
ALTER TABLE alarm ADD COLUMN IF NOT EXISTS alarm_time timestamp without time zone DEFAULT now();
ALTER TABLE alarm ADD COLUMN IF NOT EXISTS ack_res boolean DEFAULT false;
ALTER TABLE alarm ADD COLUMN IF NOT EXISTS ack_res_by uuid REFERENCES users(user_id);
ALTER TABLE alarm ADD COLUMN IF NOT EXISTS ack_res_at timestamp without time zone;

-- 6. Audit Log cleanup
ALTER TABLE audit_log DROP CONSTRAINT IF EXISTS audit_log_entity_id_fkey;
ALTER TABLE audit_log DROP COLUMN IF EXISTS session_id;
ALTER TABLE audit_log DROP COLUMN IF EXISTS ip_address;

-- 7. Seed initial Alarms
INSERT INTO alarms (alarm_name, severity, description)
VALUES 
('OCCLUSION', 'HIGH', 'Physical obstruction in the infusion line detected.'),
('AIR IN LINE', 'CRITICAL', 'Air bubble detected in the tubing. Delivery stopped.'),
('BATTERY LOW', 'MEDIUM', 'Battery level below 20%. Please connect to AC power.'),
('BATTERY CRITICAL', 'CRITICAL', 'Battery level below 5%. Shutdown imminent.'),
('HARD LIMIT EXCEEDED', 'CRITICAL', 'Attempted rate exceeds clinical hard safety limits.'),
('SOFT LIMIT WARNING', 'MEDIUM', 'Infusion rate is outside normal clinical bounds.'),
('EMERGENCY STOP', 'CRITICAL', 'Manual emergency stop triggered by clinician.')
ON CONFLICT (alarm_name) DO NOTHING;
