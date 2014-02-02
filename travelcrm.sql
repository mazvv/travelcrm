--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: visibility_enum; Type: TYPE; Schema: public; Owner: mazvv
--

CREATE TYPE visibility_enum AS ENUM (
    'all',
    'own'
);


ALTER TYPE public.visibility_enum OWNER TO mazvv;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: attachments; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE attachments (
    id integer NOT NULL,
    resources_id integer NOT NULL
);


ALTER TABLE public.attachments OWNER TO mazvv;

--
-- Name: _attachments_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _attachments_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._attachments_rid_seq OWNER TO mazvv;

--
-- Name: _attachments_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _attachments_rid_seq OWNED BY attachments.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE companies (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.companies OWNER TO mazvv;

--
-- Name: _companies_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _companies_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._companies_rid_seq OWNER TO mazvv;

--
-- Name: _companies_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _companies_rid_seq OWNED BY companies.id;


--
-- Name: companies_structures; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE companies_structures (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    companies_id integer NOT NULL,
    parent_id integer,
    name character varying(32) NOT NULL
);


ALTER TABLE public.companies_structures OWNER TO mazvv;

--
-- Name: _companies_structures_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _companies_structures_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._companies_structures_rid_seq OWNER TO mazvv;

--
-- Name: _companies_structures_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _companies_structures_rid_seq OWNED BY companies_structures.id;


--
-- Name: currencies; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE currencies (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    iso_code character varying(3) NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.currencies OWNER TO mazvv;

--
-- Name: _currencies_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _currencies_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._currencies_rid_seq OWNER TO mazvv;

--
-- Name: _currencies_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _currencies_rid_seq OWNED BY currencies.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employees (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    attachments_id integer,
    first_name character varying(32) NOT NULL,
    last_name character varying(32) NOT NULL,
    second_name character varying(32)
);


ALTER TABLE public.employees OWNER TO mazvv;

--
-- Name: _employees_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _employees_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._employees_rid_seq OWNER TO mazvv;

--
-- Name: _employees_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _employees_rid_seq OWNED BY employees.id;


--
-- Name: groups_navigations; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE groups_navigations (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    groups_id integer,
    parent_id integer,
    name character varying(32) NOT NULL,
    url character varying(128) NOT NULL,
    icon_cls character varying(32),
    "position" integer NOT NULL
);


ALTER TABLE public.groups_navigations OWNER TO mazvv;

--
-- Name: _groups_navigations_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _groups_navigations_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._groups_navigations_rid_seq OWNER TO mazvv;

--
-- Name: _groups_navigations_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _groups_navigations_rid_seq OWNED BY groups_navigations.id;


--
-- Name: groups_permisions; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE groups_permisions (
    id integer NOT NULL,
    resources_types_id integer NOT NULL,
    groups_id integer NOT NULL,
    permissions character varying[]
);


ALTER TABLE public.groups_permisions OWNER TO mazvv;

--
-- Name: _groups_permisions_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _groups_permisions_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._groups_permisions_rid_seq OWNER TO mazvv;

--
-- Name: _groups_permisions_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _groups_permisions_rid_seq OWNED BY groups_permisions.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE groups (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.groups OWNER TO mazvv;

--
-- Name: _groups_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _groups_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._groups_rid_seq OWNER TO mazvv;

--
-- Name: _groups_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _groups_rid_seq OWNED BY groups.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE regions (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    parent_id integer,
    name character varying(32) NOT NULL
);


ALTER TABLE public.regions OWNER TO mazvv;

--
-- Name: _regions_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _regions_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._regions_rid_seq OWNER TO mazvv;

--
-- Name: _regions_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _regions_rid_seq OWNED BY regions.id;


--
-- Name: resources_logs; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE resources_logs (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    modifier_id integer NOT NULL,
    comment character varying(512),
    modifydt timestamp without time zone
);


ALTER TABLE public.resources_logs OWNER TO mazvv;

--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _resources_logs_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._resources_logs_rid_seq OWNER TO mazvv;

--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _resources_logs_rid_seq OWNED BY resources_logs.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE resources (
    id integer NOT NULL,
    resources_types_id integer NOT NULL,
    status integer,
    owner_id integer NOT NULL
);


ALTER TABLE public.resources OWNER TO mazvv;

--
-- Name: _resources_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _resources_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._resources_rid_seq OWNER TO mazvv;

--
-- Name: _resources_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _resources_rid_seq OWNED BY resources.id;


--
-- Name: resources_types; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE resources_types (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    name character varying(32) NOT NULL,
    humanize character varying(32) NOT NULL,
    resource_name character varying(32) NOT NULL,
    module character varying(128) NOT NULL,
    settings text,
    description character varying(128)
);


ALTER TABLE public.resources_types OWNER TO mazvv;

--
-- Name: _resources_types_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _resources_types_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._resources_types_rid_seq OWNER TO mazvv;

--
-- Name: _resources_types_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _resources_types_rid_seq OWNED BY resources_types.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(128),
    password character varying(128) NOT NULL,
    employees_id integer
);


ALTER TABLE public.users OWNER TO mazvv;

--
-- Name: _users_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _users_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._users_rid_seq OWNER TO mazvv;

--
-- Name: _users_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _users_rid_seq OWNED BY users.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO mazvv;

--
-- Name: companies_positions; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE companies_positions (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    structure_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.companies_positions OWNER TO mazvv;

--
-- Name: companies_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE companies_positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.companies_positions_id_seq OWNER TO mazvv;

--
-- Name: companies_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE companies_positions_id_seq OWNED BY companies_positions.id;


--
-- Name: employees_appointments_h; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employees_appointments_h (
    id integer NOT NULL,
    resources_id integer NOT NULL,
    appointment_date date
);


ALTER TABLE public.employees_appointments_h OWNER TO mazvv;

--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE employees_appointments_h_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_appointments_h_id_seq OWNER TO mazvv;

--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE employees_appointments_h_id_seq OWNED BY employees_appointments_h.id;


--
-- Name: employees_appointments_r; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employees_appointments_r (
    id integer NOT NULL,
    employees_appointments_h_id integer NOT NULL,
    employees_id integer NOT NULL,
    companies_positions_id integer NOT NULL
);


ALTER TABLE public.employees_appointments_r OWNER TO mazvv;

--
-- Name: employees_appointments_r_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE employees_appointments_r_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_appointments_r_id_seq OWNER TO mazvv;

--
-- Name: employees_appointments_r_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE employees_appointments_r_id_seq OWNED BY employees_appointments_r.id;


--
-- Name: positions_navigations; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE positions_navigations (
    id integer NOT NULL,
    companies_positions_id integer,
    parent_id integer,
    name character varying(32) NOT NULL,
    url character varying(128) NOT NULL,
    icon_cls character varying(32),
    "position" integer NOT NULL,
    resources_id integer NOT NULL
);


ALTER TABLE public.positions_navigations OWNER TO mazvv;

--
-- Name: positions_navigations_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE positions_navigations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.positions_navigations_id_seq OWNER TO mazvv;

--
-- Name: positions_navigations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE positions_navigations_id_seq OWNED BY positions_navigations.id;


--
-- Name: positions_permisions; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE positions_permisions (
    id integer NOT NULL,
    resources_types_id integer NOT NULL,
    companies_positions_id integer NOT NULL,
    permisions character varying[],
    companies_structures_id integer,
    scope_type character varying(12)
);


ALTER TABLE public.positions_permisions OWNER TO mazvv;

--
-- Name: positions_permisions_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE positions_permisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.positions_permisions_id_seq OWNER TO mazvv;

--
-- Name: positions_permisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE positions_permisions_id_seq OWNED BY positions_permisions.id;


--
-- Name: users_groups; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE users_groups (
    users_id integer NOT NULL,
    groups_id integer NOT NULL
);


ALTER TABLE public.users_groups OWNER TO mazvv;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY attachments ALTER COLUMN id SET DEFAULT nextval('_attachments_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('_companies_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY companies_positions ALTER COLUMN id SET DEFAULT nextval('companies_positions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY companies_structures ALTER COLUMN id SET DEFAULT nextval('_companies_structures_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY currencies ALTER COLUMN id SET DEFAULT nextval('_currencies_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employees ALTER COLUMN id SET DEFAULT nextval('_employees_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employees_appointments_h ALTER COLUMN id SET DEFAULT nextval('employees_appointments_h_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employees_appointments_r ALTER COLUMN id SET DEFAULT nextval('employees_appointments_r_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('_groups_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY groups_navigations ALTER COLUMN id SET DEFAULT nextval('_groups_navigations_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY groups_permisions ALTER COLUMN id SET DEFAULT nextval('_groups_permisions_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY positions_navigations ALTER COLUMN id SET DEFAULT nextval('positions_navigations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY positions_permisions ALTER COLUMN id SET DEFAULT nextval('positions_permisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY regions ALTER COLUMN id SET DEFAULT nextval('_regions_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resources ALTER COLUMN id SET DEFAULT nextval('_resources_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resources_logs ALTER COLUMN id SET DEFAULT nextval('_resources_logs_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resources_types ALTER COLUMN id SET DEFAULT nextval('_resources_types_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('_users_rid_seq'::regclass);


--
-- Name: _attachments_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_attachments_rid_seq', 1, false);


--
-- Name: _companies_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_companies_rid_seq', 13, true);


--
-- Name: _companies_structures_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_companies_structures_rid_seq', 32, true);


--
-- Name: _currencies_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_currencies_rid_seq', 8, true);


--
-- Name: _employees_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_employees_rid_seq', 5, true);


--
-- Name: _groups_navigations_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_groups_navigations_rid_seq', 27, true);


--
-- Name: _groups_permisions_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_groups_permisions_rid_seq', 35, true);


--
-- Name: _groups_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_groups_rid_seq', 5, true);


--
-- Name: _regions_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_regions_rid_seq', 6, true);


--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_logs_rid_seq', 4835, true);


--
-- Name: _resources_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_rid_seq', 793, true);


--
-- Name: _resources_types_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_types_rid_seq', 67, true);


--
-- Name: _users_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_users_rid_seq', 19, true);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY alembic_version (version_num) FROM stdin;
1dfcc639ee50
\.


--
-- Data for Name: attachments; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY attachments (id, resources_id) FROM stdin;
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY companies (id, resources_id, name) FROM stdin;
4	717	K & S Travel
5	729	Rainbow Travel
7	744	Case & Chem Travel
8	745	Thomas Cook, Travel Company
9	746	TUI Travel
10	747	Carnival Corp.
11	750	Desert Adventures Tourism LLC
13	759	OutDoor Center
3	716	Main Company
\.


--
-- Data for Name: companies_positions; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY companies_positions (id, resources_id, structure_id, name) FROM stdin;
4	772	32	Main Developer
\.


--
-- Name: companies_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('companies_positions_id_seq', 4, true);


--
-- Data for Name: companies_structures; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY companies_structures (id, resources_id, companies_id, parent_id, name) FROM stdin;
1	718	3	\N	Head Office
6	725	3	\N	Odessa filial
7	726	3	\N	Kiev filial
9	728	3	\N	Lviv filial
31	763	3	\N	Dnepr Filial
32	771	3	1	Administrators
\.


--
-- Data for Name: currencies; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY currencies (id, resources_id, iso_code, name) FROM stdin;
1	286	UAH	ua hrivna
2	287	USD	usd dollar
3	288	RUB	ru ruble
4	289	CAD	canada dollar
5	290	PLN	poland zloty
6	291	GBP	gb pound
7	292	CHF	switziland frank
8	306	EUR	euro
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employees (id, resources_id, attachments_id, first_name, last_name, second_name) FROM stdin;
2	784	\N	Vitalii	Mazur	
3	785	\N	Ruslan	Ostapenko	
4	786	\N	Oleg	Pogorelov	
5	787	\N	Irina	Mazur	V.
\.


--
-- Data for Name: employees_appointments_h; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employees_appointments_h (id, resources_id, appointment_date) FROM stdin;
1	789	2014-02-02
\.


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('employees_appointments_h_id_seq', 1, true);


--
-- Data for Name: employees_appointments_r; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employees_appointments_r (id, employees_appointments_h_id, employees_id, companies_positions_id) FROM stdin;
1	1	2	4
\.


--
-- Name: employees_appointments_r_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('employees_appointments_r_id_seq', 1, true);


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY groups (id, resources_id, name) FROM stdin;
\.


--
-- Data for Name: groups_navigations; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY groups_navigations (id, resources_id, groups_id, parent_id, name, url, icon_cls, "position") FROM stdin;
\.


--
-- Data for Name: groups_permisions; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY groups_permisions (id, resources_types_id, groups_id, permissions) FROM stdin;
\.


--
-- Data for Name: positions_navigations; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY positions_navigations (id, companies_positions_id, parent_id, name, url, icon_cls, "position", resources_id) FROM stdin;
9	4	8	Resource Types	/resources_types	\N	1	779
8	4	\N	System	/	fa fa-cog	3	778
7	4	\N	Home	/	fa fa-home	1	777
10	4	\N	HR	/	fa fa-group	2	780
14	4	10	Employees Appointments	/employees_appointments	\N	2	791
15	4	8	Users	/users	\N	2	792
16	4	8	Companies	/companies	\N	3	793
13	4	10	Employees	/employees	\N	1	790
\.


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('positions_navigations_id_seq', 16, true);


--
-- Data for Name: positions_permisions; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY positions_permisions (id, resources_types_id, companies_positions_id, permisions, companies_structures_id, scope_type) FROM stdin;
22	2	4	{view,add,edit,delete}	\N	all
35	65	4	{view,add,edit,delete}	\N	all
34	61	4	{view,add,edit,delete}	\N	all
32	59	4	{view,add,edit,delete}	\N	all
30	55	4	{view,add,edit,delete}	\N	all
26	47	4	{view,add,edit,delete}	\N	all
24	12	4	{view,add,edit,delete}	\N	all
37	67	4	{view,add,edit}	\N	all
21	1	4	{view}	\N	all
28	49	4	{view,delete}	\N	all
\.


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('positions_permisions_id_seq', 37, true);


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY regions (id, resources_id, parent_id, name) FROM stdin;
1	277	\N	Украина
2	278	\N	Россия
3	279	1	Киев
4	280	1	Одеса
5	281	1	Львов
6	282	2	Москва
\.


--
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY resources (id, resources_types_id, status, owner_id) FROM stdin;
728	55	0	2
745	49	0	2
746	49	0	2
747	49	0	2
784	47	0	2
785	47	0	2
787	47	0	2
786	47	0	2
769	12	0	2
30	12	1	2
31	12	0	2
32	12	0	2
33	12	0	2
34	12	0	2
35	12	0	2
36	12	0	2
772	59	0	2
788	12	0	2
706	12	0	2
771	55	0	2
734	55	0	2
750	49	0	2
759	49	0	2
729	49	0	2
716	49	0	2
717	49	0	2
789	67	0	2
708	12	0	2
773	12	0	2
743	55	0	2
790	65	0	2
763	55	0	2
718	49	0	2
723	12	0	2
791	65	0	2
775	12	0	2
37	12	0	2
38	12	0	2
39	12	0	2
40	12	0	2
43	12	0	2
10	12	0	2
792	65	0	2
12	12	0	2
14	12	0	2
44	12	0	2
16	12	0	2
45	12	0	2
2	2	0	2
3	2	0	2
84	2	0	2
83	2	1	2
301	43	0	2
300	43	0	2
793	65	0	2
764	12	0	2
274	12	0	2
283	12	0	2
296	12	0	2
777	65	0	2
778	65	0	2
779	65	0	2
780	65	0	2
286	41	0	2
287	41	0	2
288	41	0	2
289	41	0	2
290	41	0	2
291	41	0	2
292	41	0	2
306	41	0	2
277	39	0	2
279	39	0	2
280	39	0	2
281	39	0	2
278	39	1	2
282	39	1	2
725	55	0	2
726	55	0	2
744	49	0	2
\.


--
-- Data for Name: resources_logs; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY resources_logs (id, resources_id, modifier_id, comment, modifydt) FROM stdin;
142	83	2	\N	2013-12-07 16:38:38.11618
143	84	2	\N	2013-12-07 16:39:56.788641
144	3	2	\N	2013-12-07 16:41:27.65259
145	2	2	\N	2013-12-07 16:41:31.748494
146	83	2	\N	2013-12-07 16:58:05.802634
147	83	2	\N	2013-12-07 17:00:14.544264
4770	750	2	\N	2014-01-11 19:11:27.979876
2	10	2	\N	2013-11-16 19:00:14.24272
4	12	2	\N	2013-11-16 19:00:15.497284
6	14	2	\N	2013-11-16 19:00:16.696731
8	16	2	\N	2013-11-16 19:00:17.960761
12	30	2	\N	2013-11-23 19:26:00.193553
13	30	2	\N	2013-11-23 22:02:37.363677
14	10	2	\N	2013-11-23 22:11:01.634598
15	30	2	\N	2013-11-23 22:11:14.939938
16	30	2	\N	2013-11-23 22:11:38.396085
19	30	2	\N	2013-11-24 10:30:59.830287
20	30	2	\N	2013-11-24 10:31:22.936737
21	30	2	\N	2013-11-24 10:38:08.07328
22	30	2	\N	2013-11-24 10:38:10.703187
23	30	2	\N	2013-11-24 10:38:11.896934
24	30	2	\N	2013-11-24 10:42:19.397852
25	30	2	\N	2013-11-24 10:42:50.772172
26	30	2	\N	2013-11-24 10:45:56.399572
27	30	2	\N	2013-11-24 10:48:29.950669
28	30	2	\N	2013-11-24 10:49:23.616693
29	30	2	\N	2013-11-24 10:50:05.878643
30	30	2	\N	2013-11-24 10:51:02.465585
31	30	2	\N	2013-11-24 10:54:21.011765
32	30	2	\N	2013-11-24 10:54:28.775552
33	30	2	\N	2013-11-24 10:58:34.152869
34	30	2	\N	2013-11-24 10:58:36.766104
35	30	2	\N	2013-11-24 10:58:38.767749
36	30	2	\N	2013-11-24 10:58:42.533162
37	30	2	\N	2013-11-24 10:58:43.55758
38	30	2	\N	2013-11-24 10:58:47.40587
39	30	2	\N	2013-11-24 11:00:56.130675
40	30	2	\N	2013-11-24 11:01:17.637578
41	30	2	\N	2013-11-24 11:01:20.639413
42	30	2	\N	2013-11-24 11:01:25.957588
43	30	2	\N	2013-11-24 11:01:28.015301
44	30	2	\N	2013-11-24 11:01:49.505153
45	30	2	\N	2013-11-24 11:01:54.465064
46	30	2	\N	2013-11-24 11:01:56.828797
47	30	2	\N	2013-11-24 11:02:00.873006
48	30	2	\N	2013-11-24 11:02:06.385907
49	30	2	\N	2013-11-24 11:02:08.474309
50	30	2	\N	2013-11-24 11:02:11.823259
51	30	2	\N	2013-11-24 11:02:15.084044
52	30	2	\N	2013-11-24 11:23:59.150304
53	30	2	\N	2013-11-24 12:41:22.004561
54	30	2	\N	2013-11-24 12:41:27.704243
55	30	2	\N	2013-11-24 12:41:32.588516
66	16	2	\N	2013-11-30 12:57:27.26941
67	31	2	\N	2013-11-30 14:25:42.040654
68	32	2	\N	2013-11-30 14:27:55.708736
69	33	2	\N	2013-11-30 14:28:30.596329
70	34	2	\N	2013-11-30 14:29:07.205192
71	35	2	\N	2013-11-30 14:30:10.653134
72	36	2	\N	2013-11-30 14:31:39.751221
73	37	2	\N	2013-11-30 14:32:36.035677
74	38	2	\N	2013-11-30 14:55:27.691288
75	39	2	\N	2013-11-30 14:58:07.249714
76	40	2	\N	2013-11-30 14:58:34.364695
79	43	2	\N	2013-11-30 15:08:29.574538
80	43	2	\N	2013-11-30 15:08:52.114395
81	43	2	\N	2013-11-30 15:09:21.51485
82	44	2	\N	2013-11-30 15:09:54.961188
83	45	2	\N	2013-12-01 13:04:27.697583
84	45	2	\N	2013-12-01 13:04:40.716328
85	14	2	\N	2013-12-01 14:31:19.374571
87	12	2	\N	2013-12-01 18:21:35.266219
104	10	2	\N	2013-12-02 20:43:38.334769
130	10	2	\N	2013-12-06 21:10:25.807719
4796	769	2	\N	2014-01-22 22:21:45.451623
4820	16	2	\N	2014-02-01 21:09:43.821944
4771	750	2	\N	2014-01-11 19:16:04.780716
4798	716	2	\N	2014-01-25 16:04:57.379717
4821	785	2	\N	2014-02-01 21:23:03.546657
4822	784	2	\N	2014-02-01 21:23:07.460721
4823	786	2	\N	2014-02-01 21:23:12.871915
4824	787	2	\N	2014-02-01 21:23:26.294657
4825	746	2	\N	2014-02-01 21:30:30.08985
361	274	2	\N	2013-12-14 17:16:08.962259
365	277	2	\N	2013-12-14 18:56:05.189747
366	278	2	\N	2013-12-14 18:56:17.77025
367	279	2	\N	2013-12-14 18:56:45.919492
368	280	2	\N	2013-12-14 19:10:07.617582
369	281	2	\N	2013-12-14 19:10:25.311427
370	281	2	\N	2013-12-14 19:10:59.35028
371	281	2	\N	2013-12-14 19:12:14.211139
372	282	2	\N	2013-12-14 19:14:22.861495
373	278	2	\N	2013-12-14 19:14:33.853691
374	282	2	\N	2013-12-14 19:14:41.964012
375	283	2	\N	2013-12-14 19:16:35.738242
377	283	2	\N	2013-12-14 19:18:21.622933
386	286	2	\N	2013-12-14 20:46:34.653533
387	287	2	\N	2013-12-14 20:46:47.37835
388	288	2	\N	2013-12-14 20:47:08.024243
389	289	2	\N	2013-12-14 20:47:28.256516
390	290	2	\N	2013-12-14 20:52:40.953492
391	291	2	\N	2013-12-14 20:53:08.057165
392	292	2	\N	2013-12-14 20:53:33.598708
4799	771	2	\N	2014-01-25 16:05:28.799345
4800	771	2	\N	2014-01-25 16:05:38.705799
4801	772	2	\N	2014-01-25 16:06:28.321244
4826	788	2	\N	2014-02-01 22:03:21.899916
402	296	2	\N	2013-12-15 14:57:26.846239
408	300	2	\N	2013-12-15 15:48:08.698038
409	300	2	\N	2013-12-15 15:59:24.316288
410	300	2	\N	2013-12-15 16:16:20.700714
411	301	2	\N	2013-12-15 16:16:51.189423
412	300	2	\N	2013-12-15 16:19:25.308741
413	300	2	\N	2013-12-15 16:19:30.382192
422	306	2	\N	2013-12-15 21:45:32.990838
4802	773	2	\N	2014-01-25 23:45:37.762081
4827	789	2	\N	2014-02-02 16:45:11.830435
4804	775	2	\N	2014-01-26 15:30:50.636495
4828	3	2	\N	2014-02-02 17:45:50.239397
4829	780	2	\N	2014-02-02 17:53:21.606939
4830	790	2	\N	2014-02-02 17:53:42.973553
4831	791	2	\N	2014-02-02 17:54:20.864462
4832	792	2	\N	2014-02-02 17:54:57.706749
4806	777	2	\N	2014-01-26 18:18:05.196211
4807	778	2	\N	2014-01-26 18:18:24.059336
4808	779	2	\N	2014-01-26 18:18:45.188271
4809	780	2	\N	2014-01-26 18:20:19.519217
4833	793	2	\N	2014-02-02 18:36:15.702691
4834	790	2	\N	2014-02-02 18:39:14.383473
4781	759	2	\N	2014-01-12 14:43:37.177188
4812	784	2	\N	2014-01-26 21:12:24.209136
4813	784	2	\N	2014-01-26 21:13:10.546575
4814	784	2	\N	2014-01-26 21:13:20.058093
4815	784	2	\N	2014-01-26 21:13:24.693933
4816	785	2	\N	2014-01-26 21:14:41.919016
4817	786	2	\N	2014-01-26 21:15:00.370561
4818	784	2	\N	2014-01-26 21:20:14.635984
4819	784	2	\N	2014-01-26 21:20:34.941868
4789	763	2	\N	2014-01-12 19:51:49.157909
4790	764	2	\N	2014-01-12 20:33:53.3138
4120	16	2	\N	2014-01-01 13:19:09.979922
4131	14	2	\N	2014-01-01 18:45:07.902745
4144	706	2	\N	2014-01-03 16:12:41.015146
4145	706	2	\N	2014-01-03 16:13:23.197097
4732	708	2	\N	2014-01-04 11:40:10.44979
4733	708	2	\N	2014-01-04 12:38:12.601503
4737	716	2	\N	2014-01-04 19:45:33.799638
4738	717	2	\N	2014-01-04 19:47:17.449977
4739	718	2	\N	2014-01-04 20:53:19.171091
4744	723	2	\N	2014-01-04 23:58:55.624453
4746	725	2	\N	2014-01-05 01:09:00.405742
4747	726	2	\N	2014-01-05 01:09:15.602018
4749	728	2	\N	2014-01-05 01:13:50.125212
4751	729	2	\N	2014-01-05 12:33:41.287842
4756	734	2	\N	2014-01-05 12:36:48.48575
4765	743	2	\N	2014-01-05 13:20:17.173661
4766	744	2	\N	2014-01-09 21:48:12.51608
4767	745	2	\N	2014-01-09 21:53:45.746623
4768	746	2	\N	2014-01-09 21:53:59.747431
4769	747	2	\N	2014-01-09 21:54:24.766992
\.


--
-- Data for Name: resources_types; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY resources_types (id, resources_id, name, humanize, resource_name, module, settings, description) FROM stdin;
43	296	currencies_rates	Currencies Rates	CurrenciesRates	finbroker.admin.resources.currencies_rates	\N	\N
39	274	regions	Regions	Regions	finbroker.admin.resources.regions	\N	\N
41	283	currencies	Currencies	Currencies	finbroker.admin.resources.currencies	\N	\N
2	10	users	Users	Users	travelcrm.resources.users	\N	Users list
12	16	resources_types	Resources Types	ResourcesTypes	travelcrm.resources.resources_types	\N	Resources types list
47	706	employees	Employees	Employees	travelcrm.resources.employees	\N	Employees Container Datagrid
49	708	companies	Companies	Companies	travelcrm.resources.companies	\N	Companies container
55	723	companies_structures	Companies Structures	CompaniesStructures	travelcrm.resources.companies_structures	\N	Companies structures is a tree of company structure. It's can be offices, filials, departments and so and so
59	764	companies_positions	Companies Positions	CompaniesPositions	travelcrm.resources.companies_positions	\N	Companies positions is a point of company structure where emplyees can be appointed
61	769	positions_permisions	Positions Permisions	PositionsPermisions	travelcrm.resources.positions_permisions	\N	Permisions list of company structure position. It's list of resources and permisions
1	773		Home	Root	travelcrm.resources	\N	Home Page of Travelcrm
65	775	positions_navigations	Positions Navigations	PositionsNavigations	travelcrm.resources.positions_navigations	\N	Navigations list of company structure position.
67	788	employees_appointments	Employees Appointments	EmployeesAppointments	travelcrm.resources.employees_appointments	\N	Employees to positions of company appointments
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY users (id, resources_id, username, email, password, employees_id) FROM stdin;
2	3	mazvv	vitalii.mazur@gmail.com	mazvv	2
\.


--
-- Data for Name: users_groups; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY users_groups (users_id, groups_id) FROM stdin;
\.


--
-- Name: _attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT _attachments_pkey PRIMARY KEY (id);


--
-- Name: _companies_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT _companies_pkey PRIMARY KEY (id);


--
-- Name: _companies_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY companies_structures
    ADD CONSTRAINT _companies_structures_pkey PRIMARY KEY (id);


--
-- Name: _currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY currencies
    ADD CONSTRAINT _currencies_pkey PRIMARY KEY (id);


--
-- Name: _employees_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT _employees_pkey PRIMARY KEY (id);


--
-- Name: _groups_navigations_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY groups_navigations
    ADD CONSTRAINT _groups_navigations_pkey PRIMARY KEY (id);


--
-- Name: _groups_permisions_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY groups_permisions
    ADD CONSTRAINT _groups_permisions_pkey PRIMARY KEY (id);


--
-- Name: _groups_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT _groups_pkey PRIMARY KEY (id);


--
-- Name: _regions_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY regions
    ADD CONSTRAINT _regions_pkey PRIMARY KEY (id);


--
-- Name: _resources_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resources_logs
    ADD CONSTRAINT _resources_logs_pkey PRIMARY KEY (id);


--
-- Name: _resources_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT _resources_pkey PRIMARY KEY (id);


--
-- Name: _resources_types_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resources_types
    ADD CONSTRAINT _resources_types_pkey PRIMARY KEY (id);


--
-- Name: _users_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY users_groups
    ADD CONSTRAINT _users_groups_pkey PRIMARY KEY (users_id, groups_id);


--
-- Name: _users_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT _users_pkey PRIMARY KEY (id);


--
-- Name: companies_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY companies_positions
    ADD CONSTRAINT companies_positions_pkey PRIMARY KEY (id);


--
-- Name: currencies_iso_code_key; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY currencies
    ADD CONSTRAINT currencies_iso_code_key UNIQUE (iso_code);


--
-- Name: employees_appointments_h_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY employees_appointments_h
    ADD CONSTRAINT employees_appointments_h_pkey PRIMARY KEY (id);


--
-- Name: employees_appointments_r_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY employees_appointments_r
    ADD CONSTRAINT employees_appointments_r_pkey PRIMARY KEY (id);


--
-- Name: groups_name_key; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_name_key UNIQUE (name);


--
-- Name: positions_navigations_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY positions_navigations
    ADD CONSTRAINT positions_navigations_pkey PRIMARY KEY (id);


--
-- Name: positions_permisions_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY positions_permisions
    ADD CONSTRAINT positions_permisions_pkey PRIMARY KEY (id);


--
-- Name: resources_types_humanize_key; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resources_types
    ADD CONSTRAINT resources_types_humanize_key UNIQUE (humanize);


--
-- Name: resources_types_name_key; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resources_types
    ADD CONSTRAINT resources_types_name_key UNIQUE (name);


--
-- Name: unique_idx_resources_types_module; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resources_types
    ADD CONSTRAINT unique_idx_resources_types_module UNIQUE (module, resource_name);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_username_key; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_group_permissions_permissions; Type: INDEX; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE INDEX idx_group_permissions_permissions ON groups_permisions USING btree (permissions);


--
-- Name: companies_positions_structure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY companies_positions
    ADD CONSTRAINT companies_positions_structure_id_fkey FOREIGN KEY (structure_id) REFERENCES companies_structures(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_attachments_id_employees; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT fk_attachments_id_employees FOREIGN KEY (attachments_id) REFERENCES attachments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_companies_id_companies_structures; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY companies_structures
    ADD CONSTRAINT fk_companies_id_companies_structures FOREIGN KEY (companies_id) REFERENCES companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_companies_positions_id_positions_permisions; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY positions_permisions
    ADD CONSTRAINT fk_companies_positions_id_positions_permisions FOREIGN KEY (companies_positions_id) REFERENCES companies_positions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_companies_structures_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY companies_structures
    ADD CONSTRAINT fk_companies_structures_parent_id FOREIGN KEY (parent_id) REFERENCES companies_structures(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_groups_id_groups_permisions; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY groups_permisions
    ADD CONSTRAINT fk_groups_id_groups_permisions FOREIGN KEY (groups_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_groups_navigations_groups_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY groups_navigations
    ADD CONSTRAINT fk_groups_navigations_groups_id FOREIGN KEY (groups_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_modifier_users_id_resources_log; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resources_logs
    ADD CONSTRAINT fk_modifier_users_id_resources_log FOREIGN KEY (modifier_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_owner_id_resources; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT fk_owner_id_resources FOREIGN KEY (owner_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_parent_id_groups_navigations; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY groups_navigations
    ADD CONSTRAINT fk_parent_id_groups_navigations FOREIGN KEY (parent_id) REFERENCES groups_navigations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_positions_permisions_companies_structures_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY positions_permisions
    ADD CONSTRAINT fk_positions_permisions_companies_structures_id FOREIGN KEY (companies_structures_id) REFERENCES companies_structures(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_regions_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY regions
    ADD CONSTRAINT fk_regions_parent_id FOREIGN KEY (parent_id) REFERENCES regions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_attachments; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT fk_resources_id_attachments FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_companies; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT fk_resources_id_companies FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_companies_positions; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY companies_positions
    ADD CONSTRAINT fk_resources_id_companies_positions FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_companies_structures; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY companies_structures
    ADD CONSTRAINT fk_resources_id_companies_structures FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_currencies; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY currencies
    ADD CONSTRAINT fk_resources_id_currencies FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_employees; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT fk_resources_id_employees FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_groups; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT fk_resources_id_groups FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_groups_navigations; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY groups_navigations
    ADD CONSTRAINT fk_resources_id_groups_navigations FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_regions; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY regions
    ADD CONSTRAINT fk_resources_id_regions FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_resources_log; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resources_logs
    ADD CONSTRAINT fk_resources_id_resources_log FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_resources_types; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resources_types
    ADD CONSTRAINT fk_resources_id_resources_types FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_users; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_resources_id_users FOREIGN KEY (resources_id) REFERENCES resources(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_type_id_groups_permisions; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY groups_permisions
    ADD CONSTRAINT fk_resources_type_id_groups_permisions FOREIGN KEY (resources_types_id) REFERENCES resources_types(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_type_id_positions_permissions; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY positions_permisions
    ADD CONSTRAINT fk_resources_type_id_positions_permissions FOREIGN KEY (resources_types_id) REFERENCES resources_types(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_types_id_resources; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT fk_resources_types_id_resources FOREIGN KEY (resources_types_id) REFERENCES resources_types(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_users_groups_groups_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY users_groups
    ADD CONSTRAINT fk_users_groups_groups_id FOREIGN KEY (groups_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_users_groups_users_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY users_groups
    ADD CONSTRAINT fk_users_groups_users_id FOREIGN KEY (users_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

