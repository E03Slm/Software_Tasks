-- ============================================================
-- Smart Infusion Pump Simulator
-- PostgreSQL Database — Complete Seed Script
-- ============================================================
-- FIXES APPLIED:
--   1. Merged split INSERT INTO users/drug statements into one
--   2. Replaced broken nested DO $$ blocks with one correct block
--      that uses real session/user IDs (no dangling uuid_generate_v4 FKs)
--   3. Removed session 16 (Albumin 5%) — drug not in drug table
--   4. alarm seed rows 1-4 rewritten to reference real session IDs
-- ============================================================

-- ============================================================
-- SECTION 1: EXTENSIONS
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- SECTION 2: TABLE DEFINITIONS
-- ============================================================

-- 2.1 Users
CREATE TABLE users (
    user_id       UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    username      VARCHAR(50)  NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          VARCHAR(20)  NOT NULL,
    created_at    TIMESTAMP    NOT NULL DEFAULT NOW(),
    last_login    TIMESTAMP
);

-- 2.2 Drug Library
CREATE TABLE drug (
    drug_id            UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    name               VARCHAR(100)  NOT NULL UNIQUE,
    concentration      DECIMAL(10,2) NOT NULL,
    concentration_unit VARCHAR(20)   NOT NULL,
    default_rate       DECIMAL(10,2) NOT NULL,
    rate_unit          VARCHAR(10)   DEFAULT 'mL/hr',
    hard_limit_low     DECIMAL(10,2) NOT NULL,
    hard_limit_high    DECIMAL(10,2) NOT NULL,
    soft_limit_low     DECIMAL(10,2),
    soft_limit_high    DECIMAL(10,2),
    created_by         UUID          REFERENCES users(user_id),
    created_at         TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_by         UUID          REFERENCES users(user_id),
    updated_at         TIMESTAMP
);

-- 2.3 Infusion Sessions
CREATE TABLE infusion_session (
    session_id     UUID          PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id        UUID          REFERENCES users(user_id),
    drug_id        UUID          REFERENCES drug(drug_id),
    rate           DECIMAL(10,2) NOT NULL,
    total_volume   DECIMAL(10,2) NOT NULL,
    volume_infused DECIMAL(10,2) DEFAULT 0,
    status         VARCHAR(20)   NOT NULL DEFAULT 'Idle',
    start_time     TIMESTAMP,
    end_time       TIMESTAMP,
    bolus_enabled  BOOLEAN       DEFAULT FALSE,
    kvo_enabled    BOOLEAN       DEFAULT FALSE,
    kvo_rate       DECIMAL(10,2),
    battery_level  INT           DEFAULT 100
);

-- 2.4 Alarms
CREATE TABLE alarm (
    alarm_id        UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id      UUID        REFERENCES infusion_session(session_id),
    type            VARCHAR(30) NOT NULL,
    severity        VARCHAR(20) NOT NULL,
    timestamp       TIMESTAMP   NOT NULL DEFAULT NOW(),
    acknowledged    BOOLEAN     DEFAULT FALSE,
    acknowledged_by UUID        REFERENCES users(user_id),
    acknowledged_at TIMESTAMP,
    resolved        BOOLEAN     DEFAULT FALSE,
    resolved_at     TIMESTAMP,
    description     TEXT
);

-- 2.5 Audit Log
CREATE TABLE audit_log (
    log_id      UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID         REFERENCES users(user_id),
    action      VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id   UUID,
    old_value   TEXT,
    new_value   TEXT,
    timestamp   TIMESTAMP    NOT NULL DEFAULT NOW(),
    ip_address  VARCHAR(45),
    session_id  UUID
);

-- 2.6 System Configuration
CREATE TABLE system_configuration (
    config_id   UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    key         VARCHAR(100) NOT NULL UNIQUE,
    value       TEXT         NOT NULL,
    description TEXT,
    updated_by  UUID         REFERENCES users(user_id),
    updated_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 2.7 Test Scenarios
CREATE TABLE test_scenario (
    scenario_id UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        VARCHAR(100) NOT NULL,
    description TEXT,
    script      TEXT         NOT NULL,
    created_by  UUID         REFERENCES users(user_id),
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 2.8 Test Executions
CREATE TABLE test_execution (
    execution_id   UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    scenario_id    UUID        REFERENCES test_scenario(scenario_id),
    executed_by    UUID        REFERENCES users(user_id),
    executed_at    TIMESTAMP   NOT NULL DEFAULT NOW(),
    status         VARCHAR(20) NOT NULL,
    result_details TEXT
);

-- 2.9 Reports
CREATE TABLE report (
    report_id    UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    type         VARCHAR(30) NOT NULL,
    generated_by UUID        REFERENCES users(user_id),
    generated_at TIMESTAMP   NOT NULL DEFAULT NOW(),
    parameters   TEXT,
    file_path    VARCHAR(255),
    format       VARCHAR(10) DEFAULT 'PDF'
);

-- 2.10 Event Log
CREATE TABLE event_log (
    event_id    UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id  UUID        REFERENCES infusion_session(session_id),
    event_type  VARCHAR(50) NOT NULL,
    description TEXT        NOT NULL,
    timestamp   TIMESTAMP   NOT NULL DEFAULT NOW(),
    user_id     UUID        REFERENCES users(user_id)
);

-- ============================================================
-- SECTION 3: INSERT users  (20 rows — merged into one statement)
-- ============================================================

INSERT INTO users (user_id, username, password_hash, role, created_at)
VALUES
-- System Admins
(uuid_generate_v4(), 'admin_sarah',   '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.',  'Admin',  NOW() - INTERVAL '30 days'),
(uuid_generate_v4(), 'sys_mike',      '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.',  'Admin',  NOW() - INTERVAL '25 days'),
(uuid_generate_v4(), 'it_support_1',  '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Admin',  NOW() - INTERVAL '45 days'),
(uuid_generate_v4(), 'it_support_2',  '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Admin',  NOW() - INTERVAL '40 days'),
(uuid_generate_v4(), 'it_lead_hend',  '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Admin',  NOW() - INTERVAL '38 days'),

-- Doctors
(uuid_generate_v4(), 'dr_ahmed',      '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.',  'Doctor', NOW() - INTERVAL '20 days'),
(uuid_generate_v4(), 'dr_elena',      '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.',  'Doctor', NOW() - INTERVAL '15 days'),
(uuid_generate_v4(), 'dr_kovac',      '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Doctor', NOW() - INTERVAL '18 days'),
(uuid_generate_v4(), 'dr_smith',      '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Doctor', NOW() - INTERVAL '12 days'),

-- Nurses
(uuid_generate_v4(), 'nurse_john',    '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.',  'Nurse',  NOW() - INTERVAL '10 days'),
(uuid_generate_v4(), 'nurse_layla',   '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.',  'Nurse',  NOW() - INTERVAL '5 days'),
(uuid_generate_v4(), 'nurse_omar',    '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.',  'Nurse',  NOW() - INTERVAL '2 days'),
(uuid_generate_v4(), 'nurse_chen',    '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.',  'Nurse',  NOW() - INTERVAL '1 day'),
(uuid_generate_v4(), 'nurse_maria',   '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.',  'Nurse',  NOW()),
(uuid_generate_v4(), 'nurse_sam',     '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Nurse',  NOW()),
(uuid_generate_v4(), 'nurse_fatima',  '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Nurse',  NOW() - INTERVAL '12 hours'),
(uuid_generate_v4(), 'nurse_robert',  '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Nurse',  NOW() - INTERVAL '8 hours'),
(uuid_generate_v4(), 'nurse_yuki',    '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Nurse',  NOW() - INTERVAL '6 hours'),
(uuid_generate_v4(), 'nurse_gabriel', '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Nurse',  NOW() - INTERVAL '4 hours'),
(uuid_generate_v4(), 'nurse_sana',    '$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.', 'Nurse',  NOW() - INTERVAL '2 hours');

-- ============================================================
-- SECTION 4: INSERT drug  (19 drugs — merged into one statement)
-- ============================================================

INSERT INTO drug (name, concentration, concentration_unit, default_rate, rate_unit,
                  hard_limit_low, hard_limit_high, soft_limit_low, soft_limit_high, created_by)
VALUES
-- 1. Heparin (High Alert)
('Heparin',
 100.00, 'units/mL', 12.50, 'mL/hr', 1.00, 40.00, 5.00, 25.00,
 (SELECT user_id FROM users WHERE username = 'dr_ahmed')),

-- 2. Insulin Regular
('Insulin Regular',
 1.00, 'units/mL', 2.00, 'mL/hr', 0.10, 20.00, 0.50, 10.00,
 (SELECT user_id FROM users WHERE username = 'dr_elena')),

-- 3. Morphine
('Morphine',
 1.00, 'mg/mL', 1.00, 'mL/hr', 0.50, 10.00, 1.00, 5.00,
 (SELECT user_id FROM users WHERE username = 'dr_ahmed')),

-- 4. Dopamine
('Dopamine',
 1.60, 'mg/mL', 5.00, 'mL/hr', 1.00, 50.00, 2.00, 20.00,
 (SELECT user_id FROM users WHERE username = 'dr_elena')),

-- 5. Magnesium Sulfate
('Magnesium Sulfate',
 40.00, 'mg/mL', 25.00, 'mL/hr', 5.00, 100.00, 10.00, 50.00,
 (SELECT user_id FROM users WHERE username = 'dr_ahmed')),

-- 6. Potassium Chloride
('Potassium Chloride',
 0.20, 'mEq/mL', 10.00, 'mL/hr', 2.00, 20.00, 5.00, 15.00,
 (SELECT user_id FROM users WHERE username = 'dr_elena')),

-- 7. Propofol
('Propofol',
 10.00, 'mg/mL', 5.00, 'mL/hr', 1.00, 50.00, 5.00, 30.00,
 (SELECT user_id FROM users WHERE username = 'dr_ahmed')),

-- 8. Normal Saline 0.9%
('Normal Saline 0.9%',
 0.00, 'N/A', 100.00, 'mL/hr', 1.00, 999.00, 10.00, 500.00,
 (SELECT user_id FROM users WHERE username = 'dr_elena')),

-- 9. Fentanyl
('Fentanyl',
 50.00, 'mcg/mL', 2.00, 'mL/hr', 0.50, 20.00, 1.00, 10.00,
 (SELECT user_id FROM users WHERE username = 'dr_ahmed')),

-- 10. Oxytocin
('Oxytocin',
 10.00, 'units/L', 6.00, 'mL/hr', 1.00, 40.00, 2.00, 20.00,
 (SELECT user_id FROM users WHERE username = 'dr_elena')),

-- 11. Epinephrine
('Epinephrine',
 0.10, 'mg/mL', 2.00, 'mL/hr', 0.10, 30.00, 1.00, 15.00,
 (SELECT user_id FROM users WHERE username = 'dr_ahmed')),

-- 12. Amiodarone
('Amiodarone',
 1.80, 'mg/mL', 33.30, 'mL/hr', 10.00, 100.00, 20.00, 50.00,
 (SELECT user_id FROM users WHERE username = 'dr_elena')),

-- 13. Vancomycin
('Vancomycin',
 5.00, 'mg/mL', 100.00, 'mL/hr', 20.00, 250.00, 50.00, 200.00,
 (SELECT user_id FROM users WHERE username = 'dr_ahmed')),

-- 14. Norepinephrine
('Norepinephrine',
 0.06, 'mg/mL', 5.00, 'mL/hr', 0.10, 60.00, 2.00, 40.00,
 (SELECT user_id FROM users WHERE username = 'dr_elena')),

-- 15. Dextrose 5%
('Dextrose 5%',
 0.00, 'N/A', 75.00, 'mL/hr', 1.00, 500.00, 10.00, 250.00,
 (SELECT user_id FROM users WHERE username = 'dr_ahmed')),

-- 16. Lidocaine
('Lidocaine',
 4.00, 'mg/mL', 15.00, 'mL/hr', 5.00, 60.00, 10.00, 45.00,
 (SELECT user_id FROM users WHERE username = 'dr_elena')),

-- 17. Midazolam
('Midazolam',
 1.00, 'mg/mL', 2.00, 'mL/hr', 0.50, 15.00, 1.00, 10.00,
 (SELECT user_id FROM users WHERE username = 'dr_ahmed')),

-- 18. Furosemide
('Furosemide',
 10.00, 'mg/mL', 4.00, 'mL/hr', 1.00, 20.00, 2.00, 10.00,
 (SELECT user_id FROM users WHERE username = 'dr_elena')),

-- 19. Heparin (Pediatric)
('Heparin (Peds)',
 10.00, 'units/mL', 1.00, 'mL/hr', 0.10, 10.00, 0.50, 5.00,
 (SELECT user_id FROM users WHERE username = 'dr_elena'));

-- ============================================================
-- SECTION 5: INSERT infusion_session  (19 sessions)
-- NOTE: Session 16 (Albumin 5%) removed — drug not in drug table.
--       To restore it, first INSERT the drug, then add the session.
-- ============================================================

-- 1. Normal Saline — Nearly Finished
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time, battery_level)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_john'),
    (SELECT drug_id FROM drug WHERE name = 'Normal Saline 0.9%'),
    125.00, 1000.00, 950.00, 'Infusing', NOW() - INTERVAL '8 hours', 85
);

-- 2. Heparin — Recently Started, Bolus Enabled
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time, bolus_enabled)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_layla'),
    (SELECT drug_id FROM drug WHERE name = 'Heparin'),
    12.50, 500.00, 15.20, 'Infusing', NOW() - INTERVAL '1 hour', TRUE
);

-- 3. Insulin Regular — Stopped (Occlusion)
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_omar'),
    (SELECT drug_id FROM drug WHERE name = 'Insulin Regular'),
    2.00, 50.00, 5.50, 'Stopped', NOW() - INTERVAL '30 minutes'
);

-- 4. Morphine — KVO Mode Active
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, kvo_enabled, kvo_rate)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_chen'),
    (SELECT drug_id FROM drug WHERE name = 'Morphine'),
    1.00, 100.00, 100.00, 'KVO', TRUE, 0.10
);

-- 5. Epinephrine — Low Battery Warning
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, battery_level)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_maria'),
    (SELECT drug_id FROM drug WHERE name = 'Epinephrine'),
    2.00, 50.00, 12.00, 'Infusing', 12
);

-- 6. Vancomycin — Completed
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time, end_time)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_fatima'),
    (SELECT drug_id FROM drug WHERE name = 'Vancomycin'),
    100.00, 250.00, 250.00, 'Completed',
    NOW() - INTERVAL '4 hours', NOW() - INTERVAL '90 minutes'
);

-- 7. Propofol — Active
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_robert'),
    (SELECT drug_id FROM drug WHERE name = 'Propofol'),
    15.00, 500.00, 200.00, 'Infusing', NOW() - INTERVAL '3 hours'
);

-- 8. Heparin (Peds) — Stopped, Door Open
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_yuki'),
    (SELECT drug_id FROM drug WHERE name = 'Heparin (Peds)'),
    1.00, 20.00, 2.10, 'Stopped', NOW() - INTERVAL '20 minutes'
);

-- 9. Magnesium Sulfate — Idle
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_sana'),
    (SELECT drug_id FROM drug WHERE name = 'Magnesium Sulfate'),
    25.00, 100.00, 0.00, 'Idle'
);

-- 10. Potassium Chloride — Active
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_gabriel'),
    (SELECT drug_id FROM drug WHERE name = 'Potassium Chloride'),
    10.00, 100.00, 45.00, 'Infusing', NOW() - INTERVAL '4 hours'
);

-- 11. Norepinephrine — Emergency High Rate
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time, battery_level)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_fatima'),
    (SELECT drug_id FROM drug WHERE name = 'Norepinephrine'),
    15.00, 250.00, 45.30, 'Infusing', NOW() - INTERVAL '2 hours', 98
);

-- 12. Fentanyl — Recently Started, Bolus Enabled
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time, bolus_enabled)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_robert'),
    (SELECT drug_id FROM drug WHERE name = 'Fentanyl'),
    2.50, 100.00, 5.00, 'Infusing', NOW() - INTERVAL '15 minutes', TRUE
);

-- 13. Dextrose 5% — Critical Battery
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, battery_level)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_yuki'),
    (SELECT drug_id FROM drug WHERE name = 'Dextrose 5%'),
    75.00, 500.00, 480.00, 'Infusing', 5
);

-- 14. Amiodarone — Stopped (Air-in-Line)
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_gabriel'),
    (SELECT drug_id FROM drug WHERE name = 'Amiodarone'),
    33.30, 100.00, 12.40, 'Stopped', NOW() - INTERVAL '40 minutes'
);

-- 15. Propofol — Completed
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time, end_time)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_sana'),
    (SELECT drug_id FROM drug WHERE name = 'Propofol'),
    10.00, 200.00, 200.00, 'Completed',
    NOW() - INTERVAL '6 hours', NOW() - INTERVAL '2 hours'
);

-- 17. Oxytocin — Labor Support
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_layla'),
    (SELECT drug_id FROM drug WHERE name = 'Oxytocin'),
    6.00, 500.00, 32.00, 'Infusing', NOW() - INTERVAL '1 hour'
);

-- 18. Furosemide — KVO Active
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, kvo_enabled, kvo_rate)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_john'),
    (SELECT drug_id FROM drug WHERE name = 'Furosemide'),
    4.00, 50.00, 50.00, 'KVO', TRUE, 0.50
);

-- 19. Midazolam — Stopped Manually
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_chen'),
    (SELECT drug_id FROM drug WHERE name = 'Midazolam'),
    2.00, 100.00, 85.00, 'Stopped', NOW() - INTERVAL '3 hours'
);

-- 20. Lidocaine — Cardiac Active
INSERT INTO infusion_session (user_id, drug_id, rate, total_volume, volume_infused, status, start_time)
VALUES (
    (SELECT user_id FROM users WHERE username = 'nurse_omar'),
    (SELECT drug_id FROM drug WHERE name = 'Lidocaine'),
    15.00, 250.00, 110.00, 'Infusing', NOW() - INTERVAL '5 hours'
);

-- ============================================================
-- SECTION 6: INSERT alarm  (4 manual rows using real session IDs)
-- ============================================================

INSERT INTO alarm (alarm_id, session_id, type, severity, timestamp,
                   acknowledged, acknowledged_by, acknowledged_at,
                   resolved, resolved_at, description)
VALUES

-- Row 1: Active Occlusion
(uuid_generate_v4(),
 (SELECT session_id FROM infusion_session ORDER BY start_time NULLS LAST LIMIT 1 OFFSET 0),
 'Occlusion', 'High', NOW() - INTERVAL '10 minutes',
 FALSE, NULL, NULL, FALSE, NULL,
 'Pressure limit exceeded in the IV line.'),

-- Row 2: Acknowledged Air in Line
(uuid_generate_v4(),
 (SELECT session_id FROM infusion_session ORDER BY start_time NULLS LAST LIMIT 1 OFFSET 1),
 'Air in Line', 'Critical', NOW() - INTERVAL '1 hour',
 TRUE,
 (SELECT user_id FROM users WHERE username = 'nurse_robert'),
 NOW() - INTERVAL '55 minutes',
 FALSE, NULL,
 'Large air bubble detected in chamber.'),

-- Row 3: Resolved Low Battery
(uuid_generate_v4(),
 (SELECT session_id FROM infusion_session ORDER BY start_time NULLS LAST LIMIT 1 OFFSET 2),
 'Low Battery', 'Medium', NOW() - INTERVAL '5 hours',
 TRUE,
 (SELECT user_id FROM users WHERE username = 'nurse_john'),
 NOW() - INTERVAL '4 hours',
 TRUE, NOW() - INTERVAL '3 hours',
 'Battery level below 15%. Plugged into AC.'),

-- Row 4: Door Open
(uuid_generate_v4(),
 (SELECT session_id FROM infusion_session ORDER BY start_time NULLS LAST LIMIT 1 OFFSET 3),
 'Door Open', 'High', NOW() - INTERVAL '2 minutes',
 FALSE, NULL, NULL, FALSE, NULL,
 'Pump door opened during active infusion.');

-- ============================================================
-- SECTION 7: DO $$ BLOCK — Bulk alarm generation (100 rows)
-- FIXED: Single correct block using real session/user IDs
-- ============================================================

DO $$
DECLARE
    rand_session_id UUID;
    rand_user_id    UUID;
BEGIN
    FOR i IN 1..100 LOOP

        -- Pick a random existing session
        SELECT session_id INTO rand_session_id
        FROM   infusion_session
        ORDER  BY random()
        LIMIT  1;

        -- Pick a random existing user
        SELECT user_id INTO rand_user_id
        FROM   users
        ORDER  BY random()
        LIMIT  1;

        -- Only insert when a valid session exists
        IF rand_session_id IS NOT NULL THEN
            INSERT INTO alarm (
                alarm_id,
                session_id,
                type,
                severity,
                timestamp,
                acknowledged,
                acknowledged_by,
                resolved,
                description
            ) VALUES (
                uuid_generate_v4(),
                rand_session_id,
                (ARRAY['Occlusion', 'Air in Line', 'Low Battery', 'Complete', 'Flow Error'])[floor(random() * 5 + 1)],
                (ARRAY['Low', 'Medium', 'High', 'Critical'])[floor(random() * 4 + 1)],
                NOW() - (random() * INTERVAL '7 days'),
                (random() > 0.5),
                CASE WHEN random() > 0.5 THEN rand_user_id ELSE NULL END,
                (random() > 0.7),
                'Automated simulation test alarm #' || i
            );
        END IF;

    END LOOP;
END $$;

-- ============================================================
-- SECTION 8: INSERT system_configuration  (20 rows)
-- ============================================================

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('alarm_volume', '8',
        'Master volume level for all audible alerts (Range: 1-10).',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('low_battery_threshold', '15',
        'Percentage at which the "Low Battery" medium-severity warning is triggered.',
        (SELECT user_id FROM users WHERE username = 'sys_mike'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('default_kvo_rate', '0.5',
        'The default rate used when an infusion completes and Keep Vein Open mode starts.',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('max_hardware_rate', '999.0',
        'The absolute maximum rate the pump motor can physically support (mL/hr).',
        (SELECT user_id FROM users WHERE username = 'sys_mike'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('wifi_ssid', 'HOSPITAL_SECURE_EXT',
        'The network name used for wireless data synchronization with the mobile app.',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('occlusion_sensitivity', '500',
        'Downstream pressure threshold that triggers an Occlusion Alarm.',
        (SELECT user_id FROM users WHERE username = 'sys_mike'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('screen_brightness', '75',
        'Default display brightness level for the pump physical interface.',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('audit_retention_days', '365',
        'How long logs are stored locally before being archived or deleted.',
        (SELECT user_id FROM users WHERE username = 'sys_mike'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('ui_auto_lock', '60',
        'Time in seconds before the screen locks to prevent accidental changes.',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('maintenance_due_months', '12',
        'Schedule for technical inspection and calibration of sensors.',
        (SELECT user_id FROM users WHERE username = 'sys_mike'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('log_near_miss_events', 'TRUE',
        'If enabled, the system logs attempts to enter doses that were blocked by Hard Limits.',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('drug_library_version', '2026.04.v1',
        'The current version of the clinical drug limits database installed on the pump.',
        (SELECT user_id FROM users WHERE username = 'sys_mike'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('max_bolus_allowed', '20.0',
        'The absolute maximum volume allowed for a single bolus burst regardless of drug type.',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('sync_interval_sec', '30',
        'How often the pump pushes real-time event logs to the central hospital server.',
        (SELECT user_id FROM users WHERE username = 'sys_mike'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('system_language', 'English/Arabic',
        'The primary and secondary languages for the pump display and alarm messages.',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('air_bubble_threshold_ul', '50',
        'The minimum size of a single air bubble required to trigger a Critical Stop alarm.',
        (SELECT user_id FROM users WHERE username = 'sys_mike'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('battery_shutdown_threshold', '3',
        'The battery percentage at which the pump will perform a controlled emergency stop.',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('require_pin_for_bolus', 'TRUE',
        'Whether the system requires the user to re-enter a PIN before starting a bolus.',
        (SELECT user_id FROM users WHERE username = 'sys_mike'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('alarm_pitch_hz', '440',
        'The frequency of the alarm sound. Used for customizing alert tones in different wards.',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'));

INSERT INTO system_configuration (key, value, description, updated_by)
VALUES ('pump_asset_id', 'PUMP-ICU-099',
        'Unique identifier for the physical hardware unit within the hospital network.',
        (SELECT user_id FROM users WHERE username = 'sys_mike'));

-- ============================================================
-- SECTION 9: INSERT test_scenario  (20 scenarios)
-- ============================================================

-- 1. Normal Operation Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Baseline Saline Infusion',
    'Simulates a standard 1-hour saline infusion at 100mL/hr to verify volume accuracy.',
    '{ "steps": [{"action": "set_drug", "value": "Normal Saline 0.9%"}, {"action": "set_rate", "value": 100}, {"action": "start"}] }',
    (SELECT user_id FROM users WHERE username = 'dr_ahmed')
);

-- 2. Hard Limit Violation Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Heparin Overdose Protection',
    'Tests if the system correctly rejects a rate higher than 40mL/hr for Heparin.',
    '{ "steps": [{"action": "set_drug", "value": "Heparin"}, {"action": "set_rate", "value": 50}, {"action": "verify_error", "type": "Hard Limit"}] }',
    (SELECT user_id FROM users WHERE username = 'dr_elena')
);

-- 3. Occlusion Response Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Downstream Blockage Simulation',
    'Starts an infusion and triggers a high-pressure occlusion alarm after 30 seconds.',
    '{ "steps": [{"action": "start_infusion"}, {"delay": 30}, {"action": "trigger_sensor", "type": "occlusion", "value": "high"}] }',
    (SELECT user_id FROM users WHERE username = 'sys_mike')
);

-- 4. Air-in-Line Emergency Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Air Bubble Detection',
    'Verifies immediate motor shutdown when the ultrasonic sensor detects air.',
    '{ "steps": [{"action": "start_infusion"}, {"action": "inject_air", "size": "60ul"}, {"action": "verify_status", "value": "Stopped"}] }',
    (SELECT user_id FROM users WHERE username = 'dr_ahmed')
);

-- 5. Battery Depletion Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Low Battery to Shutdown',
    'Simulates rapid battery drop to test warning and critical shutdown levels.',
    '{ "steps": [{"set_battery": 20}, {"wait": 10}, {"set_battery": 14}, {"verify_alarm": "Low Battery"}] }',
    (SELECT user_id FROM users WHERE username = 'admin_sarah')
);

-- 6. KVO Transition Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'VTBI Completion Logic',
    'Simulates reaching the end of the infusion bag to verify KVO mode activation.',
    '{ "steps": [{"set_vtbi": 1.0}, {"action": "infuse_all"}, {"verify_mode": "KVO"}] }',
    (SELECT user_id FROM users WHERE username = 'dr_elena')
);

-- 7. Door Safety Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Safety Interlock Check',
    'Attempts to open the pump door while the motor is active.',
    '{ "steps": [{"action": "start"}, {"action": "open_door"}, {"verify_alarm": "Door Open"}] }',
    (SELECT user_id FROM users WHERE username = 'sys_mike')
);

-- 8. Pediatric Safety Profile Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Pediatric Limit Validation',
    'Checks if the lower safety limits are correctly applied for pediatric concentrations.',
    '{ "steps": [{"set_drug": "Heparin (Peds)"}, {"set_rate": 0.05}, {"verify_error": "Hard Limit Low"}] }',
    (SELECT user_id FROM users WHERE username = 'dr_ahmed')
);

-- 9. Connectivity Loss Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'WiFi Disconnection Recovery',
    'Simulates a WiFi drop and verifies that the pump continues to infuse safely offline.',
    '{ "steps": [{"action": "start"}, {"action": "disable_wifi"}, {"verify_infusion": "Active"}] }',
    (SELECT user_id FROM users WHERE username = 'admin_sarah')
);

-- 10. Multi-Alarm Priority Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Dual Alarm Sorting',
    'Triggers a Low Battery followed by an Occlusion to test alarm priority sorting.',
    '{ "steps": [{"trigger": "Low Battery"}, {"trigger": "Occlusion"}, {"verify_priority": "Occlusion"}] }',
    (SELECT user_id FROM users WHERE username = 'sys_mike')
);

-- 11. Night Mode Transition Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Auto-Dimming Check',
    'Tests if the UI brightness dims automatically during night hours to prevent patient disturbance.',
    '{ "steps": [{"set_system_time": "23:00"}, {"action": "check_brightness", "expected": "<30%"}, {"verify": "Night Mode Active"}] }',
    (SELECT user_id FROM users WHERE username = 'admin_sarah')
);

-- 12. STAT Bolus Emergency Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Emergency Bolus Overload',
    'Simulates a rapid sequence of bolus requests to test motor stability and volume tracking.',
    '{ "steps": [{"action": "bolus", "vol": "5ml"}, {"delay": 2}, {"action": "bolus", "vol": "5ml"}, {"verify_total_infused": "10ml"}] }',
    (SELECT user_id FROM users WHERE username = 'dr_ahmed')
);

-- 13. Power Source Switching
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'AC to Battery Seamless Transition',
    'Simulates pulling the plug during an active infusion to ensure the motor doesn''t stutter.',
    '{ "steps": [{"action": "start"}, {"action": "disconnect_ac"}, {"verify_status": "Infusing"}, {"verify_source": "Battery"}] }',
    (SELECT user_id FROM users WHERE username = 'sys_mike')
);

-- 14. Nurse Handover Simulation
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'User Session Timeout',
    'Tests if the system logs out the current user after inactivity but keeps the infusion running.',
    '{ "steps": [{"action": "login"}, {"action": "start"}, {"idle": 300}, {"verify_user": "Logged Out"}, {"verify_pump": "Running"}] }',
    (SELECT user_id FROM users WHERE username = 'admin_sarah')
);

-- 15. Invalid Drug Library Update
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Corrupt Library Rollback',
    'Attempts to upload a drug library with invalid JSON and verifies system stays on old version.',
    '{ "steps": [{"action": "upload_library", "file": "corrupt.json"}, {"verify_error": "Invalid Format"}, {"verify_version": "current"}] }',
    (SELECT user_id FROM users WHERE username = 'sys_mike')
);

-- 16. Rapid Pressure Spike (Occlusion)
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Transient Occlusion Filter',
    'Simulates a 1-second pressure spike (patient moving arm) to see if the pump ignores "noise".',
    '{ "steps": [{"action": "start"}, {"trigger_pressure": "600mmHg", "duration": "1s"}, {"verify_alarm": "None"}] }',
    (SELECT user_id FROM users WHERE username = 'dr_elena')
);

-- 17. Air-in-Line Cumulative Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Cumulative Air Bubble Limit',
    'Triggers 5 tiny bubbles (10uL each) to test if the pump stops once the total air reaches 50uL.',
    '{ "steps": [{"repeat": 5, "do": [{"inject_air": "10ul"}, {"delay": 60}]}, {"verify_alarm": "Air-in-Line"}] }',
    (SELECT user_id FROM users WHERE username = 'dr_ahmed')
);

-- 18. Maintenance Calibration Check
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Motor Calibration Protocol',
    'Runs the motor at 10 different speeds to verify the flow sensor readings match the input.',
    '{ "steps": [{"sweep_rates": [1, 10, 50, 100, 500, 999]}, {"action": "calibrate_sensors"}] }',
    (SELECT user_id FROM users WHERE username = 'sys_mike')
);

-- 19. Unauthorized Access Attempt
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    'Drug Library Lockout',
    'Tests if a user with "Nurse" role is blocked from editing drug concentration levels.',
    '{ "steps": [{"login_as": "nurse_john"}, {"action": "edit_drug", "id": "any"}, {"verify_status": "Access Denied"}] }',
    (SELECT user_id FROM users WHERE username = 'admin_sarah')
);

-- 20. Long-Duration Stability Test
INSERT INTO test_scenario (name, description, script, created_by)
VALUES (
    '24-Hour Continuous Run',
    'Simulates a very long infusion to check for memory leaks or clock drift in the simulator.',
    '{ "steps": [{"action": "start"}, {"simulate_time_passage": "24h"}, {"verify_volume": "calculated_vs_actual"}] }',
    (SELECT user_id FROM users WHERE username = 'sys_mike')
);

-- ============================================================
-- SECTION 10: INSERT test_execution  (20 rows)
-- ============================================================

-- 1. Successful Baseline Test
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Baseline Saline Infusion'),
    (SELECT user_id FROM users WHERE username = 'sys_mike'),
    NOW() - INTERVAL '2 days', 'Passed',
    'Volume accuracy verified at 99.8%. Flow rate stable throughout 1-hour simulation.'
);

-- 2. Successful Hard Limit Protection
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Heparin Overdose Protection'),
    (SELECT user_id FROM users WHERE username = 'dr_ahmed'),
    NOW() - INTERVAL '1 day', 'Passed',
    'System correctly blocked input of 50mL/hr. "Hard Limit" alarm triggered as expected.'
);

-- 3. Failed Occlusion Test (Sensor Lag)
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Downstream Blockage Simulation'),
    (SELECT user_id FROM users WHERE username = 'sys_mike'),
    NOW() - INTERVAL '20 hours', 'Failed',
    'Alarm triggered after 45 seconds. Required response time is <30 seconds. Sensor recalibration needed.'
);

-- 4. Successful Air-in-Line Detection
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Air Bubble Detection'),
    (SELECT user_id FROM users WHERE username = 'dr_elena'),
    NOW() - INTERVAL '18 hours', 'Passed',
    'Motor stopped immediately upon 60uL air injection. Red strobe and audible alarm confirmed.'
);

-- 5. Aborted Test (User Intervention)
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Low Battery to Shutdown'),
    (SELECT user_id FROM users WHERE username = 'admin_sarah'),
    NOW() - INTERVAL '15 hours', 'Aborted',
    'Test stopped manually by admin to investigate power supply noise.'
);

-- 6. Successful KVO Transition
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'VTBI Completion Logic'),
    (SELECT user_id FROM users WHERE username = 'dr_ahmed'),
    NOW() - INTERVAL '12 hours', 'Passed',
    'Pump switched to 0.5 mL/hr rate perfectly at VTBI=0.'
);

-- 7. Failed Door Safety (Latch Failure)
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Safety Interlock Check'),
    (SELECT user_id FROM users WHERE username = 'sys_mike'),
    NOW() - INTERVAL '10 hours', 'Failed',
    'Motor continued to run for 2 seconds after door was forced open. Safety relay check required.'
);

-- 8. Successful Pediatric Limit Check
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Pediatric Limit Validation'),
    (SELECT user_id FROM users WHERE username = 'dr_elena'),
    NOW() - INTERVAL '8 hours', 'Passed',
    'Confirmed: Low-end hard limit for Heparin (Peds) correctly blocked 0.05 mL/hr input.'
);

-- 9. Successful WiFi Recovery
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'WiFi Disconnection Recovery'),
    (SELECT user_id FROM users WHERE username = 'admin_sarah'),
    NOW() - INTERVAL '5 hours', 'Passed',
    'Local log storage verified during WiFi outage. Re-sync completed once connection restored.'
);

-- 10. Successful Alarm Priority Check
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Dual Alarm Sorting'),
    (SELECT user_id FROM users WHERE username = 'sys_mike'),
    NOW() - INTERVAL '2 hours', 'Passed',
    'Occlusion (High) correctly took visual priority over Low Battery (Medium).'
);

-- 11. Successful Night Mode Transition
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Auto-Dimming Check'),
    (SELECT user_id FROM users WHERE username = 'admin_sarah'),
    NOW() - INTERVAL '1 day', 'Passed',
    'Screen brightness automatically reduced to 25% at 23:00. UI legibility maintained.'
);

-- 12. Failed STAT Bolus (Volume Mismatch)
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Emergency Bolus Overload'),
    (SELECT user_id FROM users WHERE username = 'dr_ahmed'),
    NOW() - INTERVAL '22 hours', 'Failed',
    'Total infused volume calculated at 9.8mL instead of 10.0mL. Motor steps lost during high-speed delivery.'
);

-- 13. Successful Power Source Swap
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'AC to Battery Seamless Transition'),
    (SELECT user_id FROM users WHERE username = 'sys_mike'),
    NOW() - INTERVAL '20 hours', 'Passed',
    'No interruption in infusion motor during AC disconnect. Status LED switched from Green to Amber.'
);

-- 14. Successful Session Timeout
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'User Session Timeout'),
    (SELECT user_id FROM users WHERE username = 'admin_sarah'),
    NOW() - INTERVAL '18 hours', 'Passed',
    'User automatically logged out after 300s of inactivity. Active infusion screen remained visible but locked.'
);

-- 15. Successful Security Rollback
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Corrupt Library Rollback'),
    (SELECT user_id FROM users WHERE username = 'sys_mike'),
    NOW() - INTERVAL '16 hours', 'Passed',
    'CRC Checksum failed for corrupt.json. System successfully restored drug library v2026.04.v1.'
);

-- 16. Successful Transient Pressure Filter
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Transient Occlusion Filter'),
    (SELECT user_id FROM users WHERE username = 'dr_elena'),
    NOW() - INTERVAL '14 hours', 'Passed',
    '1-second pressure spike ignored by software filter. False alarm avoided.'
);

-- 17. Successful Cumulative Air Check
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Cumulative Air Bubble Limit'),
    (SELECT user_id FROM users WHERE username = 'dr_ahmed'),
    NOW() - INTERVAL '12 hours', 'Passed',
    'Pump stopped after 5th 10uL bubble. Cumulative air logic (Total > 50uL) working correctly.'
);

-- 18. Successful Calibration Protocol
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Motor Calibration Protocol'),
    (SELECT user_id FROM users WHERE username = 'sys_mike'),
    NOW() - INTERVAL '10 hours', 'Passed',
    'Flow sensors calibrated across all rates (1-999 mL/hr). Deviation within 1.5% margin.'
);

-- 19. Successful Role-Based Access Check
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = 'Drug Library Lockout'),
    (SELECT user_id FROM users WHERE username = 'admin_sarah'),
    NOW() - INTERVAL '8 hours', 'Passed',
    'System correctly blocked Nurse John from modifying Morphine concentration limits.'
);

-- 20. Successful Stability Run
INSERT INTO test_execution (scenario_id, executed_by, executed_at, status, result_details)
VALUES (
    (SELECT scenario_id FROM test_scenario WHERE name = '24-Hour Continuous Run'),
    (SELECT user_id FROM users WHERE username = 'sys_mike'),
    NOW() - INTERVAL '4 hours', 'Passed',
    'Simulation completed. No memory leaks detected. Time drift < 0.5 seconds over 24-hour period.'
);

-- ============================================================
-- SECTION 11: INSERT report  (20 rows)
-- ============================================================

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Infusion Summary',
        (SELECT user_id FROM users WHERE username = 'nurse_john'),
        '{"date": "2026-04-20", "ward": "ICU-A"}',
        '/reports/2026/04/daily_summary_icu_0420.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Drug Library Audit',
        (SELECT user_id FROM users WHERE username = 'dr_ahmed'),
        '{"version": "2026.04.v1", "check_type": "full"}',
        '/reports/2026/04/drug_audit_v1.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Alarm Analytics',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'),
        '{"period": "last_30_days", "alarm_type": "all"}',
        '/reports/2026/analytics/alarm_trends_april.xlsx', 'XLSX');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Patient Infusion Log',
        (SELECT user_id FROM users WHERE username = 'nurse_layla'),
        '{"patient_id": "PT-9982", "session_count": 5}',
        '/reports/patients/pt_9982_history.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Test Execution Report',
        (SELECT user_id FROM users WHERE username = 'sys_mike'),
        '{"batch_id": "TEST-B-505", "status": "Passed/Failed"}',
        '/reports/tech/safety_test_505.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Near-Miss Report',
        (SELECT user_id FROM users WHERE username = 'dr_elena'),
        '{"severity": "Critical", "incident_type": "Hard Limit"}',
        '/reports/safety/near_miss_april.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Maintenance Report',
        (SELECT user_id FROM users WHERE username = 'sys_mike'),
        '{"asset_id": "PUMP-ICU-099", "check": "Battery/Motor"}',
        '/reports/maint/pump_099_status.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('User Activity Log',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'),
        '{"user_id": "nurse_john", "action": "login/logout"}',
        '/reports/security/audit_nurse_john.csv', 'CSV');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Compliance Report',
        (SELECT user_id FROM users WHERE username = 'dr_ahmed'),
        '{"protocol": "Pediatric", "adherence": "100%"}',
        '/reports/clinical/peds_compliance_q2.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('STAT Usage Report',
        (SELECT user_id FROM users WHERE username = 'dr_elena'),
        '{"drug": "Epinephrine", "mode": "Bolus"}',
        '/reports/clinical/emergency_bolus_usage.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Efficiency Report',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'),
        '{"metric": "avg_response_time", "unit": "seconds", "threshold": 60}',
        '/reports/2026/analytics/nurse_response_times_q1.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Asset Utilization',
        (SELECT user_id FROM users WHERE username = 'sys_mike'),
        '{"total_pumps": 50, "active_percentage": 82.5}',
        '/reports/2026/biomed/utilization_apr_2026.xlsx', 'XLSX');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Night Shift Audit',
        (SELECT user_id FROM users WHERE username = 'dr_ahmed'),
        '{"shift_start": "22:00", "shift_end": "06:00", "incidents": 3}',
        '/reports/2026/safety/night_shift_audit_0420.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('High-Alert Drug Log',
        (SELECT user_id FROM users WHERE username = 'dr_elena'),
        '{"drugs": ["Heparin", "Insulin", "Propofol"], "risk_level": "High"}',
        '/reports/2026/pharmacy/high_alert_usage_weekly.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Hardware Error Log',
        (SELECT user_id FROM users WHERE username = 'sys_mike'),
        '{"error_code": "E-104", "type": "Motor-Stall", "frequency": 12}',
        '/reports/2026/tech/error_code_frequency.csv', 'CSV');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Staff Competency',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'),
        '{"module": "Smart Pump Advanced", "completion_rate": "95%"}',
        '/reports/2026/hr/nurse_training_compliance.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Maintenance Forecast',
        (SELECT user_id FROM users WHERE username = 'sys_mike'),
        '{"component": "Battery", "replacement_due_count": 5}',
        '/reports/2026/biomed/battery_forecast_q2.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Clinical Override Log',
        (SELECT user_id FROM users WHERE username = 'dr_ahmed'),
        '{"type": "Soft Limit", "action": "Override", "count": 14}',
        '/reports/2026/clinical/soft_limit_overrides.xlsx', 'XLSX');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Volume Summary',
        (SELECT user_id FROM users WHERE username = 'nurse_chen'),
        '{"ward": "Pediatrics", "total_volume_liters": 45.2}',
        '/reports/2026/ward/peds_volume_summary.pdf', 'PDF');

INSERT INTO report (type, generated_by, parameters, file_path, format)
VALUES ('Decommissioning Report',
        (SELECT user_id FROM users WHERE username = 'admin_sarah'),
        '{"pumps_retired": 2, "reason": "Hardware EOL"}',
        '/reports/2026/admin/decommissioned_assets.pdf', 'PDF');

-- ============================================================
-- SECTION 12: INSERT event_log
-- ============================================================

-- SESSION 1: Morphine — technical events
INSERT INTO event_log (session_id, event_type, description, user_id, timestamp)
VALUES
((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Morphine' LIMIT 1),
 'Power Source', 'Switched from AC to Internal Battery', NULL, NOW() - INTERVAL '4 hours'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Morphine' LIMIT 1),
 'User Action', 'Nurse pressed BOLUS button',
 (SELECT user_id FROM users WHERE username = 'nurse_chen'), NOW() - INTERVAL '3 hours 55 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Morphine' LIMIT 1),
 'Bolus Start', 'Bolus delivery initiated: 2.0mL', NULL, NOW() - INTERVAL '3 hours 54 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Morphine' LIMIT 1),
 'Bolus End', 'Bolus delivery completed successfully', NULL, NOW() - INTERVAL '3 hours 52 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Morphine' LIMIT 1),
 'Sensor Update', 'Air sensor self-calibration successful', NULL, NOW() - INTERVAL '3 hours'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Morphine' LIMIT 1),
 'State Change', 'Pump entered KVO mode: VTBI reached zero', NULL, NOW() - INTERVAL '1 hour'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Morphine' LIMIT 1),
 'User Action', 'Nurse pressed STOP button',
 (SELECT user_id FROM users WHERE username = 'nurse_chen'), NOW() - INTERVAL '10 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Morphine' LIMIT 1),
 'System Message', 'Infusion session archived to local memory', NULL, NOW() - INTERVAL '5 minutes');

-- SESSION 2: Heparin — hardware error + network events
INSERT INTO event_log (session_id, event_type, description, user_id, timestamp)
VALUES
((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Heparin' LIMIT 1),
 'User Action', 'Nurse cleared occlusion alarm',
 (SELECT user_id FROM users WHERE username = 'nurse_layla'), NOW() - INTERVAL '50 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Heparin' LIMIT 1),
 'Motor Action', 'Motor restarted at 12.5 mL/hr', NULL, NOW() - INTERVAL '49 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Heparin' LIMIT 1),
 'Pressure Reading', 'Downstream pressure stabilized at 120 mmHg', NULL, NOW() - INTERVAL '45 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Heparin' LIMIT 1),
 'Network Status', 'WiFi signal lost: Entering Offline Logging Mode', NULL, NOW() - INTERVAL '30 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Heparin' LIMIT 1),
 'Network Status', 'WiFi signal restored: Syncing 5 cached events', NULL, NOW() - INTERVAL '25 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Heparin' LIMIT 1),
 'User Action', 'Rate Titration: Changed from 12.5 to 15.0 mL/hr',
 (SELECT user_id FROM users WHERE username = 'nurse_layla'), NOW() - INTERVAL '20 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Heparin' LIMIT 1),
 'Sensor Alert', 'Door latch sensor vibration detected', NULL, NOW() - INTERVAL '15 minutes');

-- General system events (no session)
INSERT INTO event_log (session_id, event_type, description, user_id)
VALUES
(NULL, 'System Boot',         'Pump Software v2.5 initialized',
 (SELECT user_id FROM users WHERE username = 'sys_mike')),
(NULL, 'Self-Test',           'Internal RAM and Motor Drive check: PASSED', NULL),
(NULL, 'Configuration Change','Alarm Volume set to 8 by Admin',
 (SELECT user_id FROM users WHERE username = 'admin_sarah')),
(NULL, 'Security',            'User nurse_omar logged out due to inactivity', NULL),
(NULL, 'Battery',             'Charging started: AC Connected', NULL);

-- SESSION 3: Insulin Regular — occlusion struggle
INSERT INTO event_log (session_id, event_type, description, user_id, timestamp)
VALUES
((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Insulin Regular' LIMIT 1),
 'Sensor Reading', 'Upstream pressure increasing: 350 mmHg', NULL, NOW() - INTERVAL '40 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Insulin Regular' LIMIT 1),
 'Alarm Triggered', 'Occlusion Alarm (Upstream) - Infusion Paused', NULL, NOW() - INTERVAL '38 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Insulin Regular' LIMIT 1),
 'User Action', 'Nurse opened door to inspect tubing',
 (SELECT user_id FROM users WHERE username = 'nurse_omar'), NOW() - INTERVAL '35 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Insulin Regular' LIMIT 1),
 'Sensor Alert', 'Door Open detected during Pause state', NULL, NOW() - INTERVAL '35 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Insulin Regular' LIMIT 1),
 'User Action', 'Nurse cleared occlusion and closed door',
 (SELECT user_id FROM users WHERE username = 'nurse_omar'), NOW() - INTERVAL '32 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Insulin Regular' LIMIT 1),
 'Motor Action', 'Pump Resume: Motor stepping at 2.0 units/hr', NULL, NOW() - INTERVAL '31 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Insulin Regular' LIMIT 1),
 'Safety Check', 'Post-occlusion bolus reduction algorithm active', NULL, NOW() - INTERVAL '30 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Insulin Regular' LIMIT 1),
 'Battery Status', 'Voltage drop detected: Battery at 10%', NULL, NOW() - INTERVAL '15 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Insulin Regular' LIMIT 1),
 'Alarm Triggered', 'Low Battery Warning (Medium Severity)', NULL, NOW() - INTERVAL '14 minutes'),

((SELECT session_id FROM infusion_session s JOIN drug d ON s.drug_id = d.drug_id WHERE d.name = 'Insulin Regular' LIMIT 1),
 'System Message', 'Session auto-save: Internal flash memory write successful', NULL, NOW() - INTERVAL '1 minute');

-- ============================================================
-- END OF SCRIPT
-- ============================================================
