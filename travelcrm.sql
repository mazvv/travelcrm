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
-- Name: attachment; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE attachment (
    id integer NOT NULL,
    resource_id integer NOT NULL
);


ALTER TABLE public.attachment OWNER TO mazvv;

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

ALTER SEQUENCE _attachments_rid_seq OWNED BY attachment.id;


--
-- Name: currency; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE currency (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(3) NOT NULL
);


ALTER TABLE public.currency OWNER TO mazvv;

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

ALTER SEQUENCE _currencies_rid_seq OWNED BY currency.id;


--
-- Name: employee; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employee (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    attachment_id integer,
    first_name character varying(32) NOT NULL,
    last_name character varying(32) NOT NULL,
    second_name character varying(32)
);


ALTER TABLE public.employee OWNER TO mazvv;

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

ALTER SEQUENCE _employees_rid_seq OWNED BY employee.id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE region (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    parent_id integer,
    name character varying(32) NOT NULL
);


ALTER TABLE public.region OWNER TO mazvv;

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

ALTER SEQUENCE _regions_rid_seq OWNED BY region.id;


--
-- Name: resource_log; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE resource_log (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    comment character varying(512),
    modifydt timestamp without time zone
);


ALTER TABLE public.resource_log OWNER TO mazvv;

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

ALTER SEQUENCE _resources_logs_rid_seq OWNED BY resource_log.id;


--
-- Name: resource; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE resource (
    id integer NOT NULL,
    resource_type_id integer NOT NULL,
    status integer,
    structure_id integer NOT NULL
);


ALTER TABLE public.resource OWNER TO mazvv;

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

ALTER SEQUENCE _resources_rid_seq OWNED BY resource.id;


--
-- Name: resource_type; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE resource_type (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    humanize character varying(32) NOT NULL,
    resource_name character varying(32) NOT NULL,
    module character varying(128) NOT NULL,
    settings text,
    description character varying(128)
);


ALTER TABLE public.resource_type OWNER TO mazvv;

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

ALTER SEQUENCE _resources_types_rid_seq OWNED BY resource_type.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(128),
    password character varying(128) NOT NULL,
    employee_id integer NOT NULL
);


ALTER TABLE public."user" OWNER TO mazvv;

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

ALTER SEQUENCE _users_rid_seq OWNED BY "user".id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO mazvv;

--
-- Name: appointment_header; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE appointment_header (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    appointment_date date
);


ALTER TABLE public.appointment_header OWNER TO mazvv;

--
-- Name: appointment_row; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE appointment_row (
    id integer NOT NULL,
    appointment_header_id integer NOT NULL,
    employee_id integer NOT NULL,
    position_id integer NOT NULL
);


ALTER TABLE public.appointment_row OWNER TO mazvv;

--
-- Name: position; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE "position" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    structure_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public."position" OWNER TO mazvv;

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

ALTER SEQUENCE companies_positions_id_seq OWNED BY "position".id;


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

ALTER SEQUENCE employees_appointments_h_id_seq OWNED BY appointment_header.id;


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

ALTER SEQUENCE employees_appointments_r_id_seq OWNED BY appointment_row.id;


--
-- Name: navigation; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE navigation (
    id integer NOT NULL,
    position_id integer,
    parent_id integer,
    name character varying(32) NOT NULL,
    url character varying(128) NOT NULL,
    icon_cls character varying(32),
    sort_order integer NOT NULL,
    resource_id integer NOT NULL
);


ALTER TABLE public.navigation OWNER TO mazvv;

--
-- Name: permision; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE permision (
    id integer NOT NULL,
    resource_type_id integer NOT NULL,
    position_id integer NOT NULL,
    permisions character varying[],
    structure_id integer,
    scope_type character varying(12)
);


ALTER TABLE public.permision OWNER TO mazvv;

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

ALTER SEQUENCE positions_navigations_id_seq OWNED BY navigation.id;


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

ALTER SEQUENCE positions_permisions_id_seq OWNED BY permision.id;


--
-- Name: structure; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE structure (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    parent_id integer,
    name character varying(32) NOT NULL
);


ALTER TABLE public.structure OWNER TO mazvv;

--
-- Name: structures_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE structures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.structures_id_seq OWNER TO mazvv;

--
-- Name: structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE structures_id_seq OWNED BY structure.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment_header ALTER COLUMN id SET DEFAULT nextval('employees_appointments_h_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment_row ALTER COLUMN id SET DEFAULT nextval('employees_appointments_r_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY attachment ALTER COLUMN id SET DEFAULT nextval('_attachments_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY currency ALTER COLUMN id SET DEFAULT nextval('_currencies_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee ALTER COLUMN id SET DEFAULT nextval('_employees_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY navigation ALTER COLUMN id SET DEFAULT nextval('positions_navigations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY permision ALTER COLUMN id SET DEFAULT nextval('positions_permisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "position" ALTER COLUMN id SET DEFAULT nextval('companies_positions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY region ALTER COLUMN id SET DEFAULT nextval('_regions_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource ALTER COLUMN id SET DEFAULT nextval('_resources_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource_log ALTER COLUMN id SET DEFAULT nextval('_resources_logs_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource_type ALTER COLUMN id SET DEFAULT nextval('_resources_types_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure ALTER COLUMN id SET DEFAULT nextval('structures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('_users_rid_seq'::regclass);


--
-- Name: _attachments_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_attachments_rid_seq', 1, false);


--
-- Name: _currencies_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_currencies_rid_seq', 48, true);


--
-- Name: _employees_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_employees_rid_seq', 6, true);


--
-- Name: _regions_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_regions_rid_seq', 6, true);


--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_logs_rid_seq', 4924, true);


--
-- Name: _resources_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_rid_seq', 863, true);


--
-- Name: _resources_types_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_types_rid_seq', 68, true);


--
-- Name: _users_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_users_rid_seq', 22, true);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY alembic_version (version_num) FROM stdin;
1e1476800d39
\.


--
-- Data for Name: appointment_header; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY appointment_header (id, resource_id, appointment_date) FROM stdin;
1	789	2014-02-02
\.


--
-- Data for Name: appointment_row; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY appointment_row (id, appointment_header_id, employee_id, position_id) FROM stdin;
1	1	2	4
\.


--
-- Data for Name: attachment; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY attachment (id, resource_id) FROM stdin;
\.


--
-- Name: companies_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('companies_positions_id_seq', 4, true);


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY currency (id, resource_id, iso_code) FROM stdin;
10	804	USD
43	848	UAH
44	849	RUB
45	850	EUR
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employee (id, resource_id, attachment_id, first_name, last_name, second_name) FROM stdin;
2	784	\N	Vitalii	Mazur	
3	785	\N	Ruslan	Ostapenko	
4	786	\N	Oleg	Pogorelov	
5	787	\N	Irina	Mazur	V.
\.


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('employees_appointments_h_id_seq', 1, true);


--
-- Name: employees_appointments_r_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('employees_appointments_r_id_seq', 1, true);


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY navigation (id, position_id, parent_id, name, url, icon_cls, sort_order, resource_id) FROM stdin;
9	4	8	Resource Types	/resources_types	\N	1	779
7	4	\N	Home	/	fa fa-home	1	777
10	4	\N	HR	/	fa fa-group	2	780
14	4	10	Employees Appointments	/employees_appointments	\N	2	791
15	4	8	Users	/users	\N	2	792
13	4	10	Employees	/employees	\N	1	790
17	4	8	Currencies	/currencies	\N	3	802
8	4	\N	System	/	fa fa-cog	4	778
18	4	\N	Company	/	fa fa-building-o	3	837
20	4	18	Positions	/positions	\N	2	863
19	4	18	Structures	/structures	\N	1	838
\.


--
-- Data for Name: permision; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY permision (id, resource_type_id, position_id, permisions, structure_id, scope_type) FROM stdin;
22	2	4	{view,add,edit,delete}	\N	all
35	65	4	{view,add,edit,delete}	\N	all
34	61	4	{view,add,edit,delete}	\N	all
32	59	4	{view,add,edit,delete}	\N	all
30	55	4	{view,add,edit,delete}	\N	all
24	12	4	{view,add,edit,delete}	\N	all
38	41	4	{view,add,edit,delete}	\N	all
37	67	4	{view,add,edit,delete}	\N	all
26	47	4	{view,add,edit,delete}	\N	all
21	1	4	{view}	\N	all
\.


--
-- Data for Name: position; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY "position" (id, resource_id, structure_id, name) FROM stdin;
4	772	32	Main Developer
\.


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('positions_navigations_id_seq', 20, true);


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('positions_permisions_id_seq', 38, true);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY region (id, resource_id, parent_id, name) FROM stdin;
1	277	\N	Украина
2	278	\N	Россия
3	279	1	Киев
4	280	1	Одеса
5	281	1	Львов
6	282	2	Москва
\.


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY resource (id, resource_type_id, status, structure_id) FROM stdin;
863	65	0	32
728	55	0	32
784	47	0	32
785	47	0	32
787	47	0	32
786	47	0	32
802	65	0	32
769	12	0	32
30	12	1	32
31	12	0	32
32	12	0	32
33	12	0	32
34	12	0	32
35	12	0	32
36	12	0	32
837	65	0	32
848	41	0	32
849	41	0	32
850	41	0	32
851	41	0	32
852	41	0	32
772	59	0	32
788	12	0	32
706	12	0	32
804	41	0	32
771	55	0	32
838	65	0	32
734	55	0	32
853	41	0	32
789	67	0	32
773	12	0	32
854	2	0	32
855	2	0	32
743	55	0	32
790	65	0	32
763	55	0	32
723	12	0	32
791	65	0	32
775	12	0	32
37	12	0	32
38	12	0	32
39	12	0	32
40	12	0	32
43	12	0	32
10	12	0	32
792	65	0	32
12	12	0	32
14	12	0	32
44	12	0	32
16	12	0	32
45	12	0	32
2	2	0	32
3	2	0	32
84	2	0	32
83	2	1	32
856	2	0	32
764	12	0	32
274	12	0	32
283	12	0	32
777	65	0	32
778	65	0	32
779	65	0	32
780	65	0	32
286	41	0	32
287	41	0	32
288	41	0	32
289	41	0	32
290	41	0	32
291	41	0	32
292	41	0	32
306	41	0	32
277	39	0	32
279	39	0	32
280	39	0	32
281	39	0	32
278	39	1	32
282	39	1	32
857	55	0	32
858	55	0	32
859	55	0	32
860	55	0	32
861	55	0	32
794	55	0	32
800	55	0	32
801	55	0	32
725	55	0	32
726	55	0	32
\.


--
-- Data for Name: resource_log; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY resource_log (id, resource_id, employee_id, comment, modifydt) FROM stdin;
142	83	2	\N	2013-12-07 16:38:38.11618
143	84	2	\N	2013-12-07 16:39:56.788641
144	3	2	\N	2013-12-07 16:41:27.65259
145	2	2	\N	2013-12-07 16:41:31.748494
146	83	2	\N	2013-12-07 16:58:05.802634
147	83	2	\N	2013-12-07 17:00:14.544264
4836	794	2	\N	2014-02-05 19:54:07.5415
4845	283	2	\N	2014-02-06 11:38:41.090464
4846	802	2	\N	2014-02-06 12:14:50.840972
2	10	2	\N	2013-11-16 19:00:14.24272
4880	837	2	\N	2014-02-08 12:44:09.181087
4	12	2	\N	2013-11-16 19:00:15.497284
4922	838	2	\N	2014-02-09 11:00:53.283205
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
4821	785	2	\N	2014-02-01 21:23:03.546657
4822	784	2	\N	2014-02-01 21:23:07.460721
4823	786	2	\N	2014-02-01 21:23:12.871915
4824	787	2	\N	2014-02-01 21:23:26.294657
4843	800	2	\N	2014-02-05 19:58:31.619612
4844	801	2	\N	2014-02-05 19:58:49.632624
4847	804	2	\N	2014-02-06 12:27:24.361214
4881	838	2	\N	2014-02-08 12:46:41.342097
4923	863	2	\N	2014-02-09 11:06:45.876408
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
4882	706	2	\N	2014-02-08 19:59:59.160282
377	283	2	\N	2013-12-14 19:18:21.622933
4924	838	2	\N	2014-02-09 12:20:11.632022
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
422	306	2	\N	2013-12-15 21:45:32.990838
4802	773	2	\N	2014-01-25 23:45:37.762081
4827	789	2	\N	2014-02-02 16:45:11.830435
4804	775	2	\N	2014-01-26 15:30:50.636495
4828	3	2	\N	2014-02-02 17:45:50.239397
4829	780	2	\N	2014-02-02 17:53:21.606939
4830	790	2	\N	2014-02-02 17:53:42.973553
4831	791	2	\N	2014-02-02 17:54:20.864462
4832	792	2	\N	2014-02-02 17:54:57.706749
4887	787	2	\N	2014-02-08 21:26:40.607951
4806	777	2	\N	2014-01-26 18:18:05.196211
4807	778	2	\N	2014-01-26 18:18:24.059336
4808	779	2	\N	2014-01-26 18:18:45.188271
4809	780	2	\N	2014-01-26 18:20:19.519217
4888	786	2	\N	2014-02-08 21:26:45.138217
4889	785	2	\N	2014-02-08 21:26:48.602711
4890	784	2	\N	2014-02-08 21:26:51.98617
4893	848	2	\N	2014-02-08 21:32:08.207947
4894	849	2	\N	2014-02-08 21:32:14.802948
4895	850	2	\N	2014-02-08 21:32:25.105565
4834	790	2	\N	2014-02-02 18:39:14.383473
4896	851	2	\N	2014-02-08 21:32:32.471247
4897	852	2	\N	2014-02-08 21:36:44.493917
4898	853	2	\N	2014-02-08 21:39:09.10029
4812	784	2	\N	2014-01-26 21:12:24.209136
4813	784	2	\N	2014-01-26 21:13:10.546575
4814	784	2	\N	2014-01-26 21:13:20.058093
4815	784	2	\N	2014-01-26 21:13:24.693933
4816	785	2	\N	2014-01-26 21:14:41.919016
4817	786	2	\N	2014-01-26 21:15:00.370561
4818	784	2	\N	2014-01-26 21:20:14.635984
4819	784	2	\N	2014-01-26 21:20:34.941868
4899	804	2	\N	2014-02-08 21:40:56.593482
4900	854	2	\N	2014-02-08 21:47:34.439997
4901	855	2	\N	2014-02-08 21:54:55.399628
4902	856	2	\N	2014-02-08 21:59:04.719245
4789	763	2	\N	2014-01-12 19:51:49.157909
4903	854	2	\N	2014-02-08 22:16:58.906498
4904	3	2	\N	2014-02-08 22:17:06.939369
4905	854	2	\N	2014-02-08 22:20:32.280238
4906	784	2	\N	2014-02-08 22:21:01.290541
4907	785	2	\N	2014-02-08 22:21:05.110163
4908	786	2	\N	2014-02-08 22:21:09.110319
4790	764	2	\N	2014-01-12 20:33:53.3138
4909	723	2	\N	2014-02-08 22:28:37.868751
4910	857	2	\N	2014-02-09 00:41:07.487567
4911	858	2	\N	2014-02-09 00:41:26.234037
4912	859	2	\N	2014-02-09 00:41:48.428505
4913	860	2	\N	2014-02-09 00:42:12.938208
4914	857	2	\N	2014-02-09 00:42:31.066281
4915	861	2	\N	2014-02-09 00:42:52.234296
4917	764	2	\N	2014-02-09 00:53:58.264629
4918	769	2	\N	2014-02-09 00:57:04.796409
4919	775	2	\N	2014-02-09 00:57:24.917548
4920	788	2	\N	2014-02-09 00:57:42.02056
4921	838	2	\N	2014-02-09 01:11:46.633177
4120	16	2	\N	2014-01-01 13:19:09.979922
4131	14	2	\N	2014-01-01 18:45:07.902745
4144	706	2	\N	2014-01-03 16:12:41.015146
4145	706	2	\N	2014-01-03 16:13:23.197097
4744	723	2	\N	2014-01-04 23:58:55.624453
4746	725	2	\N	2014-01-05 01:09:00.405742
4747	726	2	\N	2014-01-05 01:09:15.602018
4749	728	2	\N	2014-01-05 01:13:50.125212
4756	734	2	\N	2014-01-05 12:36:48.48575
4765	743	2	\N	2014-01-05 13:20:17.173661
\.


--
-- Data for Name: resource_type; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY resource_type (id, resource_id, name, humanize, resource_name, module, settings, description) FROM stdin;
39	274	regions	Regions	Regions	finbroker.admin.resources.regions	\N	\N
2	10	users	Users	Users	travelcrm.resources.users	\N	Users list
12	16	resources_types	Resources Types	ResourcesTypes	travelcrm.resources.resources_types	\N	Resources types list
47	706	employees	Employees	Employees	travelcrm.resources.employees	\N	Employees Container Datagrid
1	773		Home	Root	travelcrm.resources	\N	Home Page of Travelcrm
41	283	currencies	Currencies	Currencies	travelcrm.resources.currencies	\N	
55	723	structures	Structures	Structures	travelcrm.resources.structures	\N	Companies structures is a tree of company structure. It's can be offices, filials, departments and so and so
59	764	positions	Positions	Positions	travelcrm.resources.positions	\N	Companies positions is a point of company structure where emplyees can be appointed
61	769	permisions	Permisions	Permisions	travelcrm.resources.permisions	\N	Permisions list of company structure position. It's list of resources and permisions
65	775	navigations	Navigations	Navigations	travelcrm.resources.navigations	\N	Navigations list of company structure position.
67	788	appointments	Appointments	Appointments	travelcrm.resources.appointments	\N	Employees to positions of company appointments
\.


--
-- Data for Name: structure; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY structure (id, resource_id, parent_id, name) FROM stdin;
32	725	\N	Head Office
2	858	\N	Kiev Office
3	859	2	Sales Department
4	860	32	Marketing Dep.
1	857	32	Software Dev. Dep.
5	861	32	CEO
\.


--
-- Name: structures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('structures_id_seq', 6, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY "user" (id, resource_id, username, email, password, employee_id) FROM stdin;
2	3	mazvv	vitalii.mazur@gmail.com	mazvv	2
20	854	mazira	\N	mazira	5
\.


--
-- Name: appointment_header_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY appointment_header
    ADD CONSTRAINT appointment_header_pk PRIMARY KEY (id);


--
-- Name: appointment_row_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY appointment_row
    ADD CONSTRAINT appointment_row_pk PRIMARY KEY (id);


--
-- Name: attachment_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY attachment
    ADD CONSTRAINT attachment_pk PRIMARY KEY (id);


--
-- Name: currency_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT currency_pk PRIMARY KEY (id);


--
-- Name: employee_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pk PRIMARY KEY (id);


--
-- Name: navigation_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT navigation_pk PRIMARY KEY (id);


--
-- Name: permision_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT permision_pk PRIMARY KEY (id);


--
-- Name: position_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT position_pk PRIMARY KEY (id);


--
-- Name: region_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pk PRIMARY KEY (id);


--
-- Name: resource_log_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT resource_log_pk PRIMARY KEY (id);


--
-- Name: resource_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_pk PRIMARY KEY (id);


--
-- Name: resource_type_name_key; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT resource_type_name_key UNIQUE (name);


--
-- Name: resource_type_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT resource_type_pk PRIMARY KEY (id);


--
-- Name: structure_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT structure_pk PRIMARY KEY (id);


--
-- Name: unique_idx_currency_iso_code; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT unique_idx_currency_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_resource_type_module; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT unique_idx_resource_type_module UNIQUE (module, resource_name);


--
-- Name: unique_idx_resource_type_name; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT unique_idx_resource_type_name UNIQUE (name);


--
-- Name: unique_idx_users_email; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_idx_users_email UNIQUE (email);


--
-- Name: unique_idx_users_username; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_idx_users_username UNIQUE (username);


--
-- Name: user_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- Name: fk_appointment_header_id_appointment_row; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment_row
    ADD CONSTRAINT fk_appointment_header_id_appointment_row FOREIGN KEY (appointment_header_id) REFERENCES appointment_header(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_attachment_id_employee; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_attachment_id_employee FOREIGN KEY (attachment_id) REFERENCES attachment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_employee_id_appointment_row; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment_row
    ADD CONSTRAINT fk_employee_id_appointment_row FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_employee_id_resource_log; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_employee_id_resource_log FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_employee_id_user; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_employee_id_user FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_navigation_position_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_navigation_position_id FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_parent_id_navigation; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_parent_id_navigation FOREIGN KEY (parent_id) REFERENCES navigation(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_permision_structure_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_permision_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_position_id_appointment_row; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment_row
    ADD CONSTRAINT fk_position_id_appointment_row FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_position_id_permision; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_position_id_permision FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_position_structure_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_position_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_appointment_header; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment_header
    ADD CONSTRAINT fk_resource_id_appointment_header FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_currency; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT fk_resource_id_currency FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_employee; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_resource_id_employee FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_position; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_resource_id_position FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_position_navigation; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_resource_id_position_navigation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_resource_log; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_resource_id_resource_log FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_resource_type; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT fk_resource_id_resource_type FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_structure; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_resource_id_structure FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_user; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_resource_id_user FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_type_id_permission; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_resource_type_id_permission FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_type_id_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_resource_type_id_resource FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resources_id_attachment; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY attachment
    ADD CONSTRAINT fk_resources_id_attachment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_structure_id_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_structure_id_resource FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_structure_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_parent_id FOREIGN KEY (parent_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE CASCADE;


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

