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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

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


ALTER TABLE currency OWNER TO mazvv;

--
-- Name: _currencies_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _currencies_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE _currencies_rid_seq OWNER TO mazvv;

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


ALTER TABLE employee OWNER TO mazvv;

--
-- Name: _employees_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _employees_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE _employees_rid_seq OWNER TO mazvv;

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


ALTER TABLE region OWNER TO mazvv;

--
-- Name: _regions_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _regions_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE _regions_rid_seq OWNER TO mazvv;

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


ALTER TABLE resource_log OWNER TO mazvv;

--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _resources_logs_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE _resources_logs_rid_seq OWNER TO mazvv;

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


ALTER TABLE resource OWNER TO mazvv;

--
-- Name: _resources_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _resources_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE _resources_rid_seq OWNER TO mazvv;

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
    description character varying(128),
    settings json,
    customizable boolean,
    status smallint NOT NULL
);


ALTER TABLE resource_type OWNER TO mazvv;

--
-- Name: _resources_types_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _resources_types_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE _resources_types_rid_seq OWNER TO mazvv;

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


ALTER TABLE "user" OWNER TO mazvv;

--
-- Name: _users_rid_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE _users_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE _users_rid_seq OWNER TO mazvv;

--
-- Name: _users_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE _users_rid_seq OWNED BY "user".id;


--
-- Name: accomodation_type; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE accomodation_type (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE accomodation_type OWNER TO mazvv;

--
-- Name: accomodation_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE accomodation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE accomodation_id_seq OWNER TO mazvv;

--
-- Name: accomodation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE accomodation_id_seq OWNED BY accomodation_type.id;


--
-- Name: account; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
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


ALTER TABLE account OWNER TO mazvv;

--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account_id_seq OWNER TO mazvv;

--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE account_id_seq OWNED BY account.id;


--
-- Name: account_item; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE account_item (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(128) NOT NULL
);


ALTER TABLE account_item OWNER TO mazvv;

--
-- Name: account_item_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE account_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account_item_id_seq OWNER TO mazvv;

--
-- Name: account_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE account_item_id_seq OWNED BY account_item.id;


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


ALTER TABLE address OWNER TO mazvv;

--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE address_id_seq OWNER TO mazvv;

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


ALTER TABLE advsource OWNER TO mazvv;

--
-- Name: advsource_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE advsource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE advsource_id_seq OWNER TO mazvv;

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


ALTER TABLE alembic_version OWNER TO mazvv;

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


ALTER TABLE appointment OWNER TO mazvv;

--
-- Name: apscheduler_jobs; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE apscheduler_jobs (
    id character varying(191) NOT NULL,
    next_run_time double precision,
    job_state bytea NOT NULL
);


ALTER TABLE apscheduler_jobs OWNER TO mazvv;

--
-- Name: bank; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE bank (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE bank OWNER TO mazvv;

--
-- Name: bank_address; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE bank_address (
    bank_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE bank_address OWNER TO mazvv;

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


ALTER TABLE bank_detail OWNER TO mazvv;

--
-- Name: bank_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE bank_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bank_detail_id_seq OWNER TO mazvv;

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


ALTER TABLE bank_id_seq OWNER TO mazvv;

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


ALTER TABLE bperson OWNER TO mazvv;

--
-- Name: bperson_contact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE bperson_contact (
    bperson_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE bperson_contact OWNER TO mazvv;

--
-- Name: bperson_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE bperson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bperson_id_seq OWNER TO mazvv;

--
-- Name: bperson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE bperson_id_seq OWNED BY bperson.id;


--
-- Name: calculation; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE calculation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    service_item_id integer,
    currency_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    base_price numeric(16,2) NOT NULL
);


ALTER TABLE calculation OWNER TO mazvv;

--
-- Name: calculation_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE calculation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE calculation_id_seq OWNER TO mazvv;

--
-- Name: calculation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE calculation_id_seq OWNED BY calculation.id;


--
-- Name: cashflow; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE cashflow (
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


ALTER TABLE cashflow OWNER TO mazvv;

--
-- Name: commission; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
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


ALTER TABLE commission OWNER TO mazvv;

--
-- Name: commission_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE commission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE commission_id_seq OWNER TO mazvv;

--
-- Name: commission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE commission_id_seq OWNED BY commission.id;


--
-- Name: position; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE "position" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    structure_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE "position" OWNER TO mazvv;

--
-- Name: companies_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE companies_positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE companies_positions_id_seq OWNER TO mazvv;

--
-- Name: companies_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE companies_positions_id_seq OWNED BY "position".id;


--
-- Name: company; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE company (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    currency_id integer NOT NULL,
    settings json,
    email character varying(32) NOT NULL
);


ALTER TABLE company OWNER TO mazvv;

--
-- Name: company_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE company_id_seq OWNER TO mazvv;

--
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE company_id_seq OWNED BY company.id;


--
-- Name: contact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE contact (
    id integer NOT NULL,
    contact character varying NOT NULL,
    resource_id integer NOT NULL,
    contact_type integer NOT NULL
);


ALTER TABLE contact OWNER TO mazvv;

--
-- Name: contact_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE contact_id_seq OWNER TO mazvv;

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


ALTER TABLE country OWNER TO mazvv;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE country_id_seq OWNER TO mazvv;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: crosspayment; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE crosspayment (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    cashflow_id integer NOT NULL,
    descr character varying(255)
);


ALTER TABLE crosspayment OWNER TO mazvv;

--
-- Name: crosspayment_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE crosspayment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE crosspayment_id_seq OWNER TO mazvv;

--
-- Name: crosspayment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE crosspayment_id_seq OWNED BY crosspayment.id;


--
-- Name: currency_rate; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE currency_rate (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    date date NOT NULL,
    currency_id integer NOT NULL,
    rate numeric(16,2) NOT NULL
);


ALTER TABLE currency_rate OWNER TO mazvv;

--
-- Name: currency_rate_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE currency_rate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE currency_rate_id_seq OWNER TO mazvv;

--
-- Name: currency_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE currency_rate_id_seq OWNED BY currency_rate.id;


--
-- Name: email_campaign; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
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


ALTER TABLE email_campaign OWNER TO mazvv;

--
-- Name: email_campaign_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE email_campaign_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE email_campaign_id_seq OWNER TO mazvv;

--
-- Name: email_campaign_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE email_campaign_id_seq OWNED BY email_campaign.id;


--
-- Name: employee_address; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employee_address (
    employee_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE employee_address OWNER TO mazvv;

--
-- Name: employee_contact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employee_contact (
    employee_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE employee_contact OWNER TO mazvv;

--
-- Name: employee_notification; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employee_notification (
    employee_id integer NOT NULL,
    notification_id integer NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE employee_notification OWNER TO mazvv;

--
-- Name: employee_passport; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employee_passport (
    employee_id integer NOT NULL,
    passport_id integer NOT NULL
);


ALTER TABLE employee_passport OWNER TO mazvv;

--
-- Name: employee_subaccount; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE employee_subaccount (
    employee_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


ALTER TABLE employee_subaccount OWNER TO mazvv;

--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE employees_appointments_h_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employees_appointments_h_id_seq OWNER TO mazvv;

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


ALTER TABLE foodcat OWNER TO mazvv;

--
-- Name: foodcat_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE foodcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE foodcat_id_seq OWNER TO mazvv;

--
-- Name: foodcat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE foodcat_id_seq OWNED BY foodcat.id;


--
-- Name: general_service; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE general_service (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    order_item_id integer NOT NULL
);


ALTER TABLE general_service OWNER TO mazvv;

--
-- Name: general_service_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE general_service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE general_service_id_seq OWNER TO mazvv;

--
-- Name: general_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE general_service_id_seq OWNED BY general_service.id;


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


ALTER TABLE hotel OWNER TO mazvv;

--
-- Name: hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE hotel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hotel_id_seq OWNER TO mazvv;

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


ALTER TABLE hotelcat OWNER TO mazvv;

--
-- Name: hotelcat_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE hotelcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hotelcat_id_seq OWNER TO mazvv;

--
-- Name: hotelcat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE hotelcat_id_seq OWNED BY hotelcat.id;


--
-- Name: income; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE income (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    invoice_id integer NOT NULL
);


ALTER TABLE income OWNER TO mazvv;

--
-- Name: income_cashflow; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE income_cashflow (
    income_id integer NOT NULL,
    cashflow_id integer NOT NULL
);


ALTER TABLE income_cashflow OWNER TO mazvv;

--
-- Name: income_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE income_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE income_id_seq OWNER TO mazvv;

--
-- Name: income_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE income_id_seq OWNED BY income.id;


--
-- Name: invoice; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE invoice (
    id integer NOT NULL,
    date date NOT NULL,
    resource_id integer NOT NULL,
    account_id integer NOT NULL,
    active_until date NOT NULL
);


ALTER TABLE invoice OWNER TO mazvv;

--
-- Name: invoice_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE invoice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE invoice_id_seq OWNER TO mazvv;

--
-- Name: invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE invoice_id_seq OWNED BY invoice.id;


--
-- Name: lead; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE lead (
    id integer NOT NULL,
    lead_date date NOT NULL,
    resource_id integer NOT NULL,
    advsource_id integer NOT NULL,
    customer_id integer NOT NULL,
    status smallint NOT NULL
);


ALTER TABLE lead OWNER TO mazvv;

--
-- Name: lead_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE lead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE lead_id_seq OWNER TO mazvv;

--
-- Name: lead_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE lead_id_seq OWNED BY lead.id;


--
-- Name: lead_offer; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE lead_offer (
    lead_id integer NOT NULL,
    offer_id integer NOT NULL
);


ALTER TABLE lead_offer OWNER TO mazvv;

--
-- Name: lead_wish; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE lead_wish (
    lead_id integer NOT NULL,
    wish_id integer NOT NULL
);


ALTER TABLE lead_wish OWNER TO mazvv;

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


ALTER TABLE licence OWNER TO mazvv;

--
-- Name: licence_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE licence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE licence_id_seq OWNER TO mazvv;

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


ALTER TABLE location OWNER TO mazvv;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE location_id_seq OWNER TO mazvv;

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
    resource_id integer NOT NULL,
    separator_before boolean,
    action character varying(32)
);


ALTER TABLE navigation OWNER TO mazvv;

--
-- Name: note; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE note (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    title character varying(255) NOT NULL,
    descr character varying
);


ALTER TABLE note OWNER TO mazvv;

--
-- Name: note_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE note_id_seq OWNER TO mazvv;

--
-- Name: note_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE note_id_seq OWNED BY note.id;


--
-- Name: note_resource; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE note_resource (
    note_id integer NOT NULL,
    resource_id integer NOT NULL
);


ALTER TABLE note_resource OWNER TO mazvv;

--
-- Name: notification; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE notification (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    title character varying NOT NULL,
    descr character varying NOT NULL,
    created timestamp without time zone,
    url character varying
);


ALTER TABLE notification OWNER TO mazvv;

--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notification_id_seq OWNER TO mazvv;

--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE notification_id_seq OWNED BY notification.id;


--
-- Name: notification_resource; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE notification_resource (
    notification_id integer NOT NULL,
    resource_id integer NOT NULL
);


ALTER TABLE notification_resource OWNER TO mazvv;

--
-- Name: offer; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE offer (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    service_id integer NOT NULL,
    currency_id integer,
    price numeric(16,2),
    descr character varying(1024) NOT NULL
);


ALTER TABLE offer OWNER TO mazvv;

--
-- Name: offer_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE offer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE offer_id_seq OWNER TO mazvv;

--
-- Name: offer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE offer_id_seq OWNED BY offer.id;


--
-- Name: order; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE "order" (
    id integer NOT NULL,
    deal_date date NOT NULL,
    resource_id integer NOT NULL,
    customer_id integer NOT NULL,
    advsource_id integer NOT NULL,
    invoice_id integer,
    calculation_id integer
);


ALTER TABLE "order" OWNER TO mazvv;

--
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE order_id_seq OWNER TO mazvv;

--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE order_id_seq OWNED BY "order".id;


--
-- Name: order_item; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE order_item (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    order_id integer,
    service_id integer NOT NULL,
    currency_id integer NOT NULL,
    touroperator_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    base_price numeric(16,2) NOT NULL
);


ALTER TABLE order_item OWNER TO mazvv;

--
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE order_item_id_seq OWNER TO mazvv;

--
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE order_item_id_seq OWNED BY order_item.id;


--
-- Name: outgoing; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE outgoing (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    account_item_id integer NOT NULL,
    date date NOT NULL,
    subaccount_id integer NOT NULL,
    sum numeric(16,2) NOT NULL
);


ALTER TABLE outgoing OWNER TO mazvv;

--
-- Name: outgoing_cashflow; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE outgoing_cashflow (
    outgoing_id integer NOT NULL,
    cashflow_id integer NOT NULL
);


ALTER TABLE outgoing_cashflow OWNER TO mazvv;

--
-- Name: outgoing_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE outgoing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE outgoing_id_seq OWNER TO mazvv;

--
-- Name: outgoing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE outgoing_id_seq OWNED BY outgoing.id;


--
-- Name: passport; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE passport (
    id integer NOT NULL,
    country_id integer NOT NULL,
    num character varying(32) NOT NULL,
    descr character varying(255),
    resource_id integer NOT NULL,
    end_date date,
    passport_type integer NOT NULL
);


ALTER TABLE passport OWNER TO mazvv;

--
-- Name: passport_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE passport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE passport_id_seq OWNER TO mazvv;

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


ALTER TABLE permision OWNER TO mazvv;

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
    subscriber boolean,
    gender integer
);


ALTER TABLE person OWNER TO mazvv;

--
-- Name: person_address; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE person_address (
    person_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE person_address OWNER TO mazvv;

--
-- Name: person_contact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE person_contact (
    person_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE person_contact OWNER TO mazvv;

--
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person_id_seq OWNER TO mazvv;

--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE person_id_seq OWNED BY person.id;


--
-- Name: person_order_item; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE person_order_item (
    order_item_id integer NOT NULL,
    person_id integer NOT NULL
);


ALTER TABLE person_order_item OWNER TO mazvv;

--
-- Name: person_passport; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE person_passport (
    person_id integer NOT NULL,
    passport_id integer NOT NULL
);


ALTER TABLE person_passport OWNER TO mazvv;

--
-- Name: person_subaccount; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE person_subaccount (
    person_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


ALTER TABLE person_subaccount OWNER TO mazvv;

--
-- Name: positions_navigations_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE positions_navigations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE positions_navigations_id_seq OWNER TO mazvv;

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


ALTER TABLE positions_permisions_id_seq OWNER TO mazvv;

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


ALTER TABLE roomcat OWNER TO mazvv;

--
-- Name: roomcat_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE roomcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE roomcat_id_seq OWNER TO mazvv;

--
-- Name: roomcat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE roomcat_id_seq OWNED BY roomcat.id;


--
-- Name: service; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE service (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    descr character varying(256),
    display_text character varying(256),
    account_item_id integer NOT NULL,
    resource_type_id integer NOT NULL
);


ALTER TABLE service OWNER TO mazvv;

--
-- Name: service_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE service_id_seq OWNER TO mazvv;

--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE service_id_seq OWNED BY service.id;


--
-- Name: service_item; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
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


ALTER TABLE service_item OWNER TO mazvv;

--
-- Name: service_item_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE service_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE service_item_id_seq OWNER TO mazvv;

--
-- Name: service_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE service_item_id_seq OWNED BY service_item.id;


--
-- Name: service_sale; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE service_sale (
    id integer NOT NULL,
    deal_date date NOT NULL,
    resource_id integer NOT NULL,
    customer_id integer NOT NULL,
    advsource_id integer NOT NULL
);


ALTER TABLE service_sale OWNER TO mazvv;

--
-- Name: service_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE service_sale_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE service_sale_id_seq OWNER TO mazvv;

--
-- Name: service_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE service_sale_id_seq OWNED BY service_sale.id;


--
-- Name: service_sale_invoice; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE service_sale_invoice (
    service_sale_id integer NOT NULL,
    invoice_id integer NOT NULL
);


ALTER TABLE service_sale_invoice OWNER TO mazvv;

--
-- Name: service_sale_service_item; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE service_sale_service_item (
    service_sale_id integer NOT NULL,
    service_item_id integer NOT NULL
);


ALTER TABLE service_sale_service_item OWNER TO mazvv;

--
-- Name: structure; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE structure (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    parent_id integer,
    name character varying(32) NOT NULL,
    company_id integer NOT NULL
);


ALTER TABLE structure OWNER TO mazvv;

--
-- Name: structure_address; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE structure_address (
    structure_id integer NOT NULL,
    address_id integer NOT NULL
);


ALTER TABLE structure_address OWNER TO mazvv;

--
-- Name: structure_bank_detail; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE structure_bank_detail (
    structure_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


ALTER TABLE structure_bank_detail OWNER TO mazvv;

--
-- Name: structure_contact; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE structure_contact (
    structure_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE structure_contact OWNER TO mazvv;

--
-- Name: structures_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE structures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE structures_id_seq OWNER TO mazvv;

--
-- Name: structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE structures_id_seq OWNED BY structure.id;


--
-- Name: subaccount; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE subaccount (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    account_id integer,
    name character varying(255) NOT NULL,
    descr character varying(255)
);


ALTER TABLE subaccount OWNER TO mazvv;

--
-- Name: subaccount_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE subaccount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subaccount_id_seq OWNER TO mazvv;

--
-- Name: subaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE subaccount_id_seq OWNED BY subaccount.id;


--
-- Name: supplier; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE supplier (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE supplier OWNER TO mazvv;

--
-- Name: supplier_bank_detail; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE supplier_bank_detail (
    supplier_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


ALTER TABLE supplier_bank_detail OWNER TO mazvv;

--
-- Name: supplier_bperson; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE supplier_bperson (
    supplier_id integer NOT NULL,
    bperson_id integer NOT NULL
);


ALTER TABLE supplier_bperson OWNER TO mazvv;

--
-- Name: supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE supplier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE supplier_id_seq OWNER TO mazvv;

--
-- Name: supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE supplier_id_seq OWNED BY supplier.id;


--
-- Name: suppplier_subaccount; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE suppplier_subaccount (
    supplier_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


ALTER TABLE suppplier_subaccount OWNER TO mazvv;

--
-- Name: task; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE task (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    title character varying(128) NOT NULL,
    deadline timestamp without time zone NOT NULL,
    reminder timestamp without time zone,
    descr character varying,
    status smallint NOT NULL
);


ALTER TABLE task OWNER TO mazvv;

--
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE task_id_seq OWNER TO mazvv;

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


ALTER TABLE task_resource OWNER TO mazvv;

--
-- Name: tour_sale; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
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


ALTER TABLE tour_sale OWNER TO mazvv;

--
-- Name: tour_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE tour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tour_id_seq OWNER TO mazvv;

--
-- Name: tour_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE tour_id_seq OWNED BY tour_sale.id;


--
-- Name: tour_sale_point; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE tour_sale_point (
    id integer NOT NULL,
    location_id integer NOT NULL,
    hotel_id integer,
    accomodation_type_id integer,
    foodcat_id integer,
    roomcat_id integer,
    tour_sale_id integer,
    description character varying(255),
    end_date date NOT NULL,
    start_date date NOT NULL
);


ALTER TABLE tour_sale_point OWNER TO mazvv;

--
-- Name: tour_point_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE tour_point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tour_point_id_seq OWNER TO mazvv;

--
-- Name: tour_point_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE tour_point_id_seq OWNED BY tour_sale_point.id;


--
-- Name: tour_sale_invoice; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE tour_sale_invoice (
    tour_sale_id integer NOT NULL,
    invoice_id integer NOT NULL
);


ALTER TABLE tour_sale_invoice OWNER TO mazvv;

--
-- Name: tour_sale_person; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE tour_sale_person (
    tour_sale_id integer NOT NULL,
    person_id integer NOT NULL
);


ALTER TABLE tour_sale_person OWNER TO mazvv;

--
-- Name: tour_sale_service_item; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE tour_sale_service_item (
    tour_sale_id integer NOT NULL,
    service_item_id integer NOT NULL
);


ALTER TABLE tour_sale_service_item OWNER TO mazvv;

--
-- Name: touroperator; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE touroperator (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE touroperator OWNER TO mazvv;

--
-- Name: touroperator_bank_detail; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE touroperator_bank_detail (
    touroperator_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


ALTER TABLE touroperator_bank_detail OWNER TO mazvv;

--
-- Name: touroperator_bperson; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE touroperator_bperson (
    touroperator_id integer NOT NULL,
    bperson_id integer NOT NULL
);


ALTER TABLE touroperator_bperson OWNER TO mazvv;

--
-- Name: touroperator_commission; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE touroperator_commission (
    touroperator_id integer NOT NULL,
    commission_id integer NOT NULL
);


ALTER TABLE touroperator_commission OWNER TO mazvv;

--
-- Name: touroperator_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE touroperator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE touroperator_id_seq OWNER TO mazvv;

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


ALTER TABLE touroperator_licence OWNER TO mazvv;

--
-- Name: touroperator_subaccount; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE touroperator_subaccount (
    touroperator_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


ALTER TABLE touroperator_subaccount OWNER TO mazvv;

--
-- Name: transfer; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE transfer (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE transfer OWNER TO mazvv;

--
-- Name: transfer_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transfer_id_seq OWNER TO mazvv;

--
-- Name: transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE transfer_id_seq OWNED BY cashflow.id;


--
-- Name: transfer_id_seq1; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE transfer_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transfer_id_seq1 OWNER TO mazvv;

--
-- Name: transfer_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE transfer_id_seq1 OWNED BY transfer.id;


--
-- Name: wish; Type: TABLE; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE TABLE wish (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    service_id integer NOT NULL,
    currency_id integer,
    price_from numeric(16,2),
    price_to numeric(16,2),
    descr character varying(1024) NOT NULL
);


ALTER TABLE wish OWNER TO mazvv;

--
-- Name: wish_id_seq; Type: SEQUENCE; Schema: public; Owner: mazvv
--

CREATE SEQUENCE wish_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wish_id_seq OWNER TO mazvv;

--
-- Name: wish_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mazvv
--

ALTER SEQUENCE wish_id_seq OWNED BY wish.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY accomodation_type ALTER COLUMN id SET DEFAULT nextval('accomodation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY account ALTER COLUMN id SET DEFAULT nextval('account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY account_item ALTER COLUMN id SET DEFAULT nextval('account_item_id_seq'::regclass);


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

ALTER TABLE ONLY calculation ALTER COLUMN id SET DEFAULT nextval('calculation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY cashflow ALTER COLUMN id SET DEFAULT nextval('transfer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY commission ALTER COLUMN id SET DEFAULT nextval('commission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY company ALTER COLUMN id SET DEFAULT nextval('company_id_seq'::regclass);


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

ALTER TABLE ONLY crosspayment ALTER COLUMN id SET DEFAULT nextval('crosspayment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY currency ALTER COLUMN id SET DEFAULT nextval('_currencies_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY currency_rate ALTER COLUMN id SET DEFAULT nextval('currency_rate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY email_campaign ALTER COLUMN id SET DEFAULT nextval('email_campaign_id_seq'::regclass);


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

ALTER TABLE ONLY general_service ALTER COLUMN id SET DEFAULT nextval('general_service_id_seq'::regclass);


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

ALTER TABLE ONLY income ALTER COLUMN id SET DEFAULT nextval('income_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY invoice ALTER COLUMN id SET DEFAULT nextval('invoice_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY lead ALTER COLUMN id SET DEFAULT nextval('lead_id_seq'::regclass);


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

ALTER TABLE ONLY note ALTER COLUMN id SET DEFAULT nextval('note_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY notification ALTER COLUMN id SET DEFAULT nextval('notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY offer ALTER COLUMN id SET DEFAULT nextval('offer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "order" ALTER COLUMN id SET DEFAULT nextval('order_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY order_item ALTER COLUMN id SET DEFAULT nextval('order_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY outgoing ALTER COLUMN id SET DEFAULT nextval('outgoing_id_seq'::regclass);


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

ALTER TABLE ONLY service ALTER COLUMN id SET DEFAULT nextval('service_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_item ALTER COLUMN id SET DEFAULT nextval('service_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_sale ALTER COLUMN id SET DEFAULT nextval('service_sale_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure ALTER COLUMN id SET DEFAULT nextval('structures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY subaccount ALTER COLUMN id SET DEFAULT nextval('subaccount_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY supplier ALTER COLUMN id SET DEFAULT nextval('supplier_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY task ALTER COLUMN id SET DEFAULT nextval('task_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale ALTER COLUMN id SET DEFAULT nextval('tour_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_point ALTER COLUMN id SET DEFAULT nextval('tour_point_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator ALTER COLUMN id SET DEFAULT nextval('touroperator_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY transfer ALTER COLUMN id SET DEFAULT nextval('transfer_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('_users_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY wish ALTER COLUMN id SET DEFAULT nextval('wish_id_seq'::regclass);


--
-- Name: _currencies_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_currencies_rid_seq', 57, true);


--
-- Name: _employees_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_employees_rid_seq', 30, true);


--
-- Name: _regions_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_regions_rid_seq', 37, true);


--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_logs_rid_seq', 6739, true);


--
-- Name: _resources_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_rid_seq', 2133, true);


--
-- Name: _resources_types_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_resources_types_rid_seq', 138, true);


--
-- Name: _users_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('_users_rid_seq', 31, true);


--
-- Name: accomodation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('accomodation_id_seq', 17, true);


--
-- Data for Name: accomodation_type; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY accomodation_type (id, resource_id, name) FROM stdin;
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
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY account (id, resource_id, currency_id, account_type, name, display_text, descr) FROM stdin;
2	1438	56	0	Main Bank Account	some display text	\N
3	1439	56	1	Main Cash Account	cash payment	\N
4	1507	54	1	Main Cash EUR Account	Main Cash EUR Account	\N
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('account_id_seq', 4, true);


--
-- Data for Name: account_item; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY account_item (id, resource_id, name) FROM stdin;
1	1426	Tours Sales
2	1431	Additional Services Sale
3	1432	Rent Payments
4	1608	Refunds
5	1609	Payments To Suppliers
6	1769	Payments To Touroperators
7	1780	Account Initialization
8	1873	Payment On Invoice
9	1898	Cashing In
\.


--
-- Name: account_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('account_item_id_seq', 9, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY address (id, resource_id, location_id, zip_code, address) FROM stdin;
10	1288	14	02312	Bogdana Hmelnickogo Str
13	1308	5	12354	asdf asdf asdfsadf
14	1309	14	12345	dsfg sdfg sdfg sdfgsdfgdsf
15	1370	14	11111	Polyarnaya str., 18 A, 181
16	1374	14	11111	Polyarnaya str. 18 A, 181
17	1382	14	11111	Chavdar Elisabet, 13
18	1388	14	11111	Chavdar Elisabet, 13
19	1391	14	1111	Chavdar Elisabeth, 13
20	1407	14	11111	Radujnaya str., 56 a, 153
21	1414	14	01011	Leskova str., 9
22	1418	33	12345	Naberegnaya Pobedy, 50
23	1469	34	09909	Lavrska, str 34
24	1585	14	08967	Solomii Krushelnickoi, 34/3, ap. 45
25	1614	14	678565	Pobedy, 56/2, ap.67
26	1623	14	8934	Artema 8d, 47
27	1644	34	67234	Sichovih Strilciv, 2.
28	1652	14	54415	Vasilkovskaya 45/56, 19
29	1807	14	02121	Dekabristov str, filial #239
30	1926	14	123432	Arsenalna str
31	1951	14	02121	Gmiry str
32	2015	14	09878	Kikvidze 29, 56
33	2119	14	02121	Bazhana str.3
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('address_id_seq', 33, true);


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
265684c8e5c4
\.


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY appointment (id, resource_id, currency_id, employee_id, position_id, salary, date) FROM stdin;
1	789	54	2	4	1000.00	2014-02-02
6	892	54	7	5	4500.00	2014-02-22
8	1542	54	2	4	6500.00	2014-03-01
\.


--
-- Data for Name: apscheduler_jobs; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY apscheduler_jobs (id, next_run_time, job_state) FROM stdin;
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY bank (id, resource_id, name) FROM stdin;
1	1214	Bank of America
4	1415	Raiffaisen Bank Aval
5	1419	PrivatBank
\.


--
-- Data for Name: bank_address; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY bank_address (bank_id, address_id) FROM stdin;
5	29
5	33
\.


--
-- Data for Name: bank_detail; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY bank_detail (id, resource_id, currency_id, bank_id, beneficiary, account, swift_code) FROM stdin;
5	1420	56	4	LuxTravel, Inc	123456789	123456
6	1510	54	1	Coral Travel	12345	1234
7	1511	57	1	Coral LLC	98765	0987
8	1512	57	1	Coral LLc	0987654	12234
9	1513	56	5	Coral Travel Ukraine	567990	54343
10	1514	44	5	Coral LLc	123232321312	`12
11	1515	54	4	Coral LLC	1223456	55667
12	1554	56	5	Intertelecom	12345678	09876
13	1556	56	5	Intertelecom	12345678	09876
14	1564	56	4	Lun Real Estate	78900909	12343434
15	1569	56	5	Lun Real Estate Agency	987456152	671283
16	1570	56	4	Intertelecom Internet Service Provider	9878723847	84758GH
18	2120	57	4	sdghsdgh	sghsgh	dfghdfhgdfh
\.


--
-- Name: bank_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('bank_detail_id_seq', 18, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('bank_id_seq', 6, true);


--
-- Data for Name: bperson; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY bperson (id, resource_id, first_name, last_name, second_name, position_name) FROM stdin;
1	1009	Alexandro	Riak		Sales Manager
2	1010	Umberto			Accounting
6	1560	Ivan	Gonchar		Account Manager
7	1563	Alexander	Tkachuk		manager
5	1553	Sergey	Vlasov		Main account manager
8	1578	Anna			Manager
\.


--
-- Data for Name: bperson_contact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY bperson_contact (bperson_id, contact_id) FROM stdin;
1	54
1	55
1	56
1	57
5	61
5	62
6	63
7	64
7	65
8	66
\.


--
-- Name: bperson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('bperson_id_seq', 8, true);


--
-- Data for Name: calculation; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY calculation (id, resource_id, service_item_id, currency_id, price, base_price) FROM stdin;
3	1852	33	56	56826.88	56826.88
5	1854	36	54	3140.72	57161.10
6	1855	37	54	3556.00	59385.20
4	1853	\N	57	2150.34	25804.08
9	1859	34	57	2156.34	25876.08
10	1860	31	57	29.84	358.08
16	1918	39	54	3534.00	59017.80
17	1988	41	56	23000.00	23000.00
18	2029	44	57	2017.78	42171.60
19	2030	43	56	3450.00	3450.00
20	2031	42	56	750.00	750.00
23	2038	45	56	1105.00	1105.00
24	2039	46	56	1105.00	1105.00
29	2044	3	54	17.00	283.90
30	2045	17	57	54.00	653.40
31	2046	18	57	54.00	653.40
32	2047	19	54	17.00	283.90
\.


--
-- Name: calculation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('calculation_id_seq', 32, true);


--
-- Data for Name: cashflow; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY cashflow (id, account_from_id, subaccount_from_id, account_to_id, subaccount_to_id, account_item_id, sum, date) FROM stdin;
31	\N	\N	\N	8	8	80.00	2014-11-12
32	\N	8	3	\N	2	80.00	2014-11-12
41	\N	\N	\N	6	8	560.00	2014-11-09
42	\N	6	3	\N	2	540.00	2014-11-09
43	\N	\N	\N	8	8	1975.00	2014-11-12
44	\N	8	3	\N	2	1894.80	2014-11-12
57	\N	\N	3	\N	7	19722.96	2014-07-01
59	\N	\N	2	\N	7	20000.00	2014-09-01
60	2	\N	3	\N	9	4500.00	2014-11-18
63	\N	\N	\N	11	8	3000.00	2014-11-22
64	\N	11	4	\N	1	3000.00	2014-11-22
68	\N	8	\N	\N	4	100.20	2014-11-14
70	\N	3	\N	\N	4	10.00	2014-11-23
71	\N	10	\N	\N	3	8200.00	2014-11-18
73	\N	12	\N	\N	6	15000.00	2014-11-23
77	\N	\N	\N	4	8	29880.00	2015-01-02
78	\N	4	3	\N	1	29880.00	2015-01-02
79	\N	\N	\N	13	8	3000.00	2014-12-18
80	\N	13	3	\N	1	3000.00	2014-12-18
81	\N	\N	\N	13	8	6000.00	2015-01-13
82	\N	13	3	\N	1	6000.00	2015-01-13
83	\N	\N	\N	13	8	11000.00	2015-01-11
84	\N	13	3	\N	1	11000.00	2015-01-11
85	\N	\N	\N	13	8	3000.00	2015-01-15
86	\N	13	3	\N	1	3000.00	2015-01-15
87	\N	\N	\N	14	8	64576.00	2015-01-12
88	\N	14	3	\N	1	64576.00	2015-01-12
89	\N	\N	\N	15	8	750.00	2015-01-16
90	\N	15	3	\N	2	750.00	2015-01-16
91	\N	\N	\N	16	8	3450.00	2015-01-14
92	\N	16	3	\N	2	3450.00	2015-01-14
93	\N	\N	\N	17	8	48697.00	2015-02-01
94	\N	17	3	\N	1	48697.00	2015-02-01
\.


--
-- Data for Name: commission; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY commission (id, date_from, resource_id, service_id, percentage, price, currency_id) FROM stdin;
14	2014-06-28	1535	5	13.20	0.00	56
15	2014-06-28	1536	5	13.20	0.00	57
16	2014-06-28	1537	5	13.40	0.00	56
17	2014-06-28	1538	5	13.40	0.00	56
18	2014-06-28	1539	4	0.00	10.00	56
19	2014-06-28	1540	3	0.00	10.00	56
20	2014-06-28	1541	1	0.00	600.00	56
21	2014-08-17	1579	5	12.00	0.00	56
22	2014-08-01	1714	1	0.00	10.00	54
23	2014-08-01	1721	5	12.00	0.00	57
24	2014-05-01	1917	5	11.00	0.00	56
25	2014-01-01	2011	5	10.00	0.00	56
26	2014-01-01	2032	4	15.00	0.00	56
\.


--
-- Name: commission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('commission_id_seq', 26, true);


--
-- Name: companies_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('companies_positions_id_seq', 8, true);


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY company (id, resource_id, name, currency_id, settings, email) FROM stdin;
1	1970	LuxTravel, Inc	56	{"locale": "en", "timezone": "Europe/Kiev"}	lux.travel@gmai.com
\.


--
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('company_id_seq', 1, true);


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY contact (id, contact, resource_id, contact_type) FROM stdin;
27	+380681983869	1193	0
29	+380681983869	1195	0
30	+380681983869	1201	0
32	+380681983869	1204	0
36	+380681983869	1244	0
37	+380681983869	1257	0
39	+380681983869	1259	0
41	+380682523645	1263	0
44	+380675625353	1282	0
45	+380502355565	1285	0
47	+380673566789	1371	0
48	+380502314567	1373	0
51	+380502232233	1387	0
52	+380502354235	1404	0
53	+380503435512	1464	0
54	+380976543565	1516	0
55	+380675643623	1517	0
58	+380681983800	1543	0
61	+380681234567	1551	0
64	+380953434358	1561	0
67	+380672568976	1581	0
68	+380672346534	1591	0
69	+380500567765	1610	0
71	+380503435436	1620	0
73	+380975642876	1624	0
74	+380665638900	1640	0
76	+380502235686	1650	0
77	+380674523123	1927	0
79	+380923435643	2013	0
80	+380505674534	2018	0
81	+380671238943	2050	0
28	asdasd@mail.com	1194	1
35	vitalii.mazur@gmail.com	1243	1
38	vitalii.mazur@gmail.com	1258	1
40	vitalii.mazur@gmail.com	1260	1
42	a.koff@gmail.com	1264	1
46	n.voevoda@gmail.com	1304	1
57	ravak@myemail.com	1519	1
60	info@travelcrm.org.ua	1545	1
63	i_gonchar@i-tele.com	1559	1
65	mega_tkach@ukr.net	1562	1
70	artyuh87@gmail.com	1611	1
72	grach18@ukr.net	1621	1
75	karpuha1990@ukr.net	1641	1
78	vitalii.mazur@gmail.com	1956	1
49	travelcrm	1379	2
56	ravak_skype	1518	2
59	dorianyats	1544	2
62	serge_vlasov	1552	2
66	AnnaNews	1577	2
50	+380682345688	1380	0
82	+380676775643	2089	0
83	nikolay1987@mail.ru	2095	1
\.


--
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('contact_id_seq', 83, true);


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
12	1164	HR	Croatia
13	1169	AE	United Arab Emirates
14	1178	ES	Spain
16	1339	CY	Cyprus
17	1343	IT	Italy
11	1100	DE	Germany
18	1351	GR	Greece
19	1646	FR	France
\.


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('country_id_seq', 20, true);


--
-- Data for Name: crosspayment; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY crosspayment (id, resource_id, cashflow_id, descr) FROM stdin;
6	1893	57	Account init
8	1900	59	Init Bank Account in UAH
9	1901	60	Some Cashing in
\.


--
-- Name: crosspayment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('crosspayment_id_seq', 9, true);


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
-- Data for Name: currency_rate; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY currency_rate (id, resource_id, date, currency_id, rate) FROM stdin;
1	1396	2014-05-19	57	12.10
3	1398	2014-05-19	54	16.70
5	1400	2014-05-16	57	11.99
6	1401	2014-05-16	54	16.60
7	1402	2014-05-15	54	16.80
8	1403	2014-05-15	57	11.80
9	1504	2014-06-20	54	16.70
10	1505	2014-06-20	57	12.00
11	1506	2014-06-20	44	0.37
12	1597	2014-08-21	54	18.20
13	2023	2015-02-01	54	22.43
14	2024	2015-02-01	57	20.90
\.


--
-- Name: currency_rate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('currency_rate_id_seq', 14, true);


--
-- Data for Name: email_campaign; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY email_campaign (id, resource_id, name, plain_content, html_content, start_dt, subject) FROM stdin;
1	1955	Egypt HOT!!!	Hello.<p>Look at this</p>	      <meta content="text/html; charset=utf-8" http-equiv="Content-Type">    <title>      Boutique    </title><style type="text/css">a:hover { text-decoration: none !important; }.header h1 {color: #ede6cb !important; font: normal 24px Georgia, serif; margin: 0; padding: 0; line-height: 28px;}.header p {color: #645847; font: bold 11px Georgia, serif; margin: 0; padding: 0; line-height: 12px; text-transform: uppercase;}.content h2 {color:#393023 !important; font-weight: bold; margin: 0; padding: 0; line-height: 30px; font-size: 17px;font-family: Helvetica, Arial, sans-serif; }.content p {color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px; font-family: Helvetica, Arial, sans-serif;}.content a {color: #0fa2e6; text-decoration: none;}.footer p {font-size: 11px; color:#bfbfbf; margin: 0; padding: 0;font-family: Helvetica, Arial, sans-serif;}.footer a {color: #0fa2e6; text-decoration: none;}</style>      <table cellpadding="0" cellspacing="0" border="0" align="center" width="100%" style="background: url('images/bg_email.jpg') no-repeat center top; padding: 85px 0 35px">  <tbody><tr>  <td align="center">    <table cellpadding="0" cellspacing="0" border="0" align="center" width="599" style="font-family: Georgia, serif; background: url('images/bg_header.jpg') no-repeat center top" height="142">      <tbody><tr>        <td style="margin: 0; padding: 40px 0 0; background: #c89c22 url('images/bg_header.jpg') no-repeat center top" align="center" valign="top"><h1 style="color: #ede6cb !important; font: normal 24px Georgia, serif; margin: 0; padding: 0; line-height: 28px;">Grandma's Sweets &amp; Cookies</h1>    </td>      </tr>  <tr>        <td style="margin: 0; padding: 25px 0 0;" align="center" valign="top"><p style="color: #645847; font: bold 11px Georgia, serif; margin: 0; padding: 0; line-height: 12px; text-transform: uppercase;">ESTABLISHED 1405</p>        </td>      </tr>  <tr>  <td style="font-size: 1px; height: 15px; line-height: 1px;" height="15">&nbsp;</td>  </tr></tbody></table><!-- header--><table cellpadding="0" cellspacing="0" border="0" align="center" width="599" style="font-family: Georgia, serif;">      <tbody><tr>        <td width="599" valign="top" align="left" bgcolor="#ffffff" style="font-family: Georgia, serif; background: #fff; border-top: 5px solid #e5bd5f"><table cellpadding="0" cellspacing="0" border="0" style="color: #717171; font: normal 11px Georgia, serif; margin: 0; padding: 0;" width="599"><tbody><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 15px 0 5px; font-family: Georgia, serif;" valign="top" align="center" width="569"><img src="images/divider_top_full.png" alt="divider"><br></td><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><h2 style="color:#393023 !important; font-weight: bold; margin: 0; padding: 0; line-height: 30px; font-size: 17px;font-family: Helvetica, Arial, sans-serif;">Meet Jack — a brown cow.</h2><p style="color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px;">Suspendisse potenti--Fusce eu ante in sapien vestibulum sagittis. Cras purus. Nunc rhoncus. <a href="#" style="color: #0fa2e6; text-decoration: none;">Donec imperdiet</a>, nibh sit amet pharetra placerat, tortor purus condimentum lectus.</p></td><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><img src="images/img.jpg" alt="Cow" style="border: 5px solid #f7f7f4;"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><p style="color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px;">Suspendisse potenti--Fusce eu <a href="#" style="color: #0fa2e6; text-decoration: none;">ante in sapien</a> vestibulum sagittis.</p></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><img src="images/divider_full.png" alt="divider"></td><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 55px; font-family: Helvetica, Arial, sans-serif;" align="left"><h2 style="color:#393023 !important; font-weight: bold; margin: 0; padding: 0; line-height: 30px; font-size: 17px;font-family: Helvetica, Arial, sans-serif;">Cookies feels more valuable now than before</h2><p style="color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px;">Suspendisse potenti--Fusce eu ante in sapien vestibulum sagittis. Cras purus. Nunc rhoncus. Donec imperdiet, nibh sit amet pharetra placerat, tortor purus condimentum lectus. Says Doctor Lichtenstein in an interview done after last nights press conference in Belgium.<a href="#" style="color: #0fa2e6; text-decoration: none;">Dr. Lichtenstein</a> also states his concerns regarding chocolate now suddenly turning yellow the last couple of years. </p></td></tr>  </tbody></table></td>      </tr> <tr>  <td style="font-size: 1px; height: 10px; line-height: 1px;" height="10"><img src="images/spacer.gif" alt="space" width="15"></td>  </tr></tbody></table><!-- body --><table cellpadding="0" cellspacing="0" border="0" align="center" width="599" style="font-family: Georgia, serif; line-height: 10px;" bgcolor="#464646" class="footer">      <tbody><tr>        <td bgcolor="#464646" align="center" style="padding: 15px 0 10px; font-size: 11px; color:#bfbfbf; margin: 0; line-height: 1.2;font-family: Helvetica, Arial, sans-serif;" valign="top"><p style="font-size: 11px; color:#bfbfbf; margin: 0; padding: 0;font-family: Helvetica, Arial, sans-serif;">You're receiving this newsletter because you bought widgets from us. </p><p style="font-size: 11px; color:#bfbfbf; margin: 0 0 10px 0; padding: 0;font-family: Helvetica, Arial, sans-serif;">Having trouble reading this? <webversion style="color: #0fa2e6; text-decoration: none;">View it in your browser</webversion>. Not interested anymore? <unsubscribe style="color: #0fa2e6; text-decoration: none;">Unsubscribe</unsubscribe> Instantly.</p></td>      </tr>  </tbody></table><!-- footer-->  </td></tr>    </tbody></table>  	2014-12-28 19:18:00	Hot New Year in Egypt
\.


--
-- Name: email_campaign_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('email_campaign_id_seq', 1, true);


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
12	1043	Denis	Yurin	\N	\N	2014-04-01	\N
14	1045	Dima	Shkreba	\N	\N	2013-04-30	\N
7	885	Irina	Mazur	V.	\N	\N	employee/f8ce7007-df56-471c-a330-c43b678ed2ae.jpg
2	784	John	Doe	\N	\N	\N	employee/e588d949-e13f-43cc-aa0f-115354289850.jpg
15	1046	Viktoriia	Lastovets	\N	\N	2014-04-29	\N
30	2053	Igor	Mazur	\N	\N	\N	employee/5a83ffee-5bd2-4ba8-a82a-cea9a88c4d82.jpg
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
2	60
2	58
2	59
\.


--
-- Data for Name: employee_notification; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employee_notification (employee_id, notification_id, status) FROM stdin;
2	18	1
2	20	1
2	19	1
2	21	0
2	22	0
\.


--
-- Data for Name: employee_passport; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employee_passport (employee_id, passport_id) FROM stdin;
13	7
\.


--
-- Data for Name: employee_subaccount; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY employee_subaccount (employee_id, subaccount_id) FROM stdin;
2	1
\.


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('employees_appointments_h_id_seq', 9, true);


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

SELECT pg_catalog.setval('foodcat_id_seq', 17, true);


--
-- Data for Name: general_service; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY general_service (id, resource_id, order_item_id) FROM stdin;
\.


--
-- Name: general_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('general_service_id_seq', 1, false);


--
-- Data for Name: hotel; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY hotel (id, resource_id, hotelcat_id, name, location_id) FROM stdin;
10	1292	5	Hotel View Novi Vindolski	16
11	1320	5	PGS Kiris Resort	17
12	1322	5	Justiniano Club Park Conti	18
13	1323	5	PGS World Palace	17
14	1324	5	Concordia Celes Hotel	18
15	1325	5	Akka Alinda Hotel	17
16	1327	5	Grand Haber Hotel	19
17	1330	5	Belconti Resort	20
18	1331	3	Asdem Park	19
19	1334	4	Saphir	21
20	1335	4	Justiniano Club Alanya	18
21	1338	6	Euphoria Palm Beach	22
22	1342	4	Avlida	23
23	1346	3	Calypso	24
24	1349	4	Citta Del Mare	25
25	1350	4	Villa Adriatica	24
26	1354	4	Aldemar Cretan Village	26
27	1357	4	Estival Park Salou Hotel	27
28	1358	3	Playa Park	27
29	1360	4	Best Negresco	28
30	1362	4	Oasis Park & SPA	29
31	1364	5	The Desert Rose Resort	30
32	1367	4	Rehana Sharm Resort	31
33	1386	4	Fantasia	32
34	1470	5	Villa Augusto	21
35	1590	5	Lindos Blue	36
36	1649	5	Sezz Saint-Tropez	37
38	2111	5	Spirit of the Knights Boutique	36
\.


--
-- Name: hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('hotel_id_seq', 38, true);


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
-- Data for Name: income; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY income (id, resource_id, invoice_id) FROM stdin;
5	1447	10
6	1448	8
7	1485	10
20	1500	13
23	1509	14
24	1546	13
25	1547	13
33	1607	16
34	1639	17
35	1660	19
37	1876	21
40	1880	13
41	1882	13
42	1910	14
43	1990	22
44	1992	20
45	1993	22
46	1994	22
47	1995	22
48	1996	19
49	2001	23
50	2006	24
51	2027	26
\.


--
-- Data for Name: income_cashflow; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY income_cashflow (income_id, cashflow_id) FROM stdin;
\.


--
-- Name: income_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('income_id_seq', 51, true);


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY invoice (id, date, resource_id, account_id, active_until) FROM stdin;
8	2014-06-05	1440	3	2014-06-05
10	2014-06-06	1442	2	2014-06-06
13	2014-06-16	1487	3	2014-06-16
15	2014-06-16	1503	3	2014-06-16
14	2014-06-22	1502	4	2014-06-22
16	2014-08-22	1598	3	2014-08-22
17	2014-08-24	1634	3	2014-08-24
19	2014-08-26	1657	3	2014-08-26
20	2014-10-18	1839	3	2014-10-18
21	2014-10-24	1840	3	2014-10-27
22	2015-01-15	1987	3	2015-01-18
24	2015-01-14	2005	3	2015-01-17
23	2015-01-16	2000	3	2015-01-20
26	2015-02-01	2026	3	2015-02-04
\.


--
-- Name: invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('invoice_id_seq', 26, true);


--
-- Data for Name: lead; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY lead (id, lead_date, resource_id, advsource_id, customer_id, status) FROM stdin;
2	2015-02-04	2088	5	46	0
1	2015-02-04	2052	6	47	1
\.


--
-- Name: lead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('lead_id_seq', 2, true);


--
-- Data for Name: lead_offer; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY lead_offer (lead_id, offer_id) FROM stdin;
\.


--
-- Data for Name: lead_wish; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY lead_wish (lead_id, wish_id) FROM stdin;
\.


--
-- Data for Name: licence; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY licence (id, licence_num, date_from, date_to, resource_id) FROM stdin;
43	dfgfdgdf	2014-04-22	2014-04-22	1191
44	TTR-123456	2014-04-15	2014-04-23	1192
46	TY678234-89	2011-06-10	2017-08-18	1576
47	LNU7862	2014-12-19	2019-12-31	1952
\.


--
-- Name: licence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('licence_id_seq', 47, true);


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
17	1319	Kirish	10
18	1321	Okurcalar	12
19	1326	Kemer	10
20	1329	Belek	24
21	1333	Konacli	25
22	1337	Kizilagac	26
23	1341	Paphos	27
24	1345	Marino Centro	28
25	1348	Terrasini	29
26	1353	Hersonissos	30
27	1356	La Pineda	31
28	1359	Salou	31
29	1361	Lorett de Marr	18
30	1363	Hurgada	9
31	1366	Nabk Bey	32
32	1385	Svalyava	33
33	1417	Dnepropetrovsk	34
34	1468	Lviv	22
35	1588	Diagoras Airport	35
36	1589	Rhodos	35
37	1648	Saint-Tropez	36
\.


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('location_id_seq', 38, true);


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY navigation (id, position_id, parent_id, name, url, icon_cls, sort_order, resource_id, separator_before, action) FROM stdin;
168	4	32	Orders	/order	\N	5	2101	f	tab_open
165	4	8	Company	/company/edit	\N	4	1975	t	dialog_open
9	4	8	Resource Types	/resource_type	\N	1	779	f	\N
13	4	10	Employees	/employee	\N	1	790	f	\N
14	4	10	Employees Appointments	/appointment	\N	2	791	f	\N
15	4	8	Users	/user	\N	3	792	f	\N
19	4	18	Structures	/structure	\N	1	838	f	\N
20	4	18	Positions	/position	\N	2	863	f	\N
22	4	21	Persons	/person	\N	1	866	f	\N
27	4	26	Advertising Sources	/advsource	\N	1	902	f	\N
162	4	160	Debts	/debt	\N	2	1921	f	\N
163	4	26	Email Campaigns	/email_campaign	\N	2	1953	t	\N
166	4	32	Leads	/lead	\N	2	2048	f	tab_open
41	5	\N	Home	/	fa fa-home	1	1079	f	\N
47	5	\N	For Test	/	fa fa-credit-card	2	1253	f	\N
48	6	\N	Home	/	fa fa-home	1	1079	f	\N
49	6	\N	For Test	/	fa fa-credit-card	2	1253	f	\N
53	4	\N	Finance	/	fa fa-credit-card	7	1394	f	\N
156	4	53	Billing	/	\N	10	1905	f	\N
107	4	\N	Home	/	fa fa-home	1	1777	f	\N
32	4	\N	Sales	/	fa fa-legal	2	998	f	\N
21	4	\N	Clientage	/	fa fa-briefcase	3	864	f	\N
26	4	\N	Marketing	/	fa fa-bullhorn	4	900	f	\N
10	4	\N	HR	/	fa fa-group	5	780	f	\N
18	4	\N	Company	/	fa fa-building-o	6	837	f	\N
23	4	\N	Directories	/	fa fa-book	8	873	f	\N
152	4	\N	Reports	/	fa fa-pie-chart	9	1895	f	\N
8	4	\N	System	/	fa fa-cog	10	778	f	\N
155	4	53	Payments	/	\N	12	1904	f	\N
158	4	23	Geography	/	\N	13	1907	f	\N
160	4	152	Billing	/	\N	2	1909	f	\N
157	4	53	Currencies		\N	7	1906	t	\N
43	4	158	Locations	/location	\N	3	1089	f	\N
159	4	23	Hotels	/	\N	12	1908	t	\N
55	4	156	Accounts Items	/account_item	\N	3	1425	f	\N
17	4	157	Currencies List	/currency	\N	7	802	f	\N
24	4	158	Countries	/country	\N	4	874	f	\N
25	4	158	Regions	/region	\N	3	879	f	\N
28	4	159	Hotels Categories	/hotelcat	\N	6	910	f	\N
29	4	159	Rooms Categories	/roomcat	\N	7	911	f	\N
30	4	159	Accomodations Types	/accomodation_type	\N	10	955	f	tab_open
31	4	159	Food Categories	/foodcat	\N	9	956	f	\N
38	4	32	Tours	/tour_sale	\N	3	1075	t	tab_open
42	4	159	Hotels List	/hotel	\N	5	1080	f	\N
45	4	53	Banks	/bank	\N	5	1212	f	\N
50	4	53	Services List	/service	\N	6	1312	f	\N
51	4	32	Invoices	/invoice	\N	4	1368	f	\N
52	4	32	Services	/service_sale	\N	4	1369	f	\N
54	4	157	Currencies Rates	/currency_rate	\N	8	1395	f	\N
56	4	155	Income Payments	/income	\N	9	1434	f	\N
57	4	156	Accounts	/account	\N	1	1436	f	\N
61	4	155	Outgoing Payments	/outgoing	\N	10	1571	f	\N
151	4	155	Cross Payments	/crosspayment	\N	11	1885	f	\N
153	4	160	Turnovers	/turnover	\N	1	1896	f	\N
150	4	156	Subaccounts	/subaccount	\N	2	1798	f	\N
60	4	23	Suppliers	/supplier	\N	6	1550	f	\N
35	4	23	Touroperators	/touroperator	\N	9	1002	f	\N
36	4	23	Business Persons	/bperson	\N	10	1008	f	\N
169	4	23	Transfers	/transfer	\N	11	2128	f	tab_open
\.


--
-- Data for Name: note; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY note (id, resource_id, title, descr) FROM stdin;
1	1800	Для тестирования	\N
2	1801	For testing purpose	\N
3	1802	This resource type is under qustion	<b>Seems we need new schema for accounting.</b>
4	1803	I had asked questions for expert in accounting	Alexander said that the most appopriate schema is to use accounts for each object such as persons, touroperators and so on
5	1804	Need to ask questions to expert	\N
18	1833	Main Developer of TravelCRM	The main developer of TravelCRM
24	1872	For users	This subaccount is for Person Garkaviy Andrew
25	1924	Passport detalized	There is no information about passport
26	1931	Resource Task	This is for resource only
27	1979	Test Note	Description to test note
28	1981	VIP User	This user is for VIP
29	2012	Good Hotel	Edit description for Hotels note
30	2065	Note without source resource	This note was created directly from Tools Panel
31	2087	Good customer	Good customer in any case
32	2092	Failure	Customer failure from offers
33	2096	For test purpose only	\N
34	2097	Failure 2	\N
35	2098	New property SERVICE_TYPE	Add new property for services - SERVICE_TYPE. There is 2 types - common and tour.
36	2132	New note for Lastovec	Test Note for User
\.


--
-- Name: note_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('note_id_seq', 36, true);


--
-- Data for Name: note_resource; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY note_resource (note_id, resource_id) FROM stdin;
3	1797
5	1797
24	1868
25	1928
28	3
18	784
29	1470
26	1930
27	1980
31	2088
33	970
32	2052
34	2052
35	1413
36	2126
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY notification (id, resource_id, title, descr, created, url) FROM stdin;
3	1945	A reminder of the task #42	Do not forget about task!	2014-12-14 19:51:00.013635	\N
4	1946	A reminder of the task #42	Do not forget about task!	2014-12-14 20:31:00.012771	\N
5	1947	A reminder of the task #40	Do not forget about task!	2014-12-14 20:32:00.061386	\N
6	1948	A reminder of the task #42	Do not forget about task!	2014-12-14 20:34:00.011181	\N
7	1949	A reminder of the task #42	Do not forget about task!	2014-12-14 20:35:00.011903	\N
8	1950	A reminder of the task #42	Do not forget about task!	2014-12-14 20:38:00.01699	\N
9	1959	A reminder of the task #44	Do not forget about task!	2014-12-21 19:21:00.016784	\N
10	1961	Task: #44	Test new scheduler realization	2014-12-21 19:44:00.016315	\N
11	1963	Task: Test	Test	2014-12-24 21:33:00.014126	\N
12	1965	Task: For testing	For testing	2014-12-25 21:06:00.013657	\N
13	1972	Task: Check Payments	Check Payments	2015-01-04 12:46:00.019127	\N
14	1973	Task: Check Payments	Check Payments	2015-01-04 14:06:00.016859	\N
15	1984	Task: Test	Test	2015-01-13 17:01:00.018967	\N
16	1986	Task: Test 2	Test 2	2015-01-13 17:04:00.011637	\N
17	2010	Task: I decided to try to follow the postgres approach as directly as possible and came up with the following migration.	I decided to try to follow the postgres approach as directly as possible and came up with the following migration.	2015-01-21 21:45:00.013037	\N
18	2064	Task: Revert status after testing	Revert status after testing	2015-03-08 18:42:00.01327	\N
19	2067	Task: Notifications testing #2	Notifications testing #2	2015-03-09 17:17:00.020674	\N
20	2069	Task: Test Notification resource link	Test Notification resource link	2015-03-09 19:29:00.018282	\N
21	2076	Task: Call about discounts	Call about discounts	2015-03-21 17:10:00.014771	\N
22	2133	Task: Task For Lastovec	Task For Lastovec	2015-04-22 15:40:00.007831	\N
\.


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('notification_id_seq', 22, true);


--
-- Data for Name: notification_resource; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY notification_resource (notification_id, resource_id) FROM stdin;
20	2068
21	2075
22	2131
\.


--
-- Data for Name: offer; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY offer (id, resource_id, service_id, currency_id, price, descr) FROM stdin;
\.


--
-- Name: offer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('offer_id_seq', 1, false);


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY "order" (id, deal_date, resource_id, customer_id, advsource_id, invoice_id, calculation_id) FROM stdin;
\.


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('order_id_seq', 1, false);


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY order_item (id, resource_id, order_id, service_id, currency_id, touroperator_id, price, base_price) FROM stdin;
3	2104	\N	5	56	62	454235.00	0.00
4	2105	\N	5	57	62	2134.00	0.00
5	2106	\N	4	56	62	12.00	0.00
\.


--
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('order_item_id_seq', 5, true);


--
-- Data for Name: outgoing; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY outgoing (id, resource_id, account_item_id, date, subaccount_id, sum) FROM stdin;
11	1883	4	2014-11-14	8	100.20
13	1903	3	2014-11-18	10	8200.00
14	1912	4	2014-11-23	3	10.00
16	1915	6	2014-11-23	12	15000.00
\.


--
-- Data for Name: outgoing_cashflow; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY outgoing_cashflow (outgoing_id, cashflow_id) FROM stdin;
\.


--
-- Name: outgoing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('outgoing_id_seq', 17, true);


--
-- Data for Name: passport; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY passport (id, country_id, num, descr, resource_id, end_date, passport_type) FROM stdin;
1	14	231654	\N	1199	\N	0
2	14	132456	\N	1200	\N	0
4	12	1234564	\N	1205	\N	0
5	14	Svxzvxz	xzcvxzcv	1206	\N	0
14	3	RT678123	Foreign Passport	1584	2015-08-21	0
15	3	TY67342	\N	1592	2015-08-28	0
17	3	ER781263	\N	1613	\N	0
21	3	RT7892634	\N	1643	2017-07-19	0
22	3	RT632453	\N	1651	2019-08-16	0
25	9	TY78534	\N	2019	2018-06-06	0
6	3	НК028057	\N	1261	\N	1
7	3	HJ123456	new passport	1265	\N	1
8	3	РМ12345	from Kiev region	1286	\N	1
9	3	HK123456	\N	1376	\N	1
10	3	HK12345	\N	1381	\N	1
11	3	PO123456	\N	1406	\N	1
12	3	TY3456	\N	1467	2016-04-10	1
13	3	YU78932	Ukrainian citizen passport	1582	\N	1
16	3	IO98676	\N	1612	\N	1
18	3	НК089564	\N	1622	\N	1
19	3	RE6712346	\N	1625	\N	1
20	3	HJ789665	\N	1642	\N	1
23	3	RTY	\N	1925	\N	1
24	3	HH67187	\N	2014	\N	1
\.


--
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('passport_id_seq', 25, true);


--
-- Data for Name: permision; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY permision (id, resource_type_id, position_id, permisions, structure_id, scope_type) FROM stdin;
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
21	1	4	{view}	\N	all
65	93	4	{view,add,edit,delete}	\N	all
67	1	6	{view}	\N	all
66	2	6	{view,add,edit,delete}	5	structure
68	1	7	{view}	\N	all
69	2	7	{view,add,edit,delete}	5	structure
70	101	4	{view,add,edit,delete}	\N	all
22	2	4	{view,add,edit,delete}	\N	all
71	102	4	{view,add,edit,delete}	\N	all
73	104	4	{view,add,edit,delete}	\N	all
74	105	4	{view,add,edit,delete}	\N	all
76	107	4	{view,add,edit,delete}	\N	all
77	108	4	{view,add,edit,delete}	\N	all
79	110	4	{view,add,edit,delete}	\N	all
80	111	4	{view,add,edit,delete}	\N	all
81	112	4	{view,add,edit,delete}	\N	all
78	109	4	{view,add,edit,delete,settings,calculation,invoice,contract}	\N	all
64	92	4	{view,add,edit,delete,settings,invoice,calculation,contract}	\N	all
85	65	8	{view,add,edit,delete}	\N	all
86	61	8	{view,add,edit,delete}	\N	all
87	59	8	{view,add,edit,delete}	\N	all
88	55	8	{view,add,edit,delete}	\N	all
89	41	8	{view,add,edit,delete}	\N	all
90	67	8	{view,add,edit,delete}	\N	all
91	69	8	{view,add,edit,delete}	\N	all
92	39	8	{view,add,edit,delete}	\N	all
93	70	8	{view,add,edit,delete}	\N	all
94	71	8	{view,add,edit,delete}	\N	all
95	72	8	{view,add,edit,delete}	\N	all
96	73	8	{view,add,edit,delete}	\N	all
97	74	8	{view,add,edit,delete}	\N	all
98	75	8	{view,add,edit,delete}	\N	all
99	78	8	{view,add,edit,delete}	\N	all
100	79	8	{view,add,edit,delete}	\N	all
101	47	8	{view,add,edit,delete}	\N	all
102	83	8	{view,add,edit,delete}	\N	all
103	84	8	{view,add,edit,delete}	\N	all
104	86	8	{view,add,edit,delete}	\N	all
105	87	8	{view,add,edit,delete}	\N	all
106	89	8	{view,add,edit,delete}	\N	all
107	90	8	{view,add,edit,delete}	\N	all
108	91	8	{view,add,edit,delete}	\N	all
109	1	8	{view}	\N	all
110	93	8	{view,add,edit,delete}	\N	all
111	101	8	{view,add,edit,delete}	\N	all
112	2	8	{view,add,edit,delete}	\N	all
113	102	8	{view,add,edit,delete}	\N	all
114	104	8	{view,add,edit,delete}	\N	all
115	105	8	{view,add,edit,delete}	\N	all
116	103	8	{view,add,edit,delete}	\N	all
117	106	8	{view,add,edit,delete}	\N	all
118	107	8	{view,add,edit,delete}	\N	all
119	108	8	{view,add,edit,delete}	\N	all
120	110	8	{view,add,edit,delete}	\N	all
121	111	8	{view,add,edit,delete}	\N	all
122	112	8	{view,add,edit,delete}	\N	all
123	12	8	{view,add,edit,delete,settings}	\N	all
125	109	8	{view,add,edit,delete,settings,calculation,invoice,contract}	\N	all
126	92	8	{view,add,edit,delete,settings,invoice,calculation,contract}	\N	all
128	117	4	{view,add,edit,delete}	\N	all
129	118	4	{view,add,edit,delete}	\N	all
130	119	4	{autoload,view,edit,delete}	\N	all
75	106	4	{view,add,edit,delete,settings}	\N	all
131	120	4	{view,add,edit,delete}	\N	all
132	121	4	{view}	\N	all
133	122	4	{view}	\N	all
135	124	4	{view,add,edit,delete,settings}	\N	all
72	103	4	{view,add,edit,delete,settings}	\N	all
136	125	4	{view,settings}	\N	all
140	129	4	{view,settings}	\N	all
141	130	4	{add,view,edit,delete}	\N	all
24	12	4	{view,add,edit,delete,settings}	\N	all
134	123	4	{view,close}	\N	all
143	132	4	{view,add,edit,delete}	\N	all
144	133	4	{view,add,edit,delete}	\N	all
145	134	4	{view,add,edit,delete,settings,calculation,invoice,contract}	\N	all
146	135	4	{view,add,edit,delete,settings}	\N	all
147	136	4	{view,add,edit,delete,settings}	\N	all
148	137	4	{view,add,edit,delete,settings}	\N	all
137	126	4	{view,edit}	\N	all
149	138	4	{view,add,edit,delete,settings}	\N	all
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person (id, resource_id, first_name, last_name, second_name, birthday, subscriber, gender) FROM stdin;
17	1284	Nikolay	Voevoda		1981-07-22	f	0
19	1294	Stas	Voevoda		2007-10-16	f	0
20	1372	Oleg	Pogorelov		1970-02-17	f	0
24	1390	Igor	Mazur		2007-07-21	f	0
25	1408	Vitalii	Klishunov		1976-04-07	f	0
26	1409	Natalia	Klishunova		1978-08-10	f	0
27	1410	Maxim	Klishunov		2005-02-16	f	0
29	1465	Eugen	Velichko		1982-04-07	f	0
31	1472	Velichko	Alexander		2006-01-11	f	0
33	1586	Roman	Babich		1990-11-14	f	0
36	1616	Nikolay	Artyuh		1986-10-08	f	0
37	1619	Andriy	Garkaviy		1984-11-14	f	0
39	1627	Petro	Garkaviy		2004-06-08	f	0
41	1645	Karpenko	Alexander		1990-06-04	f	0
43	1869	Alexey	Ivankiv	V.	\N	t	0
38	1626	Elena	Garkava		1986-01-08	t	0
22	1383	Vitalii	Mazur		1979-07-17	t	0
44	2017	Sergey	Gavrish		1981-08-05	t	0
18	1293	Irina	Voevoda		1984-01-18	f	1
21	1375	Elena	Pogorelova	Petrovna	1972-02-19	f	1
28	1411	Ann	Klishunova		2013-02-14	f	1
30	1471	Irina	Avdeeva		1984-11-21	f	1
32	1473	Velichko	Elizabeth		2010-06-15	f	1
34	1593	Elena	Babich		1991-05-23	f	1
42	1653	Smichko	Olena		1992-07-15	f	1
40	1628	Alena	Garkava		2007-03-29	t	1
35	1615	Tat'ana	Artyuh		1987-02-10	t	1
45	2020	Anna	Gavrish		1993-11-17	t	1
4	870	Greg	Johnson		\N	f	0
5	871	John	Doe		\N	f	0
6	887	Peter	Parker		1976-04-07	f	0
46	2051	Nikolay			\N	f	0
23	1389	Iren	Mazur		1979-09-03	f	1
47	2090	Jason		Lewis	\N	f	0
\.


--
-- Data for Name: person_address; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person_address (person_id, address_id) FROM stdin;
17	10
20	15
21	16
22	17
23	18
24	19
25	20
29	23
33	24
35	25
37	26
41	27
42	28
30	30
44	32
\.


--
-- Data for Name: person_contact; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person_contact (person_id, contact_id) FROM stdin;
6	44
17	45
17	46
20	47
21	48
22	50
22	49
23	51
25	52
29	53
33	67
34	68
35	69
35	70
37	72
37	71
38	73
41	74
41	75
42	76
30	77
22	78
44	79
45	80
46	81
47	82
46	83
\.


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('person_id_seq', 47, true);


--
-- Data for Name: person_order_item; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person_order_item (order_item_id, person_id) FROM stdin;
\.


--
-- Data for Name: person_passport; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person_passport (person_id, passport_id) FROM stdin;
17	8
20	9
22	10
25	11
29	12
33	14
33	13
34	15
35	17
35	16
37	18
38	19
41	20
41	21
42	22
30	23
44	24
45	25
\.


--
-- Data for Name: person_subaccount; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY person_subaccount (person_id, subaccount_id) FROM stdin;
41	3
37	4
40	6
20	8
29	11
30	13
41	14
43	15
6	16
44	17
\.


--
-- Data for Name: position; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY "position" (id, resource_id, structure_id, name) FROM stdin;
4	772	32	Main Developer
5	886	5	Finance Director
6	1249	3	Sales Manager
7	1252	9	Sales Manager
8	1775	1	Main Developer
\.


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('positions_navigations_id_seq', 169, true);


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('positions_permisions_id_seq', 149, true);


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
24	1328	5	Belek
25	1332	5	Alanya
26	1336	5	Side
27	1340	16	Paphos
28	1344	17	Riminni & Ravenna
29	1347	17	Sicilia Island
30	1352	18	Crit Island
31	1355	14	Costa Dorada
32	1365	4	Sharm el Sheih
33	1384	3	Zakarpat'e
34	1416	3	Dnepropetrovsk
35	1587	18	Rhodos Island
36	1647	19	Chemiu Due Capon
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
728	55	32	\N
784	47	32	\N
1306	90	32	f
1312	65	32	f
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
1336	39	32	f
1164	70	32	\N
1165	39	32	\N
1337	84	32	f
1338	83	32	f
1347	39	32	f
1348	84	32	f
1349	83	32	f
1355	39	32	f
1356	84	32	f
1204	87	32	\N
1207	12	32	\N
1357	83	32	f
1218	39	32	\N
1359	84	32	f
1360	83	32	f
1365	39	32	f
1366	84	32	f
1367	83	32	f
1240	41	32	f
1398	104	32	f
1257	87	32	f
1258	87	32	f
1413	102	32	f
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
1313	12	32	f
1368	65	32	f
1414	90	32	f
1415	91	32	f
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
1308	90	32	f
1314	102	32	f
1369	65	32	f
1372	69	32	f
1375	69	32	f
1382	90	32	f
1168	41	32	\N
1040	47	32	\N
1041	47	32	\N
1042	47	32	\N
1043	47	32	\N
1044	47	32	\N
1045	47	32	\N
1046	47	32	\N
1169	70	32	\N
1388	90	32	f
1391	90	32	f
1067	78	32	\N
1400	104	32	f
1401	104	32	f
1199	89	32	\N
1206	89	32	\N
1209	90	32	\N
1402	104	32	f
1416	39	32	f
1417	84	32	f
1418	90	32	f
1419	91	32	f
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
1316	102	32	f
952	73	32	\N
939	73	32	\N
938	73	32	\N
937	73	32	\N
936	73	32	\N
935	73	32	\N
1370	90	32	f
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
1371	87	32	f
919	72	32	\N
918	72	32	\N
917	72	32	\N
916	72	32	\N
915	72	32	\N
914	72	32	\N
913	72	32	\N
912	72	32	\N
1373	87	32	f
1002	65	32	\N
1376	89	32	f
1378	78	32	f
1385	84	32	f
1386	83	32	f
1060	41	32	\N
1068	12	32	\N
1075	65	32	\N
1390	69	32	f
1403	104	32	f
1170	39	32	\N
1178	70	32	\N
1179	39	32	\N
1420	101	32	f
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
1317	12	32	f
975	75	32	\N
976	75	32	\N
977	75	32	\N
978	75	32	\N
274	12	32	\N
283	12	32	\N
1318	102	32	f
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
1319	84	32	f
987	75	32	\N
988	75	32	\N
1320	83	32	f
1003	12	32	\N
1004	78	32	\N
1005	78	32	\N
1321	84	32	f
1322	83	32	f
1326	84	32	f
1327	83	32	f
1328	39	32	f
1329	84	32	f
1330	83	32	f
1374	90	32	f
1377	92	32	f
1191	86	32	\N
1201	87	32	\N
1211	12	32	\N
1212	65	32	\N
1213	90	32	\N
1380	87	32	f
1383	69	32	f
1244	87	32	f
1264	87	32	f
1387	87	32	f
1393	12	32	f
1394	65	32	f
1404	87	32	f
1406	89	32	f
1409	69	32	f
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
1311	41	32	f
1062	55	32	\N
1323	83	32	f
1324	83	32	f
1078	12	32	\N
1325	83	32	f
1331	83	32	f
1332	39	32	f
1333	84	32	f
1334	83	32	f
1192	86	32	\N
1214	91	32	\N
1379	87	32	f
1381	89	32	f
1265	89	32	f
1384	39	32	f
1389	69	32	f
1395	65	32	f
1407	90	32	f
1411	69	32	f
1412	92	32	f
872	12	32	\N
873	65	32	\N
874	65	32	\N
725	55	32	\N
726	55	32	\N
1282	87	32	f
1095	70	32	\N
1009	79	32	\N
1096	39	32	\N
1097	84	32	\N
1335	83	32	f
1079	65	32	\N
1099	39	32	\N
1339	70	32	f
1340	39	32	f
1341	84	32	f
1342	83	32	f
1343	70	32	f
1344	39	32	f
1345	84	32	f
1159	78	32	\N
1346	83	32	f
1350	83	32	f
1351	70	32	f
1193	87	32	\N
1194	87	32	\N
1195	87	32	\N
1352	39	32	f
1353	84	32	f
1354	83	32	f
1358	83	32	f
1361	84	32	f
1362	83	32	f
1363	84	32	f
1364	83	32	f
1396	104	32	f
1408	69	32	f
1410	69	32	f
1424	12	32	f
1425	65	32	f
1426	105	32	f
1431	105	32	f
1432	105	32	f
1433	12	32	f
1434	65	32	f
1435	12	32	f
1436	65	32	f
1438	107	32	f
1439	107	32	f
1440	103	32	f
1442	103	32	f
1447	106	32	f
1448	106	32	f
1450	12	32	f
1452	12	32	f
1453	108	32	f
1454	108	32	f
1455	108	32	f
1456	109	32	f
1457	108	32	f
1458	108	32	f
1459	108	32	f
1460	108	32	f
1461	108	32	f
1462	108	32	f
1463	108	32	f
1464	87	32	f
1465	69	32	f
1467	89	32	f
1468	84	32	f
1469	90	32	f
1470	83	32	f
1471	69	32	f
1472	69	32	f
1473	69	32	f
1474	108	32	f
1475	108	32	f
1476	108	32	f
1477	108	32	f
1478	108	32	f
1479	108	32	f
1480	92	32	f
1481	108	32	f
1482	108	32	f
1483	108	32	f
1485	106	32	f
1487	103	32	f
1500	106	32	f
1502	103	32	f
1503	103	32	f
1504	104	32	f
1505	104	32	f
1506	104	32	f
1507	107	32	f
1509	106	32	f
1510	101	32	f
1511	101	32	f
1512	101	32	f
1513	101	32	f
1514	101	32	f
1515	101	32	f
1516	87	32	f
1517	87	32	f
1518	87	32	f
1519	87	32	f
1520	108	32	f
1521	12	32	f
1535	110	32	f
1536	110	32	f
1537	110	32	f
1538	110	32	f
1539	110	32	f
1540	110	32	f
1541	110	32	f
1542	67	32	f
1543	87	32	f
1544	87	32	f
1545	87	32	f
1546	106	32	f
1547	106	32	f
1548	12	32	f
1549	12	32	f
1550	65	32	f
1551	87	32	f
1552	87	32	f
1553	79	32	f
1554	101	32	f
1556	101	32	f
1559	87	32	f
1560	79	32	f
1561	87	32	f
1562	87	32	f
1563	79	32	f
1564	101	32	f
1567	112	32	f
1568	112	32	f
1569	101	32	f
1570	101	32	f
1571	65	32	f
1575	65	32	f
1576	86	32	f
1577	87	32	f
1578	79	32	f
1579	110	32	f
1580	78	32	f
1581	87	32	f
1582	89	32	f
1584	89	32	f
1585	90	32	f
1586	69	32	f
1587	39	32	f
1588	84	32	f
1589	84	32	f
1590	83	32	f
1591	87	32	f
1592	89	32	f
1593	69	32	f
1594	92	32	f
1595	108	32	f
1596	108	32	f
1597	104	32	f
1598	103	32	f
1600	108	32	f
1607	106	32	f
1608	105	32	f
1609	105	32	f
1610	87	32	f
1611	87	32	f
1612	89	32	f
1613	89	32	f
1614	90	32	f
1615	69	32	f
1616	69	32	f
1617	92	32	f
1618	108	32	f
1619	69	32	f
1620	87	32	f
1621	87	32	f
1622	89	32	f
1623	90	32	f
1624	87	32	f
1625	89	32	f
1626	69	32	f
1627	69	32	f
1628	69	32	f
1629	108	32	f
1630	92	32	f
1631	108	32	f
1632	108	32	f
1633	108	32	f
1634	103	32	f
1639	106	32	f
1640	87	32	f
1641	87	32	f
1642	89	32	f
1643	89	32	f
1644	90	32	f
1645	69	32	f
1646	70	32	f
1647	39	32	f
1648	84	32	f
1649	83	32	f
1650	87	32	f
1651	89	32	f
1652	90	32	f
1653	69	32	f
1654	108	32	f
1655	108	32	f
1656	92	32	f
1657	103	32	f
1659	65	32	f
1660	106	32	f
1714	110	32	f
1721	110	32	f
1758	108	32	f
1759	109	32	f
1764	111	32	f
1766	111	32	f
1769	105	32	f
1771	111	32	f
1773	111	32	f
1774	111	32	f
1775	59	32	f
1777	65	32	f
1778	12	1	f
1780	105	32	f
1797	12	32	f
1798	65	32	f
1799	12	32	f
1800	118	32	f
1801	118	32	f
1802	118	32	f
1803	118	32	f
1804	118	32	f
1807	90	32	f
1833	118	32	f
1839	103	32	f
1840	103	32	f
1841	108	32	f
1842	108	32	f
1843	108	32	f
1844	108	32	f
1845	108	32	f
1846	108	32	f
1847	108	32	f
1848	108	32	f
1849	12	32	f
1852	119	32	f
1853	119	32	f
1854	119	32	f
1855	119	32	f
1859	119	32	f
1860	119	32	f
1865	117	32	f
1866	117	32	f
1867	117	32	f
1868	117	32	f
1869	69	32	f
1870	78	32	f
1872	118	32	f
1873	105	32	f
1875	106	32	f
1876	106	32	f
1880	106	32	f
1881	106	32	f
1882	106	32	f
1883	111	32	f
1884	12	32	f
1885	65	32	f
1888	117	32	f
1893	120	32	f
1894	12	32	f
1895	65	32	f
1896	65	32	f
1898	105	32	f
1900	120	32	f
1901	120	32	f
1902	117	32	f
1903	111	32	f
1904	65	32	f
1905	65	32	f
1906	65	32	f
1907	65	32	f
1908	65	32	f
1909	65	32	f
1910	106	32	f
1911	106	32	f
1912	111	32	f
1913	117	32	f
1915	111	32	f
1917	110	32	f
1918	119	32	f
1919	12	32	f
1921	65	32	f
1922	93	32	f
1923	93	32	f
1924	118	32	f
1925	89	32	f
1926	90	32	f
1927	87	32	f
1928	92	32	f
1929	108	32	f
1930	93	32	f
1931	118	32	f
1932	93	32	f
1933	93	32	f
1934	93	32	f
1935	93	32	f
1936	93	32	f
1939	93	32	f
1940	93	32	f
1941	12	32	f
1945	123	32	f
1946	123	32	f
1947	123	32	f
1948	123	32	f
1949	123	32	f
1950	123	32	f
1951	90	32	f
1952	86	32	f
1953	65	32	f
1954	12	32	f
1956	87	32	f
1958	93	32	f
1959	123	32	f
1961	123	32	f
1962	93	32	f
1963	123	32	f
1964	93	32	f
1965	123	32	f
1955	124	32	f
1966	12	32	f
1968	12	32	f
1970	126	32	f
1971	93	32	f
1972	123	32	f
1973	123	32	f
1975	65	32	f
1976	55	32	f
1977	12	32	f
1978	2	32	f
1979	118	32	f
1980	93	32	f
1981	118	32	f
1982	93	32	f
1983	93	32	f
1984	123	32	f
1985	93	32	f
1986	123	32	f
1987	103	32	f
1988	119	32	f
1989	12	32	f
1990	106	32	f
1991	106	32	f
1992	106	32	f
1993	106	32	f
1994	106	32	f
1995	106	32	f
1996	106	32	f
1997	106	32	f
1998	108	32	f
1999	109	32	f
2000	103	32	f
2001	106	32	f
2002	106	32	f
2003	108	32	f
2004	109	32	f
2005	103	32	f
2006	106	32	f
2007	106	32	f
2009	93	32	f
2010	123	32	f
2011	110	32	f
2012	118	32	f
2013	87	32	f
2014	89	32	f
2015	90	32	f
2016	93	32	f
2017	69	32	f
2018	87	32	f
2019	89	32	f
2020	69	32	f
2021	92	32	f
2022	108	32	f
2023	104	32	f
2024	104	32	f
2026	103	32	f
2027	106	32	f
2028	106	32	f
2029	119	32	f
2030	119	32	f
2031	119	32	f
2032	110	32	f
2033	108	32	f
2034	108	32	f
2035	109	32	f
2038	119	32	f
2039	119	32	f
2044	119	32	f
2045	119	32	f
2046	119	32	f
2047	119	32	f
2048	65	32	f
2049	12	32	f
2050	87	32	f
2051	69	32	f
2052	130	32	f
2053	47	32	f
2054	2	32	f
2055	12	32	f
2062	93	32	f
2063	93	32	f
2064	123	32	f
2065	118	32	f
2066	93	32	f
2067	123	32	f
2068	93	32	f
2069	123	32	f
2070	12	32	f
2072	132	32	f
2073	132	32	f
2074	132	32	f
2075	93	32	f
2076	123	32	f
2077	12	32	f
2078	132	32	f
2079	132	32	f
2080	132	32	f
2081	133	32	f
2082	132	32	f
2083	132	32	f
2084	132	32	f
2085	133	32	f
2086	133	32	f
2087	118	32	f
2088	130	32	f
2089	87	32	f
2090	69	32	f
2091	132	32	f
2092	118	32	f
2093	133	32	f
2094	133	32	f
2095	87	32	f
2096	118	32	f
2097	118	32	f
2098	118	32	f
2099	12	32	f
2100	12	32	f
2101	65	32	f
2104	135	32	f
2105	135	32	f
2106	135	32	f
2107	12	32	f
2108	12	32	f
2111	83	32	f
2115	39	32	f
2119	90	32	f
2120	101	32	f
2126	2	32	f
2127	12	32	f
2128	65	32	f
2129	138	32	f
2130	138	32	f
2131	93	32	f
2132	118	32	f
2133	123	32	f
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
2	10	2	\N	2013-11-16 19:00:14.24272
4	12	2	\N	2013-11-16 19:00:15.497284
6	14	2	\N	2013-11-16 19:00:16.696731
8	16	2	\N	2013-11-16 19:00:17.960761
5427	1204	2	\N	2014-04-09 18:54:09.146902
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
4951	885	2	\N	2014-02-14 21:23:40.101298
4952	885	2	\N	2014-02-14 21:25:13.866935
4974	849	2	\N	2014-02-23 22:41:46.113064
4977	884	2	\N	2014-02-23 22:42:22.595852
5143	1003	2	\N	2014-03-04 21:05:09.565466
5144	1004	2	\N	2014-03-04 21:08:53.227171
5145	1005	2	\N	2014-03-04 21:09:15.542733
5471	1240	2	\N	2014-04-26 13:10:19.27836
5538	1307	2	\N	2014-04-30 11:08:33.655971
5544	1313	2	\N	2014-05-16 22:03:29.897662
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
5545	1314	2	\N	2014-05-17 13:42:16.369317
422	306	2	\N	2013-12-15 21:45:32.990838
4802	773	2	\N	2014-01-25 23:45:37.762081
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
5547	1316	2	\N	2014-05-17 14:00:25.111543
4927	865	2	\N	2014-02-09 13:26:19.008763
4804	775	2	\N	2014-01-26 15:30:50.636495
4828	3	2	\N	2014-02-02 17:45:50.239397
5416	1199	2	\N	2014-04-08 10:15:32.411146
5434	1211	2	\N	2014-04-12 14:16:34.33498
5435	1211	2	\N	2014-04-12 14:16:53.40729
4982	895	2	\N	2014-02-25 19:06:42.158245
5158	1007	2	\N	2014-03-08 10:30:25.61786
5198	3	2	\N	2014-03-11 13:14:05.142514
5233	1060	2	\N	2014-03-16 12:26:38.52955
5437	1213	2	\N	2014-04-12 14:32:08.840037
5466	1227	2	\N	2014-04-19 21:37:55.580038
5474	1243	2	\N	2014-04-26 22:38:44.326007
5541	1310	2	\N	2014-04-30 22:45:27.579715
5548	1317	2	\N	2014-05-17 14:54:57.813145
5549	1318	2	\N	2014-05-17 15:24:32.954365
5550	1319	2	\N	2014-05-17 15:53:28.880817
5551	1320	2	\N	2014-05-17 15:53:34.139717
5552	1321	2	\N	2014-05-17 15:55:03.155317
5553	1322	2	\N	2014-05-17 15:55:07.534203
5557	1326	2	\N	2014-05-17 15:59:13.891973
5558	1327	2	\N	2014-05-17 15:59:17.045556
5559	1328	2	\N	2014-05-17 16:00:04.660539
5560	1329	2	\N	2014-05-17 16:00:08.901641
5561	1330	2	\N	2014-05-17 16:00:10.337355
5566	1335	2	\N	2014-05-17 16:02:19.447311
5570	1339	2	\N	2014-05-17 16:06:26.675372
5571	1340	2	\N	2014-05-17 16:06:28.503991
5572	1341	2	\N	2014-05-17 16:06:29.727144
5573	1342	2	\N	2014-05-17 16:06:31.81672
5574	1343	2	\N	2014-05-17 16:07:44.265465
5575	1344	2	\N	2014-05-17 16:07:45.972655
5576	1345	2	\N	2014-05-17 16:07:47.259172
5577	1346	2	\N	2014-05-17 16:07:49.146563
5581	1350	2	\N	2014-05-17 16:09:55.923893
5582	1351	2	\N	2014-05-17 16:13:13.017272
5583	1352	2	\N	2014-05-17 16:13:14.609527
5584	1353	2	\N	2014-05-17 16:13:16.568079
5585	1354	2	\N	2014-05-17 16:13:17.732756
5370	1159	2	\N	2014-04-02 19:52:15.193771
4888	786	2	\N	2014-02-08 21:26:45.138217
5417	1200	2	\N	2014-04-08 10:35:59.014802
4890	784	2	\N	2014-02-08 21:26:51.98617
4929	870	2	\N	2014-02-09 14:57:54.403714
4967	892	2	\N	2014-02-22 17:14:02.512772
4983	896	2	\N	2014-02-25 19:37:56.226615
4984	897	2	\N	2014-02-25 19:38:21.395798
4985	898	2	\N	2014-02-25 19:38:30.353048
4986	899	2	\N	2014-02-25 19:39:23.588225
4988	901	2	\N	2014-02-25 19:47:57.884012
5160	1009	2	\N	2014-03-08 10:49:52.0599
5199	3	2	\N	2014-03-12 12:05:31.953558
5438	1214	2	\N	2014-04-12 14:36:07.046988
5475	1244	2	\N	2014-04-26 22:39:00.40778
5542	1311	2	\N	2014-04-30 22:45:36.089534
5554	1323	2	\N	2014-05-17 15:55:54.008685
5555	1324	2	\N	2014-05-17 15:56:55.63522
5556	1325	2	\N	2014-05-17 15:58:29.508912
5562	1331	2	\N	2014-05-17 16:00:49.21287
5563	1332	2	\N	2014-05-17 16:01:46.175183
5564	1333	2	\N	2014-05-17 16:01:47.950656
5565	1334	2	\N	2014-05-17 16:01:48.837764
5567	1336	2	\N	2014-05-17 16:03:41.796945
5568	1337	2	\N	2014-05-17 16:04:32.839289
5569	1338	2	\N	2014-05-17 16:04:34.363533
5578	1347	2	\N	2014-05-17 16:08:39.18466
5579	1348	2	\N	2014-05-17 16:08:56.863828
5580	1349	2	\N	2014-05-17 16:08:58.291349
4894	849	2	\N	2014-02-08 21:32:14.802948
4896	851	2	\N	2014-02-08 21:32:32.471247
4897	852	2	\N	2014-02-08 21:36:44.493917
4930	871	2	\N	2014-02-09 16:04:05.85568
4968	892	2	\N	2014-02-22 17:18:17.771894
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
5586	1355	2	\N	2014-05-17 16:14:39.7443
5587	1356	2	\N	2014-05-17 16:14:41.182697
5588	1357	2	\N	2014-05-17 16:14:43.239633
5590	1359	2	\N	2014-05-17 16:15:43.442935
5591	1360	2	\N	2014-05-17 16:15:45.790483
5596	1365	2	\N	2014-05-17 16:20:21.389915
5597	1366	2	\N	2014-05-17 16:20:22.473385
5598	1367	2	\N	2014-05-17 16:20:23.843632
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
5444	1218	2	\N	2014-04-12 15:00:38.646853
5447	1214	2	\N	2014-04-12 15:02:33.59771
5514	1283	2	\N	2014-04-29 12:06:08.689068
5515	1284	2	\N	2014-04-29 12:07:06.357367
5518	1287	2	\N	2014-04-29 12:09:55.486785
5520	1289	2	\N	2014-04-29 12:11:36.874588
5589	1358	2	\N	2014-05-17 16:15:09.836615
5592	1361	2	\N	2014-05-17 16:16:33.155307
5593	1362	2	\N	2014-05-17 16:16:42.585648
5594	1363	2	\N	2014-05-17 16:18:45.312153
5595	1364	2	\N	2014-05-17 16:18:46.752544
4932	872	2	\N	2014-02-10 14:29:53.759164
4996	908	2	\N	2014-02-25 23:15:44.304324
4997	909	2	\N	2014-02-25 23:16:53.455486
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
5519	1288	2	\N	2014-04-29 12:10:21.572462
5521	1290	2	\N	2014-04-29 12:13:35.434847
5603	1372	2	\N	2014-05-17 18:47:30.594446
5606	1375	2	\N	2014-05-17 18:55:21.896666
5613	1382	2	\N	2014-05-17 19:04:51.767284
5619	1388	2	\N	2014-05-17 19:09:44.578209
5622	1391	2	\N	2014-05-17 19:12:29.996417
4902	856	2	\N	2014-02-08 21:59:04.719245
4938	876	2	\N	2014-02-10 16:19:24.400952
5071	953	2	\N	2014-02-26 23:25:15.548581
5072	954	2	\N	2014-02-26 23:25:55.407709
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
5601	1370	2	\N	2014-05-17 18:45:54.451262
5602	1371	2	\N	2014-05-17 18:47:17.628356
5604	1373	2	\N	2014-05-17 18:54:01.477094
5607	1376	2	\N	2014-05-17 18:56:40.07768
5609	1378	2	\N	2014-05-17 19:02:40.402053
5616	1385	2	\N	2014-05-17 19:07:13.667811
5617	1386	2	\N	2014-05-17 19:07:36.068126
5621	1390	2	\N	2014-05-17 19:11:55.084234
4789	763	2	\N	2014-01-12 19:51:49.157909
4903	854	2	\N	2014-02-08 22:16:58.906498
4904	3	2	\N	2014-02-08 22:17:06.939369
4905	854	2	\N	2014-02-08 22:20:32.280238
4906	784	2	\N	2014-02-08 22:21:01.290541
4908	786	2	\N	2014-02-08 22:21:09.110319
5484	1253	2	\N	2014-04-28 00:03:49.599015
5289	1081	2	\N	2014-03-22 17:57:05.076581
5605	1374	2	\N	2014-05-17 18:55:03.070735
5608	1377	2	\N	2014-05-17 18:56:44.9516
5611	1380	2	\N	2014-05-17 19:03:57.212913
5614	1383	2	\N	2014-05-17 19:04:59.867959
5618	1387	2	\N	2014-05-17 19:09:22.594353
5624	1393	2	\N	2014-05-18 10:14:28.009945
4790	764	2	\N	2014-01-12 20:33:53.3138
4909	723	2	\N	2014-02-08 22:28:37.868751
4940	878	2	\N	2014-02-10 16:40:47.442615
5610	1379	2	\N	2014-05-17 19:03:38.443538
5612	1381	2	\N	2014-05-17 19:04:17.238286
5615	1384	2	\N	2014-05-17 19:07:10.869783
5620	1389	2	\N	2014-05-17 19:09:47.55779
4910	857	2	\N	2014-02-09 00:41:07.487567
4911	858	2	\N	2014-02-09 00:41:26.234037
4912	859	2	\N	2014-02-09 00:41:48.428505
4913	860	2	\N	2014-02-09 00:42:12.938208
4914	857	2	\N	2014-02-09 00:42:31.066281
4915	861	2	\N	2014-02-09 00:42:52.234296
5291	1088	2	\N	2014-03-22 18:51:18.985681
5292	1081	2	\N	2014-03-22 18:51:44.158872
5458	1225	2	\N	2014-04-13 12:01:26.796233
5627	1396	2	\N	2014-05-18 11:58:47.293591
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
5629	1398	2	\N	2014-05-18 12:12:21.975254
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
5631	1400	2	\N	2014-05-18 13:37:21.801854
5632	1401	2	\N	2014-05-18 13:37:41.402585
5633	1402	2	\N	2014-05-18 13:44:45.628784
5492	1261	2	\N	2014-04-28 13:04:58.29173
5634	1403	2	\N	2014-05-18 15:48:34.956287
5256	1067	2	\N	2014-03-16 19:34:31.935568
5494	1263	2	\N	2014-04-28 13:08:06.602496
5635	1404	2	\N	2014-05-18 19:18:07.615122
5636	1406	2	\N	2014-05-18 19:18:56.831097
5639	1409	2	\N	2014-05-18 19:22:05.971396
5394	1185	2	\N	2014-04-05 20:56:20.797318
5257	1067	2	\N	2014-03-16 19:55:56.894484
5495	1264	2	\N	2014-04-28 13:08:25.610345
5637	1407	2	\N	2014-05-18 19:19:36.399614
5641	1411	2	\N	2014-05-18 19:23:45.119721
5642	1412	2	\N	2014-05-18 19:24:25.545359
5496	1265	2	\N	2014-04-28 13:08:54.519921
5638	1408	2	\N	2014-05-18 19:19:43.401474
5258	1067	2	\N	2014-03-16 20:09:16.532934
5311	1097	2	\N	2014-03-24 19:59:44.290142
5640	1410	2	\N	2014-05-18 19:23:00.415796
5643	1413	2	\N	2014-05-20 21:26:27.311927
5259	1068	2	\N	2014-03-16 20:15:31.769185
5499	1268	2	\N	2014-04-28 23:55:09.591646
5644	1414	2	\N	2014-05-24 17:02:57.354915
5645	1415	2	\N	2014-05-24 17:03:02.922541
5646	1416	2	\N	2014-05-24 17:06:48.542492
5647	1417	2	\N	2014-05-24 17:06:51.402853
5648	1418	2	\N	2014-05-24 17:07:25.101929
5649	1419	2	\N	2014-05-24 17:07:29.075778
5650	1420	2	\N	2014-05-24 17:24:17.546972
4120	16	2	\N	2014-01-01 13:19:09.979922
4131	14	2	\N	2014-01-01 18:45:07.902745
4144	706	2	\N	2014-01-03 16:12:41.015146
4145	706	2	\N	2014-01-03 16:13:23.197097
5402	1189	2	\N	2014-04-06 18:46:40.132797
5403	1190	2	\N	2014-04-06 18:47:22.030146
5138	865	2	\N	2014-03-03 21:09:34.254642
5404	1191	2	\N	2014-04-06 18:53:34.002074
5263	1009	2	\N	2014-03-16 21:40:10.728496
5264	1009	2	\N	2014-03-16 21:44:11.742442
5405	1192	2	\N	2014-04-06 19:20:55.890208
5140	865	2	\N	2014-03-03 21:57:11.59945
5265	1004	2	\N	2014-03-17 10:29:17.115979
5266	1004	2	\N	2014-03-17 10:29:24.701637
4744	723	2	\N	2014-01-04 23:58:55.624453
4746	725	2	\N	2014-01-05 01:09:00.405742
4747	726	2	\N	2014-01-05 01:09:15.602018
4749	728	2	\N	2014-01-05 01:13:50.125212
4756	734	2	\N	2014-01-05 12:36:48.48575
4765	743	2	\N	2014-01-05 13:20:17.173661
5654	1424	2	\N	2014-06-01 10:25:44.71461
5656	1426	2	\N	2014-06-01 12:15:53.295347
5661	1431	2	\N	2014-06-07 15:12:11.693366
5662	1432	2	\N	2014-06-07 15:12:40.323386
5663	1433	2	\N	2014-06-07 17:43:14.620483
5665	1435	2	\N	2014-06-07 21:01:18.691193
5667	1438	2	\N	2014-06-07 21:11:01.089928
5668	1439	2	\N	2014-06-07 21:11:46.797584
5669	1440	2	\N	2014-06-07 22:15:09.567299
5671	1442	2	\N	2014-06-07 22:16:04.586659
5676	1447	2	\N	2014-06-08 21:25:14.638119
5677	1448	2	\N	2014-06-08 21:25:35.09515
5679	1450	2	\N	2014-06-09 15:50:23.760428
5681	1452	2	\N	2014-06-09 17:20:44.311452
5682	1453	2	\N	2014-06-09 20:15:57.545778
5683	1454	2	\N	2014-06-09 20:42:20.973803
5684	1455	2	\N	2014-06-09 20:42:41.688175
5685	1456	2	\N	2014-06-09 20:42:48.878295
5686	1457	2	\N	2014-06-09 22:18:32.577688
5687	1458	2	\N	2014-06-09 22:18:59.404909
5688	1459	2	\N	2014-06-09 22:19:29.172655
5689	1460	2	\N	2014-06-09 22:19:48.16963
5690	1461	2	\N	2014-06-09 22:20:11.231267
5691	1462	2	\N	2014-06-13 22:46:08.190119
5692	1463	2	\N	2014-06-13 22:46:42.967863
5693	1464	2	\N	2014-06-14 17:55:00.252916
5694	1465	2	\N	2014-06-14 17:55:08.213215
5695	1467	2	\N	2014-06-14 17:56:52.935007
5696	1468	2	\N	2014-06-14 17:58:15.339465
5697	1469	2	\N	2014-06-14 17:58:37.034547
5698	1470	2	\N	2014-06-14 18:00:56.71432
5699	1471	2	\N	2014-06-14 18:02:10.63169
5700	1472	2	\N	2014-06-14 18:02:54.98084
5701	1473	2	\N	2014-06-14 18:03:27.411198
5702	1474	2	\N	2014-06-14 18:04:28.298657
5703	1475	2	\N	2014-06-14 18:05:22.160315
5704	1476	2	\N	2014-06-14 18:06:04.93612
5705	1477	2	\N	2014-06-14 18:06:52.83967
5706	1478	2	\N	2014-06-14 18:07:42.799714
5707	1479	2	\N	2014-06-14 18:09:13.451489
5708	1480	2	\N	2014-06-14 18:09:57.549927
5709	1481	2	\N	2014-06-14 18:20:00.741016
5710	1482	2	\N	2014-06-14 18:20:32.755332
5711	1483	2	\N	2014-06-14 18:21:04.54574
5713	1485	2	\N	2014-06-15 15:17:28.256792
5715	1487	2	\N	2014-06-16 14:42:17.062016
5728	1500	2	\N	2014-06-18 16:59:05.631362
5730	1502	2	\N	2014-06-22 19:40:05.464875
5731	1503	2	\N	2014-06-22 19:40:20.79663
5732	1504	2	\N	2014-06-22 19:42:44.939368
5733	1505	2	\N	2014-06-22 19:43:05.103699
5734	1506	2	\N	2014-06-22 19:43:23.157992
5735	1507	2	\N	2014-06-22 19:46:21.388635
5737	1509	2	\N	2014-06-22 21:15:50.586549
5738	1510	2	\N	2014-06-24 20:30:44.36129
5739	1511	2	\N	2014-06-25 19:21:08.001771
5740	1512	2	\N	2014-06-25 19:37:43.544622
5741	1513	2	\N	2014-06-25 19:38:23.293423
5742	1514	2	\N	2014-06-25 19:38:46.712804
5743	1515	2	\N	2014-06-25 19:39:14.757449
5744	1516	2	\N	2014-06-25 20:37:42.602785
5745	1517	2	\N	2014-06-25 20:54:09.96009
5746	1518	2	\N	2014-06-25 20:54:50.943042
5747	1519	2	\N	2014-06-25 20:55:06.988343
5748	1520	2	\N	2014-06-26 17:04:36.85438
5749	1521	2	\N	2014-06-26 21:02:19.488826
5750	1535	2	\N	2014-06-28 17:17:15.295903
5751	1536	2	\N	2014-06-28 17:31:39.626186
5752	1537	2	\N	2014-06-28 20:56:05.816704
5753	1538	2	\N	2014-06-28 20:57:41.600837
5754	1539	2	\N	2014-06-28 20:59:59.522314
5755	1540	2	\N	2014-06-28 21:00:26.365557
5756	1541	2	\N	2014-06-28 21:00:51.086753
5757	1542	2	\N	2014-06-28 21:18:20.602573
5758	1543	2	\N	2014-06-28 21:25:57.336069
5759	1544	2	\N	2014-06-28 21:26:14.894807
5760	1545	2	\N	2014-06-28 21:26:35.413657
5761	1546	2	\N	2014-07-02 23:01:03.321441
5762	1547	2	\N	2014-07-02 23:03:30.755887
5763	1548	2	\N	2014-07-26 18:07:46.336433
5764	1549	2	\N	2014-08-16 20:09:11.73959
5766	1551	2	\N	2014-08-16 20:23:59.980051
5767	1552	2	\N	2014-08-16 20:24:12.305446
5768	1553	2	\N	2014-08-16 20:24:15.930016
5769	1554	2	\N	2014-08-16 20:25:09.403552
5771	1556	2	\N	2014-08-16 20:51:19.103778
5773	1559	2	\N	2014-08-16 21:13:14.302214
5774	1560	2	\N	2014-08-16 21:13:18.107616
5775	1561	2	\N	2014-08-16 21:22:35.752473
5776	1562	2	\N	2014-08-16 21:23:02.397566
5777	1563	2	\N	2014-08-16 21:23:05.499294
5778	1564	2	\N	2014-08-16 21:24:08.813965
5781	1567	2	\N	2014-08-17 11:06:39.681926
5782	1568	2	\N	2014-08-17 11:06:57.522852
5783	1569	2	\N	2014-08-17 11:07:53.713228
5784	1570	2	\N	2014-08-17 11:09:10.292392
5790	1576	2	\N	2014-08-22 22:48:58.176695
5791	1577	2	\N	2014-08-22 22:49:31.584667
5792	1578	2	\N	2014-08-22 22:49:35.101959
5793	1579	2	\N	2014-08-22 22:50:20.197271
5794	1580	2	\N	2014-08-22 22:50:49.188036
5795	1581	2	\N	2014-08-22 22:51:29.357367
5796	1582	2	\N	2014-08-22 22:52:03.171722
5797	1584	2	\N	2014-08-22 22:58:38.326467
5798	1585	2	\N	2014-08-22 22:59:28.534906
5799	1586	2	\N	2014-08-22 22:59:41.71816
5800	1587	2	\N	2014-08-22 23:01:39.676197
5801	1588	2	\N	2014-08-22 23:02:11.872661
5802	1589	2	\N	2014-08-22 23:04:10.670971
5803	1590	2	\N	2014-08-22 23:04:40.181387
5804	1591	2	\N	2014-08-22 23:05:46.128053
5805	1592	2	\N	2014-08-22 23:06:07.780481
5806	1593	2	\N	2014-08-22 23:06:12.342153
5807	1594	2	\N	2014-08-22 23:07:05.069505
5808	1595	2	\N	2014-08-22 23:08:18.152328
5809	1596	2	\N	2014-08-22 23:09:01.174533
5810	1597	2	\N	2014-08-22 23:14:17.280337
5811	1598	2	\N	2014-08-22 23:35:58.491964
5813	1600	2	\N	2014-08-23 11:04:12.184497
5820	1607	2	\N	2014-08-23 13:37:30.044239
5821	1608	2	\N	2014-08-23 16:14:22.910225
5822	1609	2	\N	2014-08-23 16:16:24.823791
5823	1610	2	\N	2014-08-24 14:10:51.002759
5824	1611	2	\N	2014-08-24 14:11:19.783792
5825	1612	2	\N	2014-08-24 14:11:36.729128
5826	1613	2	\N	2014-08-24 14:11:54.849623
5827	1614	2	\N	2014-08-24 14:48:54.04485
5828	1615	2	\N	2014-08-24 14:48:55.715304
5829	1616	2	\N	2014-08-24 14:49:59.373945
5830	1617	2	\N	2014-08-24 14:57:40.998747
5831	1618	2	\N	2014-08-24 14:58:58.327062
5832	1619	2	\N	2014-08-24 15:01:16.140346
5833	1620	2	\N	2014-08-24 15:02:15.884894
5834	1621	2	\N	2014-08-24 15:02:43.162974
5835	1622	2	\N	2014-08-24 15:03:06.67481
5836	1623	2	\N	2014-08-24 15:03:53.276198
5837	1624	2	\N	2014-08-24 15:08:02.737031
5838	1625	2	\N	2014-08-24 15:08:18.61161
5839	1626	2	\N	2014-08-24 15:08:29.0077
5840	1627	2	\N	2014-08-24 15:10:13.736496
5841	1628	2	\N	2014-08-24 15:10:44.233145
5842	1629	2	\N	2014-08-24 15:11:29.749793
5843	1630	2	\N	2014-08-24 15:11:33.251549
5844	1631	2	\N	2014-08-24 15:16:53.496818
5845	1632	2	\N	2014-08-24 15:17:15.949468
5846	1633	2	\N	2014-08-24 15:17:28.997817
5847	1634	2	\N	2014-08-24 15:21:09.48427
5852	1639	2	\N	2014-08-25 15:20:24.884947
5853	1640	2	\N	2014-08-26 19:55:53.569882
5854	1641	2	\N	2014-08-26 19:56:28.320221
5858	1645	2	\N	2014-08-26 20:01:19.187139
5860	1647	2	\N	2014-08-26 20:04:08.078366
5862	1649	2	\N	2014-08-26 20:04:48.124422
5855	1642	2	\N	2014-08-26 19:56:46.695581
5856	1643	2	\N	2014-08-26 19:57:13.160198
5857	1644	2	\N	2014-08-26 20:01:16.129984
5859	1646	2	\N	2014-08-26 20:04:06.105786
5861	1648	2	\N	2014-08-26 20:04:09.378364
5863	1650	2	\N	2014-08-26 20:06:13.193356
5864	1651	2	\N	2014-08-26 20:06:36.249641
5865	1652	2	\N	2014-08-26 20:07:23.412381
5866	1653	2	\N	2014-08-26 20:07:31.899383
5867	1654	2	\N	2014-08-26 20:12:29.150503
5868	1655	2	\N	2014-08-26 20:12:40.489325
5869	1656	2	\N	2014-08-26 20:13:02.876592
5870	1657	2	\N	2014-08-26 20:13:28.887297
5873	1660	2	\N	2014-08-31 16:37:37.888486
5919	1714	2	\N	2014-09-14 13:27:15.677766
5926	1721	2	\N	2014-09-14 14:49:51.512979
5963	1758	2	\N	2014-09-14 16:52:13.746397
5964	1759	2	\N	2014-09-14 16:52:29.599653
5967	1764	2	\N	2014-09-14 21:51:09.963908
5968	1766	2	\N	2014-09-28 17:08:27.946698
5971	1769	2	\N	2014-10-01 20:37:18.107894
5972	1771	2	\N	2014-10-01 21:39:17.299667
5973	1773	2	\N	2014-10-01 22:04:03.074823
5974	1774	2	\N	2014-10-01 22:17:44.949656
5975	1775	2	\N	2014-10-03 20:21:54.06353
5977	1777	2	\N	2014-10-03 20:35:01.628264
5978	1778	2	\N	2014-10-04 21:45:17.702702
5980	1780	2	\N	2014-10-05 12:49:28.270538
5982	1797	2	\N	2014-10-05 21:08:02.025119
5983	1798	2	\N	2014-10-05 22:07:40.176836
5984	1799	2	\N	2014-10-09 20:49:57.476724
5985	1800	2	\N	2014-10-09 21:44:48.304991
5986	1801	2	\N	2014-10-09 21:45:57.042916
5987	1802	2	\N	2014-10-09 21:51:36.274928
5988	1797	2	\N	2014-10-09 21:58:44.274487
5989	1803	2	\N	2014-10-10 21:20:08.467997
5990	1804	2	\N	2014-10-10 21:48:32.795064
5991	1797	2	\N	2014-10-10 21:48:40.224687
5994	1797	2	\N	2014-10-10 22:43:03.886027
5995	1807	2	\N	2014-10-12 12:18:58.609492
5996	1419	2	\N	2014-10-12 12:21:41.297126
5999	1419	2	\N	2014-10-12 14:03:13.921521
6000	1419	2	\N	2014-10-12 14:03:56.458732
6002	1797	2	\N	2014-10-12 14:08:19.225786
6003	1797	2	\N	2014-10-12 14:08:29.322661
6005	1797	2	\N	2014-10-12 14:09:47.667654
6006	1797	2	\N	2014-10-12 14:10:15.511498
6008	894	2	\N	2014-10-12 14:15:30.839116
6010	894	2	\N	2014-10-12 14:15:50.178579
6011	894	2	\N	2014-10-12 14:16:00.712168
6014	1507	2	\N	2014-10-12 14:21:53.792753
6015	1507	2	\N	2014-10-12 14:22:06.118134
6016	1439	2	\N	2014-10-12 14:22:17.008412
6017	1438	2	\N	2014-10-12 14:22:21.965321
6020	1780	2	\N	2014-10-12 14:25:19.014258
6021	1780	2	\N	2014-10-12 14:25:28.403238
6022	1780	2	\N	2014-10-12 14:25:37.930302
6025	1413	2	\N	2014-10-12 14:31:06.237149
6026	1413	2	\N	2014-10-12 14:31:16.507549
6029	1415	2	\N	2014-10-12 14:34:22.672887
6030	1415	2	\N	2014-10-12 14:34:32.05391
6033	1656	2	\N	2014-10-12 14:41:52.788316
6034	1656	2	\N	2014-10-12 14:42:08.782779
6036	1656	2	\N	2014-10-12 14:42:30.203879
6037	1656	2	\N	2014-10-12 14:42:44.613039
6040	1759	2	\N	2014-10-12 15:40:35.199768
6041	1759	2	\N	2014-10-12 15:41:02.788024
6043	1657	2	\N	2014-10-12 15:41:58.778177
6045	1657	2	\N	2014-10-12 15:42:13.36551
6046	1657	2	\N	2014-10-12 15:42:24.726059
6050	1653	2	\N	2014-10-12 16:27:20.425954
6051	1653	2	\N	2014-10-12 16:27:45.783221
6053	1283	2	\N	2014-10-12 16:28:08.925372
6054	1283	2	\N	2014-10-12 16:28:17.376186
6055	1833	2	\N	2014-10-12 16:29:10.045595
6056	784	2	\N	2014-10-12 16:29:11.936722
6061	1542	2	\N	2014-10-12 17:31:06.178463
6063	861	2	\N	2014-10-12 20:54:52.692696
6064	861	2	\N	2014-10-12 20:55:02.552131
6065	1075	2	\N	2014-10-18 11:46:21.55028
6066	998	2	\N	2014-10-18 11:46:31.67705
6067	1656	2	\N	2014-10-18 23:23:34.420148
6068	1630	2	\N	2014-10-18 23:23:46.465142
6069	1617	2	\N	2014-10-18 23:23:56.157596
6070	1594	2	\N	2014-10-18 23:24:05.477568
6071	1480	2	\N	2014-10-18 23:24:15.376373
6072	1412	2	\N	2014-10-18 23:24:23.479928
6073	1377	2	\N	2014-10-18 23:24:32.508988
6074	1295	2	\N	2014-10-18 23:24:41.093481
6075	1657	2	\N	2014-10-18 23:25:55.139592
6076	1657	2	\N	2014-10-18 23:26:04.397861
6077	1839	2	\N	2014-10-18 23:26:44.642232
6078	1634	2	\N	2014-10-18 23:26:52.975425
6079	1598	2	\N	2014-10-18 23:27:05.648811
6080	1502	2	\N	2014-10-18 23:27:11.743763
6081	1503	2	\N	2014-10-18 23:27:18.622533
6082	1440	2	\N	2014-10-18 23:27:25.765119
6083	1442	2	\N	2014-10-18 23:27:32.509568
6084	1840	2	\N	2014-10-18 23:35:01.43267
6085	1656	2	\N	2014-10-19 22:36:11.789477
6086	1841	2	\N	2014-10-19 22:36:11.789477
6087	1630	2	\N	2014-10-19 22:36:19.582687
6088	1842	2	\N	2014-10-19 22:36:19.582687
6089	1617	2	\N	2014-10-19 22:36:25.346653
6090	1843	2	\N	2014-10-19 22:36:25.346653
6091	1594	2	\N	2014-10-19 22:36:33.020862
6092	1844	2	\N	2014-10-19 22:36:33.020862
6093	1480	2	\N	2014-10-19 22:36:39.277425
6094	1845	2	\N	2014-10-19 22:36:39.277425
6095	1412	2	\N	2014-10-19 22:36:45.843702
6096	1846	2	\N	2014-10-19 22:36:45.843702
6097	1377	2	\N	2014-10-19 22:36:52.426547
6098	1847	2	\N	2014-10-19 22:36:52.426547
6099	1295	2	\N	2014-10-19 22:37:00.327784
6100	1848	2	\N	2014-10-19 22:37:00.327784
6101	1295	2	\N	2014-10-25 19:32:56.108191
6102	1656	2	\N	2014-10-25 19:33:11.2886
6103	1630	2	\N	2014-10-25 19:33:23.458476
6104	1630	2	\N	2014-10-25 19:33:30.31595
6105	1630	2	\N	2014-10-25 19:33:36.983101
6106	1617	2	\N	2014-10-25 19:33:44.663485
6107	1594	2	\N	2014-10-25 19:33:51.274504
6108	1480	2	\N	2014-10-25 19:34:16.807636
6109	1412	2	\N	2014-10-25 19:34:23.496097
6110	1377	2	\N	2014-10-25 19:34:31.488965
6111	1295	2	\N	2014-10-25 19:35:38.504584
6112	1759	2	\N	2014-10-25 19:46:03.137133
6113	1456	2	\N	2014-10-25 19:46:11.570251
6114	1598	2	\N	2014-10-25 20:24:45.191774
6115	1840	2	\N	2014-10-25 20:25:16.419372
6116	1839	2	\N	2014-10-25 20:25:25.421645
6117	1657	2	\N	2014-10-25 20:25:34.041679
6118	1634	2	\N	2014-10-25 20:25:41.778509
6119	1598	2	\N	2014-10-25 20:25:49.974159
6120	1503	2	\N	2014-10-25 20:25:56.790041
6121	1502	2	\N	2014-10-25 20:26:11.552957
6122	1487	2	\N	2014-10-25 20:26:20.033323
6123	1442	2	\N	2014-10-25 20:26:26.124436
6124	1440	2	\N	2014-10-25 20:26:33.450119
6125	1660	2	\N	2014-10-25 20:27:51.453322
6126	1639	2	\N	2014-10-25 20:27:59.032748
6127	1607	2	\N	2014-10-25 20:28:26.48561
6128	1547	2	\N	2014-10-25 20:31:18.593123
6129	1546	2	\N	2014-10-25 20:31:27.322575
6130	1509	2	\N	2014-10-25 20:31:34.596003
6131	1500	2	\N	2014-10-25 20:31:41.235636
6132	1485	2	\N	2014-10-25 20:31:48.295128
6133	1448	2	\N	2014-10-25 20:31:55.364673
6134	1447	2	\N	2014-10-25 20:32:03.232605
6135	864	2	\N	2014-10-25 22:27:41.085522
6136	900	2	\N	2014-10-25 22:27:48.659618
6137	780	2	\N	2014-10-25 22:27:56.462817
6138	837	2	\N	2014-10-25 22:28:02.931936
6139	1394	2	\N	2014-10-25 22:28:08.943421
6140	873	2	\N	2014-10-25 22:28:16.618586
6141	778	2	\N	2014-10-25 22:28:22.956578
6142	1659	2	\N	2014-10-25 22:39:28.23436
6143	1369	2	\N	2014-10-25 22:42:01.657224
6144	1849	2	\N	2014-10-25 23:00:37.016264
6145	1852	2	\N	2014-10-28 19:57:41.751563
6146	1853	2	\N	2014-10-28 20:23:48.907733
6147	1854	2	\N	2014-10-28 20:24:58.380434
6148	1855	2	\N	2014-10-28 20:25:08.681569
6151	1859	2	\N	2014-10-29 12:48:22.905378
6152	1860	2	\N	2014-10-30 22:03:33.988542
6157	1865	2	\N	2014-11-03 21:33:49.462196
6158	1866	2	\N	2014-11-03 21:38:54.729983
6159	1867	2	\N	2014-11-03 21:39:31.824693
6160	1868	2	\N	2014-11-03 21:40:02.647787
6161	1869	2	\N	2014-11-05 21:10:08.261088
6162	1870	2	\N	2014-11-05 21:10:38.427296
6164	1872	2	\N	2014-11-08 19:05:48.520641
6165	1868	2	\N	2014-11-08 19:07:32.928999
6166	1868	2	\N	2014-11-08 19:07:58.653299
6167	1873	2	\N	2014-11-09 14:14:33.279838
6168	1433	2	\N	2014-11-09 14:15:02.053975
6170	1875	2	\N	2014-11-09 20:43:57.157494
6171	1876	2	\N	2014-11-09 20:50:09.776581
6172	1876	2	\N	2014-11-09 21:46:07.106741
6173	1876	2	\N	2014-11-09 21:46:46.766703
6174	1876	2	\N	2014-11-12 18:42:47.24628
6175	1876	2	\N	2014-11-12 18:43:00.917409
6176	1876	2	\N	2014-11-12 18:43:51.052257
6177	1876	2	\N	2014-11-12 18:49:19.486465
6178	1876	2	\N	2014-11-12 18:49:50.992411
6182	1880	2	\N	2014-11-12 18:58:13.464317
6183	1881	2	\N	2014-11-12 18:58:13.464317
6184	1876	2	\N	2014-11-12 19:19:20.155903
6185	1880	2	\N	2014-11-12 19:20:04.488842
6186	1882	2	\N	2014-11-12 19:21:49.754499
6187	1882	2	\N	2014-11-12 20:48:55.295948
6188	1876	2	\N	2014-11-13 18:36:19.360925
6189	1876	2	\N	2014-11-13 18:36:40.275356
6190	1876	2	\N	2014-11-13 18:36:53.848561
6191	1876	2	\N	2014-11-13 18:37:04.828162
6192	1876	2	\N	2014-11-13 18:44:14.058824
6193	1880	2	\N	2014-11-14 13:23:46.652293
6194	1883	2	\N	2014-11-14 14:39:48.24157
6195	1883	2	\N	2014-11-14 14:44:29.869357
6196	1884	2	\N	2014-11-15 12:46:51.68956
6197	1885	2	\N	2014-11-15 12:55:58.618287
6200	1647	2	\N	2014-11-15 19:54:17.589811
6201	1647	2	\N	2014-11-15 19:57:05.325517
6202	1587	2	\N	2014-11-15 19:57:11.689531
6203	1656	2	\N	2014-11-15 19:58:28.321946
6204	1888	2	\N	2014-11-15 20:54:18.530252
6209	1893	2	\N	2014-11-15 21:10:00.852505
6210	1894	2	\N	2014-11-16 11:36:20.360008
6211	1895	2	\N	2014-11-16 11:38:31.304748
6212	1896	2	\N	2014-11-16 11:52:22.859107
6214	1896	2	\N	2014-11-16 17:28:25.282664
6215	1898	2	\N	2014-11-18 19:36:00.947451
6217	1900	2	\N	2014-11-18 19:59:41.794255
6218	1901	2	\N	2014-11-18 20:00:50.313385
6219	1902	2	\N	2014-11-18 20:05:55.399398
6220	1903	2	\N	2014-11-18 20:06:23.495804
6221	1225	2	\N	2014-11-20 20:55:40.655878
6222	1904	2	\N	2014-11-21 20:47:35.513987
6223	1434	2	\N	2014-11-21 20:48:05.829054
6224	1571	2	\N	2014-11-21 20:48:27.000088
6225	1885	2	\N	2014-11-21 20:48:44.475673
6226	1905	2	\N	2014-11-21 21:17:50.885382
6227	1436	2	\N	2014-11-21 21:19:06.360097
6228	1798	2	\N	2014-11-21 21:19:19.899746
6229	1425	2	\N	2014-11-21 21:19:42.772209
6230	802	2	\N	2014-11-21 21:20:02.792752
6231	1906	2	\N	2014-11-21 21:20:18.443474
6232	802	2	\N	2014-11-21 21:20:33.430037
6233	1395	2	\N	2014-11-21 21:20:55.244524
6234	1907	2	\N	2014-11-21 21:25:23.260941
6235	879	2	\N	2014-11-21 21:26:01.060638
6236	1089	2	\N	2014-11-21 21:34:19.776611
6237	874	2	\N	2014-11-21 21:34:45.906696
6238	1080	2	\N	2014-11-21 21:35:09.652432
6239	1908	2	\N	2014-11-21 21:35:29.643627
6240	910	2	\N	2014-11-21 21:36:10.21074
6241	1080	2	\N	2014-11-21 21:36:26.556412
6242	911	2	\N	2014-11-21 21:36:37.408083
6243	956	2	\N	2014-11-21 21:36:56.333028
6244	955	2	\N	2014-11-21 21:37:09.845857
6245	1909	2	\N	2014-11-21 21:42:55.617875
6246	1896	2	\N	2014-11-21 21:43:10.139464
6247	1910	2	\N	2014-11-22 17:58:53.151533
6248	1911	2	\N	2014-11-22 17:58:53.151533
6249	1883	2	\N	2014-11-23 17:32:08.015669
6250	1883	2	\N	2014-11-23 17:40:29.860378
6251	1903	2	\N	2014-11-23 17:42:18.707964
6252	1912	2	\N	2014-11-23 17:49:28.781243
6253	1903	2	\N	2014-11-23 18:15:04.669498
6254	1913	2	\N	2014-11-23 18:22:07.34092
6255	1915	2	\N	2014-11-23 18:25:34.975922
6257	1917	2	\N	2014-11-23 18:40:26.695236
6258	1918	2	\N	2014-11-23 18:40:42.249218
6259	1919	2	\N	2014-11-27 21:56:12.900683
6261	1075	2	\N	2014-11-28 21:47:39.551572
6262	1075	2	\N	2014-11-28 21:50:21.401582
6263	1075	2	\N	2014-11-28 21:50:32.965327
6264	1075	2	\N	2014-11-28 22:01:58.252158
6265	1906	2	\N	2014-11-28 22:02:27.025943
6266	1908	2	\N	2014-11-28 22:03:25.613427
6267	1919	2	\N	2014-11-30 11:21:31.130821
6268	1921	2	\N	2014-11-30 11:32:16.085887
6269	1075	2	\N	2014-11-30 18:21:55.412483
6270	1368	2	\N	2014-11-30 18:22:02.736241
6271	1922	2	\N	2014-12-07 14:34:35.538855
6272	1630	2	\N	2014-12-07 16:56:05.246646
6273	1923	2	\N	2014-12-07 17:22:48.083707
6274	1656	2	\N	2014-12-07 20:01:19.362233
6275	1656	2	\N	2014-12-07 21:16:30.31957
6276	1924	2	\N	2014-12-07 21:40:24.739542
6277	1925	2	\N	2014-12-07 21:41:09.94037
6278	1926	2	\N	2014-12-07 21:41:37.63455
6279	1471	2	\N	2014-12-07 21:41:39.584636
6280	1927	2	\N	2014-12-07 21:42:12.893528
6281	1471	2	\N	2014-12-07 21:42:14.781639
6282	1928	2	\N	2014-12-07 21:42:16.748923
6283	1929	2	\N	2014-12-07 21:42:16.748923
6284	1928	2	\N	2014-12-07 21:42:38.598358
6285	1930	2	\N	2014-12-08 21:43:55.101305
6286	1869	2	\N	2014-12-08 21:46:09.685953
6287	1931	2	\N	2014-12-08 21:52:00.685674
6288	1930	2	\N	2014-12-08 21:53:17.580512
6289	1932	2	\N	2014-12-11 22:45:01.994257
6290	1933	2	\N	2014-12-11 22:46:28.273472
6291	1934	2	\N	2014-12-11 22:50:30.21811
6292	1928	2	\N	2014-12-11 22:50:35.79796
6293	1935	2	\N	2014-12-11 22:53:00.765244
6294	1928	2	\N	2014-12-11 22:53:03.075924
6295	1935	2	\N	2014-12-11 22:53:42.569877
6296	1928	2	\N	2014-12-11 22:53:44.11868
6297	1936	2	\N	2014-12-13 21:35:47.599877
6298	1939	2	\N	2014-12-13 21:37:02.820409
6299	1939	2	\N	2014-12-13 21:37:54.352906
6300	1936	2	\N	2014-12-13 21:55:38.627009
6301	1933	2	\N	2014-12-13 21:55:57.253566
6302	1933	2	\N	2014-12-13 21:57:41.570228
6303	1933	2	\N	2014-12-13 22:01:39.804954
6304	1936	2	\N	2014-12-13 22:01:54.801501
6305	1936	2	\N	2014-12-13 22:03:25.347584
6306	1933	2	\N	2014-12-13 22:03:37.415197
6307	1939	2	\N	2014-12-13 22:03:52.016284
6308	1936	2	\N	2014-12-13 22:10:55.202627
6309	1936	2	\N	2014-12-13 22:11:45.388631
6310	1936	2	\N	2014-12-14 11:10:18.568487
6311	1936	2	\N	2014-12-14 11:10:54.616091
6312	1936	2	\N	2014-12-14 11:12:20.116844
6313	1933	2	\N	2014-12-14 11:12:44.366886
6314	1936	2	\N	2014-12-14 11:14:36.987112
6315	1933	2	\N	2014-12-14 11:14:46.937016
6316	1940	2	\N	2014-12-14 11:16:18.397912
6317	1941	2	\N	2014-12-14 17:51:15.587939
6318	1940	2	\N	2014-12-14 19:37:37.036036
6319	1936	2	\N	2014-12-14 19:37:54.381361
6320	1940	2	\N	2014-12-14 19:41:49.794566
6321	1940	2	\N	2014-12-14 19:44:37.781977
6322	1940	2	\N	2014-12-14 19:48:08.98232
6323	1940	2	\N	2014-12-14 19:50:28.583831
6324	1940	2	\N	2014-12-14 20:30:31.46273
6325	1936	2	\N	2014-12-14 20:30:45.990313
6326	1940	2	\N	2014-12-14 20:33:08.50634
6327	1940	2	\N	2014-12-14 20:34:47.73587
6328	1940	2	\N	2014-12-14 20:37:41.082704
6329	1653	2	\N	2014-12-19 21:31:43.967187
6330	1653	2	\N	2014-12-19 21:37:31.746728
6331	1951	2	\N	2014-12-19 21:38:17.300837
6332	725	2	\N	2014-12-19 21:38:20.726452
6333	1952	2	\N	2014-12-19 21:42:56.792366
6334	1870	2	\N	2014-12-19 21:43:03.803839
6335	1906	2	\N	2014-12-20 16:10:55.310323
6336	1953	2	\N	2014-12-20 16:12:04.822804
6337	1953	2	\N	2014-12-20 16:28:56.986576
6338	1869	2	\N	2014-12-20 17:01:25.535753
6339	1869	2	\N	2014-12-20 17:03:12.810766
6340	1869	2	\N	2014-12-20 17:03:22.550854
6341	1628	2	\N	2014-12-20 17:05:00.135486
6342	1869	2	\N	2014-12-20 17:05:08.130568
6343	1626	2	\N	2014-12-20 17:50:11.179188
6344	1615	2	\N	2014-12-20 17:50:33.508978
6345	1954	2	\N	2014-12-20 18:18:17.329483
6346	1954	2	\N	2014-12-20 18:18:27.668631
6347	1953	2	\N	2014-12-20 18:19:03.042411
6348	1955	2	\N	2014-12-20 20:57:13.189777
6349	1225	2	\N	2014-12-21 12:57:50.837529
6350	1433	2	\N	2014-12-21 12:57:59.036844
6351	1954	2	\N	2014-12-21 13:04:30.43023
6352	1955	2	\N	2014-12-21 14:01:21.220851
6353	1955	2	\N	2014-12-21 14:02:48.391182
6354	1955	2	\N	2014-12-21 14:05:59.186502
6355	1956	2	\N	2014-12-21 14:58:01.627945
6356	1383	2	\N	2014-12-21 14:58:04.4436
6357	1383	2	\N	2014-12-21 14:58:18.134114
6358	1955	2	\N	2014-12-21 14:58:54.05088
6359	1955	2	\N	2014-12-21 14:59:43.024479
6360	1955	2	\N	2014-12-21 15:01:24.559119
6361	1955	2	\N	2014-12-21 15:02:30.825094
6362	1955	2	\N	2014-12-21 15:03:19.517473
6363	1955	2	\N	2014-12-21 15:04:26.227416
6364	1955	2	\N	2014-12-21 15:05:25.219884
6365	1955	2	\N	2014-12-21 15:08:14.659941
6366	1955	2	\N	2014-12-21 15:09:18.610638
6367	1955	2	\N	2014-12-21 15:10:49.564969
6368	1955	2	\N	2014-12-21 15:18:30.435377
6369	1955	2	\N	2014-12-21 15:28:30.828306
6370	1955	2	\N	2014-12-21 15:30:55.116621
6371	1955	2	\N	2014-12-21 15:33:38.056888
6372	1955	2	\N	2014-12-21 15:34:45.870649
6373	1955	2	\N	2014-12-21 15:55:27.822121
6374	1955	2	\N	2014-12-21 15:56:45.477441
6375	1955	2	\N	2014-12-21 15:57:54.588037
6376	1955	2	\N	2014-12-21 15:59:56.190169
6377	1955	2	\N	2014-12-21 16:10:48.898101
6378	1955	2	\N	2014-12-21 16:11:31.348869
6379	1955	2	\N	2014-12-21 16:12:17.283128
6380	1955	2	\N	2014-12-21 16:12:43.349159
6381	1955	2	\N	2014-12-21 16:17:53.680374
6382	1955	2	\N	2014-12-21 16:18:30.615045
6383	1955	2	\N	2014-12-21 16:24:07.556851
6384	1955	2	\N	2014-12-21 16:24:36.284901
6385	1955	2	\N	2014-12-21 16:25:59.736532
6386	1955	2	\N	2014-12-21 16:26:10.717535
6387	1958	2	\N	2014-12-21 19:20:00.336409
6388	1958	2	\N	2014-12-21 19:40:10.412709
6389	1958	2	\N	2014-12-21 19:43:18.014602
6390	1955	2	\N	2014-12-21 19:54:47.763979
6391	1955	2	\N	2014-12-21 19:57:15.899119
6392	1955	2	\N	2014-12-21 20:01:57.931475
6393	1962	2	\N	2014-12-24 21:32:53.618984
6394	1955	2	\N	2014-12-24 21:52:53.75341
6395	1955	2	\N	2014-12-24 21:54:29.381242
6396	1955	2	\N	2014-12-24 21:54:40.852567
6397	1955	2	\N	2014-12-24 21:59:02.013042
6398	1955	2	\N	2014-12-24 23:47:49.852576
6399	1955	2	\N	2014-12-24 23:57:47.039863
6400	1964	2	\N	2014-12-25 21:05:49.345482
6401	1955	2	\N	2014-12-26 20:17:47.53662
6402	1955	2	\N	2014-12-26 20:29:33.803173
6403	1955	2	\N	2014-12-26 20:31:12.755178
6404	1955	2	\N	2014-12-26 20:32:53.259365
6405	1955	2	\N	2014-12-26 20:34:24.850656
6406	1955	2	\N	2014-12-26 20:36:11.286672
6407	1955	2	\N	2014-12-26 20:37:54.248513
6408	1955	2	\N	2014-12-26 22:13:17.525737
6409	1955	2	\N	2014-12-26 22:24:22.10607
6410	1955	2	\N	2014-12-26 22:28:42.906736
6411	1317	2	\N	2014-12-27 14:48:10.519499
6412	1840	2	\N	2014-12-27 16:05:27.016889
6413	1840	2	\N	2014-12-27 16:32:05.180181
6414	1840	2	\N	2014-12-27 16:45:52.831401
6415	1966	2	\N	2014-12-27 19:34:56.371248
6416	1955	2	\N	2014-12-28 18:35:17.644826
6417	1955	2	\N	2014-12-28 19:17:37.697477
6418	1966	2	\N	2014-12-31 19:10:29.989911
6420	1968	2	\N	2015-01-03 12:32:10.846571
6422	1970	2	\N	2015-01-03 12:35:21.670372
6423	1971	2	\N	2015-01-04 12:45:51.571627
6424	1840	2	\N	2015-01-04 12:45:53.947837
6425	1971	2	\N	2015-01-04 12:46:35.715575
6426	1971	2	\N	2015-01-04 14:05:54.230775
6428	1975	2	\N	2015-01-04 14:47:53.838979
6429	1976	2	\N	2015-01-04 15:06:13.604725
6430	1977	2	\N	2015-01-04 16:44:50.635763
6431	1975	2	\N	2015-01-04 16:54:32.711408
6432	1975	2	\N	2015-01-04 17:11:52.039507
6433	1975	2	\N	2015-01-04 17:31:46.570967
6434	1975	2	\N	2015-01-07 14:12:48.405815
6435	1975	2	\N	2015-01-07 14:22:19.046581
6436	1978	2	\N	2015-01-07 18:00:22.111119
6437	1979	2	\N	2015-01-07 18:22:39.961593
6438	1980	2	\N	2015-01-07 18:22:48.978415
6439	1981	2	\N	2015-01-07 18:23:19.524712
6440	3	2	\N	2015-01-07 18:23:30.384627
6441	1982	2	\N	2015-01-07 18:30:42.662112
6442	3	2	\N	2015-01-07 18:30:49.411934
6443	3	2	\N	2015-01-07 18:31:24.902432
6444	784	2	\N	2015-01-08 13:21:17.321066
6445	784	2	\N	2015-01-08 13:27:01.529898
6446	784	2	\N	2015-01-08 14:19:17.153858
6447	784	2	\N	2015-01-08 14:20:23.527059
6448	784	2	\N	2015-01-09 10:59:22.101268
6449	1046	2	\N	2015-01-12 22:16:18.421621
6450	1046	2	\N	2015-01-12 22:16:29.774766
6451	1046	2	\N	2015-01-12 22:18:02.620143
6452	1046	2	\N	2015-01-13 17:00:13.07184
6453	1983	2	\N	2015-01-13 17:00:57.932019
6454	1985	2	\N	2015-01-13 17:03:06.725248
6455	1985	2	\N	2015-01-14 21:32:00.651438
6456	1046	2	\N	2015-01-14 21:35:47.291833
6457	1987	2	\N	2015-01-15 20:30:02.464255
6458	1988	2	\N	2015-01-15 21:27:50.402917
6459	1989	2	\N	2015-01-17 15:06:55.170629
6460	1990	2	\N	2015-01-17 19:50:58.298272
6461	1991	2	\N	2015-01-17 19:50:58.298272
6462	1992	2	\N	2015-01-17 19:51:20.956564
6463	1990	2	\N	2015-01-17 21:28:18.900625
6464	1993	2	\N	2015-01-17 21:28:36.972519
6465	1994	2	\N	2015-01-17 21:50:01.04394
6466	1995	2	\N	2015-01-17 21:50:14.61181
6467	1996	2	\N	2015-01-17 21:54:58.910426
6468	1997	2	\N	2015-01-17 21:54:58.910426
6469	1998	2	\N	2015-01-17 21:56:22.636605
6470	1999	2	\N	2015-01-17 21:56:29.416802
6471	2000	2	\N	2015-01-17 21:56:46.645017
6472	2001	2	\N	2015-01-17 21:57:17.28338
6473	2002	2	\N	2015-01-17 21:57:17.28338
6474	2003	2	\N	2015-01-17 21:58:51.890926
6475	2004	2	\N	2015-01-17 21:58:54.962002
6476	2005	2	\N	2015-01-17 22:00:19.139836
6477	2006	2	\N	2015-01-17 22:00:39.986496
6478	2007	2	\N	2015-01-17 22:00:39.986496
6479	2000	2	\N	2015-01-17 22:01:41.277766
6480	2009	2	\N	2015-01-21 21:44:18.418746
6481	1985	2	\N	2015-02-01 13:03:47.123323
6482	2009	2	\N	2015-02-01 13:05:09.626214
6483	2011	2	\N	2015-02-01 13:23:15.549518
6484	1004	2	\N	2015-02-01 13:23:17.930893
6485	2012	2	\N	2015-02-01 13:51:03.67962
6486	1470	2	\N	2015-02-01 13:51:06.125989
6487	2013	2	\N	2015-02-01 15:08:04.506074
6488	2014	2	\N	2015-02-01 15:08:25.548868
6489	2015	2	\N	2015-02-01 15:09:02.223788
6490	2016	2	\N	2015-02-01 15:09:49.640295
6491	2017	2	\N	2015-02-01 15:09:55.959842
6492	2018	2	\N	2015-02-01 15:12:43.612773
6493	2019	2	\N	2015-02-01 15:13:13.911124
6494	2020	2	\N	2015-02-01 15:13:27.313034
6495	2021	2	\N	2015-02-01 15:14:04.244179
6496	2022	2	\N	2015-02-01 15:14:04.244179
6497	2023	2	\N	2015-02-01 15:16:10.834689
6498	2024	2	\N	2015-02-01 15:16:30.308954
6500	2021	2	\N	2015-02-01 15:26:52.568156
6501	2026	2	\N	2015-02-01 15:27:12.501194
6502	2026	2	\N	2015-02-01 15:27:30.084405
6503	2027	2	\N	2015-02-01 15:27:55.689729
6504	2028	2	\N	2015-02-01 15:27:55.689729
6505	2029	2	\N	2015-02-01 19:41:31.921287
6506	2030	2	\N	2015-02-01 19:49:07.587188
6507	2031	2	\N	2015-02-01 19:49:18.380376
6508	2032	2	\N	2015-02-01 19:51:03.621123
6509	1004	2	\N	2015-02-01 19:51:06.683043
6510	2033	2	\N	2015-02-01 19:52:42.620583
6511	2034	2	\N	2015-02-01 19:53:13.308024
6512	2035	2	\N	2015-02-01 19:53:17.885099
6515	2038	2	\N	2015-02-01 19:53:59.085718
6516	2039	2	\N	2015-02-01 19:53:59.085718
6521	2044	2	\N	2015-02-01 19:54:52.686809
6522	2045	2	\N	2015-02-01 19:54:52.686809
6523	2046	2	\N	2015-02-01 19:54:52.686809
6524	2047	2	\N	2015-02-01 19:54:52.686809
6525	2048	2	\N	2015-02-03 20:05:38.797054
6526	2048	2	\N	2015-02-03 20:06:16.781057
6527	1075	2	\N	2015-02-03 20:06:39.590165
6528	2049	2	\N	2015-02-03 21:27:11.659126
6529	2048	2	\N	2015-02-03 21:27:36.200475
6530	2050	2	\N	2015-02-04 21:04:02.527314
6531	2051	2	\N	2015-02-04 21:04:04.474427
6532	2051	2	\N	2015-02-04 21:11:28.094987
6533	2052	2	\N	2015-02-04 21:11:39.281593
6534	2051	2	\N	2015-02-23 21:04:13.639992
6535	1648	2	\N	2015-02-24 14:58:15.754816
6536	2053	2	\N	2015-02-24 21:04:03.673911
6537	2054	2	\N	2015-02-24 21:04:26.838046
6538	2053	2	\N	2015-02-24 21:06:05.145287
6539	2054	2	\N	2015-02-24 21:06:08.284296
6540	2053	2	\N	2015-02-24 21:06:25.905562
6541	2054	2	\N	2015-02-24 21:06:27.830735
6542	2055	2	\N	2015-03-03 16:25:23.003263
6549	1955	2	\N	2015-03-04 21:39:17.186096
6550	1955	2	\N	2015-03-04 21:39:30.590536
6551	1955	2	\N	2015-03-05 19:52:38.505441
6552	1955	2	\N	2015-03-05 19:53:54.442922
6553	2051	2	\N	2015-03-05 21:22:31.156271
6554	2052	2	\N	2015-03-05 21:22:34.187754
6555	2049	2	\N	2015-03-07 13:59:54.391614
6556	2049	2	\N	2015-03-07 14:00:01.858793
6557	2049	2	\N	2015-03-07 14:00:08.905813
6558	2049	2	\N	2015-03-07 17:41:13.176137
6559	2049	2	\N	2015-03-07 17:41:24.454712
6560	2016	2	\N	2015-03-07 19:11:45.990005
6561	1971	2	\N	2015-03-07 20:39:22.05432
6562	1939	2	\N	2015-03-07 20:41:30.911568
6563	1964	2	\N	2015-03-07 20:41:40.386597
6564	1962	2	\N	2015-03-07 20:41:47.24255
6565	2009	2	\N	2015-03-07 20:41:57.590912
6566	1958	2	\N	2015-03-07 20:42:08.257141
6567	2062	2	\N	2015-03-07 20:44:22.388688
6568	1958	2	\N	2015-03-07 20:44:57.143369
6569	1922	2	\N	2015-03-07 21:16:33.311167
6570	1930	2	\N	2015-03-07 21:18:30.204883
6571	1980	2	\N	2015-03-07 21:18:36.892234
6572	1930	2	\N	2015-03-07 21:21:01.745845
6573	1982	2	\N	2015-03-07 21:45:35.899441
6574	1983	2	\N	2015-03-07 21:45:46.115364
6575	1985	2	\N	2015-03-07 21:45:53.837217
6576	2016	2	\N	2015-03-07 21:46:03.965785
6577	1940	2	\N	2015-03-07 21:46:13.798132
6578	1932	2	\N	2015-03-07 21:46:22.868946
6579	1934	2	\N	2015-03-07 21:46:33.42948
6580	1935	2	\N	2015-03-07 21:46:42.582075
6581	1936	2	\N	2015-03-07 21:46:53.561952
6582	1933	2	\N	2015-03-07 21:47:06.74156
6583	1923	2	\N	2015-03-07 21:47:13.496663
6584	1922	2	\N	2015-03-08 18:02:14.423833
6585	1922	2	\N	2015-03-08 18:02:24.288542
6586	1989	2	\N	2015-03-08 18:07:00.091644
6587	1922	2	\N	2015-03-08 18:17:03.971743
6588	1922	2	\N	2015-03-08 18:29:12.5349
6589	2063	2	\N	2015-03-08 18:41:45.468589
6590	1989	2	\N	2015-03-08 18:41:51.822924
6591	2021	2	\N	2015-03-09 13:29:58.788901
6592	2065	2	\N	2015-03-09 14:02:38.899688
6593	2066	2	\N	2015-03-09 17:16:22.759831
6594	2068	2	\N	2015-03-09 19:28:40.834898
6595	1980	2	\N	2015-03-09 19:37:29.594475
6596	1389	2	\N	2015-03-15 19:00:11.360402
6597	1389	2	\N	2015-03-15 19:07:00.022851
6598	1389	2	\N	2015-03-15 19:08:22.540227
6599	2070	2	\N	2015-03-21 15:11:50.495946
6600	1989	2	\N	2015-03-21 15:11:59.182752
6601	2072	2	\N	2015-03-21 16:45:36.665599
6602	2073	2	\N	2015-03-21 16:48:27.610676
6603	2052	2	\N	2015-03-21 16:50:40.821135
6604	2074	2	\N	2015-03-21 16:52:45.363807
6605	2052	2	\N	2015-03-21 16:52:47.683727
6606	2075	2	\N	2015-03-21 17:05:47.83578
6607	2075	2	\N	2015-03-21 17:06:12.331454
6608	2052	2	\N	2015-03-21 17:06:35.32059
6609	2070	2	\N	2015-03-21 17:48:31.664941
6610	2077	2	\N	2015-03-21 17:49:14.645342
6611	2078	2	\N	2015-03-21 17:54:43.831114
6612	2079	2	\N	2015-03-21 17:55:33.936569
6613	2080	2	\N	2015-03-21 17:56:10.086202
6614	2081	2	\N	2015-03-21 17:58:56.608273
6615	2082	2	\N	2015-03-21 18:09:53.861989
6616	2083	2	\N	2015-03-21 18:15:06.078059
6617	2084	2	\N	2015-03-21 18:15:58.715735
6618	2052	2	\N	2015-03-21 18:16:06.930298
6619	2085	2	\N	2015-03-21 18:18:25.006345
6620	2086	2	\N	2015-03-21 18:19:02.220427
6621	2052	2	\N	2015-03-21 18:19:16.455929
6622	2087	2	\N	2015-03-21 18:20:19.713186
6623	2052	2	\N	2015-03-21 18:20:29.187736
6624	2052	2	\N	2015-03-21 19:28:39.349206
6625	2052	2	\N	2015-03-21 19:30:14.844869
6626	2052	2	\N	2015-03-21 19:33:54.902921
6627	2052	2	\N	2015-03-21 19:34:11.317898
6628	2052	2	\N	2015-03-21 19:35:55.581037
6629	2052	2	\N	2015-03-21 19:36:06.902031
6630	2052	2	\N	2015-03-21 19:36:15.834648
6631	2052	2	\N	2015-03-21 19:36:28.227499
6632	2052	2	\N	2015-03-21 19:36:44.271289
6633	2088	2	\N	2015-03-21 19:36:44.271289
6634	2089	2	\N	2015-03-21 19:38:07.835672
6635	2090	2	\N	2015-03-21 19:38:10.203402
6636	2091	2	\N	2015-03-21 19:40:16.473806
6637	2052	2	\N	2015-03-21 19:40:18.868487
6638	2052	2	\N	2015-03-21 19:41:03.761402
6639	2052	2	\N	2015-03-21 19:42:48.725752
6640	2052	2	\N	2015-03-21 19:43:52.346215
6641	2092	2	\N	2015-03-21 20:11:35.939948
6642	2052	2	\N	2015-03-21 20:11:42.394011
6643	2052	2	\N	2015-03-21 20:12:01.524624
6644	2093	2	\N	2015-03-21 21:12:58.372518
6645	2094	2	\N	2015-03-21 21:13:53.505088
6646	2052	2	\N	2015-03-21 21:14:06.180767
6647	2095	2	\N	2015-03-21 22:03:40.435063
6648	2051	2	\N	2015-03-21 22:03:42.699321
6649	2088	2	\N	2015-03-21 22:03:45.19164
6650	2052	2	\N	2015-03-21 22:12:59.222848
6651	971	2	\N	2015-03-22 16:55:09.922468
6652	2096	2	\N	2015-03-22 17:22:28.394236
6653	970	2	\N	2015-03-22 17:22:30.31308
6654	971	2	\N	2015-03-22 17:32:58.675826
6655	2097	2	\N	2015-03-22 17:35:36.969555
6656	2052	2	\N	2015-03-22 17:35:38.710629
6657	2052	2	\N	2015-03-22 17:35:54.667572
6658	2052	2	\N	2015-03-22 17:36:02.394493
6659	1413	2	\N	2015-03-22 21:10:23.96026
6660	2098	2	\N	2015-03-22 21:12:12.040889
6661	1413	2	\N	2015-03-22 21:12:14.574907
6662	953	2	\N	2015-03-23 10:52:07.126828
6663	955	2	\N	2015-03-23 10:52:46.434534
6664	955	2	\N	2015-03-23 10:53:07.107505
6665	971	2	\N	2015-03-23 11:17:09.549645
6666	971	2	\N	2015-03-23 11:17:14.786132
6667	971	2	\N	2015-03-23 22:30:47.611278
6668	2099	2	\N	2015-03-24 19:25:49.743645
6669	2100	2	\N	2015-03-24 19:26:22.746874
6670	2101	2	\N	2015-03-24 19:30:50.825716
6671	1413	2	\N	2015-03-24 21:27:29.027714
6672	1413	2	\N	2015-03-24 21:27:56.025596
6673	2104	2	\N	2015-03-25 22:08:36.018637
6674	2105	2	\N	2015-03-25 22:09:11.121353
6675	2106	2	\N	2015-03-25 22:10:32.26983
6676	2107	2	\N	2015-03-27 21:02:27.365736
6677	1413	2	\N	2015-03-27 22:11:48.664734
6678	1318	2	\N	2015-03-27 22:11:57.175441
6679	2108	2	\N	2015-03-27 22:14:09.702895
6680	1413	2	\N	2015-03-27 22:14:23.177174
6681	1975	2	\N	2015-03-29 14:54:09.090695
6682	1975	2	\N	2015-03-29 14:56:05.558074
6683	2054	2	\N	2015-03-29 18:10:37.298528
6684	2054	2	\N	2015-03-29 18:10:44.494853
6685	2054	2	\N	2015-03-29 18:11:59.351954
6686	894	2	\N	2015-03-29 18:12:33.345883
6687	2108	2	\N	2015-03-29 18:41:14.962865
6688	2108	2	\N	2015-03-29 18:41:28.932911
6689	2108	2	\N	2015-03-29 18:41:35.361837
6690	1568	2	\N	2015-03-29 18:59:52.709639
6691	1567	2	\N	2015-03-29 18:59:57.605194
6693	1578	2	\N	2015-03-29 19:28:18.094577
6694	1563	2	\N	2015-03-29 19:28:26.306719
6695	1560	2	\N	2015-03-29 19:28:31.032916
6696	1649	2	\N	2015-03-29 20:30:21.118741
6698	2111	2	\N	2015-03-29 20:32:08.188477
6699	918	2	\N	2015-03-29 20:45:02.042426
6700	918	2	\N	2015-03-29 20:45:08.391579
6701	917	2	\N	2015-03-29 20:45:13.080299
6702	916	2	\N	2015-03-29 20:45:17.094049
6703	952	2	\N	2015-03-29 20:51:29.823177
6705	988	2	\N	2015-03-29 20:57:38.470567
6707	971	2	\N	2015-03-29 21:04:32.587955
6709	1647	2	\N	2015-03-29 21:11:13.101083
6710	2115	2	\N	2015-03-29 21:11:20.771189
6711	1648	2	\N	2015-03-29 21:19:19.348961
6713	1646	2	\N	2015-03-29 21:25:36.400114
6715	1419	2	\N	2015-03-31 18:55:34.756779
6716	1415	2	\N	2015-03-31 18:55:54.50919
6718	1507	2	\N	2015-03-31 19:11:10.805316
6719	1507	2	\N	2015-03-31 19:11:17.000092
6720	1507	2	\N	2015-03-31 19:11:23.716877
6721	1898	2	\N	2015-03-31 19:19:08.662529
6722	1898	2	\N	2015-03-31 19:19:13.979595
6723	1898	2	\N	2015-03-31 19:19:19.541915
6724	2119	2	\N	2015-03-31 19:31:32.255315
6725	1419	2	\N	2015-03-31 19:31:35.171043
6726	2120	2	\N	2015-03-31 21:42:30.209371
6727	2107	2	\N	2015-04-06 22:18:27.344977
6728	2054	2	\N	2015-04-22 09:31:23.533867
6729	2126	2	\N	2015-04-22 10:21:50.083529
6730	2126	2	\N	2015-04-22 10:34:35.83663
6731	2127	2	\N	2015-04-22 15:08:30.934237
6732	2128	2	\N	2015-04-22 15:09:24.597951
6733	2129	2	\N	2015-04-22 15:30:21.099029
6734	2130	2	\N	2015-04-22 15:30:28.848383
6735	2131	2	\N	2015-04-22 15:33:06.666889
6736	2126	2	\N	2015-04-22 15:33:09.520564
6737	2132	2	\N	2015-04-22 15:34:13.439147
6738	2126	2	\N	2015-04-22 15:34:14.494849
6739	2126	2	\N	2015-04-22 15:34:41.240196
\.


--
-- Data for Name: resource_type; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY resource_type (id, resource_id, name, humanize, resource_name, module, description, settings, customizable, status) FROM stdin;
132	2070	wish	Wish Items	WishResource	travelcrm.resources.wish	Wishes Items is the list of services that customer wish in the lead	null	f	0
134	2099	order	Orders	OrderResource	travelcrm.resources.order	Orders	null	f	0
2	10	user	Users	UserResource	travelcrm.resources.user	Users list	\N	f	0
12	16	resource_type	Resources Types	ResourceTypeResource	travelcrm.resources.resource_type	Resources types list	\N	f	0
47	706	employee	Employees	EmployeeResource	travelcrm.resources.employee	Employees Container Datagrid	\N	f	0
78	1003	touroperator	Touroperators	TouroperatorResource	travelcrm.resources.touroperator	Touroperators - tours suppliers list	\N	f	0
92	1221	tour_sale	Tours Sale	TourSaleResource	travelcrm.resources.tour_sale	Tours sales documents	{"service_id": 5}	t	0
93	1225	task	Tasks	TaskResource	travelcrm.resources.task	Task manager	\N	f	0
106	1433	income	Incomes	IncomeResource	travelcrm.resources.income	Incomes Payments Document for invoices	{"account_item_id": 8}	f	0
107	1435	account	Accounts	AccountResource	travelcrm.resources.account	Billing Accounts. It can be bank accouts, cash accounts etc. and has company wide visible	null	f	0
117	1797	subaccount	Subaccounts	SubaccountResource	travelcrm.resources.subaccount	Subaccounts are accounts from other objects such as clients, touroperators and so on	null	f	0
118	1799	note	Notes	NoteResource	travelcrm.resources.note	Resources Notes	null	f	0
119	1849	calculation	Caluclations	CalculationResource	travelcrm.resources.calculation	Calculations of Sale Documents	null	f	0
120	1884	crosspayment	Cross Payments	CrosspaymentResource	travelcrm.resources.crosspayment	Cross payments between accounts and subaccounts. This document is for balance corrections to.	null	f	0
121	1894	turnover	Turnovers	TurnoverResource	travelcrm.resources.turnover	Turnovers on Accounts and Subaccounts	null	f	0
122	1919	debt	Debts	DebtResource	travelcrm.resources.debt	Calculations based debts report	null	f	0
1	773		Home	Root	travelcrm.resources	Home Page of Travelcrm	\N	f	0
133	2077	offer	Offer Items	OfferResource	travelcrm.resources.offer	Offers Items is the list of services that manager offer to the customer	null	f	0
135	2100	order_item	Orders Items	OrderItemResource	travelcrm.resources.order_item	Orders Items	null	f	0
137	2108	accomodation_service	Accomodations Services	AccomodationServiceResource	travelcrm.resources.accomodation_service	Accomodations Services Interface	null	f	0
41	283	currency	Currencies	CurrencyResource	travelcrm.resources.currency		\N	f	0
55	723	structure	Structures	StructureResource	travelcrm.resources.structure	Companies structures is a tree of company structure. It's can be offices, filials, departments and so and so	\N	f	0
59	764	position	Positions	PositionResource	travelcrm.resources.position	Companies positions is a point of company structure where emplyees can be appointed	\N	f	0
61	769	permision	Permisions	PermisionResource	travelcrm.resources.permision	Permisions list of company structure position. It's list of resources and permisions	\N	f	0
65	775	navigation	Navigations	NavigationResource	travelcrm.resources.navigation	Navigations list of company structure position.	\N	f	0
67	788	appointment	Appointments	AppointmentResource	travelcrm.resources.appointment	Employees to positions of company appointments	\N	f	0
126	1968	company	Companies	CompanyResource	travelcrm.resources.company	Multicompanies functionality	null	f	0
129	1989	sale_dynamic	Portlet: Sales Dynamics	SaleDynamicResource	travelcrm.resources.sale_dynamic	Portlet that shows dynamics of sales in quantity	{"column_index": 0}	t	0
130	2049	lead	Leads	LeadResource	travelcrm.resources.lead	Leads that can be converted into contacts	null	f	0
72	908	hotelcat	Hotels Categories	HotelcatResource	travelcrm.resources.hotelcat	Hotels categories	\N	f	0
73	909	roomcat	Rooms Categories	RoomcatResource	travelcrm.resources.roomcat	Categories of the rooms	\N	f	0
87	1190	contact	Contacts	ContactResource	travelcrm.resources.contact	Contacts for persons, business persons etc.	\N	f	0
39	274	region	Regions	RegionResource	travelcrm.resources.region		\N	f	0
69	865	person	Persons	PersonResource	travelcrm.resources.person	Persons directory. Person can be client or potential client	\N	f	0
70	872	country	Countries	CountryResource	travelcrm.resources.country	Countries directory	\N	f	0
71	901	advsource	Advertise Sources	AdvsourceResource	travelcrm.resources.advsource	Types of advertises	\N	f	0
74	953	accomodation_type	Accomodations Types	AccomodationTypeResource	travelcrm.resources.accomodation_type	Accomodations Types list	\N	f	0
75	954	foodcat	Food Categories	FoodcatResource	travelcrm.resources.foodcat	Food types in hotels	\N	f	0
79	1007	bperson	Business Persons	BPersonResource	travelcrm.resources.bperson	Business Persons is not clients it's simple business contacts that can be referenced objects that needs to have contacts	\N	f	0
83	1081	hotel	Hotels	HotelResource	travelcrm.resources.hotel	Hotels directory	\N	f	0
84	1088	location	Locations	LocationResource	travelcrm.resources.location	Locations list is list of cities, vilages etc. places to use to identify part of region	\N	f	0
86	1189	licence	Licences	LicenceResource	travelcrm.resources.licence	Licences list for any type of resources as need	\N	f	0
89	1198	passport	Passports	PassportResource	travelcrm.resources.passport	Clients persons passports lists	\N	f	0
90	1207	address	Addresses	AddressResource	travelcrm.resources.address	Addresses of any type of resources, such as persons, bpersons, hotels etc.	\N	f	0
91	1211	bank	Banks	BankResource	travelcrm.resources.bank	Banks list to create bank details and for other reasons	\N	f	0
101	1268	bank_detail	Banks Details	BankDetailResource	travelcrm.resources.bank_detail	Banks Details that can be attached to any client or business partner to define account	\N	f	0
102	1313	service	Services	ServiceResource	travelcrm.resources.service	Additional Services that can be provide with tours sales or separate	\N	f	0
103	1317	invoice	Invoices	InvoiceResource	travelcrm.resources.invoice	Invoices list. Invoice can't be created manualy - only using source document such as Tours	{"active_days": 3}	t	0
104	1393	currency_rate	Currency Rates	CurrencyRateResource	travelcrm.resources.currency_rate	Currencies Rates. Values from this dir used by billing to calc prices in base currency.	\N	f	0
105	1424	account_item	Account Items	AccountItemResource	travelcrm.resources.account_item	Finance accounts items	\N	f	0
108	1450	service_item	Service Item	ServiceItemResource	travelcrm.resources.service_item	Services Items List for include in sales documents such as Tours, Services Sales etc.	null	f	0
109	1452	service_sale	Services Sale	ServiceSaleResource	travelcrm.resources.service_sale	Additionals Services sales document. It is Invoicable objects and can generate contracts	null	f	0
110	1521	commission	Commissions	CommissionResource	travelcrm.resources.commission	Services sales commissions	null	f	0
111	1548	outgoing	Outgoings	OutgoingResource	travelcrm.resources.outgoing	Outgoings payments for touroperators, suppliers, payback payments and so on	null	f	0
112	1549	supplier	Suppliers	SupplierResource	travelcrm.resources.supplier	Suppliers for other services except tours services	null	f	0
123	1941	notification	Notifications	NotificationResource	travelcrm.resources.notification	Employee Notifications	null	f	0
124	1954	email_campaign	Email Campaigns	EmailCampaignResource	travelcrm.resources.email_campaign	Emails Campaigns for subscribers	{"timeout": 12}	t	0
125	1966	unpaid	Portlet: Unpaid Invoices	UnpaidResource	travelcrm.resources.unpaid	Portlet that shows invoices which has no any pay and active date is over	{"column_index": 1}	t	0
136	2107	general_service	General Services	GeneralServiceResource	travelcrm.resources.general_service	Common Services Interface	null	f	0
138	2127	transfer	Transfers	TransferResource	travelcrm.resources.transfer	Transfers for tours	null	f	0
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

SELECT pg_catalog.setval('roomcat_id_seq', 34, true);


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY service (id, resource_id, name, descr, display_text, account_item_id, resource_type_id) FROM stdin;
4	1318	A visa	\N	\N	2	136
3	1316	Travel Insurance	Travel Insurance price is custom.	\N	2	136
1	1314	Foreign Passport Service	\N	\N	2	136
5	1413	Tour	Use this service for tour sales	Advance payment for travel services	1	137
\.


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('service_id_seq', 6, true);


--
-- Data for Name: service_item; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY service_item (id, resource_id, service_id, currency_id, touroperator_id, price, person_id, base_price) FROM stdin;
9	1462	4	57	5	60.00	21	726.00
10	1463	4	57	5	60.00	20	726.00
25	1629	3	57	2	5.00	40	60.00
26	1631	3	57	2	5.00	39	60.00
27	1632	3	57	2	10.00	38	120.00
28	1633	3	57	2	10.00	37	120.00
29	1654	4	54	57	300.00	41	5460.00
30	1655	4	54	57	300.00	42	5460.00
24	1618	1	57	1	80.00	35	960.00
31	1758	1	57	1	45.00	38	540.00
3	1455	4	54	1	20.00	21	334.00
17	1481	1	57	1	54.00	20	653.40
18	1482	1	57	1	54.00	21	653.40
19	1483	4	54	1	20.00	20	334.00
11	1474	3	54	1	10.00	32	167.00
12	1475	3	54	1	10.00	31	167.00
13	1476	3	54	1	20.00	29	334.00
14	1477	3	54	1	20.00	30	334.00
15	1478	1	57	1	54.00	29	648.00
16	1479	1	57	1	54.00	30	648.00
20	1520	3	56	57	12.00	30	0.00
1	1453	4	57	57	60.00	21	0.00
2	1454	4	57	5	60.00	20	0.00
4	1457	3	57	2	20.00	20	0.00
5	1458	3	57	5	20.00	27	0.00
6	1459	4	54	1	60.00	20	0.00
7	1460	1	57	5	100.00	25	0.00
8	1461	3	54	57	67.00	6	0.00
21	1595	4	54	57	43.00	34	782.60
22	1596	4	54	62	45.00	33	819.00
23	1600	4	54	62	45.00	34	819.00
40	1848	5	54	5	2350.00	17	39010.00
33	1841	5	56	57	64576.00	41	64576.00
34	1842	5	57	2	2490.00	37	29880.00
35	1843	5	57	2	1475.00	35	17700.00
36	1844	5	54	62	3569.00	33	64955.80
37	1845	5	54	1	3556.00	29	59385.20
38	1846	5	56	61	8520.00	25	8520.00
39	1847	5	54	1	3534.00	20	59017.80
41	1929	5	56	5	23000.00	30	23000.00
42	1998	4	56	63	750.00	43	750.00
43	2003	3	56	61	3450.00	6	3450.00
44	2022	5	57	2	2330.00	44	48697.00
45	2033	4	56	1	1300.00	45	1300.00
46	2034	4	56	1	1300.00	44	1300.00
\.


--
-- Name: service_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('service_item_id_seq', 46, true);


--
-- Data for Name: service_sale; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY service_sale (id, deal_date, resource_id, customer_id, advsource_id) FROM stdin;
1	2014-06-09	1456	20	6
2	2014-09-14	1759	40	5
3	2015-01-16	1999	43	5
4	2015-01-14	2004	6	4
5	2015-02-01	2035	44	2
\.


--
-- Name: service_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('service_sale_id_seq', 5, true);


--
-- Data for Name: service_sale_invoice; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY service_sale_invoice (service_sale_id, invoice_id) FROM stdin;
1	13
2	21
3	23
4	24
\.


--
-- Data for Name: service_sale_service_item; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY service_sale_service_item (service_sale_id, service_item_id) FROM stdin;
1	3
1	19
1	18
1	17
2	31
3	42
4	43
5	45
5	46
\.


--
-- Data for Name: structure; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY structure (id, resource_id, parent_id, name, company_id) FROM stdin;
2	858	\N	Kiev Office	1
3	859	2	Sales Department	1
4	860	32	Marketing Dep.	1
1	857	32	Software Dev. Dep.	1
5	861	32	CEO	1
7	1062	\N	Moscow Office	1
8	1250	\N	Odessa Office	1
9	1251	8	Sales Department	1
11	1277	\N	Lviv Office	1
32	725	\N	Head Office	1
13	1976	\N	Dnepropetrovsk Office	1
\.


--
-- Data for Name: structure_address; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY structure_address (structure_id, address_id) FROM stdin;
32	31
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

SELECT pg_catalog.setval('structures_id_seq', 13, true);


--
-- Data for Name: subaccount; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY subaccount (id, resource_id, account_id, name, descr) FROM stdin;
1	1865	4	Vitalii Mazur EUR | cash	\N
2	1866	2	News Travel | Bank	\N
3	1867	4	Alexander Karpenko | EUR	\N
4	1868	3	Garkaviy Andriy | UAH	\N
6	1875	3	Main Cash Account | rid: 1628	\N
8	1881	3	Main Cash Account | rid: 1372	\N
9	1888	2	Lun Real Estate | UAH	Month Rate
10	1902	3	Lun Real Estate | UAH | CASH	Lun on cash account
11	1911	4	Main Cash EUR Account | rid: 1465	\N
12	1913	2	Sun Marino Trvl | Cash UAH	Sun Marino Main Bank Subaccount
13	1991	3	Main Cash Account | rid: 1471	\N
14	1997	3	Main Cash Account | rid: 1645	\N
15	2002	3	Main Cash Account | rid: 1869	\N
16	2007	3	Main Cash Account | rid: 887	\N
17	2028	3	Main Cash Account | rid: 2017	\N
\.


--
-- Name: subaccount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('subaccount_id_seq', 17, true);


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY supplier (id, resource_id, name) FROM stdin;
5	1567	Intertelecom
6	1568	Lun Real Estate
\.


--
-- Data for Name: supplier_bank_detail; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY supplier_bank_detail (supplier_id, bank_detail_id) FROM stdin;
6	15
5	16
\.


--
-- Data for Name: supplier_bperson; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY supplier_bperson (supplier_id, bperson_id) FROM stdin;
6	7
5	5
5	6
\.


--
-- Name: supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('supplier_id_seq', 6, true);


--
-- Data for Name: suppplier_subaccount; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY suppplier_subaccount (supplier_id, subaccount_id) FROM stdin;
6	9
6	10
\.


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY task (id, resource_id, employee_id, title, deadline, reminder, descr, status) FROM stdin;
37	1933	2	Call and remind about payment	2014-12-14 22:46:00	2014-12-14 11:15:00	\N	3
34	1923	2	Test 2	2014-12-16 17:21:00	2014-12-15 17:42:00	\N	2
38	1934	2	Call and remind about payment	2014-12-12 22:50:00	2014-12-11 22:52:00	Call and remind to pay invoice	0
39	1935	2	Review Calculation	2014-12-12 22:52:00	2014-12-11 22:55:00	\N	0
40	1936	2	For testing Purpose only	2014-12-14 22:35:00	2014-12-14 20:32:00	\N	0
33	1922	30	Test	2014-12-07 21:36:00	2014-12-07 20:36:00	For testing purpose	1
55	2063	2	Revert status after testing	2015-03-08 19:41:00	2015-03-08 18:42:00	Set status into active after testing	0
56	2066	2	Notifications testing #2	2015-03-11 17:16:00	2015-03-09 17:17:00	\N	0
57	2068	2	Test Notification resource link	2015-03-11 19:28:00	2015-03-09 19:29:00	\N	0
48	1980	2	Check Reminder	2015-01-08 18:21:00	2015-01-07 18:21:00	Description to task	3
58	2075	2	Call about discounts	2015-03-21 17:20:00	2015-03-21 17:10:00	Calls and talk about tour discounts	0
47	1971	2	Check Payments	2015-01-04 15:45:00	2015-01-04 14:06:00	\N	1
41	1939	2	I have the following code	2014-12-13 23:36:00	2014-12-13 22:04:00	\N	3
46	1964	2	For testing	2014-12-25 23:05:00	2014-12-25 21:06:00	For testing purpose only	3
45	1962	2	Test	2014-12-24 23:32:00	2014-12-24 21:33:00	\N	3
52	2009	2	I decided to try to follow the postgres approach as directly as possible and came up with the following migration.	2015-01-21 22:44:00	2015-01-21 21:45:00	\N	1
54	2062	2	New JEasyui version migrate	2015-03-07 21:43:00	2015-03-07 20:43:00	Migrate on new 0.4.2 jeasyui version, check all functionality.	2
44	1958	2	Test new scheduler realization	2014-12-22 19:18:00	2014-12-21 19:44:00	New scheduler realizations notifications test.	3
35	1930	2	Check Person Details	2014-12-11 21:43:00	2014-12-10 22:42:00	We'll reuse the Amount type from last week. It's mostly the same, except we'll remove __clause_element__(), and additionally provide a classmethod version of the as_currency() method, which we'll use when dealing with SQL expressions.	2
49	1982	2	The second task	2015-01-08 18:30:00	2015-01-07 18:30:00	Second test task	1
50	1983	2	Test	2015-01-13 17:06:00	2015-01-13 17:01:00	\N	1
51	1985	2	Test 2	2015-01-14 17:02:00	2015-01-13 17:04:00	\N	1
53	2016	2	Notify his	2015-02-02 17:09:00	2015-02-02 15:09:00	Notify about the documents	3
42	1940	2	Test notifications	2014-12-14 21:37:00	2014-12-14 20:38:00	\N	2
36	1932	2	Call and remind about payments	2014-12-11 22:48:00	2014-12-11 22:46:00	\N	1
59	2131	2	Task For Lastovec	2015-04-23 15:32:00	2015-04-22 15:40:00	Test description for task	0
\.


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('task_id_seq', 59, true);


--
-- Data for Name: task_resource; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY task_resource (task_id, resource_id) FROM stdin;
39	1928
38	1928
35	1869
47	1840
48	3
49	3
53	2017
55	1989
58	2088
59	2126
\.


--
-- Name: tour_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('tour_id_seq', 19, true);


--
-- Name: tour_point_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('tour_point_id_seq', 71, true);


--
-- Data for Name: tour_sale; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY tour_sale (id, start_location_id, end_location_id, adults, children, customer_id, resource_id, end_date, start_date, deal_date, advsource_id) FROM stdin;
15	15	15	2	0	35	1617	2014-08-31	2014-08-25	2014-08-24	2
14	15	15	2	0	33	1594	2014-08-31	2014-08-23	2014-08-22	6
13	15	15	2	2	29	1480	2014-07-20	2014-07-14	2014-06-22	2
12	14	14	2	2	25	1412	2014-07-25	2014-07-14	2014-07-14	4
10	15	15	2	0	20	1377	2014-06-07	2014-06-01	2014-05-20	4
9	15	15	2	1	17	1295	2014-05-09	2014-05-01	2014-05-17	6
16	15	15	2	2	37	1630	2014-06-09	2014-08-31	2014-08-24	4
17	15	15	2	0	41	1656	2014-05-09	2014-08-30	2014-08-26	4
18	33	34	2	0	30	1928	2014-12-13	2014-12-08	2014-07-12	1
19	15	15	2	0	44	2021	2015-02-13	2015-02-06	2015-02-01	2
\.


--
-- Data for Name: tour_sale_invoice; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY tour_sale_invoice (tour_sale_id, invoice_id) FROM stdin;
10	8
9	10
13	14
12	15
14	16
15	17
17	19
16	20
18	22
19	26
\.


--
-- Data for Name: tour_sale_person; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY tour_sale_person (tour_sale_id, person_id) FROM stdin;
13	31
13	30
13	29
13	32
12	25
12	26
12	28
12	27
10	20
10	21
9	17
9	18
9	19
15	35
15	36
14	34
14	33
16	40
16	37
16	38
16	39
17	42
17	41
18	41
18	30
19	44
19	45
\.


--
-- Data for Name: tour_sale_point; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY tour_sale_point (id, location_id, hotel_id, accomodation_type_id, foodcat_id, roomcat_id, tour_sale_id, description, end_date, start_date) FROM stdin;
60	16	10	14	10	30	9	All include, Adriatic Sea, excursions and transfer included	2014-05-09	2014-05-01
61	27	27	10	11	\N	10	\N	2014-06-07	2014-06-01
62	32	33	10	11	29	\N	\N	2014-07-18	2014-07-12
63	32	33	10	10	29	12	\N	2014-07-25	2014-07-14
64	21	34	\N	\N	\N	13	\N	2014-07-20	2014-07-14
65	36	35	\N	\N	\N	14	\N	2014-08-31	2014-08-25
66	17	13	\N	\N	\N	15	\N	2014-08-31	2014-08-25
67	31	32	\N	10	\N	16	\N	2014-09-02	2014-08-31
68	30	31	\N	15	31	16	\N	2014-09-06	2014-09-02
69	37	36	\N	\N	\N	17	\N	2014-09-05	2014-08-30
70	36	\N	\N	\N	\N	18	\N	2014-12-13	2014-07-12
71	21	15	10	15	31	19	\N	2015-02-13	2015-02-06
\.


--
-- Data for Name: tour_sale_service_item; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY tour_sale_service_item (tour_sale_id, service_item_id) FROM stdin;
17	33
16	34
15	35
14	36
13	37
12	38
10	39
9	40
18	41
19	44
\.


--
-- Data for Name: touroperator; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator (id, resource_id, name) FROM stdin;
1	1004	Turtess Travel
2	1005	Coral Travel
5	1067	Sail Croatia
61	1378	EthnoTour
57	1159	Sun Marino Trvl.
62	1580	News Travel
63	1870	Four Winds
\.


--
-- Data for Name: touroperator_bank_detail; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator_bank_detail (touroperator_id, bank_detail_id) FROM stdin;
2	6
2	11
2	8
2	9
2	10
\.


--
-- Data for Name: touroperator_bperson; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator_bperson (touroperator_id, bperson_id) FROM stdin;
2	1
62	8
\.


--
-- Data for Name: touroperator_commission; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator_commission (touroperator_id, commission_id) FROM stdin;
2	17
2	20
2	19
2	18
62	21
1	22
57	23
1	25
1	26
\.


--
-- Name: touroperator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('touroperator_id_seq', 64, true);


--
-- Data for Name: touroperator_licence; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator_licence (touroperator_id, licence_id) FROM stdin;
2	44
62	46
63	47
\.


--
-- Data for Name: touroperator_subaccount; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY touroperator_subaccount (touroperator_id, subaccount_id) FROM stdin;
62	2
57	12
\.


--
-- Data for Name: transfer; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY transfer (id, resource_id, name) FROM stdin;
1	2129	Group
2	2130	Individual
\.


--
-- Name: transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('transfer_id_seq', 94, true);


--
-- Name: transfer_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('transfer_id_seq1', 2, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY "user" (id, resource_id, username, email, password, employee_id) FROM stdin;
2	3	admin	vitalii.mazur@gmail.com	adminadmin	2
25	2054	maz_iv	\N	korn17	30
23	894	maziv	\N	111111	7
31	2126	v.lastovec	\N	111111	15
\.


--
-- Data for Name: wish; Type: TABLE DATA; Schema: public; Owner: mazvv
--

COPY wish (id, resource_id, service_id, currency_id, price_from, price_to, descr) FROM stdin;
\.


--
-- Name: wish_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mazvv
--

SELECT pg_catalog.setval('wish_id_seq', 1, false);


--
-- Name: accomodation_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY accomodation_type
    ADD CONSTRAINT accomodation_pkey PRIMARY KEY (id);


--
-- Name: account_item_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT account_item_pkey PRIMARY KEY (id);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


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
-- Name: apscheduler_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY apscheduler_jobs
    ADD CONSTRAINT apscheduler_jobs_pkey PRIMARY KEY (id);


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
-- Name: calculation_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT calculation_pkey PRIMARY KEY (id);


--
-- Name: commission_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT commission_pkey PRIMARY KEY (id);


--
-- Name: company_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


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
-- Name: crosspayment_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT crosspayment_pkey PRIMARY KEY (id);


--
-- Name: currency_pk; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT currency_pk PRIMARY KEY (id);


--
-- Name: currency_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT currency_rate_pkey PRIMARY KEY (id);


--
-- Name: email_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY email_campaign
    ADD CONSTRAINT email_campaign_pkey PRIMARY KEY (id);


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
-- Name: employee_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT employee_notification_pkey PRIMARY KEY (employee_id, notification_id);


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
-- Name: employee_subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT employee_subaccount_pkey PRIMARY KEY (employee_id, subaccount_id);


--
-- Name: foodcat_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT foodcat_pkey PRIMARY KEY (id);


--
-- Name: general_service_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY general_service
    ADD CONSTRAINT general_service_pkey PRIMARY KEY (id);


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
-- Name: income_cashflow_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT income_cashflow_pkey PRIMARY KEY (income_id, cashflow_id);


--
-- Name: income_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY income
    ADD CONSTRAINT income_pkey PRIMARY KEY (id);


--
-- Name: invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);


--
-- Name: lead_offer_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT lead_offer_pkey PRIMARY KEY (lead_id, offer_id);


--
-- Name: lead_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT lead_pkey PRIMARY KEY (id);


--
-- Name: lead_wish_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY lead_wish
    ADD CONSTRAINT lead_wish_pkey PRIMARY KEY (lead_id, wish_id);


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
-- Name: note_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_pkey PRIMARY KEY (id);


--
-- Name: note_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT note_resource_pkey PRIMARY KEY (note_id, resource_id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT notification_resource_pkey PRIMARY KEY (notification_id, resource_id);


--
-- Name: offer_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY offer
    ADD CONSTRAINT offer_pkey PRIMARY KEY (id);


--
-- Name: order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: outgoing_cashflow_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT outgoing_cashflow_pkey PRIMARY KEY (outgoing_id, cashflow_id);


--
-- Name: outgoing_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT outgoing_pkey PRIMARY KEY (id);


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
-- Name: person_order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT person_order_item_pkey PRIMARY KEY (order_item_id, person_id);


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
-- Name: person_subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT person_subaccount_pkey PRIMARY KEY (person_id, subaccount_id);


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
-- Name: service_item_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT service_item_pkey PRIMARY KEY (id);


--
-- Name: service_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: service_sale_invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY service_sale_invoice
    ADD CONSTRAINT service_sale_invoice_pkey PRIMARY KEY (service_sale_id, invoice_id);


--
-- Name: service_sale_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY service_sale
    ADD CONSTRAINT service_sale_pkey PRIMARY KEY (id);


--
-- Name: service_sale_service_item_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY service_sale_service_item
    ADD CONSTRAINT service_sale_service_item_pkey PRIMARY KEY (service_sale_id, service_item_id);


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
-- Name: subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT subaccount_pkey PRIMARY KEY (id);


--
-- Name: supplier_bank_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT supplier_bank_detail_pkey PRIMARY KEY (supplier_id, bank_detail_id);


--
-- Name: supplier_bperson_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT supplier_bperson_pkey PRIMARY KEY (supplier_id, bperson_id);


--
-- Name: supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- Name: suppplier_subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY suppplier_subaccount
    ADD CONSTRAINT suppplier_subaccount_pkey PRIMARY KEY (supplier_id, subaccount_id);


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
-- Name: tour_invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY tour_sale_invoice
    ADD CONSTRAINT tour_invoice_pkey PRIMARY KEY (tour_sale_id, invoice_id);


--
-- Name: tour_person_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY tour_sale_person
    ADD CONSTRAINT tour_person_pkey PRIMARY KEY (tour_sale_id, person_id);


--
-- Name: tour_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT tour_pkey PRIMARY KEY (id);


--
-- Name: tour_point_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT tour_point_pkey PRIMARY KEY (id);


--
-- Name: tour_sale_service_item_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY tour_sale_service_item
    ADD CONSTRAINT tour_sale_service_item_pkey PRIMARY KEY (tour_sale_id, service_item_id);


--
-- Name: touroperator_bank_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY touroperator_bank_detail
    ADD CONSTRAINT touroperator_bank_detail_pkey PRIMARY KEY (touroperator_id, bank_detail_id);


--
-- Name: touroperator_commission_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY touroperator_commission
    ADD CONSTRAINT touroperator_commission_pkey PRIMARY KEY (touroperator_id, commission_id);


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
-- Name: touroperator_subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY touroperator_subaccount
    ADD CONSTRAINT touroperator_subaccount_pkey PRIMARY KEY (touroperator_id, subaccount_id);


--
-- Name: transfer_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT transfer_pkey PRIMARY KEY (id);


--
-- Name: transfer_pkey1; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_pkey1 PRIMARY KEY (id);


--
-- Name: unique_idx_accomodation_type_name; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY accomodation_type
    ADD CONSTRAINT unique_idx_accomodation_type_name UNIQUE (name);


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
-- Name: unique_idx_currency_rate_currency_id_date; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT unique_idx_currency_rate_currency_id_date UNIQUE (currency_id, date);


--
-- Name: unique_idx_name_account; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT unique_idx_name_account UNIQUE (name);


--
-- Name: unique_idx_name_account_item; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT unique_idx_name_account_item UNIQUE (name);


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
-- Name: unique_idx_name_company; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT unique_idx_name_company UNIQUE (name);


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
-- Name: unique_idx_name_service; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT unique_idx_name_service UNIQUE (name);


--
-- Name: unique_idx_name_strcuture_id_position; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT unique_idx_name_strcuture_id_position UNIQUE (name, structure_id);


--
-- Name: unique_idx_name_subaccount; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT unique_idx_name_subaccount UNIQUE (name);


--
-- Name: unique_idx_name_supplier; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT unique_idx_name_supplier UNIQUE (name);


--
-- Name: unique_idx_name_touroperator; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY touroperator
    ADD CONSTRAINT unique_idx_name_touroperator UNIQUE (name);


--
-- Name: unique_idx_name_transfer; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT unique_idx_name_transfer UNIQUE (name);


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
-- Name: wish_pkey; Type: CONSTRAINT; Schema: public; Owner: mazvv; Tablespace: 
--

ALTER TABLE ONLY wish
    ADD CONSTRAINT wish_pkey PRIMARY KEY (id);


--
-- Name: ix_apscheduler_jobs_next_run_time; Type: INDEX; Schema: public; Owner: mazvv; Tablespace: 
--

CREATE INDEX ix_apscheduler_jobs_next_run_time ON apscheduler_jobs USING btree (next_run_time);


--
-- Name: fk_accomodation_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_accomodation_id_tour_point FOREIGN KEY (accomodation_type_id) REFERENCES accomodation_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_from_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_account_from_id_transfer FOREIGN KEY (account_from_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_id_invoice; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_account_id_invoice FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_outgoing; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_account_item_id_outgoing FOREIGN KEY (account_item_id) REFERENCES account_item(id);


--
-- Name: fk_account_item_id_service; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_account_item_id_service FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_account_item_id_transfer FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_to_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_account_to_id_transfer FOREIGN KEY (account_to_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_advsource_id_lead; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_advsource_id_lead FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_order; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_advsource_id_order FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_service_sale; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_sale
    ADD CONSTRAINT fk_advsource_id_service_sale FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT fk_advsource_id_tour FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_structure_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_supplier_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_supplier_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_bperson_id_supplier_bperson; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT fk_bperson_id_supplier_bperson FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bperson_id_touroperator_bperson; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_bperson
    ADD CONSTRAINT fk_bperson_id_touroperator_bperson FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_calculation_id_order; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_calculation_id_order FOREIGN KEY (calculation_id) REFERENCES calculation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_crosspayment; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_cashflow_id_crosspayment FOREIGN KEY (cashflow_id) REFERENCES cashflow(id);


--
-- Name: fk_cashflow_id_income_cashflow; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT fk_cashflow_id_income_cashflow FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_outgoing_cashflow; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT fk_cashflow_id_outgoing_cashflow FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_commission_id_touroperator_commission; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_commission
    ADD CONSTRAINT fk_commission_id_touroperator_commission FOREIGN KEY (commission_id) REFERENCES commission(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_contact_id_employee_notification; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT fk_contact_id_employee_notification FOREIGN KEY (notification_id) REFERENCES notification(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_currency_id_account; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY account
    ADD CONSTRAINT fk_currency_id_account FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_currency_id_commission; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_currency_id_commission FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_company; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY company
    ADD CONSTRAINT fk_currency_id_company FOREIGN KEY (currency_id) REFERENCES currency(id);


--
-- Name: fk_currency_id_offer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY offer
    ADD CONSTRAINT fk_currency_id_offer FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_currency_id_order_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT fk_currency_id_service_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_currency_id_service_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_currency_id_tour FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_wish; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY wish
    ADD CONSTRAINT fk_currency_id_wish FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_lead; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_customer_id_lead FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_order; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_customer_id_order FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_service_sale; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_sale
    ADD CONSTRAINT fk_customer_id_service_sale FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale
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
-- Name: fk_employee_id_employee_notification; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT fk_employee_id_employee_notification FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_passport; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_employee_id_employee_passport FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT fk_employee_id_employee_subaccount FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT fk_end_location_id_tour FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_foodcat_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_foodcat_id_tour_point FOREIGN KEY (foodcat_id) REFERENCES foodcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotel_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_hotel_id_tour_point FOREIGN KEY (hotel_id) REFERENCES hotel(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotelcat_id_hotel; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_hotelcat_id_hotel FOREIGN KEY (hotelcat_id) REFERENCES hotelcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_income_id_income_cashflow; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT fk_income_id_income_cashflow FOREIGN KEY (income_id) REFERENCES income(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_income; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_invoice_id_income FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_order; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_invoice_id_order FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_service_sale_invoice; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_sale_invoice
    ADD CONSTRAINT fk_invoice_id_service_sale_invoice FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_tour_invoice; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_invoice
    ADD CONSTRAINT fk_invoice_id_tour_invoice FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_lead_offer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_lead_id_lead_offer FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_lead_wish; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY lead_wish
    ADD CONSTRAINT fk_lead_id_lead_wish FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_location_id_tour_point FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_navigation_position_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_navigation_position_id FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_note_id_note_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT fk_note_id_note_resource FOREIGN KEY (note_id) REFERENCES note(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_notification_id_notification_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT fk_notification_id_notification_resource FOREIGN KEY (notification_id) REFERENCES notification(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_offer_item_id_lead_offer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_offer_item_id_lead_offer FOREIGN KEY (offer_id) REFERENCES offer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_order_id_order_item FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_general_service; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY general_service
    ADD CONSTRAINT fk_order_item_id_general_service FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_person_order_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT fk_order_item_id_person_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_outgoing_id_outgoing_cashflow; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT fk_outgoing_id_outgoing_cashflow FOREIGN KEY (outgoing_id) REFERENCES outgoing(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_person_id_person_order_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT fk_person_id_person_order_item FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_passport; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_person_id_person_passport FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT fk_person_id_person_subaccount FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT fk_person_id_service_item FOREIGN KEY (person_id) REFERENCES person(id);


--
-- Name: fk_person_id_tour_person; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_person
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

ALTER TABLE ONLY accomodation_type
    ADD CONSTRAINT fk_resource_id_accomodation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_account; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY account
    ADD CONSTRAINT fk_resource_id_account FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_account_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT fk_resource_id_account_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_id_calculation; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_resource_id_calculation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_commission; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_resource_id_commission FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_company; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY company
    ADD CONSTRAINT fk_resource_id_company FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_id_crosspayment; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_resource_id_crosspayment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_currency; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT fk_resource_id_currency FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_email_campaign; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY email_campaign
    ADD CONSTRAINT fk_resource_id_email_campaign FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_id_general_service; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY general_service
    ADD CONSTRAINT fk_resource_id_general_service FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_id_income; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_resource_id_income FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_invoice; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_resource_id_invoice FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_resource_id_lead FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_id_note; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY note
    ADD CONSTRAINT fk_resource_id_note FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_note_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT fk_resource_id_note_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_notification; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT fk_resource_id_notification FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_notification_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT fk_resource_id_notification_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_offer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY offer
    ADD CONSTRAINT fk_resource_id_offer FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_order; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_resource_id_order FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_resource_id_order_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_outgoing; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_resource_id_outgoing FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_resource_id_resource_log FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: fk_resource_id_service; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_resource_id_service FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT fk_resource_id_service_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_service_sale; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_sale
    ADD CONSTRAINT fk_resource_id_service_sale FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_structure; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_resource_id_structure FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT fk_resource_id_subaccount FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_supplier; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT fk_resource_id_supplier FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_touroperator; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator
    ADD CONSTRAINT fk_resource_id_touroperator FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_resource_id_transfer FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_user; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_resource_id_user FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_wish; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY wish
    ADD CONSTRAINT fk_resource_id_wish FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_type_id_service; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_resource_type_id_service FOREIGN KEY (resource_type_id) REFERENCES resource_type(id);


--
-- Name: fk_roomcat_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_roomcat_id_tour_point FOREIGN KEY (roomcat_id) REFERENCES roomcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_commission; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_service_id_commission FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_offer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY offer
    ADD CONSTRAINT fk_service_id_offer FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_service_id_order_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT fk_service_id_service_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_wish; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY wish
    ADD CONSTRAINT fk_service_id_wish FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_item_id_caluclation; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_service_item_id_caluclation FOREIGN KEY (service_item_id) REFERENCES service_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_item_id_service_sale_service_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_sale_service_item
    ADD CONSTRAINT fk_service_item_id_service_sale_service_item FOREIGN KEY (service_item_id) REFERENCES service_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_item_id_tour_sale_service_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_service_item
    ADD CONSTRAINT fk_service_item_id_tour_sale_service_item FOREIGN KEY (service_item_id) REFERENCES service_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_sale_id_service_sale_invoice; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_sale_invoice
    ADD CONSTRAINT fk_service_sale_id_service_sale_invoice FOREIGN KEY (service_sale_id) REFERENCES service_sale(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_sale_id_service_sale_service_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_sale_service_item
    ADD CONSTRAINT fk_service_sale_id_service_sale_service_item FOREIGN KEY (service_sale_id) REFERENCES service_sale(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale
    ADD CONSTRAINT fk_start_location_id_tour FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_company_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_company_id FOREIGN KEY (company_id) REFERENCES company(id);


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
-- Name: fk_subaccount_account_id; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT fk_subaccount_account_id FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_from_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_subaccount_from_id_transfer FOREIGN KEY (subaccount_from_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_employee_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT fk_subaccount_id_employee_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_outgoing; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_subaccount_id_outgoing FOREIGN KEY (subaccount_id) REFERENCES subaccount(id);


--
-- Name: fk_subaccount_id_person_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT fk_subaccount_id_person_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY suppplier_subaccount
    ADD CONSTRAINT fk_subaccount_id_supplier_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_touroperator_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_subaccount
    ADD CONSTRAINT fk_subaccount_id_touroperator_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_to_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_subaccount_to_id_transfer FOREIGN KEY (subaccount_to_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_bank_detail; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT fk_supplier_id_supplier_bank_detail FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_bperson; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT fk_supplier_id_supplier_bperson FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY suppplier_subaccount
    ADD CONSTRAINT fk_supplier_id_supplier_subaccount FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_task_id_task_resource; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_task_id_task_resource FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_invoice; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_invoice
    ADD CONSTRAINT fk_tour_id_tour_invoice FOREIGN KEY (tour_sale_id) REFERENCES tour_sale(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_person; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_person
    ADD CONSTRAINT fk_tour_id_tour_person FOREIGN KEY (tour_sale_id) REFERENCES tour_sale(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_point; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_point
    ADD CONSTRAINT fk_tour_id_tour_point FOREIGN KEY (tour_sale_id) REFERENCES tour_sale(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_tour_sale_id_tour_sale_service_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY tour_sale_service_item
    ADD CONSTRAINT fk_tour_sale_id_tour_sale_service_item FOREIGN KEY (tour_sale_id) REFERENCES tour_sale(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_touroperator_id_order_item FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_service_item; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY service_item
    ADD CONSTRAINT fk_touroperator_id_service_item FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_touroperator_id_touroperator_commission; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_commission
    ADD CONSTRAINT fk_touroperator_id_touroperator_commission FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_touroperator_licence; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_licence
    ADD CONSTRAINT fk_touroperator_id_touroperator_licence FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_touroperator_id_touroperator_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY touroperator_subaccount
    ADD CONSTRAINT fk_touroperator_id_touroperator_subaccount FOREIGN KEY (touroperator_id) REFERENCES touroperator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_wish_id_lead_wish; Type: FK CONSTRAINT; Schema: public; Owner: mazvv
--

ALTER TABLE ONLY lead_wish
    ADD CONSTRAINT fk_wish_id_lead_wish FOREIGN KEY (wish_id) REFERENCES wish(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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

