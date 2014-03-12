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
-- Name: _tappointment_row; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE _tappointment_row (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    position_id integer NOT NULL,
    main_id integer,
    temporal_id integer NOT NULL,
    deleted boolean DEFAULT false
);


ALTER TABLE public._tappointment_row OWNER TO mazvv;

--
-- Name: _tappointment_row_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _tappointment_row_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._tappointment_row_id_seq OWNER TO mazvv;

--
-- Name: _tappointment_row_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _tappointment_row_id_seq OWNED BY _tappointment_row.id;


--
-- Name: _tbperson; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE _tbperson (
    id integer NOT NULL,
    temporal_id integer NOT NULL,
    first_name character varying(32) NOT NULL,
    last_name character varying(32),
    second_name character varying(32),
    position_name character varying(64),
    deleted boolean,
    main_id integer
);


ALTER TABLE public._tbperson OWNER TO mazvv;

--
-- Name: _tbperson_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _tbperson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._tbperson_id_seq OWNER TO mazvv;

--
-- Name: _tbperson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _tbperson_id_seq OWNED BY _tbperson.id;


--
-- Name: _tcontact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE _tcontact (
    id integer NOT NULL,
    temporal_id integer NOT NULL,
    contact_type contact_type_enum NOT NULL,
    contact character varying NOT NULL,
    deleted boolean,
    main_id integer
);


ALTER TABLE public._tcontact OWNER TO mazvv;

--
-- Name: _tcontact_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _tcontact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._tcontact_id_seq OWNER TO mazvv;

--
-- Name: _tcontact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _tcontact_id_seq OWNED BY _tcontact.id;


--
-- Name: _temporal; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE _temporal (
    id integer NOT NULL,
    createdt timestamp without time zone,
    modifydt timestamp without time zone
);


ALTER TABLE public._temporal OWNER TO mazvv;

--
-- Name: _temporal_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _temporal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._temporal_id_seq OWNER TO mazvv;

--
-- Name: _temporal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _temporal_id_seq OWNED BY _temporal.id;


--
-- Name: _tlicence; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE _tlicence (
    id integer NOT NULL,
    temporal_id integer NOT NULL,
    licence_num character varying NOT NULL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    deleted boolean,
    main_id integer
);


ALTER TABLE public._tlicence OWNER TO mazvv;

--
-- Name: _tlicence_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _tlicence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._tlicence_id_seq OWNER TO mazvv;

--
-- Name: _tlicence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _tlicence_id_seq OWNED BY _tlicence.id;


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
    resource_id integer NOT NULL
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
    appointment_date date
);


ALTER TABLE public.appointment OWNER TO mazvv;

--
-- Name: appointment_row; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE appointment_row (
    id integer NOT NULL,
    appointment_id integer NOT NULL,
    employee_id integer NOT NULL,
    position_id integer NOT NULL
);


ALTER TABLE public.appointment_row OWNER TO mazvv;

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
    contact_type contact_type_enum NOT NULL
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
    resource_id integer NOT NULL
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
-- Name: touroperator; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE touroperator (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE public.touroperator OWNER TO mazvv;

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

ALTER TABLE ONLY _tappointment_row ALTER COLUMN id SET DEFAULT nextval('_tappointment_row_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY _tbperson ALTER COLUMN id SET DEFAULT nextval('_tbperson_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY _tcontact ALTER COLUMN id SET DEFAULT nextval('_tcontact_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY _temporal ALTER COLUMN id SET DEFAULT nextval('_temporal_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY _tlicence ALTER COLUMN id SET DEFAULT nextval('_tlicence_id_seq'::regclass);


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

ALTER TABLE ONLY appointment_row ALTER COLUMN id SET DEFAULT nextval('employees_appointments_r_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY attachment ALTER COLUMN id SET DEFAULT nextval('_attachments_rid_seq'::regclass);


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

ALTER TABLE ONLY touroperator ALTER COLUMN id SET DEFAULT nextval('touroperator_id_seq'::regclass);


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

SELECT pg_catalog.setval('_currencies_rid_seq', 49, true);


--
-- Name: _employees_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_employees_rid_seq', 15, true);


--
-- Name: _regions_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_regions_rid_seq', 11, true);


--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_logs_rid_seq', 5216, true);


--
-- Name: _resources_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_rid_seq', 1046, true);


--
-- Name: _resources_types_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_types_rid_seq', 80, true);


--
-- Data for Name: _tappointment_row; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY _tappointment_row (id, employee_id, position_id, main_id, temporal_id, deleted) FROM stdin;
\.


--
-- Name: _tappointment_row_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_tappointment_row_id_seq', 34, true);


--
-- Data for Name: _tbperson; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY _tbperson (id, temporal_id, first_name, last_name, second_name, position_name, deleted, main_id) FROM stdin;
1	75	Alexandro	Guardia		Sales Manager	f	\N
2	76	Alexandro	Averin		Sales Manager	f	\N
3	78	Denny	Malivsky		Sales Manager	f	\N
\.


--
-- Name: _tbperson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_tbperson_id_seq', 3, true);


--
-- Data for Name: _tcontact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY _tcontact (id, temporal_id, contact_type, contact, deleted, main_id) FROM stdin;
1	1	phone	+380681983869	f	\N
2	1	email	vitalii.mazur@gmail.com	f	\N
3	1	phone	sadaf sadfsd	f	\N
4	2	phone	;'l;lk;lk;	f	\N
5	3	phone	+380681983869	t	\N
7	3	email	vitalii.mazur@gmail.com	f	\N
6	3	phone	+380681983869	f	\N
9	4	phone	vitalii.mazur@gmail.com	t	\N
8	4	phone	+380681983869	t	\N
10	4	phone	54645132123	t	\N
11	5	phone	+380681983869	f	\N
12	6	email	vitalii.mazur@gmail.com	f	\N
13	6	skype	dorianyats	f	\N
14	11	phone	+380681983873	f	\N
15	19	phone	+380681983873	f	\N
16	19	email	iren.mazur@gmail.com	f	\N
19	22	phone	+381681983873	f	\N
27	26	phone	+380681983869	f	\N
28	26	email	vitalii.mazur@gmail.com	f	\N
29	26	skype	dorianyats	f	\N
32	29	phone	12346545	f	\N
34	32	phone	+380681983869	f	\N
35	32	email	vitalii.mazur@gmail.com	f	\N
36	32	skype	dorianyats	f	\N
40	34	email	vitalii.mazur@gmail.com	f	\N
41	35	phone	+380681983869	f	\N
42	35	email	vitalii.mazur@gmail.com	f	\N
43	35	skype	dorianyats	f	\N
44	36	phone	+380681983873	t	\N
45	36	phone	+380681983873	t	\N
46	37	skype	xcvbxcvbxcv	t	\N
48	74	phone	+380681325656	f	\N
49	74	email	test_tb@email.com	t	\N
50	75	phone	+525523654123	f	\N
51	75	phone	+525565488952	f	\N
52	76	phone	+525512345466	f	\N
53	78	phone	+525512356985	f	\N
54	80	phone	+525563254821	f	\N
55	81	phone	+525545625332	f	\N
\.


--
-- Name: _tcontact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_tcontact_id_seq', 55, true);


--
-- Data for Name: _temporal; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY _temporal (id, createdt, modifydt) FROM stdin;
1	\N	2014-03-02 12:16:07.833883
2	\N	2014-03-02 12:47:22.304384
3	\N	2014-03-02 12:48:36.241876
4	\N	2014-03-02 12:50:41.685846
5	\N	2014-03-02 13:20:18.416808
6	\N	2014-03-02 13:20:55.183989
7	\N	2014-03-02 13:21:47.624372
8	\N	2014-03-02 13:22:02.098652
9	\N	2014-03-02 13:29:20.999308
10	\N	2014-03-02 13:30:30.140158
11	\N	2014-03-02 13:43:29.335021
12	\N	2014-03-02 13:44:23.789512
13	\N	2014-03-02 13:44:49.93306
14	\N	2014-03-02 14:01:49.501363
15	\N	2014-03-02 14:02:30.651692
16	\N	2014-03-02 14:03:25.193367
17	\N	2014-03-02 14:03:57.605595
18	\N	2014-03-02 14:04:09.961526
19	\N	2014-03-02 14:06:48.117559
20	\N	2014-03-02 14:08:32.493909
21	\N	2014-03-02 14:09:35.381369
22	\N	2014-03-02 14:09:47.554578
23	\N	2014-03-02 14:10:01.809685
24	\N	2014-03-02 14:11:41.827964
25	\N	2014-03-02 14:11:57.622049
26	\N	2014-03-02 14:25:07.890608
27	\N	2014-03-02 14:26:19.81933
28	\N	2014-03-02 14:26:30.516835
29	\N	2014-03-02 14:29:32.479434
30	\N	2014-03-02 14:29:53.586292
31	\N	2014-03-02 14:30:04.800283
32	\N	2014-03-02 14:30:33.031611
33	\N	2014-03-02 14:31:16.603864
34	\N	2014-03-02 14:31:24.612921
35	\N	2014-03-02 14:33:36.507878
36	\N	2014-03-02 17:05:01.596174
37	\N	2014-03-02 17:22:33.776131
38	\N	2014-03-02 17:22:56.059971
39	\N	2014-03-02 17:23:07.037903
40	\N	2014-03-02 18:27:58.483841
41	\N	2014-03-02 18:32:43.706011
42	\N	2014-03-03 20:37:03.65229
43	\N	2014-03-03 21:59:39.615971
44	\N	2014-03-04 21:07:58.358789
45	\N	2014-03-04 21:08:58.398155
46	\N	2014-03-04 21:09:48.330006
47	\N	2014-03-04 21:10:00.276054
48	\N	2014-03-04 21:12:30.420355
49	\N	2014-03-04 21:17:25.564273
50	\N	2014-03-04 21:22:43.401456
51	\N	2014-03-04 21:23:06.027667
52	\N	2014-03-04 21:23:18.776932
53	\N	2014-03-04 21:23:27.348273
54	\N	2014-03-04 21:23:40.813247
55	\N	2014-03-04 21:23:54.89374
56	\N	2014-03-04 21:24:03.980426
57	\N	2014-03-04 21:24:12.970243
58	\N	2014-03-04 21:24:42.987718
59	\N	2014-03-04 21:25:43.220533
60	\N	2014-03-04 21:34:59.898267
61	\N	2014-03-04 21:35:53.032473
62	\N	2014-03-04 21:36:08.07329
63	\N	2014-03-04 21:36:18.036486
64	\N	2014-03-07 19:56:20.452894
65	\N	2014-03-07 19:58:56.876577
66	\N	2014-03-07 20:00:26.150434
67	\N	2014-03-07 20:01:11.70917
68	\N	2014-03-07 20:04:57.417582
69	\N	2014-03-07 20:05:16.841513
70	\N	2014-03-07 20:29:38.854819
71	\N	2014-03-07 20:37:25.877289
72	\N	2014-03-07 21:43:43.518766
73	\N	2014-03-07 21:50:38.018683
74	\N	2014-03-07 22:06:37.675894
75	\N	2014-03-07 22:18:51.192611
76	\N	2014-03-07 22:30:19.452246
77	\N	2014-03-07 22:38:37.105461
78	\N	2014-03-07 22:38:41.678284
79	\N	2014-03-08 10:49:15.181317
80	\N	2014-03-08 10:49:58.116562
81	\N	2014-03-08 10:51:20.805253
82	\N	2014-03-08 10:52:36.556548
83	\N	2014-03-08 10:52:48.54787
84	\N	2014-03-08 10:52:55.290322
85	\N	2014-03-08 10:54:09.696259
86	\N	2014-03-08 10:54:48.54906
87	\N	2014-03-08 10:55:44.464501
88	\N	2014-03-08 10:57:05.143735
89	\N	2014-03-08 10:59:04.148157
90	\N	2014-03-08 12:31:21.057083
91	\N	2014-03-08 12:36:00.444948
92	\N	2014-03-08 15:00:38.633772
93	\N	2014-03-08 15:00:46.449223
94	\N	2014-03-08 15:01:02.171331
95	\N	2014-03-08 16:09:28.543328
96	\N	2014-03-08 16:09:58.34606
97	\N	2014-03-08 16:11:20.053204
98	\N	2014-03-08 16:12:18.986173
99	\N	2014-03-08 16:16:00.387488
100	\N	2014-03-08 16:19:03.620599
101	\N	2014-03-08 16:21:25.752034
102	\N	2014-03-08 16:30:51.760052
103	\N	2014-03-08 16:36:59.745114
104	\N	2014-03-08 16:42:41.965372
105	\N	2014-03-08 16:52:02.618419
106	\N	2014-03-08 16:54:04.058941
107	\N	2014-03-08 17:03:51.570883
108	\N	2014-03-08 17:04:26.299383
109	\N	2014-03-08 17:06:27.293094
110	\N	2014-03-08 17:11:52.04958
111	\N	2014-03-08 17:14:07.641253
112	\N	2014-03-08 17:18:57.458218
113	\N	2014-03-08 17:19:20.987963
114	\N	2014-03-08 17:53:19.553685
115	\N	2014-03-08 17:53:53.063128
116	\N	2014-03-08 18:12:03.001446
117	\N	2014-03-08 22:58:05.409738
118	\N	2014-03-08 22:59:51.527491
119	\N	2014-03-08 23:01:46.172766
120	\N	2014-03-08 23:02:19.307063
121	\N	2014-03-08 23:02:58.823037
122	\N	2014-03-08 23:03:46.969697
123	\N	2014-03-08 23:05:07.242205
124	\N	2014-03-08 23:05:29.241738
125	\N	2014-03-08 23:11:01.745564
126	\N	2014-03-08 23:12:32.01641
127	\N	2014-03-08 23:20:37.190725
128	\N	2014-03-08 23:21:45.112045
129	\N	2014-03-08 23:22:29.634767
130	\N	2014-03-08 23:24:20.347292
131	\N	2014-03-08 23:24:36.02038
132	\N	2014-03-08 23:31:07.87584
133	\N	2014-03-08 23:38:43.12668
134	\N	2014-03-08 23:39:06.529968
135	\N	2014-03-08 23:47:17.158443
136	\N	2014-03-08 23:49:57.226015
137	\N	2014-03-08 23:51:25.700479
138	\N	2014-03-08 23:53:14.960886
139	\N	2014-03-08 23:59:08.3306
140	\N	2014-03-08 23:59:42.964627
141	\N	2014-03-09 00:00:17.301777
142	\N	2014-03-09 00:00:56.037325
143	\N	2014-03-09 00:01:03.876063
144	\N	2014-03-09 00:01:36.892077
145	\N	2014-03-09 00:02:05.164317
146	\N	2014-03-09 00:02:58.701324
147	\N	2014-03-09 00:03:13.876869
148	\N	2014-03-09 00:03:22.156708
149	\N	2014-03-09 00:03:40.987761
150	\N	2014-03-09 00:05:34.972222
151	\N	2014-03-09 00:07:13.920876
152	\N	2014-03-09 00:08:39.766272
153	\N	2014-03-09 00:09:11.392462
154	\N	2014-03-09 00:14:19.604987
155	\N	2014-03-09 00:15:06.781497
156	\N	2014-03-09 00:16:23.974532
157	\N	2014-03-09 00:16:54.613058
158	\N	2014-03-09 00:23:37.5799
159	\N	2014-03-09 00:24:12.456939
160	\N	2014-03-09 00:25:42.076082
161	\N	2014-03-09 00:26:48.499714
162	\N	2014-03-09 00:28:10.81375
163	\N	2014-03-09 00:30:17.542693
164	\N	2014-03-09 00:35:01.507511
165	\N	2014-03-09 00:36:15.955103
166	\N	2014-03-09 00:36:33.034404
167	\N	2014-03-09 00:38:53.664338
168	\N	2014-03-09 00:41:52.035044
169	\N	2014-03-09 10:42:01.629818
170	\N	2014-03-09 10:46:44.054487
171	\N	2014-03-09 10:49:03.422065
172	\N	2014-03-09 11:15:17.206162
173	\N	2014-03-09 11:16:30.007022
174	\N	2014-03-09 11:29:50.613524
175	\N	2014-03-09 11:33:33.316508
176	\N	2014-03-09 11:35:02.659349
177	\N	2014-03-09 11:36:35.848752
178	\N	2014-03-09 11:37:04.052073
179	\N	2014-03-09 11:37:27.259873
180	\N	2014-03-09 11:37:56.988304
181	\N	2014-03-09 11:38:27.564444
182	\N	2014-03-09 11:42:51.905829
183	\N	2014-03-09 11:52:09.405307
184	\N	2014-03-09 11:55:43.262925
185	\N	2014-03-09 12:09:36.520738
186	\N	2014-03-09 12:18:37.718849
187	\N	2014-03-09 12:18:50.341219
188	\N	2014-03-09 12:19:33.882235
189	\N	2014-03-09 12:20:46.733948
190	\N	2014-03-09 12:23:24.623881
191	\N	2014-03-09 12:41:10.331506
192	\N	2014-03-09 12:43:33.212464
193	\N	2014-03-09 12:46:05.005218
194	\N	2014-03-09 12:46:36.629789
195	\N	2014-03-09 13:10:56.855211
196	\N	2014-03-09 13:36:38.517963
197	\N	2014-03-09 13:41:01.978504
198	\N	2014-03-09 13:45:04.819227
199	\N	2014-03-09 13:51:06.762126
200	\N	2014-03-09 13:52:38.444505
201	\N	2014-03-09 13:58:11.115853
202	\N	2014-03-09 14:06:33.560719
203	\N	2014-03-09 14:07:55.588623
204	\N	2014-03-09 14:09:22.886572
205	\N	2014-03-09 14:12:55.48799
206	\N	2014-03-09 14:14:56.412951
207	\N	2014-03-09 14:20:27.9756
208	\N	2014-03-09 14:24:20.818685
209	\N	2014-03-09 14:26:07.162899
210	\N	2014-03-09 14:27:02.016521
211	\N	2014-03-09 14:27:51.649217
212	\N	2014-03-09 14:29:49.498304
213	\N	2014-03-09 14:31:41.744068
214	\N	2014-03-09 16:50:30.504155
215	\N	2014-03-09 16:54:02.384315
216	\N	2014-03-09 17:06:56.820459
217	\N	2014-03-09 17:16:39.925979
218	\N	2014-03-09 17:22:06.729822
219	\N	2014-03-09 17:22:53.935291
220	\N	2014-03-09 17:27:52.688908
221	\N	2014-03-09 17:52:30.541389
222	\N	2014-03-09 19:11:33.194935
223	\N	2014-03-09 19:15:03.877857
224	\N	2014-03-09 19:15:46.222185
225	\N	2014-03-09 19:17:15.484997
226	\N	2014-03-09 19:20:08.16384
227	\N	2014-03-09 19:24:23.753637
228	\N	2014-03-09 19:25:02.560994
229	\N	2014-03-09 19:26:40.146728
230	\N	2014-03-09 19:45:01.137337
231	\N	2014-03-09 20:04:36.377096
232	\N	2014-03-09 20:05:00.113487
233	\N	2014-03-09 20:05:37.140793
234	\N	2014-03-09 20:17:59.560709
235	\N	2014-03-09 20:21:19.814151
236	\N	2014-03-09 20:22:23.01697
237	\N	2014-03-09 20:24:08.922987
238	\N	2014-03-09 20:26:48.806838
239	\N	2014-03-09 20:28:54.16831
240	\N	2014-03-09 20:31:30.703584
241	\N	2014-03-09 20:33:50.002524
242	\N	2014-03-09 20:42:04.389622
243	\N	2014-03-09 20:46:54.197818
244	\N	2014-03-09 20:48:23.489462
245	\N	2014-03-09 20:48:57.9942
246	\N	2014-03-09 20:52:55.874539
247	\N	2014-03-09 20:53:39.621256
248	\N	2014-03-09 20:54:39.254256
249	\N	2014-03-09 20:55:43.958387
250	\N	2014-03-09 21:01:31.219358
251	\N	2014-03-09 21:02:42.180667
252	\N	2014-03-09 21:05:26.540135
253	\N	2014-03-09 21:06:48.739741
254	\N	2014-03-09 21:08:10.071999
255	\N	2014-03-09 21:21:23.621391
256	\N	2014-03-09 21:24:01.761225
257	\N	2014-03-09 21:24:41.963121
258	\N	2014-03-09 21:30:10.416963
259	\N	2014-03-09 21:34:49.774763
260	\N	2014-03-09 21:38:31.363435
261	\N	2014-03-09 21:41:34.75884
262	\N	2014-03-09 21:48:32.232004
263	\N	2014-03-09 21:53:48.052191
264	\N	2014-03-09 21:56:56.023742
265	\N	2014-03-09 22:10:10.846696
266	\N	2014-03-09 22:14:50.845005
267	\N	2014-03-09 22:20:22.785947
268	\N	2014-03-09 22:23:13.19147
\.


--
-- Name: _temporal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_temporal_id_seq', 6, true);


--
-- Data for Name: _tlicence; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY _tlicence (id, temporal_id, licence_num, date_from, date_to, deleted, main_id) FROM stdin;
1	48	MP-14 00023587	2013-01-01	2016-12-31	f	\N
2	50	MP-14 00023588	2014-03-04	2014-03-04	f	\N
5	53	MP-14 00023587	2014-03-04	2014-03-04	f	\N
6	54	MP-14 00023587	2014-03-04	2014-03-04	f	\N
9	57	MP-14 00023587	2014-03-04	2014-03-04	f	\N
10	60	sdf asdf asdfasdf	2013-02-01	2014-03-04	t	\N
\.


--
-- Name: _tlicence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_tlicence_id_seq', 11, true);


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
16	972	ROH
\.


--
-- Name: accomodation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('accomodation_id_seq', 16, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY address (id, resource_id) FROM stdin;
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('address_id_seq', 1, false);


--
-- Data for Name: advsource; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY advsource (id, resource_id, name) FROM stdin;
1	903	Search Engines
2	904	Google.com
3	905	Yahoo.com
4	906	Recommendation
5	907	Second appeal
\.


--
-- Name: advsource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('advsource_id_seq', 5, true);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY alembic_version (version_num) FROM stdin;
e5585a6eff4
\.


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY appointment (id, resource_id, appointment_date) FROM stdin;
1	789	2014-02-02
6	892	2014-02-22
\.


--
-- Data for Name: appointment_row; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY appointment_row (id, appointment_id, employee_id, position_id) FROM stdin;
1	1	2	4
26	6	7	5
\.


--
-- Data for Name: attachment; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY attachment (id, resource_id) FROM stdin;
\.


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
1	20
\.


--
-- Name: bperson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('bperson_id_seq', 2, true);


--
-- Name: companies_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('companies_positions_id_seq', 5, true);


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY contact (id, contact, contact_type) FROM stdin;
16	+380681983869	phone
17	vitalii.mazur@gmail.com	email
18	dorianyats	skype
20	+525545625332	phone
\.


--
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('contact_id_seq', 20, true);


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
\.


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('country_id_seq', 8, true);


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
4	786	\N	Oleg	Pogorelov	
7	885	\N	Irina	Mazur	V.
8	893	\N	Oleg	Mazur	V.
9	1040	\N	Halyna	Sereda	
10	1041	\N	Andrey	Shabanov	
11	1042	\N	Dymitrii	Veremeychuk	
12	1043	\N	Denis	Yurin	
13	1044	\N	Alexandra	Koff	
14	1045	\N	Dima	Shkreba	
15	1046	\N	Viktoriia	Lastovets	
\.


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('employees_appointments_h_id_seq', 6, true);


--
-- Name: employees_appointments_r_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('employees_appointments_r_id_seq', 26, true);


--
-- Data for Name: foodcat; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY foodcat (id, resource_id, name) FROM stdin;
1	973	ОВ
2	974	NA
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
14	986	HCAL
15	987	UAL
16	988	UAI
\.


--
-- Name: foodcat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('foodcat_id_seq', 16, true);


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
7	VT-125853-12	2014-03-08	2015-03-08	1012
8	GHT-12542	2014-03-08	2014-03-31	1013
9	TY-562314	2014-01-01	2016-12-31	1014
10	TT-1	2014-03-09	2014-03-09	1015
11	TT-02	2014-03-09	2014-03-09	1016
12	TT-03	2014-03-09	2014-03-09	1017
13	TT-04	2014-03-09	2014-03-09	1018
14	TT-005	2014-03-09	2014-03-09	1019
15	TT-06	2014-03-09	2014-03-09	1020
16	TT-07	2014-03-09	2014-03-09	1021
17	TT-08	2014-03-09	2014-03-09	1022
18	TT-10	2014-03-09	2014-03-09	1023
19	TT-11	2014-03-09	2014-03-09	1024
20	TT-12	2014-03-09	2014-03-09	1025
21	TT-13	2014-03-09	2014-03-09	1026
22	TT-14	2014-03-09	2014-03-09	1027
23	TT-15	2014-03-09	2014-03-09	1028
24	TT-16	2014-03-09	2014-03-09	1029
25	TT-17	2014-03-09	2014-03-09	1030
26	TT-18	2014-03-09	2014-03-09	1031
27	TT-19	2014-03-09	2014-03-09	1032
28	TT-20	2014-03-09	2014-03-09	1033
29	tt-21	2014-03-09	2014-03-09	1034
30	TT-24	2014-03-09	2014-03-09	1035
31	TT-25	2014-03-09	2014-03-09	1036
32	TT-30	2014-03-09	2014-03-09	1037
33	TT40	2014-03-09	2014-03-09	1038
34	TEST-001	2014-03-09	2014-03-09	1039
\.


--
-- Name: licence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('licence_id_seq', 34, true);


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY location (id, resource_id) FROM stdin;
\.


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('location_id_seq', 1, false);


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY navigation (id, position_id, parent_id, name, url, icon_cls, sort_order, resource_id) FROM stdin;
9	4	8	Resource Types	/resources_types	\N	1	779
7	4	\N	Home	/	fa fa-home	1	777
15	4	8	Users	/users	\N	2	792
13	4	10	Employees	/employees	\N	1	790
20	4	18	Positions	/positions	\N	2	863
19	4	18	Structures	/structures	\N	1	838
25	4	23	Regions	/regions	\N	3	879
17	4	23	Currencies	/currencies	\N	1	802
24	4	23	Countries	/countries	\N	3	874
14	4	10	Employees Appointments	/appointments	\N	2	791
27	4	26	Advertising Sources	/advsources	\N	1	902
28	4	23	Hotels Categories	/hotelcats	\N	4	910
29	4	23	Rooms Categories	/roomcats	\N	5	911
30	4	23	Accomodations	/accomodations	\N	7	955
31	4	23	Food Categories	/foodcats	\N	6	956
8	4	\N	System	/	fa fa-cog	8	778
23	4	\N	Directories	/	fa fa-book	7	873
18	4	\N	Company	/	fa fa-building-o	6	837
10	4	\N	HR	/	fa fa-group	5	780
26	4	\N	Marketing	/	fa fa-bullhorn	4	900
32	4	\N	Sales	/	fa fa-legal	2	998
33	4	32	Communications	/communication	\N	1	999
21	4	\N	Clientage	/	fa fa-briefcase	3	864
22	4	21	Persons	/persons	\N	1	866
35	4	23	Touroperators	/touroperators	\N	9	1002
36	4	23	Business Persons	/bpersons	\N	9	1008
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
50	80	4	{view,add,edit,delete}	\N	all
26	47	4	{view,add,edit,delete}	\N	all
21	1	4	{view}	\N	all
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person (id, resource_id, first_name, last_name, second_name, birthday, gender) FROM stdin;
4	870	Greg	Johnson		\N	\N
5	871	John	Doe		\N	\N
6	887	Peter	Parker		\N	\N
14	997	Vitalii	Mazur		2014-03-02	\N
\.


--
-- Data for Name: person_contact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person_contact (person_id, contact_id) FROM stdin;
14	16
14	17
14	18
\.


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('person_id_seq', 14, true);


--
-- Data for Name: position; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY "position" (id, resource_id, structure_id, name) FROM stdin;
4	772	32	Main Developer
5	886	5	Finance Director
\.


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('positions_navigations_id_seq', 36, true);


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('positions_permisions_id_seq', 50, true);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY region (id, resource_id, country_id, name) FROM stdin;
7	895	3	Kiev region
8	896	3	Lviv region
9	897	4	Hurgada
10	898	5	Kemer
\.


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY resource (id, resource_type_id, status, structure_id) FROM stdin;
863	65	0	32
875	70	0	32
885	47	0	32
895	39	0	32
998	65	0	32
999	65	0	32
1010	79	0	32
1019	80	0	32
1030	80	0	32
1038	80	0	32
728	55	0	32
784	47	0	32
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
864	65	0	32
876	41	0	32
886	59	0	32
896	39	0	32
897	39	0	32
772	59	0	32
788	12	0	32
706	12	0	32
804	41	0	32
771	55	0	32
838	65	0	32
734	55	0	32
898	39	0	32
899	39	0	32
900	65	0	32
901	12	0	32
902	65	0	32
1011	12	0	32
1020	80	0	32
1031	80	0	32
1039	80	0	32
853	41	0	32
865	12	0	32
866	65	0	32
789	67	0	32
887	69	0	32
773	12	0	32
892	67	1	32
903	71	0	32
904	71	0	32
905	71	0	32
906	71	0	32
907	71	0	32
1012	80	0	32
1021	80	0	32
1022	80	0	32
1023	80	0	32
1024	80	0	32
1025	80	0	32
1032	80	0	32
1040	47	0	32
1041	47	0	32
1042	47	0	32
1043	47	0	32
1044	47	0	32
1045	47	0	32
1046	47	0	32
854	2	0	32
855	2	0	32
878	70	0	32
893	47	0	32
894	2	0	32
908	12	0	32
909	12	0	32
910	65	0	32
911	65	0	32
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
940	73	1	32
941	73	1	32
942	73	1	32
943	73	1	32
944	73	1	32
945	73	1	32
946	73	1	32
947	73	1	32
948	73	1	32
949	73	1	32
950	73	1	32
951	73	1	32
952	73	1	32
939	73	1	32
938	73	1	32
937	73	1	32
936	73	1	32
935	73	1	32
934	73	1	32
933	73	1	32
932	73	1	32
931	73	1	32
930	73	1	32
929	73	1	32
928	73	1	32
927	73	1	32
926	73	1	32
925	73	1	32
924	73	1	32
923	73	1	32
922	73	1	32
921	73	1	32
920	73	1	32
919	72	1	32
918	72	1	32
917	72	1	32
916	72	1	32
915	72	1	32
914	72	1	32
913	72	1	32
912	72	1	32
1002	65	0	32
1013	80	0	32
1026	80	0	32
1033	80	0	32
1034	80	0	32
856	2	0	32
870	69	0	32
879	65	0	32
953	12	0	32
954	12	0	32
764	12	0	32
955	65	0	32
956	65	0	32
957	74	0	32
958	74	0	32
959	74	0	32
960	74	0	32
961	74	0	32
962	74	0	32
963	74	0	32
964	74	0	32
965	74	0	32
966	74	0	32
967	74	0	32
968	74	0	32
969	74	0	32
970	74	0	32
971	74	0	32
972	74	0	32
973	75	0	32
974	75	0	32
975	75	0	32
976	75	0	32
977	75	0	32
978	75	0	32
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
979	75	0	32
980	75	0	32
981	75	0	32
982	75	0	32
983	75	0	32
984	75	0	32
985	75	0	32
986	75	0	32
987	75	0	32
988	75	0	32
1003	12	0	32
1004	78	0	32
1005	78	0	32
1006	78	0	32
1014	80	0	32
1027	80	0	32
1035	80	0	32
857	55	0	32
858	55	0	32
859	55	0	32
860	55	0	32
861	55	0	32
794	55	0	32
800	55	0	32
801	55	0	32
871	69	0	32
880	70	0	32
881	70	0	32
882	70	0	32
883	70	0	32
884	70	0	32
1007	12	0	32
1008	65	0	32
1015	80	0	32
1016	80	0	32
1017	80	0	32
1028	80	0	32
1036	80	0	32
872	12	0	32
873	65	0	32
874	65	0	32
725	55	0	32
726	55	0	32
997	69	0	32
1009	79	0	32
1018	80	0	32
1029	80	0	32
1037	80	0	32
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
4950	791	2	\N	2014-02-14 19:34:50.327857
8	16	2	\N	2013-11-16 19:00:17.960761
4971	850	2	\N	2014-02-23 22:38:07.612312
12	30	2	\N	2013-11-23 19:26:00.193553
13	30	2	\N	2013-11-23 22:02:37.363677
14	10	2	\N	2013-11-23 22:11:01.634598
15	30	2	\N	2013-11-23 22:11:14.939938
16	30	2	\N	2013-11-23 22:11:38.396085
4972	850	2	\N	2014-02-23 22:38:25.984797
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
5194	1036	2	\N	2014-03-09 17:07:52.478483
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
4822	784	2	\N	2014-02-01 21:23:07.460721
4823	786	2	\N	2014-02-01 21:23:12.871915
4843	800	2	\N	2014-02-05 19:58:31.619612
4844	801	2	\N	2014-02-05 19:58:49.632624
4847	804	2	\N	2014-02-06 12:27:24.361214
4881	838	2	\N	2014-02-08 12:46:41.342097
4923	863	2	\N	2014-02-09 11:06:45.876408
4951	885	2	\N	2014-02-14 21:23:40.101298
4952	885	2	\N	2014-02-14 21:25:13.866935
4973	850	2	\N	2014-02-23 22:41:40.054082
4974	849	2	\N	2014-02-23 22:41:46.113064
4975	848	2	\N	2014-02-23 22:41:49.935029
4976	804	2	\N	2014-02-23 22:41:53.504209
4977	884	2	\N	2014-02-23 22:42:22.595852
5143	1003	2	\N	2014-03-04 21:05:09.565466
5144	1004	2	\N	2014-03-04 21:08:53.227171
5145	1005	2	\N	2014-03-04 21:09:15.542733
5146	1006	2	\N	2014-03-04 21:09:54.604161
5195	1037	2	\N	2014-03-09 17:23:08.609353
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
5154	1004	2	\N	2014-03-04 21:35:47.600889
5155	1004	2	\N	2014-03-04 21:36:05.835492
5156	1004	2	\N	2014-03-04 21:36:16.322673
5196	1038	2	\N	2014-03-09 21:35:00.987996
422	306	2	\N	2013-12-15 21:45:32.990838
4925	864	2	\N	2014-02-09 12:31:10.556265
4802	773	2	\N	2014-01-25 23:45:37.762081
4926	864	2	\N	2014-02-09 12:32:19.155301
4827	789	2	\N	2014-02-02 16:45:11.830435
4954	887	2	\N	2014-02-15 12:32:09.199652
4979	885	2	\N	2014-02-24 12:50:26.694026
4980	786	2	\N	2014-02-24 12:50:29.953348
4981	784	2	\N	2014-02-24 12:50:33.322359
5157	1004	2	\N	2014-03-07 22:30:15.652582
5197	1039	2	\N	2014-03-09 22:24:45.988076
4927	865	2	\N	2014-02-09 13:26:19.008763
4804	775	2	\N	2014-01-26 15:30:50.636495
4928	866	2	\N	2014-02-09 13:26:48.246588
4828	3	2	\N	2014-02-02 17:45:50.239397
4829	780	2	\N	2014-02-02 17:53:21.606939
4830	790	2	\N	2014-02-02 17:53:42.973553
4831	791	2	\N	2014-02-02 17:54:20.864462
4832	792	2	\N	2014-02-02 17:54:57.706749
4982	895	2	\N	2014-02-25 19:06:42.158245
5158	1007	2	\N	2014-03-08 10:30:25.61786
5159	1008	2	\N	2014-03-08 10:30:54.532147
5198	3	2	\N	2014-03-11 13:14:05.142514
4806	777	2	\N	2014-01-26 18:18:05.196211
4807	778	2	\N	2014-01-26 18:18:24.059336
4808	779	2	\N	2014-01-26 18:18:45.188271
4809	780	2	\N	2014-01-26 18:20:19.519217
4888	786	2	\N	2014-02-08 21:26:45.138217
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
4893	848	2	\N	2014-02-08 21:32:08.207947
4894	849	2	\N	2014-02-08 21:32:14.802948
4895	850	2	\N	2014-02-08 21:32:25.105565
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
4899	804	2	\N	2014-02-08 21:40:56.593482
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
5010	920	2	\N	2014-02-25 23:22:49.704809
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
5024	934	2	\N	2014-02-25 23:28:33.132182
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
5041	951	2	\N	2014-02-25 23:33:02.423499
5169	1011	2	\N	2014-03-08 15:10:44.638516
5206	3	2	\N	2014-03-12 13:00:24.217557
5207	3	2	\N	2014-03-12 13:00:34.025605
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
5048	934	2	\N	2014-02-25 23:34:22.408043
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
5062	920	2	\N	2014-02-25 23:35:36.517478
5063	919	2	\N	2014-02-25 23:35:43.645366
5064	918	2	\N	2014-02-25 23:35:47.480218
5065	917	2	\N	2014-02-25 23:35:52.042922
5066	916	2	\N	2014-02-25 23:35:57.409224
5067	915	2	\N	2014-02-25 23:36:01.802966
5068	914	2	\N	2014-02-25 23:36:05.670476
5069	913	2	\N	2014-02-25 23:36:10.129284
5070	912	2	\N	2014-02-25 23:36:14.468359
5170	1012	2	\N	2014-03-08 16:51:50.942761
5208	1040	2	\N	2014-03-12 20:50:33.871251
5209	1041	2	\N	2014-03-12 20:50:55.466763
5210	1041	2	\N	2014-03-12 20:51:02.123714
5211	1042	2	\N	2014-03-12 20:53:03.003465
5212	1043	2	\N	2014-03-12 20:53:27.910983
5213	1044	2	\N	2014-03-12 20:53:45.921718
5214	1045	2	\N	2014-03-12 20:54:23.054095
5215	1046	2	\N	2014-03-12 20:55:03.071619
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
5090	972	2	\N	2014-02-26 23:31:01.483484
5091	973	2	\N	2014-02-26 23:31:31.71567
5092	974	2	\N	2014-02-26 23:32:04.226285
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
5104	986	2	\N	2014-02-26 23:34:19.593553
5105	987	2	\N	2014-02-26 23:34:29.757456
5106	988	2	\N	2014-02-26 23:34:37.99873
5171	1013	2	\N	2014-03-08 17:04:05.710391
5216	3	2	\N	2014-03-12 21:55:10.706584
4789	763	2	\N	2014-01-12 19:51:49.157909
4903	854	2	\N	2014-02-08 22:16:58.906498
4904	3	2	\N	2014-02-08 22:17:06.939369
4905	854	2	\N	2014-02-08 22:20:32.280238
4906	784	2	\N	2014-02-08 22:21:01.290541
4908	786	2	\N	2014-02-08 22:21:09.110319
5172	1014	2	\N	2014-03-09 11:57:58.173054
4790	764	2	\N	2014-01-12 20:33:53.3138
4909	723	2	\N	2014-02-08 22:28:37.868751
4940	878	2	\N	2014-02-10 16:40:47.442615
5173	1015	2	\N	2014-03-09 13:12:11.483454
5174	1016	2	\N	2014-03-09 13:36:54.955126
5175	1017	2	\N	2014-03-09 13:41:23.021993
4910	857	2	\N	2014-02-09 00:41:07.487567
4911	858	2	\N	2014-02-09 00:41:26.234037
4912	859	2	\N	2014-02-09 00:41:48.428505
4913	860	2	\N	2014-02-09 00:42:12.938208
4914	857	2	\N	2014-02-09 00:42:31.066281
4915	861	2	\N	2014-02-09 00:42:52.234296
4941	879	2	\N	2014-02-10 21:17:56.627306
5176	1018	2	\N	2014-03-09 13:45:15.89392
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
5177	1019	2	\N	2014-03-09 13:47:07.058551
4921	838	2	\N	2014-02-09 01:11:46.633177
4949	764	2	\N	2014-02-11 19:47:14.055452
5178	1020	2	\N	2014-03-09 13:51:17.897769
5179	1021	2	\N	2014-03-09 13:53:38.91711
5180	1022	2	\N	2014-03-09 13:58:24.757844
5181	1023	2	\N	2014-03-09 14:06:44.07393
5182	1024	2	\N	2014-03-09 14:08:09.517205
5183	1025	2	\N	2014-03-09 14:09:40.082338
5184	1026	2	\N	2014-03-09 14:13:13.511467
5185	1027	2	\N	2014-03-09 14:20:53.622746
5186	1028	2	\N	2014-03-09 14:21:26.790046
5129	997	2	\N	2014-03-02 14:34:15.721348
5187	1029	2	\N	2014-03-09 14:22:09.191976
5130	997	2	\N	2014-03-02 17:22:53.946618
5131	997	2	\N	2014-03-02 17:23:05.245562
5188	1030	2	\N	2014-03-09 14:24:49.894609
5132	998	2	\N	2014-03-02 17:40:41.982664
5133	999	2	\N	2014-03-02 18:13:12.823006
5134	999	2	\N	2014-03-02 18:18:41.164422
5189	1031	2	\N	2014-03-09 14:27:20.96172
4120	16	2	\N	2014-01-01 13:19:09.979922
4131	14	2	\N	2014-01-01 18:45:07.902745
4144	706	2	\N	2014-01-03 16:12:41.015146
4145	706	2	\N	2014-01-03 16:13:23.197097
5190	1032	2	\N	2014-03-09 14:28:02.589604
5136	864	2	\N	2014-03-03 21:07:46.674859
5137	866	2	\N	2014-03-03 21:08:00.013957
5138	865	2	\N	2014-03-03 21:09:34.254642
5191	1033	2	\N	2014-03-09 14:30:01.979919
5192	1034	2	\N	2014-03-09 14:32:12.631673
5140	865	2	\N	2014-03-03 21:57:11.59945
5141	866	2	\N	2014-03-03 21:57:34.76558
5193	1035	2	\N	2014-03-09 16:51:08.847478
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
80	1011	licences	Licences	Licences	travelcrm.resources.licences	\N	Licences list.
\.


--
-- Data for Name: roomcat; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY roomcat (id, resource_id, name) FROM stdin;
1	920	STD
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
15	934	Business
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
32	951	SSV (Side Sea view)
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
\.


--
-- Name: structures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('structures_id_seq', 6, true);


--
-- Data for Name: touroperator; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator (id, resource_id, name) FROM stdin;
1	1004	Turtess Travel
2	1005	Coral Travel
3	1006	SunMar
\.


--
-- Data for Name: touroperator_bperson; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator_bperson (touroperator_id, bperson_id) FROM stdin;
\.


--
-- Name: touroperator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('touroperator_id_seq', 3, true);


--
-- Data for Name: touroperator_licence; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator_licence (touroperator_id, licence_id) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY "user" (id, resource_id, username, email, password, employee_id) FROM stdin;
2	3	mazvv	vitalii.mazur@gmail.com	mazvv	2
23	894	maziv	\N	maziv	7
\.


--
-- Name: _tappointment_row_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY _tappointment_row
    ADD CONSTRAINT _tappointment_row_pkey PRIMARY KEY (id);


--
-- Name: _tbperson_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY _tbperson
    ADD CONSTRAINT _tbperson_pkey PRIMARY KEY (id);


--
-- Name: _tcontact_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY _tcontact
    ADD CONSTRAINT _tcontact_pkey PRIMARY KEY (id);


--
-- Name: _temporal_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY _temporal
    ADD CONSTRAINT _temporal_pkey PRIMARY KEY (id);


--
-- Name: _tlicence_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY _tlicence
    ADD CONSTRAINT _tlicence_pkey PRIMARY KEY (id);


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
-- Name: permision_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT permision_pk PRIMARY KEY (id);


--
-- Name: person_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT person_contact_pkey PRIMARY KEY (person_id, contact_id);


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
-- Name: roomcat_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT roomcat_pkey PRIMARY KEY (id);


--
-- Name: structure_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT structure_pk PRIMARY KEY (id);


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
-- Name: bperson_contact_bperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT bperson_contact_bperson_id_fkey FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bperson_contact_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT bperson_contact_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_appointment_id_appointment_row; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment_row
    ADD CONSTRAINT fk_appointment_id_appointment_row FOREIGN KEY (appointment_id) REFERENCES appointment(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: fk_main_id_appointment_row_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY _tappointment_row
    ADD CONSTRAINT fk_main_id_appointment_row_id FOREIGN KEY (main_id) REFERENCES appointment_row(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_main_id_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY _tcontact
    ADD CONSTRAINT fk_main_id_contact_id FOREIGN KEY (main_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: fk_region_country_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_region_country_id FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_accomodation; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT fk_resource_id_accomodation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_advsource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT fk_resource_id_advsource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_appointment_header; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY appointment
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
-- Name: fk_resource_id_foodcat; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT fk_resource_id_foodcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_hotelcat; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT fk_resource_id_hotelcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_person; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_resource_id_person FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: fk_resource_id_region; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_resource_id_region FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: fk_resource_id_roomcat; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT fk_resource_id_roomcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: fk_tcontact_id_temporal_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY _tcontact
    ADD CONSTRAINT fk_tcontact_id_temporal_id FOREIGN KEY (temporal_id) REFERENCES _temporal(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_temporal_id_temporal_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY _tappointment_row
    ADD CONSTRAINT fk_temporal_id_temporal_id FOREIGN KEY (temporal_id) REFERENCES _temporal(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: person_contact_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT person_contact_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: person_contact_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT person_contact_person_id_fkey FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: touroperator_bperson_touroperator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_bperson
    ADD CONSTRAINT touroperator_bperson_touroperator_id_fkey FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: touroperator_licence_licence_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_licence
    ADD CONSTRAINT touroperator_licence_licence_id_fkey FOREIGN KEY (licence_id) REFERENCES licence(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: touroperator_licence_touroperator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_licence
    ADD CONSTRAINT touroperator_licence_touroperator_id_fkey FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE CASCADE;


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

