--
-- PostgreSQL database dump
--

\restrict lwGmROOOekgZZNegdOSJNn6vSBfvNRbwQvF06O3Io3aHyOWfyskAPIVL34hLTv1

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-04-23 17:05:57

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16818)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 16896)
-- Name: alarm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alarm (
    alarm_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    session_id uuid,
    type character varying(30) NOT NULL,
    severity character varying(20) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    acknowledged boolean DEFAULT false,
    acknowledged_by uuid,
    acknowledged_at timestamp without time zone,
    resolved boolean DEFAULT false,
    resolved_at timestamp without time zone,
    description text
);


ALTER TABLE public.alarm OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16921)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    log_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    action character varying(100) NOT NULL,
    entity_type character varying(50),
    entity_id uuid,
    old_value text,
    new_value text,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    ip_address character varying(45),
    session_id uuid
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16843)
-- Name: drug; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drug (
    drug_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    concentration numeric(10,2) NOT NULL,
    concentration_unit character varying(20) NOT NULL,
    default_rate numeric(10,2) NOT NULL,
    rate_unit character varying(10) DEFAULT 'mL/hr'::character varying,
    hard_limit_low numeric(10,2) NOT NULL,
    hard_limit_high numeric(10,2) NOT NULL,
    soft_limit_low numeric(10,2),
    soft_limit_high numeric(10,2),
    created_by uuid,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_by uuid,
    updated_at timestamp without time zone
);


ALTER TABLE public.drug OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17016)
-- Name: event_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_log (
    event_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    session_id uuid,
    event_type character varying(50) NOT NULL,
    description text NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    user_id uuid
);


ALTER TABLE public.event_log OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16871)
-- Name: infusion_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.infusion_session (
    session_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    drug_id uuid,
    rate numeric(10,2) NOT NULL,
    total_volume numeric(10,2) NOT NULL,
    volume_infused numeric(10,2) DEFAULT 0,
    status character varying(20) DEFAULT 'Idle'::character varying NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    bolus_enabled boolean DEFAULT false,
    kvo_enabled boolean DEFAULT false,
    kvo_rate numeric(10,2),
    battery_level integer DEFAULT 100
);


ALTER TABLE public.infusion_session OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16998)
-- Name: report; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report (
    report_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    type character varying(30) NOT NULL,
    generated_by uuid,
    generated_at timestamp without time zone DEFAULT now() NOT NULL,
    parameters text,
    file_path character varying(255),
    format character varying(10) DEFAULT 'PDF'::character varying
);


ALTER TABLE public.report OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16938)
-- Name: system_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_configuration (
    config_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    key character varying(100) NOT NULL,
    value text NOT NULL,
    description text,
    updated_by uuid,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.system_configuration OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16976)
-- Name: test_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_execution (
    execution_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    scenario_id uuid,
    executed_by uuid,
    executed_at timestamp without time zone DEFAULT now() NOT NULL,
    status character varying(20) NOT NULL,
    result_details text
);


ALTER TABLE public.test_execution OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16958)
-- Name: test_scenario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_scenario (
    scenario_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    script text NOT NULL,
    created_by uuid,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.test_scenario OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16829)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    last_login timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 5120 (class 0 OID 16896)
-- Dependencies: 223
-- Data for Name: alarm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alarm (alarm_id, session_id, type, severity, "timestamp", acknowledged, acknowledged_by, acknowledged_at, resolved, resolved_at, description) FROM stdin;
c9073c9a-28f9-4767-a78a-86b34c1ff804	a7f3b1a7-797c-436d-afa6-ebed3d1bfd65	Occlusion	High	2026-04-20 21:42:11.786454	f	\N	\N	f	\N	Downstream pressure exceeded limit.
62e54cca-47af-473e-8ec4-6410b5ba427e	808a02d4-5735-4d68-86c2-cc617bceb29e	Air in Line	Critical	2026-04-20 20:47:11.786454	t	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 20:57:11.786454	f	\N	Large air bubble detected in line.
3969feec-33ac-4c16-824d-0fc64d4e7ac8	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	Low Battery	Medium	2026-04-20 19:47:11.786454	f	\N	\N	f	\N	Battery level dropped below 15%.
9131ba07-9d03-4cd2-b4dd-da7912742521	13a44312-892f-4747-9ebf-c376d3f7ffc7	Door Open	High	2026-04-20 21:37:11.786454	f	\N	\N	f	\N	Pump door opened during active motor state.
58e3403d-ef54-4e31-b1d7-dcf9abeb17aa	7e17f3e0-388b-4453-ac2e-fed2a55c08e0	Flow Error	High	2026-04-20 18:47:11.786454	t	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 19:47:11.786454	t	\N	Unintended flow rate variation detected.
7cb8cf2c-78a1-4b15-bacd-e7e907a51e1b	9cf5152e-2ec8-4d2a-beca-1d20b2d26185	Complete	Low	2026-04-20 21:17:11.786454	t	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:22:11.786454	t	\N	Target volume (VTBI) has been reached.
fbe8ceaa-5d86-4f63-b53b-b5211331a336	bc2795a3-335e-4414-9c60-9007a2a7dab5	System Error	Critical	2026-04-20 09:47:11.786454	f	\N	\N	f	\N	Internal motor controller communication failure.
4ab6a5bc-8f04-445e-89d7-38e7b3acf16a	c32152a3-99b1-4e7f-85ff-b7007e8bea5a	KVO Active	Low	2026-04-20 21:32:11.786454	f	\N	\N	f	\N	Pump transitioned to Keep Vein Open rate.
d9c2dd6e-1840-436d-a8b8-54ad66cce3b2	26c241e6-4b07-4f43-9277-60975da34a51	Upstream Occlusion	Medium	2026-04-20 21:02:11.786454	t	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:07:11.786454	f	\N	Restricted flow detected from the source bag.
e2311c02-9f25-4990-b1e3-0498b162bef2	8e3c45d8-624e-431d-a355-59a07b1d0f52	Battery Critical	Critical	2026-04-20 21:42:11.786454	f	\N	\N	f	\N	Battery below 5%. Immediate shutdown imminent.
5d3fa0e5-536d-407f-aa9b-38a51f1058fc	be53a0e5-48a8-4264-880f-81c7e67d3c31	Occlusion	High	2026-04-20 21:32:11.786454	f	\N	\N	f	\N	Downstream pressure exceeds 500mmHg threshold.
e359bc2f-cf99-47dd-8caf-130e865ca27e	cfb3faf5-c36e-49e7-8300-540407c312da	Air in Line	Critical	2026-04-20 19:47:11.786454	t	a021a5f2-01f1-4f83-a894-a1b192480504	2026-04-20 20:47:11.786454	f	\N	Air bubble >50uL detected in the primary line.
f3f7fbf2-41c1-43fc-a585-af9aac6fec55	0f9b7877-0eef-4d2c-9744-ed11088ad9fe	Infusion Complete	Low	2026-04-20 21:02:11.786454	t	47609940-c029-4823-be05-ee3ed460433f	2026-04-20 21:07:11.786454	t	\N	Target volume (VTBI) reached. Pump in KVO mode.
20be7c4e-1cae-4144-b6b8-06654e087619	34a53387-cdab-4225-9444-624fdec71f2b	Battery Critical	Critical	2026-04-20 21:42:11.786454	f	\N	\N	f	\N	Battery level below 5%. Immediate AC connection required.
b49004c6-93ff-4272-a178-56a0fd5b5e17	bacb276e-c7e6-4597-8e50-f4666103f660	Flow Error	High	2026-04-20 18:47:11.786454	t	008c8e8a-a4c0-4a9e-9e3d-66a8f9d11e45	2026-04-20 19:47:11.786454	t	\N	Unintended flow rate variation detected and corrected.
3f684e23-7578-4000-aed1-bb7a91bc6e00	1c07846a-5f4c-4409-9e12-329707a687f2	Door Open	High	2026-04-20 21:35:11.786454	f	\N	\N	f	\N	Pump door safety interlock triggered during active state.
ba3530c3-863b-4693-aa5c-f69d134e6fa7	5e295a9e-6b6f-43f9-a31a-0263d3df6d5e	System Error	Critical	2026-04-20 15:47:11.786454	f	\N	\N	f	\N	Internal motor controller communication failure (Code: ERR_099).
17974f35-ae7a-4f89-aab6-64ef834f6d5e	1f3cb7ad-37b1-41df-8e72-4b5e3aac66df	Upstream Occlusion	Medium	2026-04-20 21:27:11.786454	t	970b61f2-e784-40b6-8621-82f0f906c638	2026-04-20 21:29:11.786454	f	\N	Fluid delivery restricted from the source bag.
bb4f28a1-5c4f-4ad3-a913-99aa40bd9a38	c6026780-2db2-4dce-a7d9-8df0ae817f4b	Dose Warning	Low	2026-04-20 20:47:11.786454	t	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 20:52:11.786454	t	\N	Soft limit high override confirmed by clinical staff.
e8eb6a79-557b-40a0-8e5c-ca70e0bc48c8	aa9bd4de-0ec4-4628-abd3-8c21ca0da50b	Power Loss	Medium	2026-04-20 17:47:11.786454	f	\N	\N	f	\N	AC power disconnected. Pump running on internal battery.
\.


--
-- TOC entry 5121 (class 0 OID 16921)
-- Dependencies: 224
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (log_id, user_id, action, entity_type, entity_id, old_value, new_value, "timestamp", ip_address, session_id) FROM stdin;
\.


--
-- TOC entry 5118 (class 0 OID 16843)
-- Dependencies: 221
-- Data for Name: drug; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.drug (drug_id, name, concentration, concentration_unit, default_rate, rate_unit, hard_limit_low, hard_limit_high, soft_limit_low, soft_limit_high, created_by, created_at, updated_by, updated_at) FROM stdin;
4dcb6af0-7ece-40bd-8b11-d308b8193357	Heparin	100.00	units/mL	12.50	mL/hr	1.00	40.00	5.00	25.00	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	\N	\N
56f11bd3-4651-4236-bdd2-c96c7605d02b	Insulin Regular	1.00	units/mL	2.00	mL/hr	0.10	20.00	0.50	10.00	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	\N	\N
3b88639c-55d4-42d8-b146-987a6b126de1	Morphine	1.00	mg/mL	1.00	mL/hr	0.50	10.00	1.00	5.00	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	\N	\N
bfebd2ce-e774-4f7f-8dde-55a3b07fda3e	Dopamine	1.60	mg/mL	5.00	mL/hr	1.00	50.00	2.00	20.00	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	\N	\N
561f88c8-554f-4a06-9e99-a8fb7310b795	Magnesium Sulfate	40.00	mg/mL	25.00	mL/hr	5.00	100.00	10.00	50.00	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	\N	\N
6ad2f071-969a-4d2e-a13e-0b951289f88b	Potassium Chloride	0.20	mEq/mL	10.00	mL/hr	2.00	20.00	5.00	15.00	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	\N	\N
40b11866-f396-41ad-ae7a-4e1181ac43b4	Propofol	10.00	mg/mL	5.00	mL/hr	1.00	50.00	5.00	30.00	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	\N	\N
91cf5c03-f04c-4a3c-b5b0-6ce6e10a0438	Normal Saline 0.9%	0.00	N/A	100.00	mL/hr	1.00	999.00	10.00	500.00	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	\N	\N
8c7d5f0e-9be6-44a2-b5a1-6e93855bf0ff	Fentanyl	50.00	mcg/mL	2.00	mL/hr	0.50	20.00	1.00	10.00	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	\N	\N
988efb0f-2b3c-4ce0-968f-be9b11ac4a89	Oxytocin	10.00	units/L	6.00	mL/hr	1.00	40.00	2.00	20.00	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	\N	\N
95c70ab7-72a8-41b8-8dfb-eb6ff4a0bc09	Epinephrine	0.10	mg/mL	2.00	mL/hr	0.10	30.00	1.00	15.00	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	\N	\N
45a98e61-af23-46e7-9c86-d4d5ff18427e	Amiodarone	1.80	mg/mL	33.30	mL/hr	10.00	100.00	20.00	50.00	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	\N	\N
41cba972-94d8-49b4-97ec-2edafa74a5f9	Vancomycin	5.00	mg/mL	100.00	mL/hr	20.00	250.00	50.00	200.00	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	\N	\N
19694754-4658-4947-a202-da8c8e32f2ca	Norepinephrine	0.06	mg/mL	5.00	mL/hr	0.10	60.00	2.00	40.00	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	\N	\N
7f53b5bd-cf99-4365-8d74-d07a012e894c	Dextrose 5%	0.00	N/A	75.00	mL/hr	1.00	500.00	10.00	250.00	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	\N	\N
c9bf59c1-f796-49c9-9a6f-2de68f6c6106	Lidocaine	4.00	mg/mL	15.00	mL/hr	5.00	60.00	10.00	45.00	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	\N	\N
3f3cee9a-77b4-409a-ab0f-4579166d13d1	Midazolam	1.00	mg/mL	2.00	mL/hr	0.50	15.00	1.00	10.00	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	\N	\N
6f9b24b6-5947-461d-aa07-41feee58c452	Furosemide	10.00	mg/mL	4.00	mL/hr	1.00	20.00	2.00	10.00	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	\N	\N
094b2a7d-50ce-4471-8297-0240bb590ea5	Heparin (Peds)	10.00	units/mL	1.00	mL/hr	0.10	10.00	0.50	5.00	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	\N	\N
\.


--
-- TOC entry 5126 (class 0 OID 17016)
-- Dependencies: 229
-- Data for Name: event_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_log (event_id, session_id, event_type, description, "timestamp", user_id) FROM stdin;
25ccd185-9667-4c93-8afe-d589f99664bf	13a44312-892f-4747-9ebf-c376d3f7ffc7	Power Source	Switched from AC to Internal Battery	2026-04-20 17:47:11.786454	\N
8ddd372f-db30-471b-897b-32f2f067d1bb	13a44312-892f-4747-9ebf-c376d3f7ffc7	User Action	Nurse pressed BOLUS button	2026-04-20 17:52:11.786454	970b61f2-e784-40b6-8621-82f0f906c638
60795cd1-e900-4e85-b538-f7c679bce8e4	13a44312-892f-4747-9ebf-c376d3f7ffc7	Bolus Start	Bolus delivery initiated: 2.0mL	2026-04-20 17:53:11.786454	\N
06ea5be4-7a68-4aea-a0f5-50ba64df1a8e	13a44312-892f-4747-9ebf-c376d3f7ffc7	Bolus End	Bolus delivery completed successfully	2026-04-20 17:55:11.786454	\N
d6ab0815-7ea0-4f4b-a60e-c9bdbd3d489b	13a44312-892f-4747-9ebf-c376d3f7ffc7	Sensor Update	Air sensor self-calibration successful	2026-04-20 18:47:11.786454	\N
feae46f0-4027-4a09-88d6-72659d5ff03a	13a44312-892f-4747-9ebf-c376d3f7ffc7	State Change	Pump entered KVO mode: VTBI reached zero	2026-04-20 20:47:11.786454	\N
198f508e-1fd7-4220-9fab-7d26f275f313	13a44312-892f-4747-9ebf-c376d3f7ffc7	User Action	Nurse pressed STOP button	2026-04-20 21:37:11.786454	970b61f2-e784-40b6-8621-82f0f906c638
785669e8-5e50-46b6-99bd-fc88bb33d826	13a44312-892f-4747-9ebf-c376d3f7ffc7	System Message	Infusion session archived to local memory	2026-04-20 21:42:11.786454	\N
ae526cb1-4a0f-4e87-a45f-a7981c82ba1a	808a02d4-5735-4d68-86c2-cc617bceb29e	User Action	Nurse cleared occlusion alarm	2026-04-20 20:57:11.786454	47609940-c029-4823-be05-ee3ed460433f
10b6b0f1-49be-448f-a22c-9d50aa273c55	808a02d4-5735-4d68-86c2-cc617bceb29e	Motor Action	Motor restarted at 12.5 mL/hr	2026-04-20 20:58:11.786454	\N
dd2871a4-f9d2-4c50-ad9b-b85d2a30056d	808a02d4-5735-4d68-86c2-cc617bceb29e	Pressure Reading	Downstream pressure stabilized at 120 mmHg	2026-04-20 21:02:11.786454	\N
d0846a20-eebe-4dba-b48a-f34429e03157	808a02d4-5735-4d68-86c2-cc617bceb29e	Network Status	WiFi signal lost: Entering Offline Logging Mode	2026-04-20 21:17:11.786454	\N
dd6dbd7d-55d8-476e-bf1e-d34542af2a9d	808a02d4-5735-4d68-86c2-cc617bceb29e	Network Status	WiFi signal restored: Syncing 5 cached events	2026-04-20 21:22:11.786454	\N
e3131e2c-8e0c-4068-995c-01323783a01b	808a02d4-5735-4d68-86c2-cc617bceb29e	User Action	Rate Titration: Changed from 12.5 to 15.0 mL/hr	2026-04-20 21:27:11.786454	47609940-c029-4823-be05-ee3ed460433f
b8261f98-7a8c-4ac6-99b9-c4a7dc5bd981	808a02d4-5735-4d68-86c2-cc617bceb29e	Sensor Alert	Door latch sensor vibration detected	2026-04-20 21:32:11.786454	\N
abbeffdd-a689-4a95-aaf2-d7ae808fe550	\N	System Boot	Pump Software v2.5 initialized	2026-04-20 21:47:11.786454	1a38911e-b7ba-45b1-b7a1-01bccf09b848
f3ce97c8-1269-45e6-a854-3fa3d1a3e229	\N	Self-Test	Internal RAM and Motor Drive check: PASSED	2026-04-20 21:47:11.786454	\N
19513e91-b786-4d79-a5e3-85996d839a11	\N	Configuration Change	Alarm Volume set to 8 by Admin	2026-04-20 21:47:11.786454	1d515ee6-734f-4d52-a45e-3a129babec5f
7aa40909-5df0-4402-80e7-b8e2d614077e	\N	Security	User nurse_omar logged out due to inactivity	2026-04-20 21:47:11.786454	\N
9127de1a-eb4a-48b3-af32-9f7862186ed0	\N	Battery	Charging started: AC Connected	2026-04-20 21:47:11.786454	\N
56203111-de23-4194-9896-deedbc620f7b	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	Sensor Reading	Upstream pressure increasing: 350 mmHg	2026-04-20 21:07:11.786454	\N
1d49283a-a321-499b-8a59-2a415af8d8e4	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	Alarm Triggered	Occlusion Alarm (Upstream) - Infusion Paused	2026-04-20 21:09:11.786454	\N
58052b07-9259-4620-b97c-9c51471368c5	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	User Action	Nurse opened door to inspect tubing	2026-04-20 21:12:11.786454	008c8e8a-a4c0-4a9e-9e3d-66a8f9d11e45
b63fd26b-027b-4b54-ab0f-d44778ab0c9f	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	Sensor Alert	Door Open detected during Pause state	2026-04-20 21:12:11.786454	\N
f60dde07-a8b8-41d3-82e4-b26219ade9e4	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	User Action	Nurse cleared occlusion and closed door	2026-04-20 21:15:11.786454	008c8e8a-a4c0-4a9e-9e3d-66a8f9d11e45
6a09508b-ec86-4560-afd7-0094f7030f5b	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	Motor Action	Pump Resume: Motor stepping at 2.0 units/hr	2026-04-20 21:16:11.786454	\N
f101c75f-b807-4cd5-9db6-9bf8dfb2522c	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	Safety Check	Post-occlusion bolus reduction algorithm active	2026-04-20 21:17:11.786454	\N
6aab3feb-ac2f-4eb6-999a-b6b3ca832cb3	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	Battery Status	Voltage drop detected: Battery at 10%	2026-04-20 21:32:11.786454	\N
10bcee96-12be-40b9-8f57-85781c3ea300	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	Alarm Triggered	Low Battery Warning (Medium Severity)	2026-04-20 21:33:11.786454	\N
c0ab2589-0952-4b26-84f9-c60e18054e47	69a7d253-bfb7-408d-ab18-53f9e17e5ef3	System Message	Session auto-save: Internal flash memory write successful	2026-04-20 21:46:11.786454	\N
\.


--
-- TOC entry 5119 (class 0 OID 16871)
-- Dependencies: 222
-- Data for Name: infusion_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.infusion_session (session_id, user_id, drug_id, rate, total_volume, volume_infused, status, start_time, end_time, bolus_enabled, kvo_enabled, kvo_rate, battery_level) FROM stdin;
a7f3b1a7-797c-436d-afa6-ebed3d1bfd65	a021a5f2-01f1-4f83-a894-a1b192480504	91cf5c03-f04c-4a3c-b5b0-6ce6e10a0438	125.00	1000.00	950.00	Infusing	2026-04-20 13:47:11.786454	\N	f	f	\N	85
808a02d4-5735-4d68-86c2-cc617bceb29e	47609940-c029-4823-be05-ee3ed460433f	4dcb6af0-7ece-40bd-8b11-d308b8193357	12.50	500.00	15.20	Infusing	2026-04-20 20:47:11.786454	\N	t	f	\N	100
69a7d253-bfb7-408d-ab18-53f9e17e5ef3	008c8e8a-a4c0-4a9e-9e3d-66a8f9d11e45	56f11bd3-4651-4236-bdd2-c96c7605d02b	2.00	50.00	5.50	Stopped	2026-04-20 21:17:11.786454	\N	f	f	\N	100
13a44312-892f-4747-9ebf-c376d3f7ffc7	970b61f2-e784-40b6-8621-82f0f906c638	3b88639c-55d4-42d8-b146-987a6b126de1	1.00	100.00	100.00	KVO	\N	\N	f	t	0.10	100
7e17f3e0-388b-4453-ac2e-fed2a55c08e0	dbe0c954-fe36-438c-80bc-9b62ef39565e	95c70ab7-72a8-41b8-8dfb-eb6ff4a0bc09	2.00	50.00	12.00	Infusing	\N	\N	f	f	\N	12
9cf5152e-2ec8-4d2a-beca-1d20b2d26185	8f6dd0fc-3133-4e37-a1a6-e0ab8e29f8a0	41cba972-94d8-49b4-97ec-2edafa74a5f9	100.00	250.00	250.00	Completed	2026-04-20 17:47:11.786454	2026-04-20 20:17:11.786454	f	f	\N	100
bc2795a3-335e-4414-9c60-9007a2a7dab5	49777666-4e6b-4444-815d-09bdc03d9d91	40b11866-f396-41ad-ae7a-4e1181ac43b4	15.00	500.00	200.00	Infusing	2026-04-20 18:47:11.786454	\N	f	f	\N	100
c32152a3-99b1-4e7f-85ff-b7007e8bea5a	8c000bde-a225-4ddc-875b-739619cc56dc	094b2a7d-50ce-4471-8297-0240bb590ea5	1.00	20.00	2.10	Stopped	2026-04-20 21:27:11.786454	\N	f	f	\N	100
26c241e6-4b07-4f43-9277-60975da34a51	71bbd316-9851-4163-9005-1b186b9c6166	561f88c8-554f-4a06-9e99-a8fb7310b795	25.00	100.00	0.00	Idle	\N	\N	f	f	\N	100
8e3c45d8-624e-431d-a355-59a07b1d0f52	f5ac9202-7447-496b-8a92-877d50d2c80a	6ad2f071-969a-4d2e-a13e-0b951289f88b	10.00	100.00	45.00	Infusing	2026-04-20 17:47:11.786454	\N	f	f	\N	100
be53a0e5-48a8-4264-880f-81c7e67d3c31	8f6dd0fc-3133-4e37-a1a6-e0ab8e29f8a0	19694754-4658-4947-a202-da8c8e32f2ca	15.00	250.00	45.30	Infusing	2026-04-20 19:47:11.786454	\N	f	f	\N	98
cfb3faf5-c36e-49e7-8300-540407c312da	49777666-4e6b-4444-815d-09bdc03d9d91	8c7d5f0e-9be6-44a2-b5a1-6e93855bf0ff	2.50	100.00	5.00	Infusing	2026-04-20 21:32:11.786454	\N	t	f	\N	100
0f9b7877-0eef-4d2c-9744-ed11088ad9fe	8c000bde-a225-4ddc-875b-739619cc56dc	7f53b5bd-cf99-4365-8d74-d07a012e894c	75.00	500.00	480.00	Infusing	\N	\N	f	f	\N	5
34a53387-cdab-4225-9444-624fdec71f2b	f5ac9202-7447-496b-8a92-877d50d2c80a	45a98e61-af23-46e7-9c86-d4d5ff18427e	33.30	100.00	12.40	Stopped	2026-04-20 21:07:11.786454	\N	f	f	\N	100
bacb276e-c7e6-4597-8e50-f4666103f660	71bbd316-9851-4163-9005-1b186b9c6166	40b11866-f396-41ad-ae7a-4e1181ac43b4	10.00	200.00	200.00	Completed	2026-04-20 15:47:11.786454	2026-04-20 19:47:11.786454	f	f	\N	100
1c07846a-5f4c-4409-9e12-329707a687f2	dbe0c954-fe36-438c-80bc-9b62ef39565e	\N	50.00	250.00	0.00	Idle	\N	\N	f	f	\N	100
5e295a9e-6b6f-43f9-a31a-0263d3df6d5e	47609940-c029-4823-be05-ee3ed460433f	988efb0f-2b3c-4ce0-968f-be9b11ac4a89	6.00	500.00	32.00	Infusing	2026-04-20 20:47:11.786454	\N	f	f	\N	100
1f3cb7ad-37b1-41df-8e72-4b5e3aac66df	a021a5f2-01f1-4f83-a894-a1b192480504	6f9b24b6-5947-461d-aa07-41feee58c452	4.00	50.00	50.00	KVO	\N	\N	f	t	0.50	100
c6026780-2db2-4dce-a7d9-8df0ae817f4b	970b61f2-e784-40b6-8621-82f0f906c638	3f3cee9a-77b4-409a-ab0f-4579166d13d1	2.00	100.00	85.00	Stopped	2026-04-20 18:47:11.786454	\N	f	f	\N	100
aa9bd4de-0ec4-4628-abd3-8c21ca0da50b	008c8e8a-a4c0-4a9e-9e3d-66a8f9d11e45	c9bf59c1-f796-49c9-9a6f-2de68f6c6106	15.00	250.00	110.00	Infusing	2026-04-20 16:47:11.786454	\N	f	f	\N	100
\.


--
-- TOC entry 5125 (class 0 OID 16998)
-- Dependencies: 228
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report (report_id, type, generated_by, generated_at, parameters, file_path, format) FROM stdin;
2bef9e84-534e-4210-af7e-8f03f479b192	Infusion Summary	a021a5f2-01f1-4f83-a894-a1b192480504	2026-04-20 21:47:11.786454	{"date": "2026-04-20", "ward": "ICU-A"}	/reports/2026/04/daily_summary_icu_0420.pdf	PDF
b7b143aa-68ec-4f67-a628-8aea00b6539f	Drug Library Audit	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	{"version": "2026.04.v1", "check_type": "full"}	/reports/2026/04/drug_audit_v1.pdf	PDF
f626412a-dd6c-4cba-8374-b13dc896bd1a	Alarm Analytics	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454	{"period": "last_30_days", "alarm_type": "all"}	/reports/2026/analytics/alarm_trends_april.xlsx	XLSX
1fc36a6f-2c4e-4728-8a67-d091aa947293	Patient Infusion Log	47609940-c029-4823-be05-ee3ed460433f	2026-04-20 21:47:11.786454	{"patient_id": "PT-9982", "session_count": 5}	/reports/patients/pt_9982_history.pdf	PDF
d4a113ac-5aca-4003-ad15-bca3aa2b79c9	Test Execution Report	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454	{"batch_id": "TEST-B-505", "status": "Passed/Failed"}	/reports/tech/safety_test_505.pdf	PDF
d60e34cc-e29e-4b07-9ea0-a6235708620a	Near-Miss Report	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	{"severity": "Critical", "incident_type": "Hard Limit"}	/reports/safety/near_miss_april.pdf	PDF
d6e9d36a-d106-4739-a3db-8cd4ebc6c265	Maintenance Report	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454	{"asset_id": "PUMP-ICU-099", "check": "Battery/Motor"}	/reports/maint/pump_099_status.pdf	PDF
2f10daf8-05ca-4320-a7d2-8e4c13d3b04d	User Activity Log	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454	{"user_id": "nurse_john", "action": "login/logout"}	/reports/security/audit_nurse_john.csv	CSV
cb8bed33-1815-442e-93c2-e5cb22b4817a	Compliance Report	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	{"protocol": "Pediatric", "adherence": "100%"}	/reports/clinical/peds_compliance_q2.pdf	PDF
65320d9a-cec5-4555-9333-4ac6727445dc	STAT Usage Report	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	{"drug": "Epinephrine", "mode": "Bolus"}	/reports/clinical/emergency_bolus_usage.pdf	PDF
e855079e-c3c4-42ad-8b0c-7c4b29123d5e	Efficiency Report	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454	{"metric": "avg_response_time", "unit": "seconds", "threshold": 60}	/reports/2026/analytics/nurse_response_times_q1.pdf	PDF
04aa3b43-0cee-45dd-b0fd-32c0464ff4ce	Asset Utilization	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454	{"total_pumps": 50, "active_percentage": 82.5}	/reports/2026/biomed/utilization_apr_2026.xlsx	XLSX
13a26e9d-574b-473f-ad82-5609437884c8	Night Shift Audit	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	{"shift_start": "22:00", "shift_end": "06:00", "incidents": 3}	/reports/2026/safety/night_shift_audit_0420.pdf	PDF
a74a9466-cb91-4767-a845-f503b7767140	High-Alert Drug Log	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454	{"drugs": ["Heparin", "Insulin", "Propofol"], "risk_level": "High"}	/reports/2026/pharmacy/high_alert_usage_weekly.pdf	PDF
935cd1f6-d7cb-4abe-9063-338fc5b3eb17	Hardware Error Log	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454	{"error_code": "E-104", "type": "Motor-Stall", "frequency": 12}	/reports/2026/tech/error_code_frequency.csv	CSV
3c8cdaf2-9973-4883-b1f7-571200174e3a	Staff Competency	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454	{"module": "Smart Pump Advanced", "completion_rate": "95%"}	/reports/2026/hr/nurse_training_compliance.pdf	PDF
4954d82e-bfb9-4cc9-b54c-e044ba21b15e	Maintenance Forecast	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454	{"component": "Battery", "replacement_due_count": 5}	/reports/2026/biomed/battery_forecast_q2.pdf	PDF
b7cc6766-93c1-4995-922e-52fe186eb7b8	Clinical Override Log	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454	{"type": "Soft Limit", "action": "Override", "count": 14}	/reports/2026/clinical/soft_limit_overrides.xlsx	XLSX
00f18017-157c-4c95-92bf-ffaf832bccdb	Volume Summary	970b61f2-e784-40b6-8621-82f0f906c638	2026-04-20 21:47:11.786454	{"ward": "Pediatrics", "total_volume_liters": 45.2}	/reports/2026/ward/peds_volume_summary.pdf	PDF
917f259c-f74b-4857-951e-95ce93069796	Decommissioning Report	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454	{"pumps_retired": 2, "reason": "Hardware EOL"}	/reports/2026/admin/decommissioned_assets.pdf	PDF
\.


--
-- TOC entry 5122 (class 0 OID 16938)
-- Dependencies: 225
-- Data for Name: system_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_configuration (config_id, key, value, description, updated_by, updated_at) FROM stdin;
ce4484c7-bc67-4ad1-9945-ae2dca341971	alarm_volume	8	Master volume level for all audible alerts (Range: 1-10).	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
1f8e8eea-fe93-41a7-be5e-1fe029adf896	low_battery_threshold	15	Percentage at which the "Low Battery" medium-severity warning is triggered.	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
dc88fe04-0bf0-4123-b84a-e4f24f78769e	default_kvo_rate	0.5	The default rate used when an infusion completes and Keep Vein Open mode starts.	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
6f059ede-72e7-407c-8c08-993166d734a0	max_hardware_rate	999.0	The absolute maximum rate the pump motor can physically support (mL/hr).	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
8f093d92-e41e-423d-9c43-8338c151e306	wifi_ssid	HOSPITAL_SECURE_EXT	The network name used for wireless data synchronization with the mobile app.	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
13edbe4d-ca28-4d71-b446-16b6e47edde5	occlusion_sensitivity	500	Downstream pressure threshold that triggers an Occlusion Alarm.	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
67ae0317-69c9-41d5-8bc6-a6e0599c11bf	screen_brightness	75	Default display brightness level for the pump physical interface.	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
55f8f0b9-f0a1-462d-be64-de9a40eea1f8	audit_retention_days	365	How long logs are stored locally before being archived or deleted.	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
01c65933-4457-4a86-b6af-fc172f39e0c1	ui_auto_lock	60	Time in seconds before the screen locks to prevent accidental changes.	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
81ff3845-f99d-4293-844e-e8c3e339d144	maintenance_due_months	12	Schedule for technical inspection and calibration of sensors.	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
68870d3d-2af7-48a0-a301-fdafcf6b32df	log_near_miss_events	TRUE	If enabled, the system logs attempts to enter doses that were blocked by Hard Limits.	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
65eaa7c0-0e04-49db-bc6a-93d54441c7e5	drug_library_version	2026.04.v1	The current version of the clinical drug limits database installed on the pump.	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
e9d78df4-37ab-439b-a6ba-ecead24bcd4b	max_bolus_allowed	20.0	The absolute maximum volume allowed for a single bolus burst regardless of drug type.	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
569b243d-9c34-49b7-9d9f-d8da60d47ccd	sync_interval_sec	30	How often the pump pushes real-time event logs to the central hospital server.	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
ffd8b72e-f1a0-4969-bd09-d2ad2f6c7da6	system_language	English/Arabic	The primary and secondary languages for the pump display and alarm messages.	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
d9d36aa9-44e1-4fef-8ef0-829a8370b64e	air_bubble_threshold_ul	50	The minimum size of a single air bubble required to trigger a Critical Stop alarm.	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
549069cd-389b-456f-a94d-5baa778cf751	battery_shutdown_threshold	3	The battery percentage at which the pump will perform a controlled emergency stop.	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
90db505a-7f27-4c63-8e05-5e907f724552	require_pin_for_bolus	TRUE	Whether the system requires the user to re-enter a PIN before starting a bolus.	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
9a59e5e7-ee84-439e-aa15-5abfdc5e866b	alarm_pitch_hz	440	The frequency of the alarm sound. Used for customizing alert tones in different wards.	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
4fa9fabe-ec23-426f-97ee-838928b561b2	pump_asset_id	PUMP-ICU-099	Unique identifier for the physical hardware unit within the hospital network.	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
\.


--
-- TOC entry 5124 (class 0 OID 16976)
-- Dependencies: 227
-- Data for Name: test_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_execution (execution_id, scenario_id, executed_by, executed_at, status, result_details) FROM stdin;
3c8ccc1b-df46-4075-afd2-51636478a1cb	8c26d788-a6df-4145-81a9-97554527ca0a	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-18 21:47:11.786454	Passed	Volume accuracy verified at 99.8%. Flow rate stable throughout 1-hour simulation.
9af042b0-3192-478e-bdfe-0693b059156d	04a10570-4efe-41fd-b6f5-224c8ab6c251	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-19 21:47:11.786454	Passed	System correctly blocked input of 50mL/hr. "Hard Limit" alarm triggered as expected.
fc70e86c-f238-40b3-b75f-18208bb8db40	d1b67e7c-4b50-4abf-9a65-e0200ec9e9aa	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 01:47:11.786454	Failed	Alarm triggered after 45 seconds. Required response time is <30 seconds. Sensor recalibration needed.
3359c08c-dea7-4989-80a0-074ffcf23215	55df8899-b5d4-472e-adfb-a9c1320e5672	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 03:47:11.786454	Passed	Motor stopped immediately upon 60uL air injection. Red strobe and audible alarm confirmed.
8f5518ef-52b1-40ba-86d4-13f0ec27d79a	\N	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 06:47:11.786454	Aborted	Test stopped manually by admin to investigate power supply noise.
d58641cb-ffc2-4f57-95e3-8f0605b5cd32	b83fc230-f1d0-476c-9b2f-b97f4a5f43bf	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 09:47:11.786454	Passed	Pump switched to 0.5 mL/hr rate perfectly at VTBI=0.
86cb5b19-0122-4bc5-a7c2-2237a3aec63c	c8049289-4718-421c-b761-9b0796d7f61a	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 11:47:11.786454	Failed	Motor continued to run for 2 seconds after door was forced open. Safety relay check required.
d151b6e7-ce73-42fb-b129-049717f44987	fcc5c715-cca4-4019-80d4-ace620141985	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 13:47:11.786454	Passed	Confirmed: Low-end hard limit for Heparin (Peds) correctly blocked 0.05 mL/hr input.
8daf4834-c13e-47f8-a855-bcfd89e1d761	d627f1c5-5950-49d1-add7-fa7feb3d226b	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 16:47:11.786454	Passed	Local log storage verified during WiFi outage. Re-sync completed once connection restored.
79c6b4c4-3403-4a7d-ad4a-3ce264cd8642	16897a52-7879-41cd-937e-81ef4aeedc7a	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 19:47:11.786454	Passed	Occlusion (High) correctly took visual priority over Low Battery (Medium).
5c7c94cb-4b1d-4856-8c28-bb0c970606d0	3de5d74d-cad3-4af9-8097-279040f98c63	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-19 21:47:11.786454	Passed	Screen brightness automatically reduced to 25% at 23:00. UI legibility maintained.
4b575d61-3811-4d03-a25a-a5c7f8bdd411	676f3183-32ec-4e10-913d-f6de854b252a	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-19 23:47:11.786454	Failed	Total infused volume calculated at 9.8mL instead of 10.0mL. Motor steps lost during high-speed delivery.
c110e200-81de-4658-a0ef-3a57a0162500	da17c66d-5a6b-4f9d-a77c-407b4204a9b8	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 01:47:11.786454	Passed	No interruption in infusion motor during AC disconnect. Status LED switched from Green to Amber.
7c565aac-2c59-4fd4-b354-e9445eb16c14	e6d44639-f9a6-40ae-9e9d-5b9959a3020f	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 03:47:11.786454	Passed	User automatically logged out after 300s of inactivity. Active infusion screen remained visible but locked.
73f36f71-251e-42df-87ba-649d18379a33	6ced975b-2b33-47b7-bf86-98d41b4b4c3a	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 05:47:11.786454	Passed	CRC Checksum failed for corrupt.json. System successfully restored drug library v2026.04.v1.
f58d9272-a239-48c9-90d4-0c029bb6942c	d0509486-e6df-4ea0-a769-d2b1078b2c99	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 07:47:11.786454	Passed	1-second pressure spike ignored by software filter. False alarm avoided.
2eddaeb3-058c-4018-89f2-c635f05d2380	6941895a-17f9-4eee-9d90-56d90ffc3e1a	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 09:47:11.786454	Passed	Pump stopped after 5th 10uL bubble. Cumulative air logic (Total > 50uL) working correctly.
7026c0cb-754b-4611-911e-d54464910de8	07af2dc4-6d1b-44a1-bbb2-3bf7a5e21f7d	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 11:47:11.786454	Passed	Flow sensors calibrated across all rates (1-999 mL/hr). Deviation within 1.5% margin.
2c578c76-e46f-4e9c-973f-92c863173eed	531b702e-66c7-48fb-a803-0b119cdcfb6e	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 13:47:11.786454	Passed	System correctly blocked Nurse John from modifying Morphine concentration limits.
76d5d0d0-b4da-4826-bf3d-970f10568d00	801e5339-ec12-442f-835a-510e65d7cda4	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 17:47:11.786454	Passed	Simulation completed. No memory leaks detected. Time drift < 0.5 seconds over 24-hour period.
\.


--
-- TOC entry 5123 (class 0 OID 16958)
-- Dependencies: 226
-- Data for Name: test_scenario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_scenario (scenario_id, name, description, script, created_by, created_at) FROM stdin;
8c26d788-a6df-4145-81a9-97554527ca0a	Baseline Saline Infusion	Simulates a standard 1-hour saline infusion at 100mL/hr to verify volume accuracy.	{ "steps": [{"action": "set_drug", "value": "Normal Saline 0.9%"}, {"action": "set_rate", "value": 100}, {"action": "start"}] }	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454
04a10570-4efe-41fd-b6f5-224c8ab6c251	Heparin Overdose Protection	Tests if the system correctly rejects a rate higher than 40mL/hr for Heparin.	{ "steps": [{"action": "set_drug", "value": "Heparin"}, {"action": "set_rate", "value": 50}, {"action": "verify_error", "type": "Hard Limit"}] }	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454
d1b67e7c-4b50-4abf-9a65-e0200ec9e9aa	Downstream Blockage Simulation	Starts an infusion and triggers a high-pressure occlusion alarm after 30 seconds.	{ "steps": [{"action": "start_infusion"}, {"delay": 30}, {"action": "trigger_sensor", "type": "occlusion", "value": "high"}] }	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
55df8899-b5d4-472e-adfb-a9c1320e5672	Air Bubble Detection	Verifies immediate motor shutdown when the ultrasonic sensor detects air.	{ "steps": [{"action": "start_infusion"}, {"action": "inject_air", "size": "60ul"}, {"action": "verify_status", "value": "Stopped"}] }	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454
ed0d4609-7e1d-4d85-865f-c03ff8d80d7f	Low Battery to Shutdown	Simulates rapid battery drop to test warning and critical shutdown levels.	{ "steps": [{"set_battery": 20}, {"wait": 10}, {"set_battery": 14}, {"verify_alarm": "Low Battery"}] }	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
b83fc230-f1d0-476c-9b2f-b97f4a5f43bf	VTBI Completion Logic	Simulates reaching the end of the infusion bag to verify KVO mode activation.	{ "steps": [{"set_vtbi": 1.0}, {"action": "infuse_all"}, {"verify_mode": "KVO"}] }	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454
c8049289-4718-421c-b761-9b0796d7f61a	Safety Interlock Check	Attempts to open the pump door while the motor is active.	{ "steps": [{"action": "start"}, {"action": "open_door"}, {"verify_alarm": "Door Open"}] }	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
fcc5c715-cca4-4019-80d4-ace620141985	Pediatric Limit Validation	Checks if the lower safety limits are correctly applied for pediatric concentrations.	{ "steps": [{"set_drug": "Heparin (Peds)"}, {"set_rate": 0.05}, {"verify_error": "Hard Limit Low"}] }	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454
d627f1c5-5950-49d1-add7-fa7feb3d226b	WiFi Disconnection Recovery	Simulates a WiFi drop and verifies that the pump continues to infuse safely offline.	{ "steps": [{"action": "start"}, {"action": "disable_wifi"}, {"verify_infusion": "Active"}] }	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
16897a52-7879-41cd-937e-81ef4aeedc7a	Dual Alarm Sorting	Triggers a Low Battery followed by an Occlusion to test alarm priority sorting.	{ "steps": [{"trigger": "Low Battery"}, {"trigger": "Occlusion"}, {"verify_priority": "Occlusion"}] }	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
3de5d74d-cad3-4af9-8097-279040f98c63	Auto-Dimming Check	Tests if the UI brightness dims automatically during night hours to prevent patient disturbance.	{ "steps": [{"set_system_time": "23:00"}, {"action": "check_brightness", "expected": "<30%"}, {"verify": "Night Mode Active"}] }	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
676f3183-32ec-4e10-913d-f6de854b252a	Emergency Bolus Overload	Simulates a rapid sequence of bolus requests to test motor stability and volume tracking.	{ "steps": [{"action": "bolus", "vol": "5ml"}, {"delay": 2}, {"action": "bolus", "vol": "5ml"}, {"verify_total_infused": "10ml"}] }	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454
da17c66d-5a6b-4f9d-a77c-407b4204a9b8	AC to Battery Seamless Transition	Simulates pulling the plug during an active infusion to ensure the motor doesn't stutter.	{ "steps": [{"action": "start"}, {"action": "disconnect_ac"}, {"verify_status": "Infusing"}, {"verify_source": "Battery"}] }	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
e6d44639-f9a6-40ae-9e9d-5b9959a3020f	User Session Timeout	Tests if the system logs out the current user after inactivity but keeps the infusion running.	{ "steps": [{"action": "login"}, {"action": "start"}, {"idle": 300}, {"verify_user": "Logged Out"}, {"verify_pump": "Running"}] }	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
6ced975b-2b33-47b7-bf86-98d41b4b4c3a	Corrupt Library Rollback	Attempts to upload a drug library with invalid JSON and verifies system stays on old version.	{ "steps": [{"action": "upload_library", "file": "corrupt.json"}, {"verify_error": "Invalid Format"}, {"verify_version": "current"}] }	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
d0509486-e6df-4ea0-a769-d2b1078b2c99	Transient Occlusion Filter	Simulates a 1-second pressure spike (patient moving arm) to see if the pump ignores "noise".	{ "steps": [{"action": "start"}, {"trigger_pressure": "600mmHg", "duration": "1s"}, {"verify_alarm": "None"}] }	a8dce4a6-6d4b-4b2b-8043-391673d815cb	2026-04-20 21:47:11.786454
6941895a-17f9-4eee-9d90-56d90ffc3e1a	Cumulative Air Bubble Limit	Triggers 5 tiny bubbles (10uL each) to test if the pump stops once the total air reaches 50uL.	{ "steps": [{"repeat": 5, "do": [{"inject_air": "10ul"}, {"delay": 60}]}, {"verify_alarm": "Air-in-Line"}] }	5514d990-93f1-4953-a721-5ab46ca45ae2	2026-04-20 21:47:11.786454
07af2dc4-6d1b-44a1-bbb2-3bf7a5e21f7d	Motor Calibration Protocol	Runs the motor at 10 different speeds to verify the flow sensor readings match the input.	{ "steps": [{"sweep_rates": [1, 10, 50, 100, 500, 999]}, {"action": "calibrate_sensors"}] }	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
531b702e-66c7-48fb-a803-0b119cdcfb6e	Drug Library Lockout	Tests if a user with "Nurse" role is blocked from editing drug concentration levels.	{ "steps": [{"login_as": "nurse_john"}, {"action": "edit_drug", "id": "any"}, {"verify_status": "Access Denied"}] }	1d515ee6-734f-4d52-a45e-3a129babec5f	2026-04-20 21:47:11.786454
801e5339-ec12-442f-835a-510e65d7cda4	24-Hour Continuous Run	Simulates a very long infusion to check for memory leaks or clock drift in the simulator.	{ "steps": [{"action": "start"}, {"simulate_time_passage": "24h"}, {"verify_volume": "calculated_vs_actual"}] }	1a38911e-b7ba-45b1-b7a1-01bccf09b848	2026-04-20 21:47:11.786454
\.


--
-- TOC entry 5117 (class 0 OID 16829)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, password_hash, role, created_at, last_login) FROM stdin;
1d515ee6-734f-4d52-a45e-3a129babec5f	admin_sarah	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Admin	2026-03-21 21:47:11.786454	\N
1a38911e-b7ba-45b1-b7a1-01bccf09b848	sys_mike	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Admin	2026-03-26 21:47:11.786454	\N
5514d990-93f1-4953-a721-5ab46ca45ae2	dr_ahmed	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Doctor	2026-03-31 21:47:11.786454	\N
a8dce4a6-6d4b-4b2b-8043-391673d815cb	dr_elena	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Doctor	2026-04-05 21:47:11.786454	\N
a021a5f2-01f1-4f83-a894-a1b192480504	nurse_john	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-10 21:47:11.786454	\N
47609940-c029-4823-be05-ee3ed460433f	nurse_layla	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-15 21:47:11.786454	\N
008c8e8a-a4c0-4a9e-9e3d-66a8f9d11e45	nurse_omar	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-18 21:47:11.786454	\N
970b61f2-e784-40b6-8621-82f0f906c638	nurse_chen	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-19 21:47:11.786454	\N
dbe0c954-fe36-438c-80bc-9b62ef39565e	nurse_maria	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-20 21:47:11.786454	\N
5a6391b9-992c-4bc9-bee1-d2cab10191e0	nurse_sam	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-20 21:47:11.786454	\N
8f6dd0fc-3133-4e37-a1a6-e0ab8e29f8a0	nurse_fatima	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-20 09:47:11.786454	\N
49777666-4e6b-4444-815d-09bdc03d9d91	nurse_robert	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-20 13:47:11.786454	\N
8c000bde-a225-4ddc-875b-739619cc56dc	nurse_yuki	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-20 15:47:11.786454	\N
f5ac9202-7447-496b-8a92-877d50d2c80a	nurse_gabriel	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-20 17:47:11.786454	\N
71bbd316-9851-4163-9005-1b186b9c6166	nurse_sana	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Nurse	2026-04-20 19:47:11.786454	\N
00a1bd81-c9e1-4371-bacc-8765e480919e	dr_kovac	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Doctor	2026-04-02 21:47:11.786454	\N
983681f6-fb0b-4f6f-a452-dbfb74e74c2a	dr_smith	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Doctor	2026-04-08 21:47:11.786454	\N
2ffe67d1-1b8e-4397-b330-c5d2e82463c6	it_support_1	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Admin	2026-03-06 21:47:11.786454	\N
b7ffbe75-a26f-4e09-98ae-70acc8fdec03	it_support_2	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Admin	2026-03-11 21:47:11.786454	\N
1e08a6c2-f7fc-4903-83f5-14f59ec8f8d9	it_lead_hend	$2b$12$HirzyyD7hx3lzYAAsRtiDunD0vsgUIyARNS3DFQQo/cP.pKpghGU.	Admin	2026-03-13 21:47:11.786454	\N
\.


--
-- TOC entry 4941 (class 2606 OID 16910)
-- Name: alarm alarm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alarm
    ADD CONSTRAINT alarm_pkey PRIMARY KEY (alarm_id);


--
-- TOC entry 4943 (class 2606 OID 16932)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (log_id);


--
-- TOC entry 4935 (class 2606 OID 16860)
-- Name: drug drug_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug
    ADD CONSTRAINT drug_name_key UNIQUE (name);


--
-- TOC entry 4937 (class 2606 OID 16858)
-- Name: drug drug_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug
    ADD CONSTRAINT drug_pkey PRIMARY KEY (drug_id);


--
-- TOC entry 4955 (class 2606 OID 17028)
-- Name: event_log event_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log
    ADD CONSTRAINT event_log_pkey PRIMARY KEY (event_id);


--
-- TOC entry 4939 (class 2606 OID 16885)
-- Name: infusion_session infusion_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.infusion_session
    ADD CONSTRAINT infusion_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 4953 (class 2606 OID 17010)
-- Name: report report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_pkey PRIMARY KEY (report_id);


--
-- TOC entry 4945 (class 2606 OID 16952)
-- Name: system_configuration system_configuration_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_configuration
    ADD CONSTRAINT system_configuration_key_key UNIQUE (key);


--
-- TOC entry 4947 (class 2606 OID 16950)
-- Name: system_configuration system_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_configuration
    ADD CONSTRAINT system_configuration_pkey PRIMARY KEY (config_id);


--
-- TOC entry 4951 (class 2606 OID 16987)
-- Name: test_execution test_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_execution
    ADD CONSTRAINT test_execution_pkey PRIMARY KEY (execution_id);


--
-- TOC entry 4949 (class 2606 OID 16970)
-- Name: test_scenario test_scenario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_scenario
    ADD CONSTRAINT test_scenario_pkey PRIMARY KEY (scenario_id);


--
-- TOC entry 4931 (class 2606 OID 16840)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4933 (class 2606 OID 16842)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4960 (class 2606 OID 16916)
-- Name: alarm alarm_acknowledged_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alarm
    ADD CONSTRAINT alarm_acknowledged_by_fkey FOREIGN KEY (acknowledged_by) REFERENCES public.users(user_id);


--
-- TOC entry 4961 (class 2606 OID 16911)
-- Name: alarm alarm_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alarm
    ADD CONSTRAINT alarm_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.infusion_session(session_id);


--
-- TOC entry 4962 (class 2606 OID 16933)
-- Name: audit_log audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 4956 (class 2606 OID 16861)
-- Name: drug drug_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug
    ADD CONSTRAINT drug_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id);


--
-- TOC entry 4957 (class 2606 OID 16866)
-- Name: drug drug_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug
    ADD CONSTRAINT drug_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(user_id);


--
-- TOC entry 4968 (class 2606 OID 17029)
-- Name: event_log event_log_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log
    ADD CONSTRAINT event_log_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.infusion_session(session_id);


--
-- TOC entry 4969 (class 2606 OID 17034)
-- Name: event_log event_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_log
    ADD CONSTRAINT event_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 4958 (class 2606 OID 16891)
-- Name: infusion_session infusion_session_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.infusion_session
    ADD CONSTRAINT infusion_session_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drug(drug_id);


--
-- TOC entry 4959 (class 2606 OID 16886)
-- Name: infusion_session infusion_session_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.infusion_session
    ADD CONSTRAINT infusion_session_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 4967 (class 2606 OID 17011)
-- Name: report report_generated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_generated_by_fkey FOREIGN KEY (generated_by) REFERENCES public.users(user_id);


--
-- TOC entry 4963 (class 2606 OID 16953)
-- Name: system_configuration system_configuration_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_configuration
    ADD CONSTRAINT system_configuration_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(user_id);


--
-- TOC entry 4965 (class 2606 OID 16993)
-- Name: test_execution test_execution_executed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_execution
    ADD CONSTRAINT test_execution_executed_by_fkey FOREIGN KEY (executed_by) REFERENCES public.users(user_id);


--
-- TOC entry 4966 (class 2606 OID 16988)
-- Name: test_execution test_execution_scenario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_execution
    ADD CONSTRAINT test_execution_scenario_id_fkey FOREIGN KEY (scenario_id) REFERENCES public.test_scenario(scenario_id);


--
-- TOC entry 4964 (class 2606 OID 16971)
-- Name: test_scenario test_scenario_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_scenario
    ADD CONSTRAINT test_scenario_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id);


-- Completed on 2026-04-23 17:05:57

--
-- PostgreSQL database dump complete
--

\unrestrict lwGmROOOekgZZNegdOSJNn6vSBfvNRbwQvF06O3Io3aHyOWfyskAPIVL34hLTv1

