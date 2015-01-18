--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: contact_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE contact_type_enum AS ENUM (
    'phone',
    'email',
    'skype'
);


--
-- Name: genders_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE genders_enum AS ENUM (
    'male',
    'female'
);


--
-- Name: passport_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE passport_type_enum AS ENUM (
    'citizen',
    'foreign'
);


--
-- Name: visibility_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE visibility_enum AS ENUM (
    'all',
    'own'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE currency (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(3) NOT NULL
);


--
-- Name: _currencies_rid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE _currencies_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _currencies_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE _currencies_rid_seq OWNED BY currency.id;


--
-- Name: employee; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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


--
-- Name: _employees_rid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE _employees_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _employees_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE _employees_rid_seq OWNED BY employee.id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE region (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    country_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: _regions_rid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE _regions_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _regions_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE _regions_rid_seq OWNED BY region.id;


--
-- Name: resource_log; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resource_log (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    comment character varying(512),
    modifydt timestamp without time zone
);


--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE _resources_logs_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE _resources_logs_rid_seq OWNED BY resource_log.id;


--
-- Name: resource; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resource (
    id integer NOT NULL,
    resource_type_id integer NOT NULL,
    structure_id integer NOT NULL,
    protected boolean
);


--
-- Name: _resources_rid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE _resources_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _resources_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE _resources_rid_seq OWNED BY resource.id;


--
-- Name: resource_type; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resource_type (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    humanize character varying(32) NOT NULL,
    resource_name character varying(32) NOT NULL,
    module character varying(128) NOT NULL,
    description character varying(128),
    settings json,
    customizable boolean
);


--
-- Name: _resources_types_rid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE _resources_types_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _resources_types_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE _resources_types_rid_seq OWNED BY resource_type.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(128),
    password character varying(128) NOT NULL,
    employee_id integer NOT NULL
);


--
-- Name: _users_rid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE _users_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: _users_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE _users_rid_seq OWNED BY "user".id;


--
-- Name: accomodation; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accomodation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: accomodation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accomodation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accomodation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accomodation_id_seq OWNED BY accomodation.id;


--
-- Name: account; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE account (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    currency_id integer NOT NULL,
    account_type smallint NOT NULL,
    name character varying(255) NOT NULL,
    display_text character varying(255) NOT NULL,
    descr character varying(255)
);


--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_id_seq OWNED BY account.id;


--
-- Name: account_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE account_item (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(128) NOT NULL
);


--
-- Name: account_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_item_id_seq OWNED BY account_item.id;


--
-- Name: address; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE address (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    location_id integer NOT NULL,
    zip_code character varying(12) NOT NULL,
    address character varying(255) NOT NULL
);


--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE address_id_seq OWNED BY address.id;


--
-- Name: advsource; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE advsource (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: advsource_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE advsource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: advsource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE advsource_id_seq OWNED BY advsource.id;


--
-- Name: appointment; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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


--
-- Name: apscheduler_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE apscheduler_jobs (
    id character varying(191) NOT NULL,
    next_run_time double precision,
    job_state bytea NOT NULL
);


--
-- Name: bank; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bank (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: bank_address; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bank_address (
    bank_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: bank_detail; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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


--
-- Name: bank_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bank_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bank_detail_id_seq OWNED BY bank_detail.id;


--
-- Name: bank_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bank_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bank_id_seq OWNED BY bank.id;


--
-- Name: bperson; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bperson (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    first_name character varying(32) NOT NULL,
    last_name character varying(32),
    second_name character varying(32),
    position_name character varying(64)
);


--
-- Name: bperson_contact; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bperson_contact (
    bperson_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: bperson_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bperson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bperson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bperson_id_seq OWNED BY bperson.id;


--
-- Name: calculation; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calculation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    service_item_id integer,
    currency_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    base_price numeric(16,2) NOT NULL
);


--
-- Name: calculation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calculation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calculation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE calculation_id_seq OWNED BY calculation.id;


--
-- Name: commission; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE commission (
    id integer NOT NULL,
    date_from date NOT NULL,
    resource_id integer NOT NULL,
    service_id integer NOT NULL,
    percentage numeric(5,2) NOT NULL,
    price numeric(16,2) NOT NULL,
    currency_id integer NOT NULL,
    CONSTRAINT chk_commission_percentage CHECK (((percentage >= (0)::numeric) AND (percentage <= (100)::numeric)))
);


--
-- Name: commission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commission_id_seq OWNED BY commission.id;


--
-- Name: position; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "position" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    structure_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: companies_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE companies_positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE companies_positions_id_seq OWNED BY "position".id;


--
-- Name: company; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE company (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    currency_id integer NOT NULL,
    settings json
);


--
-- Name: company_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE company_id_seq OWNED BY company.id;


--
-- Name: contact; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contact (
    id integer NOT NULL,
    contact character varying NOT NULL,
    contact_type contact_type_enum NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: contact_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contact_id_seq OWNED BY contact.id;


--
-- Name: country; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE country (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(2) NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: crosspayment; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE crosspayment (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    transfer_id integer NOT NULL,
    descr character varying(255)
);


--
-- Name: crosspayment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE crosspayment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crosspayment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE crosspayment_id_seq OWNED BY crosspayment.id;


--
-- Name: currency_rate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE currency_rate (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    date date NOT NULL,
    currency_id integer NOT NULL,
    rate numeric(16,2) NOT NULL
);


--
-- Name: currency_rate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE currency_rate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currency_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE currency_rate_id_seq OWNED BY currency_rate.id;


--
-- Name: email_campaign; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE email_campaign (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    plain_content text NOT NULL,
    html_content text NOT NULL,
    start_dt timestamp without time zone NOT NULL,
    subject character varying(128) NOT NULL
);


--
-- Name: email_campaign_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE email_campaign_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_campaign_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE email_campaign_id_seq OWNED BY email_campaign.id;


--
-- Name: employee_address; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_address (
    employee_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: employee_contact; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_contact (
    employee_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: employee_notification; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_notification (
    employee_id integer NOT NULL,
    notification_id integer NOT NULL
);


--
-- Name: employee_passport; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_passport (
    employee_id integer NOT NULL,
    passport_id integer NOT NULL
);


--
-- Name: employee_subaccount; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_subaccount (
    employee_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employees_appointments_h_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employees_appointments_h_id_seq OWNED BY appointment.id;


--
-- Name: foodcat; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE foodcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: foodcat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE foodcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foodcat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE foodcat_id_seq OWNED BY foodcat.id;


--
-- Name: hotel; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hotel (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    hotelcat_id integer NOT NULL,
    name character varying(32) NOT NULL,
    location_id integer
);


--
-- Name: hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hotel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hotel_id_seq OWNED BY hotel.id;


--
-- Name: hotelcat; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hotelcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: hotelcat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hotelcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hotelcat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hotelcat_id_seq OWNED BY hotelcat.id;


--
-- Name: income; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE income (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    invoice_id integer NOT NULL
);


--
-- Name: income_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE income_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: income_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE income_id_seq OWNED BY income.id;


--
-- Name: income_transfer; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE income_transfer (
    income_id integer NOT NULL,
    transfer_id integer NOT NULL
);


--
-- Name: invoice; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invoice (
    id integer NOT NULL,
    date date NOT NULL,
    resource_id integer NOT NULL,
    account_id integer NOT NULL,
    active_until date NOT NULL
);


--
-- Name: invoice_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoice_id_seq OWNED BY invoice.id;


--
-- Name: licence; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE licence (
    id integer NOT NULL,
    licence_num character varying NOT NULL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: licence_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE licence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: licence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE licence_id_seq OWNED BY licence.id;


--
-- Name: location; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE location (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    region_id integer NOT NULL
);


--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


--
-- Name: navigation; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE navigation (
    id integer NOT NULL,
    position_id integer,
    parent_id integer,
    name character varying(32) NOT NULL,
    url character varying(128) NOT NULL,
    icon_cls character varying(32),
    sort_order integer NOT NULL,
    resource_id integer NOT NULL,
    separator_before boolean,
    action character varying(32)
);


--
-- Name: note; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE note (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    title character varying(255) NOT NULL,
    descr character varying
);


--
-- Name: note_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE note_id_seq OWNED BY note.id;


--
-- Name: note_resource; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE note_resource (
    note_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: notification; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notification (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    title character varying NOT NULL,
    descr character varying NOT NULL,
    created timestamp without time zone,
    url character varying
);


--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notification_id_seq OWNED BY notification.id;


--
-- Name: outgoing; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE outgoing (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    account_item_id integer NOT NULL,
    date date NOT NULL,
    subaccount_id integer NOT NULL,
    sum numeric(16,2) NOT NULL
);


--
-- Name: outgoing_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE outgoing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outgoing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE outgoing_id_seq OWNED BY outgoing.id;


--
-- Name: outgoing_transfer; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE outgoing_transfer (
    outgoing_id integer NOT NULL,
    transfer_id integer NOT NULL
);


--
-- Name: passport; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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


--
-- Name: passport_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE passport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: passport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE passport_id_seq OWNED BY passport.id;


--
-- Name: permision; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE permision (
    id integer NOT NULL,
    resource_type_id integer NOT NULL,
    position_id integer NOT NULL,
    permisions character varying[],
    structure_id integer,
    scope_type character varying(12)
);


--
-- Name: person; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    first_name character varying(32) NOT NULL,
    last_name character varying(32),
    second_name character varying(32),
    birthday date,
    gender genders_enum,
    subscriber boolean
);


--
-- Name: person_address; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_address (
    person_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: person_contact; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_contact (
    person_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_id_seq OWNED BY person.id;


--
-- Name: person_passport; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_passport (
    person_id integer NOT NULL,
    passport_id integer NOT NULL
);


--
-- Name: person_subaccount; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_subaccount (
    person_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE positions_navigations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE positions_navigations_id_seq OWNED BY navigation.id;


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE positions_permisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE positions_permisions_id_seq OWNED BY permision.id;


--
-- Name: roomcat; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roomcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: roomcat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roomcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roomcat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roomcat_id_seq OWNED BY roomcat.id;


--
-- Name: service; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    descr character varying(256),
    display_text character varying(256),
    account_item_id integer NOT NULL
);


--
-- Name: service_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE service_id_seq OWNED BY service.id;


--
-- Name: service_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service_item (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    service_id integer NOT NULL,
    currency_id integer NOT NULL,
    touroperator_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    person_id integer NOT NULL,
    base_price numeric(16,2) NOT NULL
);


--
-- Name: service_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE service_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE service_item_id_seq OWNED BY service_item.id;


--
-- Name: service_sale; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service_sale (
    id integer NOT NULL,
    deal_date date NOT NULL,
    resource_id integer NOT NULL,
    customer_id integer NOT NULL,
    advsource_id integer NOT NULL
);


--
-- Name: service_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE service_sale_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE service_sale_id_seq OWNED BY service_sale.id;


--
-- Name: service_sale_invoice; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service_sale_invoice (
    service_sale_id integer NOT NULL,
    invoice_id integer NOT NULL
);


--
-- Name: service_sale_service_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service_sale_service_item (
    service_sale_id integer NOT NULL,
    service_item_id integer NOT NULL
);


--
-- Name: structure; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE structure (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    parent_id integer,
    name character varying(32) NOT NULL,
    company_id integer NOT NULL
);


--
-- Name: structure_address; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE structure_address (
    structure_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: structure_bank_detail; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE structure_bank_detail (
    structure_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


--
-- Name: structure_contact; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE structure_contact (
    structure_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: structures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE structures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE structures_id_seq OWNED BY structure.id;


--
-- Name: subaccount; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subaccount (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    account_id integer,
    name character varying(255) NOT NULL,
    descr character varying(255)
);


--
-- Name: subaccount_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subaccount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subaccount_id_seq OWNED BY subaccount.id;


--
-- Name: supplier; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supplier (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(64) NOT NULL
);


--
-- Name: supplier_bank_detail; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supplier_bank_detail (
    supplier_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


--
-- Name: supplier_bperson; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supplier_bperson (
    supplier_id integer NOT NULL,
    bperson_id integer NOT NULL
);


--
-- Name: supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE supplier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE supplier_id_seq OWNED BY supplier.id;


--
-- Name: suppplier_subaccount; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suppplier_subaccount (
    supplier_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: task; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE task (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    title character varying(32) NOT NULL,
    deadline timestamp without time zone NOT NULL,
    reminder timestamp without time zone,
    descr character varying,
    closed boolean
);


--
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE task_id_seq OWNED BY task.id;


--
-- Name: task_resource; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE task_resource (
    task_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: tour_sale; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tour_sale (
    id integer NOT NULL,
    start_location_id integer NOT NULL,
    end_location_id integer NOT NULL,
    adults integer NOT NULL,
    children integer NOT NULL,
    customer_id integer NOT NULL,
    resource_id integer NOT NULL,
    end_date date NOT NULL,
    start_date date NOT NULL,
    deal_date date NOT NULL,
    advsource_id integer NOT NULL
);


--
-- Name: tour_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tour_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tour_id_seq OWNED BY tour_sale.id;


--
-- Name: tour_sale_point; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tour_sale_point (
    id integer NOT NULL,
    location_id integer NOT NULL,
    hotel_id integer,
    accomodation_id integer,
    foodcat_id integer,
    roomcat_id integer,
    tour_sale_id integer,
    description character varying(255),
    end_date date NOT NULL,
    start_date date NOT NULL
);


--
-- Name: tour_point_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tour_point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tour_point_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tour_point_id_seq OWNED BY tour_sale_point.id;


--
-- Name: tour_sale_invoice; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tour_sale_invoice (
    tour_sale_id integer NOT NULL,
    invoice_id integer NOT NULL
);


--
-- Name: tour_sale_person; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tour_sale_person (
    tour_sale_id integer NOT NULL,
    person_id integer NOT NULL
);


--
-- Name: tour_sale_service_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tour_sale_service_item (
    tour_sale_id integer NOT NULL,
    service_item_id integer NOT NULL
);


--
-- Name: touroperator; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE touroperator (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: touroperator_bank_detail; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE touroperator_bank_detail (
    touroperator_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


--
-- Name: touroperator_bperson; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE touroperator_bperson (
    touroperator_id integer NOT NULL,
    bperson_id integer NOT NULL
);


--
-- Name: touroperator_commission; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE touroperator_commission (
    touroperator_id integer NOT NULL,
    commission_id integer NOT NULL
);


--
-- Name: touroperator_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE touroperator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: touroperator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE touroperator_id_seq OWNED BY touroperator.id;


--
-- Name: touroperator_licence; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE touroperator_licence (
    touroperator_id integer NOT NULL,
    licence_id integer NOT NULL
);


--
-- Name: touroperator_subaccount; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE touroperator_subaccount (
    touroperator_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: transfer; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transfer (
    id integer NOT NULL,
    account_from_id integer,
    subaccount_from_id integer,
    account_to_id integer,
    subaccount_to_id integer,
    account_item_id integer NOT NULL,
    sum numeric(16,2) NOT NULL,
    date date NOT NULL,
    CONSTRAINT constraint_transfer_account_subaccount CHECK (((NOT ((account_from_id IS NOT NULL) AND (subaccount_from_id IS NOT NULL))) AND (NOT ((account_to_id IS NOT NULL) AND (subaccount_to_id IS NOT NULL)))))
);


--
-- Name: transfer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transfer_id_seq OWNED BY transfer.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accomodation ALTER COLUMN id SET DEFAULT nextval('accomodation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY account ALTER COLUMN id SET DEFAULT nextval('account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_item ALTER COLUMN id SET DEFAULT nextval('account_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY address ALTER COLUMN id SET DEFAULT nextval('address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY advsource ALTER COLUMN id SET DEFAULT nextval('advsource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY appointment ALTER COLUMN id SET DEFAULT nextval('employees_appointments_h_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank ALTER COLUMN id SET DEFAULT nextval('bank_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_detail ALTER COLUMN id SET DEFAULT nextval('bank_detail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bperson ALTER COLUMN id SET DEFAULT nextval('bperson_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY calculation ALTER COLUMN id SET DEFAULT nextval('calculation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commission ALTER COLUMN id SET DEFAULT nextval('commission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY company ALTER COLUMN id SET DEFAULT nextval('company_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact ALTER COLUMN id SET DEFAULT nextval('contact_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY crosspayment ALTER COLUMN id SET DEFAULT nextval('crosspayment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency ALTER COLUMN id SET DEFAULT nextval('_currencies_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency_rate ALTER COLUMN id SET DEFAULT nextval('currency_rate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY email_campaign ALTER COLUMN id SET DEFAULT nextval('email_campaign_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee ALTER COLUMN id SET DEFAULT nextval('_employees_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY foodcat ALTER COLUMN id SET DEFAULT nextval('foodcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hotel ALTER COLUMN id SET DEFAULT nextval('hotel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hotelcat ALTER COLUMN id SET DEFAULT nextval('hotelcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY income ALTER COLUMN id SET DEFAULT nextval('income_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice ALTER COLUMN id SET DEFAULT nextval('invoice_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY licence ALTER COLUMN id SET DEFAULT nextval('licence_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY navigation ALTER COLUMN id SET DEFAULT nextval('positions_navigations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY note ALTER COLUMN id SET DEFAULT nextval('note_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notification ALTER COLUMN id SET DEFAULT nextval('notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY outgoing ALTER COLUMN id SET DEFAULT nextval('outgoing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY passport ALTER COLUMN id SET DEFAULT nextval('passport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY permision ALTER COLUMN id SET DEFAULT nextval('positions_permisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY person ALTER COLUMN id SET DEFAULT nextval('person_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "position" ALTER COLUMN id SET DEFAULT nextval('companies_positions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY region ALTER COLUMN id SET DEFAULT nextval('_regions_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource ALTER COLUMN id SET DEFAULT nextval('_resources_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_log ALTER COLUMN id SET DEFAULT nextval('_resources_logs_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_type ALTER COLUMN id SET DEFAULT nextval('_resources_types_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roomcat ALTER COLUMN id SET DEFAULT nextval('roomcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY service ALTER COLUMN id SET DEFAULT nextval('service_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_item ALTER COLUMN id SET DEFAULT nextval('service_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_sale ALTER COLUMN id SET DEFAULT nextval('service_sale_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure ALTER COLUMN id SET DEFAULT nextval('structures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subaccount ALTER COLUMN id SET DEFAULT nextval('subaccount_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier ALTER COLUMN id SET DEFAULT nextval('supplier_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY task ALTER COLUMN id SET DEFAULT nextval('task_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale ALTER COLUMN id SET DEFAULT nextval('tour_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_point ALTER COLUMN id SET DEFAULT nextval('tour_point_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator ALTER COLUMN id SET DEFAULT nextval('touroperator_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer ALTER COLUMN id SET DEFAULT nextval('transfer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('_users_rid_seq'::regclass);


--
-- Name: _currencies_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_currencies_rid_seq', 57, true);


--
-- Name: _employees_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_employees_rid_seq', 29, true);


--
-- Name: _regions_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_regions_rid_seq', 36, true);


--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_resources_logs_rid_seq', 6479, true);


--
-- Name: _resources_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_resources_rid_seq', 2007, true);


--
-- Name: _resources_types_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_resources_types_rid_seq', 129, true);


--
-- Name: _users_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_users_rid_seq', 24, true);


--
-- Data for Name: accomodation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO accomodation VALUES (1, 957, 'MB');
INSERT INTO accomodation VALUES (2, 958, 'HV');
INSERT INTO accomodation VALUES (3, 959, 'BGL');
INSERT INTO accomodation VALUES (4, 960, 'BG');
INSERT INTO accomodation VALUES (5, 961, 'Chale');
INSERT INTO accomodation VALUES (6, 962, 'Cabana');
INSERT INTO accomodation VALUES (7, 963, 'Cottage');
INSERT INTO accomodation VALUES (8, 964, 'Executive floor');
INSERT INTO accomodation VALUES (9, 965, 'SGL');
INSERT INTO accomodation VALUES (10, 966, 'DBL');
INSERT INTO accomodation VALUES (11, 967, 'TRPL');
INSERT INTO accomodation VALUES (12, 968, 'QDPL');
INSERT INTO accomodation VALUES (13, 969, 'ExB');
INSERT INTO accomodation VALUES (14, 970, 'Chld');
INSERT INTO accomodation VALUES (15, 971, 'ВО');


--
-- Name: accomodation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('accomodation_id_seq', 16, true);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO account VALUES (2, 1438, 56, 0, 'Main Bank Account', 'some display text', NULL);
INSERT INTO account VALUES (3, 1439, 56, 1, 'Main Cash Account', 'cash payment', NULL);
INSERT INTO account VALUES (4, 1507, 54, 1, 'Main Cash EUR Account', 'Main Cash EUR Account', NULL);


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('account_id_seq', 4, true);


--
-- Data for Name: account_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO account_item VALUES (1, 1426, 'Tours Sales');
INSERT INTO account_item VALUES (2, 1431, 'Additional Services Sale');
INSERT INTO account_item VALUES (3, 1432, 'Rent Payments');
INSERT INTO account_item VALUES (4, 1608, 'Refunds');
INSERT INTO account_item VALUES (5, 1609, 'Payments To Suppliers');
INSERT INTO account_item VALUES (6, 1769, 'Payments To Touroperators');
INSERT INTO account_item VALUES (7, 1780, 'Account Initialization');
INSERT INTO account_item VALUES (8, 1873, 'Payment On Invoice');
INSERT INTO account_item VALUES (9, 1898, 'Cashing In');


--
-- Name: account_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('account_item_id_seq', 9, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO address VALUES (10, 1288, 14, '02312', 'Bogdana Hmelnickogo Str');
INSERT INTO address VALUES (13, 1308, 5, '12354', 'asdf asdf asdfsadf');
INSERT INTO address VALUES (14, 1309, 14, '12345', 'dsfg sdfg sdfg sdfgsdfgdsf');
INSERT INTO address VALUES (15, 1370, 14, '11111', 'Polyarnaya str., 18 A, 181');
INSERT INTO address VALUES (16, 1374, 14, '11111', 'Polyarnaya str. 18 A, 181');
INSERT INTO address VALUES (17, 1382, 14, '11111', 'Chavdar Elisabet, 13');
INSERT INTO address VALUES (18, 1388, 14, '11111', 'Chavdar Elisabet, 13');
INSERT INTO address VALUES (19, 1391, 14, '1111', 'Chavdar Elisabeth, 13');
INSERT INTO address VALUES (20, 1407, 14, '11111', 'Radujnaya str., 56 a, 153');
INSERT INTO address VALUES (21, 1414, 14, '01011', 'Leskova str., 9');
INSERT INTO address VALUES (22, 1418, 33, '12345', 'Naberegnaya Pobedy, 50');
INSERT INTO address VALUES (23, 1469, 34, '09909', 'Lavrska, str 34');
INSERT INTO address VALUES (24, 1585, 14, '08967', 'Solomii Krushelnickoi, 34/3, ap. 45');
INSERT INTO address VALUES (25, 1614, 14, '678565', 'Pobedy, 56/2, ap.67');
INSERT INTO address VALUES (26, 1623, 14, '8934', 'Artema 8d, 47');
INSERT INTO address VALUES (27, 1644, 34, '67234', 'Sichovih Strilciv, 2.');
INSERT INTO address VALUES (28, 1652, 14, '54415', 'Vasilkovskaya 45/56, 19');
INSERT INTO address VALUES (29, 1807, 14, '02121', 'Dekabristov str, filial #239');
INSERT INTO address VALUES (30, 1926, 14, '123432', 'Arsenalna str');
INSERT INTO address VALUES (31, 1951, 14, '02121', 'Gmiry str');


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('address_id_seq', 31, true);


--
-- Data for Name: advsource; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO advsource VALUES (2, 904, 'Google.com');
INSERT INTO advsource VALUES (3, 905, 'Yahoo.com');
INSERT INTO advsource VALUES (4, 906, 'Recommendation');
INSERT INTO advsource VALUES (5, 907, 'Second appeal');
INSERT INTO advsource VALUES (1, 903, 'Internet Search Engines');
INSERT INTO advsource VALUES (6, 1283, 'Undefined');


--
-- Name: advsource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('advsource_id_seq', 6, true);


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO appointment VALUES (1, 789, 54, 2, 4, 1000.00, '2014-02-02');
INSERT INTO appointment VALUES (6, 892, 54, 7, 5, 4500.00, '2014-02-22');
INSERT INTO appointment VALUES (8, 1542, 54, 2, 4, 6500.00, '2014-03-01');


--
-- Data for Name: apscheduler_jobs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO bank VALUES (1, 1214, 'Bank of America');
INSERT INTO bank VALUES (4, 1415, 'Raiffaisen Bank Aval');
INSERT INTO bank VALUES (5, 1419, 'PrivatBank');


--
-- Data for Name: bank_address; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO bank_address VALUES (5, 29);


--
-- Data for Name: bank_detail; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO bank_detail VALUES (5, 1420, 56, 4, 'LuxTravel, Inc', '123456789', '123456');
INSERT INTO bank_detail VALUES (6, 1510, 54, 1, 'Coral Travel', '12345', '1234');
INSERT INTO bank_detail VALUES (7, 1511, 57, 1, 'Coral LLC', '98765', '0987');
INSERT INTO bank_detail VALUES (8, 1512, 57, 1, 'Coral LLc', '0987654', '12234');
INSERT INTO bank_detail VALUES (9, 1513, 56, 5, 'Coral Travel Ukraine', '567990', '54343');
INSERT INTO bank_detail VALUES (10, 1514, 44, 5, 'Coral LLc', '123232321312', '`12');
INSERT INTO bank_detail VALUES (11, 1515, 54, 4, 'Coral LLC', '1223456', '55667');
INSERT INTO bank_detail VALUES (12, 1554, 56, 5, 'Intertelecom', '12345678', '09876');
INSERT INTO bank_detail VALUES (13, 1556, 56, 5, 'Intertelecom', '12345678', '09876');
INSERT INTO bank_detail VALUES (14, 1564, 56, 4, 'Lun Real Estate', '78900909', '12343434');
INSERT INTO bank_detail VALUES (15, 1569, 56, 5, 'Lun Real Estate Agency', '987456152', '671283');
INSERT INTO bank_detail VALUES (16, 1570, 56, 4, 'Intertelecom Internet Service Provider', '9878723847', '84758GH');


--
-- Name: bank_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bank_detail_id_seq', 16, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bank_id_seq', 5, true);


--
-- Data for Name: bperson; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO bperson VALUES (1, 1009, 'Alexandro', 'Riak', '', 'Sales Manager');
INSERT INTO bperson VALUES (2, 1010, 'Umberto', '', '', 'Accounting');
INSERT INTO bperson VALUES (6, 1560, 'Ivan', 'Gonchar', '', 'Account Manager');
INSERT INTO bperson VALUES (7, 1563, 'Alexander', 'Tkachuk', '', 'manager');
INSERT INTO bperson VALUES (5, 1553, 'Sergey', 'Vlasov', '', 'Main account manager');
INSERT INTO bperson VALUES (8, 1578, 'Anna', '', '', 'Manager');


--
-- Data for Name: bperson_contact; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO bperson_contact VALUES (1, 54);
INSERT INTO bperson_contact VALUES (1, 55);
INSERT INTO bperson_contact VALUES (1, 56);
INSERT INTO bperson_contact VALUES (1, 57);
INSERT INTO bperson_contact VALUES (5, 61);
INSERT INTO bperson_contact VALUES (5, 62);
INSERT INTO bperson_contact VALUES (6, 63);
INSERT INTO bperson_contact VALUES (7, 64);
INSERT INTO bperson_contact VALUES (7, 65);
INSERT INTO bperson_contact VALUES (8, 66);


--
-- Name: bperson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bperson_id_seq', 8, true);


--
-- Data for Name: calculation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO calculation VALUES (3, 1852, 33, 56, 56826.88, 56826.88);
INSERT INTO calculation VALUES (5, 1854, 36, 54, 3140.72, 57161.10);
INSERT INTO calculation VALUES (6, 1855, 37, 54, 3556.00, 59385.20);
INSERT INTO calculation VALUES (4, 1853, NULL, 57, 2150.34, 25804.08);
INSERT INTO calculation VALUES (9, 1859, 34, 57, 2156.34, 25876.08);
INSERT INTO calculation VALUES (10, 1860, 31, 57, 29.84, 358.08);
INSERT INTO calculation VALUES (11, 1861, 3, 54, 20.00, 334.00);
INSERT INTO calculation VALUES (12, 1862, 17, 57, 54.00, 653.40);
INSERT INTO calculation VALUES (13, 1863, 18, 57, 54.00, 653.40);
INSERT INTO calculation VALUES (14, 1864, 19, 54, 21.00, 350.70);
INSERT INTO calculation VALUES (16, 1918, 39, 54, 3534.00, 59017.80);
INSERT INTO calculation VALUES (17, 1988, 41, 56, 23000.00, 23000.00);


--
-- Name: calculation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('calculation_id_seq', 17, true);


--
-- Data for Name: commission; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO commission VALUES (14, '2014-06-28', 1535, 5, 13.20, 0.00, 56);
INSERT INTO commission VALUES (15, '2014-06-28', 1536, 5, 13.20, 0.00, 57);
INSERT INTO commission VALUES (16, '2014-06-28', 1537, 5, 13.40, 0.00, 56);
INSERT INTO commission VALUES (17, '2014-06-28', 1538, 5, 13.40, 0.00, 56);
INSERT INTO commission VALUES (18, '2014-06-28', 1539, 4, 0.00, 10.00, 56);
INSERT INTO commission VALUES (19, '2014-06-28', 1540, 3, 0.00, 10.00, 56);
INSERT INTO commission VALUES (20, '2014-06-28', 1541, 1, 0.00, 600.00, 56);
INSERT INTO commission VALUES (21, '2014-08-17', 1579, 5, 12.00, 0.00, 56);
INSERT INTO commission VALUES (22, '2014-08-01', 1714, 1, 0.00, 10.00, 54);
INSERT INTO commission VALUES (23, '2014-08-01', 1721, 5, 12.00, 0.00, 57);
INSERT INTO commission VALUES (24, '2014-05-01', 1917, 5, 11.00, 0.00, 56);


--
-- Name: commission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('commission_id_seq', 24, true);


--
-- Name: companies_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('companies_positions_id_seq', 8, true);


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO company VALUES (1, 1970, 'LuxTravel, Inc', 56, '{"locale": "en", "timezone": "Europe/Kiev"}');


--
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('company_id_seq', 1, true);


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO contact VALUES (27, '+380681983869', 'phone', 1193);
INSERT INTO contact VALUES (28, 'asdasd@mail.com', 'email', 1194);
INSERT INTO contact VALUES (29, '+380681983869', 'phone', 1195);
INSERT INTO contact VALUES (30, '+380681983869', 'phone', 1201);
INSERT INTO contact VALUES (32, '+380681983869', 'phone', 1204);
INSERT INTO contact VALUES (35, 'vitalii.mazur@gmail.com', 'email', 1243);
INSERT INTO contact VALUES (36, '+380681983869', 'phone', 1244);
INSERT INTO contact VALUES (37, '+380681983869', 'phone', 1257);
INSERT INTO contact VALUES (38, 'vitalii.mazur@gmail.com', 'email', 1258);
INSERT INTO contact VALUES (39, '+380681983869', 'phone', 1259);
INSERT INTO contact VALUES (40, 'vitalii.mazur@gmail.com', 'email', 1260);
INSERT INTO contact VALUES (41, '+380682523645', 'phone', 1263);
INSERT INTO contact VALUES (42, 'a.koff@gmail.com', 'email', 1264);
INSERT INTO contact VALUES (44, '+380675625353', 'phone', 1282);
INSERT INTO contact VALUES (45, '+380502355565', 'phone', 1285);
INSERT INTO contact VALUES (46, 'n.voevoda@gmail.com', 'email', 1304);
INSERT INTO contact VALUES (47, '+380673566789', 'phone', 1371);
INSERT INTO contact VALUES (48, '+380502314567', 'phone', 1373);
INSERT INTO contact VALUES (49, 'travelcrm', 'skype', 1379);
INSERT INTO contact VALUES (50, '+380682345678', 'phone', 1380);
INSERT INTO contact VALUES (51, '+380502232233', 'phone', 1387);
INSERT INTO contact VALUES (52, '+380502354235', 'phone', 1404);
INSERT INTO contact VALUES (53, '+380503435512', 'phone', 1464);
INSERT INTO contact VALUES (54, '+380976543565', 'phone', 1516);
INSERT INTO contact VALUES (55, '+380675643623', 'phone', 1517);
INSERT INTO contact VALUES (56, 'ravak_skype', 'skype', 1518);
INSERT INTO contact VALUES (57, 'ravak@myemail.com', 'email', 1519);
INSERT INTO contact VALUES (58, '+380681983800', 'phone', 1543);
INSERT INTO contact VALUES (59, 'dorianyats', 'skype', 1544);
INSERT INTO contact VALUES (60, 'info@travelcrm.org.ua', 'email', 1545);
INSERT INTO contact VALUES (61, '+380681234567', 'phone', 1551);
INSERT INTO contact VALUES (62, 'serge_vlasov', 'skype', 1552);
INSERT INTO contact VALUES (63, 'i_gonchar@i-tele.com', 'email', 1559);
INSERT INTO contact VALUES (64, '+380953434358', 'phone', 1561);
INSERT INTO contact VALUES (65, 'mega_tkach@ukr.net', 'email', 1562);
INSERT INTO contact VALUES (66, 'AnnaNews', 'skype', 1577);
INSERT INTO contact VALUES (67, '+380672568976', 'phone', 1581);
INSERT INTO contact VALUES (68, '+380672346534', 'phone', 1591);
INSERT INTO contact VALUES (69, '+380500567765', 'phone', 1610);
INSERT INTO contact VALUES (70, 'artyuh87@gmail.com', 'email', 1611);
INSERT INTO contact VALUES (71, '+380503435436', 'phone', 1620);
INSERT INTO contact VALUES (72, 'grach18@ukr.net', 'email', 1621);
INSERT INTO contact VALUES (73, '+380975642876', 'phone', 1624);
INSERT INTO contact VALUES (74, '+380665638900', 'phone', 1640);
INSERT INTO contact VALUES (75, 'karpuha1990@ukr.net', 'email', 1641);
INSERT INTO contact VALUES (76, '+380502235686', 'phone', 1650);
INSERT INTO contact VALUES (77, '+380674523123', 'phone', 1927);
INSERT INTO contact VALUES (78, 'vitalii.mazur@gmail.com', 'email', 1956);


--
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('contact_id_seq', 78, true);


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO country VALUES (3, 878, 'UA', 'Ukraine');
INSERT INTO country VALUES (4, 880, 'EG', 'Egypt');
INSERT INTO country VALUES (5, 881, 'TR', 'Turkey');
INSERT INTO country VALUES (6, 882, 'GB', 'United Kingdom');
INSERT INTO country VALUES (7, 883, 'US', 'United States');
INSERT INTO country VALUES (8, 884, 'TH', 'Thailand');
INSERT INTO country VALUES (9, 1095, 'RU', 'Russian Federation');
INSERT INTO country VALUES (12, 1164, 'HR', 'Croatia');
INSERT INTO country VALUES (13, 1169, 'AE', 'United Arab Emirates');
INSERT INTO country VALUES (14, 1178, 'ES', 'Spain');
INSERT INTO country VALUES (16, 1339, 'CY', 'Cyprus');
INSERT INTO country VALUES (17, 1343, 'IT', 'Italy');
INSERT INTO country VALUES (11, 1100, 'DE', 'Germany');
INSERT INTO country VALUES (18, 1351, 'GR', 'Greece');
INSERT INTO country VALUES (19, 1646, 'FR', 'France');


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('country_id_seq', 19, true);


--
-- Data for Name: crosspayment; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO crosspayment VALUES (6, 1893, 57, 'Account init');
INSERT INTO crosspayment VALUES (8, 1900, 59, 'Init Bank Account in UAH');
INSERT INTO crosspayment VALUES (9, 1901, 60, 'Some Cashing in');


--
-- Name: crosspayment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('crosspayment_id_seq', 9, true);


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO currency VALUES (44, 849, 'RUB');
INSERT INTO currency VALUES (50, 1060, 'KZT');
INSERT INTO currency VALUES (52, 1168, 'BYR');
INSERT INTO currency VALUES (54, 1240, 'EUR');
INSERT INTO currency VALUES (56, 1310, 'UAH');
INSERT INTO currency VALUES (57, 1311, 'USD');


--
-- Data for Name: currency_rate; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO currency_rate VALUES (1, 1396, '2014-05-19', 57, 12.10);
INSERT INTO currency_rate VALUES (3, 1398, '2014-05-19', 54, 16.70);
INSERT INTO currency_rate VALUES (5, 1400, '2014-05-16', 57, 11.99);
INSERT INTO currency_rate VALUES (6, 1401, '2014-05-16', 54, 16.60);
INSERT INTO currency_rate VALUES (7, 1402, '2014-05-15', 54, 16.80);
INSERT INTO currency_rate VALUES (8, 1403, '2014-05-15', 57, 11.80);
INSERT INTO currency_rate VALUES (9, 1504, '2014-06-20', 54, 16.70);
INSERT INTO currency_rate VALUES (10, 1505, '2014-06-20', 57, 12.00);
INSERT INTO currency_rate VALUES (11, 1506, '2014-06-20', 44, 0.37);
INSERT INTO currency_rate VALUES (12, 1597, '2014-08-21', 54, 18.20);


--
-- Name: currency_rate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('currency_rate_id_seq', 12, true);


--
-- Data for Name: email_campaign; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO email_campaign VALUES (1, 1955, 'Egypt HOT!!!', 'Hello.<p>Look at this</p>', '      <meta content="text/html; charset=utf-8" http-equiv="Content-Type">    <title>      Boutique    </title><style type="text/css">a:hover { text-decoration: none !important; }.header h1 {color: #ede6cb !important; font: normal 24px Georgia, serif; margin: 0; padding: 0; line-height: 28px;}.header p {color: #645847; font: bold 11px Georgia, serif; margin: 0; padding: 0; line-height: 12px; text-transform: uppercase;}.content h2 {color:#393023 !important; font-weight: bold; margin: 0; padding: 0; line-height: 30px; font-size: 17px;font-family: Helvetica, Arial, sans-serif; }.content p {color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px; font-family: Helvetica, Arial, sans-serif;}.content a {color: #0fa2e6; text-decoration: none;}.footer p {font-size: 11px; color:#bfbfbf; margin: 0; padding: 0;font-family: Helvetica, Arial, sans-serif;}.footer a {color: #0fa2e6; text-decoration: none;}</style>      <table cellpadding="0" cellspacing="0" border="0" align="center" width="100%" style="background: url(''images/bg_email.jpg'') no-repeat center top; padding: 85px 0 35px">  <tbody><tr>  <td align="center">    <table cellpadding="0" cellspacing="0" border="0" align="center" width="599" style="font-family: Georgia, serif; background: url(''images/bg_header.jpg'') no-repeat center top" height="142">      <tbody><tr>        <td style="margin: 0; padding: 40px 0 0; background: #c89c22 url(''images/bg_header.jpg'') no-repeat center top" align="center" valign="top"><h1 style="color: #ede6cb !important; font: normal 24px Georgia, serif; margin: 0; padding: 0; line-height: 28px;">Grandma''s Sweets &amp; Cookies</h1>    </td>      </tr>  <tr>        <td style="margin: 0; padding: 25px 0 0;" align="center" valign="top"><p style="color: #645847; font: bold 11px Georgia, serif; margin: 0; padding: 0; line-height: 12px; text-transform: uppercase;">ESTABLISHED 1405</p>        </td>      </tr>  <tr>  <td style="font-size: 1px; height: 15px; line-height: 1px;" height="15">&nbsp;</td>  </tr></tbody></table><!-- header--><table cellpadding="0" cellspacing="0" border="0" align="center" width="599" style="font-family: Georgia, serif;">      <tbody><tr>        <td width="599" valign="top" align="left" bgcolor="#ffffff" style="font-family: Georgia, serif; background: #fff; border-top: 5px solid #e5bd5f"><table cellpadding="0" cellspacing="0" border="0" style="color: #717171; font: normal 11px Georgia, serif; margin: 0; padding: 0;" width="599"><tbody><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 15px 0 5px; font-family: Georgia, serif;" valign="top" align="center" width="569"><img src="images/divider_top_full.png" alt="divider"><br></td><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><h2 style="color:#393023 !important; font-weight: bold; margin: 0; padding: 0; line-height: 30px; font-size: 17px;font-family: Helvetica, Arial, sans-serif;">Meet Jack — a brown cow.</h2><p style="color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px;">Suspendisse potenti--Fusce eu ante in sapien vestibulum sagittis. Cras purus. Nunc rhoncus. <a href="#" style="color: #0fa2e6; text-decoration: none;">Donec imperdiet</a>, nibh sit amet pharetra placerat, tortor purus condimentum lectus.</p></td><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><img src="images/img.jpg" alt="Cow" style="border: 5px solid #f7f7f4;"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><p style="color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px;">Suspendisse potenti--Fusce eu <a href="#" style="color: #0fa2e6; text-decoration: none;">ante in sapien</a> vestibulum sagittis.</p></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><img src="images/divider_full.png" alt="divider"></td><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 55px; font-family: Helvetica, Arial, sans-serif;" align="left"><h2 style="color:#393023 !important; font-weight: bold; margin: 0; padding: 0; line-height: 30px; font-size: 17px;font-family: Helvetica, Arial, sans-serif;">Cookies feels more valuable now than before</h2><p style="color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px;">Suspendisse potenti--Fusce eu ante in sapien vestibulum sagittis. Cras purus. Nunc rhoncus. Donec imperdiet, nibh sit amet pharetra placerat, tortor purus condimentum lectus. Says Doctor Lichtenstein in an interview done after last nights press conference in Belgium.<a href="#" style="color: #0fa2e6; text-decoration: none;">Dr. Lichtenstein</a> also states his concerns regarding chocolate now suddenly turning yellow the last couple of years. </p></td></tr>  </tbody></table></td>      </tr> <tr>  <td style="font-size: 1px; height: 10px; line-height: 1px;" height="10"><img src="images/spacer.gif" alt="space" width="15"></td>  </tr></tbody></table><!-- body --><table cellpadding="0" cellspacing="0" border="0" align="center" width="599" style="font-family: Georgia, serif; line-height: 10px;" bgcolor="#464646" class="footer">      <tbody><tr>        <td bgcolor="#464646" align="center" style="padding: 15px 0 10px; font-size: 11px; color:#bfbfbf; margin: 0; line-height: 1.2;font-family: Helvetica, Arial, sans-serif;" valign="top"><p style="font-size: 11px; color:#bfbfbf; margin: 0; padding: 0;font-family: Helvetica, Arial, sans-serif;">You''re receiving this newsletter because you bought widgets from us. </p><p style="font-size: 11px; color:#bfbfbf; margin: 0 0 10px 0; padding: 0;font-family: Helvetica, Arial, sans-serif;">Having trouble reading this? <webversion style="color: #0fa2e6; text-decoration: none;">View it in your browser</webversion>. Not interested anymore? <unsubscribe style="color: #0fa2e6; text-decoration: none;">Unsubscribe</unsubscribe> Instantly.</p></td>      </tr>  </tbody></table><!-- footer-->  </td></tr>    </tbody></table>  ', '2014-12-28 19:18:00', 'Hot New Year in Egypt');


--
-- Name: email_campaign_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('email_campaign_id_seq', 1, true);


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO employee VALUES (4, 786, 'Oleg', 'Pogorelov', '', NULL, NULL, NULL);
INSERT INTO employee VALUES (8, 893, 'Oleg', 'Mazur', 'V.', NULL, NULL, NULL);
INSERT INTO employee VALUES (9, 1040, 'Halyna', 'Sereda', '', NULL, NULL, NULL);
INSERT INTO employee VALUES (10, 1041, 'Andrey', 'Shabanov', '', NULL, NULL, NULL);
INSERT INTO employee VALUES (11, 1042, 'Dymitrii', 'Veremeychuk', '', NULL, NULL, NULL);
INSERT INTO employee VALUES (13, 1044, 'Alexandra', 'Koff', NULL, NULL, NULL, NULL);
INSERT INTO employee VALUES (12, 1043, 'Denis', 'Yurin', NULL, NULL, '2014-04-01', NULL);
INSERT INTO employee VALUES (14, 1045, 'Dima', 'Shkreba', NULL, NULL, '2013-04-30', NULL);
INSERT INTO employee VALUES (7, 885, 'Irina', 'Mazur', 'V.', NULL, NULL, 'employee/f8ce7007-df56-471c-a330-c43b678ed2ae.jpg');
INSERT INTO employee VALUES (2, 784, 'John', 'Doe', NULL, NULL, NULL, 'employee/e588d949-e13f-43cc-aa0f-115354289850.jpg');
INSERT INTO employee VALUES (15, 1046, 'Viktoriia', 'Lastovets', NULL, NULL, '2014-04-29', NULL);


--
-- Data for Name: employee_address; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: employee_contact; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO employee_contact VALUES (13, 42);
INSERT INTO employee_contact VALUES (13, 41);
INSERT INTO employee_contact VALUES (2, 60);
INSERT INTO employee_contact VALUES (2, 58);
INSERT INTO employee_contact VALUES (2, 59);


--
-- Data for Name: employee_notification; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO employee_notification VALUES (2, 9);
INSERT INTO employee_notification VALUES (2, 10);
INSERT INTO employee_notification VALUES (2, 11);
INSERT INTO employee_notification VALUES (2, 12);
INSERT INTO employee_notification VALUES (2, 13);
INSERT INTO employee_notification VALUES (2, 14);
INSERT INTO employee_notification VALUES (2, 15);
INSERT INTO employee_notification VALUES (2, 16);


--
-- Data for Name: employee_passport; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO employee_passport VALUES (13, 7);


--
-- Data for Name: employee_subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO employee_subaccount VALUES (2, 1);


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('employees_appointments_h_id_seq', 9, true);


--
-- Data for Name: foodcat; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO foodcat VALUES (1, 973, 'ОВ');
INSERT INTO foodcat VALUES (3, 975, 'BB');
INSERT INTO foodcat VALUES (4, 976, 'HB');
INSERT INTO foodcat VALUES (5, 977, 'HB+');
INSERT INTO foodcat VALUES (6, 978, 'FB');
INSERT INTO foodcat VALUES (7, 979, 'FB+');
INSERT INTO foodcat VALUES (8, 980, 'EXTFB');
INSERT INTO foodcat VALUES (9, 981, 'Mini all inclusive');
INSERT INTO foodcat VALUES (10, 982, 'ALL');
INSERT INTO foodcat VALUES (11, 983, 'Continental Breakfast');
INSERT INTO foodcat VALUES (12, 984, 'English breakfast');
INSERT INTO foodcat VALUES (13, 985, 'American breakfast');
INSERT INTO foodcat VALUES (15, 987, 'UAL');
INSERT INTO foodcat VALUES (16, 988, 'UAI');


--
-- Name: foodcat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('foodcat_id_seq', 16, true);


--
-- Data for Name: hotel; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO hotel VALUES (10, 1292, 5, 'Hotel View Novi Vindolski', 16);
INSERT INTO hotel VALUES (11, 1320, 5, 'PGS Kiris Resort', 17);
INSERT INTO hotel VALUES (12, 1322, 5, 'Justiniano Club Park Conti', 18);
INSERT INTO hotel VALUES (13, 1323, 5, 'PGS World Palace', 17);
INSERT INTO hotel VALUES (14, 1324, 5, 'Concordia Celes Hotel', 18);
INSERT INTO hotel VALUES (15, 1325, 5, 'Akka Alinda Hotel', 17);
INSERT INTO hotel VALUES (16, 1327, 5, 'Grand Haber Hotel', 19);
INSERT INTO hotel VALUES (17, 1330, 5, 'Belconti Resort', 20);
INSERT INTO hotel VALUES (18, 1331, 3, 'Asdem Park', 19);
INSERT INTO hotel VALUES (19, 1334, 4, 'Saphir', 21);
INSERT INTO hotel VALUES (20, 1335, 4, 'Justiniano Club Alanya', 18);
INSERT INTO hotel VALUES (21, 1338, 6, 'Euphoria Palm Beach', 22);
INSERT INTO hotel VALUES (22, 1342, 4, 'Avlida', 23);
INSERT INTO hotel VALUES (23, 1346, 3, 'Calypso', 24);
INSERT INTO hotel VALUES (24, 1349, 4, 'Citta Del Mare', 25);
INSERT INTO hotel VALUES (25, 1350, 4, 'Villa Adriatica', 24);
INSERT INTO hotel VALUES (26, 1354, 4, 'Aldemar Cretan Village', 26);
INSERT INTO hotel VALUES (27, 1357, 4, 'Estival Park Salou Hotel', 27);
INSERT INTO hotel VALUES (28, 1358, 3, 'Playa Park', 27);
INSERT INTO hotel VALUES (29, 1360, 4, 'Best Negresco', 28);
INSERT INTO hotel VALUES (30, 1362, 4, 'Oasis Park & SPA', 29);
INSERT INTO hotel VALUES (31, 1364, 5, 'The Desert Rose Resort', 30);
INSERT INTO hotel VALUES (32, 1367, 4, 'Rehana Sharm Resort', 31);
INSERT INTO hotel VALUES (33, 1386, 4, 'Fantasia', 32);
INSERT INTO hotel VALUES (34, 1470, 5, 'Villa Augusto', 21);
INSERT INTO hotel VALUES (35, 1590, 5, 'Lindos Blue', 36);
INSERT INTO hotel VALUES (36, 1649, 5, 'Sezz Saint-Tropez', 37);


--
-- Name: hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hotel_id_seq', 36, true);


--
-- Data for Name: hotelcat; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO hotelcat VALUES (1, 912, '1*');
INSERT INTO hotelcat VALUES (2, 913, '2*');
INSERT INTO hotelcat VALUES (3, 914, '3*');
INSERT INTO hotelcat VALUES (4, 915, '4*');
INSERT INTO hotelcat VALUES (5, 916, '5*');
INSERT INTO hotelcat VALUES (6, 917, 'HV-1');
INSERT INTO hotelcat VALUES (7, 918, 'HV-2');
INSERT INTO hotelcat VALUES (8, 919, 'De Luxe');


--
-- Name: hotelcat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hotelcat_id_seq', 8, true);


--
-- Data for Name: income; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO income VALUES (5, 1447, 10);
INSERT INTO income VALUES (6, 1448, 8);
INSERT INTO income VALUES (7, 1485, 10);
INSERT INTO income VALUES (20, 1500, 13);
INSERT INTO income VALUES (23, 1509, 14);
INSERT INTO income VALUES (24, 1546, 13);
INSERT INTO income VALUES (25, 1547, 13);
INSERT INTO income VALUES (33, 1607, 16);
INSERT INTO income VALUES (34, 1639, 17);
INSERT INTO income VALUES (35, 1660, 19);
INSERT INTO income VALUES (37, 1876, 21);
INSERT INTO income VALUES (40, 1880, 13);
INSERT INTO income VALUES (41, 1882, 13);
INSERT INTO income VALUES (42, 1910, 14);
INSERT INTO income VALUES (43, 1990, 22);
INSERT INTO income VALUES (44, 1992, 20);
INSERT INTO income VALUES (45, 1993, 22);
INSERT INTO income VALUES (46, 1994, 22);
INSERT INTO income VALUES (47, 1995, 22);
INSERT INTO income VALUES (48, 1996, 19);
INSERT INTO income VALUES (49, 2001, 23);
INSERT INTO income VALUES (50, 2006, 24);


--
-- Name: income_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('income_id_seq', 50, true);


--
-- Data for Name: income_transfer; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO income_transfer VALUES (41, 31);
INSERT INTO income_transfer VALUES (41, 32);
INSERT INTO income_transfer VALUES (37, 41);
INSERT INTO income_transfer VALUES (37, 42);
INSERT INTO income_transfer VALUES (40, 43);
INSERT INTO income_transfer VALUES (40, 44);
INSERT INTO income_transfer VALUES (42, 64);
INSERT INTO income_transfer VALUES (42, 63);
INSERT INTO income_transfer VALUES (44, 77);
INSERT INTO income_transfer VALUES (44, 78);
INSERT INTO income_transfer VALUES (43, 79);
INSERT INTO income_transfer VALUES (43, 80);
INSERT INTO income_transfer VALUES (45, 82);
INSERT INTO income_transfer VALUES (45, 81);
INSERT INTO income_transfer VALUES (46, 84);
INSERT INTO income_transfer VALUES (46, 83);
INSERT INTO income_transfer VALUES (47, 85);
INSERT INTO income_transfer VALUES (47, 86);
INSERT INTO income_transfer VALUES (48, 88);
INSERT INTO income_transfer VALUES (48, 87);
INSERT INTO income_transfer VALUES (49, 89);
INSERT INTO income_transfer VALUES (49, 90);
INSERT INTO income_transfer VALUES (50, 91);
INSERT INTO income_transfer VALUES (50, 92);


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO invoice VALUES (8, '2014-06-05', 1440, 3, '2014-06-05');
INSERT INTO invoice VALUES (10, '2014-06-06', 1442, 2, '2014-06-06');
INSERT INTO invoice VALUES (13, '2014-06-16', 1487, 3, '2014-06-16');
INSERT INTO invoice VALUES (15, '2014-06-16', 1503, 3, '2014-06-16');
INSERT INTO invoice VALUES (14, '2014-06-22', 1502, 4, '2014-06-22');
INSERT INTO invoice VALUES (16, '2014-08-22', 1598, 3, '2014-08-22');
INSERT INTO invoice VALUES (17, '2014-08-24', 1634, 3, '2014-08-24');
INSERT INTO invoice VALUES (19, '2014-08-26', 1657, 3, '2014-08-26');
INSERT INTO invoice VALUES (20, '2014-10-18', 1839, 3, '2014-10-18');
INSERT INTO invoice VALUES (21, '2014-10-24', 1840, 3, '2014-10-27');
INSERT INTO invoice VALUES (22, '2015-01-15', 1987, 3, '2015-01-18');
INSERT INTO invoice VALUES (24, '2015-01-14', 2005, 3, '2015-01-17');
INSERT INTO invoice VALUES (23, '2015-01-16', 2000, 3, '2015-01-20');


--
-- Name: invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('invoice_id_seq', 24, true);


--
-- Data for Name: licence; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO licence VALUES (43, 'dfgfdgdf', '2014-04-22', '2014-04-22', 1191);
INSERT INTO licence VALUES (44, 'TTR-123456', '2014-04-15', '2014-04-23', 1192);
INSERT INTO licence VALUES (46, 'TY678234-89', '2011-06-10', '2017-08-18', 1576);
INSERT INTO licence VALUES (47, 'LNU7862', '2014-12-19', '2019-12-31', 1952);


--
-- Name: licence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('licence_id_seq', 47, true);


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO location VALUES (1, 1091, 'Kestel', 12);
INSERT INTO location VALUES (3, 1093, 'Airport Julyany (Kiev)', 7);
INSERT INTO location VALUES (5, 1097, 'Simferopol', 13);
INSERT INTO location VALUES (6, 1102, 'Munich', 15);
INSERT INTO location VALUES (14, 1287, 'Kiev', 7);
INSERT INTO location VALUES (15, 1289, 'Borispol Airport', 7);
INSERT INTO location VALUES (16, 1291, 'Opatiya', 23);
INSERT INTO location VALUES (17, 1319, 'Kirish', 10);
INSERT INTO location VALUES (18, 1321, 'Okurcalar', 12);
INSERT INTO location VALUES (19, 1326, 'Kemer', 10);
INSERT INTO location VALUES (20, 1329, 'Belek', 24);
INSERT INTO location VALUES (21, 1333, 'Konacli', 25);
INSERT INTO location VALUES (22, 1337, 'Kizilagac', 26);
INSERT INTO location VALUES (23, 1341, 'Paphos', 27);
INSERT INTO location VALUES (24, 1345, 'Marino Centro', 28);
INSERT INTO location VALUES (25, 1348, 'Terrasini', 29);
INSERT INTO location VALUES (26, 1353, 'Hersonissos', 30);
INSERT INTO location VALUES (27, 1356, 'La Pineda', 31);
INSERT INTO location VALUES (28, 1359, 'Salou', 31);
INSERT INTO location VALUES (29, 1361, 'Lorett de Marr', 18);
INSERT INTO location VALUES (30, 1363, 'Hurgada', 9);
INSERT INTO location VALUES (31, 1366, 'Nabk Bey', 32);
INSERT INTO location VALUES (32, 1385, 'Svalyava', 33);
INSERT INTO location VALUES (33, 1417, 'Dnepropetrovsk', 34);
INSERT INTO location VALUES (34, 1468, 'Lviv', 22);
INSERT INTO location VALUES (35, 1588, 'Diagoras Airport', 35);
INSERT INTO location VALUES (36, 1589, 'Rhodos', 35);
INSERT INTO location VALUES (37, 1648, 'Saint-Tropez', 36);


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('location_id_seq', 37, true);


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO navigation VALUES (162, 4, 160, 'Debts', '/debts', NULL, 2, 1921, false, NULL);
INSERT INTO navigation VALUES (163, 4, 26, 'Email Campaigns', '/emails_campaigns', NULL, 2, 1953, true, NULL);
INSERT INTO navigation VALUES (165, 4, 8, 'Company Settings', '/companies_settings', NULL, 3, 1975, true, 'dialog_open');
INSERT INTO navigation VALUES (9, 4, 8, 'Resource Types', '/resources_types', NULL, 1, 779, false, NULL);
INSERT INTO navigation VALUES (15, 4, 8, 'Users', '/users', NULL, 2, 792, false, NULL);
INSERT INTO navigation VALUES (13, 4, 10, 'Employees', '/employees', NULL, 1, 790, false, NULL);
INSERT INTO navigation VALUES (41, 5, NULL, 'Home', '/', 'fa fa-home', 1, 1079, false, NULL);
INSERT INTO navigation VALUES (20, 4, 18, 'Positions', '/positions', NULL, 2, 863, false, NULL);
INSERT INTO navigation VALUES (19, 4, 18, 'Structures', '/structures', NULL, 1, 838, false, NULL);
INSERT INTO navigation VALUES (14, 4, 10, 'Employees Appointments', '/appointments', NULL, 2, 791, false, NULL);
INSERT INTO navigation VALUES (27, 4, 26, 'Advertising Sources', '/advsources', NULL, 1, 902, false, NULL);
INSERT INTO navigation VALUES (22, 4, 21, 'Persons', '/persons', NULL, 1, 866, false, NULL);
INSERT INTO navigation VALUES (47, 5, NULL, 'For Test', '/', 'fa fa-credit-card', 2, 1253, false, NULL);
INSERT INTO navigation VALUES (48, 6, NULL, 'Home', '/', 'fa fa-home', 1, 1079, false, NULL);
INSERT INTO navigation VALUES (49, 6, NULL, 'For Test', '/', 'fa fa-credit-card', 2, 1253, false, NULL);
INSERT INTO navigation VALUES (111, 8, NULL, 'System', '/', 'fa fa-cog', 10, 778, false, NULL);
INSERT INTO navigation VALUES (112, 8, NULL, 'Directories', '/', 'fa fa-book', 9, 873, false, NULL);
INSERT INTO navigation VALUES (108, 8, 111, 'Resource Types', '/resources_types', NULL, 1, 779, false, NULL);
INSERT INTO navigation VALUES (109, 8, 111, 'Users', '/users', NULL, 2, 792, false, NULL);
INSERT INTO navigation VALUES (110, 8, 144, 'Employees', '/employees', NULL, 1, 790, false, NULL);
INSERT INTO navigation VALUES (113, 8, 143, 'Positions', '/positions', NULL, 2, 863, false, NULL);
INSERT INTO navigation VALUES (114, 8, 143, 'Structures', '/structures', NULL, 1, 838, false, NULL);
INSERT INTO navigation VALUES (115, 8, 112, 'Touroperators', '/touroperators', NULL, 11, 1002, false, NULL);
INSERT INTO navigation VALUES (116, 8, 144, 'Employees Appointments', '/appointments', NULL, 2, 791, false, NULL);
INSERT INTO navigation VALUES (117, 8, 112, 'Accomodations', '/accomodations', NULL, 10, 955, false, NULL);
INSERT INTO navigation VALUES (118, 8, 112, 'Food Categories', '/foodcats', NULL, 9, 956, false, NULL);
INSERT INTO navigation VALUES (119, 8, 112, 'Rooms Categories', '/roomcats', NULL, 7, 911, false, NULL);
INSERT INTO navigation VALUES (120, 8, 112, 'Hotels', '/hotels', NULL, 6, 1080, false, NULL);
INSERT INTO navigation VALUES (121, 8, 145, 'Advertising Sources', '/advsources', NULL, 1, 902, false, NULL);
INSERT INTO navigation VALUES (122, 8, 112, 'Hotels Categories', '/hotelcats', NULL, 5, 910, false, NULL);
INSERT INTO navigation VALUES (123, 8, 112, 'Locations', '/locations', NULL, 3, 1089, false, NULL);
INSERT INTO navigation VALUES (124, 8, 112, 'Countries', '/countries', NULL, 4, 874, false, NULL);
INSERT INTO navigation VALUES (125, 8, 112, 'Regions', '/regions', NULL, 3, 879, false, NULL);
INSERT INTO navigation VALUES (126, 8, 146, 'Persons', '/persons', NULL, 1, 866, false, NULL);
INSERT INTO navigation VALUES (127, 8, 112, 'Business Persons', '/bpersons', NULL, 9, 1008, false, NULL);
INSERT INTO navigation VALUES (128, 8, 142, 'Banks', '/banks', NULL, 2, 1212, false, NULL);
INSERT INTO navigation VALUES (129, 8, 142, 'Currencies', '/currencies', NULL, 3, 802, false, NULL);
INSERT INTO navigation VALUES (142, 8, NULL, 'Finance', '/', 'fa fa-credit-card', 9, 1394, false, NULL);
INSERT INTO navigation VALUES (143, 8, NULL, 'Company', '/', 'fa fa-building-o', 8, 837, false, NULL);
INSERT INTO navigation VALUES (144, 8, NULL, 'HR', '/', 'fa fa-group', 7, 780, false, NULL);
INSERT INTO navigation VALUES (145, 8, NULL, 'Marketing', '/', 'fa fa-bullhorn', 6, 900, false, NULL);
INSERT INTO navigation VALUES (146, 8, NULL, 'Clientage', '/', 'fa fa-briefcase', 5, 864, false, NULL);
INSERT INTO navigation VALUES (147, 8, NULL, 'Sales', '/', 'fa fa-legal', 4, 998, false, NULL);
INSERT INTO navigation VALUES (148, 8, NULL, 'Home', '/', 'fa fa-home', 2, 1777, false, NULL);
INSERT INTO navigation VALUES (130, 8, 142, 'Currency Rates', '/currencies_rates', NULL, 5, 1395, false, NULL);
INSERT INTO navigation VALUES (131, 8, 142, 'Income Payments', 'incomes', NULL, 6, 1434, false, NULL);
INSERT INTO navigation VALUES (132, 8, 147, 'Tours', '/tours', NULL, 2, 1075, false, NULL);
INSERT INTO navigation VALUES (133, 8, 147, 'Invoices', '/invoices', NULL, 3, 1368, false, NULL);
INSERT INTO navigation VALUES (134, 8, 142, 'Accounts', '/accounts', NULL, 1, 1436, false, NULL);
INSERT INTO navigation VALUES (135, 8, 147, 'Liabilities', '/liabilities', NULL, 10, 1659, false, NULL);
INSERT INTO navigation VALUES (136, 8, 142, 'Outgoing Payments', '/outgoings', NULL, 7, 1571, false, NULL);
INSERT INTO navigation VALUES (137, 8, 142, 'Refunds', '/refunds', NULL, 9, 1575, false, NULL);
INSERT INTO navigation VALUES (138, 8, 142, 'Services List', '/services', NULL, 1, 1312, false, NULL);
INSERT INTO navigation VALUES (139, 8, 147, 'Services', '/services_sales', NULL, 2, 1369, false, NULL);
INSERT INTO navigation VALUES (140, 8, 112, 'Suppliers', '/suppliers', NULL, 11, 1550, false, NULL);
INSERT INTO navigation VALUES (141, 8, 142, 'Accounts Items', '/accounts_items', NULL, 1, 1425, false, NULL);
INSERT INTO navigation VALUES (151, 4, 155, 'Cross Payments', '/crosspayments', NULL, 11, 1885, false, NULL);
INSERT INTO navigation VALUES (53, 4, NULL, 'Finance', '/', 'fa fa-credit-card', 7, 1394, false, NULL);
INSERT INTO navigation VALUES (156, 4, 53, 'Billing', '/', NULL, 10, 1905, false, NULL);
INSERT INTO navigation VALUES (57, 4, 156, 'Accounts', '/accounts', NULL, 1, 1436, false, NULL);
INSERT INTO navigation VALUES (107, 4, NULL, 'Home', '/', 'fa fa-home', 1, 1777, false, NULL);
INSERT INTO navigation VALUES (32, 4, NULL, 'Sales', '/', 'fa fa-legal', 2, 998, false, NULL);
INSERT INTO navigation VALUES (21, 4, NULL, 'Clientage', '/', 'fa fa-briefcase', 3, 864, false, NULL);
INSERT INTO navigation VALUES (26, 4, NULL, 'Marketing', '/', 'fa fa-bullhorn', 4, 900, false, NULL);
INSERT INTO navigation VALUES (10, 4, NULL, 'HR', '/', 'fa fa-group', 5, 780, false, NULL);
INSERT INTO navigation VALUES (18, 4, NULL, 'Company', '/', 'fa fa-building-o', 6, 837, false, NULL);
INSERT INTO navigation VALUES (23, 4, NULL, 'Directories', '/', 'fa fa-book', 8, 873, false, NULL);
INSERT INTO navigation VALUES (152, 4, NULL, 'Reports', '/', 'fa fa-pie-chart', 9, 1895, false, NULL);
INSERT INTO navigation VALUES (8, 4, NULL, 'System', '/', 'fa fa-cog', 10, 778, false, NULL);
INSERT INTO navigation VALUES (155, 4, 53, 'Payments', '/', NULL, 12, 1904, false, NULL);
INSERT INTO navigation VALUES (56, 4, 155, 'Income Payments', 'incomes', NULL, 9, 1434, false, NULL);
INSERT INTO navigation VALUES (61, 4, 155, 'Outgoing Payments', '/outgoings', NULL, 10, 1571, false, NULL);
INSERT INTO navigation VALUES (150, 4, 156, 'Subaccounts', '/subaccounts', NULL, 2, 1798, false, NULL);
INSERT INTO navigation VALUES (55, 4, 156, 'Accounts Items', '/accounts_items', NULL, 3, 1425, false, NULL);
INSERT INTO navigation VALUES (24, 4, 158, 'Countries', '/countries', NULL, 4, 874, false, NULL);
INSERT INTO navigation VALUES (17, 4, 157, 'Currencies List', '/currencies', NULL, 7, 802, false, NULL);
INSERT INTO navigation VALUES (54, 4, 157, 'Currencies Rates', '/currencies_rates', NULL, 8, 1395, false, NULL);
INSERT INTO navigation VALUES (45, 4, 53, 'Banks', '/banks', NULL, 5, 1212, false, NULL);
INSERT INTO navigation VALUES (50, 4, 53, 'Services List', '/services', NULL, 6, 1312, false, NULL);
INSERT INTO navigation VALUES (25, 4, 158, 'Regions', '/regions', NULL, 3, 879, false, NULL);
INSERT INTO navigation VALUES (43, 4, 158, 'Locations', '/locations', NULL, 3, 1089, false, NULL);
INSERT INTO navigation VALUES (31, 4, 159, 'Food Categories', '/foodcats', NULL, 9, 956, false, NULL);
INSERT INTO navigation VALUES (158, 4, 23, 'Geography', '/', NULL, 13, 1907, false, NULL);
INSERT INTO navigation VALUES (35, 4, 23, 'Touroperators', '/touroperators', NULL, 10, 1002, false, NULL);
INSERT INTO navigation VALUES (29, 4, 159, 'Rooms Categories', '/roomcats', NULL, 7, 911, false, NULL);
INSERT INTO navigation VALUES (30, 4, 159, 'Accomodations', '/accomodations', NULL, 10, 955, false, NULL);
INSERT INTO navigation VALUES (153, 4, 160, 'Turnovers', '/turnovers', NULL, 1, 1896, false, NULL);
INSERT INTO navigation VALUES (36, 4, 23, 'Business Persons', '/bpersons', NULL, 11, 1008, false, NULL);
INSERT INTO navigation VALUES (60, 4, 23, 'Suppliers', '/suppliers', NULL, 9, 1550, false, NULL);
INSERT INTO navigation VALUES (51, 4, 32, 'Invoices', '/invoices', NULL, 4, 1368, false, NULL);
INSERT INTO navigation VALUES (160, 4, 152, 'Billing', '/', NULL, 2, 1909, false, NULL);
INSERT INTO navigation VALUES (28, 4, 159, 'Hotels Categories', '/hotelcats', NULL, 6, 910, false, NULL);
INSERT INTO navigation VALUES (42, 4, 159, 'Hotels List', '/hotels', NULL, 5, 1080, false, NULL);
INSERT INTO navigation VALUES (52, 4, 32, 'Services', '/services_sales', NULL, 3, 1369, false, NULL);
INSERT INTO navigation VALUES (157, 4, 53, 'Currencies', '', NULL, 7, 1906, true, NULL);
INSERT INTO navigation VALUES (159, 4, 23, 'Hotels', '/', NULL, 12, 1908, true, NULL);
INSERT INTO navigation VALUES (38, 4, 32, 'Tours', '/tours_sales', NULL, 2, 1075, false, NULL);


--
-- Data for Name: note; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO note VALUES (1, 1800, 'Для тестирования', NULL);
INSERT INTO note VALUES (2, 1801, 'For testing purpose', NULL);
INSERT INTO note VALUES (3, 1802, 'This resource type is under qustion', '<b>Seems we need new schema for accounting.</b>');
INSERT INTO note VALUES (4, 1803, 'I had asked questions for expert in accounting', 'Alexander said that the most appopriate schema is to use accounts for each object such as persons, touroperators and so on');
INSERT INTO note VALUES (5, 1804, 'Need to ask questions to expert', NULL);
INSERT INTO note VALUES (6, 1808, 'Test note', 'for testing');
INSERT INTO note VALUES (7, 1813, 'dfsdfsdf', NULL);
INSERT INTO note VALUES (8, 1814, 'sfdfsdafasdf', NULL);
INSERT INTO note VALUES (9, 1816, 'asdaDAS', NULL);
INSERT INTO note VALUES (10, 1818, 'asdasdsadas', NULL);
INSERT INTO note VALUES (11, 1820, 'SADFASDFASDF', NULL);
INSERT INTO note VALUES (12, 1823, 'cxvzxcvzxcv', NULL);
INSERT INTO note VALUES (13, 1825, 'zxvzxcv', NULL);
INSERT INTO note VALUES (14, 1827, 'cvxzcvxc', NULL);
INSERT INTO note VALUES (15, 1829, 'xcvzxcvzxcv', NULL);
INSERT INTO note VALUES (16, 1830, 'dsfsdafasdf', NULL);
INSERT INTO note VALUES (17, 1831, 'sdafsdafasd f', NULL);
INSERT INTO note VALUES (18, 1833, 'Main Developer of TravelCRM', 'The main developer of TravelCRM');
INSERT INTO note VALUES (19, 1834, 'tretwertwer', NULL);
INSERT INTO note VALUES (20, 1835, 'sdfsdfsdf', NULL);
INSERT INTO note VALUES (21, 1836, 'asdfsdfsd', NULL);
INSERT INTO note VALUES (22, 1837, 'sdfsdfsdf', NULL);
INSERT INTO note VALUES (23, 1838, 'asdasdaSD', NULL);
INSERT INTO note VALUES (24, 1872, 'For users', 'This subaccount is for Person Garkaviy Andrew');
INSERT INTO note VALUES (25, 1924, 'Passport detalized', 'There is no information about passport');
INSERT INTO note VALUES (26, 1931, 'Resource Task', 'This is for resource only');
INSERT INTO note VALUES (27, 1979, 'Test Note', 'Description to test note');
INSERT INTO note VALUES (28, 1981, 'VIP User', 'This user is for VIP');


--
-- Name: note_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('note_id_seq', 28, true);


--
-- Data for Name: note_resource; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO note_resource VALUES (3, 1797);
INSERT INTO note_resource VALUES (5, 1797);
INSERT INTO note_resource VALUES (24, 1868);
INSERT INTO note_resource VALUES (26, 1930);
INSERT INTO note_resource VALUES (25, 1928);
INSERT INTO note_resource VALUES (27, 1980);
INSERT INTO note_resource VALUES (28, 3);
INSERT INTO note_resource VALUES (18, 784);


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO notification VALUES (3, 1945, 'A reminder of the task #42', 'Do not forget about task!', '2014-12-14 19:51:00.013635', NULL);
INSERT INTO notification VALUES (4, 1946, 'A reminder of the task #42', 'Do not forget about task!', '2014-12-14 20:31:00.012771', NULL);
INSERT INTO notification VALUES (5, 1947, 'A reminder of the task #40', 'Do not forget about task!', '2014-12-14 20:32:00.061386', NULL);
INSERT INTO notification VALUES (6, 1948, 'A reminder of the task #42', 'Do not forget about task!', '2014-12-14 20:34:00.011181', NULL);
INSERT INTO notification VALUES (7, 1949, 'A reminder of the task #42', 'Do not forget about task!', '2014-12-14 20:35:00.011903', NULL);
INSERT INTO notification VALUES (8, 1950, 'A reminder of the task #42', 'Do not forget about task!', '2014-12-14 20:38:00.01699', NULL);
INSERT INTO notification VALUES (9, 1959, 'A reminder of the task #44', 'Do not forget about task!', '2014-12-21 19:21:00.016784', NULL);
INSERT INTO notification VALUES (10, 1961, 'Task: #44', 'Test new scheduler realization', '2014-12-21 19:44:00.016315', NULL);
INSERT INTO notification VALUES (11, 1963, 'Task: Test', 'Test', '2014-12-24 21:33:00.014126', NULL);
INSERT INTO notification VALUES (12, 1965, 'Task: For testing', 'For testing', '2014-12-25 21:06:00.013657', NULL);
INSERT INTO notification VALUES (13, 1972, 'Task: Check Payments', 'Check Payments', '2015-01-04 12:46:00.019127', NULL);
INSERT INTO notification VALUES (14, 1973, 'Task: Check Payments', 'Check Payments', '2015-01-04 14:06:00.016859', NULL);
INSERT INTO notification VALUES (15, 1984, 'Task: Test', 'Test', '2015-01-13 17:01:00.018967', NULL);
INSERT INTO notification VALUES (16, 1986, 'Task: Test 2', 'Test 2', '2015-01-13 17:04:00.011637', NULL);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notification_id_seq', 16, true);


--
-- Data for Name: outgoing; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO outgoing VALUES (11, 1883, 4, '2014-11-14', 8, 100.20);
INSERT INTO outgoing VALUES (13, 1903, 3, '2014-11-18', 10, 8200.00);
INSERT INTO outgoing VALUES (14, 1912, 4, '2014-11-23', 3, 10.00);
INSERT INTO outgoing VALUES (16, 1915, 6, '2014-11-23', 12, 15000.00);


--
-- Name: outgoing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('outgoing_id_seq', 17, true);


--
-- Data for Name: outgoing_transfer; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO outgoing_transfer VALUES (11, 68);
INSERT INTO outgoing_transfer VALUES (14, 70);
INSERT INTO outgoing_transfer VALUES (13, 71);
INSERT INTO outgoing_transfer VALUES (16, 73);


--
-- Data for Name: passport; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO passport VALUES (1, 14, 'foreign', '231654', NULL, 1199, NULL);
INSERT INTO passport VALUES (2, 14, 'foreign', '132456', NULL, 1200, NULL);
INSERT INTO passport VALUES (4, 12, 'foreign', '1234564', NULL, 1205, NULL);
INSERT INTO passport VALUES (5, 14, 'foreign', 'Svxzvxz', 'xzcvxzcv', 1206, NULL);
INSERT INTO passport VALUES (6, 3, 'citizen', 'НК028057', NULL, 1261, NULL);
INSERT INTO passport VALUES (7, 3, 'citizen', 'HJ123456', 'new passport', 1265, NULL);
INSERT INTO passport VALUES (8, 3, 'citizen', 'РМ12345', 'from Kiev region', 1286, NULL);
INSERT INTO passport VALUES (9, 3, 'citizen', 'HK123456', NULL, 1376, NULL);
INSERT INTO passport VALUES (10, 3, 'citizen', 'HK12345', NULL, 1381, NULL);
INSERT INTO passport VALUES (11, 3, 'citizen', 'PO123456', NULL, 1406, NULL);
INSERT INTO passport VALUES (12, 3, 'citizen', 'TY3456', NULL, 1467, '2016-04-10');
INSERT INTO passport VALUES (13, 3, 'citizen', 'YU78932', 'Ukrainian citizen passport', 1582, NULL);
INSERT INTO passport VALUES (14, 3, 'foreign', 'RT678123', 'Foreign Passport', 1584, '2015-08-21');
INSERT INTO passport VALUES (15, 3, 'foreign', 'TY67342', NULL, 1592, '2015-08-28');
INSERT INTO passport VALUES (16, 3, 'citizen', 'IO98676', NULL, 1612, NULL);
INSERT INTO passport VALUES (17, 3, 'foreign', 'ER781263', NULL, 1613, NULL);
INSERT INTO passport VALUES (18, 3, 'citizen', 'НК089564', NULL, 1622, NULL);
INSERT INTO passport VALUES (19, 3, 'citizen', 'RE6712346', NULL, 1625, NULL);
INSERT INTO passport VALUES (20, 3, 'citizen', 'HJ789665', NULL, 1642, NULL);
INSERT INTO passport VALUES (21, 3, 'foreign', 'RT7892634', NULL, 1643, '2017-07-19');
INSERT INTO passport VALUES (22, 3, 'foreign', 'RT632453', NULL, 1651, '2019-08-16');
INSERT INTO passport VALUES (23, 3, 'citizen', 'RTY', NULL, 1925, NULL);


--
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('passport_id_seq', 23, true);


--
-- Data for Name: permision; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO permision VALUES (35, 65, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (34, 61, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (32, 59, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (30, 55, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (38, 41, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (37, 67, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (39, 69, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (40, 39, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (41, 70, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (42, 71, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (43, 72, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (44, 73, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (45, 74, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (46, 75, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (48, 78, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (49, 79, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (26, 47, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (53, 2, 5, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (54, 1, 5, '{view}', NULL, 'all');
INSERT INTO permision VALUES (55, 83, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (56, 84, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (58, 86, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (59, 87, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (61, 89, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (62, 90, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (63, 91, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (21, 1, 4, '{view}', NULL, 'all');
INSERT INTO permision VALUES (65, 93, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (67, 1, 6, '{view}', NULL, 'all');
INSERT INTO permision VALUES (66, 2, 6, '{view,add,edit,delete}', 5, 'structure');
INSERT INTO permision VALUES (68, 1, 7, '{view}', NULL, 'all');
INSERT INTO permision VALUES (69, 2, 7, '{view,add,edit,delete}', 5, 'structure');
INSERT INTO permision VALUES (70, 101, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (22, 2, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (71, 102, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (73, 104, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (74, 105, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (76, 107, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (77, 108, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (79, 110, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (80, 111, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (81, 112, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (78, 109, 4, '{view,add,edit,delete,settings,calculation,invoice,contract}', NULL, 'all');
INSERT INTO permision VALUES (64, 92, 4, '{view,add,edit,delete,settings,invoice,calculation,contract}', NULL, 'all');
INSERT INTO permision VALUES (85, 65, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (86, 61, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (87, 59, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (88, 55, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (89, 41, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (90, 67, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (91, 69, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (92, 39, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (93, 70, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (94, 71, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (95, 72, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (96, 73, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (97, 74, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (98, 75, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (99, 78, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (100, 79, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (101, 47, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (102, 83, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (103, 84, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (104, 86, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (105, 87, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (106, 89, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (24, 12, 4, '{view,add,edit,delete,settings}', NULL, 'all');
INSERT INTO permision VALUES (107, 90, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (108, 91, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (109, 1, 8, '{view}', NULL, 'all');
INSERT INTO permision VALUES (110, 93, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (111, 101, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (112, 2, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (113, 102, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (114, 104, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (115, 105, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (116, 103, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (117, 106, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (118, 107, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (119, 108, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (120, 110, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (121, 111, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (122, 112, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (123, 12, 8, '{view,add,edit,delete,settings}', NULL, 'all');
INSERT INTO permision VALUES (125, 109, 8, '{view,add,edit,delete,settings,calculation,invoice,contract}', NULL, 'all');
INSERT INTO permision VALUES (126, 92, 8, '{view,add,edit,delete,settings,invoice,calculation,contract}', NULL, 'all');
INSERT INTO permision VALUES (128, 117, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (129, 118, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (130, 119, 4, '{autoload,view,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (75, 106, 4, '{view,add,edit,delete,settings}', NULL, 'all');
INSERT INTO permision VALUES (131, 120, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (132, 121, 4, '{view}', NULL, 'all');
INSERT INTO permision VALUES (133, 122, 4, '{view}', NULL, 'all');
INSERT INTO permision VALUES (134, 123, 4, '{view,delete}', NULL, 'all');
INSERT INTO permision VALUES (135, 124, 4, '{view,add,edit,delete,settings}', NULL, 'all');
INSERT INTO permision VALUES (72, 103, 4, '{view,add,edit,delete,settings}', NULL, 'all');
INSERT INTO permision VALUES (136, 125, 4, '{view,settings}', NULL, 'all');
INSERT INTO permision VALUES (137, 126, 4, '{add,edit,view,delete}', NULL, 'all');
INSERT INTO permision VALUES (139, 128, 4, '{edit,view}', NULL, 'all');
INSERT INTO permision VALUES (140, 129, 4, '{view,settings}', NULL, 'all');


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO person VALUES (4, 870, 'Greg', 'Johnson', '', NULL, NULL, false);
INSERT INTO person VALUES (5, 871, 'John', 'Doe', '', NULL, NULL, false);
INSERT INTO person VALUES (6, 887, 'Peter', 'Parker', '', '1976-04-07', NULL, false);
INSERT INTO person VALUES (17, 1284, 'Nikolay', 'Voevoda', '', '1981-07-22', 'male', false);
INSERT INTO person VALUES (18, 1293, 'Irina', 'Voevoda', '', '1984-01-18', 'female', false);
INSERT INTO person VALUES (19, 1294, 'Stas', 'Voevoda', '', '2007-10-16', 'male', false);
INSERT INTO person VALUES (20, 1372, 'Oleg', 'Pogorelov', '', '1970-02-17', 'male', false);
INSERT INTO person VALUES (21, 1375, 'Elena', 'Pogorelova', 'Petrovna', '1972-02-19', 'female', false);
INSERT INTO person VALUES (23, 1389, 'Iren', 'Mazur', '', '1979-09-03', 'female', false);
INSERT INTO person VALUES (24, 1390, 'Igor', 'Mazur', '', '2007-07-21', 'male', false);
INSERT INTO person VALUES (25, 1408, 'Vitalii', 'Klishunov', '', '1976-04-07', 'male', false);
INSERT INTO person VALUES (26, 1409, 'Natalia', 'Klishunova', '', '1978-08-10', 'male', false);
INSERT INTO person VALUES (27, 1410, 'Maxim', 'Klishunov', '', '2005-02-16', 'male', false);
INSERT INTO person VALUES (28, 1411, 'Ann', 'Klishunova', '', '2013-02-14', 'female', false);
INSERT INTO person VALUES (29, 1465, 'Eugen', 'Velichko', '', '1982-04-07', 'male', false);
INSERT INTO person VALUES (30, 1471, 'Irina', 'Avdeeva', '', '1984-11-21', 'female', false);
INSERT INTO person VALUES (31, 1472, 'Velichko', 'Alexander', '', '2006-01-11', 'male', false);
INSERT INTO person VALUES (32, 1473, 'Velichko', 'Elizabeth', '', '2010-06-15', 'female', false);
INSERT INTO person VALUES (34, 1593, 'Elena', 'Babich', '', '1991-05-23', 'female', false);
INSERT INTO person VALUES (33, 1586, 'Roman', 'Babich', '', '1990-11-14', 'male', false);
INSERT INTO person VALUES (36, 1616, 'Nikolay', 'Artyuh', '', '1986-10-08', 'male', false);
INSERT INTO person VALUES (37, 1619, 'Andriy', 'Garkaviy', '', '1984-11-14', 'male', false);
INSERT INTO person VALUES (39, 1627, 'Petro', 'Garkaviy', '', '2004-06-08', 'male', false);
INSERT INTO person VALUES (41, 1645, 'Karpenko', 'Alexander', '', '1990-06-04', 'male', false);
INSERT INTO person VALUES (42, 1653, 'Smichko', 'Olena', '', '1992-07-15', 'female', false);
INSERT INTO person VALUES (40, 1628, 'Alena', 'Garkava', '', '2007-03-29', 'female', true);
INSERT INTO person VALUES (43, 1869, 'Alexey', 'Ivankiv', 'V.', NULL, 'male', true);
INSERT INTO person VALUES (38, 1626, 'Elena', 'Garkava', '', '1986-01-08', 'male', true);
INSERT INTO person VALUES (35, 1615, 'Tat''ana', 'Artyuh', '', '1987-02-10', 'female', true);
INSERT INTO person VALUES (22, 1383, 'Vitalii', 'Mazur', '', '1979-07-17', 'male', true);


--
-- Data for Name: person_address; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO person_address VALUES (17, 10);
INSERT INTO person_address VALUES (20, 15);
INSERT INTO person_address VALUES (21, 16);
INSERT INTO person_address VALUES (22, 17);
INSERT INTO person_address VALUES (23, 18);
INSERT INTO person_address VALUES (24, 19);
INSERT INTO person_address VALUES (25, 20);
INSERT INTO person_address VALUES (29, 23);
INSERT INTO person_address VALUES (33, 24);
INSERT INTO person_address VALUES (35, 25);
INSERT INTO person_address VALUES (37, 26);
INSERT INTO person_address VALUES (41, 27);
INSERT INTO person_address VALUES (42, 28);
INSERT INTO person_address VALUES (30, 30);


--
-- Data for Name: person_contact; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO person_contact VALUES (6, 44);
INSERT INTO person_contact VALUES (17, 45);
INSERT INTO person_contact VALUES (17, 46);
INSERT INTO person_contact VALUES (20, 47);
INSERT INTO person_contact VALUES (21, 48);
INSERT INTO person_contact VALUES (22, 50);
INSERT INTO person_contact VALUES (22, 49);
INSERT INTO person_contact VALUES (23, 51);
INSERT INTO person_contact VALUES (25, 52);
INSERT INTO person_contact VALUES (29, 53);
INSERT INTO person_contact VALUES (33, 67);
INSERT INTO person_contact VALUES (34, 68);
INSERT INTO person_contact VALUES (35, 69);
INSERT INTO person_contact VALUES (35, 70);
INSERT INTO person_contact VALUES (37, 72);
INSERT INTO person_contact VALUES (37, 71);
INSERT INTO person_contact VALUES (38, 73);
INSERT INTO person_contact VALUES (41, 74);
INSERT INTO person_contact VALUES (41, 75);
INSERT INTO person_contact VALUES (42, 76);
INSERT INTO person_contact VALUES (30, 77);
INSERT INTO person_contact VALUES (22, 78);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('person_id_seq', 43, true);


--
-- Data for Name: person_passport; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO person_passport VALUES (17, 8);
INSERT INTO person_passport VALUES (20, 9);
INSERT INTO person_passport VALUES (22, 10);
INSERT INTO person_passport VALUES (25, 11);
INSERT INTO person_passport VALUES (29, 12);
INSERT INTO person_passport VALUES (33, 14);
INSERT INTO person_passport VALUES (33, 13);
INSERT INTO person_passport VALUES (34, 15);
INSERT INTO person_passport VALUES (35, 17);
INSERT INTO person_passport VALUES (35, 16);
INSERT INTO person_passport VALUES (37, 18);
INSERT INTO person_passport VALUES (38, 19);
INSERT INTO person_passport VALUES (41, 20);
INSERT INTO person_passport VALUES (41, 21);
INSERT INTO person_passport VALUES (42, 22);
INSERT INTO person_passport VALUES (30, 23);


--
-- Data for Name: person_subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO person_subaccount VALUES (41, 3);
INSERT INTO person_subaccount VALUES (37, 4);
INSERT INTO person_subaccount VALUES (40, 6);
INSERT INTO person_subaccount VALUES (20, 8);
INSERT INTO person_subaccount VALUES (29, 11);
INSERT INTO person_subaccount VALUES (30, 13);
INSERT INTO person_subaccount VALUES (41, 14);
INSERT INTO person_subaccount VALUES (43, 15);
INSERT INTO person_subaccount VALUES (6, 16);


--
-- Data for Name: position; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "position" VALUES (4, 772, 32, 'Main Developer');
INSERT INTO "position" VALUES (5, 886, 5, 'Finance Director');
INSERT INTO "position" VALUES (6, 1249, 3, 'Sales Manager');
INSERT INTO "position" VALUES (7, 1252, 9, 'Sales Manager');
INSERT INTO "position" VALUES (8, 1775, 1, 'Main Developer');


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('positions_navigations_id_seq', 165, true);


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('positions_permisions_id_seq', 140, true);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO region VALUES (7, 895, 3, 'Kiev region');
INSERT INTO region VALUES (8, 896, 3, 'Lviv region');
INSERT INTO region VALUES (9, 897, 4, 'Hurgada');
INSERT INTO region VALUES (10, 898, 5, 'Kemer');
INSERT INTO region VALUES (12, 1090, 5, 'Antalya');
INSERT INTO region VALUES (13, 1096, 9, 'Cramia');
INSERT INTO region VALUES (15, 1101, 11, 'Bavaria');
INSERT INTO region VALUES (16, 1165, 12, 'Middle Dalmaci');
INSERT INTO region VALUES (17, 1170, 13, 'Fujairah');
INSERT INTO region VALUES (18, 1179, 14, 'Costa Brava');
INSERT INTO region VALUES (19, 1185, 13, 'Abu Dhabi');
INSERT INTO region VALUES (22, 1278, 3, 'Lviv');
INSERT INTO region VALUES (23, 1290, 12, 'Kvarner');
INSERT INTO region VALUES (24, 1328, 5, 'Belek');
INSERT INTO region VALUES (25, 1332, 5, 'Alanya');
INSERT INTO region VALUES (26, 1336, 5, 'Side');
INSERT INTO region VALUES (27, 1340, 16, 'Paphos');
INSERT INTO region VALUES (28, 1344, 17, 'Riminni & Ravenna');
INSERT INTO region VALUES (29, 1347, 17, 'Sicilia Island');
INSERT INTO region VALUES (30, 1352, 18, 'Crit Island');
INSERT INTO region VALUES (31, 1355, 14, 'Costa Dorada');
INSERT INTO region VALUES (32, 1365, 4, 'Sharm el Sheih');
INSERT INTO region VALUES (33, 1384, 3, 'Zakarpat''e');
INSERT INTO region VALUES (34, 1416, 3, 'Dnepropetrovsk');
INSERT INTO region VALUES (35, 1587, 18, 'Rhodos Island');
INSERT INTO region VALUES (36, 1647, 19, 'Chemiu Due Capon');


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO resource VALUES (1080, 65, 32, NULL);
INSERT INTO resource VALUES (1081, 12, 32, NULL);
INSERT INTO resource VALUES (863, 65, 32, NULL);
INSERT INTO resource VALUES (875, 70, 32, NULL);
INSERT INTO resource VALUES (885, 47, 32, NULL);
INSERT INTO resource VALUES (1100, 70, 32, NULL);
INSERT INTO resource VALUES (895, 39, 32, NULL);
INSERT INTO resource VALUES (1101, 39, 32, NULL);
INSERT INTO resource VALUES (1102, 84, 32, NULL);
INSERT INTO resource VALUES (1268, 12, 32, false);
INSERT INTO resource VALUES (998, 65, 32, NULL);
INSERT INTO resource VALUES (1010, 79, 32, NULL);
INSERT INTO resource VALUES (1283, 71, 32, false);
INSERT INTO resource VALUES (1284, 69, 32, false);
INSERT INTO resource VALUES (1287, 84, 32, false);
INSERT INTO resource VALUES (1289, 84, 32, false);
INSERT INTO resource VALUES (728, 55, 32, NULL);
INSERT INTO resource VALUES (784, 47, 32, NULL);
INSERT INTO resource VALUES (1306, 90, 32, false);
INSERT INTO resource VALUES (1312, 65, 32, false);
INSERT INTO resource VALUES (786, 47, 32, NULL);
INSERT INTO resource VALUES (802, 65, 32, NULL);
INSERT INTO resource VALUES (769, 12, 32, NULL);
INSERT INTO resource VALUES (30, 12, 32, NULL);
INSERT INTO resource VALUES (31, 12, 32, NULL);
INSERT INTO resource VALUES (32, 12, 32, NULL);
INSERT INTO resource VALUES (33, 12, 32, NULL);
INSERT INTO resource VALUES (34, 12, 32, NULL);
INSERT INTO resource VALUES (35, 12, 32, NULL);
INSERT INTO resource VALUES (36, 12, 32, NULL);
INSERT INTO resource VALUES (837, 65, 32, NULL);
INSERT INTO resource VALUES (1336, 39, 32, false);
INSERT INTO resource VALUES (1164, 70, 32, NULL);
INSERT INTO resource VALUES (1165, 39, 32, NULL);
INSERT INTO resource VALUES (1337, 84, 32, false);
INSERT INTO resource VALUES (1338, 83, 32, false);
INSERT INTO resource VALUES (1347, 39, 32, false);
INSERT INTO resource VALUES (1348, 84, 32, false);
INSERT INTO resource VALUES (1349, 83, 32, false);
INSERT INTO resource VALUES (1355, 39, 32, false);
INSERT INTO resource VALUES (1356, 84, 32, false);
INSERT INTO resource VALUES (1204, 87, 32, NULL);
INSERT INTO resource VALUES (1207, 12, 32, NULL);
INSERT INTO resource VALUES (1357, 83, 32, false);
INSERT INTO resource VALUES (1218, 39, 32, NULL);
INSERT INTO resource VALUES (1359, 84, 32, false);
INSERT INTO resource VALUES (1360, 83, 32, false);
INSERT INTO resource VALUES (1365, 39, 32, false);
INSERT INTO resource VALUES (1366, 84, 32, false);
INSERT INTO resource VALUES (1367, 83, 32, false);
INSERT INTO resource VALUES (1240, 41, 32, false);
INSERT INTO resource VALUES (1398, 104, 32, false);
INSERT INTO resource VALUES (1257, 87, 32, false);
INSERT INTO resource VALUES (1258, 87, 32, false);
INSERT INTO resource VALUES (1413, 102, 32, false);
INSERT INTO resource VALUES (849, 41, 32, NULL);
INSERT INTO resource VALUES (851, 41, 32, NULL);
INSERT INTO resource VALUES (852, 41, 32, NULL);
INSERT INTO resource VALUES (1285, 87, 32, false);
INSERT INTO resource VALUES (864, 65, 32, NULL);
INSERT INTO resource VALUES (876, 41, 32, NULL);
INSERT INTO resource VALUES (886, 59, 32, NULL);
INSERT INTO resource VALUES (1286, 89, 32, false);
INSERT INTO resource VALUES (896, 39, 32, NULL);
INSERT INTO resource VALUES (897, 39, 32, NULL);
INSERT INTO resource VALUES (772, 59, 32, NULL);
INSERT INTO resource VALUES (788, 12, 32, NULL);
INSERT INTO resource VALUES (706, 12, 32, NULL);
INSERT INTO resource VALUES (1291, 84, 32, false);
INSERT INTO resource VALUES (771, 55, 32, NULL);
INSERT INTO resource VALUES (838, 65, 32, NULL);
INSERT INTO resource VALUES (734, 55, 32, NULL);
INSERT INTO resource VALUES (898, 39, 32, NULL);
INSERT INTO resource VALUES (899, 39, 32, NULL);
INSERT INTO resource VALUES (900, 65, 32, NULL);
INSERT INTO resource VALUES (901, 12, 32, NULL);
INSERT INTO resource VALUES (902, 65, 32, NULL);
INSERT INTO resource VALUES (1292, 83, 32, false);
INSERT INTO resource VALUES (1304, 87, 32, false);
INSERT INTO resource VALUES (1011, 12, 32, NULL);
INSERT INTO resource VALUES (1307, 90, 32, false);
INSERT INTO resource VALUES (1313, 12, 32, false);
INSERT INTO resource VALUES (1368, 65, 32, false);
INSERT INTO resource VALUES (1414, 90, 32, false);
INSERT INTO resource VALUES (1415, 91, 32, false);
INSERT INTO resource VALUES (1185, 39, 32, NULL);
INSERT INTO resource VALUES (1198, 12, 32, NULL);
INSERT INTO resource VALUES (1205, 89, 32, NULL);
INSERT INTO resource VALUES (1221, 12, 32, NULL);
INSERT INTO resource VALUES (1227, 93, 32, NULL);
INSERT INTO resource VALUES (1241, 39, 32, false);
INSERT INTO resource VALUES (1259, 87, 32, false);
INSERT INTO resource VALUES (1260, 87, 32, false);
INSERT INTO resource VALUES (853, 41, 32, NULL);
INSERT INTO resource VALUES (865, 12, 32, NULL);
INSERT INTO resource VALUES (866, 65, 32, NULL);
INSERT INTO resource VALUES (789, 67, 32, NULL);
INSERT INTO resource VALUES (1288, 90, 32, false);
INSERT INTO resource VALUES (887, 69, 32, NULL);
INSERT INTO resource VALUES (1290, 39, 32, false);
INSERT INTO resource VALUES (773, 12, 32, NULL);
INSERT INTO resource VALUES (892, 67, 32, NULL);
INSERT INTO resource VALUES (903, 71, 32, NULL);
INSERT INTO resource VALUES (904, 71, 32, NULL);
INSERT INTO resource VALUES (905, 71, 32, NULL);
INSERT INTO resource VALUES (906, 71, 32, NULL);
INSERT INTO resource VALUES (907, 71, 32, NULL);
INSERT INTO resource VALUES (1308, 90, 32, false);
INSERT INTO resource VALUES (1314, 102, 32, false);
INSERT INTO resource VALUES (1369, 65, 32, false);
INSERT INTO resource VALUES (1372, 69, 32, false);
INSERT INTO resource VALUES (1375, 69, 32, false);
INSERT INTO resource VALUES (1382, 90, 32, false);
INSERT INTO resource VALUES (1168, 41, 32, NULL);
INSERT INTO resource VALUES (1040, 47, 32, NULL);
INSERT INTO resource VALUES (1041, 47, 32, NULL);
INSERT INTO resource VALUES (1042, 47, 32, NULL);
INSERT INTO resource VALUES (1043, 47, 32, NULL);
INSERT INTO resource VALUES (1044, 47, 32, NULL);
INSERT INTO resource VALUES (1045, 47, 32, NULL);
INSERT INTO resource VALUES (1046, 47, 32, NULL);
INSERT INTO resource VALUES (1169, 70, 32, NULL);
INSERT INTO resource VALUES (1388, 90, 32, false);
INSERT INTO resource VALUES (1391, 90, 32, false);
INSERT INTO resource VALUES (1067, 78, 32, NULL);
INSERT INTO resource VALUES (1400, 104, 32, false);
INSERT INTO resource VALUES (1401, 104, 32, false);
INSERT INTO resource VALUES (1199, 89, 32, NULL);
INSERT INTO resource VALUES (1206, 89, 32, NULL);
INSERT INTO resource VALUES (1209, 90, 32, NULL);
INSERT INTO resource VALUES (1402, 104, 32, false);
INSERT INTO resource VALUES (1416, 39, 32, false);
INSERT INTO resource VALUES (1417, 84, 32, false);
INSERT INTO resource VALUES (1418, 90, 32, false);
INSERT INTO resource VALUES (1419, 91, 32, false);
INSERT INTO resource VALUES (1249, 59, 32, false);
INSERT INTO resource VALUES (1250, 55, 32, false);
INSERT INTO resource VALUES (1251, 55, 32, false);
INSERT INTO resource VALUES (1252, 59, 32, false);
INSERT INTO resource VALUES (1261, 89, 32, false);
INSERT INTO resource VALUES (854, 2, 32, NULL);
INSERT INTO resource VALUES (855, 2, 32, NULL);
INSERT INTO resource VALUES (1277, 55, 32, false);
INSERT INTO resource VALUES (1278, 39, 32, false);
INSERT INTO resource VALUES (878, 70, 32, NULL);
INSERT INTO resource VALUES (1293, 69, 32, false);
INSERT INTO resource VALUES (893, 47, 32, NULL);
INSERT INTO resource VALUES (894, 2, 32, NULL);
INSERT INTO resource VALUES (908, 12, 32, NULL);
INSERT INTO resource VALUES (909, 12, 32, NULL);
INSERT INTO resource VALUES (910, 65, 32, NULL);
INSERT INTO resource VALUES (911, 65, 32, NULL);
INSERT INTO resource VALUES (743, 55, 32, NULL);
INSERT INTO resource VALUES (790, 65, 32, NULL);
INSERT INTO resource VALUES (1294, 69, 32, false);
INSERT INTO resource VALUES (763, 55, 32, NULL);
INSERT INTO resource VALUES (1295, 92, 32, false);
INSERT INTO resource VALUES (723, 12, 32, NULL);
INSERT INTO resource VALUES (791, 65, 32, NULL);
INSERT INTO resource VALUES (775, 12, 32, NULL);
INSERT INTO resource VALUES (37, 12, 32, NULL);
INSERT INTO resource VALUES (38, 12, 32, NULL);
INSERT INTO resource VALUES (39, 12, 32, NULL);
INSERT INTO resource VALUES (40, 12, 32, NULL);
INSERT INTO resource VALUES (43, 12, 32, NULL);
INSERT INTO resource VALUES (10, 12, 32, NULL);
INSERT INTO resource VALUES (792, 65, 32, NULL);
INSERT INTO resource VALUES (12, 12, 32, NULL);
INSERT INTO resource VALUES (14, 12, 32, NULL);
INSERT INTO resource VALUES (44, 12, 32, NULL);
INSERT INTO resource VALUES (16, 12, 32, NULL);
INSERT INTO resource VALUES (45, 12, 32, NULL);
INSERT INTO resource VALUES (1309, 90, 32, false);
INSERT INTO resource VALUES (2, 2, 32, NULL);
INSERT INTO resource VALUES (3, 2, 32, NULL);
INSERT INTO resource VALUES (84, 2, 32, NULL);
INSERT INTO resource VALUES (83, 2, 32, NULL);
INSERT INTO resource VALUES (940, 73, 32, NULL);
INSERT INTO resource VALUES (941, 73, 32, NULL);
INSERT INTO resource VALUES (942, 73, 32, NULL);
INSERT INTO resource VALUES (943, 73, 32, NULL);
INSERT INTO resource VALUES (944, 73, 32, NULL);
INSERT INTO resource VALUES (945, 73, 32, NULL);
INSERT INTO resource VALUES (946, 73, 32, NULL);
INSERT INTO resource VALUES (947, 73, 32, NULL);
INSERT INTO resource VALUES (948, 73, 32, NULL);
INSERT INTO resource VALUES (949, 73, 32, NULL);
INSERT INTO resource VALUES (950, 73, 32, NULL);
INSERT INTO resource VALUES (1316, 102, 32, false);
INSERT INTO resource VALUES (952, 73, 32, NULL);
INSERT INTO resource VALUES (939, 73, 32, NULL);
INSERT INTO resource VALUES (938, 73, 32, NULL);
INSERT INTO resource VALUES (937, 73, 32, NULL);
INSERT INTO resource VALUES (936, 73, 32, NULL);
INSERT INTO resource VALUES (935, 73, 32, NULL);
INSERT INTO resource VALUES (1370, 90, 32, false);
INSERT INTO resource VALUES (933, 73, 32, NULL);
INSERT INTO resource VALUES (932, 73, 32, NULL);
INSERT INTO resource VALUES (931, 73, 32, NULL);
INSERT INTO resource VALUES (930, 73, 32, NULL);
INSERT INTO resource VALUES (929, 73, 32, NULL);
INSERT INTO resource VALUES (928, 73, 32, NULL);
INSERT INTO resource VALUES (927, 73, 32, NULL);
INSERT INTO resource VALUES (926, 73, 32, NULL);
INSERT INTO resource VALUES (925, 73, 32, NULL);
INSERT INTO resource VALUES (924, 73, 32, NULL);
INSERT INTO resource VALUES (923, 73, 32, NULL);
INSERT INTO resource VALUES (922, 73, 32, NULL);
INSERT INTO resource VALUES (921, 73, 32, NULL);
INSERT INTO resource VALUES (1371, 87, 32, false);
INSERT INTO resource VALUES (919, 72, 32, NULL);
INSERT INTO resource VALUES (918, 72, 32, NULL);
INSERT INTO resource VALUES (917, 72, 32, NULL);
INSERT INTO resource VALUES (916, 72, 32, NULL);
INSERT INTO resource VALUES (915, 72, 32, NULL);
INSERT INTO resource VALUES (914, 72, 32, NULL);
INSERT INTO resource VALUES (913, 72, 32, NULL);
INSERT INTO resource VALUES (912, 72, 32, NULL);
INSERT INTO resource VALUES (1373, 87, 32, false);
INSERT INTO resource VALUES (1002, 65, 32, NULL);
INSERT INTO resource VALUES (1376, 89, 32, false);
INSERT INTO resource VALUES (1378, 78, 32, false);
INSERT INTO resource VALUES (1385, 84, 32, false);
INSERT INTO resource VALUES (1386, 83, 32, false);
INSERT INTO resource VALUES (1060, 41, 32, NULL);
INSERT INTO resource VALUES (1068, 12, 32, NULL);
INSERT INTO resource VALUES (1075, 65, 32, NULL);
INSERT INTO resource VALUES (1390, 69, 32, false);
INSERT INTO resource VALUES (1403, 104, 32, false);
INSERT INTO resource VALUES (1170, 39, 32, NULL);
INSERT INTO resource VALUES (1178, 70, 32, NULL);
INSERT INTO resource VALUES (1179, 39, 32, NULL);
INSERT INTO resource VALUES (1420, 101, 32, false);
INSERT INTO resource VALUES (1189, 12, 32, NULL);
INSERT INTO resource VALUES (1190, 12, 32, NULL);
INSERT INTO resource VALUES (1200, 89, 32, NULL);
INSERT INTO resource VALUES (1210, 90, 32, NULL);
INSERT INTO resource VALUES (1225, 12, 32, NULL);
INSERT INTO resource VALUES (1230, 93, 32, NULL);
INSERT INTO resource VALUES (1243, 87, 32, false);
INSERT INTO resource VALUES (1253, 65, 32, false);
INSERT INTO resource VALUES (1263, 87, 32, false);
INSERT INTO resource VALUES (856, 2, 32, NULL);
INSERT INTO resource VALUES (870, 69, 32, NULL);
INSERT INTO resource VALUES (1088, 12, 32, NULL);
INSERT INTO resource VALUES (879, 65, 32, NULL);
INSERT INTO resource VALUES (1089, 65, 32, NULL);
INSERT INTO resource VALUES (953, 12, 32, NULL);
INSERT INTO resource VALUES (954, 12, 32, NULL);
INSERT INTO resource VALUES (764, 12, 32, NULL);
INSERT INTO resource VALUES (955, 65, 32, NULL);
INSERT INTO resource VALUES (956, 65, 32, NULL);
INSERT INTO resource VALUES (957, 74, 32, NULL);
INSERT INTO resource VALUES (958, 74, 32, NULL);
INSERT INTO resource VALUES (959, 74, 32, NULL);
INSERT INTO resource VALUES (960, 74, 32, NULL);
INSERT INTO resource VALUES (961, 74, 32, NULL);
INSERT INTO resource VALUES (962, 74, 32, NULL);
INSERT INTO resource VALUES (963, 74, 32, NULL);
INSERT INTO resource VALUES (964, 74, 32, NULL);
INSERT INTO resource VALUES (965, 74, 32, NULL);
INSERT INTO resource VALUES (966, 74, 32, NULL);
INSERT INTO resource VALUES (967, 74, 32, NULL);
INSERT INTO resource VALUES (968, 74, 32, NULL);
INSERT INTO resource VALUES (969, 74, 32, NULL);
INSERT INTO resource VALUES (970, 74, 32, NULL);
INSERT INTO resource VALUES (971, 74, 32, NULL);
INSERT INTO resource VALUES (1310, 41, 32, false);
INSERT INTO resource VALUES (973, 75, 32, NULL);
INSERT INTO resource VALUES (1317, 12, 32, false);
INSERT INTO resource VALUES (975, 75, 32, NULL);
INSERT INTO resource VALUES (976, 75, 32, NULL);
INSERT INTO resource VALUES (977, 75, 32, NULL);
INSERT INTO resource VALUES (978, 75, 32, NULL);
INSERT INTO resource VALUES (274, 12, 32, NULL);
INSERT INTO resource VALUES (283, 12, 32, NULL);
INSERT INTO resource VALUES (1318, 102, 32, false);
INSERT INTO resource VALUES (778, 65, 32, NULL);
INSERT INTO resource VALUES (779, 65, 32, NULL);
INSERT INTO resource VALUES (780, 65, 32, NULL);
INSERT INTO resource VALUES (286, 41, 32, NULL);
INSERT INTO resource VALUES (287, 41, 32, NULL);
INSERT INTO resource VALUES (288, 41, 32, NULL);
INSERT INTO resource VALUES (289, 41, 32, NULL);
INSERT INTO resource VALUES (290, 41, 32, NULL);
INSERT INTO resource VALUES (291, 41, 32, NULL);
INSERT INTO resource VALUES (292, 41, 32, NULL);
INSERT INTO resource VALUES (306, 41, 32, NULL);
INSERT INTO resource VALUES (277, 39, 32, NULL);
INSERT INTO resource VALUES (279, 39, 32, NULL);
INSERT INTO resource VALUES (280, 39, 32, NULL);
INSERT INTO resource VALUES (281, 39, 32, NULL);
INSERT INTO resource VALUES (278, 39, 32, NULL);
INSERT INTO resource VALUES (282, 39, 32, NULL);
INSERT INTO resource VALUES (979, 75, 32, NULL);
INSERT INTO resource VALUES (980, 75, 32, NULL);
INSERT INTO resource VALUES (981, 75, 32, NULL);
INSERT INTO resource VALUES (982, 75, 32, NULL);
INSERT INTO resource VALUES (983, 75, 32, NULL);
INSERT INTO resource VALUES (984, 75, 32, NULL);
INSERT INTO resource VALUES (985, 75, 32, NULL);
INSERT INTO resource VALUES (1319, 84, 32, false);
INSERT INTO resource VALUES (987, 75, 32, NULL);
INSERT INTO resource VALUES (988, 75, 32, NULL);
INSERT INTO resource VALUES (1320, 83, 32, false);
INSERT INTO resource VALUES (1003, 12, 32, NULL);
INSERT INTO resource VALUES (1004, 78, 32, NULL);
INSERT INTO resource VALUES (1005, 78, 32, NULL);
INSERT INTO resource VALUES (1321, 84, 32, false);
INSERT INTO resource VALUES (1322, 83, 32, false);
INSERT INTO resource VALUES (1326, 84, 32, false);
INSERT INTO resource VALUES (1327, 83, 32, false);
INSERT INTO resource VALUES (1328, 39, 32, false);
INSERT INTO resource VALUES (1329, 84, 32, false);
INSERT INTO resource VALUES (1330, 83, 32, false);
INSERT INTO resource VALUES (1374, 90, 32, false);
INSERT INTO resource VALUES (1377, 92, 32, false);
INSERT INTO resource VALUES (1191, 86, 32, NULL);
INSERT INTO resource VALUES (1201, 87, 32, NULL);
INSERT INTO resource VALUES (1211, 12, 32, NULL);
INSERT INTO resource VALUES (1212, 65, 32, NULL);
INSERT INTO resource VALUES (1213, 90, 32, NULL);
INSERT INTO resource VALUES (1380, 87, 32, false);
INSERT INTO resource VALUES (1383, 69, 32, false);
INSERT INTO resource VALUES (1244, 87, 32, false);
INSERT INTO resource VALUES (1264, 87, 32, false);
INSERT INTO resource VALUES (1387, 87, 32, false);
INSERT INTO resource VALUES (1393, 12, 32, false);
INSERT INTO resource VALUES (1394, 65, 32, false);
INSERT INTO resource VALUES (1404, 87, 32, false);
INSERT INTO resource VALUES (1406, 89, 32, false);
INSERT INTO resource VALUES (1409, 69, 32, false);
INSERT INTO resource VALUES (857, 55, 32, NULL);
INSERT INTO resource VALUES (858, 55, 32, NULL);
INSERT INTO resource VALUES (859, 55, 32, NULL);
INSERT INTO resource VALUES (860, 55, 32, NULL);
INSERT INTO resource VALUES (861, 55, 32, NULL);
INSERT INTO resource VALUES (794, 55, 32, NULL);
INSERT INTO resource VALUES (800, 55, 32, NULL);
INSERT INTO resource VALUES (801, 55, 32, NULL);
INSERT INTO resource VALUES (1090, 39, 32, NULL);
INSERT INTO resource VALUES (871, 69, 32, NULL);
INSERT INTO resource VALUES (880, 70, 32, NULL);
INSERT INTO resource VALUES (881, 70, 32, NULL);
INSERT INTO resource VALUES (882, 70, 32, NULL);
INSERT INTO resource VALUES (883, 70, 32, NULL);
INSERT INTO resource VALUES (884, 70, 32, NULL);
INSERT INTO resource VALUES (1091, 84, 32, NULL);
INSERT INTO resource VALUES (1007, 12, 32, NULL);
INSERT INTO resource VALUES (1008, 65, 32, NULL);
INSERT INTO resource VALUES (1093, 84, 32, NULL);
INSERT INTO resource VALUES (1311, 41, 32, false);
INSERT INTO resource VALUES (1062, 55, 32, NULL);
INSERT INTO resource VALUES (1323, 83, 32, false);
INSERT INTO resource VALUES (1324, 83, 32, false);
INSERT INTO resource VALUES (1078, 12, 32, NULL);
INSERT INTO resource VALUES (1325, 83, 32, false);
INSERT INTO resource VALUES (1331, 83, 32, false);
INSERT INTO resource VALUES (1332, 39, 32, false);
INSERT INTO resource VALUES (1333, 84, 32, false);
INSERT INTO resource VALUES (1334, 83, 32, false);
INSERT INTO resource VALUES (1192, 86, 32, NULL);
INSERT INTO resource VALUES (1214, 91, 32, NULL);
INSERT INTO resource VALUES (1379, 87, 32, false);
INSERT INTO resource VALUES (1381, 89, 32, false);
INSERT INTO resource VALUES (1265, 89, 32, false);
INSERT INTO resource VALUES (1384, 39, 32, false);
INSERT INTO resource VALUES (1389, 69, 32, false);
INSERT INTO resource VALUES (1395, 65, 32, false);
INSERT INTO resource VALUES (1407, 90, 32, false);
INSERT INTO resource VALUES (1411, 69, 32, false);
INSERT INTO resource VALUES (1412, 92, 32, false);
INSERT INTO resource VALUES (872, 12, 32, NULL);
INSERT INTO resource VALUES (873, 65, 32, NULL);
INSERT INTO resource VALUES (874, 65, 32, NULL);
INSERT INTO resource VALUES (725, 55, 32, NULL);
INSERT INTO resource VALUES (726, 55, 32, NULL);
INSERT INTO resource VALUES (1282, 87, 32, false);
INSERT INTO resource VALUES (1095, 70, 32, NULL);
INSERT INTO resource VALUES (1009, 79, 32, NULL);
INSERT INTO resource VALUES (1096, 39, 32, NULL);
INSERT INTO resource VALUES (1097, 84, 32, NULL);
INSERT INTO resource VALUES (1335, 83, 32, false);
INSERT INTO resource VALUES (1079, 65, 32, NULL);
INSERT INTO resource VALUES (1099, 39, 32, NULL);
INSERT INTO resource VALUES (1339, 70, 32, false);
INSERT INTO resource VALUES (1340, 39, 32, false);
INSERT INTO resource VALUES (1341, 84, 32, false);
INSERT INTO resource VALUES (1342, 83, 32, false);
INSERT INTO resource VALUES (1343, 70, 32, false);
INSERT INTO resource VALUES (1344, 39, 32, false);
INSERT INTO resource VALUES (1345, 84, 32, false);
INSERT INTO resource VALUES (1159, 78, 32, NULL);
INSERT INTO resource VALUES (1346, 83, 32, false);
INSERT INTO resource VALUES (1350, 83, 32, false);
INSERT INTO resource VALUES (1351, 70, 32, false);
INSERT INTO resource VALUES (1193, 87, 32, NULL);
INSERT INTO resource VALUES (1194, 87, 32, NULL);
INSERT INTO resource VALUES (1195, 87, 32, NULL);
INSERT INTO resource VALUES (1352, 39, 32, false);
INSERT INTO resource VALUES (1353, 84, 32, false);
INSERT INTO resource VALUES (1354, 83, 32, false);
INSERT INTO resource VALUES (1358, 83, 32, false);
INSERT INTO resource VALUES (1361, 84, 32, false);
INSERT INTO resource VALUES (1362, 83, 32, false);
INSERT INTO resource VALUES (1363, 84, 32, false);
INSERT INTO resource VALUES (1364, 83, 32, false);
INSERT INTO resource VALUES (1396, 104, 32, false);
INSERT INTO resource VALUES (1408, 69, 32, false);
INSERT INTO resource VALUES (1410, 69, 32, false);
INSERT INTO resource VALUES (1424, 12, 32, false);
INSERT INTO resource VALUES (1425, 65, 32, false);
INSERT INTO resource VALUES (1426, 105, 32, false);
INSERT INTO resource VALUES (1431, 105, 32, false);
INSERT INTO resource VALUES (1432, 105, 32, false);
INSERT INTO resource VALUES (1433, 12, 32, false);
INSERT INTO resource VALUES (1434, 65, 32, false);
INSERT INTO resource VALUES (1435, 12, 32, false);
INSERT INTO resource VALUES (1436, 65, 32, false);
INSERT INTO resource VALUES (1438, 107, 32, false);
INSERT INTO resource VALUES (1439, 107, 32, false);
INSERT INTO resource VALUES (1440, 103, 32, false);
INSERT INTO resource VALUES (1442, 103, 32, false);
INSERT INTO resource VALUES (1447, 106, 32, false);
INSERT INTO resource VALUES (1448, 106, 32, false);
INSERT INTO resource VALUES (1450, 12, 32, false);
INSERT INTO resource VALUES (1452, 12, 32, false);
INSERT INTO resource VALUES (1453, 108, 32, false);
INSERT INTO resource VALUES (1454, 108, 32, false);
INSERT INTO resource VALUES (1455, 108, 32, false);
INSERT INTO resource VALUES (1456, 109, 32, false);
INSERT INTO resource VALUES (1457, 108, 32, false);
INSERT INTO resource VALUES (1458, 108, 32, false);
INSERT INTO resource VALUES (1459, 108, 32, false);
INSERT INTO resource VALUES (1460, 108, 32, false);
INSERT INTO resource VALUES (1461, 108, 32, false);
INSERT INTO resource VALUES (1462, 108, 32, false);
INSERT INTO resource VALUES (1463, 108, 32, false);
INSERT INTO resource VALUES (1464, 87, 32, false);
INSERT INTO resource VALUES (1465, 69, 32, false);
INSERT INTO resource VALUES (1467, 89, 32, false);
INSERT INTO resource VALUES (1468, 84, 32, false);
INSERT INTO resource VALUES (1469, 90, 32, false);
INSERT INTO resource VALUES (1470, 83, 32, false);
INSERT INTO resource VALUES (1471, 69, 32, false);
INSERT INTO resource VALUES (1472, 69, 32, false);
INSERT INTO resource VALUES (1473, 69, 32, false);
INSERT INTO resource VALUES (1474, 108, 32, false);
INSERT INTO resource VALUES (1475, 108, 32, false);
INSERT INTO resource VALUES (1476, 108, 32, false);
INSERT INTO resource VALUES (1477, 108, 32, false);
INSERT INTO resource VALUES (1478, 108, 32, false);
INSERT INTO resource VALUES (1479, 108, 32, false);
INSERT INTO resource VALUES (1480, 92, 32, false);
INSERT INTO resource VALUES (1481, 108, 32, false);
INSERT INTO resource VALUES (1482, 108, 32, false);
INSERT INTO resource VALUES (1483, 108, 32, false);
INSERT INTO resource VALUES (1485, 106, 32, false);
INSERT INTO resource VALUES (1487, 103, 32, false);
INSERT INTO resource VALUES (1500, 106, 32, false);
INSERT INTO resource VALUES (1502, 103, 32, false);
INSERT INTO resource VALUES (1503, 103, 32, false);
INSERT INTO resource VALUES (1504, 104, 32, false);
INSERT INTO resource VALUES (1505, 104, 32, false);
INSERT INTO resource VALUES (1506, 104, 32, false);
INSERT INTO resource VALUES (1507, 107, 32, false);
INSERT INTO resource VALUES (1509, 106, 32, false);
INSERT INTO resource VALUES (1510, 101, 32, false);
INSERT INTO resource VALUES (1511, 101, 32, false);
INSERT INTO resource VALUES (1512, 101, 32, false);
INSERT INTO resource VALUES (1513, 101, 32, false);
INSERT INTO resource VALUES (1514, 101, 32, false);
INSERT INTO resource VALUES (1515, 101, 32, false);
INSERT INTO resource VALUES (1516, 87, 32, false);
INSERT INTO resource VALUES (1517, 87, 32, false);
INSERT INTO resource VALUES (1518, 87, 32, false);
INSERT INTO resource VALUES (1519, 87, 32, false);
INSERT INTO resource VALUES (1520, 108, 32, false);
INSERT INTO resource VALUES (1521, 12, 32, false);
INSERT INTO resource VALUES (1535, 110, 32, false);
INSERT INTO resource VALUES (1536, 110, 32, false);
INSERT INTO resource VALUES (1537, 110, 32, false);
INSERT INTO resource VALUES (1538, 110, 32, false);
INSERT INTO resource VALUES (1539, 110, 32, false);
INSERT INTO resource VALUES (1540, 110, 32, false);
INSERT INTO resource VALUES (1541, 110, 32, false);
INSERT INTO resource VALUES (1542, 67, 32, false);
INSERT INTO resource VALUES (1543, 87, 32, false);
INSERT INTO resource VALUES (1544, 87, 32, false);
INSERT INTO resource VALUES (1545, 87, 32, false);
INSERT INTO resource VALUES (1546, 106, 32, false);
INSERT INTO resource VALUES (1547, 106, 32, false);
INSERT INTO resource VALUES (1548, 12, 32, false);
INSERT INTO resource VALUES (1549, 12, 32, false);
INSERT INTO resource VALUES (1550, 65, 32, false);
INSERT INTO resource VALUES (1551, 87, 32, false);
INSERT INTO resource VALUES (1552, 87, 32, false);
INSERT INTO resource VALUES (1553, 79, 32, false);
INSERT INTO resource VALUES (1554, 101, 32, false);
INSERT INTO resource VALUES (1556, 101, 32, false);
INSERT INTO resource VALUES (1559, 87, 32, false);
INSERT INTO resource VALUES (1560, 79, 32, false);
INSERT INTO resource VALUES (1561, 87, 32, false);
INSERT INTO resource VALUES (1562, 87, 32, false);
INSERT INTO resource VALUES (1563, 79, 32, false);
INSERT INTO resource VALUES (1564, 101, 32, false);
INSERT INTO resource VALUES (1567, 112, 32, false);
INSERT INTO resource VALUES (1568, 112, 32, false);
INSERT INTO resource VALUES (1569, 101, 32, false);
INSERT INTO resource VALUES (1570, 101, 32, false);
INSERT INTO resource VALUES (1571, 65, 32, false);
INSERT INTO resource VALUES (1575, 65, 32, false);
INSERT INTO resource VALUES (1576, 86, 32, false);
INSERT INTO resource VALUES (1577, 87, 32, false);
INSERT INTO resource VALUES (1578, 79, 32, false);
INSERT INTO resource VALUES (1579, 110, 32, false);
INSERT INTO resource VALUES (1580, 78, 32, false);
INSERT INTO resource VALUES (1581, 87, 32, false);
INSERT INTO resource VALUES (1582, 89, 32, false);
INSERT INTO resource VALUES (1584, 89, 32, false);
INSERT INTO resource VALUES (1585, 90, 32, false);
INSERT INTO resource VALUES (1586, 69, 32, false);
INSERT INTO resource VALUES (1587, 39, 32, false);
INSERT INTO resource VALUES (1588, 84, 32, false);
INSERT INTO resource VALUES (1589, 84, 32, false);
INSERT INTO resource VALUES (1590, 83, 32, false);
INSERT INTO resource VALUES (1591, 87, 32, false);
INSERT INTO resource VALUES (1592, 89, 32, false);
INSERT INTO resource VALUES (1593, 69, 32, false);
INSERT INTO resource VALUES (1594, 92, 32, false);
INSERT INTO resource VALUES (1595, 108, 32, false);
INSERT INTO resource VALUES (1596, 108, 32, false);
INSERT INTO resource VALUES (1597, 104, 32, false);
INSERT INTO resource VALUES (1598, 103, 32, false);
INSERT INTO resource VALUES (1600, 108, 32, false);
INSERT INTO resource VALUES (1607, 106, 32, false);
INSERT INTO resource VALUES (1608, 105, 32, false);
INSERT INTO resource VALUES (1609, 105, 32, false);
INSERT INTO resource VALUES (1610, 87, 32, false);
INSERT INTO resource VALUES (1611, 87, 32, false);
INSERT INTO resource VALUES (1612, 89, 32, false);
INSERT INTO resource VALUES (1613, 89, 32, false);
INSERT INTO resource VALUES (1614, 90, 32, false);
INSERT INTO resource VALUES (1615, 69, 32, false);
INSERT INTO resource VALUES (1616, 69, 32, false);
INSERT INTO resource VALUES (1617, 92, 32, false);
INSERT INTO resource VALUES (1618, 108, 32, false);
INSERT INTO resource VALUES (1619, 69, 32, false);
INSERT INTO resource VALUES (1620, 87, 32, false);
INSERT INTO resource VALUES (1621, 87, 32, false);
INSERT INTO resource VALUES (1622, 89, 32, false);
INSERT INTO resource VALUES (1623, 90, 32, false);
INSERT INTO resource VALUES (1624, 87, 32, false);
INSERT INTO resource VALUES (1625, 89, 32, false);
INSERT INTO resource VALUES (1626, 69, 32, false);
INSERT INTO resource VALUES (1627, 69, 32, false);
INSERT INTO resource VALUES (1628, 69, 32, false);
INSERT INTO resource VALUES (1629, 108, 32, false);
INSERT INTO resource VALUES (1630, 92, 32, false);
INSERT INTO resource VALUES (1631, 108, 32, false);
INSERT INTO resource VALUES (1632, 108, 32, false);
INSERT INTO resource VALUES (1633, 108, 32, false);
INSERT INTO resource VALUES (1634, 103, 32, false);
INSERT INTO resource VALUES (1639, 106, 32, false);
INSERT INTO resource VALUES (1640, 87, 32, false);
INSERT INTO resource VALUES (1641, 87, 32, false);
INSERT INTO resource VALUES (1642, 89, 32, false);
INSERT INTO resource VALUES (1643, 89, 32, false);
INSERT INTO resource VALUES (1644, 90, 32, false);
INSERT INTO resource VALUES (1645, 69, 32, false);
INSERT INTO resource VALUES (1646, 70, 32, false);
INSERT INTO resource VALUES (1647, 39, 32, false);
INSERT INTO resource VALUES (1648, 84, 32, false);
INSERT INTO resource VALUES (1649, 83, 32, false);
INSERT INTO resource VALUES (1650, 87, 32, false);
INSERT INTO resource VALUES (1651, 89, 32, false);
INSERT INTO resource VALUES (1652, 90, 32, false);
INSERT INTO resource VALUES (1653, 69, 32, false);
INSERT INTO resource VALUES (1654, 108, 32, false);
INSERT INTO resource VALUES (1655, 108, 32, false);
INSERT INTO resource VALUES (1656, 92, 32, false);
INSERT INTO resource VALUES (1657, 103, 32, false);
INSERT INTO resource VALUES (1659, 65, 32, false);
INSERT INTO resource VALUES (1660, 106, 32, false);
INSERT INTO resource VALUES (1714, 110, 32, false);
INSERT INTO resource VALUES (1721, 110, 32, false);
INSERT INTO resource VALUES (1758, 108, 32, false);
INSERT INTO resource VALUES (1759, 109, 32, false);
INSERT INTO resource VALUES (1764, 111, 32, false);
INSERT INTO resource VALUES (1766, 111, 32, false);
INSERT INTO resource VALUES (1769, 105, 32, false);
INSERT INTO resource VALUES (1771, 111, 32, false);
INSERT INTO resource VALUES (1773, 111, 32, false);
INSERT INTO resource VALUES (1774, 111, 32, false);
INSERT INTO resource VALUES (1775, 59, 32, false);
INSERT INTO resource VALUES (1777, 65, 32, false);
INSERT INTO resource VALUES (1778, 12, 1, false);
INSERT INTO resource VALUES (1780, 105, 32, false);
INSERT INTO resource VALUES (1797, 12, 32, false);
INSERT INTO resource VALUES (1798, 65, 32, false);
INSERT INTO resource VALUES (1799, 12, 32, false);
INSERT INTO resource VALUES (1800, 118, 32, false);
INSERT INTO resource VALUES (1801, 118, 32, false);
INSERT INTO resource VALUES (1802, 118, 32, false);
INSERT INTO resource VALUES (1803, 118, 32, false);
INSERT INTO resource VALUES (1804, 118, 32, false);
INSERT INTO resource VALUES (1807, 90, 32, false);
INSERT INTO resource VALUES (1808, 118, 32, false);
INSERT INTO resource VALUES (1813, 118, 32, false);
INSERT INTO resource VALUES (1814, 118, 32, false);
INSERT INTO resource VALUES (1816, 118, 32, false);
INSERT INTO resource VALUES (1818, 118, 32, false);
INSERT INTO resource VALUES (1820, 118, 32, false);
INSERT INTO resource VALUES (1823, 118, 32, false);
INSERT INTO resource VALUES (1825, 118, 32, false);
INSERT INTO resource VALUES (1827, 118, 32, false);
INSERT INTO resource VALUES (1829, 118, 32, false);
INSERT INTO resource VALUES (1830, 118, 32, false);
INSERT INTO resource VALUES (1831, 118, 32, false);
INSERT INTO resource VALUES (1833, 118, 32, false);
INSERT INTO resource VALUES (1834, 118, 32, false);
INSERT INTO resource VALUES (1835, 118, 32, false);
INSERT INTO resource VALUES (1836, 118, 32, false);
INSERT INTO resource VALUES (1837, 118, 32, false);
INSERT INTO resource VALUES (1838, 118, 32, false);
INSERT INTO resource VALUES (1839, 103, 32, false);
INSERT INTO resource VALUES (1840, 103, 32, false);
INSERT INTO resource VALUES (1841, 108, 32, false);
INSERT INTO resource VALUES (1842, 108, 32, false);
INSERT INTO resource VALUES (1843, 108, 32, false);
INSERT INTO resource VALUES (1844, 108, 32, false);
INSERT INTO resource VALUES (1845, 108, 32, false);
INSERT INTO resource VALUES (1846, 108, 32, false);
INSERT INTO resource VALUES (1847, 108, 32, false);
INSERT INTO resource VALUES (1848, 108, 32, false);
INSERT INTO resource VALUES (1849, 12, 32, false);
INSERT INTO resource VALUES (1852, 119, 32, false);
INSERT INTO resource VALUES (1853, 119, 32, false);
INSERT INTO resource VALUES (1854, 119, 32, false);
INSERT INTO resource VALUES (1855, 119, 32, false);
INSERT INTO resource VALUES (1859, 119, 32, false);
INSERT INTO resource VALUES (1860, 119, 32, false);
INSERT INTO resource VALUES (1861, 119, 32, false);
INSERT INTO resource VALUES (1862, 119, 32, false);
INSERT INTO resource VALUES (1863, 119, 32, false);
INSERT INTO resource VALUES (1864, 119, 32, false);
INSERT INTO resource VALUES (1865, 117, 32, false);
INSERT INTO resource VALUES (1866, 117, 32, false);
INSERT INTO resource VALUES (1867, 117, 32, false);
INSERT INTO resource VALUES (1868, 117, 32, false);
INSERT INTO resource VALUES (1869, 69, 32, false);
INSERT INTO resource VALUES (1870, 78, 32, false);
INSERT INTO resource VALUES (1872, 118, 32, false);
INSERT INTO resource VALUES (1873, 105, 32, false);
INSERT INTO resource VALUES (1875, 106, 32, false);
INSERT INTO resource VALUES (1876, 106, 32, false);
INSERT INTO resource VALUES (1880, 106, 32, false);
INSERT INTO resource VALUES (1881, 106, 32, false);
INSERT INTO resource VALUES (1882, 106, 32, false);
INSERT INTO resource VALUES (1883, 111, 32, false);
INSERT INTO resource VALUES (1884, 12, 32, false);
INSERT INTO resource VALUES (1885, 65, 32, false);
INSERT INTO resource VALUES (1888, 117, 32, false);
INSERT INTO resource VALUES (1893, 120, 32, false);
INSERT INTO resource VALUES (1894, 12, 32, false);
INSERT INTO resource VALUES (1895, 65, 32, false);
INSERT INTO resource VALUES (1896, 65, 32, false);
INSERT INTO resource VALUES (1898, 105, 32, false);
INSERT INTO resource VALUES (1900, 120, 32, false);
INSERT INTO resource VALUES (1901, 120, 32, false);
INSERT INTO resource VALUES (1902, 117, 32, false);
INSERT INTO resource VALUES (1903, 111, 32, false);
INSERT INTO resource VALUES (1904, 65, 32, false);
INSERT INTO resource VALUES (1905, 65, 32, false);
INSERT INTO resource VALUES (1906, 65, 32, false);
INSERT INTO resource VALUES (1907, 65, 32, false);
INSERT INTO resource VALUES (1908, 65, 32, false);
INSERT INTO resource VALUES (1909, 65, 32, false);
INSERT INTO resource VALUES (1910, 106, 32, false);
INSERT INTO resource VALUES (1911, 106, 32, false);
INSERT INTO resource VALUES (1912, 111, 32, false);
INSERT INTO resource VALUES (1913, 117, 32, false);
INSERT INTO resource VALUES (1915, 111, 32, false);
INSERT INTO resource VALUES (1917, 110, 32, false);
INSERT INTO resource VALUES (1918, 119, 32, false);
INSERT INTO resource VALUES (1919, 12, 32, false);
INSERT INTO resource VALUES (1921, 65, 32, false);
INSERT INTO resource VALUES (1922, 93, 32, false);
INSERT INTO resource VALUES (1923, 93, 32, false);
INSERT INTO resource VALUES (1924, 118, 32, false);
INSERT INTO resource VALUES (1925, 89, 32, false);
INSERT INTO resource VALUES (1926, 90, 32, false);
INSERT INTO resource VALUES (1927, 87, 32, false);
INSERT INTO resource VALUES (1928, 92, 32, false);
INSERT INTO resource VALUES (1929, 108, 32, false);
INSERT INTO resource VALUES (1930, 93, 32, false);
INSERT INTO resource VALUES (1931, 118, 32, false);
INSERT INTO resource VALUES (1932, 93, 32, false);
INSERT INTO resource VALUES (1933, 93, 32, false);
INSERT INTO resource VALUES (1934, 93, 32, false);
INSERT INTO resource VALUES (1935, 93, 32, false);
INSERT INTO resource VALUES (1936, 93, 32, false);
INSERT INTO resource VALUES (1939, 93, 32, false);
INSERT INTO resource VALUES (1940, 93, 32, false);
INSERT INTO resource VALUES (1941, 12, 32, false);
INSERT INTO resource VALUES (1945, 123, 32, false);
INSERT INTO resource VALUES (1946, 123, 32, false);
INSERT INTO resource VALUES (1947, 123, 32, false);
INSERT INTO resource VALUES (1948, 123, 32, false);
INSERT INTO resource VALUES (1949, 123, 32, false);
INSERT INTO resource VALUES (1950, 123, 32, false);
INSERT INTO resource VALUES (1951, 90, 32, false);
INSERT INTO resource VALUES (1952, 86, 32, false);
INSERT INTO resource VALUES (1953, 65, 32, false);
INSERT INTO resource VALUES (1954, 12, 32, false);
INSERT INTO resource VALUES (1955, 124, 32, false);
INSERT INTO resource VALUES (1956, 87, 32, false);
INSERT INTO resource VALUES (1958, 93, 32, false);
INSERT INTO resource VALUES (1959, 123, 32, false);
INSERT INTO resource VALUES (1961, 123, 32, false);
INSERT INTO resource VALUES (1962, 93, 32, false);
INSERT INTO resource VALUES (1963, 123, 32, false);
INSERT INTO resource VALUES (1964, 93, 32, false);
INSERT INTO resource VALUES (1965, 123, 32, false);
INSERT INTO resource VALUES (1966, 12, 32, false);
INSERT INTO resource VALUES (1968, 12, 32, false);
INSERT INTO resource VALUES (1970, 126, 32, false);
INSERT INTO resource VALUES (1971, 93, 32, false);
INSERT INTO resource VALUES (1972, 123, 32, false);
INSERT INTO resource VALUES (1973, 123, 32, false);
INSERT INTO resource VALUES (1975, 65, 32, false);
INSERT INTO resource VALUES (1976, 55, 32, false);
INSERT INTO resource VALUES (1977, 12, 32, false);
INSERT INTO resource VALUES (1978, 2, 32, false);
INSERT INTO resource VALUES (1979, 118, 32, false);
INSERT INTO resource VALUES (1980, 93, 32, false);
INSERT INTO resource VALUES (1981, 118, 32, false);
INSERT INTO resource VALUES (1982, 93, 32, false);
INSERT INTO resource VALUES (1983, 93, 32, false);
INSERT INTO resource VALUES (1984, 123, 32, false);
INSERT INTO resource VALUES (1985, 93, 32, false);
INSERT INTO resource VALUES (1986, 123, 32, false);
INSERT INTO resource VALUES (1987, 103, 32, false);
INSERT INTO resource VALUES (1988, 119, 32, false);
INSERT INTO resource VALUES (1989, 12, 32, false);
INSERT INTO resource VALUES (1990, 106, 32, false);
INSERT INTO resource VALUES (1991, 106, 32, false);
INSERT INTO resource VALUES (1992, 106, 32, false);
INSERT INTO resource VALUES (1993, 106, 32, false);
INSERT INTO resource VALUES (1994, 106, 32, false);
INSERT INTO resource VALUES (1995, 106, 32, false);
INSERT INTO resource VALUES (1996, 106, 32, false);
INSERT INTO resource VALUES (1997, 106, 32, false);
INSERT INTO resource VALUES (1998, 108, 32, false);
INSERT INTO resource VALUES (1999, 109, 32, false);
INSERT INTO resource VALUES (2000, 103, 32, false);
INSERT INTO resource VALUES (2001, 106, 32, false);
INSERT INTO resource VALUES (2002, 106, 32, false);
INSERT INTO resource VALUES (2003, 108, 32, false);
INSERT INTO resource VALUES (2004, 109, 32, false);
INSERT INTO resource VALUES (2005, 103, 32, false);
INSERT INTO resource VALUES (2006, 106, 32, false);
INSERT INTO resource VALUES (2007, 106, 32, false);


--
-- Data for Name: resource_log; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO resource_log VALUES (142, 83, 2, NULL, '2013-12-07 16:38:38.11618');
INSERT INTO resource_log VALUES (143, 84, 2, NULL, '2013-12-07 16:39:56.788641');
INSERT INTO resource_log VALUES (144, 3, 2, NULL, '2013-12-07 16:41:27.65259');
INSERT INTO resource_log VALUES (145, 2, 2, NULL, '2013-12-07 16:41:31.748494');
INSERT INTO resource_log VALUES (146, 83, 2, NULL, '2013-12-07 16:58:05.802634');
INSERT INTO resource_log VALUES (147, 83, 2, NULL, '2013-12-07 17:00:14.544264');
INSERT INTO resource_log VALUES (4836, 794, 2, NULL, '2014-02-05 19:54:07.5415');
INSERT INTO resource_log VALUES (5406, 1192, 2, NULL, '2014-04-06 19:21:11.278173');
INSERT INTO resource_log VALUES (5407, 1005, 2, NULL, '2014-04-06 19:21:55.315341');
INSERT INTO resource_log VALUES (4845, 283, 2, NULL, '2014-02-06 11:38:41.090464');
INSERT INTO resource_log VALUES (2, 10, 2, NULL, '2013-11-16 19:00:14.24272');
INSERT INTO resource_log VALUES (4, 12, 2, NULL, '2013-11-16 19:00:15.497284');
INSERT INTO resource_log VALUES (6, 14, 2, NULL, '2013-11-16 19:00:16.696731');
INSERT INTO resource_log VALUES (8, 16, 2, NULL, '2013-11-16 19:00:17.960761');
INSERT INTO resource_log VALUES (5427, 1204, 2, NULL, '2014-04-09 18:54:09.146902');
INSERT INTO resource_log VALUES (12, 30, 2, NULL, '2013-11-23 19:26:00.193553');
INSERT INTO resource_log VALUES (13, 30, 2, NULL, '2013-11-23 22:02:37.363677');
INSERT INTO resource_log VALUES (14, 10, 2, NULL, '2013-11-23 22:11:01.634598');
INSERT INTO resource_log VALUES (15, 30, 2, NULL, '2013-11-23 22:11:14.939938');
INSERT INTO resource_log VALUES (16, 30, 2, NULL, '2013-11-23 22:11:38.396085');
INSERT INTO resource_log VALUES (19, 30, 2, NULL, '2013-11-24 10:30:59.830287');
INSERT INTO resource_log VALUES (20, 30, 2, NULL, '2013-11-24 10:31:22.936737');
INSERT INTO resource_log VALUES (21, 30, 2, NULL, '2013-11-24 10:38:08.07328');
INSERT INTO resource_log VALUES (22, 30, 2, NULL, '2013-11-24 10:38:10.703187');
INSERT INTO resource_log VALUES (23, 30, 2, NULL, '2013-11-24 10:38:11.896934');
INSERT INTO resource_log VALUES (24, 30, 2, NULL, '2013-11-24 10:42:19.397852');
INSERT INTO resource_log VALUES (25, 30, 2, NULL, '2013-11-24 10:42:50.772172');
INSERT INTO resource_log VALUES (26, 30, 2, NULL, '2013-11-24 10:45:56.399572');
INSERT INTO resource_log VALUES (27, 30, 2, NULL, '2013-11-24 10:48:29.950669');
INSERT INTO resource_log VALUES (28, 30, 2, NULL, '2013-11-24 10:49:23.616693');
INSERT INTO resource_log VALUES (29, 30, 2, NULL, '2013-11-24 10:50:05.878643');
INSERT INTO resource_log VALUES (30, 30, 2, NULL, '2013-11-24 10:51:02.465585');
INSERT INTO resource_log VALUES (31, 30, 2, NULL, '2013-11-24 10:54:21.011765');
INSERT INTO resource_log VALUES (32, 30, 2, NULL, '2013-11-24 10:54:28.775552');
INSERT INTO resource_log VALUES (33, 30, 2, NULL, '2013-11-24 10:58:34.152869');
INSERT INTO resource_log VALUES (34, 30, 2, NULL, '2013-11-24 10:58:36.766104');
INSERT INTO resource_log VALUES (35, 30, 2, NULL, '2013-11-24 10:58:38.767749');
INSERT INTO resource_log VALUES (36, 30, 2, NULL, '2013-11-24 10:58:42.533162');
INSERT INTO resource_log VALUES (37, 30, 2, NULL, '2013-11-24 10:58:43.55758');
INSERT INTO resource_log VALUES (38, 30, 2, NULL, '2013-11-24 10:58:47.40587');
INSERT INTO resource_log VALUES (39, 30, 2, NULL, '2013-11-24 11:00:56.130675');
INSERT INTO resource_log VALUES (40, 30, 2, NULL, '2013-11-24 11:01:17.637578');
INSERT INTO resource_log VALUES (41, 30, 2, NULL, '2013-11-24 11:01:20.639413');
INSERT INTO resource_log VALUES (42, 30, 2, NULL, '2013-11-24 11:01:25.957588');
INSERT INTO resource_log VALUES (43, 30, 2, NULL, '2013-11-24 11:01:28.015301');
INSERT INTO resource_log VALUES (44, 30, 2, NULL, '2013-11-24 11:01:49.505153');
INSERT INTO resource_log VALUES (45, 30, 2, NULL, '2013-11-24 11:01:54.465064');
INSERT INTO resource_log VALUES (46, 30, 2, NULL, '2013-11-24 11:01:56.828797');
INSERT INTO resource_log VALUES (47, 30, 2, NULL, '2013-11-24 11:02:00.873006');
INSERT INTO resource_log VALUES (48, 30, 2, NULL, '2013-11-24 11:02:06.385907');
INSERT INTO resource_log VALUES (49, 30, 2, NULL, '2013-11-24 11:02:08.474309');
INSERT INTO resource_log VALUES (50, 30, 2, NULL, '2013-11-24 11:02:11.823259');
INSERT INTO resource_log VALUES (51, 30, 2, NULL, '2013-11-24 11:02:15.084044');
INSERT INTO resource_log VALUES (52, 30, 2, NULL, '2013-11-24 11:23:59.150304');
INSERT INTO resource_log VALUES (53, 30, 2, NULL, '2013-11-24 12:41:22.004561');
INSERT INTO resource_log VALUES (54, 30, 2, NULL, '2013-11-24 12:41:27.704243');
INSERT INTO resource_log VALUES (55, 30, 2, NULL, '2013-11-24 12:41:32.588516');
INSERT INTO resource_log VALUES (5430, 1207, 2, NULL, '2014-04-09 20:43:13.852066');
INSERT INTO resource_log VALUES (5459, 1227, 2, NULL, '2014-04-19 13:04:24.512333');
INSERT INTO resource_log VALUES (5467, 1230, 2, NULL, '2014-04-23 11:53:28.979784');
INSERT INTO resource_log VALUES (5468, 1230, 2, NULL, '2014-04-23 11:53:45.572462');
INSERT INTO resource_log VALUES (5537, 1306, 2, NULL, '2014-04-30 11:04:50.581045');
INSERT INTO resource_log VALUES (66, 16, 2, NULL, '2013-11-30 12:57:27.26941');
INSERT INTO resource_log VALUES (67, 31, 2, NULL, '2013-11-30 14:25:42.040654');
INSERT INTO resource_log VALUES (68, 32, 2, NULL, '2013-11-30 14:27:55.708736');
INSERT INTO resource_log VALUES (69, 33, 2, NULL, '2013-11-30 14:28:30.596329');
INSERT INTO resource_log VALUES (70, 34, 2, NULL, '2013-11-30 14:29:07.205192');
INSERT INTO resource_log VALUES (71, 35, 2, NULL, '2013-11-30 14:30:10.653134');
INSERT INTO resource_log VALUES (72, 36, 2, NULL, '2013-11-30 14:31:39.751221');
INSERT INTO resource_log VALUES (73, 37, 2, NULL, '2013-11-30 14:32:36.035677');
INSERT INTO resource_log VALUES (74, 38, 2, NULL, '2013-11-30 14:55:27.691288');
INSERT INTO resource_log VALUES (75, 39, 2, NULL, '2013-11-30 14:58:07.249714');
INSERT INTO resource_log VALUES (76, 40, 2, NULL, '2013-11-30 14:58:34.364695');
INSERT INTO resource_log VALUES (79, 43, 2, NULL, '2013-11-30 15:08:29.574538');
INSERT INTO resource_log VALUES (80, 43, 2, NULL, '2013-11-30 15:08:52.114395');
INSERT INTO resource_log VALUES (81, 43, 2, NULL, '2013-11-30 15:09:21.51485');
INSERT INTO resource_log VALUES (82, 44, 2, NULL, '2013-11-30 15:09:54.961188');
INSERT INTO resource_log VALUES (83, 45, 2, NULL, '2013-12-01 13:04:27.697583');
INSERT INTO resource_log VALUES (84, 45, 2, NULL, '2013-12-01 13:04:40.716328');
INSERT INTO resource_log VALUES (85, 14, 2, NULL, '2013-12-01 14:31:19.374571');
INSERT INTO resource_log VALUES (87, 12, 2, NULL, '2013-12-01 18:21:35.266219');
INSERT INTO resource_log VALUES (104, 10, 2, NULL, '2013-12-02 20:43:38.334769');
INSERT INTO resource_log VALUES (130, 10, 2, NULL, '2013-12-06 21:10:25.807719');
INSERT INTO resource_log VALUES (4796, 769, 2, NULL, '2014-01-22 22:21:45.451623');
INSERT INTO resource_log VALUES (4820, 16, 2, NULL, '2014-02-01 21:09:43.821944');
INSERT INTO resource_log VALUES (5408, 1192, 2, NULL, '2014-04-06 19:22:16.361504');
INSERT INTO resource_log VALUES (5409, 1005, 2, NULL, '2014-04-06 19:22:18.74271');
INSERT INTO resource_log VALUES (4822, 784, 2, NULL, '2014-02-01 21:23:07.460721');
INSERT INTO resource_log VALUES (4823, 786, 2, NULL, '2014-02-01 21:23:12.871915');
INSERT INTO resource_log VALUES (5410, 1193, 2, NULL, '2014-04-06 19:30:25.125445');
INSERT INTO resource_log VALUES (5411, 1194, 2, NULL, '2014-04-06 19:30:51.85642');
INSERT INTO resource_log VALUES (5412, 1195, 2, NULL, '2014-04-06 19:32:30.207073');
INSERT INTO resource_log VALUES (5428, 1205, 2, NULL, '2014-04-09 19:17:37.483997');
INSERT INTO resource_log VALUES (5431, 1209, 2, NULL, '2014-04-09 20:49:45.884539');
INSERT INTO resource_log VALUES (4843, 800, 2, NULL, '2014-02-05 19:58:31.619612');
INSERT INTO resource_log VALUES (4844, 801, 2, NULL, '2014-02-05 19:58:49.632624');
INSERT INTO resource_log VALUES (4951, 885, 2, NULL, '2014-02-14 21:23:40.101298');
INSERT INTO resource_log VALUES (4952, 885, 2, NULL, '2014-02-14 21:25:13.866935');
INSERT INTO resource_log VALUES (4974, 849, 2, NULL, '2014-02-23 22:41:46.113064');
INSERT INTO resource_log VALUES (4977, 884, 2, NULL, '2014-02-23 22:42:22.595852');
INSERT INTO resource_log VALUES (5143, 1003, 2, NULL, '2014-03-04 21:05:09.565466');
INSERT INTO resource_log VALUES (5144, 1004, 2, NULL, '2014-03-04 21:08:53.227171');
INSERT INTO resource_log VALUES (5145, 1005, 2, NULL, '2014-03-04 21:09:15.542733');
INSERT INTO resource_log VALUES (5471, 1240, 2, NULL, '2014-04-26 13:10:19.27836');
INSERT INTO resource_log VALUES (5538, 1307, 2, NULL, '2014-04-30 11:08:33.655971');
INSERT INTO resource_log VALUES (5544, 1313, 2, NULL, '2014-05-16 22:03:29.897662');
INSERT INTO resource_log VALUES (361, 274, 2, NULL, '2013-12-14 17:16:08.962259');
INSERT INTO resource_log VALUES (365, 277, 2, NULL, '2013-12-14 18:56:05.189747');
INSERT INTO resource_log VALUES (366, 278, 2, NULL, '2013-12-14 18:56:17.77025');
INSERT INTO resource_log VALUES (367, 279, 2, NULL, '2013-12-14 18:56:45.919492');
INSERT INTO resource_log VALUES (368, 280, 2, NULL, '2013-12-14 19:10:07.617582');
INSERT INTO resource_log VALUES (369, 281, 2, NULL, '2013-12-14 19:10:25.311427');
INSERT INTO resource_log VALUES (370, 281, 2, NULL, '2013-12-14 19:10:59.35028');
INSERT INTO resource_log VALUES (371, 281, 2, NULL, '2013-12-14 19:12:14.211139');
INSERT INTO resource_log VALUES (372, 282, 2, NULL, '2013-12-14 19:14:22.861495');
INSERT INTO resource_log VALUES (373, 278, 2, NULL, '2013-12-14 19:14:33.853691');
INSERT INTO resource_log VALUES (374, 282, 2, NULL, '2013-12-14 19:14:41.964012');
INSERT INTO resource_log VALUES (375, 283, 2, NULL, '2013-12-14 19:16:35.738242');
INSERT INTO resource_log VALUES (4882, 706, 2, NULL, '2014-02-08 19:59:59.160282');
INSERT INTO resource_log VALUES (377, 283, 2, NULL, '2013-12-14 19:18:21.622933');
INSERT INTO resource_log VALUES (4953, 886, 2, NULL, '2014-02-14 21:25:53.089098');
INSERT INTO resource_log VALUES (4978, 893, 2, NULL, '2014-02-24 11:11:03.613711');
INSERT INTO resource_log VALUES (5147, 1004, 2, NULL, '2014-03-04 21:17:22.306545');
INSERT INTO resource_log VALUES (5148, 1004, 2, NULL, '2014-03-04 21:23:04.343461');
INSERT INTO resource_log VALUES (386, 286, 2, NULL, '2013-12-14 20:46:34.653533');
INSERT INTO resource_log VALUES (387, 287, 2, NULL, '2013-12-14 20:46:47.37835');
INSERT INTO resource_log VALUES (388, 288, 2, NULL, '2013-12-14 20:47:08.024243');
INSERT INTO resource_log VALUES (389, 289, 2, NULL, '2013-12-14 20:47:28.256516');
INSERT INTO resource_log VALUES (390, 290, 2, NULL, '2013-12-14 20:52:40.953492');
INSERT INTO resource_log VALUES (391, 291, 2, NULL, '2013-12-14 20:53:08.057165');
INSERT INTO resource_log VALUES (392, 292, 2, NULL, '2013-12-14 20:53:33.598708');
INSERT INTO resource_log VALUES (5149, 1004, 2, NULL, '2014-03-04 21:23:17.093243');
INSERT INTO resource_log VALUES (5150, 1004, 2, NULL, '2014-03-04 21:23:25.611509');
INSERT INTO resource_log VALUES (4799, 771, 2, NULL, '2014-01-25 16:05:28.799345');
INSERT INTO resource_log VALUES (4800, 771, 2, NULL, '2014-01-25 16:05:38.705799');
INSERT INTO resource_log VALUES (4801, 772, 2, NULL, '2014-01-25 16:06:28.321244');
INSERT INTO resource_log VALUES (4826, 788, 2, NULL, '2014-02-01 22:03:21.899916');
INSERT INTO resource_log VALUES (5151, 1004, 2, NULL, '2014-03-04 21:23:52.466966');
INSERT INTO resource_log VALUES (5152, 1004, 2, NULL, '2014-03-04 21:24:11.351815');
INSERT INTO resource_log VALUES (5153, 1004, 2, NULL, '2014-03-04 21:24:20.614224');
INSERT INTO resource_log VALUES (5429, 1206, 2, NULL, '2014-04-09 19:21:09.215561');
INSERT INTO resource_log VALUES (5154, 1004, 2, NULL, '2014-03-04 21:35:47.600889');
INSERT INTO resource_log VALUES (5155, 1004, 2, NULL, '2014-03-04 21:36:05.835492');
INSERT INTO resource_log VALUES (5156, 1004, 2, NULL, '2014-03-04 21:36:16.322673');
INSERT INTO resource_log VALUES (5432, 1210, 2, NULL, '2014-04-12 13:10:08.842351');
INSERT INTO resource_log VALUES (5472, 1241, 2, NULL, '2014-04-26 19:16:28.009797');
INSERT INTO resource_log VALUES (5539, 1308, 2, NULL, '2014-04-30 11:20:34.938154');
INSERT INTO resource_log VALUES (5545, 1314, 2, NULL, '2014-05-17 13:42:16.369317');
INSERT INTO resource_log VALUES (422, 306, 2, NULL, '2013-12-15 21:45:32.990838');
INSERT INTO resource_log VALUES (4802, 773, 2, NULL, '2014-01-25 23:45:37.762081');
INSERT INTO resource_log VALUES (4827, 789, 2, NULL, '2014-02-02 16:45:11.830435');
INSERT INTO resource_log VALUES (4954, 887, 2, NULL, '2014-02-15 12:32:09.199652');
INSERT INTO resource_log VALUES (5415, 1198, 2, NULL, '2014-04-08 09:35:59.21042');
INSERT INTO resource_log VALUES (4979, 885, 2, NULL, '2014-02-24 12:50:26.694026');
INSERT INTO resource_log VALUES (4980, 786, 2, NULL, '2014-02-24 12:50:29.953348');
INSERT INTO resource_log VALUES (4981, 784, 2, NULL, '2014-02-24 12:50:33.322359');
INSERT INTO resource_log VALUES (5157, 1004, 2, NULL, '2014-03-07 22:30:15.652582');
INSERT INTO resource_log VALUES (5230, 894, 2, NULL, '2014-03-16 11:54:19.683752');
INSERT INTO resource_log VALUES (5231, 894, 2, NULL, '2014-03-16 11:54:28.171778');
INSERT INTO resource_log VALUES (5232, 894, 2, NULL, '2014-03-16 11:54:33.774318');
INSERT INTO resource_log VALUES (5270, 1004, 2, NULL, '2014-03-17 10:50:39.781432');
INSERT INTO resource_log VALUES (5465, 1230, 2, NULL, '2014-04-19 21:03:03.225866');
INSERT INTO resource_log VALUES (5508, 1277, 2, NULL, '2014-04-29 10:08:17.485661');
INSERT INTO resource_log VALUES (5509, 1278, 2, NULL, '2014-04-29 10:09:19.421905');
INSERT INTO resource_log VALUES (5540, 1309, 2, NULL, '2014-04-30 11:32:51.070911');
INSERT INTO resource_log VALUES (5547, 1316, 2, NULL, '2014-05-17 14:00:25.111543');
INSERT INTO resource_log VALUES (4927, 865, 2, NULL, '2014-02-09 13:26:19.008763');
INSERT INTO resource_log VALUES (4804, 775, 2, NULL, '2014-01-26 15:30:50.636495');
INSERT INTO resource_log VALUES (4828, 3, 2, NULL, '2014-02-02 17:45:50.239397');
INSERT INTO resource_log VALUES (5416, 1199, 2, NULL, '2014-04-08 10:15:32.411146');
INSERT INTO resource_log VALUES (5434, 1211, 2, NULL, '2014-04-12 14:16:34.33498');
INSERT INTO resource_log VALUES (5435, 1211, 2, NULL, '2014-04-12 14:16:53.40729');
INSERT INTO resource_log VALUES (4982, 895, 2, NULL, '2014-02-25 19:06:42.158245');
INSERT INTO resource_log VALUES (5158, 1007, 2, NULL, '2014-03-08 10:30:25.61786');
INSERT INTO resource_log VALUES (5198, 3, 2, NULL, '2014-03-11 13:14:05.142514');
INSERT INTO resource_log VALUES (5233, 1060, 2, NULL, '2014-03-16 12:26:38.52955');
INSERT INTO resource_log VALUES (5437, 1213, 2, NULL, '2014-04-12 14:32:08.840037');
INSERT INTO resource_log VALUES (5466, 1227, 2, NULL, '2014-04-19 21:37:55.580038');
INSERT INTO resource_log VALUES (5474, 1243, 2, NULL, '2014-04-26 22:38:44.326007');
INSERT INTO resource_log VALUES (5541, 1310, 2, NULL, '2014-04-30 22:45:27.579715');
INSERT INTO resource_log VALUES (5548, 1317, 2, NULL, '2014-05-17 14:54:57.813145');
INSERT INTO resource_log VALUES (5549, 1318, 2, NULL, '2014-05-17 15:24:32.954365');
INSERT INTO resource_log VALUES (5550, 1319, 2, NULL, '2014-05-17 15:53:28.880817');
INSERT INTO resource_log VALUES (5551, 1320, 2, NULL, '2014-05-17 15:53:34.139717');
INSERT INTO resource_log VALUES (5552, 1321, 2, NULL, '2014-05-17 15:55:03.155317');
INSERT INTO resource_log VALUES (5553, 1322, 2, NULL, '2014-05-17 15:55:07.534203');
INSERT INTO resource_log VALUES (5557, 1326, 2, NULL, '2014-05-17 15:59:13.891973');
INSERT INTO resource_log VALUES (5558, 1327, 2, NULL, '2014-05-17 15:59:17.045556');
INSERT INTO resource_log VALUES (5559, 1328, 2, NULL, '2014-05-17 16:00:04.660539');
INSERT INTO resource_log VALUES (5560, 1329, 2, NULL, '2014-05-17 16:00:08.901641');
INSERT INTO resource_log VALUES (5561, 1330, 2, NULL, '2014-05-17 16:00:10.337355');
INSERT INTO resource_log VALUES (5566, 1335, 2, NULL, '2014-05-17 16:02:19.447311');
INSERT INTO resource_log VALUES (5570, 1339, 2, NULL, '2014-05-17 16:06:26.675372');
INSERT INTO resource_log VALUES (5571, 1340, 2, NULL, '2014-05-17 16:06:28.503991');
INSERT INTO resource_log VALUES (5572, 1341, 2, NULL, '2014-05-17 16:06:29.727144');
INSERT INTO resource_log VALUES (5573, 1342, 2, NULL, '2014-05-17 16:06:31.81672');
INSERT INTO resource_log VALUES (5574, 1343, 2, NULL, '2014-05-17 16:07:44.265465');
INSERT INTO resource_log VALUES (5575, 1344, 2, NULL, '2014-05-17 16:07:45.972655');
INSERT INTO resource_log VALUES (5576, 1345, 2, NULL, '2014-05-17 16:07:47.259172');
INSERT INTO resource_log VALUES (5577, 1346, 2, NULL, '2014-05-17 16:07:49.146563');
INSERT INTO resource_log VALUES (5581, 1350, 2, NULL, '2014-05-17 16:09:55.923893');
INSERT INTO resource_log VALUES (5582, 1351, 2, NULL, '2014-05-17 16:13:13.017272');
INSERT INTO resource_log VALUES (5583, 1352, 2, NULL, '2014-05-17 16:13:14.609527');
INSERT INTO resource_log VALUES (5584, 1353, 2, NULL, '2014-05-17 16:13:16.568079');
INSERT INTO resource_log VALUES (5585, 1354, 2, NULL, '2014-05-17 16:13:17.732756');
INSERT INTO resource_log VALUES (5370, 1159, 2, NULL, '2014-04-02 19:52:15.193771');
INSERT INTO resource_log VALUES (4888, 786, 2, NULL, '2014-02-08 21:26:45.138217');
INSERT INTO resource_log VALUES (5417, 1200, 2, NULL, '2014-04-08 10:35:59.014802');
INSERT INTO resource_log VALUES (4890, 784, 2, NULL, '2014-02-08 21:26:51.98617');
INSERT INTO resource_log VALUES (4929, 870, 2, NULL, '2014-02-09 14:57:54.403714');
INSERT INTO resource_log VALUES (4967, 892, 2, NULL, '2014-02-22 17:14:02.512772');
INSERT INTO resource_log VALUES (4983, 896, 2, NULL, '2014-02-25 19:37:56.226615');
INSERT INTO resource_log VALUES (4984, 897, 2, NULL, '2014-02-25 19:38:21.395798');
INSERT INTO resource_log VALUES (4985, 898, 2, NULL, '2014-02-25 19:38:30.353048');
INSERT INTO resource_log VALUES (4986, 899, 2, NULL, '2014-02-25 19:39:23.588225');
INSERT INTO resource_log VALUES (4988, 901, 2, NULL, '2014-02-25 19:47:57.884012');
INSERT INTO resource_log VALUES (5160, 1009, 2, NULL, '2014-03-08 10:49:52.0599');
INSERT INTO resource_log VALUES (5199, 3, 2, NULL, '2014-03-12 12:05:31.953558');
INSERT INTO resource_log VALUES (5438, 1214, 2, NULL, '2014-04-12 14:36:07.046988');
INSERT INTO resource_log VALUES (5475, 1244, 2, NULL, '2014-04-26 22:39:00.40778');
INSERT INTO resource_log VALUES (5542, 1311, 2, NULL, '2014-04-30 22:45:36.089534');
INSERT INTO resource_log VALUES (5554, 1323, 2, NULL, '2014-05-17 15:55:54.008685');
INSERT INTO resource_log VALUES (5555, 1324, 2, NULL, '2014-05-17 15:56:55.63522');
INSERT INTO resource_log VALUES (5556, 1325, 2, NULL, '2014-05-17 15:58:29.508912');
INSERT INTO resource_log VALUES (5562, 1331, 2, NULL, '2014-05-17 16:00:49.21287');
INSERT INTO resource_log VALUES (5563, 1332, 2, NULL, '2014-05-17 16:01:46.175183');
INSERT INTO resource_log VALUES (5564, 1333, 2, NULL, '2014-05-17 16:01:47.950656');
INSERT INTO resource_log VALUES (5565, 1334, 2, NULL, '2014-05-17 16:01:48.837764');
INSERT INTO resource_log VALUES (5567, 1336, 2, NULL, '2014-05-17 16:03:41.796945');
INSERT INTO resource_log VALUES (5568, 1337, 2, NULL, '2014-05-17 16:04:32.839289');
INSERT INTO resource_log VALUES (5569, 1338, 2, NULL, '2014-05-17 16:04:34.363533');
INSERT INTO resource_log VALUES (5578, 1347, 2, NULL, '2014-05-17 16:08:39.18466');
INSERT INTO resource_log VALUES (5579, 1348, 2, NULL, '2014-05-17 16:08:56.863828');
INSERT INTO resource_log VALUES (5580, 1349, 2, NULL, '2014-05-17 16:08:58.291349');
INSERT INTO resource_log VALUES (4894, 849, 2, NULL, '2014-02-08 21:32:14.802948');
INSERT INTO resource_log VALUES (4896, 851, 2, NULL, '2014-02-08 21:32:32.471247');
INSERT INTO resource_log VALUES (4897, 852, 2, NULL, '2014-02-08 21:36:44.493917');
INSERT INTO resource_log VALUES (4930, 871, 2, NULL, '2014-02-09 16:04:05.85568');
INSERT INTO resource_log VALUES (4968, 892, 2, NULL, '2014-02-22 17:18:17.771894');
INSERT INTO resource_log VALUES (5161, 1009, 2, NULL, '2014-03-08 10:52:32.854366');
INSERT INTO resource_log VALUES (5162, 1009, 2, NULL, '2014-03-08 10:52:45.635015');
INSERT INTO resource_log VALUES (5163, 1009, 2, NULL, '2014-03-08 10:52:53.515357');
INSERT INTO resource_log VALUES (5164, 1009, 2, NULL, '2014-03-08 10:52:58.740536');
INSERT INTO resource_log VALUES (5165, 1010, 2, NULL, '2014-03-08 10:54:40.946487');
INSERT INTO resource_log VALUES (5166, 1010, 2, NULL, '2014-03-08 10:54:50.928085');
INSERT INTO resource_log VALUES (5200, 3, 2, NULL, '2014-03-12 12:14:05.203771');
INSERT INTO resource_log VALUES (5235, 897, 2, NULL, '2014-03-16 12:53:37.56753');
INSERT INTO resource_log VALUES (5278, 1067, 2, NULL, '2014-03-18 19:51:01.87448');
INSERT INTO resource_log VALUES (5375, 1164, 2, NULL, '2014-04-02 20:56:42.084197');
INSERT INTO resource_log VALUES (5376, 1165, 2, NULL, '2014-04-02 20:56:48.393173');
INSERT INTO resource_log VALUES (5419, 1201, 2, NULL, '2014-04-08 10:38:31.154572');
INSERT INTO resource_log VALUES (5440, 1214, 2, NULL, '2014-04-12 14:39:05.532456');
INSERT INTO resource_log VALUES (5442, 1214, 2, NULL, '2014-04-12 14:43:11.754556');
INSERT INTO resource_log VALUES (5513, 1282, 2, NULL, '2014-04-29 10:43:05.718429');
INSERT INTO resource_log VALUES (5586, 1355, 2, NULL, '2014-05-17 16:14:39.7443');
INSERT INTO resource_log VALUES (5587, 1356, 2, NULL, '2014-05-17 16:14:41.182697');
INSERT INTO resource_log VALUES (5588, 1357, 2, NULL, '2014-05-17 16:14:43.239633');
INSERT INTO resource_log VALUES (5590, 1359, 2, NULL, '2014-05-17 16:15:43.442935');
INSERT INTO resource_log VALUES (5591, 1360, 2, NULL, '2014-05-17 16:15:45.790483');
INSERT INTO resource_log VALUES (5596, 1365, 2, NULL, '2014-05-17 16:20:21.389915');
INSERT INTO resource_log VALUES (5597, 1366, 2, NULL, '2014-05-17 16:20:22.473385');
INSERT INTO resource_log VALUES (5598, 1367, 2, NULL, '2014-05-17 16:20:23.843632');
INSERT INTO resource_log VALUES (4898, 853, 2, NULL, '2014-02-08 21:39:09.10029');
INSERT INTO resource_log VALUES (4812, 784, 2, NULL, '2014-01-26 21:12:24.209136');
INSERT INTO resource_log VALUES (4813, 784, 2, NULL, '2014-01-26 21:13:10.546575');
INSERT INTO resource_log VALUES (4814, 784, 2, NULL, '2014-01-26 21:13:20.058093');
INSERT INTO resource_log VALUES (4815, 784, 2, NULL, '2014-01-26 21:13:24.693933');
INSERT INTO resource_log VALUES (4817, 786, 2, NULL, '2014-01-26 21:15:00.370561');
INSERT INTO resource_log VALUES (4818, 784, 2, NULL, '2014-01-26 21:20:14.635984');
INSERT INTO resource_log VALUES (4819, 784, 2, NULL, '2014-01-26 21:20:34.941868');
INSERT INTO resource_log VALUES (4931, 274, 2, NULL, '2014-02-10 08:49:31.501202');
INSERT INTO resource_log VALUES (4969, 893, 2, NULL, '2014-02-22 17:26:37.296722');
INSERT INTO resource_log VALUES (4970, 894, 2, NULL, '2014-02-22 17:27:40.771678');
INSERT INTO resource_log VALUES (4991, 903, 2, NULL, '2014-02-25 22:43:46.101171');
INSERT INTO resource_log VALUES (4992, 904, 2, NULL, '2014-02-25 22:43:53.30222');
INSERT INTO resource_log VALUES (4993, 905, 2, NULL, '2014-02-25 22:44:00.024066');
INSERT INTO resource_log VALUES (4994, 906, 2, NULL, '2014-02-25 22:44:13.035203');
INSERT INTO resource_log VALUES (4995, 907, 2, NULL, '2014-02-25 22:44:59.159297');
INSERT INTO resource_log VALUES (5167, 1009, 2, NULL, '2014-03-08 10:57:02.535973');
INSERT INTO resource_log VALUES (5168, 1010, 2, NULL, '2014-03-08 10:57:07.365849');
INSERT INTO resource_log VALUES (5201, 3, 2, NULL, '2014-03-12 12:29:57.686858');
INSERT INTO resource_log VALUES (5202, 3, 2, NULL, '2014-03-12 12:30:07.270368');
INSERT INTO resource_log VALUES (5203, 3, 2, NULL, '2014-03-12 12:30:09.982217');
INSERT INTO resource_log VALUES (5204, 3, 2, NULL, '2014-03-12 12:32:22.25189');
INSERT INTO resource_log VALUES (5205, 894, 2, NULL, '2014-03-12 12:32:26.366205');
INSERT INTO resource_log VALUES (5236, 919, 2, NULL, '2014-03-16 13:33:07.651832');
INSERT INTO resource_log VALUES (5444, 1218, 2, NULL, '2014-04-12 15:00:38.646853');
INSERT INTO resource_log VALUES (5447, 1214, 2, NULL, '2014-04-12 15:02:33.59771');
INSERT INTO resource_log VALUES (5514, 1283, 2, NULL, '2014-04-29 12:06:08.689068');
INSERT INTO resource_log VALUES (5515, 1284, 2, NULL, '2014-04-29 12:07:06.357367');
INSERT INTO resource_log VALUES (5518, 1287, 2, NULL, '2014-04-29 12:09:55.486785');
INSERT INTO resource_log VALUES (5520, 1289, 2, NULL, '2014-04-29 12:11:36.874588');
INSERT INTO resource_log VALUES (5589, 1358, 2, NULL, '2014-05-17 16:15:09.836615');
INSERT INTO resource_log VALUES (5592, 1361, 2, NULL, '2014-05-17 16:16:33.155307');
INSERT INTO resource_log VALUES (5593, 1362, 2, NULL, '2014-05-17 16:16:42.585648');
INSERT INTO resource_log VALUES (5594, 1363, 2, NULL, '2014-05-17 16:18:45.312153');
INSERT INTO resource_log VALUES (5595, 1364, 2, NULL, '2014-05-17 16:18:46.752544');
INSERT INTO resource_log VALUES (4932, 872, 2, NULL, '2014-02-10 14:29:53.759164');
INSERT INTO resource_log VALUES (4996, 908, 2, NULL, '2014-02-25 23:15:44.304324');
INSERT INTO resource_log VALUES (4997, 909, 2, NULL, '2014-02-25 23:16:53.455486');
INSERT INTO resource_log VALUES (5000, 912, 2, NULL, '2014-02-25 23:21:05.038132');
INSERT INTO resource_log VALUES (5001, 913, 2, NULL, '2014-02-25 23:21:10.720503');
INSERT INTO resource_log VALUES (5002, 914, 2, NULL, '2014-02-25 23:21:15.803027');
INSERT INTO resource_log VALUES (5003, 915, 2, NULL, '2014-02-25 23:21:21.245593');
INSERT INTO resource_log VALUES (5004, 916, 2, NULL, '2014-02-25 23:21:27.843749');
INSERT INTO resource_log VALUES (5005, 917, 2, NULL, '2014-02-25 23:21:40.705852');
INSERT INTO resource_log VALUES (5006, 918, 2, NULL, '2014-02-25 23:21:45.161533');
INSERT INTO resource_log VALUES (5007, 918, 2, NULL, '2014-02-25 23:21:53.74917');
INSERT INTO resource_log VALUES (5008, 918, 2, NULL, '2014-02-25 23:21:57.599668');
INSERT INTO resource_log VALUES (5009, 919, 2, NULL, '2014-02-25 23:22:22.789803');
INSERT INTO resource_log VALUES (5011, 921, 2, NULL, '2014-02-25 23:22:59.534922');
INSERT INTO resource_log VALUES (5012, 922, 2, NULL, '2014-02-25 23:23:04.765473');
INSERT INTO resource_log VALUES (5013, 923, 2, NULL, '2014-02-25 23:23:16.649188');
INSERT INTO resource_log VALUES (5014, 924, 2, NULL, '2014-02-25 23:23:30.151925');
INSERT INTO resource_log VALUES (5015, 925, 2, NULL, '2014-02-25 23:25:11.120354');
INSERT INTO resource_log VALUES (5016, 926, 2, NULL, '2014-02-25 23:26:11.314153');
INSERT INTO resource_log VALUES (5017, 927, 2, NULL, '2014-02-25 23:26:34.378644');
INSERT INTO resource_log VALUES (5018, 928, 2, NULL, '2014-02-25 23:26:49.163639');
INSERT INTO resource_log VALUES (5019, 929, 2, NULL, '2014-02-25 23:27:07.84413');
INSERT INTO resource_log VALUES (5020, 930, 2, NULL, '2014-02-25 23:27:30.797684');
INSERT INTO resource_log VALUES (5021, 931, 2, NULL, '2014-02-25 23:27:45.611037');
INSERT INTO resource_log VALUES (5022, 932, 2, NULL, '2014-02-25 23:28:05.678992');
INSERT INTO resource_log VALUES (5023, 933, 2, NULL, '2014-02-25 23:28:21.001129');
INSERT INTO resource_log VALUES (5025, 935, 2, NULL, '2014-02-25 23:28:49.565248');
INSERT INTO resource_log VALUES (5026, 936, 2, NULL, '2014-02-25 23:29:05.034117');
INSERT INTO resource_log VALUES (5027, 937, 2, NULL, '2014-02-25 23:29:16.11101');
INSERT INTO resource_log VALUES (5028, 938, 2, NULL, '2014-02-25 23:29:28.82178');
INSERT INTO resource_log VALUES (5029, 939, 2, NULL, '2014-02-25 23:29:41.159219');
INSERT INTO resource_log VALUES (5030, 940, 2, NULL, '2014-02-25 23:29:57.589154');
INSERT INTO resource_log VALUES (5031, 941, 2, NULL, '2014-02-25 23:30:12.260571');
INSERT INTO resource_log VALUES (5032, 942, 2, NULL, '2014-02-25 23:30:25.705958');
INSERT INTO resource_log VALUES (5033, 943, 2, NULL, '2014-02-25 23:30:39.278491');
INSERT INTO resource_log VALUES (5034, 944, 2, NULL, '2014-02-25 23:30:54.230938');
INSERT INTO resource_log VALUES (5035, 945, 2, NULL, '2014-02-25 23:31:08.136642');
INSERT INTO resource_log VALUES (5036, 946, 2, NULL, '2014-02-25 23:31:21.084682');
INSERT INTO resource_log VALUES (5037, 947, 2, NULL, '2014-02-25 23:31:35.443235');
INSERT INTO resource_log VALUES (5038, 948, 2, NULL, '2014-02-25 23:31:50.036032');
INSERT INTO resource_log VALUES (5039, 949, 2, NULL, '2014-02-25 23:32:16.232207');
INSERT INTO resource_log VALUES (5040, 950, 2, NULL, '2014-02-25 23:32:51.784126');
INSERT INTO resource_log VALUES (5169, 1011, 2, NULL, '2014-03-08 15:10:44.638516');
INSERT INTO resource_log VALUES (5206, 3, 2, NULL, '2014-03-12 13:00:24.217557');
INSERT INTO resource_log VALUES (5207, 3, 2, NULL, '2014-03-12 13:00:34.025605');
INSERT INTO resource_log VALUES (5238, 1062, 2, NULL, '2014-03-16 15:10:44.294343');
INSERT INTO resource_log VALUES (5239, 1062, 2, NULL, '2014-03-16 15:11:01.269428');
INSERT INTO resource_log VALUES (5240, 858, 2, NULL, '2014-03-16 15:11:06.875279');
INSERT INTO resource_log VALUES (5241, 903, 2, NULL, '2014-03-16 15:12:25.130202');
INSERT INTO resource_log VALUES (5379, 1168, 2, NULL, '2014-04-03 12:39:52.988369');
INSERT INTO resource_log VALUES (5380, 1169, 2, NULL, '2014-04-03 12:49:06.139328');
INSERT INTO resource_log VALUES (5448, 1221, 2, NULL, '2014-04-12 16:44:14.810824');
INSERT INTO resource_log VALUES (5516, 1285, 2, NULL, '2014-04-29 12:08:23.116251');
INSERT INTO resource_log VALUES (5517, 1286, 2, NULL, '2014-04-29 12:09:10.712444');
INSERT INTO resource_log VALUES (5522, 1291, 2, NULL, '2014-04-29 12:13:37.203069');
INSERT INTO resource_log VALUES (5523, 1292, 2, NULL, '2014-04-29 12:14:34.180203');
INSERT INTO resource_log VALUES (4900, 854, 2, NULL, '2014-02-08 21:47:34.439997');
INSERT INTO resource_log VALUES (4901, 855, 2, NULL, '2014-02-08 21:54:55.399628');
INSERT INTO resource_log VALUES (4936, 875, 2, NULL, '2014-02-10 15:58:53.177719');
INSERT INTO resource_log VALUES (4937, 875, 2, NULL, '2014-02-10 15:59:03.43204');
INSERT INTO resource_log VALUES (5042, 952, 2, NULL, '2014-02-25 23:33:14.57009');
INSERT INTO resource_log VALUES (5043, 939, 2, NULL, '2014-02-25 23:33:37.281163');
INSERT INTO resource_log VALUES (5044, 938, 2, NULL, '2014-02-25 23:33:44.033176');
INSERT INTO resource_log VALUES (5045, 937, 2, NULL, '2014-02-25 23:33:51.697991');
INSERT INTO resource_log VALUES (5046, 936, 2, NULL, '2014-02-25 23:33:56.981908');
INSERT INTO resource_log VALUES (5047, 935, 2, NULL, '2014-02-25 23:34:03.037741');
INSERT INTO resource_log VALUES (5049, 933, 2, NULL, '2014-02-25 23:34:27.937885');
INSERT INTO resource_log VALUES (5050, 932, 2, NULL, '2014-02-25 23:34:34.767736');
INSERT INTO resource_log VALUES (5051, 931, 2, NULL, '2014-02-25 23:34:39.075165');
INSERT INTO resource_log VALUES (5052, 930, 2, NULL, '2014-02-25 23:34:43.896812');
INSERT INTO resource_log VALUES (5053, 929, 2, NULL, '2014-02-25 23:34:48.70472');
INSERT INTO resource_log VALUES (5054, 928, 2, NULL, '2014-02-25 23:34:54.494127');
INSERT INTO resource_log VALUES (5055, 927, 2, NULL, '2014-02-25 23:35:00.125101');
INSERT INTO resource_log VALUES (5056, 926, 2, NULL, '2014-02-25 23:35:05.399995');
INSERT INTO resource_log VALUES (5057, 925, 2, NULL, '2014-02-25 23:35:10.409443');
INSERT INTO resource_log VALUES (5058, 924, 2, NULL, '2014-02-25 23:35:16.447517');
INSERT INTO resource_log VALUES (5059, 923, 2, NULL, '2014-02-25 23:35:21.959285');
INSERT INTO resource_log VALUES (5060, 922, 2, NULL, '2014-02-25 23:35:27.383937');
INSERT INTO resource_log VALUES (5061, 921, 2, NULL, '2014-02-25 23:35:31.660307');
INSERT INTO resource_log VALUES (5063, 919, 2, NULL, '2014-02-25 23:35:43.645366');
INSERT INTO resource_log VALUES (5064, 918, 2, NULL, '2014-02-25 23:35:47.480218');
INSERT INTO resource_log VALUES (5065, 917, 2, NULL, '2014-02-25 23:35:52.042922');
INSERT INTO resource_log VALUES (5066, 916, 2, NULL, '2014-02-25 23:35:57.409224');
INSERT INTO resource_log VALUES (5067, 915, 2, NULL, '2014-02-25 23:36:01.802966');
INSERT INTO resource_log VALUES (5068, 914, 2, NULL, '2014-02-25 23:36:05.670476');
INSERT INTO resource_log VALUES (5069, 913, 2, NULL, '2014-02-25 23:36:10.129284');
INSERT INTO resource_log VALUES (5070, 912, 2, NULL, '2014-02-25 23:36:14.468359');
INSERT INTO resource_log VALUES (5208, 1040, 2, NULL, '2014-03-12 20:50:33.871251');
INSERT INTO resource_log VALUES (5209, 1041, 2, NULL, '2014-03-12 20:50:55.466763');
INSERT INTO resource_log VALUES (5210, 1041, 2, NULL, '2014-03-12 20:51:02.123714');
INSERT INTO resource_log VALUES (5211, 1042, 2, NULL, '2014-03-12 20:53:03.003465');
INSERT INTO resource_log VALUES (5212, 1043, 2, NULL, '2014-03-12 20:53:27.910983');
INSERT INTO resource_log VALUES (5213, 1044, 2, NULL, '2014-03-12 20:53:45.921718');
INSERT INTO resource_log VALUES (5214, 1045, 2, NULL, '2014-03-12 20:54:23.054095');
INSERT INTO resource_log VALUES (5215, 1046, 2, NULL, '2014-03-12 20:55:03.071619');
INSERT INTO resource_log VALUES (5286, 1078, 2, NULL, '2014-03-20 21:22:51.030666');
INSERT INTO resource_log VALUES (5381, 1170, 2, NULL, '2014-04-03 12:49:07.793292');
INSERT INTO resource_log VALUES (5519, 1288, 2, NULL, '2014-04-29 12:10:21.572462');
INSERT INTO resource_log VALUES (5521, 1290, 2, NULL, '2014-04-29 12:13:35.434847');
INSERT INTO resource_log VALUES (5603, 1372, 2, NULL, '2014-05-17 18:47:30.594446');
INSERT INTO resource_log VALUES (5606, 1375, 2, NULL, '2014-05-17 18:55:21.896666');
INSERT INTO resource_log VALUES (5613, 1382, 2, NULL, '2014-05-17 19:04:51.767284');
INSERT INTO resource_log VALUES (5619, 1388, 2, NULL, '2014-05-17 19:09:44.578209');
INSERT INTO resource_log VALUES (5622, 1391, 2, NULL, '2014-05-17 19:12:29.996417');
INSERT INTO resource_log VALUES (4902, 856, 2, NULL, '2014-02-08 21:59:04.719245');
INSERT INTO resource_log VALUES (4938, 876, 2, NULL, '2014-02-10 16:19:24.400952');
INSERT INTO resource_log VALUES (5071, 953, 2, NULL, '2014-02-26 23:25:15.548581');
INSERT INTO resource_log VALUES (5072, 954, 2, NULL, '2014-02-26 23:25:55.407709');
INSERT INTO resource_log VALUES (5075, 957, 2, NULL, '2014-02-26 23:28:34.003373');
INSERT INTO resource_log VALUES (5076, 958, 2, NULL, '2014-02-26 23:28:45.594179');
INSERT INTO resource_log VALUES (5077, 959, 2, NULL, '2014-02-26 23:28:57.004231');
INSERT INTO resource_log VALUES (5078, 960, 2, NULL, '2014-02-26 23:29:08.086342');
INSERT INTO resource_log VALUES (5079, 961, 2, NULL, '2014-02-26 23:29:17.646283');
INSERT INTO resource_log VALUES (5080, 962, 2, NULL, '2014-02-26 23:29:26.175631');
INSERT INTO resource_log VALUES (5081, 963, 2, NULL, '2014-02-26 23:29:35.761623');
INSERT INTO resource_log VALUES (5082, 964, 2, NULL, '2014-02-26 23:29:46.892804');
INSERT INTO resource_log VALUES (5083, 965, 2, NULL, '2014-02-26 23:29:54.140342');
INSERT INTO resource_log VALUES (5084, 966, 2, NULL, '2014-02-26 23:30:01.375033');
INSERT INTO resource_log VALUES (5085, 967, 2, NULL, '2014-02-26 23:30:08.774222');
INSERT INTO resource_log VALUES (5086, 968, 2, NULL, '2014-02-26 23:30:17.802323');
INSERT INTO resource_log VALUES (5087, 969, 2, NULL, '2014-02-26 23:30:29.097872');
INSERT INTO resource_log VALUES (5088, 970, 2, NULL, '2014-02-26 23:30:38.081009');
INSERT INTO resource_log VALUES (5089, 971, 2, NULL, '2014-02-26 23:30:52.902609');
INSERT INTO resource_log VALUES (5091, 973, 2, NULL, '2014-02-26 23:31:31.71567');
INSERT INTO resource_log VALUES (5093, 975, 2, NULL, '2014-02-26 23:32:13.646357');
INSERT INTO resource_log VALUES (5094, 976, 2, NULL, '2014-02-26 23:32:24.624636');
INSERT INTO resource_log VALUES (5095, 977, 2, NULL, '2014-02-26 23:32:34.606814');
INSERT INTO resource_log VALUES (5096, 978, 2, NULL, '2014-02-26 23:32:43.318943');
INSERT INTO resource_log VALUES (5097, 979, 2, NULL, '2014-02-26 23:32:54.081989');
INSERT INTO resource_log VALUES (5098, 980, 2, NULL, '2014-02-26 23:33:04.823892');
INSERT INTO resource_log VALUES (5099, 981, 2, NULL, '2014-02-26 23:33:16.574818');
INSERT INTO resource_log VALUES (5100, 982, 2, NULL, '2014-02-26 23:33:28.270884');
INSERT INTO resource_log VALUES (5101, 983, 2, NULL, '2014-02-26 23:33:40.854578');
INSERT INTO resource_log VALUES (5102, 984, 2, NULL, '2014-02-26 23:33:57.05943');
INSERT INTO resource_log VALUES (5103, 985, 2, NULL, '2014-02-26 23:34:08.238483');
INSERT INTO resource_log VALUES (5105, 987, 2, NULL, '2014-02-26 23:34:29.757456');
INSERT INTO resource_log VALUES (5106, 988, 2, NULL, '2014-02-26 23:34:37.99873');
INSERT INTO resource_log VALUES (5216, 3, 2, NULL, '2014-03-12 21:55:10.706584');
INSERT INTO resource_log VALUES (5287, 1079, 2, NULL, '2014-03-22 12:57:07.526655');
INSERT INTO resource_log VALUES (5480, 1249, 2, NULL, '2014-04-27 01:02:16.23036');
INSERT INTO resource_log VALUES (5481, 1250, 2, NULL, '2014-04-27 01:02:43.699513');
INSERT INTO resource_log VALUES (5482, 1251, 2, NULL, '2014-04-27 01:03:00.011092');
INSERT INTO resource_log VALUES (5483, 1252, 2, NULL, '2014-04-27 01:03:22.219667');
INSERT INTO resource_log VALUES (5524, 1293, 2, NULL, '2014-04-29 12:17:51.658135');
INSERT INTO resource_log VALUES (5525, 1294, 2, NULL, '2014-04-29 12:18:27.913053');
INSERT INTO resource_log VALUES (5526, 1295, 2, NULL, '2014-04-29 12:19:08.236252');
INSERT INTO resource_log VALUES (5601, 1370, 2, NULL, '2014-05-17 18:45:54.451262');
INSERT INTO resource_log VALUES (5602, 1371, 2, NULL, '2014-05-17 18:47:17.628356');
INSERT INTO resource_log VALUES (5604, 1373, 2, NULL, '2014-05-17 18:54:01.477094');
INSERT INTO resource_log VALUES (5607, 1376, 2, NULL, '2014-05-17 18:56:40.07768');
INSERT INTO resource_log VALUES (5609, 1378, 2, NULL, '2014-05-17 19:02:40.402053');
INSERT INTO resource_log VALUES (5616, 1385, 2, NULL, '2014-05-17 19:07:13.667811');
INSERT INTO resource_log VALUES (5617, 1386, 2, NULL, '2014-05-17 19:07:36.068126');
INSERT INTO resource_log VALUES (5621, 1390, 2, NULL, '2014-05-17 19:11:55.084234');
INSERT INTO resource_log VALUES (4789, 763, 2, NULL, '2014-01-12 19:51:49.157909');
INSERT INTO resource_log VALUES (4903, 854, 2, NULL, '2014-02-08 22:16:58.906498');
INSERT INTO resource_log VALUES (4904, 3, 2, NULL, '2014-02-08 22:17:06.939369');
INSERT INTO resource_log VALUES (4905, 854, 2, NULL, '2014-02-08 22:20:32.280238');
INSERT INTO resource_log VALUES (4906, 784, 2, NULL, '2014-02-08 22:21:01.290541');
INSERT INTO resource_log VALUES (4908, 786, 2, NULL, '2014-02-08 22:21:09.110319');
INSERT INTO resource_log VALUES (5484, 1253, 2, NULL, '2014-04-28 00:03:49.599015');
INSERT INTO resource_log VALUES (5289, 1081, 2, NULL, '2014-03-22 17:57:05.076581');
INSERT INTO resource_log VALUES (5605, 1374, 2, NULL, '2014-05-17 18:55:03.070735');
INSERT INTO resource_log VALUES (5608, 1377, 2, NULL, '2014-05-17 18:56:44.9516');
INSERT INTO resource_log VALUES (5611, 1380, 2, NULL, '2014-05-17 19:03:57.212913');
INSERT INTO resource_log VALUES (5614, 1383, 2, NULL, '2014-05-17 19:04:59.867959');
INSERT INTO resource_log VALUES (5618, 1387, 2, NULL, '2014-05-17 19:09:22.594353');
INSERT INTO resource_log VALUES (5624, 1393, 2, NULL, '2014-05-18 10:14:28.009945');
INSERT INTO resource_log VALUES (4790, 764, 2, NULL, '2014-01-12 20:33:53.3138');
INSERT INTO resource_log VALUES (4909, 723, 2, NULL, '2014-02-08 22:28:37.868751');
INSERT INTO resource_log VALUES (4940, 878, 2, NULL, '2014-02-10 16:40:47.442615');
INSERT INTO resource_log VALUES (5610, 1379, 2, NULL, '2014-05-17 19:03:38.443538');
INSERT INTO resource_log VALUES (5612, 1381, 2, NULL, '2014-05-17 19:04:17.238286');
INSERT INTO resource_log VALUES (5615, 1384, 2, NULL, '2014-05-17 19:07:10.869783');
INSERT INTO resource_log VALUES (5620, 1389, 2, NULL, '2014-05-17 19:09:47.55779');
INSERT INTO resource_log VALUES (4910, 857, 2, NULL, '2014-02-09 00:41:07.487567');
INSERT INTO resource_log VALUES (4911, 858, 2, NULL, '2014-02-09 00:41:26.234037');
INSERT INTO resource_log VALUES (4912, 859, 2, NULL, '2014-02-09 00:41:48.428505');
INSERT INTO resource_log VALUES (4913, 860, 2, NULL, '2014-02-09 00:42:12.938208');
INSERT INTO resource_log VALUES (4914, 857, 2, NULL, '2014-02-09 00:42:31.066281');
INSERT INTO resource_log VALUES (4915, 861, 2, NULL, '2014-02-09 00:42:52.234296');
INSERT INTO resource_log VALUES (5291, 1088, 2, NULL, '2014-03-22 18:51:18.985681');
INSERT INTO resource_log VALUES (5292, 1081, 2, NULL, '2014-03-22 18:51:44.158872');
INSERT INTO resource_log VALUES (5458, 1225, 2, NULL, '2014-04-13 12:01:26.796233');
INSERT INTO resource_log VALUES (5627, 1396, 2, NULL, '2014-05-18 11:58:47.293591');
INSERT INTO resource_log VALUES (4917, 764, 2, NULL, '2014-02-09 00:53:58.264629');
INSERT INTO resource_log VALUES (4918, 769, 2, NULL, '2014-02-09 00:57:04.796409');
INSERT INTO resource_log VALUES (4919, 775, 2, NULL, '2014-02-09 00:57:24.917548');
INSERT INTO resource_log VALUES (4920, 788, 2, NULL, '2014-02-09 00:57:42.02056');
INSERT INTO resource_log VALUES (4942, 878, 2, NULL, '2014-02-10 22:47:18.374976');
INSERT INTO resource_log VALUES (4943, 880, 2, NULL, '2014-02-10 22:48:37.279277');
INSERT INTO resource_log VALUES (4944, 881, 2, NULL, '2014-02-10 22:49:24.829434');
INSERT INTO resource_log VALUES (4945, 882, 2, NULL, '2014-02-10 22:49:56.066237');
INSERT INTO resource_log VALUES (4946, 883, 2, NULL, '2014-02-10 22:50:06.121122');
INSERT INTO resource_log VALUES (4947, 884, 2, NULL, '2014-02-10 22:50:26.035905');
INSERT INTO resource_log VALUES (4948, 884, 2, NULL, '2014-02-10 22:53:06.689693');
INSERT INTO resource_log VALUES (5294, 1090, 2, NULL, '2014-03-22 20:34:50.666418');
INSERT INTO resource_log VALUES (5295, 1091, 2, NULL, '2014-03-22 20:36:11.95663');
INSERT INTO resource_log VALUES (5298, 1093, 2, NULL, '2014-03-22 20:40:16.040605');
INSERT INTO resource_log VALUES (5629, 1398, 2, NULL, '2014-05-18 12:12:21.975254');
INSERT INTO resource_log VALUES (4949, 764, 2, NULL, '2014-02-11 19:47:14.055452');
INSERT INTO resource_log VALUES (5488, 1257, 2, NULL, '2014-04-28 12:34:34.363475');
INSERT INTO resource_log VALUES (5300, 1095, 2, NULL, '2014-03-22 20:52:34.596466');
INSERT INTO resource_log VALUES (5301, 1096, 2, NULL, '2014-03-22 20:52:44.740475');
INSERT INTO resource_log VALUES (5302, 1097, 2, NULL, '2014-03-22 20:53:03.099066');
INSERT INTO resource_log VALUES (5489, 1258, 2, NULL, '2014-04-28 12:34:55.433659');
INSERT INTO resource_log VALUES (5304, 1099, 2, NULL, '2014-03-22 20:57:07.889521');
INSERT INTO resource_log VALUES (5535, 1304, 2, NULL, '2014-04-29 16:15:23.221696');
INSERT INTO resource_log VALUES (5389, 1178, 2, NULL, '2014-04-05 19:40:06.274566');
INSERT INTO resource_log VALUES (5390, 1179, 2, NULL, '2014-04-05 19:40:10.823684');
INSERT INTO resource_log VALUES (5490, 1259, 2, NULL, '2014-04-28 12:58:44.196537');
INSERT INTO resource_log VALUES (5305, 1100, 2, NULL, '2014-03-22 21:00:41.76813');
INSERT INTO resource_log VALUES (5306, 1101, 2, NULL, '2014-03-22 21:00:48.529148');
INSERT INTO resource_log VALUES (5307, 1102, 2, NULL, '2014-03-22 21:01:34.517288');
INSERT INTO resource_log VALUES (5491, 1260, 2, NULL, '2014-04-28 12:59:00.104464');
INSERT INTO resource_log VALUES (5631, 1400, 2, NULL, '2014-05-18 13:37:21.801854');
INSERT INTO resource_log VALUES (5632, 1401, 2, NULL, '2014-05-18 13:37:41.402585');
INSERT INTO resource_log VALUES (5633, 1402, 2, NULL, '2014-05-18 13:44:45.628784');
INSERT INTO resource_log VALUES (5492, 1261, 2, NULL, '2014-04-28 13:04:58.29173');
INSERT INTO resource_log VALUES (5634, 1403, 2, NULL, '2014-05-18 15:48:34.956287');
INSERT INTO resource_log VALUES (5256, 1067, 2, NULL, '2014-03-16 19:34:31.935568');
INSERT INTO resource_log VALUES (5494, 1263, 2, NULL, '2014-04-28 13:08:06.602496');
INSERT INTO resource_log VALUES (5635, 1404, 2, NULL, '2014-05-18 19:18:07.615122');
INSERT INTO resource_log VALUES (5636, 1406, 2, NULL, '2014-05-18 19:18:56.831097');
INSERT INTO resource_log VALUES (5639, 1409, 2, NULL, '2014-05-18 19:22:05.971396');
INSERT INTO resource_log VALUES (5394, 1185, 2, NULL, '2014-04-05 20:56:20.797318');
INSERT INTO resource_log VALUES (5257, 1067, 2, NULL, '2014-03-16 19:55:56.894484');
INSERT INTO resource_log VALUES (5495, 1264, 2, NULL, '2014-04-28 13:08:25.610345');
INSERT INTO resource_log VALUES (5637, 1407, 2, NULL, '2014-05-18 19:19:36.399614');
INSERT INTO resource_log VALUES (5641, 1411, 2, NULL, '2014-05-18 19:23:45.119721');
INSERT INTO resource_log VALUES (5642, 1412, 2, NULL, '2014-05-18 19:24:25.545359');
INSERT INTO resource_log VALUES (5496, 1265, 2, NULL, '2014-04-28 13:08:54.519921');
INSERT INTO resource_log VALUES (5638, 1408, 2, NULL, '2014-05-18 19:19:43.401474');
INSERT INTO resource_log VALUES (5258, 1067, 2, NULL, '2014-03-16 20:09:16.532934');
INSERT INTO resource_log VALUES (5311, 1097, 2, NULL, '2014-03-24 19:59:44.290142');
INSERT INTO resource_log VALUES (5640, 1410, 2, NULL, '2014-05-18 19:23:00.415796');
INSERT INTO resource_log VALUES (5643, 1413, 2, NULL, '2014-05-20 21:26:27.311927');
INSERT INTO resource_log VALUES (5259, 1068, 2, NULL, '2014-03-16 20:15:31.769185');
INSERT INTO resource_log VALUES (5499, 1268, 2, NULL, '2014-04-28 23:55:09.591646');
INSERT INTO resource_log VALUES (5644, 1414, 2, NULL, '2014-05-24 17:02:57.354915');
INSERT INTO resource_log VALUES (5645, 1415, 2, NULL, '2014-05-24 17:03:02.922541');
INSERT INTO resource_log VALUES (5646, 1416, 2, NULL, '2014-05-24 17:06:48.542492');
INSERT INTO resource_log VALUES (5647, 1417, 2, NULL, '2014-05-24 17:06:51.402853');
INSERT INTO resource_log VALUES (5648, 1418, 2, NULL, '2014-05-24 17:07:25.101929');
INSERT INTO resource_log VALUES (5649, 1419, 2, NULL, '2014-05-24 17:07:29.075778');
INSERT INTO resource_log VALUES (5650, 1420, 2, NULL, '2014-05-24 17:24:17.546972');
INSERT INTO resource_log VALUES (4120, 16, 2, NULL, '2014-01-01 13:19:09.979922');
INSERT INTO resource_log VALUES (4131, 14, 2, NULL, '2014-01-01 18:45:07.902745');
INSERT INTO resource_log VALUES (4144, 706, 2, NULL, '2014-01-03 16:12:41.015146');
INSERT INTO resource_log VALUES (4145, 706, 2, NULL, '2014-01-03 16:13:23.197097');
INSERT INTO resource_log VALUES (5402, 1189, 2, NULL, '2014-04-06 18:46:40.132797');
INSERT INTO resource_log VALUES (5403, 1190, 2, NULL, '2014-04-06 18:47:22.030146');
INSERT INTO resource_log VALUES (5138, 865, 2, NULL, '2014-03-03 21:09:34.254642');
INSERT INTO resource_log VALUES (5404, 1191, 2, NULL, '2014-04-06 18:53:34.002074');
INSERT INTO resource_log VALUES (5263, 1009, 2, NULL, '2014-03-16 21:40:10.728496');
INSERT INTO resource_log VALUES (5264, 1009, 2, NULL, '2014-03-16 21:44:11.742442');
INSERT INTO resource_log VALUES (5405, 1192, 2, NULL, '2014-04-06 19:20:55.890208');
INSERT INTO resource_log VALUES (5140, 865, 2, NULL, '2014-03-03 21:57:11.59945');
INSERT INTO resource_log VALUES (5265, 1004, 2, NULL, '2014-03-17 10:29:17.115979');
INSERT INTO resource_log VALUES (5266, 1004, 2, NULL, '2014-03-17 10:29:24.701637');
INSERT INTO resource_log VALUES (4744, 723, 2, NULL, '2014-01-04 23:58:55.624453');
INSERT INTO resource_log VALUES (4746, 725, 2, NULL, '2014-01-05 01:09:00.405742');
INSERT INTO resource_log VALUES (4747, 726, 2, NULL, '2014-01-05 01:09:15.602018');
INSERT INTO resource_log VALUES (4749, 728, 2, NULL, '2014-01-05 01:13:50.125212');
INSERT INTO resource_log VALUES (4756, 734, 2, NULL, '2014-01-05 12:36:48.48575');
INSERT INTO resource_log VALUES (4765, 743, 2, NULL, '2014-01-05 13:20:17.173661');
INSERT INTO resource_log VALUES (5654, 1424, 2, NULL, '2014-06-01 10:25:44.71461');
INSERT INTO resource_log VALUES (5656, 1426, 2, NULL, '2014-06-01 12:15:53.295347');
INSERT INTO resource_log VALUES (5661, 1431, 2, NULL, '2014-06-07 15:12:11.693366');
INSERT INTO resource_log VALUES (5662, 1432, 2, NULL, '2014-06-07 15:12:40.323386');
INSERT INTO resource_log VALUES (5663, 1433, 2, NULL, '2014-06-07 17:43:14.620483');
INSERT INTO resource_log VALUES (5665, 1435, 2, NULL, '2014-06-07 21:01:18.691193');
INSERT INTO resource_log VALUES (5667, 1438, 2, NULL, '2014-06-07 21:11:01.089928');
INSERT INTO resource_log VALUES (5668, 1439, 2, NULL, '2014-06-07 21:11:46.797584');
INSERT INTO resource_log VALUES (5669, 1440, 2, NULL, '2014-06-07 22:15:09.567299');
INSERT INTO resource_log VALUES (5671, 1442, 2, NULL, '2014-06-07 22:16:04.586659');
INSERT INTO resource_log VALUES (5676, 1447, 2, NULL, '2014-06-08 21:25:14.638119');
INSERT INTO resource_log VALUES (5677, 1448, 2, NULL, '2014-06-08 21:25:35.09515');
INSERT INTO resource_log VALUES (5679, 1450, 2, NULL, '2014-06-09 15:50:23.760428');
INSERT INTO resource_log VALUES (5681, 1452, 2, NULL, '2014-06-09 17:20:44.311452');
INSERT INTO resource_log VALUES (5682, 1453, 2, NULL, '2014-06-09 20:15:57.545778');
INSERT INTO resource_log VALUES (5683, 1454, 2, NULL, '2014-06-09 20:42:20.973803');
INSERT INTO resource_log VALUES (5684, 1455, 2, NULL, '2014-06-09 20:42:41.688175');
INSERT INTO resource_log VALUES (5685, 1456, 2, NULL, '2014-06-09 20:42:48.878295');
INSERT INTO resource_log VALUES (5686, 1457, 2, NULL, '2014-06-09 22:18:32.577688');
INSERT INTO resource_log VALUES (5687, 1458, 2, NULL, '2014-06-09 22:18:59.404909');
INSERT INTO resource_log VALUES (5688, 1459, 2, NULL, '2014-06-09 22:19:29.172655');
INSERT INTO resource_log VALUES (5689, 1460, 2, NULL, '2014-06-09 22:19:48.16963');
INSERT INTO resource_log VALUES (5690, 1461, 2, NULL, '2014-06-09 22:20:11.231267');
INSERT INTO resource_log VALUES (5691, 1462, 2, NULL, '2014-06-13 22:46:08.190119');
INSERT INTO resource_log VALUES (5692, 1463, 2, NULL, '2014-06-13 22:46:42.967863');
INSERT INTO resource_log VALUES (5693, 1464, 2, NULL, '2014-06-14 17:55:00.252916');
INSERT INTO resource_log VALUES (5694, 1465, 2, NULL, '2014-06-14 17:55:08.213215');
INSERT INTO resource_log VALUES (5695, 1467, 2, NULL, '2014-06-14 17:56:52.935007');
INSERT INTO resource_log VALUES (5696, 1468, 2, NULL, '2014-06-14 17:58:15.339465');
INSERT INTO resource_log VALUES (5697, 1469, 2, NULL, '2014-06-14 17:58:37.034547');
INSERT INTO resource_log VALUES (5698, 1470, 2, NULL, '2014-06-14 18:00:56.71432');
INSERT INTO resource_log VALUES (5699, 1471, 2, NULL, '2014-06-14 18:02:10.63169');
INSERT INTO resource_log VALUES (5700, 1472, 2, NULL, '2014-06-14 18:02:54.98084');
INSERT INTO resource_log VALUES (5701, 1473, 2, NULL, '2014-06-14 18:03:27.411198');
INSERT INTO resource_log VALUES (5702, 1474, 2, NULL, '2014-06-14 18:04:28.298657');
INSERT INTO resource_log VALUES (5703, 1475, 2, NULL, '2014-06-14 18:05:22.160315');
INSERT INTO resource_log VALUES (5704, 1476, 2, NULL, '2014-06-14 18:06:04.93612');
INSERT INTO resource_log VALUES (5705, 1477, 2, NULL, '2014-06-14 18:06:52.83967');
INSERT INTO resource_log VALUES (5706, 1478, 2, NULL, '2014-06-14 18:07:42.799714');
INSERT INTO resource_log VALUES (5707, 1479, 2, NULL, '2014-06-14 18:09:13.451489');
INSERT INTO resource_log VALUES (5708, 1480, 2, NULL, '2014-06-14 18:09:57.549927');
INSERT INTO resource_log VALUES (5709, 1481, 2, NULL, '2014-06-14 18:20:00.741016');
INSERT INTO resource_log VALUES (5710, 1482, 2, NULL, '2014-06-14 18:20:32.755332');
INSERT INTO resource_log VALUES (5711, 1483, 2, NULL, '2014-06-14 18:21:04.54574');
INSERT INTO resource_log VALUES (5713, 1485, 2, NULL, '2014-06-15 15:17:28.256792');
INSERT INTO resource_log VALUES (5715, 1487, 2, NULL, '2014-06-16 14:42:17.062016');
INSERT INTO resource_log VALUES (5728, 1500, 2, NULL, '2014-06-18 16:59:05.631362');
INSERT INTO resource_log VALUES (5730, 1502, 2, NULL, '2014-06-22 19:40:05.464875');
INSERT INTO resource_log VALUES (5731, 1503, 2, NULL, '2014-06-22 19:40:20.79663');
INSERT INTO resource_log VALUES (5732, 1504, 2, NULL, '2014-06-22 19:42:44.939368');
INSERT INTO resource_log VALUES (5733, 1505, 2, NULL, '2014-06-22 19:43:05.103699');
INSERT INTO resource_log VALUES (5734, 1506, 2, NULL, '2014-06-22 19:43:23.157992');
INSERT INTO resource_log VALUES (5735, 1507, 2, NULL, '2014-06-22 19:46:21.388635');
INSERT INTO resource_log VALUES (5737, 1509, 2, NULL, '2014-06-22 21:15:50.586549');
INSERT INTO resource_log VALUES (5738, 1510, 2, NULL, '2014-06-24 20:30:44.36129');
INSERT INTO resource_log VALUES (5739, 1511, 2, NULL, '2014-06-25 19:21:08.001771');
INSERT INTO resource_log VALUES (5740, 1512, 2, NULL, '2014-06-25 19:37:43.544622');
INSERT INTO resource_log VALUES (5741, 1513, 2, NULL, '2014-06-25 19:38:23.293423');
INSERT INTO resource_log VALUES (5742, 1514, 2, NULL, '2014-06-25 19:38:46.712804');
INSERT INTO resource_log VALUES (5743, 1515, 2, NULL, '2014-06-25 19:39:14.757449');
INSERT INTO resource_log VALUES (5744, 1516, 2, NULL, '2014-06-25 20:37:42.602785');
INSERT INTO resource_log VALUES (5745, 1517, 2, NULL, '2014-06-25 20:54:09.96009');
INSERT INTO resource_log VALUES (5746, 1518, 2, NULL, '2014-06-25 20:54:50.943042');
INSERT INTO resource_log VALUES (5747, 1519, 2, NULL, '2014-06-25 20:55:06.988343');
INSERT INTO resource_log VALUES (5748, 1520, 2, NULL, '2014-06-26 17:04:36.85438');
INSERT INTO resource_log VALUES (5749, 1521, 2, NULL, '2014-06-26 21:02:19.488826');
INSERT INTO resource_log VALUES (5750, 1535, 2, NULL, '2014-06-28 17:17:15.295903');
INSERT INTO resource_log VALUES (5751, 1536, 2, NULL, '2014-06-28 17:31:39.626186');
INSERT INTO resource_log VALUES (5752, 1537, 2, NULL, '2014-06-28 20:56:05.816704');
INSERT INTO resource_log VALUES (5753, 1538, 2, NULL, '2014-06-28 20:57:41.600837');
INSERT INTO resource_log VALUES (5754, 1539, 2, NULL, '2014-06-28 20:59:59.522314');
INSERT INTO resource_log VALUES (5755, 1540, 2, NULL, '2014-06-28 21:00:26.365557');
INSERT INTO resource_log VALUES (5756, 1541, 2, NULL, '2014-06-28 21:00:51.086753');
INSERT INTO resource_log VALUES (5757, 1542, 2, NULL, '2014-06-28 21:18:20.602573');
INSERT INTO resource_log VALUES (5758, 1543, 2, NULL, '2014-06-28 21:25:57.336069');
INSERT INTO resource_log VALUES (5759, 1544, 2, NULL, '2014-06-28 21:26:14.894807');
INSERT INTO resource_log VALUES (5760, 1545, 2, NULL, '2014-06-28 21:26:35.413657');
INSERT INTO resource_log VALUES (5761, 1546, 2, NULL, '2014-07-02 23:01:03.321441');
INSERT INTO resource_log VALUES (5762, 1547, 2, NULL, '2014-07-02 23:03:30.755887');
INSERT INTO resource_log VALUES (5763, 1548, 2, NULL, '2014-07-26 18:07:46.336433');
INSERT INTO resource_log VALUES (5764, 1549, 2, NULL, '2014-08-16 20:09:11.73959');
INSERT INTO resource_log VALUES (5766, 1551, 2, NULL, '2014-08-16 20:23:59.980051');
INSERT INTO resource_log VALUES (5767, 1552, 2, NULL, '2014-08-16 20:24:12.305446');
INSERT INTO resource_log VALUES (5768, 1553, 2, NULL, '2014-08-16 20:24:15.930016');
INSERT INTO resource_log VALUES (5769, 1554, 2, NULL, '2014-08-16 20:25:09.403552');
INSERT INTO resource_log VALUES (5771, 1556, 2, NULL, '2014-08-16 20:51:19.103778');
INSERT INTO resource_log VALUES (5773, 1559, 2, NULL, '2014-08-16 21:13:14.302214');
INSERT INTO resource_log VALUES (5774, 1560, 2, NULL, '2014-08-16 21:13:18.107616');
INSERT INTO resource_log VALUES (5775, 1561, 2, NULL, '2014-08-16 21:22:35.752473');
INSERT INTO resource_log VALUES (5776, 1562, 2, NULL, '2014-08-16 21:23:02.397566');
INSERT INTO resource_log VALUES (5777, 1563, 2, NULL, '2014-08-16 21:23:05.499294');
INSERT INTO resource_log VALUES (5778, 1564, 2, NULL, '2014-08-16 21:24:08.813965');
INSERT INTO resource_log VALUES (5781, 1567, 2, NULL, '2014-08-17 11:06:39.681926');
INSERT INTO resource_log VALUES (5782, 1568, 2, NULL, '2014-08-17 11:06:57.522852');
INSERT INTO resource_log VALUES (5783, 1569, 2, NULL, '2014-08-17 11:07:53.713228');
INSERT INTO resource_log VALUES (5784, 1570, 2, NULL, '2014-08-17 11:09:10.292392');
INSERT INTO resource_log VALUES (5790, 1576, 2, NULL, '2014-08-22 22:48:58.176695');
INSERT INTO resource_log VALUES (5791, 1577, 2, NULL, '2014-08-22 22:49:31.584667');
INSERT INTO resource_log VALUES (5792, 1578, 2, NULL, '2014-08-22 22:49:35.101959');
INSERT INTO resource_log VALUES (5793, 1579, 2, NULL, '2014-08-22 22:50:20.197271');
INSERT INTO resource_log VALUES (5794, 1580, 2, NULL, '2014-08-22 22:50:49.188036');
INSERT INTO resource_log VALUES (5795, 1581, 2, NULL, '2014-08-22 22:51:29.357367');
INSERT INTO resource_log VALUES (5796, 1582, 2, NULL, '2014-08-22 22:52:03.171722');
INSERT INTO resource_log VALUES (5797, 1584, 2, NULL, '2014-08-22 22:58:38.326467');
INSERT INTO resource_log VALUES (5798, 1585, 2, NULL, '2014-08-22 22:59:28.534906');
INSERT INTO resource_log VALUES (5799, 1586, 2, NULL, '2014-08-22 22:59:41.71816');
INSERT INTO resource_log VALUES (5800, 1587, 2, NULL, '2014-08-22 23:01:39.676197');
INSERT INTO resource_log VALUES (5801, 1588, 2, NULL, '2014-08-22 23:02:11.872661');
INSERT INTO resource_log VALUES (5802, 1589, 2, NULL, '2014-08-22 23:04:10.670971');
INSERT INTO resource_log VALUES (5803, 1590, 2, NULL, '2014-08-22 23:04:40.181387');
INSERT INTO resource_log VALUES (5804, 1591, 2, NULL, '2014-08-22 23:05:46.128053');
INSERT INTO resource_log VALUES (5805, 1592, 2, NULL, '2014-08-22 23:06:07.780481');
INSERT INTO resource_log VALUES (5806, 1593, 2, NULL, '2014-08-22 23:06:12.342153');
INSERT INTO resource_log VALUES (5807, 1594, 2, NULL, '2014-08-22 23:07:05.069505');
INSERT INTO resource_log VALUES (5808, 1595, 2, NULL, '2014-08-22 23:08:18.152328');
INSERT INTO resource_log VALUES (5809, 1596, 2, NULL, '2014-08-22 23:09:01.174533');
INSERT INTO resource_log VALUES (5810, 1597, 2, NULL, '2014-08-22 23:14:17.280337');
INSERT INTO resource_log VALUES (5811, 1598, 2, NULL, '2014-08-22 23:35:58.491964');
INSERT INTO resource_log VALUES (5813, 1600, 2, NULL, '2014-08-23 11:04:12.184497');
INSERT INTO resource_log VALUES (5820, 1607, 2, NULL, '2014-08-23 13:37:30.044239');
INSERT INTO resource_log VALUES (5821, 1608, 2, NULL, '2014-08-23 16:14:22.910225');
INSERT INTO resource_log VALUES (5822, 1609, 2, NULL, '2014-08-23 16:16:24.823791');
INSERT INTO resource_log VALUES (5823, 1610, 2, NULL, '2014-08-24 14:10:51.002759');
INSERT INTO resource_log VALUES (5824, 1611, 2, NULL, '2014-08-24 14:11:19.783792');
INSERT INTO resource_log VALUES (5825, 1612, 2, NULL, '2014-08-24 14:11:36.729128');
INSERT INTO resource_log VALUES (5826, 1613, 2, NULL, '2014-08-24 14:11:54.849623');
INSERT INTO resource_log VALUES (5827, 1614, 2, NULL, '2014-08-24 14:48:54.04485');
INSERT INTO resource_log VALUES (5828, 1615, 2, NULL, '2014-08-24 14:48:55.715304');
INSERT INTO resource_log VALUES (5829, 1616, 2, NULL, '2014-08-24 14:49:59.373945');
INSERT INTO resource_log VALUES (5830, 1617, 2, NULL, '2014-08-24 14:57:40.998747');
INSERT INTO resource_log VALUES (5831, 1618, 2, NULL, '2014-08-24 14:58:58.327062');
INSERT INTO resource_log VALUES (5832, 1619, 2, NULL, '2014-08-24 15:01:16.140346');
INSERT INTO resource_log VALUES (5833, 1620, 2, NULL, '2014-08-24 15:02:15.884894');
INSERT INTO resource_log VALUES (5834, 1621, 2, NULL, '2014-08-24 15:02:43.162974');
INSERT INTO resource_log VALUES (5835, 1622, 2, NULL, '2014-08-24 15:03:06.67481');
INSERT INTO resource_log VALUES (5836, 1623, 2, NULL, '2014-08-24 15:03:53.276198');
INSERT INTO resource_log VALUES (5837, 1624, 2, NULL, '2014-08-24 15:08:02.737031');
INSERT INTO resource_log VALUES (5838, 1625, 2, NULL, '2014-08-24 15:08:18.61161');
INSERT INTO resource_log VALUES (5839, 1626, 2, NULL, '2014-08-24 15:08:29.0077');
INSERT INTO resource_log VALUES (5840, 1627, 2, NULL, '2014-08-24 15:10:13.736496');
INSERT INTO resource_log VALUES (5841, 1628, 2, NULL, '2014-08-24 15:10:44.233145');
INSERT INTO resource_log VALUES (5842, 1629, 2, NULL, '2014-08-24 15:11:29.749793');
INSERT INTO resource_log VALUES (5843, 1630, 2, NULL, '2014-08-24 15:11:33.251549');
INSERT INTO resource_log VALUES (5844, 1631, 2, NULL, '2014-08-24 15:16:53.496818');
INSERT INTO resource_log VALUES (5845, 1632, 2, NULL, '2014-08-24 15:17:15.949468');
INSERT INTO resource_log VALUES (5846, 1633, 2, NULL, '2014-08-24 15:17:28.997817');
INSERT INTO resource_log VALUES (5847, 1634, 2, NULL, '2014-08-24 15:21:09.48427');
INSERT INTO resource_log VALUES (5852, 1639, 2, NULL, '2014-08-25 15:20:24.884947');
INSERT INTO resource_log VALUES (5853, 1640, 2, NULL, '2014-08-26 19:55:53.569882');
INSERT INTO resource_log VALUES (5854, 1641, 2, NULL, '2014-08-26 19:56:28.320221');
INSERT INTO resource_log VALUES (5858, 1645, 2, NULL, '2014-08-26 20:01:19.187139');
INSERT INTO resource_log VALUES (5860, 1647, 2, NULL, '2014-08-26 20:04:08.078366');
INSERT INTO resource_log VALUES (5862, 1649, 2, NULL, '2014-08-26 20:04:48.124422');
INSERT INTO resource_log VALUES (5855, 1642, 2, NULL, '2014-08-26 19:56:46.695581');
INSERT INTO resource_log VALUES (5856, 1643, 2, NULL, '2014-08-26 19:57:13.160198');
INSERT INTO resource_log VALUES (5857, 1644, 2, NULL, '2014-08-26 20:01:16.129984');
INSERT INTO resource_log VALUES (5859, 1646, 2, NULL, '2014-08-26 20:04:06.105786');
INSERT INTO resource_log VALUES (5861, 1648, 2, NULL, '2014-08-26 20:04:09.378364');
INSERT INTO resource_log VALUES (5863, 1650, 2, NULL, '2014-08-26 20:06:13.193356');
INSERT INTO resource_log VALUES (5864, 1651, 2, NULL, '2014-08-26 20:06:36.249641');
INSERT INTO resource_log VALUES (5865, 1652, 2, NULL, '2014-08-26 20:07:23.412381');
INSERT INTO resource_log VALUES (5866, 1653, 2, NULL, '2014-08-26 20:07:31.899383');
INSERT INTO resource_log VALUES (5867, 1654, 2, NULL, '2014-08-26 20:12:29.150503');
INSERT INTO resource_log VALUES (5868, 1655, 2, NULL, '2014-08-26 20:12:40.489325');
INSERT INTO resource_log VALUES (5869, 1656, 2, NULL, '2014-08-26 20:13:02.876592');
INSERT INTO resource_log VALUES (5870, 1657, 2, NULL, '2014-08-26 20:13:28.887297');
INSERT INTO resource_log VALUES (5873, 1660, 2, NULL, '2014-08-31 16:37:37.888486');
INSERT INTO resource_log VALUES (5919, 1714, 2, NULL, '2014-09-14 13:27:15.677766');
INSERT INTO resource_log VALUES (5926, 1721, 2, NULL, '2014-09-14 14:49:51.512979');
INSERT INTO resource_log VALUES (5963, 1758, 2, NULL, '2014-09-14 16:52:13.746397');
INSERT INTO resource_log VALUES (5964, 1759, 2, NULL, '2014-09-14 16:52:29.599653');
INSERT INTO resource_log VALUES (5967, 1764, 2, NULL, '2014-09-14 21:51:09.963908');
INSERT INTO resource_log VALUES (5968, 1766, 2, NULL, '2014-09-28 17:08:27.946698');
INSERT INTO resource_log VALUES (5971, 1769, 2, NULL, '2014-10-01 20:37:18.107894');
INSERT INTO resource_log VALUES (5972, 1771, 2, NULL, '2014-10-01 21:39:17.299667');
INSERT INTO resource_log VALUES (5973, 1773, 2, NULL, '2014-10-01 22:04:03.074823');
INSERT INTO resource_log VALUES (5974, 1774, 2, NULL, '2014-10-01 22:17:44.949656');
INSERT INTO resource_log VALUES (5975, 1775, 2, NULL, '2014-10-03 20:21:54.06353');
INSERT INTO resource_log VALUES (5977, 1777, 2, NULL, '2014-10-03 20:35:01.628264');
INSERT INTO resource_log VALUES (5978, 1778, 2, NULL, '2014-10-04 21:45:17.702702');
INSERT INTO resource_log VALUES (5980, 1780, 2, NULL, '2014-10-05 12:49:28.270538');
INSERT INTO resource_log VALUES (5982, 1797, 2, NULL, '2014-10-05 21:08:02.025119');
INSERT INTO resource_log VALUES (5983, 1798, 2, NULL, '2014-10-05 22:07:40.176836');
INSERT INTO resource_log VALUES (5984, 1799, 2, NULL, '2014-10-09 20:49:57.476724');
INSERT INTO resource_log VALUES (5985, 1800, 2, NULL, '2014-10-09 21:44:48.304991');
INSERT INTO resource_log VALUES (5986, 1801, 2, NULL, '2014-10-09 21:45:57.042916');
INSERT INTO resource_log VALUES (5987, 1802, 2, NULL, '2014-10-09 21:51:36.274928');
INSERT INTO resource_log VALUES (5988, 1797, 2, NULL, '2014-10-09 21:58:44.274487');
INSERT INTO resource_log VALUES (5989, 1803, 2, NULL, '2014-10-10 21:20:08.467997');
INSERT INTO resource_log VALUES (5990, 1804, 2, NULL, '2014-10-10 21:48:32.795064');
INSERT INTO resource_log VALUES (5991, 1797, 2, NULL, '2014-10-10 21:48:40.224687');
INSERT INTO resource_log VALUES (5994, 1797, 2, NULL, '2014-10-10 22:43:03.886027');
INSERT INTO resource_log VALUES (5995, 1807, 2, NULL, '2014-10-12 12:18:58.609492');
INSERT INTO resource_log VALUES (5996, 1419, 2, NULL, '2014-10-12 12:21:41.297126');
INSERT INTO resource_log VALUES (5997, 1808, 2, NULL, '2014-10-12 14:01:25.243707');
INSERT INTO resource_log VALUES (5999, 1419, 2, NULL, '2014-10-12 14:03:13.921521');
INSERT INTO resource_log VALUES (6000, 1419, 2, NULL, '2014-10-12 14:03:56.458732');
INSERT INTO resource_log VALUES (6002, 1797, 2, NULL, '2014-10-12 14:08:19.225786');
INSERT INTO resource_log VALUES (6003, 1797, 2, NULL, '2014-10-12 14:08:29.322661');
INSERT INTO resource_log VALUES (6005, 1797, 2, NULL, '2014-10-12 14:09:47.667654');
INSERT INTO resource_log VALUES (6006, 1797, 2, NULL, '2014-10-12 14:10:15.511498');
INSERT INTO resource_log VALUES (6008, 894, 2, NULL, '2014-10-12 14:15:30.839116');
INSERT INTO resource_log VALUES (6009, 1813, 2, NULL, '2014-10-12 14:15:48.666773');
INSERT INTO resource_log VALUES (6010, 894, 2, NULL, '2014-10-12 14:15:50.178579');
INSERT INTO resource_log VALUES (6011, 894, 2, NULL, '2014-10-12 14:16:00.712168');
INSERT INTO resource_log VALUES (6012, 1814, 2, NULL, '2014-10-12 14:21:39.857292');
INSERT INTO resource_log VALUES (6014, 1507, 2, NULL, '2014-10-12 14:21:53.792753');
INSERT INTO resource_log VALUES (6015, 1507, 2, NULL, '2014-10-12 14:22:06.118134');
INSERT INTO resource_log VALUES (6016, 1439, 2, NULL, '2014-10-12 14:22:17.008412');
INSERT INTO resource_log VALUES (6017, 1438, 2, NULL, '2014-10-12 14:22:21.965321');
INSERT INTO resource_log VALUES (6018, 1816, 2, NULL, '2014-10-12 14:25:07.755915');
INSERT INTO resource_log VALUES (6020, 1780, 2, NULL, '2014-10-12 14:25:19.014258');
INSERT INTO resource_log VALUES (6021, 1780, 2, NULL, '2014-10-12 14:25:28.403238');
INSERT INTO resource_log VALUES (6022, 1780, 2, NULL, '2014-10-12 14:25:37.930302');
INSERT INTO resource_log VALUES (6023, 1818, 2, NULL, '2014-10-12 14:30:47.572942');
INSERT INTO resource_log VALUES (6025, 1413, 2, NULL, '2014-10-12 14:31:06.237149');
INSERT INTO resource_log VALUES (6026, 1413, 2, NULL, '2014-10-12 14:31:16.507549');
INSERT INTO resource_log VALUES (6027, 1820, 2, NULL, '2014-10-12 14:32:08.189913');
INSERT INTO resource_log VALUES (6029, 1415, 2, NULL, '2014-10-12 14:34:22.672887');
INSERT INTO resource_log VALUES (6030, 1415, 2, NULL, '2014-10-12 14:34:32.05391');
INSERT INTO resource_log VALUES (6032, 1823, 2, NULL, '2014-10-12 14:41:47.550757');
INSERT INTO resource_log VALUES (6033, 1656, 2, NULL, '2014-10-12 14:41:52.788316');
INSERT INTO resource_log VALUES (6034, 1656, 2, NULL, '2014-10-12 14:42:08.782779');
INSERT INTO resource_log VALUES (6036, 1656, 2, NULL, '2014-10-12 14:42:30.203879');
INSERT INTO resource_log VALUES (6037, 1656, 2, NULL, '2014-10-12 14:42:44.613039');
INSERT INTO resource_log VALUES (6038, 1825, 2, NULL, '2014-10-12 15:40:22.532108');
INSERT INTO resource_log VALUES (6040, 1759, 2, NULL, '2014-10-12 15:40:35.199768');
INSERT INTO resource_log VALUES (6041, 1759, 2, NULL, '2014-10-12 15:41:02.788024');
INSERT INTO resource_log VALUES (6042, 1827, 2, NULL, '2014-10-12 15:41:56.978292');
INSERT INTO resource_log VALUES (6043, 1657, 2, NULL, '2014-10-12 15:41:58.778177');
INSERT INTO resource_log VALUES (6045, 1657, 2, NULL, '2014-10-12 15:42:13.36551');
INSERT INTO resource_log VALUES (6046, 1657, 2, NULL, '2014-10-12 15:42:24.726059');
INSERT INTO resource_log VALUES (6047, 1829, 2, NULL, '2014-10-12 15:53:46.704817');
INSERT INTO resource_log VALUES (6048, 1830, 2, NULL, '2014-10-12 15:54:37.347579');
INSERT INTO resource_log VALUES (6049, 1831, 2, NULL, '2014-10-12 15:56:47.049952');
INSERT INTO resource_log VALUES (6050, 1653, 2, NULL, '2014-10-12 16:27:20.425954');
INSERT INTO resource_log VALUES (6051, 1653, 2, NULL, '2014-10-12 16:27:45.783221');
INSERT INTO resource_log VALUES (6053, 1283, 2, NULL, '2014-10-12 16:28:08.925372');
INSERT INTO resource_log VALUES (6054, 1283, 2, NULL, '2014-10-12 16:28:17.376186');
INSERT INTO resource_log VALUES (6055, 1833, 2, NULL, '2014-10-12 16:29:10.045595');
INSERT INTO resource_log VALUES (6056, 784, 2, NULL, '2014-10-12 16:29:11.936722');
INSERT INTO resource_log VALUES (6057, 1834, 2, NULL, '2014-10-12 16:33:14.624844');
INSERT INTO resource_log VALUES (6058, 1835, 2, NULL, '2014-10-12 16:34:06.787408');
INSERT INTO resource_log VALUES (6059, 1836, 2, NULL, '2014-10-12 16:34:49.091444');
INSERT INTO resource_log VALUES (6060, 1837, 2, NULL, '2014-10-12 16:35:17.46038');
INSERT INTO resource_log VALUES (6061, 1542, 2, NULL, '2014-10-12 17:31:06.178463');
INSERT INTO resource_log VALUES (6062, 1838, 2, NULL, '2014-10-12 20:54:50.322646');
INSERT INTO resource_log VALUES (6063, 861, 2, NULL, '2014-10-12 20:54:52.692696');
INSERT INTO resource_log VALUES (6064, 861, 2, NULL, '2014-10-12 20:55:02.552131');
INSERT INTO resource_log VALUES (6065, 1075, 2, NULL, '2014-10-18 11:46:21.55028');
INSERT INTO resource_log VALUES (6066, 998, 2, NULL, '2014-10-18 11:46:31.67705');
INSERT INTO resource_log VALUES (6067, 1656, 2, NULL, '2014-10-18 23:23:34.420148');
INSERT INTO resource_log VALUES (6068, 1630, 2, NULL, '2014-10-18 23:23:46.465142');
INSERT INTO resource_log VALUES (6069, 1617, 2, NULL, '2014-10-18 23:23:56.157596');
INSERT INTO resource_log VALUES (6070, 1594, 2, NULL, '2014-10-18 23:24:05.477568');
INSERT INTO resource_log VALUES (6071, 1480, 2, NULL, '2014-10-18 23:24:15.376373');
INSERT INTO resource_log VALUES (6072, 1412, 2, NULL, '2014-10-18 23:24:23.479928');
INSERT INTO resource_log VALUES (6073, 1377, 2, NULL, '2014-10-18 23:24:32.508988');
INSERT INTO resource_log VALUES (6074, 1295, 2, NULL, '2014-10-18 23:24:41.093481');
INSERT INTO resource_log VALUES (6075, 1657, 2, NULL, '2014-10-18 23:25:55.139592');
INSERT INTO resource_log VALUES (6076, 1657, 2, NULL, '2014-10-18 23:26:04.397861');
INSERT INTO resource_log VALUES (6077, 1839, 2, NULL, '2014-10-18 23:26:44.642232');
INSERT INTO resource_log VALUES (6078, 1634, 2, NULL, '2014-10-18 23:26:52.975425');
INSERT INTO resource_log VALUES (6079, 1598, 2, NULL, '2014-10-18 23:27:05.648811');
INSERT INTO resource_log VALUES (6080, 1502, 2, NULL, '2014-10-18 23:27:11.743763');
INSERT INTO resource_log VALUES (6081, 1503, 2, NULL, '2014-10-18 23:27:18.622533');
INSERT INTO resource_log VALUES (6082, 1440, 2, NULL, '2014-10-18 23:27:25.765119');
INSERT INTO resource_log VALUES (6083, 1442, 2, NULL, '2014-10-18 23:27:32.509568');
INSERT INTO resource_log VALUES (6084, 1840, 2, NULL, '2014-10-18 23:35:01.43267');
INSERT INTO resource_log VALUES (6085, 1656, 2, NULL, '2014-10-19 22:36:11.789477');
INSERT INTO resource_log VALUES (6086, 1841, 2, NULL, '2014-10-19 22:36:11.789477');
INSERT INTO resource_log VALUES (6087, 1630, 2, NULL, '2014-10-19 22:36:19.582687');
INSERT INTO resource_log VALUES (6088, 1842, 2, NULL, '2014-10-19 22:36:19.582687');
INSERT INTO resource_log VALUES (6089, 1617, 2, NULL, '2014-10-19 22:36:25.346653');
INSERT INTO resource_log VALUES (6090, 1843, 2, NULL, '2014-10-19 22:36:25.346653');
INSERT INTO resource_log VALUES (6091, 1594, 2, NULL, '2014-10-19 22:36:33.020862');
INSERT INTO resource_log VALUES (6092, 1844, 2, NULL, '2014-10-19 22:36:33.020862');
INSERT INTO resource_log VALUES (6093, 1480, 2, NULL, '2014-10-19 22:36:39.277425');
INSERT INTO resource_log VALUES (6094, 1845, 2, NULL, '2014-10-19 22:36:39.277425');
INSERT INTO resource_log VALUES (6095, 1412, 2, NULL, '2014-10-19 22:36:45.843702');
INSERT INTO resource_log VALUES (6096, 1846, 2, NULL, '2014-10-19 22:36:45.843702');
INSERT INTO resource_log VALUES (6097, 1377, 2, NULL, '2014-10-19 22:36:52.426547');
INSERT INTO resource_log VALUES (6098, 1847, 2, NULL, '2014-10-19 22:36:52.426547');
INSERT INTO resource_log VALUES (6099, 1295, 2, NULL, '2014-10-19 22:37:00.327784');
INSERT INTO resource_log VALUES (6100, 1848, 2, NULL, '2014-10-19 22:37:00.327784');
INSERT INTO resource_log VALUES (6101, 1295, 2, NULL, '2014-10-25 19:32:56.108191');
INSERT INTO resource_log VALUES (6102, 1656, 2, NULL, '2014-10-25 19:33:11.2886');
INSERT INTO resource_log VALUES (6103, 1630, 2, NULL, '2014-10-25 19:33:23.458476');
INSERT INTO resource_log VALUES (6104, 1630, 2, NULL, '2014-10-25 19:33:30.31595');
INSERT INTO resource_log VALUES (6105, 1630, 2, NULL, '2014-10-25 19:33:36.983101');
INSERT INTO resource_log VALUES (6106, 1617, 2, NULL, '2014-10-25 19:33:44.663485');
INSERT INTO resource_log VALUES (6107, 1594, 2, NULL, '2014-10-25 19:33:51.274504');
INSERT INTO resource_log VALUES (6108, 1480, 2, NULL, '2014-10-25 19:34:16.807636');
INSERT INTO resource_log VALUES (6109, 1412, 2, NULL, '2014-10-25 19:34:23.496097');
INSERT INTO resource_log VALUES (6110, 1377, 2, NULL, '2014-10-25 19:34:31.488965');
INSERT INTO resource_log VALUES (6111, 1295, 2, NULL, '2014-10-25 19:35:38.504584');
INSERT INTO resource_log VALUES (6112, 1759, 2, NULL, '2014-10-25 19:46:03.137133');
INSERT INTO resource_log VALUES (6113, 1456, 2, NULL, '2014-10-25 19:46:11.570251');
INSERT INTO resource_log VALUES (6114, 1598, 2, NULL, '2014-10-25 20:24:45.191774');
INSERT INTO resource_log VALUES (6115, 1840, 2, NULL, '2014-10-25 20:25:16.419372');
INSERT INTO resource_log VALUES (6116, 1839, 2, NULL, '2014-10-25 20:25:25.421645');
INSERT INTO resource_log VALUES (6117, 1657, 2, NULL, '2014-10-25 20:25:34.041679');
INSERT INTO resource_log VALUES (6118, 1634, 2, NULL, '2014-10-25 20:25:41.778509');
INSERT INTO resource_log VALUES (6119, 1598, 2, NULL, '2014-10-25 20:25:49.974159');
INSERT INTO resource_log VALUES (6120, 1503, 2, NULL, '2014-10-25 20:25:56.790041');
INSERT INTO resource_log VALUES (6121, 1502, 2, NULL, '2014-10-25 20:26:11.552957');
INSERT INTO resource_log VALUES (6122, 1487, 2, NULL, '2014-10-25 20:26:20.033323');
INSERT INTO resource_log VALUES (6123, 1442, 2, NULL, '2014-10-25 20:26:26.124436');
INSERT INTO resource_log VALUES (6124, 1440, 2, NULL, '2014-10-25 20:26:33.450119');
INSERT INTO resource_log VALUES (6125, 1660, 2, NULL, '2014-10-25 20:27:51.453322');
INSERT INTO resource_log VALUES (6126, 1639, 2, NULL, '2014-10-25 20:27:59.032748');
INSERT INTO resource_log VALUES (6127, 1607, 2, NULL, '2014-10-25 20:28:26.48561');
INSERT INTO resource_log VALUES (6128, 1547, 2, NULL, '2014-10-25 20:31:18.593123');
INSERT INTO resource_log VALUES (6129, 1546, 2, NULL, '2014-10-25 20:31:27.322575');
INSERT INTO resource_log VALUES (6130, 1509, 2, NULL, '2014-10-25 20:31:34.596003');
INSERT INTO resource_log VALUES (6131, 1500, 2, NULL, '2014-10-25 20:31:41.235636');
INSERT INTO resource_log VALUES (6132, 1485, 2, NULL, '2014-10-25 20:31:48.295128');
INSERT INTO resource_log VALUES (6133, 1448, 2, NULL, '2014-10-25 20:31:55.364673');
INSERT INTO resource_log VALUES (6134, 1447, 2, NULL, '2014-10-25 20:32:03.232605');
INSERT INTO resource_log VALUES (6135, 864, 2, NULL, '2014-10-25 22:27:41.085522');
INSERT INTO resource_log VALUES (6136, 900, 2, NULL, '2014-10-25 22:27:48.659618');
INSERT INTO resource_log VALUES (6137, 780, 2, NULL, '2014-10-25 22:27:56.462817');
INSERT INTO resource_log VALUES (6138, 837, 2, NULL, '2014-10-25 22:28:02.931936');
INSERT INTO resource_log VALUES (6139, 1394, 2, NULL, '2014-10-25 22:28:08.943421');
INSERT INTO resource_log VALUES (6140, 873, 2, NULL, '2014-10-25 22:28:16.618586');
INSERT INTO resource_log VALUES (6141, 778, 2, NULL, '2014-10-25 22:28:22.956578');
INSERT INTO resource_log VALUES (6142, 1659, 2, NULL, '2014-10-25 22:39:28.23436');
INSERT INTO resource_log VALUES (6143, 1369, 2, NULL, '2014-10-25 22:42:01.657224');
INSERT INTO resource_log VALUES (6144, 1849, 2, NULL, '2014-10-25 23:00:37.016264');
INSERT INTO resource_log VALUES (6145, 1852, 2, NULL, '2014-10-28 19:57:41.751563');
INSERT INTO resource_log VALUES (6146, 1853, 2, NULL, '2014-10-28 20:23:48.907733');
INSERT INTO resource_log VALUES (6147, 1854, 2, NULL, '2014-10-28 20:24:58.380434');
INSERT INTO resource_log VALUES (6148, 1855, 2, NULL, '2014-10-28 20:25:08.681569');
INSERT INTO resource_log VALUES (6151, 1859, 2, NULL, '2014-10-29 12:48:22.905378');
INSERT INTO resource_log VALUES (6152, 1860, 2, NULL, '2014-10-30 22:03:33.988542');
INSERT INTO resource_log VALUES (6153, 1861, 2, NULL, '2014-10-30 22:04:21.818193');
INSERT INTO resource_log VALUES (6154, 1862, 2, NULL, '2014-10-30 22:04:21.818193');
INSERT INTO resource_log VALUES (6155, 1863, 2, NULL, '2014-10-30 22:04:21.818193');
INSERT INTO resource_log VALUES (6156, 1864, 2, NULL, '2014-10-30 22:04:21.818193');
INSERT INTO resource_log VALUES (6157, 1865, 2, NULL, '2014-11-03 21:33:49.462196');
INSERT INTO resource_log VALUES (6158, 1866, 2, NULL, '2014-11-03 21:38:54.729983');
INSERT INTO resource_log VALUES (6159, 1867, 2, NULL, '2014-11-03 21:39:31.824693');
INSERT INTO resource_log VALUES (6160, 1868, 2, NULL, '2014-11-03 21:40:02.647787');
INSERT INTO resource_log VALUES (6161, 1869, 2, NULL, '2014-11-05 21:10:08.261088');
INSERT INTO resource_log VALUES (6162, 1870, 2, NULL, '2014-11-05 21:10:38.427296');
INSERT INTO resource_log VALUES (6164, 1872, 2, NULL, '2014-11-08 19:05:48.520641');
INSERT INTO resource_log VALUES (6165, 1868, 2, NULL, '2014-11-08 19:07:32.928999');
INSERT INTO resource_log VALUES (6166, 1868, 2, NULL, '2014-11-08 19:07:58.653299');
INSERT INTO resource_log VALUES (6167, 1873, 2, NULL, '2014-11-09 14:14:33.279838');
INSERT INTO resource_log VALUES (6168, 1433, 2, NULL, '2014-11-09 14:15:02.053975');
INSERT INTO resource_log VALUES (6170, 1875, 2, NULL, '2014-11-09 20:43:57.157494');
INSERT INTO resource_log VALUES (6171, 1876, 2, NULL, '2014-11-09 20:50:09.776581');
INSERT INTO resource_log VALUES (6172, 1876, 2, NULL, '2014-11-09 21:46:07.106741');
INSERT INTO resource_log VALUES (6173, 1876, 2, NULL, '2014-11-09 21:46:46.766703');
INSERT INTO resource_log VALUES (6174, 1876, 2, NULL, '2014-11-12 18:42:47.24628');
INSERT INTO resource_log VALUES (6175, 1876, 2, NULL, '2014-11-12 18:43:00.917409');
INSERT INTO resource_log VALUES (6176, 1876, 2, NULL, '2014-11-12 18:43:51.052257');
INSERT INTO resource_log VALUES (6177, 1876, 2, NULL, '2014-11-12 18:49:19.486465');
INSERT INTO resource_log VALUES (6178, 1876, 2, NULL, '2014-11-12 18:49:50.992411');
INSERT INTO resource_log VALUES (6182, 1880, 2, NULL, '2014-11-12 18:58:13.464317');
INSERT INTO resource_log VALUES (6183, 1881, 2, NULL, '2014-11-12 18:58:13.464317');
INSERT INTO resource_log VALUES (6184, 1876, 2, NULL, '2014-11-12 19:19:20.155903');
INSERT INTO resource_log VALUES (6185, 1880, 2, NULL, '2014-11-12 19:20:04.488842');
INSERT INTO resource_log VALUES (6186, 1882, 2, NULL, '2014-11-12 19:21:49.754499');
INSERT INTO resource_log VALUES (6187, 1882, 2, NULL, '2014-11-12 20:48:55.295948');
INSERT INTO resource_log VALUES (6188, 1876, 2, NULL, '2014-11-13 18:36:19.360925');
INSERT INTO resource_log VALUES (6189, 1876, 2, NULL, '2014-11-13 18:36:40.275356');
INSERT INTO resource_log VALUES (6190, 1876, 2, NULL, '2014-11-13 18:36:53.848561');
INSERT INTO resource_log VALUES (6191, 1876, 2, NULL, '2014-11-13 18:37:04.828162');
INSERT INTO resource_log VALUES (6192, 1876, 2, NULL, '2014-11-13 18:44:14.058824');
INSERT INTO resource_log VALUES (6193, 1880, 2, NULL, '2014-11-14 13:23:46.652293');
INSERT INTO resource_log VALUES (6194, 1883, 2, NULL, '2014-11-14 14:39:48.24157');
INSERT INTO resource_log VALUES (6195, 1883, 2, NULL, '2014-11-14 14:44:29.869357');
INSERT INTO resource_log VALUES (6196, 1884, 2, NULL, '2014-11-15 12:46:51.68956');
INSERT INTO resource_log VALUES (6197, 1885, 2, NULL, '2014-11-15 12:55:58.618287');
INSERT INTO resource_log VALUES (6200, 1647, 2, NULL, '2014-11-15 19:54:17.589811');
INSERT INTO resource_log VALUES (6201, 1647, 2, NULL, '2014-11-15 19:57:05.325517');
INSERT INTO resource_log VALUES (6202, 1587, 2, NULL, '2014-11-15 19:57:11.689531');
INSERT INTO resource_log VALUES (6203, 1656, 2, NULL, '2014-11-15 19:58:28.321946');
INSERT INTO resource_log VALUES (6204, 1888, 2, NULL, '2014-11-15 20:54:18.530252');
INSERT INTO resource_log VALUES (6209, 1893, 2, NULL, '2014-11-15 21:10:00.852505');
INSERT INTO resource_log VALUES (6210, 1894, 2, NULL, '2014-11-16 11:36:20.360008');
INSERT INTO resource_log VALUES (6211, 1895, 2, NULL, '2014-11-16 11:38:31.304748');
INSERT INTO resource_log VALUES (6212, 1896, 2, NULL, '2014-11-16 11:52:22.859107');
INSERT INTO resource_log VALUES (6214, 1896, 2, NULL, '2014-11-16 17:28:25.282664');
INSERT INTO resource_log VALUES (6215, 1898, 2, NULL, '2014-11-18 19:36:00.947451');
INSERT INTO resource_log VALUES (6217, 1900, 2, NULL, '2014-11-18 19:59:41.794255');
INSERT INTO resource_log VALUES (6218, 1901, 2, NULL, '2014-11-18 20:00:50.313385');
INSERT INTO resource_log VALUES (6219, 1902, 2, NULL, '2014-11-18 20:05:55.399398');
INSERT INTO resource_log VALUES (6220, 1903, 2, NULL, '2014-11-18 20:06:23.495804');
INSERT INTO resource_log VALUES (6221, 1225, 2, NULL, '2014-11-20 20:55:40.655878');
INSERT INTO resource_log VALUES (6222, 1904, 2, NULL, '2014-11-21 20:47:35.513987');
INSERT INTO resource_log VALUES (6223, 1434, 2, NULL, '2014-11-21 20:48:05.829054');
INSERT INTO resource_log VALUES (6224, 1571, 2, NULL, '2014-11-21 20:48:27.000088');
INSERT INTO resource_log VALUES (6225, 1885, 2, NULL, '2014-11-21 20:48:44.475673');
INSERT INTO resource_log VALUES (6226, 1905, 2, NULL, '2014-11-21 21:17:50.885382');
INSERT INTO resource_log VALUES (6227, 1436, 2, NULL, '2014-11-21 21:19:06.360097');
INSERT INTO resource_log VALUES (6228, 1798, 2, NULL, '2014-11-21 21:19:19.899746');
INSERT INTO resource_log VALUES (6229, 1425, 2, NULL, '2014-11-21 21:19:42.772209');
INSERT INTO resource_log VALUES (6230, 802, 2, NULL, '2014-11-21 21:20:02.792752');
INSERT INTO resource_log VALUES (6231, 1906, 2, NULL, '2014-11-21 21:20:18.443474');
INSERT INTO resource_log VALUES (6232, 802, 2, NULL, '2014-11-21 21:20:33.430037');
INSERT INTO resource_log VALUES (6233, 1395, 2, NULL, '2014-11-21 21:20:55.244524');
INSERT INTO resource_log VALUES (6234, 1907, 2, NULL, '2014-11-21 21:25:23.260941');
INSERT INTO resource_log VALUES (6235, 879, 2, NULL, '2014-11-21 21:26:01.060638');
INSERT INTO resource_log VALUES (6236, 1089, 2, NULL, '2014-11-21 21:34:19.776611');
INSERT INTO resource_log VALUES (6237, 874, 2, NULL, '2014-11-21 21:34:45.906696');
INSERT INTO resource_log VALUES (6238, 1080, 2, NULL, '2014-11-21 21:35:09.652432');
INSERT INTO resource_log VALUES (6239, 1908, 2, NULL, '2014-11-21 21:35:29.643627');
INSERT INTO resource_log VALUES (6240, 910, 2, NULL, '2014-11-21 21:36:10.21074');
INSERT INTO resource_log VALUES (6241, 1080, 2, NULL, '2014-11-21 21:36:26.556412');
INSERT INTO resource_log VALUES (6242, 911, 2, NULL, '2014-11-21 21:36:37.408083');
INSERT INTO resource_log VALUES (6243, 956, 2, NULL, '2014-11-21 21:36:56.333028');
INSERT INTO resource_log VALUES (6244, 955, 2, NULL, '2014-11-21 21:37:09.845857');
INSERT INTO resource_log VALUES (6245, 1909, 2, NULL, '2014-11-21 21:42:55.617875');
INSERT INTO resource_log VALUES (6246, 1896, 2, NULL, '2014-11-21 21:43:10.139464');
INSERT INTO resource_log VALUES (6247, 1910, 2, NULL, '2014-11-22 17:58:53.151533');
INSERT INTO resource_log VALUES (6248, 1911, 2, NULL, '2014-11-22 17:58:53.151533');
INSERT INTO resource_log VALUES (6249, 1883, 2, NULL, '2014-11-23 17:32:08.015669');
INSERT INTO resource_log VALUES (6250, 1883, 2, NULL, '2014-11-23 17:40:29.860378');
INSERT INTO resource_log VALUES (6251, 1903, 2, NULL, '2014-11-23 17:42:18.707964');
INSERT INTO resource_log VALUES (6252, 1912, 2, NULL, '2014-11-23 17:49:28.781243');
INSERT INTO resource_log VALUES (6253, 1903, 2, NULL, '2014-11-23 18:15:04.669498');
INSERT INTO resource_log VALUES (6254, 1913, 2, NULL, '2014-11-23 18:22:07.34092');
INSERT INTO resource_log VALUES (6255, 1915, 2, NULL, '2014-11-23 18:25:34.975922');
INSERT INTO resource_log VALUES (6257, 1917, 2, NULL, '2014-11-23 18:40:26.695236');
INSERT INTO resource_log VALUES (6258, 1918, 2, NULL, '2014-11-23 18:40:42.249218');
INSERT INTO resource_log VALUES (6259, 1919, 2, NULL, '2014-11-27 21:56:12.900683');
INSERT INTO resource_log VALUES (6261, 1075, 2, NULL, '2014-11-28 21:47:39.551572');
INSERT INTO resource_log VALUES (6262, 1075, 2, NULL, '2014-11-28 21:50:21.401582');
INSERT INTO resource_log VALUES (6263, 1075, 2, NULL, '2014-11-28 21:50:32.965327');
INSERT INTO resource_log VALUES (6264, 1075, 2, NULL, '2014-11-28 22:01:58.252158');
INSERT INTO resource_log VALUES (6265, 1906, 2, NULL, '2014-11-28 22:02:27.025943');
INSERT INTO resource_log VALUES (6266, 1908, 2, NULL, '2014-11-28 22:03:25.613427');
INSERT INTO resource_log VALUES (6267, 1919, 2, NULL, '2014-11-30 11:21:31.130821');
INSERT INTO resource_log VALUES (6268, 1921, 2, NULL, '2014-11-30 11:32:16.085887');
INSERT INTO resource_log VALUES (6269, 1075, 2, NULL, '2014-11-30 18:21:55.412483');
INSERT INTO resource_log VALUES (6270, 1368, 2, NULL, '2014-11-30 18:22:02.736241');
INSERT INTO resource_log VALUES (6271, 1922, 2, NULL, '2014-12-07 14:34:35.538855');
INSERT INTO resource_log VALUES (6272, 1630, 2, NULL, '2014-12-07 16:56:05.246646');
INSERT INTO resource_log VALUES (6273, 1923, 2, NULL, '2014-12-07 17:22:48.083707');
INSERT INTO resource_log VALUES (6274, 1656, 2, NULL, '2014-12-07 20:01:19.362233');
INSERT INTO resource_log VALUES (6275, 1656, 2, NULL, '2014-12-07 21:16:30.31957');
INSERT INTO resource_log VALUES (6276, 1924, 2, NULL, '2014-12-07 21:40:24.739542');
INSERT INTO resource_log VALUES (6277, 1925, 2, NULL, '2014-12-07 21:41:09.94037');
INSERT INTO resource_log VALUES (6278, 1926, 2, NULL, '2014-12-07 21:41:37.63455');
INSERT INTO resource_log VALUES (6279, 1471, 2, NULL, '2014-12-07 21:41:39.584636');
INSERT INTO resource_log VALUES (6280, 1927, 2, NULL, '2014-12-07 21:42:12.893528');
INSERT INTO resource_log VALUES (6281, 1471, 2, NULL, '2014-12-07 21:42:14.781639');
INSERT INTO resource_log VALUES (6282, 1928, 2, NULL, '2014-12-07 21:42:16.748923');
INSERT INTO resource_log VALUES (6283, 1929, 2, NULL, '2014-12-07 21:42:16.748923');
INSERT INTO resource_log VALUES (6284, 1928, 2, NULL, '2014-12-07 21:42:38.598358');
INSERT INTO resource_log VALUES (6285, 1930, 2, NULL, '2014-12-08 21:43:55.101305');
INSERT INTO resource_log VALUES (6286, 1869, 2, NULL, '2014-12-08 21:46:09.685953');
INSERT INTO resource_log VALUES (6287, 1931, 2, NULL, '2014-12-08 21:52:00.685674');
INSERT INTO resource_log VALUES (6288, 1930, 2, NULL, '2014-12-08 21:53:17.580512');
INSERT INTO resource_log VALUES (6289, 1932, 2, NULL, '2014-12-11 22:45:01.994257');
INSERT INTO resource_log VALUES (6290, 1933, 2, NULL, '2014-12-11 22:46:28.273472');
INSERT INTO resource_log VALUES (6291, 1934, 2, NULL, '2014-12-11 22:50:30.21811');
INSERT INTO resource_log VALUES (6292, 1928, 2, NULL, '2014-12-11 22:50:35.79796');
INSERT INTO resource_log VALUES (6293, 1935, 2, NULL, '2014-12-11 22:53:00.765244');
INSERT INTO resource_log VALUES (6294, 1928, 2, NULL, '2014-12-11 22:53:03.075924');
INSERT INTO resource_log VALUES (6295, 1935, 2, NULL, '2014-12-11 22:53:42.569877');
INSERT INTO resource_log VALUES (6296, 1928, 2, NULL, '2014-12-11 22:53:44.11868');
INSERT INTO resource_log VALUES (6297, 1936, 2, NULL, '2014-12-13 21:35:47.599877');
INSERT INTO resource_log VALUES (6298, 1939, 2, NULL, '2014-12-13 21:37:02.820409');
INSERT INTO resource_log VALUES (6299, 1939, 2, NULL, '2014-12-13 21:37:54.352906');
INSERT INTO resource_log VALUES (6300, 1936, 2, NULL, '2014-12-13 21:55:38.627009');
INSERT INTO resource_log VALUES (6301, 1933, 2, NULL, '2014-12-13 21:55:57.253566');
INSERT INTO resource_log VALUES (6302, 1933, 2, NULL, '2014-12-13 21:57:41.570228');
INSERT INTO resource_log VALUES (6303, 1933, 2, NULL, '2014-12-13 22:01:39.804954');
INSERT INTO resource_log VALUES (6304, 1936, 2, NULL, '2014-12-13 22:01:54.801501');
INSERT INTO resource_log VALUES (6305, 1936, 2, NULL, '2014-12-13 22:03:25.347584');
INSERT INTO resource_log VALUES (6306, 1933, 2, NULL, '2014-12-13 22:03:37.415197');
INSERT INTO resource_log VALUES (6307, 1939, 2, NULL, '2014-12-13 22:03:52.016284');
INSERT INTO resource_log VALUES (6308, 1936, 2, NULL, '2014-12-13 22:10:55.202627');
INSERT INTO resource_log VALUES (6309, 1936, 2, NULL, '2014-12-13 22:11:45.388631');
INSERT INTO resource_log VALUES (6310, 1936, 2, NULL, '2014-12-14 11:10:18.568487');
INSERT INTO resource_log VALUES (6311, 1936, 2, NULL, '2014-12-14 11:10:54.616091');
INSERT INTO resource_log VALUES (6312, 1936, 2, NULL, '2014-12-14 11:12:20.116844');
INSERT INTO resource_log VALUES (6313, 1933, 2, NULL, '2014-12-14 11:12:44.366886');
INSERT INTO resource_log VALUES (6314, 1936, 2, NULL, '2014-12-14 11:14:36.987112');
INSERT INTO resource_log VALUES (6315, 1933, 2, NULL, '2014-12-14 11:14:46.937016');
INSERT INTO resource_log VALUES (6316, 1940, 2, NULL, '2014-12-14 11:16:18.397912');
INSERT INTO resource_log VALUES (6317, 1941, 2, NULL, '2014-12-14 17:51:15.587939');
INSERT INTO resource_log VALUES (6318, 1940, 2, NULL, '2014-12-14 19:37:37.036036');
INSERT INTO resource_log VALUES (6319, 1936, 2, NULL, '2014-12-14 19:37:54.381361');
INSERT INTO resource_log VALUES (6320, 1940, 2, NULL, '2014-12-14 19:41:49.794566');
INSERT INTO resource_log VALUES (6321, 1940, 2, NULL, '2014-12-14 19:44:37.781977');
INSERT INTO resource_log VALUES (6322, 1940, 2, NULL, '2014-12-14 19:48:08.98232');
INSERT INTO resource_log VALUES (6323, 1940, 2, NULL, '2014-12-14 19:50:28.583831');
INSERT INTO resource_log VALUES (6324, 1940, 2, NULL, '2014-12-14 20:30:31.46273');
INSERT INTO resource_log VALUES (6325, 1936, 2, NULL, '2014-12-14 20:30:45.990313');
INSERT INTO resource_log VALUES (6326, 1940, 2, NULL, '2014-12-14 20:33:08.50634');
INSERT INTO resource_log VALUES (6327, 1940, 2, NULL, '2014-12-14 20:34:47.73587');
INSERT INTO resource_log VALUES (6328, 1940, 2, NULL, '2014-12-14 20:37:41.082704');
INSERT INTO resource_log VALUES (6329, 1653, 2, NULL, '2014-12-19 21:31:43.967187');
INSERT INTO resource_log VALUES (6330, 1653, 2, NULL, '2014-12-19 21:37:31.746728');
INSERT INTO resource_log VALUES (6331, 1951, 2, NULL, '2014-12-19 21:38:17.300837');
INSERT INTO resource_log VALUES (6332, 725, 2, NULL, '2014-12-19 21:38:20.726452');
INSERT INTO resource_log VALUES (6333, 1952, 2, NULL, '2014-12-19 21:42:56.792366');
INSERT INTO resource_log VALUES (6334, 1870, 2, NULL, '2014-12-19 21:43:03.803839');
INSERT INTO resource_log VALUES (6335, 1906, 2, NULL, '2014-12-20 16:10:55.310323');
INSERT INTO resource_log VALUES (6336, 1953, 2, NULL, '2014-12-20 16:12:04.822804');
INSERT INTO resource_log VALUES (6337, 1953, 2, NULL, '2014-12-20 16:28:56.986576');
INSERT INTO resource_log VALUES (6338, 1869, 2, NULL, '2014-12-20 17:01:25.535753');
INSERT INTO resource_log VALUES (6339, 1869, 2, NULL, '2014-12-20 17:03:12.810766');
INSERT INTO resource_log VALUES (6340, 1869, 2, NULL, '2014-12-20 17:03:22.550854');
INSERT INTO resource_log VALUES (6341, 1628, 2, NULL, '2014-12-20 17:05:00.135486');
INSERT INTO resource_log VALUES (6342, 1869, 2, NULL, '2014-12-20 17:05:08.130568');
INSERT INTO resource_log VALUES (6343, 1626, 2, NULL, '2014-12-20 17:50:11.179188');
INSERT INTO resource_log VALUES (6344, 1615, 2, NULL, '2014-12-20 17:50:33.508978');
INSERT INTO resource_log VALUES (6345, 1954, 2, NULL, '2014-12-20 18:18:17.329483');
INSERT INTO resource_log VALUES (6346, 1954, 2, NULL, '2014-12-20 18:18:27.668631');
INSERT INTO resource_log VALUES (6347, 1953, 2, NULL, '2014-12-20 18:19:03.042411');
INSERT INTO resource_log VALUES (6348, 1955, 2, NULL, '2014-12-20 20:57:13.189777');
INSERT INTO resource_log VALUES (6349, 1225, 2, NULL, '2014-12-21 12:57:50.837529');
INSERT INTO resource_log VALUES (6350, 1433, 2, NULL, '2014-12-21 12:57:59.036844');
INSERT INTO resource_log VALUES (6351, 1954, 2, NULL, '2014-12-21 13:04:30.43023');
INSERT INTO resource_log VALUES (6352, 1955, 2, NULL, '2014-12-21 14:01:21.220851');
INSERT INTO resource_log VALUES (6353, 1955, 2, NULL, '2014-12-21 14:02:48.391182');
INSERT INTO resource_log VALUES (6354, 1955, 2, NULL, '2014-12-21 14:05:59.186502');
INSERT INTO resource_log VALUES (6355, 1956, 2, NULL, '2014-12-21 14:58:01.627945');
INSERT INTO resource_log VALUES (6356, 1383, 2, NULL, '2014-12-21 14:58:04.4436');
INSERT INTO resource_log VALUES (6357, 1383, 2, NULL, '2014-12-21 14:58:18.134114');
INSERT INTO resource_log VALUES (6358, 1955, 2, NULL, '2014-12-21 14:58:54.05088');
INSERT INTO resource_log VALUES (6359, 1955, 2, NULL, '2014-12-21 14:59:43.024479');
INSERT INTO resource_log VALUES (6360, 1955, 2, NULL, '2014-12-21 15:01:24.559119');
INSERT INTO resource_log VALUES (6361, 1955, 2, NULL, '2014-12-21 15:02:30.825094');
INSERT INTO resource_log VALUES (6362, 1955, 2, NULL, '2014-12-21 15:03:19.517473');
INSERT INTO resource_log VALUES (6363, 1955, 2, NULL, '2014-12-21 15:04:26.227416');
INSERT INTO resource_log VALUES (6364, 1955, 2, NULL, '2014-12-21 15:05:25.219884');
INSERT INTO resource_log VALUES (6365, 1955, 2, NULL, '2014-12-21 15:08:14.659941');
INSERT INTO resource_log VALUES (6366, 1955, 2, NULL, '2014-12-21 15:09:18.610638');
INSERT INTO resource_log VALUES (6367, 1955, 2, NULL, '2014-12-21 15:10:49.564969');
INSERT INTO resource_log VALUES (6368, 1955, 2, NULL, '2014-12-21 15:18:30.435377');
INSERT INTO resource_log VALUES (6369, 1955, 2, NULL, '2014-12-21 15:28:30.828306');
INSERT INTO resource_log VALUES (6370, 1955, 2, NULL, '2014-12-21 15:30:55.116621');
INSERT INTO resource_log VALUES (6371, 1955, 2, NULL, '2014-12-21 15:33:38.056888');
INSERT INTO resource_log VALUES (6372, 1955, 2, NULL, '2014-12-21 15:34:45.870649');
INSERT INTO resource_log VALUES (6373, 1955, 2, NULL, '2014-12-21 15:55:27.822121');
INSERT INTO resource_log VALUES (6374, 1955, 2, NULL, '2014-12-21 15:56:45.477441');
INSERT INTO resource_log VALUES (6375, 1955, 2, NULL, '2014-12-21 15:57:54.588037');
INSERT INTO resource_log VALUES (6376, 1955, 2, NULL, '2014-12-21 15:59:56.190169');
INSERT INTO resource_log VALUES (6377, 1955, 2, NULL, '2014-12-21 16:10:48.898101');
INSERT INTO resource_log VALUES (6378, 1955, 2, NULL, '2014-12-21 16:11:31.348869');
INSERT INTO resource_log VALUES (6379, 1955, 2, NULL, '2014-12-21 16:12:17.283128');
INSERT INTO resource_log VALUES (6380, 1955, 2, NULL, '2014-12-21 16:12:43.349159');
INSERT INTO resource_log VALUES (6381, 1955, 2, NULL, '2014-12-21 16:17:53.680374');
INSERT INTO resource_log VALUES (6382, 1955, 2, NULL, '2014-12-21 16:18:30.615045');
INSERT INTO resource_log VALUES (6383, 1955, 2, NULL, '2014-12-21 16:24:07.556851');
INSERT INTO resource_log VALUES (6384, 1955, 2, NULL, '2014-12-21 16:24:36.284901');
INSERT INTO resource_log VALUES (6385, 1955, 2, NULL, '2014-12-21 16:25:59.736532');
INSERT INTO resource_log VALUES (6386, 1955, 2, NULL, '2014-12-21 16:26:10.717535');
INSERT INTO resource_log VALUES (6387, 1958, 2, NULL, '2014-12-21 19:20:00.336409');
INSERT INTO resource_log VALUES (6388, 1958, 2, NULL, '2014-12-21 19:40:10.412709');
INSERT INTO resource_log VALUES (6389, 1958, 2, NULL, '2014-12-21 19:43:18.014602');
INSERT INTO resource_log VALUES (6390, 1955, 2, NULL, '2014-12-21 19:54:47.763979');
INSERT INTO resource_log VALUES (6391, 1955, 2, NULL, '2014-12-21 19:57:15.899119');
INSERT INTO resource_log VALUES (6392, 1955, 2, NULL, '2014-12-21 20:01:57.931475');
INSERT INTO resource_log VALUES (6393, 1962, 2, NULL, '2014-12-24 21:32:53.618984');
INSERT INTO resource_log VALUES (6394, 1955, 2, NULL, '2014-12-24 21:52:53.75341');
INSERT INTO resource_log VALUES (6395, 1955, 2, NULL, '2014-12-24 21:54:29.381242');
INSERT INTO resource_log VALUES (6396, 1955, 2, NULL, '2014-12-24 21:54:40.852567');
INSERT INTO resource_log VALUES (6397, 1955, 2, NULL, '2014-12-24 21:59:02.013042');
INSERT INTO resource_log VALUES (6398, 1955, 2, NULL, '2014-12-24 23:47:49.852576');
INSERT INTO resource_log VALUES (6399, 1955, 2, NULL, '2014-12-24 23:57:47.039863');
INSERT INTO resource_log VALUES (6400, 1964, 2, NULL, '2014-12-25 21:05:49.345482');
INSERT INTO resource_log VALUES (6401, 1955, 2, NULL, '2014-12-26 20:17:47.53662');
INSERT INTO resource_log VALUES (6402, 1955, 2, NULL, '2014-12-26 20:29:33.803173');
INSERT INTO resource_log VALUES (6403, 1955, 2, NULL, '2014-12-26 20:31:12.755178');
INSERT INTO resource_log VALUES (6404, 1955, 2, NULL, '2014-12-26 20:32:53.259365');
INSERT INTO resource_log VALUES (6405, 1955, 2, NULL, '2014-12-26 20:34:24.850656');
INSERT INTO resource_log VALUES (6406, 1955, 2, NULL, '2014-12-26 20:36:11.286672');
INSERT INTO resource_log VALUES (6407, 1955, 2, NULL, '2014-12-26 20:37:54.248513');
INSERT INTO resource_log VALUES (6408, 1955, 2, NULL, '2014-12-26 22:13:17.525737');
INSERT INTO resource_log VALUES (6409, 1955, 2, NULL, '2014-12-26 22:24:22.10607');
INSERT INTO resource_log VALUES (6410, 1955, 2, NULL, '2014-12-26 22:28:42.906736');
INSERT INTO resource_log VALUES (6411, 1317, 2, NULL, '2014-12-27 14:48:10.519499');
INSERT INTO resource_log VALUES (6412, 1840, 2, NULL, '2014-12-27 16:05:27.016889');
INSERT INTO resource_log VALUES (6413, 1840, 2, NULL, '2014-12-27 16:32:05.180181');
INSERT INTO resource_log VALUES (6414, 1840, 2, NULL, '2014-12-27 16:45:52.831401');
INSERT INTO resource_log VALUES (6415, 1966, 2, NULL, '2014-12-27 19:34:56.371248');
INSERT INTO resource_log VALUES (6416, 1955, 2, NULL, '2014-12-28 18:35:17.644826');
INSERT INTO resource_log VALUES (6417, 1955, 2, NULL, '2014-12-28 19:17:37.697477');
INSERT INTO resource_log VALUES (6418, 1966, 2, NULL, '2014-12-31 19:10:29.989911');
INSERT INTO resource_log VALUES (6420, 1968, 2, NULL, '2015-01-03 12:32:10.846571');
INSERT INTO resource_log VALUES (6422, 1970, 2, NULL, '2015-01-03 12:35:21.670372');
INSERT INTO resource_log VALUES (6423, 1971, 2, NULL, '2015-01-04 12:45:51.571627');
INSERT INTO resource_log VALUES (6424, 1840, 2, NULL, '2015-01-04 12:45:53.947837');
INSERT INTO resource_log VALUES (6425, 1971, 2, NULL, '2015-01-04 12:46:35.715575');
INSERT INTO resource_log VALUES (6426, 1971, 2, NULL, '2015-01-04 14:05:54.230775');
INSERT INTO resource_log VALUES (6428, 1975, 2, NULL, '2015-01-04 14:47:53.838979');
INSERT INTO resource_log VALUES (6429, 1976, 2, NULL, '2015-01-04 15:06:13.604725');
INSERT INTO resource_log VALUES (6430, 1977, 2, NULL, '2015-01-04 16:44:50.635763');
INSERT INTO resource_log VALUES (6431, 1975, 2, NULL, '2015-01-04 16:54:32.711408');
INSERT INTO resource_log VALUES (6432, 1975, 2, NULL, '2015-01-04 17:11:52.039507');
INSERT INTO resource_log VALUES (6433, 1975, 2, NULL, '2015-01-04 17:31:46.570967');
INSERT INTO resource_log VALUES (6434, 1975, 2, NULL, '2015-01-07 14:12:48.405815');
INSERT INTO resource_log VALUES (6435, 1975, 2, NULL, '2015-01-07 14:22:19.046581');
INSERT INTO resource_log VALUES (6436, 1978, 2, NULL, '2015-01-07 18:00:22.111119');
INSERT INTO resource_log VALUES (6437, 1979, 2, NULL, '2015-01-07 18:22:39.961593');
INSERT INTO resource_log VALUES (6438, 1980, 2, NULL, '2015-01-07 18:22:48.978415');
INSERT INTO resource_log VALUES (6439, 1981, 2, NULL, '2015-01-07 18:23:19.524712');
INSERT INTO resource_log VALUES (6440, 3, 2, NULL, '2015-01-07 18:23:30.384627');
INSERT INTO resource_log VALUES (6441, 1982, 2, NULL, '2015-01-07 18:30:42.662112');
INSERT INTO resource_log VALUES (6442, 3, 2, NULL, '2015-01-07 18:30:49.411934');
INSERT INTO resource_log VALUES (6443, 3, 2, NULL, '2015-01-07 18:31:24.902432');
INSERT INTO resource_log VALUES (6444, 784, 2, NULL, '2015-01-08 13:21:17.321066');
INSERT INTO resource_log VALUES (6445, 784, 2, NULL, '2015-01-08 13:27:01.529898');
INSERT INTO resource_log VALUES (6446, 784, 2, NULL, '2015-01-08 14:19:17.153858');
INSERT INTO resource_log VALUES (6447, 784, 2, NULL, '2015-01-08 14:20:23.527059');
INSERT INTO resource_log VALUES (6448, 784, 2, NULL, '2015-01-09 10:59:22.101268');
INSERT INTO resource_log VALUES (6449, 1046, 2, NULL, '2015-01-12 22:16:18.421621');
INSERT INTO resource_log VALUES (6450, 1046, 2, NULL, '2015-01-12 22:16:29.774766');
INSERT INTO resource_log VALUES (6451, 1046, 2, NULL, '2015-01-12 22:18:02.620143');
INSERT INTO resource_log VALUES (6452, 1046, 2, NULL, '2015-01-13 17:00:13.07184');
INSERT INTO resource_log VALUES (6453, 1983, 2, NULL, '2015-01-13 17:00:57.932019');
INSERT INTO resource_log VALUES (6454, 1985, 2, NULL, '2015-01-13 17:03:06.725248');
INSERT INTO resource_log VALUES (6455, 1985, 2, NULL, '2015-01-14 21:32:00.651438');
INSERT INTO resource_log VALUES (6456, 1046, 2, NULL, '2015-01-14 21:35:47.291833');
INSERT INTO resource_log VALUES (6457, 1987, 2, NULL, '2015-01-15 20:30:02.464255');
INSERT INTO resource_log VALUES (6458, 1988, 2, NULL, '2015-01-15 21:27:50.402917');
INSERT INTO resource_log VALUES (6459, 1989, 2, NULL, '2015-01-17 15:06:55.170629');
INSERT INTO resource_log VALUES (6460, 1990, 2, NULL, '2015-01-17 19:50:58.298272');
INSERT INTO resource_log VALUES (6461, 1991, 2, NULL, '2015-01-17 19:50:58.298272');
INSERT INTO resource_log VALUES (6462, 1992, 2, NULL, '2015-01-17 19:51:20.956564');
INSERT INTO resource_log VALUES (6463, 1990, 2, NULL, '2015-01-17 21:28:18.900625');
INSERT INTO resource_log VALUES (6464, 1993, 2, NULL, '2015-01-17 21:28:36.972519');
INSERT INTO resource_log VALUES (6465, 1994, 2, NULL, '2015-01-17 21:50:01.04394');
INSERT INTO resource_log VALUES (6466, 1995, 2, NULL, '2015-01-17 21:50:14.61181');
INSERT INTO resource_log VALUES (6467, 1996, 2, NULL, '2015-01-17 21:54:58.910426');
INSERT INTO resource_log VALUES (6468, 1997, 2, NULL, '2015-01-17 21:54:58.910426');
INSERT INTO resource_log VALUES (6469, 1998, 2, NULL, '2015-01-17 21:56:22.636605');
INSERT INTO resource_log VALUES (6470, 1999, 2, NULL, '2015-01-17 21:56:29.416802');
INSERT INTO resource_log VALUES (6471, 2000, 2, NULL, '2015-01-17 21:56:46.645017');
INSERT INTO resource_log VALUES (6472, 2001, 2, NULL, '2015-01-17 21:57:17.28338');
INSERT INTO resource_log VALUES (6473, 2002, 2, NULL, '2015-01-17 21:57:17.28338');
INSERT INTO resource_log VALUES (6474, 2003, 2, NULL, '2015-01-17 21:58:51.890926');
INSERT INTO resource_log VALUES (6475, 2004, 2, NULL, '2015-01-17 21:58:54.962002');
INSERT INTO resource_log VALUES (6476, 2005, 2, NULL, '2015-01-17 22:00:19.139836');
INSERT INTO resource_log VALUES (6477, 2006, 2, NULL, '2015-01-17 22:00:39.986496');
INSERT INTO resource_log VALUES (6478, 2007, 2, NULL, '2015-01-17 22:00:39.986496');
INSERT INTO resource_log VALUES (6479, 2000, 2, NULL, '2015-01-17 22:01:41.277766');


--
-- Data for Name: resource_type; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO resource_type VALUES (117, 1797, 'subaccounts', 'Subaccounts', 'Subaccounts', 'travelcrm.resources.subaccounts', 'Subaccounts are accounts from other objects such as clients, touroperators and so on', 'null', false);
INSERT INTO resource_type VALUES (107, 1435, 'accounts', 'Accounts', 'Accounts', 'travelcrm.resources.accounts', 'Billing Accounts. It can be bank accouts, cash accounts etc. and has company wide visible', 'null', false);
INSERT INTO resource_type VALUES (118, 1799, 'notes', 'Notes', 'Notes', 'travelcrm.resources.notes', 'Resources Notes', 'null', false);
INSERT INTO resource_type VALUES (92, 1221, 'tours_sales', 'Tours Sale', 'ToursSales', 'travelcrm.resources.tours_sales', 'Tours sales documents', '{"service_id": 5}', true);
INSERT INTO resource_type VALUES (119, 1849, 'calculations', 'Caluclations', 'Calculations', 'travelcrm.resources.calculations', 'Calculations of Sale Documents', 'null', false);
INSERT INTO resource_type VALUES (120, 1884, 'crosspayments', 'Cross Payments', 'Crosspayments', 'travelcrm.resources.crosspayments', 'Cross payments between accounts and subaccounts. This document is for balance corrections to.', 'null', false);
INSERT INTO resource_type VALUES (121, 1894, 'turnovers', 'Turnovers', 'Turnovers', 'travelcrm.resources.turnovers', 'Turnovers on Accounts and Subaccounts', 'null', false);
INSERT INTO resource_type VALUES (2, 10, 'users', 'Users', 'Users', 'travelcrm.resources.users', 'Users list', NULL, false);
INSERT INTO resource_type VALUES (12, 16, 'resources_types', 'Resources Types', 'ResourcesTypes', 'travelcrm.resources.resources_types', 'Resources types list', NULL, false);
INSERT INTO resource_type VALUES (47, 706, 'employees', 'Employees', 'Employees', 'travelcrm.resources.employees', 'Employees Container Datagrid', NULL, false);
INSERT INTO resource_type VALUES (78, 1003, 'touroperators', 'Touroperators', 'Touroperators', 'travelcrm.resources.touroperators', 'Touroperators - tours suppliers list', NULL, false);
INSERT INTO resource_type VALUES (1, 773, '', 'Home', 'Root', 'travelcrm.resources', 'Home Page of Travelcrm', NULL, false);
INSERT INTO resource_type VALUES (122, 1919, 'debts', 'Debts', 'Debts', 'travelcrm.resources.debts', 'Calculations based debts report', 'null', false);
INSERT INTO resource_type VALUES (93, 1225, 'tasks', 'Tasks', 'Tasks', 'travelcrm.resources.tasks', 'Task manager', NULL, false);
INSERT INTO resource_type VALUES (106, 1433, 'incomes', 'Incomes', 'Incomes', 'travelcrm.resources.incomes', 'Incomes Payments Document for invoices', '{"account_item_id": 8}', false);
INSERT INTO resource_type VALUES (41, 283, 'currencies', 'Currencies', 'Currencies', 'travelcrm.resources.currencies', '', NULL, false);
INSERT INTO resource_type VALUES (55, 723, 'structures', 'Structures', 'Structures', 'travelcrm.resources.structures', 'Companies structures is a tree of company structure. It''s can be offices, filials, departments and so and so', NULL, false);
INSERT INTO resource_type VALUES (59, 764, 'positions', 'Positions', 'Positions', 'travelcrm.resources.positions', 'Companies positions is a point of company structure where emplyees can be appointed', NULL, false);
INSERT INTO resource_type VALUES (61, 769, 'permisions', 'Permisions', 'Permisions', 'travelcrm.resources.permisions', 'Permisions list of company structure position. It''s list of resources and permisions', NULL, false);
INSERT INTO resource_type VALUES (65, 775, 'navigations', 'Navigations', 'Navigations', 'travelcrm.resources.navigations', 'Navigations list of company structure position.', NULL, false);
INSERT INTO resource_type VALUES (67, 788, 'appointments', 'Appointments', 'Appointments', 'travelcrm.resources.appointments', 'Employees to positions of company appointments', NULL, false);
INSERT INTO resource_type VALUES (39, 274, 'regions', 'Regions', 'Regions', 'travelcrm.resources.regions', '', NULL, false);
INSERT INTO resource_type VALUES (70, 872, 'countries', 'Countries', 'Countries', 'travelcrm.resources.countries', 'Countries directory', NULL, false);
INSERT INTO resource_type VALUES (71, 901, 'advsources', 'Advertise Sources', 'Advsources', 'travelcrm.resources.advsources', 'Types of advertises', NULL, false);
INSERT INTO resource_type VALUES (72, 908, 'hotelcats', 'Hotels Categories', 'Hotelcats', 'travelcrm.resources.hotelcats', 'Hotels categories', NULL, false);
INSERT INTO resource_type VALUES (73, 909, 'roomcats', 'Rooms Categories', 'Roomcats', 'travelcrm.resources.roomcats', 'Categories of the rooms', NULL, false);
INSERT INTO resource_type VALUES (74, 953, 'accomodations', 'Accomodations', 'Accomodations', 'travelcrm.resources.accomodations', 'Accomodations Types list', NULL, false);
INSERT INTO resource_type VALUES (75, 954, 'foodcats', 'Food Categories', 'Foodcats', 'travelcrm.resources.foodcats', 'Food types in hotels', NULL, false);
INSERT INTO resource_type VALUES (69, 865, 'persons', 'Persons', 'Persons', 'travelcrm.resources.persons', 'Persons directory. Person can be client or potential client', NULL, false);
INSERT INTO resource_type VALUES (79, 1007, 'bpersons', 'Business Persons', 'BPersons', 'travelcrm.resources.bpersons', 'Business Persons is not clients it''s simple business contacts that can be referenced objects that needs to have contacts', NULL, false);
INSERT INTO resource_type VALUES (84, 1088, 'locations', 'Locations', 'Locations', 'travelcrm.resources.locations', 'Locations list is list of cities, vilages etc. places to use to identify part of region', NULL, false);
INSERT INTO resource_type VALUES (83, 1081, 'hotels', 'Hotels', 'Hotels', 'travelcrm.resources.hotels', 'Hotels directory', NULL, false);
INSERT INTO resource_type VALUES (86, 1189, 'licences', 'Licences', 'Licences', 'travelcrm.resources.licences', 'Licences list for any type of resources as need', NULL, false);
INSERT INTO resource_type VALUES (87, 1190, 'contacts', 'Contacts', 'Contacts', 'travelcrm.resources.contacts', 'Contacts for persons, business persons etc.', NULL, false);
INSERT INTO resource_type VALUES (89, 1198, 'passports', 'Passports', 'Passports', 'travelcrm.resources.passports', 'Clients persons passports lists', NULL, false);
INSERT INTO resource_type VALUES (90, 1207, 'addresses', 'Addresses', 'Addresses', 'travelcrm.resources.addresses', 'Addresses of any type of resources, such as persons, bpersons, hotels etc.', NULL, false);
INSERT INTO resource_type VALUES (91, 1211, 'banks', 'Banks', 'Banks', 'travelcrm.resources.banks', 'Banks list to create bank details and for other reasons', NULL, false);
INSERT INTO resource_type VALUES (102, 1313, 'services', 'Services', 'Services', 'travelcrm.resources.services', 'Additional Services that can be provide with tours sales or separate', NULL, false);
INSERT INTO resource_type VALUES (101, 1268, 'banks_details', 'Banks Details', 'BanksDetails', 'travelcrm.resources.banks_details', 'Banks Details that can be attached to any client or business partner to define account', NULL, false);
INSERT INTO resource_type VALUES (104, 1393, 'currencies_rates', 'Currency Rates', 'CurrenciesRates', 'travelcrm.resources.currencies_rates', 'Currencies Rates. Values from this dir used by billing to calc prices in base currency.', NULL, false);
INSERT INTO resource_type VALUES (105, 1424, 'accounts_items', 'Account Items', 'AccountsItems', 'travelcrm.resources.accounts_items', 'Finance accounts items', NULL, false);
INSERT INTO resource_type VALUES (109, 1452, 'services_sales', 'Services Sale', 'ServicesSales', 'travelcrm.resources.services_sales', 'Additionals Services sales document. It is Invoicable objects and can generate contracts', 'null', false);
INSERT INTO resource_type VALUES (108, 1450, 'services_items', 'Service Item', 'ServicesItems', 'travelcrm.resources.services_items', 'Services Items List for include in sales documents such as Tours, Services Sales etc.', 'null', false);
INSERT INTO resource_type VALUES (110, 1521, 'commissions', 'Commissions', 'Commissions', 'travelcrm.resources.commissions', 'Services sales commissions', 'null', false);
INSERT INTO resource_type VALUES (112, 1549, 'suppliers', 'Suppliers', 'Suppliers', 'travelcrm.resources.suppliers', 'Suppliers for other services except tours services', 'null', false);
INSERT INTO resource_type VALUES (111, 1548, 'outgoings', 'Outgoings', 'Outgoings', 'travelcrm.resources.outgoings', 'Outgoings payments for touroperators, suppliers, payback payments and so on', 'null', false);
INSERT INTO resource_type VALUES (123, 1941, 'notifications', 'Notifications', 'Notifications', 'travelcrm.resources.notifications', 'Employee Notifications', 'null', false);
INSERT INTO resource_type VALUES (128, 1977, 'companies_settings', 'Companies Settings', 'CompaniesSettings', 'travelcrm.resources.companies_settings', 'Companies Settings', 'null', false);
INSERT INTO resource_type VALUES (124, 1954, 'emails_campaigns', 'Email Campaigns', 'EmailsCampaigns', 'travelcrm.resources.emails_campaigns', 'Emails Campaigns for subscribers', '{"timeout": 12}', true);
INSERT INTO resource_type VALUES (129, 1989, 'sales_dynamics', 'Portlet: Sales Dynamics', 'SalesDynamics', 'travelcrm.resources.sales_dynamics', 'Portlet that shows dynamics of sales in quantity', '{"column_index": 0}', true);
INSERT INTO resource_type VALUES (103, 1317, 'invoices', 'Invoices', 'Invoices', 'travelcrm.resources.invoices', 'Invoices list. Invoice can''t be created manualy - only using source document such as Tours', '{"active_days": 3}', true);
INSERT INTO resource_type VALUES (125, 1966, 'unpaid_invoices', 'Portlet: Unpaid Invoices', 'UnpaidInvoices', 'travelcrm.resources.unpaid_invoices', 'Portlet that shows invoices which has no any pay and active date is over', '{"column_index": 1}', true);
INSERT INTO resource_type VALUES (126, 1968, 'companies', 'Companies', 'Companies', 'travelcrm.resources.companies', 'Multicompanies functionality', 'null', false);


--
-- Data for Name: roomcat; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO roomcat VALUES (2, 921, 'BDR');
INSERT INTO roomcat VALUES (3, 922, 'BDRM');
INSERT INTO roomcat VALUES (4, 923, 'Superior');
INSERT INTO roomcat VALUES (5, 924, 'Studio');
INSERT INTO roomcat VALUES (6, 925, 'Family Room');
INSERT INTO roomcat VALUES (7, 926, 'Family Studio');
INSERT INTO roomcat VALUES (8, 927, 'Extra Bed');
INSERT INTO roomcat VALUES (9, 928, 'Suite');
INSERT INTO roomcat VALUES (10, 929, 'Suite Mini');
INSERT INTO roomcat VALUES (11, 930, 'Junior Suite');
INSERT INTO roomcat VALUES (12, 931, 'De Luxe');
INSERT INTO roomcat VALUES (13, 932, 'Executive Suite');
INSERT INTO roomcat VALUES (14, 933, 'Suite Senior');
INSERT INTO roomcat VALUES (16, 935, 'Honeymoon Room');
INSERT INTO roomcat VALUES (17, 936, 'Connected Rooms');
INSERT INTO roomcat VALUES (18, 937, 'Duplex');
INSERT INTO roomcat VALUES (19, 938, 'Apartment');
INSERT INTO roomcat VALUES (20, 939, 'President');
INSERT INTO roomcat VALUES (21, 940, 'Balcony');
INSERT INTO roomcat VALUES (22, 941, 'City View');
INSERT INTO roomcat VALUES (23, 942, 'Beach View');
INSERT INTO roomcat VALUES (24, 943, 'Pool View');
INSERT INTO roomcat VALUES (25, 944, 'Garden View');
INSERT INTO roomcat VALUES (26, 945, 'Ocean View');
INSERT INTO roomcat VALUES (27, 946, 'Land View');
INSERT INTO roomcat VALUES (28, 947, 'Dune View');
INSERT INTO roomcat VALUES (29, 948, 'Mountain View');
INSERT INTO roomcat VALUES (30, 949, 'Park View');
INSERT INTO roomcat VALUES (31, 950, 'SV (Sea view)');
INSERT INTO roomcat VALUES (33, 952, 'Inside View');


--
-- Name: roomcat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('roomcat_id_seq', 33, true);


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO service VALUES (4, 1318, 'A visa', NULL, NULL, 2);
INSERT INTO service VALUES (3, 1316, 'Travel Insurance', 'Travel Insurance price is custom.', NULL, 2);
INSERT INTO service VALUES (1, 1314, 'Foreign Passport Service', NULL, NULL, 2);
INSERT INTO service VALUES (5, 1413, 'Tour', NULL, 'Advance payment for travel services', 1);


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('service_id_seq', 6, true);


--
-- Data for Name: service_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO service_item VALUES (9, 1462, 4, 57, 5, 60.00, 21, 726.00);
INSERT INTO service_item VALUES (10, 1463, 4, 57, 5, 60.00, 20, 726.00);
INSERT INTO service_item VALUES (25, 1629, 3, 57, 2, 5.00, 40, 60.00);
INSERT INTO service_item VALUES (26, 1631, 3, 57, 2, 5.00, 39, 60.00);
INSERT INTO service_item VALUES (27, 1632, 3, 57, 2, 10.00, 38, 120.00);
INSERT INTO service_item VALUES (28, 1633, 3, 57, 2, 10.00, 37, 120.00);
INSERT INTO service_item VALUES (29, 1654, 4, 54, 57, 300.00, 41, 5460.00);
INSERT INTO service_item VALUES (30, 1655, 4, 54, 57, 300.00, 42, 5460.00);
INSERT INTO service_item VALUES (24, 1618, 1, 57, 1, 80.00, 35, 960.00);
INSERT INTO service_item VALUES (31, 1758, 1, 57, 1, 45.00, 38, 540.00);
INSERT INTO service_item VALUES (3, 1455, 4, 54, 1, 20.00, 21, 334.00);
INSERT INTO service_item VALUES (17, 1481, 1, 57, 1, 54.00, 20, 653.40);
INSERT INTO service_item VALUES (18, 1482, 1, 57, 1, 54.00, 21, 653.40);
INSERT INTO service_item VALUES (19, 1483, 4, 54, 1, 20.00, 20, 334.00);
INSERT INTO service_item VALUES (11, 1474, 3, 54, 1, 10.00, 32, 167.00);
INSERT INTO service_item VALUES (12, 1475, 3, 54, 1, 10.00, 31, 167.00);
INSERT INTO service_item VALUES (13, 1476, 3, 54, 1, 20.00, 29, 334.00);
INSERT INTO service_item VALUES (14, 1477, 3, 54, 1, 20.00, 30, 334.00);
INSERT INTO service_item VALUES (15, 1478, 1, 57, 1, 54.00, 29, 648.00);
INSERT INTO service_item VALUES (16, 1479, 1, 57, 1, 54.00, 30, 648.00);
INSERT INTO service_item VALUES (20, 1520, 3, 56, 57, 12.00, 30, 0.00);
INSERT INTO service_item VALUES (1, 1453, 4, 57, 57, 60.00, 21, 0.00);
INSERT INTO service_item VALUES (2, 1454, 4, 57, 5, 60.00, 20, 0.00);
INSERT INTO service_item VALUES (4, 1457, 3, 57, 2, 20.00, 20, 0.00);
INSERT INTO service_item VALUES (5, 1458, 3, 57, 5, 20.00, 27, 0.00);
INSERT INTO service_item VALUES (6, 1459, 4, 54, 1, 60.00, 20, 0.00);
INSERT INTO service_item VALUES (7, 1460, 1, 57, 5, 100.00, 25, 0.00);
INSERT INTO service_item VALUES (8, 1461, 3, 54, 57, 67.00, 6, 0.00);
INSERT INTO service_item VALUES (21, 1595, 4, 54, 57, 43.00, 34, 782.60);
INSERT INTO service_item VALUES (22, 1596, 4, 54, 62, 45.00, 33, 819.00);
INSERT INTO service_item VALUES (23, 1600, 4, 54, 62, 45.00, 34, 819.00);
INSERT INTO service_item VALUES (40, 1848, 5, 54, 5, 2350.00, 17, 39010.00);
INSERT INTO service_item VALUES (33, 1841, 5, 56, 57, 64576.00, 41, 64576.00);
INSERT INTO service_item VALUES (34, 1842, 5, 57, 2, 2490.00, 37, 29880.00);
INSERT INTO service_item VALUES (35, 1843, 5, 57, 2, 1475.00, 35, 17700.00);
INSERT INTO service_item VALUES (36, 1844, 5, 54, 62, 3569.00, 33, 64955.80);
INSERT INTO service_item VALUES (37, 1845, 5, 54, 1, 3556.00, 29, 59385.20);
INSERT INTO service_item VALUES (38, 1846, 5, 56, 61, 8520.00, 25, 8520.00);
INSERT INTO service_item VALUES (39, 1847, 5, 54, 1, 3534.00, 20, 59017.80);
INSERT INTO service_item VALUES (41, 1929, 5, 56, 5, 23000.00, 30, 23000.00);
INSERT INTO service_item VALUES (42, 1998, 4, 56, 63, 750.00, 43, 750.00);
INSERT INTO service_item VALUES (43, 2003, 3, 56, 61, 3450.00, 6, 3450.00);


--
-- Name: service_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('service_item_id_seq', 43, true);


--
-- Data for Name: service_sale; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO service_sale VALUES (1, '2014-06-09', 1456, 20, 6);
INSERT INTO service_sale VALUES (2, '2014-09-14', 1759, 40, 5);
INSERT INTO service_sale VALUES (3, '2015-01-16', 1999, 43, 5);
INSERT INTO service_sale VALUES (4, '2015-01-14', 2004, 6, 4);


--
-- Name: service_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('service_sale_id_seq', 4, true);


--
-- Data for Name: service_sale_invoice; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO service_sale_invoice VALUES (1, 13);
INSERT INTO service_sale_invoice VALUES (2, 21);
INSERT INTO service_sale_invoice VALUES (3, 23);
INSERT INTO service_sale_invoice VALUES (4, 24);


--
-- Data for Name: service_sale_service_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO service_sale_service_item VALUES (1, 3);
INSERT INTO service_sale_service_item VALUES (1, 19);
INSERT INTO service_sale_service_item VALUES (1, 18);
INSERT INTO service_sale_service_item VALUES (1, 17);
INSERT INTO service_sale_service_item VALUES (2, 31);
INSERT INTO service_sale_service_item VALUES (3, 42);
INSERT INTO service_sale_service_item VALUES (4, 43);


--
-- Data for Name: structure; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO structure VALUES (2, 858, NULL, 'Kiev Office', 1);
INSERT INTO structure VALUES (3, 859, 2, 'Sales Department', 1);
INSERT INTO structure VALUES (4, 860, 32, 'Marketing Dep.', 1);
INSERT INTO structure VALUES (1, 857, 32, 'Software Dev. Dep.', 1);
INSERT INTO structure VALUES (5, 861, 32, 'CEO', 1);
INSERT INTO structure VALUES (7, 1062, NULL, 'Moscow Office', 1);
INSERT INTO structure VALUES (8, 1250, NULL, 'Odessa Office', 1);
INSERT INTO structure VALUES (9, 1251, 8, 'Sales Department', 1);
INSERT INTO structure VALUES (11, 1277, NULL, 'Lviv Office', 1);
INSERT INTO structure VALUES (32, 725, NULL, 'Head Office', 1);
INSERT INTO structure VALUES (13, 1976, NULL, 'Dnepropetrovsk Office', 1);


--
-- Data for Name: structure_address; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO structure_address VALUES (32, 31);


--
-- Data for Name: structure_bank_detail; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: structure_contact; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: structures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('structures_id_seq', 13, true);


--
-- Data for Name: subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO subaccount VALUES (1, 1865, 4, 'Vitalii Mazur EUR | cash', NULL);
INSERT INTO subaccount VALUES (2, 1866, 2, 'News Travel | Bank', NULL);
INSERT INTO subaccount VALUES (3, 1867, 4, 'Alexander Karpenko | EUR', NULL);
INSERT INTO subaccount VALUES (4, 1868, 3, 'Garkaviy Andriy | UAH', NULL);
INSERT INTO subaccount VALUES (6, 1875, 3, 'Main Cash Account | rid: 1628', NULL);
INSERT INTO subaccount VALUES (8, 1881, 3, 'Main Cash Account | rid: 1372', NULL);
INSERT INTO subaccount VALUES (9, 1888, 2, 'Lun Real Estate | UAH', 'Month Rate');
INSERT INTO subaccount VALUES (10, 1902, 3, 'Lun Real Estate | UAH | CASH', 'Lun on cash account');
INSERT INTO subaccount VALUES (11, 1911, 4, 'Main Cash EUR Account | rid: 1465', NULL);
INSERT INTO subaccount VALUES (12, 1913, 2, 'Sun Marino Trvl | Cash UAH', 'Sun Marino Main Bank Subaccount');
INSERT INTO subaccount VALUES (13, 1991, 3, 'Main Cash Account | rid: 1471', NULL);
INSERT INTO subaccount VALUES (14, 1997, 3, 'Main Cash Account | rid: 1645', NULL);
INSERT INTO subaccount VALUES (15, 2002, 3, 'Main Cash Account | rid: 1869', NULL);
INSERT INTO subaccount VALUES (16, 2007, 3, 'Main Cash Account | rid: 887', NULL);


--
-- Name: subaccount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('subaccount_id_seq', 16, true);


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO supplier VALUES (5, 1567, 'Intertelecom');
INSERT INTO supplier VALUES (6, 1568, 'Lun Real Estate');


--
-- Data for Name: supplier_bank_detail; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO supplier_bank_detail VALUES (6, 15);
INSERT INTO supplier_bank_detail VALUES (5, 16);


--
-- Data for Name: supplier_bperson; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO supplier_bperson VALUES (6, 7);
INSERT INTO supplier_bperson VALUES (5, 5);
INSERT INTO supplier_bperson VALUES (5, 6);


--
-- Name: supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('supplier_id_seq', 6, true);


--
-- Data for Name: suppplier_subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO suppplier_subaccount VALUES (6, 9);
INSERT INTO suppplier_subaccount VALUES (6, 10);


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO task VALUES (44, 1958, 2, 'Test new scheduler realization', '2014-12-22 19:18:00', '2014-12-21 19:44:00', 'New scheduler realizations notifications test.', false);
INSERT INTO task VALUES (45, 1962, 2, 'Test', '2014-12-24 23:32:00', '2014-12-24 21:33:00', NULL, false);
INSERT INTO task VALUES (46, 1964, 2, 'For testing', '2014-12-25 23:05:00', '2014-12-25 21:06:00', 'For testing purpose only', false);
INSERT INTO task VALUES (47, 1971, 2, 'Check Payments', '2015-01-04 15:45:00', '2015-01-04 14:06:00', NULL, false);
INSERT INTO task VALUES (48, 1980, 2, 'Check Reminder', '2015-01-08 18:21:00', '2015-01-07 18:21:00', 'Description to task', false);
INSERT INTO task VALUES (49, 1982, 2, 'The second task', '2015-01-08 18:30:00', '2015-01-07 18:30:00', 'Second test task', false);
INSERT INTO task VALUES (50, 1983, 2, 'Test', '2015-01-13 17:06:00', '2015-01-13 17:01:00', NULL, false);
INSERT INTO task VALUES (51, 1985, 2, 'Test 2', '2015-01-14 17:02:00', '2015-01-13 17:04:00', NULL, false);
INSERT INTO task VALUES (34, 1923, 2, 'Test 2', '2014-12-16 17:21:00', '2014-12-15 17:42:00', NULL, false);
INSERT INTO task VALUES (33, 1922, 2, 'Test', '2014-12-07 21:36:00', '2014-12-07 20:36:00', 'For testing purpose', false);
INSERT INTO task VALUES (35, 1930, 2, 'Check Person Details', '2014-12-11 21:43:00', '2014-12-10 22:42:00', 'Check if details is correct', false);
INSERT INTO task VALUES (36, 1932, 2, 'Call and remind about payments', '2014-12-11 22:48:00', '2014-12-11 22:46:00', NULL, false);
INSERT INTO task VALUES (38, 1934, 2, 'Call and remind about payment', '2014-12-12 22:50:00', '2014-12-11 22:52:00', 'Call and remind to pay invoice', false);
INSERT INTO task VALUES (39, 1935, 2, 'Review Calculation', '2014-12-12 22:52:00', '2014-12-11 22:55:00', NULL, false);
INSERT INTO task VALUES (41, 1939, 2, 'I have the following code', '2014-12-13 23:36:00', '2014-12-13 22:04:00', NULL, true);
INSERT INTO task VALUES (37, 1933, 2, 'Call and remind about payment', '2014-12-14 22:46:00', '2014-12-14 11:15:00', NULL, false);
INSERT INTO task VALUES (40, 1936, 2, 'For testing Purpose only', '2014-12-14 22:35:00', '2014-12-14 20:32:00', NULL, false);
INSERT INTO task VALUES (42, 1940, 2, 'Test notifications', '2014-12-14 21:37:00', '2014-12-14 20:38:00', NULL, false);


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('task_id_seq', 51, true);


--
-- Data for Name: task_resource; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO task_resource VALUES (39, 1928);
INSERT INTO task_resource VALUES (38, 1928);
INSERT INTO task_resource VALUES (35, 1869);
INSERT INTO task_resource VALUES (47, 1840);
INSERT INTO task_resource VALUES (48, 3);
INSERT INTO task_resource VALUES (49, 3);


--
-- Name: tour_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tour_id_seq', 18, true);


--
-- Name: tour_point_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tour_point_id_seq', 70, true);


--
-- Data for Name: tour_sale; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tour_sale VALUES (15, 15, 15, 2, 0, 35, 1617, '2014-08-31', '2014-08-25', '2014-08-24', 2);
INSERT INTO tour_sale VALUES (14, 15, 15, 2, 0, 33, 1594, '2014-08-31', '2014-08-23', '2014-08-22', 6);
INSERT INTO tour_sale VALUES (13, 15, 15, 2, 2, 29, 1480, '2014-07-20', '2014-07-14', '2014-06-22', 2);
INSERT INTO tour_sale VALUES (12, 14, 14, 2, 2, 25, 1412, '2014-07-25', '2014-07-14', '2014-07-14', 4);
INSERT INTO tour_sale VALUES (10, 15, 15, 2, 0, 20, 1377, '2014-06-07', '2014-06-01', '2014-05-20', 4);
INSERT INTO tour_sale VALUES (9, 15, 15, 2, 1, 17, 1295, '2014-05-09', '2014-05-01', '2014-05-17', 6);
INSERT INTO tour_sale VALUES (16, 15, 15, 2, 2, 37, 1630, '2014-06-09', '2014-08-31', '2014-08-24', 4);
INSERT INTO tour_sale VALUES (17, 15, 15, 2, 0, 41, 1656, '2014-05-09', '2014-08-30', '2014-08-26', 4);
INSERT INTO tour_sale VALUES (18, 33, 34, 2, 0, 30, 1928, '2014-12-13', '2014-12-08', '2014-07-12', 1);


--
-- Data for Name: tour_sale_invoice; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tour_sale_invoice VALUES (10, 8);
INSERT INTO tour_sale_invoice VALUES (9, 10);
INSERT INTO tour_sale_invoice VALUES (13, 14);
INSERT INTO tour_sale_invoice VALUES (12, 15);
INSERT INTO tour_sale_invoice VALUES (14, 16);
INSERT INTO tour_sale_invoice VALUES (15, 17);
INSERT INTO tour_sale_invoice VALUES (17, 19);
INSERT INTO tour_sale_invoice VALUES (16, 20);
INSERT INTO tour_sale_invoice VALUES (18, 22);


--
-- Data for Name: tour_sale_person; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tour_sale_person VALUES (13, 31);
INSERT INTO tour_sale_person VALUES (13, 30);
INSERT INTO tour_sale_person VALUES (13, 29);
INSERT INTO tour_sale_person VALUES (13, 32);
INSERT INTO tour_sale_person VALUES (12, 25);
INSERT INTO tour_sale_person VALUES (12, 26);
INSERT INTO tour_sale_person VALUES (12, 28);
INSERT INTO tour_sale_person VALUES (12, 27);
INSERT INTO tour_sale_person VALUES (10, 20);
INSERT INTO tour_sale_person VALUES (10, 21);
INSERT INTO tour_sale_person VALUES (9, 17);
INSERT INTO tour_sale_person VALUES (9, 18);
INSERT INTO tour_sale_person VALUES (9, 19);
INSERT INTO tour_sale_person VALUES (15, 35);
INSERT INTO tour_sale_person VALUES (15, 36);
INSERT INTO tour_sale_person VALUES (14, 34);
INSERT INTO tour_sale_person VALUES (14, 33);
INSERT INTO tour_sale_person VALUES (16, 40);
INSERT INTO tour_sale_person VALUES (16, 37);
INSERT INTO tour_sale_person VALUES (16, 38);
INSERT INTO tour_sale_person VALUES (16, 39);
INSERT INTO tour_sale_person VALUES (17, 42);
INSERT INTO tour_sale_person VALUES (17, 41);
INSERT INTO tour_sale_person VALUES (18, 41);
INSERT INTO tour_sale_person VALUES (18, 30);


--
-- Data for Name: tour_sale_point; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tour_sale_point VALUES (60, 16, 10, 14, 10, 30, 9, 'All include, Adriatic Sea, excursions and transfer included', '2014-05-09', '2014-05-01');
INSERT INTO tour_sale_point VALUES (61, 27, 27, 10, 11, NULL, 10, NULL, '2014-06-07', '2014-06-01');
INSERT INTO tour_sale_point VALUES (62, 32, 33, 10, 11, 29, NULL, NULL, '2014-07-18', '2014-07-12');
INSERT INTO tour_sale_point VALUES (63, 32, 33, 10, 10, 29, 12, NULL, '2014-07-25', '2014-07-14');
INSERT INTO tour_sale_point VALUES (64, 21, 34, NULL, NULL, NULL, 13, NULL, '2014-07-20', '2014-07-14');
INSERT INTO tour_sale_point VALUES (65, 36, 35, NULL, NULL, NULL, 14, NULL, '2014-08-31', '2014-08-25');
INSERT INTO tour_sale_point VALUES (66, 17, 13, NULL, NULL, NULL, 15, NULL, '2014-08-31', '2014-08-25');
INSERT INTO tour_sale_point VALUES (67, 31, 32, NULL, 10, NULL, 16, NULL, '2014-09-02', '2014-08-31');
INSERT INTO tour_sale_point VALUES (68, 30, 31, NULL, 15, 31, 16, NULL, '2014-09-06', '2014-09-02');
INSERT INTO tour_sale_point VALUES (69, 37, 36, NULL, NULL, NULL, 17, NULL, '2014-09-05', '2014-08-30');
INSERT INTO tour_sale_point VALUES (70, 36, NULL, NULL, NULL, NULL, 18, NULL, '2014-12-13', '2014-07-12');


--
-- Data for Name: tour_sale_service_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tour_sale_service_item VALUES (17, 33);
INSERT INTO tour_sale_service_item VALUES (16, 34);
INSERT INTO tour_sale_service_item VALUES (15, 35);
INSERT INTO tour_sale_service_item VALUES (14, 36);
INSERT INTO tour_sale_service_item VALUES (13, 37);
INSERT INTO tour_sale_service_item VALUES (12, 38);
INSERT INTO tour_sale_service_item VALUES (10, 39);
INSERT INTO tour_sale_service_item VALUES (9, 40);
INSERT INTO tour_sale_service_item VALUES (18, 41);


--
-- Data for Name: touroperator; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO touroperator VALUES (1, 1004, 'Turtess Travel');
INSERT INTO touroperator VALUES (2, 1005, 'Coral Travel');
INSERT INTO touroperator VALUES (5, 1067, 'Sail Croatia');
INSERT INTO touroperator VALUES (61, 1378, 'EthnoTour');
INSERT INTO touroperator VALUES (57, 1159, 'Sun Marino Trvl.');
INSERT INTO touroperator VALUES (62, 1580, 'News Travel');
INSERT INTO touroperator VALUES (63, 1870, 'Four Winds');


--
-- Data for Name: touroperator_bank_detail; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO touroperator_bank_detail VALUES (2, 6);
INSERT INTO touroperator_bank_detail VALUES (2, 11);
INSERT INTO touroperator_bank_detail VALUES (2, 8);
INSERT INTO touroperator_bank_detail VALUES (2, 9);
INSERT INTO touroperator_bank_detail VALUES (2, 10);


--
-- Data for Name: touroperator_bperson; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO touroperator_bperson VALUES (2, 1);
INSERT INTO touroperator_bperson VALUES (62, 8);


--
-- Data for Name: touroperator_commission; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO touroperator_commission VALUES (2, 17);
INSERT INTO touroperator_commission VALUES (2, 20);
INSERT INTO touroperator_commission VALUES (2, 19);
INSERT INTO touroperator_commission VALUES (2, 18);
INSERT INTO touroperator_commission VALUES (62, 21);
INSERT INTO touroperator_commission VALUES (1, 22);
INSERT INTO touroperator_commission VALUES (57, 23);


--
-- Name: touroperator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('touroperator_id_seq', 63, true);


--
-- Data for Name: touroperator_licence; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO touroperator_licence VALUES (2, 44);
INSERT INTO touroperator_licence VALUES (62, 46);
INSERT INTO touroperator_licence VALUES (63, 47);


--
-- Data for Name: touroperator_subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO touroperator_subaccount VALUES (62, 2);
INSERT INTO touroperator_subaccount VALUES (57, 12);


--
-- Data for Name: transfer; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO transfer VALUES (31, NULL, NULL, NULL, 8, 8, 80.00, '2014-11-12');
INSERT INTO transfer VALUES (32, NULL, 8, 3, NULL, 2, 80.00, '2014-11-12');
INSERT INTO transfer VALUES (41, NULL, NULL, NULL, 6, 8, 560.00, '2014-11-09');
INSERT INTO transfer VALUES (42, NULL, 6, 3, NULL, 2, 540.00, '2014-11-09');
INSERT INTO transfer VALUES (43, NULL, NULL, NULL, 8, 8, 1975.00, '2014-11-12');
INSERT INTO transfer VALUES (44, NULL, 8, 3, NULL, 2, 1894.80, '2014-11-12');
INSERT INTO transfer VALUES (57, NULL, NULL, 3, NULL, 7, 19722.96, '2014-07-01');
INSERT INTO transfer VALUES (59, NULL, NULL, 2, NULL, 7, 20000.00, '2014-09-01');
INSERT INTO transfer VALUES (60, 2, NULL, 3, NULL, 9, 4500.00, '2014-11-18');
INSERT INTO transfer VALUES (63, NULL, NULL, NULL, 11, 8, 3000.00, '2014-11-22');
INSERT INTO transfer VALUES (64, NULL, 11, 4, NULL, 1, 3000.00, '2014-11-22');
INSERT INTO transfer VALUES (68, NULL, 8, NULL, NULL, 4, 100.20, '2014-11-14');
INSERT INTO transfer VALUES (70, NULL, 3, NULL, NULL, 4, 10.00, '2014-11-23');
INSERT INTO transfer VALUES (71, NULL, 10, NULL, NULL, 3, 8200.00, '2014-11-18');
INSERT INTO transfer VALUES (73, NULL, 12, NULL, NULL, 6, 15000.00, '2014-11-23');
INSERT INTO transfer VALUES (77, NULL, NULL, NULL, 4, 8, 29880.00, '2015-01-02');
INSERT INTO transfer VALUES (78, NULL, 4, 3, NULL, 1, 29880.00, '2015-01-02');
INSERT INTO transfer VALUES (79, NULL, NULL, NULL, 13, 8, 3000.00, '2014-12-18');
INSERT INTO transfer VALUES (80, NULL, 13, 3, NULL, 1, 3000.00, '2014-12-18');
INSERT INTO transfer VALUES (81, NULL, NULL, NULL, 13, 8, 6000.00, '2015-01-13');
INSERT INTO transfer VALUES (82, NULL, 13, 3, NULL, 1, 6000.00, '2015-01-13');
INSERT INTO transfer VALUES (83, NULL, NULL, NULL, 13, 8, 11000.00, '2015-01-11');
INSERT INTO transfer VALUES (84, NULL, 13, 3, NULL, 1, 11000.00, '2015-01-11');
INSERT INTO transfer VALUES (85, NULL, NULL, NULL, 13, 8, 3000.00, '2015-01-15');
INSERT INTO transfer VALUES (86, NULL, 13, 3, NULL, 1, 3000.00, '2015-01-15');
INSERT INTO transfer VALUES (87, NULL, NULL, NULL, 14, 8, 64576.00, '2015-01-12');
INSERT INTO transfer VALUES (88, NULL, 14, 3, NULL, 1, 64576.00, '2015-01-12');
INSERT INTO transfer VALUES (89, NULL, NULL, NULL, 15, 8, 750.00, '2015-01-16');
INSERT INTO transfer VALUES (90, NULL, 15, 3, NULL, 2, 750.00, '2015-01-16');
INSERT INTO transfer VALUES (91, NULL, NULL, NULL, 16, 8, 3450.00, '2015-01-14');
INSERT INTO transfer VALUES (92, NULL, 16, 3, NULL, 2, 3450.00, '2015-01-14');


--
-- Name: transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('transfer_id_seq', 92, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "user" VALUES (23, 894, 'maziv', NULL, 'maziv_maziv', 7);
INSERT INTO "user" VALUES (2, 3, 'admin', 'vitalii.mazur@gmail.com', 'adminadmin', 2);


--
-- Name: accomodation_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT accomodation_pkey PRIMARY KEY (id);


--
-- Name: account_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT account_item_pkey PRIMARY KEY (id);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: advsource_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT advsource_pkey PRIMARY KEY (id);


--
-- Name: appointment_header_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT appointment_header_pk PRIMARY KEY (id);


--
-- Name: apscheduler_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY apscheduler_jobs
    ADD CONSTRAINT apscheduler_jobs_pkey PRIMARY KEY (id);


--
-- Name: bank_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT bank_address_pkey PRIMARY KEY (bank_id, address_id);


--
-- Name: bank_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT bank_detail_pkey PRIMARY KEY (id);


--
-- Name: bank_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (id);


--
-- Name: bperson_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT bperson_contact_pkey PRIMARY KEY (bperson_id, contact_id);


--
-- Name: bperson_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bperson
    ADD CONSTRAINT bperson_pkey PRIMARY KEY (id);


--
-- Name: calculation_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT calculation_pkey PRIMARY KEY (id);


--
-- Name: commission_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT commission_pkey PRIMARY KEY (id);


--
-- Name: company_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: crosspayment_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT crosspayment_pkey PRIMARY KEY (id);


--
-- Name: currency_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT currency_pk PRIMARY KEY (id);


--
-- Name: currency_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT currency_rate_pkey PRIMARY KEY (id);


--
-- Name: email_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY email_campaign
    ADD CONSTRAINT email_campaign_pkey PRIMARY KEY (id);


--
-- Name: employee_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT employee_address_pkey PRIMARY KEY (employee_id, address_id);


--
-- Name: employee_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT employee_contact_pkey PRIMARY KEY (employee_id, contact_id);


--
-- Name: employee_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT employee_notification_pkey PRIMARY KEY (employee_id, notification_id);


--
-- Name: employee_passport_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT employee_passport_pkey PRIMARY KEY (employee_id, passport_id);


--
-- Name: employee_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pk PRIMARY KEY (id);


--
-- Name: employee_subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT employee_subaccount_pkey PRIMARY KEY (employee_id, subaccount_id);


--
-- Name: foodcat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT foodcat_pkey PRIMARY KEY (id);


--
-- Name: hotel_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (id);


--
-- Name: hotelcat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT hotelcat_pkey PRIMARY KEY (id);


--
-- Name: income_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY income
    ADD CONSTRAINT income_pkey PRIMARY KEY (id);


--
-- Name: income_transfer_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY income_transfer
    ADD CONSTRAINT income_transfer_pkey PRIMARY KEY (income_id, transfer_id);


--
-- Name: invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);


--
-- Name: licence_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY licence
    ADD CONSTRAINT licence_pkey PRIMARY KEY (id);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: navigation_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT navigation_pk PRIMARY KEY (id);


--
-- Name: note_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_pkey PRIMARY KEY (id);


--
-- Name: note_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT note_resource_pkey PRIMARY KEY (note_id, resource_id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: outgoing_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT outgoing_pkey PRIMARY KEY (id);


--
-- Name: outgoing_transfer_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outgoing_transfer
    ADD CONSTRAINT outgoing_transfer_pkey PRIMARY KEY (outgoing_id, transfer_id);


--
-- Name: passport_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY (id);


--
-- Name: permision_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT permision_pk PRIMARY KEY (id);


--
-- Name: person_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT person_address_pkey PRIMARY KEY (person_id, address_id);


--
-- Name: person_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT person_contact_pkey PRIMARY KEY (person_id, contact_id);


--
-- Name: person_passport_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT person_passport_pkey PRIMARY KEY (person_id, passport_id);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: person_subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT person_subaccount_pkey PRIMARY KEY (person_id, subaccount_id);


--
-- Name: position_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT position_pk PRIMARY KEY (id);


--
-- Name: region_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pk PRIMARY KEY (id);


--
-- Name: resource_log_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT resource_log_pk PRIMARY KEY (id);


--
-- Name: resource_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_pk PRIMARY KEY (id);


--
-- Name: resource_type_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT resource_type_pk PRIMARY KEY (id);


--
-- Name: roomcat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT roomcat_pkey PRIMARY KEY (id);


--
-- Name: service_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT service_item_pkey PRIMARY KEY (id);


--
-- Name: service_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: service_sale_invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service_sale_invoice
    ADD CONSTRAINT service_sale_invoice_pkey PRIMARY KEY (service_sale_id, invoice_id);


--
-- Name: service_sale_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service_sale
    ADD CONSTRAINT service_sale_pkey PRIMARY KEY (id);


--
-- Name: service_sale_service_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service_sale_service_item
    ADD CONSTRAINT service_sale_service_item_pkey PRIMARY KEY (service_sale_id, service_item_id);


--
-- Name: structure_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT structure_address_pkey PRIMARY KEY (structure_id, address_id);


--
-- Name: structure_bank_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT structure_bank_detail_pkey PRIMARY KEY (structure_id, bank_detail_id);


--
-- Name: structure_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT structure_contact_pkey PRIMARY KEY (structure_id, contact_id);


--
-- Name: structure_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT structure_pk PRIMARY KEY (id);


--
-- Name: subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT subaccount_pkey PRIMARY KEY (id);


--
-- Name: supplier_bank_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT supplier_bank_detail_pkey PRIMARY KEY (supplier_id, bank_detail_id);


--
-- Name: supplier_bperson_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT supplier_bperson_pkey PRIMARY KEY (supplier_id, bperson_id);


--
-- Name: supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- Name: suppplier_subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY suppplier_subaccount
    ADD CONSTRAINT suppplier_subaccount_pkey PRIMARY KEY (supplier_id, subaccount_id);


--
-- Name: task_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: task_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT task_resource_pkey PRIMARY KEY (task_id, resource_id);


--
-- Name: tour_invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour_sale_invoice
    ADD CONSTRAINT tour_invoice_pkey PRIMARY KEY (tour_sale_id, invoice_id);


--
-- Name: tour_person_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour_sale_person
    ADD CONSTRAINT tour_person_pkey PRIMARY KEY (tour_sale_id, person_id);


--
-- Name: tour_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT tour_pkey PRIMARY KEY (id);


--
-- Name: tour_point_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT tour_point_pkey PRIMARY KEY (id);


--
-- Name: tour_sale_service_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour_sale_service_item
    ADD CONSTRAINT tour_sale_service_item_pkey PRIMARY KEY (tour_sale_id, service_item_id);


--
-- Name: touroperator_bank_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY touroperator_bank_detail
    ADD CONSTRAINT touroperator_bank_detail_pkey PRIMARY KEY (touroperator_id, bank_detail_id);


--
-- Name: touroperator_commission_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY touroperator_commission
    ADD CONSTRAINT touroperator_commission_pkey PRIMARY KEY (touroperator_id, commission_id);


--
-- Name: touroperator_licence_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY touroperator_licence
    ADD CONSTRAINT touroperator_licence_pkey PRIMARY KEY (touroperator_id, licence_id);


--
-- Name: touroperator_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY touroperator
    ADD CONSTRAINT touroperator_pkey PRIMARY KEY (id);


--
-- Name: touroperator_subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY touroperator_subaccount
    ADD CONSTRAINT touroperator_subaccount_pkey PRIMARY KEY (touroperator_id, subaccount_id);


--
-- Name: transfer_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_pkey PRIMARY KEY (id);


--
-- Name: unique_idx_accomodation_name; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT unique_idx_accomodation_name UNIQUE (name);


--
-- Name: unique_idx_country_iso_code; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT unique_idx_country_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_currency_iso_code; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT unique_idx_currency_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_currency_rate_currency_id_date; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT unique_idx_currency_rate_currency_id_date UNIQUE (currency_id, date);


--
-- Name: unique_idx_name_account; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT unique_idx_name_account UNIQUE (name);


--
-- Name: unique_idx_name_account_item; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT unique_idx_name_account_item UNIQUE (name);


--
-- Name: unique_idx_name_advsource; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT unique_idx_name_advsource UNIQUE (name);


--
-- Name: unique_idx_name_bank; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT unique_idx_name_bank UNIQUE (name);


--
-- Name: unique_idx_name_company; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT unique_idx_name_company UNIQUE (name);


--
-- Name: unique_idx_name_country_id_region; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT unique_idx_name_country_id_region UNIQUE (name, country_id);


--
-- Name: unique_idx_name_foodcat; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT unique_idx_name_foodcat UNIQUE (name);


--
-- Name: unique_idx_name_hotelcat; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT unique_idx_name_hotelcat UNIQUE (name);


--
-- Name: unique_idx_name_region_id_location; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT unique_idx_name_region_id_location UNIQUE (name, region_id);


--
-- Name: unique_idx_name_roomcat; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT unique_idx_name_roomcat UNIQUE (name);


--
-- Name: unique_idx_name_service; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT unique_idx_name_service UNIQUE (name);


--
-- Name: unique_idx_name_strcuture_id_position; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT unique_idx_name_strcuture_id_position UNIQUE (name, structure_id);


--
-- Name: unique_idx_name_subaccount; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT unique_idx_name_subaccount UNIQUE (name);


--
-- Name: unique_idx_name_supplier; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT unique_idx_name_supplier UNIQUE (name);


--
-- Name: unique_idx_name_touroperator; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY touroperator
    ADD CONSTRAINT unique_idx_name_touroperator UNIQUE (name);


--
-- Name: unique_idx_resource_type_id_position_id_permision; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT unique_idx_resource_type_id_position_id_permision UNIQUE (resource_type_id, position_id);


--
-- Name: unique_idx_resource_type_module; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT unique_idx_resource_type_module UNIQUE (module, resource_name);


--
-- Name: unique_idx_resource_type_name; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT unique_idx_resource_type_name UNIQUE (name);


--
-- Name: unique_idx_users_email; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_idx_users_email UNIQUE (email);


--
-- Name: unique_idx_users_username; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_idx_users_username UNIQUE (username);


--
-- Name: user_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- Name: ix_apscheduler_jobs_next_run_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_apscheduler_jobs_next_run_time ON apscheduler_jobs USING btree (next_run_time);


--
-- Name: fk_accomodation_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_accomodation_id_tour_point FOREIGN KEY (accomodation_id) REFERENCES accomodation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_from_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_account_from_id_transfer FOREIGN KEY (account_from_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_id_invoice; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_account_id_invoice FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_outgoing; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_account_item_id_outgoing FOREIGN KEY (account_item_id) REFERENCES account_item(id);


--
-- Name: fk_account_item_id_service; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_account_item_id_service FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_account_item_id_transfer FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_to_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_account_to_id_transfer FOREIGN KEY (account_to_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_bank_address; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT fk_address_id_bank_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_employee_address; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT fk_address_id_employee_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_person_address; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT fk_address_id_person_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_structure_address; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT fk_address_id_structure_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_service_sale; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_sale
    ADD CONSTRAINT fk_advsource_id_service_sale FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT fk_advsource_id_tour FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_structure_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_supplier_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_supplier_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_touroperator_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_touroperator_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_id_bank_address; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT fk_bank_id_bank_address FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_id_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_bank_id_bank_detail FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bperson_id_bperson_contact; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT fk_bperson_id_bperson_contact FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bperson_id_supplier_bperson; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT fk_bperson_id_supplier_bperson FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bperson_id_touroperator_bperson; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator_bperson
    ADD CONSTRAINT fk_bperson_id_touroperator_bperson FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_commission_id_touroperator_commission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator_commission
    ADD CONSTRAINT fk_commission_id_touroperator_commission FOREIGN KEY (commission_id) REFERENCES commission(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_bperson_contact; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT fk_contact_id_bperson_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_employee_contact; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT fk_contact_id_employee_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_employee_notification; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT fk_contact_id_employee_notification FOREIGN KEY (notification_id) REFERENCES notification(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_person_contact; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT fk_contact_id_person_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_structure_contact; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT fk_contact_id_structure_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_country_id_passport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_country_id_passport FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_account; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account
    ADD CONSTRAINT fk_currency_id_account FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_appointment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_currency_id_appointment FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_currency_id_bank_detail FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_commission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_currency_id_commission FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_company; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company
    ADD CONSTRAINT fk_currency_id_company FOREIGN KEY (currency_id) REFERENCES currency(id);


--
-- Name: fk_currency_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT fk_currency_id_service_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_currency_id_service_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_currency_id_tour FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_service_sale; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_sale
    ADD CONSTRAINT fk_customer_id_service_sale FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT fk_customer_id_tour FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_appointment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_employee_id_appointment FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_address; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT fk_employee_id_employee_address FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_contact; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT fk_employee_id_employee_contact FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_notification; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT fk_employee_id_employee_notification FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_passport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_employee_id_employee_passport FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT fk_employee_id_employee_subaccount FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_resource_log; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_employee_id_resource_log FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_task; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_employee_id_task FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_employee_id_user FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_location_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT fk_end_location_id_tour FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_foodcat_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_foodcat_id_tour_point FOREIGN KEY (foodcat_id) REFERENCES foodcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotel_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_hotel_id_tour_point FOREIGN KEY (hotel_id) REFERENCES hotel(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotelcat_id_hotel; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_hotelcat_id_hotel FOREIGN KEY (hotelcat_id) REFERENCES hotelcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_income_id_income_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY income_transfer
    ADD CONSTRAINT fk_income_id_income_transfer FOREIGN KEY (income_id) REFERENCES income(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_income; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_invoice_id_income FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_service_sale_invoice; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_sale_invoice
    ADD CONSTRAINT fk_invoice_id_service_sale_invoice FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_tour_invoice; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_invoice
    ADD CONSTRAINT fk_invoice_id_tour_invoice FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_licence_id_touroperator_licence; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator_licence
    ADD CONSTRAINT fk_licence_id_touroperator_licence FOREIGN KEY (licence_id) REFERENCES licence(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_address; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT fk_location_id_address FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_hotel; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_location_id_hotel FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_location_id_tour_point FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_navigation_position_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_navigation_position_id FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_note_id_note_resource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT fk_note_id_note_resource FOREIGN KEY (note_id) REFERENCES note(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_outgoing_id_outgoing_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outgoing_transfer
    ADD CONSTRAINT fk_outgoing_id_outgoing_transfer FOREIGN KEY (outgoing_id) REFERENCES outgoing(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_parent_id_navigation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_parent_id_navigation FOREIGN KEY (parent_id) REFERENCES navigation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_employee_passport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_passport_id_employee_passport FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_person_passport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_passport_id_person_passport FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_permision_structure_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_permision_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_address; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT fk_person_id_person_address FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_contact; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT fk_person_id_person_contact FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_passport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_person_id_person_passport FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT fk_person_id_person_subaccount FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT fk_person_id_service_item FOREIGN KEY (person_id) REFERENCES person(id);


--
-- Name: fk_person_id_tour_person; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_person
    ADD CONSTRAINT fk_person_id_tour_person FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_position_id_appointment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_position_id_appointment FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_position_id_permision; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_position_id_permision FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_position_structure_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_position_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_region_country_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_region_country_id FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_region_id_location; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_region_id_location FOREIGN KEY (region_id) REFERENCES region(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_accomodation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT fk_resource_id_accomodation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_account; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account
    ADD CONSTRAINT fk_resource_id_account FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_account_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT fk_resource_id_account_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_address; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT fk_resource_id_address FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_advsource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT fk_resource_id_advsource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_appointment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_resource_id_appointment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bank; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT fk_resource_id_bank FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_resource_id_bank_detail FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bperson; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bperson
    ADD CONSTRAINT fk_resource_id_bperson FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_calculation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_resource_id_calculation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_commission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_resource_id_commission FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_company; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company
    ADD CONSTRAINT fk_resource_id_company FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_contact; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT fk_resource_id_contact FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_country; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY country
    ADD CONSTRAINT fk_resource_id_country FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_crosspayment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_resource_id_crosspayment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_currency; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT fk_resource_id_currency FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_email_campaign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY email_campaign
    ADD CONSTRAINT fk_resource_id_email_campaign FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_employee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_resource_id_employee FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_foodcat; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT fk_resource_id_foodcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_hotel; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_resource_id_hotel FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_hotelcat; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT fk_resource_id_hotelcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_income; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_resource_id_income FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_invoice; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_resource_id_invoice FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_licence; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY licence
    ADD CONSTRAINT fk_resource_id_licence FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_location; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_resource_id_location FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_navigation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_resource_id_navigation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_note; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY note
    ADD CONSTRAINT fk_resource_id_note FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_note_resource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT fk_resource_id_note_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_notification; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT fk_resource_id_notification FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_outgoing; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_resource_id_outgoing FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_passport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_resource_id_passport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_person; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_resource_id_person FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_position; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_resource_id_position FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_region; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_resource_id_region FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_resource_log; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_resource_id_resource_log FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_resource_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT fk_resource_id_resource_type FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_roomcat; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT fk_resource_id_roomcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_service; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_resource_id_service FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT fk_resource_id_service_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_service_sale; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_sale
    ADD CONSTRAINT fk_resource_id_service_sale FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_structure; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_resource_id_structure FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT fk_resource_id_subaccount FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_supplier; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT fk_resource_id_supplier FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_task; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_resource_id_task FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_task_resource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_resource_id_task_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_touroperator; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator
    ADD CONSTRAINT fk_resource_id_touroperator FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_resource_id_user FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_type_id_permission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_resource_type_id_permission FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_type_id_resource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_resource_type_id_resource FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_roomcat_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_roomcat_id_tour_point FOREIGN KEY (roomcat_id) REFERENCES roomcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_commission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_service_id_commission FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT fk_service_id_service_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_item_id_caluclation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_service_item_id_caluclation FOREIGN KEY (service_item_id) REFERENCES service_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_item_id_service_sale_service_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_sale_service_item
    ADD CONSTRAINT fk_service_item_id_service_sale_service_item FOREIGN KEY (service_item_id) REFERENCES service_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_item_id_tour_sale_service_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_service_item
    ADD CONSTRAINT fk_service_item_id_tour_sale_service_item FOREIGN KEY (service_item_id) REFERENCES service_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_sale_id_service_sale_invoice; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_sale_invoice
    ADD CONSTRAINT fk_service_sale_id_service_sale_invoice FOREIGN KEY (service_sale_id) REFERENCES service_sale(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_sale_id_service_sale_service_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_sale_service_item
    ADD CONSTRAINT fk_service_sale_id_service_sale_service_item FOREIGN KEY (service_sale_id) REFERENCES service_sale(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT fk_start_location_id_tour FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_company_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_company_id FOREIGN KEY (company_id) REFERENCES company(id);


--
-- Name: fk_structure_id_resource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_structure_id_resource FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_address; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT fk_structure_id_structure_address FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_structure_id_structure_bank_detail FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_contact; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT fk_structure_id_structure_contact FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_parent_id FOREIGN KEY (parent_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_account_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT fk_subaccount_account_id FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_from_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_subaccount_from_id_transfer FOREIGN KEY (subaccount_from_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_employee_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT fk_subaccount_id_employee_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_outgoing; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_subaccount_id_outgoing FOREIGN KEY (subaccount_id) REFERENCES subaccount(id);


--
-- Name: fk_subaccount_id_person_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT fk_subaccount_id_person_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY suppplier_subaccount
    ADD CONSTRAINT fk_subaccount_id_supplier_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_touroperator_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator_subaccount
    ADD CONSTRAINT fk_subaccount_id_touroperator_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_to_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_subaccount_to_id_transfer FOREIGN KEY (subaccount_to_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT fk_supplier_id_supplier_bank_detail FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_bperson; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT fk_supplier_id_supplier_bperson FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY suppplier_subaccount
    ADD CONSTRAINT fk_supplier_id_supplier_subaccount FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_task_id_task_resource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_task_id_task_resource FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_invoice; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_invoice
    ADD CONSTRAINT fk_tour_id_tour_invoice FOREIGN KEY (tour_sale_id) REFERENCES tour_sale(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_person; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_person
    ADD CONSTRAINT fk_tour_id_tour_person FOREIGN KEY (tour_sale_id) REFERENCES tour_sale(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_tour_id_tour_point FOREIGN KEY (tour_sale_id) REFERENCES tour_sale(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_tour_sale_id_tour_sale_service_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_sale_service_item
    ADD CONSTRAINT fk_tour_sale_id_tour_sale_service_item FOREIGN KEY (tour_sale_id) REFERENCES tour_sale(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT fk_touroperator_id_service_item FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_touroperator_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator_bank_detail
    ADD CONSTRAINT fk_touroperator_id_touroperator_bank_detail FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_touroperator_bperson; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator_bperson
    ADD CONSTRAINT fk_touroperator_id_touroperator_bperson FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_touroperator_commission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator_commission
    ADD CONSTRAINT fk_touroperator_id_touroperator_commission FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_touroperator_licence; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator_licence
    ADD CONSTRAINT fk_touroperator_id_touroperator_licence FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_touroperator_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY touroperator_subaccount
    ADD CONSTRAINT fk_touroperator_id_touroperator_subaccount FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_transfer_id_crosspayment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_transfer_id_crosspayment FOREIGN KEY (transfer_id) REFERENCES transfer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_transfer_id_income_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY income_transfer
    ADD CONSTRAINT fk_transfer_id_income_transfer FOREIGN KEY (transfer_id) REFERENCES transfer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_transfer_id_outgoing_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outgoing_transfer
    ADD CONSTRAINT fk_transfer_id_outgoing_transfer FOREIGN KEY (transfer_id) REFERENCES transfer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

