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
-- Name: contact_type_enum; Type: TYPE; Schema: public; Owner: mazvv
--

CREATE TYPE contact_type_enum AS ENUM (
    'phone',
    'email',
    'skype'
);


ALTER TYPE public.contact_type_enum OWNER TO mazvv;

--
-- Name: genders_enum; Type: TYPE; Schema: public; Owner: mazvv
--

CREATE TYPE genders_enum AS ENUM (
    'male',
    'female'
);


ALTER TYPE public.genders_enum OWNER TO mazvv;

--
-- Name: passport_type_enum; Type: TYPE; Schema: public; Owner: mazvv
--

CREATE TYPE passport_type_enum AS ENUM (
    'citizen',
    'foreign'
);


ALTER TYPE public.passport_type_enum OWNER TO mazvv;

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
    first_name character varying(32) NOT NULL,
    last_name character varying(32) NOT NULL,
    second_name character varying(32),
    itn character varying(32),
    dismissal_date date,
    photo character varying
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
    country_id integer NOT NULL,
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
    structure_id integer NOT NULL,
    protected boolean
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
-- Name: accomodation; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE accomodation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.accomodation OWNER TO mazvv;

--
-- Name: accomodation_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE accomodation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accomodation_id_seq OWNER TO mazvv;

--
-- Name: accomodation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE accomodation_id_seq OWNED BY accomodation.id;


--
-- Name: address; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE address (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    location_id integer NOT NULL,
    zip_code character varying(12) NOT NULL,
    address character varying(255) NOT NULL
);


ALTER TABLE public.address OWNER TO mazvv;

--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.address_id_seq OWNER TO mazvv;

--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE address_id_seq OWNED BY address.id;


--
-- Name: advsource; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE advsource (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.advsource OWNER TO mazvv;

--
-- Name: advsource_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE advsource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.advsource_id_seq OWNER TO mazvv;

--
-- Name: advsource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE advsource_id_seq OWNED BY advsource.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO mazvv;

--
-- Name: appointment; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE appointment (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    currency_id integer NOT NULL,
    employee_id integer NOT NULL,
    position_id integer NOT NULL,
    salary numeric(16,2) NOT NULL,
    date date
);


ALTER TABLE public.appointment OWNER TO mazvv;

--
-- Name: bank; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE bank (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.bank OWNER TO mazvv;

--
-- Name: bank_address; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE bank_address (
    bank_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE public.bank_address OWNER TO mazvv;

--
-- Name: bank_detail; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE bank_detail (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    currency_id integer NOT NULL,
    bank_id integer NOT NULL,
    beneficiary character varying(255),
    account character varying(32) NOT NULL,
    swift_code character varying(32) NOT NULL
);


ALTER TABLE public.bank_detail OWNER TO mazvv;

--
-- Name: bank_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE bank_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bank_detail_id_seq OWNER TO mazvv;

--
-- Name: bank_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE bank_detail_id_seq OWNED BY bank_detail.id;


--
-- Name: bank_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE bank_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bank_id_seq OWNER TO mazvv;

--
-- Name: bank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE bank_id_seq OWNED BY bank.id;


--
-- Name: bperson; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE bperson (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    first_name character varying(32) NOT NULL,
    last_name character varying(32),
    second_name character varying(32),
    position_name character varying(64)
);


ALTER TABLE public.bperson OWNER TO mazvv;

--
-- Name: bperson_contact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE bperson_contact (
    bperson_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE public.bperson_contact OWNER TO mazvv;

--
-- Name: bperson_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE bperson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bperson_id_seq OWNER TO mazvv;

--
-- Name: bperson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE bperson_id_seq OWNED BY bperson.id;


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
-- Name: contact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE contact (
    id integer NOT NULL,
    contact character varying NOT NULL,
    contact_type contact_type_enum NOT NULL,
    resource_id integer NOT NULL
);


ALTER TABLE public.contact OWNER TO mazvv;

--
-- Name: contact_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_id_seq OWNER TO mazvv;

--
-- Name: contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE contact_id_seq OWNED BY contact.id;


--
-- Name: country; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE country (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(2) NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.country OWNER TO mazvv;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.country_id_seq OWNER TO mazvv;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: employee_address; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employee_address (
    employee_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE public.employee_address OWNER TO mazvv;

--
-- Name: employee_contact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employee_contact (
    employee_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE public.employee_contact OWNER TO mazvv;

--
-- Name: employee_passport; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employee_passport (
    employee_id integer NOT NULL,
    passport_id integer NOT NULL
);


ALTER TABLE public.employee_passport OWNER TO mazvv;

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

ALTER SEQUENCE employees_appointments_h_id_seq OWNED BY appointment.id;


--
-- Name: foodcat; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE foodcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.foodcat OWNER TO mazvv;

--
-- Name: foodcat_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE foodcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.foodcat_id_seq OWNER TO mazvv;

--
-- Name: foodcat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE foodcat_id_seq OWNED BY foodcat.id;


--
-- Name: hotel; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE hotel (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    hotelcat_id integer NOT NULL,
    name character varying(32) NOT NULL,
    location_id integer
);


ALTER TABLE public.hotel OWNER TO mazvv;

--
-- Name: hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE hotel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hotel_id_seq OWNER TO mazvv;

--
-- Name: hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE hotel_id_seq OWNED BY hotel.id;


--
-- Name: hotelcat; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE hotelcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.hotelcat OWNER TO mazvv;

--
-- Name: hotelcat_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE hotelcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hotelcat_id_seq OWNER TO mazvv;

--
-- Name: hotelcat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE hotelcat_id_seq OWNED BY hotelcat.id;


--
-- Name: licence; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE licence (
    id integer NOT NULL,
    licence_num character varying NOT NULL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    resource_id integer NOT NULL
);


ALTER TABLE public.licence OWNER TO mazvv;

--
-- Name: licence_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE licence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.licence_id_seq OWNER TO mazvv;

--
-- Name: licence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE licence_id_seq OWNED BY licence.id;


--
-- Name: location; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE location (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    region_id integer NOT NULL
);


ALTER TABLE public.location OWNER TO mazvv;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.location_id_seq OWNER TO mazvv;

--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


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
-- Name: passport; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE passport (
    id integer NOT NULL,
    country_id integer NOT NULL,
    passport_type passport_type_enum NOT NULL,
    num character varying(32) NOT NULL,
    descr character varying(255),
    resource_id integer NOT NULL,
    end_date date
);


ALTER TABLE public.passport OWNER TO mazvv;

--
-- Name: passport_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE passport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.passport_id_seq OWNER TO mazvv;

--
-- Name: passport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE passport_id_seq OWNED BY passport.id;


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
-- Name: person; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE person (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    first_name character varying(32) NOT NULL,
    last_name character varying(32),
    second_name character varying(32),
    birthday date,
    gender genders_enum
);


ALTER TABLE public.person OWNER TO mazvv;

--
-- Name: person_address; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE person_address (
    person_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE public.person_address OWNER TO mazvv;

--
-- Name: person_contact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE person_contact (
    person_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE public.person_contact OWNER TO mazvv;

--
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_id_seq OWNER TO mazvv;

--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE person_id_seq OWNED BY person.id;


--
-- Name: person_passport; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE person_passport (
    person_id integer NOT NULL,
    passport_id integer NOT NULL
);


ALTER TABLE public.person_passport OWNER TO mazvv;

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
-- Name: roomcat; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE roomcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.roomcat OWNER TO mazvv;

--
-- Name: roomcat_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE roomcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roomcat_id_seq OWNER TO mazvv;

--
-- Name: roomcat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE roomcat_id_seq OWNED BY roomcat.id;


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
-- Name: structure_address; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE structure_address (
    structure_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE public.structure_address OWNER TO mazvv;

--
-- Name: structure_bank_detail; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE structure_bank_detail (
    structure_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


ALTER TABLE public.structure_bank_detail OWNER TO mazvv;

--
-- Name: structure_contact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE structure_contact (
    structure_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE public.structure_contact OWNER TO mazvv;

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
-- Name: task; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE task (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    title character varying(32) NOT NULL,
    deadline date NOT NULL,
    reminder timestamp without time zone,
    descr character varying,
    priority integer NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE public.task OWNER TO mazvv;

--
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_id_seq OWNER TO mazvv;

--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE task_id_seq OWNED BY task.id;


--
-- Name: task_resource; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE task_resource (
    task_id integer NOT NULL,
    resource_id integer NOT NULL
);


ALTER TABLE public.task_resource OWNER TO mazvv;

--
-- Name: tour; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE tour (
    id integer NOT NULL,
    touroperator_id integer NOT NULL,
    start_location_id integer NOT NULL,
    end_location_id integer NOT NULL,
    currency_id integer NOT NULL,
    price numeric(16,4) NOT NULL,
    adults integer NOT NULL,
    children integer NOT NULL,
    customer_id integer NOT NULL,
    resource_id integer NOT NULL,
    end_date date NOT NULL,
    start_date date NOT NULL,
    deal_date date NOT NULL,
    advsource_id integer NOT NULL
);


ALTER TABLE public.tour OWNER TO mazvv;

--
-- Name: tour_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE tour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tour_id_seq OWNER TO mazvv;

--
-- Name: tour_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE tour_id_seq OWNED BY tour.id;


--
-- Name: tour_person; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE tour_person (
    tour_id integer NOT NULL,
    person_id integer NOT NULL
);


ALTER TABLE public.tour_person OWNER TO mazvv;

--
-- Name: tour_point; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE tour_point (
    id integer NOT NULL,
    location_id integer NOT NULL,
    hotel_id integer,
    accomodation_id integer,
    foodcat_id integer,
    roomcat_id integer,
    tour_id integer,
    description character varying(255),
    end_date date NOT NULL,
    start_date date NOT NULL
);


ALTER TABLE public.tour_point OWNER TO mazvv;

--
-- Name: tour_point_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE tour_point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tour_point_id_seq OWNER TO mazvv;

--
-- Name: tour_point_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE tour_point_id_seq OWNED BY tour_point.id;


--
-- Name: touroperator; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE touroperator (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.touroperator OWNER TO mazvv;

--
-- Name: touroperator_bank_detail; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE touroperator_bank_detail (
    touroperator_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


ALTER TABLE public.touroperator_bank_detail OWNER TO mazvv;

--
-- Name: touroperator_bperson; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE touroperator_bperson (
    touroperator_id integer NOT NULL,
    bperson_id integer NOT NULL
);


ALTER TABLE public.touroperator_bperson OWNER TO mazvv;

--
-- Name: touroperator_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE touroperator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.touroperator_id_seq OWNER TO mazvv;

--
-- Name: touroperator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE touroperator_id_seq OWNED BY touroperator.id;


--
-- Name: touroperator_licence; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE touroperator_licence (
    touroperator_id integer NOT NULL,
    licence_id integer NOT NULL
);


ALTER TABLE public.touroperator_licence OWNER TO mazvv;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY accomodation ALTER COLUMN id SET DEFAULT nextval('accomodation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY address ALTER COLUMN id SET DEFAULT nextval('address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY advsource ALTER COLUMN id SET DEFAULT nextval('advsource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment ALTER COLUMN id SET DEFAULT nextval('employees_appointments_h_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bank ALTER COLUMN id SET DEFAULT nextval('bank_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bank_detail ALTER COLUMN id SET DEFAULT nextval('bank_detail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bperson ALTER COLUMN id SET DEFAULT nextval('bperson_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY contact ALTER COLUMN id SET DEFAULT nextval('contact_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


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

ALTER TABLE ONLY foodcat ALTER COLUMN id SET DEFAULT nextval('foodcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY hotel ALTER COLUMN id SET DEFAULT nextval('hotel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY hotelcat ALTER COLUMN id SET DEFAULT nextval('hotelcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY licence ALTER COLUMN id SET DEFAULT nextval('licence_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY navigation ALTER COLUMN id SET DEFAULT nextval('positions_navigations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY passport ALTER COLUMN id SET DEFAULT nextval('passport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY permision ALTER COLUMN id SET DEFAULT nextval('positions_permisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person ALTER COLUMN id SET DEFAULT nextval('person_id_seq'::regclass);


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

ALTER TABLE ONLY roomcat ALTER COLUMN id SET DEFAULT nextval('roomcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure ALTER COLUMN id SET DEFAULT nextval('structures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY task ALTER COLUMN id SET DEFAULT nextval('task_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour ALTER COLUMN id SET DEFAULT nextval('tour_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_point ALTER COLUMN id SET DEFAULT nextval('tour_point_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator ALTER COLUMN id SET DEFAULT nextval('touroperator_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('_users_rid_seq'::regclass);


--
-- Name: _currencies_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_currencies_rid_seq', 57, true);


--
-- Name: _employees_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_employees_rid_seq', 29, true);


--
-- Name: _regions_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_regions_rid_seq', 23, true);


--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_logs_rid_seq', 5542, true);


--
-- Name: _resources_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_rid_seq', 1311, true);


--
-- Name: _resources_types_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_types_rid_seq', 101, true);


--
-- Name: _users_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_users_rid_seq', 23, true);


--
-- Data for Name: accomodation; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY accomodation (id, resource_id, name) FROM stdin;
1	957	MB
2	958	HV
3	959	BGL
4	960	BG
5	961	Chale
6	962	Cabana
7	963	Cottage
8	964	Executive floor
9	965	SGL
10	966	DBL
11	967	TRPL
12	968	QDPL
13	969	ExB
14	970	Chld
15	971	ВО
\.


--
-- Name: accomodation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('accomodation_id_seq', 16, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY address (id, resource_id, location_id, zip_code, address) FROM stdin;
10	1288	14	02312	Bogdana Hmelnickogo Str
13	1308	5	12354	asdf asdf asdfsadf
14	1309	14	12345	dsfg sdfg sdfg sdfgsdfgdsf
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('address_id_seq', 14, true);


--
-- Data for Name: advsource; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY advsource (id, resource_id, name) FROM stdin;
2	904	Google.com
3	905	Yahoo.com
4	906	Recommendation
5	907	Second appeal
1	903	Internet Search Engines
6	1283	Undefined
\.


--
-- Name: advsource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('advsource_id_seq', 6, true);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY alembic_version (version_num) FROM stdin;
2fddfccc6bfd
\.


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY appointment (id, resource_id, currency_id, employee_id, position_id, salary, date) FROM stdin;
1	789	54	2	4	1000.00	2014-02-02
6	892	54	7	5	4500.00	2014-02-22
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY bank (id, resource_id, name) FROM stdin;
1	1214	Bank of America
\.


--
-- Data for Name: bank_address; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY bank_address (bank_id, address_id) FROM stdin;
\.


--
-- Data for Name: bank_detail; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY bank_detail (id, resource_id, currency_id, bank_id, beneficiary, account, swift_code) FROM stdin;
\.


--
-- Name: bank_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('bank_detail_id_seq', 4, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('bank_id_seq', 3, true);


--
-- Data for Name: bperson; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY bperson (id, resource_id, first_name, last_name, second_name, position_name) FROM stdin;
1	1009	Alexandro	Riak		Sales Manager
2	1010	Umberto			Accounting
\.


--
-- Data for Name: bperson_contact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY bperson_contact (bperson_id, contact_id) FROM stdin;
\.


--
-- Name: bperson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('bperson_id_seq', 4, true);


--
-- Name: companies_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('companies_positions_id_seq', 7, true);


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY contact (id, contact, contact_type, resource_id) FROM stdin;
27	+380681983869	phone	1193
28	asdasd@mail.com	email	1194
29	+380681983869	phone	1195
30	+380681983869	phone	1201
32	+380681983869	phone	1204
35	vitalii.mazur@gmail.com	email	1243
36	+380681983869	phone	1244
37	+380681983869	phone	1257
38	vitalii.mazur@gmail.com	email	1258
39	+380681983869	phone	1259
40	vitalii.mazur@gmail.com	email	1260
41	+380682523645	phone	1263
42	a.koff@gmail.com	email	1264
44	+380675625353	phone	1282
45	+380502355565	phone	1285
46	n.voevoda@gmail.com	email	1304
\.


--
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('contact_id_seq', 46, true);


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY country (id, resource_id, iso_code, name) FROM stdin;
3	878	UA	Ukraine
4	880	EG	Egypt
5	881	TR	Turkey
6	882	GB	United Kingdom
7	883	US	United States
8	884	TH	Thailand
9	1095	RU	Russian Federation
11	1100	GR	Germany
12	1164	HR	Croatia
13	1169	AE	United Arab Emirates
14	1178	ES	Spain
\.


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('country_id_seq', 15, true);


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY currency (id, resource_id, iso_code) FROM stdin;
44	849	RUB
50	1060	KZT
52	1168	BYR
54	1240	EUR
56	1310	UAH
57	1311	USD
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employee (id, resource_id, first_name, last_name, second_name, itn, dismissal_date, photo) FROM stdin;
4	786	Oleg	Pogorelov		\N	\N	\N
8	893	Oleg	Mazur	V.	\N	\N	\N
9	1040	Halyna	Sereda		\N	\N	\N
10	1041	Andrey	Shabanov		\N	\N	\N
11	1042	Dymitrii	Veremeychuk		\N	\N	\N
13	1044	Alexandra	Koff	\N	\N	\N	\N
15	1046	Viktoriia	Lastovets	\N	\N	2014-04-28	\N
12	1043	Denis	Yurin	\N	\N	2014-04-01	\N
14	1045	Dima	Shkreba	\N	\N	2013-04-30	\N
2	784	Vitalii	Mazur	\N	\N	\N	employee/53945b8e-5eaf-4319-b759-1d2c23d91988.jpg
7	885	Irina	Mazur	V.	\N	\N	employee/f8ce7007-df56-471c-a330-c43b678ed2ae.jpg
\.


--
-- Data for Name: employee_address; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employee_address (employee_id, address_id) FROM stdin;
\.


--
-- Data for Name: employee_contact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employee_contact (employee_id, contact_id) FROM stdin;
13	42
13	41
\.


--
-- Data for Name: employee_passport; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employee_passport (employee_id, passport_id) FROM stdin;
13	7
\.


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('employees_appointments_h_id_seq', 7, true);


--
-- Data for Name: foodcat; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY foodcat (id, resource_id, name) FROM stdin;
1	973	ОВ
3	975	BB
4	976	HB
5	977	HB+
6	978	FB
7	979	FB+
8	980	EXTFB
9	981	Mini all inclusive
10	982	ALL
11	983	Continental Breakfast
12	984	English breakfast
13	985	American breakfast
15	987	UAL
16	988	UAI
\.


--
-- Name: foodcat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('foodcat_id_seq', 16, true);


--
-- Data for Name: hotel; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY hotel (id, resource_id, hotelcat_id, name, location_id) FROM stdin;
10	1292	5	Hotel View Novi Vindolski	16
\.


--
-- Name: hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('hotel_id_seq', 10, true);


--
-- Data for Name: hotelcat; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY hotelcat (id, resource_id, name) FROM stdin;
1	912	1*
2	913	2*
3	914	3*
4	915	4*
5	916	5*
6	917	HV-1
7	918	HV-2
8	919	De Luxe
\.


--
-- Name: hotelcat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('hotelcat_id_seq', 8, true);


--
-- Data for Name: licence; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY licence (id, licence_num, date_from, date_to, resource_id) FROM stdin;
43	dfgfdgdf	2014-04-22	2014-04-22	1191
44	TTR-123456	2014-04-15	2014-04-23	1192
\.


--
-- Name: licence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('licence_id_seq', 45, true);


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY location (id, resource_id, name, region_id) FROM stdin;
1	1091	Kestel	12
3	1093	Airport Julyany (Kiev)	7
5	1097	Simferopol	13
6	1102	Munich	15
14	1287	Kiev	7
15	1289	Borispol Airport	7
16	1291	Opatiya	23
\.


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('location_id_seq', 16, true);


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY navigation (id, position_id, parent_id, name, url, icon_cls, sort_order, resource_id) FROM stdin;
9	4	8	Resource Types	/resources_types	\N	1	779
23	4	\N	Directories	/	fa fa-book	8	873
18	4	\N	Company	/	fa fa-building-o	7	837
10	4	\N	HR	/	fa fa-group	6	780
26	4	\N	Marketing	/	fa fa-bullhorn	5	900
7	4	\N	Home	/	fa fa-home	1	777
21	4	\N	Clientage	/	fa fa-briefcase	4	864
39	4	\N	Services	/	fa fa-puzzle-piece	3	1076
15	4	8	Users	/users	\N	2	792
13	4	10	Employees	/employees	\N	1	790
41	5	\N	Home	/	fa fa-home	1	1079
20	4	18	Positions	/positions	\N	2	863
19	4	18	Structures	/structures	\N	1	838
35	4	23	Touroperators	/touroperators	\N	11	1002
17	4	23	Currencies	/currencies	\N	1	802
14	4	10	Employees Appointments	/appointments	\N	2	791
30	4	23	Accomodations	/accomodations	\N	10	955
31	4	23	Food Categories	/foodcats	\N	9	956
29	4	23	Rooms Categories	/roomcats	\N	7	911
42	4	23	Hotels	/hotels	\N	6	1080
27	4	26	Advertising Sources	/advsources	\N	1	902
28	4	23	Hotels Categories	/hotelcats	\N	5	910
43	4	23	Locations	/locations	\N	3	1089
24	4	23	Countries	/countries	\N	4	874
25	4	23	Regions	/regions	\N	3	879
32	4	\N	Sales	/	fa fa-legal	2	998
45	4	23	Banks	/banks	\N	12	1212
22	4	21	Persons	/persons	\N	1	866
36	4	23	Business Persons	/bpersons	\N	9	1008
38	4	32	Tours	/tours	\N	2	1075
8	4	\N	System	/	fa fa-cog	9	778
47	5	\N	For Test	/	fa fa-credit-card	2	1253
48	6	\N	Home	/	fa fa-home	1	1079
49	6	\N	For Test	/	fa fa-credit-card	2	1253
\.


--
-- Data for Name: passport; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY passport (id, country_id, passport_type, num, descr, resource_id, end_date) FROM stdin;
1	14	foreign	231654	\N	1199	\N
2	14	foreign	132456	\N	1200	\N
4	12	foreign	1234564	\N	1205	\N
5	14	foreign	Svxzvxz	xzcvxzcv	1206	\N
6	3	citizen	НК028057	\N	1261	\N
7	3	citizen	HJ123456	new passport	1265	\N
8	3	citizen	РМ12345	from Kiev region	1286	\N
\.


--
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('passport_id_seq', 8, true);


--
-- Data for Name: permision; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY permision (id, resource_type_id, position_id, permisions, structure_id, scope_type) FROM stdin;
22	2	4	{view,add,edit,delete}	\N	all
35	65	4	{view,add,edit,delete}	\N	all
34	61	4	{view,add,edit,delete}	\N	all
32	59	4	{view,add,edit,delete}	\N	all
30	55	4	{view,add,edit,delete}	\N	all
38	41	4	{view,add,edit,delete}	\N	all
37	67	4	{view,add,edit,delete}	\N	all
39	69	4	{view,add,edit,delete}	\N	all
40	39	4	{view,add,edit,delete}	\N	all
41	70	4	{view,add,edit,delete}	\N	all
42	71	4	{view,add,edit,delete}	\N	all
43	72	4	{view,add,edit,delete}	\N	all
44	73	4	{view,add,edit,delete}	\N	all
45	74	4	{view,add,edit,delete}	\N	all
46	75	4	{view,add,edit,delete}	\N	all
48	78	4	{view,add,edit,delete}	\N	all
49	79	4	{view,add,edit,delete}	\N	all
26	47	4	{view,add,edit,delete}	\N	all
53	2	5	{view,add,edit,delete}	\N	all
54	1	5	{view}	\N	all
55	83	4	{view,add,edit,delete}	\N	all
56	84	4	{view,add,edit,delete}	\N	all
58	86	4	{view,add,edit,delete}	\N	all
59	87	4	{view,add,edit,delete}	\N	all
61	89	4	{view,add,edit,delete}	\N	all
62	90	4	{view,add,edit,delete}	\N	all
63	91	4	{view,add,edit,delete}	\N	all
64	92	4	{view,add,edit,delete}	\N	all
21	1	4	{view}	\N	all
65	93	4	{view,add,edit,delete}	\N	all
24	12	4	{view,add,edit,delete}	\N	all
67	1	6	{view}	\N	all
66	2	6	{view,add,edit,delete}	5	structure
68	1	7	{view}	\N	all
69	2	7	{view,add,edit,delete}	5	structure
70	101	4	{view,add,edit,delete}	\N	all
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person (id, resource_id, first_name, last_name, second_name, birthday, gender) FROM stdin;
4	870	Greg	Johnson		\N	\N
5	871	John	Doe		\N	\N
6	887	Peter	Parker		1976-04-07	\N
17	1284	Nikolay	Voevoda		1981-07-22	male
18	1293	Irina	Voevoda		1984-01-18	female
19	1294	Stas	Voevoda		2007-10-16	male
\.


--
-- Data for Name: person_address; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person_address (person_id, address_id) FROM stdin;
17	10
\.


--
-- Data for Name: person_contact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person_contact (person_id, contact_id) FROM stdin;
6	44
17	45
17	46
\.


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('person_id_seq', 19, true);


--
-- Data for Name: person_passport; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person_passport (person_id, passport_id) FROM stdin;
17	8
\.


--
-- Data for Name: position; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY "position" (id, resource_id, structure_id, name) FROM stdin;
4	772	32	Main Developer
5	886	5	Finance Director
6	1249	3	Sales Manager
7	1252	9	Sales Manager
\.


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('positions_navigations_id_seq', 49, true);


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('positions_permisions_id_seq', 70, true);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY region (id, resource_id, country_id, name) FROM stdin;
7	895	3	Kiev region
8	896	3	Lviv region
9	897	4	Hurgada
10	898	5	Kemer
12	1090	5	Antalya
13	1096	9	Cramia
15	1101	11	Bavaria
16	1165	12	Middle Dalmaci
17	1170	13	Fujairah
18	1179	14	Costa Brava
19	1185	13	Abu Dhabi
22	1278	3	Lviv
23	1290	12	Kvarner
\.


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY resource (id, resource_type_id, structure_id, protected) FROM stdin;
1080	65	32	\N
1081	12	32	\N
863	65	32	\N
875	70	32	\N
885	47	32	\N
1100	70	32	\N
895	39	32	\N
1101	39	32	\N
1102	84	32	\N
1268	12	32	f
998	65	32	\N
1010	79	32	\N
1283	71	32	f
1284	69	32	f
1287	84	32	f
1289	84	32	f
1303	93	32	f
728	55	32	\N
784	47	32	\N
1306	90	32	f
786	47	32	\N
802	65	32	\N
769	12	32	\N
30	12	32	\N
31	12	32	\N
32	12	32	\N
33	12	32	\N
34	12	32	\N
35	12	32	\N
36	12	32	\N
837	65	32	\N
1164	70	32	\N
1165	39	32	\N
1204	87	32	\N
1207	12	32	\N
1218	39	32	\N
1240	41	32	f
1257	87	32	f
1258	87	32	f
849	41	32	\N
851	41	32	\N
852	41	32	\N
1285	87	32	f
864	65	32	\N
876	41	32	\N
886	59	32	\N
1286	89	32	f
896	39	32	\N
897	39	32	\N
772	59	32	\N
788	12	32	\N
706	12	32	\N
1291	84	32	f
771	55	32	\N
838	65	32	\N
734	55	32	\N
898	39	32	\N
899	39	32	\N
900	65	32	\N
901	12	32	\N
902	65	32	\N
1292	83	32	f
1304	87	32	f
1011	12	32	\N
1307	90	32	f
1185	39	32	\N
1198	12	32	\N
1205	89	32	\N
1221	12	32	\N
1227	93	32	\N
1241	39	32	f
1259	87	32	f
1260	87	32	f
853	41	32	\N
865	12	32	\N
866	65	32	\N
789	67	32	\N
1288	90	32	f
887	69	32	\N
1290	39	32	f
773	12	32	\N
892	67	32	\N
903	71	32	\N
904	71	32	\N
905	71	32	\N
906	71	32	\N
907	71	32	\N
1305	93	32	f
1308	90	32	f
1168	41	32	\N
1040	47	32	\N
1041	47	32	\N
1042	47	32	\N
1043	47	32	\N
1044	47	32	\N
1045	47	32	\N
1046	47	32	\N
1169	70	32	\N
1067	78	32	\N
1199	89	32	\N
1206	89	32	\N
1209	90	32	\N
1249	59	32	f
1250	55	32	f
1251	55	32	f
1252	59	32	f
1261	89	32	f
854	2	32	\N
855	2	32	\N
1277	55	32	f
1278	39	32	f
878	70	32	\N
1293	69	32	f
893	47	32	\N
894	2	32	\N
908	12	32	\N
909	12	32	\N
910	65	32	\N
911	65	32	\N
743	55	32	\N
790	65	32	\N
1294	69	32	f
763	55	32	\N
1295	92	32	f
723	12	32	\N
791	65	32	\N
775	12	32	\N
37	12	32	\N
38	12	32	\N
39	12	32	\N
40	12	32	\N
43	12	32	\N
10	12	32	\N
792	65	32	\N
12	12	32	\N
14	12	32	\N
44	12	32	\N
16	12	32	\N
45	12	32	\N
1309	90	32	f
2	2	32	\N
3	2	32	\N
84	2	32	\N
83	2	32	\N
940	73	32	\N
941	73	32	\N
942	73	32	\N
943	73	32	\N
944	73	32	\N
945	73	32	\N
946	73	32	\N
947	73	32	\N
948	73	32	\N
949	73	32	\N
950	73	32	\N
952	73	32	\N
939	73	32	\N
938	73	32	\N
937	73	32	\N
936	73	32	\N
935	73	32	\N
933	73	32	\N
932	73	32	\N
931	73	32	\N
930	73	32	\N
929	73	32	\N
928	73	32	\N
927	73	32	\N
926	73	32	\N
925	73	32	\N
924	73	32	\N
923	73	32	\N
922	73	32	\N
921	73	32	\N
919	72	32	\N
918	72	32	\N
917	72	32	\N
916	72	32	\N
915	72	32	\N
914	72	32	\N
913	72	32	\N
912	72	32	\N
1002	65	32	\N
1060	41	32	\N
1068	12	32	\N
1075	65	32	\N
1170	39	32	\N
1178	70	32	\N
1179	39	32	\N
1189	12	32	\N
1190	12	32	\N
1200	89	32	\N
1210	90	32	\N
1225	12	32	\N
1230	93	32	\N
1243	87	32	f
1253	65	32	f
1263	87	32	f
856	2	32	\N
870	69	32	\N
1088	12	32	\N
879	65	32	\N
1089	65	32	\N
953	12	32	\N
954	12	32	\N
764	12	32	\N
955	65	32	\N
956	65	32	\N
957	74	32	\N
958	74	32	\N
959	74	32	\N
960	74	32	\N
961	74	32	\N
962	74	32	\N
963	74	32	\N
964	74	32	\N
965	74	32	\N
966	74	32	\N
967	74	32	\N
968	74	32	\N
969	74	32	\N
970	74	32	\N
971	74	32	\N
1310	41	32	f
973	75	32	\N
975	75	32	\N
976	75	32	\N
977	75	32	\N
978	75	32	\N
274	12	32	\N
283	12	32	\N
777	65	32	\N
778	65	32	\N
779	65	32	\N
780	65	32	\N
286	41	32	\N
287	41	32	\N
288	41	32	\N
289	41	32	\N
290	41	32	\N
291	41	32	\N
292	41	32	\N
306	41	32	\N
277	39	32	\N
279	39	32	\N
280	39	32	\N
281	39	32	\N
278	39	32	\N
282	39	32	\N
979	75	32	\N
980	75	32	\N
981	75	32	\N
982	75	32	\N
983	75	32	\N
984	75	32	\N
985	75	32	\N
987	75	32	\N
988	75	32	\N
1003	12	32	\N
1004	78	32	\N
1005	78	32	\N
1076	65	32	\N
1191	86	32	\N
1201	87	32	\N
1211	12	32	\N
1212	65	32	\N
1213	90	32	\N
1244	87	32	f
1264	87	32	f
857	55	32	\N
858	55	32	\N
859	55	32	\N
860	55	32	\N
861	55	32	\N
794	55	32	\N
800	55	32	\N
801	55	32	\N
1090	39	32	\N
871	69	32	\N
880	70	32	\N
881	70	32	\N
882	70	32	\N
883	70	32	\N
884	70	32	\N
1091	84	32	\N
1007	12	32	\N
1008	65	32	\N
1093	84	32	\N
1297	93	32	f
1300	93	32	f
1302	93	32	f
1311	41	32	f
1062	55	32	\N
1078	12	32	\N
1192	86	32	\N
1214	91	32	\N
1265	89	32	f
872	12	32	\N
873	65	32	\N
874	65	32	\N
725	55	32	\N
726	55	32	\N
1282	87	32	f
1298	93	32	f
1095	70	32	\N
1009	79	32	\N
1096	39	32	\N
1097	84	32	\N
1299	93	32	f
1301	93	32	f
1079	65	32	\N
1099	39	32	\N
1159	78	32	\N
1193	87	32	\N
1194	87	32	\N
1195	87	32	\N
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
5406	1192	2	\N	2014-04-06 19:21:11.278173
5407	1005	2	\N	2014-04-06 19:21:55.315341
4845	283	2	\N	2014-02-06 11:38:41.090464
4846	802	2	\N	2014-02-06 12:14:50.840972
2	10	2	\N	2013-11-16 19:00:14.24272
4880	837	2	\N	2014-02-08 12:44:09.181087
4	12	2	\N	2013-11-16 19:00:15.497284
4922	838	2	\N	2014-02-09 11:00:53.283205
6	14	2	\N	2013-11-16 19:00:16.696731
4950	791	2	\N	2014-02-14 19:34:50.327857
8	16	2	\N	2013-11-16 19:00:17.960761
5427	1204	2	\N	2014-04-09 18:54:09.146902
12	30	2	\N	2013-11-23 19:26:00.193553
13	30	2	\N	2013-11-23 22:02:37.363677
14	10	2	\N	2013-11-23 22:11:01.634598
15	30	2	\N	2013-11-23 22:11:14.939938
16	30	2	\N	2013-11-23 22:11:38.396085
5142	1002	2	\N	2014-03-04 20:58:18.574794
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
5430	1207	2	\N	2014-04-09 20:43:13.852066
5459	1227	2	\N	2014-04-19 13:04:24.512333
5467	1230	2	\N	2014-04-23 11:53:28.979784
5468	1230	2	\N	2014-04-23 11:53:45.572462
5537	1306	2	\N	2014-04-30 11:04:50.581045
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
5408	1192	2	\N	2014-04-06 19:22:16.361504
5409	1005	2	\N	2014-04-06 19:22:18.74271
4822	784	2	\N	2014-02-01 21:23:07.460721
4823	786	2	\N	2014-02-01 21:23:12.871915
5410	1193	2	\N	2014-04-06 19:30:25.125445
5411	1194	2	\N	2014-04-06 19:30:51.85642
5412	1195	2	\N	2014-04-06 19:32:30.207073
5428	1205	2	\N	2014-04-09 19:17:37.483997
5431	1209	2	\N	2014-04-09 20:49:45.884539
4843	800	2	\N	2014-02-05 19:58:31.619612
4844	801	2	\N	2014-02-05 19:58:49.632624
4881	838	2	\N	2014-02-08 12:46:41.342097
4923	863	2	\N	2014-02-09 11:06:45.876408
4951	885	2	\N	2014-02-14 21:23:40.101298
4952	885	2	\N	2014-02-14 21:25:13.866935
4974	849	2	\N	2014-02-23 22:41:46.113064
4977	884	2	\N	2014-02-23 22:42:22.595852
5143	1003	2	\N	2014-03-04 21:05:09.565466
5144	1004	2	\N	2014-03-04 21:08:53.227171
5145	1005	2	\N	2014-03-04 21:09:15.542733
5471	1240	2	\N	2014-04-26 13:10:19.27836
5538	1307	2	\N	2014-04-30 11:08:33.655971
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
4953	886	2	\N	2014-02-14 21:25:53.089098
4978	893	2	\N	2014-02-24 11:11:03.613711
5147	1004	2	\N	2014-03-04 21:17:22.306545
5148	1004	2	\N	2014-03-04 21:23:04.343461
386	286	2	\N	2013-12-14 20:46:34.653533
387	287	2	\N	2013-12-14 20:46:47.37835
388	288	2	\N	2013-12-14 20:47:08.024243
389	289	2	\N	2013-12-14 20:47:28.256516
390	290	2	\N	2013-12-14 20:52:40.953492
391	291	2	\N	2013-12-14 20:53:08.057165
392	292	2	\N	2013-12-14 20:53:33.598708
5149	1004	2	\N	2014-03-04 21:23:17.093243
5150	1004	2	\N	2014-03-04 21:23:25.611509
4799	771	2	\N	2014-01-25 16:05:28.799345
4800	771	2	\N	2014-01-25 16:05:38.705799
4801	772	2	\N	2014-01-25 16:06:28.321244
4826	788	2	\N	2014-02-01 22:03:21.899916
5151	1004	2	\N	2014-03-04 21:23:52.466966
5152	1004	2	\N	2014-03-04 21:24:11.351815
5153	1004	2	\N	2014-03-04 21:24:20.614224
5429	1206	2	\N	2014-04-09 19:21:09.215561
5154	1004	2	\N	2014-03-04 21:35:47.600889
5155	1004	2	\N	2014-03-04 21:36:05.835492
5156	1004	2	\N	2014-03-04 21:36:16.322673
5432	1210	2	\N	2014-04-12 13:10:08.842351
5472	1241	2	\N	2014-04-26 19:16:28.009797
5539	1308	2	\N	2014-04-30 11:20:34.938154
422	306	2	\N	2013-12-15 21:45:32.990838
4925	864	2	\N	2014-02-09 12:31:10.556265
4802	773	2	\N	2014-01-25 23:45:37.762081
4926	864	2	\N	2014-02-09 12:32:19.155301
4827	789	2	\N	2014-02-02 16:45:11.830435
4954	887	2	\N	2014-02-15 12:32:09.199652
5415	1198	2	\N	2014-04-08 09:35:59.21042
4979	885	2	\N	2014-02-24 12:50:26.694026
4980	786	2	\N	2014-02-24 12:50:29.953348
4981	784	2	\N	2014-02-24 12:50:33.322359
5157	1004	2	\N	2014-03-07 22:30:15.652582
5230	894	2	\N	2014-03-16 11:54:19.683752
5231	894	2	\N	2014-03-16 11:54:28.171778
5232	894	2	\N	2014-03-16 11:54:33.774318
5270	1004	2	\N	2014-03-17 10:50:39.781432
5465	1230	2	\N	2014-04-19 21:03:03.225866
5508	1277	2	\N	2014-04-29 10:08:17.485661
5509	1278	2	\N	2014-04-29 10:09:19.421905
5540	1309	2	\N	2014-04-30 11:32:51.070911
4927	865	2	\N	2014-02-09 13:26:19.008763
4804	775	2	\N	2014-01-26 15:30:50.636495
4928	866	2	\N	2014-02-09 13:26:48.246588
4828	3	2	\N	2014-02-02 17:45:50.239397
4829	780	2	\N	2014-02-02 17:53:21.606939
4830	790	2	\N	2014-02-02 17:53:42.973553
4831	791	2	\N	2014-02-02 17:54:20.864462
4832	792	2	\N	2014-02-02 17:54:57.706749
5416	1199	2	\N	2014-04-08 10:15:32.411146
5434	1211	2	\N	2014-04-12 14:16:34.33498
5435	1211	2	\N	2014-04-12 14:16:53.40729
4982	895	2	\N	2014-02-25 19:06:42.158245
5158	1007	2	\N	2014-03-08 10:30:25.61786
5159	1008	2	\N	2014-03-08 10:30:54.532147
5198	3	2	\N	2014-03-11 13:14:05.142514
5233	1060	2	\N	2014-03-16 12:26:38.52955
5436	1212	2	\N	2014-04-12 14:17:59.589801
5437	1213	2	\N	2014-04-12 14:32:08.840037
5466	1227	2	\N	2014-04-19 21:37:55.580038
5474	1243	2	\N	2014-04-26 22:38:44.326007
5541	1310	2	\N	2014-04-30 22:45:27.579715
5370	1159	2	\N	2014-04-02 19:52:15.193771
4806	777	2	\N	2014-01-26 18:18:05.196211
4807	778	2	\N	2014-01-26 18:18:24.059336
4808	779	2	\N	2014-01-26 18:18:45.188271
4809	780	2	\N	2014-01-26 18:20:19.519217
4888	786	2	\N	2014-02-08 21:26:45.138217
5417	1200	2	\N	2014-04-08 10:35:59.014802
4890	784	2	\N	2014-02-08 21:26:51.98617
4929	870	2	\N	2014-02-09 14:57:54.403714
4967	892	2	\N	2014-02-22 17:14:02.512772
4983	896	2	\N	2014-02-25 19:37:56.226615
4984	897	2	\N	2014-02-25 19:38:21.395798
4985	898	2	\N	2014-02-25 19:38:30.353048
4986	899	2	\N	2014-02-25 19:39:23.588225
4987	900	2	\N	2014-02-25 19:43:55.188369
4988	901	2	\N	2014-02-25 19:47:57.884012
4989	902	2	\N	2014-02-25 19:54:09.470994
5160	1009	2	\N	2014-03-08 10:49:52.0599
5199	3	2	\N	2014-03-12 12:05:31.953558
5438	1214	2	\N	2014-04-12 14:36:07.046988
5475	1244	2	\N	2014-04-26 22:39:00.40778
5542	1311	2	\N	2014-04-30 22:45:36.089534
4894	849	2	\N	2014-02-08 21:32:14.802948
4834	790	2	\N	2014-02-02 18:39:14.383473
4896	851	2	\N	2014-02-08 21:32:32.471247
4897	852	2	\N	2014-02-08 21:36:44.493917
4930	871	2	\N	2014-02-09 16:04:05.85568
4968	892	2	\N	2014-02-22 17:18:17.771894
4990	902	2	\N	2014-02-25 22:32:43.788139
5161	1009	2	\N	2014-03-08 10:52:32.854366
5162	1009	2	\N	2014-03-08 10:52:45.635015
5163	1009	2	\N	2014-03-08 10:52:53.515357
5164	1009	2	\N	2014-03-08 10:52:58.740536
5165	1010	2	\N	2014-03-08 10:54:40.946487
5166	1010	2	\N	2014-03-08 10:54:50.928085
5200	3	2	\N	2014-03-12 12:14:05.203771
5235	897	2	\N	2014-03-16 12:53:37.56753
5278	1067	2	\N	2014-03-18 19:51:01.87448
5375	1164	2	\N	2014-04-02 20:56:42.084197
5376	1165	2	\N	2014-04-02 20:56:48.393173
5419	1201	2	\N	2014-04-08 10:38:31.154572
5440	1214	2	\N	2014-04-12 14:39:05.532456
5442	1214	2	\N	2014-04-12 14:43:11.754556
5513	1282	2	\N	2014-04-29 10:43:05.718429
4898	853	2	\N	2014-02-08 21:39:09.10029
4812	784	2	\N	2014-01-26 21:12:24.209136
4813	784	2	\N	2014-01-26 21:13:10.546575
4814	784	2	\N	2014-01-26 21:13:20.058093
4815	784	2	\N	2014-01-26 21:13:24.693933
4817	786	2	\N	2014-01-26 21:15:00.370561
4818	784	2	\N	2014-01-26 21:20:14.635984
4819	784	2	\N	2014-01-26 21:20:34.941868
4931	274	2	\N	2014-02-10 08:49:31.501202
4969	893	2	\N	2014-02-22 17:26:37.296722
4970	894	2	\N	2014-02-22 17:27:40.771678
4991	903	2	\N	2014-02-25 22:43:46.101171
4992	904	2	\N	2014-02-25 22:43:53.30222
4993	905	2	\N	2014-02-25 22:44:00.024066
4994	906	2	\N	2014-02-25 22:44:13.035203
4995	907	2	\N	2014-02-25 22:44:59.159297
5167	1009	2	\N	2014-03-08 10:57:02.535973
5168	1010	2	\N	2014-03-08 10:57:07.365849
5201	3	2	\N	2014-03-12 12:29:57.686858
5202	3	2	\N	2014-03-12 12:30:07.270368
5203	3	2	\N	2014-03-12 12:30:09.982217
5204	3	2	\N	2014-03-12 12:32:22.25189
5205	894	2	\N	2014-03-12 12:32:26.366205
5236	919	2	\N	2014-03-16 13:33:07.651832
5279	1075	2	\N	2014-03-18 20:16:38.404556
5444	1218	2	\N	2014-04-12 15:00:38.646853
5447	1214	2	\N	2014-04-12 15:02:33.59771
5514	1283	2	\N	2014-04-29 12:06:08.689068
5515	1284	2	\N	2014-04-29 12:07:06.357367
5518	1287	2	\N	2014-04-29 12:09:55.486785
5520	1289	2	\N	2014-04-29 12:11:36.874588
4932	872	2	\N	2014-02-10 14:29:53.759164
4933	873	2	\N	2014-02-10 14:36:29.132134
4934	874	2	\N	2014-02-10 14:36:56.817818
4935	802	2	\N	2014-02-10 14:37:05.778544
4996	908	2	\N	2014-02-25 23:15:44.304324
4997	909	2	\N	2014-02-25 23:16:53.455486
4998	910	2	\N	2014-02-25 23:17:30.650965
4999	911	2	\N	2014-02-25 23:17:53.999146
5000	912	2	\N	2014-02-25 23:21:05.038132
5001	913	2	\N	2014-02-25 23:21:10.720503
5002	914	2	\N	2014-02-25 23:21:15.803027
5003	915	2	\N	2014-02-25 23:21:21.245593
5004	916	2	\N	2014-02-25 23:21:27.843749
5005	917	2	\N	2014-02-25 23:21:40.705852
5006	918	2	\N	2014-02-25 23:21:45.161533
5007	918	2	\N	2014-02-25 23:21:53.74917
5008	918	2	\N	2014-02-25 23:21:57.599668
5009	919	2	\N	2014-02-25 23:22:22.789803
5011	921	2	\N	2014-02-25 23:22:59.534922
5012	922	2	\N	2014-02-25 23:23:04.765473
5013	923	2	\N	2014-02-25 23:23:16.649188
5014	924	2	\N	2014-02-25 23:23:30.151925
5015	925	2	\N	2014-02-25 23:25:11.120354
5016	926	2	\N	2014-02-25 23:26:11.314153
5017	927	2	\N	2014-02-25 23:26:34.378644
5018	928	2	\N	2014-02-25 23:26:49.163639
5019	929	2	\N	2014-02-25 23:27:07.84413
5020	930	2	\N	2014-02-25 23:27:30.797684
5021	931	2	\N	2014-02-25 23:27:45.611037
5022	932	2	\N	2014-02-25 23:28:05.678992
5023	933	2	\N	2014-02-25 23:28:21.001129
5025	935	2	\N	2014-02-25 23:28:49.565248
5026	936	2	\N	2014-02-25 23:29:05.034117
5027	937	2	\N	2014-02-25 23:29:16.11101
5028	938	2	\N	2014-02-25 23:29:28.82178
5029	939	2	\N	2014-02-25 23:29:41.159219
5030	940	2	\N	2014-02-25 23:29:57.589154
5031	941	2	\N	2014-02-25 23:30:12.260571
5032	942	2	\N	2014-02-25 23:30:25.705958
5033	943	2	\N	2014-02-25 23:30:39.278491
5034	944	2	\N	2014-02-25 23:30:54.230938
5035	945	2	\N	2014-02-25 23:31:08.136642
5036	946	2	\N	2014-02-25 23:31:21.084682
5037	947	2	\N	2014-02-25 23:31:35.443235
5038	948	2	\N	2014-02-25 23:31:50.036032
5039	949	2	\N	2014-02-25 23:32:16.232207
5040	950	2	\N	2014-02-25 23:32:51.784126
5169	1011	2	\N	2014-03-08 15:10:44.638516
5206	3	2	\N	2014-03-12 13:00:24.217557
5207	3	2	\N	2014-03-12 13:00:34.025605
5238	1062	2	\N	2014-03-16 15:10:44.294343
5239	1062	2	\N	2014-03-16 15:11:01.269428
5240	858	2	\N	2014-03-16 15:11:06.875279
5241	903	2	\N	2014-03-16 15:12:25.130202
5280	1075	2	\N	2014-03-18 20:59:45.308042
5281	1075	2	\N	2014-03-18 21:01:26.02361
5282	1076	2	\N	2014-03-18 21:03:59.593763
5379	1168	2	\N	2014-04-03 12:39:52.988369
5380	1169	2	\N	2014-04-03 12:49:06.139328
5448	1221	2	\N	2014-04-12 16:44:14.810824
5516	1285	2	\N	2014-04-29 12:08:23.116251
5517	1286	2	\N	2014-04-29 12:09:10.712444
5522	1291	2	\N	2014-04-29 12:13:37.203069
5523	1292	2	\N	2014-04-29 12:14:34.180203
4900	854	2	\N	2014-02-08 21:47:34.439997
4901	855	2	\N	2014-02-08 21:54:55.399628
4936	875	2	\N	2014-02-10 15:58:53.177719
4937	875	2	\N	2014-02-10 15:59:03.43204
5042	952	2	\N	2014-02-25 23:33:14.57009
5043	939	2	\N	2014-02-25 23:33:37.281163
5044	938	2	\N	2014-02-25 23:33:44.033176
5045	937	2	\N	2014-02-25 23:33:51.697991
5046	936	2	\N	2014-02-25 23:33:56.981908
5047	935	2	\N	2014-02-25 23:34:03.037741
5049	933	2	\N	2014-02-25 23:34:27.937885
5050	932	2	\N	2014-02-25 23:34:34.767736
5051	931	2	\N	2014-02-25 23:34:39.075165
5052	930	2	\N	2014-02-25 23:34:43.896812
5053	929	2	\N	2014-02-25 23:34:48.70472
5054	928	2	\N	2014-02-25 23:34:54.494127
5055	927	2	\N	2014-02-25 23:35:00.125101
5056	926	2	\N	2014-02-25 23:35:05.399995
5057	925	2	\N	2014-02-25 23:35:10.409443
5058	924	2	\N	2014-02-25 23:35:16.447517
5059	923	2	\N	2014-02-25 23:35:21.959285
5060	922	2	\N	2014-02-25 23:35:27.383937
5061	921	2	\N	2014-02-25 23:35:31.660307
5063	919	2	\N	2014-02-25 23:35:43.645366
5064	918	2	\N	2014-02-25 23:35:47.480218
5065	917	2	\N	2014-02-25 23:35:52.042922
5066	916	2	\N	2014-02-25 23:35:57.409224
5067	915	2	\N	2014-02-25 23:36:01.802966
5068	914	2	\N	2014-02-25 23:36:05.670476
5069	913	2	\N	2014-02-25 23:36:10.129284
5070	912	2	\N	2014-02-25 23:36:14.468359
5208	1040	2	\N	2014-03-12 20:50:33.871251
5209	1041	2	\N	2014-03-12 20:50:55.466763
5210	1041	2	\N	2014-03-12 20:51:02.123714
5211	1042	2	\N	2014-03-12 20:53:03.003465
5212	1043	2	\N	2014-03-12 20:53:27.910983
5213	1044	2	\N	2014-03-12 20:53:45.921718
5214	1045	2	\N	2014-03-12 20:54:23.054095
5215	1046	2	\N	2014-03-12 20:55:03.071619
5286	1078	2	\N	2014-03-20 21:22:51.030666
5381	1170	2	\N	2014-04-03 12:49:07.793292
5449	1075	2	\N	2014-04-12 16:56:06.775781
5519	1288	2	\N	2014-04-29 12:10:21.572462
5521	1290	2	\N	2014-04-29 12:13:35.434847
4902	856	2	\N	2014-02-08 21:59:04.719245
4938	876	2	\N	2014-02-10 16:19:24.400952
5071	953	2	\N	2014-02-26 23:25:15.548581
5072	954	2	\N	2014-02-26 23:25:55.407709
5073	955	2	\N	2014-02-26 23:26:48.626397
5074	956	2	\N	2014-02-26 23:27:06.354467
5075	957	2	\N	2014-02-26 23:28:34.003373
5076	958	2	\N	2014-02-26 23:28:45.594179
5077	959	2	\N	2014-02-26 23:28:57.004231
5078	960	2	\N	2014-02-26 23:29:08.086342
5079	961	2	\N	2014-02-26 23:29:17.646283
5080	962	2	\N	2014-02-26 23:29:26.175631
5081	963	2	\N	2014-02-26 23:29:35.761623
5082	964	2	\N	2014-02-26 23:29:46.892804
5083	965	2	\N	2014-02-26 23:29:54.140342
5084	966	2	\N	2014-02-26 23:30:01.375033
5085	967	2	\N	2014-02-26 23:30:08.774222
5086	968	2	\N	2014-02-26 23:30:17.802323
5087	969	2	\N	2014-02-26 23:30:29.097872
5088	970	2	\N	2014-02-26 23:30:38.081009
5089	971	2	\N	2014-02-26 23:30:52.902609
5091	973	2	\N	2014-02-26 23:31:31.71567
5093	975	2	\N	2014-02-26 23:32:13.646357
5094	976	2	\N	2014-02-26 23:32:24.624636
5095	977	2	\N	2014-02-26 23:32:34.606814
5096	978	2	\N	2014-02-26 23:32:43.318943
5097	979	2	\N	2014-02-26 23:32:54.081989
5098	980	2	\N	2014-02-26 23:33:04.823892
5099	981	2	\N	2014-02-26 23:33:16.574818
5100	982	2	\N	2014-02-26 23:33:28.270884
5101	983	2	\N	2014-02-26 23:33:40.854578
5102	984	2	\N	2014-02-26 23:33:57.05943
5103	985	2	\N	2014-02-26 23:34:08.238483
5105	987	2	\N	2014-02-26 23:34:29.757456
5106	988	2	\N	2014-02-26 23:34:37.99873
5216	3	2	\N	2014-03-12 21:55:10.706584
5287	1079	2	\N	2014-03-22 12:57:07.526655
5480	1249	2	\N	2014-04-27 01:02:16.23036
5481	1250	2	\N	2014-04-27 01:02:43.699513
5482	1251	2	\N	2014-04-27 01:03:00.011092
5483	1252	2	\N	2014-04-27 01:03:22.219667
5524	1293	2	\N	2014-04-29 12:17:51.658135
5525	1294	2	\N	2014-04-29 12:18:27.913053
5526	1295	2	\N	2014-04-29 12:19:08.236252
4789	763	2	\N	2014-01-12 19:51:49.157909
4903	854	2	\N	2014-02-08 22:16:58.906498
4904	3	2	\N	2014-02-08 22:17:06.939369
4905	854	2	\N	2014-02-08 22:20:32.280238
4906	784	2	\N	2014-02-08 22:21:01.290541
4908	786	2	\N	2014-02-08 22:21:09.110319
5484	1253	2	\N	2014-04-28 00:03:49.599015
5288	1080	2	\N	2014-03-22 17:56:32.875855
5289	1081	2	\N	2014-03-22 17:57:05.076581
4790	764	2	\N	2014-01-12 20:33:53.3138
4909	723	2	\N	2014-02-08 22:28:37.868751
4940	878	2	\N	2014-02-10 16:40:47.442615
5528	1297	2	\N	2014-04-29 14:56:57.894099
5531	1300	2	\N	2014-04-29 15:09:52.91536
5533	1302	2	\N	2014-04-29 15:20:52.336646
4910	857	2	\N	2014-02-09 00:41:07.487567
4911	858	2	\N	2014-02-09 00:41:26.234037
4912	859	2	\N	2014-02-09 00:41:48.428505
4913	860	2	\N	2014-02-09 00:42:12.938208
4914	857	2	\N	2014-02-09 00:42:31.066281
4915	861	2	\N	2014-02-09 00:42:52.234296
4941	879	2	\N	2014-02-10 21:17:56.627306
5291	1088	2	\N	2014-03-22 18:51:18.985681
5292	1081	2	\N	2014-03-22 18:51:44.158872
5293	1089	2	\N	2014-03-22 18:52:26.137124
5458	1225	2	\N	2014-04-13 12:01:26.796233
5529	1298	2	\N	2014-04-29 15:04:08.798582
5530	1299	2	\N	2014-04-29 15:07:15.435124
5532	1301	2	\N	2014-04-29 15:12:08.265284
4917	764	2	\N	2014-02-09 00:53:58.264629
4918	769	2	\N	2014-02-09 00:57:04.796409
4919	775	2	\N	2014-02-09 00:57:24.917548
4920	788	2	\N	2014-02-09 00:57:42.02056
4942	878	2	\N	2014-02-10 22:47:18.374976
4943	880	2	\N	2014-02-10 22:48:37.279277
4944	881	2	\N	2014-02-10 22:49:24.829434
4945	882	2	\N	2014-02-10 22:49:56.066237
4946	883	2	\N	2014-02-10 22:50:06.121122
4947	884	2	\N	2014-02-10 22:50:26.035905
4948	884	2	\N	2014-02-10 22:53:06.689693
5294	1090	2	\N	2014-03-22 20:34:50.666418
5295	1091	2	\N	2014-03-22 20:36:11.95663
5298	1093	2	\N	2014-03-22 20:40:16.040605
5534	1303	2	\N	2014-04-29 15:50:56.347101
4921	838	2	\N	2014-02-09 01:11:46.633177
4949	764	2	\N	2014-02-11 19:47:14.055452
5488	1257	2	\N	2014-04-28 12:34:34.363475
5300	1095	2	\N	2014-03-22 20:52:34.596466
5301	1096	2	\N	2014-03-22 20:52:44.740475
5302	1097	2	\N	2014-03-22 20:53:03.099066
5489	1258	2	\N	2014-04-28 12:34:55.433659
5304	1099	2	\N	2014-03-22 20:57:07.889521
5535	1304	2	\N	2014-04-29 16:15:23.221696
5389	1178	2	\N	2014-04-05 19:40:06.274566
5390	1179	2	\N	2014-04-05 19:40:10.823684
5490	1259	2	\N	2014-04-28 12:58:44.196537
5305	1100	2	\N	2014-03-22 21:00:41.76813
5306	1101	2	\N	2014-03-22 21:00:48.529148
5307	1102	2	\N	2014-03-22 21:01:34.517288
5491	1260	2	\N	2014-04-28 12:59:00.104464
5536	1305	2	\N	2014-04-29 18:26:56.143932
5492	1261	2	\N	2014-04-28 13:04:58.29173
5256	1067	2	\N	2014-03-16 19:34:31.935568
5494	1263	2	\N	2014-04-28 13:08:06.602496
5394	1185	2	\N	2014-04-05 20:56:20.797318
5257	1067	2	\N	2014-03-16 19:55:56.894484
5495	1264	2	\N	2014-04-28 13:08:25.610345
5496	1265	2	\N	2014-04-28 13:08:54.519921
5258	1067	2	\N	2014-03-16 20:09:16.532934
5311	1097	2	\N	2014-03-24 19:59:44.290142
5259	1068	2	\N	2014-03-16 20:15:31.769185
5499	1268	2	\N	2014-04-28 23:55:09.591646
5132	998	2	\N	2014-03-02 17:40:41.982664
4120	16	2	\N	2014-01-01 13:19:09.979922
4131	14	2	\N	2014-01-01 18:45:07.902745
4144	706	2	\N	2014-01-03 16:12:41.015146
4145	706	2	\N	2014-01-03 16:13:23.197097
5402	1189	2	\N	2014-04-06 18:46:40.132797
5403	1190	2	\N	2014-04-06 18:47:22.030146
5136	864	2	\N	2014-03-03 21:07:46.674859
5137	866	2	\N	2014-03-03 21:08:00.013957
5138	865	2	\N	2014-03-03 21:09:34.254642
5404	1191	2	\N	2014-04-06 18:53:34.002074
5263	1009	2	\N	2014-03-16 21:40:10.728496
5264	1009	2	\N	2014-03-16 21:44:11.742442
5405	1192	2	\N	2014-04-06 19:20:55.890208
5140	865	2	\N	2014-03-03 21:57:11.59945
5141	866	2	\N	2014-03-03 21:57:34.76558
5265	1004	2	\N	2014-03-17 10:29:17.115979
5266	1004	2	\N	2014-03-17 10:29:24.701637
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
2	10	users	Users	Users	travelcrm.resources.users	\N	Users list
12	16	resources_types	Resources Types	ResourcesTypes	travelcrm.resources.resources_types	\N	Resources types list
47	706	employees	Employees	Employees	travelcrm.resources.employees	\N	Employees Container Datagrid
78	1003	touroperators	Touroperators	Touroperators	travelcrm.resources.touroperators	\N	Touroperators - tours suppliers list
1	773		Home	Root	travelcrm.resources	\N	Home Page of Travelcrm
41	283	currencies	Currencies	Currencies	travelcrm.resources.currencies	\N	
55	723	structures	Structures	Structures	travelcrm.resources.structures	\N	Companies structures is a tree of company structure. It's can be offices, filials, departments and so and so
59	764	positions	Positions	Positions	travelcrm.resources.positions	\N	Companies positions is a point of company structure where emplyees can be appointed
61	769	permisions	Permisions	Permisions	travelcrm.resources.permisions	\N	Permisions list of company structure position. It's list of resources and permisions
65	775	navigations	Navigations	Navigations	travelcrm.resources.navigations	\N	Navigations list of company structure position.
67	788	appointments	Appointments	Appointments	travelcrm.resources.appointments	\N	Employees to positions of company appointments
39	274	regions	Regions	Regions	travelcrm.resources.regions	\N	
70	872	countries	Countries	Countries	travelcrm.resources.countries	\N	Countries directory
71	901	advsources	Advertise Sources	Advsources	travelcrm.resources.advsources	\N	Types of advertises
72	908	hotelcats	Hotels Categories	Hotelcats	travelcrm.resources.hotelcats	\N	Hotels categories
73	909	roomcats	Rooms Categories	Roomcats	travelcrm.resources.roomcats	\N	Categories of the rooms
74	953	accomodations	Accomodations	Accomodations	travelcrm.resources.accomodations	\N	Accomodations Types list
75	954	foodcats	Food Categories	Foodcats	travelcrm.resources.foodcats	\N	Food types in hotels
69	865	persons	Persons	Persons	travelcrm.resources.persons	\N	Persons directory. Person can be client or potential client
79	1007	bpersons	Business Persons	BPersons	travelcrm.resources.bpersons	\N	Business Persons is not clients it's simple business contacts that can be referenced objects that needs to have contacts
84	1088	locations	Locations	Locations	travelcrm.resources.locations	\N	Locations list is list of cities, vilages etc. places to use to identify part of region
83	1081	hotels	Hotels	Hotels	travelcrm.resources.hotels	\N	Hotels directory
86	1189	licences	Licences	Licences	travelcrm.resources.licences	\N	Licences list for any type of resources as need
87	1190	contacts	Contacts	Contacts	travelcrm.resources.contacts	\N	Contacts for persons, business persons etc.
89	1198	passports	Passports	Passports	travelcrm.resources.passports	\N	Clients persons passports lists
90	1207	addresses	Addresses	Addresses	travelcrm.resources.addresses	\N	Addresses of any type of resources, such as persons, bpersons, hotels etc.
91	1211	banks	Banks	Banks	travelcrm.resources.banks	\N	Banks list to create bank details and for other reasons
92	1221	tours	Tours	Tours	travelcrm.resources.tours	\N	Tour creation and sale it
93	1225	tasks	Tasks	Tasks	travelcrm.resources.tasks	\N	Task manager
101	1268	banks_details	Banks Details	BanksDetails	travelcrm.resources.banks_details	\N	Banks Details that can be attached any client or business partner to define account
\.


--
-- Data for Name: roomcat; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY roomcat (id, resource_id, name) FROM stdin;
2	921	BDR
3	922	BDRM
4	923	Superior
5	924	Studio
6	925	Family Room
7	926	Family Studio
8	927	Extra Bed
9	928	Suite
10	929	Suite Mini
11	930	Junior Suite
12	931	De Luxe
13	932	Executive Suite
14	933	Suite Senior
16	935	Honeymoon Room
17	936	Connected Rooms
18	937	Duplex
19	938	Apartment
20	939	President
21	940	Balcony
22	941	City View
23	942	Beach View
24	943	Pool View
25	944	Garden View
26	945	Ocean View
27	946	Land View
28	947	Dune View
29	948	Mountain View
30	949	Park View
31	950	SV (Sea view)
33	952	Inside View
\.


--
-- Name: roomcat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('roomcat_id_seq', 33, true);


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
7	1062	\N	Moscow Office
8	1250	\N	Odessa Office
9	1251	8	Sales Department
11	1277	\N	Lviv Office
\.


--
-- Data for Name: structure_address; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY structure_address (structure_id, address_id) FROM stdin;
\.


--
-- Data for Name: structure_bank_detail; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY structure_bank_detail (structure_id, bank_detail_id) FROM stdin;
\.


--
-- Data for Name: structure_contact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY structure_contact (structure_id, contact_id) FROM stdin;
\.


--
-- Name: structures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('structures_id_seq', 12, true);


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY task (id, resource_id, employee_id, title, deadline, reminder, descr, priority, status) FROM stdin;
11	1298	2	Task functionality completion	2014-05-17	\N	Complete Tasks Functionality<p></p><ol><li>Make Tasks Comments</li><li>Make Tasks Reminders</li><li>Make Tasks bindings to resources</li><li>Make possibility to create tasks from resources</li><li>Make Tasks filters to find tasks by priority, status, etc.</li><li>Bugfixing with tasks</li><li>Tasks sorting</li></ol><p></p>	2	2
12	1299	2	Billing Functionality	2014-05-10	\N	Requirements is in progress now	2	3
13	1300	2	Inline actions in grid rows	2014-05-10	\N	Rework with rows actions in grids. Make actions in grid rows	2	3
14	1301	2	Restrictions in foreign keys	2014-05-10	\N	Rework foreign keys in DB, make it restricted to avoid critical aftermath after resources deletion.	3	1
15	1302	2	Translate CRM for RU, UA	2014-05-09	\N	\N	2	1
16	1303	2	Widgets functionality	2014-05-10	\N	Make widgets functionality for Home or other places	1	3
17	1305	2	Fulltext search functionality	2014-05-10	\N	Make full text search functionality	2	3
10	1297	2	Invoices and Contracts	2014-05-10	\N	To provide Billing functionality:<p><ol><li>Add Invoice creattion functionality from sales documents</li><li>Add Contract creation using structures Banks Details</li></ol></p>	2	2
\.


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('task_id_seq', 17, true);


--
-- Data for Name: task_resource; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY task_resource (task_id, resource_id) FROM stdin;
\.


--
-- Data for Name: tour; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY tour (id, touroperator_id, start_location_id, end_location_id, currency_id, price, adults, children, customer_id, resource_id, end_date, start_date, deal_date, advsource_id) FROM stdin;
9	5	15	15	54	2350.0000	2	1	17	1295	2014-05-09	2014-05-01	2014-04-29	6
\.


--
-- Name: tour_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('tour_id_seq', 9, true);


--
-- Data for Name: tour_person; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY tour_person (tour_id, person_id) FROM stdin;
9	19
9	17
9	18
\.


--
-- Data for Name: tour_point; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY tour_point (id, location_id, hotel_id, accomodation_id, foodcat_id, roomcat_id, tour_id, description, end_date, start_date) FROM stdin;
60	16	10	14	10	30	9	All include, Adriatic Sea, excursions and transfer included	2014-05-09	2014-05-01
\.


--
-- Name: tour_point_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('tour_point_id_seq', 60, true);


--
-- Data for Name: touroperator; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator (id, resource_id, name) FROM stdin;
1	1004	Turtess Travel
2	1005	Coral Travel
5	1067	Sail Croatia
57	1159	Sun Marino Trvl.
\.


--
-- Data for Name: touroperator_bank_detail; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator_bank_detail (touroperator_id, bank_detail_id) FROM stdin;
\.


--
-- Data for Name: touroperator_bperson; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator_bperson (touroperator_id, bperson_id) FROM stdin;
5	1
\.


--
-- Name: touroperator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('touroperator_id_seq', 60, true);


--
-- Data for Name: touroperator_licence; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator_licence (touroperator_id, licence_id) FROM stdin;
2	44
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY "user" (id, resource_id, username, email, password, employee_id) FROM stdin;
23	894	maziv	\N	maziv_maziv	7
2	3	admin	vitalii.mazur@gmail.com	adminadmin	2
\.


--
-- Name: accomodation_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT accomodation_pkey PRIMARY KEY (id);


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: advsource_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT advsource_pkey PRIMARY KEY (id);


--
-- Name: appointment_header_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT appointment_header_pk PRIMARY KEY (id);


--
-- Name: bank_address_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT bank_address_pkey PRIMARY KEY (bank_id, address_id);


--
-- Name: bank_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT bank_detail_pkey PRIMARY KEY (id);


--
-- Name: bank_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (id);


--
-- Name: bperson_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT bperson_contact_pkey PRIMARY KEY (bperson_id, contact_id);


--
-- Name: bperson_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY bperson
    ADD CONSTRAINT bperson_pkey PRIMARY KEY (id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: currency_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT currency_pk PRIMARY KEY (id);


--
-- Name: employee_address_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT employee_address_pkey PRIMARY KEY (employee_id, address_id);


--
-- Name: employee_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT employee_contact_pkey PRIMARY KEY (employee_id, contact_id);


--
-- Name: employee_passport_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT employee_passport_pkey PRIMARY KEY (employee_id, passport_id);


--
-- Name: employee_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pk PRIMARY KEY (id);


--
-- Name: foodcat_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT foodcat_pkey PRIMARY KEY (id);


--
-- Name: hotel_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (id);


--
-- Name: hotelcat_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT hotelcat_pkey PRIMARY KEY (id);


--
-- Name: licence_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY licence
    ADD CONSTRAINT licence_pkey PRIMARY KEY (id);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: navigation_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT navigation_pk PRIMARY KEY (id);


--
-- Name: passport_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY (id);


--
-- Name: permision_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT permision_pk PRIMARY KEY (id);


--
-- Name: person_address_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT person_address_pkey PRIMARY KEY (person_id, address_id);


--
-- Name: person_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT person_contact_pkey PRIMARY KEY (person_id, contact_id);


--
-- Name: person_passport_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT person_passport_pkey PRIMARY KEY (person_id, passport_id);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


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
-- Name: resource_type_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT resource_type_pk PRIMARY KEY (id);


--
-- Name: roomcat_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT roomcat_pkey PRIMARY KEY (id);


--
-- Name: structure_address_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT structure_address_pkey PRIMARY KEY (structure_id, address_id);


--
-- Name: structure_bank_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT structure_bank_detail_pkey PRIMARY KEY (structure_id, bank_detail_id);


--
-- Name: structure_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT structure_contact_pkey PRIMARY KEY (structure_id, contact_id);


--
-- Name: structure_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT structure_pk PRIMARY KEY (id);


--
-- Name: task_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: task_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT task_resource_pkey PRIMARY KEY (task_id, resource_id);


--
-- Name: tour_person_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY tour_person
    ADD CONSTRAINT tour_person_pkey PRIMARY KEY (tour_id, person_id);


--
-- Name: tour_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT tour_pkey PRIMARY KEY (id);


--
-- Name: tour_point_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY tour_point
    ADD CONSTRAINT tour_point_pkey PRIMARY KEY (id);


--
-- Name: touroperator_bank_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY touroperator_bank_detail
    ADD CONSTRAINT touroperator_bank_detail_pkey PRIMARY KEY (touroperator_id, bank_detail_id);


--
-- Name: touroperator_licence_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY touroperator_licence
    ADD CONSTRAINT touroperator_licence_pkey PRIMARY KEY (touroperator_id, licence_id);


--
-- Name: touroperator_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY touroperator
    ADD CONSTRAINT touroperator_pkey PRIMARY KEY (id);


--
-- Name: unique_idx_accomodation_name; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT unique_idx_accomodation_name UNIQUE (name);


--
-- Name: unique_idx_country_iso_code; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT unique_idx_country_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_currency_iso_code; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT unique_idx_currency_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_name_advsource; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT unique_idx_name_advsource UNIQUE (name);


--
-- Name: unique_idx_name_bank; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT unique_idx_name_bank UNIQUE (name);


--
-- Name: unique_idx_name_country_id_region; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT unique_idx_name_country_id_region UNIQUE (name, country_id);


--
-- Name: unique_idx_name_foodcat; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT unique_idx_name_foodcat UNIQUE (name);


--
-- Name: unique_idx_name_hotelcat; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT unique_idx_name_hotelcat UNIQUE (name);


--
-- Name: unique_idx_name_region_id_location; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT unique_idx_name_region_id_location UNIQUE (name, region_id);


--
-- Name: unique_idx_name_roomcat; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT unique_idx_name_roomcat UNIQUE (name);


--
-- Name: unique_idx_name_strcuture_id_position; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT unique_idx_name_strcuture_id_position UNIQUE (name, structure_id);


--
-- Name: unique_idx_name_touroperator; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY touroperator
    ADD CONSTRAINT unique_idx_name_touroperator UNIQUE (name);


--
-- Name: unique_idx_resource_type_id_position_id_permision; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT unique_idx_resource_type_id_position_id_permision UNIQUE (resource_type_id, position_id);


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
-- Name: fk_accomodation_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_point
    ADD CONSTRAINT fk_accomodation_id_tour_point FOREIGN KEY (accomodation_id) REFERENCES accomodation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_bank_address; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT fk_address_id_bank_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_employee_address; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT fk_address_id_employee_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_person_address; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT fk_address_id_person_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_structure_address; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT fk_address_id_structure_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_advsource_id_tour FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_structure_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_touroperator_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_touroperator_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_id_bank_address; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT fk_bank_id_bank_address FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_id_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_bank_id_bank_detail FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bperson_id_bperson_contact; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT fk_bperson_id_bperson_contact FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bperson_id_touroperator_bperson; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_bperson
    ADD CONSTRAINT fk_bperson_id_touroperator_bperson FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_bperson_contact; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT fk_contact_id_bperson_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_employee_contact; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT fk_contact_id_employee_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_person_contact; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT fk_contact_id_person_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_structure_contact; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT fk_contact_id_structure_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_country_id_passport; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_country_id_passport FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_appointment; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_currency_id_appointment FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_currency_id_bank_detail FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_currency_id_tour FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: fk_customer_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_customer_id_tour FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_appointment; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_employee_id_appointment FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_address; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT fk_employee_id_employee_address FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_contact; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT fk_employee_id_employee_contact FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_passport; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_employee_id_employee_passport FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_resource_log; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_employee_id_resource_log FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_task; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_employee_id_task FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_user; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_employee_id_user FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_location_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_end_location_id_tour FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_foodcat_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_point
    ADD CONSTRAINT fk_foodcat_id_tour_point FOREIGN KEY (foodcat_id) REFERENCES foodcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotel_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_point
    ADD CONSTRAINT fk_hotel_id_tour_point FOREIGN KEY (hotel_id) REFERENCES hotel(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotelcat_id_hotel; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_hotelcat_id_hotel FOREIGN KEY (hotelcat_id) REFERENCES hotelcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_licence_id_touroperator_licence; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_licence
    ADD CONSTRAINT fk_licence_id_touroperator_licence FOREIGN KEY (licence_id) REFERENCES licence(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_address; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY address
    ADD CONSTRAINT fk_location_id_address FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_hotel; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_location_id_hotel FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_point
    ADD CONSTRAINT fk_location_id_tour_point FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_navigation_position_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_navigation_position_id FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_parent_id_navigation; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_parent_id_navigation FOREIGN KEY (parent_id) REFERENCES navigation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_employee_passport; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_passport_id_employee_passport FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_person_passport; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_passport_id_person_passport FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_permision_structure_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_permision_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_address; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT fk_person_id_person_address FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_contact; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT fk_person_id_person_contact FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_passport; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_person_id_person_passport FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_tour_person; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_person
    ADD CONSTRAINT fk_person_id_tour_person FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_position_id_appointment; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_position_id_appointment FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_position_id_permision; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_position_id_permision FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_position_structure_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_position_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_region_country_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_region_country_id FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_region_id_location; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_region_id_location FOREIGN KEY (region_id) REFERENCES region(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_accomodation; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT fk_resource_id_accomodation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_address; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY address
    ADD CONSTRAINT fk_resource_id_address FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_advsource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT fk_resource_id_advsource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_appointment; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_resource_id_appointment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bank; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT fk_resource_id_bank FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_resource_id_bank_detail FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bperson; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bperson
    ADD CONSTRAINT fk_resource_id_bperson FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_contact; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT fk_resource_id_contact FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_country; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY country
    ADD CONSTRAINT fk_resource_id_country FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_currency; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT fk_resource_id_currency FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_employee; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_resource_id_employee FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_foodcat; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT fk_resource_id_foodcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_hotel; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_resource_id_hotel FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_hotelcat; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT fk_resource_id_hotelcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_licence; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY licence
    ADD CONSTRAINT fk_resource_id_licence FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_location; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_resource_id_location FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_navigation; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_resource_id_navigation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_passport; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_resource_id_passport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_person; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_resource_id_person FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_position; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_resource_id_position FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_region; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_resource_id_region FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_resource_log; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_resource_id_resource_log FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_resource_type; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT fk_resource_id_resource_type FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_roomcat; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT fk_resource_id_roomcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_structure; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_resource_id_structure FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_task; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_resource_id_task FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_task_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_resource_id_task_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_touroperator; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator
    ADD CONSTRAINT fk_resource_id_touroperator FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_user; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_resource_id_user FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_type_id_permission; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_resource_type_id_permission FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_type_id_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_resource_type_id_resource FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_roomcat_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_point
    ADD CONSTRAINT fk_roomcat_id_tour_point FOREIGN KEY (roomcat_id) REFERENCES roomcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_start_location_id_tour FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_structure_id_resource FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_address; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT fk_structure_id_structure_address FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_structure_id_structure_bank_detail FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_contact; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT fk_structure_id_structure_contact FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_parent_id FOREIGN KEY (parent_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_task_id_task_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_task_id_task_resource FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_person; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_person
    ADD CONSTRAINT fk_tour_id_tour_person FOREIGN KEY (tour_id) REFERENCES tour(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_point
    ADD CONSTRAINT fk_tour_id_tour_point FOREIGN KEY (tour_id) REFERENCES tour(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_touroperator_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_touroperator_id_tour FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_touroperator_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_bank_detail
    ADD CONSTRAINT fk_touroperator_id_touroperator_bank_detail FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_touroperator_bperson; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_bperson
    ADD CONSTRAINT fk_touroperator_id_touroperator_bperson FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_touroperator_licence; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_licence
    ADD CONSTRAINT fk_touroperator_id_touroperator_licence FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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

