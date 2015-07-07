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
-- Name: clone_schema(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION clone_schema(source_schema text, dest_schema text) RETURNS void
    LANGUAGE plpgsql
    AS $$
 
DECLARE
  object text;
  buffer text;
  default_ text;
  column_ text;
BEGIN
  EXECUTE 'CREATE SCHEMA ' || dest_schema ;
 
  -- TODO: Find a way to make this sequence's owner is the correct table.
  FOR object IN
    SELECT sequence_name::text FROM information_schema.SEQUENCES WHERE sequence_schema = source_schema
  LOOP
    EXECUTE 'CREATE SEQUENCE ' || dest_schema || '.' || object;
  END LOOP;
 
  FOR object IN
    SELECT TABLE_NAME::text FROM information_schema.TABLES WHERE table_schema = source_schema
  LOOP
    buffer := dest_schema || '.' || object;
    EXECUTE 'CREATE TABLE ' || buffer || ' (LIKE ' || source_schema || '.' || object || ' INCLUDING CONSTRAINTS INCLUDING INDEXES INCLUDING DEFAULTS)';
 
    FOR column_, default_ IN
      SELECT column_name::text, REPLACE(column_default::text, source_schema, dest_schema) FROM information_schema.COLUMNS WHERE table_schema = dest_schema AND TABLE_NAME = object AND column_default LIKE 'nextval(%' || source_schema || '%::regclass)'
    LOOP
      EXECUTE 'ALTER TABLE ' || buffer || ' ALTER COLUMN ' || column_ || ' SET DEFAULT ' || default_;
    END LOOP;
  END LOOP;
 
END;
 
$$;


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
    photo_upload_id integer
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
    modifydt timestamp with time zone
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
    descr character varying(128),
    settings json,
    status smallint NOT NULL
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
    descr character varying(255),
    status smallint NOT NULL
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
    name character varying(128) NOT NULL,
    parent_id integer,
    type integer NOT NULL,
    status integer NOT NULL,
    descr character varying(128)
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
    position_name character varying(64),
    descr character varying(255),
    status smallint NOT NULL
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
    price numeric(16,2) NOT NULL,
    order_item_id integer
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
-- Name: cashflow; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cashflow (
    id integer NOT NULL,
    subaccount_from_id integer,
    subaccount_to_id integer,
    account_item_id integer,
    sum numeric(16,2) NOT NULL,
    date date NOT NULL,
    vat numeric(16,2)
);


--
-- Name: commission; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE commission (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    service_id integer NOT NULL,
    percentage numeric(5,2) NOT NULL,
    price numeric(16,2) NOT NULL,
    currency_id integer NOT NULL,
    descr character varying(255),
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
    resource_id integer,
    name character varying(32) NOT NULL,
    currency_id integer,
    settings json,
    email character varying(32) NOT NULL
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
-- Name: company_subaccount; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE company_subaccount (
    company_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: contact; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contact (
    id integer NOT NULL,
    contact character varying NOT NULL,
    resource_id integer NOT NULL,
    contact_type integer NOT NULL,
    descr character varying(255),
    status smallint NOT NULL
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
-- Name: contract; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contract (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    date date NOT NULL,
    num character varying NOT NULL,
    descr character varying(255),
    status smallint NOT NULL
);


--
-- Name: contract_commission; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contract_commission (
    contract_id integer NOT NULL,
    commission_id integer NOT NULL
);


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
    cashflow_id integer NOT NULL,
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
    rate numeric(16,2) NOT NULL,
    supplier_id integer NOT NULL
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
    start_dt timestamp with time zone NOT NULL,
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
    notification_id integer NOT NULL,
    status smallint NOT NULL
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
-- Name: employee_upload; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_upload (
    employee_id integer NOT NULL,
    upload_id integer NOT NULL
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
    invoice_id integer NOT NULL,
    account_item_id integer NOT NULL,
    date date NOT NULL,
    sum numeric(16,2) NOT NULL,
    descr character varying(255)
);


--
-- Name: income_cashflow; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE income_cashflow (
    income_id integer NOT NULL,
    cashflow_id integer NOT NULL
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
-- Name: invoice; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invoice (
    id integer NOT NULL,
    date date NOT NULL,
    resource_id integer NOT NULL,
    account_id integer NOT NULL,
    active_until date NOT NULL,
    order_id integer NOT NULL,
    descr character varying(255)
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
-- Name: invoice_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invoice_item (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    vat numeric(16,2) NOT NULL,
    discount numeric(16,2) NOT NULL,
    descr character varying(255),
    order_item_id integer NOT NULL
);


--
-- Name: invoice_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoice_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoice_item_id_seq OWNED BY invoice_item.id;


--
-- Name: lead; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lead (
    id integer NOT NULL,
    lead_date date NOT NULL,
    resource_id integer NOT NULL,
    advsource_id integer NOT NULL,
    customer_id integer NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: lead_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lead_id_seq OWNED BY lead.id;


--
-- Name: lead_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lead_item (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    lead_id integer,
    service_id integer NOT NULL,
    currency_id integer,
    price_from numeric(16,2),
    price_to numeric(16,2),
    descr character varying
);


--
-- Name: lead_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lead_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lead_item_id_seq OWNED BY lead_item.id;


--
-- Name: lead_offer; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lead_offer (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    lead_id integer,
    service_id integer NOT NULL,
    currency_id integer NOT NULL,
    supplier_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    status smallint NOT NULL,
    descr character varying
);


--
-- Name: lead_offer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lead_offer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_offer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lead_offer_id_seq OWNED BY lead_offer.id;


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

ALTER SEQUENCE licence_id_seq OWNED BY contract.id;


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
-- Name: note_upload; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE note_upload (
    note_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: notification; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notification (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    title character varying NOT NULL,
    descr character varying NOT NULL,
    created timestamp with time zone,
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
-- Name: notification_resource; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notification_resource (
    notification_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: order; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "order" (
    id integer NOT NULL,
    deal_date date NOT NULL,
    resource_id integer NOT NULL,
    customer_id integer NOT NULL,
    advsource_id integer NOT NULL,
    descr character varying(255),
    lead_id integer,
    status smallint NOT NULL
);


--
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE order_id_seq OWNED BY "order".id;


--
-- Name: order_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE order_item (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    order_id integer,
    service_id integer NOT NULL,
    currency_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    status smallint NOT NULL,
    status_date date,
    status_info character varying(128),
    supplier_id integer NOT NULL,
    discount_sum numeric(16,2) NOT NULL,
    discount_percent numeric(16,2) NOT NULL
);


--
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE order_item_id_seq OWNED BY order_item.id;


--
-- Name: outgoing; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE outgoing (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    account_item_id integer NOT NULL,
    date date NOT NULL,
    subaccount_id integer NOT NULL,
    sum numeric(16,2) NOT NULL,
    descr character varying(255)
);


--
-- Name: outgoing_cashflow; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE outgoing_cashflow (
    outgoing_id integer NOT NULL,
    cashflow_id integer NOT NULL
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
-- Name: passport; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    subscriber boolean,
    gender integer,
    descr character varying(255)
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
-- Name: person_order_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_order_item (
    order_item_id integer NOT NULL,
    person_id integer NOT NULL
);


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
    display_text character varying(256) NOT NULL,
    resource_type_id integer NOT NULL
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
-- Name: spassport; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE spassport (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    photo_done boolean NOT NULL,
    docs_receive_date date,
    docs_transfer_date date,
    passport_receive_date date,
    descr character varying(255)
);


--
-- Name: spassport_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE spassport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spassport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE spassport_id_seq OWNED BY spassport.id;


--
-- Name: spassport_order_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE spassport_order_item (
    order_item_id integer NOT NULL,
    spassport_id integer NOT NULL
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
    account_id integer NOT NULL,
    name character varying(255) NOT NULL,
    descr character varying(255),
    status smallint NOT NULL
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
    name character varying(32) NOT NULL,
    status smallint NOT NULL,
    descr character varying(255),
    supplier_type_id integer NOT NULL
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
-- Name: supplier_contract; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supplier_contract (
    supplier_id integer NOT NULL,
    contract_id integer NOT NULL
);


--
-- Name: supplier_subaccount; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supplier_subaccount (
    supplier_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: supplier_type; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supplier_type (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    descr character varying(255)
);


--
-- Name: supplier_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE supplier_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE supplier_type_id_seq OWNED BY supplier_type.id;


--
-- Name: task; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE task (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    title character varying(128) NOT NULL,
    deadline timestamp with time zone NOT NULL,
    descr character varying,
    status smallint NOT NULL,
    reminder integer
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
-- Name: task_upload; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE task_upload (
    task_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: ticket; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    start_location_id integer NOT NULL,
    end_location_id integer NOT NULL,
    ticket_class_id integer NOT NULL,
    transport_id integer NOT NULL,
    start_dt timestamp with time zone NOT NULL,
    start_additional_info character varying(128),
    end_dt timestamp with time zone NOT NULL,
    end_additional_info character varying(128),
    adults integer NOT NULL,
    children integer NOT NULL,
    descr character varying(255)
);


--
-- Name: ticket_class; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_class (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: ticket_class_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_class_id_seq OWNED BY ticket_class.id;


--
-- Name: ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_id_seq OWNED BY ticket.id;


--
-- Name: ticket_order_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ticket_order_item (
    order_item_id integer NOT NULL,
    ticket_id integer NOT NULL
);


--
-- Name: tour; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tour (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    start_location_id integer NOT NULL,
    end_location_id integer NOT NULL,
    hotel_id integer,
    accomodation_id integer,
    foodcat_id integer,
    roomcat_id integer,
    adults integer NOT NULL,
    children integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    descr character varying(255),
    end_transport_id integer NOT NULL,
    start_transport_id integer NOT NULL,
    transfer_id integer,
    end_additional_info character varying(128),
    start_additional_info character varying(128)
);


--
-- Name: tour_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tour_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tour_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tour_id_seq1 OWNED BY tour.id;


--
-- Name: tour_order_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tour_order_item (
    order_item_id integer NOT NULL,
    tour_id integer NOT NULL
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

ALTER SEQUENCE touroperator_id_seq OWNED BY supplier.id;


--
-- Name: transfer; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transfer (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
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

ALTER SEQUENCE transfer_id_seq OWNED BY cashflow.id;


--
-- Name: transfer_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transfer_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transfer_id_seq1 OWNED BY transfer.id;


--
-- Name: transport; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transport (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: transport_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transport_id_seq OWNED BY transport.id;


--
-- Name: upload; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE upload (
    id integer NOT NULL,
    path character varying(255) NOT NULL,
    size numeric(16,2) NOT NULL,
    media_type character varying(32) NOT NULL,
    descr character varying(255),
    name character varying(255) NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: upload_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE upload_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: upload_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE upload_id_seq OWNED BY upload.id;


--
-- Name: vat; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    service_id integer NOT NULL,
    date date NOT NULL,
    vat numeric(5,2) NOT NULL,
    calc_method smallint NOT NULL,
    descr character varying(255),
    account_id integer NOT NULL
);


--
-- Name: vat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vat_id_seq OWNED BY vat.id;


--
-- Name: visa; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visa (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    country_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    type smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: visa_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visa_id_seq OWNED BY visa.id;


--
-- Name: visa_order_item; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visa_order_item (
    order_item_id integer NOT NULL,
    visa_id integer NOT NULL
);


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

ALTER TABLE ONLY cashflow ALTER COLUMN id SET DEFAULT nextval('transfer_id_seq'::regclass);


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

ALTER TABLE ONLY contract ALTER COLUMN id SET DEFAULT nextval('licence_id_seq'::regclass);


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

ALTER TABLE ONLY invoice_item ALTER COLUMN id SET DEFAULT nextval('invoice_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead ALTER COLUMN id SET DEFAULT nextval('lead_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_item ALTER COLUMN id SET DEFAULT nextval('lead_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_offer ALTER COLUMN id SET DEFAULT nextval('lead_offer_id_seq'::regclass);


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

ALTER TABLE ONLY "order" ALTER COLUMN id SET DEFAULT nextval('order_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_item ALTER COLUMN id SET DEFAULT nextval('order_item_id_seq'::regclass);


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

ALTER TABLE ONLY spassport ALTER COLUMN id SET DEFAULT nextval('spassport_id_seq'::regclass);


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

ALTER TABLE ONLY supplier ALTER COLUMN id SET DEFAULT nextval('touroperator_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_type ALTER COLUMN id SET DEFAULT nextval('supplier_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY task ALTER COLUMN id SET DEFAULT nextval('task_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket ALTER COLUMN id SET DEFAULT nextval('ticket_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_class ALTER COLUMN id SET DEFAULT nextval('ticket_class_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour ALTER COLUMN id SET DEFAULT nextval('tour_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer ALTER COLUMN id SET DEFAULT nextval('transfer_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transport ALTER COLUMN id SET DEFAULT nextval('transport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY upload ALTER COLUMN id SET DEFAULT nextval('upload_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('_users_rid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vat ALTER COLUMN id SET DEFAULT nextval('vat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visa ALTER COLUMN id SET DEFAULT nextval('visa_id_seq'::regclass);


--
-- Name: _currencies_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_currencies_rid_seq', 57, true);


--
-- Name: _employees_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_employees_rid_seq', 31, true);


--
-- Name: _regions_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_regions_rid_seq', 38, true);


--
-- Name: _resources_logs_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_resources_logs_rid_seq', 7376, true);


--
-- Name: _resources_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_resources_rid_seq', 2549, true);


--
-- Name: _resources_types_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_resources_types_rid_seq', 150, true);


--
-- Name: _users_rid_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('_users_rid_seq', 32, true);


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

SELECT pg_catalog.setval('accomodation_id_seq', 17, true);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO account VALUES (2, 1438, 56, 0, 'Main Bank Account', 'some display text', NULL, 0);
INSERT INTO account VALUES (3, 1439, 56, 1, 'Main Cash Account', 'cash payment', NULL, 0);
INSERT INTO account VALUES (4, 1507, 54, 1, 'Main Cash EUR Account', 'Main Cash EUR Account', NULL, 0);


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('account_id_seq', 4, true);


--
-- Data for Name: account_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO account_item VALUES (3, 1432, 'Taxes', NULL, 0, 0, NULL);
INSERT INTO account_item VALUES (4, 1608, 'Operating charges', NULL, 0, 0, NULL);
INSERT INTO account_item VALUES (5, 1609, 'Internal cash flow', NULL, 0, 0, NULL);
INSERT INTO account_item VALUES (6, 1769, 'Profit distribution', NULL, 0, 0, NULL);
INSERT INTO account_item VALUES (7, 1780, 'Rent', 2, 0, 0, NULL);
INSERT INTO account_item VALUES (8, 1873, 'POF', 2, 0, 0, NULL);
INSERT INTO account_item VALUES (9, 1898, 'Communication', 2, 0, 0, NULL);
INSERT INTO account_item VALUES (10, 2199, 'Marketing, Sales', 2, 0, 0, NULL);
INSERT INTO account_item VALUES (11, 2246, 'Software', 2, 0, 0, 'Sales of any type of tickets');
INSERT INTO account_item VALUES (13, 2277, 'Other operating', 2, 0, 0, NULL);
INSERT INTO account_item VALUES (1, 1426, 'Income Tax', 3, 0, 0, NULL);
INSERT INTO account_item VALUES (14, 2389, 'VAT', 3, 0, 0, NULL);
INSERT INTO account_item VALUES (15, 2390, 'Other taxes, fees', 3, 0, 0, NULL);
INSERT INTO account_item VALUES (17, 2392, 'Return to the buyer', 4, 0, 0, NULL);
INSERT INTO account_item VALUES (18, 2393, 'Payment of the tour operator', 4, 0, 0, NULL);
INSERT INTO account_item VALUES (19, 2394, 'Return the tour operator', 4, 0, 0, NULL);
INSERT INTO account_item VALUES (20, 2395, 'Other operating income', 4, 0, 0, NULL);
INSERT INTO account_item VALUES (21, 2396, 'Other operating expenses', 4, 0, 0, NULL);
INSERT INTO account_item VALUES (22, 2397, 'The money from bank to bank', 5, 0, 0, NULL);
INSERT INTO account_item VALUES (23, 2398, 'The money from the cash to the account', 5, 0, 0, NULL);
INSERT INTO account_item VALUES (24, 2399, 'Money from the account in cash', 5, 0, 0, NULL);
INSERT INTO account_item VALUES (25, 2400, 'Conversion', 5, 0, 0, NULL);
INSERT INTO account_item VALUES (26, 2401, 'Acquisition of fixed assets', 6, 0, 0, NULL);
INSERT INTO account_item VALUES (27, 2402, 'The withdrawal of capital', 6, 0, 0, NULL);
INSERT INTO account_item VALUES (28, 2403, 'Rental fee', 7, 0, 0, NULL);
INSERT INTO account_item VALUES (29, 2404, 'Utility payments', 7, 0, 0, NULL);
INSERT INTO account_item VALUES (30, 2405, 'POF payable', 8, 0, 0, NULL);
INSERT INTO account_item VALUES (31, 2406, 'PIT', 8, 0, 0, NULL);
INSERT INTO account_item VALUES (32, 2407, 'ERUs', 8, 0, 0, NULL);
INSERT INTO account_item VALUES (33, 2408, 'Bonuses (bonus)', 8, 0, 0, NULL);
INSERT INTO account_item VALUES (34, 2409, 'Telephone landline', 9, 0, 0, NULL);
INSERT INTO account_item VALUES (35, 2410, 'Mobile Phones', 9, 0, 0, NULL);
INSERT INTO account_item VALUES (36, 2411, 'Internet', 9, 0, 0, NULL);
INSERT INTO account_item VALUES (37, 2412, 'Other', 9, 0, 0, NULL);
INSERT INTO account_item VALUES (38, 2413, 'Outdoor advertising', 10, 0, 0, NULL);
INSERT INTO account_item VALUES (39, 2414, 'Advertising in print media', 10, 0, 0, NULL);
INSERT INTO account_item VALUES (40, 2415, 'Advertising on TV, radio', 10, 0, 0, NULL);
INSERT INTO account_item VALUES (41, 2416, 'Promotions and presentations', 10, 0, 0, NULL);
INSERT INTO account_item VALUES (42, 2417, 'Exhibitions', 10, 0, 0, NULL);
INSERT INTO account_item VALUES (43, 2418, 'Advertising on the Internet', 10, 0, 0, NULL);
INSERT INTO account_item VALUES (44, 2419, ' Website Promotion', 10, 0, 0, NULL);
INSERT INTO account_item VALUES (45, 2420, 'Mailing lists', 10, 0, 0, NULL);
INSERT INTO account_item VALUES (46, 2421, 'Other marketing', 10, 0, 0, NULL);
INSERT INTO account_item VALUES (47, 2422, 'The costs for the modernization of the local software', 11, 0, 0, NULL);
INSERT INTO account_item VALUES (48, 2423, 'The cost of upgrading the website', 11, 0, 0, NULL);
INSERT INTO account_item VALUES (49, 2424, 'Bank charges', 12, 0, 0, NULL);
INSERT INTO account_item VALUES (50, 2425, 'Other cash and settlement services', 12, 0, 0, NULL);
INSERT INTO account_item VALUES (51, 2426, 'Office supplies, office software', 13, 0, 0, NULL);
INSERT INTO account_item VALUES (52, 2427, 'Representation', 13, 0, 0, NULL);
INSERT INTO account_item VALUES (53, 2428, 'Staff Missions', 13, 0, 0, NULL);
INSERT INTO account_item VALUES (54, 2429, 'Postage, courier services', 13, 0, 0, NULL);
INSERT INTO account_item VALUES (55, 2430, 'Minor repairs of machinery', 13, 0, 0, NULL);
INSERT INTO account_item VALUES (56, 2431, 'Purchase low-value goods', 13, 0, 0, NULL);
INSERT INTO account_item VALUES (57, 2432, 'Other (not included in any of the articles)', 13, 0, 0, NULL);
INSERT INTO account_item VALUES (2, 1431, 'Administrative expensive', NULL, 2, 0, 'Group of items');
INSERT INTO account_item VALUES (12, 2269, 'Cash and Settlement Services', 2, 2, 0, NULL);
INSERT INTO account_item VALUES (16, 2391, 'Payment by the buyer', 4, 1, 0, NULL);


--
-- Name: account_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('account_item_id_seq', 57, true);


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
INSERT INTO address VALUES (32, 2015, 14, '09878', 'Kikvidze 29, 56');
INSERT INTO address VALUES (33, 2119, 14, '02121', 'Bazhana str.3');
INSERT INTO address VALUES (34, 2475, 34, 'fgfgf', 'fgfgfg');


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('address_id_seq', 34, true);


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
INSERT INTO bank_address VALUES (5, 33);


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
INSERT INTO bank_detail VALUES (18, 2120, 57, 4, 'sdghsdgh', 'sghsgh', 'dfghdfhgdfh');
INSERT INTO bank_detail VALUES (19, 2486, 57, 5, 'ghgh', 'ggh', 'hghg');


--
-- Name: bank_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bank_detail_id_seq', 19, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bank_id_seq', 6, true);


--
-- Data for Name: bperson; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO bperson VALUES (1, 1009, 'Alexandro', 'Riak', '', 'Sales Manager', NULL, 0);
INSERT INTO bperson VALUES (6, 1560, 'Ivan', 'Gonchar', '', 'Account Manager', NULL, 0);
INSERT INTO bperson VALUES (5, 1553, 'Sergey', 'Vlasov', '', 'Main account manager', NULL, 0);
INSERT INTO bperson VALUES (7, 1563, 'Alexander', 'Tkachuk', '', 'manager', '', 0);
INSERT INTO bperson VALUES (8, 1578, 'Anna', '', '', 'Manager', '', 0);
INSERT INTO bperson VALUES (2, 1010, 'Umberto', '', '', 'Accounting', '', 1);


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
INSERT INTO bperson_contact VALUES (2, 89);


--
-- Name: bperson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bperson_id_seq', 9, true);


--
-- Data for Name: calculation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO calculation VALUES (33, 2468, 300.00, NULL);
INSERT INTO calculation VALUES (34, 2469, 54462.00, NULL);
INSERT INTO calculation VALUES (37, 2503, 3201.00, NULL);
INSERT INTO calculation VALUES (35, 2470, 300.00, NULL);
INSERT INTO calculation VALUES (41, 2529, 270.00, NULL);
INSERT INTO calculation VALUES (42, 2530, 270.00, NULL);
INSERT INTO calculation VALUES (43, 2531, 54462.75, NULL);
INSERT INTO calculation VALUES (46, 2534, 3201.00, NULL);
INSERT INTO calculation VALUES (47, 2535, 3201.00, NULL);
INSERT INTO calculation VALUES (48, 2537, 2788.50, 40);
INSERT INTO calculation VALUES (49, 2538, 1760.00, NULL);
INSERT INTO calculation VALUES (50, 2541, 1548.80, 39);
INSERT INTO calculation VALUES (44, 2532, 270.00, NULL);
INSERT INTO calculation VALUES (45, 2533, 54462.75, NULL);
INSERT INTO calculation VALUES (51, 2547, 270.00, 43);
INSERT INTO calculation VALUES (52, 2548, 47611.95, 42);


--
-- Name: calculation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('calculation_id_seq', 52, true);


--
-- Data for Name: cashflow; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO cashflow VALUES (216, 19, NULL, 27, 500.00, '2015-06-14', NULL);
INSERT INTO cashflow VALUES (250, NULL, 22, 16, 380.00, '2015-06-14', NULL);
INSERT INTO cashflow VALUES (251, 22, 18, NULL, 272.00, '2015-06-14', 20.65);
INSERT INTO cashflow VALUES (252, NULL, 21, 16, 35500.00, '2015-06-14', NULL);
INSERT INTO cashflow VALUES (253, 21, 19, NULL, 35500.00, '2015-06-14', 2356.80);
INSERT INTO cashflow VALUES (254, NULL, 21, 16, 5000.00, '2015-06-14', NULL);
INSERT INTO cashflow VALUES (255, 21, 19, NULL, 5000.00, '2015-06-14', 2356.80);
INSERT INTO cashflow VALUES (256, NULL, 22, 16, 1400.73, '2015-06-13', 20.65);
INSERT INTO cashflow VALUES (257, 22, 18, NULL, 1292.73, '2015-06-13', NULL);
INSERT INTO cashflow VALUES (258, 23, NULL, 18, 15000.00, '2015-06-14', NULL);
INSERT INTO cashflow VALUES (259, 22, NULL, 17, 108.00, '2015-06-14', NULL);


--
-- Data for Name: commission; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO commission VALUES (36, 2501, 5, 12.00, 0.00, 57, 'Commission for tours');
INSERT INTO commission VALUES (37, 2502, 7, 10.00, 0.00, 57, 'Tickets commission');
INSERT INTO commission VALUES (38, 2505, 5, 12.00, 0.00, 57, '');
INSERT INTO commission VALUES (39, 2507, 7, 10.00, 0.00, 57, 'Tickets commission');
INSERT INTO commission VALUES (40, 2508, 4, 2.00, 10.00, 57, 'Visa service commission');
INSERT INTO commission VALUES (41, 2510, 4, 10.00, 0.00, 57, '');
INSERT INTO commission VALUES (42, 2536, 5, 12.50, 0.00, 57, 'Commission value for tour service');
INSERT INTO commission VALUES (43, 2539, 5, 12.00, 0.00, 57, 'Tour commission');
INSERT INTO commission VALUES (44, 2546, 5, 12.00, 0.00, 57, '');


--
-- Name: commission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('commission_id_seq', 44, true);


--
-- Name: companies_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('companies_positions_id_seq', 8, true);


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO company VALUES (1, 1970, 'LuxTravel, Inc', 56, '{"locale": "en", "timezone": "Europe/Kiev", "tax": "20"}', 'lux.travel@gmai.com');


--
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('company_id_seq', 14, true);


--
-- Data for Name: company_subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO company_subaccount VALUES (1, 18);
INSERT INTO company_subaccount VALUES (1, 19);
INSERT INTO company_subaccount VALUES (1, 20);


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO contact VALUES (27, '+380681983869', 1193, 0, NULL, 0);
INSERT INTO contact VALUES (29, '+380681983869', 1195, 0, NULL, 0);
INSERT INTO contact VALUES (30, '+380681983869', 1201, 0, NULL, 0);
INSERT INTO contact VALUES (32, '+380681983869', 1204, 0, NULL, 0);
INSERT INTO contact VALUES (36, '+380681983869', 1244, 0, NULL, 0);
INSERT INTO contact VALUES (37, '+380681983869', 1257, 0, NULL, 0);
INSERT INTO contact VALUES (39, '+380681983869', 1259, 0, NULL, 0);
INSERT INTO contact VALUES (41, '+380682523645', 1263, 0, NULL, 0);
INSERT INTO contact VALUES (44, '+380675625353', 1282, 0, NULL, 0);
INSERT INTO contact VALUES (45, '+380502355565', 1285, 0, NULL, 0);
INSERT INTO contact VALUES (47, '+380673566789', 1371, 0, NULL, 0);
INSERT INTO contact VALUES (48, '+380502314567', 1373, 0, NULL, 0);
INSERT INTO contact VALUES (51, '+380502232233', 1387, 0, NULL, 0);
INSERT INTO contact VALUES (52, '+380502354235', 1404, 0, NULL, 0);
INSERT INTO contact VALUES (53, '+380503435512', 1464, 0, NULL, 0);
INSERT INTO contact VALUES (54, '+380976543565', 1516, 0, NULL, 0);
INSERT INTO contact VALUES (55, '+380675643623', 1517, 0, NULL, 0);
INSERT INTO contact VALUES (58, '+380681983800', 1543, 0, NULL, 0);
INSERT INTO contact VALUES (61, '+380681234567', 1551, 0, NULL, 0);
INSERT INTO contact VALUES (64, '+380953434358', 1561, 0, NULL, 0);
INSERT INTO contact VALUES (67, '+380672568976', 1581, 0, NULL, 0);
INSERT INTO contact VALUES (68, '+380672346534', 1591, 0, NULL, 0);
INSERT INTO contact VALUES (69, '+380500567765', 1610, 0, NULL, 0);
INSERT INTO contact VALUES (71, '+380503435436', 1620, 0, NULL, 0);
INSERT INTO contact VALUES (73, '+380975642876', 1624, 0, NULL, 0);
INSERT INTO contact VALUES (74, '+380665638900', 1640, 0, NULL, 0);
INSERT INTO contact VALUES (76, '+380502235686', 1650, 0, NULL, 0);
INSERT INTO contact VALUES (77, '+380674523123', 1927, 0, NULL, 0);
INSERT INTO contact VALUES (79, '+380923435643', 2013, 0, NULL, 0);
INSERT INTO contact VALUES (80, '+380505674534', 2018, 0, NULL, 0);
INSERT INTO contact VALUES (81, '+380671238943', 2050, 0, NULL, 0);
INSERT INTO contact VALUES (28, 'asdasd@mail.com', 1194, 1, NULL, 0);
INSERT INTO contact VALUES (35, 'vitalii.mazur@gmail.com', 1243, 1, NULL, 0);
INSERT INTO contact VALUES (38, 'vitalii.mazur@gmail.com', 1258, 1, NULL, 0);
INSERT INTO contact VALUES (40, 'vitalii.mazur@gmail.com', 1260, 1, NULL, 0);
INSERT INTO contact VALUES (42, 'a.koff@gmail.com', 1264, 1, NULL, 0);
INSERT INTO contact VALUES (46, 'n.voevoda@gmail.com', 1304, 1, NULL, 0);
INSERT INTO contact VALUES (57, 'ravak@myemail.com', 1519, 1, NULL, 0);
INSERT INTO contact VALUES (60, 'info@travelcrm.org.ua', 1545, 1, NULL, 0);
INSERT INTO contact VALUES (63, 'i_gonchar@i-tele.com', 1559, 1, NULL, 0);
INSERT INTO contact VALUES (65, 'mega_tkach@ukr.net', 1562, 1, NULL, 0);
INSERT INTO contact VALUES (70, 'artyuh87@gmail.com', 1611, 1, NULL, 0);
INSERT INTO contact VALUES (72, 'grach18@ukr.net', 1621, 1, NULL, 0);
INSERT INTO contact VALUES (75, 'karpuha1990@ukr.net', 1641, 1, NULL, 0);
INSERT INTO contact VALUES (78, 'vitalii.mazur@gmail.com', 1956, 1, NULL, 0);
INSERT INTO contact VALUES (49, 'travelcrm', 1379, 2, NULL, 0);
INSERT INTO contact VALUES (56, 'ravak_skype', 1518, 2, NULL, 0);
INSERT INTO contact VALUES (59, 'dorianyats', 1544, 2, NULL, 0);
INSERT INTO contact VALUES (62, 'serge_vlasov', 1552, 2, NULL, 0);
INSERT INTO contact VALUES (50, '+380682345688', 1380, 0, NULL, 0);
INSERT INTO contact VALUES (82, '+380676775643', 2089, 0, NULL, 0);
INSERT INTO contact VALUES (83, 'nikolay1987@mail.ru', 2095, 1, NULL, 0);
INSERT INTO contact VALUES (66, 'AnnaNews', 1577, 2, '', 1);
INSERT INTO contact VALUES (84, '+380672334345', 2307, 0, '', 0);
INSERT INTO contact VALUES (85, '+380503435676', 2308, 0, '', 1);
INSERT INTO contact VALUES (86, '+380674252212', 2327, 0, '', 0);
INSERT INTO contact VALUES (87, '+380678521452', 2338, 0, '', 0);
INSERT INTO contact VALUES (88, '+380502356543', 2366, 0, '', 0);
INSERT INTO contact VALUES (89, 'mazira@online.ua', 2493, 1, '', 0);


--
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('contact_id_seq', 89, true);


--
-- Data for Name: contract; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO contract VALUES (48, 2210, '2015-05-09', '1234/56', 'Test contract', 0);
INSERT INTO contract VALUES (49, 2213, '2015-05-09', '12345/67', 'Test agent contract for supplier', 0);
INSERT INTO contract VALUES (50, 2215, '2014-01-10', '12/34', 'First contract', 1);
INSERT INTO contract VALUES (51, 2489, '2015-06-23', '19/06', '', 0);
INSERT INTO contract VALUES (52, 2490, '2015-06-23', '19/06', '', 0);
INSERT INTO contract VALUES (54, 2506, '2015-06-01', '36542-89.77', '', 0);
INSERT INTO contract VALUES (55, 2511, '2015-06-01', '678/90', '', 0);
INSERT INTO contract VALUES (53, 2491, '2015-06-01', '19/06/15', '', 0);
INSERT INTO contract VALUES (56, 2540, '2015-05-01', '0987-97', 'Contract with teztour', 0);
INSERT INTO contract VALUES (57, 2545, '2015-06-01', 'TUI-09-15', '', 0);


--
-- Data for Name: contract_commission; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO contract_commission VALUES (52, 36);
INSERT INTO contract_commission VALUES (52, 37);
INSERT INTO contract_commission VALUES (54, 38);
INSERT INTO contract_commission VALUES (54, 39);
INSERT INTO contract_commission VALUES (54, 40);
INSERT INTO contract_commission VALUES (55, 41);
INSERT INTO contract_commission VALUES (53, 42);
INSERT INTO contract_commission VALUES (56, 43);
INSERT INTO contract_commission VALUES (57, 44);


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
INSERT INTO country VALUES (21, 2270, 'PL', 'Poland');


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('country_id_seq', 21, true);


--
-- Data for Name: crosspayment; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO crosspayment VALUES (10, 2465, 216, 'The capital withdraw by CEO');


--
-- Name: crosspayment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('crosspayment_id_seq', 10, true);


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

INSERT INTO currency_rate VALUES (19, 2281, '2015-05-15', 57, 23.00, 87);
INSERT INTO currency_rate VALUES (20, 2289, '2015-05-17', 57, 22.70, 102);
INSERT INTO currency_rate VALUES (21, 2290, '2015-04-29', 57, 23.05, 102);
INSERT INTO currency_rate VALUES (22, 2319, '2015-06-01', 54, 24.20, 87);
INSERT INTO currency_rate VALUES (23, 2334, '2015-06-02', 57, 21.50, 93);
INSERT INTO currency_rate VALUES (24, 2335, '2015-06-02', 54, 23.65, 93);
INSERT INTO currency_rate VALUES (25, 2336, '2015-06-02', 57, 21.66, 100);
INSERT INTO currency_rate VALUES (26, 2337, '2015-06-02', 54, 23.70, 100);
INSERT INTO currency_rate VALUES (27, 2383, '2015-06-06', 54, 24.30, 102);
INSERT INTO currency_rate VALUES (28, 2384, '2015-06-06', 54, 24.25, 92);
INSERT INTO currency_rate VALUES (29, 2385, '2015-06-06', 57, 21.50, 92);


--
-- Name: currency_rate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('currency_rate_id_seq', 29, true);


--
-- Data for Name: email_campaign; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO email_campaign VALUES (1, 1955, 'Egypt HOT!!!', 'Hello.<p>Look at this</p>', '      <meta content="text/html; charset=utf-8" http-equiv="Content-Type">    <title>      Boutique    </title><style type="text/css">a:hover { text-decoration: none !important; }.header h1 {color: #ede6cb !important; font: normal 24px Georgia, serif; margin: 0; padding: 0; line-height: 28px;}.header p {color: #645847; font: bold 11px Georgia, serif; margin: 0; padding: 0; line-height: 12px; text-transform: uppercase;}.content h2 {color:#393023 !important; font-weight: bold; margin: 0; padding: 0; line-height: 30px; font-size: 17px;font-family: Helvetica, Arial, sans-serif; }.content p {color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px; font-family: Helvetica, Arial, sans-serif;}.content a {color: #0fa2e6; text-decoration: none;}.footer p {font-size: 11px; color:#bfbfbf; margin: 0; padding: 0;font-family: Helvetica, Arial, sans-serif;}.footer a {color: #0fa2e6; text-decoration: none;}</style>      <table cellpadding="0" cellspacing="0" border="0" align="center" width="100%" style="background: url(''images/bg_email.jpg'') no-repeat center top; padding: 85px 0 35px">  <tbody><tr>  <td align="center">    <table cellpadding="0" cellspacing="0" border="0" align="center" width="599" style="font-family: Georgia, serif; background: url(''images/bg_header.jpg'') no-repeat center top" height="142">      <tbody><tr>        <td style="margin: 0; padding: 40px 0 0; background: #c89c22 url(''images/bg_header.jpg'') no-repeat center top" align="center" valign="top"><h1 style="color: #ede6cb !important; font: normal 24px Georgia, serif; margin: 0; padding: 0; line-height: 28px;">Grandma''s Sweets &amp; Cookies</h1>    </td>      </tr>  <tr>        <td style="margin: 0; padding: 25px 0 0;" align="center" valign="top"><p style="color: #645847; font: bold 11px Georgia, serif; margin: 0; padding: 0; line-height: 12px; text-transform: uppercase;">ESTABLISHED 1405</p>        </td>      </tr>  <tr>  <td style="font-size: 1px; height: 15px; line-height: 1px;" height="15">&nbsp;</td>  </tr></tbody></table><!-- header--><table cellpadding="0" cellspacing="0" border="0" align="center" width="599" style="font-family: Georgia, serif;">      <tbody><tr>        <td width="599" valign="top" align="left" bgcolor="#ffffff" style="font-family: Georgia, serif; background: #fff; border-top: 5px solid #e5bd5f"><table cellpadding="0" cellspacing="0" border="0" style="color: #717171; font: normal 11px Georgia, serif; margin: 0; padding: 0;" width="599"><tbody><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 15px 0 5px; font-family: Georgia, serif;" valign="top" align="center" width="569"><img src="images/divider_top_full.png" alt="divider"><br></td><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><h2 style="color:#393023 !important; font-weight: bold; margin: 0; padding: 0; line-height: 30px; font-size: 17px;font-family: Helvetica, Arial, sans-serif;">Meet Jack — a brown cow.</h2><p style="color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px;">Suspendisse potenti--Fusce eu ante in sapien vestibulum sagittis. Cras purus. Nunc rhoncus. <a href="#" style="color: #0fa2e6; text-decoration: none;">Donec imperdiet</a>, nibh sit amet pharetra placerat, tortor purus condimentum lectus.</p></td><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><img src="images/img.jpg" alt="Cow" style="border: 5px solid #f7f7f4;"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><p style="color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px;">Suspendisse potenti--Fusce eu <a href="#" style="color: #0fa2e6; text-decoration: none;">ante in sapien</a> vestibulum sagittis.</p></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 0; font-family: Helvetica, Arial, sans-serif;" align="left"><img src="images/divider_full.png" alt="divider"></td><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td></tr><tr><td width="15" style="font-size: 1px; line-height: 1px; width: 15px;"><img src="images/spacer.gif" alt="space" width="15"></td><td style="padding: 10px 0 55px; font-family: Helvetica, Arial, sans-serif;" align="left"><h2 style="color:#393023 !important; font-weight: bold; margin: 0; padding: 0; line-height: 30px; font-size: 17px;font-family: Helvetica, Arial, sans-serif;">Cookies feels more valuable now than before</h2><p style="color:#767676; font-weight: normal; margin: 0; padding: 0; line-height: 20px; font-size: 12px;">Suspendisse potenti--Fusce eu ante in sapien vestibulum sagittis. Cras purus. Nunc rhoncus. Donec imperdiet, nibh sit amet pharetra placerat, tortor purus condimentum lectus. Says Doctor Lichtenstein in an interview done after last nights press conference in Belgium.<a href="#" style="color: #0fa2e6; text-decoration: none;">Dr. Lichtenstein</a> also states his concerns regarding chocolate now suddenly turning yellow the last couple of years. </p></td></tr>  </tbody></table></td>      </tr> <tr>  <td style="font-size: 1px; height: 10px; line-height: 1px;" height="10"><img src="images/spacer.gif" alt="space" width="15"></td>  </tr></tbody></table><!-- body --><table cellpadding="0" cellspacing="0" border="0" align="center" width="599" style="font-family: Georgia, serif; line-height: 10px;" bgcolor="#464646" class="footer">      <tbody><tr>        <td bgcolor="#464646" align="center" style="padding: 15px 0 10px; font-size: 11px; color:#bfbfbf; margin: 0; line-height: 1.2;font-family: Helvetica, Arial, sans-serif;" valign="top"><p style="font-size: 11px; color:#bfbfbf; margin: 0; padding: 0;font-family: Helvetica, Arial, sans-serif;">You''re receiving this newsletter because you bought widgets from us. </p><p style="font-size: 11px; color:#bfbfbf; margin: 0 0 10px 0; padding: 0;font-family: Helvetica, Arial, sans-serif;">Having trouble reading this? <webversion style="color: #0fa2e6; text-decoration: none;">View it in your browser</webversion>. Not interested anymore? <unsubscribe style="color: #0fa2e6; text-decoration: none;">Unsubscribe</unsubscribe> Instantly.</p></td>      </tr>  </tbody></table><!-- footer-->  </td></tr>    </tbody></table>  ', '2014-12-28 19:18:00+02', 'Hot New Year in Egypt');


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
INSERT INTO employee VALUES (14, 1045, 'Dima', 'Shkreba', NULL, NULL, '2013-04-30', NULL);
INSERT INTO employee VALUES (15, 1046, 'Viktoriia', 'Lastovets', NULL, NULL, '2014-04-29', NULL);
INSERT INTO employee VALUES (12, 1043, 'Denis', 'Yurin', NULL, '12', '2014-04-01', NULL);
INSERT INTO employee VALUES (7, 885, 'Irina', 'Mazur', 'V.', NULL, NULL, NULL);
INSERT INTO employee VALUES (30, 2053, 'Igor', 'Mazur', NULL, NULL, NULL, NULL);
INSERT INTO employee VALUES (31, 2477, 'Alina', 'Kabaeva', NULL, '344', '2015-06-23', NULL);
INSERT INTO employee VALUES (2, 784, 'John', 'Doe', NULL, NULL, NULL, 7);


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

INSERT INTO employee_notification VALUES (2, 18, 1);
INSERT INTO employee_notification VALUES (2, 20, 1);
INSERT INTO employee_notification VALUES (2, 19, 1);
INSERT INTO employee_notification VALUES (2, 21, 0);
INSERT INTO employee_notification VALUES (2, 22, 0);
INSERT INTO employee_notification VALUES (2, 23, 0);
INSERT INTO employee_notification VALUES (2, 24, 0);


--
-- Data for Name: employee_passport; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO employee_passport VALUES (13, 7);


--
-- Data for Name: employee_subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO employee_subaccount VALUES (2, 1);


--
-- Data for Name: employee_upload; Type: TABLE DATA; Schema: public; Owner: -
--



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

SELECT pg_catalog.setval('foodcat_id_seq', 17, true);


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
INSERT INTO hotel VALUES (38, 2111, 5, 'Spirit of the Knights Boutique', 36);
INSERT INTO hotel VALUES (39, 2375, 5, 'Radisson Blu Resort & Spa', 39);


--
-- Name: hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hotel_id_seq', 39, true);


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

INSERT INTO income VALUES (65, 2457, 31, 16, '2015-06-14', 380.00, NULL);
INSERT INTO income VALUES (66, 2458, 30, 16, '2015-06-14', 35500.00, NULL);
INSERT INTO income VALUES (67, 2459, 30, 16, '2015-06-14', 5000.00, NULL);
INSERT INTO income VALUES (60, 2451, 31, 16, '2015-06-13', 1400.73, NULL);


--
-- Data for Name: income_cashflow; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO income_cashflow VALUES (65, 250);
INSERT INTO income_cashflow VALUES (65, 251);
INSERT INTO income_cashflow VALUES (66, 252);
INSERT INTO income_cashflow VALUES (66, 253);
INSERT INTO income_cashflow VALUES (67, 254);
INSERT INTO income_cashflow VALUES (67, 255);
INSERT INTO income_cashflow VALUES (60, 256);
INSERT INTO income_cashflow VALUES (60, 257);


--
-- Name: income_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('income_id_seq', 67, true);


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO invoice VALUES (31, '2015-06-13', 2450, 4, '2015-06-16', 7, NULL);
INSERT INTO invoice VALUES (30, '2015-06-06', 2388, 3, '2015-06-09', 9, NULL);


--
-- Name: invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('invoice_id_seq', 31, true);


--
-- Data for Name: invoice_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO invoice_item VALUES (31, 31, 1672.73, 20.65, 0.00, 'Tour booking service', 39);
INSERT INTO invoice_item VALUES (29, 30, 7290.00, 1215.00, 0.00, 'The issues for visas', 43);
INSERT INTO invoice_item VALUES (30, 30, 57090.00, 1141.80, 2627.25, 'Tour booking service', 42);


--
-- Name: invoice_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('invoice_item_id_seq', 31, true);


--
-- Data for Name: lead; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO lead VALUES (2, '2015-02-04', 2088, 5, 46, 1, 'Test lead description');
INSERT INTO lead VALUES (1, '2015-02-04', 2052, 6, 47, 2, 'Cant to offer any proposition for customer');
INSERT INTO lead VALUES (3, '2015-05-24', 2312, 4, 48, 1, NULL);
INSERT INTO lead VALUES (4, '2015-06-02', 2333, 2, 50, 0, NULL);
INSERT INTO lead VALUES (5, '2015-06-06', 2372, 6, 53, 1, NULL);
INSERT INTO lead VALUES (6, '2015-06-10', 2434, 6, 53, 3, NULL);


--
-- Name: lead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lead_id_seq', 6, true);


--
-- Data for Name: lead_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO lead_item VALUES (1, 2293, NULL, 5, 57, NULL, 3001.00, 'Tour in Turkey for 2 adult persons and one children for 7 days in 5*');
INSERT INTO lead_item VALUES (2, 2294, NULL, 4, 57, NULL, 70.00, 'A visa for Schengen for one person');
INSERT INTO lead_item VALUES (3, 2295, NULL, 5, 57, NULL, 3000.00, 'Turkey, 5*, 2 persons adult');
INSERT INTO lead_item VALUES (4, 2297, NULL, 5, 57, NULL, 2500.00, 'Turkey, 10 days, 2 persons, 5*');
INSERT INTO lead_item VALUES (5, 2300, 2, 5, 57, NULL, 2500.00, 'Turkey, 5*, 2 persons, the middle of Jule, 10 days');
INSERT INTO lead_item VALUES (6, 2305, 1, 4, NULL, NULL, NULL, 'Schengen');
INSERT INTO lead_item VALUES (7, 2310, 3, 5, 57, NULL, 1600.00, 'For 2 persons into Egypt or Turkey, exelent 4* or 5* with AI, 7 days, in the middle of JUNE');
INSERT INTO lead_item VALUES (8, 2313, 3, 1, NULL, NULL, NULL, 'Need a foreign passport for two persons very QUICK!');
INSERT INTO lead_item VALUES (9, 2329, 4, 5, 57, 2500.00, 3500.00, 'Turkey, 5* AI, 2 adults and child, Kemer prefered');
INSERT INTO lead_item VALUES (10, 2330, 4, 4, 54, NULL, 70.00, 'EU visa for 2 persons');
INSERT INTO lead_item VALUES (11, 2368, 5, 5, 57, 2000.00, 3000.00, 'Croatia for 2 persons, 5* on June or July beginings');
INSERT INTO lead_item VALUES (12, 2433, 6, 5, NULL, NULL, NULL, 'Turkey or Egypt on the end of July, 5* with UAI for 3 persons');


--
-- Name: lead_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lead_item_id_seq', 12, true);


--
-- Data for Name: lead_offer; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO lead_offer VALUES (2, 2299, NULL, 5, 57, 87, 2450.00, 0, NULL);
INSERT INTO lead_offer VALUES (3, 2301, 2, 5, 57, 87, 2250.00, 0, 'Turkey, 5*, UAI, Kemer, 2 persons, 10 - 20 of Jule');
INSERT INTO lead_offer VALUES (4, 2306, 1, 4, 57, 90, 100.00, 2, 'This price only');
INSERT INTO lead_offer VALUES (5, 2331, 4, 5, 57, 93, 3300.00, 1, 'Turkey Kemer, 5* UAI for 2 persons and child');
INSERT INTO lead_offer VALUES (6, 2332, 4, 4, 54, 100, 65.00, 1, 'for 2 person single visa');
INSERT INTO lead_offer VALUES (7, 2369, 5, 5, 56, 92, 57090.00, 1, 'Radisson Blu Resort & Spa Dubrovnik Sun Gardens 5*, Croatia, Orashac, for 2 persons');
INSERT INTO lead_offer VALUES (9, 2437, 6, 5, 57, 99, 1400.00, 1, 'Egypt, Sharm El Sheih, 5 UAI, 10 days for 2 adult persons and 1 child');
INSERT INTO lead_offer VALUES (8, 2435, 6, 5, 57, 100, 1800.00, 2, 'Turkey Kemer for 7 days with AI for 2 adults and single child. Hotel is uknown this is hot tour with caurosel.

This offer was not approved by customer, its too expensive');


--
-- Name: lead_offer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lead_offer_id_seq', 9, true);


--
-- Name: licence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('licence_id_seq', 57, true);


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
INSERT INTO location VALUES (39, 2374, 'Orashac', 38);


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('location_id_seq', 39, true);


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO navigation VALUES (41, 5, NULL, 'Home', '/', 'fa fa-home', 1, 1079, false, NULL);
INSERT INTO navigation VALUES (47, 5, NULL, 'For Test', '/', 'fa fa-credit-card', 2, 1253, false, NULL);
INSERT INTO navigation VALUES (48, 6, NULL, 'Home', '/', 'fa fa-home', 1, 1079, false, NULL);
INSERT INTO navigation VALUES (49, 6, NULL, 'For Test', '/', 'fa fa-credit-card', 2, 1253, false, NULL);
INSERT INTO navigation VALUES (53, 4, NULL, 'Finance', '/', 'fa fa-credit-card', 7, 1394, false, NULL);
INSERT INTO navigation VALUES (156, 4, 53, 'Billing', '/', NULL, 10, 1905, false, NULL);
INSERT INTO navigation VALUES (107, 4, NULL, 'Home', '/', 'fa fa-home', 1, 1777, false, NULL);
INSERT INTO navigation VALUES (32, 4, NULL, 'Sales', '/', 'fa fa-legal', 2, 998, false, NULL);
INSERT INTO navigation VALUES (21, 4, NULL, 'Clientage', '/', 'fa fa-briefcase', 3, 864, false, NULL);
INSERT INTO navigation VALUES (26, 4, NULL, 'Marketing', '/', 'fa fa-bullhorn', 4, 900, false, NULL);
INSERT INTO navigation VALUES (10, 4, NULL, 'HR', '/', 'fa fa-group', 5, 780, false, NULL);
INSERT INTO navigation VALUES (18, 4, NULL, 'Company', '/', 'fa fa-building-o', 6, 837, false, NULL);
INSERT INTO navigation VALUES (23, 4, NULL, 'Directories', '/', 'fa fa-book', 8, 873, false, NULL);
INSERT INTO navigation VALUES (152, 4, NULL, 'Reports', '/', 'fa fa-pie-chart', 9, 1895, false, NULL);
INSERT INTO navigation VALUES (155, 4, 53, 'Payments', '/', NULL, 12, 1904, false, NULL);
INSERT INTO navigation VALUES (158, 4, 23, 'Geography', '/', NULL, 13, 1907, false, NULL);
INSERT INTO navigation VALUES (157, 4, 53, 'Currencies', '', NULL, 7, 1906, true, NULL);
INSERT INTO navigation VALUES (159, 4, 23, 'Hotels', '/', NULL, 12, 1908, true, NULL);
INSERT INTO navigation VALUES (42, 4, 159, 'Hotels List', '/hotels', NULL, 5, 1080, false, NULL);
INSERT INTO navigation VALUES (43, 4, 158, 'Locations', '/locations', NULL, 3, 1089, false, NULL);
INSERT INTO navigation VALUES (50, 4, 53, 'Services List', '/services', NULL, 6, 1312, false, NULL);
INSERT INTO navigation VALUES (45, 4, 53, 'Banks', '/banks', NULL, 6, 1212, false, 'tab_open');
INSERT INTO navigation VALUES (153, 4, 152, 'Turnovers', '/turnovers', NULL, 2, 1896, false, 'tab_open');
INSERT INTO navigation VALUES (51, 4, 32, 'Invoices', '/invoices', NULL, 5, 1368, true, 'tab_open');
INSERT INTO navigation VALUES (9, 4, 8, 'Resource Types', '/resources_types', NULL, 1, 779, false, NULL);
INSERT INTO navigation VALUES (13, 4, 10, 'Employees', '/employees', NULL, 1, 790, false, NULL);
INSERT INTO navigation VALUES (8, 4, NULL, 'System', '/', 'fa fa-cog', 11, 778, false, 'tab_open');
INSERT INTO navigation VALUES (54, 4, 157, 'Currencies Rates', '/currencies_rates', NULL, 8, 1395, false, NULL);
INSERT INTO navigation VALUES (55, 4, 156, 'Accounts Items', '/accounts_items', NULL, 3, 1425, false, NULL);
INSERT INTO navigation VALUES (56, 4, 155, 'Income Payments', '/incomes', NULL, 9, 1434, false, NULL);
INSERT INTO navigation VALUES (57, 4, 156, 'Accounts', '/accounts', NULL, 1, 1436, false, NULL);
INSERT INTO navigation VALUES (14, 4, 10, 'Employees Appointments', '/appointments', NULL, 2, 791, false, NULL);
INSERT INTO navigation VALUES (174, 4, 156, 'Vat Settings', '/vats', NULL, 5, 2514, true, 'tab_open');
INSERT INTO navigation VALUES (60, 4, 23, 'Suppliers', '/suppliers', NULL, 5, 1550, false, 'tab_open');
INSERT INTO navigation VALUES (15, 4, 8, 'Users', '/users', NULL, 3, 792, false, NULL);
INSERT INTO navigation VALUES (17, 4, 157, 'Currencies List', '/currencies', NULL, 7, 802, false, NULL);
INSERT INTO navigation VALUES (19, 4, 18, 'Structures', '/structures', NULL, 1, 838, false, NULL);
INSERT INTO navigation VALUES (20, 4, 18, 'Positions', '/positions', NULL, 2, 863, false, NULL);
INSERT INTO navigation VALUES (22, 4, 21, 'Persons', '/persons', NULL, 1, 866, false, NULL);
INSERT INTO navigation VALUES (24, 4, 158, 'Countries', '/countries', NULL, 4, 874, false, NULL);
INSERT INTO navigation VALUES (25, 4, 158, 'Regions', '/regions', NULL, 3, 879, false, NULL);
INSERT INTO navigation VALUES (27, 4, 26, 'Advertising Sources', '/advsources', NULL, 1, 902, false, NULL);
INSERT INTO navigation VALUES (28, 4, 159, 'Hotels Categories', '/hotelcats', NULL, 6, 910, false, NULL);
INSERT INTO navigation VALUES (29, 4, 159, 'Rooms Categories', '/roomcats', NULL, 7, 911, false, NULL);
INSERT INTO navigation VALUES (30, 4, 159, 'Accomodations', '/accomodations', NULL, 10, 955, false, 'tab_open');
INSERT INTO navigation VALUES (31, 4, 159, 'Food Categories', '/foodcats', NULL, 9, 956, false, NULL);
INSERT INTO navigation VALUES (36, 4, 23, 'Business Persons', '/bpersons', NULL, 8, 1008, false, 'tab_open');
INSERT INTO navigation VALUES (61, 4, 155, 'Outgoing Payments', '/outgoings', NULL, 10, 1571, false, NULL);
INSERT INTO navigation VALUES (150, 4, 156, 'Subaccounts', '/subaccounts', NULL, 2, 1798, false, NULL);
INSERT INTO navigation VALUES (151, 4, 155, 'Cross Payments', '/crosspayments', NULL, 11, 1885, false, NULL);
INSERT INTO navigation VALUES (163, 4, 26, 'Email Campaigns', '/emails_campaigns', NULL, 2, 1953, true, NULL);
INSERT INTO navigation VALUES (165, 4, 8, 'Company', '/companies/edit', NULL, 4, 1975, true, 'dialog_open');
INSERT INTO navigation VALUES (166, 4, 32, 'Leads', '/leads', NULL, 2, 2048, false, 'tab_open');
INSERT INTO navigation VALUES (168, 4, 32, 'Orders', '/orders', NULL, 4, 2101, false, 'tab_open');
INSERT INTO navigation VALUES (169, 4, 23, 'Transfers', '/transfers', NULL, 9, 2128, true, 'tab_open');
INSERT INTO navigation VALUES (170, 4, 23, 'Transport', '/transports', NULL, 10, 2136, false, 'tab_open');
INSERT INTO navigation VALUES (171, 4, 23, 'Suppliers Types', '/suppliers_types', NULL, 7, 2219, false, 'tab_open');
INSERT INTO navigation VALUES (172, 4, 23, 'Contracts', '/contracts', NULL, 6, 2222, false, 'tab_open');
INSERT INTO navigation VALUES (173, 4, 23, 'Ticket Class', '/tickets_classes', NULL, 11, 2245, false, 'tab_open');


--
-- Data for Name: note; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO note VALUES (1, 1800, 'Для тестирования', NULL);
INSERT INTO note VALUES (2, 1801, 'For testing purpose', NULL);
INSERT INTO note VALUES (3, 1802, 'This resource type is under qustion', '<b>Seems we need new schema for accounting.</b>');
INSERT INTO note VALUES (4, 1803, 'I had asked questions for expert in accounting', 'Alexander said that the most appopriate schema is to use accounts for each object such as persons, touroperators and so on');
INSERT INTO note VALUES (5, 1804, 'Need to ask questions to expert', NULL);
INSERT INTO note VALUES (18, 1833, 'Main Developer of TravelCRM', 'The main developer of TravelCRM');
INSERT INTO note VALUES (24, 1872, 'For users', 'This subaccount is for Person Garkaviy Andrew');
INSERT INTO note VALUES (25, 1924, 'Passport detalized', 'There is no information about passport');
INSERT INTO note VALUES (26, 1931, 'Resource Task', 'This is for resource only');
INSERT INTO note VALUES (27, 1979, 'Test Note', 'Description to test note');
INSERT INTO note VALUES (28, 1981, 'VIP User', 'This user is for VIP');
INSERT INTO note VALUES (29, 2012, 'Good Hotel', 'Edit description for Hotels note');
INSERT INTO note VALUES (30, 2065, 'Note without source resource', 'This note was created directly from Tools Panel');
INSERT INTO note VALUES (31, 2087, 'Good customer', 'Good customer in any case');
INSERT INTO note VALUES (32, 2092, 'Failure', 'Customer failure from offers');
INSERT INTO note VALUES (33, 2096, 'For test purpose only', NULL);
INSERT INTO note VALUES (34, 2097, 'Failure 2', NULL);
INSERT INTO note VALUES (35, 2098, 'New property SERVICE_TYPE', 'Add new property for services - SERVICE_TYPE. There is 2 types - common and tour.');
INSERT INTO note VALUES (36, 2132, 'New note for Lastovec', 'Test Note for User');
INSERT INTO note VALUES (42, 2302, 'Cant call', NULL);
INSERT INTO note VALUES (43, 2370, 'Very promissed', 'Very promised client, redy to make business');


--
-- Name: note_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('note_id_seq', 58, true);


--
-- Data for Name: note_resource; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO note_resource VALUES (3, 1797);
INSERT INTO note_resource VALUES (5, 1797);
INSERT INTO note_resource VALUES (24, 1868);
INSERT INTO note_resource VALUES (28, 3);
INSERT INTO note_resource VALUES (29, 1470);
INSERT INTO note_resource VALUES (27, 1980);
INSERT INTO note_resource VALUES (33, 970);
INSERT INTO note_resource VALUES (36, 2126);
INSERT INTO note_resource VALUES (42, 2075);
INSERT INTO note_resource VALUES (31, 2088);
INSERT INTO note_resource VALUES (32, 2052);
INSERT INTO note_resource VALUES (34, 2052);
INSERT INTO note_resource VALUES (43, 2372);
INSERT INTO note_resource VALUES (35, 1413);
INSERT INTO note_resource VALUES (18, 784);
INSERT INTO note_resource VALUES (26, 1930);


--
-- Data for Name: note_upload; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO notification VALUES (3, 1945, 'A reminder of the task #42', 'Do not forget about task!', '2014-12-14 19:51:00.013635+02', NULL);
INSERT INTO notification VALUES (4, 1946, 'A reminder of the task #42', 'Do not forget about task!', '2014-12-14 20:31:00.012771+02', NULL);
INSERT INTO notification VALUES (5, 1947, 'A reminder of the task #40', 'Do not forget about task!', '2014-12-14 20:32:00.061386+02', NULL);
INSERT INTO notification VALUES (6, 1948, 'A reminder of the task #42', 'Do not forget about task!', '2014-12-14 20:34:00.011181+02', NULL);
INSERT INTO notification VALUES (7, 1949, 'A reminder of the task #42', 'Do not forget about task!', '2014-12-14 20:35:00.011903+02', NULL);
INSERT INTO notification VALUES (8, 1950, 'A reminder of the task #42', 'Do not forget about task!', '2014-12-14 20:38:00.01699+02', NULL);
INSERT INTO notification VALUES (9, 1959, 'A reminder of the task #44', 'Do not forget about task!', '2014-12-21 19:21:00.016784+02', NULL);
INSERT INTO notification VALUES (10, 1961, 'Task: #44', 'Test new scheduler realization', '2014-12-21 19:44:00.016315+02', NULL);
INSERT INTO notification VALUES (11, 1963, 'Task: Test', 'Test', '2014-12-24 21:33:00.014126+02', NULL);
INSERT INTO notification VALUES (12, 1965, 'Task: For testing', 'For testing', '2014-12-25 21:06:00.013657+02', NULL);
INSERT INTO notification VALUES (13, 1972, 'Task: Check Payments', 'Check Payments', '2015-01-04 12:46:00.019127+02', NULL);
INSERT INTO notification VALUES (14, 1973, 'Task: Check Payments', 'Check Payments', '2015-01-04 14:06:00.016859+02', NULL);
INSERT INTO notification VALUES (15, 1984, 'Task: Test', 'Test', '2015-01-13 17:01:00.018967+02', NULL);
INSERT INTO notification VALUES (16, 1986, 'Task: Test 2', 'Test 2', '2015-01-13 17:04:00.011637+02', NULL);
INSERT INTO notification VALUES (17, 2010, 'Task: I decided to try to follow the postgres approach as directly as possible and came up with the following migration.', 'I decided to try to follow the postgres approach as directly as possible and came up with the following migration.', '2015-01-21 21:45:00.013037+02', NULL);
INSERT INTO notification VALUES (18, 2064, 'Task: Revert status after testing', 'Revert status after testing', '2015-03-08 18:42:00.01327+02', NULL);
INSERT INTO notification VALUES (19, 2067, 'Task: Notifications testing #2', 'Notifications testing #2', '2015-03-09 17:17:00.020674+02', NULL);
INSERT INTO notification VALUES (20, 2069, 'Task: Test Notification resource link', 'Test Notification resource link', '2015-03-09 19:29:00.018282+02', NULL);
INSERT INTO notification VALUES (21, 2076, 'Task: Call about discounts', 'Call about discounts', '2015-03-21 17:10:00.014771+02', NULL);
INSERT INTO notification VALUES (22, 2133, 'Task: Task For Lastovec', 'Task For Lastovec', '2015-04-22 15:40:00.007831+03', NULL);
INSERT INTO notification VALUES (23, 2198, 'Task: Check reminder', 'Check reminder', '2015-05-03 13:35:00.039271+03', NULL);
INSERT INTO notification VALUES (24, 2304, 'Task: Call about offer', 'Call about offer', '2015-05-24 17:20:00.01303+03', NULL);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notification_id_seq', 24, true);


--
-- Data for Name: notification_resource; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO notification_resource VALUES (20, 2068);
INSERT INTO notification_resource VALUES (21, 2075);
INSERT INTO notification_resource VALUES (22, 2131);
INSERT INTO notification_resource VALUES (23, 2197);
INSERT INTO notification_resource VALUES (24, 2303);


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "order" VALUES (4, '2015-05-10', 2275, 17, 4, NULL, NULL, 0);
INSERT INTO "order" VALUES (3, '2015-05-10', 2267, 43, 5, NULL, NULL, 0);
INSERT INTO "order" VALUES (2, '2015-05-10', 2264, 44, 6, NULL, NULL, 0);
INSERT INTO "order" VALUES (5, '2015-04-29', 2280, 42, 1, 'Test description', NULL, 0);
INSERT INTO "order" VALUES (6, '2015-05-16', 2284, 36, 2, NULL, NULL, 0);
INSERT INTO "order" VALUES (9, '2015-06-06', 2382, 53, 6, NULL, 5, 1);
INSERT INTO "order" VALUES (7, '2015-05-26', 2317, 48, 4, 'For Lead testing', 3, 3);
INSERT INTO "order" VALUES (8, '2015-06-02', 2345, 50, 2, NULL, 4, 1);


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('order_id_seq', 9, true);


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO order_item VALUES (28, 2254, NULL, 7, 57, 420.00, 0, NULL, NULL, 97, 0.00, 0.00);
INSERT INTO order_item VALUES (29, 2256, NULL, 7, 57, 420.00, 0, NULL, NULL, 97, 0.00, 0.00);
INSERT INTO order_item VALUES (30, 2258, NULL, 7, 57, 420.00, 0, NULL, NULL, 97, 0.00, 0.00);
INSERT INTO order_item VALUES (34, 2273, 4, 4, 57, 150.00, 1, '2015-05-10', NULL, 102, 0.00, 0.00);
INSERT INTO order_item VALUES (33, 2265, 3, 5, 57, 2400.00, 0, NULL, NULL, 94, 0.00, 0.00);
INSERT INTO order_item VALUES (31, 2260, 2, 7, 57, 422.00, 0, NULL, NULL, 97, 0.00, 0.00);
INSERT INTO order_item VALUES (32, 2262, 2, 7, 57, 387.00, 0, NULL, NULL, 97, 0.00, 0.00);
INSERT INTO order_item VALUES (37, 2285, NULL, 5, 57, 2780.00, 1, '2015-05-16', NULL, 87, 0.00, 0.00);
INSERT INTO order_item VALUES (38, 2287, NULL, 7, 54, 640.00, 2, '2015-05-16', NULL, 97, 0.00, 0.00);
INSERT INTO order_item VALUES (36, 2282, 6, 5, 57, 3201.00, 0, '2015-05-16', NULL, 87, 0.00, 2.00);
INSERT INTO order_item VALUES (35, 2278, 5, 1, 57, 40.00, 1, '2015-05-10', 'passport had been received by customer', 102, 0.00, 0.00);
INSERT INTO order_item VALUES (40, 2341, 8, 5, 57, 3300.00, 1, '2015-06-02', NULL, 93, 0.00, 3.00);
INSERT INTO order_item VALUES (43, 2379, 9, 4, 54, 300.00, 1, '2015-06-06', '#678975-HJYT', 102, 0.00, 0.00);
INSERT INTO order_item VALUES (42, 2377, 9, 5, 56, 57090.00, 1, '2015-06-06', '#5677912TY', 92, 1200.00, 2.50);
INSERT INTO order_item VALUES (39, 2315, 7, 5, 57, 1760.00, 1, '2015-05-26', '#878qweiu', 87, 0.00, 0.00);
INSERT INTO order_item VALUES (41, 2343, 8, 4, 54, 130.00, 2, '2015-06-20', '#6509-9', 100, 0.00, 2.00);


--
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('order_item_id_seq', 43, true);


--
-- Data for Name: outgoing; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO outgoing VALUES (13, 1903, 3, '2014-11-18', 10, 8200.00, NULL);
INSERT INTO outgoing VALUES (16, 1915, 6, '2014-11-23', 12, 15000.00, NULL);
INSERT INTO outgoing VALUES (23, 2467, 18, '2015-06-14', 23, 15000.00, NULL);
INSERT INTO outgoing VALUES (21, 2463, 17, '2015-06-14', 22, 108.00, 'Test for outgoing cashflows');


--
-- Data for Name: outgoing_cashflow; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO outgoing_cashflow VALUES (23, 258);
INSERT INTO outgoing_cashflow VALUES (21, 259);


--
-- Name: outgoing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('outgoing_id_seq', 23, true);


--
-- Data for Name: passport; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO passport VALUES (1, 14, '231654', NULL, 1199, NULL, 0);
INSERT INTO passport VALUES (2, 14, '132456', NULL, 1200, NULL, 0);
INSERT INTO passport VALUES (4, 12, '1234564', NULL, 1205, NULL, 0);
INSERT INTO passport VALUES (5, 14, 'Svxzvxz', 'xzcvxzcv', 1206, NULL, 0);
INSERT INTO passport VALUES (14, 3, 'RT678123', 'Foreign Passport', 1584, '2015-08-21', 0);
INSERT INTO passport VALUES (15, 3, 'TY67342', NULL, 1592, '2015-08-28', 0);
INSERT INTO passport VALUES (17, 3, 'ER781263', NULL, 1613, NULL, 0);
INSERT INTO passport VALUES (21, 3, 'RT7892634', NULL, 1643, '2017-07-19', 0);
INSERT INTO passport VALUES (22, 3, 'RT632453', NULL, 1651, '2019-08-16', 0);
INSERT INTO passport VALUES (25, 9, 'TY78534', NULL, 2019, '2018-06-06', 0);
INSERT INTO passport VALUES (6, 3, 'НК028057', NULL, 1261, NULL, 1);
INSERT INTO passport VALUES (7, 3, 'HJ123456', 'new passport', 1265, NULL, 1);
INSERT INTO passport VALUES (9, 3, 'HK123456', NULL, 1376, NULL, 1);
INSERT INTO passport VALUES (10, 3, 'HK12345', NULL, 1381, NULL, 1);
INSERT INTO passport VALUES (11, 3, 'PO123456', NULL, 1406, NULL, 1);
INSERT INTO passport VALUES (12, 3, 'TY3456', NULL, 1467, '2016-04-10', 1);
INSERT INTO passport VALUES (13, 3, 'YU78932', 'Ukrainian citizen passport', 1582, NULL, 1);
INSERT INTO passport VALUES (16, 3, 'IO98676', NULL, 1612, NULL, 1);
INSERT INTO passport VALUES (18, 3, 'НК089564', NULL, 1622, NULL, 1);
INSERT INTO passport VALUES (19, 3, 'RE6712346', NULL, 1625, NULL, 1);
INSERT INTO passport VALUES (20, 3, 'HJ789665', NULL, 1642, NULL, 1);
INSERT INTO passport VALUES (23, 3, 'RTY', NULL, 1925, NULL, 1);
INSERT INTO passport VALUES (24, 3, 'HH67187', NULL, 2014, NULL, 1);
INSERT INTO passport VALUES (8, 3, 'РМ12345', 'from Kiev region', 1286, '2015-06-19', 1);


--
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('passport_id_seq', 25, true);


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
INSERT INTO permision VALUES (79, 110, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (80, 111, 4, '{view,add,edit,delete}', NULL, 'all');
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
INSERT INTO permision VALUES (120, 110, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (121, 111, 8, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (123, 12, 8, '{view,add,edit,delete,settings}', NULL, 'all');
INSERT INTO permision VALUES (128, 117, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (129, 118, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (130, 119, 4, '{autoload,view,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (131, 120, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (132, 121, 4, '{view}', NULL, 'all');
INSERT INTO permision VALUES (24, 12, 4, '{view,add,edit,delete,settings}', NULL, 'all');
INSERT INTO permision VALUES (134, 123, 4, '{view,close}', NULL, 'all');
INSERT INTO permision VALUES (137, 126, 4, '{view,edit}', NULL, 'all');
INSERT INTO permision VALUES (158, 146, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (141, 130, 4, '{view,add,edit,delete,order}', NULL, 'all');
INSERT INTO permision VALUES (157, 145, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (155, 144, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (154, 143, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (153, 142, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (152, 141, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (151, 140, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (150, 139, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (149, 138, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (148, 137, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (146, 135, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (145, 134, 4, '{view,add,edit,delete,calculation,invoice,contract}', NULL, 'all');
INSERT INTO permision VALUES (135, 124, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (75, 106, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (72, 103, 4, '{view,add,edit,delete,settings}', NULL, 'all');
INSERT INTO permision VALUES (160, 148, 4, '{view,add,edit,delete}', NULL, 'all');
INSERT INTO permision VALUES (161, 149, 4, '{view,add,edit,delete}', NULL, 'all');


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO person VALUES (19, 1294, 'Stas', 'Voevoda', '', '2007-10-16', false, 0, NULL);
INSERT INTO person VALUES (20, 1372, 'Oleg', 'Pogorelov', '', '1970-02-17', false, 0, NULL);
INSERT INTO person VALUES (24, 1390, 'Igor', 'Mazur', '', '2007-07-21', false, 0, NULL);
INSERT INTO person VALUES (25, 1408, 'Vitalii', 'Klishunov', '', '1976-04-07', false, 0, NULL);
INSERT INTO person VALUES (26, 1409, 'Natalia', 'Klishunova', '', '1978-08-10', false, 0, NULL);
INSERT INTO person VALUES (27, 1410, 'Maxim', 'Klishunov', '', '2005-02-16', false, 0, NULL);
INSERT INTO person VALUES (29, 1465, 'Eugen', 'Velichko', '', '1982-04-07', false, 0, NULL);
INSERT INTO person VALUES (31, 1472, 'Velichko', 'Alexander', '', '2006-01-11', false, 0, NULL);
INSERT INTO person VALUES (33, 1586, 'Roman', 'Babich', '', '1990-11-14', false, 0, NULL);
INSERT INTO person VALUES (36, 1616, 'Nikolay', 'Artyuh', '', '1986-10-08', false, 0, NULL);
INSERT INTO person VALUES (37, 1619, 'Andriy', 'Garkaviy', '', '1984-11-14', false, 0, NULL);
INSERT INTO person VALUES (39, 1627, 'Petro', 'Garkaviy', '', '2004-06-08', false, 0, NULL);
INSERT INTO person VALUES (41, 1645, 'Karpenko', 'Alexander', '', '1990-06-04', false, 0, NULL);
INSERT INTO person VALUES (43, 1869, 'Alexey', 'Ivankiv', 'V.', NULL, true, 0, NULL);
INSERT INTO person VALUES (38, 1626, 'Elena', 'Garkava', '', '1986-01-08', true, 0, NULL);
INSERT INTO person VALUES (22, 1383, 'Vitalii', 'Mazur', '', '1979-07-17', true, 0, NULL);
INSERT INTO person VALUES (44, 2017, 'Sergey', 'Gavrish', '', '1981-08-05', true, 0, NULL);
INSERT INTO person VALUES (18, 1293, 'Irina', 'Voevoda', '', '1984-01-18', false, 1, NULL);
INSERT INTO person VALUES (21, 1375, 'Elena', 'Pogorelova', 'Petrovna', '1972-02-19', false, 1, NULL);
INSERT INTO person VALUES (28, 1411, 'Ann', 'Klishunova', '', '2013-02-14', false, 1, NULL);
INSERT INTO person VALUES (30, 1471, 'Irina', 'Avdeeva', '', '1984-11-21', false, 1, NULL);
INSERT INTO person VALUES (32, 1473, 'Velichko', 'Elizabeth', '', '2010-06-15', false, 1, NULL);
INSERT INTO person VALUES (34, 1593, 'Elena', 'Babich', '', '1991-05-23', false, 1, NULL);
INSERT INTO person VALUES (42, 1653, 'Smichko', 'Olena', '', '1992-07-15', false, 1, NULL);
INSERT INTO person VALUES (40, 1628, 'Alena', 'Garkava', '', '2007-03-29', true, 1, NULL);
INSERT INTO person VALUES (35, 1615, 'Tat''ana', 'Artyuh', '', '1987-02-10', true, 1, NULL);
INSERT INTO person VALUES (45, 2020, 'Anna', 'Gavrish', '', '1993-11-17', true, 1, NULL);
INSERT INTO person VALUES (4, 870, 'Greg', 'Johnson', '', NULL, false, 0, NULL);
INSERT INTO person VALUES (5, 871, 'John', 'Doe', '', NULL, false, 0, NULL);
INSERT INTO person VALUES (6, 887, 'Peter', 'Parker', '', '1976-04-07', false, 0, NULL);
INSERT INTO person VALUES (46, 2051, 'Nikolay', '', '', NULL, false, 0, NULL);
INSERT INTO person VALUES (23, 1389, 'Iren', 'Mazur', '', '1979-09-03', false, 1, NULL);
INSERT INTO person VALUES (47, 2090, 'Jason', '', 'Lewis', NULL, false, 0, NULL);
INSERT INTO person VALUES (48, 2309, 'Oleg', '', '', NULL, false, 0, NULL);
INSERT INTO person VALUES (49, 2314, 'Anna', '', '', NULL, false, 1, NULL);
INSERT INTO person VALUES (50, 2328, 'Alex', 'Nikitin', '', '1991-08-14', false, 0, NULL);
INSERT INTO person VALUES (51, 2339, 'Julia', 'Nikitina', '', '1991-12-12', false, 1, NULL);
INSERT INTO person VALUES (52, 2340, 'Ivan', 'Nikitin', '', '2012-02-15', false, 0, NULL);
INSERT INTO person VALUES (53, 2367, 'Sergey', 'Stepanchuk', '', '1984-11-06', false, 0, NULL);
INSERT INTO person VALUES (54, 2376, 'Nadiya', 'Gavrilyuk', '', '1988-03-02', false, 1, NULL);
INSERT INTO person VALUES (17, 1284, 'Nikolay', 'Voevoda', '', '1981-07-22', false, 0, NULL);


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
INSERT INTO person_address VALUES (44, 32);


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
INSERT INTO person_contact VALUES (44, 79);
INSERT INTO person_contact VALUES (45, 80);
INSERT INTO person_contact VALUES (46, 81);
INSERT INTO person_contact VALUES (47, 82);
INSERT INTO person_contact VALUES (46, 83);
INSERT INTO person_contact VALUES (48, 84);
INSERT INTO person_contact VALUES (48, 85);
INSERT INTO person_contact VALUES (50, 86);
INSERT INTO person_contact VALUES (51, 87);
INSERT INTO person_contact VALUES (53, 88);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('person_id_seq', 54, true);


--
-- Data for Name: person_order_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO person_order_item VALUES (33, 41);
INSERT INTO person_order_item VALUES (33, 43);
INSERT INTO person_order_item VALUES (34, 17);
INSERT INTO person_order_item VALUES (37, 20);
INSERT INTO person_order_item VALUES (37, 21);
INSERT INTO person_order_item VALUES (38, 21);
INSERT INTO person_order_item VALUES (38, 20);
INSERT INTO person_order_item VALUES (36, 36);
INSERT INTO person_order_item VALUES (36, 35);
INSERT INTO person_order_item VALUES (35, 33);
INSERT INTO person_order_item VALUES (35, 42);
INSERT INTO person_order_item VALUES (40, 51);
INSERT INTO person_order_item VALUES (40, 50);
INSERT INTO person_order_item VALUES (40, 52);
INSERT INTO person_order_item VALUES (43, 53);
INSERT INTO person_order_item VALUES (43, 54);
INSERT INTO person_order_item VALUES (42, 53);
INSERT INTO person_order_item VALUES (42, 54);
INSERT INTO person_order_item VALUES (39, 48);
INSERT INTO person_order_item VALUES (39, 49);
INSERT INTO person_order_item VALUES (41, 50);
INSERT INTO person_order_item VALUES (41, 51);
INSERT INTO person_order_item VALUES (28, 44);
INSERT INTO person_order_item VALUES (28, 45);
INSERT INTO person_order_item VALUES (29, 44);
INSERT INTO person_order_item VALUES (29, 45);
INSERT INTO person_order_item VALUES (30, 44);
INSERT INTO person_order_item VALUES (30, 45);
INSERT INTO person_order_item VALUES (31, 44);
INSERT INTO person_order_item VALUES (31, 45);
INSERT INTO person_order_item VALUES (32, 44);
INSERT INTO person_order_item VALUES (32, 45);


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
INSERT INTO person_passport VALUES (44, 24);
INSERT INTO person_passport VALUES (45, 25);


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
INSERT INTO person_subaccount VALUES (44, 17);
INSERT INTO person_subaccount VALUES (53, 21);
INSERT INTO person_subaccount VALUES (48, 22);


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

SELECT pg_catalog.setval('positions_navigations_id_seq', 174, true);


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('positions_permisions_id_seq', 162, true);


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
INSERT INTO region VALUES (38, 2373, 12, 'South Dalmacia');


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
INSERT INTO resource VALUES (1376, 89, 32, false);
INSERT INTO resource VALUES (1378, 78, 32, false);
INSERT INTO resource VALUES (1385, 84, 32, false);
INSERT INTO resource VALUES (1386, 83, 32, false);
INSERT INTO resource VALUES (1060, 41, 32, NULL);
INSERT INTO resource VALUES (1068, 12, 32, NULL);
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
INSERT INTO resource VALUES (1464, 87, 32, false);
INSERT INTO resource VALUES (1465, 69, 32, false);
INSERT INTO resource VALUES (1467, 89, 32, false);
INSERT INTO resource VALUES (1468, 84, 32, false);
INSERT INTO resource VALUES (1469, 90, 32, false);
INSERT INTO resource VALUES (1470, 83, 32, false);
INSERT INTO resource VALUES (1471, 69, 32, false);
INSERT INTO resource VALUES (1472, 69, 32, false);
INSERT INTO resource VALUES (1473, 69, 32, false);
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
INSERT INTO resource VALUES (1597, 104, 32, false);
INSERT INTO resource VALUES (1598, 103, 32, false);
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
INSERT INTO resource VALUES (1657, 103, 32, false);
INSERT INTO resource VALUES (1659, 65, 32, false);
INSERT INTO resource VALUES (1660, 106, 32, false);
INSERT INTO resource VALUES (1714, 110, 32, false);
INSERT INTO resource VALUES (1721, 110, 32, false);
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
INSERT INTO resource VALUES (1833, 118, 32, false);
INSERT INTO resource VALUES (1839, 103, 32, false);
INSERT INTO resource VALUES (1840, 103, 32, false);
INSERT INTO resource VALUES (1849, 12, 32, false);
INSERT INTO resource VALUES (1852, 119, 32, false);
INSERT INTO resource VALUES (1853, 119, 32, false);
INSERT INTO resource VALUES (1854, 119, 32, false);
INSERT INTO resource VALUES (1855, 119, 32, false);
INSERT INTO resource VALUES (1859, 119, 32, false);
INSERT INTO resource VALUES (1860, 119, 32, false);
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
INSERT INTO resource VALUES (1910, 106, 32, false);
INSERT INTO resource VALUES (1911, 106, 32, false);
INSERT INTO resource VALUES (1913, 117, 32, false);
INSERT INTO resource VALUES (1915, 111, 32, false);
INSERT INTO resource VALUES (1917, 110, 32, false);
INSERT INTO resource VALUES (1918, 119, 32, false);
INSERT INTO resource VALUES (1919, 12, 32, false);
INSERT INTO resource VALUES (1922, 93, 32, false);
INSERT INTO resource VALUES (1924, 118, 32, false);
INSERT INTO resource VALUES (1925, 89, 32, false);
INSERT INTO resource VALUES (1926, 90, 32, false);
INSERT INTO resource VALUES (1927, 87, 32, false);
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
INSERT INTO resource VALUES (1956, 87, 32, false);
INSERT INTO resource VALUES (1958, 93, 32, false);
INSERT INTO resource VALUES (1959, 123, 32, false);
INSERT INTO resource VALUES (1961, 123, 32, false);
INSERT INTO resource VALUES (1962, 93, 32, false);
INSERT INTO resource VALUES (1963, 123, 32, false);
INSERT INTO resource VALUES (1964, 93, 32, false);
INSERT INTO resource VALUES (1965, 123, 32, false);
INSERT INTO resource VALUES (1955, 124, 32, false);
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
INSERT INTO resource VALUES (2000, 103, 32, false);
INSERT INTO resource VALUES (2001, 106, 32, false);
INSERT INTO resource VALUES (2002, 106, 32, false);
INSERT INTO resource VALUES (2005, 103, 32, false);
INSERT INTO resource VALUES (2006, 106, 32, false);
INSERT INTO resource VALUES (2007, 106, 32, false);
INSERT INTO resource VALUES (2009, 93, 32, false);
INSERT INTO resource VALUES (2010, 123, 32, false);
INSERT INTO resource VALUES (2011, 110, 32, false);
INSERT INTO resource VALUES (2012, 118, 32, false);
INSERT INTO resource VALUES (2013, 87, 32, false);
INSERT INTO resource VALUES (2014, 89, 32, false);
INSERT INTO resource VALUES (2015, 90, 32, false);
INSERT INTO resource VALUES (2016, 93, 32, false);
INSERT INTO resource VALUES (2017, 69, 32, false);
INSERT INTO resource VALUES (2018, 87, 32, false);
INSERT INTO resource VALUES (2019, 89, 32, false);
INSERT INTO resource VALUES (2020, 69, 32, false);
INSERT INTO resource VALUES (2023, 104, 32, false);
INSERT INTO resource VALUES (2024, 104, 32, false);
INSERT INTO resource VALUES (2026, 103, 32, false);
INSERT INTO resource VALUES (2027, 106, 32, false);
INSERT INTO resource VALUES (2028, 106, 32, false);
INSERT INTO resource VALUES (2029, 119, 32, false);
INSERT INTO resource VALUES (2030, 119, 32, false);
INSERT INTO resource VALUES (2031, 119, 32, false);
INSERT INTO resource VALUES (2032, 110, 32, false);
INSERT INTO resource VALUES (2038, 119, 32, false);
INSERT INTO resource VALUES (2039, 119, 32, false);
INSERT INTO resource VALUES (2044, 119, 32, false);
INSERT INTO resource VALUES (2045, 119, 32, false);
INSERT INTO resource VALUES (2046, 119, 32, false);
INSERT INTO resource VALUES (2047, 119, 32, false);
INSERT INTO resource VALUES (2048, 65, 32, false);
INSERT INTO resource VALUES (2049, 12, 32, false);
INSERT INTO resource VALUES (2050, 87, 32, false);
INSERT INTO resource VALUES (2051, 69, 32, false);
INSERT INTO resource VALUES (2052, 130, 32, false);
INSERT INTO resource VALUES (2053, 47, 32, false);
INSERT INTO resource VALUES (2054, 2, 32, false);
INSERT INTO resource VALUES (2055, 12, 32, false);
INSERT INTO resource VALUES (2062, 93, 32, false);
INSERT INTO resource VALUES (2063, 93, 32, false);
INSERT INTO resource VALUES (2064, 123, 32, false);
INSERT INTO resource VALUES (2065, 118, 32, false);
INSERT INTO resource VALUES (2066, 93, 32, false);
INSERT INTO resource VALUES (2067, 123, 32, false);
INSERT INTO resource VALUES (2068, 93, 32, false);
INSERT INTO resource VALUES (2069, 123, 32, false);
INSERT INTO resource VALUES (2070, 12, 32, false);
INSERT INTO resource VALUES (2075, 93, 32, false);
INSERT INTO resource VALUES (2076, 123, 32, false);
INSERT INTO resource VALUES (2077, 12, 32, false);
INSERT INTO resource VALUES (2087, 118, 32, false);
INSERT INTO resource VALUES (2088, 130, 32, false);
INSERT INTO resource VALUES (2089, 87, 32, false);
INSERT INTO resource VALUES (2090, 69, 32, false);
INSERT INTO resource VALUES (2092, 118, 32, false);
INSERT INTO resource VALUES (2095, 87, 32, false);
INSERT INTO resource VALUES (2096, 118, 32, false);
INSERT INTO resource VALUES (2097, 118, 32, false);
INSERT INTO resource VALUES (2098, 118, 32, false);
INSERT INTO resource VALUES (2099, 12, 32, false);
INSERT INTO resource VALUES (2100, 12, 32, false);
INSERT INTO resource VALUES (2101, 65, 32, false);
INSERT INTO resource VALUES (2104, 135, 32, false);
INSERT INTO resource VALUES (2105, 135, 32, false);
INSERT INTO resource VALUES (2106, 135, 32, false);
INSERT INTO resource VALUES (2107, 12, 32, false);
INSERT INTO resource VALUES (2108, 12, 32, false);
INSERT INTO resource VALUES (2111, 83, 32, false);
INSERT INTO resource VALUES (2115, 39, 32, false);
INSERT INTO resource VALUES (2119, 90, 32, false);
INSERT INTO resource VALUES (2120, 101, 32, false);
INSERT INTO resource VALUES (2126, 2, 32, false);
INSERT INTO resource VALUES (2127, 12, 32, false);
INSERT INTO resource VALUES (2128, 65, 32, false);
INSERT INTO resource VALUES (2129, 138, 32, false);
INSERT INTO resource VALUES (2130, 138, 32, false);
INSERT INTO resource VALUES (2131, 93, 32, false);
INSERT INTO resource VALUES (2132, 118, 32, false);
INSERT INTO resource VALUES (2133, 123, 32, false);
INSERT INTO resource VALUES (2135, 12, 32, false);
INSERT INTO resource VALUES (2136, 65, 32, false);
INSERT INTO resource VALUES (2137, 139, 32, false);
INSERT INTO resource VALUES (2138, 139, 32, false);
INSERT INTO resource VALUES (2139, 139, 32, false);
INSERT INTO resource VALUES (2144, 135, 32, false);
INSERT INTO resource VALUES (2145, 137, 32, false);
INSERT INTO resource VALUES (2146, 135, 32, false);
INSERT INTO resource VALUES (2147, 137, 32, false);
INSERT INTO resource VALUES (2148, 135, 32, false);
INSERT INTO resource VALUES (2149, 137, 32, false);
INSERT INTO resource VALUES (2150, 135, 32, false);
INSERT INTO resource VALUES (2151, 137, 32, false);
INSERT INTO resource VALUES (2152, 135, 32, false);
INSERT INTO resource VALUES (2153, 137, 32, false);
INSERT INTO resource VALUES (2154, 135, 32, false);
INSERT INTO resource VALUES (2155, 137, 32, false);
INSERT INTO resource VALUES (2156, 135, 32, false);
INSERT INTO resource VALUES (2157, 137, 32, false);
INSERT INTO resource VALUES (2158, 135, 32, false);
INSERT INTO resource VALUES (2159, 137, 32, false);
INSERT INTO resource VALUES (2160, 135, 32, false);
INSERT INTO resource VALUES (2161, 137, 32, false);
INSERT INTO resource VALUES (2162, 135, 32, false);
INSERT INTO resource VALUES (2163, 137, 32, false);
INSERT INTO resource VALUES (2164, 135, 32, false);
INSERT INTO resource VALUES (2165, 137, 32, false);
INSERT INTO resource VALUES (2167, 135, 32, false);
INSERT INTO resource VALUES (2168, 137, 32, false);
INSERT INTO resource VALUES (2171, 93, 32, false);
INSERT INTO resource VALUES (2172, 135, 32, false);
INSERT INTO resource VALUES (2173, 137, 32, false);
INSERT INTO resource VALUES (2174, 135, 32, false);
INSERT INTO resource VALUES (2175, 137, 32, false);
INSERT INTO resource VALUES (2176, 135, 32, false);
INSERT INTO resource VALUES (2177, 137, 32, false);
INSERT INTO resource VALUES (2178, 135, 32, false);
INSERT INTO resource VALUES (2179, 137, 32, false);
INSERT INTO resource VALUES (2180, 135, 32, false);
INSERT INTO resource VALUES (2181, 137, 32, false);
INSERT INTO resource VALUES (2182, 135, 32, false);
INSERT INTO resource VALUES (2183, 137, 32, false);
INSERT INTO resource VALUES (2184, 135, 32, false);
INSERT INTO resource VALUES (2185, 137, 32, false);
INSERT INTO resource VALUES (2186, 134, 32, false);
INSERT INTO resource VALUES (2187, 135, 32, false);
INSERT INTO resource VALUES (2188, 137, 32, false);
INSERT INTO resource VALUES (2189, 135, 32, false);
INSERT INTO resource VALUES (2190, 137, 32, false);
INSERT INTO resource VALUES (2197, 93, 32, false);
INSERT INTO resource VALUES (2198, 123, 32, false);
INSERT INTO resource VALUES (2199, 105, 32, false);
INSERT INTO resource VALUES (2200, 104, 32, false);
INSERT INTO resource VALUES (2201, 104, 32, false);
INSERT INTO resource VALUES (2203, 104, 32, false);
INSERT INTO resource VALUES (2205, 110, 32, false);
INSERT INTO resource VALUES (2206, 110, 32, false);
INSERT INTO resource VALUES (2207, 110, 32, false);
INSERT INTO resource VALUES (2208, 110, 32, false);
INSERT INTO resource VALUES (2209, 110, 32, false);
INSERT INTO resource VALUES (2210, 86, 32, false);
INSERT INTO resource VALUES (2211, 110, 32, false);
INSERT INTO resource VALUES (2212, 110, 32, false);
INSERT INTO resource VALUES (2213, 86, 32, false);
INSERT INTO resource VALUES (2214, 110, 32, false);
INSERT INTO resource VALUES (2215, 86, 32, false);
INSERT INTO resource VALUES (2216, 78, 32, false);
INSERT INTO resource VALUES (2217, 12, 32, false);
INSERT INTO resource VALUES (2218, 140, 32, false);
INSERT INTO resource VALUES (2219, 65, 32, false);
INSERT INTO resource VALUES (2221, 140, 32, false);
INSERT INTO resource VALUES (2222, 65, 32, false);
INSERT INTO resource VALUES (2223, 78, 32, false);
INSERT INTO resource VALUES (2224, 78, 32, false);
INSERT INTO resource VALUES (2225, 78, 32, false);
INSERT INTO resource VALUES (2226, 78, 32, false);
INSERT INTO resource VALUES (2227, 78, 32, false);
INSERT INTO resource VALUES (2228, 78, 32, false);
INSERT INTO resource VALUES (2229, 78, 32, false);
INSERT INTO resource VALUES (2230, 78, 32, false);
INSERT INTO resource VALUES (2231, 78, 32, false);
INSERT INTO resource VALUES (2232, 78, 32, false);
INSERT INTO resource VALUES (2233, 78, 32, false);
INSERT INTO resource VALUES (2234, 78, 32, false);
INSERT INTO resource VALUES (2235, 78, 32, false);
INSERT INTO resource VALUES (2236, 78, 32, false);
INSERT INTO resource VALUES (2237, 78, 32, false);
INSERT INTO resource VALUES (2238, 78, 32, false);
INSERT INTO resource VALUES (2239, 78, 32, false);
INSERT INTO resource VALUES (2240, 78, 32, false);
INSERT INTO resource VALUES (2241, 78, 32, false);
INSERT INTO resource VALUES (2242, 78, 32, false);
INSERT INTO resource VALUES (2243, 12, 32, false);
INSERT INTO resource VALUES (2244, 12, 32, false);
INSERT INTO resource VALUES (2245, 65, 32, false);
INSERT INTO resource VALUES (2246, 105, 32, false);
INSERT INTO resource VALUES (2247, 102, 32, false);
INSERT INTO resource VALUES (2248, 141, 32, false);
INSERT INTO resource VALUES (2249, 141, 32, false);
INSERT INTO resource VALUES (2254, 135, 32, false);
INSERT INTO resource VALUES (2255, 142, 32, false);
INSERT INTO resource VALUES (2256, 135, 32, false);
INSERT INTO resource VALUES (2257, 142, 32, false);
INSERT INTO resource VALUES (2258, 135, 32, false);
INSERT INTO resource VALUES (2259, 142, 32, false);
INSERT INTO resource VALUES (2260, 135, 32, false);
INSERT INTO resource VALUES (2261, 142, 32, false);
INSERT INTO resource VALUES (2262, 135, 32, false);
INSERT INTO resource VALUES (2263, 142, 32, false);
INSERT INTO resource VALUES (2264, 134, 32, false);
INSERT INTO resource VALUES (2265, 135, 32, false);
INSERT INTO resource VALUES (2266, 137, 32, false);
INSERT INTO resource VALUES (2267, 134, 32, false);
INSERT INTO resource VALUES (2268, 12, 32, false);
INSERT INTO resource VALUES (2269, 105, 32, false);
INSERT INTO resource VALUES (2270, 70, 32, false);
INSERT INTO resource VALUES (2271, 140, 32, false);
INSERT INTO resource VALUES (2272, 78, 32, false);
INSERT INTO resource VALUES (2273, 135, 32, false);
INSERT INTO resource VALUES (2274, 143, 32, false);
INSERT INTO resource VALUES (2275, 134, 32, false);
INSERT INTO resource VALUES (2276, 12, 32, false);
INSERT INTO resource VALUES (2277, 105, 32, false);
INSERT INTO resource VALUES (2278, 135, 32, false);
INSERT INTO resource VALUES (2279, 144, 32, false);
INSERT INTO resource VALUES (2280, 134, 32, false);
INSERT INTO resource VALUES (2281, 104, 32, false);
INSERT INTO resource VALUES (2282, 135, 32, false);
INSERT INTO resource VALUES (2283, 137, 32, false);
INSERT INTO resource VALUES (2284, 134, 32, false);
INSERT INTO resource VALUES (2285, 135, 32, false);
INSERT INTO resource VALUES (2286, 137, 32, false);
INSERT INTO resource VALUES (2287, 135, 32, false);
INSERT INTO resource VALUES (2288, 142, 32, false);
INSERT INTO resource VALUES (2289, 104, 32, false);
INSERT INTO resource VALUES (2290, 104, 32, false);
INSERT INTO resource VALUES (2291, 93, 32, false);
INSERT INTO resource VALUES (2292, 12, 32, false);
INSERT INTO resource VALUES (2293, 145, 32, false);
INSERT INTO resource VALUES (2294, 145, 32, false);
INSERT INTO resource VALUES (2295, 145, 32, false);
INSERT INTO resource VALUES (2296, 12, 32, false);
INSERT INTO resource VALUES (2297, 145, 32, false);
INSERT INTO resource VALUES (2299, 146, 32, false);
INSERT INTO resource VALUES (2300, 145, 32, false);
INSERT INTO resource VALUES (2301, 146, 32, false);
INSERT INTO resource VALUES (2302, 118, 32, false);
INSERT INTO resource VALUES (2303, 93, 32, false);
INSERT INTO resource VALUES (2304, 123, 32, false);
INSERT INTO resource VALUES (2305, 145, 32, false);
INSERT INTO resource VALUES (2306, 146, 32, false);
INSERT INTO resource VALUES (2307, 87, 32, false);
INSERT INTO resource VALUES (2308, 87, 32, false);
INSERT INTO resource VALUES (2309, 69, 32, false);
INSERT INTO resource VALUES (2310, 145, 32, false);
INSERT INTO resource VALUES (2311, 93, 32, false);
INSERT INTO resource VALUES (2312, 130, 32, false);
INSERT INTO resource VALUES (2313, 145, 32, false);
INSERT INTO resource VALUES (2314, 69, 32, false);
INSERT INTO resource VALUES (2315, 135, 32, false);
INSERT INTO resource VALUES (2316, 137, 32, false);
INSERT INTO resource VALUES (2317, 134, 32, false);
INSERT INTO resource VALUES (2319, 104, 32, false);
INSERT INTO resource VALUES (2320, 12, 32, false);
INSERT INTO resource VALUES (2327, 87, 32, false);
INSERT INTO resource VALUES (2328, 69, 32, false);
INSERT INTO resource VALUES (2329, 145, 32, false);
INSERT INTO resource VALUES (2330, 145, 32, false);
INSERT INTO resource VALUES (2331, 146, 32, false);
INSERT INTO resource VALUES (2332, 146, 32, false);
INSERT INTO resource VALUES (2333, 130, 32, false);
INSERT INTO resource VALUES (2334, 104, 32, false);
INSERT INTO resource VALUES (2335, 104, 32, false);
INSERT INTO resource VALUES (2336, 104, 32, false);
INSERT INTO resource VALUES (2337, 104, 32, false);
INSERT INTO resource VALUES (2338, 87, 32, false);
INSERT INTO resource VALUES (2339, 69, 32, false);
INSERT INTO resource VALUES (2340, 69, 32, false);
INSERT INTO resource VALUES (2341, 135, 32, false);
INSERT INTO resource VALUES (2342, 137, 32, false);
INSERT INTO resource VALUES (2343, 135, 32, false);
INSERT INTO resource VALUES (2344, 143, 32, false);
INSERT INTO resource VALUES (2345, 134, 32, false);
INSERT INTO resource VALUES (2366, 87, 32, false);
INSERT INTO resource VALUES (2367, 69, 32, false);
INSERT INTO resource VALUES (2368, 145, 32, false);
INSERT INTO resource VALUES (2369, 146, 32, false);
INSERT INTO resource VALUES (2370, 118, 32, false);
INSERT INTO resource VALUES (2371, 93, 32, false);
INSERT INTO resource VALUES (2372, 130, 32, false);
INSERT INTO resource VALUES (2373, 39, 32, false);
INSERT INTO resource VALUES (2374, 84, 32, false);
INSERT INTO resource VALUES (2375, 83, 32, false);
INSERT INTO resource VALUES (2376, 69, 32, false);
INSERT INTO resource VALUES (2377, 135, 32, false);
INSERT INTO resource VALUES (2378, 137, 32, false);
INSERT INTO resource VALUES (2379, 135, 32, false);
INSERT INTO resource VALUES (2380, 143, 32, false);
INSERT INTO resource VALUES (2381, 93, 32, false);
INSERT INTO resource VALUES (2382, 134, 32, false);
INSERT INTO resource VALUES (2383, 104, 32, false);
INSERT INTO resource VALUES (2384, 104, 32, false);
INSERT INTO resource VALUES (2385, 104, 32, false);
INSERT INTO resource VALUES (2388, 103, 32, false);
INSERT INTO resource VALUES (2389, 105, 32, false);
INSERT INTO resource VALUES (2390, 105, 32, false);
INSERT INTO resource VALUES (2391, 105, 32, false);
INSERT INTO resource VALUES (2392, 105, 32, false);
INSERT INTO resource VALUES (2393, 105, 32, false);
INSERT INTO resource VALUES (2394, 105, 32, false);
INSERT INTO resource VALUES (2395, 105, 32, false);
INSERT INTO resource VALUES (2396, 105, 32, false);
INSERT INTO resource VALUES (2397, 105, 32, false);
INSERT INTO resource VALUES (2398, 105, 32, false);
INSERT INTO resource VALUES (2399, 105, 32, false);
INSERT INTO resource VALUES (2400, 105, 32, false);
INSERT INTO resource VALUES (2401, 105, 32, false);
INSERT INTO resource VALUES (2402, 105, 32, false);
INSERT INTO resource VALUES (2403, 105, 32, false);
INSERT INTO resource VALUES (2404, 105, 32, false);
INSERT INTO resource VALUES (2405, 105, 32, false);
INSERT INTO resource VALUES (2406, 105, 32, false);
INSERT INTO resource VALUES (2407, 105, 32, false);
INSERT INTO resource VALUES (2408, 105, 32, false);
INSERT INTO resource VALUES (2409, 105, 32, false);
INSERT INTO resource VALUES (2410, 105, 32, false);
INSERT INTO resource VALUES (2411, 105, 32, false);
INSERT INTO resource VALUES (2412, 105, 32, false);
INSERT INTO resource VALUES (2413, 105, 32, false);
INSERT INTO resource VALUES (2414, 105, 32, false);
INSERT INTO resource VALUES (2415, 105, 32, false);
INSERT INTO resource VALUES (2416, 105, 32, false);
INSERT INTO resource VALUES (2417, 105, 32, false);
INSERT INTO resource VALUES (2418, 105, 32, false);
INSERT INTO resource VALUES (2419, 105, 32, false);
INSERT INTO resource VALUES (2420, 105, 32, false);
INSERT INTO resource VALUES (2421, 105, 32, false);
INSERT INTO resource VALUES (2422, 105, 32, false);
INSERT INTO resource VALUES (2423, 105, 32, false);
INSERT INTO resource VALUES (2424, 105, 32, false);
INSERT INTO resource VALUES (2425, 105, 32, false);
INSERT INTO resource VALUES (2426, 105, 32, false);
INSERT INTO resource VALUES (2427, 105, 32, false);
INSERT INTO resource VALUES (2428, 105, 32, false);
INSERT INTO resource VALUES (2429, 105, 32, false);
INSERT INTO resource VALUES (2430, 105, 32, false);
INSERT INTO resource VALUES (2431, 105, 32, false);
INSERT INTO resource VALUES (2432, 105, 32, false);
INSERT INTO resource VALUES (2433, 145, 32, false);
INSERT INTO resource VALUES (2434, 130, 32, false);
INSERT INTO resource VALUES (2435, 146, 32, false);
INSERT INTO resource VALUES (2436, 93, 32, false);
INSERT INTO resource VALUES (2437, 146, 32, false);
INSERT INTO resource VALUES (2438, 117, 32, false);
INSERT INTO resource VALUES (2439, 117, 32, false);
INSERT INTO resource VALUES (2440, 117, 32, false);
INSERT INTO resource VALUES (2442, 117, 32, false);
INSERT INTO resource VALUES (2450, 103, 32, false);
INSERT INTO resource VALUES (2451, 106, 32, false);
INSERT INTO resource VALUES (2452, 117, 32, false);
INSERT INTO resource VALUES (2457, 106, 32, false);
INSERT INTO resource VALUES (2458, 106, 32, false);
INSERT INTO resource VALUES (2459, 106, 32, false);
INSERT INTO resource VALUES (2463, 111, 32, false);
INSERT INTO resource VALUES (2465, 120, 32, false);
INSERT INTO resource VALUES (2466, 117, 32, false);
INSERT INTO resource VALUES (2467, 111, 32, false);
INSERT INTO resource VALUES (2468, 119, 32, false);
INSERT INTO resource VALUES (2469, 119, 32, false);
INSERT INTO resource VALUES (2470, 119, 32, false);
INSERT INTO resource VALUES (2475, 90, 32, false);
INSERT INTO resource VALUES (2477, 47, 32, false);
INSERT INTO resource VALUES (2484, 2, 32, false);
INSERT INTO resource VALUES (2486, 101, 32, false);
INSERT INTO resource VALUES (2488, 93, 32, false);
INSERT INTO resource VALUES (2489, 86, 32, false);
INSERT INTO resource VALUES (2490, 86, 32, false);
INSERT INTO resource VALUES (2491, 86, 32, false);
INSERT INTO resource VALUES (2492, 93, 32, false);
INSERT INTO resource VALUES (2493, 87, 32, false);
INSERT INTO resource VALUES (2496, 93, 32, false);
INSERT INTO resource VALUES (2499, 93, 32, false);
INSERT INTO resource VALUES (2501, 110, 32, false);
INSERT INTO resource VALUES (2502, 110, 32, false);
INSERT INTO resource VALUES (2503, 119, 32, false);
INSERT INTO resource VALUES (2505, 110, 32, false);
INSERT INTO resource VALUES (2506, 86, 32, false);
INSERT INTO resource VALUES (2507, 110, 32, false);
INSERT INTO resource VALUES (2508, 110, 32, false);
INSERT INTO resource VALUES (2510, 110, 32, false);
INSERT INTO resource VALUES (2511, 86, 32, false);
INSERT INTO resource VALUES (2513, 12, 32, false);
INSERT INTO resource VALUES (2514, 65, 32, false);
INSERT INTO resource VALUES (2515, 148, 32, false);
INSERT INTO resource VALUES (2516, 12, 32, false);
INSERT INTO resource VALUES (2517, 149, 32, false);
INSERT INTO resource VALUES (2518, 149, 32, false);
INSERT INTO resource VALUES (2519, 47, 32, false);
INSERT INTO resource VALUES (2520, 149, 32, false);
INSERT INTO resource VALUES (2521, 149, 32, false);
INSERT INTO resource VALUES (2522, 149, 32, false);
INSERT INTO resource VALUES (2523, 149, 32, false);
INSERT INTO resource VALUES (2524, 149, 32, false);
INSERT INTO resource VALUES (2525, 149, 32, false);
INSERT INTO resource VALUES (2526, 149, 32, false);
INSERT INTO resource VALUES (2527, 149, 32, false);
INSERT INTO resource VALUES (2528, 149, 32, false);
INSERT INTO resource VALUES (2529, 119, 32, false);
INSERT INTO resource VALUES (2530, 119, 32, false);
INSERT INTO resource VALUES (2531, 119, 32, false);
INSERT INTO resource VALUES (2532, 119, 32, false);
INSERT INTO resource VALUES (2533, 119, 32, false);
INSERT INTO resource VALUES (2534, 119, 32, false);
INSERT INTO resource VALUES (2535, 119, 32, false);
INSERT INTO resource VALUES (2536, 110, 32, false);
INSERT INTO resource VALUES (2537, 119, 32, false);
INSERT INTO resource VALUES (2538, 119, 32, false);
INSERT INTO resource VALUES (2539, 110, 32, false);
INSERT INTO resource VALUES (2540, 86, 32, false);
INSERT INTO resource VALUES (2541, 119, 32, false);
INSERT INTO resource VALUES (2542, 148, 32, false);
INSERT INTO resource VALUES (2543, 148, 32, false);
INSERT INTO resource VALUES (2544, 148, 32, false);
INSERT INTO resource VALUES (2545, 86, 32, false);
INSERT INTO resource VALUES (2546, 110, 32, false);
INSERT INTO resource VALUES (2547, 119, 32, false);
INSERT INTO resource VALUES (2548, 119, 32, false);
INSERT INTO resource VALUES (2549, 12, 32, false);


--
-- Data for Name: resource_log; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO resource_log VALUES (142, 83, 2, NULL, '2013-12-07 16:38:38.11618+02');
INSERT INTO resource_log VALUES (143, 84, 2, NULL, '2013-12-07 16:39:56.788641+02');
INSERT INTO resource_log VALUES (144, 3, 2, NULL, '2013-12-07 16:41:27.65259+02');
INSERT INTO resource_log VALUES (145, 2, 2, NULL, '2013-12-07 16:41:31.748494+02');
INSERT INTO resource_log VALUES (146, 83, 2, NULL, '2013-12-07 16:58:05.802634+02');
INSERT INTO resource_log VALUES (147, 83, 2, NULL, '2013-12-07 17:00:14.544264+02');
INSERT INTO resource_log VALUES (4836, 794, 2, NULL, '2014-02-05 19:54:07.5415+02');
INSERT INTO resource_log VALUES (5406, 1192, 2, NULL, '2014-04-06 19:21:11.278173+03');
INSERT INTO resource_log VALUES (5407, 1005, 2, NULL, '2014-04-06 19:21:55.315341+03');
INSERT INTO resource_log VALUES (4845, 283, 2, NULL, '2014-02-06 11:38:41.090464+02');
INSERT INTO resource_log VALUES (2, 10, 2, NULL, '2013-11-16 19:00:14.24272+02');
INSERT INTO resource_log VALUES (4, 12, 2, NULL, '2013-11-16 19:00:15.497284+02');
INSERT INTO resource_log VALUES (6, 14, 2, NULL, '2013-11-16 19:00:16.696731+02');
INSERT INTO resource_log VALUES (8, 16, 2, NULL, '2013-11-16 19:00:17.960761+02');
INSERT INTO resource_log VALUES (5427, 1204, 2, NULL, '2014-04-09 18:54:09.146902+03');
INSERT INTO resource_log VALUES (12, 30, 2, NULL, '2013-11-23 19:26:00.193553+02');
INSERT INTO resource_log VALUES (13, 30, 2, NULL, '2013-11-23 22:02:37.363677+02');
INSERT INTO resource_log VALUES (14, 10, 2, NULL, '2013-11-23 22:11:01.634598+02');
INSERT INTO resource_log VALUES (15, 30, 2, NULL, '2013-11-23 22:11:14.939938+02');
INSERT INTO resource_log VALUES (16, 30, 2, NULL, '2013-11-23 22:11:38.396085+02');
INSERT INTO resource_log VALUES (19, 30, 2, NULL, '2013-11-24 10:30:59.830287+02');
INSERT INTO resource_log VALUES (20, 30, 2, NULL, '2013-11-24 10:31:22.936737+02');
INSERT INTO resource_log VALUES (21, 30, 2, NULL, '2013-11-24 10:38:08.07328+02');
INSERT INTO resource_log VALUES (22, 30, 2, NULL, '2013-11-24 10:38:10.703187+02');
INSERT INTO resource_log VALUES (23, 30, 2, NULL, '2013-11-24 10:38:11.896934+02');
INSERT INTO resource_log VALUES (24, 30, 2, NULL, '2013-11-24 10:42:19.397852+02');
INSERT INTO resource_log VALUES (25, 30, 2, NULL, '2013-11-24 10:42:50.772172+02');
INSERT INTO resource_log VALUES (26, 30, 2, NULL, '2013-11-24 10:45:56.399572+02');
INSERT INTO resource_log VALUES (27, 30, 2, NULL, '2013-11-24 10:48:29.950669+02');
INSERT INTO resource_log VALUES (28, 30, 2, NULL, '2013-11-24 10:49:23.616693+02');
INSERT INTO resource_log VALUES (29, 30, 2, NULL, '2013-11-24 10:50:05.878643+02');
INSERT INTO resource_log VALUES (30, 30, 2, NULL, '2013-11-24 10:51:02.465585+02');
INSERT INTO resource_log VALUES (31, 30, 2, NULL, '2013-11-24 10:54:21.011765+02');
INSERT INTO resource_log VALUES (32, 30, 2, NULL, '2013-11-24 10:54:28.775552+02');
INSERT INTO resource_log VALUES (33, 30, 2, NULL, '2013-11-24 10:58:34.152869+02');
INSERT INTO resource_log VALUES (34, 30, 2, NULL, '2013-11-24 10:58:36.766104+02');
INSERT INTO resource_log VALUES (35, 30, 2, NULL, '2013-11-24 10:58:38.767749+02');
INSERT INTO resource_log VALUES (36, 30, 2, NULL, '2013-11-24 10:58:42.533162+02');
INSERT INTO resource_log VALUES (37, 30, 2, NULL, '2013-11-24 10:58:43.55758+02');
INSERT INTO resource_log VALUES (38, 30, 2, NULL, '2013-11-24 10:58:47.40587+02');
INSERT INTO resource_log VALUES (39, 30, 2, NULL, '2013-11-24 11:00:56.130675+02');
INSERT INTO resource_log VALUES (40, 30, 2, NULL, '2013-11-24 11:01:17.637578+02');
INSERT INTO resource_log VALUES (41, 30, 2, NULL, '2013-11-24 11:01:20.639413+02');
INSERT INTO resource_log VALUES (42, 30, 2, NULL, '2013-11-24 11:01:25.957588+02');
INSERT INTO resource_log VALUES (43, 30, 2, NULL, '2013-11-24 11:01:28.015301+02');
INSERT INTO resource_log VALUES (44, 30, 2, NULL, '2013-11-24 11:01:49.505153+02');
INSERT INTO resource_log VALUES (45, 30, 2, NULL, '2013-11-24 11:01:54.465064+02');
INSERT INTO resource_log VALUES (46, 30, 2, NULL, '2013-11-24 11:01:56.828797+02');
INSERT INTO resource_log VALUES (47, 30, 2, NULL, '2013-11-24 11:02:00.873006+02');
INSERT INTO resource_log VALUES (48, 30, 2, NULL, '2013-11-24 11:02:06.385907+02');
INSERT INTO resource_log VALUES (49, 30, 2, NULL, '2013-11-24 11:02:08.474309+02');
INSERT INTO resource_log VALUES (50, 30, 2, NULL, '2013-11-24 11:02:11.823259+02');
INSERT INTO resource_log VALUES (51, 30, 2, NULL, '2013-11-24 11:02:15.084044+02');
INSERT INTO resource_log VALUES (52, 30, 2, NULL, '2013-11-24 11:23:59.150304+02');
INSERT INTO resource_log VALUES (53, 30, 2, NULL, '2013-11-24 12:41:22.004561+02');
INSERT INTO resource_log VALUES (54, 30, 2, NULL, '2013-11-24 12:41:27.704243+02');
INSERT INTO resource_log VALUES (55, 30, 2, NULL, '2013-11-24 12:41:32.588516+02');
INSERT INTO resource_log VALUES (5430, 1207, 2, NULL, '2014-04-09 20:43:13.852066+03');
INSERT INTO resource_log VALUES (5459, 1227, 2, NULL, '2014-04-19 13:04:24.512333+03');
INSERT INTO resource_log VALUES (5467, 1230, 2, NULL, '2014-04-23 11:53:28.979784+03');
INSERT INTO resource_log VALUES (5468, 1230, 2, NULL, '2014-04-23 11:53:45.572462+03');
INSERT INTO resource_log VALUES (5537, 1306, 2, NULL, '2014-04-30 11:04:50.581045+03');
INSERT INTO resource_log VALUES (66, 16, 2, NULL, '2013-11-30 12:57:27.26941+02');
INSERT INTO resource_log VALUES (67, 31, 2, NULL, '2013-11-30 14:25:42.040654+02');
INSERT INTO resource_log VALUES (68, 32, 2, NULL, '2013-11-30 14:27:55.708736+02');
INSERT INTO resource_log VALUES (69, 33, 2, NULL, '2013-11-30 14:28:30.596329+02');
INSERT INTO resource_log VALUES (70, 34, 2, NULL, '2013-11-30 14:29:07.205192+02');
INSERT INTO resource_log VALUES (71, 35, 2, NULL, '2013-11-30 14:30:10.653134+02');
INSERT INTO resource_log VALUES (72, 36, 2, NULL, '2013-11-30 14:31:39.751221+02');
INSERT INTO resource_log VALUES (73, 37, 2, NULL, '2013-11-30 14:32:36.035677+02');
INSERT INTO resource_log VALUES (74, 38, 2, NULL, '2013-11-30 14:55:27.691288+02');
INSERT INTO resource_log VALUES (75, 39, 2, NULL, '2013-11-30 14:58:07.249714+02');
INSERT INTO resource_log VALUES (76, 40, 2, NULL, '2013-11-30 14:58:34.364695+02');
INSERT INTO resource_log VALUES (79, 43, 2, NULL, '2013-11-30 15:08:29.574538+02');
INSERT INTO resource_log VALUES (80, 43, 2, NULL, '2013-11-30 15:08:52.114395+02');
INSERT INTO resource_log VALUES (81, 43, 2, NULL, '2013-11-30 15:09:21.51485+02');
INSERT INTO resource_log VALUES (82, 44, 2, NULL, '2013-11-30 15:09:54.961188+02');
INSERT INTO resource_log VALUES (83, 45, 2, NULL, '2013-12-01 13:04:27.697583+02');
INSERT INTO resource_log VALUES (84, 45, 2, NULL, '2013-12-01 13:04:40.716328+02');
INSERT INTO resource_log VALUES (85, 14, 2, NULL, '2013-12-01 14:31:19.374571+02');
INSERT INTO resource_log VALUES (87, 12, 2, NULL, '2013-12-01 18:21:35.266219+02');
INSERT INTO resource_log VALUES (104, 10, 2, NULL, '2013-12-02 20:43:38.334769+02');
INSERT INTO resource_log VALUES (130, 10, 2, NULL, '2013-12-06 21:10:25.807719+02');
INSERT INTO resource_log VALUES (4796, 769, 2, NULL, '2014-01-22 22:21:45.451623+02');
INSERT INTO resource_log VALUES (4820, 16, 2, NULL, '2014-02-01 21:09:43.821944+02');
INSERT INTO resource_log VALUES (5408, 1192, 2, NULL, '2014-04-06 19:22:16.361504+03');
INSERT INTO resource_log VALUES (5409, 1005, 2, NULL, '2014-04-06 19:22:18.74271+03');
INSERT INTO resource_log VALUES (4822, 784, 2, NULL, '2014-02-01 21:23:07.460721+02');
INSERT INTO resource_log VALUES (4823, 786, 2, NULL, '2014-02-01 21:23:12.871915+02');
INSERT INTO resource_log VALUES (5410, 1193, 2, NULL, '2014-04-06 19:30:25.125445+03');
INSERT INTO resource_log VALUES (5411, 1194, 2, NULL, '2014-04-06 19:30:51.85642+03');
INSERT INTO resource_log VALUES (5412, 1195, 2, NULL, '2014-04-06 19:32:30.207073+03');
INSERT INTO resource_log VALUES (5428, 1205, 2, NULL, '2014-04-09 19:17:37.483997+03');
INSERT INTO resource_log VALUES (5431, 1209, 2, NULL, '2014-04-09 20:49:45.884539+03');
INSERT INTO resource_log VALUES (4843, 800, 2, NULL, '2014-02-05 19:58:31.619612+02');
INSERT INTO resource_log VALUES (4844, 801, 2, NULL, '2014-02-05 19:58:49.632624+02');
INSERT INTO resource_log VALUES (4951, 885, 2, NULL, '2014-02-14 21:23:40.101298+02');
INSERT INTO resource_log VALUES (4952, 885, 2, NULL, '2014-02-14 21:25:13.866935+02');
INSERT INTO resource_log VALUES (4974, 849, 2, NULL, '2014-02-23 22:41:46.113064+02');
INSERT INTO resource_log VALUES (4977, 884, 2, NULL, '2014-02-23 22:42:22.595852+02');
INSERT INTO resource_log VALUES (5143, 1003, 2, NULL, '2014-03-04 21:05:09.565466+02');
INSERT INTO resource_log VALUES (5144, 1004, 2, NULL, '2014-03-04 21:08:53.227171+02');
INSERT INTO resource_log VALUES (5145, 1005, 2, NULL, '2014-03-04 21:09:15.542733+02');
INSERT INTO resource_log VALUES (5471, 1240, 2, NULL, '2014-04-26 13:10:19.27836+03');
INSERT INTO resource_log VALUES (5538, 1307, 2, NULL, '2014-04-30 11:08:33.655971+03');
INSERT INTO resource_log VALUES (5544, 1313, 2, NULL, '2014-05-16 22:03:29.897662+03');
INSERT INTO resource_log VALUES (361, 274, 2, NULL, '2013-12-14 17:16:08.962259+02');
INSERT INTO resource_log VALUES (365, 277, 2, NULL, '2013-12-14 18:56:05.189747+02');
INSERT INTO resource_log VALUES (366, 278, 2, NULL, '2013-12-14 18:56:17.77025+02');
INSERT INTO resource_log VALUES (367, 279, 2, NULL, '2013-12-14 18:56:45.919492+02');
INSERT INTO resource_log VALUES (368, 280, 2, NULL, '2013-12-14 19:10:07.617582+02');
INSERT INTO resource_log VALUES (369, 281, 2, NULL, '2013-12-14 19:10:25.311427+02');
INSERT INTO resource_log VALUES (370, 281, 2, NULL, '2013-12-14 19:10:59.35028+02');
INSERT INTO resource_log VALUES (371, 281, 2, NULL, '2013-12-14 19:12:14.211139+02');
INSERT INTO resource_log VALUES (372, 282, 2, NULL, '2013-12-14 19:14:22.861495+02');
INSERT INTO resource_log VALUES (373, 278, 2, NULL, '2013-12-14 19:14:33.853691+02');
INSERT INTO resource_log VALUES (374, 282, 2, NULL, '2013-12-14 19:14:41.964012+02');
INSERT INTO resource_log VALUES (375, 283, 2, NULL, '2013-12-14 19:16:35.738242+02');
INSERT INTO resource_log VALUES (4882, 706, 2, NULL, '2014-02-08 19:59:59.160282+02');
INSERT INTO resource_log VALUES (377, 283, 2, NULL, '2013-12-14 19:18:21.622933+02');
INSERT INTO resource_log VALUES (4953, 886, 2, NULL, '2014-02-14 21:25:53.089098+02');
INSERT INTO resource_log VALUES (4978, 893, 2, NULL, '2014-02-24 11:11:03.613711+02');
INSERT INTO resource_log VALUES (5147, 1004, 2, NULL, '2014-03-04 21:17:22.306545+02');
INSERT INTO resource_log VALUES (5148, 1004, 2, NULL, '2014-03-04 21:23:04.343461+02');
INSERT INTO resource_log VALUES (386, 286, 2, NULL, '2013-12-14 20:46:34.653533+02');
INSERT INTO resource_log VALUES (387, 287, 2, NULL, '2013-12-14 20:46:47.37835+02');
INSERT INTO resource_log VALUES (388, 288, 2, NULL, '2013-12-14 20:47:08.024243+02');
INSERT INTO resource_log VALUES (389, 289, 2, NULL, '2013-12-14 20:47:28.256516+02');
INSERT INTO resource_log VALUES (390, 290, 2, NULL, '2013-12-14 20:52:40.953492+02');
INSERT INTO resource_log VALUES (391, 291, 2, NULL, '2013-12-14 20:53:08.057165+02');
INSERT INTO resource_log VALUES (392, 292, 2, NULL, '2013-12-14 20:53:33.598708+02');
INSERT INTO resource_log VALUES (5149, 1004, 2, NULL, '2014-03-04 21:23:17.093243+02');
INSERT INTO resource_log VALUES (5150, 1004, 2, NULL, '2014-03-04 21:23:25.611509+02');
INSERT INTO resource_log VALUES (4799, 771, 2, NULL, '2014-01-25 16:05:28.799345+02');
INSERT INTO resource_log VALUES (4800, 771, 2, NULL, '2014-01-25 16:05:38.705799+02');
INSERT INTO resource_log VALUES (4801, 772, 2, NULL, '2014-01-25 16:06:28.321244+02');
INSERT INTO resource_log VALUES (4826, 788, 2, NULL, '2014-02-01 22:03:21.899916+02');
INSERT INTO resource_log VALUES (5151, 1004, 2, NULL, '2014-03-04 21:23:52.466966+02');
INSERT INTO resource_log VALUES (5152, 1004, 2, NULL, '2014-03-04 21:24:11.351815+02');
INSERT INTO resource_log VALUES (5153, 1004, 2, NULL, '2014-03-04 21:24:20.614224+02');
INSERT INTO resource_log VALUES (5429, 1206, 2, NULL, '2014-04-09 19:21:09.215561+03');
INSERT INTO resource_log VALUES (5154, 1004, 2, NULL, '2014-03-04 21:35:47.600889+02');
INSERT INTO resource_log VALUES (5155, 1004, 2, NULL, '2014-03-04 21:36:05.835492+02');
INSERT INTO resource_log VALUES (5156, 1004, 2, NULL, '2014-03-04 21:36:16.322673+02');
INSERT INTO resource_log VALUES (5432, 1210, 2, NULL, '2014-04-12 13:10:08.842351+03');
INSERT INTO resource_log VALUES (5472, 1241, 2, NULL, '2014-04-26 19:16:28.009797+03');
INSERT INTO resource_log VALUES (5539, 1308, 2, NULL, '2014-04-30 11:20:34.938154+03');
INSERT INTO resource_log VALUES (5545, 1314, 2, NULL, '2014-05-17 13:42:16.369317+03');
INSERT INTO resource_log VALUES (422, 306, 2, NULL, '2013-12-15 21:45:32.990838+02');
INSERT INTO resource_log VALUES (4802, 773, 2, NULL, '2014-01-25 23:45:37.762081+02');
INSERT INTO resource_log VALUES (4827, 789, 2, NULL, '2014-02-02 16:45:11.830435+02');
INSERT INTO resource_log VALUES (4954, 887, 2, NULL, '2014-02-15 12:32:09.199652+02');
INSERT INTO resource_log VALUES (5415, 1198, 2, NULL, '2014-04-08 09:35:59.21042+03');
INSERT INTO resource_log VALUES (4979, 885, 2, NULL, '2014-02-24 12:50:26.694026+02');
INSERT INTO resource_log VALUES (4980, 786, 2, NULL, '2014-02-24 12:50:29.953348+02');
INSERT INTO resource_log VALUES (4981, 784, 2, NULL, '2014-02-24 12:50:33.322359+02');
INSERT INTO resource_log VALUES (5157, 1004, 2, NULL, '2014-03-07 22:30:15.652582+02');
INSERT INTO resource_log VALUES (5230, 894, 2, NULL, '2014-03-16 11:54:19.683752+02');
INSERT INTO resource_log VALUES (5231, 894, 2, NULL, '2014-03-16 11:54:28.171778+02');
INSERT INTO resource_log VALUES (5232, 894, 2, NULL, '2014-03-16 11:54:33.774318+02');
INSERT INTO resource_log VALUES (5270, 1004, 2, NULL, '2014-03-17 10:50:39.781432+02');
INSERT INTO resource_log VALUES (5465, 1230, 2, NULL, '2014-04-19 21:03:03.225866+03');
INSERT INTO resource_log VALUES (5508, 1277, 2, NULL, '2014-04-29 10:08:17.485661+03');
INSERT INTO resource_log VALUES (5509, 1278, 2, NULL, '2014-04-29 10:09:19.421905+03');
INSERT INTO resource_log VALUES (5540, 1309, 2, NULL, '2014-04-30 11:32:51.070911+03');
INSERT INTO resource_log VALUES (5547, 1316, 2, NULL, '2014-05-17 14:00:25.111543+03');
INSERT INTO resource_log VALUES (4927, 865, 2, NULL, '2014-02-09 13:26:19.008763+02');
INSERT INTO resource_log VALUES (4804, 775, 2, NULL, '2014-01-26 15:30:50.636495+02');
INSERT INTO resource_log VALUES (4828, 3, 2, NULL, '2014-02-02 17:45:50.239397+02');
INSERT INTO resource_log VALUES (5416, 1199, 2, NULL, '2014-04-08 10:15:32.411146+03');
INSERT INTO resource_log VALUES (5434, 1211, 2, NULL, '2014-04-12 14:16:34.33498+03');
INSERT INTO resource_log VALUES (5435, 1211, 2, NULL, '2014-04-12 14:16:53.40729+03');
INSERT INTO resource_log VALUES (4982, 895, 2, NULL, '2014-02-25 19:06:42.158245+02');
INSERT INTO resource_log VALUES (5158, 1007, 2, NULL, '2014-03-08 10:30:25.61786+02');
INSERT INTO resource_log VALUES (5198, 3, 2, NULL, '2014-03-11 13:14:05.142514+02');
INSERT INTO resource_log VALUES (5233, 1060, 2, NULL, '2014-03-16 12:26:38.52955+02');
INSERT INTO resource_log VALUES (5437, 1213, 2, NULL, '2014-04-12 14:32:08.840037+03');
INSERT INTO resource_log VALUES (5466, 1227, 2, NULL, '2014-04-19 21:37:55.580038+03');
INSERT INTO resource_log VALUES (5474, 1243, 2, NULL, '2014-04-26 22:38:44.326007+03');
INSERT INTO resource_log VALUES (5541, 1310, 2, NULL, '2014-04-30 22:45:27.579715+03');
INSERT INTO resource_log VALUES (5548, 1317, 2, NULL, '2014-05-17 14:54:57.813145+03');
INSERT INTO resource_log VALUES (5549, 1318, 2, NULL, '2014-05-17 15:24:32.954365+03');
INSERT INTO resource_log VALUES (5550, 1319, 2, NULL, '2014-05-17 15:53:28.880817+03');
INSERT INTO resource_log VALUES (5551, 1320, 2, NULL, '2014-05-17 15:53:34.139717+03');
INSERT INTO resource_log VALUES (5552, 1321, 2, NULL, '2014-05-17 15:55:03.155317+03');
INSERT INTO resource_log VALUES (5553, 1322, 2, NULL, '2014-05-17 15:55:07.534203+03');
INSERT INTO resource_log VALUES (5557, 1326, 2, NULL, '2014-05-17 15:59:13.891973+03');
INSERT INTO resource_log VALUES (5558, 1327, 2, NULL, '2014-05-17 15:59:17.045556+03');
INSERT INTO resource_log VALUES (5559, 1328, 2, NULL, '2014-05-17 16:00:04.660539+03');
INSERT INTO resource_log VALUES (5560, 1329, 2, NULL, '2014-05-17 16:00:08.901641+03');
INSERT INTO resource_log VALUES (5561, 1330, 2, NULL, '2014-05-17 16:00:10.337355+03');
INSERT INTO resource_log VALUES (5566, 1335, 2, NULL, '2014-05-17 16:02:19.447311+03');
INSERT INTO resource_log VALUES (5570, 1339, 2, NULL, '2014-05-17 16:06:26.675372+03');
INSERT INTO resource_log VALUES (5571, 1340, 2, NULL, '2014-05-17 16:06:28.503991+03');
INSERT INTO resource_log VALUES (5572, 1341, 2, NULL, '2014-05-17 16:06:29.727144+03');
INSERT INTO resource_log VALUES (5573, 1342, 2, NULL, '2014-05-17 16:06:31.81672+03');
INSERT INTO resource_log VALUES (5574, 1343, 2, NULL, '2014-05-17 16:07:44.265465+03');
INSERT INTO resource_log VALUES (5575, 1344, 2, NULL, '2014-05-17 16:07:45.972655+03');
INSERT INTO resource_log VALUES (5576, 1345, 2, NULL, '2014-05-17 16:07:47.259172+03');
INSERT INTO resource_log VALUES (5577, 1346, 2, NULL, '2014-05-17 16:07:49.146563+03');
INSERT INTO resource_log VALUES (5581, 1350, 2, NULL, '2014-05-17 16:09:55.923893+03');
INSERT INTO resource_log VALUES (5582, 1351, 2, NULL, '2014-05-17 16:13:13.017272+03');
INSERT INTO resource_log VALUES (5583, 1352, 2, NULL, '2014-05-17 16:13:14.609527+03');
INSERT INTO resource_log VALUES (5584, 1353, 2, NULL, '2014-05-17 16:13:16.568079+03');
INSERT INTO resource_log VALUES (5585, 1354, 2, NULL, '2014-05-17 16:13:17.732756+03');
INSERT INTO resource_log VALUES (5370, 1159, 2, NULL, '2014-04-02 19:52:15.193771+03');
INSERT INTO resource_log VALUES (4888, 786, 2, NULL, '2014-02-08 21:26:45.138217+02');
INSERT INTO resource_log VALUES (5417, 1200, 2, NULL, '2014-04-08 10:35:59.014802+03');
INSERT INTO resource_log VALUES (4890, 784, 2, NULL, '2014-02-08 21:26:51.98617+02');
INSERT INTO resource_log VALUES (4929, 870, 2, NULL, '2014-02-09 14:57:54.403714+02');
INSERT INTO resource_log VALUES (4967, 892, 2, NULL, '2014-02-22 17:14:02.512772+02');
INSERT INTO resource_log VALUES (4983, 896, 2, NULL, '2014-02-25 19:37:56.226615+02');
INSERT INTO resource_log VALUES (4984, 897, 2, NULL, '2014-02-25 19:38:21.395798+02');
INSERT INTO resource_log VALUES (4985, 898, 2, NULL, '2014-02-25 19:38:30.353048+02');
INSERT INTO resource_log VALUES (4986, 899, 2, NULL, '2014-02-25 19:39:23.588225+02');
INSERT INTO resource_log VALUES (4988, 901, 2, NULL, '2014-02-25 19:47:57.884012+02');
INSERT INTO resource_log VALUES (5160, 1009, 2, NULL, '2014-03-08 10:49:52.0599+02');
INSERT INTO resource_log VALUES (5199, 3, 2, NULL, '2014-03-12 12:05:31.953558+02');
INSERT INTO resource_log VALUES (5438, 1214, 2, NULL, '2014-04-12 14:36:07.046988+03');
INSERT INTO resource_log VALUES (5475, 1244, 2, NULL, '2014-04-26 22:39:00.40778+03');
INSERT INTO resource_log VALUES (5542, 1311, 2, NULL, '2014-04-30 22:45:36.089534+03');
INSERT INTO resource_log VALUES (5554, 1323, 2, NULL, '2014-05-17 15:55:54.008685+03');
INSERT INTO resource_log VALUES (5555, 1324, 2, NULL, '2014-05-17 15:56:55.63522+03');
INSERT INTO resource_log VALUES (5556, 1325, 2, NULL, '2014-05-17 15:58:29.508912+03');
INSERT INTO resource_log VALUES (5562, 1331, 2, NULL, '2014-05-17 16:00:49.21287+03');
INSERT INTO resource_log VALUES (5563, 1332, 2, NULL, '2014-05-17 16:01:46.175183+03');
INSERT INTO resource_log VALUES (5564, 1333, 2, NULL, '2014-05-17 16:01:47.950656+03');
INSERT INTO resource_log VALUES (5565, 1334, 2, NULL, '2014-05-17 16:01:48.837764+03');
INSERT INTO resource_log VALUES (5567, 1336, 2, NULL, '2014-05-17 16:03:41.796945+03');
INSERT INTO resource_log VALUES (5568, 1337, 2, NULL, '2014-05-17 16:04:32.839289+03');
INSERT INTO resource_log VALUES (5569, 1338, 2, NULL, '2014-05-17 16:04:34.363533+03');
INSERT INTO resource_log VALUES (5578, 1347, 2, NULL, '2014-05-17 16:08:39.18466+03');
INSERT INTO resource_log VALUES (5579, 1348, 2, NULL, '2014-05-17 16:08:56.863828+03');
INSERT INTO resource_log VALUES (5580, 1349, 2, NULL, '2014-05-17 16:08:58.291349+03');
INSERT INTO resource_log VALUES (4894, 849, 2, NULL, '2014-02-08 21:32:14.802948+02');
INSERT INTO resource_log VALUES (4896, 851, 2, NULL, '2014-02-08 21:32:32.471247+02');
INSERT INTO resource_log VALUES (4897, 852, 2, NULL, '2014-02-08 21:36:44.493917+02');
INSERT INTO resource_log VALUES (4930, 871, 2, NULL, '2014-02-09 16:04:05.85568+02');
INSERT INTO resource_log VALUES (4968, 892, 2, NULL, '2014-02-22 17:18:17.771894+02');
INSERT INTO resource_log VALUES (5161, 1009, 2, NULL, '2014-03-08 10:52:32.854366+02');
INSERT INTO resource_log VALUES (5162, 1009, 2, NULL, '2014-03-08 10:52:45.635015+02');
INSERT INTO resource_log VALUES (5163, 1009, 2, NULL, '2014-03-08 10:52:53.515357+02');
INSERT INTO resource_log VALUES (5164, 1009, 2, NULL, '2014-03-08 10:52:58.740536+02');
INSERT INTO resource_log VALUES (5165, 1010, 2, NULL, '2014-03-08 10:54:40.946487+02');
INSERT INTO resource_log VALUES (5166, 1010, 2, NULL, '2014-03-08 10:54:50.928085+02');
INSERT INTO resource_log VALUES (5200, 3, 2, NULL, '2014-03-12 12:14:05.203771+02');
INSERT INTO resource_log VALUES (5235, 897, 2, NULL, '2014-03-16 12:53:37.56753+02');
INSERT INTO resource_log VALUES (5278, 1067, 2, NULL, '2014-03-18 19:51:01.87448+02');
INSERT INTO resource_log VALUES (5375, 1164, 2, NULL, '2014-04-02 20:56:42.084197+03');
INSERT INTO resource_log VALUES (5376, 1165, 2, NULL, '2014-04-02 20:56:48.393173+03');
INSERT INTO resource_log VALUES (5419, 1201, 2, NULL, '2014-04-08 10:38:31.154572+03');
INSERT INTO resource_log VALUES (5440, 1214, 2, NULL, '2014-04-12 14:39:05.532456+03');
INSERT INTO resource_log VALUES (5442, 1214, 2, NULL, '2014-04-12 14:43:11.754556+03');
INSERT INTO resource_log VALUES (5513, 1282, 2, NULL, '2014-04-29 10:43:05.718429+03');
INSERT INTO resource_log VALUES (5586, 1355, 2, NULL, '2014-05-17 16:14:39.7443+03');
INSERT INTO resource_log VALUES (5587, 1356, 2, NULL, '2014-05-17 16:14:41.182697+03');
INSERT INTO resource_log VALUES (5588, 1357, 2, NULL, '2014-05-17 16:14:43.239633+03');
INSERT INTO resource_log VALUES (5590, 1359, 2, NULL, '2014-05-17 16:15:43.442935+03');
INSERT INTO resource_log VALUES (5591, 1360, 2, NULL, '2014-05-17 16:15:45.790483+03');
INSERT INTO resource_log VALUES (5596, 1365, 2, NULL, '2014-05-17 16:20:21.389915+03');
INSERT INTO resource_log VALUES (5597, 1366, 2, NULL, '2014-05-17 16:20:22.473385+03');
INSERT INTO resource_log VALUES (5598, 1367, 2, NULL, '2014-05-17 16:20:23.843632+03');
INSERT INTO resource_log VALUES (4898, 853, 2, NULL, '2014-02-08 21:39:09.10029+02');
INSERT INTO resource_log VALUES (4812, 784, 2, NULL, '2014-01-26 21:12:24.209136+02');
INSERT INTO resource_log VALUES (4813, 784, 2, NULL, '2014-01-26 21:13:10.546575+02');
INSERT INTO resource_log VALUES (4814, 784, 2, NULL, '2014-01-26 21:13:20.058093+02');
INSERT INTO resource_log VALUES (4815, 784, 2, NULL, '2014-01-26 21:13:24.693933+02');
INSERT INTO resource_log VALUES (4817, 786, 2, NULL, '2014-01-26 21:15:00.370561+02');
INSERT INTO resource_log VALUES (4818, 784, 2, NULL, '2014-01-26 21:20:14.635984+02');
INSERT INTO resource_log VALUES (4819, 784, 2, NULL, '2014-01-26 21:20:34.941868+02');
INSERT INTO resource_log VALUES (4931, 274, 2, NULL, '2014-02-10 08:49:31.501202+02');
INSERT INTO resource_log VALUES (4969, 893, 2, NULL, '2014-02-22 17:26:37.296722+02');
INSERT INTO resource_log VALUES (4970, 894, 2, NULL, '2014-02-22 17:27:40.771678+02');
INSERT INTO resource_log VALUES (4991, 903, 2, NULL, '2014-02-25 22:43:46.101171+02');
INSERT INTO resource_log VALUES (4992, 904, 2, NULL, '2014-02-25 22:43:53.30222+02');
INSERT INTO resource_log VALUES (4993, 905, 2, NULL, '2014-02-25 22:44:00.024066+02');
INSERT INTO resource_log VALUES (4994, 906, 2, NULL, '2014-02-25 22:44:13.035203+02');
INSERT INTO resource_log VALUES (4995, 907, 2, NULL, '2014-02-25 22:44:59.159297+02');
INSERT INTO resource_log VALUES (5167, 1009, 2, NULL, '2014-03-08 10:57:02.535973+02');
INSERT INTO resource_log VALUES (5168, 1010, 2, NULL, '2014-03-08 10:57:07.365849+02');
INSERT INTO resource_log VALUES (5201, 3, 2, NULL, '2014-03-12 12:29:57.686858+02');
INSERT INTO resource_log VALUES (5202, 3, 2, NULL, '2014-03-12 12:30:07.270368+02');
INSERT INTO resource_log VALUES (5203, 3, 2, NULL, '2014-03-12 12:30:09.982217+02');
INSERT INTO resource_log VALUES (5204, 3, 2, NULL, '2014-03-12 12:32:22.25189+02');
INSERT INTO resource_log VALUES (5205, 894, 2, NULL, '2014-03-12 12:32:26.366205+02');
INSERT INTO resource_log VALUES (5236, 919, 2, NULL, '2014-03-16 13:33:07.651832+02');
INSERT INTO resource_log VALUES (5444, 1218, 2, NULL, '2014-04-12 15:00:38.646853+03');
INSERT INTO resource_log VALUES (5447, 1214, 2, NULL, '2014-04-12 15:02:33.59771+03');
INSERT INTO resource_log VALUES (5514, 1283, 2, NULL, '2014-04-29 12:06:08.689068+03');
INSERT INTO resource_log VALUES (5515, 1284, 2, NULL, '2014-04-29 12:07:06.357367+03');
INSERT INTO resource_log VALUES (5518, 1287, 2, NULL, '2014-04-29 12:09:55.486785+03');
INSERT INTO resource_log VALUES (5520, 1289, 2, NULL, '2014-04-29 12:11:36.874588+03');
INSERT INTO resource_log VALUES (5589, 1358, 2, NULL, '2014-05-17 16:15:09.836615+03');
INSERT INTO resource_log VALUES (5592, 1361, 2, NULL, '2014-05-17 16:16:33.155307+03');
INSERT INTO resource_log VALUES (5593, 1362, 2, NULL, '2014-05-17 16:16:42.585648+03');
INSERT INTO resource_log VALUES (5594, 1363, 2, NULL, '2014-05-17 16:18:45.312153+03');
INSERT INTO resource_log VALUES (5595, 1364, 2, NULL, '2014-05-17 16:18:46.752544+03');
INSERT INTO resource_log VALUES (4932, 872, 2, NULL, '2014-02-10 14:29:53.759164+02');
INSERT INTO resource_log VALUES (4996, 908, 2, NULL, '2014-02-25 23:15:44.304324+02');
INSERT INTO resource_log VALUES (4997, 909, 2, NULL, '2014-02-25 23:16:53.455486+02');
INSERT INTO resource_log VALUES (5000, 912, 2, NULL, '2014-02-25 23:21:05.038132+02');
INSERT INTO resource_log VALUES (5001, 913, 2, NULL, '2014-02-25 23:21:10.720503+02');
INSERT INTO resource_log VALUES (5002, 914, 2, NULL, '2014-02-25 23:21:15.803027+02');
INSERT INTO resource_log VALUES (5003, 915, 2, NULL, '2014-02-25 23:21:21.245593+02');
INSERT INTO resource_log VALUES (5004, 916, 2, NULL, '2014-02-25 23:21:27.843749+02');
INSERT INTO resource_log VALUES (5005, 917, 2, NULL, '2014-02-25 23:21:40.705852+02');
INSERT INTO resource_log VALUES (5006, 918, 2, NULL, '2014-02-25 23:21:45.161533+02');
INSERT INTO resource_log VALUES (5007, 918, 2, NULL, '2014-02-25 23:21:53.74917+02');
INSERT INTO resource_log VALUES (5008, 918, 2, NULL, '2014-02-25 23:21:57.599668+02');
INSERT INTO resource_log VALUES (5009, 919, 2, NULL, '2014-02-25 23:22:22.789803+02');
INSERT INTO resource_log VALUES (5011, 921, 2, NULL, '2014-02-25 23:22:59.534922+02');
INSERT INTO resource_log VALUES (5012, 922, 2, NULL, '2014-02-25 23:23:04.765473+02');
INSERT INTO resource_log VALUES (5013, 923, 2, NULL, '2014-02-25 23:23:16.649188+02');
INSERT INTO resource_log VALUES (5014, 924, 2, NULL, '2014-02-25 23:23:30.151925+02');
INSERT INTO resource_log VALUES (5015, 925, 2, NULL, '2014-02-25 23:25:11.120354+02');
INSERT INTO resource_log VALUES (5016, 926, 2, NULL, '2014-02-25 23:26:11.314153+02');
INSERT INTO resource_log VALUES (5017, 927, 2, NULL, '2014-02-25 23:26:34.378644+02');
INSERT INTO resource_log VALUES (5018, 928, 2, NULL, '2014-02-25 23:26:49.163639+02');
INSERT INTO resource_log VALUES (5019, 929, 2, NULL, '2014-02-25 23:27:07.84413+02');
INSERT INTO resource_log VALUES (5020, 930, 2, NULL, '2014-02-25 23:27:30.797684+02');
INSERT INTO resource_log VALUES (5021, 931, 2, NULL, '2014-02-25 23:27:45.611037+02');
INSERT INTO resource_log VALUES (5022, 932, 2, NULL, '2014-02-25 23:28:05.678992+02');
INSERT INTO resource_log VALUES (5023, 933, 2, NULL, '2014-02-25 23:28:21.001129+02');
INSERT INTO resource_log VALUES (5025, 935, 2, NULL, '2014-02-25 23:28:49.565248+02');
INSERT INTO resource_log VALUES (5026, 936, 2, NULL, '2014-02-25 23:29:05.034117+02');
INSERT INTO resource_log VALUES (5027, 937, 2, NULL, '2014-02-25 23:29:16.11101+02');
INSERT INTO resource_log VALUES (5028, 938, 2, NULL, '2014-02-25 23:29:28.82178+02');
INSERT INTO resource_log VALUES (5029, 939, 2, NULL, '2014-02-25 23:29:41.159219+02');
INSERT INTO resource_log VALUES (5030, 940, 2, NULL, '2014-02-25 23:29:57.589154+02');
INSERT INTO resource_log VALUES (5031, 941, 2, NULL, '2014-02-25 23:30:12.260571+02');
INSERT INTO resource_log VALUES (5032, 942, 2, NULL, '2014-02-25 23:30:25.705958+02');
INSERT INTO resource_log VALUES (5033, 943, 2, NULL, '2014-02-25 23:30:39.278491+02');
INSERT INTO resource_log VALUES (5034, 944, 2, NULL, '2014-02-25 23:30:54.230938+02');
INSERT INTO resource_log VALUES (5035, 945, 2, NULL, '2014-02-25 23:31:08.136642+02');
INSERT INTO resource_log VALUES (5036, 946, 2, NULL, '2014-02-25 23:31:21.084682+02');
INSERT INTO resource_log VALUES (5037, 947, 2, NULL, '2014-02-25 23:31:35.443235+02');
INSERT INTO resource_log VALUES (5038, 948, 2, NULL, '2014-02-25 23:31:50.036032+02');
INSERT INTO resource_log VALUES (5039, 949, 2, NULL, '2014-02-25 23:32:16.232207+02');
INSERT INTO resource_log VALUES (5040, 950, 2, NULL, '2014-02-25 23:32:51.784126+02');
INSERT INTO resource_log VALUES (5169, 1011, 2, NULL, '2014-03-08 15:10:44.638516+02');
INSERT INTO resource_log VALUES (5206, 3, 2, NULL, '2014-03-12 13:00:24.217557+02');
INSERT INTO resource_log VALUES (5207, 3, 2, NULL, '2014-03-12 13:00:34.025605+02');
INSERT INTO resource_log VALUES (5238, 1062, 2, NULL, '2014-03-16 15:10:44.294343+02');
INSERT INTO resource_log VALUES (5239, 1062, 2, NULL, '2014-03-16 15:11:01.269428+02');
INSERT INTO resource_log VALUES (5240, 858, 2, NULL, '2014-03-16 15:11:06.875279+02');
INSERT INTO resource_log VALUES (5241, 903, 2, NULL, '2014-03-16 15:12:25.130202+02');
INSERT INTO resource_log VALUES (5379, 1168, 2, NULL, '2014-04-03 12:39:52.988369+03');
INSERT INTO resource_log VALUES (5380, 1169, 2, NULL, '2014-04-03 12:49:06.139328+03');
INSERT INTO resource_log VALUES (5448, 1221, 2, NULL, '2014-04-12 16:44:14.810824+03');
INSERT INTO resource_log VALUES (5516, 1285, 2, NULL, '2014-04-29 12:08:23.116251+03');
INSERT INTO resource_log VALUES (5517, 1286, 2, NULL, '2014-04-29 12:09:10.712444+03');
INSERT INTO resource_log VALUES (5522, 1291, 2, NULL, '2014-04-29 12:13:37.203069+03');
INSERT INTO resource_log VALUES (5523, 1292, 2, NULL, '2014-04-29 12:14:34.180203+03');
INSERT INTO resource_log VALUES (4900, 854, 2, NULL, '2014-02-08 21:47:34.439997+02');
INSERT INTO resource_log VALUES (4901, 855, 2, NULL, '2014-02-08 21:54:55.399628+02');
INSERT INTO resource_log VALUES (4936, 875, 2, NULL, '2014-02-10 15:58:53.177719+02');
INSERT INTO resource_log VALUES (4937, 875, 2, NULL, '2014-02-10 15:59:03.43204+02');
INSERT INTO resource_log VALUES (5042, 952, 2, NULL, '2014-02-25 23:33:14.57009+02');
INSERT INTO resource_log VALUES (5043, 939, 2, NULL, '2014-02-25 23:33:37.281163+02');
INSERT INTO resource_log VALUES (5044, 938, 2, NULL, '2014-02-25 23:33:44.033176+02');
INSERT INTO resource_log VALUES (5045, 937, 2, NULL, '2014-02-25 23:33:51.697991+02');
INSERT INTO resource_log VALUES (5046, 936, 2, NULL, '2014-02-25 23:33:56.981908+02');
INSERT INTO resource_log VALUES (5047, 935, 2, NULL, '2014-02-25 23:34:03.037741+02');
INSERT INTO resource_log VALUES (5049, 933, 2, NULL, '2014-02-25 23:34:27.937885+02');
INSERT INTO resource_log VALUES (5050, 932, 2, NULL, '2014-02-25 23:34:34.767736+02');
INSERT INTO resource_log VALUES (5051, 931, 2, NULL, '2014-02-25 23:34:39.075165+02');
INSERT INTO resource_log VALUES (5052, 930, 2, NULL, '2014-02-25 23:34:43.896812+02');
INSERT INTO resource_log VALUES (5053, 929, 2, NULL, '2014-02-25 23:34:48.70472+02');
INSERT INTO resource_log VALUES (5054, 928, 2, NULL, '2014-02-25 23:34:54.494127+02');
INSERT INTO resource_log VALUES (5055, 927, 2, NULL, '2014-02-25 23:35:00.125101+02');
INSERT INTO resource_log VALUES (5056, 926, 2, NULL, '2014-02-25 23:35:05.399995+02');
INSERT INTO resource_log VALUES (5057, 925, 2, NULL, '2014-02-25 23:35:10.409443+02');
INSERT INTO resource_log VALUES (5058, 924, 2, NULL, '2014-02-25 23:35:16.447517+02');
INSERT INTO resource_log VALUES (5059, 923, 2, NULL, '2014-02-25 23:35:21.959285+02');
INSERT INTO resource_log VALUES (5060, 922, 2, NULL, '2014-02-25 23:35:27.383937+02');
INSERT INTO resource_log VALUES (5061, 921, 2, NULL, '2014-02-25 23:35:31.660307+02');
INSERT INTO resource_log VALUES (5063, 919, 2, NULL, '2014-02-25 23:35:43.645366+02');
INSERT INTO resource_log VALUES (5064, 918, 2, NULL, '2014-02-25 23:35:47.480218+02');
INSERT INTO resource_log VALUES (5065, 917, 2, NULL, '2014-02-25 23:35:52.042922+02');
INSERT INTO resource_log VALUES (5066, 916, 2, NULL, '2014-02-25 23:35:57.409224+02');
INSERT INTO resource_log VALUES (5067, 915, 2, NULL, '2014-02-25 23:36:01.802966+02');
INSERT INTO resource_log VALUES (5068, 914, 2, NULL, '2014-02-25 23:36:05.670476+02');
INSERT INTO resource_log VALUES (5069, 913, 2, NULL, '2014-02-25 23:36:10.129284+02');
INSERT INTO resource_log VALUES (5070, 912, 2, NULL, '2014-02-25 23:36:14.468359+02');
INSERT INTO resource_log VALUES (5208, 1040, 2, NULL, '2014-03-12 20:50:33.871251+02');
INSERT INTO resource_log VALUES (5209, 1041, 2, NULL, '2014-03-12 20:50:55.466763+02');
INSERT INTO resource_log VALUES (5210, 1041, 2, NULL, '2014-03-12 20:51:02.123714+02');
INSERT INTO resource_log VALUES (5211, 1042, 2, NULL, '2014-03-12 20:53:03.003465+02');
INSERT INTO resource_log VALUES (5212, 1043, 2, NULL, '2014-03-12 20:53:27.910983+02');
INSERT INTO resource_log VALUES (5213, 1044, 2, NULL, '2014-03-12 20:53:45.921718+02');
INSERT INTO resource_log VALUES (5214, 1045, 2, NULL, '2014-03-12 20:54:23.054095+02');
INSERT INTO resource_log VALUES (5215, 1046, 2, NULL, '2014-03-12 20:55:03.071619+02');
INSERT INTO resource_log VALUES (5286, 1078, 2, NULL, '2014-03-20 21:22:51.030666+02');
INSERT INTO resource_log VALUES (5381, 1170, 2, NULL, '2014-04-03 12:49:07.793292+03');
INSERT INTO resource_log VALUES (5519, 1288, 2, NULL, '2014-04-29 12:10:21.572462+03');
INSERT INTO resource_log VALUES (5521, 1290, 2, NULL, '2014-04-29 12:13:35.434847+03');
INSERT INTO resource_log VALUES (5603, 1372, 2, NULL, '2014-05-17 18:47:30.594446+03');
INSERT INTO resource_log VALUES (5606, 1375, 2, NULL, '2014-05-17 18:55:21.896666+03');
INSERT INTO resource_log VALUES (5613, 1382, 2, NULL, '2014-05-17 19:04:51.767284+03');
INSERT INTO resource_log VALUES (5619, 1388, 2, NULL, '2014-05-17 19:09:44.578209+03');
INSERT INTO resource_log VALUES (5622, 1391, 2, NULL, '2014-05-17 19:12:29.996417+03');
INSERT INTO resource_log VALUES (4902, 856, 2, NULL, '2014-02-08 21:59:04.719245+02');
INSERT INTO resource_log VALUES (4938, 876, 2, NULL, '2014-02-10 16:19:24.400952+02');
INSERT INTO resource_log VALUES (5071, 953, 2, NULL, '2014-02-26 23:25:15.548581+02');
INSERT INTO resource_log VALUES (5072, 954, 2, NULL, '2014-02-26 23:25:55.407709+02');
INSERT INTO resource_log VALUES (5075, 957, 2, NULL, '2014-02-26 23:28:34.003373+02');
INSERT INTO resource_log VALUES (5076, 958, 2, NULL, '2014-02-26 23:28:45.594179+02');
INSERT INTO resource_log VALUES (5077, 959, 2, NULL, '2014-02-26 23:28:57.004231+02');
INSERT INTO resource_log VALUES (5078, 960, 2, NULL, '2014-02-26 23:29:08.086342+02');
INSERT INTO resource_log VALUES (5079, 961, 2, NULL, '2014-02-26 23:29:17.646283+02');
INSERT INTO resource_log VALUES (5080, 962, 2, NULL, '2014-02-26 23:29:26.175631+02');
INSERT INTO resource_log VALUES (5081, 963, 2, NULL, '2014-02-26 23:29:35.761623+02');
INSERT INTO resource_log VALUES (5082, 964, 2, NULL, '2014-02-26 23:29:46.892804+02');
INSERT INTO resource_log VALUES (5083, 965, 2, NULL, '2014-02-26 23:29:54.140342+02');
INSERT INTO resource_log VALUES (5084, 966, 2, NULL, '2014-02-26 23:30:01.375033+02');
INSERT INTO resource_log VALUES (5085, 967, 2, NULL, '2014-02-26 23:30:08.774222+02');
INSERT INTO resource_log VALUES (5086, 968, 2, NULL, '2014-02-26 23:30:17.802323+02');
INSERT INTO resource_log VALUES (5087, 969, 2, NULL, '2014-02-26 23:30:29.097872+02');
INSERT INTO resource_log VALUES (5088, 970, 2, NULL, '2014-02-26 23:30:38.081009+02');
INSERT INTO resource_log VALUES (5089, 971, 2, NULL, '2014-02-26 23:30:52.902609+02');
INSERT INTO resource_log VALUES (5091, 973, 2, NULL, '2014-02-26 23:31:31.71567+02');
INSERT INTO resource_log VALUES (5093, 975, 2, NULL, '2014-02-26 23:32:13.646357+02');
INSERT INTO resource_log VALUES (5094, 976, 2, NULL, '2014-02-26 23:32:24.624636+02');
INSERT INTO resource_log VALUES (5095, 977, 2, NULL, '2014-02-26 23:32:34.606814+02');
INSERT INTO resource_log VALUES (5096, 978, 2, NULL, '2014-02-26 23:32:43.318943+02');
INSERT INTO resource_log VALUES (5097, 979, 2, NULL, '2014-02-26 23:32:54.081989+02');
INSERT INTO resource_log VALUES (5098, 980, 2, NULL, '2014-02-26 23:33:04.823892+02');
INSERT INTO resource_log VALUES (5099, 981, 2, NULL, '2014-02-26 23:33:16.574818+02');
INSERT INTO resource_log VALUES (5100, 982, 2, NULL, '2014-02-26 23:33:28.270884+02');
INSERT INTO resource_log VALUES (5101, 983, 2, NULL, '2014-02-26 23:33:40.854578+02');
INSERT INTO resource_log VALUES (5102, 984, 2, NULL, '2014-02-26 23:33:57.05943+02');
INSERT INTO resource_log VALUES (5103, 985, 2, NULL, '2014-02-26 23:34:08.238483+02');
INSERT INTO resource_log VALUES (5105, 987, 2, NULL, '2014-02-26 23:34:29.757456+02');
INSERT INTO resource_log VALUES (5106, 988, 2, NULL, '2014-02-26 23:34:37.99873+02');
INSERT INTO resource_log VALUES (5216, 3, 2, NULL, '2014-03-12 21:55:10.706584+02');
INSERT INTO resource_log VALUES (5287, 1079, 2, NULL, '2014-03-22 12:57:07.526655+02');
INSERT INTO resource_log VALUES (5480, 1249, 2, NULL, '2014-04-27 01:02:16.23036+03');
INSERT INTO resource_log VALUES (5481, 1250, 2, NULL, '2014-04-27 01:02:43.699513+03');
INSERT INTO resource_log VALUES (5482, 1251, 2, NULL, '2014-04-27 01:03:00.011092+03');
INSERT INTO resource_log VALUES (5483, 1252, 2, NULL, '2014-04-27 01:03:22.219667+03');
INSERT INTO resource_log VALUES (5524, 1293, 2, NULL, '2014-04-29 12:17:51.658135+03');
INSERT INTO resource_log VALUES (5525, 1294, 2, NULL, '2014-04-29 12:18:27.913053+03');
INSERT INTO resource_log VALUES (5601, 1370, 2, NULL, '2014-05-17 18:45:54.451262+03');
INSERT INTO resource_log VALUES (5602, 1371, 2, NULL, '2014-05-17 18:47:17.628356+03');
INSERT INTO resource_log VALUES (5604, 1373, 2, NULL, '2014-05-17 18:54:01.477094+03');
INSERT INTO resource_log VALUES (5607, 1376, 2, NULL, '2014-05-17 18:56:40.07768+03');
INSERT INTO resource_log VALUES (5609, 1378, 2, NULL, '2014-05-17 19:02:40.402053+03');
INSERT INTO resource_log VALUES (5616, 1385, 2, NULL, '2014-05-17 19:07:13.667811+03');
INSERT INTO resource_log VALUES (5617, 1386, 2, NULL, '2014-05-17 19:07:36.068126+03');
INSERT INTO resource_log VALUES (5621, 1390, 2, NULL, '2014-05-17 19:11:55.084234+03');
INSERT INTO resource_log VALUES (4789, 763, 2, NULL, '2014-01-12 19:51:49.157909+02');
INSERT INTO resource_log VALUES (4903, 854, 2, NULL, '2014-02-08 22:16:58.906498+02');
INSERT INTO resource_log VALUES (4904, 3, 2, NULL, '2014-02-08 22:17:06.939369+02');
INSERT INTO resource_log VALUES (4905, 854, 2, NULL, '2014-02-08 22:20:32.280238+02');
INSERT INTO resource_log VALUES (4906, 784, 2, NULL, '2014-02-08 22:21:01.290541+02');
INSERT INTO resource_log VALUES (4908, 786, 2, NULL, '2014-02-08 22:21:09.110319+02');
INSERT INTO resource_log VALUES (5484, 1253, 2, NULL, '2014-04-28 00:03:49.599015+03');
INSERT INTO resource_log VALUES (5289, 1081, 2, NULL, '2014-03-22 17:57:05.076581+02');
INSERT INTO resource_log VALUES (5605, 1374, 2, NULL, '2014-05-17 18:55:03.070735+03');
INSERT INTO resource_log VALUES (5611, 1380, 2, NULL, '2014-05-17 19:03:57.212913+03');
INSERT INTO resource_log VALUES (5614, 1383, 2, NULL, '2014-05-17 19:04:59.867959+03');
INSERT INTO resource_log VALUES (5618, 1387, 2, NULL, '2014-05-17 19:09:22.594353+03');
INSERT INTO resource_log VALUES (5624, 1393, 2, NULL, '2014-05-18 10:14:28.009945+03');
INSERT INTO resource_log VALUES (4790, 764, 2, NULL, '2014-01-12 20:33:53.3138+02');
INSERT INTO resource_log VALUES (4909, 723, 2, NULL, '2014-02-08 22:28:37.868751+02');
INSERT INTO resource_log VALUES (4940, 878, 2, NULL, '2014-02-10 16:40:47.442615+02');
INSERT INTO resource_log VALUES (5610, 1379, 2, NULL, '2014-05-17 19:03:38.443538+03');
INSERT INTO resource_log VALUES (5612, 1381, 2, NULL, '2014-05-17 19:04:17.238286+03');
INSERT INTO resource_log VALUES (5615, 1384, 2, NULL, '2014-05-17 19:07:10.869783+03');
INSERT INTO resource_log VALUES (5620, 1389, 2, NULL, '2014-05-17 19:09:47.55779+03');
INSERT INTO resource_log VALUES (4910, 857, 2, NULL, '2014-02-09 00:41:07.487567+02');
INSERT INTO resource_log VALUES (4911, 858, 2, NULL, '2014-02-09 00:41:26.234037+02');
INSERT INTO resource_log VALUES (4912, 859, 2, NULL, '2014-02-09 00:41:48.428505+02');
INSERT INTO resource_log VALUES (4913, 860, 2, NULL, '2014-02-09 00:42:12.938208+02');
INSERT INTO resource_log VALUES (4914, 857, 2, NULL, '2014-02-09 00:42:31.066281+02');
INSERT INTO resource_log VALUES (4915, 861, 2, NULL, '2014-02-09 00:42:52.234296+02');
INSERT INTO resource_log VALUES (5291, 1088, 2, NULL, '2014-03-22 18:51:18.985681+02');
INSERT INTO resource_log VALUES (5292, 1081, 2, NULL, '2014-03-22 18:51:44.158872+02');
INSERT INTO resource_log VALUES (5458, 1225, 2, NULL, '2014-04-13 12:01:26.796233+03');
INSERT INTO resource_log VALUES (5627, 1396, 2, NULL, '2014-05-18 11:58:47.293591+03');
INSERT INTO resource_log VALUES (4917, 764, 2, NULL, '2014-02-09 00:53:58.264629+02');
INSERT INTO resource_log VALUES (4918, 769, 2, NULL, '2014-02-09 00:57:04.796409+02');
INSERT INTO resource_log VALUES (4919, 775, 2, NULL, '2014-02-09 00:57:24.917548+02');
INSERT INTO resource_log VALUES (4920, 788, 2, NULL, '2014-02-09 00:57:42.02056+02');
INSERT INTO resource_log VALUES (4942, 878, 2, NULL, '2014-02-10 22:47:18.374976+02');
INSERT INTO resource_log VALUES (4943, 880, 2, NULL, '2014-02-10 22:48:37.279277+02');
INSERT INTO resource_log VALUES (4944, 881, 2, NULL, '2014-02-10 22:49:24.829434+02');
INSERT INTO resource_log VALUES (4945, 882, 2, NULL, '2014-02-10 22:49:56.066237+02');
INSERT INTO resource_log VALUES (4946, 883, 2, NULL, '2014-02-10 22:50:06.121122+02');
INSERT INTO resource_log VALUES (4947, 884, 2, NULL, '2014-02-10 22:50:26.035905+02');
INSERT INTO resource_log VALUES (4948, 884, 2, NULL, '2014-02-10 22:53:06.689693+02');
INSERT INTO resource_log VALUES (5294, 1090, 2, NULL, '2014-03-22 20:34:50.666418+02');
INSERT INTO resource_log VALUES (5295, 1091, 2, NULL, '2014-03-22 20:36:11.95663+02');
INSERT INTO resource_log VALUES (5298, 1093, 2, NULL, '2014-03-22 20:40:16.040605+02');
INSERT INTO resource_log VALUES (5629, 1398, 2, NULL, '2014-05-18 12:12:21.975254+03');
INSERT INTO resource_log VALUES (4949, 764, 2, NULL, '2014-02-11 19:47:14.055452+02');
INSERT INTO resource_log VALUES (5488, 1257, 2, NULL, '2014-04-28 12:34:34.363475+03');
INSERT INTO resource_log VALUES (5300, 1095, 2, NULL, '2014-03-22 20:52:34.596466+02');
INSERT INTO resource_log VALUES (5301, 1096, 2, NULL, '2014-03-22 20:52:44.740475+02');
INSERT INTO resource_log VALUES (5302, 1097, 2, NULL, '2014-03-22 20:53:03.099066+02');
INSERT INTO resource_log VALUES (5489, 1258, 2, NULL, '2014-04-28 12:34:55.433659+03');
INSERT INTO resource_log VALUES (5304, 1099, 2, NULL, '2014-03-22 20:57:07.889521+02');
INSERT INTO resource_log VALUES (5535, 1304, 2, NULL, '2014-04-29 16:15:23.221696+03');
INSERT INTO resource_log VALUES (5389, 1178, 2, NULL, '2014-04-05 19:40:06.274566+03');
INSERT INTO resource_log VALUES (5390, 1179, 2, NULL, '2014-04-05 19:40:10.823684+03');
INSERT INTO resource_log VALUES (5490, 1259, 2, NULL, '2014-04-28 12:58:44.196537+03');
INSERT INTO resource_log VALUES (5305, 1100, 2, NULL, '2014-03-22 21:00:41.76813+02');
INSERT INTO resource_log VALUES (5306, 1101, 2, NULL, '2014-03-22 21:00:48.529148+02');
INSERT INTO resource_log VALUES (5307, 1102, 2, NULL, '2014-03-22 21:01:34.517288+02');
INSERT INTO resource_log VALUES (5491, 1260, 2, NULL, '2014-04-28 12:59:00.104464+03');
INSERT INTO resource_log VALUES (5631, 1400, 2, NULL, '2014-05-18 13:37:21.801854+03');
INSERT INTO resource_log VALUES (5632, 1401, 2, NULL, '2014-05-18 13:37:41.402585+03');
INSERT INTO resource_log VALUES (5633, 1402, 2, NULL, '2014-05-18 13:44:45.628784+03');
INSERT INTO resource_log VALUES (5492, 1261, 2, NULL, '2014-04-28 13:04:58.29173+03');
INSERT INTO resource_log VALUES (5634, 1403, 2, NULL, '2014-05-18 15:48:34.956287+03');
INSERT INTO resource_log VALUES (5256, 1067, 2, NULL, '2014-03-16 19:34:31.935568+02');
INSERT INTO resource_log VALUES (5494, 1263, 2, NULL, '2014-04-28 13:08:06.602496+03');
INSERT INTO resource_log VALUES (5635, 1404, 2, NULL, '2014-05-18 19:18:07.615122+03');
INSERT INTO resource_log VALUES (5636, 1406, 2, NULL, '2014-05-18 19:18:56.831097+03');
INSERT INTO resource_log VALUES (5639, 1409, 2, NULL, '2014-05-18 19:22:05.971396+03');
INSERT INTO resource_log VALUES (5394, 1185, 2, NULL, '2014-04-05 20:56:20.797318+03');
INSERT INTO resource_log VALUES (5257, 1067, 2, NULL, '2014-03-16 19:55:56.894484+02');
INSERT INTO resource_log VALUES (5495, 1264, 2, NULL, '2014-04-28 13:08:25.610345+03');
INSERT INTO resource_log VALUES (5637, 1407, 2, NULL, '2014-05-18 19:19:36.399614+03');
INSERT INTO resource_log VALUES (5641, 1411, 2, NULL, '2014-05-18 19:23:45.119721+03');
INSERT INTO resource_log VALUES (5496, 1265, 2, NULL, '2014-04-28 13:08:54.519921+03');
INSERT INTO resource_log VALUES (5638, 1408, 2, NULL, '2014-05-18 19:19:43.401474+03');
INSERT INTO resource_log VALUES (5258, 1067, 2, NULL, '2014-03-16 20:09:16.532934+02');
INSERT INTO resource_log VALUES (5311, 1097, 2, NULL, '2014-03-24 19:59:44.290142+02');
INSERT INTO resource_log VALUES (5640, 1410, 2, NULL, '2014-05-18 19:23:00.415796+03');
INSERT INTO resource_log VALUES (5643, 1413, 2, NULL, '2014-05-20 21:26:27.311927+03');
INSERT INTO resource_log VALUES (5259, 1068, 2, NULL, '2014-03-16 20:15:31.769185+02');
INSERT INTO resource_log VALUES (5499, 1268, 2, NULL, '2014-04-28 23:55:09.591646+03');
INSERT INTO resource_log VALUES (5644, 1414, 2, NULL, '2014-05-24 17:02:57.354915+03');
INSERT INTO resource_log VALUES (5645, 1415, 2, NULL, '2014-05-24 17:03:02.922541+03');
INSERT INTO resource_log VALUES (5646, 1416, 2, NULL, '2014-05-24 17:06:48.542492+03');
INSERT INTO resource_log VALUES (5647, 1417, 2, NULL, '2014-05-24 17:06:51.402853+03');
INSERT INTO resource_log VALUES (5648, 1418, 2, NULL, '2014-05-24 17:07:25.101929+03');
INSERT INTO resource_log VALUES (5649, 1419, 2, NULL, '2014-05-24 17:07:29.075778+03');
INSERT INTO resource_log VALUES (5650, 1420, 2, NULL, '2014-05-24 17:24:17.546972+03');
INSERT INTO resource_log VALUES (4120, 16, 2, NULL, '2014-01-01 13:19:09.979922+02');
INSERT INTO resource_log VALUES (4131, 14, 2, NULL, '2014-01-01 18:45:07.902745+02');
INSERT INTO resource_log VALUES (4144, 706, 2, NULL, '2014-01-03 16:12:41.015146+02');
INSERT INTO resource_log VALUES (4145, 706, 2, NULL, '2014-01-03 16:13:23.197097+02');
INSERT INTO resource_log VALUES (5402, 1189, 2, NULL, '2014-04-06 18:46:40.132797+03');
INSERT INTO resource_log VALUES (5403, 1190, 2, NULL, '2014-04-06 18:47:22.030146+03');
INSERT INTO resource_log VALUES (5138, 865, 2, NULL, '2014-03-03 21:09:34.254642+02');
INSERT INTO resource_log VALUES (5404, 1191, 2, NULL, '2014-04-06 18:53:34.002074+03');
INSERT INTO resource_log VALUES (5263, 1009, 2, NULL, '2014-03-16 21:40:10.728496+02');
INSERT INTO resource_log VALUES (5264, 1009, 2, NULL, '2014-03-16 21:44:11.742442+02');
INSERT INTO resource_log VALUES (5405, 1192, 2, NULL, '2014-04-06 19:20:55.890208+03');
INSERT INTO resource_log VALUES (5140, 865, 2, NULL, '2014-03-03 21:57:11.59945+02');
INSERT INTO resource_log VALUES (5265, 1004, 2, NULL, '2014-03-17 10:29:17.115979+02');
INSERT INTO resource_log VALUES (5266, 1004, 2, NULL, '2014-03-17 10:29:24.701637+02');
INSERT INTO resource_log VALUES (4744, 723, 2, NULL, '2014-01-04 23:58:55.624453+02');
INSERT INTO resource_log VALUES (4746, 725, 2, NULL, '2014-01-05 01:09:00.405742+02');
INSERT INTO resource_log VALUES (4747, 726, 2, NULL, '2014-01-05 01:09:15.602018+02');
INSERT INTO resource_log VALUES (4749, 728, 2, NULL, '2014-01-05 01:13:50.125212+02');
INSERT INTO resource_log VALUES (4756, 734, 2, NULL, '2014-01-05 12:36:48.48575+02');
INSERT INTO resource_log VALUES (4765, 743, 2, NULL, '2014-01-05 13:20:17.173661+02');
INSERT INTO resource_log VALUES (5654, 1424, 2, NULL, '2014-06-01 10:25:44.71461+03');
INSERT INTO resource_log VALUES (5656, 1426, 2, NULL, '2014-06-01 12:15:53.295347+03');
INSERT INTO resource_log VALUES (5661, 1431, 2, NULL, '2014-06-07 15:12:11.693366+03');
INSERT INTO resource_log VALUES (5662, 1432, 2, NULL, '2014-06-07 15:12:40.323386+03');
INSERT INTO resource_log VALUES (5663, 1433, 2, NULL, '2014-06-07 17:43:14.620483+03');
INSERT INTO resource_log VALUES (5665, 1435, 2, NULL, '2014-06-07 21:01:18.691193+03');
INSERT INTO resource_log VALUES (5667, 1438, 2, NULL, '2014-06-07 21:11:01.089928+03');
INSERT INTO resource_log VALUES (5668, 1439, 2, NULL, '2014-06-07 21:11:46.797584+03');
INSERT INTO resource_log VALUES (5669, 1440, 2, NULL, '2014-06-07 22:15:09.567299+03');
INSERT INTO resource_log VALUES (5671, 1442, 2, NULL, '2014-06-07 22:16:04.586659+03');
INSERT INTO resource_log VALUES (5676, 1447, 2, NULL, '2014-06-08 21:25:14.638119+03');
INSERT INTO resource_log VALUES (5677, 1448, 2, NULL, '2014-06-08 21:25:35.09515+03');
INSERT INTO resource_log VALUES (5679, 1450, 2, NULL, '2014-06-09 15:50:23.760428+03');
INSERT INTO resource_log VALUES (5681, 1452, 2, NULL, '2014-06-09 17:20:44.311452+03');
INSERT INTO resource_log VALUES (5693, 1464, 2, NULL, '2014-06-14 17:55:00.252916+03');
INSERT INTO resource_log VALUES (5694, 1465, 2, NULL, '2014-06-14 17:55:08.213215+03');
INSERT INTO resource_log VALUES (5695, 1467, 2, NULL, '2014-06-14 17:56:52.935007+03');
INSERT INTO resource_log VALUES (5696, 1468, 2, NULL, '2014-06-14 17:58:15.339465+03');
INSERT INTO resource_log VALUES (5697, 1469, 2, NULL, '2014-06-14 17:58:37.034547+03');
INSERT INTO resource_log VALUES (5698, 1470, 2, NULL, '2014-06-14 18:00:56.71432+03');
INSERT INTO resource_log VALUES (5699, 1471, 2, NULL, '2014-06-14 18:02:10.63169+03');
INSERT INTO resource_log VALUES (5700, 1472, 2, NULL, '2014-06-14 18:02:54.98084+03');
INSERT INTO resource_log VALUES (5701, 1473, 2, NULL, '2014-06-14 18:03:27.411198+03');
INSERT INTO resource_log VALUES (5713, 1485, 2, NULL, '2014-06-15 15:17:28.256792+03');
INSERT INTO resource_log VALUES (5715, 1487, 2, NULL, '2014-06-16 14:42:17.062016+03');
INSERT INTO resource_log VALUES (5728, 1500, 2, NULL, '2014-06-18 16:59:05.631362+03');
INSERT INTO resource_log VALUES (5730, 1502, 2, NULL, '2014-06-22 19:40:05.464875+03');
INSERT INTO resource_log VALUES (5731, 1503, 2, NULL, '2014-06-22 19:40:20.79663+03');
INSERT INTO resource_log VALUES (5732, 1504, 2, NULL, '2014-06-22 19:42:44.939368+03');
INSERT INTO resource_log VALUES (5733, 1505, 2, NULL, '2014-06-22 19:43:05.103699+03');
INSERT INTO resource_log VALUES (5734, 1506, 2, NULL, '2014-06-22 19:43:23.157992+03');
INSERT INTO resource_log VALUES (5735, 1507, 2, NULL, '2014-06-22 19:46:21.388635+03');
INSERT INTO resource_log VALUES (5737, 1509, 2, NULL, '2014-06-22 21:15:50.586549+03');
INSERT INTO resource_log VALUES (5738, 1510, 2, NULL, '2014-06-24 20:30:44.36129+03');
INSERT INTO resource_log VALUES (5739, 1511, 2, NULL, '2014-06-25 19:21:08.001771+03');
INSERT INTO resource_log VALUES (5740, 1512, 2, NULL, '2014-06-25 19:37:43.544622+03');
INSERT INTO resource_log VALUES (5741, 1513, 2, NULL, '2014-06-25 19:38:23.293423+03');
INSERT INTO resource_log VALUES (5742, 1514, 2, NULL, '2014-06-25 19:38:46.712804+03');
INSERT INTO resource_log VALUES (5743, 1515, 2, NULL, '2014-06-25 19:39:14.757449+03');
INSERT INTO resource_log VALUES (5744, 1516, 2, NULL, '2014-06-25 20:37:42.602785+03');
INSERT INTO resource_log VALUES (5745, 1517, 2, NULL, '2014-06-25 20:54:09.96009+03');
INSERT INTO resource_log VALUES (5746, 1518, 2, NULL, '2014-06-25 20:54:50.943042+03');
INSERT INTO resource_log VALUES (5747, 1519, 2, NULL, '2014-06-25 20:55:06.988343+03');
INSERT INTO resource_log VALUES (5749, 1521, 2, NULL, '2014-06-26 21:02:19.488826+03');
INSERT INTO resource_log VALUES (5750, 1535, 2, NULL, '2014-06-28 17:17:15.295903+03');
INSERT INTO resource_log VALUES (5751, 1536, 2, NULL, '2014-06-28 17:31:39.626186+03');
INSERT INTO resource_log VALUES (5752, 1537, 2, NULL, '2014-06-28 20:56:05.816704+03');
INSERT INTO resource_log VALUES (5753, 1538, 2, NULL, '2014-06-28 20:57:41.600837+03');
INSERT INTO resource_log VALUES (5754, 1539, 2, NULL, '2014-06-28 20:59:59.522314+03');
INSERT INTO resource_log VALUES (5755, 1540, 2, NULL, '2014-06-28 21:00:26.365557+03');
INSERT INTO resource_log VALUES (5756, 1541, 2, NULL, '2014-06-28 21:00:51.086753+03');
INSERT INTO resource_log VALUES (5757, 1542, 2, NULL, '2014-06-28 21:18:20.602573+03');
INSERT INTO resource_log VALUES (5758, 1543, 2, NULL, '2014-06-28 21:25:57.336069+03');
INSERT INTO resource_log VALUES (5759, 1544, 2, NULL, '2014-06-28 21:26:14.894807+03');
INSERT INTO resource_log VALUES (5760, 1545, 2, NULL, '2014-06-28 21:26:35.413657+03');
INSERT INTO resource_log VALUES (5761, 1546, 2, NULL, '2014-07-02 23:01:03.321441+03');
INSERT INTO resource_log VALUES (5762, 1547, 2, NULL, '2014-07-02 23:03:30.755887+03');
INSERT INTO resource_log VALUES (5763, 1548, 2, NULL, '2014-07-26 18:07:46.336433+03');
INSERT INTO resource_log VALUES (5764, 1549, 2, NULL, '2014-08-16 20:09:11.73959+03');
INSERT INTO resource_log VALUES (5766, 1551, 2, NULL, '2014-08-16 20:23:59.980051+03');
INSERT INTO resource_log VALUES (5767, 1552, 2, NULL, '2014-08-16 20:24:12.305446+03');
INSERT INTO resource_log VALUES (5768, 1553, 2, NULL, '2014-08-16 20:24:15.930016+03');
INSERT INTO resource_log VALUES (5769, 1554, 2, NULL, '2014-08-16 20:25:09.403552+03');
INSERT INTO resource_log VALUES (5771, 1556, 2, NULL, '2014-08-16 20:51:19.103778+03');
INSERT INTO resource_log VALUES (5773, 1559, 2, NULL, '2014-08-16 21:13:14.302214+03');
INSERT INTO resource_log VALUES (5774, 1560, 2, NULL, '2014-08-16 21:13:18.107616+03');
INSERT INTO resource_log VALUES (5775, 1561, 2, NULL, '2014-08-16 21:22:35.752473+03');
INSERT INTO resource_log VALUES (5776, 1562, 2, NULL, '2014-08-16 21:23:02.397566+03');
INSERT INTO resource_log VALUES (5777, 1563, 2, NULL, '2014-08-16 21:23:05.499294+03');
INSERT INTO resource_log VALUES (5778, 1564, 2, NULL, '2014-08-16 21:24:08.813965+03');
INSERT INTO resource_log VALUES (5783, 1569, 2, NULL, '2014-08-17 11:07:53.713228+03');
INSERT INTO resource_log VALUES (5784, 1570, 2, NULL, '2014-08-17 11:09:10.292392+03');
INSERT INTO resource_log VALUES (5790, 1576, 2, NULL, '2014-08-22 22:48:58.176695+03');
INSERT INTO resource_log VALUES (5791, 1577, 2, NULL, '2014-08-22 22:49:31.584667+03');
INSERT INTO resource_log VALUES (5792, 1578, 2, NULL, '2014-08-22 22:49:35.101959+03');
INSERT INTO resource_log VALUES (5793, 1579, 2, NULL, '2014-08-22 22:50:20.197271+03');
INSERT INTO resource_log VALUES (5794, 1580, 2, NULL, '2014-08-22 22:50:49.188036+03');
INSERT INTO resource_log VALUES (5795, 1581, 2, NULL, '2014-08-22 22:51:29.357367+03');
INSERT INTO resource_log VALUES (5796, 1582, 2, NULL, '2014-08-22 22:52:03.171722+03');
INSERT INTO resource_log VALUES (5797, 1584, 2, NULL, '2014-08-22 22:58:38.326467+03');
INSERT INTO resource_log VALUES (5798, 1585, 2, NULL, '2014-08-22 22:59:28.534906+03');
INSERT INTO resource_log VALUES (5799, 1586, 2, NULL, '2014-08-22 22:59:41.71816+03');
INSERT INTO resource_log VALUES (5800, 1587, 2, NULL, '2014-08-22 23:01:39.676197+03');
INSERT INTO resource_log VALUES (5801, 1588, 2, NULL, '2014-08-22 23:02:11.872661+03');
INSERT INTO resource_log VALUES (5802, 1589, 2, NULL, '2014-08-22 23:04:10.670971+03');
INSERT INTO resource_log VALUES (5803, 1590, 2, NULL, '2014-08-22 23:04:40.181387+03');
INSERT INTO resource_log VALUES (5804, 1591, 2, NULL, '2014-08-22 23:05:46.128053+03');
INSERT INTO resource_log VALUES (5805, 1592, 2, NULL, '2014-08-22 23:06:07.780481+03');
INSERT INTO resource_log VALUES (5806, 1593, 2, NULL, '2014-08-22 23:06:12.342153+03');
INSERT INTO resource_log VALUES (5810, 1597, 2, NULL, '2014-08-22 23:14:17.280337+03');
INSERT INTO resource_log VALUES (5811, 1598, 2, NULL, '2014-08-22 23:35:58.491964+03');
INSERT INTO resource_log VALUES (5820, 1607, 2, NULL, '2014-08-23 13:37:30.044239+03');
INSERT INTO resource_log VALUES (5821, 1608, 2, NULL, '2014-08-23 16:14:22.910225+03');
INSERT INTO resource_log VALUES (5822, 1609, 2, NULL, '2014-08-23 16:16:24.823791+03');
INSERT INTO resource_log VALUES (5823, 1610, 2, NULL, '2014-08-24 14:10:51.002759+03');
INSERT INTO resource_log VALUES (5824, 1611, 2, NULL, '2014-08-24 14:11:19.783792+03');
INSERT INTO resource_log VALUES (5825, 1612, 2, NULL, '2014-08-24 14:11:36.729128+03');
INSERT INTO resource_log VALUES (5826, 1613, 2, NULL, '2014-08-24 14:11:54.849623+03');
INSERT INTO resource_log VALUES (5827, 1614, 2, NULL, '2014-08-24 14:48:54.04485+03');
INSERT INTO resource_log VALUES (5828, 1615, 2, NULL, '2014-08-24 14:48:55.715304+03');
INSERT INTO resource_log VALUES (5829, 1616, 2, NULL, '2014-08-24 14:49:59.373945+03');
INSERT INTO resource_log VALUES (5832, 1619, 2, NULL, '2014-08-24 15:01:16.140346+03');
INSERT INTO resource_log VALUES (5833, 1620, 2, NULL, '2014-08-24 15:02:15.884894+03');
INSERT INTO resource_log VALUES (5834, 1621, 2, NULL, '2014-08-24 15:02:43.162974+03');
INSERT INTO resource_log VALUES (5835, 1622, 2, NULL, '2014-08-24 15:03:06.67481+03');
INSERT INTO resource_log VALUES (5836, 1623, 2, NULL, '2014-08-24 15:03:53.276198+03');
INSERT INTO resource_log VALUES (5837, 1624, 2, NULL, '2014-08-24 15:08:02.737031+03');
INSERT INTO resource_log VALUES (5838, 1625, 2, NULL, '2014-08-24 15:08:18.61161+03');
INSERT INTO resource_log VALUES (5839, 1626, 2, NULL, '2014-08-24 15:08:29.0077+03');
INSERT INTO resource_log VALUES (5840, 1627, 2, NULL, '2014-08-24 15:10:13.736496+03');
INSERT INTO resource_log VALUES (5841, 1628, 2, NULL, '2014-08-24 15:10:44.233145+03');
INSERT INTO resource_log VALUES (5847, 1634, 2, NULL, '2014-08-24 15:21:09.48427+03');
INSERT INTO resource_log VALUES (5852, 1639, 2, NULL, '2014-08-25 15:20:24.884947+03');
INSERT INTO resource_log VALUES (5853, 1640, 2, NULL, '2014-08-26 19:55:53.569882+03');
INSERT INTO resource_log VALUES (5854, 1641, 2, NULL, '2014-08-26 19:56:28.320221+03');
INSERT INTO resource_log VALUES (5858, 1645, 2, NULL, '2014-08-26 20:01:19.187139+03');
INSERT INTO resource_log VALUES (5860, 1647, 2, NULL, '2014-08-26 20:04:08.078366+03');
INSERT INTO resource_log VALUES (5862, 1649, 2, NULL, '2014-08-26 20:04:48.124422+03');
INSERT INTO resource_log VALUES (5855, 1642, 2, NULL, '2014-08-26 19:56:46.695581+03');
INSERT INTO resource_log VALUES (5856, 1643, 2, NULL, '2014-08-26 19:57:13.160198+03');
INSERT INTO resource_log VALUES (5857, 1644, 2, NULL, '2014-08-26 20:01:16.129984+03');
INSERT INTO resource_log VALUES (5859, 1646, 2, NULL, '2014-08-26 20:04:06.105786+03');
INSERT INTO resource_log VALUES (5861, 1648, 2, NULL, '2014-08-26 20:04:09.378364+03');
INSERT INTO resource_log VALUES (5863, 1650, 2, NULL, '2014-08-26 20:06:13.193356+03');
INSERT INTO resource_log VALUES (5864, 1651, 2, NULL, '2014-08-26 20:06:36.249641+03');
INSERT INTO resource_log VALUES (5865, 1652, 2, NULL, '2014-08-26 20:07:23.412381+03');
INSERT INTO resource_log VALUES (5866, 1653, 2, NULL, '2014-08-26 20:07:31.899383+03');
INSERT INTO resource_log VALUES (5870, 1657, 2, NULL, '2014-08-26 20:13:28.887297+03');
INSERT INTO resource_log VALUES (5873, 1660, 2, NULL, '2014-08-31 16:37:37.888486+03');
INSERT INTO resource_log VALUES (5919, 1714, 2, NULL, '2014-09-14 13:27:15.677766+03');
INSERT INTO resource_log VALUES (5926, 1721, 2, NULL, '2014-09-14 14:49:51.512979+03');
INSERT INTO resource_log VALUES (5967, 1764, 2, NULL, '2014-09-14 21:51:09.963908+03');
INSERT INTO resource_log VALUES (5968, 1766, 2, NULL, '2014-09-28 17:08:27.946698+03');
INSERT INTO resource_log VALUES (5971, 1769, 2, NULL, '2014-10-01 20:37:18.107894+03');
INSERT INTO resource_log VALUES (5972, 1771, 2, NULL, '2014-10-01 21:39:17.299667+03');
INSERT INTO resource_log VALUES (5973, 1773, 2, NULL, '2014-10-01 22:04:03.074823+03');
INSERT INTO resource_log VALUES (5974, 1774, 2, NULL, '2014-10-01 22:17:44.949656+03');
INSERT INTO resource_log VALUES (5975, 1775, 2, NULL, '2014-10-03 20:21:54.06353+03');
INSERT INTO resource_log VALUES (5977, 1777, 2, NULL, '2014-10-03 20:35:01.628264+03');
INSERT INTO resource_log VALUES (5978, 1778, 2, NULL, '2014-10-04 21:45:17.702702+03');
INSERT INTO resource_log VALUES (5980, 1780, 2, NULL, '2014-10-05 12:49:28.270538+03');
INSERT INTO resource_log VALUES (5982, 1797, 2, NULL, '2014-10-05 21:08:02.025119+03');
INSERT INTO resource_log VALUES (5983, 1798, 2, NULL, '2014-10-05 22:07:40.176836+03');
INSERT INTO resource_log VALUES (5984, 1799, 2, NULL, '2014-10-09 20:49:57.476724+03');
INSERT INTO resource_log VALUES (5985, 1800, 2, NULL, '2014-10-09 21:44:48.304991+03');
INSERT INTO resource_log VALUES (5986, 1801, 2, NULL, '2014-10-09 21:45:57.042916+03');
INSERT INTO resource_log VALUES (5987, 1802, 2, NULL, '2014-10-09 21:51:36.274928+03');
INSERT INTO resource_log VALUES (5988, 1797, 2, NULL, '2014-10-09 21:58:44.274487+03');
INSERT INTO resource_log VALUES (5989, 1803, 2, NULL, '2014-10-10 21:20:08.467997+03');
INSERT INTO resource_log VALUES (5990, 1804, 2, NULL, '2014-10-10 21:48:32.795064+03');
INSERT INTO resource_log VALUES (5991, 1797, 2, NULL, '2014-10-10 21:48:40.224687+03');
INSERT INTO resource_log VALUES (5994, 1797, 2, NULL, '2014-10-10 22:43:03.886027+03');
INSERT INTO resource_log VALUES (5995, 1807, 2, NULL, '2014-10-12 12:18:58.609492+03');
INSERT INTO resource_log VALUES (5996, 1419, 2, NULL, '2014-10-12 12:21:41.297126+03');
INSERT INTO resource_log VALUES (5999, 1419, 2, NULL, '2014-10-12 14:03:13.921521+03');
INSERT INTO resource_log VALUES (6000, 1419, 2, NULL, '2014-10-12 14:03:56.458732+03');
INSERT INTO resource_log VALUES (6002, 1797, 2, NULL, '2014-10-12 14:08:19.225786+03');
INSERT INTO resource_log VALUES (6003, 1797, 2, NULL, '2014-10-12 14:08:29.322661+03');
INSERT INTO resource_log VALUES (6005, 1797, 2, NULL, '2014-10-12 14:09:47.667654+03');
INSERT INTO resource_log VALUES (6006, 1797, 2, NULL, '2014-10-12 14:10:15.511498+03');
INSERT INTO resource_log VALUES (6008, 894, 2, NULL, '2014-10-12 14:15:30.839116+03');
INSERT INTO resource_log VALUES (6010, 894, 2, NULL, '2014-10-12 14:15:50.178579+03');
INSERT INTO resource_log VALUES (6011, 894, 2, NULL, '2014-10-12 14:16:00.712168+03');
INSERT INTO resource_log VALUES (6014, 1507, 2, NULL, '2014-10-12 14:21:53.792753+03');
INSERT INTO resource_log VALUES (6015, 1507, 2, NULL, '2014-10-12 14:22:06.118134+03');
INSERT INTO resource_log VALUES (6016, 1439, 2, NULL, '2014-10-12 14:22:17.008412+03');
INSERT INTO resource_log VALUES (6017, 1438, 2, NULL, '2014-10-12 14:22:21.965321+03');
INSERT INTO resource_log VALUES (6020, 1780, 2, NULL, '2014-10-12 14:25:19.014258+03');
INSERT INTO resource_log VALUES (6021, 1780, 2, NULL, '2014-10-12 14:25:28.403238+03');
INSERT INTO resource_log VALUES (6022, 1780, 2, NULL, '2014-10-12 14:25:37.930302+03');
INSERT INTO resource_log VALUES (6025, 1413, 2, NULL, '2014-10-12 14:31:06.237149+03');
INSERT INTO resource_log VALUES (6026, 1413, 2, NULL, '2014-10-12 14:31:16.507549+03');
INSERT INTO resource_log VALUES (6029, 1415, 2, NULL, '2014-10-12 14:34:22.672887+03');
INSERT INTO resource_log VALUES (6030, 1415, 2, NULL, '2014-10-12 14:34:32.05391+03');
INSERT INTO resource_log VALUES (6043, 1657, 2, NULL, '2014-10-12 15:41:58.778177+03');
INSERT INTO resource_log VALUES (6045, 1657, 2, NULL, '2014-10-12 15:42:13.36551+03');
INSERT INTO resource_log VALUES (6046, 1657, 2, NULL, '2014-10-12 15:42:24.726059+03');
INSERT INTO resource_log VALUES (6050, 1653, 2, NULL, '2014-10-12 16:27:20.425954+03');
INSERT INTO resource_log VALUES (6051, 1653, 2, NULL, '2014-10-12 16:27:45.783221+03');
INSERT INTO resource_log VALUES (6053, 1283, 2, NULL, '2014-10-12 16:28:08.925372+03');
INSERT INTO resource_log VALUES (6054, 1283, 2, NULL, '2014-10-12 16:28:17.376186+03');
INSERT INTO resource_log VALUES (6055, 1833, 2, NULL, '2014-10-12 16:29:10.045595+03');
INSERT INTO resource_log VALUES (6056, 784, 2, NULL, '2014-10-12 16:29:11.936722+03');
INSERT INTO resource_log VALUES (6061, 1542, 2, NULL, '2014-10-12 17:31:06.178463+03');
INSERT INTO resource_log VALUES (6063, 861, 2, NULL, '2014-10-12 20:54:52.692696+03');
INSERT INTO resource_log VALUES (6064, 861, 2, NULL, '2014-10-12 20:55:02.552131+03');
INSERT INTO resource_log VALUES (6066, 998, 2, NULL, '2014-10-18 11:46:31.67705+03');
INSERT INTO resource_log VALUES (6075, 1657, 2, NULL, '2014-10-18 23:25:55.139592+03');
INSERT INTO resource_log VALUES (6076, 1657, 2, NULL, '2014-10-18 23:26:04.397861+03');
INSERT INTO resource_log VALUES (6077, 1839, 2, NULL, '2014-10-18 23:26:44.642232+03');
INSERT INTO resource_log VALUES (6078, 1634, 2, NULL, '2014-10-18 23:26:52.975425+03');
INSERT INTO resource_log VALUES (6079, 1598, 2, NULL, '2014-10-18 23:27:05.648811+03');
INSERT INTO resource_log VALUES (6080, 1502, 2, NULL, '2014-10-18 23:27:11.743763+03');
INSERT INTO resource_log VALUES (6081, 1503, 2, NULL, '2014-10-18 23:27:18.622533+03');
INSERT INTO resource_log VALUES (6082, 1440, 2, NULL, '2014-10-18 23:27:25.765119+03');
INSERT INTO resource_log VALUES (6083, 1442, 2, NULL, '2014-10-18 23:27:32.509568+03');
INSERT INTO resource_log VALUES (6084, 1840, 2, NULL, '2014-10-18 23:35:01.43267+03');
INSERT INTO resource_log VALUES (6114, 1598, 2, NULL, '2014-10-25 20:24:45.191774+03');
INSERT INTO resource_log VALUES (6115, 1840, 2, NULL, '2014-10-25 20:25:16.419372+03');
INSERT INTO resource_log VALUES (6116, 1839, 2, NULL, '2014-10-25 20:25:25.421645+03');
INSERT INTO resource_log VALUES (6117, 1657, 2, NULL, '2014-10-25 20:25:34.041679+03');
INSERT INTO resource_log VALUES (6118, 1634, 2, NULL, '2014-10-25 20:25:41.778509+03');
INSERT INTO resource_log VALUES (6119, 1598, 2, NULL, '2014-10-25 20:25:49.974159+03');
INSERT INTO resource_log VALUES (6120, 1503, 2, NULL, '2014-10-25 20:25:56.790041+03');
INSERT INTO resource_log VALUES (6121, 1502, 2, NULL, '2014-10-25 20:26:11.552957+03');
INSERT INTO resource_log VALUES (6122, 1487, 2, NULL, '2014-10-25 20:26:20.033323+03');
INSERT INTO resource_log VALUES (6123, 1442, 2, NULL, '2014-10-25 20:26:26.124436+03');
INSERT INTO resource_log VALUES (6124, 1440, 2, NULL, '2014-10-25 20:26:33.450119+03');
INSERT INTO resource_log VALUES (6125, 1660, 2, NULL, '2014-10-25 20:27:51.453322+03');
INSERT INTO resource_log VALUES (6126, 1639, 2, NULL, '2014-10-25 20:27:59.032748+03');
INSERT INTO resource_log VALUES (6127, 1607, 2, NULL, '2014-10-25 20:28:26.48561+03');
INSERT INTO resource_log VALUES (6128, 1547, 2, NULL, '2014-10-25 20:31:18.593123+03');
INSERT INTO resource_log VALUES (6129, 1546, 2, NULL, '2014-10-25 20:31:27.322575+03');
INSERT INTO resource_log VALUES (6130, 1509, 2, NULL, '2014-10-25 20:31:34.596003+03');
INSERT INTO resource_log VALUES (6131, 1500, 2, NULL, '2014-10-25 20:31:41.235636+03');
INSERT INTO resource_log VALUES (6132, 1485, 2, NULL, '2014-10-25 20:31:48.295128+03');
INSERT INTO resource_log VALUES (6133, 1448, 2, NULL, '2014-10-25 20:31:55.364673+03');
INSERT INTO resource_log VALUES (6134, 1447, 2, NULL, '2014-10-25 20:32:03.232605+03');
INSERT INTO resource_log VALUES (6135, 864, 2, NULL, '2014-10-25 22:27:41.085522+03');
INSERT INTO resource_log VALUES (6136, 900, 2, NULL, '2014-10-25 22:27:48.659618+03');
INSERT INTO resource_log VALUES (6137, 780, 2, NULL, '2014-10-25 22:27:56.462817+03');
INSERT INTO resource_log VALUES (6138, 837, 2, NULL, '2014-10-25 22:28:02.931936+03');
INSERT INTO resource_log VALUES (6139, 1394, 2, NULL, '2014-10-25 22:28:08.943421+03');
INSERT INTO resource_log VALUES (6140, 873, 2, NULL, '2014-10-25 22:28:16.618586+03');
INSERT INTO resource_log VALUES (6141, 778, 2, NULL, '2014-10-25 22:28:22.956578+03');
INSERT INTO resource_log VALUES (6142, 1659, 2, NULL, '2014-10-25 22:39:28.23436+03');
INSERT INTO resource_log VALUES (6144, 1849, 2, NULL, '2014-10-25 23:00:37.016264+03');
INSERT INTO resource_log VALUES (6145, 1852, 2, NULL, '2014-10-28 19:57:41.751563+02');
INSERT INTO resource_log VALUES (6146, 1853, 2, NULL, '2014-10-28 20:23:48.907733+02');
INSERT INTO resource_log VALUES (6147, 1854, 2, NULL, '2014-10-28 20:24:58.380434+02');
INSERT INTO resource_log VALUES (6148, 1855, 2, NULL, '2014-10-28 20:25:08.681569+02');
INSERT INTO resource_log VALUES (6151, 1859, 2, NULL, '2014-10-29 12:48:22.905378+02');
INSERT INTO resource_log VALUES (6152, 1860, 2, NULL, '2014-10-30 22:03:33.988542+02');
INSERT INTO resource_log VALUES (6157, 1865, 2, NULL, '2014-11-03 21:33:49.462196+02');
INSERT INTO resource_log VALUES (6158, 1866, 2, NULL, '2014-11-03 21:38:54.729983+02');
INSERT INTO resource_log VALUES (6159, 1867, 2, NULL, '2014-11-03 21:39:31.824693+02');
INSERT INTO resource_log VALUES (6160, 1868, 2, NULL, '2014-11-03 21:40:02.647787+02');
INSERT INTO resource_log VALUES (6161, 1869, 2, NULL, '2014-11-05 21:10:08.261088+02');
INSERT INTO resource_log VALUES (6162, 1870, 2, NULL, '2014-11-05 21:10:38.427296+02');
INSERT INTO resource_log VALUES (6164, 1872, 2, NULL, '2014-11-08 19:05:48.520641+02');
INSERT INTO resource_log VALUES (6165, 1868, 2, NULL, '2014-11-08 19:07:32.928999+02');
INSERT INTO resource_log VALUES (6166, 1868, 2, NULL, '2014-11-08 19:07:58.653299+02');
INSERT INTO resource_log VALUES (6167, 1873, 2, NULL, '2014-11-09 14:14:33.279838+02');
INSERT INTO resource_log VALUES (6168, 1433, 2, NULL, '2014-11-09 14:15:02.053975+02');
INSERT INTO resource_log VALUES (6170, 1875, 2, NULL, '2014-11-09 20:43:57.157494+02');
INSERT INTO resource_log VALUES (6171, 1876, 2, NULL, '2014-11-09 20:50:09.776581+02');
INSERT INTO resource_log VALUES (6172, 1876, 2, NULL, '2014-11-09 21:46:07.106741+02');
INSERT INTO resource_log VALUES (6173, 1876, 2, NULL, '2014-11-09 21:46:46.766703+02');
INSERT INTO resource_log VALUES (6174, 1876, 2, NULL, '2014-11-12 18:42:47.24628+02');
INSERT INTO resource_log VALUES (6175, 1876, 2, NULL, '2014-11-12 18:43:00.917409+02');
INSERT INTO resource_log VALUES (6176, 1876, 2, NULL, '2014-11-12 18:43:51.052257+02');
INSERT INTO resource_log VALUES (6177, 1876, 2, NULL, '2014-11-12 18:49:19.486465+02');
INSERT INTO resource_log VALUES (6178, 1876, 2, NULL, '2014-11-12 18:49:50.992411+02');
INSERT INTO resource_log VALUES (6182, 1880, 2, NULL, '2014-11-12 18:58:13.464317+02');
INSERT INTO resource_log VALUES (6183, 1881, 2, NULL, '2014-11-12 18:58:13.464317+02');
INSERT INTO resource_log VALUES (6184, 1876, 2, NULL, '2014-11-12 19:19:20.155903+02');
INSERT INTO resource_log VALUES (6185, 1880, 2, NULL, '2014-11-12 19:20:04.488842+02');
INSERT INTO resource_log VALUES (6186, 1882, 2, NULL, '2014-11-12 19:21:49.754499+02');
INSERT INTO resource_log VALUES (6187, 1882, 2, NULL, '2014-11-12 20:48:55.295948+02');
INSERT INTO resource_log VALUES (6188, 1876, 2, NULL, '2014-11-13 18:36:19.360925+02');
INSERT INTO resource_log VALUES (6189, 1876, 2, NULL, '2014-11-13 18:36:40.275356+02');
INSERT INTO resource_log VALUES (6190, 1876, 2, NULL, '2014-11-13 18:36:53.848561+02');
INSERT INTO resource_log VALUES (6191, 1876, 2, NULL, '2014-11-13 18:37:04.828162+02');
INSERT INTO resource_log VALUES (6192, 1876, 2, NULL, '2014-11-13 18:44:14.058824+02');
INSERT INTO resource_log VALUES (6193, 1880, 2, NULL, '2014-11-14 13:23:46.652293+02');
INSERT INTO resource_log VALUES (6196, 1884, 2, NULL, '2014-11-15 12:46:51.68956+02');
INSERT INTO resource_log VALUES (6197, 1885, 2, NULL, '2014-11-15 12:55:58.618287+02');
INSERT INTO resource_log VALUES (6200, 1647, 2, NULL, '2014-11-15 19:54:17.589811+02');
INSERT INTO resource_log VALUES (6201, 1647, 2, NULL, '2014-11-15 19:57:05.325517+02');
INSERT INTO resource_log VALUES (6202, 1587, 2, NULL, '2014-11-15 19:57:11.689531+02');
INSERT INTO resource_log VALUES (6204, 1888, 2, NULL, '2014-11-15 20:54:18.530252+02');
INSERT INTO resource_log VALUES (6209, 1893, 2, NULL, '2014-11-15 21:10:00.852505+02');
INSERT INTO resource_log VALUES (6210, 1894, 2, NULL, '2014-11-16 11:36:20.360008+02');
INSERT INTO resource_log VALUES (6211, 1895, 2, NULL, '2014-11-16 11:38:31.304748+02');
INSERT INTO resource_log VALUES (6212, 1896, 2, NULL, '2014-11-16 11:52:22.859107+02');
INSERT INTO resource_log VALUES (6214, 1896, 2, NULL, '2014-11-16 17:28:25.282664+02');
INSERT INTO resource_log VALUES (6215, 1898, 2, NULL, '2014-11-18 19:36:00.947451+02');
INSERT INTO resource_log VALUES (6217, 1900, 2, NULL, '2014-11-18 19:59:41.794255+02');
INSERT INTO resource_log VALUES (6218, 1901, 2, NULL, '2014-11-18 20:00:50.313385+02');
INSERT INTO resource_log VALUES (6219, 1902, 2, NULL, '2014-11-18 20:05:55.399398+02');
INSERT INTO resource_log VALUES (6220, 1903, 2, NULL, '2014-11-18 20:06:23.495804+02');
INSERT INTO resource_log VALUES (6221, 1225, 2, NULL, '2014-11-20 20:55:40.655878+02');
INSERT INTO resource_log VALUES (6222, 1904, 2, NULL, '2014-11-21 20:47:35.513987+02');
INSERT INTO resource_log VALUES (6223, 1434, 2, NULL, '2014-11-21 20:48:05.829054+02');
INSERT INTO resource_log VALUES (6224, 1571, 2, NULL, '2014-11-21 20:48:27.000088+02');
INSERT INTO resource_log VALUES (6225, 1885, 2, NULL, '2014-11-21 20:48:44.475673+02');
INSERT INTO resource_log VALUES (6226, 1905, 2, NULL, '2014-11-21 21:17:50.885382+02');
INSERT INTO resource_log VALUES (6227, 1436, 2, NULL, '2014-11-21 21:19:06.360097+02');
INSERT INTO resource_log VALUES (6228, 1798, 2, NULL, '2014-11-21 21:19:19.899746+02');
INSERT INTO resource_log VALUES (6229, 1425, 2, NULL, '2014-11-21 21:19:42.772209+02');
INSERT INTO resource_log VALUES (6230, 802, 2, NULL, '2014-11-21 21:20:02.792752+02');
INSERT INTO resource_log VALUES (6231, 1906, 2, NULL, '2014-11-21 21:20:18.443474+02');
INSERT INTO resource_log VALUES (6232, 802, 2, NULL, '2014-11-21 21:20:33.430037+02');
INSERT INTO resource_log VALUES (6233, 1395, 2, NULL, '2014-11-21 21:20:55.244524+02');
INSERT INTO resource_log VALUES (6234, 1907, 2, NULL, '2014-11-21 21:25:23.260941+02');
INSERT INTO resource_log VALUES (6235, 879, 2, NULL, '2014-11-21 21:26:01.060638+02');
INSERT INTO resource_log VALUES (6236, 1089, 2, NULL, '2014-11-21 21:34:19.776611+02');
INSERT INTO resource_log VALUES (6237, 874, 2, NULL, '2014-11-21 21:34:45.906696+02');
INSERT INTO resource_log VALUES (6238, 1080, 2, NULL, '2014-11-21 21:35:09.652432+02');
INSERT INTO resource_log VALUES (6239, 1908, 2, NULL, '2014-11-21 21:35:29.643627+02');
INSERT INTO resource_log VALUES (6240, 910, 2, NULL, '2014-11-21 21:36:10.21074+02');
INSERT INTO resource_log VALUES (6241, 1080, 2, NULL, '2014-11-21 21:36:26.556412+02');
INSERT INTO resource_log VALUES (6242, 911, 2, NULL, '2014-11-21 21:36:37.408083+02');
INSERT INTO resource_log VALUES (6243, 956, 2, NULL, '2014-11-21 21:36:56.333028+02');
INSERT INTO resource_log VALUES (6244, 955, 2, NULL, '2014-11-21 21:37:09.845857+02');
INSERT INTO resource_log VALUES (6246, 1896, 2, NULL, '2014-11-21 21:43:10.139464+02');
INSERT INTO resource_log VALUES (6247, 1910, 2, NULL, '2014-11-22 17:58:53.151533+02');
INSERT INTO resource_log VALUES (6248, 1911, 2, NULL, '2014-11-22 17:58:53.151533+02');
INSERT INTO resource_log VALUES (6251, 1903, 2, NULL, '2014-11-23 17:42:18.707964+02');
INSERT INTO resource_log VALUES (6253, 1903, 2, NULL, '2014-11-23 18:15:04.669498+02');
INSERT INTO resource_log VALUES (6254, 1913, 2, NULL, '2014-11-23 18:22:07.34092+02');
INSERT INTO resource_log VALUES (6255, 1915, 2, NULL, '2014-11-23 18:25:34.975922+02');
INSERT INTO resource_log VALUES (6257, 1917, 2, NULL, '2014-11-23 18:40:26.695236+02');
INSERT INTO resource_log VALUES (6258, 1918, 2, NULL, '2014-11-23 18:40:42.249218+02');
INSERT INTO resource_log VALUES (6259, 1919, 2, NULL, '2014-11-27 21:56:12.900683+02');
INSERT INTO resource_log VALUES (6265, 1906, 2, NULL, '2014-11-28 22:02:27.025943+02');
INSERT INTO resource_log VALUES (6266, 1908, 2, NULL, '2014-11-28 22:03:25.613427+02');
INSERT INTO resource_log VALUES (6267, 1919, 2, NULL, '2014-11-30 11:21:31.130821+02');
INSERT INTO resource_log VALUES (6270, 1368, 2, NULL, '2014-11-30 18:22:02.736241+02');
INSERT INTO resource_log VALUES (6271, 1922, 2, NULL, '2014-12-07 14:34:35.538855+02');
INSERT INTO resource_log VALUES (6276, 1924, 2, NULL, '2014-12-07 21:40:24.739542+02');
INSERT INTO resource_log VALUES (6277, 1925, 2, NULL, '2014-12-07 21:41:09.94037+02');
INSERT INTO resource_log VALUES (6278, 1926, 2, NULL, '2014-12-07 21:41:37.63455+02');
INSERT INTO resource_log VALUES (6279, 1471, 2, NULL, '2014-12-07 21:41:39.584636+02');
INSERT INTO resource_log VALUES (6280, 1927, 2, NULL, '2014-12-07 21:42:12.893528+02');
INSERT INTO resource_log VALUES (6281, 1471, 2, NULL, '2014-12-07 21:42:14.781639+02');
INSERT INTO resource_log VALUES (6285, 1930, 2, NULL, '2014-12-08 21:43:55.101305+02');
INSERT INTO resource_log VALUES (6286, 1869, 2, NULL, '2014-12-08 21:46:09.685953+02');
INSERT INTO resource_log VALUES (6287, 1931, 2, NULL, '2014-12-08 21:52:00.685674+02');
INSERT INTO resource_log VALUES (6288, 1930, 2, NULL, '2014-12-08 21:53:17.580512+02');
INSERT INTO resource_log VALUES (6289, 1932, 2, NULL, '2014-12-11 22:45:01.994257+02');
INSERT INTO resource_log VALUES (6290, 1933, 2, NULL, '2014-12-11 22:46:28.273472+02');
INSERT INTO resource_log VALUES (6291, 1934, 2, NULL, '2014-12-11 22:50:30.21811+02');
INSERT INTO resource_log VALUES (6293, 1935, 2, NULL, '2014-12-11 22:53:00.765244+02');
INSERT INTO resource_log VALUES (6295, 1935, 2, NULL, '2014-12-11 22:53:42.569877+02');
INSERT INTO resource_log VALUES (6297, 1936, 2, NULL, '2014-12-13 21:35:47.599877+02');
INSERT INTO resource_log VALUES (6298, 1939, 2, NULL, '2014-12-13 21:37:02.820409+02');
INSERT INTO resource_log VALUES (6299, 1939, 2, NULL, '2014-12-13 21:37:54.352906+02');
INSERT INTO resource_log VALUES (6300, 1936, 2, NULL, '2014-12-13 21:55:38.627009+02');
INSERT INTO resource_log VALUES (6301, 1933, 2, NULL, '2014-12-13 21:55:57.253566+02');
INSERT INTO resource_log VALUES (6302, 1933, 2, NULL, '2014-12-13 21:57:41.570228+02');
INSERT INTO resource_log VALUES (6303, 1933, 2, NULL, '2014-12-13 22:01:39.804954+02');
INSERT INTO resource_log VALUES (6304, 1936, 2, NULL, '2014-12-13 22:01:54.801501+02');
INSERT INTO resource_log VALUES (6305, 1936, 2, NULL, '2014-12-13 22:03:25.347584+02');
INSERT INTO resource_log VALUES (6306, 1933, 2, NULL, '2014-12-13 22:03:37.415197+02');
INSERT INTO resource_log VALUES (6307, 1939, 2, NULL, '2014-12-13 22:03:52.016284+02');
INSERT INTO resource_log VALUES (6308, 1936, 2, NULL, '2014-12-13 22:10:55.202627+02');
INSERT INTO resource_log VALUES (6309, 1936, 2, NULL, '2014-12-13 22:11:45.388631+02');
INSERT INTO resource_log VALUES (6310, 1936, 2, NULL, '2014-12-14 11:10:18.568487+02');
INSERT INTO resource_log VALUES (6311, 1936, 2, NULL, '2014-12-14 11:10:54.616091+02');
INSERT INTO resource_log VALUES (6312, 1936, 2, NULL, '2014-12-14 11:12:20.116844+02');
INSERT INTO resource_log VALUES (6313, 1933, 2, NULL, '2014-12-14 11:12:44.366886+02');
INSERT INTO resource_log VALUES (6314, 1936, 2, NULL, '2014-12-14 11:14:36.987112+02');
INSERT INTO resource_log VALUES (6315, 1933, 2, NULL, '2014-12-14 11:14:46.937016+02');
INSERT INTO resource_log VALUES (6316, 1940, 2, NULL, '2014-12-14 11:16:18.397912+02');
INSERT INTO resource_log VALUES (6317, 1941, 2, NULL, '2014-12-14 17:51:15.587939+02');
INSERT INTO resource_log VALUES (6318, 1940, 2, NULL, '2014-12-14 19:37:37.036036+02');
INSERT INTO resource_log VALUES (6319, 1936, 2, NULL, '2014-12-14 19:37:54.381361+02');
INSERT INTO resource_log VALUES (6320, 1940, 2, NULL, '2014-12-14 19:41:49.794566+02');
INSERT INTO resource_log VALUES (6321, 1940, 2, NULL, '2014-12-14 19:44:37.781977+02');
INSERT INTO resource_log VALUES (6322, 1940, 2, NULL, '2014-12-14 19:48:08.98232+02');
INSERT INTO resource_log VALUES (6323, 1940, 2, NULL, '2014-12-14 19:50:28.583831+02');
INSERT INTO resource_log VALUES (6324, 1940, 2, NULL, '2014-12-14 20:30:31.46273+02');
INSERT INTO resource_log VALUES (6325, 1936, 2, NULL, '2014-12-14 20:30:45.990313+02');
INSERT INTO resource_log VALUES (6326, 1940, 2, NULL, '2014-12-14 20:33:08.50634+02');
INSERT INTO resource_log VALUES (6327, 1940, 2, NULL, '2014-12-14 20:34:47.73587+02');
INSERT INTO resource_log VALUES (6328, 1940, 2, NULL, '2014-12-14 20:37:41.082704+02');
INSERT INTO resource_log VALUES (6329, 1653, 2, NULL, '2014-12-19 21:31:43.967187+02');
INSERT INTO resource_log VALUES (6330, 1653, 2, NULL, '2014-12-19 21:37:31.746728+02');
INSERT INTO resource_log VALUES (6331, 1951, 2, NULL, '2014-12-19 21:38:17.300837+02');
INSERT INTO resource_log VALUES (6332, 725, 2, NULL, '2014-12-19 21:38:20.726452+02');
INSERT INTO resource_log VALUES (6333, 1952, 2, NULL, '2014-12-19 21:42:56.792366+02');
INSERT INTO resource_log VALUES (6334, 1870, 2, NULL, '2014-12-19 21:43:03.803839+02');
INSERT INTO resource_log VALUES (6335, 1906, 2, NULL, '2014-12-20 16:10:55.310323+02');
INSERT INTO resource_log VALUES (6336, 1953, 2, NULL, '2014-12-20 16:12:04.822804+02');
INSERT INTO resource_log VALUES (6337, 1953, 2, NULL, '2014-12-20 16:28:56.986576+02');
INSERT INTO resource_log VALUES (6338, 1869, 2, NULL, '2014-12-20 17:01:25.535753+02');
INSERT INTO resource_log VALUES (6339, 1869, 2, NULL, '2014-12-20 17:03:12.810766+02');
INSERT INTO resource_log VALUES (6340, 1869, 2, NULL, '2014-12-20 17:03:22.550854+02');
INSERT INTO resource_log VALUES (6341, 1628, 2, NULL, '2014-12-20 17:05:00.135486+02');
INSERT INTO resource_log VALUES (6342, 1869, 2, NULL, '2014-12-20 17:05:08.130568+02');
INSERT INTO resource_log VALUES (6343, 1626, 2, NULL, '2014-12-20 17:50:11.179188+02');
INSERT INTO resource_log VALUES (6344, 1615, 2, NULL, '2014-12-20 17:50:33.508978+02');
INSERT INTO resource_log VALUES (6345, 1954, 2, NULL, '2014-12-20 18:18:17.329483+02');
INSERT INTO resource_log VALUES (6346, 1954, 2, NULL, '2014-12-20 18:18:27.668631+02');
INSERT INTO resource_log VALUES (6347, 1953, 2, NULL, '2014-12-20 18:19:03.042411+02');
INSERT INTO resource_log VALUES (6348, 1955, 2, NULL, '2014-12-20 20:57:13.189777+02');
INSERT INTO resource_log VALUES (6349, 1225, 2, NULL, '2014-12-21 12:57:50.837529+02');
INSERT INTO resource_log VALUES (6350, 1433, 2, NULL, '2014-12-21 12:57:59.036844+02');
INSERT INTO resource_log VALUES (6351, 1954, 2, NULL, '2014-12-21 13:04:30.43023+02');
INSERT INTO resource_log VALUES (6352, 1955, 2, NULL, '2014-12-21 14:01:21.220851+02');
INSERT INTO resource_log VALUES (6353, 1955, 2, NULL, '2014-12-21 14:02:48.391182+02');
INSERT INTO resource_log VALUES (6354, 1955, 2, NULL, '2014-12-21 14:05:59.186502+02');
INSERT INTO resource_log VALUES (6355, 1956, 2, NULL, '2014-12-21 14:58:01.627945+02');
INSERT INTO resource_log VALUES (6356, 1383, 2, NULL, '2014-12-21 14:58:04.4436+02');
INSERT INTO resource_log VALUES (6357, 1383, 2, NULL, '2014-12-21 14:58:18.134114+02');
INSERT INTO resource_log VALUES (6358, 1955, 2, NULL, '2014-12-21 14:58:54.05088+02');
INSERT INTO resource_log VALUES (6359, 1955, 2, NULL, '2014-12-21 14:59:43.024479+02');
INSERT INTO resource_log VALUES (6360, 1955, 2, NULL, '2014-12-21 15:01:24.559119+02');
INSERT INTO resource_log VALUES (6361, 1955, 2, NULL, '2014-12-21 15:02:30.825094+02');
INSERT INTO resource_log VALUES (6362, 1955, 2, NULL, '2014-12-21 15:03:19.517473+02');
INSERT INTO resource_log VALUES (6363, 1955, 2, NULL, '2014-12-21 15:04:26.227416+02');
INSERT INTO resource_log VALUES (6364, 1955, 2, NULL, '2014-12-21 15:05:25.219884+02');
INSERT INTO resource_log VALUES (6365, 1955, 2, NULL, '2014-12-21 15:08:14.659941+02');
INSERT INTO resource_log VALUES (6366, 1955, 2, NULL, '2014-12-21 15:09:18.610638+02');
INSERT INTO resource_log VALUES (6367, 1955, 2, NULL, '2014-12-21 15:10:49.564969+02');
INSERT INTO resource_log VALUES (6368, 1955, 2, NULL, '2014-12-21 15:18:30.435377+02');
INSERT INTO resource_log VALUES (6369, 1955, 2, NULL, '2014-12-21 15:28:30.828306+02');
INSERT INTO resource_log VALUES (6370, 1955, 2, NULL, '2014-12-21 15:30:55.116621+02');
INSERT INTO resource_log VALUES (6371, 1955, 2, NULL, '2014-12-21 15:33:38.056888+02');
INSERT INTO resource_log VALUES (6372, 1955, 2, NULL, '2014-12-21 15:34:45.870649+02');
INSERT INTO resource_log VALUES (6373, 1955, 2, NULL, '2014-12-21 15:55:27.822121+02');
INSERT INTO resource_log VALUES (6374, 1955, 2, NULL, '2014-12-21 15:56:45.477441+02');
INSERT INTO resource_log VALUES (6375, 1955, 2, NULL, '2014-12-21 15:57:54.588037+02');
INSERT INTO resource_log VALUES (6376, 1955, 2, NULL, '2014-12-21 15:59:56.190169+02');
INSERT INTO resource_log VALUES (6377, 1955, 2, NULL, '2014-12-21 16:10:48.898101+02');
INSERT INTO resource_log VALUES (6378, 1955, 2, NULL, '2014-12-21 16:11:31.348869+02');
INSERT INTO resource_log VALUES (6379, 1955, 2, NULL, '2014-12-21 16:12:17.283128+02');
INSERT INTO resource_log VALUES (6380, 1955, 2, NULL, '2014-12-21 16:12:43.349159+02');
INSERT INTO resource_log VALUES (6381, 1955, 2, NULL, '2014-12-21 16:17:53.680374+02');
INSERT INTO resource_log VALUES (6382, 1955, 2, NULL, '2014-12-21 16:18:30.615045+02');
INSERT INTO resource_log VALUES (6383, 1955, 2, NULL, '2014-12-21 16:24:07.556851+02');
INSERT INTO resource_log VALUES (6384, 1955, 2, NULL, '2014-12-21 16:24:36.284901+02');
INSERT INTO resource_log VALUES (6385, 1955, 2, NULL, '2014-12-21 16:25:59.736532+02');
INSERT INTO resource_log VALUES (6386, 1955, 2, NULL, '2014-12-21 16:26:10.717535+02');
INSERT INTO resource_log VALUES (6387, 1958, 2, NULL, '2014-12-21 19:20:00.336409+02');
INSERT INTO resource_log VALUES (6388, 1958, 2, NULL, '2014-12-21 19:40:10.412709+02');
INSERT INTO resource_log VALUES (6389, 1958, 2, NULL, '2014-12-21 19:43:18.014602+02');
INSERT INTO resource_log VALUES (6390, 1955, 2, NULL, '2014-12-21 19:54:47.763979+02');
INSERT INTO resource_log VALUES (6391, 1955, 2, NULL, '2014-12-21 19:57:15.899119+02');
INSERT INTO resource_log VALUES (6392, 1955, 2, NULL, '2014-12-21 20:01:57.931475+02');
INSERT INTO resource_log VALUES (6393, 1962, 2, NULL, '2014-12-24 21:32:53.618984+02');
INSERT INTO resource_log VALUES (6394, 1955, 2, NULL, '2014-12-24 21:52:53.75341+02');
INSERT INTO resource_log VALUES (6395, 1955, 2, NULL, '2014-12-24 21:54:29.381242+02');
INSERT INTO resource_log VALUES (6396, 1955, 2, NULL, '2014-12-24 21:54:40.852567+02');
INSERT INTO resource_log VALUES (6397, 1955, 2, NULL, '2014-12-24 21:59:02.013042+02');
INSERT INTO resource_log VALUES (6398, 1955, 2, NULL, '2014-12-24 23:47:49.852576+02');
INSERT INTO resource_log VALUES (6399, 1955, 2, NULL, '2014-12-24 23:57:47.039863+02');
INSERT INTO resource_log VALUES (6400, 1964, 2, NULL, '2014-12-25 21:05:49.345482+02');
INSERT INTO resource_log VALUES (6401, 1955, 2, NULL, '2014-12-26 20:17:47.53662+02');
INSERT INTO resource_log VALUES (6402, 1955, 2, NULL, '2014-12-26 20:29:33.803173+02');
INSERT INTO resource_log VALUES (6403, 1955, 2, NULL, '2014-12-26 20:31:12.755178+02');
INSERT INTO resource_log VALUES (6404, 1955, 2, NULL, '2014-12-26 20:32:53.259365+02');
INSERT INTO resource_log VALUES (6405, 1955, 2, NULL, '2014-12-26 20:34:24.850656+02');
INSERT INTO resource_log VALUES (6406, 1955, 2, NULL, '2014-12-26 20:36:11.286672+02');
INSERT INTO resource_log VALUES (6407, 1955, 2, NULL, '2014-12-26 20:37:54.248513+02');
INSERT INTO resource_log VALUES (6408, 1955, 2, NULL, '2014-12-26 22:13:17.525737+02');
INSERT INTO resource_log VALUES (6409, 1955, 2, NULL, '2014-12-26 22:24:22.10607+02');
INSERT INTO resource_log VALUES (6410, 1955, 2, NULL, '2014-12-26 22:28:42.906736+02');
INSERT INTO resource_log VALUES (6411, 1317, 2, NULL, '2014-12-27 14:48:10.519499+02');
INSERT INTO resource_log VALUES (6412, 1840, 2, NULL, '2014-12-27 16:05:27.016889+02');
INSERT INTO resource_log VALUES (6413, 1840, 2, NULL, '2014-12-27 16:32:05.180181+02');
INSERT INTO resource_log VALUES (6414, 1840, 2, NULL, '2014-12-27 16:45:52.831401+02');
INSERT INTO resource_log VALUES (6415, 1966, 2, NULL, '2014-12-27 19:34:56.371248+02');
INSERT INTO resource_log VALUES (6416, 1955, 2, NULL, '2014-12-28 18:35:17.644826+02');
INSERT INTO resource_log VALUES (6417, 1955, 2, NULL, '2014-12-28 19:17:37.697477+02');
INSERT INTO resource_log VALUES (6418, 1966, 2, NULL, '2014-12-31 19:10:29.989911+02');
INSERT INTO resource_log VALUES (6420, 1968, 2, NULL, '2015-01-03 12:32:10.846571+02');
INSERT INTO resource_log VALUES (6422, 1970, 2, NULL, '2015-01-03 12:35:21.670372+02');
INSERT INTO resource_log VALUES (6423, 1971, 2, NULL, '2015-01-04 12:45:51.571627+02');
INSERT INTO resource_log VALUES (6424, 1840, 2, NULL, '2015-01-04 12:45:53.947837+02');
INSERT INTO resource_log VALUES (6425, 1971, 2, NULL, '2015-01-04 12:46:35.715575+02');
INSERT INTO resource_log VALUES (6426, 1971, 2, NULL, '2015-01-04 14:05:54.230775+02');
INSERT INTO resource_log VALUES (6428, 1975, 2, NULL, '2015-01-04 14:47:53.838979+02');
INSERT INTO resource_log VALUES (6429, 1976, 2, NULL, '2015-01-04 15:06:13.604725+02');
INSERT INTO resource_log VALUES (6430, 1977, 2, NULL, '2015-01-04 16:44:50.635763+02');
INSERT INTO resource_log VALUES (6431, 1975, 2, NULL, '2015-01-04 16:54:32.711408+02');
INSERT INTO resource_log VALUES (6432, 1975, 2, NULL, '2015-01-04 17:11:52.039507+02');
INSERT INTO resource_log VALUES (6433, 1975, 2, NULL, '2015-01-04 17:31:46.570967+02');
INSERT INTO resource_log VALUES (6434, 1975, 2, NULL, '2015-01-07 14:12:48.405815+02');
INSERT INTO resource_log VALUES (6435, 1975, 2, NULL, '2015-01-07 14:22:19.046581+02');
INSERT INTO resource_log VALUES (6436, 1978, 2, NULL, '2015-01-07 18:00:22.111119+02');
INSERT INTO resource_log VALUES (6437, 1979, 2, NULL, '2015-01-07 18:22:39.961593+02');
INSERT INTO resource_log VALUES (6438, 1980, 2, NULL, '2015-01-07 18:22:48.978415+02');
INSERT INTO resource_log VALUES (6439, 1981, 2, NULL, '2015-01-07 18:23:19.524712+02');
INSERT INTO resource_log VALUES (6440, 3, 2, NULL, '2015-01-07 18:23:30.384627+02');
INSERT INTO resource_log VALUES (6441, 1982, 2, NULL, '2015-01-07 18:30:42.662112+02');
INSERT INTO resource_log VALUES (6442, 3, 2, NULL, '2015-01-07 18:30:49.411934+02');
INSERT INTO resource_log VALUES (6443, 3, 2, NULL, '2015-01-07 18:31:24.902432+02');
INSERT INTO resource_log VALUES (6444, 784, 2, NULL, '2015-01-08 13:21:17.321066+02');
INSERT INTO resource_log VALUES (6445, 784, 2, NULL, '2015-01-08 13:27:01.529898+02');
INSERT INTO resource_log VALUES (6446, 784, 2, NULL, '2015-01-08 14:19:17.153858+02');
INSERT INTO resource_log VALUES (6447, 784, 2, NULL, '2015-01-08 14:20:23.527059+02');
INSERT INTO resource_log VALUES (6448, 784, 2, NULL, '2015-01-09 10:59:22.101268+02');
INSERT INTO resource_log VALUES (6449, 1046, 2, NULL, '2015-01-12 22:16:18.421621+02');
INSERT INTO resource_log VALUES (6450, 1046, 2, NULL, '2015-01-12 22:16:29.774766+02');
INSERT INTO resource_log VALUES (6451, 1046, 2, NULL, '2015-01-12 22:18:02.620143+02');
INSERT INTO resource_log VALUES (6452, 1046, 2, NULL, '2015-01-13 17:00:13.07184+02');
INSERT INTO resource_log VALUES (6453, 1983, 2, NULL, '2015-01-13 17:00:57.932019+02');
INSERT INTO resource_log VALUES (6454, 1985, 2, NULL, '2015-01-13 17:03:06.725248+02');
INSERT INTO resource_log VALUES (6455, 1985, 2, NULL, '2015-01-14 21:32:00.651438+02');
INSERT INTO resource_log VALUES (6456, 1046, 2, NULL, '2015-01-14 21:35:47.291833+02');
INSERT INTO resource_log VALUES (6457, 1987, 2, NULL, '2015-01-15 20:30:02.464255+02');
INSERT INTO resource_log VALUES (6458, 1988, 2, NULL, '2015-01-15 21:27:50.402917+02');
INSERT INTO resource_log VALUES (6459, 1989, 2, NULL, '2015-01-17 15:06:55.170629+02');
INSERT INTO resource_log VALUES (6460, 1990, 2, NULL, '2015-01-17 19:50:58.298272+02');
INSERT INTO resource_log VALUES (6461, 1991, 2, NULL, '2015-01-17 19:50:58.298272+02');
INSERT INTO resource_log VALUES (6462, 1992, 2, NULL, '2015-01-17 19:51:20.956564+02');
INSERT INTO resource_log VALUES (6463, 1990, 2, NULL, '2015-01-17 21:28:18.900625+02');
INSERT INTO resource_log VALUES (6464, 1993, 2, NULL, '2015-01-17 21:28:36.972519+02');
INSERT INTO resource_log VALUES (6465, 1994, 2, NULL, '2015-01-17 21:50:01.04394+02');
INSERT INTO resource_log VALUES (6466, 1995, 2, NULL, '2015-01-17 21:50:14.61181+02');
INSERT INTO resource_log VALUES (6467, 1996, 2, NULL, '2015-01-17 21:54:58.910426+02');
INSERT INTO resource_log VALUES (6468, 1997, 2, NULL, '2015-01-17 21:54:58.910426+02');
INSERT INTO resource_log VALUES (6471, 2000, 2, NULL, '2015-01-17 21:56:46.645017+02');
INSERT INTO resource_log VALUES (6472, 2001, 2, NULL, '2015-01-17 21:57:17.28338+02');
INSERT INTO resource_log VALUES (6473, 2002, 2, NULL, '2015-01-17 21:57:17.28338+02');
INSERT INTO resource_log VALUES (6476, 2005, 2, NULL, '2015-01-17 22:00:19.139836+02');
INSERT INTO resource_log VALUES (6477, 2006, 2, NULL, '2015-01-17 22:00:39.986496+02');
INSERT INTO resource_log VALUES (6478, 2007, 2, NULL, '2015-01-17 22:00:39.986496+02');
INSERT INTO resource_log VALUES (6479, 2000, 2, NULL, '2015-01-17 22:01:41.277766+02');
INSERT INTO resource_log VALUES (6480, 2009, 2, NULL, '2015-01-21 21:44:18.418746+02');
INSERT INTO resource_log VALUES (6481, 1985, 2, NULL, '2015-02-01 13:03:47.123323+02');
INSERT INTO resource_log VALUES (6482, 2009, 2, NULL, '2015-02-01 13:05:09.626214+02');
INSERT INTO resource_log VALUES (6483, 2011, 2, NULL, '2015-02-01 13:23:15.549518+02');
INSERT INTO resource_log VALUES (6484, 1004, 2, NULL, '2015-02-01 13:23:17.930893+02');
INSERT INTO resource_log VALUES (6485, 2012, 2, NULL, '2015-02-01 13:51:03.67962+02');
INSERT INTO resource_log VALUES (6486, 1470, 2, NULL, '2015-02-01 13:51:06.125989+02');
INSERT INTO resource_log VALUES (6487, 2013, 2, NULL, '2015-02-01 15:08:04.506074+02');
INSERT INTO resource_log VALUES (6488, 2014, 2, NULL, '2015-02-01 15:08:25.548868+02');
INSERT INTO resource_log VALUES (6489, 2015, 2, NULL, '2015-02-01 15:09:02.223788+02');
INSERT INTO resource_log VALUES (6490, 2016, 2, NULL, '2015-02-01 15:09:49.640295+02');
INSERT INTO resource_log VALUES (6491, 2017, 2, NULL, '2015-02-01 15:09:55.959842+02');
INSERT INTO resource_log VALUES (6492, 2018, 2, NULL, '2015-02-01 15:12:43.612773+02');
INSERT INTO resource_log VALUES (6493, 2019, 2, NULL, '2015-02-01 15:13:13.911124+02');
INSERT INTO resource_log VALUES (6494, 2020, 2, NULL, '2015-02-01 15:13:27.313034+02');
INSERT INTO resource_log VALUES (6497, 2023, 2, NULL, '2015-02-01 15:16:10.834689+02');
INSERT INTO resource_log VALUES (6498, 2024, 2, NULL, '2015-02-01 15:16:30.308954+02');
INSERT INTO resource_log VALUES (6501, 2026, 2, NULL, '2015-02-01 15:27:12.501194+02');
INSERT INTO resource_log VALUES (6502, 2026, 2, NULL, '2015-02-01 15:27:30.084405+02');
INSERT INTO resource_log VALUES (6503, 2027, 2, NULL, '2015-02-01 15:27:55.689729+02');
INSERT INTO resource_log VALUES (6504, 2028, 2, NULL, '2015-02-01 15:27:55.689729+02');
INSERT INTO resource_log VALUES (6505, 2029, 2, NULL, '2015-02-01 19:41:31.921287+02');
INSERT INTO resource_log VALUES (6506, 2030, 2, NULL, '2015-02-01 19:49:07.587188+02');
INSERT INTO resource_log VALUES (6507, 2031, 2, NULL, '2015-02-01 19:49:18.380376+02');
INSERT INTO resource_log VALUES (6508, 2032, 2, NULL, '2015-02-01 19:51:03.621123+02');
INSERT INTO resource_log VALUES (6509, 1004, 2, NULL, '2015-02-01 19:51:06.683043+02');
INSERT INTO resource_log VALUES (6515, 2038, 2, NULL, '2015-02-01 19:53:59.085718+02');
INSERT INTO resource_log VALUES (6516, 2039, 2, NULL, '2015-02-01 19:53:59.085718+02');
INSERT INTO resource_log VALUES (6521, 2044, 2, NULL, '2015-02-01 19:54:52.686809+02');
INSERT INTO resource_log VALUES (6522, 2045, 2, NULL, '2015-02-01 19:54:52.686809+02');
INSERT INTO resource_log VALUES (6523, 2046, 2, NULL, '2015-02-01 19:54:52.686809+02');
INSERT INTO resource_log VALUES (6524, 2047, 2, NULL, '2015-02-01 19:54:52.686809+02');
INSERT INTO resource_log VALUES (6525, 2048, 2, NULL, '2015-02-03 20:05:38.797054+02');
INSERT INTO resource_log VALUES (6526, 2048, 2, NULL, '2015-02-03 20:06:16.781057+02');
INSERT INTO resource_log VALUES (6528, 2049, 2, NULL, '2015-02-03 21:27:11.659126+02');
INSERT INTO resource_log VALUES (6529, 2048, 2, NULL, '2015-02-03 21:27:36.200475+02');
INSERT INTO resource_log VALUES (6530, 2050, 2, NULL, '2015-02-04 21:04:02.527314+02');
INSERT INTO resource_log VALUES (6531, 2051, 2, NULL, '2015-02-04 21:04:04.474427+02');
INSERT INTO resource_log VALUES (6532, 2051, 2, NULL, '2015-02-04 21:11:28.094987+02');
INSERT INTO resource_log VALUES (6533, 2052, 2, NULL, '2015-02-04 21:11:39.281593+02');
INSERT INTO resource_log VALUES (6534, 2051, 2, NULL, '2015-02-23 21:04:13.639992+02');
INSERT INTO resource_log VALUES (6535, 1648, 2, NULL, '2015-02-24 14:58:15.754816+02');
INSERT INTO resource_log VALUES (6536, 2053, 2, NULL, '2015-02-24 21:04:03.673911+02');
INSERT INTO resource_log VALUES (6537, 2054, 2, NULL, '2015-02-24 21:04:26.838046+02');
INSERT INTO resource_log VALUES (6538, 2053, 2, NULL, '2015-02-24 21:06:05.145287+02');
INSERT INTO resource_log VALUES (6539, 2054, 2, NULL, '2015-02-24 21:06:08.284296+02');
INSERT INTO resource_log VALUES (6540, 2053, 2, NULL, '2015-02-24 21:06:25.905562+02');
INSERT INTO resource_log VALUES (6541, 2054, 2, NULL, '2015-02-24 21:06:27.830735+02');
INSERT INTO resource_log VALUES (6542, 2055, 2, NULL, '2015-03-03 16:25:23.003263+02');
INSERT INTO resource_log VALUES (6549, 1955, 2, NULL, '2015-03-04 21:39:17.186096+02');
INSERT INTO resource_log VALUES (6550, 1955, 2, NULL, '2015-03-04 21:39:30.590536+02');
INSERT INTO resource_log VALUES (6551, 1955, 2, NULL, '2015-03-05 19:52:38.505441+02');
INSERT INTO resource_log VALUES (6552, 1955, 2, NULL, '2015-03-05 19:53:54.442922+02');
INSERT INTO resource_log VALUES (6553, 2051, 2, NULL, '2015-03-05 21:22:31.156271+02');
INSERT INTO resource_log VALUES (6554, 2052, 2, NULL, '2015-03-05 21:22:34.187754+02');
INSERT INTO resource_log VALUES (6555, 2049, 2, NULL, '2015-03-07 13:59:54.391614+02');
INSERT INTO resource_log VALUES (6556, 2049, 2, NULL, '2015-03-07 14:00:01.858793+02');
INSERT INTO resource_log VALUES (6557, 2049, 2, NULL, '2015-03-07 14:00:08.905813+02');
INSERT INTO resource_log VALUES (6558, 2049, 2, NULL, '2015-03-07 17:41:13.176137+02');
INSERT INTO resource_log VALUES (6559, 2049, 2, NULL, '2015-03-07 17:41:24.454712+02');
INSERT INTO resource_log VALUES (6560, 2016, 2, NULL, '2015-03-07 19:11:45.990005+02');
INSERT INTO resource_log VALUES (6561, 1971, 2, NULL, '2015-03-07 20:39:22.05432+02');
INSERT INTO resource_log VALUES (6562, 1939, 2, NULL, '2015-03-07 20:41:30.911568+02');
INSERT INTO resource_log VALUES (6563, 1964, 2, NULL, '2015-03-07 20:41:40.386597+02');
INSERT INTO resource_log VALUES (6564, 1962, 2, NULL, '2015-03-07 20:41:47.24255+02');
INSERT INTO resource_log VALUES (6565, 2009, 2, NULL, '2015-03-07 20:41:57.590912+02');
INSERT INTO resource_log VALUES (6566, 1958, 2, NULL, '2015-03-07 20:42:08.257141+02');
INSERT INTO resource_log VALUES (6567, 2062, 2, NULL, '2015-03-07 20:44:22.388688+02');
INSERT INTO resource_log VALUES (6568, 1958, 2, NULL, '2015-03-07 20:44:57.143369+02');
INSERT INTO resource_log VALUES (6569, 1922, 2, NULL, '2015-03-07 21:16:33.311167+02');
INSERT INTO resource_log VALUES (6570, 1930, 2, NULL, '2015-03-07 21:18:30.204883+02');
INSERT INTO resource_log VALUES (6571, 1980, 2, NULL, '2015-03-07 21:18:36.892234+02');
INSERT INTO resource_log VALUES (6572, 1930, 2, NULL, '2015-03-07 21:21:01.745845+02');
INSERT INTO resource_log VALUES (6573, 1982, 2, NULL, '2015-03-07 21:45:35.899441+02');
INSERT INTO resource_log VALUES (6574, 1983, 2, NULL, '2015-03-07 21:45:46.115364+02');
INSERT INTO resource_log VALUES (6575, 1985, 2, NULL, '2015-03-07 21:45:53.837217+02');
INSERT INTO resource_log VALUES (6576, 2016, 2, NULL, '2015-03-07 21:46:03.965785+02');
INSERT INTO resource_log VALUES (6577, 1940, 2, NULL, '2015-03-07 21:46:13.798132+02');
INSERT INTO resource_log VALUES (6578, 1932, 2, NULL, '2015-03-07 21:46:22.868946+02');
INSERT INTO resource_log VALUES (6579, 1934, 2, NULL, '2015-03-07 21:46:33.42948+02');
INSERT INTO resource_log VALUES (6580, 1935, 2, NULL, '2015-03-07 21:46:42.582075+02');
INSERT INTO resource_log VALUES (6581, 1936, 2, NULL, '2015-03-07 21:46:53.561952+02');
INSERT INTO resource_log VALUES (6582, 1933, 2, NULL, '2015-03-07 21:47:06.74156+02');
INSERT INTO resource_log VALUES (6584, 1922, 2, NULL, '2015-03-08 18:02:14.423833+02');
INSERT INTO resource_log VALUES (6585, 1922, 2, NULL, '2015-03-08 18:02:24.288542+02');
INSERT INTO resource_log VALUES (6586, 1989, 2, NULL, '2015-03-08 18:07:00.091644+02');
INSERT INTO resource_log VALUES (6587, 1922, 2, NULL, '2015-03-08 18:17:03.971743+02');
INSERT INTO resource_log VALUES (6588, 1922, 2, NULL, '2015-03-08 18:29:12.5349+02');
INSERT INTO resource_log VALUES (6589, 2063, 2, NULL, '2015-03-08 18:41:45.468589+02');
INSERT INTO resource_log VALUES (6590, 1989, 2, NULL, '2015-03-08 18:41:51.822924+02');
INSERT INTO resource_log VALUES (6592, 2065, 2, NULL, '2015-03-09 14:02:38.899688+02');
INSERT INTO resource_log VALUES (6593, 2066, 2, NULL, '2015-03-09 17:16:22.759831+02');
INSERT INTO resource_log VALUES (6594, 2068, 2, NULL, '2015-03-09 19:28:40.834898+02');
INSERT INTO resource_log VALUES (6595, 1980, 2, NULL, '2015-03-09 19:37:29.594475+02');
INSERT INTO resource_log VALUES (6596, 1389, 2, NULL, '2015-03-15 19:00:11.360402+02');
INSERT INTO resource_log VALUES (6597, 1389, 2, NULL, '2015-03-15 19:07:00.022851+02');
INSERT INTO resource_log VALUES (6598, 1389, 2, NULL, '2015-03-15 19:08:22.540227+02');
INSERT INTO resource_log VALUES (6599, 2070, 2, NULL, '2015-03-21 15:11:50.495946+02');
INSERT INTO resource_log VALUES (6600, 1989, 2, NULL, '2015-03-21 15:11:59.182752+02');
INSERT INTO resource_log VALUES (6603, 2052, 2, NULL, '2015-03-21 16:50:40.821135+02');
INSERT INTO resource_log VALUES (6605, 2052, 2, NULL, '2015-03-21 16:52:47.683727+02');
INSERT INTO resource_log VALUES (6606, 2075, 2, NULL, '2015-03-21 17:05:47.83578+02');
INSERT INTO resource_log VALUES (6607, 2075, 2, NULL, '2015-03-21 17:06:12.331454+02');
INSERT INTO resource_log VALUES (6608, 2052, 2, NULL, '2015-03-21 17:06:35.32059+02');
INSERT INTO resource_log VALUES (6609, 2070, 2, NULL, '2015-03-21 17:48:31.664941+02');
INSERT INTO resource_log VALUES (6610, 2077, 2, NULL, '2015-03-21 17:49:14.645342+02');
INSERT INTO resource_log VALUES (6618, 2052, 2, NULL, '2015-03-21 18:16:06.930298+02');
INSERT INTO resource_log VALUES (6621, 2052, 2, NULL, '2015-03-21 18:19:16.455929+02');
INSERT INTO resource_log VALUES (6622, 2087, 2, NULL, '2015-03-21 18:20:19.713186+02');
INSERT INTO resource_log VALUES (6623, 2052, 2, NULL, '2015-03-21 18:20:29.187736+02');
INSERT INTO resource_log VALUES (6624, 2052, 2, NULL, '2015-03-21 19:28:39.349206+02');
INSERT INTO resource_log VALUES (6625, 2052, 2, NULL, '2015-03-21 19:30:14.844869+02');
INSERT INTO resource_log VALUES (6626, 2052, 2, NULL, '2015-03-21 19:33:54.902921+02');
INSERT INTO resource_log VALUES (6627, 2052, 2, NULL, '2015-03-21 19:34:11.317898+02');
INSERT INTO resource_log VALUES (6628, 2052, 2, NULL, '2015-03-21 19:35:55.581037+02');
INSERT INTO resource_log VALUES (6629, 2052, 2, NULL, '2015-03-21 19:36:06.902031+02');
INSERT INTO resource_log VALUES (6630, 2052, 2, NULL, '2015-03-21 19:36:15.834648+02');
INSERT INTO resource_log VALUES (6631, 2052, 2, NULL, '2015-03-21 19:36:28.227499+02');
INSERT INTO resource_log VALUES (6632, 2052, 2, NULL, '2015-03-21 19:36:44.271289+02');
INSERT INTO resource_log VALUES (6633, 2088, 2, NULL, '2015-03-21 19:36:44.271289+02');
INSERT INTO resource_log VALUES (6634, 2089, 2, NULL, '2015-03-21 19:38:07.835672+02');
INSERT INTO resource_log VALUES (6635, 2090, 2, NULL, '2015-03-21 19:38:10.203402+02');
INSERT INTO resource_log VALUES (6637, 2052, 2, NULL, '2015-03-21 19:40:18.868487+02');
INSERT INTO resource_log VALUES (6638, 2052, 2, NULL, '2015-03-21 19:41:03.761402+02');
INSERT INTO resource_log VALUES (6639, 2052, 2, NULL, '2015-03-21 19:42:48.725752+02');
INSERT INTO resource_log VALUES (6640, 2052, 2, NULL, '2015-03-21 19:43:52.346215+02');
INSERT INTO resource_log VALUES (6641, 2092, 2, NULL, '2015-03-21 20:11:35.939948+02');
INSERT INTO resource_log VALUES (6642, 2052, 2, NULL, '2015-03-21 20:11:42.394011+02');
INSERT INTO resource_log VALUES (6643, 2052, 2, NULL, '2015-03-21 20:12:01.524624+02');
INSERT INTO resource_log VALUES (6646, 2052, 2, NULL, '2015-03-21 21:14:06.180767+02');
INSERT INTO resource_log VALUES (6647, 2095, 2, NULL, '2015-03-21 22:03:40.435063+02');
INSERT INTO resource_log VALUES (6648, 2051, 2, NULL, '2015-03-21 22:03:42.699321+02');
INSERT INTO resource_log VALUES (6649, 2088, 2, NULL, '2015-03-21 22:03:45.19164+02');
INSERT INTO resource_log VALUES (6650, 2052, 2, NULL, '2015-03-21 22:12:59.222848+02');
INSERT INTO resource_log VALUES (6651, 971, 2, NULL, '2015-03-22 16:55:09.922468+02');
INSERT INTO resource_log VALUES (6652, 2096, 2, NULL, '2015-03-22 17:22:28.394236+02');
INSERT INTO resource_log VALUES (6653, 970, 2, NULL, '2015-03-22 17:22:30.31308+02');
INSERT INTO resource_log VALUES (6654, 971, 2, NULL, '2015-03-22 17:32:58.675826+02');
INSERT INTO resource_log VALUES (6655, 2097, 2, NULL, '2015-03-22 17:35:36.969555+02');
INSERT INTO resource_log VALUES (6656, 2052, 2, NULL, '2015-03-22 17:35:38.710629+02');
INSERT INTO resource_log VALUES (6657, 2052, 2, NULL, '2015-03-22 17:35:54.667572+02');
INSERT INTO resource_log VALUES (6658, 2052, 2, NULL, '2015-03-22 17:36:02.394493+02');
INSERT INTO resource_log VALUES (6659, 1413, 2, NULL, '2015-03-22 21:10:23.96026+02');
INSERT INTO resource_log VALUES (6660, 2098, 2, NULL, '2015-03-22 21:12:12.040889+02');
INSERT INTO resource_log VALUES (6661, 1413, 2, NULL, '2015-03-22 21:12:14.574907+02');
INSERT INTO resource_log VALUES (6662, 953, 2, NULL, '2015-03-23 10:52:07.126828+02');
INSERT INTO resource_log VALUES (6663, 955, 2, NULL, '2015-03-23 10:52:46.434534+02');
INSERT INTO resource_log VALUES (6664, 955, 2, NULL, '2015-03-23 10:53:07.107505+02');
INSERT INTO resource_log VALUES (6665, 971, 2, NULL, '2015-03-23 11:17:09.549645+02');
INSERT INTO resource_log VALUES (6666, 971, 2, NULL, '2015-03-23 11:17:14.786132+02');
INSERT INTO resource_log VALUES (6667, 971, 2, NULL, '2015-03-23 22:30:47.611278+02');
INSERT INTO resource_log VALUES (6668, 2099, 2, NULL, '2015-03-24 19:25:49.743645+02');
INSERT INTO resource_log VALUES (6669, 2100, 2, NULL, '2015-03-24 19:26:22.746874+02');
INSERT INTO resource_log VALUES (6670, 2101, 2, NULL, '2015-03-24 19:30:50.825716+02');
INSERT INTO resource_log VALUES (6671, 1413, 2, NULL, '2015-03-24 21:27:29.027714+02');
INSERT INTO resource_log VALUES (6672, 1413, 2, NULL, '2015-03-24 21:27:56.025596+02');
INSERT INTO resource_log VALUES (6673, 2104, 2, NULL, '2015-03-25 22:08:36.018637+02');
INSERT INTO resource_log VALUES (6674, 2105, 2, NULL, '2015-03-25 22:09:11.121353+02');
INSERT INTO resource_log VALUES (6675, 2106, 2, NULL, '2015-03-25 22:10:32.26983+02');
INSERT INTO resource_log VALUES (6676, 2107, 2, NULL, '2015-03-27 21:02:27.365736+02');
INSERT INTO resource_log VALUES (6677, 1413, 2, NULL, '2015-03-27 22:11:48.664734+02');
INSERT INTO resource_log VALUES (6678, 1318, 2, NULL, '2015-03-27 22:11:57.175441+02');
INSERT INTO resource_log VALUES (6679, 2108, 2, NULL, '2015-03-27 22:14:09.702895+02');
INSERT INTO resource_log VALUES (6680, 1413, 2, NULL, '2015-03-27 22:14:23.177174+02');
INSERT INTO resource_log VALUES (6681, 1975, 2, NULL, '2015-03-29 14:54:09.090695+03');
INSERT INTO resource_log VALUES (6682, 1975, 2, NULL, '2015-03-29 14:56:05.558074+03');
INSERT INTO resource_log VALUES (6683, 2054, 2, NULL, '2015-03-29 18:10:37.298528+03');
INSERT INTO resource_log VALUES (6684, 2054, 2, NULL, '2015-03-29 18:10:44.494853+03');
INSERT INTO resource_log VALUES (6685, 2054, 2, NULL, '2015-03-29 18:11:59.351954+03');
INSERT INTO resource_log VALUES (6686, 894, 2, NULL, '2015-03-29 18:12:33.345883+03');
INSERT INTO resource_log VALUES (6687, 2108, 2, NULL, '2015-03-29 18:41:14.962865+03');
INSERT INTO resource_log VALUES (6688, 2108, 2, NULL, '2015-03-29 18:41:28.932911+03');
INSERT INTO resource_log VALUES (6689, 2108, 2, NULL, '2015-03-29 18:41:35.361837+03');
INSERT INTO resource_log VALUES (6693, 1578, 2, NULL, '2015-03-29 19:28:18.094577+03');
INSERT INTO resource_log VALUES (6694, 1563, 2, NULL, '2015-03-29 19:28:26.306719+03');
INSERT INTO resource_log VALUES (6695, 1560, 2, NULL, '2015-03-29 19:28:31.032916+03');
INSERT INTO resource_log VALUES (6696, 1649, 2, NULL, '2015-03-29 20:30:21.118741+03');
INSERT INTO resource_log VALUES (6698, 2111, 2, NULL, '2015-03-29 20:32:08.188477+03');
INSERT INTO resource_log VALUES (6699, 918, 2, NULL, '2015-03-29 20:45:02.042426+03');
INSERT INTO resource_log VALUES (6700, 918, 2, NULL, '2015-03-29 20:45:08.391579+03');
INSERT INTO resource_log VALUES (6701, 917, 2, NULL, '2015-03-29 20:45:13.080299+03');
INSERT INTO resource_log VALUES (6702, 916, 2, NULL, '2015-03-29 20:45:17.094049+03');
INSERT INTO resource_log VALUES (6703, 952, 2, NULL, '2015-03-29 20:51:29.823177+03');
INSERT INTO resource_log VALUES (6705, 988, 2, NULL, '2015-03-29 20:57:38.470567+03');
INSERT INTO resource_log VALUES (6707, 971, 2, NULL, '2015-03-29 21:04:32.587955+03');
INSERT INTO resource_log VALUES (6709, 1647, 2, NULL, '2015-03-29 21:11:13.101083+03');
INSERT INTO resource_log VALUES (6710, 2115, 2, NULL, '2015-03-29 21:11:20.771189+03');
INSERT INTO resource_log VALUES (6711, 1648, 2, NULL, '2015-03-29 21:19:19.348961+03');
INSERT INTO resource_log VALUES (6713, 1646, 2, NULL, '2015-03-29 21:25:36.400114+03');
INSERT INTO resource_log VALUES (6715, 1419, 2, NULL, '2015-03-31 18:55:34.756779+03');
INSERT INTO resource_log VALUES (6716, 1415, 2, NULL, '2015-03-31 18:55:54.50919+03');
INSERT INTO resource_log VALUES (6718, 1507, 2, NULL, '2015-03-31 19:11:10.805316+03');
INSERT INTO resource_log VALUES (6719, 1507, 2, NULL, '2015-03-31 19:11:17.000092+03');
INSERT INTO resource_log VALUES (6720, 1507, 2, NULL, '2015-03-31 19:11:23.716877+03');
INSERT INTO resource_log VALUES (6721, 1898, 2, NULL, '2015-03-31 19:19:08.662529+03');
INSERT INTO resource_log VALUES (6722, 1898, 2, NULL, '2015-03-31 19:19:13.979595+03');
INSERT INTO resource_log VALUES (6723, 1898, 2, NULL, '2015-03-31 19:19:19.541915+03');
INSERT INTO resource_log VALUES (6724, 2119, 2, NULL, '2015-03-31 19:31:32.255315+03');
INSERT INTO resource_log VALUES (6725, 1419, 2, NULL, '2015-03-31 19:31:35.171043+03');
INSERT INTO resource_log VALUES (6726, 2120, 2, NULL, '2015-03-31 21:42:30.209371+03');
INSERT INTO resource_log VALUES (6727, 2107, 2, NULL, '2015-04-06 22:18:27.344977+03');
INSERT INTO resource_log VALUES (6728, 2054, 2, NULL, '2015-04-22 09:31:23.533867+03');
INSERT INTO resource_log VALUES (6729, 2126, 2, NULL, '2015-04-22 10:21:50.083529+03');
INSERT INTO resource_log VALUES (6730, 2126, 2, NULL, '2015-04-22 10:34:35.83663+03');
INSERT INTO resource_log VALUES (6731, 2127, 2, NULL, '2015-04-22 15:08:30.934237+03');
INSERT INTO resource_log VALUES (6732, 2128, 2, NULL, '2015-04-22 15:09:24.597951+03');
INSERT INTO resource_log VALUES (6733, 2129, 2, NULL, '2015-04-22 15:30:21.099029+03');
INSERT INTO resource_log VALUES (6734, 2130, 2, NULL, '2015-04-22 15:30:28.848383+03');
INSERT INTO resource_log VALUES (6735, 2131, 2, NULL, '2015-04-22 15:33:06.666889+03');
INSERT INTO resource_log VALUES (6736, 2126, 2, NULL, '2015-04-22 15:33:09.520564+03');
INSERT INTO resource_log VALUES (6737, 2132, 2, NULL, '2015-04-22 15:34:13.439147+03');
INSERT INTO resource_log VALUES (6738, 2126, 2, NULL, '2015-04-22 15:34:14.494849+03');
INSERT INTO resource_log VALUES (6739, 2126, 2, NULL, '2015-04-22 15:34:41.240196+03');
INSERT INTO resource_log VALUES (6740, 2130, 2, NULL, '2015-04-24 21:16:26.897843+03');
INSERT INTO resource_log VALUES (6741, 953, 2, NULL, '2015-04-24 21:38:02.133997+03');
INSERT INTO resource_log VALUES (6742, 955, 2, NULL, '2015-04-24 21:39:08.574084+03');
INSERT INTO resource_log VALUES (6743, 2108, 2, NULL, '2015-04-25 13:14:21.858762+03');
INSERT INTO resource_log VALUES (6745, 2135, 2, NULL, '2015-04-25 16:39:24.611492+03');
INSERT INTO resource_log VALUES (6746, 2128, 2, NULL, '2015-04-25 16:59:29.339712+03');
INSERT INTO resource_log VALUES (6747, 2136, 2, NULL, '2015-04-25 16:59:52.412523+03');
INSERT INTO resource_log VALUES (6748, 2137, 2, NULL, '2015-04-25 21:29:39.820793+03');
INSERT INTO resource_log VALUES (6749, 2138, 2, NULL, '2015-04-25 21:29:47.819244+03');
INSERT INTO resource_log VALUES (6750, 2139, 2, NULL, '2015-04-25 21:29:55.72108+03');
INSERT INTO resource_log VALUES (6751, 2144, 2, NULL, '2015-04-26 00:17:08.072699+03');
INSERT INTO resource_log VALUES (6752, 2145, 2, NULL, '2015-04-26 00:17:08.072699+03');
INSERT INTO resource_log VALUES (6753, 2146, 2, NULL, '2015-04-26 00:22:46.640907+03');
INSERT INTO resource_log VALUES (6754, 2147, 2, NULL, '2015-04-26 00:22:46.640907+03');
INSERT INTO resource_log VALUES (6755, 2148, 2, NULL, '2015-04-26 00:26:59.761945+03');
INSERT INTO resource_log VALUES (6756, 2149, 2, NULL, '2015-04-26 00:26:59.761945+03');
INSERT INTO resource_log VALUES (6757, 2150, 2, NULL, '2015-04-26 00:30:11.687983+03');
INSERT INTO resource_log VALUES (6758, 2151, 2, NULL, '2015-04-26 00:30:11.687983+03');
INSERT INTO resource_log VALUES (6759, 2152, 2, NULL, '2015-04-26 00:36:42.355592+03');
INSERT INTO resource_log VALUES (6760, 2153, 2, NULL, '2015-04-26 00:36:42.355592+03');
INSERT INTO resource_log VALUES (6761, 2154, 2, NULL, '2015-04-26 00:44:52.209962+03');
INSERT INTO resource_log VALUES (6762, 2155, 2, NULL, '2015-04-26 00:44:52.209962+03');
INSERT INTO resource_log VALUES (6763, 2156, 2, NULL, '2015-04-26 09:56:13.81422+03');
INSERT INTO resource_log VALUES (6764, 2157, 2, NULL, '2015-04-26 09:56:13.81422+03');
INSERT INTO resource_log VALUES (6765, 2158, 2, NULL, '2015-04-26 10:00:13.021078+03');
INSERT INTO resource_log VALUES (6766, 2159, 2, NULL, '2015-04-26 10:00:13.021078+03');
INSERT INTO resource_log VALUES (6767, 2160, 2, NULL, '2015-04-26 10:09:07.981749+03');
INSERT INTO resource_log VALUES (6768, 2161, 2, NULL, '2015-04-26 10:09:07.981749+03');
INSERT INTO resource_log VALUES (6769, 2162, 2, NULL, '2015-04-26 10:11:20.869074+03');
INSERT INTO resource_log VALUES (6770, 2163, 2, NULL, '2015-04-26 10:11:20.869074+03');
INSERT INTO resource_log VALUES (6771, 2164, 2, NULL, '2015-04-26 10:23:35.980962+03');
INSERT INTO resource_log VALUES (6772, 2165, 2, NULL, '2015-04-26 10:23:35.980962+03');
INSERT INTO resource_log VALUES (6774, 2167, 2, NULL, '2015-04-26 10:30:42.474899+03');
INSERT INTO resource_log VALUES (6775, 2168, 2, NULL, '2015-04-26 10:30:42.474899+03');
INSERT INTO resource_log VALUES (6778, 2171, 2, NULL, '2015-04-26 10:38:49.924523+03');
INSERT INTO resource_log VALUES (6779, 2172, 2, NULL, '2015-04-26 10:41:15.682562+03');
INSERT INTO resource_log VALUES (6780, 2173, 2, NULL, '2015-04-26 10:41:15.682562+03');
INSERT INTO resource_log VALUES (6781, 2174, 2, NULL, '2015-04-26 10:51:18.425172+03');
INSERT INTO resource_log VALUES (6782, 2175, 2, NULL, '2015-04-26 10:51:18.425172+03');
INSERT INTO resource_log VALUES (6783, 2176, 2, NULL, '2015-04-26 10:54:26.243589+03');
INSERT INTO resource_log VALUES (6784, 2177, 2, NULL, '2015-04-26 10:54:26.243589+03');
INSERT INTO resource_log VALUES (6785, 2178, 2, NULL, '2015-04-26 10:57:26.669326+03');
INSERT INTO resource_log VALUES (6786, 2179, 2, NULL, '2015-04-26 10:57:26.669326+03');
INSERT INTO resource_log VALUES (6787, 2180, 2, NULL, '2015-04-26 11:08:04.739521+03');
INSERT INTO resource_log VALUES (6788, 2181, 2, NULL, '2015-04-26 11:08:04.739521+03');
INSERT INTO resource_log VALUES (6789, 2182, 2, NULL, '2015-04-26 11:13:10.975009+03');
INSERT INTO resource_log VALUES (6790, 2183, 2, NULL, '2015-04-26 11:13:10.975009+03');
INSERT INTO resource_log VALUES (6791, 2184, 2, NULL, '2015-04-26 13:03:25.416787+03');
INSERT INTO resource_log VALUES (6792, 2185, 2, NULL, '2015-04-26 13:03:25.416787+03');
INSERT INTO resource_log VALUES (6793, 2186, 2, NULL, '2015-04-26 13:42:49.969814+03');
INSERT INTO resource_log VALUES (6794, 2187, 2, NULL, '2015-04-26 14:04:42.384772+03');
INSERT INTO resource_log VALUES (6795, 2188, 2, NULL, '2015-04-26 14:04:42.384772+03');
INSERT INTO resource_log VALUES (6796, 2189, 2, NULL, '2015-04-26 14:05:26.994527+03');
INSERT INTO resource_log VALUES (6797, 2190, 2, NULL, '2015-04-26 14:05:26.994527+03');
INSERT INTO resource_log VALUES (6798, 2186, 2, NULL, '2015-04-26 14:05:29.313624+03');
INSERT INTO resource_log VALUES (6801, 2197, 2, NULL, '2015-05-03 13:21:34.120955+03');
INSERT INTO resource_log VALUES (6802, 2197, 2, NULL, '2015-05-03 13:23:12.828981+03');
INSERT INTO resource_log VALUES (6803, 2197, 2, NULL, '2015-05-03 13:34:38.831852+03');
INSERT INTO resource_log VALUES (6804, 2197, 2, NULL, '2015-05-03 13:40:51.674186+03');
INSERT INTO resource_log VALUES (6805, 2199, 2, NULL, '2015-05-03 23:18:19.876372+03');
INSERT INTO resource_log VALUES (6806, 1780, 2, NULL, '2015-05-03 23:18:33.103558+03');
INSERT INTO resource_log VALUES (6807, 1368, 2, NULL, '2015-05-04 19:21:58.460934+03');
INSERT INTO resource_log VALUES (6808, 1368, 2, NULL, '2015-05-04 19:22:20.533133+03');
INSERT INTO resource_log VALUES (6809, 2200, 2, NULL, '2015-05-04 20:57:01.637182+03');
INSERT INTO resource_log VALUES (6810, 2201, 2, NULL, '2015-05-04 20:58:33.565049+03');
INSERT INTO resource_log VALUES (6811, 2203, 2, NULL, '2015-05-04 21:30:33.485239+03');
INSERT INTO resource_log VALUES (6812, 1003, 2, NULL, '2015-05-08 21:15:22.303904+03');
INSERT INTO resource_log VALUES (6813, 2205, 2, NULL, '2015-05-08 22:38:40.1563+03');
INSERT INTO resource_log VALUES (6814, 2206, 2, NULL, '2015-05-08 22:40:57.101857+03');
INSERT INTO resource_log VALUES (6815, 2207, 2, NULL, '2015-05-08 22:43:00.228497+03');
INSERT INTO resource_log VALUES (6816, 2208, 2, NULL, '2015-05-08 22:43:46.205549+03');
INSERT INTO resource_log VALUES (6817, 2209, 2, NULL, '2015-05-09 15:04:04.437709+03');
INSERT INTO resource_log VALUES (6818, 2210, 2, NULL, '2015-05-09 15:18:42.295591+03');
INSERT INTO resource_log VALUES (6819, 2211, 2, NULL, '2015-05-09 15:20:41.04877+03');
INSERT INTO resource_log VALUES (6820, 2212, 2, NULL, '2015-05-09 15:21:16.54612+03');
INSERT INTO resource_log VALUES (6821, 2213, 2, NULL, '2015-05-09 15:21:20.750661+03');
INSERT INTO resource_log VALUES (6822, 2214, 2, NULL, '2015-05-09 15:27:46.304009+03');
INSERT INTO resource_log VALUES (6823, 2215, 2, NULL, '2015-05-09 15:27:52.157735+03');
INSERT INTO resource_log VALUES (6824, 2216, 2, NULL, '2015-05-09 15:32:20.738122+03');
INSERT INTO resource_log VALUES (6825, 2216, 2, NULL, '2015-05-09 15:34:43.153612+03');
INSERT INTO resource_log VALUES (6826, 2216, 2, NULL, '2015-05-09 15:35:37.080548+03');
INSERT INTO resource_log VALUES (6827, 2216, 2, NULL, '2015-05-09 15:36:20.491648+03');
INSERT INTO resource_log VALUES (6828, 2216, 2, NULL, '2015-05-09 15:36:28.290218+03');
INSERT INTO resource_log VALUES (6829, 2217, 2, NULL, '2015-05-09 16:10:30.715652+03');
INSERT INTO resource_log VALUES (6830, 2218, 2, NULL, '2015-05-09 16:40:29.294581+03');
INSERT INTO resource_log VALUES (6831, 2216, 2, NULL, '2015-05-09 16:40:47.688279+03');
INSERT INTO resource_log VALUES (6832, 2219, 2, NULL, '2015-05-09 16:52:43.81748+03');
INSERT INTO resource_log VALUES (6833, 1550, 2, NULL, '2015-05-09 16:53:04.04708+03');
INSERT INTO resource_log VALUES (6834, 1008, 2, NULL, '2015-05-09 16:53:15.905297+03');
INSERT INTO resource_log VALUES (6836, 2218, 2, NULL, '2015-05-09 16:56:24.612587+03');
INSERT INTO resource_log VALUES (6837, 2221, 2, NULL, '2015-05-09 16:58:37.060459+03');
INSERT INTO resource_log VALUES (6838, 2216, 2, NULL, '2015-05-09 17:04:04.921556+03');
INSERT INTO resource_log VALUES (6839, 2216, 2, NULL, '2015-05-09 17:04:48.531212+03');
INSERT INTO resource_log VALUES (6840, 1563, 2, NULL, '2015-05-09 19:32:44.822595+03');
INSERT INTO resource_log VALUES (6841, 2222, 2, NULL, '2015-05-09 19:43:25.178079+03');
INSERT INTO resource_log VALUES (6842, 2215, 2, NULL, '2015-05-09 20:07:16.539791+03');
INSERT INTO resource_log VALUES (6843, 2216, 2, NULL, '2015-05-09 20:07:46.078918+03');
INSERT INTO resource_log VALUES (6844, 2223, 2, NULL, '2015-05-09 20:08:53.78535+03');
INSERT INTO resource_log VALUES (6845, 2224, 2, NULL, '2015-05-09 20:09:23.379411+03');
INSERT INTO resource_log VALUES (6846, 2225, 2, NULL, '2015-05-09 20:09:44.887962+03');
INSERT INTO resource_log VALUES (6847, 2226, 2, NULL, '2015-05-09 20:17:22.088876+03');
INSERT INTO resource_log VALUES (6848, 2227, 2, NULL, '2015-05-09 20:29:08.971941+03');
INSERT INTO resource_log VALUES (6849, 2228, 2, NULL, '2015-05-09 20:29:24.701653+03');
INSERT INTO resource_log VALUES (6850, 2229, 2, NULL, '2015-05-09 20:29:40.419576+03');
INSERT INTO resource_log VALUES (6851, 2224, 2, NULL, '2015-05-09 20:29:49.729598+03');
INSERT INTO resource_log VALUES (6852, 2230, 2, NULL, '2015-05-09 20:30:09.233291+03');
INSERT INTO resource_log VALUES (6853, 2231, 2, NULL, '2015-05-09 20:30:23.623593+03');
INSERT INTO resource_log VALUES (6854, 2232, 2, NULL, '2015-05-09 20:30:35.560504+03');
INSERT INTO resource_log VALUES (6855, 2233, 2, NULL, '2015-05-09 20:30:51.356148+03');
INSERT INTO resource_log VALUES (6856, 2234, 2, NULL, '2015-05-09 20:31:09.312334+03');
INSERT INTO resource_log VALUES (6857, 2235, 2, NULL, '2015-05-09 20:31:21.029136+03');
INSERT INTO resource_log VALUES (6858, 2236, 2, NULL, '2015-05-09 20:31:43.127575+03');
INSERT INTO resource_log VALUES (6859, 2237, 2, NULL, '2015-05-09 20:31:57.326798+03');
INSERT INTO resource_log VALUES (6860, 2238, 2, NULL, '2015-05-09 20:32:20.746647+03');
INSERT INTO resource_log VALUES (6861, 2239, 2, NULL, '2015-05-09 20:32:35.107871+03');
INSERT INTO resource_log VALUES (6862, 2240, 2, NULL, '2015-05-09 20:32:50.419187+03');
INSERT INTO resource_log VALUES (6863, 2241, 2, NULL, '2015-05-09 20:33:01.999568+03');
INSERT INTO resource_log VALUES (6864, 2242, 2, NULL, '2015-05-09 20:33:16.190303+03');
INSERT INTO resource_log VALUES (6865, 2236, 2, NULL, '2015-05-09 20:54:08.857766+03');
INSERT INTO resource_log VALUES (6866, 2216, 2, NULL, '2015-05-09 21:04:14.03464+03');
INSERT INTO resource_log VALUES (6867, 1578, 2, NULL, '2015-05-09 21:16:42.718164+03');
INSERT INTO resource_log VALUES (6868, 2243, 2, NULL, '2015-05-10 13:44:27.494956+03');
INSERT INTO resource_log VALUES (6869, 2244, 2, NULL, '2015-05-10 13:45:29.048699+03');
INSERT INTO resource_log VALUES (6870, 2245, 2, NULL, '2015-05-10 13:46:40.29071+03');
INSERT INTO resource_log VALUES (6871, 2246, 2, NULL, '2015-05-10 14:01:26.829403+03');
INSERT INTO resource_log VALUES (6872, 2247, 2, NULL, '2015-05-10 14:01:57.254972+03');
INSERT INTO resource_log VALUES (6873, 2248, 2, NULL, '2015-05-10 14:10:42.034833+03');
INSERT INTO resource_log VALUES (6874, 2249, 2, NULL, '2015-05-10 14:10:53.000133+03');
INSERT INTO resource_log VALUES (6875, 2254, 2, NULL, '2015-05-10 14:35:53.336283+03');
INSERT INTO resource_log VALUES (6876, 2255, 2, NULL, '2015-05-10 14:35:53.336283+03');
INSERT INTO resource_log VALUES (6877, 2256, 2, NULL, '2015-05-10 14:39:45.730714+03');
INSERT INTO resource_log VALUES (6878, 2257, 2, NULL, '2015-05-10 14:39:45.730714+03');
INSERT INTO resource_log VALUES (6879, 2258, 2, NULL, '2015-05-10 14:45:11.098493+03');
INSERT INTO resource_log VALUES (6880, 2259, 2, NULL, '2015-05-10 14:45:11.098493+03');
INSERT INTO resource_log VALUES (6881, 2260, 2, NULL, '2015-05-10 14:53:32.27851+03');
INSERT INTO resource_log VALUES (6882, 2261, 2, NULL, '2015-05-10 14:53:32.27851+03');
INSERT INTO resource_log VALUES (6883, 2262, 2, NULL, '2015-05-10 14:57:13.121414+03');
INSERT INTO resource_log VALUES (6884, 2263, 2, NULL, '2015-05-10 14:57:13.121414+03');
INSERT INTO resource_log VALUES (6885, 2264, 2, NULL, '2015-05-10 14:57:55.441966+03');
INSERT INTO resource_log VALUES (6886, 2265, 2, NULL, '2015-05-10 15:07:20.399588+03');
INSERT INTO resource_log VALUES (6887, 2266, 2, NULL, '2015-05-10 15:07:20.399588+03');
INSERT INTO resource_log VALUES (6888, 2267, 2, NULL, '2015-05-10 15:07:27.786314+03');
INSERT INTO resource_log VALUES (6889, 2268, 2, NULL, '2015-05-10 16:04:17.22685+03');
INSERT INTO resource_log VALUES (6890, 2269, 2, NULL, '2015-05-10 16:04:56.471262+03');
INSERT INTO resource_log VALUES (6891, 1318, 2, NULL, '2015-05-10 16:05:16.31159+03');
INSERT INTO resource_log VALUES (6892, 2270, 2, NULL, '2015-05-10 16:07:24.626275+03');
INSERT INTO resource_log VALUES (6893, 2271, 2, NULL, '2015-05-10 16:08:32.663974+03');
INSERT INTO resource_log VALUES (6894, 2272, 2, NULL, '2015-05-10 16:08:35.587577+03');
INSERT INTO resource_log VALUES (6895, 2273, 2, NULL, '2015-05-10 16:08:47.271902+03');
INSERT INTO resource_log VALUES (6896, 2274, 2, NULL, '2015-05-10 16:08:47.271902+03');
INSERT INTO resource_log VALUES (6897, 2275, 2, NULL, '2015-05-10 16:09:34.650716+03');
INSERT INTO resource_log VALUES (6898, 2276, 2, NULL, '2015-05-10 22:11:18.586994+03');
INSERT INTO resource_log VALUES (6899, 2277, 2, NULL, '2015-05-10 22:12:40.523328+03');
INSERT INTO resource_log VALUES (6900, 1314, 2, NULL, '2015-05-10 22:12:56.872348+03');
INSERT INTO resource_log VALUES (6901, 2278, 2, NULL, '2015-05-10 22:14:48.438204+03');
INSERT INTO resource_log VALUES (6902, 2279, 2, NULL, '2015-05-10 22:14:48.438204+03');
INSERT INTO resource_log VALUES (6903, 2280, 2, NULL, '2015-05-10 22:19:21.083289+03');
INSERT INTO resource_log VALUES (6904, 2280, 2, NULL, '2015-05-13 21:55:52.759278+03');
INSERT INTO resource_log VALUES (6905, 2275, 2, NULL, '2015-05-13 21:56:48.008072+03');
INSERT INTO resource_log VALUES (6906, 2267, 2, NULL, '2015-05-13 21:56:54.031403+03');
INSERT INTO resource_log VALUES (6907, 2264, 2, NULL, '2015-05-13 21:56:59.496539+03');
INSERT INTO resource_log VALUES (6908, 2281, 2, NULL, '2015-05-16 15:29:57.002389+03');
INSERT INTO resource_log VALUES (6909, 2282, 2, NULL, '2015-05-16 15:34:53.800182+03');
INSERT INTO resource_log VALUES (6910, 2283, 2, NULL, '2015-05-16 15:34:53.800182+03');
INSERT INTO resource_log VALUES (6911, 2284, 2, NULL, '2015-05-16 15:36:09.929045+03');
INSERT INTO resource_log VALUES (6912, 2285, 2, NULL, '2015-05-16 15:45:33.371911+03');
INSERT INTO resource_log VALUES (6913, 2286, 2, NULL, '2015-05-16 15:45:33.371911+03');
INSERT INTO resource_log VALUES (6914, 2287, 2, NULL, '2015-05-16 15:48:18.436182+03');
INSERT INTO resource_log VALUES (6915, 2288, 2, NULL, '2015-05-16 15:48:18.436182+03');
INSERT INTO resource_log VALUES (6916, 2289, 2, NULL, '2015-05-17 21:30:51.134604+03');
INSERT INTO resource_log VALUES (6917, 2280, 2, NULL, '2015-05-17 21:31:00.094313+03');
INSERT INTO resource_log VALUES (6918, 2290, 2, NULL, '2015-05-17 21:31:39.003456+03');
INSERT INTO resource_log VALUES (6919, 2280, 2, NULL, '2015-05-17 21:31:48.129633+03');
INSERT INTO resource_log VALUES (6920, 2284, 2, NULL, '2015-05-17 22:02:03.373006+03');
INSERT INTO resource_log VALUES (6921, 2284, 2, NULL, '2015-05-17 22:02:31.027832+03');
INSERT INTO resource_log VALUES (6922, 2291, 2, NULL, '2015-05-18 16:39:17.24427+03');
INSERT INTO resource_log VALUES (6923, 2284, 2, NULL, '2015-05-18 16:40:09.305094+03');
INSERT INTO resource_log VALUES (6924, 2284, 2, NULL, '2015-05-18 20:31:39.659544+03');
INSERT INTO resource_log VALUES (6925, 2284, 2, NULL, '2015-05-18 20:34:34.03653+03');
INSERT INTO resource_log VALUES (6926, 2284, 2, NULL, '2015-05-18 21:22:46.805573+03');
INSERT INTO resource_log VALUES (6927, 2292, 2, NULL, '2015-05-24 12:55:28.784478+03');
INSERT INTO resource_log VALUES (6928, 1212, 2, NULL, '2015-05-24 13:06:21.488837+03');
INSERT INTO resource_log VALUES (6929, 2293, 2, NULL, '2015-05-24 15:06:40.212091+03');
INSERT INTO resource_log VALUES (6930, 2294, 2, NULL, '2015-05-24 15:11:44.965777+03');
INSERT INTO resource_log VALUES (6931, 2295, 2, NULL, '2015-05-24 16:49:53.513439+03');
INSERT INTO resource_log VALUES (6932, 2296, 2, NULL, '2015-05-24 16:50:41.467323+03');
INSERT INTO resource_log VALUES (6933, 2297, 2, NULL, '2015-05-24 16:55:00.642026+03');
INSERT INTO resource_log VALUES (6934, 2299, 2, NULL, '2015-05-24 16:57:39.672043+03');
INSERT INTO resource_log VALUES (6935, 2300, 2, NULL, '2015-05-24 17:03:51.85238+03');
INSERT INTO resource_log VALUES (6936, 2088, 2, NULL, '2015-05-24 17:03:55.878998+03');
INSERT INTO resource_log VALUES (6937, 2301, 2, NULL, '2015-05-24 17:04:54.502108+03');
INSERT INTO resource_log VALUES (6938, 2088, 2, NULL, '2015-05-24 17:10:16.729607+03');
INSERT INTO resource_log VALUES (6939, 2088, 2, NULL, '2015-05-24 17:10:29.437025+03');
INSERT INTO resource_log VALUES (6940, 2088, 2, NULL, '2015-05-24 17:15:30.592241+03');
INSERT INTO resource_log VALUES (6941, 2302, 2, NULL, '2015-05-24 17:16:33.029089+03');
INSERT INTO resource_log VALUES (6942, 2075, 2, NULL, '2015-05-24 17:16:41.742578+03');
INSERT INTO resource_log VALUES (6943, 2303, 2, NULL, '2015-05-24 17:17:17.81127+03');
INSERT INTO resource_log VALUES (6944, 2088, 2, NULL, '2015-05-24 17:17:21.677682+03');
INSERT INTO resource_log VALUES (6945, 2305, 2, NULL, '2015-05-24 20:37:07.412723+03');
INSERT INTO resource_log VALUES (6946, 2052, 2, NULL, '2015-05-24 20:37:10.892479+03');
INSERT INTO resource_log VALUES (6947, 2088, 2, NULL, '2015-05-24 21:01:25.501241+03');
INSERT INTO resource_log VALUES (6948, 2052, 2, NULL, '2015-05-24 21:13:25.598747+03');
INSERT INTO resource_log VALUES (6949, 2306, 2, NULL, '2015-05-24 21:14:39.628922+03');
INSERT INTO resource_log VALUES (6950, 2052, 2, NULL, '2015-05-24 21:14:43.723121+03');
INSERT INTO resource_log VALUES (6951, 2280, 2, NULL, '2015-05-24 21:21:32.476216+03');
INSERT INTO resource_log VALUES (6952, 2280, 2, NULL, '2015-05-24 21:22:00.849383+03');
INSERT INTO resource_log VALUES (6953, 2280, 2, NULL, '2015-05-24 21:22:09.702717+03');
INSERT INTO resource_log VALUES (6954, 2307, 2, NULL, '2015-05-24 21:32:02.910902+03');
INSERT INTO resource_log VALUES (6955, 2308, 2, NULL, '2015-05-24 21:32:24.738611+03');
INSERT INTO resource_log VALUES (6956, 2309, 2, NULL, '2015-05-24 21:32:31.516248+03');
INSERT INTO resource_log VALUES (6957, 2310, 2, NULL, '2015-05-24 21:33:17.528061+03');
INSERT INTO resource_log VALUES (6958, 2311, 2, NULL, '2015-05-24 21:35:46.300244+03');
INSERT INTO resource_log VALUES (6959, 2312, 2, NULL, '2015-05-24 21:36:06.190691+03');
INSERT INTO resource_log VALUES (6960, 2312, 2, NULL, '2015-05-24 21:36:27.205265+03');
INSERT INTO resource_log VALUES (6961, 2313, 2, NULL, '2015-05-25 21:31:05.718794+03');
INSERT INTO resource_log VALUES (6962, 2312, 2, NULL, '2015-05-25 21:31:08.674137+03');
INSERT INTO resource_log VALUES (6963, 2314, 2, NULL, '2015-05-26 20:44:11.702313+03');
INSERT INTO resource_log VALUES (6964, 2315, 2, NULL, '2015-05-26 20:44:48.242189+03');
INSERT INTO resource_log VALUES (6965, 2316, 2, NULL, '2015-05-26 20:44:48.242189+03');
INSERT INTO resource_log VALUES (6966, 2317, 2, NULL, '2015-05-26 20:45:01.161364+03');
INSERT INTO resource_log VALUES (6967, 2284, 2, NULL, '2015-05-28 13:46:35.94219+03');
INSERT INTO resource_log VALUES (6968, 2317, 2, NULL, '2015-05-28 13:46:45.92498+03');
INSERT INTO resource_log VALUES (6969, 2280, 2, NULL, '2015-05-28 13:46:51.874219+03');
INSERT INTO resource_log VALUES (6970, 1507, 2, NULL, '2015-05-31 21:55:12.660877+03');
INSERT INTO resource_log VALUES (6971, 1507, 2, NULL, '2015-05-31 21:56:27.809825+03');
INSERT INTO resource_log VALUES (6972, 1439, 2, NULL, '2015-05-31 21:57:11.520889+03');
INSERT INTO resource_log VALUES (6973, 1507, 2, NULL, '2015-05-31 21:58:33.173778+03');
INSERT INTO resource_log VALUES (6974, 1507, 2, NULL, '2015-05-31 22:00:02.964614+03');
INSERT INTO resource_log VALUES (6975, 1507, 2, NULL, '2015-05-31 22:00:38.733485+03');
INSERT INTO resource_log VALUES (6976, 1507, 2, NULL, '2015-05-31 22:11:01.827304+03');
INSERT INTO resource_log VALUES (6977, 1507, 2, NULL, '2015-06-01 09:54:54.423199+03');
INSERT INTO resource_log VALUES (6978, 2284, 2, NULL, '2015-06-01 11:22:28.244232+03');
INSERT INTO resource_log VALUES (6979, 2319, 2, NULL, '2015-06-01 11:37:24.071069+03');
INSERT INTO resource_log VALUES (6980, 2320, 2, NULL, '2015-06-01 12:56:01.185317+03');
INSERT INTO resource_log VALUES (6986, 2327, 2, NULL, '2015-06-02 13:22:30.670092+03');
INSERT INTO resource_log VALUES (6987, 2328, 2, NULL, '2015-06-02 13:22:36.147873+03');
INSERT INTO resource_log VALUES (6988, 2329, 2, NULL, '2015-06-02 13:23:35.222007+03');
INSERT INTO resource_log VALUES (6989, 2330, 2, NULL, '2015-06-02 13:24:32.384898+03');
INSERT INTO resource_log VALUES (6990, 2331, 2, NULL, '2015-06-02 13:25:52.745886+03');
INSERT INTO resource_log VALUES (6991, 2332, 2, NULL, '2015-06-02 13:27:31.983851+03');
INSERT INTO resource_log VALUES (6992, 2333, 2, NULL, '2015-06-02 13:27:36.950926+03');
INSERT INTO resource_log VALUES (6993, 2334, 2, NULL, '2015-06-02 13:28:43.733459+03');
INSERT INTO resource_log VALUES (6994, 2335, 2, NULL, '2015-06-02 13:29:10.771807+03');
INSERT INTO resource_log VALUES (6995, 2336, 2, NULL, '2015-06-02 13:29:57.138464+03');
INSERT INTO resource_log VALUES (6996, 2337, 2, NULL, '2015-06-02 13:30:11.199071+03');
INSERT INTO resource_log VALUES (6997, 2338, 2, NULL, '2015-06-02 13:34:47.558077+03');
INSERT INTO resource_log VALUES (6998, 2339, 2, NULL, '2015-06-02 13:34:50.130325+03');
INSERT INTO resource_log VALUES (6999, 2340, 2, NULL, '2015-06-02 13:35:46.336511+03');
INSERT INTO resource_log VALUES (7000, 2341, 2, NULL, '2015-06-02 13:36:09.066506+03');
INSERT INTO resource_log VALUES (7001, 2342, 2, NULL, '2015-06-02 13:36:09.066506+03');
INSERT INTO resource_log VALUES (7002, 2343, 2, NULL, '2015-06-02 13:37:26.99598+03');
INSERT INTO resource_log VALUES (7003, 2344, 2, NULL, '2015-06-02 13:37:26.99598+03');
INSERT INTO resource_log VALUES (7004, 2345, 2, NULL, '2015-06-02 13:37:42.100766+03');
INSERT INTO resource_log VALUES (7023, 2345, 2, NULL, '2015-06-06 20:33:35.089301+03');
INSERT INTO resource_log VALUES (7024, 2366, 2, NULL, '2015-06-06 21:47:05.357423+03');
INSERT INTO resource_log VALUES (7025, 2367, 2, NULL, '2015-06-06 21:47:08.978477+03');
INSERT INTO resource_log VALUES (7026, 2368, 2, NULL, '2015-06-06 21:49:00.661472+03');
INSERT INTO resource_log VALUES (7027, 2369, 2, NULL, '2015-06-06 21:50:18.211354+03');
INSERT INTO resource_log VALUES (7028, 2370, 2, NULL, '2015-06-06 21:51:07.167429+03');
INSERT INTO resource_log VALUES (7029, 2371, 2, NULL, '2015-06-06 21:52:21.362863+03');
INSERT INTO resource_log VALUES (7030, 2372, 2, NULL, '2015-06-06 21:52:25.91268+03');
INSERT INTO resource_log VALUES (7031, 2367, 2, NULL, '2015-06-06 22:01:59.580344+03');
INSERT INTO resource_log VALUES (7032, 2373, 2, NULL, '2015-06-06 22:05:50.240364+03');
INSERT INTO resource_log VALUES (7033, 2374, 2, NULL, '2015-06-06 22:06:07.223567+03');
INSERT INTO resource_log VALUES (7034, 2375, 2, NULL, '2015-06-06 22:06:55.79185+03');
INSERT INTO resource_log VALUES (7035, 2376, 2, NULL, '2015-06-06 22:07:46.643073+03');
INSERT INTO resource_log VALUES (7036, 2377, 2, NULL, '2015-06-06 22:08:11.14074+03');
INSERT INTO resource_log VALUES (7037, 2378, 2, NULL, '2015-06-06 22:08:11.14074+03');
INSERT INTO resource_log VALUES (7038, 2379, 2, NULL, '2015-06-06 22:10:53.894076+03');
INSERT INTO resource_log VALUES (7039, 2380, 2, NULL, '2015-06-06 22:10:53.894076+03');
INSERT INTO resource_log VALUES (7040, 2381, 2, NULL, '2015-06-06 22:12:04.71986+03');
INSERT INTO resource_log VALUES (7041, 2382, 2, NULL, '2015-06-06 22:12:17.899878+03');
INSERT INTO resource_log VALUES (7042, 2372, 2, NULL, '2015-06-06 22:12:34.850437+03');
INSERT INTO resource_log VALUES (7043, 2383, 2, NULL, '2015-06-06 22:34:30.822368+03');
INSERT INTO resource_log VALUES (7044, 2384, 2, NULL, '2015-06-06 22:35:06.098136+03');
INSERT INTO resource_log VALUES (7045, 2385, 2, NULL, '2015-06-06 22:35:22.838833+03');
INSERT INTO resource_log VALUES (7046, 2382, 2, NULL, '2015-06-06 22:36:33.646314+03');
INSERT INTO resource_log VALUES (7047, 2388, 2, NULL, '2015-06-06 22:43:36.614024+03');
INSERT INTO resource_log VALUES (7048, 2382, 2, NULL, '2015-06-07 15:30:58.294045+03');
INSERT INTO resource_log VALUES (7049, 2247, 2, NULL, '2015-06-07 17:10:29.033956+03');
INSERT INTO resource_log VALUES (7050, 1413, 2, NULL, '2015-06-07 17:10:56.929199+03');
INSERT INTO resource_log VALUES (7051, 1318, 2, NULL, '2015-06-07 17:11:36.862031+03');
INSERT INTO resource_log VALUES (7052, 1314, 2, NULL, '2015-06-07 17:12:28.161782+03');
INSERT INTO resource_log VALUES (7053, 1431, 2, NULL, '2015-06-07 19:55:54.571452+03');
INSERT INTO resource_log VALUES (7054, 1898, 2, NULL, '2015-06-07 19:59:40.465993+03');
INSERT INTO resource_log VALUES (7055, 1898, 2, NULL, '2015-06-07 20:00:47.882499+03');
INSERT INTO resource_log VALUES (7056, 1432, 2, NULL, '2015-06-07 20:00:59.808075+03');
INSERT INTO resource_log VALUES (7057, 1608, 2, NULL, '2015-06-07 20:01:30.177316+03');
INSERT INTO resource_log VALUES (7058, 1609, 2, NULL, '2015-06-07 20:02:19.266681+03');
INSERT INTO resource_log VALUES (7059, 1769, 2, NULL, '2015-06-07 20:03:05.939338+03');
INSERT INTO resource_log VALUES (7060, 1780, 2, NULL, '2015-06-07 20:04:36.345782+03');
INSERT INTO resource_log VALUES (7061, 1873, 2, NULL, '2015-06-07 20:05:07.816356+03');
INSERT INTO resource_log VALUES (7062, 1898, 2, NULL, '2015-06-07 20:05:26.076509+03');
INSERT INTO resource_log VALUES (7063, 2199, 2, NULL, '2015-06-07 20:05:57.959925+03');
INSERT INTO resource_log VALUES (7064, 2246, 2, NULL, '2015-06-07 20:06:32.075272+03');
INSERT INTO resource_log VALUES (7065, 2246, 2, NULL, '2015-06-07 20:06:41.085651+03');
INSERT INTO resource_log VALUES (7066, 2269, 2, NULL, '2015-06-07 20:07:23.767588+03');
INSERT INTO resource_log VALUES (7067, 2277, 2, NULL, '2015-06-07 20:07:57.192127+03');
INSERT INTO resource_log VALUES (7068, 1426, 2, NULL, '2015-06-07 20:09:52.309668+03');
INSERT INTO resource_log VALUES (7069, 2389, 2, NULL, '2015-06-07 20:10:03.246206+03');
INSERT INTO resource_log VALUES (7070, 2390, 2, NULL, '2015-06-07 20:10:21.42447+03');
INSERT INTO resource_log VALUES (7071, 2391, 2, NULL, '2015-06-07 20:10:54.694938+03');
INSERT INTO resource_log VALUES (7072, 2392, 2, NULL, '2015-06-07 20:11:12.709328+03');
INSERT INTO resource_log VALUES (7073, 2393, 2, NULL, '2015-06-07 20:11:33.449675+03');
INSERT INTO resource_log VALUES (7074, 2394, 2, NULL, '2015-06-07 20:11:54.80775+03');
INSERT INTO resource_log VALUES (7075, 2395, 2, NULL, '2015-06-07 20:12:24.648998+03');
INSERT INTO resource_log VALUES (7076, 2396, 2, NULL, '2015-06-07 20:12:47.549001+03');
INSERT INTO resource_log VALUES (7077, 2397, 2, NULL, '2015-06-07 20:13:09.482196+03');
INSERT INTO resource_log VALUES (7078, 2398, 2, NULL, '2015-06-07 20:13:26.815118+03');
INSERT INTO resource_log VALUES (7079, 2399, 2, NULL, '2015-06-07 20:13:43.442647+03');
INSERT INTO resource_log VALUES (7080, 2400, 2, NULL, '2015-06-07 20:13:57.868779+03');
INSERT INTO resource_log VALUES (7081, 2401, 2, NULL, '2015-06-07 20:14:15.895967+03');
INSERT INTO resource_log VALUES (7082, 2402, 2, NULL, '2015-06-07 20:14:42.501203+03');
INSERT INTO resource_log VALUES (7083, 2403, 2, NULL, '2015-06-07 20:15:33.611845+03');
INSERT INTO resource_log VALUES (7084, 2404, 2, NULL, '2015-06-07 20:15:53.460657+03');
INSERT INTO resource_log VALUES (7085, 2405, 2, NULL, '2015-06-07 20:16:10.772685+03');
INSERT INTO resource_log VALUES (7086, 2406, 2, NULL, '2015-06-07 20:16:32.442601+03');
INSERT INTO resource_log VALUES (7087, 2407, 2, NULL, '2015-06-07 20:16:56.509083+03');
INSERT INTO resource_log VALUES (7088, 2408, 2, NULL, '2015-06-07 20:17:19.457924+03');
INSERT INTO resource_log VALUES (7089, 2409, 2, NULL, '2015-06-07 20:17:39.828441+03');
INSERT INTO resource_log VALUES (7090, 2410, 2, NULL, '2015-06-07 20:17:59.953522+03');
INSERT INTO resource_log VALUES (7091, 2411, 2, NULL, '2015-06-07 20:18:15.36941+03');
INSERT INTO resource_log VALUES (7092, 2412, 2, NULL, '2015-06-07 20:18:33.319787+03');
INSERT INTO resource_log VALUES (7093, 2413, 2, NULL, '2015-06-07 20:18:53.786993+03');
INSERT INTO resource_log VALUES (7094, 2414, 2, NULL, '2015-06-07 20:19:17.251882+03');
INSERT INTO resource_log VALUES (7095, 2415, 2, NULL, '2015-06-07 20:34:54.782206+03');
INSERT INTO resource_log VALUES (7096, 2416, 2, NULL, '2015-06-07 20:35:11.96143+03');
INSERT INTO resource_log VALUES (7097, 2417, 2, NULL, '2015-06-07 20:35:33.998015+03');
INSERT INTO resource_log VALUES (7098, 2418, 2, NULL, '2015-06-07 20:36:01.596002+03');
INSERT INTO resource_log VALUES (7099, 2419, 2, NULL, '2015-06-07 20:36:15.960332+03');
INSERT INTO resource_log VALUES (7100, 2420, 2, NULL, '2015-06-07 20:36:35.413228+03');
INSERT INTO resource_log VALUES (7101, 2421, 2, NULL, '2015-06-07 20:37:30.352425+03');
INSERT INTO resource_log VALUES (7102, 2422, 2, NULL, '2015-06-07 20:37:53.888785+03');
INSERT INTO resource_log VALUES (7103, 2423, 2, NULL, '2015-06-07 20:38:10.610447+03');
INSERT INTO resource_log VALUES (7104, 2424, 2, NULL, '2015-06-07 20:38:59.517394+03');
INSERT INTO resource_log VALUES (7105, 2425, 2, NULL, '2015-06-07 20:39:26.415211+03');
INSERT INTO resource_log VALUES (7106, 2426, 2, NULL, '2015-06-07 20:40:05.840226+03');
INSERT INTO resource_log VALUES (7107, 2427, 2, NULL, '2015-06-07 20:40:46.537019+03');
INSERT INTO resource_log VALUES (7108, 2428, 2, NULL, '2015-06-07 20:41:01.3009+03');
INSERT INTO resource_log VALUES (7109, 2429, 2, NULL, '2015-06-07 20:41:17.634439+03');
INSERT INTO resource_log VALUES (7110, 2430, 2, NULL, '2015-06-07 20:41:36.56949+03');
INSERT INTO resource_log VALUES (7111, 2431, 2, NULL, '2015-06-07 20:41:54.944525+03');
INSERT INTO resource_log VALUES (7112, 2432, 2, NULL, '2015-06-07 20:42:11.063081+03');
INSERT INTO resource_log VALUES (7113, 2433, 2, NULL, '2015-06-10 21:10:55.543668+03');
INSERT INTO resource_log VALUES (7114, 2434, 2, NULL, '2015-06-10 21:10:58.272269+03');
INSERT INTO resource_log VALUES (7115, 2434, 2, NULL, '2015-06-10 21:11:16.546457+03');
INSERT INTO resource_log VALUES (7116, 2435, 2, NULL, '2015-06-10 21:11:49.343497+03');
INSERT INTO resource_log VALUES (7117, 2436, 2, NULL, '2015-06-10 21:12:20.087946+03');
INSERT INTO resource_log VALUES (7119, 2437, 2, NULL, '2015-06-10 21:13:28.379702+03');
INSERT INTO resource_log VALUES (7120, 2434, 2, NULL, '2015-06-10 21:13:35.658848+03');
INSERT INTO resource_log VALUES (7118, 2434, 2, NULL, '2015-06-10 21:12:30.557424+03');
INSERT INTO resource_log VALUES (7121, 2434, 2, NULL, '2015-06-13 11:08:16.884538+03');
INSERT INTO resource_log VALUES (7122, 2438, 2, NULL, '2015-06-13 12:24:23.664338+03');
INSERT INTO resource_log VALUES (7123, 2439, 2, NULL, '2015-06-13 12:25:12.11639+03');
INSERT INTO resource_log VALUES (7124, 2440, 2, NULL, '2015-06-13 12:25:55.053099+03');
INSERT INTO resource_log VALUES (7125, 2439, 2, NULL, '2015-06-13 12:28:23.509307+03');
INSERT INTO resource_log VALUES (7126, 1431, 2, NULL, '2015-06-13 16:13:14.891511+03');
INSERT INTO resource_log VALUES (7127, 2269, 2, NULL, '2015-06-13 16:29:21.58833+03');
INSERT INTO resource_log VALUES (7128, 2391, 2, NULL, '2015-06-13 16:29:38.922876+03');
INSERT INTO resource_log VALUES (7130, 2442, 2, NULL, '2015-06-13 17:22:11.365048+03');
INSERT INTO resource_log VALUES (7162, 2450, 2, NULL, '2015-06-13 19:58:22.391173+03');
INSERT INTO resource_log VALUES (7163, 2317, 2, NULL, '2015-06-13 19:58:33.103367+03');
INSERT INTO resource_log VALUES (7164, 2451, 2, NULL, '2015-06-13 19:59:50.784052+03');
INSERT INTO resource_log VALUES (7165, 2452, 2, NULL, '2015-06-13 19:59:50.784052+03');
INSERT INTO resource_log VALUES (7166, 2317, 2, NULL, '2015-06-13 20:00:28.712308+03');
INSERT INTO resource_log VALUES (7167, 2317, 2, NULL, '2015-06-13 20:01:26.421434+03');
INSERT INTO resource_log VALUES (7168, 2317, 2, NULL, '2015-06-13 20:03:24.653457+03');
INSERT INTO resource_log VALUES (7176, 2451, 2, NULL, '2015-06-14 10:07:32.690694+03');
INSERT INTO resource_log VALUES (7177, 2451, 2, NULL, '2015-06-14 10:16:32.619194+03');
INSERT INTO resource_log VALUES (7178, 2451, 2, NULL, '2015-06-14 13:13:57.393431+03');
INSERT INTO resource_log VALUES (7179, 2451, 2, NULL, '2015-06-14 13:21:50.094038+03');
INSERT INTO resource_log VALUES (7180, 2451, 2, NULL, '2015-06-14 13:22:37.050016+03');
INSERT INTO resource_log VALUES (7181, 2451, 2, NULL, '2015-06-14 13:23:13.387606+03');
INSERT INTO resource_log VALUES (7182, 2451, 2, NULL, '2015-06-14 13:23:25.25704+03');
INSERT INTO resource_log VALUES (7183, 2457, 2, NULL, '2015-06-14 13:25:18.074212+03');
INSERT INTO resource_log VALUES (7184, 2451, 2, NULL, '2015-06-14 13:26:56.97373+03');
INSERT INTO resource_log VALUES (7185, 2458, 2, NULL, '2015-06-14 13:28:59.472857+03');
INSERT INTO resource_log VALUES (7186, 2459, 2, NULL, '2015-06-14 13:29:40.688494+03');
INSERT INTO resource_log VALUES (7187, 2457, 2, NULL, '2015-06-14 14:17:22.935487+03');
INSERT INTO resource_log VALUES (7199, 2463, 2, NULL, '2015-06-14 16:30:22.760587+03');
INSERT INTO resource_log VALUES (7201, 2463, 2, NULL, '2015-06-14 16:43:36.808614+03');
INSERT INTO resource_log VALUES (7202, 2465, 2, NULL, '2015-06-14 18:28:13.295968+03');
INSERT INTO resource_log VALUES (7203, 2466, 2, NULL, '2015-06-14 18:50:25.96227+03');
INSERT INTO resource_log VALUES (7204, 2467, 2, NULL, '2015-06-14 18:50:57.662486+03');
INSERT INTO resource_log VALUES (7205, 2468, 2, NULL, '2015-06-17 21:13:39.6663+03');
INSERT INTO resource_log VALUES (7206, 2469, 2, NULL, '2015-06-17 21:13:39.6663+03');
INSERT INTO resource_log VALUES (7207, 2469, 2, NULL, '2015-06-17 21:39:31.5421+03');
INSERT INTO resource_log VALUES (7208, 2470, 2, NULL, '2015-06-17 21:39:43.056809+03');
INSERT INTO resource_log VALUES (7211, 2296, 2, NULL, '2015-06-17 22:28:24.889672+03');
INSERT INTO resource_log VALUES (7212, 2296, 2, NULL, '2015-06-17 22:28:44.137455+03');
INSERT INTO resource_log VALUES (7213, 2296, 2, NULL, '2015-06-17 22:28:55.531055+03');
INSERT INTO resource_log VALUES (7214, 2296, 2, NULL, '2015-06-17 22:29:04.688414+03');
INSERT INTO resource_log VALUES (7217, 1190, 2, NULL, '2015-06-18 08:41:45.975909+03');
INSERT INTO resource_log VALUES (7218, 1190, 2, NULL, '2015-06-18 08:41:55.712142+03');
INSERT INTO resource_log VALUES (7219, 2475, 2, NULL, '2015-06-18 08:47:40.598128+03');
INSERT INTO resource_log VALUES (7221, 1043, 2, NULL, '2015-06-18 08:49:28.676473+03');
INSERT INTO resource_log VALUES (7222, 2477, 2, NULL, '2015-06-18 08:53:01.574753+03');
INSERT INTO resource_log VALUES (7229, 2484, 2, NULL, '2015-06-18 09:11:44.190988+03');
INSERT INTO resource_log VALUES (7230, 2477, 2, NULL, '2015-06-18 09:15:16.231618+03');
INSERT INTO resource_log VALUES (7232, 2486, 2, NULL, '2015-06-19 08:53:30.530081+03');
INSERT INTO resource_log VALUES (7234, 2488, 2, NULL, '2015-06-19 08:57:49.623777+03');
INSERT INTO resource_log VALUES (7235, 2489, 2, NULL, '2015-06-19 08:57:56.925224+03');
INSERT INTO resource_log VALUES (7236, 2490, 2, NULL, '2015-06-19 08:58:47.001543+03');
INSERT INTO resource_log VALUES (7237, 2491, 2, NULL, '2015-06-19 09:01:01.141859+03');
INSERT INTO resource_log VALUES (7238, 2492, 2, NULL, '2015-06-19 09:04:12.050796+03');
INSERT INTO resource_log VALUES (7239, 2493, 2, NULL, '2015-06-19 09:05:15.381515+03');
INSERT INTO resource_log VALUES (7241, 1010, 2, NULL, '2015-06-19 09:18:51.710345+03');
INSERT INTO resource_log VALUES (7243, 2496, 2, NULL, '2015-06-19 09:22:30.421219+03');
INSERT INTO resource_log VALUES (7244, 2129, 2, NULL, '2015-06-19 09:22:37.844576+03');
INSERT INTO resource_log VALUES (7247, 2499, 2, NULL, '2015-06-19 09:24:13.472874+03');
INSERT INTO resource_log VALUES (7248, 2137, 2, NULL, '2015-06-19 09:24:18.706637+03');
INSERT INTO resource_log VALUES (7250, 2248, 2, NULL, '2015-06-19 09:24:53.046897+03');
INSERT INTO resource_log VALUES (7251, 2477, 2, NULL, '2015-06-20 10:13:49.575046+03');
INSERT INTO resource_log VALUES (7252, 2484, 2, NULL, '2015-06-20 10:13:59.32685+03');
INSERT INTO resource_log VALUES (7253, 2501, 2, NULL, '2015-06-20 10:23:36.01186+03');
INSERT INTO resource_log VALUES (7254, 2490, 2, NULL, '2015-06-20 10:24:30.090794+03');
INSERT INTO resource_log VALUES (7255, 2502, 2, NULL, '2015-06-20 10:25:23.92051+03');
INSERT INTO resource_log VALUES (7256, 2490, 2, NULL, '2015-06-20 10:25:26.171733+03');
INSERT INTO resource_log VALUES (7257, 2503, 2, NULL, '2015-06-20 10:58:18.119129+03');
INSERT INTO resource_log VALUES (7259, 2505, 2, NULL, '2015-06-20 11:21:58.139735+03');
INSERT INTO resource_log VALUES (7260, 2506, 2, NULL, '2015-06-20 11:22:00.401736+03');
INSERT INTO resource_log VALUES (7261, 2507, 2, NULL, '2015-06-20 11:22:46.430212+03');
INSERT INTO resource_log VALUES (7262, 2506, 2, NULL, '2015-06-20 11:22:51.478424+03');
INSERT INTO resource_log VALUES (7263, 2508, 2, NULL, '2015-06-20 11:23:54.736317+03');
INSERT INTO resource_log VALUES (7264, 2506, 2, NULL, '2015-06-20 11:23:56.167951+03');
INSERT INTO resource_log VALUES (7265, 2345, 2, NULL, '2015-06-20 11:26:36.603828+03');
INSERT INTO resource_log VALUES (7266, 2345, 2, NULL, '2015-06-20 11:27:18.047841+03');
INSERT INTO resource_log VALUES (7268, 2345, 2, NULL, '2015-06-20 11:46:46.13788+03');
INSERT INTO resource_log VALUES (7269, 2510, 2, NULL, '2015-06-20 11:50:12.161837+03');
INSERT INTO resource_log VALUES (7270, 2511, 2, NULL, '2015-06-20 11:50:13.525526+03');
INSERT INTO resource_log VALUES (7272, 2463, 2, NULL, '2015-06-20 23:00:10.769493+03');
INSERT INTO resource_log VALUES (7273, 2467, 2, NULL, '2015-06-20 23:00:18.463896+03');
INSERT INTO resource_log VALUES (7274, 2459, 2, NULL, '2015-06-20 23:00:44.920864+03');
INSERT INTO resource_log VALUES (7275, 2458, 2, NULL, '2015-06-20 23:00:51.132288+03');
INSERT INTO resource_log VALUES (7276, 2457, 2, NULL, '2015-06-20 23:00:57.565186+03');
INSERT INTO resource_log VALUES (7277, 2451, 2, NULL, '2015-06-20 23:01:04.368039+03');
INSERT INTO resource_log VALUES (7278, 2451, 2, NULL, '2015-06-20 23:04:17.342527+03');
INSERT INTO resource_log VALUES (7279, 2457, 2, NULL, '2015-06-20 23:04:23.315461+03');
INSERT INTO resource_log VALUES (7280, 2458, 2, NULL, '2015-06-20 23:04:30.160097+03');
INSERT INTO resource_log VALUES (7281, 2459, 2, NULL, '2015-06-20 23:04:35.721205+03');
INSERT INTO resource_log VALUES (7282, 1896, 2, NULL, '2015-06-21 11:16:22.975624+03');
INSERT INTO resource_log VALUES (7285, 2459, 2, NULL, '2015-06-21 11:19:17.963777+03');
INSERT INTO resource_log VALUES (7286, 2458, 2, NULL, '2015-06-21 11:19:23.880837+03');
INSERT INTO resource_log VALUES (7287, 2457, 2, NULL, '2015-06-21 11:19:29.44712+03');
INSERT INTO resource_log VALUES (7288, 2451, 2, NULL, '2015-06-21 11:19:35.471458+03');
INSERT INTO resource_log VALUES (7289, 2467, 2, NULL, '2015-06-21 11:19:54.443461+03');
INSERT INTO resource_log VALUES (7290, 2463, 2, NULL, '2015-06-21 11:20:00.085347+03');
INSERT INTO resource_log VALUES (7291, 2465, 2, NULL, '2015-06-21 11:21:33.270335+03');
INSERT INTO resource_log VALUES (7292, 2513, 2, NULL, '2015-06-23 22:26:54.54596+03');
INSERT INTO resource_log VALUES (7293, 778, 2, NULL, '2015-06-23 22:31:51.561928+03');
INSERT INTO resource_log VALUES (7294, 2514, 2, NULL, '2015-06-23 22:34:29.078834+03');
INSERT INTO resource_log VALUES (7295, 2514, 2, NULL, '2015-06-23 22:36:01.548881+03');
INSERT INTO resource_log VALUES (7296, 2513, 2, NULL, '2015-06-23 22:42:58.979814+03');
INSERT INTO resource_log VALUES (7297, 2514, 2, NULL, '2015-06-23 22:46:14.322892+03');
INSERT INTO resource_log VALUES (7298, 2515, 2, NULL, '2015-06-23 22:48:32.462285+03');
INSERT INTO resource_log VALUES (7299, 2477, 2, NULL, '2015-06-27 16:53:47.400114+03');
INSERT INTO resource_log VALUES (7300, 2477, 2, NULL, '2015-06-27 17:29:32.884456+03');
INSERT INTO resource_log VALUES (7301, 2477, 2, NULL, '2015-06-27 17:32:15.776144+03');
INSERT INTO resource_log VALUES (7302, 2477, 2, NULL, '2015-06-27 17:33:05.384003+03');
INSERT INTO resource_log VALUES (7303, 2477, 2, NULL, '2015-06-27 17:35:05.607746+03');
INSERT INTO resource_log VALUES (7304, 2477, 2, NULL, '2015-06-27 17:36:45.346277+03');
INSERT INTO resource_log VALUES (7305, 2477, 2, NULL, '2015-06-27 17:38:01.404518+03');
INSERT INTO resource_log VALUES (7306, 784, 2, NULL, '2015-06-27 17:39:03.474446+03');
INSERT INTO resource_log VALUES (7307, 784, 2, NULL, '2015-06-27 17:52:48.813097+03');
INSERT INTO resource_log VALUES (7308, 885, 2, NULL, '2015-06-27 17:53:15.731358+03');
INSERT INTO resource_log VALUES (7309, 2053, 2, NULL, '2015-06-27 17:58:30.465951+03');
INSERT INTO resource_log VALUES (7310, 2477, 2, NULL, '2015-06-27 19:15:20.180008+03');
INSERT INTO resource_log VALUES (7311, 2477, 2, NULL, '2015-06-27 19:49:02.708272+03');
INSERT INTO resource_log VALUES (7312, 784, 2, NULL, '2015-06-27 19:50:37.220816+03');
INSERT INTO resource_log VALUES (7313, 784, 2, NULL, '2015-06-27 19:50:45.528129+03');
INSERT INTO resource_log VALUES (7314, 784, 2, NULL, '2015-06-27 19:50:53.618877+03');
INSERT INTO resource_log VALUES (7315, 784, 2, NULL, '2015-06-27 19:52:29.5324+03');
INSERT INTO resource_log VALUES (7316, 2477, 2, NULL, '2015-06-27 19:52:36.102154+03');
INSERT INTO resource_log VALUES (7317, 2516, 2, NULL, '2015-06-27 20:34:38.335917+03');
INSERT INTO resource_log VALUES (7318, 2517, 2, NULL, '2015-06-27 21:02:52.190849+03');
INSERT INTO resource_log VALUES (7319, 2518, 2, NULL, '2015-06-27 22:00:11.577645+03');
INSERT INTO resource_log VALUES (7320, 784, 2, NULL, '2015-06-27 22:13:51.726755+03');
INSERT INTO resource_log VALUES (7321, 2519, 2, NULL, '2015-06-27 22:13:51.726755+03');
INSERT INTO resource_log VALUES (7322, 2520, 2, NULL, '2015-06-27 22:14:31.050053+03');
INSERT INTO resource_log VALUES (7323, 2521, 2, NULL, '2015-06-27 22:15:06.48124+03');
INSERT INTO resource_log VALUES (7324, 2522, 2, NULL, '2015-06-27 22:27:54.400494+03');
INSERT INTO resource_log VALUES (7325, 2523, 2, NULL, '2015-06-27 22:40:18.037224+03');
INSERT INTO resource_log VALUES (7326, 2524, 2, NULL, '2015-06-27 22:42:17.60206+03');
INSERT INTO resource_log VALUES (7327, 2525, 2, NULL, '2015-06-27 22:42:37.767083+03');
INSERT INTO resource_log VALUES (7328, 784, 2, NULL, '2015-06-27 22:49:09.961687+03');
INSERT INTO resource_log VALUES (7329, 784, 2, NULL, '2015-06-27 22:49:28.712758+03');
INSERT INTO resource_log VALUES (7330, 784, 2, NULL, '2015-06-27 22:49:40.054287+03');
INSERT INTO resource_log VALUES (7331, 2526, 2, NULL, '2015-06-28 15:48:24.134048+03');
INSERT INTO resource_log VALUES (7332, 2527, 2, NULL, '2015-06-28 15:49:06.934643+03');
INSERT INTO resource_log VALUES (7333, 1930, 2, NULL, '2015-06-28 15:49:08.476175+03');
INSERT INTO resource_log VALUES (7334, 1930, 2, NULL, '2015-06-28 15:49:15.43238+03');
INSERT INTO resource_log VALUES (7335, 1286, 2, NULL, '2015-06-28 16:19:06.654271+03');
INSERT INTO resource_log VALUES (7336, 1284, 2, NULL, '2015-06-28 16:19:08.822984+03');
INSERT INTO resource_log VALUES (7337, 2528, 2, NULL, '2015-06-28 16:27:58.214962+03');
INSERT INTO resource_log VALUES (7338, 2529, 2, NULL, '2015-07-04 20:12:31.951644+03');
INSERT INTO resource_log VALUES (7339, 2530, 2, NULL, '2015-07-04 20:16:08.99227+03');
INSERT INTO resource_log VALUES (7340, 2531, 2, NULL, '2015-07-04 20:16:08.99227+03');
INSERT INTO resource_log VALUES (7341, 2532, 2, NULL, '2015-07-04 20:36:07.167824+03');
INSERT INTO resource_log VALUES (7342, 2533, 2, NULL, '2015-07-04 20:36:07.167824+03');
INSERT INTO resource_log VALUES (7343, 2534, 2, NULL, '2015-07-04 20:57:32.449165+03');
INSERT INTO resource_log VALUES (7344, 2491, 2, NULL, '2015-07-04 20:58:12.716739+03');
INSERT INTO resource_log VALUES (7345, 2535, 2, NULL, '2015-07-04 20:58:36.935951+03');
INSERT INTO resource_log VALUES (7346, 2536, 2, NULL, '2015-07-04 20:59:39.366864+03');
INSERT INTO resource_log VALUES (7347, 2491, 2, NULL, '2015-07-04 20:59:49.220324+03');
INSERT INTO resource_log VALUES (7348, 2537, 2, NULL, '2015-07-04 21:00:02.518034+03');
INSERT INTO resource_log VALUES (7349, 2538, 2, NULL, '2015-07-04 21:13:08.541103+03');
INSERT INTO resource_log VALUES (7350, 2539, 2, NULL, '2015-07-04 21:14:30.611204+03');
INSERT INTO resource_log VALUES (7351, 2540, 2, NULL, '2015-07-04 21:14:32.763289+03');
INSERT INTO resource_log VALUES (7352, 2541, 2, NULL, '2015-07-04 21:14:50.821175+03');
INSERT INTO resource_log VALUES (7353, 2450, 2, NULL, '2015-07-04 21:16:23.905581+03');
INSERT INTO resource_log VALUES (7354, 2542, 2, NULL, '2015-07-04 21:17:54.658173+03');
INSERT INTO resource_log VALUES (7355, 2450, 2, NULL, '2015-07-04 21:20:36.496307+03');
INSERT INTO resource_log VALUES (7356, 2450, 2, NULL, '2015-07-04 21:22:20.163177+03');
INSERT INTO resource_log VALUES (7357, 2450, 2, NULL, '2015-07-04 21:25:41.863118+03');
INSERT INTO resource_log VALUES (7358, 2543, 2, NULL, '2015-07-04 21:26:56.584606+03');
INSERT INTO resource_log VALUES (7359, 2544, 2, NULL, '2015-07-04 21:27:23.469843+03');
INSERT INTO resource_log VALUES (7360, 2388, 2, NULL, '2015-07-04 21:27:31.474854+03');
INSERT INTO resource_log VALUES (7361, 2545, 2, NULL, '2015-07-04 21:30:18.47115+03');
INSERT INTO resource_log VALUES (7362, 2546, 2, NULL, '2015-07-04 21:30:37.579131+03');
INSERT INTO resource_log VALUES (7363, 2545, 2, NULL, '2015-07-04 21:30:38.730906+03');
INSERT INTO resource_log VALUES (7364, 2547, 2, NULL, '2015-07-04 21:30:51.680567+03');
INSERT INTO resource_log VALUES (7365, 2548, 2, NULL, '2015-07-04 21:30:51.680567+03');
INSERT INTO resource_log VALUES (7366, 2388, 2, NULL, '2015-07-04 21:31:14.422776+03');
INSERT INTO resource_log VALUES (7367, 2451, 2, NULL, '2015-07-05 14:30:51.54628+03');
INSERT INTO resource_log VALUES (7368, 2457, 2, NULL, '2015-07-05 14:33:01.814653+03');
INSERT INTO resource_log VALUES (7369, 2458, 2, NULL, '2015-07-05 14:33:47.939925+03');
INSERT INTO resource_log VALUES (7370, 2459, 2, NULL, '2015-07-05 14:33:59.629688+03');
INSERT INTO resource_log VALUES (7371, 2451, 2, NULL, '2015-07-05 14:39:43.167129+03');
INSERT INTO resource_log VALUES (7372, 2467, 2, NULL, '2015-07-05 14:49:52.691681+03');
INSERT INTO resource_log VALUES (7373, 2463, 2, NULL, '2015-07-05 14:50:06.470488+03');
INSERT INTO resource_log VALUES (7374, 2549, 2, NULL, '2015-07-05 15:34:32.780638+03');
INSERT INTO resource_log VALUES (7376, 2434, 2, NULL, '2015-07-05 19:13:53.412323+03');


--
-- Data for Name: resource_type; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO resource_type VALUES (145, 2292, 'leads_items', 'Leads Items', 'LeadsItemsResource', 'travelcrm.resources.leads_items', 'Leads Items', 'null', 0);
INSERT INTO resource_type VALUES (103, 1317, 'invoices', 'Invoices', 'InvoicesResource', 'travelcrm.resources.invoices', 'Invoices list. Invoice can''t be created manualy - only using source document such as Tours', '{"active_days": 3}', 0);
INSERT INTO resource_type VALUES (87, 1190, 'contacts', 'Contacts', 'ContactsResource', 'travelcrm.resources.contacts', 'Contacts for persons, business persons etc.', NULL, 0);
INSERT INTO resource_type VALUES (148, 2513, 'vats', 'Vat', 'VatsResource', 'travelcrm.resources.vats', 'Vat for accounts and services', 'null', 0);
INSERT INTO resource_type VALUES (2, 10, 'users', 'Users', 'UsersResource', 'travelcrm.resources.users', 'Users list', NULL, 0);
INSERT INTO resource_type VALUES (149, 2516, 'uploads', 'Uploads', 'UploadsResource', 'travelcrm.resources.uploads', 'Uploads for any type of resources', 'null', 0);
INSERT INTO resource_type VALUES (1, 773, '', 'Home', 'Root', 'travelcrm.resources', 'Home Page of Travelcrm', NULL, 0);
INSERT INTO resource_type VALUES (12, 16, 'resources_types', 'Resources Types', 'ResourcesTypesResource', 'travelcrm.resources.resources_types', 'Resources types list', NULL, 0);
INSERT INTO resource_type VALUES (39, 274, 'regions', 'Regions', 'RegionsResource', 'travelcrm.resources.regions', '', NULL, 0);
INSERT INTO resource_type VALUES (41, 283, 'currencies', 'Currencies', 'CurrenciesResource', 'travelcrm.resources.currencies', '', NULL, 0);
INSERT INTO resource_type VALUES (47, 706, 'employees', 'Employees', 'EmployeesResource', 'travelcrm.resources.employees', 'Employees Container Datagrid', NULL, 0);
INSERT INTO resource_type VALUES (55, 723, 'structures', 'Structures', 'StructuresResource', 'travelcrm.resources.structures', 'Companies structures is a tree of company structure. It''s can be offices, filials, departments and so and so', NULL, 0);
INSERT INTO resource_type VALUES (59, 764, 'positions', 'Positions', 'PositionsResource', 'travelcrm.resources.positions', 'Companies positions is a point of company structure where emplyees can be appointed', NULL, 0);
INSERT INTO resource_type VALUES (61, 769, 'permisions', 'Permisions', 'PermisionsResource', 'travelcrm.resources.permisions', 'Permisions list of company structure position. It''s list of resources and permisions', NULL, 0);
INSERT INTO resource_type VALUES (65, 775, 'navigations', 'Navigations', 'NavigationsResource', 'travelcrm.resources.navigations', 'Navigations list of company structure position.', NULL, 0);
INSERT INTO resource_type VALUES (67, 788, 'appointments', 'Appointments', 'AppointmentsResource', 'travelcrm.resources.appointments', 'Employees to positions of company appointments', NULL, 0);
INSERT INTO resource_type VALUES (69, 865, 'persons', 'Persons', 'PersonsResource', 'travelcrm.resources.persons', 'Persons directory. Person can be client or potential client', NULL, 0);
INSERT INTO resource_type VALUES (70, 872, 'countries', 'Countries', 'CountriesResource', 'travelcrm.resources.countries', 'Countries directory', NULL, 0);
INSERT INTO resource_type VALUES (71, 901, 'advsources', 'Advertises Sources', 'AdvsourcesResource', 'travelcrm.resources.advsources', 'Types of advertises', NULL, 0);
INSERT INTO resource_type VALUES (72, 908, 'hotelcats', 'Hotels Categories', 'HotelcatsResource', 'travelcrm.resources.hotelcats', 'Hotels categories', NULL, 0);
INSERT INTO resource_type VALUES (73, 909, 'roomcats', 'Rooms Categories', 'RoomcatsResource', 'travelcrm.resources.roomcats', 'Categories of the rooms', NULL, 0);
INSERT INTO resource_type VALUES (75, 954, 'foodcats', 'Foods Categories', 'FoodcatsResource', 'travelcrm.resources.foodcats', 'Food types in hotels', NULL, 0);
INSERT INTO resource_type VALUES (78, 1003, 'suppliers', 'Suppliers', 'SuppliersResource', 'travelcrm.resources.suppliers', 'Suppliers, such as touroperators, aircompanies, IATA etc.', NULL, 0);
INSERT INTO resource_type VALUES (79, 1007, 'bpersons', 'Business Persons', 'BPersonsResource', 'travelcrm.resources.bpersons', 'Business Persons is not clients it''s simple business contacts that can be referenced objects that needs to have contacts', NULL, 0);
INSERT INTO resource_type VALUES (83, 1081, 'hotels', 'Hotels', 'HotelsResource', 'travelcrm.resources.hotels', 'Hotels directory', NULL, 0);
INSERT INTO resource_type VALUES (84, 1088, 'locations', 'Locations', 'LocationsResource', 'travelcrm.resources.locations', 'Locations list is list of cities, vilages etc. places to use to identify part of region', NULL, 0);
INSERT INTO resource_type VALUES (86, 1189, 'contracts', 'Contracts', 'ContractsResource', 'travelcrm.resources.contracts', 'Licences list for any type of resources as need', NULL, 0);
INSERT INTO resource_type VALUES (89, 1198, 'passports', 'Passports', 'PassportsResource', 'travelcrm.resources.passports', 'Clients persons passports lists', NULL, 0);
INSERT INTO resource_type VALUES (90, 1207, 'addresses', 'Addresses', 'AddressesResource', 'travelcrm.resources.addresses', 'Addresses of any type of resources, such as persons, bpersons, hotels etc.', NULL, 0);
INSERT INTO resource_type VALUES (91, 1211, 'banks', 'Banks', 'BanksResource', 'travelcrm.resources.banks', 'Banks list to create bank details and for other reasons', NULL, 0);
INSERT INTO resource_type VALUES (93, 1225, 'tasks', 'Tasks', 'TasksResource', 'travelcrm.resources.tasks', 'Task manager', NULL, 0);
INSERT INTO resource_type VALUES (101, 1268, 'banks_details', 'Banks Details', 'BanksDetailsResource', 'travelcrm.resources.banks_details', 'Banks Details that can be attached to any client or business partner to define account', NULL, 0);
INSERT INTO resource_type VALUES (102, 1313, 'services', 'Services', 'ServicesResource', 'travelcrm.resources.services', 'Additional Services that can be provide with tours sales or separate', NULL, 0);
INSERT INTO resource_type VALUES (104, 1393, 'currencies_rates', 'Currency Rates', 'CurrenciesRatesResource', 'travelcrm.resources.currencies_rates', 'Currencies Rates. Values from this dir used by billing to calc prices in base currency.', NULL, 0);
INSERT INTO resource_type VALUES (105, 1424, 'accounts_items', 'Accounts Items', 'AccountsItemsResource', 'travelcrm.resources.accounts_items', 'Finance accounts items', NULL, 0);
INSERT INTO resource_type VALUES (106, 1433, 'incomes', 'Incomes', 'IncomesResource', 'travelcrm.resources.incomes', 'Incomes Payments Document for invoices', '{"account_item_id": 8}', 0);
INSERT INTO resource_type VALUES (107, 1435, 'accounts', 'Accounts', 'AccountsResource', 'travelcrm.resources.accounts', 'Billing Accounts. It can be bank accouts, cash accounts etc. and has company wide visible', 'null', 0);
INSERT INTO resource_type VALUES (117, 1797, 'subaccounts', 'Subaccounts', 'SubaccountsResource', 'travelcrm.resources.subaccounts', 'Subaccounts are accounts from other objects such as clients, touroperators and so on', 'null', 0);
INSERT INTO resource_type VALUES (118, 1799, 'notes', 'Notes', 'NotesResource', 'travelcrm.resources.notes', 'Resources Notes', 'null', 0);
INSERT INTO resource_type VALUES (119, 1849, 'calculations', 'Caluclations', 'CalculationsResource', 'travelcrm.resources.calculations', 'Calculations of Sale Documents', 'null', 0);
INSERT INTO resource_type VALUES (121, 1894, 'turnovers', 'Turnovers', 'TurnoversResource', 'travelcrm.resources.turnovers', 'Turnovers on Accounts and Subaccounts', 'null', 0);
INSERT INTO resource_type VALUES (126, 1968, 'companies', 'Companies', 'CompaniesResource', 'travelcrm.resources.companies', 'Multicompanies functionality', 'null', 0);
INSERT INTO resource_type VALUES (130, 2049, 'leads', 'Leads', 'LeadsResource', 'travelcrm.resources.leads', 'Leads that can be converted into contacts', 'null', 0);
INSERT INTO resource_type VALUES (134, 2099, 'orders', 'Orders', 'OrdersResource', 'travelcrm.resources.orders', 'Orders', 'null', 0);
INSERT INTO resource_type VALUES (135, 2100, 'orders_items', 'Orders Items', 'OrdersItemsResource', 'travelcrm.resources.orders_items', 'Orders Items', 'null', 0);
INSERT INTO resource_type VALUES (137, 2108, 'tours', 'Tours', 'ToursResource', 'travelcrm.resources.tours', 'Tour Service', 'null', 0);
INSERT INTO resource_type VALUES (74, 953, 'accomodations', 'Accomodations', 'AccomodationsResource', 'travelcrm.resources.accomodations', 'Accomodations Types list', NULL, 0);
INSERT INTO resource_type VALUES (110, 1521, 'commissions', 'Commissions', 'CommissionsResource', 'travelcrm.resources.commissions', 'Services sales commissions', 'null', 0);
INSERT INTO resource_type VALUES (111, 1548, 'outgoings', 'Outgoings', 'OutgoingsResource', 'travelcrm.resources.outgoings', 'Outgoings payments for touroperators, suppliers, payback payments and so on', 'null', 0);
INSERT INTO resource_type VALUES (146, 2296, 'leads_offers', 'Leads Offers', 'LeadsOffersResource', 'travelcrm.resources.leads_offers', 'Leads Offers', 'null', 0);
INSERT INTO resource_type VALUES (120, 1884, 'crosspayments', 'Cross Payments', 'CrosspaymentsResource', 'travelcrm.resources.crosspayments', 'Cross payments between accounts and subaccounts. This document is for balance corrections to.', 'null', 0);
INSERT INTO resource_type VALUES (123, 1941, 'notifications', 'Notifications', 'NotificationsResource', 'travelcrm.resources.notifications', 'Employee Notifications', 'null', 0);
INSERT INTO resource_type VALUES (124, 1954, 'emails_campaigns', 'Email Campaigns', 'EmailsCampaignsResource', 'travelcrm.resources.emails_campaigns', 'Emails Campaigns for subscribers', '{"timeout": 12}', 0);
INSERT INTO resource_type VALUES (138, 2127, 'transfers', 'Transfers', 'TransfersResource', 'travelcrm.resources.transfers', 'Transfers for tours', 'null', 0);
INSERT INTO resource_type VALUES (139, 2135, 'transports', 'Transports', 'TransportsResource', 'travelcrm.resources.transports', 'Transports Types List', 'null', 0);
INSERT INTO resource_type VALUES (140, 2217, 'suppliers_types', 'Suppliers Types', 'SuppliersTypesResource', 'travelcrm.resources.suppliers_types', 'Suppliers Types list', 'null', 0);
INSERT INTO resource_type VALUES (141, 2243, 'tickets_classes', 'Tickets Classes', 'TicketsClassesResource', 'travelcrm.resources.tickets_classes', 'Tickets Classes list, such as first class, business class etc', 'null', 0);
INSERT INTO resource_type VALUES (142, 2244, 'tickets', 'Tickets', 'TicketsResource', 'travelcrm.resources.tickets', 'Ticket is a service for sale tickets of any type', 'null', 0);
INSERT INTO resource_type VALUES (143, 2268, 'visas', 'Visas', 'VisasResource', 'travelcrm.resources.visas', 'Visa is a service for sale visas', 'null', 0);
INSERT INTO resource_type VALUES (144, 2276, 'spassports', 'Passports Services', 'SpassportsResource', 'travelcrm.resources.spassports', 'Service formulation of foreign passports', 'null', 0);


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

SELECT pg_catalog.setval('roomcat_id_seq', 34, true);


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO service VALUES (7, 2247, 'Ticket', NULL, 'Ticket booking service', 142);
INSERT INTO service VALUES (5, 1413, 'Tour', 'Use this service for tour sales', 'Tour booking service', 137);
INSERT INTO service VALUES (4, 1318, 'A visa', NULL, 'The issues for visas', 143);
INSERT INTO service VALUES (1, 1314, 'Foreign Passport Service', NULL, 'Formulation of foreign passport', 144);


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('service_id_seq', 7, true);


--
-- Data for Name: spassport; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO spassport VALUES (1, 2279, true, '2015-04-29', '2015-04-30', '2015-05-10', 'Must be done in 10 days after docs recieved');


--
-- Name: spassport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('spassport_id_seq', 1, true);


--
-- Data for Name: spassport_order_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO spassport_order_item VALUES (35, 1);


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

INSERT INTO subaccount VALUES (1, 1865, 4, 'Vitalii Mazur EUR | cash', NULL, 0);
INSERT INTO subaccount VALUES (2, 1866, 2, 'News Travel | Bank', NULL, 0);
INSERT INTO subaccount VALUES (3, 1867, 4, 'Alexander Karpenko | EUR', NULL, 0);
INSERT INTO subaccount VALUES (4, 1868, 3, 'Garkaviy Andriy | UAH', NULL, 0);
INSERT INTO subaccount VALUES (6, 1875, 3, 'Main Cash Account | rid: 1628', NULL, 0);
INSERT INTO subaccount VALUES (8, 1881, 3, 'Main Cash Account | rid: 1372', NULL, 0);
INSERT INTO subaccount VALUES (9, 1888, 2, 'Lun Real Estate | UAH', 'Month Rate', 0);
INSERT INTO subaccount VALUES (10, 1902, 3, 'Lun Real Estate | UAH | CASH', 'Lun on cash account', 0);
INSERT INTO subaccount VALUES (11, 1911, 4, 'Main Cash EUR Account | rid: 1465', NULL, 0);
INSERT INTO subaccount VALUES (12, 1913, 2, 'Sun Marino Trvl | Cash UAH', 'Sun Marino Main Bank Subaccount', 0);
INSERT INTO subaccount VALUES (13, 1991, 3, 'Main Cash Account | rid: 1471', NULL, 0);
INSERT INTO subaccount VALUES (14, 1997, 3, 'Main Cash Account | rid: 1645', NULL, 0);
INSERT INTO subaccount VALUES (15, 2002, 3, 'Main Cash Account | rid: 1869', NULL, 0);
INSERT INTO subaccount VALUES (16, 2007, 3, 'Main Cash Account | rid: 887', NULL, 0);
INSERT INTO subaccount VALUES (17, 2028, 3, 'Main Cash Account | rid: 2017', NULL, 0);
INSERT INTO subaccount VALUES (18, 2438, 4, 'COMPANY EUR CASH', 'Main company Eur cash subaccount', 0);
INSERT INTO subaccount VALUES (20, 2440, 2, 'COMPANY UAH BANK', 'Main Company Uah bank account subaccount', 0);
INSERT INTO subaccount VALUES (19, 2439, 3, 'COMPANY UAH CASH', 'Main company Uah cash subaccount', 0);
INSERT INTO subaccount VALUES (21, 2442, 3, 'Stepanchuk Sergey, UAH, cash', NULL, 0);
INSERT INTO subaccount VALUES (22, 2452, 4, 'Oleg, EUR, cash', NULL, 0);
INSERT INTO subaccount VALUES (23, 2466, 3, 'Tez Tour UAH, cash', 'Tez tour cash UAH subaccount', 0);


--
-- Name: subaccount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('subaccount_id_seq', 23, true);


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO supplier VALUES (65, 2216, 'New Wind', 0, 'First touroperator', 1);
INSERT INTO supplier VALUES (66, 2223, 'MAU', 0, 'Internation Ukrainian Airlines', 2);
INSERT INTO supplier VALUES (68, 2225, 'Four Winds', 0, '', 1);
INSERT INTO supplier VALUES (69, 2226, 'Akkord Tour', 0, '', 1);
INSERT INTO supplier VALUES (86, 2227, 'Feerija', 0, '', 1);
INSERT INTO supplier VALUES (87, 2228, 'TEZ Tour', 0, '', 1);
INSERT INTO supplier VALUES (88, 2229, 'Gamalija', 0, '', 1);
INSERT INTO supplier VALUES (67, 2224, 'News Travel', 1, 'Cyprus touroperator only', 1);
INSERT INTO supplier VALUES (89, 2230, 'Voyage De Luxe', 0, '', 1);
INSERT INTO supplier VALUES (90, 2231, 'IdrisKa tour', 0, '', 1);
INSERT INTO supplier VALUES (91, 2232, 'Anex Tour', 0, '', 1);
INSERT INTO supplier VALUES (92, 2233, 'TUI', 0, '', 1);
INSERT INTO supplier VALUES (93, 2234, 'Turtess Travel', 0, '', 1);
INSERT INTO supplier VALUES (94, 2235, 'Coral Travel', 0, '', 1);
INSERT INTO supplier VALUES (96, 2237, 'Natali Turs', 0, '', 1);
INSERT INTO supplier VALUES (97, 2238, 'Kiy Avia', 0, '', 2);
INSERT INTO supplier VALUES (98, 2239, 'MIBS Travel', 0, '', 1);
INSERT INTO supplier VALUES (99, 2240, 'SAM', 0, '', 1);
INSERT INTO supplier VALUES (100, 2241, 'Pilot', 0, '', 1);
INSERT INTO supplier VALUES (101, 2242, 'Orbita', 0, '', 1);
INSERT INTO supplier VALUES (95, 2236, 'Pan Ukraine', 1, '', 1);
INSERT INTO supplier VALUES (102, 2272, 'Ukrainian Visa Center', 0, '', 3);


--
-- Data for Name: supplier_bank_detail; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: supplier_bperson; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO supplier_bperson VALUES (65, 7);


--
-- Data for Name: supplier_contract; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO supplier_contract VALUES (65, 50);
INSERT INTO supplier_contract VALUES (65, 49);
INSERT INTO supplier_contract VALUES (97, 51);
INSERT INTO supplier_contract VALUES (96, 52);
INSERT INTO supplier_contract VALUES (93, 53);
INSERT INTO supplier_contract VALUES (100, 54);
INSERT INTO supplier_contract VALUES (102, 55);
INSERT INTO supplier_contract VALUES (87, 56);
INSERT INTO supplier_contract VALUES (92, 57);


--
-- Data for Name: supplier_subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO supplier_subaccount VALUES (87, 23);


--
-- Data for Name: supplier_type; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO supplier_type VALUES (1, 2218, 'Touroperator', '');
INSERT INTO supplier_type VALUES (2, 2221, 'Aircompany', '');
INSERT INTO supplier_type VALUES (3, 2271, 'Visa Center', '');


--
-- Name: supplier_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('supplier_type_id_seq', 3, true);


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO task VALUES (37, 1933, 2, 'Call and remind about payment', '2014-12-14 22:46:00+02', NULL, 3, NULL);
INSERT INTO task VALUES (38, 1934, 2, 'Call and remind about payment', '2014-12-12 22:50:00+02', 'Call and remind to pay invoice', 0, NULL);
INSERT INTO task VALUES (39, 1935, 2, 'Review Calculation', '2014-12-12 22:52:00+02', NULL, 0, NULL);
INSERT INTO task VALUES (40, 1936, 2, 'For testing Purpose only', '2014-12-14 22:35:00+02', NULL, 0, NULL);
INSERT INTO task VALUES (33, 1922, 30, 'Test', '2014-12-07 21:36:00+02', 'For testing purpose', 1, NULL);
INSERT INTO task VALUES (55, 2063, 2, 'Revert status after testing', '2015-03-08 19:41:00+02', 'Set status into active after testing', 0, NULL);
INSERT INTO task VALUES (56, 2066, 2, 'Notifications testing #2', '2015-03-11 17:16:00+02', NULL, 0, NULL);
INSERT INTO task VALUES (57, 2068, 2, 'Test Notification resource link', '2015-03-11 19:28:00+02', NULL, 0, NULL);
INSERT INTO task VALUES (48, 1980, 2, 'Check Reminder', '2015-01-08 18:21:00+02', 'Description to task', 3, NULL);
INSERT INTO task VALUES (47, 1971, 2, 'Check Payments', '2015-01-04 15:45:00+02', NULL, 1, NULL);
INSERT INTO task VALUES (41, 1939, 2, 'I have the following code', '2014-12-13 23:36:00+02', NULL, 3, NULL);
INSERT INTO task VALUES (46, 1964, 2, 'For testing', '2014-12-25 23:05:00+02', 'For testing purpose only', 3, NULL);
INSERT INTO task VALUES (45, 1962, 2, 'Test', '2014-12-24 23:32:00+02', NULL, 3, NULL);
INSERT INTO task VALUES (52, 2009, 2, 'I decided to try to follow the postgres approach as directly as possible and came up with the following migration.', '2015-01-21 22:44:00+02', NULL, 1, NULL);
INSERT INTO task VALUES (54, 2062, 2, 'New JEasyui version migrate', '2015-03-07 21:43:00+02', 'Migrate on new 0.4.2 jeasyui version, check all functionality.', 2, NULL);
INSERT INTO task VALUES (44, 1958, 2, 'Test new scheduler realization', '2014-12-22 19:18:00+02', 'New scheduler realizations notifications test.', 3, NULL);
INSERT INTO task VALUES (49, 1982, 2, 'The second task', '2015-01-08 18:30:00+02', 'Second test task', 1, NULL);
INSERT INTO task VALUES (50, 1983, 2, 'Test', '2015-01-13 17:06:00+02', NULL, 1, NULL);
INSERT INTO task VALUES (51, 1985, 2, 'Test 2', '2015-01-14 17:02:00+02', NULL, 1, NULL);
INSERT INTO task VALUES (53, 2016, 2, 'Notify his', '2015-02-02 17:09:00+02', 'Notify about the documents', 3, NULL);
INSERT INTO task VALUES (42, 1940, 2, 'Test notifications', '2014-12-14 21:37:00+02', NULL, 2, NULL);
INSERT INTO task VALUES (36, 1932, 2, 'Call and remind about payments', '2014-12-11 22:48:00+02', NULL, 1, NULL);
INSERT INTO task VALUES (59, 2131, 2, 'Task For Lastovec', '2015-04-23 15:32:00+03', 'Test description for task', 0, NULL);
INSERT INTO task VALUES (60, 2171, 2, 'Test for', '2015-04-28 10:38:00+03', NULL, 0, NULL);
INSERT INTO task VALUES (67, 2197, 2, 'Check reminder', '2015-05-03 13:45:00+03', NULL, 0, 10);
INSERT INTO task VALUES (68, 2291, 2, 'Call and ansswer about discount', '2015-05-19 16:39:00+03', 'talk about discount', 0, 10);
INSERT INTO task VALUES (58, 2075, 2, 'Call about discounts', '2015-03-21 17:20:00+02', 'Calls and talk about tour discounts', 3, 10);
INSERT INTO task VALUES (69, 2303, 2, 'Call about offer', '2015-05-24 17:30:00+03', NULL, 0, 10);
INSERT INTO task VALUES (70, 2311, 2, 'Select hotels and hot tours', '2015-05-25 10:35:00+03', NULL, 0, 10);
INSERT INTO task VALUES (71, 2371, 2, 'Call to client', '2015-06-08 15:00:00+03', 'Call to client with success bucking', 0, 30);
INSERT INTO task VALUES (72, 2381, 2, 'Make an Invoice', '2015-06-06 22:12:00+03', 'Make invoice for this order', 0, 10);
INSERT INTO task VALUES (73, 2436, 2, 'Позвонить клиент', '2015-06-11 08:12:00+03', NULL, 0, 10);
INSERT INTO task VALUES (74, 2488, 2, 'gfgfdgdfgdf', '2015-06-23 08:57:00+03', NULL, 0, 10);
INSERT INTO task VALUES (75, 2492, 2, 'fgfgfg', '2015-06-19 09:04:00+03', NULL, 0, 10);
INSERT INTO task VALUES (76, 2496, 2, 'ghghgh', '2015-06-23 09:22:00+03', NULL, 0, 10);
INSERT INTO task VALUES (77, 2499, 2, 'asasasasasas', '2015-06-21 09:24:00+03', NULL, 0, 10);
INSERT INTO task VALUES (35, 1930, 2, 'Check Person Details', '2014-12-11 21:43:00+02', 'We''ll reuse the Amount type from last week. It''s mostly the same, except we''ll remove __clause_element__(), and additionally provide a classmethod version of the as_currency() method, which we''ll use when dealing with SQL expressions.', 2, 10);


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('task_id_seq', 77, true);


--
-- Data for Name: task_resource; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO task_resource VALUES (35, 1869);
INSERT INTO task_resource VALUES (47, 1840);
INSERT INTO task_resource VALUES (48, 3);
INSERT INTO task_resource VALUES (49, 3);
INSERT INTO task_resource VALUES (53, 2017);
INSERT INTO task_resource VALUES (55, 1989);
INSERT INTO task_resource VALUES (59, 2126);
INSERT INTO task_resource VALUES (69, 2088);
INSERT INTO task_resource VALUES (58, 2088);
INSERT INTO task_resource VALUES (70, 2312);
INSERT INTO task_resource VALUES (68, 2284);
INSERT INTO task_resource VALUES (71, 2372);
INSERT INTO task_resource VALUES (72, 2382);
INSERT INTO task_resource VALUES (74, 2489);
INSERT INTO task_resource VALUES (76, 2129);
INSERT INTO task_resource VALUES (77, 2137);
INSERT INTO task_resource VALUES (73, 2434);


--
-- Data for Name: task_upload; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO ticket VALUES (2, 2255, 15, 21, 2, 1, '2015-05-10 14:11:00+03', NULL, '2015-05-10 15:26:00+03', NULL, 2, 0, NULL);
INSERT INTO ticket VALUES (3, 2257, 15, 21, 2, 1, '2015-05-16 14:38:00+03', NULL, '2015-05-16 15:39:00+03', NULL, 2, 0, NULL);
INSERT INTO ticket VALUES (4, 2259, 21, 15, 2, 1, '2015-05-22 17:38:00+03', NULL, '2015-05-22 18:39:00+03', NULL, 2, 0, NULL);
INSERT INTO ticket VALUES (5, 2261, 15, 21, 2, 1, '2015-05-15 17:52:00+03', NULL, '2015-05-15 18:52:00+03', NULL, 2, 0, NULL);
INSERT INTO ticket VALUES (6, 2263, 21, 15, 2, 1, '2015-05-22 17:52:00+03', NULL, '2015-05-22 18:52:00+03', NULL, 2, 0, NULL);
INSERT INTO ticket VALUES (7, 2288, 15, 37, 2, 1, '2015-05-29 15:46:00+03', 'TICKET INFO', '2015-05-29 17:31:00+03', NULL, 2, 0, NULL);


--
-- Data for Name: ticket_class; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO ticket_class VALUES (1, 2248, 'First class');
INSERT INTO ticket_class VALUES (2, 2249, 'Business Class');


--
-- Name: ticket_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('ticket_class_id_seq', 2, true);


--
-- Name: ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('ticket_id_seq', 7, true);


--
-- Data for Name: ticket_order_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO ticket_order_item VALUES (28, 2);
INSERT INTO ticket_order_item VALUES (29, 3);
INSERT INTO ticket_order_item VALUES (30, 4);
INSERT INTO ticket_order_item VALUES (31, 5);
INSERT INTO ticket_order_item VALUES (32, 6);
INSERT INTO ticket_order_item VALUES (38, 7);


--
-- Data for Name: tour; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tour VALUES (1, 2145, 15, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, 'MAU', 'MAU');
INSERT INTO tour VALUES (2, 2147, 14, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (3, 2149, 15, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-25', '2015-04-30', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (4, 2151, 15, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (5, 2153, 15, 14, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (6, 2155, 3, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (7, 2157, 15, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (8, 2159, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (9, 2161, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (10, 2163, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (11, 2165, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (12, 2168, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (13, 2173, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (14, 2175, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (15, 2177, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (16, 2179, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (17, 2181, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (18, 2183, 33, 37, 36, NULL, NULL, NULL, 2, 0, '2015-04-30', '2015-05-08', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (19, 2185, 33, 37, 36, NULL, 15, 30, 2, 0, '2015-04-30', '2015-05-08', 'Description for service', 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (20, 2188, 33, 37, 36, NULL, 15, 30, 2, 0, '2015-04-30', '2015-05-08', 'Description for service', 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (21, 2190, 33, 37, 36, NULL, 15, 30, 2, 0, '2015-04-30', '2015-05-08', 'Description for service', 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (22, 2266, 15, 20, 12, 2, 15, 30, 2, 0, '2015-05-16', '2015-05-23', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (24, 2286, 15, 31, 32, 12, 16, 26, 2, 0, '2015-05-20', '2015-05-27', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (23, 2283, 15, 19, 16, NULL, NULL, NULL, 2, 0, '2015-05-22', '2015-05-29', NULL, 1, 1, NULL, NULL, NULL);
INSERT INTO tour VALUES (26, 2342, 15, 19, 16, 10, 15, NULL, 2, 1, '2015-07-13', '2015-07-18', NULL, 1, 1, NULL, '#MAU', '#MAU');
INSERT INTO tour VALUES (27, 2378, 15, 39, 39, 10, 10, NULL, 2, 0, '2015-06-28', '2015-07-04', NULL, 1, 1, NULL, '#MAU', '#MAU');
INSERT INTO tour VALUES (25, 2316, 15, 19, 18, 10, 10, 33, 2, 0, '2015-06-21', '2015-06-27', NULL, 1, 1, NULL, '# MAU', '# MAU');


--
-- Name: tour_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tour_id_seq1', 27, true);


--
-- Data for Name: tour_order_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO tour_order_item VALUES (33, 22);
INSERT INTO tour_order_item VALUES (36, 23);
INSERT INTO tour_order_item VALUES (37, 24);
INSERT INTO tour_order_item VALUES (39, 25);
INSERT INTO tour_order_item VALUES (40, 26);
INSERT INTO tour_order_item VALUES (42, 27);


--
-- Name: touroperator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('touroperator_id_seq', 102, true);


--
-- Data for Name: transfer; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO transfer VALUES (1, 2129, 'Group');
INSERT INTO transfer VALUES (2, 2130, 'Individual');


--
-- Name: transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('transfer_id_seq', 259, true);


--
-- Name: transfer_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('transfer_id_seq1', 3, true);


--
-- Data for Name: transport; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO transport VALUES (1, 2137, 'Avia');
INSERT INTO transport VALUES (2, 2138, 'Auto');
INSERT INTO transport VALUES (3, 2139, 'Railway');


--
-- Name: transport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('transport_id_seq', 3, true);


--
-- Data for Name: upload; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO upload VALUES (4, '2015627/11fad20d-91e8-4aae-9991-84a9f3ce68a2.jpg', 0.00, 'image/jpeg', '', 'YniVN8l0kTY.jpg', 2517);
INSERT INTO upload VALUES (5, '2015627/edbfabe1-5fa4-413f-a34a-7e87d2962dbd.jpg', 0.00, 'image/jpeg', '', 'YniVN8l0kTY.jpg', 2518);
INSERT INTO upload VALUES (7, '2015627/8c985058-a198-42df-97d2-f55996a1a9b3.jpg', 0.00, 'image/jpeg', NULL, 'Che-Guevara-9322774-1-402.jpg', 2519);
INSERT INTO upload VALUES (8, '2015627/cdef8ade-0166-4206-bac6-43f1a64ee471.jpg', 0.00, 'image/jpeg', '', 'YniVN8l0kTY.jpg', 2520);
INSERT INTO upload VALUES (9, '2015627/e066c3a4-9840-434a-947d-088a46ecbb32.jpg', 0.00, 'image/jpeg', '', 'YniVN8l0kTY.jpg', 2521);
INSERT INTO upload VALUES (10, '2015627/bacad34b-c04f-4a77-b8d1-3a1a5b944f5b.jpg', 0.00, 'image/jpeg', '', 'YniVN8l0kTY.jpg', 2522);
INSERT INTO upload VALUES (11, '2015627/ba9d9b9e-220c-4ee7-b4d6-7e25a8582881.pdf', 0.00, 'application/pdf', '', 'Python..pdf', 2523);
INSERT INTO upload VALUES (12, '2015627/64d46808-2e69-4048-bc60-ca7ee03de0de.pdf', 0.00, 'application/pdf', '', 'Python..pdf', 2524);
INSERT INTO upload VALUES (13, '2015627/5f588c0b-bd08-4f4e-a55e-54f76895a184.png', 0.00, 'image/png', '', 'Снимок экрана из 2015-06-18 13:18:52.png', 2525);
INSERT INTO upload VALUES (14, '2015628/6b2d987b-b6fe-41d9-8edf-37b1e70fe79b.png', 0.00, 'image/png', '', 'Снимок экрана из 2015-06-14 22:01:13.png', 2526);
INSERT INTO upload VALUES (15, '2015628/6e5fbc5e-7ee9-4abd-9329-2c365546a3cd.png', 0.00, 'image/png', '', 'Снимок экрана из 2015-06-14 22:00:32.png', 2527);
INSERT INTO upload VALUES (16, '2015628/283deac4-aa2c-4222-a8c0-905d44de3530.png', 0.00, 'image/png', '', 'Снимок экрана из 2015-06-14 22:00:37.png', 2528);


--
-- Name: upload_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('upload_id_seq', 16, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "user" VALUES (2, 3, 'admin', 'vitalii.mazur@gmail.com', 'adminadmin', 2);
INSERT INTO "user" VALUES (25, 2054, 'maz_iv', NULL, 'korn17', 30);
INSERT INTO "user" VALUES (23, 894, 'maziv', NULL, '111111', 7);
INSERT INTO "user" VALUES (31, 2126, 'v.lastovec', NULL, '111111', 15);
INSERT INTO "user" VALUES (32, 2484, 'alinka', NULL, 'korn1979', 31);


--
-- Data for Name: vat; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO vat VALUES (1, 2515, 5, '2015-06-01', 20.00, 0, 'Vat on Tours is only for commission', 2);
INSERT INTO vat VALUES (2, 2542, 5, '2015-06-01', 20.00, 0, NULL, 4);
INSERT INTO vat VALUES (3, 2543, 5, '2015-05-01', 20.00, 0, NULL, 3);
INSERT INTO vat VALUES (4, 2544, 4, '2015-05-01', 20.00, 1, NULL, 3);


--
-- Name: vat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('vat_id_seq', 4, true);


--
-- Data for Name: visa; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO visa VALUES (1, 2274, 21, '2015-05-31', '2016-05-31', 0, NULL);
INSERT INTO visa VALUES (3, 2380, 12, '2015-06-14', '2016-06-14', 0, NULL);
INSERT INTO visa VALUES (2, 2344, 17, '2015-08-01', '2015-09-01', 0, NULL);


--
-- Name: visa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('visa_id_seq', 3, true);


--
-- Data for Name: visa_order_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO visa_order_item VALUES (34, 1);
INSERT INTO visa_order_item VALUES (41, 2);
INSERT INTO visa_order_item VALUES (43, 3);


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
-- Name: company_subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT company_subaccount_pkey PRIMARY KEY (company_id, subaccount_id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: contract_commission_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT contract_commission_pkey PRIMARY KEY (contract_id, commission_id);


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
-- Name: employee_upload_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT employee_upload_pkey PRIMARY KEY (employee_id, upload_id);


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
-- Name: income_cashflow_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT income_cashflow_pkey PRIMARY KEY (income_id, cashflow_id);


--
-- Name: income_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY income
    ADD CONSTRAINT income_pkey PRIMARY KEY (id);


--
-- Name: invoice_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT invoice_item_pkey PRIMARY KEY (id);


--
-- Name: invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);


--
-- Name: lead_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT lead_item_pkey PRIMARY KEY (id);


--
-- Name: lead_offer_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT lead_offer_pkey PRIMARY KEY (id);


--
-- Name: lead_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT lead_pkey PRIMARY KEY (id);


--
-- Name: licence_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contract
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
-- Name: note_upload_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT note_upload_pkey PRIMARY KEY (note_id, upload_id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT notification_resource_pkey PRIMARY KEY (notification_id, resource_id);


--
-- Name: order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: outgoing_cashflow_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT outgoing_cashflow_pkey PRIMARY KEY (outgoing_id, cashflow_id);


--
-- Name: outgoing_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT outgoing_pkey PRIMARY KEY (id);


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
-- Name: person_order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT person_order_item_pkey PRIMARY KEY (order_item_id, person_id);


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
-- Name: service_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: spassport_order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT spassport_order_item_pkey PRIMARY KEY (order_item_id, spassport_id);


--
-- Name: spassport_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY spassport
    ADD CONSTRAINT spassport_pkey PRIMARY KEY (id);


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
-- Name: supplier_contract_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT supplier_contract_pkey PRIMARY KEY (supplier_id, contract_id);


--
-- Name: supplier_subaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT supplier_subaccount_pkey PRIMARY KEY (supplier_id, subaccount_id);


--
-- Name: supplier_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT supplier_type_pkey PRIMARY KEY (id);


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
-- Name: task_upload_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT task_upload_pkey PRIMARY KEY (task_id, upload_id);


--
-- Name: ticket_class_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT ticket_class_pkey PRIMARY KEY (id);


--
-- Name: ticket_order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT ticket_order_item_pkey PRIMARY KEY (order_item_id, ticket_id);


--
-- Name: ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- Name: tour_order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT tour_order_item_pkey PRIMARY KEY (order_item_id, tour_id);


--
-- Name: tour_pkey1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT tour_pkey1 PRIMARY KEY (id);


--
-- Name: touroperator_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT touroperator_pkey PRIMARY KEY (id);


--
-- Name: transfer_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT transfer_pkey PRIMARY KEY (id);


--
-- Name: transfer_pkey1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_pkey1 PRIMARY KEY (id);


--
-- Name: transport_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT transport_pkey PRIMARY KEY (id);


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
    ADD CONSTRAINT unique_idx_currency_rate_currency_id_date UNIQUE (currency_id, date, supplier_id);


--
-- Name: unique_idx_name_account; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT unique_idx_name_account UNIQUE (name);


--
-- Name: unique_idx_name_account_id_subaccount; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT unique_idx_name_account_id_subaccount UNIQUE (name, account_id);


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
-- Name: unique_idx_name_supplier_type; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT unique_idx_name_supplier_type UNIQUE (name);


--
-- Name: unique_idx_name_ticket_class; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT unique_idx_name_ticket_class UNIQUE (name);


--
-- Name: unique_idx_name_transfer; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT unique_idx_name_transfer UNIQUE (name);


--
-- Name: unique_idx_name_transport; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT unique_idx_name_transport UNIQUE (name);


--
-- Name: unique_idx_path_upload; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT unique_idx_path_upload UNIQUE (path);


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
-- Name: upload_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT upload_pkey PRIMARY KEY (id);


--
-- Name: user_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- Name: vat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT vat_pkey PRIMARY KEY (id);


--
-- Name: visa_order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT visa_order_item_pkey PRIMARY KEY (order_item_id, visa_id);


--
-- Name: visa_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT visa_pkey PRIMARY KEY (id);


--
-- Name: ix_apscheduler_jobs_next_run_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ix_apscheduler_jobs_next_run_time ON apscheduler_jobs USING btree (next_run_time);


--
-- Name: fk_accomodation_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_accomodation_id_tour FOREIGN KEY (accomodation_id) REFERENCES accomodation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_id_invoice; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_account_id_invoice FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_id_vat; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_account_id_vat FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: fk_account_item_id_cashflow; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_account_item_id_cashflow FOREIGN KEY (account_item_id) REFERENCES account_item(id);


--
-- Name: fk_account_item_id_outgoing; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_account_item_id_outgoing FOREIGN KEY (account_item_id) REFERENCES account_item(id);


--
-- Name: fk_account_item_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_account_item_id_transfer FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT fk_account_item_parent_id FOREIGN KEY (parent_id) REFERENCES account_item(id);


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
-- Name: fk_advsource_id_lead; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_advsource_id_lead FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_order; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_advsource_id_order FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_cashflow_id_crosspayment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_cashflow_id_crosspayment FOREIGN KEY (cashflow_id) REFERENCES cashflow(id);


--
-- Name: fk_cashflow_id_income_cashflow; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT fk_cashflow_id_income_cashflow FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_outgoing_cashflow; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT fk_cashflow_id_outgoing_cashflow FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_commission_id_contract_commission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT fk_commission_id_contract_commission FOREIGN KEY (commission_id) REFERENCES commission(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_company_id_company_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT fk_company_id_company_subaccount FOREIGN KEY (company_id) REFERENCES company(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_contract_id_contract_commission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT fk_contract_id_contract_commission FOREIGN KEY (contract_id) REFERENCES contract(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contract_id_supplier_contract; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT fk_contract_id_supplier_contract FOREIGN KEY (contract_id) REFERENCES contract(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_country_id_passport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_country_id_passport FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_country_id_visa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT fk_country_id_visa FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_currency_id_lead_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_currency_id_lead_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_lead_offer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_currency_id_lead_offer FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_currency_id_order_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_currency_id_tour FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_lead; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_customer_id_lead FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_order; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_customer_id_order FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_employee_id_employee_upload; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT fk_employee_id_employee_upload FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_end_location_id_ticket; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_end_location_id_ticket FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_location_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_end_location_id_tour FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_transport_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_end_transport_id_tour FOREIGN KEY (end_transport_id) REFERENCES transport(id);


--
-- Name: fk_foodcat_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_foodcat_id_tour FOREIGN KEY (foodcat_id) REFERENCES foodcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotel_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_hotel_id_tour FOREIGN KEY (hotel_id) REFERENCES hotel(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotelcat_id_hotel; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_hotelcat_id_hotel FOREIGN KEY (hotelcat_id) REFERENCES hotelcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_income_id_income_cashflow; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT fk_income_id_income_cashflow FOREIGN KEY (income_id) REFERENCES income(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_income; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_invoice_id_income FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_invoice_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT fk_invoice_id_invoice_item FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_lead_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_lead_id_lead_item FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_lead_offer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_lead_id_lead_offer FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_order; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_lead_id_order FOREIGN KEY (lead_id) REFERENCES lead(id);


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
-- Name: fk_note_id_note_upload; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT fk_note_id_note_upload FOREIGN KEY (note_id) REFERENCES note(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_notification_id_notification_resource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT fk_notification_id_notification_resource FOREIGN KEY (notification_id) REFERENCES notification(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_id_invoice; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_order_id_invoice FOREIGN KEY (order_id) REFERENCES "order"(id);


--
-- Name: fk_order_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_order_id_order_item FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_caluclation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_order_item_id_caluclation FOREIGN KEY (order_item_id) REFERENCES order_item(id);


--
-- Name: fk_order_item_id_invoice_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT fk_order_item_id_invoice_item FOREIGN KEY (order_item_id) REFERENCES order_item(id);


--
-- Name: fk_order_item_id_person_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT fk_order_item_id_person_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_spassport_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT fk_order_item_id_spassport_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_ticket_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT fk_order_item_id_ticket_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_tour_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT fk_order_item_id_tour_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_visa_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT fk_order_item_id_visa_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_outgoing_id_outgoing_cashflow; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT fk_outgoing_id_outgoing_cashflow FOREIGN KEY (outgoing_id) REFERENCES outgoing(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_person_id_person_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT fk_person_id_person_order_item FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_photo_upload_id_employee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_photo_upload_id_employee FOREIGN KEY (photo_upload_id) REFERENCES upload(id);


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
-- Name: fk_resource_id_contact; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT fk_resource_id_contact FOREIGN KEY (resource_id) REFERENCES resource(id);


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
-- Name: fk_resource_id_lead; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_resource_id_lead FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_resource_id_lead_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead_offer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_resource_id_lead_offer FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_licence; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contract
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
-- Name: fk_resource_id_notification_resource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT fk_resource_id_notification_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_order; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_resource_id_order FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_resource_id_order_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_id_spassport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY spassport
    ADD CONSTRAINT fk_resource_id_spassport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_id_supplier_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT fk_resource_id_supplier_type FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_id_ticket; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_resource_id_ticket FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_ticket_class; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT fk_resource_id_ticket_class FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_touroperator; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT fk_resource_id_touroperator FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_resource_id_transfer FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_transport; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT fk_resource_id_transport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_resource_id_user FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_vat; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_resource_id_vat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_visa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT fk_resource_id_visa FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_type_id_service; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_resource_type_id_service FOREIGN KEY (resource_type_id) REFERENCES resource_type(id);


--
-- Name: fk_roomcat_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_roomcat_id_tour FOREIGN KEY (roomcat_id) REFERENCES roomcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_commission; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_service_id_commission FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_lead_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_service_id_lead_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_lead_offer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_service_id_lead_offer FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_service_id_order_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_service_id_order_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_spassport_id_spassport_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT fk_spassport_id_spassport_order_item FOREIGN KEY (spassport_id) REFERENCES spassport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_ticket; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_start_location_id_ticket FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_start_location_id_tour FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_transport_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_start_transport_id_tour FOREIGN KEY (start_transport_id) REFERENCES transport(id);


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

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_subaccount_from_id_transfer FOREIGN KEY (subaccount_from_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_company_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT fk_subaccount_id_company_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT fk_subaccount_id_supplier_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_to_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_subaccount_to_id_transfer FOREIGN KEY (subaccount_to_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_currency_rate; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_supplier_id_currency_rate FOREIGN KEY (supplier_id) REFERENCES supplier(id);


--
-- Name: fk_supplier_id_lead_offer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_supplier_id_lead_offer FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_supplier_id_order_item FOREIGN KEY (supplier_id) REFERENCES supplier(id);


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
-- Name: fk_supplier_id_supplier_contract; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT fk_supplier_id_supplier_contract FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT fk_supplier_id_supplier_subaccount FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_type_id_supplier; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT fk_supplier_type_id_supplier FOREIGN KEY (supplier_type_id) REFERENCES supplier_type(id);


--
-- Name: fk_task_id_task_resource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_task_id_task_resource FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_task_id_task_upload; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT fk_task_id_task_upload FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_ticket_class_id_ticket; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_ticket_class_id_ticket FOREIGN KEY (ticket_class_id) REFERENCES ticket_class(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_ticket_id_ticket_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT fk_ticket_id_ticket_order_item FOREIGN KEY (ticket_id) REFERENCES ticket(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT fk_tour_id_tour_order_item FOREIGN KEY (tour_id) REFERENCES tour(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_transfer_id_tour; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_transfer_id_tour FOREIGN KEY (transfer_id) REFERENCES transfer(id);


--
-- Name: fk_transport_id_ticket; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_transport_id_ticket FOREIGN KEY (transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_employee_upload; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT fk_upload_id_employee_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_note_upload; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT fk_upload_id_note_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_task_upload; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT fk_upload_id_task_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_visa_id_visa_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT fk_visa_id_visa_order_item FOREIGN KEY (visa_id) REFERENCES visa(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

