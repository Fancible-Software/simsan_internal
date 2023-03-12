--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: configurations; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.configurations (
    id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL,
    "isImage" boolean DEFAULT false NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "createdBy" character varying NOT NULL
);


ALTER TABLE public.configurations OWNER TO admin;

--
-- Name: configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.configurations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.configurations_id_seq OWNER TO admin;

--
-- Name: configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.configurations_id_seq OWNED BY public.configurations.id;


--
-- Name: form; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.form (
    "formId" integer NOT NULL,
    "invoiceUuid" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "customerName" character varying NOT NULL,
    "customerEmail" character varying NOT NULL,
    "customerPhone" character varying,
    "customerAddress" character varying NOT NULL,
    "customerPostalCode" character varying NOT NULL,
    "customerCity" character varying NOT NULL,
    "customerProvince" character varying NOT NULL,
    "customerCountry" character varying DEFAULT 'Canada'::character varying NOT NULL,
    total character varying NOT NULL,
    discount character varying NOT NULL,
    discount_percent character varying NOT NULL,
    is_taxable boolean NOT NULL,
    final_amount character varying NOT NULL,
    is_invoice_generated boolean DEFAULT false,
    invoice_id character varying,
    invoice_path character varying,
    "updatedAt" timestamp without time zone DEFAULT now(),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "createdBy" character varying NOT NULL,
    type character varying NOT NULL,
    "invoiceNumber" character varying NOT NULL,
    comment character varying
);


ALTER TABLE public.form OWNER TO admin;

--
-- Name: form_formId_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public."form_formId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."form_formId_seq" OWNER TO admin;

--
-- Name: form_formId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public."form_formId_seq" OWNED BY public.form."formId";


--
-- Name: form_to_services; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.form_to_services (
    id integer NOT NULL,
    price character varying NOT NULL,
    "formId" integer NOT NULL,
    "serviceId" integer NOT NULL
);


ALTER TABLE public.form_to_services OWNER TO admin;

--
-- Name: form_to_services_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.form_to_services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.form_to_services_id_seq OWNER TO admin;

--
-- Name: form_to_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.form_to_services_id_seq OWNED BY public.form_to_services.id;


--
-- Name: location; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.location (
    "locationId" integer NOT NULL,
    city character varying NOT NULL,
    city_ascii character varying NOT NULL,
    province_id character varying NOT NULL,
    province_name character varying NOT NULL,
    lat character varying NOT NULL,
    lng character varying NOT NULL,
    population character varying NOT NULL,
    density character varying NOT NULL,
    timezone character varying NOT NULL,
    ranking integer NOT NULL,
    postal character varying(4000) NOT NULL,
    city_id character varying NOT NULL
);


ALTER TABLE public.location OWNER TO admin;

--
-- Name: location_locationId_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public."location_locationId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."location_locationId_seq" OWNER TO admin;

--
-- Name: location_locationId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public."location_locationId_seq" OWNED BY public.location."locationId";


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.migrations OWNER TO admin;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_id_seq OWNER TO admin;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: service; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.service (
    "serviceId" integer NOT NULL,
    "serviceName" character varying NOT NULL,
    "isActive" integer DEFAULT 1 NOT NULL,
    price character varying DEFAULT '0'::character varying NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "createdBy" character varying DEFAULT 'default'::character varying NOT NULL,
    priority integer DEFAULT 0
);


ALTER TABLE public.service OWNER TO admin;

--
-- Name: service_serviceId_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public."service_serviceId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."service_serviceId_seq" OWNER TO admin;

--
-- Name: service_serviceId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public."service_serviceId_seq" OWNED BY public.service."serviceId";


--
-- Name: typeorm_metadata; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.typeorm_metadata (
    type character varying NOT NULL,
    database character varying,
    schema character varying,
    "table" character varying,
    name character varying,
    value text
);


ALTER TABLE public.typeorm_metadata OWNER TO admin;

--
-- Name: user; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    mobile_no character varying NOT NULL,
    password character varying NOT NULL,
    is_login character varying DEFAULT '0'::character varying NOT NULL,
    is_active integer DEFAULT 1 NOT NULL,
    roles character varying DEFAULT 'sub_admin'::character varying NOT NULL,
    "createdBy" character varying NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    verified_at timestamp without time zone,
    "updatedAt" timestamp without time zone DEFAULT now(),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    is_deleted integer DEFAULT 0 NOT NULL,
    deleted_at timestamp without time zone,
    deleted_by integer
);


ALTER TABLE public."user" OWNER TO admin;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO admin;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: user_verification; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_verification (
    id integer NOT NULL,
    token character varying NOT NULL,
    type character varying NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "userIdId" integer
);


ALTER TABLE public.user_verification OWNER TO admin;

--
-- Name: user_verification_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.user_verification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_verification_id_seq OWNER TO admin;

--
-- Name: user_verification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.user_verification_id_seq OWNED BY public.user_verification.id;


--
-- Name: configurations id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.configurations ALTER COLUMN id SET DEFAULT nextval('public.configurations_id_seq'::regclass);


--
-- Name: form formId; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.form ALTER COLUMN "formId" SET DEFAULT nextval('public."form_formId_seq"'::regclass);


--
-- Name: form_to_services id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.form_to_services ALTER COLUMN id SET DEFAULT nextval('public.form_to_services_id_seq'::regclass);


--
-- Name: location locationId; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.location ALTER COLUMN "locationId" SET DEFAULT nextval('public."location_locationId_seq"'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: service serviceId; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.service ALTER COLUMN "serviceId" SET DEFAULT nextval('public."service_serviceId_seq"'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: user_verification id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_verification ALTER COLUMN id SET DEFAULT nextval('public.user_verification_id_seq'::regclass);


--
-- Data for Name: configurations; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.configurations (id, key, value, "isImage", "updatedAt", "createdAt", "createdBy") FROM stdin;
2	gst	HYGYGYA123	f	2023-01-20 14:51:28.584144	2023-01-20 14:51:28.584144	Admin
3	company_name	Simsan Maintenance Pvt. Ltd.	f	2023-01-20 14:53:46.471448	2023-01-20 14:53:46.471448	Admin
6	company_country	CANADA	f	2023-01-20 14:53:46.471448	2023-01-20 14:53:46.471448	Admin
4	company_address	2175 Fraser Avenue	f	2023-01-20 14:53:46.471448	2023-01-20 14:53:46.471448	Admin
5	company_city	Port Coquitlam	f	2023-01-20 14:53:46.471448	2023-01-20 14:53:46.471448	Admin
7	company_zip	V3B0H8	f	2023-01-20 14:53:46.471448	2023-01-20 14:53:46.471448	Admin
1	logo	http://billing.simsanfrasermain.com/api/assets/img/1668802931748_logo_simsan_fraser_cropped.png	t	2023-01-20 14:51:28.584144	2023-01-20 14:51:28.584144	Admin
\.


--
-- Data for Name: form; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.form ("formId", "invoiceUuid", "customerName", "customerEmail", "customerPhone", "customerAddress", "customerPostalCode", "customerCity", "customerProvince", "customerCountry", total, discount, discount_percent, is_taxable, final_amount, is_invoice_generated, invoice_id, invoice_path, "updatedAt", "createdAt", "createdBy", type, "invoiceNumber", comment) FROM stdin;
41	260c7b4c-b5c6-4e46-a08f-786d8eb3639e	Vikas Arora	aroravikas583@gmail.com	9779866222	n305 hoston street	ADS123	Vancouver	BC	Canada	1000	0	0	t	1050.00	f	\N	\N	2023-03-08 08:50:56.11806	2023-03-08 08:50:56.11806	1	QUOTE	1678265456114	
42	b94402b5-39cb-4318-9887-5fcd5f072e2c	Vikas Arora	aroravikas583@gmail.com	9779866222	hoston street	AS12A1	Vancouver	BC	Canada	600	0	0	t	630.00	f	\N	\N	2023-03-08 16:03:55.800325	2023-03-08 16:03:55.800325	1	FORM	1678291435798	
43	fbde8ed7-8c99-415e-9929-d88c2b9064fb	Sandeep Sanctis	sandeep9993@gmail.com	6048804476	312-2175 Fraser Avenue	V3B0H8	Port Coquitlam	BC	Canada	1000	100	10	t	945.00	f	\N	\N	2023-03-09 05:34:06.731441	2023-03-09 05:34:06.726	1	FORM	1678339654872	Start the job at 11.00 AM
44	0e2c0b36-ef88-4b80-8152-a5773adf0ada	Matt	sandeep9993@gmail.com	67987987987	jlkjdalskjdasjd	v3b0h8	Coquitlam	BC	Canada	450	45	10	f	405	f	\N	\N	2023-03-09 05:53:10.601137	2023-03-09 05:53:10.601137	8	QUOTE	1678341190600	lkklks;dlk
\.


--
-- Data for Name: form_to_services; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.form_to_services (id, price, "formId", "serviceId") FROM stdin;
366	100	41	1
367	200	41	2
368	400	41	3
369	100	41	4
370	200	41	5
371	100	42	1
372	200	42	2
373	100	42	3
374	200	42	4
375	600	43	1
376	250	43	2
377	150	43	3
378	150	44	4
379	200	44	18
380	100	44	13
\.


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.location ("locationId", city, city_ascii, province_id, province_name, lat, lng, population, density, timezone, ranking, postal, city_id) FROM stdin;
1	Toronto	Toronto	ON	Ontario	43.7417	-79.3733	5429524	4334.4	America/Toronto	1	M5T M5V M5P M5S M5R M5E M5G M5A M5C M5B M5M M5N M5H M5J M4X M4Y M4R M4S M4P M4V M4W M4T M4J M4K M4H M4N M4L M4M M4B M4C M4A M4G M4E M3N M3M M3L M3K M3J M3H M3C M3B M3A M2P M2R M2L M2M M2N M2H M2J M2K M1C M1B M1E M1G M1H M1K M1J M1M M1L M1N M1P M1S M1R M1T M1W M1V M1X M9P M9R M9W M9V M9M M9L M9N M9A M9C M9B M6P M6R M6S M6A M6B M6C M6E M6G M6H M6J M6K M6L M6M M6N M8Z M8X M8Y M8V M8W	1124279679
2	Montréal	Montreal	QC	Quebec	45.5089	-73.5617	3519595	3889	America/Montreal	1	H1X H1Y H1Z H1P H1R H1S H1T H1V H1W H1H H1J H1K H1L H1M H1N H1A H1B H1C H1E H1G H2Y H2X H2Z H2T H2W H2V H2P H2S H2R H2M H2L H2N H2H H2K H2J H2E H2G H2A H2C H2B H3B H3C H3A H3G H3E H3J H3K H3H H3N H3L H3M H3R H3S H3V H3W H3T H3X H4G H4E H4C H4B H4A H4N H4M H4L H4K H4J H4H H4V H4S H4R H4P H8N H8S H8R H8P H8T H8Z H8Y H9A H9C H9E H9H H9J H9K	1124586170
3	Vancouver	Vancouver	BC	British Columbia	49.25	-123.1	2264823	5492.6	America/Vancouver	1	V6Z V6S V6R V6P V6N V6M V6L V6K V6J V6H V6G V6E V6C V6B V6A V5S V5P V5Z V5N V5L V5M V5K V5V V5W V5T V5R V5X V5Y	1124825478
4	Calgary	Calgary	AB	Alberta	51.05	-114.0667	1239220	1501.1	America/Edmonton	1	T1Y T2H T2K T2J T2L T2N T2A T2C T2B T2E T2G T2Y T2X T2Z T2S T2R T2T T2V T3N T3L T3M T3J T3K T3H T3G T3E T3B T3C T3A T3R T3S T3P	1124690423
5	Edmonton	Edmonton	AB	Alberta	53.5344	-113.4903	1062643	1360.9	America/Edmonton	1	T5X T5Y T5Z T5P T5R T5S T5T T5V T5W T5H T5J T5K T5L T5M T5N T5A T5B T5C T5E T5G T6X T6T T6W T6V T6P T6S T6R T6M T6L T6H T6K T6J T6E T6G T6A T6C T6B	1124290735
6	Ottawa	Ottawa	ON	Ontario	45.4247	-75.695	989567	334	America/Montreal	1	K4P K4M K4A K4B K4C K7S K1S K1R K1P K1W K1V K1T K1Z K1Y K1X K1C K1B K1G K1E K1K K1J K1H K1N K1M K1L K0A K2R K2S K2P K2V K2W K2T K2J K2K K2H K2L K2M K2B K2C K2A K2G K2E	1124399363
7	Mississauga	Mississauga	ON	Ontario	43.6	-79.65	721599	2467.6	America/Toronto	2	L4W L4V L4T L4Z L4Y L4X L5R L5V L5W L5A L5B L5C L5E L5G L5H L5J L5K L5L L5M L5N	1124112672
8	Winnipeg	Winnipeg	MB	Manitoba	49.8844	-97.1464	705244	1430	America/Winnipeg	1	R2N R2M R2L R2K R2J R2H R2G R2C R2Y R2X R2W R2V R2R R2P R3L R3M R3N R3H R3J R3K R3E R3G R3A R3B R3X R3Y R3T R3V R3W R3P R3R R3S	1124224963
9	Quebec City	Quebec City	QC	Quebec	46.8139	-71.2081	705103	1173.2	America/Montreal	1	G1N G1M G1L G1K G1J G1H G1G G1E G1C G1B G1Y G1X G1W G1V G1T G1S G1R G1P G3E G3G G3K G3J G2G G2E G2B G2C G2A G2N G2L G2M G2J G2K	1124823933
10	Hamilton	Hamilton	ON	Ontario	43.2567	-79.8692	693645	480.6	America/Toronto	2	L0R L0P L8W L8V L8T L8S L8R L8P L8G L8E L8N L8M L8L L8K L8J L8H L9G L9A L9B L9C L9H L9K N1R	1124567288
11	Brampton	Brampton	ON	Ontario	43.6833	-79.7667	593638	2228.7	America/Toronto	2	L7A L6T L6W L6V L6P L6S L6R L6Y L6X L6Z	1124625989
12	Surrey	Surrey	BC	British Columbia	49.19	-122.8489	517887	1636.8	America/Vancouver	2	V4A V4N V4P V3R V3S V3T V3V V3W V3X V3Z	1124001454
13	Kitchener	Kitchener	ON	Ontario	43.4186	-80.4728	470015	3433.5	America/Toronto	1	N2K N2H N2N N2M N2C N2B N2A N2G N2E N2R N2P	1124158530
14	Laval	Laval	QC	Quebec	45.5833	-73.75	422993	1710.9	America/Montreal	2	H7N H7L H7M H7J H7K H7H H7G H7E H7B H7C H7A H7X H7Y H7V H7W H7T H7R H7S H7P	1124922301
15	Halifax	Halifax	NS	Nova Scotia	44.6475	-63.5906	403131	73.4	America/Halifax	1	B2Z B2Y B2X B2W B2V B2T B2S B2R B3T B3V B3P B3R B3L B3M B3N B3H B3J B3K B3E B3G B3A B3B B0J B3Z B3S B4E B4G B4A B4C B4B B0N	1124130981
16	London	London	ON	Ontario	42.9836	-81.2497	383822	913.1	America/Toronto	2	N5Z N5X N5Y N5V N5W N6A N6P N6G N6E N6C N6N N6L N6J N6H N6B N6M N6K	1124469960
17	Victoria	Victoria	BC	British Columbia	48.4283	-123.3647	335696	4406.3	America/Vancouver	1	V8T V8W V8S V8R V9A V8V	1124147219
18	Markham	Markham	ON	Ontario	43.8767	-79.2633	328966	1549.2	America/Toronto	2	L3T L3R L3P L3S L6E L6G L6C L6B	1124272698
19	St. Catharines	St. Catharines	ON	Ontario	43.1833	-79.2333	309319	1384.8	America/Toronto	2	L2M L2N L2P L2S L2R L2T L2W	1124140229
20	Niagara Falls	Niagara Falls	ON	Ontario	43.06	-79.1067	308596	419.9	America/Toronto	2	L2E L2G L2H L2J L3B	1124704011
21	Vaughan	Vaughan	ON	Ontario	43.8333	-79.5	306233	1119.4	America/Toronto	2	L0J L4K L4J L4H L4L L6A	1124000141
22	Gatineau	Gatineau	QC	Quebec	45.4833	-75.65	276245	773.7	America/Montreal	2	J8P J8R J8T J8Y J8X J8Z J8M J9J J9H J9A	1124722129
23	Windsor	Windsor	ON	Ontario	42.2833	-83	276165	1484.3	America/Toronto	2	N8T N8W N8P N8S N8R N8Y N8X N9J N9B N9C N9A N9G N9E N0R	1124261024
24	Saskatoon	Saskatoon	SK	Saskatchewan	52.1333	-106.6833	246376	1080	America/Regina	2	S7H S7K S7J S7M S7L S7N S7S S7R S7W S7V	1124612546
25	Longueuil	Longueuil	QC	Quebec	45.5333	-73.5167	239700	2002	America/Montreal	2	J4T J4V J4P J4R J4M J4L J4N J4H J4K J4J J4G J3Y J3Z	1124122753
26	Burnaby	Burnaby	BC	British Columbia	49.2667	-122.9667	232755	2568.7	America/Vancouver	2	V5B V5G V5E V5C V5J V5H V5A V3J V3N	1124817304
27	Regina	Regina	SK	Saskatchewan	50.4547	-104.6067	215106	1195.2	America/Regina	2	S4T S4V S4W S4R S4S S4X S4Y S4Z	1124342541
28	Richmond	Richmond	BC	British Columbia	49.1667	-123.1333	198309	1534.1	America/Vancouver	2	V6Y V6X V6W V6V V7E V7A V7B V7C	1124121940
29	Richmond Hill	Richmond Hill	ON	Ontario	43.8667	-79.4333	195022	1928.8	America/Toronto	2	L4S L4C L4B L4E	1124364273
30	Oakville	Oakville	ON	Ontario	43.45	-79.6833	193832	1314.2	America/Toronto	2	L6M L6L L6H L6K L6J	1124080468
31	Burlington	Burlington	ON	Ontario	43.3167	-79.8	183314	946.8	America/Toronto	2	L7R L7S L7P L7T L7N L7L L7M	1124955083
32	Barrie	Barrie	ON	Ontario	44.3711	-79.6769	172657	1428	America/Toronto	2	L9J L4N L4M	1124340223
33	Oshawa	Oshawa	ON	Ontario	43.9	-78.85	166000	1027	America/Toronto	2	L1L L1H L1J L1K L1G	1124541904
34	Sherbrooke	Sherbrooke	QC	Quebec	45.4	-71.9	161323	456	America/Montreal	2	J1N J1L J1M J1J J1K J1H J1G J1E J1C J1R	1124559506
35	Saguenay	Saguenay	QC	Quebec	48.4167	-71.0667	144746	128.5	America/Montreal	2	G8A G7N G7H G7K G7T G7Z G7G G7B G7J G7P G7S G7Y G7X	1124001930
36	Lévis	Levis	QC	Quebec	46.8	-71.1833	143414	319.4	America/Montreal	2	G7A G6J G6K G6C G6Z G6X G6Y G6V G6W	1124958950
37	Kelowna	Kelowna	BC	British Columbia	49.8881	-119.4956	142146	601.3	America/Vancouver	2	V1X V1Y V1P V1W V1V	1124080626
38	Abbotsford	Abbotsford	BC	British Columbia	49.05	-122.3167	141397	376.5	America/Vancouver	2	V4X V2S V2T V3G	1124808029
39	Coquitlam	Coquitlam	BC	British Columbia	49.2839	-122.7919	139284	1138.9	America/Vancouver	2	V3B V3C V3E V3J V3K	1124000500
40	Trois-Rivières	Trois-Rivieres	QC	Quebec	46.35	-72.55	134413	1581.2	America/Montreal	2	G9C G9B G9A G8T G8V G8W G8Y G8Z	1124407487
41	Guelph	Guelph	ON	Ontario	43.55	-80.25	131794	1511.1	America/Toronto	2	N1C N1G N1E N1K N1H N1L	1124968815
42	Cambridge	Cambridge	ON	Ontario	43.3972	-80.3114	129920	1149.6	America/Toronto	2	N3H N3C N3E N1R N1S N1P N1T	1124113576
43	Whitby	Whitby	ON	Ontario	43.8833	-78.9417	128377	876.1	America/Toronto	2	L0B L1P L1R L1M L1N	1124112077
44	Ajax	Ajax	ON	Ontario	43.8583	-79.0364	119677	1634.2	America/Toronto	2	L1Z L1T L1S	1124382916
45	Langley	Langley	BC	British Columbia	49.1044	-122.5827	117285	380.8	America/Vancouver	2	V1M V4W V2Z V2Y V3A	1124000480
46	Saanich	Saanich	BC	British Columbia	48.484	-123.381	114148	1099.9	America/Vancouver	2	V8N V8X V8Z V8P V8R V9A V9E V8Y	1124000949
47	Terrebonne	Terrebonne	QC	Quebec	45.7	-73.6333	111575	687.1	America/Montreal	2	J6Y J6V J7M J6X J6W	1124993674
48	Milton	Milton	ON	Ontario	43.5083	-79.8833	110128	230.11	America/Toronto	2	L7J L0P L9T	1124001426
49	St. John's	St. John's	NL	Newfoundland and Labrador	47.4817	-52.7971	108860	244.1	America/St_Johns	2	A1H A1S A1E A1G A1A A1C A1B	1124741456
50	Moncton	Moncton	NB	New Brunswick	46.1328	-64.7714	108620	506	America/Moncton	2	E1H E1A E1C E1E E1G	1124521303
51	Thunder Bay	Thunder Bay	ON	Ontario	48.3822	-89.2461	107909	330.1	America/Thunder_Bay	2	P7G P7E P7B P7C P7J P7K	1124398712
52	Dieppe	Dieppe	NB	New Brunswick	46.0989	-64.7242	107068	469.6	America/Moncton	2	E1A	1124195431
53	Waterloo	Waterloo	ON	Ontario	43.4667	-80.5167	104986	1520.7	America/Toronto	2	N2K N2J N2L N2V N2T	1124321390
54	Delta	Delta	BC	British Columbia	49.0847	-123.0586	102238	567.4	America/Vancouver	2	V4C V4E V4G V4K V4M V4L	1124001200
55	Chatham	Chatham	ON	Ontario	42.4229	-82.1324	101647	41.4	America/Toronto	2	N8A N0P N7L N7M	1124393373
56	Red Deer	Red Deer	AB	Alberta	52.2681	-113.8111	100418	958.8	America/Edmonton	2	T4R T4P T4N	1124404130
57	Kamloops	Kamloops	BC	British Columbia	50.6761	-120.3408	100046	301.7	America/Vancouver	2	V1S V2C V2B V2E	1124735582
58	Brantford	Brantford	ON	Ontario	43.1667	-80.25	97496	1345.9	America/Toronto	3	N3P N3R N3S N3T N3V	1124737006
59	Cape Breton	Cape Breton	NS	Nova Scotia	46.1389	-60.1931	94285	38.8	America/Glace_Bay	3	B2A B1S B1V B1G B1E B1B B1C B1A B1N B1L B1M B1J B1H B1T B1R B1P B1Y B1K	1124000383
60	Lethbridge	Lethbridge	AB	Alberta	49.6942	-112.8328	92729	759.5	America/Edmonton	3	T1H T1J T1K	1124321200
61	Saint-Jean-sur-Richelieu	Saint-Jean-sur-Richelieu	QC	Quebec	45.3167	-73.2667	92394	419.7	America/Montreal	3	J2W J2Y J2X J3A J3B	1124278447
62	Clarington	Clarington	ON	Ontario	43.935	-78.6083	92013	138.3	America/Toronto	3	L0B L0A L1E L1B L1C	1124000882
63	Pickering	Pickering	ON	Ontario	43.8354	-79.089	91771	383.1	America/Toronto	3	L0H L0B L1X L1Y L1V L1W	1124781814
64	Nanaimo	Nanaimo	BC	British Columbia	49.1642	-123.9364	90504	918	America/Vancouver	3	V9R V9S V9V V9T	1124623893
65	Sudbury	Sudbury	ON	Ontario	46.49	-81.01	88054	49.7	America/Toronto	3	P0M P3N P3L P3B P3C P3A P3G P3Y P3P	1124539524
66	North Vancouver	North Vancouver	BC	British Columbia	49.3641	-123.0066	85935	534.6	America/Vancouver	3	V7P V7R V7L V7N V7H V7J V7K V7G	1124000146
67	Brossard	Brossard	QC	Quebec	45.4667	-73.45	85721	1896	America/Montreal	3	J4Y J4X J4Z J4W	1124655166
68	Repentigny	Repentigny	QC	Quebec	45.7333	-73.4667	84965	1395.4	America/Montreal	3	J6A J5Z J5Y	1124379778
69	Newmarket	Newmarket	ON	Ontario	44.05	-79.4667	84224	2190.5	America/Toronto	2	L3X L3Y	1124400266
70	Chilliwack	Chilliwack	BC	British Columbia	49.1577	-121.9509	83788	320.2	America/Vancouver	3	V4Z V2R V2P	1124531262
71	White Rock	White Rock	BC	British Columbia	49.025	-122.8028	82368	3893.1	America/Vancouver	2	V4B	1124260555
72	Maple Ridge	Maple Ridge	BC	British Columbia	49.2167	-122.6	82256	308.3	America/Vancouver	3	V4R V2W V2X	1124001699
73	Peterborough	Peterborough	ON	Ontario	44.3	-78.3167	82094	1261.2	America/Toronto	3	K9K K9J K9H K9L	1124440356
74	Kawartha Lakes	Kawartha Lakes	ON	Ontario	44.35	-78.75	75423	24.5	America/Toronto	3	L0K L0B L0A K9V K0M	1124000852
75	Prince George	Prince George	BC	British Columbia	53.9169	-122.7494	74003	232.5	America/Vancouver	3	V2K V2N V2M V2L	1124733292
76	Sault Ste. Marie	Sault Ste. Marie	ON	Ontario	46.5333	-84.35	73368	328.6	America/Toronto	3	P6A P6C P6B	1124810690
77	Sarnia	Sarnia	ON	Ontario	42.9994	-82.3089	71594	434.3	America/Toronto	3	N7V N7W N7S N7T N7X	1124509835
78	Wood Buffalo	Wood Buffalo	AB	Alberta	57.6042	-111.3284	71589	1.2	America/Edmonton	3	T9H T9J T9K T0P	1124001123
79	New Westminster	New Westminster	BC	British Columbia	49.2069	-122.9111	70996	4543.4	America/Vancouver	2	V3L V3M	1124196524
80	Châteauguay	Chateauguay	QC	Quebec	45.38	-73.75	70812	1278.9	America/Montreal	3	J6K J6J	1124437897
81	Saint-Jérôme	Saint-Jerome	QC	Quebec	45.7833	-74	69598	756.3	America/Montreal	3	J7Y J7Z J5L	1124268324
82	Drummondville	Drummondville	QC	Quebec	45.8833	-72.4833	68601	1315.4	America/Montreal	3	J2E J2C J2B J2A J1Z	1124624283
83	Saint John	Saint John	NB	New Brunswick	45.2806	-66.0761	67575	213.8	America/Moncton	3	E2P E2L E2M E2N E2H E2J E2K	1124631364
84	Caledon	Caledon	ON	Ontario	43.8667	-79.8667	66502	96.6	America/Toronto	3	L7K L7C L7E	1124070007
85	St. Albert	St. Albert	AB	Alberta	53.6303	-113.6258	65589	1353.9	America/Edmonton	3	T8N	1124850754
86	Granby	Granby	QC	Quebec	45.4	-72.7333	63433	415.3	America/Montreal	3	J2G J2J J2H	1124502071
87	Medicine Hat	Medicine Hat	AB	Alberta	50.0417	-110.6775	63260	564.6	America/Edmonton	3	T1A T1B T1C	1124303972
88	Grande Prairie	Grande Prairie	AB	Alberta	55.1708	-118.7947	63166	475.9	America/Edmonton	3	T8V T8X T8W	1124505481
89	St. Thomas	St. Thomas	ON	Ontario	42.775	-81.1833	61707	1067.3	America/Toronto	3	N5R N5P	1124790209
90	Airdrie	Airdrie	AB	Alberta	51.2917	-114.0144	61581	728.2	America/Edmonton	3	T4B T4A	1124990202
91	Halton Hills	Halton Hills	ON	Ontario	43.63	-79.95	61161	221.4	America/Toronto	3	L7J L7G L0P L9T	1124000788
92	Saint-Hyacinthe	Saint-Hyacinthe	QC	Quebec	45.6167	-72.95	59614	294.5	America/Montreal	3	J2T J2S J2R	1124010116
93	Lac-Brome	Lac-Brome	QC	Quebec	45.2167	-72.5167	58889	27.3	America/Montreal	3	J0E	1124000579
94	Port Coquitlam	Port Coquitlam	BC	British Columbia	49.2625	-122.7811	58612	2009.4	America/Vancouver	2	V3B V3C	1124473757
95	Fredericton	Fredericton	NB	New Brunswick	45.9636	-66.6431	58220	439.2	America/Moncton	3	E3G E3C E3B E3A	1124061289
96	Blainville	Blainville	QC	Quebec	45.67	-73.88	56363	1030.9	America/Montreal	3	J7B J7C J7E	1124000623
97	Aurora	Aurora	ON	Ontario	44	-79.4667	55445	1112.3	America/Toronto	3	L4G	1124085034
98	Welland	Welland	ON	Ontario	42.9833	-79.2333	52293	645.3	America/Toronto	3	L3B L3C	1124745616
99	North Bay	North Bay	ON	Ontario	46.3	-79.45	51553	161.6	America/Toronto	3	P1A P1B P1C	1124058496
100	Beloeil	Beloeil	QC	Quebec	45.5667	-73.2	50796	862.8	America/Montreal	3	J3G	1124469084
101	Belleville	Belleville	ON	Ontario	44.1667	-77.3833	50716	205.1	America/Toronto	3	K8N K8P K0K	1124786959
102	Mirabel	Mirabel	QC	Quebec	45.65	-74.0833	50513	104.1	America/Montreal	3	J7J J7N	1124182375
103	Shawinigan	Shawinigan	QC	Quebec	46.5667	-72.75	50060	68.2	America/Montreal	3	G9N G9T G9R G9P G0X	1124441118
104	Dollard-des-Ormeaux	Dollard-des-Ormeaux	QC	Quebec	45.4833	-73.8167	49637	3286.7	America/Montreal	2	H9A H9B H9G	1124902278
105	Brandon	Brandon	MB	Manitoba	49.8483	-99.95	48859	599.1	America/Winnipeg	3	R7A R7B R7C	1124239939
106	Rimouski	Rimouski	QC	Quebec	48.45	-68.53	48664	143.3	America/Montreal	3	G5N G5M G5L G0L	1124433645
107	Cornwall	Cornwall	ON	Ontario	45.0275	-74.74	46589	756.8	America/Toronto	3	K6J K6K K6H	1124938303
108	Stouffville	Stouffville	ON	Ontario	43.9667	-79.25	45837	222.3	America/Toronto	3	L0H L3Y L4A	1124207594
109	Georgina	Georgina	ON	Ontario	44.3	-79.4333	45418	157.8	America/Toronto	3	L0E L4P	1124000048
110	Victoriaville	Victoriaville	QC	Quebec	46.05	-71.9667	45309	516.2	America/Montreal	3	G6R G6P G6T	1124149787
111	Vernon	Vernon	BC	British Columbia	50.267	-119.272	44600	417.7	America/Vancouver	3	V1T V1H	1124553338
112	Duncan	Duncan	BC	British Columbia	48.7787	-123.7079	44451	2387.1	America/Vancouver	2	V9L	1124316061
113	Saint-Eustache	Saint-Eustache	QC	Quebec	45.57	-73.9	44154	634.3	America/Montreal	3	J7P J7R	1124758162
114	Quinte West	Quinte West	ON	Ontario	44.1833	-77.5667	43577	88.2	America/Toronto	3	K8N K8R K8V K0K	1124001037
115	Charlottetown	Charlottetown	PE	Prince Edward Island	46.2403	-63.1347	42602	779.7	America/Halifax	3	C1C C1A C1E	1124897699
116	Mascouche	Mascouche	QC	Quebec	45.75	-73.6	42491	398.4	America/Montreal	3	J7K J7L	1124001580
117	West Vancouver	West Vancouver	BC	British Columbia	49.3667	-123.1667	42473	486.8	America/Vancouver	3	V7T V7V V7S	1124001824
118	Salaberry-de-Valleyfield	Salaberry-de-Valleyfield	QC	Quebec	45.25	-74.13	42410	395.5	America/Montreal	3	J6T J6S	1124638758
119	Rouyn-Noranda	Rouyn-Noranda	QC	Quebec	48.2333	-79.0167	42334	7	America/Montreal	3	J9X J9Y J0Y J0Z	1124267752
120	Timmins	Timmins	ON	Ontario	48.4667	-81.3333	41788	14	America/Toronto	3	P0N P4N P4R P4P	1124760634
121	Sorel-Tracy	Sorel-Tracy	QC	Quebec	46.0333	-73.1167	41629	241.1	America/Montreal	3	J3P J3R	1124000182
122	New Tecumseth	New Tecumseth	ON	Ontario	44.0833	-79.75	41439	151.1	America/Toronto	3	L0L L0G L9R	1124001571
123	Woodstock	Woodstock	ON	Ontario	43.1306	-80.7467	40902	835.3	America/Toronto	3	N4S N4T N4V	1124758374
124	Boucherville	Boucherville	QC	Quebec	45.6	-73.45	40753	575.5	America/Montreal	3	J4B	1124000296
125	Mission	Mission	BC	British Columbia	49.1337	-122.3112	38833	170.6	America/Vancouver	3	V4S V2V	1124502601
126	Vaudreuil-Dorion	Vaudreuil-Dorion	QC	Quebec	45.4	-74.0333	38117	524.1	America/Montreal	3	J7V	1124618618
127	Brant	Brant	ON	Ontario	43.1167	-80.3667	36707	43.5	America/Toronto	3	N3L N3T N3W N0E	1124000682
128	Lakeshore	Lakeshore	ON	Ontario	42.2399	-82.6511	36611	69	America/Toronto	3	N8M N8N N9K N0P N0R	1124001501
129	Innisfil	Innisfil	ON	Ontario	44.3	-79.5833	36566	139.2	America/Toronto	3	L0L L9S	1124001408
130	Prince Albert	Prince Albert	SK	Saskatchewan	53.2	-105.75	35926	534.4	America/Regina	3	S6X S6V S6W	1124158154
131	Langford Station	Langford Station	BC	British Columbia	48.4506	-123.5058	35342	885	America/Vancouver	3	V9B V9C	1124095065
132	Bradford West Gwillimbury	Bradford West Gwillimbury	ON	Ontario	44.1333	-79.6333	35325	175.7	America/Toronto	3	L0G L3Z	1124001093
133	Campbell River	Campbell River	BC	British Columbia	50.0244	-125.2475	35138	1143.9	America/Vancouver	3	V9H V9W	1124851971
134	Spruce Grove	Spruce Grove	AB	Alberta	53.545	-113.9008	34066	1057.9	America/Edmonton	3	T7X	1124943146
135	Moose Jaw	Moose Jaw	SK	Saskatchewan	50.3933	-105.5519	33890	710.7	America/Regina	3	S6K S6H	1124806868
136	Penticton	Penticton	BC	British Columbia	49.4911	-119.5886	33761	801.8	America/Vancouver	3	V2A	1124613898
137	Port Moody	Port Moody	BC	British Columbia	49.2831	-122.8317	33551	1295.9	America/Vancouver	3	V3H	1124252668
138	Leamington	Leamington	ON	Ontario	42.0667	-82.5833	32991	105.3	America/Toronto	3	N8H N0P	1124258797
139	East Kelowna	East Kelowna	BC	British Columbia	49.8625	-119.5833	32655	264.4	America/Vancouver	3	V1Z V4T	1124070905
140	Côte-Saint-Luc	Cote-Saint-Luc	QC	Quebec	45.4687	-73.6673	32448	4662.5	America/Montreal	2	H4W H4V H4X	1124563603
141	Val-d’Or	Val-d'Or	QC	Quebec	48.1	-77.7833	31862	9	America/Montreal	3	J9P	1124239138
142	Owen Sound	Owen Sound	ON	Ontario	44.5667	-80.9333	31820	1311.1	America/Toronto	3	N4K	1124623613
143	Stratford	Stratford	ON	Ontario	43.3708	-80.9819	31465	1167.5	America/Toronto	3	N4Z N5A	1124676255
144	Lloydminster	Lloydminster	SK	Saskatchewan	53.2783	-110.005	31410	742.2	America/Edmonton	3	S9V	1124051728
145	Pointe-Claire	Pointe-Claire	QC	Quebec	45.45	-73.8167	31380	1662	America/Montreal	3	H9R H9S	1124470650
146	Orillia	Orillia	ON	Ontario	44.6	-79.4167	31166	1090.3	America/Toronto	3	L3V	1124049830
147	Alma	Alma	QC	Quebec	48.55	-71.65	30904	158	America/Montreal	3	G8E G8B G8C	1124138438
148	Orangeville	Orangeville	ON	Ontario	43.9167	-80.1167	30734	69.3	America/Toronto	3	L9W	1124566061
149	Fort Erie	Fort Erie	ON	Ontario	42.9167	-79.0167	30710	184.7	America/Toronto	3	L0S L2A	1124516852
150	LaSalle	LaSalle	ON	Ontario	42.2167	-83.0667	30180	461.8	America/Toronto	3	N9J N9H N9A	1124000988
151	Sainte-Julie	Sainte-Julie	QC	Quebec	45.5833	-73.3333	30104	607.8	America/Montreal	3	J3E	1124000521
152	Leduc	Leduc	AB	Alberta	53.2594	-113.5492	29993	706.7	America/Edmonton	3	T9E	1124170853
153	North Cowichan	North Cowichan	BC	British Columbia	48.8236	-123.7192	29676	147.3	America/Vancouver	3	V0R V9L	1124000052
154	Chambly	Chambly	QC	Quebec	45.4311	-73.2873	29120	1158.7	America/Montreal	3	J3L	1124345124
155	Okotoks	Okotoks	AB	Alberta	50.725	-113.975	28881	1471	America/Edmonton	3	T1S	1124521470
156	Sept-Îles	Sept-Iles	QC	Quebec	50.2167	-66.3833	28534	16.1	America/Montreal	3	G4S G0G	1124406431
157	Centre Wellington	Centre Wellington	ON	Ontario	43.7	-80.3667	28191	69.2	America/Toronto	3	N0B N1M	1124000849
158	Saint-Constant	Saint-Constant	QC	Quebec	45.37	-73.57	27359	478.9	America/Montreal	3	J5A	1124000054
159	Grimsby	Grimsby	ON	Ontario	43.2	-79.55	27314	396.3	America/Toronto	3	L3M	1124989517
160	Boisbriand	Boisbriand	QC	Quebec	45.62	-73.83	26884	966.5	America/Montreal	3	J7H J7E J7G	1124001940
161	Conception Bay South	Conception Bay South	NL	Newfoundland and Labrador	47.5167	-52.9833	26199	443.3	America/St_Johns	3	A1W A1X	1124000563
162	Saint-Bruno-de-Montarville	Saint-Bruno-de-Montarville	QC	Quebec	45.5333	-73.35	26107	603.3	America/Montreal	3	J3V	1124286783
163	Sainte-Thérèse	Sainte-Therese	QC	Quebec	45.6333	-73.85	26025	2716.1	America/Montreal	2	J7E	1124190411
164	Cochrane	Cochrane	AB	Alberta	51.189	-114.467	25853	866.7	America/Edmonton	3	T4C	1124952542
165	Thetford Mines	Thetford Mines	QC	Quebec	46.1	-71.3	25709	113.3	America/Montreal	3	G6H G6G	1124032181
166	Courtenay	Courtenay	BC	British Columbia	49.6878	-124.9944	25599	789.9	America/Vancouver	3	V9N	1124324905
167	Magog	Magog	QC	Quebec	45.2667	-72.15	25358	175.9	America/Montreal	3	J1X	1124404849
168	Whitehorse	Whitehorse	YT	Yukon	60.7029	-135.0691	25085	60.2	America/Whitehorse	3	Y1A	1124348186
169	Woolwich	Woolwich	ON	Ontario	43.5667	-80.4833	25006	76.7	America/Toronto	3	N2J N3B N0B	1124000096
170	Clarence-Rockland	Clarence-Rockland	ON	Ontario	45.4833	-75.2	24512	82.3	America/Toronto	3	K4K K0A	1124000639
171	Fort Saskatchewan	Fort Saskatchewan	AB	Alberta	53.7128	-113.2133	24149	501.3	America/Edmonton	3	T8L	1124769097
172	East Gwillimbury	East Gwillimbury	ON	Ontario	44.1333	-79.4167	23991	97.9	America/Toronto	3	L0G L9N	1124001370
173	Lincoln	Lincoln	ON	Ontario	43.13	-79.43	23787	146.1	America/Toronto	3	L0R L2R	1124001767
174	La Prairie	La Prairie	QC	Quebec	45.42	-73.5	23357	539.7	America/Montreal	3	J5R	1124956496
175	Tecumseh	Tecumseh	ON	Ontario	42.2431	-82.9256	23229	245.4	America/Toronto	3	N8N N9K N0R	1124720869
176	Mount Pearl Park	Mount Pearl Park	NL	Newfoundland and Labrador	47.5189	-52.8058	22957	1456.8	America/St_Johns	3	A1N	1124869949
177	Amherstburg	Amherstburg	ON	Ontario	42.1	-83.0833	21936	118.2	America/Toronto	3	N9V N0R	1124696938
178	Saint-Lambert	Saint-Lambert	QC	Quebec	45.5	-73.5167	21861	2880.6	America/Montreal	2	J4P J4S J4R	1124174363
179	Brockville	Brockville	ON	Ontario	44.5833	-75.6833	21854	1167.8	America/Toronto	3	K6V	1124286131
180	Collingwood	Collingwood	ON	Ontario	44.5	-80.2167	21793	645.1	America/Toronto	3	L9Y	1124219884
181	Scugog	Scugog	ON	Ontario	44.09	-78.936	21617	45.4	America/Toronto	3	L0C L0B L9L	1124000741
182	Kingsville	Kingsville	ON	Ontario	42.1	-82.7167	21552	87.3	America/Toronto	3	N8M N9Y N0P N0R	1124616034
183	Baie-Comeau	Baie-Comeau	QC	Quebec	49.2167	-68.15	21536	64	America/Montreal	3	G5C G4Z	1124859576
184	Paradise	Paradise	NL	Newfoundland and Labrador	47.5333	-52.8667	21389	731.5	America/St_Johns	3	A1L	1124001159
185	Uxbridge	Uxbridge	ON	Ontario	44.1167	-79.1333	21176	45.6	America/Toronto	3	L0E L0C L9P L4A	1124829638
186	Essa	Essa	ON	Ontario	44.25	-79.7833	21083	75.3	America/Toronto	3	L0M L0L L9R	1124001569
187	Candiac	Candiac	QC	Quebec	45.38	-73.52	21047	1215.8	America/Montreal	3	J5R	1124457982
188	Oro-Medonte	Oro-Medonte	ON	Ontario	44.5667	-79.5833	21036	35.8	America/Toronto	3	L0L L0K L3V L4R L4M	1124001350
189	Varennes	Varennes	QC	Quebec	45.6833	-73.4333	20994	226.9	America/Montreal	3	J3X	1124232101
190	Strathroy-Caradoc	Strathroy-Caradoc	ON	Ontario	42.9575	-81.6167	20867	77.1	America/Toronto	3	N0L N7G	1124000831
191	Wasaga Beach	Wasaga Beach	ON	Ontario	44.5206	-80.0167	20675	352.6	America/Toronto	3	L9Z	1124001919
192	New Glasgow	New Glasgow	NS	Nova Scotia	45.5926	-62.6455	20609	911.6	America/Halifax	3	B2H	1124760188
193	Wilmot	Wilmot	ON	Ontario	43.4	-80.65	20545	77.9	America/Toronto	3	N3A N0B	1124001797
194	Essex	Essex	ON	Ontario	42.0833	-82.9	20427	73.5	America/Toronto	3	N8M N0R	1124628052
195	Fort St. John	Fort St. John	BC	British Columbia	56.2465	-120.8476	20155	820.2	America/Dawson_Creek	3	V1J	1124517495
196	Kirkland	Kirkland	QC	Quebec	45.45	-73.8667	20151	2204.4	America/Montreal	2	H9H H9J	1124000941
197	L’Assomption	L'Assomption	QC	Quebec	45.8333	-73.4167	20065	202.9	America/Montreal	3	J5W	1124500862
198	Westmount	Westmount	QC	Quebec	45.4833	-73.6	19931	4952.8	America/Montreal	2	H3Z H3Y	1124878078
199	Saint-Lazare	Saint-Lazare	QC	Quebec	45.4	-74.1333	19889	289.6	America/Montreal	3	J7T	1124000613
200	Chestermere	Chestermere	AB	Alberta	51.05	-113.8225	19887	603.8	America/Edmonton	3	T1X	1124000371
201	Huntsville	Huntsville	ON	Ontario	45.3333	-79.2167	19816	27.9	America/Toronto	3	P0B P1H	1124961145
202	Corner Brook	Corner Brook	NL	Newfoundland and Labrador	48.9287	-57.926	19806	133.6	America/St_Johns	3	A2H	1124244792
203	Riverview	Riverview	NB	New Brunswick	46.0613	-64.8052	19667	554.8	America/Moncton	3	E1B	1124000112
204	Joliette	Joliette	QC	Quebec	46.0167	-73.45	19621	860.3	America/Montreal	3	J6E	1124841554
205	Yellowknife	Yellowknife	NT	Northwest Territories	62.4709	-114.4053	19569	185.5	America/Yellowknife	3	X1A	1124208917
206	Squamish	Squamish	BC	British Columbia	49.7017	-123.1589	19512	186.1	America/Vancouver	3	V0N V8B	1124005958
207	Mont-Royal	Mont-Royal	QC	Quebec	45.5161	-73.6431	19503	2545.3	America/Montreal	2	H3R H3P H4P	1124001920
208	Rivière-du-Loup	Riviere-du-Loup	QC	Quebec	47.8333	-69.5333	19447	230.9	America/Montreal	3	G5R	1124662123
209	Cobourg	Cobourg	ON	Ontario	43.9667	-78.1667	19440	869.3	America/Toronto	3	K9A	1124831257
210	Cranbrook	Cranbrook	BC	British Columbia	49.5097	-115.7667	19259	604.7	America/Edmonton	3	V1C	1124937794
211	Beaconsfield	Beaconsfield	QC	Quebec	45.4333	-73.8667	19115	1752.6	America/Montreal	3	H9W	1124755118
212	Springwater	Springwater	ON	Ontario	44.4333	-79.7333	19059	35.5	America/Toronto	3	L0L L4M	1124001298
213	Dorval	Dorval	QC	Quebec	45.45	-73.75	18980	839.2	America/Montreal	3	H9P H9S	1124933556
214	Thorold	Thorold	ON	Ontario	43.1167	-79.2	18801	226.5	America/Toronto	3	L0S L2V L3B	1124718251
215	Camrose	Camrose	AB	Alberta	53.0167	-112.8333	18742	439.8	America/Edmonton	3	T4V	1124351657
216	South Frontenac	South Frontenac	ON	Ontario	44.5081	-76.4939	18646	19.2	America/Toronto	3	K0H	1124000063
217	Pitt Meadows	Pitt Meadows	BC	British Columbia	49.2333	-122.6833	18573	214.7	America/Vancouver	3	V3Y	1124786902
218	Port Colborne	Port Colborne	ON	Ontario	42.8833	-79.25	18306	150.1	America/Toronto	3	L0S L3K	1124274319
219	Quispamsis	Quispamsis	NB	New Brunswick	45.4322	-65.9462	18245	318.9	America/Moncton	3	E2S E2E E2G	1124000379
220	Mont-Saint-Hilaire	Mont-Saint-Hilaire	QC	Quebec	45.5622	-73.1917	18200	410.9	America/Montreal	3	J3H	1124333461
221	Bathurst	Bathurst	NB	New Brunswick	47.62	-65.65	18154	129.3	America/Moncton	3	E2A	1124816720
222	Saint-Augustin-de-Desmaures	Saint-Augustin-de-Desmaures	QC	Quebec	46.7333	-71.4667	18141	211.5	America/Montreal	3	G3A	1124000358
223	Oak Bay	Oak Bay	BC	British Columbia	48.4264	-123.3228	18094	1717.7	America/Vancouver	3	V8P V8S V8R	1124761730
224	Sainte-Marthe-sur-le-Lac	Sainte-Marthe-sur-le-Lac	QC	Quebec	45.53	-73.93	18074	2066.7	America/Montreal	2	J0N	1124001153
225	Salmon Arm	Salmon Arm	BC	British Columbia	50.7022	-119.2722	17706	144	America/Vancouver	3	V0E V1E	1124478865
226	Port Alberni	Port Alberni	BC	British Columbia	49.2339	-124.805	17678	894.6	America/Vancouver	3	V9Y	1124952808
227	Esquimalt	Esquimalt	BC	British Columbia	48.4306	-123.4147	17655	2494.7	America/Vancouver	2	V9A	1124990218
228	Deux-Montagnes	Deux-Montagnes	QC	Quebec	45.5333	-73.8833	17553	2850.1	America/Montreal	2	J7R	1124980214
229	Miramichi	Miramichi	NB	New Brunswick	47.0196	-65.5072	17537	97.7	America/Moncton	3	E1V E1N	1124714190
230	Niagara-on-the-Lake	Niagara-on-the-Lake	ON	Ontario	43.2553	-79.0717	17511	131.8	America/Toronto	3	L0S	1124366228
231	Saint-Lin--Laurentides	Saint-Lin--Laurentides	QC	Quebec	45.85	-73.7667	17463	147.3	America/Montreal	3	J5M	1124906585
232	Beaumont	Beaumont	AB	Alberta	53.3572	-113.4147	17396	1661.1	America/Edmonton	3	T4X	1124001210
233	Middlesex Centre	Middlesex Centre	ON	Ontario	43.05	-81.45	17262	29.4	America/Toronto	3	N6P N6H N0M N0L	1124001841
234	Inverness	Inverness	NS	Nova Scotia	46.2	-61.1	17235	4.5	America/Halifax	3	B0E	1124840965
235	Stony Plain	Stony Plain	AB	Alberta	53.5264	-114.0069	17189	481.2	America/Edmonton	3	T7Z	1124982081
236	Petawawa	Petawawa	ON	Ontario	45.9	-77.2833	17187	103.1	America/Toronto	3	K8H	1124206291
237	Pelham	Pelham	ON	Ontario	43.0333	-79.3333	17110	135.3	America/Toronto	3	L0S	1124000042
238	Selwyn	Selwyn	ON	Ontario	44.4167	-78.3333	17060	54	America/Toronto	3	K9J K9L K0L	1124000937
239	Loyalist	Loyalist	ON	Ontario	44.25	-76.75	16971	49.8	America/Toronto	3	K7N K7R K0H	1124001145
240	Midland	Midland	ON	Ontario	44.75	-79.8833	16864	477.3	America/Toronto	3	L4R	1124104490
241	Colwood	Colwood	BC	British Columbia	48.4236	-123.4958	16859	954.2	America/Vancouver	3	V9B V9C	1124000395
242	Central Saanich	Central Saanich	BC	British Columbia	48.5142	-123.3839	16814	406.8	America/Vancouver	3	V8M	1124000519
243	Sainte-Catherine	Sainte-Catherine	QC	Quebec	45.4	-73.58	16762	1764.1	America/Montreal	3	J5C	1124941451
244	Port Hope	Port Hope	ON	Ontario	43.95	-78.3	16753	60.1	America/Toronto	3	L0A L1A	1124105292
245	L’Ancienne-Lorette	L'Ancienne-Lorette	QC	Quebec	46.8	-71.35	16745	2193.6	America/Montreal	2	G2E	1124580674
246	Saint-Basile-le-Grand	Saint-Basile-le-Grand	QC	Quebec	45.5333	-73.2833	16736	463.6	America/Montreal	3	J3N	1124000968
247	Swift Current	Swift Current	SK	Saskatchewan	50.2881	-107.7939	16604	566.5	America/Swift_Current	3	S9H	1124460875
248	Edmundston	Edmundston	NB	New Brunswick	47.3765	-68.3253	16580	155.2	America/Moncton	3	E7C E7B E3V	1124274233
249	Russell	Russell	ON	Ontario	45.2569	-75.3583	16520	83	America/Toronto	3	K4R K0A	1124982538
250	North Grenville	North Grenville	ON	Ontario	44.9667	-75.65	16451	46.7	America/Toronto	3	K0G	1124000746
251	Yorkton	Yorkton	SK	Saskatchewan	51.2139	-102.4628	16343	449.9	America/Regina	3	S3N	1124108820
252	Tracadie	Tracadie	NB	New Brunswick	47.5124	-64.9101	16114	31.2	America/Moncton	3	E1X E9H	1124362021
253	Bracebridge	Bracebridge	ON	Ontario	45.0333	-79.3	16010	25.5	America/Toronto	3	P1L P1P	1124793645
254	Greater Napanee	Greater Napanee	ON	Ontario	44.25	-76.95	15892	34.5	America/Toronto	3	K7R K0H K0K	1124001319
255	Tillsonburg	Tillsonburg	ON	Ontario	42.8667	-80.7333	15872	710.8	America/Toronto	3	N4G	1124817746
256	Steinbach	Steinbach	MB	Manitoba	49.5258	-96.6839	15829	618.6	America/Winnipeg	3	R5G	1124152692
257	Hanover	Hanover	MB	Manitoba	49.4433	-96.8492	15733	21.2	America/Winnipeg	3	R5G R0A	1124001704
258	Terrace	Terrace	BC	British Columbia	54.5164	-128.5997	15723	212.7	America/Vancouver	3	V8G	1124878479
259	Springfield	Springfield	MB	Manitoba	49.9292	-96.6939	15342	13.9	America/Winnipeg	3	R2C R0E	1124000696
260	Gaspé	Gaspe	QC	Quebec	48.8333	-64.4833	15163	13.5	America/Montreal	3	G4X	1124212754
261	Kenora	Kenora	ON	Ontario	49.7667	-94.4833	15096	71.3	America/Winnipeg	3	P9N	1124844807
262	Cold Lake	Cold Lake	AB	Alberta	54.4642	-110.1825	14961	249.7	America/Edmonton	3	T9M	1124089461
263	Summerside	Summerside	PE	Prince Edward Island	46.4	-63.7833	14829	520.5	America/Halifax	3	C1N C0B	1124487102
264	Comox	Comox	BC	British Columbia	49.6733	-124.9022	14828	838.2	America/Vancouver	3	V0R V9M	1124788300
265	Sylvan Lake	Sylvan Lake	AB	Alberta	52.3083	-114.0964	14816	634.2	America/Edmonton	3	T4S	1124397940
266	Pincourt	Pincourt	QC	Quebec	45.3833	-73.9833	14558	2048.1	America/Montreal	2	J7W	1124637966
267	West Lincoln	West Lincoln	ON	Ontario	43.0667	-79.5667	14500	37.4	America/Toronto	3	L0R	1124001460
268	Matane	Matane	QC	Quebec	48.85	-67.5333	14462	74	America/Montreal	3	G4W	1124528318
269	Brooks	Brooks	AB	Alberta	50.5642	-111.8989	14451	777.3	America/Edmonton	3	T1R	1124093123
270	Sainte-Anne-des-Plaines	Sainte-Anne-des-Plaines	QC	Quebec	45.7617	-73.8204	14421	154.1	America/Montreal	3	J0N	1124304532
271	West Nipissing / Nipissing Ouest	West Nipissing / Nipissing Ouest	ON	Ontario	46.3667	-79.9167	14364	7.2	America/Toronto	3	P0H P1B P2B	1124000026
272	Rosemère	Rosemere	QC	Quebec	45.6369	-73.8	14294	1326.9	America/Montreal	3	J7A	1124741055
273	Mistassini	Mistassini	QC	Quebec	48.8229	-72.2154	14250	48.2	America/Montreal	3	G8L	1124980171
274	Grand Falls	Grand Falls	NL	Newfoundland and Labrador	48.9578	-55.6633	14171	259.2	America/St_Johns	3	A2A A2B	1124068277
275	Clearview	Clearview	ON	Ontario	44.3981	-80.0742	14151	25.4	America/Toronto	3	L0M L9Y	1124000053
276	St. Clair	St. Clair	ON	Ontario	42.7833	-82.35	14086	22.8	America/Toronto	3	N8A N0N N0P	1124000228
277	Canmore	Canmore	AB	Alberta	51.089	-115.359	13992	201.5	America/Edmonton	3	T1W	1124688642
278	North Battleford	North Battleford	SK	Saskatchewan	52.7575	-108.2861	13888	414	America/Regina	3	S9A	1124789635
279	Pembroke	Pembroke	ON	Ontario	45.8167	-77.1	13882	953.3	America/Toronto	3	K8A	1124877940
280	Mont-Laurier	Mont-Laurier	QC	Quebec	46.55	-75.5	13779	23.3	America/Montreal	3	J9L	1124355399
281	Strathmore	Strathmore	AB	Alberta	51.0378	-113.4003	13756	502	America/Edmonton	3	T1P	1124000881
282	Saugeen Shores	Saugeen Shores	ON	Ontario	44.4333	-81.3667	13715	80.2	America/Toronto	3	N0H	1124000488
283	Thompson	Thompson	MB	Manitoba	55.7433	-97.8553	13678	657.91	America/Winnipeg	3	R8N	1124110693
284	Lavaltrie	Lavaltrie	QC	Quebec	45.8833	-73.2833	13657	199.7	America/Montreal	3	J5T	1124818327
285	High River	High River	AB	Alberta	50.5808	-113.8744	13584	635.1	America/Edmonton	3	T1V	1124607825
286	Severn	Severn	ON	Ontario	44.75	-79.5167	13477	24.5	America/Toronto	3	L0K L3V	1124489890
287	Sainte-Sophie	Sainte-Sophie	QC	Quebec	45.82	-73.9	13375	120.2	America/Montreal	3	J5J	1124001574
288	Saint-Charles-Borromée	Saint-Charles-Borromee	QC	Quebec	46.05	-73.4667	13321	715	America/Montreal	3	J6E	1124000877
289	Portage La Prairie	Portage La Prairie	MB	Manitoba	49.9728	-98.2919	13304	539.1	America/Winnipeg	3	R1N	1124282782
290	Thames Centre	Thames Centre	ON	Ontario	43.03	-81.08	13191	30.4	America/Toronto	3	N0M N0L N6M	1124000993
291	Mississippi Mills	Mississippi Mills	ON	Ontario	45.2167	-76.2	13163	25.3	America/Toronto	3	K7C K0A	1124001617
292	Powell River	Powell River	BC	British Columbia	49.8353	-124.5247	13157	444.1	America/Vancouver	3	V8A	1124154376
293	South Glengarry	South Glengarry	ON	Ontario	45.2	-74.5833	13150	21.7	America/Toronto	3	K6H K0C	1124001506
294	North Perth	North Perth	ON	Ontario	43.73	-80.95	13130	26.6	America/Toronto	3	N4W N0K N0G	1124000749
295	Mercier	Mercier	QC	Quebec	45.32	-73.75	13115	284.6	America/Montreal	3	J6R	1124186621
296	South Stormont	South Stormont	ON	Ontario	45.0833	-74.9667	13110	28.2	America/Toronto	3	K0C	1124001793
297	Saint-Colomban	Saint-Colomban	QC	Quebec	45.73	-74.13	13080	139.8	America/Montreal	3	J5K	1124001676
298	Lacombe	Lacombe	AB	Alberta	52.4683	-113.7369	13057	627.5	America/Edmonton	3	T4L	1124057569
299	Sooke	Sooke	BC	British Columbia	48.3761	-123.7378	13001	229.6	America/Vancouver	3	V9Z	1124034713
300	Dawson Creek	Dawson Creek	BC	British Columbia	55.7606	-120.2356	12978	475.4	America/Dawson_Creek	3	V1G	1124081402
301	Lake Country	Lake Country	BC	British Columbia	50.0833	-119.4142	12922	105.8	America/Vancouver	3	V4V	1124001544
302	Trent Hills	Trent Hills	ON	Ontario	44.3142	-77.8514	12900	25.2	America/Toronto	3	K0K K0L	1124001755
303	Sainte-Marie	Sainte-Marie	QC	Quebec	46.45	-71.0333	12889	120.3	America/Montreal	3	G6E	1124650507
304	Guelph/Eramosa	Guelph/Eramosa	ON	Ontario	43.63	-80.22	12854	44.1	America/Toronto	3	N0B N1H	1124001707
305	Truro	Truro	NS	Nova Scotia	45.3647	-63.28	12826	355.5	America/Halifax	3	B2N	1124952899
306	Amos	Amos	QC	Quebec	48.5667	-78.1167	12823	29.8	America/Montreal	3	J9T	1124939649
307	The Nation / La Nation	The Nation / La Nation	ON	Ontario	45.35	-75.0333	12808	19.5	America/Toronto	3	K0A K0B K0C	1124001243
308	Ingersoll	Ingersoll	ON	Ontario	43.0392	-80.8836	12757	1000.7	America/Toronto	3	N5C	1124716784
309	Winkler	Winkler	MB	Manitoba	49.1817	-97.9397	12660	740.5	America/Winnipeg	3	R6W	1124205424
310	Wetaskiwin	Wetaskiwin	AB	Alberta	52.9694	-113.3769	12655	691.1	America/Edmonton	3	T9A	1124492484
311	Central Elgin	Central Elgin	ON	Ontario	42.7667	-81.1	12607	45	America/Toronto	3	N5R N5P N5L N0L	1124000475
312	Lachute	Lachute	QC	Quebec	45.65	-74.3333	12551	114.9	America/Montreal	3	J8H	1124217062
313	West Grey	West Grey	ON	Ontario	44.1833	-80.8167	12518	14.3	America/Toronto	3	N4N N0G N0C	1124000272
314	Parksville	Parksville	BC	British Columbia	49.315	-124.312	12514	854.6	America/Vancouver	3	V9P	1124698963
315	Cowansville	Cowansville	QC	Quebec	45.2	-72.75	12489	271	America/Montreal	3	J2K	1124357421
316	Bécancour	Becancour	QC	Quebec	46.3333	-72.4333	12438	28.2	America/Montreal	3	G9H	1124242297
317	Gravenhurst	Gravenhurst	ON	Ontario	44.9167	-79.3667	12311	23.8	America/Toronto	3	P0E P1P	1124842372
318	Perth East	Perth East	ON	Ontario	43.47	-80.95	12261	17.2	America/Toronto	3	N4W N5A N3A N0K N0B	1124001760
319	Prince Rupert	Prince Rupert	BC	British Columbia	54.3122	-130.3271	12220	227.7	America/Vancouver	3	V8J	1124847707
320	Prévost	Prevost	QC	Quebec	45.87	-74.08	12171	347.2	America/Montreal	3	J0R	1124001584
321	Sainte-Adèle	Sainte-Adele	QC	Quebec	45.95	-74.13	12137	100.4	America/Montreal	3	J8B	1124439200
322	Kentville	Kentville	NS	Nova Scotia	45.0775	-64.4958	12088	363.3	America/Halifax	3	B4N	1124530137
323	Beauharnois	Beauharnois	QC	Quebec	45.32	-73.87	12011	173.9	America/Montreal	3	J6N	1124880971
324	Les Îles-de-la-Madeleine	Les Iles-de-la-Madeleine	QC	Quebec	47.3833	-61.8667	12010	69.5	America/Halifax	3	G4T	1124000721
325	Wellington North	Wellington North	ON	Ontario	43.9	-80.57	11914	22.6	America/Toronto	3	N0G	1124001997
326	St. Andrews	St. Andrews	MB	Manitoba	50.27	-96.9747	11913	15.8	America/Winnipeg	3	R0C R1A	1124001672
506	Saint-Zotique	Saint-Zotique	QC	Quebec	45.25	-74.25	6773	268.8	America/Montreal	3	J0P	1124170824
327	Carleton Place	Carleton Place	ON	Ontario	45.1333	-76.1333	11901	1176.2	America/Toronto	3	K7C	1124676010
328	Whistler	Whistler	BC	British Columbia	50.1208	-122.9544	11854	49.3	America/Vancouver	3	V0N	1124001562
329	Brighton	Brighton	ON	Ontario	44.1222	-77.7642	11844	43.2	America/Toronto	3	K0K	1124672085
330	Tiny	Tiny	ON	Ontario	44.6833	-79.95	11787	35	America/Toronto	3	L0L L9M	1124000103
331	Gander	Gander	NL	Newfoundland and Labrador	48.9569	-54.6089	11688	112.1	America/St_Johns	3	A1V	1124310517
332	Sidney	Sidney	BC	British Columbia	48.6506	-123.3986	11672	2290.7	America/Vancouver	2	V8L	1124421362
333	Rothesay	Rothesay	NB	New Brunswick	45.3831	-65.9969	11659	335.8	America/Moncton	3	E2S E2E E2H	1124211328
334	Brock	Brock	ON	Ontario	44.3167	-79.0833	11642	27.5	America/Toronto	3	L0K L0E L0C	1124001106
335	Summerland	Summerland	BC	British Columbia	49.6006	-119.6778	11615	156.8	America/Vancouver	3	V0H	1124400731
336	Val-des-Monts	Val-des-Monts	QC	Quebec	45.65	-75.6667	11582	26.2	America/Montreal	3	J8N	1124001051
337	Taché	Tache	MB	Manitoba	49.7081	-96.6736	11568	19.9	America/Winnipeg	3	R5H R0A R0E	1124000169
338	Montmagny	Montmagny	QC	Quebec	46.9833	-70.55	11491	91.1	America/Montreal	3	G5V	1124025705
339	Erin	Erin	ON	Ontario	43.7667	-80.0667	11439	38.4	America/Toronto	3	L7J L0N N0B	1124418313
340	Kincardine	Kincardine	ON	Ontario	44.1667	-81.6333	11389	21.2	America/Toronto	3	N2Z N0G	1124781881
341	North Dundas	North Dundas	ON	Ontario	45.0833	-75.35	11278	22.4	America/Toronto	3	K0C K0E	1124000474
342	Wellesley	Wellesley	ON	Ontario	43.55	-80.7167	11260	40.5	America/Toronto	3	N0B	1124590159
343	Estevan	Estevan	SK	Saskatchewan	49.1392	-102.9861	11258	586.6	America/Regina	3	S4A	1124416742
344	North Saanich	North Saanich	BC	British Columbia	48.6142	-123.42	11249	301.8	America/Vancouver	3	V8L	1124000779
345	Warman	Warman	SK	Saskatchewan	52.3219	-106.5842	11020	844.6	America/Regina	3	S0K	1124688931
346	La Tuque	La Tuque	QC	Quebec	48.0652	-74.0528	11001	0.4	America/Montreal	3	G9X G0X	1124000430
347	Norwich	Norwich	ON	Ontario	42.9833	-80.6	11001	25.5	America/Toronto	3	N4S N4G N0J	1124219807
348	Meaford	Meaford	ON	Ontario	44.58	-80.73	10991	18.7	America/Toronto	3	N4K N4L N0H	1124445257
349	Adjala-Tosorontio	Adjala-Tosorontio	ON	Ontario	44.1333	-79.9333	10975	29.5	America/Toronto	3	L0N L0M L0G L9R	1124000498
350	Hamilton Township	Hamilton Township	ON	Ontario	44.054	-78.2164	10942	42.7	America/Toronto	3	K9A K0K K0L	1124000994
351	St. Clements	St. Clements	MB	Manitoba	50.2689	-96.6742	10876	14.9	America/Winnipeg	3	R0E R1B R1C R1A	1124000566
352	Saint-Amable	Saint-Amable	QC	Quebec	45.65	-73.3	10870	296.3	America/Montreal	3	J0L	1124000904
353	Weyburn	Weyburn	SK	Saskatchewan	49.6611	-103.8525	10870	688.8	America/Regina	3	S4H	1124618383
354	South Dundas	South Dundas	ON	Ontario	44.9167	-75.2667	10833	20.8	America/Toronto	3	K0C K0E	1124001404
355	L’Île-Perrot	L'Ile-Perrot	QC	Quebec	45.3833	-73.95	10756	1955.6	America/Montreal	3	J7V	1124063001
356	Notre-Dame-de-l'Île-Perrot	Notre-Dame-de-l'Ile-Perrot	QC	Quebec	45.3667	-73.9333	10756	386.9	America/Montreal	3	J7V	1124001191
357	Williams Lake	Williams Lake	BC	British Columbia	52.1294	-122.1383	10753	327	America/Vancouver	3	V2G	1124821980
358	Elliot Lake	Elliot Lake	ON	Ontario	46.3833	-82.65	10741	15.9	America/Toronto	3	P5A	1124793448
359	Cantley	Cantley	QC	Quebec	45.5667	-75.7833	10699	83.4	America/Montreal	3	J8V	1124000263
360	Nelson	Nelson	BC	British Columbia	49.5	-117.2833	10664	1552.3	America/Vancouver	3	V1L	1124361295
361	Lambton Shores	Lambton Shores	ON	Ontario	43.1833	-81.9	10631	32.1	America/Toronto	3	N0M N0N	1124001891
362	Mapleton	Mapleton	ON	Ontario	43.7358	-80.6681	10527	19.7	America/Toronto	3	N4W N0G N0B	1124000835
363	Georgian Bluffs	Georgian Bluffs	ON	Ontario	44.65	-81.0333	10479	17.3	America/Toronto	3	N4K N0H	1124001470
364	Rawdon	Rawdon	QC	Quebec	46.05	-73.7167	10416	55.7	America/Montreal	3	J0K	1124084263
365	Campbellton	Campbellton	NB	New Brunswick	48.005	-66.6731	10411	370.5	America/Moncton	3	E3N	1124336512
366	View Royal	View Royal	BC	British Columbia	48.4517	-123.4339	10408	724.8	America/Vancouver	3	V9B	1124001985
367	Coldstream	Coldstream	BC	British Columbia	50.22	-119.2481	10314	155.6	America/Vancouver	3	V1B	1124000216
368	Chester	Chester	NS	Nova Scotia	44.65	-64.3	10310	9.2	America/Halifax	3	B0J	1124772236
369	Queens	Queens	NS	Nova Scotia	44.0333	-64.7167	10307	4.3	America/Halifax	3	B0T	1124001652
370	Selkirk	Selkirk	MB	Manitoba	50.1436	-96.8839	10278	413.4	America/Winnipeg	3	R1A	1124499880
371	Saint-Félicien	Saint-Felicien	QC	Quebec	48.65	-72.45	10278	28.3	America/Montreal	3	G8K	1124555496
372	Hawkesbury	Hawkesbury	ON	Ontario	45.6	-74.6	10263	1067.3	America/Montreal	3	K6A	1124065659
373	Roberval	Roberval	QC	Quebec	48.52	-72.23	10227	66.8	America/Montreal	3	G8H	1124395055
374	Sainte-Agathe-des-Monts	Sainte-Agathe-des-Monts	QC	Quebec	46.05	-74.28	10223	78.6	America/Montreal	3	J8C	1124041166
375	North Dumfries	North Dumfries	ON	Ontario	43.32	-80.38	10215	54.5	America/Toronto	3	N0B N1R	1124000802
376	Rideau Lakes	Rideau Lakes	ON	Ontario	44.6667	-76.2167	10207	14	America/Toronto	3	K0E K0G	1124000369
377	Sechelt	Sechelt	BC	British Columbia	49.4742	-123.7542	10200	212.9	America/Vancouver	3	V0N	1124845591
378	North Glengarry	North Glengarry	ON	Ontario	45.3333	-74.7333	10109	15.7	America/Toronto	3	K0B K0C	1124000836
379	South Huron	South Huron	ON	Ontario	43.32	-81.5	10096	23.4	America/Toronto	3	N0M	1124000910
380	Marieville	Marieville	QC	Quebec	45.4333	-73.1667	10094	160.8	America/Montreal	3	J3M	1124834229
381	Tay	Tay	ON	Ontario	44.7167	-79.7667	10033	72.1	America/Toronto	3	L0L L0K L4R	1124001057
382	Temiskaming Shores	Temiskaming Shores	ON	Ontario	47.5167	-79.6833	9920	55.7	America/Toronto	3	P0J	1124001880
383	Hinton	Hinton	AB	Alberta	53.4114	-117.5639	9882	294.8	America/Edmonton	3	T7V	1124131074
384	Saint-Sauveur	Saint-Sauveur	QC	Quebec	45.9	-74.17	9881	206.8	America/Montreal	3	J0R	1124720935
385	Quesnel	Quesnel	BC	British Columbia	52.9784	-122.4927	9879	279.2	America/Vancouver	3	V2J	1124028015
386	Elizabethtown-Kitley	Elizabethtown-Kitley	ON	Ontario	44.7	-75.8833	9854	17.7	America/Toronto	3	K6V K6T K0E K0G	1124001450
387	Morinville	Morinville	AB	Alberta	53.8022	-113.6497	9848	882.8	America/Edmonton	3	T8R	1124322535
388	Grey Highlands	Grey Highlands	ON	Ontario	44.3333	-80.5	9804	11.1	America/Toronto	3	N4L N0C	1124000119
389	Alfred and Plantagenet	Alfred and Plantagenet	ON	Ontario	45.5667	-74.9167	9680	24.7	America/Toronto	3	K0B	1124001813
390	Mont-Tremblant	Mont-Tremblant	QC	Quebec	46.1167	-74.6	9646	40.5	America/Montreal	3	J8E	1124041173
391	Martensville	Martensville	SK	Saskatchewan	52.2897	-106.6667	9645	1421.2	America/Regina	3	S0K	1124000654
392	Saint-Raymond	Saint-Raymond	QC	Quebec	46.9	-71.8333	9615	14.3	America/Montreal	3	G3L	1124162305
393	Amherst	Amherst	NS	Nova Scotia	45.8167	-64.2167	9550	779.7	America/Halifax	3	B4H	1124895094
394	Ramara	Ramara	ON	Ontario	44.6333	-79.2167	9488	22.7	America/Toronto	3	L0K L3V	1124000641
395	Bois-des-Filion	Bois-des-Filion	QC	Quebec	45.6667	-73.75	9485	2216.2	America/Montreal	2	J6Z	1124978470
396	Leeds and the Thousand Islands	Leeds and the Thousand Islands	ON	Ontario	44.45	-76.08	9465	15.1	America/Toronto	3	K7G K0E K0H	1124000531
397	Carignan	Carignan	QC	Quebec	45.45	-73.3	9462	151.9	America/Montreal	3	J3L	1124001655
398	Brockton	Brockton	ON	Ontario	44.1667	-81.2167	9461	16.7	America/Toronto	3	N0G	1124000713
399	Laurentian Valley	Laurentian Valley	ON	Ontario	45.7681	-77.2239	9387	17	America/Toronto	3	K8A K8B	1124000736
400	East St. Paul	East St. Paul	MB	Manitoba	49.9772	-97.0103	9372	222.6	America/Winnipeg	3	R2E	1124000695
401	Lorraine	Lorraine	QC	Quebec	45.6833	-73.7833	9352	1570	America/Montreal	3	J6Z	1124001859
402	Sainte-Julienne	Sainte-Julienne	QC	Quebec	45.97	-73.72	9331	94	America/Montreal	3	J0K	1124086540
403	Blackfalds	Blackfalds	AB	Alberta	52.3833	-113.8	9328	567.3	America/Edmonton	3	T0M T4M	1124056144
404	Malahide	Malahide	ON	Ontario	42.7928	-80.9361	9292	23.5	America/Toronto	3	N5H N0L	1124001777
405	Oromocto	Oromocto	NB	New Brunswick	45.8488	-66.4788	9223	411	America/Moncton	3	E2V	1124928183
406	Olds	Olds	AB	Alberta	51.7928	-114.1067	9184	615.3	America/Edmonton	3	T4H	1124330412
407	Huron East	Huron East	ON	Ontario	43.63	-81.28	9138	13.8	America/Toronto	3	N4W N0M N0K N0G	1124000724
408	Stanley	Stanley	MB	Manitoba	49.1331	-98.0656	9038	10.8	America/Winnipeg	3	R6M R6W	1124001503
409	Penetanguishene	Penetanguishene	ON	Ontario	44.7667	-79.9333	8962	350.3	America/Toronto	3	L9M	1124304117
410	Qualicum Beach	Qualicum Beach	BC	British Columbia	49.35	-124.4333	8943	497.4	America/Vancouver	3	V9K	1124822520
411	Notre-Dame-des-Prairies	Notre-Dame-des-Prairies	QC	Quebec	46.05	-73.4333	8868	487.3	America/Montreal	3	J6E	1124001393
412	West Perth	West Perth	ON	Ontario	43.47	-81.2	8865	15.3	America/Toronto	3	N0K	1124001056
413	Cavan Monaghan	Cavan Monaghan	ON	Ontario	44.2	-78.4667	8829	28.8	America/Toronto	3	L0A K0L	1124001281
414	Arnprior	Arnprior	ON	Ontario	45.4333	-76.35	8795	672.7	America/Toronto	3	K7S	1124700031
415	Smiths Falls	Smiths Falls	ON	Ontario	44.9	-76.0167	8780	909.1	America/Toronto	3	K7A	1124233827
416	Pont-Rouge	Pont-Rouge	QC	Quebec	46.75	-71.7	8723	72	America/Montreal	3	G3H	1124608325
417	Champlain	Champlain	ON	Ontario	45.5333	-74.65	8706	42	America/Toronto	3	K6A K0B	1124000537
418	Coaticook	Coaticook	QC	Quebec	45.1333	-71.8	8698	39.6	America/Montreal	3	J1A	1124454176
419	Minto	Minto	ON	Ontario	43.9167	-80.8667	8671	28.8	America/Toronto	3	N0G	1124000198
420	Morden	Morden	MB	Manitoba	49.1919	-98.1006	8668	401	America/Winnipeg	3	R6M	1124327817
421	Mono	Mono	ON	Ontario	44.0167	-80.0667	8609	31	America/Toronto	3	L9V L9W	1124001904
422	Corman Park No. 344	Corman Park No. 344	SK	Saskatchewan	52.2291	-106.8002	8568	4.5	America/Regina	4	S0K S7K S7P S7T	1124000077
423	Ladysmith	Ladysmith	BC	British Columbia	48.9975	-123.8203	8537	711.9	America/Vancouver	3	V9G	1124872385
424	Bridgewater	Bridgewater	NS	Nova Scotia	44.37	-64.52	8532	625.9	America/Halifax	3	B4V	1124736310
425	Dauphin	Dauphin	MB	Manitoba	51.1992	-100.0633	8457	670.7	America/Winnipeg	3	R7N	1124144510
426	Otterburn Park	Otterburn Park	QC	Quebec	45.5333	-73.2167	8450	1580.6	America/Montreal	3	J3H	1124899409
427	Taber	Taber	AB	Alberta	49.7847	-112.1508	8428	537.9	America/Edmonton	3	T1G	1124113583
428	South Bruce Peninsula	South Bruce Peninsula	ON	Ontario	44.7333	-81.2	8416	15.8	America/Toronto	3	N0H	1124000114
429	Edson	Edson	AB	Alberta	53.5817	-116.4344	8414	283.1	America/Edmonton	3	T7E	1124553562
430	Farnham	Farnham	QC	Quebec	45.2833	-72.9833	8330	90.5	America/Montreal	3	J2N	1124553013
431	Kapuskasing	Kapuskasing	ON	Ontario	49.4167	-82.4333	8292	98.3	America/Toronto	3	P5N	1124764245
432	La Malbaie	La Malbaie	QC	Quebec	47.65	-70.15	8271	18	America/Montreal	3	G5A	1124466004
433	Renfrew	Renfrew	ON	Ontario	45.4717	-76.6831	8223	643.4	America/Toronto	3	K7V	1124652971
434	Coaldale	Coaldale	AB	Alberta	49.7333	-112.6167	8215	1028.5	America/Edmonton	3	T1M	1124989507
435	Portugal Cove-St. Philip's	Portugal Cove-St. Philip's	NL	Newfoundland and Labrador	47.6272	-52.8506	8147	128.4	America/St_Johns	3	A1M	1124001559
436	Zorra	Zorra	ON	Ontario	43.15	-80.95	8138	15.4	America/Toronto	3	N5C N0M N0J	1124000608
437	Kitimat	Kitimat	BC	British Columbia	54	-128.7	8131	34.7	America/Vancouver	3	V8C	1124198272
438	Shelburne	Shelburne	ON	Ontario	44.0833	-80.2	8126	907.1	America/Toronto	3	L9V	1124470888
439	Happy Valley	Happy Valley	NL	Newfoundland and Labrador	53.3396	-60.4467	8109	26.5	America/Goose_Bay	4	A0P	1124879731
440	Saint-Hippolyte	Saint-Hippolyte	QC	Quebec	45.93	-74.02	8083	67	America/Montreal	3	J8A	1124001758
441	Castlegar	Castlegar	BC	British Columbia	49.3256	-117.6661	8039	408.6	America/Vancouver	3	V1N	1124379972
442	Church Point	Church Point	NS	Nova Scotia	44.3333	-66.1167	8018	9.4	America/Halifax	3	B0W	1124316445
443	Drumheller	Drumheller	AB	Alberta	51.4636	-112.7194	7982	73.9	America/Edmonton	3	T0J	1124745292
444	Kirkland Lake	Kirkland Lake	ON	Ontario	48.15	-80.0333	7981	30.4	America/Toronto	3	P0K P2N	1124683504
445	Argyle	Argyle	NS	Nova Scotia	43.8	-65.85	7899	5.2	America/Halifax	3	B0W	1124503052
446	Torbay	Torbay	NL	Newfoundland and Labrador	47.65	-52.7333	7899	212.1	America/St_Johns	3	A1K	1124406642
447	La Pêche	La Peche	QC	Quebec	45.6833	-75.9833	7863	13.4	America/Montreal	3	J0X	1124001249
448	Banff	Banff	AB	Alberta	51.1781	-115.5719	7847	1646	America/Edmonton	3	T1L	1124351648
449	Innisfail	Innisfail	AB	Alberta	52.0333	-113.95	7847	404.6	America/Edmonton	3	T4G	1124612670
450	Nicolet	Nicolet	QC	Quebec	46.2167	-72.6167	7828	81.5	America/Montreal	3	J3T	1124746363
451	Rockwood	Rockwood	MB	Manitoba	50.2856	-97.2869	7823	6.5	America/Winnipeg	3	R0C	1124000435
452	Drummond/North Elmsley	Drummond/North Elmsley	ON	Ontario	44.9667	-76.2	7773	21.2	America/Toronto	3	K7A K7C K7H K0G	1124001787
453	Dryden	Dryden	ON	Ontario	49.7833	-92.8333	7749	117.1	America/Winnipeg	3	P8N	1124295097
454	Iqaluit	Iqaluit	NU	Nunavut	63.7598	-68.5107	7740	147.4	America/Iqaluit	4	X0A	1124379539
455	Fort Frances	Fort Frances	ON	Ontario	48.6167	-93.4	7739	303.4	America/Winnipeg	3	P9A	1124939714
456	La Sarre	La Sarre	QC	Quebec	48.8	-79.2	7719	51.9	America/Montreal	3	J9Z	1124902252
457	Trail	Trail	BC	British Columbia	49.095	-117.71	7709	220.7	America/Vancouver	3	V1R	1124817036
458	Chandler	Chandler	QC	Quebec	48.35	-64.6833	7703	18.4	America/Montreal	3	G0C	1124111932
459	Stone Mills	Stone Mills	ON	Ontario	44.45	-76.9167	7702	10.9	America/Toronto	3	K0K	1124000075
460	South-West Oxford	South-West Oxford	ON	Ontario	42.95	-80.8	7664	20.7	America/Toronto	3	N4S N4G N5C N0L N0J	1124000210
461	Acton Vale	Acton Vale	QC	Quebec	45.65	-72.5667	7664	84.2	America/Montreal	3	J0H	1124864792
462	Bromont	Bromont	QC	Quebec	45.3167	-72.65	7649	66.9	America/Montreal	3	J2L	1124286457
463	Beckwith	Beckwith	ON	Ontario	45.0833	-76.0667	7644	31.8	America/Toronto	3	K7A K7C K0A	1124000163
464	Goderich	Goderich	ON	Ontario	43.7333	-81.7	7628	882.8	America/Toronto	3	N7A	1124989247
465	Plympton-Wyoming	Plympton-Wyoming	ON	Ontario	43.0167	-82.0833	7576	23.8	America/Toronto	3	N0N	1124001273
466	Central Huron	Central Huron	ON	Ontario	43.63	-81.57	7576	16.9	America/Toronto	3	N0M N7A	1124001983
467	Rigaud	Rigaud	QC	Quebec	45.4833	-74.3	7566	74.1	America/Montreal	3	J0P	1124176101
468	Louiseville	Louiseville	QC	Quebec	46.25	-72.95	7517	120.1	America/Montreal	3	J5V	1124866425
469	Chibougamau	Chibougamau	QC	Quebec	49.9167	-74.3667	7504	10.7	America/Montreal	3	G8P	1124650514
470	Aylmer	Aylmer	ON	Ontario	42.7667	-80.9833	7492	1197.6	America/Toronto	3	N5H	1124964102
471	Delson	Delson	QC	Quebec	45.37	-73.55	7462	982.6	America/Montreal	3	J5B	1124405717
472	Kimberley	Kimberley	BC	British Columbia	49.6697	-115.9775	7425	122.5	America/Edmonton	3	V1A	1124170837
473	Blandford-Blenheim	Blandford-Blenheim	ON	Ontario	43.2333	-80.6	7399	19.4	America/Toronto	3	N0J	1124001001
474	Bayham	Bayham	ON	Ontario	42.7333	-80.7833	7396	30.2	America/Toronto	3	N5H N0J	1124000461
475	Augusta	Augusta	ON	Ontario	44.7511	-75.6003	7353	23.4	America/Toronto	3	K6V K0E K0G	1124000619
476	Puslinch	Puslinch	ON	Ontario	43.45	-80.1667	7336	34.2	America/Toronto	3	N3C N0B N1H	1124129947
477	Beauport	Beauport	QC	Quebec	46.9667	-71.3	7281	118.8	America/Montreal	3	G3B	1124715267
478	Saint-Rémi	Saint-Remi	QC	Quebec	45.2667	-73.6167	7265	92.2	America/Montreal	3	J0L	1124638080
479	St. Marys	St. Marys	ON	Ontario	43.2583	-81.1333	7265	583.5	America/Toronto	3	N4X	1124438866
480	Drayton Valley	Drayton Valley	AB	Alberta	53.2222	-114.9769	7235	235.5	America/Edmonton	3	T7A	1124814220
481	Ponoka	Ponoka	AB	Alberta	52.6833	-113.5667	7229	417.1	America/Edmonton	3	T4J	1124308190
482	Labrador City	Labrador City	NL	Newfoundland and Labrador	52.95	-66.9167	7220	186	America/Goose_Bay	3	A2V	1124000773
483	Donnacona	Donnacona	QC	Quebec	46.6747	-71.7294	7200	357.6	America/Montreal	3	G3M	1124002794
484	Southgate	Southgate	ON	Ontario	44.1	-80.5833	7190	11.4	America/Toronto	3	N0G N0C	1124000656
485	McNab/Braeside	McNab/Braeside	ON	Ontario	45.45	-76.5	7178	28.1	America/Toronto	3	K7S K7V K0A	1124001458
486	Macdonald	Macdonald	MB	Manitoba	49.6725	-97.4472	7162	6.2	America/Winnipeg	3	R4G R0G	1124000633
487	Hampstead	Hampstead	QC	Quebec	45.4833	-73.6333	7153	3996.5	America/Montreal	2	H3X	1124000763
488	Baie-Saint-Paul	Baie-Saint-Paul	QC	Quebec	47.45	-70.5	7146	13.1	America/Montreal	3	G3Z	1124415452
489	Merritt	Merritt	BC	British Columbia	50.1128	-120.7897	7139	273.9	America/Vancouver	3	V1K	1124550302
490	Bluewater	Bluewater	ON	Ontario	43.45	-81.6	7136	17.1	America/Toronto	3	N0M	1124000066
491	East Zorra-Tavistock	East Zorra-Tavistock	ON	Ontario	43.2333	-80.7833	7129	29.4	America/Toronto	3	N4S N0J N0B	1124000189
492	Brownsburg	Brownsburg	QC	Quebec	45.6703	-74.4467	7122	28.8	America/Montreal	4	J8G	1124023263
493	Stoneham-et-Tewkesbury	Stoneham-et-Tewkesbury	QC	Quebec	47.1667	-71.4333	7106	10.6	America/Montreal	3	G3C	1124000439
494	Asbestos	Asbestos	QC	Quebec	45.7667	-71.9333	7096	239.1	America/Montreal	3	J1T	1124583779
495	Huron-Kinloss	Huron-Kinloss	ON	Ontario	44.05	-81.5333	7069	16	America/Toronto	3	N2Z N0G	1124000614
496	Coteau-du-Lac	Coteau-du-Lac	QC	Quebec	45.3	-74.18	7044	150.2	America/Montreal	3	J0P	1124000308
497	The Blue Mountains	The Blue Mountains	ON	Ontario	44.4833	-80.3833	7025	24.5	America/Toronto	3	L9Y N0H	1124000370
498	Whitewater Region	Whitewater Region	ON	Ontario	45.7167	-76.8333	7009	13	America/Toronto	3	K0J	1124001363
499	Edwardsburgh/Cardinal	Edwardsburgh/Cardinal	ON	Ontario	44.8333	-75.5	6959	22.3	America/Toronto	3	K0E	1124001736
500	Sainte-Anne-des-Monts	Sainte-Anne-des-Monts	QC	Quebec	49.1333	-66.5	6933	26.3	America/Montreal	3	G4V	1124183859
501	Old Chelsea	Old Chelsea	QC	Quebec	45.5	-75.7833	6909	60.7	America/Montreal	3	J9B	1124835028
502	North Stormont	North Stormont	ON	Ontario	45.2167	-75	6873	13.3	America/Toronto	3	K0A K0C	1124000261
503	Alnwick/Haldimand	Alnwick/Haldimand	ON	Ontario	44.0833	-78.0333	6869	17.25	America/Toronto	3	K9A K0K	1124000698
504	Peace River	Peace River	AB	Alberta	56.2339	-117.2897	6842	260.6	America/Edmonton	3	T8S	1124941936
505	Arran-Elderslie	Arran-Elderslie	ON	Ontario	44.4	-81.2	6803	14.8	America/Toronto	3	N0H N0G	1124001766
507	Val-Shefford	Val-Shefford	QC	Quebec	45.35	-72.5667	6711	56.7	America/Montreal	3	J2M	1124787548
508	Douro-Dummer	Douro-Dummer	ON	Ontario	44.45	-78.1	6709	14.6	America/Toronto	3	K9J K9L K0L	1124001679
509	Plessisville	Plessisville	QC	Quebec	46.2167	-71.7833	6688	1546	America/Montreal	3	G6L	1124223899
510	Ritchot	Ritchot	MB	Manitoba	49.6647	-97.1167	6679	20	America/Winnipeg	3	R5A R0A R0G	1124001990
511	Otonabee-South Monaghan	Otonabee-South Monaghan	ON	Ontario	44.2333	-78.2333	6670	19.2	America/Toronto	3	K9J K0L	1124000517
512	Shediac	Shediac	NB	New Brunswick	46.2167	-64.5333	6664	123.5	America/Moncton	3	E4P	1124770042
513	Slave Lake	Slave Lake	AB	Alberta	55.2853	-114.7706	6651	460.5	America/Edmonton	3	T0G	1124106662
514	Port-Cartier	Port-Cartier	QC	Quebec	50.0333	-66.8667	6651	6	America/Montreal	3	G5B G0H	1124795368
515	Saint-Lambert-de-Lauzon	Saint-Lambert-de-Lauzon	QC	Quebec	46.5865	-71.2271	6647	62.2	America/Montreal	4	G0S	1124610423
516	Barrington	Barrington	NS	Nova Scotia	43.5646	-65.5639	6646	10.5	America/Halifax	3	B0W	1124548310
517	Rocky Mountain House	Rocky Mountain House	AB	Alberta	52.3753	-114.9217	6635	521.8	America/Edmonton	3	T4T	1124203206
518	Chatsworth	Chatsworth	ON	Ontario	44.38	-80.87	6630	11.1	America/Toronto	3	N0H	1124525225
519	Stephenville	Stephenville	NL	Newfoundland and Labrador	48.55	-58.5667	6623	185.6	America/St_Johns	3	A2N	1124000201
520	Muskoka Falls	Muskoka Falls	ON	Ontario	45.1264	-79.558	6588	8.3	America/Toronto	4	P0C P0B P1L P1P	1124955753
521	Devon	Devon	AB	Alberta	53.3633	-113.7322	6578	460.2	America/Edmonton	3	T9G	1124268366
522	Yarmouth	Yarmouth	NS	Nova Scotia	43.8361	-66.1175	6518	616.9	America/Halifax	3	B5A	1124983867
523	Boischatel	Boischatel	QC	Quebec	46.9	-71.15	6465	308.8	America/Montreal	3	G0A	1124332563
524	Parry Sound	Parry Sound	ON	Ontario	45.3333	-80.0333	6408	478.2	America/Toronto	3	P2A	1124245809
525	Pointe-Calumet	Pointe-Calumet	QC	Quebec	45.5	-73.97	6396	1382.4	America/Montreal	3	J0N	1124629762
526	Beaubassin East / Beaubassin-est	Beaubassin East / Beaubassin-est	NB	New Brunswick	46.1726	-64.3122	6376	21.9	America/Moncton	3	E4P E4N	1124000427
527	Wainfleet	Wainfleet	ON	Ontario	42.925	-79.375	6372	29.3	America/Toronto	3	L0S L0R L3B L3K	1124538125
528	Cramahe	Cramahe	ON	Ontario	44.0833	-77.8833	6355	31.4	America/Toronto	3	K0K	1124000879
529	Beauceville	Beauceville	QC	Quebec	46.2	-70.7833	6354	37.9	America/Montreal	3	G5X	1124575286
530	North Middlesex	North Middlesex	ON	Ontario	43.15	-81.6333	6352	10.6	America/Toronto	3	N0M	1124001914
531	Amqui	Amqui	QC	Quebec	48.4667	-67.4333	6322	52.3	America/Montreal	3	G5J	1124681333
532	Sainte-Catherine-de-la-Jacques-Cartier	Sainte-Catherine-de-la-Jacques-Cartier	QC	Quebec	46.85	-71.6167	6319	52.1	America/Montreal	3	G3N	1124001417
533	Clarenville	Clarenville	NL	Newfoundland and Labrador	48.1566	-53.965	6291	44.7	America/St_Johns	3	A5A	1124924217
534	Mont-Joli	Mont-Joli	QC	Quebec	48.58	-68.18	6281	272.6	America/Montreal	3	G5H	1124642037
535	Dysart et al	Dysart et al	ON	Ontario	45.2042	-78.4047	6280	4.2	America/Toronto	4	K0L K0M	1124000824
536	Wainwright	Wainwright	AB	Alberta	52.8333	-110.8667	6270	688.7	America/Edmonton	3	T9W	1124385336
537	Contrecoeur	Contrecoeur	QC	Quebec	45.85	-73.2333	6252	102.2	America/Montreal	3	J0L	1124384220
538	Beresford	Beresford	NB	New Brunswick	47.7181	-65.8794	6248	13.7	America/Moncton	4	E8J E8K	1124000299
539	Saint-Joseph-du-Lac	Saint-Joseph-du-Lac	QC	Quebec	45.5333	-74	6195	149.7	America/Montreal	3	J0N	1124001195
540	Hope	Hope	BC	British Columbia	49.3858	-121.4419	6181	151	America/Vancouver	3	V0X	1124662863
541	Gimli	Gimli	MB	Manitoba	50.6619	-97.0297	6181	19.5	America/Winnipeg	3	R0C	1124472413
542	Douglas	Douglas	NB	New Brunswick	46.2819	-66.942	6154	4.3	America/Moncton	4	E6L E6B E3G	1124000768
543	Saint-Apollinaire	Saint-Apollinaire	QC	Quebec	46.6167	-71.5167	6110	63	America/Montreal	3	G0S	1124951601
544	Hindon Hill	Hindon Hill	ON	Ontario	44.9333	-78.7333	6088	6.9	America/Toronto	3	K0M	1124076260
545	Les Cèdres	Les Cedres	QC	Quebec	45.3	-74.05	6079	78.1	America/Montreal	3	J7T	1124051098
546	La Broquerie	La Broquerie	MB	Manitoba	49.3994	-96.5103	6076	10.5	America/Winnipeg	3	R0A	1124000582
547	Kent	Kent	BC	British Columbia	49.2833	-121.75	6067	35.9	America/Vancouver	3	V0M	1124001999
548	Tweed	Tweed	ON	Ontario	44.6	-77.3333	6044	6.3	America/Toronto	3	K0K	1124220211
549	Saint-Félix-de-Valois	Saint-Felix-de-Valois	QC	Quebec	46.17	-73.43	6029	68.6	America/Montreal	3	J0K	1124578689
550	Bay Roberts	Bay Roberts	NL	Newfoundland and Labrador	47.5847	-53.2783	6012	249.9	America/St_Johns	3	A0A	1124372298
551	Melfort	Melfort	SK	Saskatchewan	52.8564	-104.61	5992	405.4	America/Regina	3	S0E	1124817334
552	Bonnyville	Bonnyville	AB	Alberta	54.2667	-110.75	5975	421.4	America/Edmonton	3	T9N	1124166469
553	Stettler	Stettler	AB	Alberta	52.3236	-112.7192	5952	453	America/Edmonton	3	T0C	1124010388
554	Saint-Calixte	Saint-Calixte	QC	Quebec	45.95	-73.85	5934	41.4	America/Montreal	3	J0K	1124001462
555	Lac-Mégantic	Lac-Megantic	QC	Quebec	45.5833	-70.8833	5932	272.5	America/Montreal	3	G6B	1124329615
556	Perth	Perth	ON	Ontario	44.9	-76.25	5930	484.1	America/Toronto	3	K7H	1124732094
557	Oliver Paipoonge	Oliver Paipoonge	ON	Ontario	48.39	-89.52	5922	16.9	America/Toronto	3	P0T P7G P7J P7K	1124000729
558	Humboldt	Humboldt	SK	Saskatchewan	52.2019	-105.1231	5869	1783.4	America/Regina	3	S0K	1124147660
559	Charlemagne	Charlemagne	QC	Quebec	45.7167	-73.4833	5853	2704	America/Montreal	2	J5Z	1124185024
560	Pontiac	Pontiac	QC	Quebec	45.5833	-76.1333	5850	13.1	America/Montreal	3	J0X	1124000248
561	St. Paul	St. Paul	AB	Alberta	53.9928	-111.2972	5827	674.2	America/Edmonton	3	T0A	1124528022
562	Petrolia	Petrolia	ON	Ontario	42.8833	-82.1417	5742	452.8	America/Toronto	3	N0N	1124479624
563	Southwest Middlesex	Southwest Middlesex	ON	Ontario	42.75	-81.7	5723	13.4	America/Toronto	3	N0L	1124000520
564	Front of Yonge	Front of Yonge	ON	Ontario	44.5333	-75.8667	5710	20.3	America/Toronto	3	K0E	1124001901
565	Vegreville	Vegreville	AB	Alberta	53.4928	-112.0522	5708	405.4	America/Edmonton	3	T9C	1124534321
566	Sainte-Brigitte-de-Laval	Sainte-Brigitte-de-Laval	QC	Quebec	47	-71.2	5696	52.4	America/Montreal	3	G0A	1124647754
567	Princeville	Princeville	QC	Quebec	46.1667	-71.8833	5693	29.3	America/Montreal	4	G6L	1124715340
568	Verchères	Vercheres	QC	Quebec	45.7833	-73.35	5692	77.7	America/Montreal	3	J0L	1124549666
569	The Pas	The Pas	MB	Manitoba	53.825	-101.2533	5689	115.3	America/Winnipeg	3	R9A R0B	1124755168
570	Saint-Césaire	Saint-Cesaire	QC	Quebec	45.4167	-73	5686	68.1	America/Montreal	3	J0L	1124948389
571	La Ronge	La Ronge	SK	Saskatchewan	55.1	-105.3	5671	163.9	America/Regina	3	S0J	1124763455
572	Tay Valley	Tay Valley	ON	Ontario	44.8667	-76.3833	5665	10.3	America/Toronto	3	K7H K0G K0H	1124000734
573	South Bruce	South Bruce	ON	Ontario	44.0333	-81.2	5639	11.6	America/Toronto	3	N0G	1124001457
574	McMasterville	McMasterville	QC	Quebec	45.55	-73.2333	5615	1810.3	America/Montreal	3	J3G	1124000115
575	Redcliff	Redcliff	AB	Alberta	50.0792	-110.7783	5600	344.6	America/Edmonton	3	T0J	1124603057
576	Crowsnest Pass	Crowsnest Pass	AB	Alberta	49.5955	-114.5136	5589	15	America/Edmonton	4	T0K	1124000595
577	Saint-Philippe	Saint-Philippe	QC	Quebec	45.35	-73.47	5495	88.5	America/Montreal	3	J0L	1124461923
578	Richelieu	Richelieu	QC	Quebec	45.45	-73.25	5467	176.2	America/Montreal	3	J3L	1124000387
579	Notre-Dame-du-Mont-Carmel	Notre-Dame-du-Mont-Carmel	QC	Quebec	46.4833	-72.65	5467	42.6	America/Montreal	3	G0X	1124893320
580	L'Ange-Gardien	L'Ange-Gardien	QC	Quebec	45.5833	-75.45	5464	25	America/Montreal	3	J8L	1124001197
581	Sainte-Martine	Sainte-Martine	QC	Quebec	45.25	-73.8	5461	86.4	America/Montreal	3	J0S	1124000017
582	Saint-Pie	Saint-Pie	QC	Quebec	45.5	-72.9	5438	49.9	America/Montreal	3	J0H	1124508787
583	Peachland	Peachland	BC	British Columbia	49.7736	-119.7369	5428	340.1	America/Vancouver	3	V0H	1124440160
584	Ashfield-Colborne-Wawanosh	Ashfield-Colborne-Wawanosh	ON	Ontario	43.8667	-81.6	5422	9.2	America/Toronto	3	N0M N0G N7A	1124000025
585	Trent Lakes	Trent Lakes	ON	Ontario	44.6667	-78.4333	5397	6.3	America/Toronto	3	K0L K0M	1124001268
586	Northern Rockies	Northern Rockies	BC	British Columbia	59	-123.75	5393	0.063	America/Fort_Nelson	3	V0C	1124001362
587	Cookshire	Cookshire	QC	Quebec	45.3729	-71.672	5393	18.2	America/Montreal	4	J0B	1124895156
588	West St. Paul	West St. Paul	MB	Manitoba	50.0119	-97.115	5368	61.1	America/Winnipeg	3	R4A R2V	1124001136
589	L’Epiphanie	L'Epiphanie	QC	Quebec	45.85	-73.4833	5353	2367.9	America/Montreal	2	J5X	1124599436
590	Creston	Creston	BC	British Columbia	49.09	-116.51	5351	626.8	America/Creston	3	V0B	1124204302
591	Smithers	Smithers	BC	British Columbia	54.7819	-127.1681	5351	514.9	America/Vancouver	3	V0J	1124191574
592	Meadow Lake	Meadow Lake	SK	Saskatchewan	54.1242	-108.4358	5344	433.6	America/Regina	3	S9X	1124434578
593	Lanark Highlands	Lanark Highlands	ON	Ontario	45.088	-76.517	5338	5.1	America/Toronto	3	K0A K0G	1124000887
594	Sackville	Sackville	NB	New Brunswick	45.9	-64.3667	5331	71.9	America/Moncton	3	E4L	1124877244
595	Marystown	Marystown	NL	Newfoundland and Labrador	47.1667	-55.1667	5316	85.8	America/St_Johns	3	A0E	1124408131
596	Sioux Lookout	Sioux Lookout	ON	Ontario	50.1	-91.9167	5272	13.9	America/Winnipeg	3	P0V P8T	1124804545
597	Didsbury	Didsbury	AB	Alberta	51.6658	-114.1311	5268	321.7	America/Edmonton	3	T0M	1124574154
598	Saint-Honoré	Saint-Honore	QC	Quebec	48.5333	-71.0833	5257	27.8	America/Montreal	4	G0V	1124504668
599	Fernie	Fernie	BC	British Columbia	49.5042	-115.0628	5249	388.8	America/Edmonton	3	V0B	1124927114
600	Deer Lake	Deer Lake	NL	Newfoundland and Labrador	49.1744	-57.4269	5249	71.7	America/St_Johns	3	A8A	1124841556
601	Val-David	Val-David	QC	Quebec	46.03	-74.22	5209	103.9	America/Montreal	3	J0T	1124707666
602	Flin Flon	Flin Flon	SK	Saskatchewan	54.7667	-101.8778	5185	448.9	America/Winnipeg	3	S0P	1124500458
603	Hudson	Hudson	QC	Quebec	45.45	-74.15	5165	234.5	America/Montreal	3	J0P	1124590540
604	Gananoque	Gananoque	ON	Ontario	44.33	-76.17	5159	733.6	America/Toronto	3	K7G	1124349596
605	Brokenhead	Brokenhead	MB	Manitoba	50.1428	-96.5319	5122	6.8	America/Winnipeg	3	R0E	1124000321
606	Saint-Paul	Saint-Paul	QC	Quebec	45.9833	-73.45	5122	103.7	America/Montreal	3	J0K	1124001817
607	Burton	Burton	NB	New Brunswick	45.8009	-66.4066	5119	19.8	America/Moncton	4	E2V	1124000544
608	Spallumcheen	Spallumcheen	BC	British Columbia	50.4462	-119.2121	5106	20	America/Vancouver	4	V0E	1124001340
609	Westlock	Westlock	AB	Alberta	54.1522	-113.8511	5101	381.4	America/Edmonton	3	T7P	1124037311
610	Témiscouata-sur-le-Lac	Temiscouata-sur-le-Lac	QC	Quebec	47.68	-68.88	5096	23.3	America/Montreal	3	G0L	1124001776
611	Shannon	Shannon	QC	Quebec	46.8833	-71.5167	5086	79.8	America/Montreal	3	G0A	1124440867
612	Osoyoos	Osoyoos	BC	British Columbia	49.0325	-119.4661	5085	598.2	America/Vancouver	3	V0H	1124713973
613	Montréal-Ouest	Montreal-Ouest	QC	Quebec	45.4536	-73.6472	5085	3614.6	America/Montreal	2	H4X	1124001742
614	Hearst	Hearst	ON	Ontario	49.6869	-83.6544	5070	51.5	America/Toronto	3	P0L	1124376843
615	Saint-Henri	Saint-Henri	QC	Quebec	46.7	-71.0667	5023	41.1	America/Montreal	4	G0R	1124057702
616	Ste. Anne	Ste. Anne	MB	Manitoba	49.6186	-96.5708	5003	10.5	America/Winnipeg	4	R5H R5G R0A R0E	1124000501
617	Antigonish	Antigonish	NS	Nova Scotia	45.6167	-61.9833	5002	871.7	America/Halifax	3	B2G	1124839247
618	Espanola	Espanola	ON	Ontario	46.25	-81.7667	4996	60.3	America/Toronto	3	P5E	1124133485
619	West Elgin	West Elgin	ON	Ontario	42.5833	-81.6667	4995	15.5	America/Toronto	3	N0L	1124000948
620	Flin Flon (Part)	Flin Flon (Part)	MB	Manitoba	54.7712	-101.8419	4982	359.2	America/Winnipeg	3	R8A	1124000122
621	Grand Bay-Westfield	Grand Bay-Westfield	NB	New Brunswick	45.3608	-66.2415	4964	83	America/Moncton	3	E5K	1124001504
622	Sainte-Anne-de-Bellevue	Sainte-Anne-de-Bellevue	QC	Quebec	45.4039	-73.9525	4958	473	America/Montreal	3	H9X	1124418135
623	North Huron	North Huron	ON	Ontario	43.83	-81.42	4932	27.6	America/Toronto	3	N0G	1124001142
624	Oliver	Oliver	BC	British Columbia	49.1844	-119.55	4928	896	America/Vancouver	3	V0H	1124145879
625	Saint-Roch-de-l'Achigan	Saint-Roch-de-l'Achigan	QC	Quebec	45.85	-73.6	4892	60.6	America/Montreal	3	J0K	1124000365
626	Stirling-Rawdon	Stirling-Rawdon	ON	Ontario	44.3667	-77.5917	4882	17.3	America/Toronto	3	K0K	1124001948
627	Chisasibi	Chisasibi	QC	Quebec	53.6645	-78.7938	4872	5.9	America/Montreal	4	J0M	1124000072
628	Carbonear	Carbonear	NL	Newfoundland and Labrador	47.7375	-53.2294	4838	411.5	America/St_Johns	3	A1Y	1124121214
629	Saint Marys	Saint Marys	NB	New Brunswick	46.1748	-66.4897	4837	6.4	America/Moncton	4	E6C E3A	1124000221
630	Chertsey	Chertsey	QC	Quebec	46.17	-73.92	4836	16.8	America/Montreal	3	J0K	1124001234
631	Armstrong	Armstrong	BC	British Columbia	50.4483	-119.1961	4830	927.7	America/Vancouver	3	V0E	1124201947
632	Stonewall	Stonewall	MB	Manitoba	50.1344	-97.3261	4809	802.8	America/Winnipeg	3	R0C	1124829875
633	Shippagan	Shippagan	NB	New Brunswick	47.8557	-64.6012	4800	23.1	America/Moncton	4	E8T E8S	1124001772
634	Lanoraie	Lanoraie	QC	Quebec	45.9667	-73.2167	4787	46.4	America/Montreal	3	J0K	1124453107
635	Memramcook	Memramcook	NB	New Brunswick	46	-64.55	4778	25.5	America/Moncton	3	E4K	1124833147
636	Centre Hastings	Centre Hastings	ON	Ontario	44.4167	-77.4417	4774	20.4	America/Toronto	3	K0K	1124000705
637	Warwick	Warwick	QC	Quebec	45.95	-71.9833	4766	43.3	America/Montreal	3	J0A	1124510688
638	East Ferris	East Ferris	ON	Ontario	46.2667	-79.3	4750	30.6	America/Toronto	3	P0H	1124000523
639	Hanwell	Hanwell	NB	New Brunswick	45.8681	-66.7947	4750	31.4	America/Moncton	3	E3E E3B	1124001405
640	Saint-Joseph-de-Beauce	Saint-Joseph-de-Beauce	QC	Quebec	46.3	-70.8833	4722	42.6	America/Montreal	3	G0S	1124865207
641	Metchosin	Metchosin	BC	British Columbia	48.3819	-123.5378	4708	66.2	America/Vancouver	3	V9C	1124625175
642	Lucan Biddulph	Lucan Biddulph	ON	Ontario	43.2	-81.3833	4700	27.8	America/Toronto	3	N0M	1124000469
643	Rivière-Rouge	Riviere-Rouge	QC	Quebec	46.4167	-74.8667	4645	10.2	America/Montreal	3	J0T	1124001720
644	Greenstone	Greenstone	ON	Ontario	50	-86.7333	4636	1.7	America/Toronto	3	P0T	1124000068
645	Saint-Mathias-sur-Richelieu	Saint-Mathias-sur-Richelieu	QC	Quebec	45.4667	-73.2667	4618	97.8	America/Montreal	3	J3L	1124000576
646	Neepawa	Neepawa	MB	Manitoba	50.2289	-99.4656	4609	206.5	America/Winnipeg	3	R0J	1124375380
647	Gibsons	Gibsons	BC	British Columbia	49.4028	-123.5036	4605	1066	America/Vancouver	3	V0N	1124342069
648	Kindersley	Kindersley	SK	Saskatchewan	51.4678	-109.1567	4597	347.5	America/Regina	3	S0L	1124343190
649	Jasper	Jasper	AB	Alberta	52.9013	-118.1312	4590	5	America/Edmonton	4	T0E	1124533812
650	Barrhead	Barrhead	AB	Alberta	54.1167	-114.4	4579	560.4	America/Edmonton	3	T7N	1124181687
651	Les Coteaux	Les Coteaux	QC	Quebec	45.28	-74.23	4568	393.2	America/Montreal	3	J7X	1124001989
652	Melville	Melville	SK	Saskatchewan	50.9306	-102.8078	4562	307.8	America/Regina	3	S0A	1124823140
653	Saint-Germain-de-Grantham	Saint-Germain-de-Grantham	QC	Quebec	45.8333	-72.5667	4551	51.9	America/Montreal	3	J0C	1124972184
654	Iroquois Falls	Iroquois Falls	ON	Ontario	48.7667	-80.6667	4537	7.6	America/Toronto	3	P0K	1124652927
655	Havelock-Belmont-Methuen	Havelock-Belmont-Methuen	ON	Ontario	44.5667	-77.9	4530	8.3	America/Toronto	3	K0L	1124001644
656	Cornwallis	Cornwallis	MB	Manitoba	49.7981	-99.8481	4520	9	America/Winnipeg	3	R7A	1124000766
657	Saint-Boniface	Saint-Boniface	QC	Quebec	46.5	-72.8167	4511	41.4	America/Montreal	3	G0X	1124000235
658	Edenwold No. 158	Edenwold No. 158	SK	Saskatchewan	50.5166	-104.3451	4490	5.3	America/Regina	4	S0G S4L	1124001180
659	Coverdale	Coverdale	NB	New Brunswick	46.0003	-64.8859	4466	18.9	America/Moncton	4	E1J E4J	1124001531
660	Vanderhoof	Vanderhoof	BC	British Columbia	54.0143	-124.0089	4439	81	America/Vancouver	3	V0J	1124100075
661	Southwold	Southwold	ON	Ontario	42.75	-81.3167	4421	14.7	America/Toronto	3	N5P N5L N0L	1124001461
662	Goulds	Goulds	NL	Newfoundland and Labrador	47.4517	-52.7647	4418	721.3	America/St_Johns	3	A1S	1124000955
663	Saint Stephen	Saint Stephen	NB	New Brunswick	45.2	-67.2833	4415	326.6	America/New_York	3	E3L	1124128038
664	Nipawin	Nipawin	SK	Saskatchewan	53.3572	-104.0192	4401	505	America/Regina	3	S0E	1124567955
665	Neuville	Neuville	QC	Quebec	46.7	-71.5833	4392	61	America/Montreal	3	G0A	1124862301
666	Saint-Cyrille-de-Wendover	Saint-Cyrille-de-Wendover	QC	Quebec	45.9333	-72.4333	4389	39.8	America/Montreal	3	J1Z	1124582350
667	Central Frontenac	Central Frontenac	ON	Ontario	44.7167	-76.8	4373	4.3	America/Toronto	3	K0H	1124000254
668	Mont-Orford	Mont-Orford	QC	Quebec	45.3661	-72.1838	4337	31.8	America/Montreal	4	J1X	1124618048
669	Saint-Jean-de-Matha	Saint-Jean-de-Matha	QC	Quebec	46.23	-73.53	4335	39.6	America/Montreal	3	J0K	1124833822
670	Seguin	Seguin	ON	Ontario	45.2882	-79.8116	4304	7.2	America/Toronto	3	P0C P2A	1124001464
671	Tyendinaga	Tyendinaga	ON	Ontario	44.3	-77.2	4297	13.7	America/Toronto	3	K0K	1124000109
672	Hampton	Hampton	NB	New Brunswick	45.533	-65.833	4289	203.4	America/Moncton	3	E5N	1124175945
673	Sussex	Sussex	NB	New Brunswick	45.7167	-65.5167	4282	478.3	America/Moncton	3	E5P E4E	1124362993
674	Grand Forks	Grand Forks	BC	British Columbia	49.0333	-118.44	4274	388.1	America/Vancouver	3	V0H	1124547325
675	La Pocatière	La Pocatiere	QC	Quebec	47.3667	-70.0333	4266	196.3	America/Montreal	3	G0R	1124845219
676	Caraquet	Caraquet	NB	New Brunswick	47.7853	-64.9592	4248	62.1	America/Moncton	3	E1W	1124593896
677	Saint-Étienne-des-Grès	Saint-Etienne-des-Gres	QC	Quebec	46.4333	-72.7667	4217	40.2	America/Montreal	3	G0X	1124635032
678	Altona	Altona	MB	Manitoba	49.1044	-97.5625	4212	445.2	America/Winnipeg	3	R0G	1124628560
679	Stellarton	Stellarton	NS	Nova Scotia	45.5567	-62.66	4208	468.1	America/Halifax	3	B0K	1124388660
680	Wolfville	Wolfville	NS	Nova Scotia	45.0833	-64.3667	4195	649.8	America/Halifax	3	B4P	1124909280
681	New Maryland	New Maryland	NB	New Brunswick	45.8911	-66.6847	4174	195.7	America/Moncton	3	E3C	1124001875
682	Port Hardy	Port Hardy	BC	British Columbia	50.7225	-127.4928	4132	106.7	America/Vancouver	3	V0N	1124937351
683	Saint-Donat	Saint-Donat	QC	Quebec	46.3167	-74.2167	4130	11.7	America/Montreal	3	J0T	1124430126
684	Château-Richer	Chateau-Richer	QC	Quebec	46.9667	-71.0167	4126	18	America/Montreal	3	G0A	1124518769
685	Madawaska Valley	Madawaska Valley	ON	Ontario	45.5	-77.6667	4123	6.1	America/Toronto	3	K0J	1124000653
686	Deep River	Deep River	ON	Ontario	46.1	-77.4917	4109	82	America/Montreal	3	K0J	1124309248
687	Asphodel-Norwood	Asphodel-Norwood	ON	Ontario	44.3531	-78.0183	4109	25.5	America/Toronto	3	K0L	1124001973
688	Red Lake	Red Lake	ON	Ontario	51.0333	-93.8333	4107	6.7	America/Winnipeg	3	P0V	1124856215
689	Métabetchouan-Lac-à-la-Croix	Metabetchouan-Lac-a-la-Croix	QC	Quebec	48.4333	-71.8667	4097	21.9	America/Montreal	3	G8G	1124093309
690	Berthierville	Berthierville	QC	Quebec	46.0833	-73.1833	4091	596.8	America/Montreal	3	J0K	1124734495
691	Vermilion	Vermilion	AB	Alberta	53.3542	-110.8528	4084	315.8	America/Edmonton	3	T9X	1124995979
692	Niverville	Niverville	MB	Manitoba	49.6056	-97.0417	4083	1767.5	America/Winnipeg	3	R0A	1124001529
693	Hastings Highlands	Hastings Highlands	ON	Ontario	45.2333	-77.9333	4078	4.2	America/Toronto	3	K0J K0L	1124000285
694	Carstairs	Carstairs	AB	Alberta	51.5619	-114.0953	4077	342.1	America/Edmonton	3	T0M	1124621475
695	Danville	Danville	QC	Quebec	45.7833	-72.0167	4070	26.7	America/Montreal	3	J0A J1T	1124290094
696	Channel-Port aux Basques	Channel-Port aux Basques	NL	Newfoundland and Labrador	47.5694	-59.1361	4067	104.9	America/St_Johns	3	A0M	1124993496
697	Battleford	Battleford	SK	Saskatchewan	52.7383	-108.3153	4065	174.2	America/Regina	3	S0M	1124885955
698	Lac-Etchemin	Lac-Etchemin	QC	Quebec	46.4	-70.5	4061	25.8	America/Montreal	3	G0R	1124000895
699	Saint-Antonin	Saint-Antonin	QC	Quebec	47.7667	-69.4833	4027	22.9	America/Montreal	4	G0L	1124990343
700	Saint-Jacques	Saint-Jacques	QC	Quebec	45.95	-73.5667	4021	59.7	America/Montreal	3	J0K	1124472694
701	Swan River	Swan River	MB	Manitoba	52.1058	-101.2667	4014	560.4	America/Winnipeg	3	R0L	1124210942
702	Sutton	Sutton	QC	Quebec	45.091	-72.5792	4012	16.3	America/Montreal	4	J0E	1124001526
703	Northern Bruce Peninsula	Northern Bruce Peninsula	ON	Ontario	45.08	-81.38	3999	5.1	America/Toronto	3	N0H	1124000606
704	L’Islet-sur-Mer	L'Islet-sur-Mer	QC	Quebec	47.1	-70.35	3999	33.3	America/Montreal	3	G0R	1124309185
705	Carleton-sur-Mer	Carleton-sur-Mer	QC	Quebec	48.1	-66.1333	3991	18	America/Montreal	3	G0C	1124001943
706	Oka	Oka	QC	Quebec	45.47	-74.08	3969	69.3	America/Montreal	3	J0N	1124446142
707	Prescott	Prescott	ON	Ontario	44.7167	-75.5167	3965	1273.5	America/Toronto	3	K0E	1124461297
708	Amaranth	Amaranth	ON	Ontario	43.9833	-80.2333	3963	15	America/Toronto	3	L9W	1124001154
709	Marmora and Lake	Marmora and Lake	ON	Ontario	44.6425	-77.7372	3953	7.1	America/Toronto	3	K0K K0L	1124000420
710	Maniwaki	Maniwaki	QC	Quebec	46.375	-75.9667	3930	677.7	America/Montreal	3	J9E	1124137130
711	Morin-Heights	Morin-Heights	QC	Quebec	45.9	-74.25	3925	69.5	America/Montreal	3	J0R	1124001231
712	Dundas	Dundas	NB	New Brunswick	46.3155	-64.6947	3914	22.4	America/Moncton	4	E4R E4V	1124001475
713	Napierville	Napierville	QC	Quebec	45.1833	-73.4	3899	796.6	America/Montreal	3	J0J	1124015883
714	Crabtree	Crabtree	QC	Quebec	45.9667	-73.4667	3887	155	America/Montreal	3	J0K	1124136084
715	Bancroft	Bancroft	ON	Ontario	45.05	-77.85	3881	16.9	America/Toronto	3	K0L	1124451822
716	Saint-Tite	Saint-Tite	QC	Quebec	46.7333	-72.5667	3880	41.9	America/Montreal	3	G0X	1124821328
717	Howick	Howick	ON	Ontario	43.9	-81.07	3873	13.4	America/Toronto	3	N0G	1124000394
718	Dutton/Dunwich	Dutton/Dunwich	ON	Ontario	42.6667	-81.5	3866	13.1	America/Toronto	3	N0L	1124000540
719	Callander	Callander	ON	Ontario	46.1781	-79.4125	3863	36.4	America/Toronto	4	P0H	1124853285
720	Simonds	Simonds	NB	New Brunswick	45.3145	-65.803	3843	13.7	America/Moncton	4	E2S	1124001671
721	Baie-d’Urfé	Baie-d'Urfe	QC	Quebec	45.4167	-73.9167	3823	633.9	America/Montreal	3	H9X	1124534130
722	New Richmond	New Richmond	QC	Quebec	48.1667	-65.8667	3810	22.6	America/Montreal	3	G0C	1124960222
723	Perth South	Perth South	ON	Ontario	43.3	-81.15	3810	9.7	America/Toronto	3	N4X N5A N0K	1124000996
724	Roxton Pond	Roxton Pond	QC	Quebec	45.4833	-72.6667	3786	38.8	America/Montreal	4	J0E	1124356503
725	Sparwood	Sparwood	BC	British Columbia	49.7331	-114.8853	3784	19.4	America/Edmonton	3	V0B	1124001718
726	Claresholm	Claresholm	AB	Alberta	50.0194	-113.5783	3780	465.9	America/Edmonton	3	T0L	1124380878
727	Breslau	Breslau	ON	Ontario	43.4816	-80.408	3778	691.9	America/Toronto	3	N0B	1124001083
728	Montague	Montague	ON	Ontario	44.9667	-75.9667	3761	13.4	America/Toronto	3	K7A	1124001810
729	Cumberland	Cumberland	BC	British Columbia	49.6206	-125.0261	3753	128.9	America/Vancouver	3	V0R	1124658693
730	Beaupré	Beaupre	QC	Quebec	47.05	-70.9	3752	163.4	America/Montreal	3	G0A	1124125524
731	Saint-André-Avellin	Saint-Andre-Avellin	QC	Quebec	45.7167	-75.0667	3749	27.2	America/Montreal	3	J0V	1124494033
732	Saint-Ambroise-de-Kildare	Saint-Ambroise-de-Kildare	QC	Quebec	46.0833	-73.55	3747	55.3	America/Montreal	3	J0K	1124306240
733	East Angus	East Angus	QC	Quebec	45.4833	-71.6667	3741	472.7	America/Montreal	3	J0B	1124456321
734	Rossland	Rossland	BC	British Columbia	49.0786	-117.7992	3729	62.4	America/Vancouver	3	V0G	1124850810
735	Mackenzie	Mackenzie	BC	British Columbia	55.3381	-123.0944	3714	22.6	America/Vancouver	3	V0J	1124001437
736	Golden	Golden	BC	British Columbia	51.3019	-116.9667	3708	325	America/Edmonton	3	V0A	1124428625
737	Raymond	Raymond	AB	Alberta	49.4658	-112.6508	3708	557.1	America/Edmonton	3	T0K	1124125903
738	Saint-Adolphe-d'Howard	Saint-Adolphe-d'Howard	QC	Quebec	45.97	-74.33	3702	26.6	America/Montreal	3	J0T	1124001188
739	Bowen Island	Bowen Island	BC	British Columbia	49.3833	-123.3833	3680	73.4	America/Vancouver	3	V0N	1124000418
740	Bonnechere Valley	Bonnechere Valley	ON	Ontario	45.5333	-77.1	3674	6.2	America/Toronto	3	K0J	1124000398
741	Pincher Creek	Pincher Creek	AB	Alberta	49.4861	-113.95	3642	361.1	America/Edmonton	3	T0K	1124252125
742	Alnwick	Alnwick	NB	New Brunswick	47.2656	-65.2292	3640	5.4	America/Moncton	4	E1V E9G E9H	1124000627
743	Westville	Westville	NS	Nova Scotia	45.55	-62.7	3628	254.9	America/Halifax	3	B0K	1124476279
744	Fruitvale	Fruitvale	BC	British Columbia	49.1161	-117.5414	3627	1363.5	America/Vancouver	3	V0G	1124854890
745	Pasadena	Pasadena	NL	Newfoundland and Labrador	49.0161	-57.605	3620	73.6	America/St_Johns	3	A0L	1124001778
746	Saint-Prosper	Saint-Prosper	QC	Quebec	46.2167	-70.4833	3605	27	America/Montreal	4	G0M	1124232575
747	Ormstown	Ormstown	QC	Quebec	45.13	-74	3595	25.2	America/Montreal	3	J0S	1124670346
748	Cardston	Cardston	AB	Alberta	49.2025	-113.3019	3585	417.5	America/Edmonton	3	T0K	1124479644
749	Westbank	Westbank	BC	British Columbia	49.8423	-119.6743	3581	80.6	America/Vancouver	4	V4T	1124001101
750	De Salaberry	De Salaberry	MB	Manitoba	49.4403	-96.9844	3580	5.3	America/Winnipeg	3	R0A	1124001664
751	Headingley	Headingley	MB	Manitoba	49.8681	-97.3908	3579	33.4	America/Winnipeg	3	R4H R4J	1124000273
752	Grande Cache	Grande Cache	AB	Alberta	53.8773	-119.1199	3571	102.1	America/Edmonton	4	T0E	1124001952
753	Atholville	Atholville	NB	New Brunswick	47.9894	-66.7125	3570	29.8	America/Moncton	3	E3N	1124001302
754	Saint-Agapit	Saint-Agapit	QC	Quebec	46.5667	-71.4333	3567	54.5	America/Montreal	4	G0S	1124119699
755	Prince Albert No. 461	Prince Albert No. 461	SK	Saskatchewan	53.1089	-105.6574	3562	3.5	America/Regina	4	S6V	1124001802
756	Casselman	Casselman	ON	Ontario	45.3	-75.0833	3548	693.4	America/Toronto	3	K0A	1124666499
757	Saint-Ambroise	Saint-Ambroise	QC	Quebec	48.55	-71.3333	3546	23.5	America/Montreal	4	G7P	1124001342
758	Hay River	Hay River	NT	Northwest Territories	60.7531	-115.9004	3528	26.5	America/Yellowknife	4	X0E	1124721803
759	Mistissini	Mistissini	QC	Quebec	50.5707	-73.6829	3523	4.1	America/Montreal	4	G0W J0Y	1124001942
760	Studholm	Studholm	NB	New Brunswick	45.8133	-65.5747	3522	7.8	America/Moncton	4	E5P E4G	1124001373
761	Lumby	Lumby	BC	British Columbia	50.2494	-118.9656	3500	379.5	America/Vancouver	3	V0E	1124173367
762	Saint-Faustin--Lac-Carré	Saint-Faustin--Lac-Carre	QC	Quebec	46.0813	-74.4668	3499	28.8	America/Montreal	4	J0T	1124677642
763	Morris-Turnberry	Morris-Turnberry	ON	Ontario	43.85	-81.25	3496	9.1	America/Toronto	3	N0G	1124001124
764	Placentia	Placentia	NL	Newfoundland and Labrador	47.2458	-53.9611	3496	60.2	America/St_Johns	3	A0B	1124471582
765	Saint-Pascal	Saint-Pascal	QC	Quebec	47.5333	-69.8	3490	58.8	America/Montreal	3	G0L	1124617986
766	Mulmur	Mulmur	ON	Ontario	44.1917	-80.1083	3478	12.1	America/Toronto	3	L0M L9V	1124001711
767	Blind River	Blind River	ON	Ontario	46.1833	-82.95	3472	6.6	America/Toronto	3	P0R	1124244510
768	Dunham	Dunham	QC	Quebec	45.1333	-72.8	3471	17.8	America/Montreal	3	J0E	1124514371
769	Havre-Saint-Pierre	Havre-Saint-Pierre	QC	Quebec	50.2333	-63.6	3460	1.2	America/Montreal	3	G0G	1124890113
770	Saint-Anselme	Saint-Anselme	QC	Quebec	46.6333	-70.9667	3458	46.9	America/Montreal	4	G0R	1124041118
771	Trois-Pistoles	Trois-Pistoles	QC	Quebec	48.12	-69.18	3456	450.9	America/Montreal	3	G0L	1124667916
772	Grande-Rivière	Grande-Riviere	QC	Quebec	48.4	-64.5	3456	39.5	America/Montreal	3	G0C	1124608500
773	Powassan	Powassan	ON	Ontario	46.0825	-79.3619	3455	15.4	America/Toronto	3	P0H	1124971329
774	Malartic	Malartic	QC	Quebec	48.1333	-78.1333	3449	23.2	America/Montreal	3	J0Y	1124600555
775	Bonavista	Bonavista	NL	Newfoundland and Labrador	48.6597	-53.1208	3448	109.4	America/St_Johns	3	A0C	1124990261
776	Killarney - Turtle Mountain	Killarney - Turtle Mountain	MB	Manitoba	49.1775	-99.6906	3429	3.7	America/Winnipeg	4	R0K	1124001432
777	Woodlands	Woodlands	MB	Manitoba	50.2408	-97.7358	3416	2.9	America/Winnipeg	4	R0C	1124530756
778	Lewisporte	Lewisporte	NL	Newfoundland and Labrador	49.23	-55.07	3409	92.4	America/St_Johns	3	A0G	1124582594
779	Saint-Denis-de-Brompton	Saint-Denis-de-Brompton	QC	Quebec	45.45	-72.0833	3402	48.1	America/Montreal	4	J0B	1124001970
780	Invermere	Invermere	BC	British Columbia	50.5083	-116.0303	3391	315.9	America/Edmonton	3	V0A	1124839399
781	Salisbury	Salisbury	NB	New Brunswick	46.0776	-65.1996	3388	3.9	America/Moncton	4	E4Z E4J	1124001982
782	Bifrost-Riverton	Bifrost-Riverton	MB	Manitoba	51.0603	-97.1436	3378	2.1	America/Winnipeg	3	R0C	1124000047
783	Buckland No. 491	Buckland No. 491	SK	Saskatchewan	53.3276	-105.7804	3375	4.3	America/Regina	4	S0J S6V	1124001476
784	Cartier	Cartier	MB	Manitoba	49.9161	-97.7	3368	6.1	America/Winnipeg	3	R4K R0G R0H	1124001073
785	Sainte-Anne-des-Lacs	Sainte-Anne-des-Lacs	QC	Quebec	45.85	-74.1333	3363	135.8	America/Montreal	3	J0R	1124001507
786	Highlands East	Highlands East	ON	Ontario	44.9667	-78.25	3343	4.7	America/Toronto	3	K0L K0M	1124001598
787	Alexander	Alexander	MB	Manitoba	50.4222	-96.075	3333	2.1	America/Winnipeg	3	R0E	1124001199
788	Sainte-Claire	Sainte-Claire	QC	Quebec	46.6	-70.8667	3325	37.8	America/Montreal	3	G0R	1124401109
789	Percé	Perce	QC	Quebec	48.5333	-64.2167	3312	7.7	America/Montreal	3	G0C	1124000234
790	Saint-Jean-Port-Joli	Saint-Jean-Port-Joli	QC	Quebec	47.2167	-70.2667	3304	47.9	America/Montreal	3	G0R	1124255737
791	East Hawkesbury	East Hawkesbury	ON	Ontario	45.5167	-74.4667	3296	14	America/Toronto	3	K6A K0B	1124000222
792	Bright	Bright	NB	New Brunswick	46.1205	-67.0545	3289	8.1	America/Moncton	4	E6L	1124001649
793	Penhold	Penhold	AB	Alberta	52.1333	-113.8667	3277	619.9	America/Edmonton	3	T0M	1124360682
794	Saint-André-d'Argenteuil	Saint-Andre-d'Argenteuil	QC	Quebec	45.5667	-74.3333	3275	33.5	America/Montreal	3	J0V	1124000962
795	Saint-Côme--Linière	Saint-Come--Liniere	QC	Quebec	46.0667	-70.5167	3274	21.8	America/Montreal	4	G0M	1124151898
796	Saint-Sulpice	Saint-Sulpice	QC	Quebec	45.8333	-73.35	3273	90	America/Montreal	3	J5W	1124000703
797	Marathon	Marathon	ON	Ontario	48.75	-86.3667	3273	19.2	America/Toronto	3	P0T	1124974800
798	Forestville	Forestville	QC	Quebec	48.7333	-69.0833	3270	16.8	America/Montreal	3	G0T	1124215354
799	Inuvik	Inuvik	NT	Northwest Territories	68.3407	-133.6096	3243	51.9	America/Inuvik	4	X0E	1124116419
800	Lake Cowichan	Lake Cowichan	BC	British Columbia	48.8258	-124.0542	3226	369.6	America/Vancouver	3	V0R	1124082843
801	Sables-Spanish Rivers	Sables-Spanish Rivers	ON	Ontario	46.2333	-82	3214	3.9	America/Toronto	3	P0P	1124000330
802	Hillsburg-Roblin-Shell River	Hillsburg-Roblin-Shell River	MB	Manitoba	51.3343	-101.2929	3214	1.9	America/Winnipeg	4	R0L	1124001467
803	Port Hawkesbury	Port Hawkesbury	NS	Nova Scotia	45.6153	-61.3642	3214	396.6	America/Halifax	3	B9A	1124913307
804	Three Hills	Three Hills	AB	Alberta	51.7072	-113.2647	3212	475.7	America/Edmonton	3	T0M	1124247045
805	Lorette	Lorette	MB	Manitoba	49.7414	-96.8761	3208	685	America/Winnipeg	3	R0A	1124000429
806	Paspebiac	Paspebiac	QC	Quebec	48.0333	-65.25	3198	33.8	America/Montreal	3	G0C	1124858850
807	Saint-Thomas	Saint-Thomas	QC	Quebec	46.0167	-73.35	3193	33.6	America/Montreal	3	J0K	1124176940
808	Saint-Jean-Baptiste	Saint-Jean-Baptiste	QC	Quebec	45.5167	-73.1167	3191	44.3	America/Montreal	3	J0L	1124000869
809	Portneuf	Portneuf	QC	Quebec	46.7	-71.8833	3187	29.1	America/Montreal	3	G0A	1124993610
810	Pictou	Pictou	NS	Nova Scotia	45.6814	-62.7119	3186	397.6	America/Halifax	3	B0K	1124595917
811	Tisdale	Tisdale	SK	Saskatchewan	52.85	-104.05	3180	491.5	America/Regina	3	S0E	1124001086
812	Lake of Bays	Lake of Bays	ON	Ontario	45.3043	-79.018	3167	4.7	America/Toronto	4	P0B P0A P1H	1124000232
813	High Level	High Level	AB	Alberta	58.5169	-117.1361	3159	108.2	America/Edmonton	3	T0H	1124099423
814	Gibbons	Gibbons	AB	Alberta	53.8278	-113.3228	3159	421.3	America/Edmonton	3	T0A	1124001097
815	Bishops Falls	Bishops Falls	NL	Newfoundland and Labrador	49.0167	-55.5167	3156	112.2	America/St_Johns	3	A0H	1124735612
816	WestLake-Gladstone	WestLake-Gladstone	MB	Manitoba	50.2862	-98.8415	3154	1.7	America/Winnipeg	4	R0J R0H	1124001087
817	Normandin	Normandin	QC	Quebec	48.8333	-72.5333	3137	14.8	America/Montreal	3	G8M	1124410764
818	Saint-Alphonse-Rodriguez	Saint-Alphonse-Rodriguez	QC	Quebec	46.1833	-73.7	3134	32	America/Montreal	3	J0K	1124001435
819	Beauséjour	Beausejour	MB	Manitoba	50.0622	-96.5161	3126	584.4	America/Winnipeg	3	R0E	1124260967
820	Dalhousie	Dalhousie	NB	New Brunswick	48.1	-66.6167	3126	205.3	America/Montreal	3	E8C	1124540945
821	Saint-Alphonse-de-Granby	Saint-Alphonse-de-Granby	QC	Quebec	45.3333	-72.8167	3125	62.6	America/Montreal	3	J0E	1124000185
822	Lac du Bonnet	Lac du Bonnet	MB	Manitoba	50.2577	-96.1209	3121	2.8	America/Winnipeg	4	R0E	1124000450
823	Clermont	Clermont	QC	Quebec	47.6833	-70.2333	3118	62.8	America/Montreal	3	G4A	1124937298
824	Virden	Virden	MB	Manitoba	49.8508	-100.9317	3114	370.2	America/Winnipeg	3	R0M	1124620072
825	Compton	Compton	QC	Quebec	45.2333	-71.8167	3112	15.1	America/Montreal	4	J0B	1124144541
826	White City	White City	SK	Saskatchewan	50.4353	-104.3572	3099	7.5	America/Regina	3	S4L	1124001289
827	Ellison	Ellison	BC	British Columbia	49.9646	-119.3178	3094	37.6	America/Vancouver	4	V1X V1P	1124000194
828	Mont-Saint-Grégoire	Mont-Saint-Gregoire	QC	Quebec	45.3333	-73.1667	3086	38.8	America/Montreal	3	J0J	1124094125
829	Wellington	Wellington	NB	New Brunswick	46.4768	-64.7478	3079	16.7	America/Moncton	4	E4S E4V	1124001391
830	Merrickville	Merrickville	ON	Ontario	44.8539	-75.8269	3067	14.3	America/Toronto	4	K0G	1124846224
831	Saint-Liboire	Saint-Liboire	QC	Quebec	45.65	-72.7667	3051	41.9	America/Montreal	3	J0H	1124016354
832	Dégelis	Degelis	QC	Quebec	47.55	-68.65	3051	5.5	America/Montreal	3	G5T	1124001549
833	Morris	Morris	MB	Manitoba	49.3986	-97.4592	3047	2.9	America/Winnipeg	4	R0G	1124001886
834	Saint-Alexis-des-Monts	Saint-Alexis-des-Monts	QC	Quebec	46.4667	-73.1333	3046	2.9	America/Montreal	3	J0K	1124120192
835	Cap-Saint-Ignace	Cap-Saint-Ignace	QC	Quebec	47.0333	-70.4667	3045	14.6	America/Montreal	3	G0R	1124138813
836	Saint-Anaclet-de-Lessard	Saint-Anaclet-de-Lessard	QC	Quebec	48.48	-68.42	3035	23.9	America/Montreal	4	G0K	1124764523
837	Carman	Carman	MB	Manitoba	49.4992	-98.0008	3027	702.4	America/Winnipeg	3	R0G	1124732787
838	Athens	Athens	ON	Ontario	44.625	-75.95	3013	23.6	America/Toronto	3	K0E	1124291343
839	Melancthon	Melancthon	ON	Ontario	44.15	-80.2667	3008	9.7	America/Toronto	3	L0N	1124736504
840	Cap Santé	Cap Sante	QC	Quebec	46.6667	-71.7833	2996	54.7	America/Montreal	3	G0A	1124080648
841	Harbour Grace	Harbour Grace	NL	Newfoundland and Labrador	47.6917	-53.2167	2995	88.8	America/St_Johns	3	A0A	1124871661
842	Houston	Houston	BC	British Columbia	54.3975	-126.6419	2993	41	America/Vancouver	3	V0J	1124993327
843	Adelaide-Metcalfe	Adelaide-Metcalfe	ON	Ontario	42.95	-81.7	2990	9	America/Toronto	3	N0M N7G	1124000926
844	Crossfield	Crossfield	AB	Alberta	51.4333	-114.0333	2983	249.3	America/Edmonton	3	T0M	1124737275
845	Springdale	Springdale	NL	Newfoundland and Labrador	49.4974	-56.0727	2971	168.8	America/St_Johns	3	A0J	1124612197
846	Fort Macleod	Fort Macleod	AB	Alberta	49.7256	-113.3975	2967	126.8	America/Edmonton	3	T0L	1124975838
847	Athabasca	Athabasca	AB	Alberta	54.7197	-113.2856	2965	168	America/Edmonton	3	T9S	1124006333
848	Enderby	Enderby	BC	British Columbia	50.5508	-119.1397	2964	695.8	America/Vancouver	3	V0E	1124312550
849	Saint-Ferréol-les-Neiges	Saint-Ferreol-les-Neiges	QC	Quebec	47.1167	-70.85	2964	35.6	America/Montreal	3	G0A	1124255920
850	Laurentian Hills	Laurentian Hills	ON	Ontario	46.1333	-77.55	2961	4.6	America/Montreal	3	K0J	1124000976
851	Grand Valley	Grand Valley	ON	Ontario	43.95	-80.3667	2956	18.7	America/Toronto	3	L9W	1124627074
852	Senneterre	Senneterre	QC	Quebec	48.3833	-77.2333	2953	0.2	America/Montreal	3	J0Y	1124548422
853	Sainte-Marie-Madeleine	Sainte-Marie-Madeleine	QC	Quebec	45.6	-73.1	2935	57.7	America/Montreal	4	J0H	1124000666
854	Admaston/Bromley	Admaston/Bromley	ON	Ontario	45.5292	-76.8969	2935	5.6	America/Toronto	3	K7V K0J	1124001494
855	Saint-Gabriel-de-Valcartier	Saint-Gabriel-de-Valcartier	QC	Quebec	46.9333	-71.4667	2933	6.7	America/Montreal	3	G0A	1124782327
856	North Algona Wilberforce	North Algona Wilberforce	ON	Ontario	45.6167	-77.2	2915	7.7	America/Toronto	3	K8A K0J	1124001620
857	Kingston	Kingston	NB	New Brunswick	45.4663	-66.0217	2913	14.5	America/Moncton	4	E5N E5S	1124000116
858	Wawa	Wawa	ON	Ontario	47.9931	-84.7736	2905	7	America/Toronto	3	P0S	1124381797
859	Saint-Christophe-d'Arthabaska	Saint-Christophe-d'Arthabaska	QC	Quebec	46.0333	-71.8833	2892	41.9	America/Montreal	4	G6R G6S	1124000694
860	Sainte-Mélanie	Sainte-Melanie	QC	Quebec	46.1333	-73.5167	2892	38.1	America/Montreal	3	J0K	1124173990
861	Ascot Corner	Ascot Corner	QC	Quebec	45.45	-71.7667	2891	35.1	America/Montreal	4	J0B	1124945733
862	Horton	Horton	ON	Ontario	45.5	-76.6667	2887	18.2	America/Toronto	3	K7V	1124001850
863	Saint-Michel	Saint-Michel	QC	Quebec	45.2333	-73.5667	2884	48.2	America/Montreal	3	J0L	1124926265
864	Botwood	Botwood	NL	Newfoundland and Labrador	49.15	-55.3667	2875	191	America/St_Johns	3	A0H	1124634384
865	Saint-Paul-d'Abbotsford	Saint-Paul-d'Abbotsford	QC	Quebec	45.4333	-72.8833	2870	36.1	America/Montreal	4	J0E	1124492372
866	Saint-Marc-des-Carrières	Saint-Marc-des-Carrieres	QC	Quebec	46.6833	-72.05	2862	172	America/Montreal	3	G0A	1124924445
867	Stanstead	Stanstead	QC	Quebec	45.0167	-72.1	2857	125.8	America/Montreal	3	J0B	1124000851
868	Sainte-Anne-de-Beaupré	Sainte-Anne-de-Beaupre	QC	Quebec	47.0167	-70.9333	2854	45.6	America/Montreal	3	G0A	1124323389
869	Sainte-Luce	Sainte-Luce	QC	Quebec	48.55	-68.38	2851	39	America/Montreal	3	G0K	1124000034
870	Saint-Gabriel	Saint-Gabriel	QC	Quebec	46.3	-73.3833	2844	1012.3	America/Montreal	3	J0K	1124920056
871	Rankin Inlet	Rankin Inlet	NU	Nunavut	62.83	-92.1321	2842	140.4	America/Rankin_Inlet	4	X0C	1124057160
872	Vanscoy No. 345	Vanscoy No. 345	SK	Saskatchewan	52.0073	-107.0552	2840	3.3	America/Regina	4	S0K S0L S7K	1124001166
873	Cedar	Cedar	BC	British Columbia	49.0853	-123.8259	2836	83.8	America/Vancouver	4	V9X	1124000187
874	Princeton	Princeton	BC	British Columbia	49.4589	-120.506	2828	47.4	America/Vancouver	3	V0X	1124790102
875	La Loche	La Loche	SK	Saskatchewan	56.4833	-109.4333	2827	181.3	America/Regina	3	S0M	1124048077
876	Kingsclear	Kingsclear	NB	New Brunswick	45.8796	-66.8695	2822	18.6	America/Moncton	4	E3E	1124744497
877	Ferme-Neuve	Ferme-Neuve	QC	Quebec	46.7	-75.45	2822	3.6	America/Montreal	3	J0W	1124159065
878	Thurso	Thurso	QC	Quebec	45.5969	-75.2433	2818	449	America/Montreal	3	J0X	1124913486
879	Adstock	Adstock	QC	Quebec	46.05	-71.08	2806	9.7	America/Montreal	4	G0N	1124001673
880	Shuniah	Shuniah	ON	Ontario	48.5833	-88.8333	2798	4.9	America/Toronto	3	P0T P7A	1124000092
881	Enniskillen	Enniskillen	ON	Ontario	42.8167	-82.125	2796	8.3	America/Toronto	3	N0N	1124001379
882	Yamachiche	Yamachiche	QC	Quebec	46.2667	-72.8333	2787	26.2	America/Montreal	3	G0X	1124138672
883	Saint-Maurice	Saint-Maurice	QC	Quebec	46.4667	-72.5333	2775	30.3	America/Montreal	3	G0X	1124381241
884	Bonaventure	Bonaventure	QC	Quebec	48.05	-65.4833	2775	26.6	America/Montreal	3	G0C	1124014798
885	Val-Morin	Val-Morin	QC	Quebec	46	-74.18	2772	70.3	America/Montreal	3	J0T	1124001446
886	Pohénégamook	Pohenegamook	QC	Quebec	47.4667	-69.2167	2770	8.1	America/Montreal	3	G0L	1124000688
887	Wakefield	Wakefield	NB	New Brunswick	46.2406	-67.6248	2767	14.1	America/Moncton	4	E7M E7P	1124000329
888	Stoke	Stoke	QC	Quebec	45.5333	-71.8	2765	10.8	America/Montreal	4	J0B	1124001196
889	Sainte-Marguerite-du-Lac-Masson	Sainte-Marguerite-du-Lac-Masson	QC	Quebec	46.056	-74.0723	2763	30	America/Montreal	4	J0T	1124208615
890	Saint-Prime	Saint-Prime	QC	Quebec	48.58	-72.33	2758	18.7	America/Montreal	3	G8J	1124389119
891	Kuujjuaq	Kuujjuaq	QC	Quebec	58.1429	-68.3742	2754	9.4	America/Montreal	4	J0M	1124705411
892	Atikokan	Atikokan	ON	Ontario	48.75	-91.6167	2753	8.6	America/Atikokan	3	P0T	1124868159
893	Grenville-sur-la-Rouge	Grenville-sur-la-Rouge	QC	Quebec	45.65	-74.6333	2746	8.7	America/Montreal	3	J0V	1124001524
894	North Cypress-Langford	North Cypress-Langford	MB	Manitoba	49.9969	-99.3982	2745	1.6	America/Winnipeg	4	R0J R0K	1124001785
895	Sainte-Anne-de-Sorel	Sainte-Anne-de-Sorel	QC	Quebec	46.05	-73.0667	2742	71.4	America/Montreal	4	J3P	1124001977
896	Macamic	Macamic	QC	Quebec	48.75	-79	2734	13.5	America/Montreal	3	J0Z	1124965674
897	Sundre	Sundre	AB	Alberta	51.7972	-114.6406	2729	245.6	America/Edmonton	3	T0M	1124001279
898	Rougemont	Rougemont	QC	Quebec	45.4333	-73.05	2723	62	America/Montreal	3	J0L	1124876872
899	Piedmont	Piedmont	QC	Quebec	45.9	-74.13	2721	111.7	America/Montreal	3	J0R	1124001265
900	Grimshaw	Grimshaw	AB	Alberta	56.1908	-117.6117	2718	383.4	America/Edmonton	3	T0H	1124339886
901	Lac-des-Écorces	Lac-des-Ecorces	QC	Quebec	46.55	-75.35	2713	18.8	America/Montreal	3	J0W	1124808962
902	Northeastern Manitoulin and the Islands	Northeastern Manitoulin and the Islands	ON	Ontario	45.9667	-81.9333	2706	5.5	America/Toronto	3	P0P	1124001541
903	Pelican Narrows	Pelican Narrows	SK	Saskatchewan	55.1883	-102.9342	2703	295	America/Regina	3	S0P	1124970223
904	McDougall	McDougall	ON	Ontario	45.45	-80.0167	2702	10.1	America/Toronto	3	P2A	1124000643
905	Black Diamond	Black Diamond	AB	Alberta	50.6881	-114.2333	2700	702.7	America/Edmonton	3	T0L	1124170822
906	Saint-Pamphile	Saint-Pamphile	QC	Quebec	46.9667	-69.7833	2685	19.6	America/Montreal	3	G0R	1124993070
907	Bedford	Bedford	QC	Quebec	45.1167	-72.9833	2684	639.4	America/Montreal	3	J0J	1124195813
908	Weedon-Centre	Weedon-Centre	QC	Quebec	45.7	-71.4667	2683	12.4	America/Montreal	3	J0B	1124651516
909	Lacolle	Lacolle	QC	Quebec	45.0833	-73.3667	2680	54	America/Montreal	3	J0J	1124270266
910	Saint-Gabriel-de-Brandon	Saint-Gabriel-de-Brandon	QC	Quebec	46.2667	-73.3833	2679	26.8	America/Montreal	3	J0K	1124001827
911	Errington	Errington	BC	British Columbia	49.2874	-124.3433	2677	97.4	America/Vancouver	4	V0R V9P	1124001138
912	Coalhurst	Coalhurst	AB	Alberta	49.7457	-112.9319	2668	857.5	America/Edmonton	3	T0L	1124001548
913	French River / Rivière des Français	French River / Riviere des Francais	ON	Ontario	46.1667	-80.5	2662	3.6	America/Toronto	3	P0M	1124000556
914	Arviat	Arviat	NU	Nunavut	61.0996	-94.1688	2657	20.1	America/Rankin_Inlet	4	X0C	1124309634
915	Saint-David-de-Falardeau	Saint-David-de-Falardeau	QC	Quebec	48.6167	-71.1167	2657	6.6	America/Montreal	4	G0V	1124001854
916	Markstay	Markstay	ON	Ontario	46.4912	-80.4717	2656	5.2	America/Toronto	4	P0H P0M	1124061532
917	Spaniards Bay	Spaniards Bay	NL	Newfoundland and Labrador	47.6181	-53.3369	2653	40.4	America/St_Johns	3	A0A	1124334544
918	Cocagne	Cocagne	NB	New Brunswick	46.3406	-64.62	2649	66.78	America/Moncton	3	E4R	1124000195
919	Saint-Bruno	Saint-Bruno	QC	Quebec	48.4667	-71.65	2636	33.8	America/Montreal	3	G0W	1124000655
920	Chetwynd	Chetwynd	BC	British Columbia	55.6972	-121.6333	2635	43.1	America/Dawson_Creek	3	V0C	1124001005
921	Laurier-Station	Laurier-Station	QC	Quebec	46.5333	-71.6333	2634	219.3	America/Montreal	3	G0S	1124029105
922	Saint-Anicet	Saint-Anicet	QC	Quebec	45.12	-74.35	2626	19.4	America/Montreal	3	J0S	1124287636
923	Saint-Mathieu-de-Beloeil	Saint-Mathieu-de-Beloeil	QC	Quebec	45.5667	-73.2	2624	65.8	America/Montreal	3	J3G	1124000340
924	Cap-Chat	Cap-Chat	QC	Quebec	49.1	-66.6833	2623	14.4	America/Montreal	3	G0J	1124662875
925	Sexsmith	Sexsmith	AB	Alberta	55.3508	-118.7825	2620	197.9	America/Edmonton	3	T0H	1124024490
926	Notre-Dame-de-Lourdes	Notre-Dame-de-Lourdes	QC	Quebec	46.1	-73.4333	2595	72.6	America/Montreal	4	J0K	1124935751
927	Ville-Marie	Ville-Marie	QC	Quebec	47.3333	-79.4333	2595	424.8	America/Montreal	3	J9V	1124001938
928	Saint-Isidore	Saint-Isidore	QC	Quebec	45.3	-73.68	2581	49.7	America/Montreal	3	J0L	1124775572
929	Shippegan	Shippegan	NB	New Brunswick	47.7439	-64.7178	2580	257.6	America/Moncton	3	E8S	1124198415
930	East Garafraxa	East Garafraxa	ON	Ontario	43.85	-80.25	2579	15.5	America/Toronto	3	L9W	1124000753
931	Pemberton	Pemberton	BC	British Columbia	50.3203	-122.8053	2574	217.5	America/Vancouver	3	V0N	1124476252
932	Unity	Unity	SK	Saskatchewan	52.4333	-109.1667	2573	244.6	America/Regina	3	S0K	1124230227
933	Rimbey	Rimbey	AB	Alberta	52.6333	-114.2167	2567	225.1	America/Edmonton	3	T0C	1124861733
934	High Prairie	High Prairie	AB	Alberta	55.4325	-116.4861	2564	355.3	America/Edmonton	3	T0G	1124163323
935	Turner Valley	Turner Valley	AB	Alberta	50.6739	-114.2786	2559	442.1	America/Edmonton	3	T0L	1124557397
936	Hanna	Hanna	AB	Alberta	51.6383	-111.9419	2559	290.6	America/Edmonton	3	T0J	1124751402
937	Fort Smith	Fort Smith	NT	Northwest Territories	60.026	-112.0821	2542	27.4	America/Yellowknife	4	X0E	1124491408
938	Maria	Maria	QC	Quebec	48.1667	-65.9833	2536	26.7	America/Montreal	3	G0C	1124002967
939	Saint-Chrysostome	Saint-Chrysostome	QC	Quebec	45.1	-73.7667	2522	25.2	America/Montreal	3	J0S	1124333805
940	Greater Madawaska	Greater Madawaska	ON	Ontario	45.2722	-76.8589	2518	2.4	America/Toronto	3	K7V K0J	1124001487
941	Berwick	Berwick	NS	Nova Scotia	45.0475	-64.736	2509	381.3	America/Halifax	3	B0P	1124831957
942	Saint-Damase	Saint-Damase	QC	Quebec	45.5333	-73	2506	31.7	America/Montreal	3	J0H	1124245814
943	Disraeli	Disraeli	QC	Quebec	45.9	-71.35	2502	362.1	America/Montreal	3	G0N	1124115327
944	Sainte-Victoire-de-Sorel	Sainte-Victoire-de-Sorel	QC	Quebec	45.95	-73.0833	2501	33.5	America/Montreal	4	J0G	1124001523
945	Meadow Lake No. 588	Meadow Lake No. 588	SK	Saskatchewan	54.1213	-108.2837	2501	0.4	America/Regina	4	S0M S9X	1124001846
946	Elkford	Elkford	BC	British Columbia	50.0214	-114.9158	2499	24.6	America/Edmonton	3	V0B	1124000218
947	Georgian Bay	Georgian Bay	ON	Ontario	44.9833	-79.8167	2499	4.6	America/Toronto	3	L0K P0E	1124001020
948	Saint-Alexandre	Saint-Alexandre	QC	Quebec	45.2333	-73.1167	2495	32.8	America/Montreal	3	J0J	1124016760
949	Hérbertville	Herbertville	QC	Quebec	48.3473	-71.6784	2491	9.5	America/Montreal	4	G8N	1124806332
950	Moosomin	Moosomin	SK	Saskatchewan	50.142	-101.67	2485	327.5	America/Regina	3	S0G	1124103159
951	North Kawartha	North Kawartha	ON	Ontario	44.75	-78.1	2479	3.2	America/Toronto	3	K0L	1124001184
952	Sainte-Thècle	Sainte-Thecle	QC	Quebec	46.8167	-72.5	2478	11.6	America/Montreal	3	G0X	1124387301
953	Trenton	Trenton	NS	Nova Scotia	45.6193	-62.6332	2474	407.8	America/Halifax	3	B0K	1124776153
954	Fermont	Fermont	QC	Quebec	52.7833	-67.0833	2474	5.2	America/Montreal	3	G0G	1124001089
955	Esterhazy	Esterhazy	SK	Saskatchewan	50.65	-102.0667	2472	520.9	America/Regina	3	S0A	1124095034
956	Wickham	Wickham	QC	Quebec	45.75	-72.5	2470	25	America/Montreal	3	J0C	1124353605
957	La Présentation	La Presentation	QC	Quebec	45.6667	-73.05	2466	26.1	America/Montreal	3	J0H	1124865042
958	Beaverlodge	Beaverlodge	AB	Alberta	55.2094	-119.4292	2465	430.5	America/Edmonton	3	T0H	1124894073
959	Sainte-Catherine-de-Hatley	Sainte-Catherine-de-Hatley	QC	Quebec	45.25	-72.05	2464	28.5	America/Montreal	3	J0B	1124000135
960	Saint-Basile	Saint-Basile	QC	Quebec	46.75	-71.8167	2463	25.1	America/Montreal	3	G0A	1124369196
961	Saint-Raphaël	Saint-Raphael	QC	Quebec	46.8	-70.75	2463	20.3	America/Montreal	4	G0R	1124630982
962	Holyrood	Holyrood	NL	Newfoundland and Labrador	47.3833	-53.1333	2463	19.6	America/St_Johns	4	A0A	1124289617
963	Gracefield	Gracefield	QC	Quebec	46.0926	-75.9574	2462	6.4	America/Montreal	4	J0X	1124000820
964	Saint-Martin	Saint-Martin	QC	Quebec	45.9667	-70.65	2462	20.8	America/Montreal	4	G0M	1124001971
965	Causapscal	Causapscal	QC	Quebec	48.3667	-67.2333	2458	15.2	America/Montreal	3	G0J	1124289460
966	Brigham	Brigham	QC	Quebec	45.25	-72.85	2457	28.2	America/Montreal	3	J2K	1124336821
967	Perry	Perry	ON	Ontario	45.5	-79.2833	2454	13.1	America/Toronto	3	P0A	1124001994
968	Port-Daniel--Gascons	Port-Daniel--Gascons	QC	Quebec	48.1833	-64.9667	2453	8.1	America/Montreal	3	G0C	1124001024
969	Rosetown	Rosetown	SK	Saskatchewan	51.55	-107.9833	2451	201.9	America/Regina	3	S0L	1124742251
970	Minnedosa	Minnedosa	MB	Manitoba	50.2453	-99.8428	2449	161.1	America/Winnipeg	3	R0J	1124860237
971	Labelle	Labelle	QC	Quebec	46.2833	-74.7333	2445	12.3	America/Montreal	3	J0T	1124748931
972	Huntingdon	Huntingdon	QC	Quebec	45.08	-74.17	2444	879.2	America/Montreal	3	J0S	1124322836
973	Hébertville	Hebertville	QC	Quebec	48.4	-71.6833	2441	9.3	America/Montreal	4	G0W	1124293093
974	Black River-Matheson	Black River-Matheson	ON	Ontario	48.5333	-80.4667	2438	2.1	America/Toronto	3	P0K	1124000106
975	Saint-Michel-des-Saints	Saint-Michel-des-Saints	QC	Quebec	46.6833	-73.9167	2436	4.9	America/Montreal	3	J0K	1124969050
976	Dufferin	Dufferin	MB	Manitoba	49.5319	-98.07	2435	2.7	America/Winnipeg	4	R0G	1124001018
977	Saint-Victor	Saint-Victor	QC	Quebec	46.15	-70.9	2430	20.2	America/Montreal	3	G0M	1124899336
978	Sicamous	Sicamous	BC	British Columbia	50.8378	-118.9703	2429	192	America/Vancouver	3	V0E	1124519194
979	Cap Pele	Cap Pele	NB	New Brunswick	46.2172	-64.2822	2425	103.8	America/Moncton	4	E4N	1124541608
980	Kelsey	Kelsey	MB	Manitoba	53.7356	-101.395	2424	2.8	America/Winnipeg	3	R9A R0B	1124001840
981	Killaloe, Hagarty and Richards	Killaloe, Hagarty and Richards	ON	Ontario	45.6	-77.5	2420	6.1	America/Toronto	3	K0J	1124001779
982	Alvinston	Alvinston	ON	Ontario	42.8489	-81.9049	2411	7.7	America/Toronto	4	N0N	1124753895
983	Dundurn No. 314	Dundurn No. 314	SK	Saskatchewan	51.8261	-106.5416	2404	3	America/Regina	4	S0K	1124000094
984	Saint-Éphrem-de-Beauce	Saint-Ephrem-de-Beauce	QC	Quebec	46.0516	-70.9374	2400	20.2	America/Montreal	4	G0M	1124956973
985	Assiniboia	Assiniboia	SK	Saskatchewan	49.6167	-105.9833	2389	630.3	America/Regina	3	S0H	1124513932
986	Témiscaming	Temiscaming	QC	Quebec	46.7167	-79.1	2385	3.3	America/Toronto	3	J0Z	1124002169
987	Magrath	Magrath	AB	Alberta	49.4239	-112.8683	2374	396.4	America/Edmonton	3	T0K	1124735480
988	Sainte-Geneviève-de-Berthier	Sainte-Genevieve-de-Berthier	QC	Quebec	46.0833	-73.2167	2365	35.5	America/Montreal	4	J0K	1124001090
989	Buctouche	Buctouche	NB	New Brunswick	46.4719	-64.7249	2361	130.5	America/Moncton	3	E4S	1124405790
990	Grand Manan	Grand Manan	NB	New Brunswick	44.69	-66.82	2360	15.8	America/Moncton	3	E5G	1124000229
991	Sainte-Madeleine	Sainte-Madeleine	QC	Quebec	45.6	-73.1	2356	439.8	America/Montreal	3	J0H	1124000679
992	Boissevain	Boissevain	MB	Manitoba	49.1779	-100.0955	2353	2.2	America/Winnipeg	4	R0K	1124368869
993	Scott	Scott	QC	Quebec	46.512	-71.077	2352	75.1	America/Montreal	4	G0S	1124001254
994	Sainte-Croix	Sainte-Croix	QC	Quebec	46.62	-71.73	2352	33.8	America/Montreal	3	G0S	1124208011
995	Algonquin Highlands	Algonquin Highlands	ON	Ontario	45.4	-78.75	2351	2.3	America/Toronto	3	P0A	1124001381
996	Valcourt	Valcourt	QC	Quebec	45.5	-72.3167	2349	467.3	America/Montreal	3	J0E	1124334549
997	Saint George	Saint George	NB	New Brunswick	45.2916	-66.8501	2341	4.7	America/Moncton	4	E5C	1124000156
998	Paquetville	Paquetville	NB	New Brunswick	47.6334	-65.1803	2329	10.6	America/Moncton	4	E8R	1124000770
999	Saint-Dominique	Saint-Dominique	QC	Quebec	45.5667	-72.85	2327	33.7	America/Montreal	3	J0H	1124847475
1000	Clearwater	Clearwater	BC	British Columbia	51.65	-120.0333	2324	41.7	America/Vancouver	3	V0E	1124911350
1001	Addington Highlands	Addington Highlands	ON	Ontario	45	-77.25	2323	1.7	America/Toronto	3	K0H	1124001921
1002	Lillooet	Lillooet	BC	British Columbia	50.6864	-121.9364	2321	84.4	America/Vancouver	3	V0K	1124632130
1003	Burin	Burin	NL	Newfoundland and Labrador	47.05	-55.18	2315	67.8	America/St_Johns	3	A0E	1124434509
1004	Grand Bank	Grand Bank	NL	Newfoundland and Labrador	47.1	-55.7833	2310	136.1	America/St_Johns	3	A0E	1124257527
1005	Léry	Lery	QC	Quebec	45.35	-73.8	2307	218.2	America/Montreal	3	J6N	1124481204
1006	Rosthern No. 403	Rosthern No. 403	SK	Saskatchewan	52.6206	-106.3967	2300	2.4	America/Regina	4	S0K	1124001178
1007	Chase	Chase	BC	British Columbia	50.8189	-119.6844	2286	607	America/Vancouver	3	V0E	1124452830
1008	Mansfield-et-Pontefract	Mansfield-et-Pontefract	QC	Quebec	45.8611	-76.7392	2285	4.8	America/Montreal	3	J0X	1124000865
1009	Saint-Denis	Saint-Denis	QC	Quebec	45.7833	-73.15	2285	26.9	America/Montreal	3	J0H	1124298615
1010	Outlook	Outlook	SK	Saskatchewan	51.5	-107.05	2279	291	America/Regina	3	S0L	1124721522
1011	Mitchell	Mitchell	MB	Manitoba	49.5363	-96.7634	2279	704.7	America/Winnipeg	3	R5G	1124001295
1012	Saint-Gédéon-de-Beauce	Saint-Gedeon-de-Beauce	QC	Quebec	45.85	-70.6333	2277	11.6	America/Montreal	4	G0M	1124765625
1013	Saint-Léonard-d'Aston	Saint-Leonard-d'Aston	QC	Quebec	46.1	-72.3667	2271	27.5	America/Montreal	3	J0C	1124836222
1014	Lunenburg	Lunenburg	NS	Nova Scotia	44.3833	-64.3167	2263	560.1	America/Halifax	3	B0J	1124214420
1015	Northesk	Northesk	NB	New Brunswick	47.2569	-66.2613	2263	0.7	America/Moncton	4	E1V E9E	1124000917
1016	Albanel	Albanel	QC	Quebec	48.8833	-72.45	2262	11.4	America/Montreal	3	G8M	1124386968
1017	St. Anthony	St. Anthony	NL	Newfoundland and Labrador	51.3725	-55.5947	2258	61	America/St_Johns	3	A0K	1124808047
1018	Pessamit	Pessamit	QC	Quebec	49.0485	-68.6814	2256	8.8	America/Montreal	4	G0H	1124000551
1019	Maskinongé	Maskinonge	QC	Quebec	46.2333	-73.0167	2253	30.2	America/Montreal	3	J0K	1124944084
1020	Saint-Charles-de-Bellechasse	Saint-Charles-de-Bellechasse	QC	Quebec	46.7667	-70.95	2246	24.1	America/Montreal	4	G0R	1124845287
1021	Fogo Island	Fogo Island	NL	Newfoundland and Labrador	49.6667	-54.1833	2244	9.4	America/St_Johns	3	A0G	1124001746
1022	East Broughton	East Broughton	QC	Quebec	46.2167	-71.0667	2229	255.3	America/Montreal	3	G0N	1124076092
1023	Lantz	Lantz	NS	Nova Scotia	44.9894	-63.4736	2229	749.9	America/Halifax	3	B2S	1124980158
1024	Calmar	Calmar	AB	Alberta	53.25	-113.7833	2228	476.2	America/Edmonton	3	T0C	1124941943
1025	Highlands	Highlands	BC	British Columbia	48.52	-123.5	2225	58.5	America/Vancouver	3	V9B V9E	1124001752
1026	Saint-Polycarpe	Saint-Polycarpe	QC	Quebec	45.3	-74.3	2224	31.8	America/Montreal	3	J0P	1124227112
1027	Logy Bay-Middle Cove-Outer Cove	Logy Bay-Middle Cove-Outer Cove	NL	Newfoundland and Labrador	47.63	-52.68	2221	130.9	America/St_Johns	3	A1K	1124001213
1028	Deschambault	Deschambault	QC	Quebec	46.6436	-72.0236	2220	17.8	America/Montreal	4	G0A	1124057933
1029	Canora	Canora	SK	Saskatchewan	51.6339	-102.4369	2219	303.7	America/Regina	3	S0A	1124454845
1030	Upper Miramichi	Upper Miramichi	NB	New Brunswick	46.5254	-66.2085	2218	1.2	America/Moncton	4	E9C E6A	1124001963
1031	Anmore	Anmore	BC	British Columbia	49.3144	-122.8564	2210	80.2	America/Vancouver	3	V3H	1124001000
1032	Hardwicke	Hardwicke	NB	New Brunswick	47.0208	-65.0302	2201	7.9	America/Moncton	4	E1N E9A	1124081011
1033	Saint-Côme	Saint-Come	QC	Quebec	46.27	-73.78	2198	13.5	America/Montreal	3	J0K	1124183187
1034	Waskaganish	Waskaganish	QC	Quebec	51.3674	-78.7069	2196	4.4	America/Montreal	4	J0M J0Y	1124626196
1035	Twillingate	Twillingate	NL	Newfoundland and Labrador	49.6444	-54.7436	2196	85.3	America/St_Johns	3	A0G	1124836835
1036	Saint-Quentin	Saint-Quentin	NB	New Brunswick	47.5135	-67.3921	2194	517.2	America/Moncton	3	E8A	1124243371
1037	Lebel-sur-Quévillon	Lebel-sur-Quevillon	QC	Quebec	49.05	-76.9833	2187	53.8	America/Montreal	3	J0Y	1124000875
1038	Pilot Butte	Pilot Butte	SK	Saskatchewan	50.4667	-104.4167	2183	377.7	America/Regina	3	S0G	1124343267
1039	Nanton	Nanton	AB	Alberta	50.3494	-113.7717	2181	447.8	America/Edmonton	3	T0L	1124418201
1040	Pierreville	Pierreville	QC	Quebec	46.0667	-72.8167	2176	27.8	America/Montreal	3	J0G	1124888889
1041	New-Wes-Valley	New-Wes-Valley	NL	Newfoundland and Labrador	49.15	-53.5833	2172	16.3	America/St_Johns	3	A0G	1124000397
1042	Pennfield Ridge	Pennfield Ridge	NB	New Brunswick	45.1924	-66.6858	2170	6	America/Moncton	4	E5H	1124474914
1043	West Interlake	West Interlake	MB	Manitoba	50.9837	-98.3572	2162	1.3	America/Winnipeg	4	R0C	1124001724
1044	Biggar	Biggar	SK	Saskatchewan	52.059	-107.979	2161	137.2	America/Regina	3	S0K	1124897904
1045	Britannia No. 502	Britannia No. 502	SK	Saskatchewan	53.4236	-109.7772	2153	2.3	America/Edmonton	4	S9V	1124000458
1046	Wabana	Wabana	NL	Newfoundland and Labrador	47.65	-52.9333	2146	148	America/St_Johns	3	A0A	1124180362
1047	Saint-Gilles	Saint-Gilles	QC	Quebec	46.5167	-71.3667	2138	12.1	America/Montreal	4	G0S	1124239919
1048	Wendake	Wendake	QC	Quebec	46.8693	-71.3628	2134	1253.9	America/Montreal	3	G0A	1124000757
1049	Saint-Bernard	Saint-Bernard	QC	Quebec	46.5	-71.1333	2131	23.7	America/Montreal	4	G0S	1124594239
1050	Sainte-Cécile-de-Milton	Sainte-Cecile-de-Milton	QC	Quebec	45.4833	-72.75	2128	29.1	America/Montreal	4	J0E	1124000630
1051	Saint-Roch-de-Richelieu	Saint-Roch-de-Richelieu	QC	Quebec	45.8833	-73.1667	2122	60.9	America/Montreal	4	J0L	1124796601
1052	Saint-Nazaire	Saint-Nazaire	QC	Quebec	48.5833	-71.5333	2114	14.6	America/Montreal	4	G0W	1124583281
1053	Saint-Elzéar	Saint-Elzear	QC	Quebec	46.4	-71.0667	2107	24.1	America/Montreal	4	G0S	1124069879
1054	Hinchinbrooke	Hinchinbrooke	QC	Quebec	45.05	-74.1	2103	14.1	America/Montreal	3	J0S	1124000812
1055	Saint-François-Xavier-de-Brompton	Saint-Francois-Xavier-de-Brompton	QC	Quebec	45.5333	-72.05	2101	21.5	America/Montreal	4	J0B	1124331796
1056	Papineauville	Papineauville	QC	Quebec	45.6167	-75.0167	2101	34.3	America/Montreal	3	J0V	1124866604
1057	Prairie View	Prairie View	MB	Manitoba	50.3304	-100.9803	2088	1.2	America/Winnipeg	4	R0J R0M	1124001412
1058	Cowichan Bay	Cowichan Bay	BC	British Columbia	48.7666	-123.6743	2086	89.5	America/Vancouver	4	V9L	1124254242
1059	Saint-Ignace-de-Loyola	Saint-Ignace-de-Loyola	QC	Quebec	46.0667	-73.1333	2086	57.7	America/Montreal	3	J0K	1124837640
1060	Central Manitoulin	Central Manitoulin	ON	Ontario	45.7167	-82.2	2084	4.8	America/Toronto	3	P0P	1124001582
1061	Maple Creek	Maple Creek	SK	Saskatchewan	49.9167	-109.4667	2084	471.3	America/Regina	3	S0N	1124706244
1062	Glovertown	Glovertown	NL	Newfoundland and Labrador	48.6667	-54.05	2083	29.6	America/St_Johns	3	A0G	1124282877
1063	Tofield	Tofield	AB	Alberta	53.3703	-112.6667	2081	253.4	America/Edmonton	3	T0B	1124392098
1064	Madoc	Madoc	ON	Ontario	44.5833	-77.5167	2078	7.9	America/Toronto	3	K0K	1124600331
1065	Upton	Upton	QC	Quebec	45.65	-72.6833	2075	37.3	America/Montreal	4	J0H	1124955599
1066	Sainte-Anne-de-Sabrevois	Sainte-Anne-de-Sabrevois	QC	Quebec	45.2	-73.2167	2074	46.3	America/Montreal	3	J0J	1124001436
1067	Logan Lake	Logan Lake	BC	British Columbia	50.4911	-120.8153	2073	6.4	America/Vancouver	3	V0K	1124000306
1068	Sainte-Anne-de-la-Pérade	Sainte-Anne-de-la-Perade	QC	Quebec	46.5833	-72.2	2072	18.8	America/Montreal	3	G0X	1124630006
1069	Saint-Damien-de-Buckland	Saint-Damien-de-Buckland	QC	Quebec	46.6333	-70.6667	2071	25.2	America/Montreal	4	G0R	1124710733
1070	Baker Lake	Baker Lake	NU	Nunavut	64.3287	-96.0308	2069	11.4	America/Rankin_Inlet	4	X0C	1124826935
1071	Saltair	Saltair	BC	British Columbia	48.9504	-123.7637	2069	305.1	America/Vancouver	3	V0R V9G	1124001512
1072	Pouch Cove	Pouch Cove	NL	Newfoundland and Labrador	47.767	-52.767	2069	35.5	America/St_Johns	3	A0A	1124198879
1073	Saint-Ferdinand	Saint-Ferdinand	QC	Quebec	46.1	-71.5667	2067	15.1	America/Montreal	3	G0N	1124190438
1074	Port McNeill	Port McNeill	BC	British Columbia	50.5903	-127.0847	2064	149.9	America/Vancouver	3	V0N	1124339378
1075	Digby	Digby	NS	Nova Scotia	44.6222	-65.7606	2060	654.6	America/Halifax	3	B0V	1124797865
1076	Manouane	Manouane	QC	Quebec	47.2091	-74.3833	2060	258.4	America/Montreal	3	J0K	1124764304
1077	Saint-Gervais	Saint-Gervais	QC	Quebec	46.7167	-70.8833	2058	23.1	America/Montreal	4	G0R	1124488792
1078	Neebing	Neebing	ON	Ontario	48.1833	-89.4667	2055	2.3	America/Toronto	3	P7L	1124000953
1079	Redwater	Redwater	AB	Alberta	53.9489	-113.1067	2053	102.5	America/Edmonton	3	T0A	1124001733
1080	Saint-Alexandre-de-Kamouraska	Saint-Alexandre-de-Kamouraska	QC	Quebec	47.6817	-69.625	2050	18.4	America/Montreal	4	G0L	1124090811
1081	Saint-Marc-sur-Richelieu	Saint-Marc-sur-Richelieu	QC	Quebec	45.6833	-73.2	2050	33.8	America/Montreal	4	J0L	1124009496
1082	Mandeville	Mandeville	QC	Quebec	46.3667	-73.35	2043	6.3	America/Montreal	3	J0K	1124912146
1083	Caplan	Caplan	QC	Quebec	48.1	-65.6833	2039	23.7	America/Montreal	3	G0C	1124049436
1084	Point Edward	Point Edward	ON	Ontario	42.9931	-82.4083	2037	620.6	America/Toronto	3	N7V N7T	1124647566
1085	Allardville	Allardville	NB	New Brunswick	47.4321	-65.4383	2032	3.1	America/Moncton	4	E8L	1124442131
1086	Waterville	Waterville	QC	Quebec	45.2667	-71.9	2028	45.7	America/Montreal	3	J0B	1124639721
1087	Saint-Damien	Saint-Damien	QC	Quebec	46.33	-73.48	2020	7.9	America/Montreal	3	J0K	1124745807
1088	Lac-Nominingue	Lac-Nominingue	QC	Quebec	46.4	-75.0333	2019	6.6	America/Montreal	3	J0W	1124245371
1089	Obedjiwan	Obedjiwan	QC	Quebec	48.6686	-74.9289	2019	234.4	America/Montreal	3	G0W	1124832696
1090	Rama	Rama	SK	Saskatchewan	51.7578	-103.0008	2016	3087.3	America/Regina	2	S0A	1124000936
1091	McCreary	McCreary	MB	Manitoba	50.7494	-99.485	2011	274.7	America/Winnipeg	3	R0J	1124852381
1092	Deloraine-Winchester	Deloraine-Winchester	MB	Manitoba	49.1775	-100.4322	2011	2	America/Winnipeg	4	R0M	1124000085
1093	Oakland-Wawanesa	Oakland-Wawanesa	MB	Manitoba	49.6208	-99.8481	2011	2.9	America/Winnipeg	4	R0K	1124000206
1094	Brenda-Waskada	Brenda-Waskada	MB	Manitoba	49.1775	-100.7019	2011	0.9	America/Winnipeg	4	R0M	1124000292
1095	Russell-Binscarth	Russell-Binscarth	MB	Manitoba	50.7272	-101.3689	2011	4.3	America/Winnipeg	4	R0J	1124000326
1096	Ellice-Archie	Ellice-Archie	MB	Manitoba	50.3239	-101.2729	2011	0.8	America/Winnipeg	4	R0M	1124000366
1097	Souris-Glenwood	Souris-Glenwood	MB	Manitoba	49.6208	-100.2581	2011	4.4	America/Winnipeg	4	R0K	1124000381
1098	Riverdale	Riverdale	MB	Manitoba	49.975	-100.2789	2011	3.7	America/Winnipeg	3	R0K	1124000402
1099	Pembina	Pembina	MB	Manitoba	49.1775	-98.5408	2011	2.1	America/Winnipeg	3	R0G	1124000460
1100	Wallace-Woodworth	Wallace-Woodworth	MB	Manitoba	49.9156	-100.9389	2011	1.5	America/Winnipeg	4	R0M	1124000533
1101	Lorne	Lorne	MB	Manitoba	49.4436	-98.7494	2011	3.3	America/Winnipeg	3	R0G R0K	1124000596
1102	Ethelbert	Ethelbert	MB	Manitoba	51.5364	-100.4981	2011	104.3	America/Winnipeg	4	R0L	1124793190
1103	Yellowhead	Yellowhead	MB	Manitoba	50.4847	-100.4828	2011	1.8	America/Winnipeg	4	R0J	1124000631
1104	Swan Valley West	Swan Valley West	MB	Manitoba	51.9978	-101.3944	2011	1.6	America/Winnipeg	3	R0L	1124000683
1105	Grey	Grey	MB	Manitoba	49.7094	-98.0736	2011	2.8	America/Winnipeg	4	R0G	1124000699
1106	Gilbert Plains	Gilbert Plains	MB	Manitoba	51.1547	-100.4381	2011	1.4	America/Winnipeg	4	R0L	1124524030
1107	Norfolk-Treherne	Norfolk-Treherne	MB	Manitoba	49.6653	-98.5967	2011	2.4	America/Winnipeg	4	R0G	1124000889
1108	Hamiota	Hamiota	MB	Manitoba	50.1964	-100.6342	2011	248.3	America/Winnipeg	3	R0M	1124139264
1109	Emerson-Franklin	Emerson-Franklin	MB	Manitoba	49.1333	-97.0331	2011	2.6	America/Winnipeg	3	R0A	1124000940
1110	Sifton	Sifton	MB	Manitoba	49.6653	-100.6678	2011	2.6	America/Winnipeg	3	R0M	1124001004
1111	Rossburn	Rossburn	MB	Manitoba	50.7272	-100.7408	2011	150.4	America/Winnipeg	4	R0J	1124628261
1112	Grand View	Grand View	MB	Manitoba	51.155	-100.7892	2011	310.3	America/Winnipeg	3	R0L	1124791401
1113	Grassland	Grassland	MB	Manitoba	49.4306	-100.3103	2011	1.2	America/Winnipeg	4	R0K R0M	1124001149
1114	Louise	Louise	MB	Manitoba	49.1772	-98.8794	2011	2	America/Winnipeg	4	R0G R0K	1124001192
1115	Ste. Rose	Ste. Rose	MB	Manitoba	51.0222	-99.4306	2011	2.7	America/Winnipeg	4	R0J R0L	1124001220
1116	Cartwright-Roblin	Cartwright-Roblin	MB	Manitoba	49.1331	-99.2797	2011	1.8	America/Winnipeg	3	R0K	1124001248
1117	Mossey River	Mossey River	MB	Manitoba	51.755	-99.9664	2011	1	America/Winnipeg	4	R0L	1124001378
1118	Riding Mountain West	Riding Mountain West	MB	Manitoba	50.8347	-101.0961	2011	0.9	America/Winnipeg	3	R0J	1124001496
1119	Clanwilliam-Erickson	Clanwilliam-Erickson	MB	Manitoba	50.5061	-99.8156	2011	2.5	America/Winnipeg	4	R0J	1124001796
1120	Glenboro-South Cypress	Glenboro-South Cypress	MB	Manitoba	49.665	-99.3708	2011	1.4	America/Winnipeg	4	R0K	1124001832
1121	North Norfolk	North Norfolk	MB	Manitoba	49.9308	-98.8356	2011	3.3	America/Winnipeg	4	R0H	1124001856
1122	Reinland	Reinland	MB	Manitoba	49.1331	-97.5942	2011	6.2	America/Winnipeg	3	R0G	1124389945
1123	Minitonas-Bowsman	Minitonas-Bowsman	MB	Manitoba	52.1433	-100.9772	2011	1.4	America/Winnipeg	4	R0L	1124001902
1124	Kippens	Kippens	NL	Newfoundland and Labrador	48.5492	-58.6236	2008	140.3	America/St_Johns	3	A2N	1124001147
1125	Blucher	Blucher	SK	Saskatchewan	52.0134	-106.2176	2006	2.5	America/Regina	4	S0K	1124237296
1126	Hatley	Hatley	QC	Quebec	45.27	-71.95	2003	28	America/Montreal	4	J0B	1124001440
1127	Saint-Gédéon	Saint-Gedeon	QC	Quebec	48.5	-71.7667	2001	31.5	America/Montreal	3	G0W	1124458135
1128	Kingsey Falls	Kingsey Falls	QC	Quebec	45.85	-72.0667	2000	28.7	America/Montreal	3	J0A	1124274388
1129	Provost	Provost	AB	Alberta	52.3539	-110.2686	1998	423	America/Edmonton	3	T0B	1124659213
1130	Saint-Charles	Saint-Charles	NB	New Brunswick	46.6692	-65.0184	1997	11.4	America/Moncton	4	E4W	1124000730
1131	Mattawa	Mattawa	ON	Ontario	46.3167	-78.7	1993	544.8	America/Montreal	3	P0H	1124041230
1132	Tumbler Ridge	Tumbler Ridge	BC	British Columbia	55.1333	-121	1987	1.3	America/Dawson_Creek	3	V0C	1124001642
1133	Terrasse-Vaudreuil	Terrasse-Vaudreuil	QC	Quebec	45.4	-73.9833	1986	1865.2	America/Montreal	3	J7V	1124001658
1134	L'Ascension-de-Notre-Seigneur	L'Ascension-de-Notre-Seigneur	QC	Quebec	48.7	-71.6833	1983	15	America/Montreal	4	G0W	1124000873
1135	Bow Island	Bow Island	AB	Alberta	49.8667	-111.3667	1983	341.6	America/Edmonton	3	T0K	1124002843
1136	Barraute	Barraute	QC	Quebec	48.4333	-77.6333	1980	4	America/Montreal	3	J0Y	1124495319
1137	One Hundred Mile House	One Hundred Mile House	BC	British Columbia	51.6413	-121.3127	1980	37.2	America/Vancouver	4	V0K	1124920746
1138	Kedgwick	Kedgwick	NB	New Brunswick	47.6456	-67.3431	1979	3	America/Moncton	3	E8B	1124759374
1139	Gambo	Gambo	NL	Newfoundland and Labrador	48.7833	-54.2167	1978	21.5	America/St_Johns	3	A0G	1124499854
1140	Saint-Liguori	Saint-Liguori	QC	Quebec	46.0167	-73.5667	1976	39.1	America/Montreal	4	J0K	1124672824
1141	Bonfield	Bonfield	ON	Ontario	46.2167	-79.1333	1975	9.5	America/Toronto	3	P0H	1124001075
1142	Pointe-Lebel	Pointe-Lebel	QC	Quebec	49.1667	-68.2	1973	23.3	America/Montreal	4	G0H	1124216164
1143	Saint Mary	Saint Mary	NB	New Brunswick	46.3987	-64.8681	1972	8.3	America/Moncton	4	E4S	1124001508
1144	Saint-Patrice-de-Sherrington	Saint-Patrice-de-Sherrington	QC	Quebec	45.1667	-73.5167	1971	21.3	America/Montreal	3	J0L	1124878423
1145	Fox Creek	Fox Creek	AB	Alberta	54.395	-116.8092	1971	159.4	America/Edmonton	3	T0H	1124001709
1146	Dawn-Euphemia	Dawn-Euphemia	ON	Ontario	42.7	-82.0167	1967	4.4	America/Toronto	3	N0P	1124000898
1147	Chapleau	Chapleau	ON	Ontario	47.8333	-83.4	1964	138.2	America/Toronto	3	P0M	1124518288
1148	Saint-Esprit	Saint-Esprit	QC	Quebec	45.9	-73.6667	1963	36.4	America/Montreal	3	J0K	1124001003
1149	Westfield Beach	Westfield Beach	NB	New Brunswick	45.3432	-66.2868	1962	6.6	America/Moncton	4	E5K E5S	1124204415
1150	Mashteuiatsh	Mashteuiatsh	QC	Quebec	48.569	-72.2495	1957	134.9	America/Montreal	4	G0W	1124000997
1151	Saint-François-du-Lac	Saint-Francois-du-Lac	QC	Quebec	46.0667	-72.8333	1957	30.4	America/Montreal	3	J0G	1124010410
1152	Eel River Crossing	Eel River Crossing	NB	New Brunswick	48.0125	-66.4208	1953	29.8	America/Moncton	3	E8E	1124000490
1153	Saint-Fulgence	Saint-Fulgence	QC	Quebec	48.45	-70.9	1949	5.5	America/Montreal	4	G0V	1124969917
1154	Millet	Millet	AB	Alberta	53.0978	-113.4728	1945	522.9	America/Edmonton	3	T0C	1124327149
1155	Vallée-Jonction	Vallee-Jonction	QC	Quebec	46.3667	-70.9167	1940	76.6	America/Montreal	4	G0S	1124672986
1156	Saint-Georges-de-Cacouna	Saint-Georges-de-Cacouna	QC	Quebec	47.9167	-69.5	1939	30.6	America/Montreal	3	G0L	1124882699
1157	Lumsden No. 189	Lumsden No. 189	SK	Saskatchewan	50.6734	-104.7686	1938	2.4	America/Regina	4	S0G	1124001061
1158	Manitouwadge	Manitouwadge	ON	Ontario	49.1333	-85.8333	1937	5.5	America/Toronto	3	P0T	1124548320
1159	Swift Current No. 137	Swift Current No. 137	SK	Saskatchewan	50.2211	-107.8559	1932	1.8	America/Regina	4	S0N S9H	1124000742
1160	Tofino	Tofino	BC	British Columbia	49.1275	-125.8852	1932	183.1	America/Vancouver	4	V0R	1124140302
1161	Fort Qu’Appelle	Fort Qu'Appelle	SK	Saskatchewan	50.7667	-103.7833	1919	363.2	America/Regina	3	S0G	1124904751
1162	Vulcan	Vulcan	AB	Alberta	50.4	-113.25	1917	302.3	America/Edmonton	3	T0L	1124607765
1163	Indian Head	Indian Head	SK	Saskatchewan	50.5333	-103.6667	1910	602	America/Regina	3	S0G	1124084038
1164	Petit Rocher	Petit Rocher	NB	New Brunswick	47.7839	-65.7159	1908	425.2	America/Moncton	3	E8J	1124808094
1165	Wabush	Wabush	NL	Newfoundland and Labrador	52.9081	-66.869	1906	41.2	America/Goose_Bay	3	A0R	1124012604
1166	Saint-Fabien	Saint-Fabien	QC	Quebec	48.3	-68.87	1906	15.9	America/Montreal	4	G0L	1124462554
1167	Watrous	Watrous	SK	Saskatchewan	51.6841	-105.4661	1900	170.1	America/Regina	4	S0K	1124468381
1168	North Frontenac	North Frontenac	ON	Ontario	44.95	-76.9	1898	1.6	America/Toronto	3	K0H	1124000803
1169	Lac-Supérieur	Lac-Superieur	QC	Quebec	46.2	-74.4667	1892	5.1	America/Montreal	3	J0T	1124000862
1170	Les Escoumins	Les Escoumins	QC	Quebec	48.35	-69.4	1891	7	America/Montreal	3	G0T	1124123618
1171	Richibucto	Richibucto	NB	New Brunswick	46.6189	-64.8385	1887	7.6	America/Moncton	4	E4W	1124000569
1172	Rivière-Beaudette	Riviere-Beaudette	QC	Quebec	45.2333	-74.3333	1885	101.9	America/Montreal	3	J0P	1124687157
1173	Saint-Barthélemy	Saint-Barthelemy	QC	Quebec	46.1833	-73.1333	1883	17.9	America/Montreal	4	J0K	1124598418
1174	Nisga'a	Nisga'a	BC	British Columbia	55.1078	-129.4293	1880	0.9	America/Vancouver	4	V0J	1124000744
1175	Austin	Austin	QC	Quebec	45.1833	-72.2833	1880	25.5	America/Montreal	3	J0B	1124000885
1176	Saint-Mathieu	Saint-Mathieu	QC	Quebec	45.3167	-73.5164	1879	59.5	America/Montreal	3	J0L	1124978563
1177	Saint-Paul-de-l'Île-aux-Noix	Saint-Paul-de-l'Ile-aux-Noix	QC	Quebec	45.1333	-73.2833	1877	63.4	America/Montreal	3	J0J	1124000680
1178	Orkney No. 244	Orkney No. 244	SK	Saskatchewan	51.2557	-102.6469	1875	2.3	America/Regina	4	S3N	1124000139
1179	Behchokò	Behchoko	NT	Northwest Territories	62.8184	-115.9933	1874	24.9	America/Yellowknife	4	X0E	1124001992
1180	Saint-Joseph-de-Coleraine	Saint-Joseph-de-Coleraine	QC	Quebec	45.97	-71.37	1870	14.7	America/Montreal	4	G0N	1124000088
1181	Saint-Cyprien-de-Napierville	Saint-Cyprien-de-Napierville	QC	Quebec	45.1833	-73.4167	1869	19.2	America/Montreal	3	J0J	1124000843
1182	Sayabec	Sayabec	QC	Quebec	48.5667	-67.6833	1864	14.3	America/Montreal	3	G0J	1124175872
1183	Valleyview	Valleyview	AB	Alberta	55.0686	-117.2683	1863	199.9	America/Edmonton	3	T0H	1124211786
1184	Déléage	Deleage	QC	Quebec	46.3833	-75.9167	1856	7.5	America/Montreal	4	J9E	1124001615
1185	Potton	Potton	QC	Quebec	45.0833	-72.3667	1849	7.1	America/Montreal	3	J0E	1124000571
1186	Sainte-Béatrix	Sainte-Beatrix	QC	Quebec	46.2	-73.6167	1849	22	America/Montreal	3	J0K	1124233714
1187	Sainte-Justine	Sainte-Justine	QC	Quebec	46.4	-70.35	1845	14.6	America/Montreal	3	G0R	1124340970
1188	Eastman	Eastman	QC	Quebec	45.3341	-72.3041	1843	25	America/Montreal	4	J0E	1124001358
1189	Saint-Valérien-de-Milton	Saint-Valerien-de-Milton	QC	Quebec	45.5667	-72.7167	1840	17.1	America/Montreal	3	J0H	1124253518
1190	Saint-Cuthbert	Saint-Cuthbert	QC	Quebec	46.15	-73.2333	1839	13.9	America/Montreal	3	J0K	1124546028
1191	Saint-Blaise-sur-Richelieu	Saint-Blaise-sur-Richelieu	QC	Quebec	45.2167	-73.2833	1837	26.3	America/Montreal	3	J0J	1124693015
1192	Middleton	Middleton	NS	Nova Scotia	44.9418	-65.0686	1832	329.1	America/Halifax	3	B0S	1124792393
1193	Maugerville	Maugerville	NB	New Brunswick	46.1301	-66.2859	1831	2	America/Moncton	4	E3A	1124001594
1194	Dalmeny	Dalmeny	SK	Saskatchewan	52.3411	-106.7733	1826	805.7	America/Regina	3	S0K	1124962648
1195	Kamsack	Kamsack	SK	Saskatchewan	51.565	-101.8947	1825	311.8	America/Regina	3	S0A	1124566093
1196	Lumsden	Lumsden	SK	Saskatchewan	50.6463	-104.8676	1824	402	America/Regina	3	S0G	1124301488
1197	Trinity Bay North	Trinity Bay North	NL	Newfoundland and Labrador	48.4978	-53.086	1819	71.5	America/St_Johns	4	A0C	1124001498
1198	Saint-Michel-de-Bellechasse	Saint-Michel-de-Bellechasse	QC	Quebec	46.8667	-70.9167	1816	41	America/Montreal	3	G0R	1124972269
1199	Sainte-Angèle-de-Monnoir	Sainte-Angele-de-Monnoir	QC	Quebec	45.3833	-73.1	1812	39.9	America/Montreal	3	J0L	1124001386
1200	Picture Butte	Picture Butte	AB	Alberta	49.8731	-112.78	1810	635.1	America/Edmonton	3	T0K	1124001015
1201	Sacré-Coeur-Saguenay	Sacre-Coeur-Saguenay	QC	Quebec	48.2479	-69.854	1803	5.9	America/Montreal	4	G0T	1124365978
1202	Saint-Louis	Saint-Louis	NB	New Brunswick	46.7048	-65.1046	1802	7	America/Moncton	4	E4X	1124001801
1203	Saint-Robert	Saint-Robert	QC	Quebec	45.9667	-73	1794	27.7	America/Montreal	3	J0G	1124000874
1204	Saint-Pierre-de-l'Île-d'Orléans	Saint-Pierre-de-l'Ile-d'Orleans	QC	Quebec	46.8833	-71.0667	1789	57.1	America/Montreal	3	G0A	1124000266
1205	La Guadeloupe	La Guadeloupe	QC	Quebec	45.95	-70.93	1787	54.8	America/Montreal	3	G0M	1124124557
1206	Saint Andrews	Saint Andrews	NB	New Brunswick	45.074	-67.0521	1786	213.9	America/Moncton	3	E5B	1124559218
1207	Burns Lake	Burns Lake	BC	British Columbia	54.2292	-125.7625	1779	269.8	America/Vancouver	3	V0J	1124512812
1208	Povungnituk	Povungnituk	QC	Quebec	60.0477	-77.2751	1779	20.6	America/Montreal	4	J0M	1124176799
1209	Manners Sutton	Manners Sutton	NB	New Brunswick	45.6417	-67.0609	1777	3.4	America/Moncton	4	E6K	1124811576
1210	Gore	Gore	QC	Quebec	45.77	-74.25	1775	19.1	America/Montreal	3	J0V	1124000246
1211	Deseronto	Deseronto	ON	Ontario	44.2	-77.05	1774	705.7	America/Toronto	3	K0K	1124824752
1212	Lamont	Lamont	AB	Alberta	53.7603	-112.7778	1774	192.8	America/Edmonton	3	T0B	1124567192
1213	Chambord	Chambord	QC	Quebec	48.4333	-72.0667	1773	14.6	America/Montreal	3	G0W	1124404193
1214	Dudswell	Dudswell	QC	Quebec	45.5833	-71.5833	1771	8.1	America/Montreal	3	J0B	1124209090
1215	Wynyard	Wynyard	SK	Saskatchewan	51.7667	-104.1833	1767	334.1	America/Regina	3	S0A	1124699826
1216	Cambridge Bay	Cambridge Bay	NU	Nunavut	69.1528	-105.1707	1766	8.7	America/Cambridge_Bay	4	X0B	1124596377
1217	Saint-Narcisse	Saint-Narcisse	QC	Quebec	46.5667	-72.4667	1762	16.8	America/Montreal	3	G0X	1124808791
1218	Frontenac Islands	Frontenac Islands	ON	Ontario	44.2	-76.3833	1760	10.1	America/Toronto	3	K7G K0H	1124000098
1219	Waswanipi	Waswanipi	QC	Quebec	49.7883	-75.9544	1759	4.2	America/Montreal	4	J0Y	1124000056
1220	Inukjuak	Inukjuak	QC	Quebec	58.4824	-78.1309	1757	31.6	America/Montreal	4	J0M	1124369757
1221	Piney	Piney	MB	Manitoba	49.2069	-95.8333	1755	0	America/Winnipeg	3	R0A	1124958787
1222	Komoka	Komoka	ON	Ontario	42.958	-81.4001	1754	1576.6	America/Toronto	3	N0L	1124109518
1223	Saint-Zacharie	Saint-Zacharie	QC	Quebec	46.1333	-70.3667	1751	9.4	America/Montreal	4	G0M	1124927704
1224	Hemmingford	Hemmingford	QC	Quebec	45.0833	-73.5833	1747	11.1	America/Montreal	3	J0L	1124000648
1225	Saint-Clet	Saint-Clet	QC	Quebec	45.35	-74.22	1738	44.3	America/Montreal	3	J0P	1124001293
1226	Carberry	Carberry	MB	Manitoba	49.8689	-99.3594	1738	350.7	America/Winnipeg	3	R0K	1124314305
1227	Saint-Antoine	Saint-Antoine	NB	New Brunswick	46.3629	-64.753	1733	274.3	America/Moncton	3	E4V	1124873921
1228	Warfield	Warfield	BC	British Columbia	49.0953	-117.7344	1729	910	America/Vancouver	3	V1R	1124000473
1229	Northampton	Northampton	NB	New Brunswick	46.1313	-67.4713	1724	7.1	America/Moncton	4	E7N	1124001603
1230	Saint-Ours	Saint-Ours	QC	Quebec	45.8833	-73.15	1721	29	America/Montreal	3	J0G	1124177651
1231	Stephenville Crossing	Stephenville Crossing	NL	Newfoundland and Labrador	48.5167	-58.4167	1719	55.1	America/St_Johns	3	A0N	1124113007
1232	Sainte-Anne-de-la-Pocatière	Sainte-Anne-de-la-Pocatiere	QC	Quebec	47.35	-70	1717	31.1	America/Montreal	3	G0R	1124000130
1233	Ucluelet	Ucluelet	BC	British Columbia	48.9358	-125.5433	1717	264.5	America/Vancouver	3	V0R	1124290800
1234	Saint-Placide	Saint-Placide	QC	Quebec	45.5333	-74.2	1715	39.8	America/Montreal	3	J0V	1124722091
1235	Barrière	Barriere	BC	British Columbia	51.1803	-120.1261	1713	164.7	America/Vancouver	3	V0E	1124124556
1236	Fisher	Fisher	MB	Manitoba	51.0825	-97.6611	1708	1.2	America/Winnipeg	4	R0C	1124001091
1237	Nipissing	Nipissing	ON	Ontario	46.05	-79.55	1707	4.3	America/Toronto	3	P0H	1124001066
1238	Sainte-Clotilde	Sainte-Clotilde	QC	Quebec	45.15	-73.6833	1704	21.6	America/Montreal	3	J0L	1124121082
1239	Shaunavon	Shaunavon	SK	Saskatchewan	49.651	-108.412	1699	344.2	America/Regina	3	S0N	1124484836
1240	Wicklow	Wicklow	NB	New Brunswick	46.5017	-67.7067	1697	8.7	America/Moncton	4	E7K E7L	1124000344
1241	Southesk	Southesk	NB	New Brunswick	46.9901	-66.4336	1694	0.7	America/Moncton	4	E9E	1124001519
1242	Nouvelle	Nouvelle	QC	Quebec	48.1333	-66.3167	1689	7.3	America/Montreal	3	G0C	1124064051
1243	Rosthern	Rosthern	SK	Saskatchewan	52.65	-106.3333	1688	392	America/Regina	3	S0K	1124886826
1244	Yamaska	Yamaska	QC	Quebec	46.0236	-72.9391	1687	23.2	America/Montreal	4	J0G	1124001651
1245	Neguac	Neguac	NB	New Brunswick	47.2333	-65.05	1684	62.9	America/Moncton	3	E9G	1124936735
1246	Flat Rock	Flat Rock	NL	Newfoundland and Labrador	47.7086	-52.7144	1683	92.9	America/St_Johns	3	A1K	1124195076
1247	Igloolik	Igloolik	NU	Nunavut	69.3817	-81.6811	1682	16.3	America/Iqaluit	4	X0A	1124253277
1248	Grunthal	Grunthal	MB	Manitoba	49.4065	-96.8603	1680	593.7	America/Winnipeg	3	R0A	1124001008
1249	Naramata	Naramata	BC	British Columbia	49.5886	-119.5838	1676	207.8	America/Vancouver	3	V0H	1124000620
1250	Saint-Élie-de-Caxton	Saint-Elie-de-Caxton	QC	Quebec	46.4833	-72.9667	1676	14.2	America/Montreal	3	G0X	1124000951
1251	Blumenort	Blumenort	MB	Manitoba	49.6033	-96.7006	1675	526.3	America/Winnipeg	3	R0A	1124001566
1252	Balmoral	Balmoral	NB	New Brunswick	47.9667	-66.45	1674	38.6	America/Moncton	3	E8E	1124774000
1253	Price	Price	QC	Quebec	48.6017	-68.1227	1673	646	America/Montreal	3	G0J	1124592512
1254	Rosedale	Rosedale	MB	Manitoba	50.4397	-99.5389	1672	1.9	America/Winnipeg	4	R0J	1124000230
1255	Saint-Jacques-le-Mineur	Saint-Jacques-le-Mineur	QC	Quebec	45.2833	-73.4167	1672	24.9	America/Montreal	3	J0J	1124000320
1256	Huron Shores	Huron Shores	ON	Ontario	46.2833	-83.2	1664	3.8	America/Toronto	3	P0R	1124000756
1257	Whitehead	Whitehead	MB	Manitoba	49.7981	-100.2575	1661	2.9	America/Winnipeg	4	R7A R0K	1124001853
1258	Saint-Antoine-sur-Richelieu	Saint-Antoine-sur-Richelieu	QC	Quebec	45.7833	-73.1833	1659	25.2	America/Montreal	4	J0L	1124151577
1259	Saint-Pacôme	Saint-Pacome	QC	Quebec	47.4	-69.95	1658	57.5	America/Montreal	4	G0L	1124275513
1260	Saint-Stanislas-de-Kostka	Saint-Stanislas-de-Kostka	QC	Quebec	45.18	-74.13	1654	28.7	America/Montreal	3	J0S	1124267249
1261	Frontenac	Frontenac	QC	Quebec	45.58	-70.83	1650	7.4	America/Montreal	4	G6B	1124001833
1262	Stuartburn	Stuartburn	MB	Manitoba	49.1331	-96.5158	1648	1.4	America/Winnipeg	3	R0A	1124000992
1263	Yamaska-Est	Yamaska-Est	QC	Quebec	46	-72.92	1644	22.5	America/Montreal	3	J0G	1124187626
1264	Sainte-Émélie-de-l'Énergie	Sainte-Emelie-de-l'Energie	QC	Quebec	46.3167	-73.65	1644	10.7	America/Montreal	3	J0K	1124367776
1265	Saint-Charles-sur-Richelieu	Saint-Charles-sur-Richelieu	QC	Quebec	45.6833	-73.1833	1643	25.2	America/Montreal	3	J0H	1124477144
1266	Saint-Joseph-de-Sorel	Saint-Joseph-de-Sorel	QC	Quebec	46.0446	-73.1308	1642	1192.7	America/Montreal	3	J3R	1124557970
1267	Nipigon	Nipigon	ON	Ontario	49.0153	-88.2683	1642	15	America/Nipigon	3	P0T	1124361489
1268	Rivière-Blanche	Riviere-Blanche	QC	Quebec	48.7833	-67.7	1642	13.6	America/Montreal	3	G0J	1124696529
1269	Sainte-Hélène-de-Bagot	Sainte-Helene-de-Bagot	QC	Quebec	45.7333	-72.7333	1637	22.3	America/Montreal	3	J0H	1124837882
1270	Franklin Centre	Franklin Centre	QC	Quebec	45.0467	-73.9005	1636	14.5	America/Montreal	4	J0S	1124556676
1271	Harbour Breton	Harbour Breton	NL	Newfoundland and Labrador	47.4833	-55.8333	1634	118.9	America/St_Johns	3	A0H	1124833379
1272	Massey Drive	Massey Drive	NL	Newfoundland and Labrador	48.9372	-57.9	1632	658.7	America/St_Johns	3	A2H	1124000923
1273	Mille-Isles	Mille-Isles	QC	Quebec	45.82	-74.22	1629	26.8	America/Montreal	3	J0R	1124001094
1274	Wilton No. 472	Wilton No. 472	SK	Saskatchewan	53.124	-109.7885	1629	1.6	America/Edmonton	4	S0M S9V	1124001208
1275	Lyster	Lyster	QC	Quebec	46.3667	-71.6167	1628	9.7	America/Montreal	4	G0S	1124296106
1276	Oakview	Oakview	MB	Manitoba	50.1964	-100.2167	1626	1.4	America/Winnipeg	4	R0K	1124000384
1277	Balgonie	Balgonie	SK	Saskatchewan	50.488	-104.269	1625	515.8	America/Regina	3	S0G	1124001148
1278	Harrison Park	Harrison Park	MB	Manitoba	50.5563	-100.1674	1622	1.7	America/Winnipeg	4	R0J	1124000697
1279	Kensington	Kensington	PE	Prince Edward Island	46.4333	-63.65	1619	537.9	America/Halifax	3	C0B	1124918690
1280	Witless Bay	Witless Bay	NL	Newfoundland and Labrador	47.28	-52.83	1619	92.6	America/St_Johns	3	A0A	1124037826
1281	Pond Inlet	Pond Inlet	NU	Nunavut	72.6808	-77.7503	1617	9.3	America/Iqaluit	4	X0A	1124788973
1282	Royston	Royston	BC	British Columbia	49.6405	-124.9406	1616	361.3	America/Vancouver	3	V0R V9N	1124000692
1283	Sainte-Clotilde-de-Horton	Sainte-Clotilde-de-Horton	QC	Quebec	45.9833	-72.2333	1616	14.2	America/Montreal	4	J0A	1124416351
1284	Burford	Burford	ON	Ontario	43.1036	-80.424	1615	208.2	America/Toronto	3	N0E	1124578509
1285	Fossambault-sur-le-Lac	Fossambault-sur-le-Lac	QC	Quebec	46.8667	-71.6167	1613	141.7	America/Montreal	3	G3N	1124001825
1286	Saint-Benoît-Labre	Saint-Benoit-Labre	QC	Quebec	46.0667	-70.8	1612	19	America/Montreal	4	G0M	1124381557
1287	Coombs	Coombs	BC	British Columbia	49.3008	-124.4049	1612	102.8	America/Vancouver	4	V0R	1124001663
1288	Terrace Bay	Terrace Bay	ON	Ontario	48.8	-87.1	1611	10.5	America/Toronto	3	P0T	1124634789
1289	Chapais	Chapais	QC	Quebec	49.7819	-74.8544	1610	25.3	America/Montreal	3	G0W	1124629095
1290	Saint-Honoré-de-Shenley	Saint-Honore-de-Shenley	QC	Quebec	45.9667	-70.8333	1610	12.1	America/Montreal	4	G0M	1124007745
1291	Cleveland	Cleveland	QC	Quebec	45.67	-72.08	1609	12.9	America/Montreal	4	J0B	1124001081
1292	Macdonald, Meredith and Aberdeen Additional	Macdonald, Meredith and Aberdeen Additional	ON	Ontario	46.4833	-84.0667	1609	9.8	America/Toronto	3	P0S	1124001485
1293	Messines	Messines	QC	Quebec	46.2333	-76.0167	1608	14.1	America/Montreal	3	J0X	1124295094
1294	Saint-Jean-de-Dieu	Saint-Jean-de-Dieu	QC	Quebec	48	-69.05	1606	10.6	America/Montreal	4	G0L	1124739032
1295	Nakusp	Nakusp	BC	British Columbia	50.2434	-117.8002	1605	195.2	America/Vancouver	3	V0G	1124310238
1296	Florenceville	Florenceville	NB	New Brunswick	46.4435	-67.6152	1604	102.7	America/Moncton	3	E7L	1124518996
1297	Saint-Antoine-de-Tilly	Saint-Antoine-de-Tilly	QC	Quebec	46.6667	-71.5833	1604	26.6	America/Montreal	4	G0S	1124590960
1298	Lakeview	Lakeview	BC	British Columbia	49.9026	-119.5699	1600	63.5	America/Vancouver	4	V1Z V4T	1124001451
1299	Humbermouth	Humbermouth	NL	Newfoundland and Labrador	49.0156	-58.1678	1599	24.6	America/St_Johns	4	A0L	1124416255
1300	Fort St. James	Fort St. James	BC	British Columbia	54.4431	-124.2542	1598	72	America/Vancouver	3	V0J	1124865218
1301	Saint-François-de-la-Rivière-du-Sud	Saint-Francois-de-la-Riviere-du-Sud	QC	Quebec	46.8833	-70.7167	1596	17	America/Montreal	4	G0R	1124001406
1302	Uashat	Uashat	QC	Quebec	50.233	-66.3947	1592	681.8	America/Montreal	3	G4S G4R	1124001483
1303	Eeyou Istchee Baie-James	Eeyou Istchee Baie-James	QC	Quebec	52.3382	-75.1977	1589	0	America/Montreal	4	J0Y	1124001722
1304	Shellbrook No. 493	Shellbrook No. 493	SK	Saskatchewan	53.3545	-106.2553	1587	1.3	America/Regina	4	S0J	1124000896
1305	Shawville	Shawville	QC	Quebec	45.6	-76.4833	1587	294.5	America/Montreal	3	J0X	1124868099
1306	Saint-Lucien	Saint-Lucien	QC	Quebec	45.8667	-72.2667	1584	14.2	America/Montreal	4	J0C	1124000172
1307	Lambton	Lambton	QC	Quebec	45.83	-71.08	1584	14.6	America/Montreal	4	G0M	1124236153
1308	Saint-Laurent-de-l'Île-d'Orléans	Saint-Laurent-de-l'Ile-d'Orleans	QC	Quebec	46.8667	-71.0167	1580	44.2	America/Montreal	3	G0A	1124000659
1309	Saint-Flavien	Saint-Flavien	QC	Quebec	46.5167	-71.6	1578	23.4	America/Montreal	4	G0S	1124326824
1310	Grenville	Grenville	QC	Quebec	45.6333	-74.6	1577	560.4	America/Montreal	3	J0V	1124831011
1311	Chute-aux-Outardes	Chute-aux-Outardes	QC	Quebec	49.1167	-68.4	1577	216	America/Montreal	3	G0H	1124968977
1312	Sainte-Marcelline-de-Kildare	Sainte-Marcelline-de-Kildare	QC	Quebec	46.1167	-73.6	1567	45.2	America/Montreal	4	J0K	1124028672
1313	Saint-Félix-de-Kingsey	Saint-Felix-de-Kingsey	QC	Quebec	45.8	-72.1833	1563	12.3	America/Montreal	3	J0B	1124052771
1314	Upper Island Cove	Upper Island Cove	NL	Newfoundland and Labrador	47.6472	-53.2233	1561	199	America/St_Johns	3	A0A	1124254175
1315	Glenelg	Glenelg	NB	New Brunswick	46.9455	-65.2893	1560	3.1	America/Moncton	4	E1N	1124001212
1316	Sainte-Élisabeth	Sainte-Elisabeth	QC	Quebec	46.0833	-73.35	1559	18.8	America/Montreal	4	J0K	1124368135
1317	Ashcroft	Ashcroft	BC	British Columbia	50.7256	-121.2806	1558	32.3	America/Vancouver	3	V0K	1124521001
1318	Clarkes Beach	Clarkes Beach	NL	Newfoundland and Labrador	47.5447	-53.2824	1558	122.6	America/St_Johns	4	A0A	1124886112
1319	Saint-Bernard-de-Lacolle	Saint-Bernard-de-Lacolle	QC	Quebec	45.0833	-73.4167	1549	13	America/Montreal	3	J0J	1124000541
1320	Belledune	Belledune	NB	New Brunswick	47.9	-65.8167	1548	8.2	America/Moncton	3	E8G	1124444357
1321	Saint-Guillaume	Saint-Guillaume	QC	Quebec	45.8833	-72.7667	1547	17.6	America/Montreal	4	J0C	1124732782
1322	Venise-en-Québec	Venise-en-Quebec	QC	Quebec	45.0833	-73.1333	1547	116.9	America/Montreal	3	J0J	1124001019
1323	Maliotenam	Maliotenam	QC	Quebec	50.2114	-66.1911	1542	288.7	America/Montreal	3	G4R	1124000333
1324	Ripon	Ripon	QC	Quebec	45.7833	-75.1	1542	11.7	America/Montreal	4	J0V	1124368199
1325	Hilliers	Hilliers	BC	British Columbia	49.3022	-124.4727	1540	53	America/Vancouver	4	V0R V9K	1124744995
1326	Saint-Joseph	Saint-Joseph	NB	New Brunswick	47.558	-68.3082	1538	4.8	America/Moncton	4	E7B	1124001284
1327	Saint-Paulin	Saint-Paulin	QC	Quebec	46.4167	-73.0333	1534	16	America/Montreal	4	J0K	1124571978
1328	Bon Accord	Bon Accord	AB	Alberta	53.8328	-113.4189	1529	718.7	America/Edmonton	3	T0A	1124764880
1329	Saint David	Saint David	NB	New Brunswick	45.2918	-67.1983	1529	8	America/Moncton	4	E5A E3L	1124001550
1330	Saint-Albert	Saint-Albert	QC	Quebec	46	-72.0833	1526	21.8	America/Montreal	4	J0A	1124484773
1331	Matagami	Matagami	QC	Quebec	49.75	-77.6333	1526	22.8	America/Montreal	3	J0Y	1124686252
1332	Notre-Dame-du-Laus	Notre-Dame-du-Laus	QC	Quebec	46.0833	-75.6167	1518	1.8	America/Montreal	3	J0X	1124131832
1333	St. George	St. George	NB	New Brunswick	45.1333	-66.8167	1517	93.8	America/Moncton	3	E5C	1124740743
1334	Wembley	Wembley	AB	Alberta	55.1572	-119.1392	1516	318.9	America/Edmonton	3	T0H	1124957462
1335	Springbrook	Springbrook	AB	Alberta	52.1796	-113.885	1507	286.3	America/Edmonton	3	T4S	1124001537
1336	Saint-Tite-des-Caps	Saint-Tite-des-Caps	QC	Quebec	47.1333	-70.7667	1506	11.7	America/Montreal	3	G0A	1124367873
1337	Hudson Bay	Hudson Bay	SK	Saskatchewan	52.851	-102.392	1504	86.7	America/Regina	3	S0E	1124151446
1338	Pinawa	Pinawa	MB	Manitoba	50.1707	-95.9547	1504	11.7	America/Winnipeg	4	R0E	1124622420
1339	Brudenell, Lyndoch and Raglan	Brudenell, Lyndoch and Raglan	ON	Ontario	45.3167	-77.4	1503	2.1	America/Toronto	3	K0J	1124001367
1340	Carlyle	Carlyle	SK	Saskatchewan	49.6333	-102.2667	1503	451.1	America/Regina	3	S0C	1124830228
1341	Keremeos	Keremeos	BC	British Columbia	49.2025	-119.8294	1502	717.5	America/Vancouver	3	V0X	1124920590
1342	Val-Joli	Val-Joli	QC	Quebec	45.6	-71.97	1501	16.5	America/Montreal	4	J1S	1124000422
1343	Gold River	Gold River	BC	British Columbia	49.7769	-126.0514	1500	15	America/Vancouver	3	V0P	1124000663
1344	Saint-Casimir	Saint-Casimir	QC	Quebec	46.65	-72.1333	1500	22.5	America/Montreal	3	G0A	1124445682
1345	Bay Bulls	Bay Bulls	NL	Newfoundland and Labrador	47.3158	-52.8103	1500	48.8	America/St_Johns	3	A0A	1124701391
1346	Langham	Langham	SK	Saskatchewan	52.3667	-106.9667	1496	374.9	America/Regina	3	S0K	1124101937
1347	Frenchman Butte	Frenchman Butte	SK	Saskatchewan	53.6052	-109.4298	1494	0.8	America/Regina	4	S0M	1124729147
1348	Gordon	Gordon	NB	New Brunswick	46.8363	-67.1913	1493	1	America/Moncton	4	E7G	1124001029
1349	Kugluktuk	Kugluktuk	NU	Nunavut	67.8055	-115.3223	1491	2.7	America/Cambridge_Bay	4	X0B	1124349489
1350	Saint-Malachie	Saint-Malachie	QC	Quebec	46.5333	-70.7667	1489	14.8	America/Montreal	3	G0R	1124048620
1351	Southampton	Southampton	NB	New Brunswick	46.0789	-67.3124	1484	3.3	America/Moncton	4	E6E E6G	1124711539
1352	Salluit	Salluit	QC	Quebec	62.2013	-75.6337	1483	101.1	America/Montreal	4	J0M	1124962070
1353	Pangnirtung	Pangnirtung	NU	Nunavut	66.1436	-65.6829	1481	190.6	America/Pangnirtung	4	X0A	1124731886
1354	Saint-Louis-de-Gonzague	Saint-Louis-de-Gonzague	QC	Quebec	45.2	-73.98	1481	18.6	America/Montreal	3	J0S	1124000598
1355	Moosonee	Moosonee	ON	Ontario	51.2722	-80.6431	1481	2.7	America/Toronto	3	P0L	1124592907
1356	Englehart	Englehart	ON	Ontario	47.8167	-79.8667	1479	489.7	America/Toronto	3	P0J	1124297839
1357	Saint-Urbain	Saint-Urbain	QC	Quebec	47.55	-70.5333	1474	4.4	America/Montreal	4	G0A	1124108877
1358	Tring-Jonction	Tring-Jonction	QC	Quebec	46.2667	-70.9833	1473	57.5	America/Montreal	4	G0N	1124821925
1359	Nauwigewauk	Nauwigewauk	NB	New Brunswick	45.4812	-65.8738	1472	48.2	America/Moncton	4	E5N	1124029649
1360	Pointe-à-la-Croix	Pointe-a-la-Croix	QC	Quebec	48.0167	-66.6833	1472	3.7	America/Moncton	3	G0C	1124993506
1361	Denmark	Denmark	NB	New Brunswick	47.1155	-67.4771	1471	2	America/Moncton	4	E7H E7G	1124001349
1362	Saint-Joachim	Saint-Joachim	QC	Quebec	47.05	-70.85	1471	34.5	America/Montreal	3	G0A	1124056373
1363	Torch River No. 488	Torch River No. 488	SK	Saskatchewan	53.5445	-104.4619	1471	0.3	America/Regina	4	S0J	1124001716
1364	Saint-Théodore-d'Acton	Saint-Theodore-d'Acton	QC	Quebec	45.6833	-72.5833	1471	17.7	America/Montreal	4	J0H	1124207486
1365	Grindrod	Grindrod	BC	British Columbia	50.63	-119.1314	1470	34	America/Vancouver	4	V0E V1E	1124245869
1366	L’ Îsle-Verte	L' Isle-Verte	QC	Quebec	48.0167	-69.3333	1469	12.5	America/Montreal	3	G0L	1124320524
1367	Harrison Hot Springs	Harrison Hot Springs	BC	British Columbia	49.3	-121.7819	1468	263.4	America/Vancouver	3	V0M	1124001888
1368	Palmarolle	Palmarolle	QC	Quebec	48.6667	-79.2	1465	12.5	America/Montreal	3	J0Z	1124693739
1369	Henryville	Henryville	QC	Quebec	45.1333	-73.1833	1464	22.6	America/Montreal	3	J0J	1124175333
1370	Sussex Corner	Sussex Corner	NB	New Brunswick	45.7122	-65.4719	1461	156.4	America/Moncton	4	E4E	1124001821
1371	Saint-Odilon-de-Cranbourne	Saint-Odilon-de-Cranbourne	QC	Quebec	46.3667	-70.6833	1459	11.2	America/Montreal	4	G0S	1124001239
1372	Pipestone	Pipestone	MB	Manitoba	49.6653	-101.1444	1458	1.3	America/Winnipeg	3	R0M	1124293936
1373	Laurierville	Laurierville	QC	Quebec	46.3	-71.65	1454	13.6	America/Montreal	4	G0S	1124864029
1374	La Doré	La Dore	QC	Quebec	48.72	-72.65	1453	5	America/Montreal	3	G8J	1124387334
1375	Lac-au-Saumon	Lac-au-Saumon	QC	Quebec	48.4167	-67.35	1453	17.7	America/Montreal	3	G0J	1124759496
1376	Wotton	Wotton	QC	Quebec	45.7333	-71.8	1453	10.1	America/Montreal	4	J0A	1124174332
1377	Prairie Lakes	Prairie Lakes	MB	Manitoba	49.4034	-99.6298	1453	1.4	America/Winnipeg	4	R0K	1124001186
1378	Elk Point	Elk Point	AB	Alberta	53.8967	-110.8972	1452	295.5	America/Edmonton	3	T0A	1124622637
1379	Shellbrook	Shellbrook	SK	Saskatchewan	53.2167	-106.4	1444	390.3	America/Regina	3	S0J	1124817725
1380	Wemindji	Wemindji	QC	Quebec	53.044	-78.7384	1444	3.7	America/Montreal	4	J0M	1124079157
1381	Cape Dorset	Cape Dorset	NU	Nunavut	64.2237	-76.5405	1441	147.9	America/Iqaluit	4	X0A	1124646146
1382	Strong	Strong	ON	Ontario	45.75	-79.4	1439	9	America/Toronto	3	P0A	1124000578
1383	Lappe	Lappe	ON	Ontario	48.5693	-89.3573	1436	9.8	America/Toronto	4	P7G	1124000934
1384	Rivière-Héva	Riviere-Heva	QC	Quebec	48.2333	-78.2167	1433	3.4	America/Montreal	4	J0Y	1124000406
1385	Fort-Coulonge	Fort-Coulonge	QC	Quebec	45.85	-76.7333	1433	462.4	America/Montreal	3	J0X	1124453309
1386	Irishtown-Summerside	Irishtown-Summerside	NL	Newfoundland and Labrador	48.9833	-57.95	1418	119.2	America/St_Johns	4	A2H	1124000307
1387	Godmanchester	Godmanchester	QC	Quebec	45.08	-74.25	1417	10.2	America/Montreal	3	J0S	1124000511
1388	Macklin	Macklin	SK	Saskatchewan	52.33	-109.94	1415	450.7	America/Regina	3	S0L	1124573046
1389	Armour	Armour	ON	Ontario	45.6289	-79.3436	1414	8.6	America/Toronto	3	P0A	1124000589
1390	Saint-Simon	Saint-Simon	QC	Quebec	45.719	-72.8463	1413	20.5	America/Montreal	4	J0H	1124669265
1391	St. François Xavier	St. Francois Xavier	MB	Manitoba	49.9903	-97.6722	1411	6.9	America/Winnipeg	3	R4L	1124001915
1392	Tingwick	Tingwick	QC	Quebec	45.8873	-71.9244	1410	8.3	America/Montreal	4	J0A	1124969542
1393	Saint-Aubert	Saint-Aubert	QC	Quebec	47.1833	-70.2167	1409	14	America/Montreal	3	G0R	1124439130
1394	Saint-Mathieu-du-Parc	Saint-Mathieu-du-Parc	QC	Quebec	46.5667	-72.9167	1407	6.3	America/Montreal	4	G0X	1124001318
1395	Wabasca	Wabasca	AB	Alberta	55.9855	-113.8566	1406	65.8	America/Edmonton	4	T0G	1124001857
1396	Ragueneau	Ragueneau	QC	Quebec	49.0667	-68.5333	1405	7.6	America/Montreal	4	G0H	1124000159
1397	Notre-Dame-du-Bon-Conseil	Notre-Dame-du-Bon-Conseil	QC	Quebec	46	-72.35	1404	331.4	America/Montreal	3	J0C	1124217511
1398	Wasagamack	Wasagamack	MB	Manitoba	53.9056	-94.9412	1403	17.3	America/Winnipeg	4	R0B	1124000650
1399	Saint-Ubalde	Saint-Ubalde	QC	Quebec	46.75	-72.2667	1403	10	America/Montreal	3	G0A	1124614507
1400	Creighton	Creighton	SK	Saskatchewan	54.7561	-101.8973	1402	97.4	America/Winnipeg	3	S0P	1124000828
1401	Fortune	Fortune	NL	Newfoundland and Labrador	47.0733	-55.8217	1401	25.5	America/St_Johns	3	A0E	1124546267
1402	Faraday	Faraday	ON	Ontario	45	-77.9167	1401	6.4	America/Toronto	3	K0L	1124001991
1403	Berthier-sur-Mer	Berthier-sur-Mer	QC	Quebec	46.9167	-70.7333	1398	52.2	America/Montreal	3	G0R	1124625020
1404	Frampton	Frampton	QC	Quebec	46.4667	-70.8	1393	9.2	America/Montreal	3	G0R	1124063273
1405	Magnetawan	Magnetawan	ON	Ontario	45.6667	-79.6333	1390	2.6	America/Toronto	3	P0A	1124537839
1406	New Carlisle	New Carlisle	QC	Quebec	48.0167	-65.3333	1388	20.5	America/Montreal	3	G0C	1124193848
1407	Laird No. 404	Laird No. 404	SK	Saskatchewan	52.5696	-106.7312	1387	1.9	America/Regina	4	S0K	1124001811
1408	Petitcodiac	Petitcodiac	NB	New Brunswick	45.9333	-65.1667	1383	80.4	America/Moncton	3	E4Z	1124122911
1409	Popkum	Popkum	BC	British Columbia	49.1911	-121.7553	1382	216.7	America/Vancouver	3	V0X	1124000726
1410	Norton	Norton	NB	New Brunswick	45.6387	-65.6955	1382	18.3	America/Moncton	3	E5N	1124362919
1411	Canwood No. 494	Canwood No. 494	SK	Saskatchewan	53.4574	-106.7768	1381	0.7	America/Regina	4	S0J	1124001486
1412	Wentworth-Nord	Wentworth-Nord	QC	Quebec	45.85	-74.45	1381	8.8	America/Montreal	3	J0T	1124001955
1413	Bas Caraquet	Bas Caraquet	NB	New Brunswick	47.8	-64.8333	1380	44.5	America/Moncton	4	E1W	1124124817
1414	Sainte-Ursule	Sainte-Ursule	QC	Quebec	46.2833	-73.0333	1375	20.2	America/Montreal	4	J0K	1124000577
1415	Dawson	Dawson	YT	Yukon	64.0464	-139.3893	1375	42.4	America/Whitehorse	4	Y0B	1124075766
1416	Nantes	Nantes	QC	Quebec	45.6333	-71.0333	1374	11.4	America/Montreal	3	G0Y	1124802333
1417	Lac-aux-Sables	Lac-aux-Sables	QC	Quebec	46.8667	-72.4	1373	5.1	America/Montreal	3	G0X	1124691735
1418	Stewiacke	Stewiacke	NS	Nova Scotia	45.1422	-63.3483	1373	77.9	America/Halifax	3	B0N	1124573534
1419	Taylor	Taylor	BC	British Columbia	56.159	-120.6878	1373	80.3	America/Dawson_Creek	3	V0C	1124063816
1420	Rosser	Rosser	MB	Manitoba	49.99	-97.4592	1372	3.1	America/Winnipeg	3	R3C R0H	1124001581
1421	Estevan No. 5	Estevan No. 5	SK	Saskatchewan	49.1308	-103.0126	1370	1.8	America/Regina	4	S4A	1124000725
1422	Falmouth	Falmouth	NS	Nova Scotia	44.9967	-64.1634	1368	262.3	America/Halifax	3	B0P	1124001382
1423	Vaudreuil-sur-le-Lac	Vaudreuil-sur-le-Lac	QC	Quebec	45.4	-74.0333	1359	989.2	America/Montreal	3	J7V	1124001806
1424	Grahamdale	Grahamdale	MB	Manitoba	51.42	-98.3733	1359	0.6	America/Winnipeg	3	R0C	1124001918
1425	Cardwell	Cardwell	NB	New Brunswick	45.7848	-65.3037	1353	4.3	America/Moncton	4	E4Z E4G	1124001428
1426	Two Hills	Two Hills	AB	Alberta	53.715	-111.7461	1352	400	America/Edmonton	3	T0B	1124512958
1427	Spiritwood No. 496	Spiritwood No. 496	SK	Saskatchewan	53.4435	-107.4495	1347	0.6	America/Regina	4	S0J	1124001575
1428	Legal	Legal	AB	Alberta	53.9492	-113.595	1345	423.4	America/Edmonton	3	T0G	1124819805
1429	Amulet	Amulet	QC	Quebec	48.2938	-79.0274	1340	724.3	America/Montreal	3	J9X J9Y	1124000786
1430	Hérouxville	Herouxville	QC	Quebec	46.6667	-72.6167	1340	25.3	America/Montreal	3	G0X	1124001698
1431	Pointe-des-Cascades	Pointe-des-Cascades	QC	Quebec	45.3333	-73.9667	1340	502.2	America/Montreal	3	J0P	1124001740
1432	Weldford	Weldford	NB	New Brunswick	46.5221	-65.1114	1338	2.2	America/Moncton	4	E4W E4T	1124000165
1433	Reynolds	Reynolds	MB	Manitoba	49.7678	-95.8842	1338	0.4	America/Winnipeg	3	R0E	1124938750
1434	St. Laurent	St. Laurent	MB	Manitoba	50.43	-97.7933	1338	2.9	America/Winnipeg	4	R0C	1124303582
1435	Lions Bay	Lions Bay	BC	British Columbia	49.4581	-123.2369	1334	526.5	America/Vancouver	3	V0N	1124001126
1436	L'Isle-aux-Allumettes	L'Isle-aux-Allumettes	QC	Quebec	45.8667	-77.0667	1334	7.2	America/Montreal	3	J0X	1124001726
1437	Emo	Emo	ON	Ontario	48.6333	-93.8333	1333	6.6	America/Winnipeg	3	P0W	1124320866
1438	Sainte-Brigide-d'Iberville	Sainte-Brigide-d'Iberville	QC	Quebec	45.3167	-73.0667	1331	18.7	America/Montreal	3	J0J	1124015542
1439	Les Éboulements	Les Eboulements	QC	Quebec	47.4833	-70.3167	1331	8.5	America/Montreal	3	G0A	1124253187
1440	Dunsmuir	Dunsmuir	BC	British Columbia	49.3696	-124.5772	1330	62.3	America/Vancouver	4	V9K	1124000426
1441	Pointe-aux-Outardes	Pointe-aux-Outardes	QC	Quebec	49.05	-68.4333	1330	17.8	America/Montreal	3	G0H	1124001253
1442	Smooth Rock Falls	Smooth Rock Falls	ON	Ontario	49.2833	-81.6333	1330	6.6	America/Toronto	3	P0L	1124418972
1443	Oxbow	Oxbow	SK	Saskatchewan	49.2333	-102.1667	1328	412.6	America/Regina	3	S0C	1124727899
1444	Telkwa	Telkwa	BC	British Columbia	54.6972	-127.05	1327	191.9	America/Vancouver	3	V0J	1124000170
1445	Gjoa Haven	Gjoa Haven	NU	Nunavut	68.6448	-95.8912	1324	46.5	America/Cambridge_Bay	4	X0B	1124942230
1446	Sainte-Barbe	Sainte-Barbe	QC	Quebec	45.1667	-74.2	1324	33	America/Montreal	3	J0S	1124147367
1447	Mayerthorpe	Mayerthorpe	AB	Alberta	53.9503	-115.1336	1320	302.2	America/Edmonton	3	T0E	1124001053
1448	Saint-Louis-du-Ha! Ha!	Saint-Louis-du-Ha! Ha!	QC	Quebec	47.67	-68.98	1318	11.7	America/Montreal	3	G0L	1124487645
1449	Powerview-Pine Falls	Powerview-Pine Falls	MB	Manitoba	50.5661	-96.1981	1316	262	America/Winnipeg	3	R0E	1124001400
1450	Baie Verte	Baie Verte	NL	Newfoundland and Labrador	49.9167	-56.1833	1313	3.5	America/St_Johns	3	A0K	1124727368
1451	Saint-Édouard	Saint-Edouard	QC	Quebec	45.2333	-73.5167	1312	24.8	America/Montreal	3	J0L	1124689962
1452	Charlo	Charlo	NB	New Brunswick	48	-66.32	1310	41.9	America/Moncton	3	E8E	1124001583
1453	Hillsborough	Hillsborough	NB	New Brunswick	45.9052	-64.7652	1308	4.3	America/Moncton	4	E4H	1124000107
1454	Bruederheim	Bruederheim	AB	Alberta	53.8042	-112.9278	1308	183.8	America/Edmonton	3	T0B	1124027946
1455	Burgeo	Burgeo	NL	Newfoundland and Labrador	47.6	-57.6333	1307	41.7	America/St_Johns	3	A0N	1124034870
1456	Wadena	Wadena	SK	Saskatchewan	51.9458	-103.8014	1306	449.5	America/Regina	3	S0A	1124604550
1457	Swan Hills	Swan Hills	AB	Alberta	54.7106	-115.4133	1301	49.8	America/Edmonton	3	T0G	1124000651
1458	Wilkie	Wilkie	SK	Saskatchewan	52.4167	-108.7	1301	137.3	America/Regina	3	S0K	1124926813
1459	Saint-Léonard	Saint-Leonard	NB	New Brunswick	47.1625	-67.925	1300	249.2	America/Moncton	3	E7E	1124194436
1460	Rivière-Bleue	Riviere-Bleue	QC	Quebec	47.4333	-69.05	1299	7.5	America/Montreal	4	G0L	1124592122
1461	Noyan	Noyan	QC	Quebec	45.0667	-73.3	1297	29	America/Montreal	3	J0J	1124781949
1462	Ile-à-la-Crosse	Ile-a-la-Crosse	SK	Saskatchewan	55.45	-107.8833	1296	54.4	America/Regina	3	S0J S0M	1124359869
1463	Landmark	Landmark	MB	Manitoba	49.6711	-96.8179	1292	433.4	America/Winnipeg	3	R0A	1124000247
1464	Saint-Hugues	Saint-Hugues	QC	Quebec	45.8	-72.8667	1292	15.4	America/Montreal	3	J0H	1124983381
1465	Chisholm	Chisholm	ON	Ontario	46.1	-79.2333	1291	6.2	America/Toronto	4	P0H	1124000894
1466	Sainte-Anne-du-Sault	Sainte-Anne-du-Sault	QC	Quebec	46.1733	-72.1415	1290	21.6	America/Montreal	4	G0Z	1124001314
1467	La Conception	La Conception	QC	Quebec	46.15	-74.7	1287	9.9	America/Montreal	3	J0T	1124175484
1468	Saint-Valère	Saint-Valere	QC	Quebec	46.0667	-72.1	1286	11.9	America/Montreal	4	G0P	1124182292
1469	Sorrento	Sorrento	BC	British Columbia	50.8832	-119.4782	1285	108.3	America/Vancouver	4	V0E	1124978509
1470	Lamèque	Lameque	NB	New Brunswick	47.7925	-64.6532	1285	102.8	America/Moncton	3	E8T	1124209362
1471	Thessalon	Thessalon	ON	Ontario	46.25	-83.55	1279	284.6	America/Toronto	3	P0R	1124087342
1472	L'Isle-aux-Coudres	L'Isle-aux-Coudres	QC	Quebec	47.4	-70.3833	1279	42.5	America/Montreal	3	G0A	1124001681
1473	Nobleford	Nobleford	AB	Alberta	49.8822	-113.0531	1278	802.6	America/Edmonton	3	T0L	1124281605
1474	Larouche	Larouche	QC	Quebec	48.45	-71.5167	1277	15.1	America/Montreal	4	G0W	1124000827
1475	South Qu'Appelle No. 157	South Qu'Appelle No. 157	SK	Saskatchewan	50.5389	-104.0141	1275	1.4	America/Regina	4	S0G	1124001385
1476	Elton	Elton	MB	Manitoba	49.975	-99.8658	1273	2.2	America/Winnipeg	4	R0K	1124000871
1477	Lorrainville	Lorrainville	QC	Quebec	47.3613	-79.3382	1272	14.5	America/Montreal	4	J0Z	1124001976
1478	Conestogo	Conestogo	ON	Ontario	43.5441	-80.4997	1270	595.5	America/Toronto	3	N0B	1124566995
1479	Upham	Upham	NB	New Brunswick	45.5083	-65.6618	1269	6.7	America/Moncton	4	E5N	1124000748
1480	St.-Charles	St.-Charles	ON	Ontario	46.3422	-80.4497	1269	3.9	America/Toronto	4	P0M	1124428919
1481	Sainte-Lucie-des-Laurentides	Sainte-Lucie-des-Laurentides	QC	Quebec	46.13	-74.18	1269	11.1	America/Montreal	4	J0T	1124001146
1482	Saint-Alexis	Saint-Alexis	QC	Quebec	45.9333	-73.6167	1267	29.2	America/Montreal	4	J0K	1124001453
1483	Gillam	Gillam	MB	Manitoba	56.3472	-94.7078	1265	0.6	America/Winnipeg	3	R0B	1124560722
1484	Roxton Falls	Roxton Falls	QC	Quebec	45.5667	-72.5167	1265	259.1	America/Montreal	3	J0H	1124901453
1485	Montcalm	Montcalm	MB	Manitoba	49.1775	-97.3247	1260	2.7	America/Winnipeg	3	R0G	1124000100
1486	Clarendon	Clarendon	QC	Quebec	45.65	-76.5167	1256	3.8	America/Montreal	3	J0X	1124000922
1487	Mervin No. 499	Mervin No. 499	SK	Saskatchewan	53.5455	-108.8762	1256	0.8	America/Regina	4	S0M	1124001677
1488	Saint-Ludger	Saint-Ludger	QC	Quebec	45.75	-70.7	1255	9.8	America/Montreal	4	G0M	1124281144
1489	Coldwell	Coldwell	MB	Manitoba	50.6389	-98.0417	1254	1.4	America/Winnipeg	4	R0C	1124001845
1490	Saint-Arsène	Saint-Arsene	QC	Quebec	47.9167	-69.4333	1253	17.7	America/Montreal	4	G0L	1124482227
1491	Racine	Racine	QC	Quebec	45.5	-72.25	1252	11.8	America/Montreal	4	J0E	1124253350
1492	Saint-Majorique-de-Grantham	Saint-Majorique-de-Grantham	QC	Quebec	45.9333	-72.5833	1251	21.6	America/Montreal	4	J2B	1124000808
1493	Saint-Zénon	Saint-Zenon	QC	Quebec	46.55	-73.8167	1250	2.7	America/Montreal	3	J0K	1124443019
1494	Saint-Armand	Saint-Armand	QC	Quebec	45.0333	-73.05	1248	15.1	America/Montreal	3	J0J	1124958164
1495	Saint-Édouard-de-Lotbinière	Saint-Edouard-de-Lotbiniere	QC	Quebec	46.5667	-71.8333	1248	12.7	America/Montreal	4	G0S	1124001130
1496	Alonsa	Alonsa	MB	Manitoba	50.9794	-99.0796	1247	0.4	America/Winnipeg	4	R0H R0L	1124385753
1497	Listuguj	Listuguj	QC	Quebec	48.0609	-66.7491	1241	28	America/Montreal	4	G0C	1124001828
1498	Bowden	Bowden	AB	Alberta	51.9306	-114.0256	1240	442.8	America/Edmonton	3	T0M	1124945470
1499	St. Joseph	St. Joseph	ON	Ontario	46.2667	-84	1240	9.3	America/Toronto	3	P0R	1124001430
1500	Osler	Osler	SK	Saskatchewan	52.37	-106.54	1237	796.5	America/Regina	3	S0K	1124000037
1501	Saint-Hubert-de-Rivière-du-Loup	Saint-Hubert-de-Riviere-du-Loup	QC	Quebec	47.8167	-69.15	1235	6.4	America/Montreal	4	G0L	1124000191
1502	Saint-Jude	Saint-Jude	QC	Quebec	45.7667	-72.9833	1235	16	America/Montreal	3	J0H	1124510808
1503	Dildo	Dildo	NL	Newfoundland and Labrador	47.5685	-53.5471	1234	152	America/St_Johns	4	A0B	1124396361
1504	La Minerve	La Minerve	QC	Quebec	46.25	-74.9333	1234	4.4	America/Montreal	3	J0T	1124869065
1505	Lanigan	Lanigan	SK	Saskatchewan	51.85	-105.0333	1233	165.2	America/Regina	3	S0K	1124052623
1506	Lajord No. 128	Lajord No. 128	SK	Saskatchewan	50.1965	-104.2507	1232	1.3	America/Regina	4	S0G	1124000590
1507	Moonbeam	Moonbeam	ON	Ontario	49.35	-82.15	1231	5.2	America/Toronto	3	P0L	1124775223
1508	Notre-Dame-des-Pins	Notre-Dame-des-Pins	QC	Quebec	46.1833	-70.7167	1227	51.2	America/Montreal	3	G0M	1124000253
1509	Saint-Alban	Saint-Alban	QC	Quebec	46.7167	-72.0833	1225	8.2	America/Montreal	3	G0A	1124839435
1510	Saint-Pierre-les-Becquets	Saint-Pierre-les-Becquets	QC	Quebec	46.5	-72.2	1223	25.6	America/Montreal	4	G0X	1124957722
1511	Arborg	Arborg	MB	Manitoba	50.9075	-97.2182	1222	611	America/Winnipeg	3	R0C	1124353392
1512	Vauxhall	Vauxhall	AB	Alberta	50.0689	-112.0975	1222	449.4	America/Edmonton	3	T0K	1124148360
1513	Bayfield	Bayfield	ON	Ontario	43.5615	-81.6983	1218	439.9	America/Toronto	3	N0M	1124665510
1514	Beaver River	Beaver River	SK	Saskatchewan	54.3531	-109.5575	1216	0.5	America/Regina	4	S0M	1124717040
1515	Irricana	Irricana	AB	Alberta	51.3189	-113.6106	1216	376.1	America/Edmonton	3	T0M	1124968867
1516	Labrecque	Labrecque	QC	Quebec	48.6667	-71.5333	1215	7.9	America/Montreal	4	G0W	1124000362
1517	New Bandon	New Bandon	NB	New Brunswick	47.6912	-65.29	1214	3.4	America/Moncton	4	E2A E8N	1124001513
1518	Wemotaci	Wemotaci	QC	Quebec	47.9219	-73.7872	1213	38.5	America/Montreal	4	G0X	1124001294
1519	Sainte-Hénédine	Sainte-Henedine	QC	Quebec	46.55	-70.9833	1212	23.6	America/Montreal	4	G0S	1124771909
1520	L'Anse-Saint-Jean	L'Anse-Saint-Jean	QC	Quebec	48.2333	-70.2	1208	2.4	America/Montreal	3	G0V	1124155071
1521	Bassano	Bassano	AB	Alberta	50.7833	-112.4667	1206	231.2	America/Edmonton	3	T0J	1124776374
1522	Parrsboro	Parrsboro	NS	Nova Scotia	45.3998	-64.3312	1205	81.4	America/Halifax	4	B0M	1124877589
1523	Kaleden	Kaleden	BC	British Columbia	49.3926	-119.5955	1203	278.7	America/Vancouver	3	V0H	1124001071
1524	St. George's	St. George's	NL	Newfoundland and Labrador	48.4275	-58.4778	1203	46.6	America/St_Johns	3	A0N	1124178262
1525	Fort Simpson	Fort Simpson	NT	Northwest Territories	61.8082	-121.3199	1202	15.3	America/Yellowknife	4	X0E	1124669512
1526	Akwesasne	Akwesasne	QC	Quebec	45.0155	-74.5769	1202	48.4	America/Montreal	4	J0S H0M	1124000436
1527	L’Avenir	L'Avenir	QC	Quebec	45.7667	-72.3	1202	12.4	America/Montreal	4	J0C	1124154040
1528	Ignace	Ignace	ON	Ontario	49.4167	-91.6667	1202	16.5	America/Winnipeg	3	P0T	1124972211
1529	Claremont	Claremont	ON	Ontario	43.9741	-79.1316	1202	567.5	America/Toronto	3	L1Y	1124327632
1530	Teulon	Teulon	MB	Manitoba	50.3858	-97.2611	1201	372.3	America/Winnipeg	3	R0C	1124616630
1531	Peel	Peel	NB	New Brunswick	46.4058	-67.5278	1196	10.6	America/Moncton	4	E7L	1124771409
1532	Musquash	Musquash	NB	New Brunswick	45.1836	-66.3514	1194	5.1	America/Moncton	4	E5J	1124987756
1533	Notre-Dame-du-Portage	Notre-Dame-du-Portage	QC	Quebec	47.7667	-69.6167	1193	29.9	America/Montreal	3	G0L	1124956445
1534	St. Lawrence	St. Lawrence	NL	Newfoundland and Labrador	46.9244	-55.3928	1192	33.6	America/St_Johns	3	A0E	1124645666
1535	Oxford	Oxford	NS	Nova Scotia	45.7306	-63.8733	1190	110.6	America/Halifax	3	B0M	1124455847
1536	Minto-Odanah	Minto-Odanah	MB	Manitoba	50.2406	-99.8056	1189	1.6	America/Winnipeg	4	R0J	1124001517
1537	St. Alban's	St. Alban's	NL	Newfoundland and Labrador	47.8753	-55.8414	1186	56.9	America/St_Johns	3	A0H	1124613667
1538	Saint James	Saint James	NB	New Brunswick	45.3822	-67.3427	1186	2.1	America/Moncton	4	E5A E3L	1124001675
1539	Saint-Norbert-d'Arthabaska	Saint-Norbert-d'Arthabaska	QC	Quebec	46.1	-71.8167	1185	11.4	America/Montreal	4	G0P	1124000467
1540	Manning	Manning	AB	Alberta	56.9142	-117.6272	1183	291.9	America/Edmonton	3	T0H	1124001357
1541	Glenella-Lansdowne	Glenella-Lansdowne	MB	Manitoba	50.4163	-99.2097	1181	0.9	America/Winnipeg	4	R0J	1124001185
1542	Saint-Hilarion	Saint-Hilarion	QC	Quebec	47.5667	-70.4	1181	11.9	America/Montreal	4	G0A	1124375343
1543	Saint-Siméon	Saint-Simeon	QC	Quebec	48.0667	-65.5667	1179	20.9	America/Montreal	4	G0C	1124797465
1544	Saint-Barnabé	Saint-Barnabe	QC	Quebec	46.4	-72.8833	1179	20	America/Montreal	3	G0X	1124760889
1545	Sainte-Félicité	Sainte-Felicite	QC	Quebec	48.9	-67.3333	1175	12.9	America/Montreal	3	G0J	1124831574
1546	Two Borders	Two Borders	MB	Manitoba	49.2668	-101.1124	1175	0.5	America/Winnipeg	4	R0M	1124001678
1547	Queensbury	Queensbury	NB	New Brunswick	45.9918	-67.0632	1174	3.9	America/Moncton	4	E6L E6E	1124001691
1548	Bury	Bury	QC	Quebec	45.4667	-71.5	1174	4.9	America/Montreal	3	J0B	1124643055
1549	Lac-Bouchette	Lac-Bouchette	QC	Quebec	48.25	-72.18	1174	1.3	America/Montreal	4	G0W	1124365485
1550	Saint-Lazare-de-Bellechasse	Saint-Lazare-de-Bellechasse	QC	Quebec	46.65	-70.8	1172	13.6	America/Montreal	4	G0R	1124054719
1551	Saint-Michel-du-Squatec	Saint-Michel-du-Squatec	QC	Quebec	47.88	-68.72	1171	3.2	America/Montreal	4	G0L	1124190334
1552	Saint-Joachim-de-Shefford	Saint-Joachim-de-Shefford	QC	Quebec	45.45	-72.5333	1171	9.2	America/Montreal	4	J0E	1124777025
1553	St-Pierre-Jolys	St-Pierre-Jolys	MB	Manitoba	49.4403	-96.9844	1170	440.5	America/Winnipeg	3	R0A	1124001013
1554	Grand-Remous	Grand-Remous	QC	Quebec	46.6167	-75.9	1168	3.3	America/Montreal	3	J0W	1124917091
1555	Saint-Gabriel-de-Rimouski	Saint-Gabriel-de-Rimouski	QC	Quebec	48.4209	-68.1791	1167	9.2	America/Montreal	4	G0K	1124766556
1556	Rogersville	Rogersville	NB	New Brunswick	46.7167	-65.4167	1166	161.9	America/Moncton	3	E4Y	1124369581
1557	Langenburg	Langenburg	SK	Saskatchewan	50.8333	-101.7	1165	337.1	America/Regina	3	S0A	1124335442
1558	Sainte-Marie-Salomé	Sainte-Marie-Salome	QC	Quebec	45.9333	-73.5	1164	34.5	America/Montreal	3	J0K	1124001034
1559	Moose Jaw No. 161	Moose Jaw No. 161	SK	Saskatchewan	50.4433	-105.5091	1163	1.5	America/Regina	4	S0H S6J	1124000515
1560	Saint-Cyprien	Saint-Cyprien	QC	Quebec	47.9	-69.0167	1163	8.4	America/Montreal	4	G0L	1124986836
1561	Maidstone	Maidstone	SK	Saskatchewan	53.092	-109.294	1156	233.5	America/Edmonton	3	S0M	1124537085
1562	Très-Saint-Sacrement	Tres-Saint-Sacrement	QC	Quebec	45.1833	-73.85	1155	11.7	America/Montreal	3	J0S	1124001118
1563	Battle River No. 438	Battle River No. 438	SK	Saskatchewan	52.7343	-108.4452	1154	1.1	America/Regina	4	S0M	1124001521
1564	Miltonvale Park	Miltonvale Park	PE	Prince Edward Island	46.318	-63.237	1153	32.4	America/Halifax	4	C1E	1124001949
1565	McAdam	McAdam	NB	New Brunswick	45.5944	-67.3258	1151	80.6	America/Moncton	3	E6J	1124054455
1566	Saints-Anges	Saints-Anges	QC	Quebec	46.4167	-70.8833	1149	16.6	America/Montreal	4	G0S	1124749056
1567	Saint-Urbain-Premier	Saint-Urbain-Premier	QC	Quebec	45.22	-73.73	1148	21.6	America/Montreal	3	J0S	1124927145
1568	Centreville-Wareham-Trinity	Centreville-Wareham-Trinity	NL	Newfoundland and Labrador	48.9879	-53.9069	1147	30.8	America/St_Johns	3	A0G	1124000332
1569	Alberton	Alberton	PE	Prince Edward Island	46.8167	-64.0667	1145	253.5	America/Halifax	3	C0B	1124792801
1570	Winnipeg Beach	Winnipeg Beach	MB	Manitoba	50.5058	-96.9742	1145	295.9	America/Winnipeg	3	R0C	1124001121
1571	Sainte-Agathe-de-Lotbinière	Sainte-Agathe-de-Lotbiniere	QC	Quebec	46.3833	-71.4167	1145	6.9	America/Montreal	4	G0S	1124003470
1572	Salmo	Salmo	BC	British Columbia	49.1942	-117.2778	1141	466.2	America/Vancouver	3	V0G	1124411651
1573	Kipling	Kipling	SK	Saskatchewan	50.1015	-102.6324	1140	396.5	America/Regina	3	S0G	1124000823
1574	Sagamok	Sagamok	ON	Ontario	46.1529	-82.2072	1140	11.6	America/Toronto	4	P0P	1124001822
1575	Trécesson	Trecesson	QC	Quebec	48.65	-78.3167	1138	5.8	America/Montreal	4	J0Y	1124000493
1576	Tara	Tara	ON	Ontario	44.4793	-81.1445	1138	470.3	America/Toronto	3	N0H	1124001864
1577	Grande-Vallée	Grande-Vallee	QC	Quebec	49.2167	-65.1333	1137	7.9	America/Montreal	3	G0E	1124608975
1578	Bertrand	Bertrand	NB	New Brunswick	47.7622	-65.0686	1137	24.5	America/Moncton	4	E1W	1124001809
1579	Newcastle	Newcastle	NB	New Brunswick	47.1725	-65.5551	1136	2	America/Moncton	4	E1V	1124367015
1580	Mont-Carmel	Mont-Carmel	QC	Quebec	47.4397	-69.8586	1136	2.7	America/Montreal	4	G0L	1124064864
1581	Saint Martins	Saint Martins	NB	New Brunswick	45.4563	-65.4395	1132	1.8	America/Moncton	4	E5R	1124001010
1582	Saint-Eugène	Saint-Eugene	QC	Quebec	45.8	-72.7	1131	14.9	America/Montreal	3	J0C	1124834014
1583	Notre-Dame-des-Neiges	Notre-Dame-des-Neiges	QC	Quebec	48.1167	-69.1667	1129	12	America/Montreal	4	G0L	1124000518
1584	Saint-André	Saint-Andre	NB	New Brunswick	47.1392	-67.7444	1129	8.8	America/Moncton	4	E3Y	1124000931
1585	Centreville	Centreville	NS	Nova Scotia	45.13	-64.5224	1129	477.5	America/Halifax	3	B0P	1124795742
1586	Roland	Roland	MB	Manitoba	49.3547	-97.8997	1129	2.3	America/Winnipeg	4	R0G	1124796797
1587	Saint-Léon-de-Standon	Saint-Leon-de-Standon	QC	Quebec	46.4833	-70.6167	1128	8.2	America/Montreal	4	G0R	1124297826
1588	Saint-Modeste	Saint-Modeste	QC	Quebec	47.8333	-69.4	1128	10.3	America/Montreal	4	G0L	1124591131
1589	Carnduff	Carnduff	SK	Saskatchewan	49.167	-101.783	1126	498.2	America/Regina	3	S0C	1124238691
1590	Carling	Carling	ON	Ontario	45.4333	-80.2167	1125	4.5	America/Toronto	3	P0G	1124000522
1591	Eckville	Eckville	AB	Alberta	52.3622	-114.3614	1125	703.3	America/Edmonton	3	T0M	1124000793
1592	Nain	Nain	NL	Newfoundland and Labrador	56.5422	-61.6928	1125	11.9	America/Goose_Bay	3	A0P	1124719084
1593	Hillsburgh	Hillsburgh	ON	Ontario	43.7914	-80.1354	1124	384.9	America/Toronto	3	N0B	1124258378
1594	Foam Lake	Foam Lake	SK	Saskatchewan	51.65	-103.5333	1123	189.4	America/Regina	3	S0A	1124751136
1595	Sainte-Sabine	Sainte-Sabine	QC	Quebec	45.2333	-73.0167	1120	20.3	America/Montreal	4	J0J	1124001836
1596	Saint-Maxime-du-Mont-Louis	Saint-Maxime-du-Mont-Louis	QC	Quebec	49.2333	-65.7333	1118	4.8	America/Montreal	3	G0E	1124000029
1597	Blanc-Sablon	Blanc-Sablon	QC	Quebec	51.4167	-57.1333	1118	4.5	America/Blanc-Sablon	3	G0G	1124785666
1598	Cobalt	Cobalt	ON	Ontario	47.4	-79.6833	1118	776	America/Toronto	3	P0J	1124248298
1599	Gravelbourg	Gravelbourg	SK	Saskatchewan	49.874	-106.555	1116	346	America/Regina	3	S0H	1124409900
1600	South River	South River	ON	Ontario	45.8417	-79.375	1114	268.3	America/Toronto	3	P0A	1124154548
1601	Hudson Bay No. 394	Hudson Bay No. 394	SK	Saskatchewan	53.0295	-102.3122	1114	0.1	America/Regina	4	S0E	1124001694
1602	McKellar	McKellar	ON	Ontario	45.4833	-79.85	1111	6.1	America/Toronto	3	P0G P2A	1124000057
1603	Frelighsburg	Frelighsburg	QC	Quebec	45.0461	-72.8106	1111	9	America/Montreal	4	J0J	1124000101
1604	Buffalo Narrows	Buffalo Narrows	SK	Saskatchewan	55.8769	-108.5244	1110	16.2	America/Regina	3	S0M	1124766743
1605	Ayer’s Cliff	Ayer's Cliff	QC	Quebec	45.1667	-72.05	1109	197.9	America/Montreal	3	J0B	1124916439
1606	Les Méchins	Les Mechins	QC	Quebec	49	-66.9833	1107	2.5	America/Montreal	3	G0J	1124540316
1607	Sainte-Marguerite	Sainte-Marguerite	QC	Quebec	46.5167	-70.9333	1107	12.9	America/Montreal	4	G0S	1124041972
1608	Saint-Claude	Saint-Claude	QC	Quebec	45.6667	-71.9833	1106	9.3	America/Montreal	4	J1S	1124525083
1609	Air Ronge	Air Ronge	SK	Saskatchewan	55.0872	-105.3318	1106	184.3	America/Regina	3	S0J	1124001996
1610	Chipman	Chipman	NB	New Brunswick	46.171	-65.884	1104	58	America/Moncton	3	E4A	1124551016
1611	Girardville	Girardville	QC	Quebec	49	-72.55	1100	8.9	America/Montreal	4	G0W	1124315247
1612	Saint-Bruno-de-Guigues	Saint-Bruno-de-Guigues	QC	Quebec	47.4667	-79.4333	1100	8.8	America/Montreal	4	J0Z	1124052468
1613	Grenfell	Grenfell	SK	Saskatchewan	50.4167	-102.9167	1099	347	America/Regina	3	S0G	1124603747
1614	Dorchester	Dorchester	NB	New Brunswick	45.9016	-64.5161	1096	189.3	America/Moncton	3	E4K	1124001021
1615	South Algonquin	South Algonquin	ON	Ontario	45.4967	-78.0239	1096	1.3	America/Toronto	3	K0J	1124001032
1616	Windermere	Windermere	BC	British Columbia	50.4856	-115.9948	1092	104	America/Edmonton	4	V0A V0B	1124519589
1617	Saint-Narcisse-de-Beaurivage	Saint-Narcisse-de-Beaurivage	QC	Quebec	46.4833	-71.2333	1091	17.6	America/Montreal	4	G0S	1124000086
1618	Saint-René-de-Matane	Saint-Rene-de-Matane	QC	Quebec	48.7	-67.3833	1089	4.3	America/Montreal	4	G0J	1124000167
1619	Sainte-Jeanne-d'Arc	Sainte-Jeanne-d'Arc	QC	Quebec	48.8575	-72.0939	1089	4	America/Montreal	3	G0W	1124001392
1620	Plaisance	Plaisance	QC	Quebec	45.6167	-75.1167	1088	30.1	America/Montreal	3	J0V	1124858477
1621	Roxton-Sud	Roxton-Sud	QC	Quebec	45.5521	-72.5265	1086	7.3	America/Montreal	4	J0H	1124174410
1622	St. Louis No. 431	St. Louis No. 431	SK	Saskatchewan	52.8277	-105.7873	1086	1.4	America/Regina	4	S0J S0K	1124000136
1682	Taloyoak	Taloyoak	NU	Nunavut	69.5554	-93.4972	1029	27.3	America/Cambridge_Bay	4	X0B	1124099415
1623	Youbou	Youbou	BC	British Columbia	48.8562	-124.1731	1086	122.8	America/Vancouver	4	V0R	1124809081
1624	Duchess	Duchess	AB	Alberta	50.7333	-111.9	1085	553.4	America/Edmonton	3	T0J	1124156956
1625	Saint-Frédéric	Saint-Frederic	QC	Quebec	46.3	-70.9667	1085	14.9	America/Montreal	4	G0N	1124436339
1626	Viking	Viking	AB	Alberta	53.0953	-111.7769	1083	292.5	America/Edmonton	3	T0B	1124502081
1627	Sioux Narrows-Nestor Falls	Sioux Narrows-Nestor Falls	ON	Ontario	49.4	-94.08	1082	0.5	America/Winnipeg	3	P0X	1124000587
1628	Whitecourt	Whitecourt	AB	Alberta	54.1417	-115.6833	1082	386	America/Edmonton	3	T7S	1124641551
1629	Repulse Bay	Repulse Bay	NU	Nunavut	66.5628	-86.3186	1082	2.6	America/Rankin_Inlet	4	X0C	1124398936
1630	Montréal-Est	Montreal-Est	QC	Quebec	45.63	-73.52	1082	299.4	America/Montreal	3	H1L H1B	1124000990
1631	King	King	ON	Ontario	44.0463	-79.6044	1082	73.6	America/Toronto	3	L7B L0G L3Y	1124001693
1632	Regina Beach	Regina Beach	SK	Saskatchewan	50.79	-104.99	1081	462.4	America/Regina	3	S0G	1124000991
1633	Saint-Patrice-de-Beaurivage	Saint-Patrice-de-Beaurivage	QC	Quebec	46.4167	-71.2333	1080	12.6	America/Montreal	4	G0S	1124097931
1634	Ootischenia	Ootischenia	BC	British Columbia	49.2916	-117.6323	1080	135.4	America/Vancouver	4	V1N	1124935527
1635	Hensall	Hensall	ON	Ontario	43.4345	-81.504	1078	569	America/Toronto	3	N0M	1124762629
1636	Bentley	Bentley	AB	Alberta	52.4667	-114.05	1078	482.2	America/Edmonton	3	T0C	1124340912
1637	Durham	Durham	NB	New Brunswick	47.7631	-66.0849	1076	2.6	America/Moncton	4	E8G	1124000804
1638	Sainte-Marthe	Sainte-Marthe	QC	Quebec	45.4	-74.3	1075	13.5	America/Montreal	3	J0P	1124191744
1639	Notre-Dame-du-Nord	Notre-Dame-du-Nord	QC	Quebec	47.6	-79.4833	1075	14.3	America/Montreal	3	J0Z	1124408692
1640	Pinehouse	Pinehouse	SK	Saskatchewan	55.5136	-106.5986	1074	142.9	America/Regina	3	S0J	1124001604
1641	Saint-Aimé-des-Lacs	Saint-Aime-des-Lacs	QC	Quebec	47.6833	-70.3	1073	11.6	America/Montreal	4	G0T	1124001325
1642	Lac-Drolet	Lac-Drolet	QC	Quebec	45.72	-70.85	1071	8.6	America/Montreal	4	G0Y	1124120357
1643	Preeceville	Preeceville	SK	Saskatchewan	51.958	-102.6673	1070	0.7	America/Regina	3	S0A	1124064523
1644	Maple Creek No. 111	Maple Creek No. 111	SK	Saskatchewan	49.8044	-109.6508	1068	0.3	America/Regina	4	S0N	1124000783
1645	Harbour Main-Chapel's Cove-Lakeview	Harbour Main-Chapel's Cove-Lakeview	NL	Newfoundland and Labrador	47.4337	-53.1458	1067	50.6	America/St_Johns	3	A0A	1124000035
1646	Saint-Wenceslas	Saint-Wenceslas	QC	Quebec	46.1667	-72.3333	1064	13.3	America/Montreal	4	G0Z	1124947290
1647	Weyburn No. 67	Weyburn No. 67	SK	Saskatchewan	49.6535	-103.8348	1064	1.3	America/Regina	4	S0C	1124000632
1648	Birch Hills	Birch Hills	SK	Saskatchewan	52.9833	-105.4333	1064	468.4	America/Regina	3	S0J	1124520497
1649	Wedgeport	Wedgeport	NS	Nova Scotia	43.7323	-65.9797	1061	109.3	America/Halifax	4	B0W	1124599537
1650	Kerrobert	Kerrobert	SK	Saskatchewan	51.92	-109.1272	1061	141.7	America/Regina	3	S0L	1124941446
1651	Havelock	Havelock	NB	New Brunswick	45.9523	-65.3885	1061	3	America/Moncton	4	E4Z	1124740292
1652	Eston	Eston	SK	Saskatchewan	51.15	-108.75	1061	390.3	America/Regina	3	S0L	1124212993
1653	Sainte-Geneviève-de-Batiscan	Sainte-Genevieve-de-Batiscan	QC	Quebec	46.5333	-72.3333	1060	10.8	America/Montreal	3	G0X	1124685530
1654	Saint-Justin	Saint-Justin	QC	Quebec	46.25	-73.0833	1060	13.5	America/Montreal	4	J0K	1124449723
1655	Saint-Norbert	Saint-Norbert	QC	Quebec	46.1667	-73.3167	1059	14.1	America/Montreal	3	J0K	1124000928
1656	Schreiber	Schreiber	ON	Ontario	48.8167	-87.2667	1059	28.8	America/Toronto	3	P0T	1124663303
1657	Trochu	Trochu	AB	Alberta	51.8236	-113.2328	1058	381.1	America/Edmonton	3	T0M	1124642144
1658	Botsford	Botsford	NB	New Brunswick	46.1145	-63.9804	1058	3.5	America/Moncton	4	E4M	1124000452
1659	Riviere-Ouelle	Riviere-Ouelle	QC	Quebec	47.4333	-70.0167	1058	18.6	America/Montreal	3	G0L	1124401890
1660	Greenwich	Greenwich	NB	New Brunswick	45.5112	-66.1229	1058	9.2	America/Moncton	4	E5M	1124001377
1661	Stukely-Sud	Stukely-Sud	QC	Quebec	45.3167	-72.4167	1058	15.8	America/Montreal	4	J0E	1124476796
1662	Saint-Georges-de-Clarenceville	Saint-Georges-de-Clarenceville	QC	Quebec	45.0667	-73.25	1056	16.6	America/Montreal	3	J0J	1124963246
1663	Sainte-Thérèse-de-Gaspé	Sainte-Therese-de-Gaspe	QC	Quebec	48.4167	-64.4167	1055	31.5	America/Montreal	3	G0C	1124000271
1664	Beachburg	Beachburg	ON	Ontario	45.7303	-76.8559	1054	242.8	America/Toronto	3	K0J	1124185620
1665	Desbiens	Desbiens	QC	Quebec	48.4167	-71.95	1053	101.1	America/Montreal	4	G0W	1124443927
1666	Clyde River	Clyde River	NU	Nunavut	70.4632	-68.4822	1053	9.9	America/Iqaluit	4	X0A	1124801172
1667	La Macaza	La Macaza	QC	Quebec	46.3667	-74.7667	1053	6.5	America/Montreal	3	J0T	1124760668
1668	Souris	Souris	PE	Prince Edward Island	46.3554	-62.2542	1053	303.7	America/Halifax	3	C0A	1124838959
1669	Kindersley No. 290	Kindersley No. 290	SK	Saskatchewan	51.4894	-109.0979	1049	0.5	America/Regina	4	S0L	1124000416
1670	Laird	Laird	ON	Ontario	46.3833	-84.0667	1047	10.2	America/Detroit	4	P0S	1124000662
1671	Falher	Falher	AB	Alberta	55.7372	-117.2014	1047	376.4	America/Edmonton	3	T0H	1124001263
1672	Saint-Vallier	Saint-Vallier	QC	Quebec	46.8833	-70.8167	1046	23.4	America/Montreal	3	G0R	1124440624
1673	Coleraine	Coleraine	QC	Quebec	45.9649	-71.3734	1043	249.9	America/Montreal	3	G0N	1124793029
1674	Melita	Melita	MB	Manitoba	49.2681	-100.9958	1042	342.7	America/Winnipeg	3	R0M	1124113199
1675	Noonan	Noonan	NB	New Brunswick	45.9544	-66.4868	1042	13.7	America/Moncton	4	E3A	1124001109
1676	Sainte-Pétronille	Sainte-Petronille	QC	Quebec	46.85	-71.1333	1041	227.2	America/Montreal	3	G0A	1124000628
1677	Delisle	Delisle	SK	Saskatchewan	51.9254	-107.1333	1038	310.2	America/Regina	3	S0L	1124184784
1678	Bristol	Bristol	QC	Quebec	45.5333	-76.4667	1036	5	America/Montreal	3	J0X	1124215672
1679	Mahone Bay	Mahone Bay	NS	Nova Scotia	44.4489	-64.3819	1036	332.1	America/Halifax	3	B0J	1124406380
1680	Waldheim	Waldheim	SK	Saskatchewan	52.65	-106.6167	1035	525.5	America/Regina	3	S0K	1124273730
1681	Saint-Sylvestre	Saint-Sylvestre	QC	Quebec	46.3667	-71.2333	1035	7.1	America/Montreal	3	G0S	1124754541
1683	Onoway	Onoway	AB	Alberta	53.7011	-114.1981	1029	310.3	America/Edmonton	3	T0E	1124983122
1684	Saint-Stanislas	Saint-Stanislas	QC	Quebec	46.6167	-72.4	1029	11.5	America/Montreal	3	G0X	1124711165
1685	Malpeque	Malpeque	PE	Prince Edward Island	46.5	-63.6667	1029	8.1	America/Halifax	3	C0B	1124663926
1686	Plantagenet	Plantagenet	ON	Ontario	45.5321	-74.9956	1027	260.5	America/Toronto	3	K0B	1124496473
1687	Longue-Rive	Longue-Rive	QC	Quebec	48.55	-69.25	1026	3.3	America/Montreal	3	G0T	1124001270
1688	Davidson	Davidson	SK	Saskatchewan	51.2667	-105.9667	1025	228.4	America/Regina	3	S0G	1124057902
1689	Plaster Rock	Plaster Rock	NB	New Brunswick	46.8833	-67.3833	1023	336.1	America/Moncton	3	E7G	1124983558
1690	Valemount	Valemount	BC	British Columbia	52.8284	-119.2659	1021	197.6	America/Vancouver	4	V0E	1124899599
1691	Saint-Léonard-de-Portneuf	Saint-Leonard-de-Portneuf	QC	Quebec	46.8833	-71.9167	1019	7.2	America/Montreal	4	G0A	1124001565
1692	Alberta Beach	Alberta Beach	AB	Alberta	53.6767	-114.35	1018	507.1	America/Edmonton	3	T0E	1124000690
1693	Saint-Narcisse-de-Rimouski	Saint-Narcisse-de-Rimouski	QC	Quebec	48.28	-68.43	1017	6.2	America/Montreal	4	G0K	1124000363
1694	Saint-Bonaventure	Saint-Bonaventure	QC	Quebec	45.9667	-72.6833	1017	12.9	America/Montreal	4	J0C	1124324069
1695	Longlaketon No. 219	Longlaketon No. 219	SK	Saskatchewan	50.9386	-104.6913	1016	1	America/Regina	4	S0G	1124000772
1696	Papineau-Cameron	Papineau-Cameron	ON	Ontario	46.3	-78.7333	1016	1.8	America/Toronto	4	P0H	1124000867
1697	Assiginack	Assiginack	ON	Ontario	45.7333	-81.8	1013	4.5	America/Toronto	3	P0P	1124000091
1698	Brébeuf	Brebeuf	QC	Quebec	46.0667	-74.6667	1012	27.9	America/Montreal	4	J0T	1124001084
1699	Hudson Hope	Hudson Hope	BC	British Columbia	56.0316	-121.9057	1012	1.1	America/Dawson_Creek	3	V0C	1124260692
1700	Prince	Prince	ON	Ontario	46.5333	-84.5	1010	11.8	America/Toronto	3	P6A	1124000733
1701	Baie-du-Febvre	Baie-du-Febvre	QC	Quebec	46.13	-72.72	1010	10.4	America/Montreal	3	J0G	1124218916
1702	Durham-Sud	Durham-Sud	QC	Quebec	45.6667	-72.3333	1008	10.8	America/Montreal	4	J0H	1124105436
1703	Melbourne	Melbourne	QC	Quebec	45.58	-72.17	1004	5.8	America/Montreal	3	J0B	1124850489
1704	Nipawin No. 487	Nipawin No. 487	SK	Saskatchewan	53.2881	-104.0544	1004	1.1	America/Regina	4	S0E	1124001339
1705	Duck Lake No. 463	Duck Lake No. 463	SK	Saskatchewan	52.9596	-106.2089	1004	1	America/Regina	4	S0K S6V	1124001661
1706	Oyen	Oyen	AB	Alberta	51.3522	-110.4739	1001	189.6	America/Edmonton	3	T0J	1124000494
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
1	1667841299086	defaultUser1667841299086
2	1667846657815	masterServicesData1667846657815
3	1668497938732	provinceCities1668497938732
\.


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.service ("serviceId", "serviceName", "isActive", price, "updatedAt", "createdAt", "createdBy", priority) FROM stdin;
1	Roof moss removal	1	0	2023-03-07 12:51:51.985729	2023-01-17 16:19:07.187294	default	1
2	Gutter cleaning from inside	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	2
3	Gutter cleaning from outside	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	3
4	Window washing	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	4
5	Awning washing	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	5
6	Stylites washing	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	7
7	Vinyl Sidings Soft wash	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	6
20	Garage gutter cleaning from outside	1	0	2023-02-28 22:33:08.208587	2023-01-17 16:19:07.187294	default	10
18	Garage roof moss removal	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	8
19	Garage gutter cleaning from inside	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	9
8	Stucco pressure washing	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	16
9	Side walk pressure washing	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	12
10	Drive way pressure washing	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	11
11	Front stairs pressure washing	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	14
12	Backyard pressure washing	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	13
13	Downspout fixin	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	17
17	Back patio pressure washing	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	15
14	Leak fixing	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	18
15	Tile replacement	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	20
16	Tile repair	1	0	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	default	19
21	Painting	0	0	2023-02-28 22:34:50.925225	2023-01-17 16:19:07.187294	default	22
89	Interior Cleaning	1	0	2023-02-28 22:36:14.981071	2023-02-28 22:34:36.120117	admin admin	21
90	Gutter Guard Installation	1	1	2023-03-09 06:35:31.988831	2023-03-09 06:35:31.988831	admin admin	23
\.


--
-- Data for Name: typeorm_metadata; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.typeorm_metadata (type, database, schema, "table", name, value) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public."user" (id, first_name, last_name, email, mobile_no, password, is_login, is_active, roles, "createdBy", is_verified, verified_at, "updatedAt", "createdAt", is_deleted, deleted_at, deleted_by) FROM stdin;
1	admin	admin	admin@simsanfrasermain.com	9898989898	$2a$10$dWs7A4iuznzn8It6kfOVE.SWIJjkpTrW8zngxHmEZUlfjEAXDxHYq	0	1	admin	default	t	\N	2023-01-17 16:19:07.187294	2023-01-17 16:19:07.187294	0	\N	\N
8	Matt	Nish	sandeep9993@gmail.com	6043581354	$2a$10$xUdFQ7OJASVtQyd6y/zQu.Ql7pEehnTFA4Tr1FBSxXqR28O5YzEz6	0	1	sub_admin	admin admin	t	2023-03-09 05:51:12.553	2023-03-09 05:51:12.556267	2023-03-09 05:49:40.710864	0	\N	\N
9	Vikas	Arora	va7869909@gmail.com	9888222730	$2a$10$lw0jxcAaFDdqf4pBI0NFRugkhuaMQraZwyT70bQ6bwjjEo2d52AtS	0	1	admin	admin admin	f	\N	2023-03-11 15:47:44.13825	2023-03-11 15:47:14.767591	1	2023-03-11 15:47:44.134	1
\.


--
-- Data for Name: user_verification; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_verification (id, token, type, "updatedAt", "createdAt", "userIdId") FROM stdin;
7	792640	otp	2023-03-09 05:49:40.719589	2023-03-09 05:49:40.719589	8
8	661658	otp	2023-03-11 15:47:14.77994	2023-03-11 15:47:14.77994	9
\.


--
-- Name: configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.configurations_id_seq', 7, true);


--
-- Name: form_formId_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public."form_formId_seq"', 44, true);


--
-- Name: form_to_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.form_to_services_id_seq', 380, true);


--
-- Name: location_locationId_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public."location_locationId_seq"', 1706, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.migrations_id_seq', 3, true);


--
-- Name: service_serviceId_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public."service_serviceId_seq"', 90, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.user_id_seq', 9, true);


--
-- Name: user_verification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.user_verification_id_seq', 8, true);


--
-- Name: form PK_33c609c116b70de2102ccf364f4; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.form
    ADD CONSTRAINT "PK_33c609c116b70de2102ccf364f4" PRIMARY KEY ("formId");


--
-- Name: user_verification PK_679edeb6fcfcbc4c094573e27e7; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_verification
    ADD CONSTRAINT "PK_679edeb6fcfcbc4c094573e27e7" PRIMARY KEY (id);


--
-- Name: location PK_8b51e14a3447c3df460c1907acb; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT "PK_8b51e14a3447c3df460c1907acb" PRIMARY KEY ("locationId");


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: service PK_a33c7dfb23f788d7a9a0b7044da; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT "PK_a33c7dfb23f788d7a9a0b7044da" PRIMARY KEY ("serviceId");


--
-- Name: form_to_services PK_ab314c3a6bcb5e8ba806d5f84cb; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.form_to_services
    ADD CONSTRAINT "PK_ab314c3a6bcb5e8ba806d5f84cb" PRIMARY KEY (id);


--
-- Name: user PK_cace4a159ff9f2512dd42373760; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY (id);


--
-- Name: configurations PK_ef9fc29709cc5fc66610fc6a664; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT "PK_ef9fc29709cc5fc66610fc6a664" PRIMARY KEY (id);


--
-- Name: user_verification REL_1a390dc6c0e1182eab696d13f8; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_verification
    ADD CONSTRAINT "REL_1a390dc6c0e1182eab696d13f8" UNIQUE ("userIdId");


--
-- Name: service UQ_92d833ca57e4bc0e2cd0914e0af; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT "UQ_92d833ca57e4bc0e2cd0914e0af" UNIQUE ("serviceName");


--
-- Name: user UQ_e12875dfb3b1d92d7d7c5377e22; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e22" UNIQUE (email);


--
-- Name: user_verification FK_1a390dc6c0e1182eab696d13f80; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_verification
    ADD CONSTRAINT "FK_1a390dc6c0e1182eab696d13f80" FOREIGN KEY ("userIdId") REFERENCES public."user"(id);


--
-- Name: form_to_services FK_b30a0404a01cd6714a00e450272; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.form_to_services
    ADD CONSTRAINT "FK_b30a0404a01cd6714a00e450272" FOREIGN KEY ("serviceId") REFERENCES public.service("serviceId");


--
-- Name: form_to_services FK_c1f6fb3d5d20fffaae0af5ec34a; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.form_to_services
    ADD CONSTRAINT "FK_c1f6fb3d5d20fffaae0af5ec34a" FOREIGN KEY ("formId") REFERENCES public.form("formId");


--
-- PostgreSQL database dump complete
--

