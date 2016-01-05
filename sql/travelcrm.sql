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
-- Name: company; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA company;


--
-- Name: demo_ru; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA demo_ru;


--
-- Name: test; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA test;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = company, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accomodation; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE accomodation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: accomodation_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE accomodation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accomodation_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE accomodation_id_seq OWNED BY accomodation.id;


--
-- Name: account; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: account_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE account_id_seq OWNED BY account.id;


--
-- Name: account_item; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: account_item_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE account_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_item_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE account_item_id_seq OWNED BY account_item.id;


--
-- Name: address; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE address (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    location_id integer NOT NULL,
    zip_code character varying(12) NOT NULL,
    address character varying(255) NOT NULL
);


--
-- Name: address_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE address_id_seq OWNED BY address.id;


--
-- Name: advsource; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE advsource (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: advsource_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE advsource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: advsource_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE advsource_id_seq OWNED BY advsource.id;


--
-- Name: alembic_version; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: appointment; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: bank; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE bank (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: bank_address; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE bank_address (
    bank_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: bank_detail; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: bank_detail_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE bank_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE bank_detail_id_seq OWNED BY bank_detail.id;


--
-- Name: bank_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE bank_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE bank_id_seq OWNED BY bank.id;


--
-- Name: bperson; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: bperson_contact; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE bperson_contact (
    bperson_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: bperson_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE bperson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bperson_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE bperson_id_seq OWNED BY bperson.id;


--
-- Name: calculation; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE calculation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    order_item_id integer,
    contract_id integer
);


--
-- Name: calculation_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE calculation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calculation_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE calculation_id_seq OWNED BY calculation.id;


--
-- Name: campaign; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE campaign (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    subject character varying(128) NOT NULL,
    plain_content text,
    html_content text,
    start_dt timestamp with time zone NOT NULL,
    status smallint NOT NULL
);


--
-- Name: campaign_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE campaign_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaign_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE campaign_id_seq OWNED BY campaign.id;


--
-- Name: cashflow; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: commission; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: commission_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE commission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commission_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE commission_id_seq OWNED BY commission.id;


--
-- Name: companies_counter; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE companies_counter
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: position; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE "position" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    structure_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: companies_positions_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE companies_positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE companies_positions_id_seq OWNED BY "position".id;


--
-- Name: company; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: company_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE company_id_seq OWNED BY company.id;


--
-- Name: company_subaccount; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE company_subaccount (
    company_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: contact; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: contact_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE contact_id_seq OWNED BY contact.id;


--
-- Name: contract; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: contract_commission; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE contract_commission (
    contract_id integer NOT NULL,
    commission_id integer NOT NULL
);


--
-- Name: country; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE country (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(2) NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: country_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: crosspayment; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE crosspayment (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    cashflow_id integer NOT NULL,
    descr character varying(255)
);


--
-- Name: crosspayment_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE crosspayment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crosspayment_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE crosspayment_id_seq OWNED BY crosspayment.id;


--
-- Name: currency; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE currency (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(3) NOT NULL
);


--
-- Name: currency_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE currency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currency_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE currency_id_seq OWNED BY currency.id;


--
-- Name: currency_rate; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: currency_rate_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE currency_rate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currency_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE currency_rate_id_seq OWNED BY currency_rate.id;


--
-- Name: employee; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: employee_address; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE employee_address (
    employee_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: employee_contact; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE employee_contact (
    employee_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: employee_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE employee_id_seq OWNED BY employee.id;


--
-- Name: employee_notification; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE employee_notification (
    employee_id integer NOT NULL,
    notification_id integer NOT NULL,
    status smallint NOT NULL
);


--
-- Name: employee_passport; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE employee_passport (
    employee_id integer NOT NULL,
    passport_id integer NOT NULL
);


--
-- Name: employee_subaccount; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE employee_subaccount (
    employee_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: employee_upload; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE employee_upload (
    employee_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE employees_appointments_h_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE employees_appointments_h_id_seq OWNED BY appointment.id;


--
-- Name: foodcat; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE foodcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: foodcat_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE foodcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foodcat_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE foodcat_id_seq OWNED BY foodcat.id;


--
-- Name: hotel; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE hotel (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    hotelcat_id integer NOT NULL,
    name character varying(32) NOT NULL,
    location_id integer
);


--
-- Name: hotel_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE hotel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE hotel_id_seq OWNED BY hotel.id;


--
-- Name: hotelcat; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE hotelcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: hotelcat_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE hotelcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hotelcat_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE hotelcat_id_seq OWNED BY hotelcat.id;


--
-- Name: income; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: income_cashflow; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE income_cashflow (
    income_id integer NOT NULL,
    cashflow_id integer NOT NULL
);


--
-- Name: income_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE income_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: income_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE income_id_seq OWNED BY income.id;


--
-- Name: invoice; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: invoice_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE invoice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE invoice_id_seq OWNED BY invoice.id;


--
-- Name: invoice_item; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: invoice_item_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE invoice_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_item_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE invoice_item_id_seq OWNED BY invoice_item.id;


--
-- Name: lead; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: lead_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE lead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE lead_id_seq OWNED BY lead.id;


--
-- Name: lead_item; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: lead_item_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE lead_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_item_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE lead_item_id_seq OWNED BY lead_item.id;


--
-- Name: lead_offer; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: lead_offer_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE lead_offer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_offer_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE lead_offer_id_seq OWNED BY lead_offer.id;


--
-- Name: licence_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE licence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: licence_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE licence_id_seq OWNED BY contract.id;


--
-- Name: location; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE location (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    region_id integer NOT NULL
);


--
-- Name: location_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


--
-- Name: navigation; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: note; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE note (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    title character varying(255) NOT NULL,
    descr character varying
);


--
-- Name: note_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE note_id_seq OWNED BY note.id;


--
-- Name: note_resource; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE note_resource (
    note_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: note_upload; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE note_upload (
    note_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: notification; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: notification_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE notification_id_seq OWNED BY notification.id;


--
-- Name: notification_resource; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE notification_resource (
    notification_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: order; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: order_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE order_id_seq OWNED BY "order".id;


--
-- Name: order_item; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE order_item_id_seq OWNED BY order_item.id;


--
-- Name: outgoing; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: outgoing_cashflow; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE outgoing_cashflow (
    outgoing_id integer NOT NULL,
    cashflow_id integer NOT NULL
);


--
-- Name: outgoing_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE outgoing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outgoing_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE outgoing_id_seq OWNED BY outgoing.id;


--
-- Name: passport; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: passport_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE passport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: passport_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE passport_id_seq OWNED BY passport.id;


--
-- Name: passport_upload; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE passport_upload (
    passport_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: permision; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: person; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE person (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    first_name character varying(32) NOT NULL,
    last_name character varying(32),
    second_name character varying(32),
    birthday date,
    gender integer,
    descr character varying(255),
    person_category_id integer,
    email_subscription boolean,
    sms_subscription boolean
);


--
-- Name: person_address; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE person_address (
    person_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: person_category; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE person_category (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: person_category_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE person_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_category_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE person_category_id_seq OWNED BY person_category.id;


--
-- Name: person_contact; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE person_contact (
    person_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: person_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE person_id_seq OWNED BY person.id;


--
-- Name: person_order_item; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE person_order_item (
    order_item_id integer NOT NULL,
    person_id integer NOT NULL
);


--
-- Name: person_passport; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE person_passport (
    person_id integer NOT NULL,
    passport_id integer NOT NULL
);


--
-- Name: person_subaccount; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE person_subaccount (
    person_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE positions_navigations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE positions_navigations_id_seq OWNED BY navigation.id;


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE positions_permisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE positions_permisions_id_seq OWNED BY permision.id;


--
-- Name: region; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE region (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    country_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: region_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE region_id_seq OWNED BY region.id;


--
-- Name: resource; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE resource (
    id integer NOT NULL,
    resource_type_id integer NOT NULL,
    structure_id integer NOT NULL,
    protected boolean
);


--
-- Name: resource_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE resource_id_seq OWNED BY resource.id;


--
-- Name: resource_log; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE resource_log (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    comment character varying(512),
    modifydt timestamp with time zone
);


--
-- Name: resource_log_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE resource_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_log_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE resource_log_id_seq OWNED BY resource_log.id;


--
-- Name: resource_type; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: resource_type_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE resource_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_type_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE resource_type_id_seq OWNED BY resource_type.id;


--
-- Name: roomcat; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE roomcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: roomcat_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE roomcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roomcat_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE roomcat_id_seq OWNED BY roomcat.id;


--
-- Name: service; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: service_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE service_id_seq OWNED BY service.id;


--
-- Name: spassport; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: spassport_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE spassport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spassport_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE spassport_id_seq OWNED BY spassport.id;


--
-- Name: spassport_order_item; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE spassport_order_item (
    order_item_id integer NOT NULL,
    spassport_id integer NOT NULL
);


--
-- Name: structure; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE structure (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    parent_id integer,
    name character varying(32) NOT NULL,
    company_id integer NOT NULL
);


--
-- Name: structure_address; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE structure_address (
    structure_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: structure_bank_detail; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE structure_bank_detail (
    structure_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


--
-- Name: structure_contact; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE structure_contact (
    structure_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: structures_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE structures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: structures_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE structures_id_seq OWNED BY structure.id;


--
-- Name: subaccount; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: subaccount_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE subaccount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE subaccount_id_seq OWNED BY subaccount.id;


--
-- Name: supplier; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: supplier_bank_detail; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE supplier_bank_detail (
    supplier_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


--
-- Name: supplier_bperson; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE supplier_bperson (
    supplier_id integer NOT NULL,
    bperson_id integer NOT NULL
);


--
-- Name: supplier_contract; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE supplier_contract (
    supplier_id integer NOT NULL,
    contract_id integer NOT NULL
);


--
-- Name: supplier_subaccount; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE supplier_subaccount (
    supplier_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: supplier_type; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE supplier_type (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    descr character varying(255)
);


--
-- Name: supplier_type_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE supplier_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_type_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE supplier_type_id_seq OWNED BY supplier_type.id;


--
-- Name: task; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: task_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE task_id_seq OWNED BY task.id;


--
-- Name: task_resource; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE task_resource (
    task_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: task_upload; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE task_upload (
    task_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: ticket; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: ticket_class; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE ticket_class (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: ticket_class_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE ticket_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_class_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE ticket_class_id_seq OWNED BY ticket_class.id;


--
-- Name: ticket_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE ticket_id_seq OWNED BY ticket.id;


--
-- Name: ticket_order_item; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE ticket_order_item (
    order_item_id integer NOT NULL,
    ticket_id integer NOT NULL
);


--
-- Name: tour; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: tour_id_seq1; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE tour_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tour_id_seq1; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE tour_id_seq1 OWNED BY tour.id;


--
-- Name: tour_order_item; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE tour_order_item (
    order_item_id integer NOT NULL,
    tour_id integer NOT NULL
);


--
-- Name: touroperator_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE touroperator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: touroperator_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE touroperator_id_seq OWNED BY supplier.id;


--
-- Name: transfer; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE transfer (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: transfer_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE transfer_id_seq OWNED BY cashflow.id;


--
-- Name: transfer_id_seq1; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE transfer_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_id_seq1; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE transfer_id_seq1 OWNED BY transfer.id;


--
-- Name: transport; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE transport (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: transport_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE transport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transport_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE transport_id_seq OWNED BY transport.id;


--
-- Name: uni_list; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE uni_list (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: uni_list_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE uni_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: uni_list_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE uni_list_id_seq OWNED BY uni_list.id;


--
-- Name: upload; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: upload_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE upload_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: upload_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE upload_id_seq OWNED BY upload.id;


--
-- Name: user; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(128) NOT NULL,
    password character varying(128) NOT NULL,
    employee_id integer NOT NULL
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: vat; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: vat_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE vat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vat_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE vat_id_seq OWNED BY vat.id;


--
-- Name: visa; Type: TABLE; Schema: company; Owner: -; Tablespace: 
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
-- Name: visa_id_seq; Type: SEQUENCE; Schema: company; Owner: -
--

CREATE SEQUENCE visa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visa_id_seq; Type: SEQUENCE OWNED BY; Schema: company; Owner: -
--

ALTER SEQUENCE visa_id_seq OWNED BY visa.id;


--
-- Name: visa_order_item; Type: TABLE; Schema: company; Owner: -; Tablespace: 
--

CREATE TABLE visa_order_item (
    order_item_id integer NOT NULL,
    visa_id integer NOT NULL
);


SET search_path = demo_ru, pg_catalog;

--
-- Name: accomodation; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE accomodation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: accomodation_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE accomodation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accomodation_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE accomodation_id_seq OWNED BY accomodation.id;


--
-- Name: account; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE account (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    currency_id integer NOT NULL,
    account_type smallint NOT NULL,
    name character varying(255) NOT NULL,
    display_text character varying(255) NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: account_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE account_id_seq OWNED BY account.id;


--
-- Name: account_item; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE account_item (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    parent_id integer,
    name character varying(128) NOT NULL,
    type smallint NOT NULL,
    status smallint NOT NULL,
    descr character varying(128)
);


--
-- Name: account_item_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE account_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_item_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE account_item_id_seq OWNED BY account_item.id;


--
-- Name: address; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE address (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    location_id integer NOT NULL,
    zip_code character varying(12) NOT NULL,
    address character varying(255) NOT NULL
);


--
-- Name: address_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE address_id_seq OWNED BY address.id;


--
-- Name: advsource; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE advsource (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: advsource_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE advsource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: advsource_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE advsource_id_seq OWNED BY advsource.id;


--
-- Name: alembic_version; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: appointment; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE appointment (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    date date,
    employee_id integer NOT NULL,
    position_id integer NOT NULL,
    salary numeric(16,2) NOT NULL,
    currency_id integer NOT NULL
);


--
-- Name: appointment_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE appointment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE appointment_id_seq OWNED BY appointment.id;


--
-- Name: bank; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE bank (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: bank_address; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE bank_address (
    bank_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: bank_detail; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
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
-- Name: bank_detail_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE bank_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE bank_detail_id_seq OWNED BY bank_detail.id;


--
-- Name: bank_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE bank_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE bank_id_seq OWNED BY bank.id;


--
-- Name: bperson; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE bperson (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    first_name character varying(32) NOT NULL,
    last_name character varying(32),
    second_name character varying(32),
    position_name character varying(64),
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: bperson_contact; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE bperson_contact (
    bperson_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: bperson_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE bperson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bperson_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE bperson_id_seq OWNED BY bperson.id;


--
-- Name: calculation; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE calculation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    order_item_id integer,
    price numeric(16,2) NOT NULL,
    contract_id integer
);


--
-- Name: calculation_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE calculation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calculation_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE calculation_id_seq OWNED BY calculation.id;


--
-- Name: campaign; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE campaign (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    subject character varying(128) NOT NULL,
    plain_content text,
    html_content text,
    start_dt timestamp with time zone NOT NULL,
    status smallint NOT NULL
);


--
-- Name: campaign_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE campaign_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaign_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE campaign_id_seq OWNED BY campaign.id;


--
-- Name: cashflow; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE cashflow (
    id integer NOT NULL,
    subaccount_from_id integer,
    subaccount_to_id integer,
    account_item_id integer,
    sum numeric(16,2) NOT NULL,
    vat numeric(16,2),
    date date NOT NULL,
    CONSTRAINT constraint_cashflow_subaccount CHECK (((subaccount_from_id IS NOT NULL) OR (subaccount_to_id IS NOT NULL)))
);


--
-- Name: cashflow_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE cashflow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cashflow_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE cashflow_id_seq OWNED BY cashflow.id;


--
-- Name: commission; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
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
-- Name: commission_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE commission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commission_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE commission_id_seq OWNED BY commission.id;


--
-- Name: company; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE company (
    id integer NOT NULL,
    resource_id integer,
    currency_id integer,
    name character varying(32) NOT NULL,
    email character varying(32) NOT NULL,
    settings json
);


--
-- Name: company_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE company_id_seq OWNED BY company.id;


--
-- Name: company_subaccount; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE company_subaccount (
    company_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: contact; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE contact (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    contact_type smallint NOT NULL,
    contact character varying NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: contact_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE contact_id_seq OWNED BY contact.id;


--
-- Name: contract; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE contract (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    num character varying NOT NULL,
    date date NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: contract_commission; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE contract_commission (
    contract_id integer NOT NULL,
    commission_id integer NOT NULL
);


--
-- Name: contract_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE contract_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contract_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE contract_id_seq OWNED BY contract.id;


--
-- Name: country; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE country (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(2) NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: country_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: crosspayment; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE crosspayment (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    cashflow_id integer NOT NULL,
    descr character varying(255)
);


--
-- Name: crosspayment_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE crosspayment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crosspayment_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE crosspayment_id_seq OWNED BY crosspayment.id;


--
-- Name: currency; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE currency (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(3) NOT NULL
);


--
-- Name: currency_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE currency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currency_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE currency_id_seq OWNED BY currency.id;


--
-- Name: currency_rate; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE currency_rate (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    currency_id integer NOT NULL,
    supplier_id integer NOT NULL,
    date date NOT NULL,
    rate numeric(16,2) NOT NULL
);


--
-- Name: currency_rate_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE currency_rate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currency_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE currency_rate_id_seq OWNED BY currency_rate.id;


--
-- Name: employee; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE employee (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    photo_upload_id integer,
    first_name character varying(32) NOT NULL,
    last_name character varying(32) NOT NULL,
    second_name character varying(32),
    itn character varying(32),
    dismissal_date date
);


--
-- Name: employee_address; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE employee_address (
    employee_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: employee_contact; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE employee_contact (
    employee_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: employee_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE employee_id_seq OWNED BY employee.id;


--
-- Name: employee_notification; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE employee_notification (
    employee_id integer NOT NULL,
    notification_id integer NOT NULL,
    status smallint NOT NULL
);


--
-- Name: employee_passport; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE employee_passport (
    employee_id integer NOT NULL,
    passport_id integer NOT NULL
);


--
-- Name: employee_subaccount; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE employee_subaccount (
    employee_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: employee_upload; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE employee_upload (
    employee_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: foodcat; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE foodcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: foodcat_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE foodcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foodcat_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE foodcat_id_seq OWNED BY foodcat.id;


--
-- Name: hotel; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE hotel (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    hotelcat_id integer NOT NULL,
    location_id integer,
    name character varying(32) NOT NULL
);


--
-- Name: hotel_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE hotel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE hotel_id_seq OWNED BY hotel.id;


--
-- Name: hotelcat; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE hotelcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: hotelcat_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE hotelcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hotelcat_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE hotelcat_id_seq OWNED BY hotelcat.id;


--
-- Name: income; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE income (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    invoice_id integer NOT NULL,
    account_item_id integer NOT NULL,
    sum numeric(16,2) NOT NULL,
    date date NOT NULL,
    descr character varying(255)
);


--
-- Name: income_cashflow; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE income_cashflow (
    income_id integer NOT NULL,
    cashflow_id integer NOT NULL
);


--
-- Name: income_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE income_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: income_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE income_id_seq OWNED BY income.id;


--
-- Name: invoice; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE invoice (
    id integer NOT NULL,
    date date NOT NULL,
    active_until date NOT NULL,
    resource_id integer NOT NULL,
    order_id integer NOT NULL,
    account_id integer NOT NULL,
    descr character varying(255)
);


--
-- Name: invoice_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE invoice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE invoice_id_seq OWNED BY invoice.id;


--
-- Name: invoice_item; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE invoice_item (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    order_item_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    vat numeric(16,2) NOT NULL,
    discount numeric(16,2) NOT NULL,
    descr character varying(255)
);


--
-- Name: invoice_item_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE invoice_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_item_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE invoice_item_id_seq OWNED BY invoice_item.id;


--
-- Name: lead; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
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
-- Name: lead_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE lead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE lead_id_seq OWNED BY lead.id;


--
-- Name: lead_item; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
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
-- Name: lead_item_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE lead_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_item_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE lead_item_id_seq OWNED BY lead_item.id;


--
-- Name: lead_offer; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
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
-- Name: lead_offer_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE lead_offer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_offer_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE lead_offer_id_seq OWNED BY lead_offer.id;


--
-- Name: location; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE location (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    region_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: location_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


--
-- Name: navigation; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE navigation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    position_id integer,
    parent_id integer,
    name character varying(32) NOT NULL,
    url character varying(128) NOT NULL,
    action character varying(32),
    icon_cls character varying(32),
    separator_before boolean,
    sort_order integer NOT NULL
);


--
-- Name: navigation_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE navigation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: navigation_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE navigation_id_seq OWNED BY navigation.id;


--
-- Name: note; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE note (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    title character varying(255) NOT NULL,
    descr character varying
);


--
-- Name: note_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE note_id_seq OWNED BY note.id;


--
-- Name: note_resource; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE note_resource (
    note_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: note_upload; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE note_upload (
    note_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: notification; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE notification (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    title character varying NOT NULL,
    descr character varying NOT NULL,
    url character varying,
    created timestamp with time zone
);


--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE notification_id_seq OWNED BY notification.id;


--
-- Name: notification_resource; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE notification_resource (
    notification_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: order; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE "order" (
    id integer NOT NULL,
    deal_date date NOT NULL,
    resource_id integer NOT NULL,
    customer_id integer NOT NULL,
    lead_id integer,
    advsource_id integer NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: order_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE order_id_seq OWNED BY "order".id;


--
-- Name: order_item; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE order_item (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    order_id integer,
    service_id integer NOT NULL,
    currency_id integer NOT NULL,
    supplier_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    discount_sum numeric(16,2) NOT NULL,
    discount_percent numeric(16,2) NOT NULL,
    status smallint NOT NULL,
    status_date date,
    status_info character varying(128)
);


--
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE order_item_id_seq OWNED BY order_item.id;


--
-- Name: outgoing; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE outgoing (
    id integer NOT NULL,
    date date NOT NULL,
    resource_id integer NOT NULL,
    account_item_id integer NOT NULL,
    subaccount_id integer NOT NULL,
    sum numeric(16,2) NOT NULL,
    descr character varying(255)
);


--
-- Name: outgoing_cashflow; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE outgoing_cashflow (
    outgoing_id integer NOT NULL,
    cashflow_id integer NOT NULL
);


--
-- Name: outgoing_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE outgoing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outgoing_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE outgoing_id_seq OWNED BY outgoing.id;


--
-- Name: passport; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE passport (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    country_id integer NOT NULL,
    passport_type smallint NOT NULL,
    num character varying(32) NOT NULL,
    end_date date,
    descr character varying(255)
);


--
-- Name: passport_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE passport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: passport_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE passport_id_seq OWNED BY passport.id;


--
-- Name: passport_upload; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE passport_upload (
    passport_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: permision; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE permision (
    id integer NOT NULL,
    resource_type_id integer NOT NULL,
    position_id integer NOT NULL,
    permisions character varying[],
    scope_type character varying,
    structure_id integer
);


--
-- Name: permision_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE permision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permision_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE permision_id_seq OWNED BY permision.id;


--
-- Name: person; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE person (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    person_category_id integer,
    first_name character varying(32) NOT NULL,
    last_name character varying(32),
    second_name character varying(32),
    birthday date,
    gender smallint,
    email_subscription boolean,
    sms_subscription boolean,
    descr character varying(255)
);


--
-- Name: person_address; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE person_address (
    person_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: person_category; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE person_category (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: person_category_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE person_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_category_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE person_category_id_seq OWNED BY person_category.id;


--
-- Name: person_contact; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE person_contact (
    person_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: person_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE person_id_seq OWNED BY person.id;


--
-- Name: person_order_item; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE person_order_item (
    order_item_id integer NOT NULL,
    person_id integer NOT NULL
);


--
-- Name: person_passport; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE person_passport (
    person_id integer NOT NULL,
    passport_id integer NOT NULL
);


--
-- Name: person_subaccount; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE person_subaccount (
    person_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: position; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE "position" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    structure_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: position_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE position_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: position_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE position_id_seq OWNED BY "position".id;


--
-- Name: region; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE region (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    country_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: region_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE region_id_seq OWNED BY region.id;


--
-- Name: resource; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE resource (
    id integer NOT NULL,
    resource_type_id integer NOT NULL,
    structure_id integer NOT NULL,
    protected boolean
);


--
-- Name: resource_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE resource_id_seq OWNED BY resource.id;


--
-- Name: resource_log; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE resource_log (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    comment character varying(512),
    modifydt timestamp with time zone
);


--
-- Name: resource_log_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE resource_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_log_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE resource_log_id_seq OWNED BY resource_log.id;


--
-- Name: resource_type; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE resource_type (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    humanize character varying(32) NOT NULL,
    resource_name character varying(32) NOT NULL,
    module character varying(128) NOT NULL,
    settings json,
    descr character varying(255),
    status smallint NOT NULL
);


--
-- Name: resource_type_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE resource_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_type_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE resource_type_id_seq OWNED BY resource_type.id;


--
-- Name: roomcat; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE roomcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: roomcat_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE roomcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roomcat_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE roomcat_id_seq OWNED BY roomcat.id;


--
-- Name: service; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE service (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    resource_type_id integer NOT NULL,
    name character varying(32) NOT NULL,
    display_text character varying(255) NOT NULL,
    descr character varying(255)
);


--
-- Name: service_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE service_id_seq OWNED BY service.id;


--
-- Name: spassport; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
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
-- Name: spassport_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE spassport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spassport_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE spassport_id_seq OWNED BY spassport.id;


--
-- Name: spassport_order_item; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE spassport_order_item (
    order_item_id integer NOT NULL,
    spassport_id integer NOT NULL
);


--
-- Name: structure; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE structure (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    parent_id integer,
    company_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: structure_address; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE structure_address (
    structure_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: structure_bank_detail; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE structure_bank_detail (
    structure_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


--
-- Name: structure_contact; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE structure_contact (
    structure_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: structure_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE structure_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: structure_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE structure_id_seq OWNED BY structure.id;


--
-- Name: subaccount; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE subaccount (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    account_id integer NOT NULL,
    name character varying(255) NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: subaccount_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE subaccount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE subaccount_id_seq OWNED BY subaccount.id;


--
-- Name: supplier; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE supplier (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    supplier_type_id integer NOT NULL,
    name character varying(32) NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: supplier_bank_detail; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE supplier_bank_detail (
    supplier_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


--
-- Name: supplier_bperson; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE supplier_bperson (
    supplier_id integer NOT NULL,
    bperson_id integer NOT NULL
);


--
-- Name: supplier_contract; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE supplier_contract (
    supplier_id integer NOT NULL,
    contract_id integer NOT NULL
);


--
-- Name: supplier_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE supplier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE supplier_id_seq OWNED BY supplier.id;


--
-- Name: supplier_subaccount; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE supplier_subaccount (
    supplier_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: supplier_type; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE supplier_type (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    descr character varying(255)
);


--
-- Name: supplier_type_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE supplier_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_type_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE supplier_type_id_seq OWNED BY supplier_type.id;


--
-- Name: task; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE task (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    title character varying(128) NOT NULL,
    deadline timestamp with time zone NOT NULL,
    reminder integer,
    descr character varying,
    status smallint NOT NULL
);


--
-- Name: task_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE task_id_seq OWNED BY task.id;


--
-- Name: task_resource; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE task_resource (
    task_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: task_upload; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE task_upload (
    task_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: ticket; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
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
-- Name: ticket_class; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE ticket_class (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: ticket_class_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE ticket_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_class_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE ticket_class_id_seq OWNED BY ticket_class.id;


--
-- Name: ticket_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE ticket_id_seq OWNED BY ticket.id;


--
-- Name: ticket_order_item; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE ticket_order_item (
    order_item_id integer NOT NULL,
    ticket_id integer NOT NULL
);


--
-- Name: tour; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE tour (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    start_location_id integer NOT NULL,
    start_transport_id integer NOT NULL,
    end_location_id integer NOT NULL,
    end_transport_id integer NOT NULL,
    hotel_id integer,
    accomodation_id integer,
    foodcat_id integer,
    roomcat_id integer,
    transfer_id integer,
    adults integer NOT NULL,
    children integer NOT NULL,
    start_date date NOT NULL,
    start_additional_info character varying(128),
    end_date date NOT NULL,
    end_additional_info character varying(128),
    descr character varying(255)
);


--
-- Name: tour_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE tour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tour_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE tour_id_seq OWNED BY tour.id;


--
-- Name: tour_order_item; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE tour_order_item (
    order_item_id integer NOT NULL,
    tour_id integer NOT NULL
);


--
-- Name: transfer; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE transfer (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: transfer_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE transfer_id_seq OWNED BY transfer.id;


--
-- Name: transport; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE transport (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: transport_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE transport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transport_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE transport_id_seq OWNED BY transport.id;


--
-- Name: upload; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE upload (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL,
    path character varying(255) NOT NULL,
    size numeric(16,2) NOT NULL,
    media_type character varying(32) NOT NULL,
    descr character varying(255)
);


--
-- Name: upload_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE upload_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: upload_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE upload_id_seq OWNED BY upload.id;


--
-- Name: user; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(128) NOT NULL,
    password character varying(128) NOT NULL
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: vat; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE vat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    account_id integer NOT NULL,
    service_id integer NOT NULL,
    date date NOT NULL,
    vat numeric(5,2) NOT NULL,
    calc_method smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: vat_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE vat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vat_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE vat_id_seq OWNED BY vat.id;


--
-- Name: visa; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
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
-- Name: visa_id_seq; Type: SEQUENCE; Schema: demo_ru; Owner: -
--

CREATE SEQUENCE visa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visa_id_seq; Type: SEQUENCE OWNED BY; Schema: demo_ru; Owner: -
--

ALTER SEQUENCE visa_id_seq OWNED BY visa.id;


--
-- Name: visa_order_item; Type: TABLE; Schema: demo_ru; Owner: -; Tablespace: 
--

CREATE TABLE visa_order_item (
    order_item_id integer NOT NULL,
    visa_id integer NOT NULL
);


SET search_path = public, pg_catalog;

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
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE alembic_version (
    version_num character varying(32) NOT NULL
);


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
    order_item_id integer,
    contract_id integer
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
-- Name: campaign; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE campaign (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    subject character varying(128) NOT NULL,
    plain_content text,
    html_content text,
    start_dt timestamp with time zone NOT NULL,
    status smallint NOT NULL
);


--
-- Name: campaign_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE campaign_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaign_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE campaign_id_seq OWNED BY campaign.id;


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
-- Name: companies_counter; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE companies_counter
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


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
-- Name: currency; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE currency (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(3) NOT NULL
);


--
-- Name: currency_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE currency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE currency_id_seq OWNED BY currency.id;


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
-- Name: employee_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employee_id_seq OWNED BY employee.id;


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
-- Name: passport_upload; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE passport_upload (
    passport_id integer NOT NULL,
    upload_id integer NOT NULL
);


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
    gender integer,
    descr character varying(255),
    person_category_id integer,
    email_subscription boolean,
    sms_subscription boolean
);


--
-- Name: person_address; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_address (
    person_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: person_category; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_category (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: person_category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_category_id_seq OWNED BY person_category.id;


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
-- Name: region; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE region (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    country_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE region_id_seq OWNED BY region.id;


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
-- Name: resource_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resource_id_seq OWNED BY resource.id;


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
-- Name: resource_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resource_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resource_log_id_seq OWNED BY resource_log.id;


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
-- Name: resource_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resource_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resource_type_id_seq OWNED BY resource_type.id;


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
-- Name: user; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(128) NOT NULL,
    password character varying(128) NOT NULL,
    employee_id integer NOT NULL
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


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


SET search_path = test, pg_catalog;

--
-- Name: accomodation; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE accomodation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: accomodation_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE accomodation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accomodation_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE accomodation_id_seq OWNED BY accomodation.id;


--
-- Name: account; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE account (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    currency_id integer NOT NULL,
    account_type smallint NOT NULL,
    name character varying(255) NOT NULL,
    display_text character varying(255) NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: account_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE account_id_seq OWNED BY account.id;


--
-- Name: account_item; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE account_item (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    parent_id integer,
    name character varying(128) NOT NULL,
    type smallint NOT NULL,
    status smallint NOT NULL,
    descr character varying(128)
);


--
-- Name: account_item_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE account_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_item_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE account_item_id_seq OWNED BY account_item.id;


--
-- Name: address; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE address (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    location_id integer NOT NULL,
    zip_code character varying(12) NOT NULL,
    address character varying(255) NOT NULL
);


--
-- Name: address_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE address_id_seq OWNED BY address.id;


--
-- Name: advsource; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE advsource (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: advsource_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE advsource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: advsource_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE advsource_id_seq OWNED BY advsource.id;


--
-- Name: alembic_version; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: appointment; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE appointment (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    date date,
    employee_id integer NOT NULL,
    position_id integer NOT NULL,
    salary numeric(16,2) NOT NULL,
    currency_id integer NOT NULL
);


--
-- Name: appointment_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE appointment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE appointment_id_seq OWNED BY appointment.id;


--
-- Name: bank; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE bank (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: bank_address; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE bank_address (
    bank_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: bank_detail; Type: TABLE; Schema: test; Owner: -; Tablespace: 
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
-- Name: bank_detail_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE bank_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE bank_detail_id_seq OWNED BY bank_detail.id;


--
-- Name: bank_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE bank_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE bank_id_seq OWNED BY bank.id;


--
-- Name: bperson; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE bperson (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    first_name character varying(32) NOT NULL,
    last_name character varying(32),
    second_name character varying(32),
    position_name character varying(64),
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: bperson_contact; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE bperson_contact (
    bperson_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: bperson_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE bperson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bperson_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE bperson_id_seq OWNED BY bperson.id;


--
-- Name: calculation; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE calculation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    order_item_id integer,
    price numeric(16,2) NOT NULL,
    contract_id integer
);


--
-- Name: calculation_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE calculation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calculation_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE calculation_id_seq OWNED BY calculation.id;


--
-- Name: campaign; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE campaign (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    subject character varying(128) NOT NULL,
    plain_content text,
    html_content text,
    start_dt timestamp with time zone NOT NULL,
    status smallint NOT NULL
);


--
-- Name: campaign_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE campaign_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaign_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE campaign_id_seq OWNED BY campaign.id;


--
-- Name: cashflow; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE cashflow (
    id integer NOT NULL,
    subaccount_from_id integer,
    subaccount_to_id integer,
    account_item_id integer,
    sum numeric(16,2) NOT NULL,
    vat numeric(16,2),
    date date NOT NULL,
    CONSTRAINT constraint_cashflow_subaccount CHECK (((subaccount_from_id IS NOT NULL) OR (subaccount_to_id IS NOT NULL)))
);


--
-- Name: cashflow_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE cashflow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cashflow_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE cashflow_id_seq OWNED BY cashflow.id;


--
-- Name: commission; Type: TABLE; Schema: test; Owner: -; Tablespace: 
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
-- Name: commission_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE commission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commission_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE commission_id_seq OWNED BY commission.id;


--
-- Name: company; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE company (
    id integer NOT NULL,
    resource_id integer,
    currency_id integer,
    name character varying(32) NOT NULL,
    email character varying(32) NOT NULL,
    settings json
);


--
-- Name: company_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE company_id_seq OWNED BY company.id;


--
-- Name: company_subaccount; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE company_subaccount (
    company_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: contact; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE contact (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    contact_type smallint NOT NULL,
    contact character varying NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: contact_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE contact_id_seq OWNED BY contact.id;


--
-- Name: contract; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE contract (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    num character varying NOT NULL,
    date date NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: contract_commission; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE contract_commission (
    contract_id integer NOT NULL,
    commission_id integer NOT NULL
);


--
-- Name: contract_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE contract_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contract_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE contract_id_seq OWNED BY contract.id;


--
-- Name: country; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE country (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(2) NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: country_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: crosspayment; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE crosspayment (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    cashflow_id integer NOT NULL,
    descr character varying(255)
);


--
-- Name: crosspayment_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE crosspayment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crosspayment_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE crosspayment_id_seq OWNED BY crosspayment.id;


--
-- Name: currency; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE currency (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    iso_code character varying(3) NOT NULL
);


--
-- Name: currency_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE currency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currency_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE currency_id_seq OWNED BY currency.id;


--
-- Name: currency_rate; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE currency_rate (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    currency_id integer NOT NULL,
    supplier_id integer NOT NULL,
    date date NOT NULL,
    rate numeric(16,2) NOT NULL
);


--
-- Name: currency_rate_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE currency_rate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currency_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE currency_rate_id_seq OWNED BY currency_rate.id;


--
-- Name: employee; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE employee (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    photo_upload_id integer,
    first_name character varying(32) NOT NULL,
    last_name character varying(32) NOT NULL,
    second_name character varying(32),
    itn character varying(32),
    dismissal_date date
);


--
-- Name: employee_address; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE employee_address (
    employee_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: employee_contact; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE employee_contact (
    employee_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: employee_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE employee_id_seq OWNED BY employee.id;


--
-- Name: employee_notification; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE employee_notification (
    employee_id integer NOT NULL,
    notification_id integer NOT NULL,
    status smallint NOT NULL
);


--
-- Name: employee_passport; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE employee_passport (
    employee_id integer NOT NULL,
    passport_id integer NOT NULL
);


--
-- Name: employee_subaccount; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE employee_subaccount (
    employee_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: employee_upload; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE employee_upload (
    employee_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: foodcat; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE foodcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: foodcat_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE foodcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foodcat_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE foodcat_id_seq OWNED BY foodcat.id;


--
-- Name: hotel; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE hotel (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    hotelcat_id integer NOT NULL,
    location_id integer,
    name character varying(32) NOT NULL
);


--
-- Name: hotel_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE hotel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE hotel_id_seq OWNED BY hotel.id;


--
-- Name: hotelcat; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE hotelcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: hotelcat_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE hotelcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hotelcat_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE hotelcat_id_seq OWNED BY hotelcat.id;


--
-- Name: income; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE income (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    invoice_id integer NOT NULL,
    account_item_id integer NOT NULL,
    sum numeric(16,2) NOT NULL,
    date date NOT NULL,
    descr character varying(255)
);


--
-- Name: income_cashflow; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE income_cashflow (
    income_id integer NOT NULL,
    cashflow_id integer NOT NULL
);


--
-- Name: income_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE income_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: income_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE income_id_seq OWNED BY income.id;


--
-- Name: invoice; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE invoice (
    id integer NOT NULL,
    date date NOT NULL,
    active_until date NOT NULL,
    resource_id integer NOT NULL,
    order_id integer NOT NULL,
    account_id integer NOT NULL,
    descr character varying(255)
);


--
-- Name: invoice_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE invoice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE invoice_id_seq OWNED BY invoice.id;


--
-- Name: invoice_item; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE invoice_item (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    order_item_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    vat numeric(16,2) NOT NULL,
    discount numeric(16,2) NOT NULL,
    descr character varying(255)
);


--
-- Name: invoice_item_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE invoice_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_item_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE invoice_item_id_seq OWNED BY invoice_item.id;


--
-- Name: lead; Type: TABLE; Schema: test; Owner: -; Tablespace: 
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
-- Name: lead_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE lead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE lead_id_seq OWNED BY lead.id;


--
-- Name: lead_item; Type: TABLE; Schema: test; Owner: -; Tablespace: 
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
-- Name: lead_item_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE lead_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_item_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE lead_item_id_seq OWNED BY lead_item.id;


--
-- Name: lead_offer; Type: TABLE; Schema: test; Owner: -; Tablespace: 
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
-- Name: lead_offer_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE lead_offer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lead_offer_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE lead_offer_id_seq OWNED BY lead_offer.id;


--
-- Name: location; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE location (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    region_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: location_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


--
-- Name: navigation; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE navigation (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    position_id integer,
    parent_id integer,
    name character varying(32) NOT NULL,
    url character varying(128) NOT NULL,
    action character varying(32),
    icon_cls character varying(32),
    separator_before boolean,
    sort_order integer NOT NULL
);


--
-- Name: navigation_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE navigation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: navigation_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE navigation_id_seq OWNED BY navigation.id;


--
-- Name: note; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE note (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    title character varying(255) NOT NULL,
    descr character varying
);


--
-- Name: note_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE note_id_seq OWNED BY note.id;


--
-- Name: note_resource; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE note_resource (
    note_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: note_upload; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE note_upload (
    note_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: notification; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE notification (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    title character varying NOT NULL,
    descr character varying NOT NULL,
    url character varying,
    created timestamp with time zone
);


--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE notification_id_seq OWNED BY notification.id;


--
-- Name: notification_resource; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE notification_resource (
    notification_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: order; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE "order" (
    id integer NOT NULL,
    deal_date date NOT NULL,
    resource_id integer NOT NULL,
    customer_id integer NOT NULL,
    lead_id integer,
    advsource_id integer NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: order_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE order_id_seq OWNED BY "order".id;


--
-- Name: order_item; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE order_item (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    order_id integer,
    service_id integer NOT NULL,
    currency_id integer NOT NULL,
    supplier_id integer NOT NULL,
    price numeric(16,2) NOT NULL,
    discount_sum numeric(16,2) NOT NULL,
    discount_percent numeric(16,2) NOT NULL,
    status smallint NOT NULL,
    status_date date,
    status_info character varying(128)
);


--
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE order_item_id_seq OWNED BY order_item.id;


--
-- Name: outgoing; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE outgoing (
    id integer NOT NULL,
    date date NOT NULL,
    resource_id integer NOT NULL,
    account_item_id integer NOT NULL,
    subaccount_id integer NOT NULL,
    sum numeric(16,2) NOT NULL,
    descr character varying(255)
);


--
-- Name: outgoing_cashflow; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE outgoing_cashflow (
    outgoing_id integer NOT NULL,
    cashflow_id integer NOT NULL
);


--
-- Name: outgoing_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE outgoing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outgoing_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE outgoing_id_seq OWNED BY outgoing.id;


--
-- Name: passport; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE passport (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    country_id integer NOT NULL,
    passport_type smallint NOT NULL,
    num character varying(32) NOT NULL,
    end_date date,
    descr character varying(255)
);


--
-- Name: passport_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE passport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: passport_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE passport_id_seq OWNED BY passport.id;


--
-- Name: passport_upload; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE passport_upload (
    passport_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: permision; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE permision (
    id integer NOT NULL,
    resource_type_id integer NOT NULL,
    position_id integer NOT NULL,
    permisions character varying[],
    scope_type character varying,
    structure_id integer
);


--
-- Name: permision_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE permision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permision_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE permision_id_seq OWNED BY permision.id;


--
-- Name: person; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE person (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    person_category_id integer,
    first_name character varying(32) NOT NULL,
    last_name character varying(32),
    second_name character varying(32),
    birthday date,
    gender smallint,
    email_subscription boolean,
    sms_subscription boolean,
    descr character varying(255)
);


--
-- Name: person_address; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE person_address (
    person_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: person_category; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE person_category (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: person_category_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE person_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_category_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE person_category_id_seq OWNED BY person_category.id;


--
-- Name: person_contact; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE person_contact (
    person_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: person_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE person_id_seq OWNED BY person.id;


--
-- Name: person_order_item; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE person_order_item (
    order_item_id integer NOT NULL,
    person_id integer NOT NULL
);


--
-- Name: person_passport; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE person_passport (
    person_id integer NOT NULL,
    passport_id integer NOT NULL
);


--
-- Name: person_subaccount; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE person_subaccount (
    person_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: position; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE "position" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    structure_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: position_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE position_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: position_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE position_id_seq OWNED BY "position".id;


--
-- Name: region; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE region (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    country_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: region_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE region_id_seq OWNED BY region.id;


--
-- Name: resource; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE resource (
    id integer NOT NULL,
    resource_type_id integer NOT NULL,
    structure_id integer NOT NULL,
    protected boolean
);


--
-- Name: resource_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE resource_id_seq OWNED BY resource.id;


--
-- Name: resource_log; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE resource_log (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    comment character varying(512),
    modifydt timestamp with time zone
);


--
-- Name: resource_log_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE resource_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_log_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE resource_log_id_seq OWNED BY resource_log.id;


--
-- Name: resource_type; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE resource_type (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    humanize character varying(32) NOT NULL,
    resource_name character varying(32) NOT NULL,
    module character varying(128) NOT NULL,
    settings json,
    descr character varying(255),
    status smallint NOT NULL
);


--
-- Name: resource_type_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE resource_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_type_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE resource_type_id_seq OWNED BY resource_type.id;


--
-- Name: roomcat; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE roomcat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: roomcat_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE roomcat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roomcat_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE roomcat_id_seq OWNED BY roomcat.id;


--
-- Name: service; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE service (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    resource_type_id integer NOT NULL,
    name character varying(32) NOT NULL,
    display_text character varying(255) NOT NULL,
    descr character varying(255)
);


--
-- Name: service_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE service_id_seq OWNED BY service.id;


--
-- Name: spassport; Type: TABLE; Schema: test; Owner: -; Tablespace: 
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
-- Name: spassport_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE spassport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spassport_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE spassport_id_seq OWNED BY spassport.id;


--
-- Name: spassport_order_item; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE spassport_order_item (
    order_item_id integer NOT NULL,
    spassport_id integer NOT NULL
);


--
-- Name: structure; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE structure (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    parent_id integer,
    company_id integer NOT NULL,
    name character varying(32) NOT NULL
);


--
-- Name: structure_address; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE structure_address (
    structure_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: structure_bank_detail; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE structure_bank_detail (
    structure_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


--
-- Name: structure_contact; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE structure_contact (
    structure_id integer NOT NULL,
    contact_id integer NOT NULL
);


--
-- Name: structure_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE structure_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: structure_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE structure_id_seq OWNED BY structure.id;


--
-- Name: subaccount; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE subaccount (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    account_id integer NOT NULL,
    name character varying(255) NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: subaccount_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE subaccount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE subaccount_id_seq OWNED BY subaccount.id;


--
-- Name: supplier; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE supplier (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    supplier_type_id integer NOT NULL,
    name character varying(32) NOT NULL,
    status smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: supplier_bank_detail; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE supplier_bank_detail (
    supplier_id integer NOT NULL,
    bank_detail_id integer NOT NULL
);


--
-- Name: supplier_bperson; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE supplier_bperson (
    supplier_id integer NOT NULL,
    bperson_id integer NOT NULL
);


--
-- Name: supplier_contract; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE supplier_contract (
    supplier_id integer NOT NULL,
    contract_id integer NOT NULL
);


--
-- Name: supplier_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE supplier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE supplier_id_seq OWNED BY supplier.id;


--
-- Name: supplier_subaccount; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE supplier_subaccount (
    supplier_id integer NOT NULL,
    subaccount_id integer NOT NULL
);


--
-- Name: supplier_type; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE supplier_type (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(32) NOT NULL,
    descr character varying(255)
);


--
-- Name: supplier_type_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE supplier_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_type_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE supplier_type_id_seq OWNED BY supplier_type.id;


--
-- Name: task; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE task (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    title character varying(128) NOT NULL,
    deadline timestamp with time zone NOT NULL,
    reminder integer,
    descr character varying,
    status smallint NOT NULL
);


--
-- Name: task_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE task_id_seq OWNED BY task.id;


--
-- Name: task_resource; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE task_resource (
    task_id integer NOT NULL,
    resource_id integer NOT NULL
);


--
-- Name: task_upload; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE task_upload (
    task_id integer NOT NULL,
    upload_id integer NOT NULL
);


--
-- Name: ticket; Type: TABLE; Schema: test; Owner: -; Tablespace: 
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
-- Name: ticket_class; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE ticket_class (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: ticket_class_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE ticket_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_class_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE ticket_class_id_seq OWNED BY ticket_class.id;


--
-- Name: ticket_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE ticket_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE ticket_id_seq OWNED BY ticket.id;


--
-- Name: ticket_order_item; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE ticket_order_item (
    order_item_id integer NOT NULL,
    ticket_id integer NOT NULL
);


--
-- Name: tour; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE tour (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    start_location_id integer NOT NULL,
    start_transport_id integer NOT NULL,
    end_location_id integer NOT NULL,
    end_transport_id integer NOT NULL,
    hotel_id integer,
    accomodation_id integer,
    foodcat_id integer,
    roomcat_id integer,
    transfer_id integer,
    adults integer NOT NULL,
    children integer NOT NULL,
    start_date date NOT NULL,
    start_additional_info character varying(128),
    end_date date NOT NULL,
    end_additional_info character varying(128),
    descr character varying(255)
);


--
-- Name: tour_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE tour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tour_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE tour_id_seq OWNED BY tour.id;


--
-- Name: tour_order_item; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE tour_order_item (
    order_item_id integer NOT NULL,
    tour_id integer NOT NULL
);


--
-- Name: transfer; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE transfer (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: transfer_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE transfer_id_seq OWNED BY transfer.id;


--
-- Name: transport; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE transport (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: transport_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE transport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transport_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE transport_id_seq OWNED BY transport.id;


--
-- Name: upload; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE upload (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    name character varying(255) NOT NULL,
    path character varying(255) NOT NULL,
    size numeric(16,2) NOT NULL,
    media_type character varying(32) NOT NULL,
    descr character varying(255)
);


--
-- Name: upload_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE upload_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: upload_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE upload_id_seq OWNED BY upload.id;


--
-- Name: user; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    employee_id integer NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(128) NOT NULL,
    password character varying(128) NOT NULL
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: vat; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE vat (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    account_id integer NOT NULL,
    service_id integer NOT NULL,
    date date NOT NULL,
    vat numeric(5,2) NOT NULL,
    calc_method smallint NOT NULL,
    descr character varying(255)
);


--
-- Name: vat_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE vat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vat_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE vat_id_seq OWNED BY vat.id;


--
-- Name: visa; Type: TABLE; Schema: test; Owner: -; Tablespace: 
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
-- Name: visa_id_seq; Type: SEQUENCE; Schema: test; Owner: -
--

CREATE SEQUENCE visa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visa_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: -
--

ALTER SEQUENCE visa_id_seq OWNED BY visa.id;


--
-- Name: visa_order_item; Type: TABLE; Schema: test; Owner: -; Tablespace: 
--

CREATE TABLE visa_order_item (
    order_item_id integer NOT NULL,
    visa_id integer NOT NULL
);


SET search_path = company, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY accomodation ALTER COLUMN id SET DEFAULT nextval('accomodation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY account ALTER COLUMN id SET DEFAULT nextval('account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY account_item ALTER COLUMN id SET DEFAULT nextval('account_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY address ALTER COLUMN id SET DEFAULT nextval('address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY advsource ALTER COLUMN id SET DEFAULT nextval('advsource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY appointment ALTER COLUMN id SET DEFAULT nextval('employees_appointments_h_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY bank ALTER COLUMN id SET DEFAULT nextval('bank_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY bank_detail ALTER COLUMN id SET DEFAULT nextval('bank_detail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY bperson ALTER COLUMN id SET DEFAULT nextval('bperson_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY calculation ALTER COLUMN id SET DEFAULT nextval('calculation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY campaign ALTER COLUMN id SET DEFAULT nextval('campaign_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY cashflow ALTER COLUMN id SET DEFAULT nextval('transfer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY commission ALTER COLUMN id SET DEFAULT nextval('commission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY company ALTER COLUMN id SET DEFAULT nextval('company_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY contact ALTER COLUMN id SET DEFAULT nextval('contact_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY contract ALTER COLUMN id SET DEFAULT nextval('licence_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY crosspayment ALTER COLUMN id SET DEFAULT nextval('crosspayment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY currency ALTER COLUMN id SET DEFAULT nextval('currency_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY currency_rate ALTER COLUMN id SET DEFAULT nextval('currency_rate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee ALTER COLUMN id SET DEFAULT nextval('employee_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY foodcat ALTER COLUMN id SET DEFAULT nextval('foodcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY hotel ALTER COLUMN id SET DEFAULT nextval('hotel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY hotelcat ALTER COLUMN id SET DEFAULT nextval('hotelcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY income ALTER COLUMN id SET DEFAULT nextval('income_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY invoice ALTER COLUMN id SET DEFAULT nextval('invoice_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY invoice_item ALTER COLUMN id SET DEFAULT nextval('invoice_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead ALTER COLUMN id SET DEFAULT nextval('lead_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_item ALTER COLUMN id SET DEFAULT nextval('lead_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_offer ALTER COLUMN id SET DEFAULT nextval('lead_offer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY navigation ALTER COLUMN id SET DEFAULT nextval('positions_navigations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY note ALTER COLUMN id SET DEFAULT nextval('note_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY notification ALTER COLUMN id SET DEFAULT nextval('notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY "order" ALTER COLUMN id SET DEFAULT nextval('order_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY order_item ALTER COLUMN id SET DEFAULT nextval('order_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY outgoing ALTER COLUMN id SET DEFAULT nextval('outgoing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY passport ALTER COLUMN id SET DEFAULT nextval('passport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY permision ALTER COLUMN id SET DEFAULT nextval('positions_permisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY person ALTER COLUMN id SET DEFAULT nextval('person_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_category ALTER COLUMN id SET DEFAULT nextval('person_category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY "position" ALTER COLUMN id SET DEFAULT nextval('companies_positions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY region ALTER COLUMN id SET DEFAULT nextval('region_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY resource ALTER COLUMN id SET DEFAULT nextval('resource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY resource_log ALTER COLUMN id SET DEFAULT nextval('resource_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY resource_type ALTER COLUMN id SET DEFAULT nextval('resource_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY roomcat ALTER COLUMN id SET DEFAULT nextval('roomcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY service ALTER COLUMN id SET DEFAULT nextval('service_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY spassport ALTER COLUMN id SET DEFAULT nextval('spassport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY structure ALTER COLUMN id SET DEFAULT nextval('structures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY subaccount ALTER COLUMN id SET DEFAULT nextval('subaccount_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier ALTER COLUMN id SET DEFAULT nextval('touroperator_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier_type ALTER COLUMN id SET DEFAULT nextval('supplier_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY task ALTER COLUMN id SET DEFAULT nextval('task_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY ticket ALTER COLUMN id SET DEFAULT nextval('ticket_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY ticket_class ALTER COLUMN id SET DEFAULT nextval('ticket_class_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour ALTER COLUMN id SET DEFAULT nextval('tour_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY transfer ALTER COLUMN id SET DEFAULT nextval('transfer_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY transport ALTER COLUMN id SET DEFAULT nextval('transport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY uni_list ALTER COLUMN id SET DEFAULT nextval('uni_list_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY upload ALTER COLUMN id SET DEFAULT nextval('upload_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY vat ALTER COLUMN id SET DEFAULT nextval('vat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: company; Owner: -
--

ALTER TABLE ONLY visa ALTER COLUMN id SET DEFAULT nextval('visa_id_seq'::regclass);


SET search_path = demo_ru, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY accomodation ALTER COLUMN id SET DEFAULT nextval('accomodation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY account ALTER COLUMN id SET DEFAULT nextval('account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY account_item ALTER COLUMN id SET DEFAULT nextval('account_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY address ALTER COLUMN id SET DEFAULT nextval('address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY advsource ALTER COLUMN id SET DEFAULT nextval('advsource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY appointment ALTER COLUMN id SET DEFAULT nextval('appointment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bank ALTER COLUMN id SET DEFAULT nextval('bank_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bank_detail ALTER COLUMN id SET DEFAULT nextval('bank_detail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bperson ALTER COLUMN id SET DEFAULT nextval('bperson_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY calculation ALTER COLUMN id SET DEFAULT nextval('calculation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY campaign ALTER COLUMN id SET DEFAULT nextval('campaign_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY cashflow ALTER COLUMN id SET DEFAULT nextval('cashflow_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY commission ALTER COLUMN id SET DEFAULT nextval('commission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY company ALTER COLUMN id SET DEFAULT nextval('company_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY contact ALTER COLUMN id SET DEFAULT nextval('contact_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY contract ALTER COLUMN id SET DEFAULT nextval('contract_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY crosspayment ALTER COLUMN id SET DEFAULT nextval('crosspayment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY currency ALTER COLUMN id SET DEFAULT nextval('currency_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY currency_rate ALTER COLUMN id SET DEFAULT nextval('currency_rate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee ALTER COLUMN id SET DEFAULT nextval('employee_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY foodcat ALTER COLUMN id SET DEFAULT nextval('foodcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY hotel ALTER COLUMN id SET DEFAULT nextval('hotel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY hotelcat ALTER COLUMN id SET DEFAULT nextval('hotelcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY income ALTER COLUMN id SET DEFAULT nextval('income_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY invoice ALTER COLUMN id SET DEFAULT nextval('invoice_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY invoice_item ALTER COLUMN id SET DEFAULT nextval('invoice_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead ALTER COLUMN id SET DEFAULT nextval('lead_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_item ALTER COLUMN id SET DEFAULT nextval('lead_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_offer ALTER COLUMN id SET DEFAULT nextval('lead_offer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY navigation ALTER COLUMN id SET DEFAULT nextval('navigation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY note ALTER COLUMN id SET DEFAULT nextval('note_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY notification ALTER COLUMN id SET DEFAULT nextval('notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "order" ALTER COLUMN id SET DEFAULT nextval('order_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY order_item ALTER COLUMN id SET DEFAULT nextval('order_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY outgoing ALTER COLUMN id SET DEFAULT nextval('outgoing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY passport ALTER COLUMN id SET DEFAULT nextval('passport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY permision ALTER COLUMN id SET DEFAULT nextval('permision_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person ALTER COLUMN id SET DEFAULT nextval('person_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_category ALTER COLUMN id SET DEFAULT nextval('person_category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "position" ALTER COLUMN id SET DEFAULT nextval('position_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY region ALTER COLUMN id SET DEFAULT nextval('region_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY resource ALTER COLUMN id SET DEFAULT nextval('resource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY resource_log ALTER COLUMN id SET DEFAULT nextval('resource_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY resource_type ALTER COLUMN id SET DEFAULT nextval('resource_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY roomcat ALTER COLUMN id SET DEFAULT nextval('roomcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY service ALTER COLUMN id SET DEFAULT nextval('service_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY spassport ALTER COLUMN id SET DEFAULT nextval('spassport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY structure ALTER COLUMN id SET DEFAULT nextval('structure_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY subaccount ALTER COLUMN id SET DEFAULT nextval('subaccount_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier ALTER COLUMN id SET DEFAULT nextval('supplier_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier_type ALTER COLUMN id SET DEFAULT nextval('supplier_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY task ALTER COLUMN id SET DEFAULT nextval('task_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY ticket ALTER COLUMN id SET DEFAULT nextval('ticket_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY ticket_class ALTER COLUMN id SET DEFAULT nextval('ticket_class_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour ALTER COLUMN id SET DEFAULT nextval('tour_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY transfer ALTER COLUMN id SET DEFAULT nextval('transfer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY transport ALTER COLUMN id SET DEFAULT nextval('transport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY upload ALTER COLUMN id SET DEFAULT nextval('upload_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY vat ALTER COLUMN id SET DEFAULT nextval('vat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY visa ALTER COLUMN id SET DEFAULT nextval('visa_id_seq'::regclass);


SET search_path = public, pg_catalog;

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

ALTER TABLE ONLY campaign ALTER COLUMN id SET DEFAULT nextval('campaign_id_seq'::regclass);


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

ALTER TABLE ONLY currency ALTER COLUMN id SET DEFAULT nextval('currency_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency_rate ALTER COLUMN id SET DEFAULT nextval('currency_rate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employee ALTER COLUMN id SET DEFAULT nextval('employee_id_seq'::regclass);


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

ALTER TABLE ONLY person_category ALTER COLUMN id SET DEFAULT nextval('person_category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "position" ALTER COLUMN id SET DEFAULT nextval('companies_positions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY region ALTER COLUMN id SET DEFAULT nextval('region_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource ALTER COLUMN id SET DEFAULT nextval('resource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_log ALTER COLUMN id SET DEFAULT nextval('resource_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_type ALTER COLUMN id SET DEFAULT nextval('resource_type_id_seq'::regclass);


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

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vat ALTER COLUMN id SET DEFAULT nextval('vat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visa ALTER COLUMN id SET DEFAULT nextval('visa_id_seq'::regclass);


SET search_path = test, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY accomodation ALTER COLUMN id SET DEFAULT nextval('accomodation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY account ALTER COLUMN id SET DEFAULT nextval('account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY account_item ALTER COLUMN id SET DEFAULT nextval('account_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY address ALTER COLUMN id SET DEFAULT nextval('address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY advsource ALTER COLUMN id SET DEFAULT nextval('advsource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY appointment ALTER COLUMN id SET DEFAULT nextval('appointment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY bank ALTER COLUMN id SET DEFAULT nextval('bank_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY bank_detail ALTER COLUMN id SET DEFAULT nextval('bank_detail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY bperson ALTER COLUMN id SET DEFAULT nextval('bperson_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY calculation ALTER COLUMN id SET DEFAULT nextval('calculation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY campaign ALTER COLUMN id SET DEFAULT nextval('campaign_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY cashflow ALTER COLUMN id SET DEFAULT nextval('cashflow_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY commission ALTER COLUMN id SET DEFAULT nextval('commission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY company ALTER COLUMN id SET DEFAULT nextval('company_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY contact ALTER COLUMN id SET DEFAULT nextval('contact_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY contract ALTER COLUMN id SET DEFAULT nextval('contract_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY crosspayment ALTER COLUMN id SET DEFAULT nextval('crosspayment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY currency ALTER COLUMN id SET DEFAULT nextval('currency_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY currency_rate ALTER COLUMN id SET DEFAULT nextval('currency_rate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee ALTER COLUMN id SET DEFAULT nextval('employee_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY foodcat ALTER COLUMN id SET DEFAULT nextval('foodcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY hotel ALTER COLUMN id SET DEFAULT nextval('hotel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY hotelcat ALTER COLUMN id SET DEFAULT nextval('hotelcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY income ALTER COLUMN id SET DEFAULT nextval('income_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY invoice ALTER COLUMN id SET DEFAULT nextval('invoice_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY invoice_item ALTER COLUMN id SET DEFAULT nextval('invoice_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead ALTER COLUMN id SET DEFAULT nextval('lead_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_item ALTER COLUMN id SET DEFAULT nextval('lead_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_offer ALTER COLUMN id SET DEFAULT nextval('lead_offer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY navigation ALTER COLUMN id SET DEFAULT nextval('navigation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY note ALTER COLUMN id SET DEFAULT nextval('note_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY notification ALTER COLUMN id SET DEFAULT nextval('notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY "order" ALTER COLUMN id SET DEFAULT nextval('order_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY order_item ALTER COLUMN id SET DEFAULT nextval('order_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY outgoing ALTER COLUMN id SET DEFAULT nextval('outgoing_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY passport ALTER COLUMN id SET DEFAULT nextval('passport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY permision ALTER COLUMN id SET DEFAULT nextval('permision_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY person ALTER COLUMN id SET DEFAULT nextval('person_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_category ALTER COLUMN id SET DEFAULT nextval('person_category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY "position" ALTER COLUMN id SET DEFAULT nextval('position_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY region ALTER COLUMN id SET DEFAULT nextval('region_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY resource ALTER COLUMN id SET DEFAULT nextval('resource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY resource_log ALTER COLUMN id SET DEFAULT nextval('resource_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY resource_type ALTER COLUMN id SET DEFAULT nextval('resource_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY roomcat ALTER COLUMN id SET DEFAULT nextval('roomcat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY service ALTER COLUMN id SET DEFAULT nextval('service_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY spassport ALTER COLUMN id SET DEFAULT nextval('spassport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY structure ALTER COLUMN id SET DEFAULT nextval('structure_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY subaccount ALTER COLUMN id SET DEFAULT nextval('subaccount_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier ALTER COLUMN id SET DEFAULT nextval('supplier_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier_type ALTER COLUMN id SET DEFAULT nextval('supplier_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY task ALTER COLUMN id SET DEFAULT nextval('task_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY ticket ALTER COLUMN id SET DEFAULT nextval('ticket_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY ticket_class ALTER COLUMN id SET DEFAULT nextval('ticket_class_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour ALTER COLUMN id SET DEFAULT nextval('tour_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY transfer ALTER COLUMN id SET DEFAULT nextval('transfer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY transport ALTER COLUMN id SET DEFAULT nextval('transport_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY upload ALTER COLUMN id SET DEFAULT nextval('upload_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY vat ALTER COLUMN id SET DEFAULT nextval('vat_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: test; Owner: -
--

ALTER TABLE ONLY visa ALTER COLUMN id SET DEFAULT nextval('visa_id_seq'::regclass);


SET search_path = company, pg_catalog;

--
-- Data for Name: accomodation; Type: TABLE DATA; Schema: company; Owner: -
--

COPY accomodation (id, resource_id, name) FROM stdin;
\.


--
-- Name: accomodation_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('accomodation_id_seq', 1, true);


--
-- Data for Name: account; Type: TABLE DATA; Schema: company; Owner: -
--

COPY account (id, resource_id, currency_id, account_type, name, display_text, descr, status) FROM stdin;
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('account_id_seq', 1, true);


--
-- Data for Name: account_item; Type: TABLE DATA; Schema: company; Owner: -
--

COPY account_item (id, resource_id, name, parent_id, type, status, descr) FROM stdin;
\.


--
-- Name: account_item_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('account_item_id_seq', 1, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: company; Owner: -
--

COPY address (id, resource_id, location_id, zip_code, address) FROM stdin;
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('address_id_seq', 1, true);


--
-- Data for Name: advsource; Type: TABLE DATA; Schema: company; Owner: -
--

COPY advsource (id, resource_id, name) FROM stdin;
\.


--
-- Name: advsource_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('advsource_id_seq', 1, true);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: company; Owner: -
--

COPY alembic_version (version_num) FROM stdin;
1502d7ef7d40
\.


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: company; Owner: -
--

COPY appointment (id, resource_id, currency_id, employee_id, position_id, salary, date) FROM stdin;
1	789	54	2	4	1000.00	2014-02-02
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: company; Owner: -
--

COPY bank (id, resource_id, name) FROM stdin;
\.


--
-- Data for Name: bank_address; Type: TABLE DATA; Schema: company; Owner: -
--

COPY bank_address (bank_id, address_id) FROM stdin;
\.


--
-- Data for Name: bank_detail; Type: TABLE DATA; Schema: company; Owner: -
--

COPY bank_detail (id, resource_id, currency_id, bank_id, beneficiary, account, swift_code) FROM stdin;
\.


--
-- Name: bank_detail_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('bank_detail_id_seq', 1, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('bank_id_seq', 1, true);


--
-- Data for Name: bperson; Type: TABLE DATA; Schema: company; Owner: -
--

COPY bperson (id, resource_id, first_name, last_name, second_name, position_name, descr, status) FROM stdin;
\.


--
-- Data for Name: bperson_contact; Type: TABLE DATA; Schema: company; Owner: -
--

COPY bperson_contact (bperson_id, contact_id) FROM stdin;
\.


--
-- Name: bperson_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('bperson_id_seq', 1, true);


--
-- Data for Name: calculation; Type: TABLE DATA; Schema: company; Owner: -
--

COPY calculation (id, resource_id, price, order_item_id, contract_id) FROM stdin;
\.


--
-- Name: calculation_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('calculation_id_seq', 1, true);


--
-- Data for Name: campaign; Type: TABLE DATA; Schema: company; Owner: -
--

COPY campaign (id, resource_id, name, subject, plain_content, html_content, start_dt, status) FROM stdin;
\.


--
-- Name: campaign_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('campaign_id_seq', 1, true);


--
-- Data for Name: cashflow; Type: TABLE DATA; Schema: company; Owner: -
--

COPY cashflow (id, subaccount_from_id, subaccount_to_id, account_item_id, sum, date, vat) FROM stdin;
\.


--
-- Data for Name: commission; Type: TABLE DATA; Schema: company; Owner: -
--

COPY commission (id, resource_id, service_id, percentage, price, currency_id, descr) FROM stdin;
\.


--
-- Name: commission_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('commission_id_seq', 1, true);


--
-- Name: companies_counter; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('companies_counter', 1065, true);


--
-- Name: companies_positions_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('companies_positions_id_seq', 8, true);


--
-- Data for Name: company; Type: TABLE DATA; Schema: company; Owner: -
--

COPY company (id, resource_id, name, currency_id, settings, email) FROM stdin;
1	1970	LuxTravel, Inc	56	{"locale": "en", "timezone": "Europe/Kiev"}	lux.travel@gmai.com
\.


--
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('company_id_seq', 1, true);


--
-- Data for Name: company_subaccount; Type: TABLE DATA; Schema: company; Owner: -
--

COPY company_subaccount (company_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: contact; Type: TABLE DATA; Schema: company; Owner: -
--

COPY contact (id, contact, resource_id, contact_type, descr, status) FROM stdin;
\.


--
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('contact_id_seq', 1, true);


--
-- Data for Name: contract; Type: TABLE DATA; Schema: company; Owner: -
--

COPY contract (id, resource_id, date, num, descr, status) FROM stdin;
\.


--
-- Data for Name: contract_commission; Type: TABLE DATA; Schema: company; Owner: -
--

COPY contract_commission (contract_id, commission_id) FROM stdin;
\.


--
-- Data for Name: country; Type: TABLE DATA; Schema: company; Owner: -
--

COPY country (id, resource_id, iso_code, name) FROM stdin;
3	878	UA	Ukraine
4	880	EG	Egypt
5	881	TR	Turkey
6	882	GB	United Kingdom
7	883	US	United States
9	1095	RU	Russian Federation
11	1100	DE	Germany
\.


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('country_id_seq', 11, true);


--
-- Data for Name: crosspayment; Type: TABLE DATA; Schema: company; Owner: -
--

COPY crosspayment (id, resource_id, cashflow_id, descr) FROM stdin;
\.


--
-- Name: crosspayment_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('crosspayment_id_seq', 1, true);


--
-- Data for Name: currency; Type: TABLE DATA; Schema: company; Owner: -
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
-- Name: currency_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('currency_id_seq', 57, true);


--
-- Data for Name: currency_rate; Type: TABLE DATA; Schema: company; Owner: -
--

COPY currency_rate (id, resource_id, date, currency_id, rate, supplier_id) FROM stdin;
\.


--
-- Name: currency_rate_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('currency_rate_id_seq', 1, true);


--
-- Data for Name: employee; Type: TABLE DATA; Schema: company; Owner: -
--

COPY employee (id, resource_id, first_name, last_name, second_name, itn, dismissal_date, photo_upload_id) FROM stdin;
2	784	John	Doe	\N	\N	\N	7
\.


--
-- Data for Name: employee_address; Type: TABLE DATA; Schema: company; Owner: -
--

COPY employee_address (employee_id, address_id) FROM stdin;
\.


--
-- Data for Name: employee_contact; Type: TABLE DATA; Schema: company; Owner: -
--

COPY employee_contact (employee_id, contact_id) FROM stdin;
\.


--
-- Name: employee_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('employee_id_seq', 2, true);


--
-- Data for Name: employee_notification; Type: TABLE DATA; Schema: company; Owner: -
--

COPY employee_notification (employee_id, notification_id, status) FROM stdin;
\.


--
-- Data for Name: employee_passport; Type: TABLE DATA; Schema: company; Owner: -
--

COPY employee_passport (employee_id, passport_id) FROM stdin;
\.


--
-- Data for Name: employee_subaccount; Type: TABLE DATA; Schema: company; Owner: -
--

COPY employee_subaccount (employee_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: employee_upload; Type: TABLE DATA; Schema: company; Owner: -
--

COPY employee_upload (employee_id, upload_id) FROM stdin;
\.


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('employees_appointments_h_id_seq', 12, true);


--
-- Data for Name: foodcat; Type: TABLE DATA; Schema: company; Owner: -
--

COPY foodcat (id, resource_id, name) FROM stdin;
\.


--
-- Name: foodcat_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('foodcat_id_seq', 1, true);


--
-- Data for Name: hotel; Type: TABLE DATA; Schema: company; Owner: -
--

COPY hotel (id, resource_id, hotelcat_id, name, location_id) FROM stdin;
\.


--
-- Name: hotel_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('hotel_id_seq', 1, true);


--
-- Data for Name: hotelcat; Type: TABLE DATA; Schema: company; Owner: -
--

COPY hotelcat (id, resource_id, name) FROM stdin;
\.


--
-- Name: hotelcat_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('hotelcat_id_seq', 1, true);


--
-- Data for Name: income; Type: TABLE DATA; Schema: company; Owner: -
--

COPY income (id, resource_id, invoice_id, account_item_id, date, sum, descr) FROM stdin;
\.


--
-- Data for Name: income_cashflow; Type: TABLE DATA; Schema: company; Owner: -
--

COPY income_cashflow (income_id, cashflow_id) FROM stdin;
\.


--
-- Name: income_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('income_id_seq', 1, true);


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: company; Owner: -
--

COPY invoice (id, date, resource_id, account_id, active_until, order_id, descr) FROM stdin;
\.


--
-- Name: invoice_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('invoice_id_seq', 1, true);


--
-- Data for Name: invoice_item; Type: TABLE DATA; Schema: company; Owner: -
--

COPY invoice_item (id, invoice_id, price, vat, discount, descr, order_item_id) FROM stdin;
\.


--
-- Name: invoice_item_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('invoice_item_id_seq', 1, true);


--
-- Data for Name: lead; Type: TABLE DATA; Schema: company; Owner: -
--

COPY lead (id, lead_date, resource_id, advsource_id, customer_id, status, descr) FROM stdin;
\.


--
-- Name: lead_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('lead_id_seq', 1, true);


--
-- Data for Name: lead_item; Type: TABLE DATA; Schema: company; Owner: -
--

COPY lead_item (id, resource_id, lead_id, service_id, currency_id, price_from, price_to, descr) FROM stdin;
\.


--
-- Name: lead_item_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('lead_item_id_seq', 1, true);


--
-- Data for Name: lead_offer; Type: TABLE DATA; Schema: company; Owner: -
--

COPY lead_offer (id, resource_id, lead_id, service_id, currency_id, supplier_id, price, status, descr) FROM stdin;
\.


--
-- Name: lead_offer_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('lead_offer_id_seq', 1, true);


--
-- Name: licence_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('licence_id_seq', 59, true);


--
-- Data for Name: location; Type: TABLE DATA; Schema: company; Owner: -
--

COPY location (id, resource_id, name, region_id) FROM stdin;
\.


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('location_id_seq', 1, true);


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: company; Owner: -
--

COPY navigation (id, position_id, parent_id, name, url, icon_cls, sort_order, resource_id, separator_before, action) FROM stdin;
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
155	4	53	Payments	/	\N	12	1904	f	\N
157	4	53	Currencies		\N	7	1906	t	\N
42	4	159	Hotels List	/hotels	\N	5	1080	f	\N
43	4	158	Locations	/locations	\N	3	1089	f	\N
50	4	53	Services List	/services	\N	6	1312	f	\N
45	4	53	Banks	/banks	\N	6	1212	f	tab_open
153	4	152	Turnovers	/turnovers	\N	2	1896	f	tab_open
51	4	32	Invoices	/invoices	\N	5	1368	t	tab_open
9	4	8	Resource Types	/resources_types	\N	1	779	f	\N
13	4	10	Employees	/employees	\N	1	790	f	\N
8	4	\N	System	/	fa fa-cog	11	778	f	tab_open
54	4	157	Currencies Rates	/currencies_rates	\N	8	1395	f	\N
55	4	156	Accounts Items	/accounts_items	\N	3	1425	f	\N
56	4	155	Income Payments	/incomes	\N	9	1434	f	\N
57	4	156	Accounts	/accounts	\N	1	1436	f	\N
14	4	10	Employees Appointments	/appointments	\N	2	791	f	\N
174	4	156	Vat Settings	/vats	\N	5	2514	t	tab_open
15	4	8	Users	/users	\N	3	792	f	\N
17	4	157	Currencies List	/currencies	\N	7	802	f	\N
19	4	18	Structures	/structures	\N	1	838	f	\N
20	4	18	Positions	/positions	\N	2	863	f	\N
22	4	21	Persons	/persons	\N	1	866	f	\N
24	4	158	Countries	/countries	\N	4	874	f	\N
25	4	158	Regions	/regions	\N	3	879	f	\N
27	4	26	Advertising Sources	/advsources	\N	1	902	f	\N
28	4	159	Hotels Categories	/hotelcats	\N	6	910	f	\N
29	4	159	Rooms Categories	/roomcats	\N	7	911	f	\N
30	4	159	Accomodations	/accomodations	\N	10	955	f	tab_open
31	4	159	Food Categories	/foodcats	\N	9	956	f	\N
61	4	155	Outgoing Payments	/outgoings	\N	10	1571	f	\N
150	4	156	Subaccounts	/subaccounts	\N	2	1798	f	\N
151	4	155	Cross Payments	/crosspayments	\N	11	1885	f	\N
36	4	23	Business Persons	/bpersons	\N	4	1008	f	tab_open
60	4	23	Suppliers	/suppliers	\N	1	1550	f	tab_open
165	4	8	Company	/companies/edit	\N	4	1975	t	dialog_open
166	4	32	Leads	/leads	\N	2	2048	f	tab_open
168	4	32	Orders	/orders	\N	4	2101	f	tab_open
158	4	23	Geography	/	\N	10	1907	f	\N
159	4	23	Hotels	/	\N	9	1908	t	\N
169	4	23	Transfers	/transfers	\N	5	2128	t	tab_open
170	4	23	Transport	/transports	\N	6	2136	f	tab_open
171	4	23	Suppliers Types	/suppliers_types	\N	3	2219	f	tab_open
172	4	23	Contracts	/contracts	\N	2	2222	f	tab_open
173	4	23	Ticket Class	/tickets_classes	\N	7	2245	f	tab_open
175	4	23	Persons Categories	/persons_categories	\N	8	2552	f	tab_open
236	4	26	Campaigns	/campaigns	\N	3	2741	t	tab_open
\.


--
-- Data for Name: note; Type: TABLE DATA; Schema: company; Owner: -
--

COPY note (id, resource_id, title, descr) FROM stdin;
\.


--
-- Name: note_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('note_id_seq', 1, true);


--
-- Data for Name: note_resource; Type: TABLE DATA; Schema: company; Owner: -
--

COPY note_resource (note_id, resource_id) FROM stdin;
\.


--
-- Data for Name: note_upload; Type: TABLE DATA; Schema: company; Owner: -
--

COPY note_upload (note_id, upload_id) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: company; Owner: -
--

COPY notification (id, resource_id, title, descr, created, url) FROM stdin;
\.


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('notification_id_seq', 1, true);


--
-- Data for Name: notification_resource; Type: TABLE DATA; Schema: company; Owner: -
--

COPY notification_resource (notification_id, resource_id) FROM stdin;
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: company; Owner: -
--

COPY "order" (id, deal_date, resource_id, customer_id, advsource_id, descr, lead_id, status) FROM stdin;
\.


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('order_id_seq', 1, true);


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: company; Owner: -
--

COPY order_item (id, resource_id, order_id, service_id, currency_id, price, status, status_date, status_info, supplier_id, discount_sum, discount_percent) FROM stdin;
\.


--
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('order_item_id_seq', 1, true);


--
-- Data for Name: outgoing; Type: TABLE DATA; Schema: company; Owner: -
--

COPY outgoing (id, resource_id, account_item_id, date, subaccount_id, sum, descr) FROM stdin;
\.


--
-- Data for Name: outgoing_cashflow; Type: TABLE DATA; Schema: company; Owner: -
--

COPY outgoing_cashflow (outgoing_id, cashflow_id) FROM stdin;
\.


--
-- Name: outgoing_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('outgoing_id_seq', 1, true);


--
-- Data for Name: passport; Type: TABLE DATA; Schema: company; Owner: -
--

COPY passport (id, country_id, num, descr, resource_id, end_date, passport_type) FROM stdin;
\.


--
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('passport_id_seq', 1, true);


--
-- Data for Name: passport_upload; Type: TABLE DATA; Schema: company; Owner: -
--

COPY passport_upload (passport_id, upload_id) FROM stdin;
\.


--
-- Data for Name: permision; Type: TABLE DATA; Schema: company; Owner: -
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
294	156	4	{view,add,edit,delete,settings}	\N	all
55	83	4	{view,add,edit,delete}	\N	all
56	84	4	{view,add,edit,delete}	\N	all
58	86	4	{view,add,edit,delete}	\N	all
59	87	4	{view,add,edit,delete}	\N	all
61	89	4	{view,add,edit,delete}	\N	all
62	90	4	{view,add,edit,delete}	\N	all
63	91	4	{view,add,edit,delete}	\N	all
21	1	4	{view}	\N	all
65	93	4	{view,add,edit,delete}	\N	all
70	101	4	{view,add,edit,delete}	\N	all
22	2	4	{view,add,edit,delete}	\N	all
71	102	4	{view,add,edit,delete}	\N	all
73	104	4	{view,add,edit,delete}	\N	all
74	105	4	{view,add,edit,delete}	\N	all
76	107	4	{view,add,edit,delete}	\N	all
79	110	4	{view,add,edit,delete}	\N	all
80	111	4	{view,add,edit,delete}	\N	all
128	117	4	{view,add,edit,delete}	\N	all
129	118	4	{view,add,edit,delete}	\N	all
130	119	4	{autoload,view,edit,delete}	\N	all
131	120	4	{view,add,edit,delete}	\N	all
132	121	4	{view}	\N	all
24	12	4	{view,add,edit,delete,settings}	\N	all
134	123	4	{view,close}	\N	all
137	126	4	{view,edit}	\N	all
158	146	4	{view,add,edit,delete}	\N	all
141	130	4	{view,add,edit,delete,order}	\N	all
157	145	4	{view,add,edit,delete}	\N	all
155	144	4	{view,add,edit,delete}	\N	all
154	143	4	{view,add,edit,delete}	\N	all
153	142	4	{view,add,edit,delete}	\N	all
152	141	4	{view,add,edit,delete}	\N	all
151	140	4	{view,add,edit,delete}	\N	all
150	139	4	{view,add,edit,delete}	\N	all
149	138	4	{view,add,edit,delete}	\N	all
148	137	4	{view,add,edit,delete}	\N	all
146	135	4	{view,add,edit,delete}	\N	all
145	134	4	{view,add,edit,delete,calculation,invoice,contract}	\N	all
75	106	4	{view,add,edit,delete}	\N	all
72	103	4	{view,add,edit,delete,settings}	\N	all
160	148	4	{view,add,edit,delete}	\N	all
161	149	4	{view,add,edit,delete}	\N	all
163	151	4	{view,add,edit,delete}	\N	all
164	152	4	{view,settings}	\N	all
165	153	4	{view,settings}	\N	all
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: company; Owner: -
--

COPY person (id, resource_id, first_name, last_name, second_name, birthday, gender, descr, person_category_id, email_subscription, sms_subscription) FROM stdin;
\.


--
-- Data for Name: person_address; Type: TABLE DATA; Schema: company; Owner: -
--

COPY person_address (person_id, address_id) FROM stdin;
\.


--
-- Data for Name: person_category; Type: TABLE DATA; Schema: company; Owner: -
--

COPY person_category (id, resource_id, name) FROM stdin;
\.


--
-- Name: person_category_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('person_category_id_seq', 1, true);


--
-- Data for Name: person_contact; Type: TABLE DATA; Schema: company; Owner: -
--

COPY person_contact (person_id, contact_id) FROM stdin;
\.


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('person_id_seq', 1, true);


--
-- Data for Name: person_order_item; Type: TABLE DATA; Schema: company; Owner: -
--

COPY person_order_item (order_item_id, person_id) FROM stdin;
\.


--
-- Data for Name: person_passport; Type: TABLE DATA; Schema: company; Owner: -
--

COPY person_passport (person_id, passport_id) FROM stdin;
\.


--
-- Data for Name: person_subaccount; Type: TABLE DATA; Schema: company; Owner: -
--

COPY person_subaccount (person_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: position; Type: TABLE DATA; Schema: company; Owner: -
--

COPY "position" (id, resource_id, structure_id, name) FROM stdin;
4	772	1	Main Developer
\.


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('positions_navigations_id_seq', 236, true);


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('positions_permisions_id_seq', 296, true);


--
-- Data for Name: region; Type: TABLE DATA; Schema: company; Owner: -
--

COPY region (id, resource_id, country_id, name) FROM stdin;
\.


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('region_id_seq', 1, true);


--
-- Data for Name: resource; Type: TABLE DATA; Schema: company; Owner: -
--

COPY resource (id, resource_type_id, structure_id, protected) FROM stdin;
1080	65	1	\N
1081	12	1	\N
863	65	1	\N
875	70	1	\N
885	47	1	\N
1100	70	1	\N
895	39	1	\N
1101	39	1	\N
1268	12	1	f
998	65	1	\N
1284	69	1	f
728	55	1	\N
784	47	1	\N
1306	90	1	f
2788	12	1	f
1312	65	1	f
786	47	1	\N
802	65	1	\N
769	12	1	\N
30	12	1	\N
31	12	1	\N
32	12	1	\N
33	12	1	\N
34	12	1	\N
35	12	1	\N
36	12	1	\N
837	65	1	\N
1336	39	1	f
1165	39	1	\N
1347	39	1	f
1355	39	1	f
1204	87	1	\N
1207	12	1	\N
1218	39	1	\N
1365	39	1	f
1240	41	1	f
1398	104	1	f
1257	87	1	f
1258	87	1	f
1413	102	1	f
849	41	1	\N
851	41	1	\N
852	41	1	\N
1285	87	1	f
864	65	1	\N
876	41	1	\N
1286	89	1	f
896	39	1	\N
897	39	1	\N
772	59	1	\N
788	12	1	\N
706	12	1	\N
771	55	1	\N
838	65	1	\N
734	55	1	\N
898	39	1	\N
899	39	1	\N
900	65	1	\N
901	12	1	\N
902	65	1	\N
1304	87	1	f
1011	12	1	\N
1307	90	1	f
1313	12	1	f
1368	65	1	f
1414	90	1	f
1185	39	1	\N
1198	12	1	\N
1205	89	1	\N
1221	12	1	\N
1227	93	1	\N
1241	39	1	f
1259	87	1	f
1260	87	1	f
853	41	1	\N
865	12	1	\N
866	65	1	\N
789	67	1	\N
1288	90	1	f
887	69	1	\N
1290	39	1	f
773	12	1	\N
1308	90	1	f
1314	102	1	f
1372	69	1	f
1375	69	1	f
1382	90	1	f
1168	41	1	\N
1040	47	1	\N
1041	47	1	\N
1042	47	1	\N
1043	47	1	\N
1044	47	1	\N
1045	47	1	\N
1046	47	1	\N
1388	90	1	f
1391	90	1	f
1067	78	1	\N
1400	104	1	f
1401	104	1	f
1199	89	1	\N
1206	89	1	\N
1209	90	1	\N
1402	104	1	f
726	55	1	\N
1416	39	1	f
1418	90	1	f
1251	55	1	f
1261	89	1	f
854	2	1	\N
855	2	1	\N
1278	39	1	f
878	70	1	\N
1293	69	1	f
893	47	1	\N
894	2	1	\N
908	12	1	\N
909	12	1	\N
910	65	1	\N
911	65	1	\N
743	55	1	\N
790	65	1	\N
1294	69	1	f
763	55	1	\N
723	12	1	\N
791	65	1	\N
775	12	1	\N
37	12	1	\N
38	12	1	\N
39	12	1	\N
40	12	1	\N
43	12	1	\N
10	12	1	\N
792	65	1	\N
12	12	1	\N
14	12	1	\N
44	12	1	\N
16	12	1	\N
45	12	1	\N
1309	90	1	f
2	2	1	\N
3	2	1	\N
84	2	1	\N
83	2	1	\N
940	73	1	\N
941	73	1	\N
942	73	1	\N
943	73	1	\N
944	73	1	\N
945	73	1	\N
946	73	1	\N
947	73	1	\N
948	73	1	\N
949	73	1	\N
950	73	1	\N
1316	102	1	f
952	73	1	\N
939	73	1	\N
938	73	1	\N
937	73	1	\N
936	73	1	\N
935	73	1	\N
1370	90	1	f
933	73	1	\N
932	73	1	\N
931	73	1	\N
930	73	1	\N
929	73	1	\N
928	73	1	\N
927	73	1	\N
926	73	1	\N
925	73	1	\N
924	73	1	\N
923	73	1	\N
922	73	1	\N
921	73	1	\N
1371	87	1	f
919	72	1	\N
918	72	1	\N
917	72	1	\N
916	72	1	\N
915	72	1	\N
914	72	1	\N
913	72	1	\N
912	72	1	\N
1373	87	1	f
1376	89	1	f
1378	78	1	f
1060	41	1	\N
1068	12	1	\N
1390	69	1	f
1403	104	1	f
1170	39	1	\N
1179	39	1	\N
1189	12	1	\N
1190	12	1	\N
1200	89	1	\N
1210	90	1	\N
1225	12	1	\N
1230	93	1	\N
1243	87	1	f
1253	65	1	f
1263	87	1	f
856	2	1	\N
870	69	1	\N
1088	12	1	\N
879	65	1	\N
1089	65	1	\N
953	12	1	\N
954	12	1	\N
764	12	1	\N
955	65	1	\N
956	65	1	\N
957	74	1	\N
958	74	1	\N
959	74	1	\N
960	74	1	\N
961	74	1	\N
962	74	1	\N
963	74	1	\N
964	74	1	\N
965	74	1	\N
966	74	1	\N
967	74	1	\N
968	74	1	\N
969	74	1	\N
970	74	1	\N
971	74	1	\N
1310	41	1	f
973	75	1	\N
1317	12	1	f
975	75	1	\N
976	75	1	\N
977	75	1	\N
978	75	1	\N
274	12	1	\N
283	12	1	\N
1318	102	1	f
778	65	1	\N
779	65	1	\N
780	65	1	\N
286	41	1	\N
287	41	1	\N
288	41	1	\N
289	41	1	\N
290	41	1	\N
291	41	1	\N
292	41	1	\N
306	41	1	\N
277	39	1	\N
279	39	1	\N
280	39	1	\N
281	39	1	\N
278	39	1	\N
282	39	1	\N
979	75	1	\N
980	75	1	\N
981	75	1	\N
982	75	1	\N
983	75	1	\N
984	75	1	\N
985	75	1	\N
987	75	1	\N
988	75	1	\N
1003	12	1	\N
1004	78	1	\N
1005	78	1	\N
1328	39	1	f
1374	90	1	f
1191	86	1	\N
1201	87	1	\N
1211	12	1	\N
1212	65	1	\N
1213	90	1	\N
1380	87	1	f
1383	69	1	f
1244	87	1	f
1264	87	1	f
1387	87	1	f
1393	12	1	f
1394	65	1	f
1404	87	1	f
1406	89	1	f
1409	69	1	f
857	55	1	\N
859	55	1	\N
860	55	1	\N
861	55	1	\N
794	55	1	\N
800	55	1	\N
801	55	1	\N
1090	39	1	\N
2586	87	1	f
2587	87	1	f
2588	89	1	f
2589	89	1	f
2590	90	1	f
2591	69	1	f
871	69	1	\N
880	70	1	\N
881	70	1	\N
882	70	1	\N
883	70	1	\N
1007	12	1	\N
1008	65	1	\N
1311	41	1	f
1078	12	1	\N
1332	39	1	f
1192	86	1	\N
1379	87	1	f
1381	89	1	f
1265	89	1	f
1384	39	1	f
1389	69	1	f
1395	65	1	f
1407	90	1	f
1411	69	1	f
872	12	1	\N
873	65	1	\N
874	65	1	\N
725	55	1	\N
1282	87	1	f
1095	70	1	\N
1096	39	1	\N
1079	65	1	\N
1099	39	1	\N
1340	39	1	f
1344	39	1	f
1159	78	1	\N
1193	87	1	\N
1194	87	1	\N
1195	87	1	\N
1352	39	1	f
1396	104	1	f
1408	69	1	f
1410	69	1	f
1424	12	1	f
1425	65	1	f
1426	105	1	f
1431	105	1	f
1432	105	1	f
1433	12	1	f
1434	65	1	f
1435	12	1	f
1436	65	1	f
1440	103	1	f
1442	103	1	f
1447	106	1	f
1448	106	1	f
1450	12	1	f
1452	12	1	f
1464	87	1	f
1465	69	1	f
1467	89	1	f
1469	90	1	f
1471	69	1	f
1472	69	1	f
1473	69	1	f
1485	106	1	f
1487	103	1	f
1500	106	1	f
1502	103	1	f
1503	103	1	f
1504	104	1	f
1505	104	1	f
1506	104	1	f
1509	106	1	f
1516	87	1	f
1517	87	1	f
1518	87	1	f
1519	87	1	f
1521	12	1	f
1535	110	1	f
1536	110	1	f
1537	110	1	f
1538	110	1	f
1539	110	1	f
1540	110	1	f
1541	110	1	f
1543	87	1	f
1544	87	1	f
1545	87	1	f
1546	106	1	f
1547	106	1	f
1548	12	1	f
1549	12	1	f
1550	65	1	f
1551	87	1	f
1552	87	1	f
1559	87	1	f
1561	87	1	f
1562	87	1	f
1571	65	1	f
1575	65	1	f
1576	86	1	f
1577	87	1	f
1579	110	1	f
1580	78	1	f
1581	87	1	f
1582	89	1	f
1584	89	1	f
1585	90	1	f
1586	69	1	f
1587	39	1	f
1591	87	1	f
1592	89	1	f
1593	69	1	f
1597	104	1	f
1598	103	1	f
1607	106	1	f
1608	105	1	f
1609	105	1	f
1610	87	1	f
1611	87	1	f
1612	89	1	f
1613	89	1	f
1614	90	1	f
1615	69	1	f
1616	69	1	f
1619	69	1	f
1620	87	1	f
1621	87	1	f
1622	89	1	f
1623	90	1	f
1624	87	1	f
1625	89	1	f
1626	69	1	f
1627	69	1	f
1628	69	1	f
1634	103	1	f
1639	106	1	f
1640	87	1	f
1641	87	1	f
1642	89	1	f
1643	89	1	f
1644	90	1	f
1645	69	1	f
1647	39	1	f
1650	87	1	f
1651	89	1	f
1652	90	1	f
1653	69	1	f
1657	103	1	f
1659	65	1	f
1660	106	1	f
1714	110	1	f
1721	110	1	f
1764	111	1	f
1766	111	1	f
1769	105	1	f
1771	111	1	f
1773	111	1	f
1774	111	1	f
1777	65	1	f
1780	105	1	f
1797	12	1	f
1798	65	1	f
1799	12	1	f
1807	90	1	f
1839	103	1	f
1840	103	1	f
1849	12	1	f
1852	119	1	f
1853	119	1	f
1854	119	1	f
1855	119	1	f
1859	119	1	f
1860	119	1	f
1866	117	1	f
1869	69	1	f
1870	78	1	f
1873	105	1	f
1876	106	1	f
1880	106	1	f
1882	106	1	f
1884	12	1	f
1885	65	1	f
1888	117	1	f
1893	120	1	f
1894	12	1	f
1895	65	1	f
1896	65	1	f
1898	105	1	f
1900	120	1	f
1901	120	1	f
1902	117	1	f
1903	111	1	f
1904	65	1	f
1905	65	1	f
1906	65	1	f
1907	65	1	f
1908	65	1	f
1910	106	1	f
1913	117	1	f
1915	111	1	f
1917	110	1	f
1918	119	1	f
1919	12	1	f
1922	93	1	f
1925	89	1	f
1926	90	1	f
1927	87	1	f
1941	12	1	f
1945	123	1	f
1946	123	1	f
1947	123	1	f
1948	123	1	f
1949	123	1	f
1950	123	1	f
1951	90	1	f
1952	86	1	f
1954	12	1	f
1956	87	1	f
1959	123	1	f
1961	123	1	f
1963	123	1	f
1965	123	1	f
1966	12	1	f
1968	12	1	f
1970	126	1	f
1972	123	1	f
1973	123	1	f
1975	65	1	f
1977	12	1	f
1978	2	1	f
1984	123	1	f
1986	123	1	f
1987	103	1	f
1988	119	1	f
1989	12	1	f
1990	106	1	f
1992	106	1	f
1993	106	1	f
1994	106	1	f
1995	106	1	f
1996	106	1	f
2000	103	1	f
2001	106	1	f
2005	103	1	f
2006	106	1	f
2010	123	1	f
2011	110	1	f
2013	87	1	f
2014	89	1	f
2015	90	1	f
2017	69	1	f
2018	87	1	f
2019	89	1	f
2020	69	1	f
2023	104	1	f
2024	104	1	f
2026	103	1	f
2027	106	1	f
2029	119	1	f
2030	119	1	f
2031	119	1	f
2032	110	1	f
2038	119	1	f
2039	119	1	f
2044	119	1	f
2045	119	1	f
2046	119	1	f
2047	119	1	f
2048	65	1	f
2049	12	1	f
2050	87	1	f
2051	69	1	f
2053	47	1	f
2054	2	1	f
2055	12	1	f
2064	123	1	f
2067	123	1	f
2069	123	1	f
2070	12	1	f
2076	123	1	f
2077	12	1	f
2089	87	1	f
2090	69	1	f
2095	87	1	f
2099	12	1	f
2100	12	1	f
2101	65	1	f
2104	135	1	f
2105	135	1	f
2106	135	1	f
2107	12	1	f
2108	12	1	f
2115	39	1	f
2119	90	1	f
2126	2	1	f
2127	12	1	f
2128	65	1	f
2129	138	1	f
2130	138	1	f
2133	123	1	f
2135	12	1	f
2136	65	1	f
2137	139	1	f
2138	139	1	f
2139	139	1	f
2144	135	1	f
2145	137	1	f
2146	135	1	f
2147	137	1	f
2148	135	1	f
2149	137	1	f
2150	135	1	f
2151	137	1	f
2152	135	1	f
2153	137	1	f
2154	135	1	f
2155	137	1	f
2156	135	1	f
2157	137	1	f
2158	135	1	f
2159	137	1	f
2160	135	1	f
2161	137	1	f
2162	135	1	f
2163	137	1	f
2164	135	1	f
2165	137	1	f
2167	135	1	f
2168	137	1	f
2172	135	1	f
2173	137	1	f
2174	135	1	f
2175	137	1	f
2176	135	1	f
2177	137	1	f
2178	135	1	f
2179	137	1	f
2180	135	1	f
2181	137	1	f
2182	135	1	f
2183	137	1	f
2184	135	1	f
2185	137	1	f
2186	134	1	f
2187	135	1	f
2188	137	1	f
2189	135	1	f
2190	137	1	f
2198	123	1	f
2199	105	1	f
2200	104	1	f
2201	104	1	f
2203	104	1	f
2205	110	1	f
2206	110	1	f
2207	110	1	f
2208	110	1	f
2209	110	1	f
2210	86	1	f
2211	110	1	f
2212	110	1	f
2213	86	1	f
2214	110	1	f
2215	86	1	f
2217	12	1	f
2219	65	1	f
2222	65	1	f
2243	12	1	f
2244	12	1	f
2245	65	1	f
2246	105	1	f
2247	102	1	f
2248	141	1	f
2249	141	1	f
2254	135	1	f
2255	142	1	f
2256	135	1	f
2257	142	1	f
2258	135	1	f
2259	142	1	f
2260	135	1	f
2261	142	1	f
2262	135	1	f
2263	142	1	f
2265	135	1	f
2266	137	1	f
2268	12	1	f
2269	105	1	f
2273	135	1	f
2274	143	1	f
2276	12	1	f
2277	105	1	f
2278	135	1	f
2279	144	1	f
2282	135	1	f
2283	137	1	f
2285	135	1	f
2286	137	1	f
2287	135	1	f
2288	142	1	f
2292	12	1	f
2293	145	1	f
2294	145	1	f
2295	145	1	f
2296	12	1	f
2297	145	1	f
2299	146	1	f
2300	145	1	f
2301	146	1	f
2304	123	1	f
2305	145	1	f
2306	146	1	f
2307	87	1	f
2308	87	1	f
2309	69	1	f
2310	145	1	f
2313	145	1	f
2314	69	1	f
2315	135	1	f
2316	137	1	f
2320	12	1	f
2327	87	1	f
2328	69	1	f
2329	145	1	f
2330	145	1	f
2331	146	1	f
2332	146	1	f
2338	87	1	f
2339	69	1	f
2340	69	1	f
2341	135	1	f
2342	137	1	f
2343	135	1	f
2344	143	1	f
2366	87	1	f
2367	69	1	f
2368	145	1	f
2369	146	1	f
2373	39	1	f
2376	69	1	f
2377	135	1	f
2378	137	1	f
2379	135	1	f
2380	143	1	f
2389	105	1	f
2390	105	1	f
2391	105	1	f
2392	105	1	f
2393	105	1	f
2394	105	1	f
2395	105	1	f
2396	105	1	f
2397	105	1	f
2398	105	1	f
2399	105	1	f
2400	105	1	f
2401	105	1	f
2402	105	1	f
2403	105	1	f
2404	105	1	f
2405	105	1	f
2406	105	1	f
2407	105	1	f
2408	105	1	f
2409	105	1	f
2410	105	1	f
2411	105	1	f
2412	105	1	f
2413	105	1	f
2414	105	1	f
2415	105	1	f
2416	105	1	f
2417	105	1	f
2418	105	1	f
2419	105	1	f
2420	105	1	f
2421	105	1	f
2422	105	1	f
2423	105	1	f
2424	105	1	f
2425	105	1	f
2426	105	1	f
2427	105	1	f
2428	105	1	f
2429	105	1	f
2430	105	1	f
2431	105	1	f
2432	105	1	f
2433	145	1	f
2435	146	1	f
2437	146	1	f
2465	120	1	f
2468	119	1	f
2469	119	1	f
2470	119	1	f
2475	90	1	f
2477	47	1	f
2484	2	1	f
2489	86	1	f
2490	86	1	f
2491	86	1	f
2493	87	1	f
2501	110	1	f
2502	110	1	f
2503	119	1	f
2505	110	1	f
2506	86	1	f
2507	110	1	f
2508	110	1	f
2510	110	1	f
2511	86	1	f
2513	12	1	f
2514	65	1	f
2516	12	1	f
2517	149	1	f
2518	149	1	f
2519	47	1	f
2520	149	1	f
2521	149	1	f
2522	149	1	f
2523	149	1	f
2524	149	1	f
2525	149	1	f
2526	149	1	f
2527	149	1	f
2528	149	1	f
2529	119	1	f
2530	119	1	f
2531	119	1	f
2532	119	1	f
2533	119	1	f
2534	119	1	f
2535	119	1	f
2536	110	1	f
2537	119	1	f
2538	119	1	f
2539	110	1	f
2540	86	1	f
2541	119	1	f
2545	86	1	f
2546	110	1	f
2547	119	1	f
2548	119	1	f
2549	12	1	f
2550	87	1	f
2551	12	1	f
2552	65	1	f
2553	65	1	f
2554	65	1	f
2556	151	1	f
2557	151	1	f
2558	12	1	f
2559	151	1	f
2560	69	1	f
2561	145	1	f
2563	69	1	f
2564	145	1	f
2566	69	1	f
2567	145	1	f
2568	145	1	f
2570	69	1	f
2571	145	1	f
2573	69	1	f
2574	145	1	f
2576	69	1	f
2577	145	1	f
2578	145	1	f
2580	69	1	f
2581	145	1	f
2583	12	1	f
2585	87	1	f
2592	123	1	f
2593	69	1	f
2594	87	1	f
2595	69	1	f
2596	145	1	f
2597	145	1	f
2598	145	1	f
2602	65	1	f
2603	65	1	f
2604	65	1	f
2605	65	1	f
2608	65	1	f
2612	65	1	f
2613	65	1	f
2617	65	1	f
2631	65	1	f
2632	65	1	f
2633	65	1	f
2634	65	1	f
2635	65	1	f
2636	65	1	f
2637	65	1	f
2638	65	1	f
2642	65	1	f
2643	65	1	f
2646	65	1	f
2647	65	1	f
2648	65	1	f
2649	65	1	f
2650	65	1	f
2651	65	1	f
2652	65	1	f
2653	65	1	f
2654	65	1	f
2655	65	1	f
2665	149	1	f
2666	87	1	f
2667	69	1	f
2668	145	1	f
2670	146	1	f
2672	123	1	f
2673	39	1	f
2676	87	1	f
2677	89	1	f
2678	69	1	f
2679	69	1	f
2680	89	1	f
2681	89	1	f
2682	149	1	f
2683	89	1	f
2684	149	1	f
2685	89	1	f
2686	135	1	f
2687	137	1	f
2688	135	1	f
2689	143	1	f
2693	110	1	f
2694	110	1	f
2695	86	1	f
2698	110	1	f
2699	86	1	f
2700	119	1	f
2701	119	1	f
2702	119	1	f
2703	119	1	f
2704	119	1	f
2705	119	1	f
2706	119	1	f
2707	119	1	f
2708	119	1	f
2709	119	1	f
2710	119	1	f
2711	119	1	f
2712	119	1	f
2713	119	1	f
2715	119	1	f
2716	119	1	f
2717	119	1	f
2718	119	1	f
2719	119	1	f
2720	119	1	f
2721	119	1	f
2722	119	1	f
2724	119	1	f
2725	119	1	f
2726	110	1	f
2727	119	1	f
2728	119	1	f
2729	103	1	f
2731	123	1	f
2734	119	1	f
2735	119	1	f
2736	119	1	f
2739	69	1	f
2740	12	1	f
2741	65	1	f
2742	12	1	f
2779	123	1	f
2780	123	1	f
2781	123	1	f
2785	47	1	f
2786	2	1	f
2787	2	1	f
2790	12	1	f
\.


--
-- Name: resource_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('resource_id_seq', 2790, true);


--
-- Data for Name: resource_log; Type: TABLE DATA; Schema: company; Owner: -
--

COPY resource_log (id, resource_id, employee_id, comment, modifydt) FROM stdin;
7672	725	2	\N	2015-10-25 18:29:36.485331+02
7673	772	2	\N	2015-10-25 18:29:48.734406+02
7674	2742	2	\N	2015-10-25 21:14:37.429267+02
7675	2740	2	\N	2015-10-25 21:14:41.037197+02
7676	2583	2	\N	2015-10-25 21:14:44.152213+02
7677	2558	2	\N	2015-10-25 21:14:47.468287+02
7678	2551	2	\N	2015-10-25 21:14:50.661752+02
7679	2516	2	\N	2015-10-25 21:14:54.043974+02
7680	2513	2	\N	2015-10-25 21:14:57.515749+02
7681	2296	2	\N	2015-10-25 21:15:00.801576+02
7682	2292	2	\N	2015-10-25 21:15:04.579697+02
7683	2276	2	\N	2015-10-25 21:15:07.859876+02
7684	2268	2	\N	2015-10-25 21:15:11.41355+02
7685	2244	2	\N	2015-10-25 21:15:15.08087+02
7686	2243	2	\N	2015-10-25 21:15:18.415374+02
7687	2217	2	\N	2015-10-25 21:15:22.580956+02
7688	2135	2	\N	2015-10-25 21:15:26.822285+02
7689	2127	2	\N	2015-10-25 21:15:30.469938+02
7690	2108	2	\N	2015-10-25 21:15:35.148375+02
7691	2100	2	\N	2015-10-25 21:15:38.483633+02
7692	2099	2	\N	2015-10-25 21:15:43.982787+02
7693	2049	2	\N	2015-10-25 21:15:49.162966+02
7694	1968	2	\N	2015-10-25 21:15:53.440626+02
7695	1941	2	\N	2015-10-25 21:15:57.551908+02
7696	1884	2	\N	2015-10-25 21:16:01.935865+02
7697	1894	2	\N	2015-10-25 21:16:05.350861+02
7698	1849	2	\N	2015-10-25 21:16:08.565296+02
7699	1799	2	\N	2015-10-25 21:16:11.898419+02
7700	1797	2	\N	2015-10-25 21:16:17.305403+02
7701	1548	2	\N	2015-10-25 21:16:20.933341+02
7702	1521	2	\N	2015-10-25 21:16:24.346478+02
7703	1435	2	\N	2015-10-25 21:16:28.278231+02
7704	1433	2	\N	2015-10-25 21:16:32.204893+02
7705	1424	2	\N	2015-10-25 21:16:37.127758+02
7706	1393	2	\N	2015-10-25 21:16:40.502794+02
7707	1317	2	\N	2015-10-25 21:16:43.978797+02
7708	1313	2	\N	2015-10-25 21:16:48.394405+02
7709	1268	2	\N	2015-10-25 21:16:52.253586+02
7710	1225	2	\N	2015-10-25 21:16:55.883212+02
7711	1211	2	\N	2015-10-25 21:17:02.365419+02
7712	1207	2	\N	2015-10-25 21:17:11.228895+02
7713	1198	2	\N	2015-10-25 21:17:14.605706+02
7714	1190	2	\N	2015-10-25 21:17:17.962226+02
7715	1189	2	\N	2015-10-25 21:17:22.169824+02
7716	1088	2	\N	2015-10-25 21:17:27.123342+02
7717	1081	2	\N	2015-10-25 21:17:30.484303+02
7718	1007	2	\N	2015-10-25 21:17:33.84324+02
7719	1003	2	\N	2015-10-25 21:17:37.28513+02
7720	954	2	\N	2015-10-25 21:17:41.191895+02
7721	953	2	\N	2015-10-25 21:17:45.458502+02
7722	909	2	\N	2015-10-25 21:17:49.385186+02
7723	908	2	\N	2015-10-25 21:17:53.112889+02
7724	901	2	\N	2015-10-25 21:17:58.692045+02
7725	872	2	\N	2015-10-25 21:18:02.214698+02
7726	865	2	\N	2015-10-25 21:18:05.09372+02
7727	788	2	\N	2015-10-25 21:18:08.146867+02
7728	775	2	\N	2015-10-25 21:18:11.413701+02
7729	769	2	\N	2015-10-25 21:18:14.703555+02
7730	764	2	\N	2015-10-25 21:18:17.786192+02
7731	723	2	\N	2015-10-25 21:18:21.267664+02
7732	706	2	\N	2015-10-25 21:18:24.219742+02
7733	283	2	\N	2015-10-25 21:18:27.627488+02
7734	274	2	\N	2015-10-25 21:18:30.883104+02
7735	16	2	\N	2015-10-25 21:18:33.921184+02
7736	10	2	\N	2015-10-25 21:18:37.163922+02
7737	773	2	\N	2015-10-25 21:18:49.306767+02
7738	3	2	\N	2015-10-25 21:19:10.539731+02
7739	784	2	\N	2015-10-25 21:19:27.565925+02
7740	789	2	\N	2015-10-25 21:19:38.951573+02
7741	772	2	\N	2015-10-25 21:19:53.535469+02
7742	1100	2	\N	2015-10-25 21:20:18.256979+02
7743	1095	2	\N	2015-10-25 21:20:21.415245+02
7744	883	2	\N	2015-10-25 21:20:24.411401+02
7745	882	2	\N	2015-10-25 21:20:27.610602+02
7746	881	2	\N	2015-10-25 21:20:30.548418+02
7747	880	2	\N	2015-10-25 21:20:34.03857+02
7748	878	2	\N	2015-10-25 21:20:36.956871+02
7749	2788	2	\N	2015-11-15 11:41:32.753196+02
7750	2741	2	\N	2015-11-15 11:42:42.182101+02
7752	2790	2	\N	2015-11-22 22:04:31.745001+02
\.


--
-- Name: resource_log_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('resource_log_id_seq', 7752, true);


--
-- Data for Name: resource_type; Type: TABLE DATA; Schema: company; Owner: -
--

COPY resource_type (id, resource_id, name, humanize, resource_name, module, descr, settings, status) FROM stdin;
145	2292	leads_items	Leads Items	LeadsItemsResource	travelcrm.resources.leads_items	Leads Items	null	0
103	1317	invoices	Invoices	InvoicesResource	travelcrm.resources.invoices	Invoices list. Invoice can't be created manualy - only using source document such as Tours	{"active_days": 3}	0
87	1190	contacts	Contacts	ContactsResource	travelcrm.resources.contacts	Contacts for persons, business persons etc.	\N	0
148	2513	vats	Vat	VatsResource	travelcrm.resources.vats	Vat for accounts and services	null	0
2	10	users	Users	UsersResource	travelcrm.resources.users	Users list	\N	0
149	2516	uploads	Uploads	UploadsResource	travelcrm.resources.uploads	Uploads for any type of resources	null	0
151	2551	persons_categories	Persons Categories	PersonsCategoriesResource	travelcrm.resources.persons_categories	Categorise your clients with categories of persons	null	0
12	16	resources_types	Resources Types	ResourcesTypesResource	travelcrm.resources.resources_types	Resources types list	\N	0
39	274	regions	Regions	RegionsResource	travelcrm.resources.regions		\N	0
41	283	currencies	Currencies	CurrenciesResource	travelcrm.resources.currencies		\N	0
47	706	employees	Employees	EmployeesResource	travelcrm.resources.employees	Employees Container Datagrid	\N	0
55	723	structures	Structures	StructuresResource	travelcrm.resources.structures	Companies structures is a tree of company structure. It's can be offices, filials, departments and so and so	\N	0
59	764	positions	Positions	PositionsResource	travelcrm.resources.positions	Companies positions is a point of company structure where emplyees can be appointed	\N	0
61	769	permisions	Permisions	PermisionsResource	travelcrm.resources.permisions	Permisions list of company structure position. It's list of resources and permisions	\N	0
65	775	navigations	Navigations	NavigationsResource	travelcrm.resources.navigations	Navigations list of company structure position.	\N	0
67	788	appointments	Appointments	AppointmentsResource	travelcrm.resources.appointments	Employees to positions of company appointments	\N	0
69	865	persons	Persons	PersonsResource	travelcrm.resources.persons	Persons directory. Person can be client or potential client	\N	0
70	872	countries	Countries	CountriesResource	travelcrm.resources.countries	Countries directory	\N	0
71	901	advsources	Advertises Sources	AdvsourcesResource	travelcrm.resources.advsources	Types of advertises	\N	0
72	908	hotelcats	Hotels Categories	HotelcatsResource	travelcrm.resources.hotelcats	Hotels categories	\N	0
73	909	roomcats	Rooms Categories	RoomcatsResource	travelcrm.resources.roomcats	Categories of the rooms	\N	0
75	954	foodcats	Foods Categories	FoodcatsResource	travelcrm.resources.foodcats	Food types in hotels	\N	0
78	1003	suppliers	Suppliers	SuppliersResource	travelcrm.resources.suppliers	Suppliers, such as touroperators, aircompanies, IATA etc.	\N	0
79	1007	bpersons	Business Persons	BPersonsResource	travelcrm.resources.bpersons	Business Persons is not clients it's simple business contacts that can be referenced objects that needs to have contacts	\N	0
83	1081	hotels	Hotels	HotelsResource	travelcrm.resources.hotels	Hotels directory	\N	0
84	1088	locations	Locations	LocationsResource	travelcrm.resources.locations	Locations list is list of cities, vilages etc. places to use to identify part of region	\N	0
86	1189	contracts	Contracts	ContractsResource	travelcrm.resources.contracts	Licences list for any type of resources as need	\N	0
89	1198	passports	Passports	PassportsResource	travelcrm.resources.passports	Clients persons passports lists	\N	0
90	1207	addresses	Addresses	AddressesResource	travelcrm.resources.addresses	Addresses of any type of resources, such as persons, bpersons, hotels etc.	\N	0
91	1211	banks	Banks	BanksResource	travelcrm.resources.banks	Banks list to create bank details and for other reasons	\N	0
93	1225	tasks	Tasks	TasksResource	travelcrm.resources.tasks	Task manager	\N	0
101	1268	banks_details	Banks Details	BanksDetailsResource	travelcrm.resources.banks_details	Banks Details that can be attached to any client or business partner to define account	\N	0
102	1313	services	Services	ServicesResource	travelcrm.resources.services	Additional Services that can be provide with tours sales or separate	\N	0
104	1393	currencies_rates	Currency Rates	CurrenciesRatesResource	travelcrm.resources.currencies_rates	Currencies Rates. Values from this dir used by billing to calc prices in base currency.	\N	0
105	1424	accounts_items	Accounts Items	AccountsItemsResource	travelcrm.resources.accounts_items	Finance accounts items	\N	0
106	1433	incomes	Incomes	IncomesResource	travelcrm.resources.incomes	Incomes Payments Document for invoices	{"account_item_id": 8}	0
107	1435	accounts	Accounts	AccountsResource	travelcrm.resources.accounts	Billing Accounts. It can be bank accouts, cash accounts etc. and has company wide visible	null	0
117	1797	subaccounts	Subaccounts	SubaccountsResource	travelcrm.resources.subaccounts	Subaccounts are accounts from other objects such as clients, touroperators and so on	null	0
118	1799	notes	Notes	NotesResource	travelcrm.resources.notes	Resources Notes	null	0
119	1849	calculations	Caluclations	CalculationsResource	travelcrm.resources.calculations	Calculations of Sale Documents	null	0
121	1894	turnovers	Turnovers	TurnoversResource	travelcrm.resources.turnovers	Turnovers on Accounts and Subaccounts	null	0
126	1968	companies	Companies	CompaniesResource	travelcrm.resources.companies	Multicompanies functionality	null	0
130	2049	leads	Leads	LeadsResource	travelcrm.resources.leads	Leads that can be converted into contacts	null	0
134	2099	orders	Orders	OrdersResource	travelcrm.resources.orders	Orders	null	0
135	2100	orders_items	Orders Items	OrdersItemsResource	travelcrm.resources.orders_items	Orders Items	null	0
137	2108	tours	Tours	ToursResource	travelcrm.resources.tours	Tour Service	null	0
74	953	accomodations	Accomodations	AccomodationsResource	travelcrm.resources.accomodations	Accomodations Types list	\N	0
110	1521	commissions	Commissions	CommissionsResource	travelcrm.resources.commissions	Services sales commissions	null	0
111	1548	outgoings	Outgoings	OutgoingsResource	travelcrm.resources.outgoings	Outgoings payments for touroperators, suppliers, payback payments and so on	null	0
1	773	 	Home	Root	travelcrm.resources	Home Page of Travelcrm	\N	0
146	2296	leads_offers	Leads Offers	LeadsOffersResource	travelcrm.resources.leads_offers	Leads Offers	null	0
152	2558	leads_stats	Leads Stats	LeadsStatsResource	travelcrm.resources.leads_stats	Portlet with leads statistics	{"column_index": 0}	0
120	1884	crosspayments	Cross Payments	CrosspaymentsResource	travelcrm.resources.crosspayments	Cross payments between accounts and subaccounts. This document is for balance corrections to.	null	0
153	2583	activities	Activities	ActivitiesResource	travelcrm.resources.activities	My last activities	{"column_index": 1}	0
123	1941	notifications	Notifications	NotificationsResource	travelcrm.resources.notifications	Employee Notifications	null	0
138	2127	transfers	Transfers	TransfersResource	travelcrm.resources.transfers	Transfers for tours	null	0
139	2135	transports	Transports	TransportsResource	travelcrm.resources.transports	Transports Types List	null	0
140	2217	suppliers_types	Suppliers Types	SuppliersTypesResource	travelcrm.resources.suppliers_types	Suppliers Types list	null	0
141	2243	tickets_classes	Tickets Classes	TicketsClassesResource	travelcrm.resources.tickets_classes	Tickets Classes list, such as first class, business class etc	null	0
142	2244	tickets	Tickets	TicketsResource	travelcrm.resources.tickets	Ticket is a service for sale tickets of any type	null	0
143	2268	visas	Visas	VisasResource	travelcrm.resources.visas	Visa is a service for sale visas	null	0
144	2276	spassports	Passports Services	SpassportsResource	travelcrm.resources.spassports	Service formulation of foreign passports	null	0
156	2788	campaigns	Campaigns	CampaignsResource	travelcrm.resources.campaigns	Marketings campaigns	{"username": "--", "host": "--", "password": "--", "port": "2525", "default_sender": "--"}	0
\.


--
-- Name: resource_type_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('resource_type_id_seq', 158, true);


--
-- Data for Name: roomcat; Type: TABLE DATA; Schema: company; Owner: -
--

COPY roomcat (id, resource_id, name) FROM stdin;
\.


--
-- Name: roomcat_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('roomcat_id_seq', 1, true);


--
-- Data for Name: service; Type: TABLE DATA; Schema: company; Owner: -
--

COPY service (id, resource_id, name, descr, display_text, resource_type_id) FROM stdin;
7	2247	Ticket	\N	Ticket booking service	142
5	1413	Tour	Use this service for tour sales	Tour booking service	137
4	1318	A visa	\N	The issues for visas	143
1	1314	Foreign Passport Service	\N	Formulation of foreign passport	144
\.


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('service_id_seq', 7, true);


--
-- Data for Name: spassport; Type: TABLE DATA; Schema: company; Owner: -
--

COPY spassport (id, resource_id, photo_done, docs_receive_date, docs_transfer_date, passport_receive_date, descr) FROM stdin;
\.


--
-- Name: spassport_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('spassport_id_seq', 1, true);


--
-- Data for Name: spassport_order_item; Type: TABLE DATA; Schema: company; Owner: -
--

COPY spassport_order_item (order_item_id, spassport_id) FROM stdin;
\.


--
-- Data for Name: structure; Type: TABLE DATA; Schema: company; Owner: -
--

COPY structure (id, resource_id, parent_id, name, company_id) FROM stdin;
1	725	\N	Head Office	1
\.


--
-- Data for Name: structure_address; Type: TABLE DATA; Schema: company; Owner: -
--

COPY structure_address (structure_id, address_id) FROM stdin;
\.


--
-- Data for Name: structure_bank_detail; Type: TABLE DATA; Schema: company; Owner: -
--

COPY structure_bank_detail (structure_id, bank_detail_id) FROM stdin;
\.


--
-- Data for Name: structure_contact; Type: TABLE DATA; Schema: company; Owner: -
--

COPY structure_contact (structure_id, contact_id) FROM stdin;
\.


--
-- Name: structures_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('structures_id_seq', 2, false);


--
-- Data for Name: subaccount; Type: TABLE DATA; Schema: company; Owner: -
--

COPY subaccount (id, resource_id, account_id, name, descr, status) FROM stdin;
\.


--
-- Name: subaccount_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('subaccount_id_seq', 1, true);


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: company; Owner: -
--

COPY supplier (id, resource_id, name, status, descr, supplier_type_id) FROM stdin;
\.


--
-- Data for Name: supplier_bank_detail; Type: TABLE DATA; Schema: company; Owner: -
--

COPY supplier_bank_detail (supplier_id, bank_detail_id) FROM stdin;
\.


--
-- Data for Name: supplier_bperson; Type: TABLE DATA; Schema: company; Owner: -
--

COPY supplier_bperson (supplier_id, bperson_id) FROM stdin;
\.


--
-- Data for Name: supplier_contract; Type: TABLE DATA; Schema: company; Owner: -
--

COPY supplier_contract (supplier_id, contract_id) FROM stdin;
\.


--
-- Data for Name: supplier_subaccount; Type: TABLE DATA; Schema: company; Owner: -
--

COPY supplier_subaccount (supplier_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: supplier_type; Type: TABLE DATA; Schema: company; Owner: -
--

COPY supplier_type (id, resource_id, name, descr) FROM stdin;
\.


--
-- Name: supplier_type_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('supplier_type_id_seq', 1, true);


--
-- Data for Name: task; Type: TABLE DATA; Schema: company; Owner: -
--

COPY task (id, resource_id, employee_id, title, deadline, descr, status, reminder) FROM stdin;
\.


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('task_id_seq', 1, true);


--
-- Data for Name: task_resource; Type: TABLE DATA; Schema: company; Owner: -
--

COPY task_resource (task_id, resource_id) FROM stdin;
\.


--
-- Data for Name: task_upload; Type: TABLE DATA; Schema: company; Owner: -
--

COPY task_upload (task_id, upload_id) FROM stdin;
\.


--
-- Data for Name: ticket; Type: TABLE DATA; Schema: company; Owner: -
--

COPY ticket (id, resource_id, start_location_id, end_location_id, ticket_class_id, transport_id, start_dt, start_additional_info, end_dt, end_additional_info, adults, children, descr) FROM stdin;
\.


--
-- Data for Name: ticket_class; Type: TABLE DATA; Schema: company; Owner: -
--

COPY ticket_class (id, resource_id, name) FROM stdin;
\.


--
-- Name: ticket_class_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('ticket_class_id_seq', 1, true);


--
-- Name: ticket_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('ticket_id_seq', 1, true);


--
-- Data for Name: ticket_order_item; Type: TABLE DATA; Schema: company; Owner: -
--

COPY ticket_order_item (order_item_id, ticket_id) FROM stdin;
\.


--
-- Data for Name: tour; Type: TABLE DATA; Schema: company; Owner: -
--

COPY tour (id, resource_id, start_location_id, end_location_id, hotel_id, accomodation_id, foodcat_id, roomcat_id, adults, children, start_date, end_date, descr, end_transport_id, start_transport_id, transfer_id, end_additional_info, start_additional_info) FROM stdin;
\.


--
-- Name: tour_id_seq1; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('tour_id_seq1', 28, true);


--
-- Data for Name: tour_order_item; Type: TABLE DATA; Schema: company; Owner: -
--

COPY tour_order_item (order_item_id, tour_id) FROM stdin;
\.


--
-- Name: touroperator_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('touroperator_id_seq', 102, true);


--
-- Data for Name: transfer; Type: TABLE DATA; Schema: company; Owner: -
--

COPY transfer (id, resource_id, name) FROM stdin;
\.


--
-- Name: transfer_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('transfer_id_seq', 1, true);


--
-- Name: transfer_id_seq1; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('transfer_id_seq1', 3, true);


--
-- Data for Name: transport; Type: TABLE DATA; Schema: company; Owner: -
--

COPY transport (id, resource_id, name) FROM stdin;
\.


--
-- Name: transport_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('transport_id_seq', 1, true);


--
-- Data for Name: uni_list; Type: TABLE DATA; Schema: company; Owner: -
--

COPY uni_list (id, resource_id, name) FROM stdin;
\.


--
-- Name: uni_list_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('uni_list_id_seq', 1, false);


--
-- Data for Name: upload; Type: TABLE DATA; Schema: company; Owner: -
--

COPY upload (id, path, size, media_type, descr, name, resource_id) FROM stdin;
7	2015627/8c985058-a198-42df-97d2-f55996a1a9b3.jpg	0.00	image/jpeg	\N	Che-Guevara-9322774-1-402.jpg	2519
\.


--
-- Name: upload_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('upload_id_seq', 7, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: company; Owner: -
--

COPY "user" (id, resource_id, username, email, password, employee_id) FROM stdin;
2	3	admin	admin@mail.ru	adminadmin	2
\.


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('user_id_seq', 2, true);


--
-- Data for Name: vat; Type: TABLE DATA; Schema: company; Owner: -
--

COPY vat (id, resource_id, service_id, date, vat, calc_method, descr, account_id) FROM stdin;
\.


--
-- Name: vat_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('vat_id_seq', 1, true);


--
-- Data for Name: visa; Type: TABLE DATA; Schema: company; Owner: -
--

COPY visa (id, resource_id, country_id, start_date, end_date, type, descr) FROM stdin;
\.


--
-- Name: visa_id_seq; Type: SEQUENCE SET; Schema: company; Owner: -
--

SELECT pg_catalog.setval('visa_id_seq', 1, true);


--
-- Data for Name: visa_order_item; Type: TABLE DATA; Schema: company; Owner: -
--

COPY visa_order_item (order_item_id, visa_id) FROM stdin;
\.


SET search_path = demo_ru, pg_catalog;

--
-- Data for Name: accomodation; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY accomodation (id, resource_id, name) FROM stdin;
\.


--
-- Name: accomodation_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('accomodation_id_seq', 1, true);


--
-- Data for Name: account; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY account (id, resource_id, currency_id, account_type, name, display_text, status, descr) FROM stdin;
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('account_id_seq', 1, true);


--
-- Data for Name: account_item; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY account_item (id, resource_id, parent_id, name, type, status, descr) FROM stdin;
\.


--
-- Name: account_item_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('account_item_id_seq', 1, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY address (id, resource_id, location_id, zip_code, address) FROM stdin;
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('address_id_seq', 1, true);


--
-- Data for Name: advsource; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY advsource (id, resource_id, name) FROM stdin;
\.


--
-- Name: advsource_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('advsource_id_seq', 1, true);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY alembic_version (version_num) FROM stdin;
1502d7ef7d40
\.


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY appointment (id, resource_id, date, employee_id, position_id, salary, currency_id) FROM stdin;
1	789	2014-02-02	2	4	4000.00	54
\.


--
-- Name: appointment_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('appointment_id_seq', 1, true);


--
-- Data for Name: bank; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY bank (id, resource_id, name) FROM stdin;
\.


--
-- Data for Name: bank_address; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY bank_address (bank_id, address_id) FROM stdin;
\.


--
-- Data for Name: bank_detail; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY bank_detail (id, resource_id, currency_id, bank_id, beneficiary, account, swift_code) FROM stdin;
\.


--
-- Name: bank_detail_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('bank_detail_id_seq', 1, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('bank_id_seq', 1, true);


--
-- Data for Name: bperson; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY bperson (id, resource_id, first_name, last_name, second_name, position_name, status, descr) FROM stdin;
\.


--
-- Data for Name: bperson_contact; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY bperson_contact (bperson_id, contact_id) FROM stdin;
\.


--
-- Name: bperson_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('bperson_id_seq', 1, true);


--
-- Data for Name: calculation; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY calculation (id, resource_id, order_item_id, price, contract_id) FROM stdin;
\.


--
-- Name: calculation_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('calculation_id_seq', 1, true);


--
-- Data for Name: campaign; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY campaign (id, resource_id, name, subject, plain_content, html_content, start_dt, status) FROM stdin;
\.


--
-- Name: campaign_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('campaign_id_seq', 1, true);


--
-- Data for Name: cashflow; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY cashflow (id, subaccount_from_id, subaccount_to_id, account_item_id, sum, vat, date) FROM stdin;
\.


--
-- Name: cashflow_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('cashflow_id_seq', 1, true);


--
-- Data for Name: commission; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY commission (id, resource_id, service_id, percentage, price, currency_id, descr) FROM stdin;
\.


--
-- Name: commission_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('commission_id_seq', 1, true);


--
-- Data for Name: company; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY company (id, resource_id, currency_id, name, email, settings) FROM stdin;
1	1970	56	Туристическая компания	email@email.com	{"locale": "ru", "timezone": "Africa/Abidjan"}
\.


--
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('company_id_seq', 1, true);


--
-- Data for Name: company_subaccount; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY company_subaccount (company_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: contact; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY contact (id, resource_id, contact_type, contact, status, descr) FROM stdin;
\.


--
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('contact_id_seq', 1, true);


--
-- Data for Name: contract; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY contract (id, resource_id, num, date, status, descr) FROM stdin;
\.


--
-- Data for Name: contract_commission; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY contract_commission (contract_id, commission_id) FROM stdin;
\.


--
-- Name: contract_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('contract_id_seq', 1, true);


--
-- Data for Name: country; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY country (id, resource_id, iso_code, name) FROM stdin;
3	878	UA	Ukraine
4	880	EG	Egypt
5	881	TR	Turkey
6	882	GB	United Kingdom
7	883	US	United States
9	1095	RU	Russian Federation
11	1100	DE	Germany
\.


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('country_id_seq', 11, true);


--
-- Data for Name: crosspayment; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY crosspayment (id, resource_id, cashflow_id, descr) FROM stdin;
\.


--
-- Name: crosspayment_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('crosspayment_id_seq', 1, true);


--
-- Data for Name: currency; Type: TABLE DATA; Schema: demo_ru; Owner: -
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
-- Name: currency_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('currency_id_seq', 57, true);


--
-- Data for Name: currency_rate; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY currency_rate (id, resource_id, currency_id, supplier_id, date, rate) FROM stdin;
\.


--
-- Name: currency_rate_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('currency_rate_id_seq', 1, true);


--
-- Data for Name: employee; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY employee (id, resource_id, photo_upload_id, first_name, last_name, second_name, itn, dismissal_date) FROM stdin;
2	784	7	Василий	Пупкин	\N	\N	\N
\.


--
-- Data for Name: employee_address; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY employee_address (employee_id, address_id) FROM stdin;
\.


--
-- Data for Name: employee_contact; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY employee_contact (employee_id, contact_id) FROM stdin;
\.


--
-- Name: employee_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('employee_id_seq', 2, true);


--
-- Data for Name: employee_notification; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY employee_notification (employee_id, notification_id, status) FROM stdin;
\.


--
-- Data for Name: employee_passport; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY employee_passport (employee_id, passport_id) FROM stdin;
\.


--
-- Data for Name: employee_subaccount; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY employee_subaccount (employee_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: employee_upload; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY employee_upload (employee_id, upload_id) FROM stdin;
\.


--
-- Data for Name: foodcat; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY foodcat (id, resource_id, name) FROM stdin;
\.


--
-- Name: foodcat_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('foodcat_id_seq', 1, true);


--
-- Data for Name: hotel; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY hotel (id, resource_id, hotelcat_id, location_id, name) FROM stdin;
\.


--
-- Name: hotel_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('hotel_id_seq', 1, true);


--
-- Data for Name: hotelcat; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY hotelcat (id, resource_id, name) FROM stdin;
\.


--
-- Name: hotelcat_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('hotelcat_id_seq', 1, true);


--
-- Data for Name: income; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY income (id, resource_id, invoice_id, account_item_id, sum, date, descr) FROM stdin;
\.


--
-- Data for Name: income_cashflow; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY income_cashflow (income_id, cashflow_id) FROM stdin;
\.


--
-- Name: income_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('income_id_seq', 1, true);


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY invoice (id, date, active_until, resource_id, order_id, account_id, descr) FROM stdin;
\.


--
-- Name: invoice_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('invoice_id_seq', 1, true);


--
-- Data for Name: invoice_item; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY invoice_item (id, invoice_id, order_item_id, price, vat, discount, descr) FROM stdin;
\.


--
-- Name: invoice_item_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('invoice_item_id_seq', 1, true);


--
-- Data for Name: lead; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY lead (id, lead_date, resource_id, advsource_id, customer_id, status, descr) FROM stdin;
\.


--
-- Name: lead_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('lead_id_seq', 1, true);


--
-- Data for Name: lead_item; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY lead_item (id, resource_id, lead_id, service_id, currency_id, price_from, price_to, descr) FROM stdin;
\.


--
-- Name: lead_item_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('lead_item_id_seq', 1, true);


--
-- Data for Name: lead_offer; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY lead_offer (id, resource_id, lead_id, service_id, currency_id, supplier_id, price, status, descr) FROM stdin;
\.


--
-- Name: lead_offer_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('lead_offer_id_seq', 1, true);


--
-- Data for Name: location; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY location (id, resource_id, region_id, name) FROM stdin;
\.


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('location_id_seq', 1, true);


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY navigation (id, resource_id, position_id, parent_id, name, url, action, icon_cls, separator_before, sort_order) FROM stdin;
57	1436	4	156	Счета	/accounts	tab_open	\N	f	1
107	1777	4	\N	Домашняя	/	\N	fa fa-home	f	1
150	1798	4	156	Субсчета	/subaccounts	tab_open	\N	f	2
21	864	4	\N	Клиенты	/	tab -open	fa fa-briefcase	f	3
55	1425	4	156	Статьи учета	/accounts_items	tab_open	\N	f	3
174	2514	4	156	Настройки НДС	/vats	tab_open	\N	t	5
8	778	4	\N	Система	/	tab_open	fa fa-cog	f	11
166	2048	4	32	Лиды	/leads	tab_open	\N	f	2
168	2101	4	32	Заявки	/orders	tab_open	\N	f	4
51	1368	4	32	Инвойсы	/invoices	tab_open	\N	t	5
236	2741	4	26	Кампании	/campaigns	tab_open	\N	t	3
45	1212	4	53	Банки	/banks	tab_open	\N	f	6
153	1896	4	152	Обороты	/turnovers	tab_open	\N	f	2
165	1975	4	8	Настройки компании	/companies/edit	dialog_open	\N	t	4
60	1550	4	23	Поставщики	/suppliers	tab_open	\N	f	1
172	2222	4	23	Договора	/contracts	tab_open	\N	f	2
171	2219	4	23	Типы поставщиков	/suppliers_types	tab_open	\N	f	3
36	1008	4	23	Бизнес контакты	/bpersons	tab_open	\N	f	4
169	2128	4	23	Типы трансферов	/transfers	tab_open	\N	t	5
170	2136	4	23	Транспорт	/transports	tab_open	\N	f	6
173	2245	4	23	Класс билетов	/tickets_classes	tab_open	\N	f	7
175	2552	4	23	Категория клиентов	/persons_categories	tab_open	\N	f	8
30	955	4	159	Тип размещения	/accomodations	tab_open	\N	f	10
19	838	4	18	Структура	/structures	\N	\N	f	1
28	910	4	159	Категории отелей	/hotelcats	tab_open	\N	f	6
32	998	4	\N	Продажи	/	tab_open	fa fa-legal	f	2
26	900	4	\N	Маркетинг	/	tab_open	fa fa-bullhorn	f	4
18	837	4	\N	Компания	/	tab_open	fa fa-building-o	f	6
23	873	4	\N	Справочники	/	tab_open	fa fa-book	f	8
152	1895	4	\N	Отчеты	/	tab_open	fa fa-pie-chart	f	9
22	866	4	21	Физ. лица	/persons	tab_open	\N	f	1
27	902	4	26	Источники рекламы	/advsources	tab_open	\N	f	1
13	790	4	10	Сотрудники	/employees	tab_open	\N	f	1
14	791	4	10	Назначения сотрудников	/appointments	tab_open	\N	f	2
20	863	4	18	Должности	/positions	tab_open	\N	f	2
50	1312	4	53	Сервисы	/services	tab_open	\N	f	6
157	1906	4	53	Валюты		tab_open	\N	t	7
17	802	4	157	Список валют	/currencies	tab_open	\N	f	7
54	1395	4	157	Курсы валют	/currencies_rates	tab_open	\N	f	8
56	1434	4	155	Входящие платежи	/incomes	tab_open	\N	f	9
156	1905	4	53	Биллинг	/	tab_open	\N	f	10
155	1904	4	53	Платежи	/	tab_open	\N	f	12
61	1571	4	155	Исходящие платежи	/outgoings	tab_open	\N	f	10
151	1885	4	155	Кросс платежи	/crosspayments	tab_open	\N	f	11
9	779	4	8	Типы ресурсов	/resources_types	tab_open	\N	f	1
15	792	4	8	Пользователи	/users	tab_open	\N	f	3
53	1394	4	\N	Финансы	/	tab_open	fa fa-credit-card	f	7
10	780	4	\N	HR	/	tab_open	fa fa-group	f	5
159	1908	4	23	Отели	/	tab_open	\N	t	9
158	1907	4	23	География	/	tab_open	\N	f	10
42	1080	4	159	Справочник отелей	/hotels	tab_open	\N	f	5
29	911	4	159	Категории номеров	/roomcats	tab_open	\N	f	7
31	956	4	159	Категории питания	/foodcats	tab_open	\N	f	9
25	879	4	158	Регионы	/regions	tab_open	\N	f	3
43	1089	4	158	Населенные пункты	/locations	tab_open	\N	f	3
24	874	4	158	Страны	/countries	tab_open	\N	f	4
\.


--
-- Name: navigation_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('navigation_id_seq', 236, true);


--
-- Data for Name: note; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY note (id, resource_id, title, descr) FROM stdin;
\.


--
-- Name: note_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('note_id_seq', 1, true);


--
-- Data for Name: note_resource; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY note_resource (note_id, resource_id) FROM stdin;
\.


--
-- Data for Name: note_upload; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY note_upload (note_id, upload_id) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY notification (id, resource_id, title, descr, url, created) FROM stdin;
\.


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('notification_id_seq', 1, true);


--
-- Data for Name: notification_resource; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY notification_resource (notification_id, resource_id) FROM stdin;
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY "order" (id, deal_date, resource_id, customer_id, lead_id, advsource_id, status, descr) FROM stdin;
\.


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('order_id_seq', 1, true);


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY order_item (id, resource_id, order_id, service_id, currency_id, supplier_id, price, discount_sum, discount_percent, status, status_date, status_info) FROM stdin;
\.


--
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('order_item_id_seq', 1, true);


--
-- Data for Name: outgoing; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY outgoing (id, date, resource_id, account_item_id, subaccount_id, sum, descr) FROM stdin;
\.


--
-- Data for Name: outgoing_cashflow; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY outgoing_cashflow (outgoing_id, cashflow_id) FROM stdin;
\.


--
-- Name: outgoing_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('outgoing_id_seq', 1, true);


--
-- Data for Name: passport; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY passport (id, resource_id, country_id, passport_type, num, end_date, descr) FROM stdin;
\.


--
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('passport_id_seq', 1, true);


--
-- Data for Name: passport_upload; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY passport_upload (passport_id, upload_id) FROM stdin;
\.


--
-- Data for Name: permision; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY permision (id, resource_type_id, position_id, permisions, scope_type, structure_id) FROM stdin;
35	65	4	{view,add,edit,delete}	all	\N
34	61	4	{view,add,edit,delete}	all	\N
32	59	4	{view,add,edit,delete}	all	\N
30	55	4	{view,add,edit,delete}	all	\N
38	41	4	{view,add,edit,delete}	all	\N
37	67	4	{view,add,edit,delete}	all	\N
39	69	4	{view,add,edit,delete}	all	\N
40	39	4	{view,add,edit,delete}	all	\N
41	70	4	{view,add,edit,delete}	all	\N
42	71	4	{view,add,edit,delete}	all	\N
43	72	4	{view,add,edit,delete}	all	\N
44	73	4	{view,add,edit,delete}	all	\N
45	74	4	{view,add,edit,delete}	all	\N
46	75	4	{view,add,edit,delete}	all	\N
48	78	4	{view,add,edit,delete}	all	\N
49	79	4	{view,add,edit,delete}	all	\N
26	47	4	{view,add,edit,delete}	all	\N
294	156	4	{view,add,edit,delete,settings}	all	\N
55	83	4	{view,add,edit,delete}	all	\N
56	84	4	{view,add,edit,delete}	all	\N
58	86	4	{view,add,edit,delete}	all	\N
59	87	4	{view,add,edit,delete}	all	\N
61	89	4	{view,add,edit,delete}	all	\N
62	90	4	{view,add,edit,delete}	all	\N
63	91	4	{view,add,edit,delete}	all	\N
21	1	4	{view}	all	\N
65	93	4	{view,add,edit,delete}	all	\N
70	101	4	{view,add,edit,delete}	all	\N
22	2	4	{view,add,edit,delete}	all	\N
71	102	4	{view,add,edit,delete}	all	\N
73	104	4	{view,add,edit,delete}	all	\N
74	105	4	{view,add,edit,delete}	all	\N
76	107	4	{view,add,edit,delete}	all	\N
79	110	4	{view,add,edit,delete}	all	\N
80	111	4	{view,add,edit,delete}	all	\N
128	117	4	{view,add,edit,delete}	all	\N
129	118	4	{view,add,edit,delete}	all	\N
130	119	4	{autoload,view,edit,delete}	all	\N
131	120	4	{view,add,edit,delete}	all	\N
132	121	4	{view}	all	\N
24	12	4	{view,add,edit,delete,settings}	all	\N
134	123	4	{view,close}	all	\N
137	126	4	{view,edit}	all	\N
158	146	4	{view,add,edit,delete}	all	\N
141	130	4	{view,add,edit,delete,order}	all	\N
157	145	4	{view,add,edit,delete}	all	\N
155	144	4	{view,add,edit,delete}	all	\N
154	143	4	{view,add,edit,delete}	all	\N
153	142	4	{view,add,edit,delete}	all	\N
152	141	4	{view,add,edit,delete}	all	\N
151	140	4	{view,add,edit,delete}	all	\N
150	139	4	{view,add,edit,delete}	all	\N
149	138	4	{view,add,edit,delete}	all	\N
148	137	4	{view,add,edit,delete}	all	\N
146	135	4	{view,add,edit,delete}	all	\N
145	134	4	{view,add,edit,delete,calculation,invoice,contract}	all	\N
75	106	4	{view,add,edit,delete}	all	\N
72	103	4	{view,add,edit,delete,settings}	all	\N
160	148	4	{view,add,edit,delete}	all	\N
161	149	4	{view,add,edit,delete}	all	\N
163	151	4	{view,add,edit,delete}	all	\N
164	152	4	{view,settings}	all	\N
165	153	4	{view,settings}	all	\N
\.


--
-- Name: permision_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('permision_id_seq', 295, true);


--
-- Data for Name: person; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY person (id, resource_id, person_category_id, first_name, last_name, second_name, birthday, gender, email_subscription, sms_subscription, descr) FROM stdin;
\.


--
-- Data for Name: person_address; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY person_address (person_id, address_id) FROM stdin;
\.


--
-- Data for Name: person_category; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY person_category (id, resource_id, name) FROM stdin;
\.


--
-- Name: person_category_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('person_category_id_seq', 1, true);


--
-- Data for Name: person_contact; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY person_contact (person_id, contact_id) FROM stdin;
\.


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('person_id_seq', 1, true);


--
-- Data for Name: person_order_item; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY person_order_item (order_item_id, person_id) FROM stdin;
\.


--
-- Data for Name: person_passport; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY person_passport (person_id, passport_id) FROM stdin;
\.


--
-- Data for Name: person_subaccount; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY person_subaccount (person_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: position; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY "position" (id, resource_id, structure_id, name) FROM stdin;
4	772	1	Главный разработчик
\.


--
-- Name: position_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('position_id_seq', 4, true);


--
-- Data for Name: region; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY region (id, resource_id, country_id, name) FROM stdin;
\.


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('region_id_seq', 1, true);


--
-- Data for Name: resource; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY resource (id, resource_type_id, structure_id, protected) FROM stdin;
1080	65	1	\N
1081	12	1	\N
863	65	1	\N
875	70	1	\N
885	47	1	\N
1100	70	1	\N
895	39	1	\N
1101	39	1	\N
1268	12	1	f
998	65	1	\N
1284	69	1	f
728	55	1	\N
784	47	1	\N
1306	90	1	f
2788	12	1	f
1312	65	1	f
786	47	1	\N
802	65	1	\N
769	12	1	\N
30	12	1	\N
31	12	1	\N
32	12	1	\N
33	12	1	\N
34	12	1	\N
35	12	1	\N
36	12	1	\N
837	65	1	\N
1336	39	1	f
1165	39	1	\N
1347	39	1	f
1355	39	1	f
1204	87	1	\N
1207	12	1	\N
1218	39	1	\N
1365	39	1	f
1240	41	1	f
1398	104	1	f
1257	87	1	f
1258	87	1	f
1413	102	1	f
849	41	1	\N
851	41	1	\N
852	41	1	\N
1285	87	1	f
864	65	1	\N
876	41	1	\N
1286	89	1	f
896	39	1	\N
897	39	1	\N
772	59	1	\N
788	12	1	\N
706	12	1	\N
771	55	1	\N
838	65	1	\N
734	55	1	\N
898	39	1	\N
899	39	1	\N
900	65	1	\N
901	12	1	\N
902	65	1	\N
1304	87	1	f
1011	12	1	\N
1307	90	1	f
1313	12	1	f
1368	65	1	f
1414	90	1	f
1185	39	1	\N
1198	12	1	\N
1205	89	1	\N
1221	12	1	\N
1227	93	1	\N
1241	39	1	f
1259	87	1	f
1260	87	1	f
853	41	1	\N
865	12	1	\N
866	65	1	\N
789	67	1	\N
1288	90	1	f
887	69	1	\N
1290	39	1	f
773	12	1	\N
1308	90	1	f
1314	102	1	f
1372	69	1	f
1375	69	1	f
1382	90	1	f
1168	41	1	\N
1040	47	1	\N
1041	47	1	\N
1042	47	1	\N
1043	47	1	\N
1044	47	1	\N
1045	47	1	\N
1046	47	1	\N
1388	90	1	f
1391	90	1	f
1067	78	1	\N
1400	104	1	f
1401	104	1	f
1199	89	1	\N
1206	89	1	\N
1209	90	1	\N
1402	104	1	f
726	55	1	\N
1416	39	1	f
1418	90	1	f
1251	55	1	f
1261	89	1	f
854	2	1	\N
855	2	1	\N
1278	39	1	f
878	70	1	\N
1293	69	1	f
893	47	1	\N
894	2	1	\N
908	12	1	\N
909	12	1	\N
910	65	1	\N
911	65	1	\N
743	55	1	\N
790	65	1	\N
1294	69	1	f
763	55	1	\N
723	12	1	\N
791	65	1	\N
775	12	1	\N
37	12	1	\N
38	12	1	\N
39	12	1	\N
40	12	1	\N
43	12	1	\N
10	12	1	\N
792	65	1	\N
12	12	1	\N
14	12	1	\N
44	12	1	\N
16	12	1	\N
45	12	1	\N
1309	90	1	f
2	2	1	\N
3	2	1	\N
84	2	1	\N
83	2	1	\N
940	73	1	\N
941	73	1	\N
942	73	1	\N
943	73	1	\N
944	73	1	\N
945	73	1	\N
946	73	1	\N
947	73	1	\N
948	73	1	\N
949	73	1	\N
950	73	1	\N
1316	102	1	f
952	73	1	\N
939	73	1	\N
938	73	1	\N
937	73	1	\N
936	73	1	\N
935	73	1	\N
1370	90	1	f
933	73	1	\N
932	73	1	\N
931	73	1	\N
930	73	1	\N
929	73	1	\N
928	73	1	\N
927	73	1	\N
926	73	1	\N
925	73	1	\N
924	73	1	\N
923	73	1	\N
922	73	1	\N
921	73	1	\N
1371	87	1	f
919	72	1	\N
918	72	1	\N
917	72	1	\N
916	72	1	\N
915	72	1	\N
914	72	1	\N
913	72	1	\N
912	72	1	\N
1373	87	1	f
1376	89	1	f
1378	78	1	f
1060	41	1	\N
1068	12	1	\N
1390	69	1	f
1403	104	1	f
1170	39	1	\N
1179	39	1	\N
1189	12	1	\N
1190	12	1	\N
1200	89	1	\N
1210	90	1	\N
1225	12	1	\N
1230	93	1	\N
1243	87	1	f
1253	65	1	f
1263	87	1	f
856	2	1	\N
870	69	1	\N
1088	12	1	\N
879	65	1	\N
1089	65	1	\N
953	12	1	\N
954	12	1	\N
764	12	1	\N
955	65	1	\N
956	65	1	\N
957	74	1	\N
958	74	1	\N
959	74	1	\N
960	74	1	\N
961	74	1	\N
962	74	1	\N
963	74	1	\N
964	74	1	\N
965	74	1	\N
966	74	1	\N
967	74	1	\N
968	74	1	\N
969	74	1	\N
970	74	1	\N
971	74	1	\N
1310	41	1	f
973	75	1	\N
1317	12	1	f
975	75	1	\N
976	75	1	\N
977	75	1	\N
978	75	1	\N
274	12	1	\N
283	12	1	\N
1318	102	1	f
778	65	1	\N
779	65	1	\N
780	65	1	\N
286	41	1	\N
287	41	1	\N
288	41	1	\N
289	41	1	\N
290	41	1	\N
291	41	1	\N
292	41	1	\N
306	41	1	\N
277	39	1	\N
279	39	1	\N
280	39	1	\N
281	39	1	\N
278	39	1	\N
282	39	1	\N
979	75	1	\N
980	75	1	\N
981	75	1	\N
982	75	1	\N
983	75	1	\N
984	75	1	\N
985	75	1	\N
987	75	1	\N
988	75	1	\N
1003	12	1	\N
1004	78	1	\N
1005	78	1	\N
1328	39	1	f
1374	90	1	f
1191	86	1	\N
1201	87	1	\N
1211	12	1	\N
1212	65	1	\N
1213	90	1	\N
1380	87	1	f
1383	69	1	f
1244	87	1	f
1264	87	1	f
1387	87	1	f
1393	12	1	f
1394	65	1	f
1404	87	1	f
1406	89	1	f
1409	69	1	f
857	55	1	\N
859	55	1	\N
860	55	1	\N
861	55	1	\N
794	55	1	\N
800	55	1	\N
801	55	1	\N
1090	39	1	\N
2586	87	1	f
2587	87	1	f
2588	89	1	f
2589	89	1	f
2590	90	1	f
2591	69	1	f
871	69	1	\N
880	70	1	\N
881	70	1	\N
882	70	1	\N
883	70	1	\N
1007	12	1	\N
1008	65	1	\N
1311	41	1	f
1078	12	1	\N
1332	39	1	f
1192	86	1	\N
1379	87	1	f
1381	89	1	f
1265	89	1	f
1384	39	1	f
1389	69	1	f
1395	65	1	f
1407	90	1	f
1411	69	1	f
872	12	1	\N
873	65	1	\N
874	65	1	\N
725	55	1	\N
1282	87	1	f
1095	70	1	\N
1096	39	1	\N
1079	65	1	\N
1099	39	1	\N
1340	39	1	f
1344	39	1	f
1159	78	1	\N
1193	87	1	\N
1194	87	1	\N
1195	87	1	\N
1352	39	1	f
1396	104	1	f
1408	69	1	f
1410	69	1	f
1424	12	1	f
1425	65	1	f
1426	105	1	f
1431	105	1	f
1432	105	1	f
1433	12	1	f
1434	65	1	f
1435	12	1	f
1436	65	1	f
1440	103	1	f
1442	103	1	f
1447	106	1	f
1448	106	1	f
1450	12	1	f
1452	12	1	f
1464	87	1	f
1465	69	1	f
1467	89	1	f
1469	90	1	f
1471	69	1	f
1472	69	1	f
1473	69	1	f
1485	106	1	f
1487	103	1	f
1500	106	1	f
1502	103	1	f
1503	103	1	f
1504	104	1	f
1505	104	1	f
1506	104	1	f
1509	106	1	f
1516	87	1	f
1517	87	1	f
1518	87	1	f
1519	87	1	f
1521	12	1	f
1535	110	1	f
1536	110	1	f
1537	110	1	f
1538	110	1	f
1539	110	1	f
1540	110	1	f
1541	110	1	f
1543	87	1	f
1544	87	1	f
1545	87	1	f
1546	106	1	f
1547	106	1	f
1548	12	1	f
1549	12	1	f
1550	65	1	f
1551	87	1	f
1552	87	1	f
1559	87	1	f
1561	87	1	f
1562	87	1	f
1571	65	1	f
1575	65	1	f
1576	86	1	f
1577	87	1	f
1579	110	1	f
1580	78	1	f
1581	87	1	f
1582	89	1	f
1584	89	1	f
1585	90	1	f
1586	69	1	f
1587	39	1	f
1591	87	1	f
1592	89	1	f
1593	69	1	f
1597	104	1	f
1598	103	1	f
1607	106	1	f
1608	105	1	f
1609	105	1	f
1610	87	1	f
1611	87	1	f
1612	89	1	f
1613	89	1	f
1614	90	1	f
1615	69	1	f
1616	69	1	f
1619	69	1	f
1620	87	1	f
1621	87	1	f
1622	89	1	f
1623	90	1	f
1624	87	1	f
1625	89	1	f
1626	69	1	f
1627	69	1	f
1628	69	1	f
1634	103	1	f
1639	106	1	f
1640	87	1	f
1641	87	1	f
1642	89	1	f
1643	89	1	f
1644	90	1	f
1645	69	1	f
1647	39	1	f
1650	87	1	f
1651	89	1	f
1652	90	1	f
1653	69	1	f
1657	103	1	f
1659	65	1	f
1660	106	1	f
1714	110	1	f
1721	110	1	f
1764	111	1	f
1766	111	1	f
1769	105	1	f
1771	111	1	f
1773	111	1	f
1774	111	1	f
1777	65	1	f
1780	105	1	f
1797	12	1	f
1798	65	1	f
1799	12	1	f
1807	90	1	f
1839	103	1	f
1840	103	1	f
1849	12	1	f
1852	119	1	f
1853	119	1	f
1854	119	1	f
1855	119	1	f
1859	119	1	f
1860	119	1	f
1866	117	1	f
1869	69	1	f
1870	78	1	f
1873	105	1	f
1876	106	1	f
1880	106	1	f
1882	106	1	f
1884	12	1	f
1885	65	1	f
1888	117	1	f
1893	120	1	f
1894	12	1	f
1895	65	1	f
1896	65	1	f
1898	105	1	f
1900	120	1	f
1901	120	1	f
1902	117	1	f
1903	111	1	f
1904	65	1	f
1905	65	1	f
1906	65	1	f
1907	65	1	f
1908	65	1	f
1910	106	1	f
1913	117	1	f
1915	111	1	f
1917	110	1	f
1918	119	1	f
1919	12	1	f
1922	93	1	f
1925	89	1	f
1926	90	1	f
1927	87	1	f
1941	12	1	f
1945	123	1	f
1946	123	1	f
1947	123	1	f
1948	123	1	f
1949	123	1	f
1950	123	1	f
1951	90	1	f
1952	86	1	f
1954	12	1	f
1956	87	1	f
1959	123	1	f
1961	123	1	f
1963	123	1	f
1965	123	1	f
1966	12	1	f
1968	12	1	f
1970	126	1	f
1972	123	1	f
1973	123	1	f
1975	65	1	f
1977	12	1	f
1978	2	1	f
1984	123	1	f
1986	123	1	f
1987	103	1	f
1988	119	1	f
1989	12	1	f
1990	106	1	f
1992	106	1	f
1993	106	1	f
1994	106	1	f
1995	106	1	f
1996	106	1	f
2000	103	1	f
2001	106	1	f
2005	103	1	f
2006	106	1	f
2010	123	1	f
2011	110	1	f
2013	87	1	f
2014	89	1	f
2015	90	1	f
2017	69	1	f
2018	87	1	f
2019	89	1	f
2020	69	1	f
2023	104	1	f
2024	104	1	f
2026	103	1	f
2027	106	1	f
2029	119	1	f
2030	119	1	f
2031	119	1	f
2032	110	1	f
2038	119	1	f
2039	119	1	f
2044	119	1	f
2045	119	1	f
2046	119	1	f
2047	119	1	f
2048	65	1	f
2049	12	1	f
2050	87	1	f
2051	69	1	f
2053	47	1	f
2054	2	1	f
2055	12	1	f
2064	123	1	f
2067	123	1	f
2069	123	1	f
2070	12	1	f
2076	123	1	f
2077	12	1	f
2089	87	1	f
2090	69	1	f
2095	87	1	f
2099	12	1	f
2100	12	1	f
2101	65	1	f
2104	135	1	f
2105	135	1	f
2106	135	1	f
2107	12	1	f
2108	12	1	f
2115	39	1	f
2119	90	1	f
2126	2	1	f
2127	12	1	f
2128	65	1	f
2129	138	1	f
2130	138	1	f
2133	123	1	f
2135	12	1	f
2136	65	1	f
2137	139	1	f
2138	139	1	f
2139	139	1	f
2144	135	1	f
2145	137	1	f
2146	135	1	f
2147	137	1	f
2148	135	1	f
2149	137	1	f
2150	135	1	f
2151	137	1	f
2152	135	1	f
2153	137	1	f
2154	135	1	f
2155	137	1	f
2156	135	1	f
2157	137	1	f
2158	135	1	f
2159	137	1	f
2160	135	1	f
2161	137	1	f
2162	135	1	f
2163	137	1	f
2164	135	1	f
2165	137	1	f
2167	135	1	f
2168	137	1	f
2172	135	1	f
2173	137	1	f
2174	135	1	f
2175	137	1	f
2176	135	1	f
2177	137	1	f
2178	135	1	f
2179	137	1	f
2180	135	1	f
2181	137	1	f
2182	135	1	f
2183	137	1	f
2184	135	1	f
2185	137	1	f
2186	134	1	f
2187	135	1	f
2188	137	1	f
2189	135	1	f
2190	137	1	f
2198	123	1	f
2199	105	1	f
2200	104	1	f
2201	104	1	f
2203	104	1	f
2205	110	1	f
2206	110	1	f
2207	110	1	f
2208	110	1	f
2209	110	1	f
2210	86	1	f
2211	110	1	f
2212	110	1	f
2213	86	1	f
2214	110	1	f
2215	86	1	f
2217	12	1	f
2219	65	1	f
2222	65	1	f
2243	12	1	f
2244	12	1	f
2245	65	1	f
2246	105	1	f
2247	102	1	f
2248	141	1	f
2249	141	1	f
2254	135	1	f
2255	142	1	f
2256	135	1	f
2257	142	1	f
2258	135	1	f
2259	142	1	f
2260	135	1	f
2261	142	1	f
2262	135	1	f
2263	142	1	f
2265	135	1	f
2266	137	1	f
2268	12	1	f
2269	105	1	f
2273	135	1	f
2274	143	1	f
2276	12	1	f
2277	105	1	f
2278	135	1	f
2279	144	1	f
2282	135	1	f
2283	137	1	f
2285	135	1	f
2286	137	1	f
2287	135	1	f
2288	142	1	f
2292	12	1	f
2293	145	1	f
2294	145	1	f
2295	145	1	f
2296	12	1	f
2297	145	1	f
2299	146	1	f
2300	145	1	f
2301	146	1	f
2304	123	1	f
2305	145	1	f
2306	146	1	f
2307	87	1	f
2308	87	1	f
2309	69	1	f
2310	145	1	f
2313	145	1	f
2314	69	1	f
2315	135	1	f
2316	137	1	f
2320	12	1	f
2327	87	1	f
2328	69	1	f
2329	145	1	f
2330	145	1	f
2331	146	1	f
2332	146	1	f
2338	87	1	f
2339	69	1	f
2340	69	1	f
2341	135	1	f
2342	137	1	f
2343	135	1	f
2344	143	1	f
2366	87	1	f
2367	69	1	f
2368	145	1	f
2369	146	1	f
2373	39	1	f
2376	69	1	f
2377	135	1	f
2378	137	1	f
2379	135	1	f
2380	143	1	f
2389	105	1	f
2390	105	1	f
2391	105	1	f
2392	105	1	f
2393	105	1	f
2394	105	1	f
2395	105	1	f
2396	105	1	f
2397	105	1	f
2398	105	1	f
2399	105	1	f
2400	105	1	f
2401	105	1	f
2402	105	1	f
2403	105	1	f
2404	105	1	f
2405	105	1	f
2406	105	1	f
2407	105	1	f
2408	105	1	f
2409	105	1	f
2410	105	1	f
2411	105	1	f
2412	105	1	f
2413	105	1	f
2414	105	1	f
2415	105	1	f
2416	105	1	f
2417	105	1	f
2418	105	1	f
2419	105	1	f
2420	105	1	f
2421	105	1	f
2422	105	1	f
2423	105	1	f
2424	105	1	f
2425	105	1	f
2426	105	1	f
2427	105	1	f
2428	105	1	f
2429	105	1	f
2430	105	1	f
2431	105	1	f
2432	105	1	f
2433	145	1	f
2435	146	1	f
2437	146	1	f
2465	120	1	f
2468	119	1	f
2469	119	1	f
2470	119	1	f
2475	90	1	f
2477	47	1	f
2484	2	1	f
2489	86	1	f
2490	86	1	f
2491	86	1	f
2493	87	1	f
2501	110	1	f
2502	110	1	f
2503	119	1	f
2505	110	1	f
2506	86	1	f
2507	110	1	f
2508	110	1	f
2510	110	1	f
2511	86	1	f
2513	12	1	f
2514	65	1	f
2516	12	1	f
2517	149	1	f
2518	149	1	f
2519	47	1	f
2520	149	1	f
2521	149	1	f
2522	149	1	f
2523	149	1	f
2524	149	1	f
2525	149	1	f
2526	149	1	f
2527	149	1	f
2528	149	1	f
2529	119	1	f
2530	119	1	f
2531	119	1	f
2532	119	1	f
2533	119	1	f
2534	119	1	f
2535	119	1	f
2536	110	1	f
2537	119	1	f
2538	119	1	f
2539	110	1	f
2540	86	1	f
2541	119	1	f
2545	86	1	f
2546	110	1	f
2547	119	1	f
2548	119	1	f
2549	12	1	f
2550	87	1	f
2551	12	1	f
2552	65	1	f
2553	65	1	f
2554	65	1	f
2556	151	1	f
2557	151	1	f
2558	12	1	f
2559	151	1	f
2560	69	1	f
2561	145	1	f
2563	69	1	f
2564	145	1	f
2566	69	1	f
2567	145	1	f
2568	145	1	f
2570	69	1	f
2571	145	1	f
2573	69	1	f
2574	145	1	f
2576	69	1	f
2577	145	1	f
2578	145	1	f
2580	69	1	f
2581	145	1	f
2583	12	1	f
2585	87	1	f
2592	123	1	f
2593	69	1	f
2594	87	1	f
2595	69	1	f
2596	145	1	f
2597	145	1	f
2598	145	1	f
2602	65	1	f
2603	65	1	f
2604	65	1	f
2605	65	1	f
2608	65	1	f
2612	65	1	f
2613	65	1	f
2617	65	1	f
2631	65	1	f
2632	65	1	f
2633	65	1	f
2634	65	1	f
2635	65	1	f
2636	65	1	f
2637	65	1	f
2638	65	1	f
2642	65	1	f
2643	65	1	f
2646	65	1	f
2647	65	1	f
2648	65	1	f
2649	65	1	f
2650	65	1	f
2651	65	1	f
2652	65	1	f
2653	65	1	f
2654	65	1	f
2655	65	1	f
2665	149	1	f
2666	87	1	f
2667	69	1	f
2668	145	1	f
2670	146	1	f
2672	123	1	f
2673	39	1	f
2676	87	1	f
2677	89	1	f
2678	69	1	f
2679	69	1	f
2680	89	1	f
2681	89	1	f
2682	149	1	f
2683	89	1	f
2684	149	1	f
2685	89	1	f
2686	135	1	f
2687	137	1	f
2688	135	1	f
2689	143	1	f
2693	110	1	f
2694	110	1	f
2695	86	1	f
2698	110	1	f
2699	86	1	f
2700	119	1	f
2701	119	1	f
2702	119	1	f
2703	119	1	f
2704	119	1	f
2705	119	1	f
2706	119	1	f
2707	119	1	f
2708	119	1	f
2709	119	1	f
2710	119	1	f
2711	119	1	f
2712	119	1	f
2713	119	1	f
2715	119	1	f
2716	119	1	f
2717	119	1	f
2718	119	1	f
2719	119	1	f
2720	119	1	f
2721	119	1	f
2722	119	1	f
2724	119	1	f
2725	119	1	f
2726	110	1	f
2727	119	1	f
2728	119	1	f
2729	103	1	f
2731	123	1	f
2734	119	1	f
2735	119	1	f
2736	119	1	f
2739	69	1	f
2740	12	1	f
2741	65	1	f
2742	12	1	f
2779	123	1	f
2780	123	1	f
2781	123	1	f
2785	47	1	f
2786	2	1	f
2787	2	1	f
2790	12	1	f
\.


--
-- Name: resource_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('resource_id_seq', 2790, true);


--
-- Data for Name: resource_log; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY resource_log (id, resource_id, employee_id, comment, modifydt) FROM stdin;
7672	725	2	\N	2015-10-25 18:29:36.485331+02
7673	772	2	\N	2015-10-25 18:29:48.734406+02
7674	2742	2	\N	2015-10-25 21:14:37.429267+02
7675	2740	2	\N	2015-10-25 21:14:41.037197+02
7676	2583	2	\N	2015-10-25 21:14:44.152213+02
7677	2558	2	\N	2015-10-25 21:14:47.468287+02
7678	2551	2	\N	2015-10-25 21:14:50.661752+02
7679	2516	2	\N	2015-10-25 21:14:54.043974+02
7680	2513	2	\N	2015-10-25 21:14:57.515749+02
7681	2296	2	\N	2015-10-25 21:15:00.801576+02
7682	2292	2	\N	2015-10-25 21:15:04.579697+02
7683	2276	2	\N	2015-10-25 21:15:07.859876+02
7684	2268	2	\N	2015-10-25 21:15:11.41355+02
7685	2244	2	\N	2015-10-25 21:15:15.08087+02
7686	2243	2	\N	2015-10-25 21:15:18.415374+02
7687	2217	2	\N	2015-10-25 21:15:22.580956+02
7688	2135	2	\N	2015-10-25 21:15:26.822285+02
7689	2127	2	\N	2015-10-25 21:15:30.469938+02
7690	2108	2	\N	2015-10-25 21:15:35.148375+02
7691	2100	2	\N	2015-10-25 21:15:38.483633+02
7692	2099	2	\N	2015-10-25 21:15:43.982787+02
7693	2049	2	\N	2015-10-25 21:15:49.162966+02
7694	1968	2	\N	2015-10-25 21:15:53.440626+02
7695	1941	2	\N	2015-10-25 21:15:57.551908+02
7696	1884	2	\N	2015-10-25 21:16:01.935865+02
7697	1894	2	\N	2015-10-25 21:16:05.350861+02
7698	1849	2	\N	2015-10-25 21:16:08.565296+02
7699	1799	2	\N	2015-10-25 21:16:11.898419+02
7700	1797	2	\N	2015-10-25 21:16:17.305403+02
7701	1548	2	\N	2015-10-25 21:16:20.933341+02
7702	1521	2	\N	2015-10-25 21:16:24.346478+02
7703	1435	2	\N	2015-10-25 21:16:28.278231+02
7704	1433	2	\N	2015-10-25 21:16:32.204893+02
7705	1424	2	\N	2015-10-25 21:16:37.127758+02
7706	1393	2	\N	2015-10-25 21:16:40.502794+02
7707	1317	2	\N	2015-10-25 21:16:43.978797+02
7708	1313	2	\N	2015-10-25 21:16:48.394405+02
7709	1268	2	\N	2015-10-25 21:16:52.253586+02
7710	1225	2	\N	2015-10-25 21:16:55.883212+02
7711	1211	2	\N	2015-10-25 21:17:02.365419+02
7712	1207	2	\N	2015-10-25 21:17:11.228895+02
7713	1198	2	\N	2015-10-25 21:17:14.605706+02
7714	1190	2	\N	2015-10-25 21:17:17.962226+02
7715	1189	2	\N	2015-10-25 21:17:22.169824+02
7716	1088	2	\N	2015-10-25 21:17:27.123342+02
7717	1081	2	\N	2015-10-25 21:17:30.484303+02
7718	1007	2	\N	2015-10-25 21:17:33.84324+02
7719	1003	2	\N	2015-10-25 21:17:37.28513+02
7720	954	2	\N	2015-10-25 21:17:41.191895+02
7721	953	2	\N	2015-10-25 21:17:45.458502+02
7722	909	2	\N	2015-10-25 21:17:49.385186+02
7723	908	2	\N	2015-10-25 21:17:53.112889+02
7724	901	2	\N	2015-10-25 21:17:58.692045+02
7725	872	2	\N	2015-10-25 21:18:02.214698+02
7726	865	2	\N	2015-10-25 21:18:05.09372+02
7727	788	2	\N	2015-10-25 21:18:08.146867+02
7728	775	2	\N	2015-10-25 21:18:11.413701+02
7729	769	2	\N	2015-10-25 21:18:14.703555+02
7730	764	2	\N	2015-10-25 21:18:17.786192+02
7731	723	2	\N	2015-10-25 21:18:21.267664+02
7732	706	2	\N	2015-10-25 21:18:24.219742+02
7733	283	2	\N	2015-10-25 21:18:27.627488+02
7734	274	2	\N	2015-10-25 21:18:30.883104+02
7735	16	2	\N	2015-10-25 21:18:33.921184+02
7736	10	2	\N	2015-10-25 21:18:37.163922+02
7737	773	2	\N	2015-10-25 21:18:49.306767+02
7738	3	2	\N	2015-10-25 21:19:10.539731+02
7739	784	2	\N	2015-10-25 21:19:27.565925+02
7740	789	2	\N	2015-10-25 21:19:38.951573+02
7741	772	2	\N	2015-10-25 21:19:53.535469+02
7742	1100	2	\N	2015-10-25 21:20:18.256979+02
7743	1095	2	\N	2015-10-25 21:20:21.415245+02
7744	883	2	\N	2015-10-25 21:20:24.411401+02
7745	882	2	\N	2015-10-25 21:20:27.610602+02
7746	881	2	\N	2015-10-25 21:20:30.548418+02
7747	880	2	\N	2015-10-25 21:20:34.03857+02
7748	878	2	\N	2015-10-25 21:20:36.956871+02
7749	2788	2	\N	2015-11-15 11:41:32.753196+02
7750	2741	2	\N	2015-11-15 11:42:42.182101+02
7752	2790	2	\N	2015-11-22 22:04:31.745001+02
7753	998	2	\N	2015-12-19 18:58:53.274875+02
7754	864	2	\N	2015-12-19 18:59:12.993038+02
7755	900	2	\N	2015-12-19 18:59:28.904635+02
7756	837	2	\N	2015-12-19 18:59:47.892138+02
7757	873	2	\N	2015-12-19 19:00:17.462583+02
7758	1895	2	\N	2015-12-19 19:00:42.041626+02
7759	778	2	\N	2015-12-19 19:00:56.774689+02
7760	2048	2	\N	2015-12-19 19:01:12.925063+02
7761	2101	2	\N	2015-12-19 19:01:30.542048+02
7762	1368	2	\N	2015-12-19 19:01:45.470669+02
7763	866	2	\N	2015-12-19 19:02:19.68642+02
7764	902	2	\N	2015-12-19 19:03:00.164077+02
7765	2741	2	\N	2015-12-19 19:03:14.621449+02
7766	790	2	\N	2015-12-19 19:03:40.873053+02
7767	791	2	\N	2015-12-19 19:04:11.128561+02
7768	838	2	\N	2015-12-19 19:04:47.126719+02
7769	863	2	\N	2015-12-19 19:05:01.927793+02
7770	1312	2	\N	2015-12-19 19:11:29.692654+02
7771	1212	2	\N	2015-12-19 19:11:42.401036+02
7772	1906	2	\N	2015-12-19 19:12:07.282949+02
7773	802	2	\N	2015-12-19 19:12:35.147785+02
7774	1395	2	\N	2015-12-19 19:13:03.538972+02
7775	1905	2	\N	2015-12-19 19:13:29.909671+02
7776	1905	2	\N	2015-12-19 19:13:43.05814+02
7777	1904	2	\N	2015-12-19 19:14:08.86286+02
7778	1434	2	\N	2015-12-19 19:14:42.669227+02
7779	1571	2	\N	2015-12-19 19:15:08.72348+02
7780	1885	2	\N	2015-12-19 19:15:31.549063+02
7781	1896	2	\N	2015-12-19 19:17:48.737362+02
7782	779	2	\N	2015-12-19 19:18:09.272548+02
7783	792	2	\N	2015-12-19 19:18:27.223073+02
7784	1975	2	\N	2015-12-19 19:18:45.712798+02
7785	1550	2	\N	2015-12-19 19:19:10.04637+02
7786	2222	2	\N	2015-12-19 19:19:23.129832+02
7787	2219	2	\N	2015-12-19 19:19:37.815734+02
7788	1008	2	\N	2015-12-19 19:19:57.484164+02
7789	1394	2	\N	2015-12-19 19:20:16.701021+02
7790	780	2	\N	2015-12-19 19:20:28.354133+02
7791	2128	2	\N	2015-12-19 19:20:48.362209+02
7792	2136	2	\N	2015-12-19 19:21:00.415791+02
7793	2245	2	\N	2015-12-19 19:21:15.736704+02
7794	2552	2	\N	2015-12-19 19:21:33.532013+02
7795	1908	2	\N	2015-12-19 19:21:49.622808+02
7796	1907	2	\N	2015-12-19 19:22:06.733382+02
7797	1080	2	\N	2015-12-19 19:22:39.105738+02
7798	910	2	\N	2015-12-19 19:23:14.279406+02
7799	911	2	\N	2015-12-19 19:23:45.913381+02
7800	956	2	\N	2015-12-19 19:24:08.184513+02
7801	955	2	\N	2015-12-19 19:24:26.990458+02
7802	879	2	\N	2015-12-19 19:24:49.931923+02
7803	1089	2	\N	2015-12-19 19:25:10.514211+02
7804	874	2	\N	2015-12-19 19:25:27.130616+02
7805	1436	2	\N	2015-12-19 19:55:59.961598+02
7806	1798	2	\N	2015-12-19 19:56:29.707064+02
7807	1425	2	\N	2015-12-19 19:57:48.500731+02
7808	2514	2	\N	2015-12-19 19:58:18.992544+02
7810	2788	2	\N	2015-12-19 22:02:14.069026+02
7811	2583	2	\N	2015-12-19 22:02:47.427632+02
7812	2558	2	\N	2015-12-19 22:03:01.721374+02
7813	2551	2	\N	2015-12-19 22:03:16.895798+02
7814	2516	2	\N	2015-12-19 22:03:26.242027+02
7815	2513	2	\N	2015-12-19 22:03:35.240474+02
7816	2296	2	\N	2015-12-19 22:03:49.365283+02
7817	2292	2	\N	2015-12-19 22:04:09.175036+02
7818	2276	2	\N	2015-12-19 22:04:30.952139+02
7819	2268	2	\N	2015-12-19 22:04:38.996063+02
7820	2244	2	\N	2015-12-19 22:04:46.546011+02
7821	2243	2	\N	2015-12-19 22:05:00.185389+02
7822	2217	2	\N	2015-12-19 22:05:13.507764+02
7823	2135	2	\N	2015-12-19 22:05:21.728269+02
7824	2127	2	\N	2015-12-19 22:05:34.042409+02
7825	2127	2	\N	2015-12-19 22:05:41.058239+02
7826	2108	2	\N	2015-12-19 22:05:50.198094+02
7827	2100	2	\N	2015-12-19 22:06:03.58054+02
7828	2099	2	\N	2015-12-19 22:06:12.023947+02
7829	2049	2	\N	2015-12-19 22:06:19.296484+02
7830	1968	2	\N	2015-12-19 22:06:27.461482+02
7832	1894	2	\N	2015-12-19 22:06:49.847649+02
7834	1849	2	\N	2015-12-19 22:07:13.830825+02
7836	1797	2	\N	2015-12-19 22:07:38.267483+02
7840	1433	2	\N	2015-12-19 22:08:29.052796+02
7843	1317	2	\N	2015-12-19 22:09:05.307643+02
7845	2513	2	\N	2015-12-19 22:09:47.524464+02
7849	274	2	\N	2015-12-19 22:10:38.840667+02
7851	706	2	\N	2015-12-19 22:10:55.732613+02
7854	769	2	\N	2015-12-19 22:11:19.431344+02
7857	865	2	\N	2015-12-19 22:12:01.90528+02
7859	901	2	\N	2015-12-19 22:12:26.005959+02
7861	1225	2	\N	2015-12-19 22:12:58.217044+02
7863	1207	2	\N	2015-12-19 22:13:14.285855+02
7864	1198	2	\N	2015-12-19 22:13:22.924173+02
7866	1189	2	\N	2015-12-19 22:13:39.095813+02
7868	1081	2	\N	2015-12-19 22:13:59.753756+02
7870	1003	2	\N	2015-12-19 22:14:20.298224+02
7873	909	2	\N	2015-12-19 22:14:54.326966+02
7882	2276	2	\N	2015-12-19 22:18:13.736045+02
7831	1941	2	\N	2015-12-19 22:06:41.107604+02
7833	1884	2	\N	2015-12-19 22:07:02.728022+02
7835	1799	2	\N	2015-12-19 22:07:23.304713+02
7837	1548	2	\N	2015-12-19 22:07:56.719874+02
7838	1521	2	\N	2015-12-19 22:08:07.633327+02
7839	1435	2	\N	2015-12-19 22:08:15.283625+02
7841	1424	2	\N	2015-12-19 22:08:40.943186+02
7842	1393	2	\N	2015-12-19 22:08:53.488969+02
7844	1313	2	\N	2015-12-19 22:09:18.933898+02
7846	773	2	\N	2015-12-19 22:10:10.177732+02
7847	10	2	\N	2015-12-19 22:10:19.923385+02
7848	16	2	\N	2015-12-19 22:10:31.364704+02
7850	283	2	\N	2015-12-19 22:10:47.472805+02
7852	723	2	\N	2015-12-19 22:11:03.855144+02
7853	764	2	\N	2015-12-19 22:11:11.06599+02
7855	775	2	\N	2015-12-19 22:11:37.854087+02
7856	788	2	\N	2015-12-19 22:11:52.422586+02
7858	872	2	\N	2015-12-19 22:12:11.983192+02
7860	1268	2	\N	2015-12-19 22:12:51.356992+02
7862	1211	2	\N	2015-12-19 22:13:06.641889+02
7865	1190	2	\N	2015-12-19 22:13:31.70604+02
7867	1088	2	\N	2015-12-19 22:13:50.598753+02
7869	1007	2	\N	2015-12-19 22:14:11.463114+02
7871	954	2	\N	2015-12-19 22:14:34.426344+02
7872	953	2	\N	2015-12-19 22:14:43.642625+02
7874	908	2	\N	2015-12-19 22:15:05.092951+02
7875	784	2	\N	2015-12-19 22:16:07.26156+02
7876	725	2	\N	2015-12-19 22:16:34.527916+02
7877	2247	2	\N	2015-12-19 22:17:03.184025+02
7878	1413	2	\N	2015-12-19 22:17:11.942957+02
7879	1318	2	\N	2015-12-19 22:17:24.515341+02
7880	1314	2	\N	2015-12-19 22:17:50.177423+02
7881	2276	2	\N	2015-12-19 22:18:05.676719+02
7883	772	2	\N	2015-12-19 22:19:32.565016+02
7884	772	2	\N	2015-12-19 22:19:39.21454+02
7885	789	2	\N	2015-12-19 22:19:58.837279+02
\.


--
-- Name: resource_log_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('resource_log_id_seq', 7885, true);


--
-- Data for Name: resource_type; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY resource_type (id, resource_id, name, humanize, resource_name, module, settings, descr, status) FROM stdin;
149	2516	uploads	Загрузки	UploadsResource	travelcrm.resources.uploads	null	Uploads for any type of resources	0
1	773	 	Домашняя	Root	travelcrm.resources	null	Home Page of Travelcrm	0
146	2296	leads_offers	Предложения по лидам	LeadsOffersResource	travelcrm.resources.leads_offers	null	Leads Offers	0
145	2292	leads_items	Содержимое лидов	LeadsItemsResource	travelcrm.resources.leads_items	null	Leads Items	0
137	2108	tours	Туры	ToursResource	travelcrm.resources.tours	null	Tour Service	0
135	2100	orders_items	Содержимое заявки	OrdersItemsResource	travelcrm.resources.orders_items	null	Orders Items	0
134	2099	orders	Заявки	OrdersResource	travelcrm.resources.orders	null	Orders	0
130	2049	leads	Лиды	LeadsResource	travelcrm.resources.leads	null	Leads that can be converted into contacts	0
126	1968	companies	Компании	CompaniesResource	travelcrm.resources.companies	null	Multicompanies functionality	0
121	1894	turnovers	Обороты	TurnoversResource	travelcrm.resources.turnovers	null	Turnovers on Accounts and Subaccounts	0
118	1799	notes	Заметки	NotesResource	travelcrm.resources.notes	null	Resources Notes	0
117	1797	subaccounts	Субсчета	SubaccountsResource	travelcrm.resources.subaccounts	null	Subaccounts are accounts from other objects such as clients, touroperators and so on	0
111	1548	outgoings	Исходящие платежи	OutgoingsResource	travelcrm.resources.outgoings	null	Outgoings payments for touroperators, suppliers, payback payments and so on	0
110	1521	commissions	Комиссии	CommissionsResource	travelcrm.resources.commissions	null	Services sales commissions	0
107	1435	accounts	Счета	AccountsResource	travelcrm.resources.accounts	null	Billing Accounts. It can be bank accouts, cash accounts etc. and has company wide visible	0
106	1433	incomes	Входящие платежи	IncomesResource	travelcrm.resources.incomes	{"account_item_id": 8}	Incomes Payments Document for invoices	0
105	1424	accounts_items	Статьи учета	AccountsItemsResource	travelcrm.resources.accounts_items	null	Finance accounts items	0
103	1317	invoices	Инвойсы	InvoicesResource	travelcrm.resources.invoices	{"active_days": 3}	Invoices list. Invoice can't be created manualy - only using source document such as Tours	0
102	1313	services	Сервисы	ServicesResource	travelcrm.resources.services	null	Additional Services that can be provide with tours sales or separate	0
148	2513	vats	Настройки НДС	VatsResource	travelcrm.resources.vats	null	Vat for accounts and services	0
2	10	users	Пользователи	UsersResource	travelcrm.resources.users	null	Users list	0
12	16	resources_types	Типы ресурсов	ResourcesTypesResource	travelcrm.resources.resources_types	null	Resources types list	0
39	274	regions	Регионы	RegionsResource	travelcrm.resources.regions	null		0
41	283	currencies	Валюты	CurrenciesResource	travelcrm.resources.currencies	null		0
47	706	employees	Сотрудники	EmployeesResource	travelcrm.resources.employees	null	Employees Container Datagrid	0
55	723	structures	Структура	StructuresResource	travelcrm.resources.structures	null	Companies structures is a tree of company structure. It's can be offices, filials, departments and so and so	0
59	764	positions	Должности	PositionsResource	travelcrm.resources.positions	null	Companies positions is a point of company structure where emplyees can be appointed	0
61	769	permisions	Доступ	PermisionsResource	travelcrm.resources.permisions	null	Permisions list of company structure position. It's list of resources and permisions	0
65	775	navigations	Меню	NavigationsResource	travelcrm.resources.navigations	null	Navigations list of company structure position.	0
67	788	appointments	Назначения сотрудников	AppointmentsResource	travelcrm.resources.appointments	null	Employees to positions of company appointments	0
69	865	persons	Физ. лица	PersonsResource	travelcrm.resources.persons	null	Persons directory. Person can be client or potential client	0
70	872	countries	Страны	CountriesResource	travelcrm.resources.countries	null	Countries directory	0
71	901	advsources	Источники рекламы	AdvsourcesResource	travelcrm.resources.advsources	null	Types of advertises	0
93	1225	tasks	Задачи	TasksResource	travelcrm.resources.tasks	null	Task manager	0
91	1211	banks	Банки	BanksResource	travelcrm.resources.banks	null	Banks list to create bank details and for other reasons	0
90	1207	addresses	Адреса	AddressesResource	travelcrm.resources.addresses	null	Addresses of any type of resources, such as persons, bpersons, hotels etc.	0
89	1198	passports	Паспорта	PassportsResource	travelcrm.resources.passports	null	Clients persons passports lists	0
87	1190	contacts	Контакты	ContactsResource	travelcrm.resources.contacts	null	Contacts for persons, business persons etc.	0
86	1189	contracts	Договора	ContractsResource	travelcrm.resources.contracts	null	Licences list for any type of resources as need	0
84	1088	locations	Населенные пункты	LocationsResource	travelcrm.resources.locations	null	Locations list is list of cities, vilages etc. places to use to identify part of region	0
83	1081	hotels	Отели	HotelsResource	travelcrm.resources.hotels	null	Hotels directory	0
79	1007	bpersons	Бизнес контакты	BPersonsResource	travelcrm.resources.bpersons	null	Business Persons is not clients it's simple business contacts that can be referenced objects that needs to have contacts	0
78	1003	suppliers	Поставщики	SuppliersResource	travelcrm.resources.suppliers	null	Suppliers, such as touroperators, aircompanies, IATA etc.	0
75	954	foodcats	Категории питания	FoodcatsResource	travelcrm.resources.foodcats	null	Food types in hotels	0
74	953	accomodations	Типы размещения	AccomodationsResource	travelcrm.resources.accomodations	null	Accomodations Types list	0
73	909	roomcats	Категории номеров	RoomcatsResource	travelcrm.resources.roomcats	null	Categories of the rooms	0
72	908	hotelcats	Категории отелей	HotelcatsResource	travelcrm.resources.hotelcats	null	Hotels categories	0
156	2788	campaigns	Кампании	CampaignsResource	travelcrm.resources.campaigns	{"username": "--", "host": "--", "password": "--", "port": "2525", "default_sender": "--"}	Marketings campaigns	0
153	2583	activities	Активность	ActivitiesResource	travelcrm.resources.activities	{"column_index": 1}	My last activities	0
152	2558	leads_stats	Статистика по лидам	LeadsStatsResource	travelcrm.resources.leads_stats	{"column_index": 0}	Portlet with leads statistics	0
151	2551	persons_categories	Категории физ. лиц	PersonsCategoriesResource	travelcrm.resources.persons_categories	null	Categorise your clients with categories of persons	0
143	2268	visas	Визы	VisasResource	travelcrm.resources.visas	null	Visa is a service for sale visas	0
142	2244	tickets	Билеты	TicketsResource	travelcrm.resources.tickets	null	Ticket is a service for sale tickets of any type	0
141	2243	tickets_classes	Классы билетов	TicketsClassesResource	travelcrm.resources.tickets_classes	null	Tickets Classes list, such as first class, business class etc	0
140	2217	suppliers_types	Типы поставщиков	SuppliersTypesResource	travelcrm.resources.suppliers_types	null	Suppliers Types list	0
139	2135	transports	Транспорт	TransportsResource	travelcrm.resources.transports	null	Transports Types List	0
138	2127	transfers	Трансфер	TransfersResource	travelcrm.resources.transfers	null	Transfers for tours	0
123	1941	notifications	Уведомления	NotificationsResource	travelcrm.resources.notifications	null	Employee Notifications	0
120	1884	crosspayments	Кросс оплаты	CrosspaymentsResource	travelcrm.resources.crosspayments	null	Cross payments between accounts and subaccounts. This document is for balance corrections to.	0
119	1849	calculations	Калькуляции	CalculationsResource	travelcrm.resources.calculations	null	Calculations of Sale Documents	0
104	1393	currencies_rates	Курсы валют	CurrenciesRatesResource	travelcrm.resources.currencies_rates	null	Currencies Rates. Values from this dir used by billing to calc prices in base currency.	0
101	1268	banks_details	Реквизиты	BanksDetailsResource	travelcrm.resources.banks_details	null	Banks Details that can be attached to any client or business partner to define account	0
144	2276	spassports	Оформление паспортов	SpassportsResource	travelcrm.resources.spassports	null	Service formulation of foreign passports	0
\.


--
-- Name: resource_type_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('resource_type_id_seq', 157, true);


--
-- Data for Name: roomcat; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY roomcat (id, resource_id, name) FROM stdin;
\.


--
-- Name: roomcat_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('roomcat_id_seq', 1, true);


--
-- Data for Name: service; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY service (id, resource_id, resource_type_id, name, display_text, descr) FROM stdin;
7	2247	142	Продажа билетов	Ticket booking service	\N
5	1413	137	Продажа туров	Tour booking service	Use this service for tour sales
4	1318	143	Оформление виз	The issues for visas	\N
1	1314	144	Оформление загран. паспортов	Formulation of foreign passport	\N
\.


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('service_id_seq', 7, true);


--
-- Data for Name: spassport; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY spassport (id, resource_id, photo_done, docs_receive_date, docs_transfer_date, passport_receive_date, descr) FROM stdin;
\.


--
-- Name: spassport_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('spassport_id_seq', 1, true);


--
-- Data for Name: spassport_order_item; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY spassport_order_item (order_item_id, spassport_id) FROM stdin;
\.


--
-- Data for Name: structure; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY structure (id, resource_id, parent_id, company_id, name) FROM stdin;
1	725	\N	1	Головной Офис
\.


--
-- Data for Name: structure_address; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY structure_address (structure_id, address_id) FROM stdin;
\.


--
-- Data for Name: structure_bank_detail; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY structure_bank_detail (structure_id, bank_detail_id) FROM stdin;
\.


--
-- Data for Name: structure_contact; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY structure_contact (structure_id, contact_id) FROM stdin;
\.


--
-- Name: structure_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('structure_id_seq', 1, true);


--
-- Data for Name: subaccount; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY subaccount (id, resource_id, account_id, name, status, descr) FROM stdin;
\.


--
-- Name: subaccount_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('subaccount_id_seq', 1, true);


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY supplier (id, resource_id, supplier_type_id, name, status, descr) FROM stdin;
\.


--
-- Data for Name: supplier_bank_detail; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY supplier_bank_detail (supplier_id, bank_detail_id) FROM stdin;
\.


--
-- Data for Name: supplier_bperson; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY supplier_bperson (supplier_id, bperson_id) FROM stdin;
\.


--
-- Data for Name: supplier_contract; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY supplier_contract (supplier_id, contract_id) FROM stdin;
\.


--
-- Name: supplier_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('supplier_id_seq', 1, true);


--
-- Data for Name: supplier_subaccount; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY supplier_subaccount (supplier_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: supplier_type; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY supplier_type (id, resource_id, name, descr) FROM stdin;
\.


--
-- Name: supplier_type_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('supplier_type_id_seq', 1, true);


--
-- Data for Name: task; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY task (id, resource_id, employee_id, title, deadline, reminder, descr, status) FROM stdin;
\.


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('task_id_seq', 1, true);


--
-- Data for Name: task_resource; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY task_resource (task_id, resource_id) FROM stdin;
\.


--
-- Data for Name: task_upload; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY task_upload (task_id, upload_id) FROM stdin;
\.


--
-- Data for Name: ticket; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY ticket (id, resource_id, start_location_id, end_location_id, ticket_class_id, transport_id, start_dt, start_additional_info, end_dt, end_additional_info, adults, children, descr) FROM stdin;
\.


--
-- Data for Name: ticket_class; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY ticket_class (id, resource_id, name) FROM stdin;
\.


--
-- Name: ticket_class_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('ticket_class_id_seq', 1, true);


--
-- Name: ticket_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('ticket_id_seq', 1, true);


--
-- Data for Name: ticket_order_item; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY ticket_order_item (order_item_id, ticket_id) FROM stdin;
\.


--
-- Data for Name: tour; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY tour (id, resource_id, start_location_id, start_transport_id, end_location_id, end_transport_id, hotel_id, accomodation_id, foodcat_id, roomcat_id, transfer_id, adults, children, start_date, start_additional_info, end_date, end_additional_info, descr) FROM stdin;
\.


--
-- Name: tour_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('tour_id_seq', 1, true);


--
-- Data for Name: tour_order_item; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY tour_order_item (order_item_id, tour_id) FROM stdin;
\.


--
-- Data for Name: transfer; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY transfer (id, resource_id, name) FROM stdin;
\.


--
-- Name: transfer_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('transfer_id_seq', 1, true);


--
-- Data for Name: transport; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY transport (id, resource_id, name) FROM stdin;
\.


--
-- Name: transport_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('transport_id_seq', 1, true);


--
-- Data for Name: upload; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY upload (id, resource_id, name, path, size, media_type, descr) FROM stdin;
\.


--
-- Name: upload_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('upload_id_seq', 1, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY "user" (id, resource_id, employee_id, username, email, password) FROM stdin;
2	3	2	admin	admin@mail.ru	adminadmin
\.


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('user_id_seq', 2, true);


--
-- Data for Name: vat; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY vat (id, resource_id, account_id, service_id, date, vat, calc_method, descr) FROM stdin;
\.


--
-- Name: vat_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('vat_id_seq', 1, true);


--
-- Data for Name: visa; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY visa (id, resource_id, country_id, start_date, end_date, type, descr) FROM stdin;
\.


--
-- Name: visa_id_seq; Type: SEQUENCE SET; Schema: demo_ru; Owner: -
--

SELECT pg_catalog.setval('visa_id_seq', 1, true);


--
-- Data for Name: visa_order_item; Type: TABLE DATA; Schema: demo_ru; Owner: -
--

COPY visa_order_item (order_item_id, visa_id) FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- Data for Name: accomodation; Type: TABLE DATA; Schema: public; Owner: -
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
-- Name: accomodation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('accomodation_id_seq', 17, true);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: -
--

COPY account (id, resource_id, currency_id, account_type, name, display_text, descr, status) FROM stdin;
3	1439	56	1	Main Cash Account	cash payment	\N	0
4	1507	54	1	Main Cash EUR Account	Main Cash EUR Account	\N	0
2	1438	56	0	Main Bank Account	displa text	\N	0
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('account_id_seq', 4, true);


--
-- Data for Name: account_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY account_item (id, resource_id, name, parent_id, type, status, descr) FROM stdin;
3	1432	Taxes	\N	0	0	\N
4	1608	Operating charges	\N	0	0	\N
5	1609	Internal cash flow	\N	0	0	\N
6	1769	Profit distribution	\N	0	0	\N
7	1780	Rent	2	0	0	\N
8	1873	POF	2	0	0	\N
9	1898	Communication	2	0	0	\N
10	2199	Marketing, Sales	2	0	0	\N
11	2246	Software	2	0	0	Sales of any type of tickets
13	2277	Other operating	2	0	0	\N
1	1426	Income Tax	3	0	0	\N
14	2389	VAT	3	0	0	\N
15	2390	Other taxes, fees	3	0	0	\N
17	2392	Return to the buyer	4	0	0	\N
18	2393	Payment of the tour operator	4	0	0	\N
19	2394	Return the tour operator	4	0	0	\N
20	2395	Other operating income	4	0	0	\N
21	2396	Other operating expenses	4	0	0	\N
22	2397	The money from bank to bank	5	0	0	\N
23	2398	The money from the cash to the account	5	0	0	\N
24	2399	Money from the account in cash	5	0	0	\N
25	2400	Conversion	5	0	0	\N
26	2401	Acquisition of fixed assets	6	0	0	\N
27	2402	The withdrawal of capital	6	0	0	\N
28	2403	Rental fee	7	0	0	\N
29	2404	Utility payments	7	0	0	\N
30	2405	POF payable	8	0	0	\N
31	2406	PIT	8	0	0	\N
32	2407	ERUs	8	0	0	\N
33	2408	Bonuses (bonus)	8	0	0	\N
34	2409	Telephone landline	9	0	0	\N
35	2410	Mobile Phones	9	0	0	\N
36	2411	Internet	9	0	0	\N
37	2412	Other	9	0	0	\N
38	2413	Outdoor advertising	10	0	0	\N
39	2414	Advertising in print media	10	0	0	\N
40	2415	Advertising on TV, radio	10	0	0	\N
41	2416	Promotions and presentations	10	0	0	\N
42	2417	Exhibitions	10	0	0	\N
43	2418	Advertising on the Internet	10	0	0	\N
44	2419	 Website Promotion	10	0	0	\N
45	2420	Mailing lists	10	0	0	\N
46	2421	Other marketing	10	0	0	\N
47	2422	The costs for the modernization of the local software	11	0	0	\N
48	2423	The cost of upgrading the website	11	0	0	\N
49	2424	Bank charges	12	0	0	\N
50	2425	Other cash and settlement services	12	0	0	\N
51	2426	Office supplies, office software	13	0	0	\N
52	2427	Representation	13	0	0	\N
53	2428	Staff Missions	13	0	0	\N
54	2429	Postage, courier services	13	0	0	\N
55	2430	Minor repairs of machinery	13	0	0	\N
56	2431	Purchase low-value goods	13	0	0	\N
57	2432	Other (not included in any of the articles)	13	0	0	\N
2	1431	Administrative expensive	\N	2	0	Group of items
12	2269	Cash and Settlement Services	2	2	0	\N
16	2391	Payment by the buyer	4	1	0	\N
\.


--
-- Name: account_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('account_item_id_seq', 57, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: -
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
34	2475	34	fgfgf	fgfgfg
35	2590	14	06752	Vladimirskaya str, 12a, 33
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('address_id_seq', 35, true);


--
-- Data for Name: advsource; Type: TABLE DATA; Schema: public; Owner: -
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
-- Name: advsource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('advsource_id_seq', 6, true);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY alembic_version (version_num) FROM stdin;
1502d7ef7d40
\.


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY appointment (id, resource_id, currency_id, employee_id, position_id, salary, date) FROM stdin;
1	789	54	2	4	1000.00	2014-02-02
6	892	54	7	5	4500.00	2014-02-22
8	1542	54	2	4	6500.00	2014-03-01
12	2658	56	7	6	12000.00	2015-05-01
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: -
--

COPY bank (id, resource_id, name) FROM stdin;
1	1214	Bank of America
4	1415	Raiffaisen Bank Aval
5	1419	PrivatBank
\.


--
-- Data for Name: bank_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY bank_address (bank_id, address_id) FROM stdin;
5	29
5	33
\.


--
-- Data for Name: bank_detail; Type: TABLE DATA; Schema: public; Owner: -
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
19	2486	57	5	ghgh	ggh	hghg
\.


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

COPY bperson (id, resource_id, first_name, last_name, second_name, position_name, descr, status) FROM stdin;
1	1009	Alexandro	Riak		Sales Manager	\N	0
6	1560	Ivan	Gonchar		Account Manager	\N	0
5	1553	Sergey	Vlasov		Main account manager	\N	0
7	1563	Alexander	Tkachuk		manager		0
8	1578	Anna			Manager		0
2	1010	Umberto			Accounting		1
\.


--
-- Data for Name: bperson_contact; Type: TABLE DATA; Schema: public; Owner: -
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
2	89
\.


--
-- Name: bperson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bperson_id_seq', 9, true);


--
-- Data for Name: calculation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY calculation (id, resource_id, price, order_item_id, contract_id) FROM stdin;
33	2468	300.00	\N	\N
34	2469	54462.00	\N	\N
37	2503	3201.00	\N	\N
35	2470	300.00	\N	\N
41	2529	270.00	\N	\N
42	2530	270.00	\N	\N
43	2531	54462.75	\N	\N
46	2534	3201.00	\N	\N
47	2535	3201.00	\N	\N
48	2537	2788.50	40	\N
49	2538	1760.00	\N	\N
44	2532	270.00	\N	\N
45	2533	54462.75	\N	\N
57	2700	1496.40	\N	\N
58	2701	30.00	\N	\N
59	2702	1680.60	\N	\N
60	2703	30.00	\N	\N
61	2704	1715.00	\N	\N
62	2705	30.00	\N	\N
63	2706	1720.00	\N	\N
64	2707	30.00	\N	\N
65	2708	1525.80	\N	\N
66	2709	30.00	\N	\N
67	2710	1530.80	\N	\N
68	2711	30.00	\N	\N
69	2712	1525.80	\N	\N
70	2713	30.00	\N	\N
71	2715	1525.80	\N	\N
72	2716	30.00	\N	\N
73	2717	1398.95	\N	\N
74	2718	30.00	\N	\N
75	2719	1398.95	\N	\N
76	2720	30.00	\N	\N
77	2721	1398.95	\N	\N
78	2722	30.00	\N	\N
79	2724	1525.30	\N	\N
80	2725	30.00	\N	\N
81	2727	1525.30	44	\N
82	2728	26.70	45	\N
50	2541	1548.80	\N	\N
83	2734	1548.80	39	\N
51	2547	270.00	\N	\N
52	2548	47611.95	\N	\N
84	2735	270.00	43	\N
85	2736	50239.20	42	\N
86	2832	2024.00	\N	\N
87	2836	2091.66	\N	\N
88	2839	2090.15	\N	\N
89	2840	25.00	\N	\N
90	2842	2090.15	\N	\N
91	2843	25.00	\N	\N
92	2844	2090.15	\N	\N
93	2845	25.00	\N	\N
94	2846	2090.15	\N	\N
95	2847	25.00	\N	\N
96	2848	2090.15	\N	\N
97	2849	0.00	\N	\N
98	2850	2090.15	\N	60
99	2851	0.00	\N	\N
100	2854	2090.15	\N	60
101	2855	0.00	\N	\N
102	2856	2090.15	46	60
103	2857	15.50	47	61
\.


--
-- Name: calculation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('calculation_id_seq', 103, true);


--
-- Data for Name: campaign; Type: TABLE DATA; Schema: public; Owner: -
--

COPY campaign (id, resource_id, name, subject, plain_content, html_content, start_dt, status) FROM stdin;
\.


--
-- Name: campaign_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('campaign_id_seq', 23, true);


--
-- Data for Name: cashflow; Type: TABLE DATA; Schema: public; Owner: -
--

COPY cashflow (id, subaccount_from_id, subaccount_to_id, account_item_id, sum, date, vat) FROM stdin;
216	19	\N	27	500.00	2015-06-14	\N
250	\N	22	16	380.00	2015-06-14	\N
251	22	18	\N	272.00	2015-06-14	20.65
252	\N	21	16	35500.00	2015-06-14	\N
253	21	19	\N	35500.00	2015-06-14	2356.80
254	\N	21	16	5000.00	2015-06-14	\N
255	21	19	\N	5000.00	2015-06-14	2356.80
256	\N	22	16	1400.73	2015-06-13	20.65
257	22	18	\N	1292.73	2015-06-13	\N
258	23	\N	18	15000.00	2015-06-14	\N
259	22	\N	17	108.00	2015-06-14	\N
260	\N	24	16	25000.00	2015-07-22	6856.68
261	24	20	\N	25000.00	2015-07-22	\N
262	\N	25	16	59782.12	2016-01-02	937.77
263	25	19	\N	59782.12	2016-01-02	\N
264	18	26	\N	1600.00	2016-01-02	\N
265	26	\N	18	1600.00	2016-01-02	\N
266	20	27	\N	760.35	2016-01-02	\N
267	27	\N	36	760.35	2016-01-02	\N
\.


--
-- Data for Name: commission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY commission (id, resource_id, service_id, percentage, price, currency_id, descr) FROM stdin;
36	2501	5	12.00	0.00	57	Commission for tours
37	2502	7	10.00	0.00	57	Tickets commission
38	2505	5	12.00	0.00	57	
39	2507	7	10.00	0.00	57	Tickets commission
40	2508	4	2.00	10.00	57	Visa service commission
41	2510	4	10.00	0.00	57	
42	2536	5	12.50	0.00	57	Commission value for tour service
43	2539	5	12.00	0.00	57	Tour commission
44	2546	5	12.00	0.00	57	
45	2693	5	12.00	0.00	57	Tour comission
46	2694	4	0.00	5.00	54	
47	2698	5	11.00	5.00	54	
48	2726	4	0.00	3.00	54	
49	2833	5	8.50	330.00	56	
50	2852	1	0.00	10.00	57	
\.


--
-- Name: commission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('commission_id_seq', 50, true);


--
-- Name: companies_counter; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('companies_counter', 1077, true);


--
-- Name: companies_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('companies_positions_id_seq', 8, true);


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: -
--

COPY company (id, resource_id, name, currency_id, settings, email) FROM stdin;
1	1970	LuxTravel, Inc	56	{"locale": "ru", "timezone": "Europe/Kiev"}	lux.travel@gmai.com
\.


--
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('company_id_seq', 14, true);


--
-- Data for Name: company_subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

COPY company_subaccount (company_id, subaccount_id) FROM stdin;
1	18
1	19
1	20
\.


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contact (id, contact, resource_id, contact_type, descr, status) FROM stdin;
27	+380681983869	1193	0	\N	0
29	+380681983869	1195	0	\N	0
30	+380681983869	1201	0	\N	0
32	+380681983869	1204	0	\N	0
36	+380681983869	1244	0	\N	0
37	+380681983869	1257	0	\N	0
39	+380681983869	1259	0	\N	0
41	+380682523645	1263	0	\N	0
44	+380675625353	1282	0	\N	0
45	+380502355565	1285	0	\N	0
47	+380673566789	1371	0	\N	0
48	+380502314567	1373	0	\N	0
51	+380502232233	1387	0	\N	0
52	+380502354235	1404	0	\N	0
53	+380503435512	1464	0	\N	0
54	+380976543565	1516	0	\N	0
55	+380675643623	1517	0	\N	0
58	+380681983800	1543	0	\N	0
61	+380681234567	1551	0	\N	0
64	+380953434358	1561	0	\N	0
67	+380672568976	1581	0	\N	0
68	+380672346534	1591	0	\N	0
69	+380500567765	1610	0	\N	0
71	+380503435436	1620	0	\N	0
73	+380975642876	1624	0	\N	0
74	+380665638900	1640	0	\N	0
76	+380502235686	1650	0	\N	0
77	+380674523123	1927	0	\N	0
79	+380923435643	2013	0	\N	0
80	+380505674534	2018	0	\N	0
81	+380671238943	2050	0	\N	0
28	asdasd@mail.com	1194	1	\N	0
35	vitalii.mazur@gmail.com	1243	1	\N	0
38	vitalii.mazur@gmail.com	1258	1	\N	0
40	vitalii.mazur@gmail.com	1260	1	\N	0
42	a.koff@gmail.com	1264	1	\N	0
46	n.voevoda@gmail.com	1304	1	\N	0
57	ravak@myemail.com	1519	1	\N	0
60	info@travelcrm.org.ua	1545	1	\N	0
63	i_gonchar@i-tele.com	1559	1	\N	0
65	mega_tkach@ukr.net	1562	1	\N	0
70	artyuh87@gmail.com	1611	1	\N	0
72	grach18@ukr.net	1621	1	\N	0
75	karpuha1990@ukr.net	1641	1	\N	0
78	vitalii.mazur@gmail.com	1956	1	\N	0
49	travelcrm	1379	2	\N	0
56	ravak_skype	1518	2	\N	0
59	dorianyats	1544	2	\N	0
62	serge_vlasov	1552	2	\N	0
50	+380682345688	1380	0	\N	0
82	+380676775643	2089	0	\N	0
83	nikolay1987@mail.ru	2095	1	\N	0
66	AnnaNews	1577	2		1
84	+380672334345	2307	0		0
85	+380503435676	2308	0		1
86	+380674252212	2327	0		0
87	+380678521452	2338	0		0
88	+380502356543	2366	0		0
89	mazira@online.ua	2493	1		0
90	+380661234567	2550	0		1
91	+380500126753	2585	0	New phone	0
92	grisha_1972@mail.ru	2586	1		0
93	grishutka_super	2587	2		0
94	+380973498675	2594	0		0
95	valik_gopko	2659	2		0
96	+380673508989	2666	0		0
97	+380504538765	2676	0		0
98	+380681983869	2814	0		0
99	+380386754543	2821	0		0
\.


--
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('contact_id_seq', 99, true);


--
-- Data for Name: contract; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contract (id, resource_id, date, num, descr, status) FROM stdin;
48	2210	2015-05-09	1234/56	Test contract	0
49	2213	2015-05-09	12345/67	Test agent contract for supplier	0
50	2215	2014-01-10	12/34	First contract	1
51	2489	2015-06-23	19/06		0
52	2490	2015-06-23	19/06		0
54	2506	2015-06-01	36542-89.77		0
55	2511	2015-06-01	678/90		0
53	2491	2015-06-01	19/06/15		0
57	2545	2015-06-01	TUI-09-15		0
58	2695	2015-08-01	#08-01		0
59	2699	2015-07-01	#07-01		0
60	2834	2016-01-01	TT-000139	New Tez Tour Contract	0
56	2540	2015-01-05	0987-97	Contract with teztour	1
61	2853	2016-01-01	TT-00154		0
\.


--
-- Data for Name: contract_commission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contract_commission (contract_id, commission_id) FROM stdin;
52	36
52	37
54	38
54	39
54	40
55	41
53	42
56	43
57	44
58	45
58	46
59	47
59	48
60	49
61	50
\.


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: -
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
21	2270	PL	Poland
\.


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('country_id_seq', 21, true);


--
-- Data for Name: crosspayment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY crosspayment (id, resource_id, cashflow_id, descr) FROM stdin;
10	2465	216	The capital withdraw by CEO
\.


--
-- Name: crosspayment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('crosspayment_id_seq', 10, true);


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: -
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
-- Name: currency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('currency_id_seq', 57, true);


--
-- Data for Name: currency_rate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY currency_rate (id, resource_id, date, currency_id, rate, supplier_id) FROM stdin;
19	2281	2015-05-15	57	23.00	87
20	2289	2015-05-17	57	22.70	102
21	2290	2015-04-29	57	23.05	102
22	2319	2015-06-01	54	24.20	87
23	2334	2015-06-02	57	21.50	93
24	2335	2015-06-02	54	23.65	93
25	2336	2015-06-02	57	21.66	100
26	2337	2015-06-02	54	23.70	100
27	2383	2015-06-06	54	24.30	102
28	2384	2015-06-06	54	24.25	92
29	2385	2015-06-06	57	21.50	92
30	2714	2015-07-22	54	26.37	101
31	2723	2015-07-22	57	23.98	101
33	2841	2016-01-01	54	28.30	87
32	2835	2016-01-01	57	25.70	87
\.


--
-- Name: currency_rate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('currency_rate_id_seq', 33, true);


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: -
--

COPY employee (id, resource_id, first_name, last_name, second_name, itn, dismissal_date, photo_upload_id) FROM stdin;
4	786	Oleg	Pogorelov		\N	\N	\N
8	893	Oleg	Mazur	V.	\N	\N	\N
9	1040	Halyna	Sereda		\N	\N	\N
10	1041	Andrey	Shabanov		\N	\N	\N
11	1042	Dymitrii	Veremeychuk		\N	\N	\N
13	1044	Alexandra	Koff	\N	\N	\N	\N
14	1045	Dima	Shkreba	\N	\N	2013-04-30	\N
15	1046	Viktoriia	Lastovets	\N	\N	2014-04-29	\N
12	1043	Denis	Yurin	\N	12	2014-04-01	\N
30	2053	Igor	Mazur	\N	\N	\N	\N
31	2477	Alina	Kabaeva	\N	344	2015-06-23	\N
2	784	John	Doe	\N	\N	\N	7
7	885	Irina	Mazur	V.	\N	\N	\N
32	2785	Charlize	Theron	\N	\N	\N	\N
\.


--
-- Data for Name: employee_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY employee_address (employee_id, address_id) FROM stdin;
\.


--
-- Data for Name: employee_contact; Type: TABLE DATA; Schema: public; Owner: -
--

COPY employee_contact (employee_id, contact_id) FROM stdin;
13	42
13	41
2	60
2	58
2	59
\.


--
-- Name: employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('employee_id_seq', 32, true);


--
-- Data for Name: employee_notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY employee_notification (employee_id, notification_id, status) FROM stdin;
2	18	1
2	20	1
2	19	1
2	21	1
2	22	1
2	23	1
2	24	1
2	25	1
7	34	0
2	26	1
2	27	1
2	35	0
2	36	0
\.


--
-- Data for Name: employee_passport; Type: TABLE DATA; Schema: public; Owner: -
--

COPY employee_passport (employee_id, passport_id) FROM stdin;
13	7
\.


--
-- Data for Name: employee_subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

COPY employee_subaccount (employee_id, subaccount_id) FROM stdin;
2	1
\.


--
-- Data for Name: employee_upload; Type: TABLE DATA; Schema: public; Owner: -
--

COPY employee_upload (employee_id, upload_id) FROM stdin;
\.


--
-- Name: employees_appointments_h_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('employees_appointments_h_id_seq', 12, true);


--
-- Data for Name: foodcat; Type: TABLE DATA; Schema: public; Owner: -
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
-- Name: foodcat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('foodcat_id_seq', 17, true);


--
-- Data for Name: hotel; Type: TABLE DATA; Schema: public; Owner: -
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
39	2375	5	Radisson Blu Resort & Spa	39
40	2675	4	Frangiorgio Hotel Apartments	40
\.


--
-- Name: hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hotel_id_seq', 40, true);


--
-- Data for Name: hotelcat; Type: TABLE DATA; Schema: public; Owner: -
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
-- Name: hotelcat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('hotelcat_id_seq', 8, true);


--
-- Data for Name: income; Type: TABLE DATA; Schema: public; Owner: -
--

COPY income (id, resource_id, invoice_id, account_item_id, date, sum, descr) FROM stdin;
65	2457	31	16	2015-06-14	380.00	\N
66	2458	30	16	2015-06-14	35500.00	\N
67	2459	30	16	2015-06-14	5000.00	\N
60	2451	31	16	2015-06-13	1400.73	\N
68	2737	32	16	2015-07-22	25000.00	\N
69	2860	33	16	2016-01-02	59782.12	\N
\.


--
-- Data for Name: income_cashflow; Type: TABLE DATA; Schema: public; Owner: -
--

COPY income_cashflow (income_id, cashflow_id) FROM stdin;
65	250
65	251
66	252
66	253
67	254
67	255
60	256
60	257
68	260
68	261
69	262
69	263
\.


--
-- Name: income_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('income_id_seq', 69, true);


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: public; Owner: -
--

COPY invoice (id, date, resource_id, account_id, active_until, order_id, descr) FROM stdin;
32	2015-07-22	2729	2	2015-07-25	10	\N
30	2015-06-06	2388	3	2015-06-09	9	\N
31	2015-06-13	2450	4	2015-06-16	7	\N
33	2016-01-02	2858	3	2016-01-05	11	\N
\.


--
-- Name: invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('invoice_id_seq', 33, true);


--
-- Data for Name: invoice_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY invoice_item (id, invoice_id, price, vat, discount, descr, order_item_id) FROM stdin;
29	30	7290.00	1215.00	0.00	The issues for visas	43
32	32	41245.60	6736.78	824.91	Tour booking service	44
33	32	719.40	119.90	0.00	The issues for visas	45
30	30	57090.00	703.93	2627.25	Tour booking service	42
31	31	1672.73	33.45	0.00	Tour booking service	39
34	33	59110.00	898.86	0.00	Tour booking service	46
35	33	707.50	38.91	35.38	Formulation of foreign passport	47
\.


--
-- Name: invoice_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('invoice_item_id_seq', 35, true);


--
-- Data for Name: lead; Type: TABLE DATA; Schema: public; Owner: -
--

COPY lead (id, lead_date, resource_id, advsource_id, customer_id, status, descr) FROM stdin;
2	2015-02-04	2088	5	46	1	Test lead description
1	2015-02-04	2052	6	47	2	Cant to offer any proposition for customer
3	2015-05-24	2312	4	48	1	\N
4	2015-06-02	2333	2	50	0	\N
5	2015-06-06	2372	6	53	1	\N
6	2015-06-10	2434	6	53	3	\N
7	2015-07-18	2562	4	55	0	\N
8	2015-07-18	2565	6	56	0	\N
9	2015-07-16	2569	2	57	0	\N
10	2015-07-14	2572	6	58	0	\N
11	2015-07-17	2575	6	59	0	\N
12	2015-07-17	2579	2	60	0	\N
13	2015-07-17	2582	6	61	0	\N
14	2015-07-20	2599	6	63	0	\N
15	2015-07-21	2662	6	65	1	\N
16	2015-07-22	2669	2	66	3	\N
17	2016-01-01	2824	6	70	0	\N
\.


--
-- Name: lead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lead_id_seq', 17, true);


--
-- Data for Name: lead_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY lead_item (id, resource_id, lead_id, service_id, currency_id, price_from, price_to, descr) FROM stdin;
1	2293	\N	5	57	\N	3001.00	Tour in Turkey for 2 adult persons and one children for 7 days in 5*
2	2294	\N	4	57	\N	70.00	A visa for Schengen for one person
3	2295	\N	5	57	\N	3000.00	Turkey, 5*, 2 persons adult
4	2297	\N	5	57	\N	2500.00	Turkey, 10 days, 2 persons, 5*
5	2300	2	5	57	\N	2500.00	Turkey, 5*, 2 persons, the middle of Jule, 10 days
6	2305	1	4	\N	\N	\N	Schengen
7	2310	3	5	57	\N	1600.00	For 2 persons into Egypt or Turkey, exelent 4* or 5* with AI, 7 days, in the middle of JUNE
8	2313	3	1	\N	\N	\N	Need a foreign passport for two persons very QUICK!
9	2329	4	5	57	2500.00	3500.00	Turkey, 5* AI, 2 adults and child, Kemer prefered
10	2330	4	4	54	\N	70.00	EU visa for 2 persons
11	2368	5	5	57	2000.00	3000.00	Croatia for 2 persons, 5* on June or July beginings
12	2433	6	5	\N	\N	\N	Turkey or Egypt on the end of July, 5* with UAI for 3 persons
13	2561	7	5	56	\N	20000.00	Turkey, not less than 4* with AI for 2 person on 7 nights
14	2564	8	4	54	\N	50.00	Shengen visas for 2 persons to Poland
15	2567	9	1	\N	\N	\N	Need a foreign passport
16	2568	9	5	57	\N	1500.00	Tour for 2 adult persons to Turkey
17	2571	10	5	57	\N	900.00	Want tour into Bulgary, for single adult person, 7 nights
18	2574	11	5	\N	\N	\N	Odessa tour, 4 days in good hotel
19	2577	12	5	54	\N	2000.00	Kiprus, for 7 nights for 3 persons (2 adults, 1 child), 5* pansionat, near the sea
20	2578	12	4	\N	\N	\N	Shengen to Germany for 2 persons
21	2581	13	1	\N	\N	\N	Foreign Passport for two persons very QUICK
22	2596	14	4	\N	\N	100.00	Shcengen NEEDS!
23	2597	14	7	\N	\N	\N	Kiev - Frankfurt, Avia, 1.08 for single peron business class
24	2598	14	1	\N	\N	\N	Foreign passport for single person and QUICK!
25	2661	15	5	57	\N	2200.00	OAE, 5* not less, UAI, for single person near the sea. Need perfect appartaments with SPA for 5 days
26	2668	16	5	57	1500.00	1700.00	Kiprus from 24.07 to 30.07 for 2 adult persons 4* or more.
27	2823	17	5	56	\N	60000.00	Egypt tour for 2 persons from fubruary begining
\.


--
-- Name: lead_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lead_item_id_seq', 27, true);


--
-- Data for Name: lead_offer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY lead_offer (id, resource_id, lead_id, service_id, currency_id, supplier_id, price, status, descr) FROM stdin;
2	2299	\N	5	57	87	2450.00	0	\N
3	2301	2	5	57	87	2250.00	0	Turkey, 5*, UAI, Kemer, 2 persons, 10 - 20 of Jule
4	2306	1	4	57	90	100.00	2	This price only
5	2331	4	5	57	93	3300.00	1	Turkey Kemer, 5* UAI for 2 persons and child
6	2332	4	4	54	100	65.00	1	for 2 person single visa
7	2369	5	5	56	92	57090.00	1	Radisson Blu Resort & Spa Dubrovnik Sun Gardens 5*, Croatia, Orashac, for 2 persons
9	2437	6	5	57	99	1400.00	1	Egypt, Sharm El Sheih, 5 UAI, 10 days for 2 adult persons and 1 child
8	2435	6	5	57	100	1800.00	2	Turkey Kemer for 7 days with AI for 2 adults and single child. Hotel is uknown this is hot tour with caurosel.\r\n\r\nThis offer was not approved by customer, its too expensive
10	2670	16	5	57	100	1720.00	1	4* pansionat, 2 adult from 24.07 to 30.07
11	2825	17	5	57	87	2300.00	1	Sharm el Sheih from 12.02-19.02
\.


--
-- Name: lead_offer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lead_offer_id_seq', 11, true);


--
-- Name: licence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('licence_id_seq', 61, true);


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: -
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
39	2374	Orashac	38
40	2674	Larnaka	39
\.


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('location_id_seq', 40, true);


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY navigation (id, position_id, parent_id, name, url, icon_cls, sort_order, resource_id, separator_before, action) FROM stdin;
41	5	\N	Home	/	fa fa-home	1	1079	f	\N
47	5	\N	For Test	/	fa fa-credit-card	2	1253	f	\N
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
155	4	53	Payments	/	\N	12	1904	f	\N
157	4	53	Currencies		\N	7	1906	t	\N
42	4	159	Hotels List	/hotels	\N	5	1080	f	\N
43	4	158	Locations	/locations	\N	3	1089	f	\N
50	4	53	Services List	/services	\N	6	1312	f	\N
45	4	53	Banks	/banks	\N	6	1212	f	tab_open
153	4	152	Turnovers	/turnovers	\N	2	1896	f	tab_open
51	4	32	Invoices	/invoices	\N	5	1368	t	tab_open
9	4	8	Resource Types	/resources_types	\N	1	779	f	\N
13	4	10	Employees	/employees	\N	1	790	f	\N
8	4	\N	System	/	fa fa-cog	11	778	f	tab_open
54	4	157	Currencies Rates	/currencies_rates	\N	8	1395	f	\N
55	4	156	Accounts Items	/accounts_items	\N	3	1425	f	\N
56	4	155	Income Payments	/incomes	\N	9	1434	f	\N
57	4	156	Accounts	/accounts	\N	1	1436	f	\N
14	4	10	Employees Appointments	/appointments	\N	2	791	f	\N
174	4	156	Vat Settings	/vats	\N	5	2514	t	tab_open
15	4	8	Users	/users	\N	3	792	f	\N
17	4	157	Currencies List	/currencies	\N	7	802	f	\N
19	4	18	Structures	/structures	\N	1	838	f	\N
20	4	18	Positions	/positions	\N	2	863	f	\N
22	4	21	Persons	/persons	\N	1	866	f	\N
24	4	158	Countries	/countries	\N	4	874	f	\N
25	4	158	Regions	/regions	\N	3	879	f	\N
27	4	26	Advertising Sources	/advsources	\N	1	902	f	\N
28	4	159	Hotels Categories	/hotelcats	\N	6	910	f	\N
29	4	159	Rooms Categories	/roomcats	\N	7	911	f	\N
30	4	159	Accomodations	/accomodations	\N	10	955	f	tab_open
31	4	159	Food Categories	/foodcats	\N	9	956	f	\N
61	4	155	Outgoing Payments	/outgoings	\N	10	1571	f	\N
150	4	156	Subaccounts	/subaccounts	\N	2	1798	f	\N
151	4	155	Cross Payments	/crosspayments	\N	11	1885	f	\N
36	4	23	Business Persons	/bpersons	\N	4	1008	f	tab_open
60	4	23	Suppliers	/suppliers	\N	1	1550	f	tab_open
165	4	8	Company	/companies/edit	\N	4	1975	t	dialog_open
166	4	32	Leads	/leads	\N	2	2048	f	tab_open
168	4	32	Orders	/orders	\N	4	2101	f	tab_open
158	4	23	Geography	/	\N	10	1907	f	\N
159	4	23	Hotels	/	\N	9	1908	t	\N
169	4	23	Transfers	/transfers	\N	5	2128	t	tab_open
170	4	23	Transport	/transports	\N	6	2136	f	tab_open
171	4	23	Suppliers Types	/suppliers_types	\N	3	2219	f	tab_open
172	4	23	Contracts	/contracts	\N	2	2222	f	tab_open
173	4	23	Ticket Class	/tickets_classes	\N	7	2245	f	tab_open
175	4	23	Persons Categories	/persons_categories	\N	8	2552	f	tab_open
182	6	\N	Home	/	fa fa-home	1	2602	f	\N
183	6	\N	Sales	/	fa fa-legal	2	2603	f	\N
184	6	\N	Clientage	/	fa fa-briefcase	3	2604	f	\N
185	6	\N	Marketing	/	fa fa-bullhorn	4	2605	f	\N
188	6	\N	Directories	/	fa fa-book	8	2608	f	\N
192	6	229	Hotels List	/hotels	\N	5	2612	f	\N
193	6	228	Locations	/locations	\N	3	2613	f	\N
197	6	183	Invoices	/invoices	\N	5	2617	t	tab_open
211	6	184	Persons	/persons	\N	1	2631	f	\N
212	6	228	Countries	/countries	\N	4	2632	f	\N
213	6	228	Regions	/regions	\N	3	2633	f	\N
214	6	185	Advertising Sources	/advsources	\N	1	2634	f	\N
215	6	229	Hotels Categories	/hotelcats	\N	6	2635	f	\N
216	6	229	Rooms Categories	/roomcats	\N	7	2636	f	\N
217	6	229	Accomodations	/accomodations	\N	10	2637	f	tab_open
218	6	229	Food Categories	/foodcats	\N	9	2638	f	\N
222	6	188	Business Persons	/bpersons	\N	4	2642	f	tab_open
223	6	188	Suppliers	/suppliers	\N	1	2643	f	tab_open
226	6	183	Leads	/leads	\N	2	2646	f	tab_open
227	6	183	Orders	/orders	\N	4	2647	f	tab_open
228	6	188	Geography	/	\N	10	2648	f	\N
229	6	188	Hotels	/	\N	9	2649	t	\N
230	6	188	Transfers	/transfers	\N	5	2650	t	tab_open
231	6	188	Transport	/transports	\N	6	2651	f	tab_open
232	6	188	Suppliers Types	/suppliers_types	\N	3	2652	f	tab_open
233	6	188	Contracts	/contracts	\N	2	2653	f	tab_open
234	6	188	Ticket Class	/tickets_classes	\N	7	2654	f	tab_open
235	6	188	Persons Categories	/persons_categories	\N	8	2655	f	tab_open
236	4	26	Campaigns	/campaigns	\N	3	2741	t	tab_open
\.


--
-- Data for Name: note; Type: TABLE DATA; Schema: public; Owner: -
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
42	2302	Cant call	\N
43	2370	Very promissed	Very promised client, redy to make business
59	2663	Details contacts	Need to details contacts for this person. He can be perfect VIP client
60	2820	Important	Make this very carefully
61	2826	offer taken	Offer taken by client\r\n
\.


--
-- Name: note_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('note_id_seq', 61, true);


--
-- Data for Name: note_resource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY note_resource (note_id, resource_id) FROM stdin;
3	1797
5	1797
24	1868
29	1470
27	1980
33	970
42	2075
31	2088
32	2052
34	2052
43	2372
35	1413
18	784
28	3
36	2126
59	2662
60	1930
26	1930
61	2824
\.


--
-- Data for Name: note_upload; Type: TABLE DATA; Schema: public; Owner: -
--

COPY note_upload (note_id, upload_id) FROM stdin;
59	17
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notification (id, resource_id, title, descr, created, url) FROM stdin;
3	1945	A reminder of the task #42	Do not forget about task!	2014-12-14 19:51:00.013635+02	\N
4	1946	A reminder of the task #42	Do not forget about task!	2014-12-14 20:31:00.012771+02	\N
5	1947	A reminder of the task #40	Do not forget about task!	2014-12-14 20:32:00.061386+02	\N
6	1948	A reminder of the task #42	Do not forget about task!	2014-12-14 20:34:00.011181+02	\N
7	1949	A reminder of the task #42	Do not forget about task!	2014-12-14 20:35:00.011903+02	\N
8	1950	A reminder of the task #42	Do not forget about task!	2014-12-14 20:38:00.01699+02	\N
9	1959	A reminder of the task #44	Do not forget about task!	2014-12-21 19:21:00.016784+02	\N
10	1961	Task: #44	Test new scheduler realization	2014-12-21 19:44:00.016315+02	\N
11	1963	Task: Test	Test	2014-12-24 21:33:00.014126+02	\N
12	1965	Task: For testing	For testing	2014-12-25 21:06:00.013657+02	\N
13	1972	Task: Check Payments	Check Payments	2015-01-04 12:46:00.019127+02	\N
14	1973	Task: Check Payments	Check Payments	2015-01-04 14:06:00.016859+02	\N
15	1984	Task: Test	Test	2015-01-13 17:01:00.018967+02	\N
16	1986	Task: Test 2	Test 2	2015-01-13 17:04:00.011637+02	\N
17	2010	Task: I decided to try to follow the postgres approach as directly as possible and came up with the following migration.	I decided to try to follow the postgres approach as directly as possible and came up with the following migration.	2015-01-21 21:45:00.013037+02	\N
18	2064	Task: Revert status after testing	Revert status after testing	2015-03-08 18:42:00.01327+02	\N
19	2067	Task: Notifications testing #2	Notifications testing #2	2015-03-09 17:17:00.020674+02	\N
20	2069	Task: Test Notification resource link	Test Notification resource link	2015-03-09 19:29:00.018282+02	\N
21	2076	Task: Call about discounts	Call about discounts	2015-03-21 17:10:00.014771+02	\N
22	2133	Task: Task For Lastovec	Task For Lastovec	2015-04-22 15:40:00.007831+03	\N
23	2198	Task: Check reminder	Check reminder	2015-05-03 13:35:00.039271+03	\N
24	2304	Task: Call about offer	Call about offer	2015-05-24 17:20:00.01303+03	\N
25	2592	Task: JEasyui 1.4.3 migration	JEasyui 1.4.3 migration	2015-07-19 23:55:00.094469+03	\N
26	2672	Task: Call to customer!	Call to customer!	2015-07-22 11:55:00.063723+03	\N
27	2731	Task: Check invoice	Check invoice	2015-07-22 15:20:00.039585+03	\N
29	2779	Your User profile was changed		2015-10-24 14:58:32.749242+03	\N
30	2780	Your User profile was changed		2015-10-24 14:59:57.669772+03	\N
31	2781	Your User profile was changed		2015-10-24 15:00:56.289933+03	\N
32	2782	Your User profile was changed		2015-10-24 15:06:44.559696+03	\N
33	2783	Your User profile was changed		2015-10-24 15:13:07.98256+03	\N
34	2784	Your User profile was changed		2015-10-24 15:16:03.818888+03	\N
35	2817	Test for notifications 2	Test for notifications 2	2015-11-29 18:06:00.016338+02	\N
36	2819	Check for notofications	Check for notofications	2015-11-29 19:07:00.054887+02	\N
\.


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('notification_id_seq', 36, true);


--
-- Data for Name: notification_resource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY notification_resource (notification_id, resource_id) FROM stdin;
20	2068
21	2075
22	2131
23	2197
24	2303
25	2584
26	2671
27	2730
29	2484
30	2484
31	894
32	894
34	894
35	2816
36	2818
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "order" (id, deal_date, resource_id, customer_id, advsource_id, descr, lead_id, status) FROM stdin;
4	2015-05-10	2275	17	4	\N	\N	0
3	2015-05-10	2267	43	5	\N	\N	0
2	2015-05-10	2264	44	6	\N	\N	0
5	2015-04-29	2280	42	1	Test description	\N	0
6	2015-05-16	2284	36	2	\N	\N	0
9	2015-06-06	2382	53	6	\N	5	1
8	2015-06-02	2345	50	2	\N	4	1
10	2015-07-22	2690	66	2	\N	16	1
7	2015-05-26	2317	48	4	For Lead testing	3	3
11	2016-01-02	2831	70	6	\N	17	0
\.


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('order_id_seq', 11, true);


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY order_item (id, resource_id, order_id, service_id, currency_id, price, status, status_date, status_info, supplier_id, discount_sum, discount_percent) FROM stdin;
28	2254	\N	7	57	420.00	0	\N	\N	97	0.00	0.00
29	2256	\N	7	57	420.00	0	\N	\N	97	0.00	0.00
30	2258	\N	7	57	420.00	0	\N	\N	97	0.00	0.00
34	2273	4	4	57	150.00	1	2015-05-10	\N	102	0.00	0.00
33	2265	3	5	57	2400.00	0	\N	\N	94	0.00	0.00
31	2260	2	7	57	422.00	0	\N	\N	97	0.00	0.00
32	2262	2	7	57	387.00	0	\N	\N	97	0.00	0.00
37	2285	\N	5	57	2780.00	1	2015-05-16	\N	87	0.00	0.00
38	2287	\N	7	54	640.00	2	2015-05-16	\N	97	0.00	0.00
36	2282	6	5	57	3201.00	0	2015-05-16	\N	87	0.00	2.00
35	2278	5	1	57	40.00	1	2015-05-10	passport had been received by customer	102	0.00	0.00
40	2341	8	5	57	3300.00	1	2015-06-02	\N	93	0.00	3.00
43	2379	9	4	54	300.00	1	2015-06-06	#678975-HJYT	102	0.00	0.00
42	2377	9	5	56	57090.00	1	2015-06-06	#5677912TY	92	1200.00	2.50
39	2315	7	5	57	1760.00	1	2015-05-26	#878qweiu	87	0.00	0.00
41	2343	8	4	54	130.00	2	2015-06-20	#6509-9	100	0.00	2.00
44	2686	10	5	57	1720.00	1	2015-07-22	BOOKING #: 1239642	101	0.00	2.00
45	2688	10	4	57	30.00	1	2015-07-22	succesfully confirmed	101	0.00	0.00
46	2827	11	5	57	2300.00	1	2016-01-02	TREYW6754-16	87	0.00	0.00
47	2837	11	1	54	25.00	1	2016-02-01	\N	87	0.00	5.00
\.


--
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('order_item_id_seq', 47, true);


--
-- Data for Name: outgoing; Type: TABLE DATA; Schema: public; Owner: -
--

COPY outgoing (id, resource_id, account_item_id, date, subaccount_id, sum, descr) FROM stdin;
13	1903	3	2014-11-18	10	8200.00	\N
16	1915	6	2014-11-23	12	15000.00	\N
23	2467	18	2015-06-14	23	15000.00	\N
21	2463	17	2015-06-14	22	108.00	Test for outgoing cashflows
24	2863	18	2016-01-02	26	1600.00	\N
25	2867	36	2016-01-02	27	760.35	\N
\.


--
-- Data for Name: outgoing_cashflow; Type: TABLE DATA; Schema: public; Owner: -
--

COPY outgoing_cashflow (outgoing_id, cashflow_id) FROM stdin;
23	258
21	259
24	264
24	265
25	266
25	267
\.


--
-- Name: outgoing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('outgoing_id_seq', 25, true);


--
-- Data for Name: passport; Type: TABLE DATA; Schema: public; Owner: -
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
8	3	РМ12345	from Kiev region	1286	2015-06-19	1
26	3	TT6785412	\N	2588	\N	0
27	3	HGTR789123	\N	2589	2015-07-31	1
28	3	TY56241	\N	2677	2018-02-07	1
29	3	YT76811	\N	2680	\N	0
30	3	RT61253	\N	2681	\N	1
31	3	YU678251	\N	2683	\N	0
32	3	TY65142	\N	2685	2018-04-06	1
\.


--
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('passport_id_seq', 32, true);


--
-- Data for Name: passport_upload; Type: TABLE DATA; Schema: public; Owner: -
--

COPY passport_upload (passport_id, upload_id) FROM stdin;
32	20
\.


--
-- Data for Name: permision; Type: TABLE DATA; Schema: public; Owner: -
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
68	1	7	{view}	\N	all
69	2	7	{view,add,edit,delete}	5	structure
70	101	4	{view,add,edit,delete}	\N	all
22	2	4	{view,add,edit,delete}	\N	all
71	102	4	{view,add,edit,delete}	\N	all
73	104	4	{view,add,edit,delete}	\N	all
74	105	4	{view,add,edit,delete}	\N	all
76	107	4	{view,add,edit,delete}	\N	all
79	110	4	{view,add,edit,delete}	\N	all
80	111	4	{view,add,edit,delete}	\N	all
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
120	110	8	{view,add,edit,delete}	\N	all
121	111	8	{view,add,edit,delete}	\N	all
123	12	8	{view,add,edit,delete,settings}	\N	all
128	117	4	{view,add,edit,delete}	\N	all
129	118	4	{view,add,edit,delete}	\N	all
130	119	4	{autoload,view,edit,delete}	\N	all
131	120	4	{view,add,edit,delete}	\N	all
132	121	4	{view}	\N	all
24	12	4	{view,add,edit,delete,settings}	\N	all
134	123	4	{view,close}	\N	all
137	126	4	{view,edit}	\N	all
158	146	4	{view,add,edit,delete}	\N	all
141	130	4	{view,add,edit,delete,order}	\N	all
157	145	4	{view,add,edit,delete}	\N	all
155	144	4	{view,add,edit,delete}	\N	all
154	143	4	{view,add,edit,delete}	\N	all
153	142	4	{view,add,edit,delete}	\N	all
152	141	4	{view,add,edit,delete}	\N	all
151	140	4	{view,add,edit,delete}	\N	all
150	139	4	{view,add,edit,delete}	\N	all
149	138	4	{view,add,edit,delete}	\N	all
148	137	4	{view,add,edit,delete}	\N	all
146	135	4	{view,add,edit,delete}	\N	all
145	134	4	{view,add,edit,delete,calculation,invoice,contract}	\N	all
75	106	4	{view,add,edit,delete}	\N	all
72	103	4	{view,add,edit,delete,settings}	\N	all
160	148	4	{view,add,edit,delete}	\N	all
161	149	4	{view,add,edit,delete}	\N	all
163	151	4	{view,add,edit,delete}	\N	all
164	152	4	{view,settings}	\N	all
165	153	4	{view,settings}	\N	all
233	41	6	{view,add,edit,delete}	\N	all
234	67	6	{view,add,edit,delete}	\N	all
236	39	6	{view,add,edit,delete}	\N	all
237	70	6	{view,add,edit,delete}	\N	all
238	71	6	{view,add,edit,delete}	\N	all
239	72	6	{view,add,edit,delete}	\N	all
240	73	6	{view,add,edit,delete}	\N	all
241	74	6	{view,add,edit,delete}	\N	all
242	75	6	{view,add,edit,delete}	\N	all
244	79	6	{view,add,edit,delete}	\N	all
246	83	6	{view,add,edit,delete}	\N	all
247	84	6	{view,add,edit,delete}	\N	all
249	87	6	{view,add,edit,delete}	\N	all
250	89	6	{view,add,edit,delete}	\N	all
251	90	6	{view,add,edit,delete}	\N	all
253	1	6	{view}	\N	all
254	93	6	{view,add,edit,delete}	\N	all
261	110	6	{view,add,edit,delete}	\N	all
264	118	6	{view,add,edit,delete}	\N	all
267	121	6	{view}	\N	all
269	123	6	{view,close}	\N	all
271	146	6	{view,add,edit,delete}	\N	all
273	145	6	{view,add,edit,delete}	\N	all
274	144	6	{view,add,edit,delete}	\N	all
275	143	6	{view,add,edit,delete}	\N	all
276	142	6	{view,add,edit,delete}	\N	all
282	135	6	{view,add,edit,delete}	\N	all
277	141	6	{view}	\N	all
278	140	6	{view}	\N	all
279	139	6	{view}	\N	all
280	138	6	{view}	\N	all
281	137	6	{view,add,edit,delete}	3	structure
283	134	6	{view,add,edit,delete,calculation,invoice,contract}	3	structure
272	130	6	{view,add,edit,delete,order}	3	structure
270	126	6	{}	\N	all
266	120	6	{}	\N	all
265	119	6	{view,edit,delete}	\N	all
263	117	6	{view}	\N	all
262	111	6	{}	\N	all
260	107	6	{view}	\N	all
285	106	6	{}	\N	all
259	105	6	{}	\N	all
258	104	6	{view}	\N	all
286	103	6	{view,add,edit,delete}	\N	all
257	102	6	{view}	\N	all
255	101	6	{view}	\N	all
252	91	6	{view}	\N	all
248	86	6	{view}	\N	all
243	78	6	{view}	\N	all
229	65	6	{view}	\N	all
230	61	6	{view}	\N	all
231	59	6	{}	\N	all
268	12	6	{}	\N	all
288	149	6	{view,add,edit,delete}	\N	all
256	2	6	{}	\N	all
290	152	6	{view,settings}	\N	all
291	153	6	{view}	\N	all
289	151	6	{view}	\N	all
287	148	6	{view}	\N	all
232	55	6	{view}	\N	all
245	47	6	{view}	\N	all
235	69	6	{view,add,edit,delete}	\N	all
294	156	4	{view,add,edit,delete,settings}	\N	all
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: -
--

COPY person (id, resource_id, first_name, last_name, second_name, birthday, gender, descr, person_category_id, email_subscription, sms_subscription) FROM stdin;
19	1294	Stas	Voevoda		2007-10-16	0	\N	\N	t	\N
24	1390	Igor	Mazur		2007-07-21	0	\N	\N	t	\N
25	1408	Vitalii	Klishunov		1976-04-07	0	\N	\N	t	\N
26	1409	Natalia	Klishunova		1978-08-10	0	\N	\N	t	\N
27	1410	Maxim	Klishunov		2005-02-16	0	\N	\N	t	\N
29	1465	Eugen	Velichko		1982-04-07	0	\N	\N	t	\N
31	1472	Velichko	Alexander		2006-01-11	0	\N	\N	t	\N
33	1586	Roman	Babich		1990-11-14	0	\N	\N	t	\N
36	1616	Nikolay	Artyuh		1986-10-08	0	\N	\N	t	\N
37	1619	Andriy	Garkaviy		1984-11-14	0	\N	\N	t	\N
39	1627	Petro	Garkaviy		2004-06-08	0	\N	\N	t	\N
41	1645	Karpenko	Alexander		1990-06-04	0	\N	\N	t	\N
43	1869	Alexey	Ivankiv	V.	\N	0	\N	\N	t	\N
38	1626	Elena	Garkava		1986-01-08	0	\N	\N	t	\N
22	1383	Vitalii	Mazur		1979-07-17	0	\N	\N	t	\N
44	2017	Sergey	Gavrish		1981-08-05	0	\N	\N	t	\N
18	1293	Irina	Voevoda		1984-01-18	1	\N	\N	t	\N
28	1411	Ann	Klishunova		2013-02-14	1	\N	\N	t	\N
30	1471	Irina	Avdeeva		1984-11-21	1	\N	\N	t	\N
32	1473	Velichko	Elizabeth		2010-06-15	1	\N	\N	t	\N
34	1593	Elena	Babich		1991-05-23	1	\N	\N	t	\N
42	1653	Smichko	Olena		1992-07-15	1	\N	\N	t	\N
40	1628	Alena	Garkava		2007-03-29	1	\N	\N	t	\N
35	1615	Tat'ana	Artyuh		1987-02-10	1	\N	\N	t	\N
45	2020	Anna	Gavrish		1993-11-17	1	\N	\N	t	\N
4	870	Greg	Johnson		\N	0	\N	\N	t	\N
5	871	John	Doe		\N	0	\N	\N	t	\N
46	2051	Nikolay			\N	0	\N	\N	t	\N
23	1389	Iren	Mazur		1979-09-03	1	\N	\N	t	\N
47	2090	Jason		Lewis	\N	0	\N	\N	t	\N
48	2309	Oleg			\N	0	\N	\N	t	\N
49	2314	Anna			\N	1	\N	\N	t	\N
50	2328	Alex	Nikitin		1991-08-14	0	\N	\N	t	\N
51	2339	Julia	Nikitina		1991-12-12	1	\N	\N	t	\N
52	2340	Ivan	Nikitin		2012-02-15	0	\N	\N	t	\N
53	2367	Sergey	Stepanchuk		1984-11-06	0	\N	\N	t	\N
17	1284	Nikolay	Voevoda		1981-07-22	0	\N	\N	t	\N
20	1372	Oleg	Pogorelov		1970-02-17	0	\N	1	t	\N
21	1375	Elena	Pogorelova	Petrovna	1972-02-19	1	\N	\N	t	\N
6	887	Peter	Parker		1976-04-07	0	\N	2	t	\N
54	2376	Nadiya	Gavrilyuk		1988-03-02	1	\N	2	t	\N
55	2560	Vladislav	Potusenko		\N	0	\N	3	t	\N
57	2566	Valik			\N	0	\N	\N	t	\N
58	2570	Jenya	Buryak		\N	1	\N	2	t	\N
59	2573	Vlad	Petchenko		\N	0	\N	3	t	\N
60	2576	Olexiy	Spisovs'kiy		\N	0	\N	\N	t	\N
61	2580	Vlad	Chernyavskiy		\N	0	\N	\N	t	\N
62	2591	Grigoriy	Yarmolenko		1972-10-19	0	\N	3	t	\N
64	2595	Irina			\N	1	\N	\N	t	\N
65	2660	Valentin	Gopko		\N	0	\N	3	t	\N
66	2667	Anatoliy	Fedirko		\N	0	\N	\N	t	\N
68	2679	Yuriy	Fedirko		2012-04-05	0	\N	\N	t	\N
67	2678	Anna	Fedirko		\N	1	\N	\N	t	\N
56	2563	Alex	Saveliev		\N	0	\N	3	t	\N
63	2593	Maria	Fed'ko		1993-05-19	1	\N	3	t	f
69	2739	Vitalii			\N	\N	\N	\N	t	t
70	2822	Pavel	Romanuta		1986-03-28	0	\N	3	f	f
71	2830	Helen	Romanuta		1986-12-12	1	\N	3	f	f
\.


--
-- Data for Name: person_address; Type: TABLE DATA; Schema: public; Owner: -
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
62	35
\.


--
-- Data for Name: person_category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY person_category (id, resource_id, name) FROM stdin;
2	2557	Loyal
1	2556	VIP
3	2559	Uncategoried
\.


--
-- Name: person_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('person_category_id_seq', 3, true);


--
-- Data for Name: person_contact; Type: TABLE DATA; Schema: public; Owner: -
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
48	84
48	85
50	86
51	87
53	88
20	90
62	93
62	91
62	92
64	94
65	95
66	96
67	97
70	99
\.


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('person_id_seq', 71, true);


--
-- Data for Name: person_order_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY person_order_item (order_item_id, person_id) FROM stdin;
33	41
33	43
34	17
37	20
37	21
38	21
38	20
36	36
36	35
35	33
35	42
40	51
40	50
40	52
43	53
43	54
42	53
42	54
39	48
39	49
41	50
41	51
28	44
28	45
29	44
29	45
30	44
30	45
31	44
31	45
32	44
32	45
44	68
44	66
44	67
45	66
45	67
46	70
46	71
47	71
47	70
\.


--
-- Data for Name: person_passport; Type: TABLE DATA; Schema: public; Owner: -
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
62	27
62	26
67	28
66	32
66	31
\.


--
-- Data for Name: person_subaccount; Type: TABLE DATA; Schema: public; Owner: -
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
53	21
48	22
66	24
70	25
\.


--
-- Data for Name: position; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "position" (id, resource_id, structure_id, name) FROM stdin;
4	772	32	Main Developer
5	886	5	Finance Director
6	1249	3	Sales Manager
7	1252	9	Sales Manager
8	1775	1	Main Developer
\.


--
-- Name: positions_navigations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('positions_navigations_id_seq', 236, true);


--
-- Name: positions_permisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('positions_permisions_id_seq', 296, true);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: -
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
38	2373	12	South Dalmacia
39	2673	16	Larnaka
\.


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('region_id_seq', 39, true);


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: -
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
1376	89	32	f
1378	78	32	f
1385	84	32	f
1386	83	32	f
1060	41	32	\N
1068	12	32	\N
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
1464	87	32	f
1465	69	32	f
1467	89	32	f
1468	84	32	f
1469	90	32	f
1470	83	32	f
1471	69	32	f
1472	69	32	f
1473	69	32	f
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
1597	104	32	f
1598	103	32	f
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
1657	103	32	f
1659	65	32	f
1660	106	32	f
1714	110	32	f
1721	110	32	f
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
1910	106	32	f
1911	106	32	f
1913	117	32	f
1915	111	32	f
1917	110	32	f
1918	119	32	f
1919	12	32	f
1922	93	32	f
1924	118	32	f
1925	89	32	f
1926	90	32	f
1927	87	32	f
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
1954	12	32	f
1956	87	32	f
1958	93	32	f
1959	123	32	f
1961	123	32	f
1962	93	32	f
1963	123	32	f
1964	93	32	f
1965	123	32	f
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
2000	103	32	f
2001	106	32	f
2002	106	32	f
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
2023	104	32	f
2024	104	32	f
2026	103	32	f
2027	106	32	f
2028	106	32	f
2029	119	32	f
2030	119	32	f
2031	119	32	f
2032	110	32	f
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
2075	93	32	f
2076	123	32	f
2077	12	32	f
2087	118	32	f
2088	130	32	f
2089	87	32	f
2090	69	32	f
2092	118	32	f
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
2135	12	32	f
2136	65	32	f
2137	139	32	f
2138	139	32	f
2139	139	32	f
2144	135	32	f
2145	137	32	f
2146	135	32	f
2147	137	32	f
2148	135	32	f
2149	137	32	f
2150	135	32	f
2151	137	32	f
2152	135	32	f
2153	137	32	f
2154	135	32	f
2155	137	32	f
2156	135	32	f
2157	137	32	f
2158	135	32	f
2159	137	32	f
2160	135	32	f
2161	137	32	f
2162	135	32	f
2163	137	32	f
2164	135	32	f
2165	137	32	f
2167	135	32	f
2168	137	32	f
2171	93	32	f
2172	135	32	f
2173	137	32	f
2174	135	32	f
2175	137	32	f
2176	135	32	f
2177	137	32	f
2178	135	32	f
2179	137	32	f
2180	135	32	f
2181	137	32	f
2182	135	32	f
2183	137	32	f
2184	135	32	f
2185	137	32	f
2186	134	32	f
2187	135	32	f
2188	137	32	f
2189	135	32	f
2190	137	32	f
2197	93	32	f
2198	123	32	f
2199	105	32	f
2200	104	32	f
2201	104	32	f
2203	104	32	f
2205	110	32	f
2206	110	32	f
2207	110	32	f
2208	110	32	f
2209	110	32	f
2210	86	32	f
2211	110	32	f
2212	110	32	f
2213	86	32	f
2214	110	32	f
2215	86	32	f
2216	78	32	f
2217	12	32	f
2218	140	32	f
2219	65	32	f
2221	140	32	f
2222	65	32	f
2223	78	32	f
2224	78	32	f
2225	78	32	f
2226	78	32	f
2227	78	32	f
2228	78	32	f
2229	78	32	f
2230	78	32	f
2231	78	32	f
2232	78	32	f
2233	78	32	f
2234	78	32	f
2235	78	32	f
2236	78	32	f
2237	78	32	f
2238	78	32	f
2239	78	32	f
2240	78	32	f
2241	78	32	f
2242	78	32	f
2243	12	32	f
2244	12	32	f
2245	65	32	f
2246	105	32	f
2247	102	32	f
2248	141	32	f
2249	141	32	f
2254	135	32	f
2255	142	32	f
2256	135	32	f
2257	142	32	f
2258	135	32	f
2259	142	32	f
2260	135	32	f
2261	142	32	f
2262	135	32	f
2263	142	32	f
2264	134	32	f
2265	135	32	f
2266	137	32	f
2267	134	32	f
2268	12	32	f
2269	105	32	f
2270	70	32	f
2271	140	32	f
2272	78	32	f
2273	135	32	f
2274	143	32	f
2275	134	32	f
2276	12	32	f
2277	105	32	f
2278	135	32	f
2279	144	32	f
2280	134	32	f
2281	104	32	f
2282	135	32	f
2283	137	32	f
2284	134	32	f
2285	135	32	f
2286	137	32	f
2287	135	32	f
2288	142	32	f
2289	104	32	f
2290	104	32	f
2291	93	32	f
2292	12	32	f
2293	145	32	f
2294	145	32	f
2295	145	32	f
2296	12	32	f
2297	145	32	f
2299	146	32	f
2300	145	32	f
2301	146	32	f
2302	118	32	f
2303	93	32	f
2304	123	32	f
2305	145	32	f
2306	146	32	f
2307	87	32	f
2308	87	32	f
2309	69	32	f
2310	145	32	f
2311	93	32	f
2312	130	32	f
2313	145	32	f
2314	69	32	f
2315	135	32	f
2316	137	32	f
2317	134	32	f
2319	104	32	f
2320	12	32	f
2327	87	32	f
2328	69	32	f
2329	145	32	f
2330	145	32	f
2331	146	32	f
2332	146	32	f
2333	130	32	f
2334	104	32	f
2335	104	32	f
2336	104	32	f
2337	104	32	f
2338	87	32	f
2339	69	32	f
2340	69	32	f
2341	135	32	f
2342	137	32	f
2343	135	32	f
2344	143	32	f
2345	134	32	f
2366	87	32	f
2367	69	32	f
2368	145	32	f
2369	146	32	f
2370	118	32	f
2371	93	32	f
2372	130	32	f
2373	39	32	f
2374	84	32	f
2375	83	32	f
2376	69	32	f
2377	135	32	f
2378	137	32	f
2379	135	32	f
2380	143	32	f
2381	93	32	f
2382	134	32	f
2383	104	32	f
2384	104	32	f
2385	104	32	f
2388	103	32	f
2389	105	32	f
2390	105	32	f
2391	105	32	f
2392	105	32	f
2393	105	32	f
2394	105	32	f
2395	105	32	f
2396	105	32	f
2397	105	32	f
2398	105	32	f
2399	105	32	f
2400	105	32	f
2401	105	32	f
2402	105	32	f
2403	105	32	f
2404	105	32	f
2405	105	32	f
2406	105	32	f
2407	105	32	f
2408	105	32	f
2409	105	32	f
2410	105	32	f
2411	105	32	f
2412	105	32	f
2413	105	32	f
2414	105	32	f
2415	105	32	f
2416	105	32	f
2417	105	32	f
2418	105	32	f
2419	105	32	f
2420	105	32	f
2421	105	32	f
2422	105	32	f
2423	105	32	f
2424	105	32	f
2425	105	32	f
2426	105	32	f
2427	105	32	f
2428	105	32	f
2429	105	32	f
2430	105	32	f
2431	105	32	f
2432	105	32	f
2433	145	32	f
2434	130	32	f
2435	146	32	f
2436	93	32	f
2437	146	32	f
2438	117	32	f
2439	117	32	f
2440	117	32	f
2442	117	32	f
2450	103	32	f
2451	106	32	f
2452	117	32	f
2457	106	32	f
2458	106	32	f
2459	106	32	f
2463	111	32	f
2465	120	32	f
2466	117	32	f
2467	111	32	f
2468	119	32	f
2469	119	32	f
2470	119	32	f
2475	90	32	f
2477	47	32	f
2484	2	32	f
2486	101	32	f
2489	86	32	f
2490	86	32	f
2491	86	32	f
2493	87	32	f
2501	110	32	f
2502	110	32	f
2503	119	32	f
2505	110	32	f
2506	86	32	f
2507	110	32	f
2508	110	32	f
2510	110	32	f
2511	86	32	f
2513	12	32	f
2514	65	32	f
2515	148	32	f
2516	12	32	f
2517	149	32	f
2518	149	32	f
2519	47	32	f
2520	149	32	f
2521	149	32	f
2522	149	32	f
2523	149	32	f
2524	149	32	f
2525	149	32	f
2526	149	32	f
2527	149	32	f
2528	149	32	f
2529	119	32	f
2530	119	32	f
2531	119	32	f
2532	119	32	f
2533	119	32	f
2534	119	32	f
2535	119	32	f
2536	110	32	f
2537	119	32	f
2538	119	32	f
2539	110	32	f
2540	86	32	f
2541	119	32	f
2542	148	32	f
2543	148	32	f
2544	148	32	f
2545	86	32	f
2546	110	32	f
2547	119	32	f
2548	119	32	f
2549	12	32	f
2550	87	32	f
2551	12	32	f
2552	65	32	f
2553	65	32	f
2554	65	32	f
2556	151	32	f
2557	151	32	f
2558	12	32	f
2559	151	32	f
2560	69	32	f
2561	145	32	f
2562	130	32	f
2563	69	32	f
2564	145	32	f
2565	130	32	f
2566	69	32	f
2567	145	32	f
2568	145	32	f
2569	130	32	f
2570	69	32	f
2571	145	32	f
2572	130	32	f
2573	69	32	f
2574	145	32	f
2575	130	32	f
2576	69	32	f
2577	145	32	f
2578	145	32	f
2579	130	32	f
2580	69	32	f
2581	145	32	f
2582	130	32	f
2583	12	32	f
2584	93	32	f
2585	87	32	f
2586	87	32	f
2587	87	32	f
2588	89	32	f
2589	89	32	f
2590	90	32	f
2591	69	32	f
2592	123	32	f
2593	69	32	f
2594	87	32	f
2595	69	32	f
2596	145	32	f
2597	145	32	f
2598	145	32	f
2599	130	32	f
2602	65	32	f
2603	65	32	f
2604	65	32	f
2605	65	32	f
2608	65	32	f
2612	65	32	f
2613	65	32	f
2617	65	32	f
2631	65	32	f
2632	65	32	f
2633	65	32	f
2634	65	32	f
2635	65	32	f
2636	65	32	f
2637	65	32	f
2638	65	32	f
2642	65	32	f
2643	65	32	f
2646	65	32	f
2647	65	32	f
2648	65	32	f
2649	65	32	f
2650	65	32	f
2651	65	32	f
2652	65	32	f
2653	65	32	f
2654	65	32	f
2655	65	32	f
2658	67	32	f
2659	87	3	f
2660	69	3	f
2661	145	3	f
2662	130	3	f
2663	118	32	f
2664	149	32	f
2665	149	32	f
2666	87	32	f
2667	69	32	f
2668	145	32	f
2669	130	32	f
2670	146	32	f
2671	93	32	f
2672	123	32	f
2673	39	32	f
2674	84	32	f
2675	83	32	f
2676	87	32	f
2677	89	32	f
2678	69	32	f
2679	69	32	f
2680	89	32	f
2681	89	32	f
2682	149	32	f
2683	89	32	f
2684	149	32	f
2685	89	32	f
2686	135	32	f
2687	137	32	f
2688	135	32	f
2689	143	32	f
2690	134	32	f
2693	110	32	f
2694	110	32	f
2695	86	32	f
2698	110	32	f
2699	86	32	f
2700	119	32	f
2701	119	32	f
2702	119	32	f
2703	119	32	f
2704	119	32	f
2705	119	32	f
2706	119	32	f
2707	119	32	f
2708	119	32	f
2709	119	32	f
2710	119	32	f
2711	119	32	f
2712	119	32	f
2713	119	32	f
2714	104	32	f
2715	119	32	f
2716	119	32	f
2717	119	32	f
2718	119	32	f
2719	119	32	f
2720	119	32	f
2721	119	32	f
2722	119	32	f
2723	104	32	f
2724	119	32	f
2725	119	32	f
2726	110	32	f
2727	119	32	f
2728	119	32	f
2729	103	32	f
2730	93	32	f
2731	123	32	f
2732	148	32	f
2733	148	32	f
2734	119	32	f
2735	119	32	f
2736	119	32	f
2737	106	32	f
2738	117	32	f
2739	69	32	f
2740	12	32	f
2741	65	32	f
2742	12	32	f
2779	123	32	f
2780	123	32	f
2781	123	32	f
2782	123	3	f
2783	123	3	f
2784	123	3	f
2785	47	32	f
2786	2	32	f
2787	2	32	f
2788	12	32	f
2813	12	32	f
2814	87	32	f
2815	93	32	f
2816	93	32	f
2817	123	32	f
2818	93	32	f
2819	123	32	f
2820	118	32	f
2821	87	32	f
2822	69	32	f
2823	145	32	f
2824	130	32	f
2825	146	32	f
2826	118	32	f
2827	135	32	f
2828	137	32	f
2829	93	32	f
2830	69	32	f
2831	134	32	f
2832	119	32	f
2833	110	32	f
2834	86	32	f
2835	104	32	f
2836	119	32	f
2837	135	32	f
2838	144	32	f
2839	119	32	f
2840	119	32	f
2841	104	32	f
2842	119	32	f
2843	119	32	f
2844	119	32	f
2845	119	32	f
2846	119	32	f
2847	119	32	f
2848	119	32	f
2849	119	32	f
2850	119	32	f
2851	119	32	f
2852	110	32	f
2853	86	32	f
2854	119	32	f
2855	119	32	f
2856	119	32	f
2857	119	32	f
2858	103	32	f
2859	148	32	f
2860	106	32	f
2861	117	32	f
2862	117	32	f
2863	111	32	f
2864	140	32	f
2866	117	32	f
2867	111	32	f
2865	78	32	f
\.


--
-- Name: resource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('resource_id_seq', 2867, true);


--
-- Data for Name: resource_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY resource_log (id, resource_id, employee_id, comment, modifydt) FROM stdin;
142	83	2	\N	2013-12-07 16:38:38.11618+02
143	84	2	\N	2013-12-07 16:39:56.788641+02
144	3	2	\N	2013-12-07 16:41:27.65259+02
145	2	2	\N	2013-12-07 16:41:31.748494+02
146	83	2	\N	2013-12-07 16:58:05.802634+02
147	83	2	\N	2013-12-07 17:00:14.544264+02
4836	794	2	\N	2014-02-05 19:54:07.5415+02
5406	1192	2	\N	2014-04-06 19:21:11.278173+03
5407	1005	2	\N	2014-04-06 19:21:55.315341+03
4845	283	2	\N	2014-02-06 11:38:41.090464+02
2	10	2	\N	2013-11-16 19:00:14.24272+02
4	12	2	\N	2013-11-16 19:00:15.497284+02
6	14	2	\N	2013-11-16 19:00:16.696731+02
8	16	2	\N	2013-11-16 19:00:17.960761+02
5427	1204	2	\N	2014-04-09 18:54:09.146902+03
12	30	2	\N	2013-11-23 19:26:00.193553+02
13	30	2	\N	2013-11-23 22:02:37.363677+02
14	10	2	\N	2013-11-23 22:11:01.634598+02
15	30	2	\N	2013-11-23 22:11:14.939938+02
16	30	2	\N	2013-11-23 22:11:38.396085+02
19	30	2	\N	2013-11-24 10:30:59.830287+02
20	30	2	\N	2013-11-24 10:31:22.936737+02
21	30	2	\N	2013-11-24 10:38:08.07328+02
22	30	2	\N	2013-11-24 10:38:10.703187+02
23	30	2	\N	2013-11-24 10:38:11.896934+02
24	30	2	\N	2013-11-24 10:42:19.397852+02
25	30	2	\N	2013-11-24 10:42:50.772172+02
26	30	2	\N	2013-11-24 10:45:56.399572+02
27	30	2	\N	2013-11-24 10:48:29.950669+02
28	30	2	\N	2013-11-24 10:49:23.616693+02
29	30	2	\N	2013-11-24 10:50:05.878643+02
30	30	2	\N	2013-11-24 10:51:02.465585+02
31	30	2	\N	2013-11-24 10:54:21.011765+02
32	30	2	\N	2013-11-24 10:54:28.775552+02
33	30	2	\N	2013-11-24 10:58:34.152869+02
34	30	2	\N	2013-11-24 10:58:36.766104+02
35	30	2	\N	2013-11-24 10:58:38.767749+02
36	30	2	\N	2013-11-24 10:58:42.533162+02
37	30	2	\N	2013-11-24 10:58:43.55758+02
38	30	2	\N	2013-11-24 10:58:47.40587+02
39	30	2	\N	2013-11-24 11:00:56.130675+02
40	30	2	\N	2013-11-24 11:01:17.637578+02
41	30	2	\N	2013-11-24 11:01:20.639413+02
42	30	2	\N	2013-11-24 11:01:25.957588+02
43	30	2	\N	2013-11-24 11:01:28.015301+02
44	30	2	\N	2013-11-24 11:01:49.505153+02
45	30	2	\N	2013-11-24 11:01:54.465064+02
46	30	2	\N	2013-11-24 11:01:56.828797+02
47	30	2	\N	2013-11-24 11:02:00.873006+02
48	30	2	\N	2013-11-24 11:02:06.385907+02
49	30	2	\N	2013-11-24 11:02:08.474309+02
50	30	2	\N	2013-11-24 11:02:11.823259+02
51	30	2	\N	2013-11-24 11:02:15.084044+02
52	30	2	\N	2013-11-24 11:23:59.150304+02
53	30	2	\N	2013-11-24 12:41:22.004561+02
54	30	2	\N	2013-11-24 12:41:27.704243+02
55	30	2	\N	2013-11-24 12:41:32.588516+02
5430	1207	2	\N	2014-04-09 20:43:13.852066+03
5459	1227	2	\N	2014-04-19 13:04:24.512333+03
5467	1230	2	\N	2014-04-23 11:53:28.979784+03
5468	1230	2	\N	2014-04-23 11:53:45.572462+03
5537	1306	2	\N	2014-04-30 11:04:50.581045+03
66	16	2	\N	2013-11-30 12:57:27.26941+02
67	31	2	\N	2013-11-30 14:25:42.040654+02
68	32	2	\N	2013-11-30 14:27:55.708736+02
69	33	2	\N	2013-11-30 14:28:30.596329+02
70	34	2	\N	2013-11-30 14:29:07.205192+02
71	35	2	\N	2013-11-30 14:30:10.653134+02
72	36	2	\N	2013-11-30 14:31:39.751221+02
73	37	2	\N	2013-11-30 14:32:36.035677+02
74	38	2	\N	2013-11-30 14:55:27.691288+02
75	39	2	\N	2013-11-30 14:58:07.249714+02
76	40	2	\N	2013-11-30 14:58:34.364695+02
79	43	2	\N	2013-11-30 15:08:29.574538+02
80	43	2	\N	2013-11-30 15:08:52.114395+02
81	43	2	\N	2013-11-30 15:09:21.51485+02
82	44	2	\N	2013-11-30 15:09:54.961188+02
83	45	2	\N	2013-12-01 13:04:27.697583+02
84	45	2	\N	2013-12-01 13:04:40.716328+02
85	14	2	\N	2013-12-01 14:31:19.374571+02
87	12	2	\N	2013-12-01 18:21:35.266219+02
104	10	2	\N	2013-12-02 20:43:38.334769+02
130	10	2	\N	2013-12-06 21:10:25.807719+02
4796	769	2	\N	2014-01-22 22:21:45.451623+02
4820	16	2	\N	2014-02-01 21:09:43.821944+02
5408	1192	2	\N	2014-04-06 19:22:16.361504+03
5409	1005	2	\N	2014-04-06 19:22:18.74271+03
4822	784	2	\N	2014-02-01 21:23:07.460721+02
4823	786	2	\N	2014-02-01 21:23:12.871915+02
5410	1193	2	\N	2014-04-06 19:30:25.125445+03
5411	1194	2	\N	2014-04-06 19:30:51.85642+03
5412	1195	2	\N	2014-04-06 19:32:30.207073+03
5428	1205	2	\N	2014-04-09 19:17:37.483997+03
5431	1209	2	\N	2014-04-09 20:49:45.884539+03
4843	800	2	\N	2014-02-05 19:58:31.619612+02
4844	801	2	\N	2014-02-05 19:58:49.632624+02
4951	885	2	\N	2014-02-14 21:23:40.101298+02
4952	885	2	\N	2014-02-14 21:25:13.866935+02
4974	849	2	\N	2014-02-23 22:41:46.113064+02
4977	884	2	\N	2014-02-23 22:42:22.595852+02
5143	1003	2	\N	2014-03-04 21:05:09.565466+02
5144	1004	2	\N	2014-03-04 21:08:53.227171+02
5145	1005	2	\N	2014-03-04 21:09:15.542733+02
5471	1240	2	\N	2014-04-26 13:10:19.27836+03
5538	1307	2	\N	2014-04-30 11:08:33.655971+03
5544	1313	2	\N	2014-05-16 22:03:29.897662+03
361	274	2	\N	2013-12-14 17:16:08.962259+02
365	277	2	\N	2013-12-14 18:56:05.189747+02
366	278	2	\N	2013-12-14 18:56:17.77025+02
367	279	2	\N	2013-12-14 18:56:45.919492+02
368	280	2	\N	2013-12-14 19:10:07.617582+02
369	281	2	\N	2013-12-14 19:10:25.311427+02
370	281	2	\N	2013-12-14 19:10:59.35028+02
371	281	2	\N	2013-12-14 19:12:14.211139+02
372	282	2	\N	2013-12-14 19:14:22.861495+02
373	278	2	\N	2013-12-14 19:14:33.853691+02
374	282	2	\N	2013-12-14 19:14:41.964012+02
375	283	2	\N	2013-12-14 19:16:35.738242+02
4882	706	2	\N	2014-02-08 19:59:59.160282+02
377	283	2	\N	2013-12-14 19:18:21.622933+02
4953	886	2	\N	2014-02-14 21:25:53.089098+02
4978	893	2	\N	2014-02-24 11:11:03.613711+02
5147	1004	2	\N	2014-03-04 21:17:22.306545+02
5148	1004	2	\N	2014-03-04 21:23:04.343461+02
386	286	2	\N	2013-12-14 20:46:34.653533+02
387	287	2	\N	2013-12-14 20:46:47.37835+02
388	288	2	\N	2013-12-14 20:47:08.024243+02
389	289	2	\N	2013-12-14 20:47:28.256516+02
390	290	2	\N	2013-12-14 20:52:40.953492+02
391	291	2	\N	2013-12-14 20:53:08.057165+02
392	292	2	\N	2013-12-14 20:53:33.598708+02
5149	1004	2	\N	2014-03-04 21:23:17.093243+02
5150	1004	2	\N	2014-03-04 21:23:25.611509+02
4799	771	2	\N	2014-01-25 16:05:28.799345+02
4800	771	2	\N	2014-01-25 16:05:38.705799+02
4801	772	2	\N	2014-01-25 16:06:28.321244+02
4826	788	2	\N	2014-02-01 22:03:21.899916+02
5151	1004	2	\N	2014-03-04 21:23:52.466966+02
5152	1004	2	\N	2014-03-04 21:24:11.351815+02
5153	1004	2	\N	2014-03-04 21:24:20.614224+02
5429	1206	2	\N	2014-04-09 19:21:09.215561+03
5154	1004	2	\N	2014-03-04 21:35:47.600889+02
5155	1004	2	\N	2014-03-04 21:36:05.835492+02
5156	1004	2	\N	2014-03-04 21:36:16.322673+02
5432	1210	2	\N	2014-04-12 13:10:08.842351+03
5472	1241	2	\N	2014-04-26 19:16:28.009797+03
5539	1308	2	\N	2014-04-30 11:20:34.938154+03
5545	1314	2	\N	2014-05-17 13:42:16.369317+03
422	306	2	\N	2013-12-15 21:45:32.990838+02
4802	773	2	\N	2014-01-25 23:45:37.762081+02
4827	789	2	\N	2014-02-02 16:45:11.830435+02
4954	887	2	\N	2014-02-15 12:32:09.199652+02
5415	1198	2	\N	2014-04-08 09:35:59.21042+03
4979	885	2	\N	2014-02-24 12:50:26.694026+02
4980	786	2	\N	2014-02-24 12:50:29.953348+02
4981	784	2	\N	2014-02-24 12:50:33.322359+02
5157	1004	2	\N	2014-03-07 22:30:15.652582+02
5230	894	2	\N	2014-03-16 11:54:19.683752+02
5231	894	2	\N	2014-03-16 11:54:28.171778+02
5232	894	2	\N	2014-03-16 11:54:33.774318+02
5270	1004	2	\N	2014-03-17 10:50:39.781432+02
5465	1230	2	\N	2014-04-19 21:03:03.225866+03
5508	1277	2	\N	2014-04-29 10:08:17.485661+03
5509	1278	2	\N	2014-04-29 10:09:19.421905+03
5540	1309	2	\N	2014-04-30 11:32:51.070911+03
5547	1316	2	\N	2014-05-17 14:00:25.111543+03
4927	865	2	\N	2014-02-09 13:26:19.008763+02
4804	775	2	\N	2014-01-26 15:30:50.636495+02
4828	3	2	\N	2014-02-02 17:45:50.239397+02
5416	1199	2	\N	2014-04-08 10:15:32.411146+03
5434	1211	2	\N	2014-04-12 14:16:34.33498+03
5435	1211	2	\N	2014-04-12 14:16:53.40729+03
4982	895	2	\N	2014-02-25 19:06:42.158245+02
5158	1007	2	\N	2014-03-08 10:30:25.61786+02
5198	3	2	\N	2014-03-11 13:14:05.142514+02
5233	1060	2	\N	2014-03-16 12:26:38.52955+02
5437	1213	2	\N	2014-04-12 14:32:08.840037+03
5466	1227	2	\N	2014-04-19 21:37:55.580038+03
5474	1243	2	\N	2014-04-26 22:38:44.326007+03
5541	1310	2	\N	2014-04-30 22:45:27.579715+03
5548	1317	2	\N	2014-05-17 14:54:57.813145+03
5549	1318	2	\N	2014-05-17 15:24:32.954365+03
5550	1319	2	\N	2014-05-17 15:53:28.880817+03
5551	1320	2	\N	2014-05-17 15:53:34.139717+03
5552	1321	2	\N	2014-05-17 15:55:03.155317+03
5553	1322	2	\N	2014-05-17 15:55:07.534203+03
5557	1326	2	\N	2014-05-17 15:59:13.891973+03
5558	1327	2	\N	2014-05-17 15:59:17.045556+03
5559	1328	2	\N	2014-05-17 16:00:04.660539+03
5560	1329	2	\N	2014-05-17 16:00:08.901641+03
5561	1330	2	\N	2014-05-17 16:00:10.337355+03
5566	1335	2	\N	2014-05-17 16:02:19.447311+03
5570	1339	2	\N	2014-05-17 16:06:26.675372+03
5571	1340	2	\N	2014-05-17 16:06:28.503991+03
5572	1341	2	\N	2014-05-17 16:06:29.727144+03
5573	1342	2	\N	2014-05-17 16:06:31.81672+03
5574	1343	2	\N	2014-05-17 16:07:44.265465+03
5575	1344	2	\N	2014-05-17 16:07:45.972655+03
5576	1345	2	\N	2014-05-17 16:07:47.259172+03
5577	1346	2	\N	2014-05-17 16:07:49.146563+03
5581	1350	2	\N	2014-05-17 16:09:55.923893+03
5582	1351	2	\N	2014-05-17 16:13:13.017272+03
5583	1352	2	\N	2014-05-17 16:13:14.609527+03
5584	1353	2	\N	2014-05-17 16:13:16.568079+03
5585	1354	2	\N	2014-05-17 16:13:17.732756+03
5370	1159	2	\N	2014-04-02 19:52:15.193771+03
4888	786	2	\N	2014-02-08 21:26:45.138217+02
5417	1200	2	\N	2014-04-08 10:35:59.014802+03
4890	784	2	\N	2014-02-08 21:26:51.98617+02
4929	870	2	\N	2014-02-09 14:57:54.403714+02
4967	892	2	\N	2014-02-22 17:14:02.512772+02
4983	896	2	\N	2014-02-25 19:37:56.226615+02
4984	897	2	\N	2014-02-25 19:38:21.395798+02
4985	898	2	\N	2014-02-25 19:38:30.353048+02
4986	899	2	\N	2014-02-25 19:39:23.588225+02
4988	901	2	\N	2014-02-25 19:47:57.884012+02
5160	1009	2	\N	2014-03-08 10:49:52.0599+02
5199	3	2	\N	2014-03-12 12:05:31.953558+02
5438	1214	2	\N	2014-04-12 14:36:07.046988+03
5475	1244	2	\N	2014-04-26 22:39:00.40778+03
5542	1311	2	\N	2014-04-30 22:45:36.089534+03
5554	1323	2	\N	2014-05-17 15:55:54.008685+03
5555	1324	2	\N	2014-05-17 15:56:55.63522+03
5556	1325	2	\N	2014-05-17 15:58:29.508912+03
5562	1331	2	\N	2014-05-17 16:00:49.21287+03
5563	1332	2	\N	2014-05-17 16:01:46.175183+03
5564	1333	2	\N	2014-05-17 16:01:47.950656+03
5565	1334	2	\N	2014-05-17 16:01:48.837764+03
5567	1336	2	\N	2014-05-17 16:03:41.796945+03
5568	1337	2	\N	2014-05-17 16:04:32.839289+03
5569	1338	2	\N	2014-05-17 16:04:34.363533+03
5578	1347	2	\N	2014-05-17 16:08:39.18466+03
5579	1348	2	\N	2014-05-17 16:08:56.863828+03
5580	1349	2	\N	2014-05-17 16:08:58.291349+03
4894	849	2	\N	2014-02-08 21:32:14.802948+02
4896	851	2	\N	2014-02-08 21:32:32.471247+02
4897	852	2	\N	2014-02-08 21:36:44.493917+02
4930	871	2	\N	2014-02-09 16:04:05.85568+02
4968	892	2	\N	2014-02-22 17:18:17.771894+02
5161	1009	2	\N	2014-03-08 10:52:32.854366+02
5162	1009	2	\N	2014-03-08 10:52:45.635015+02
5163	1009	2	\N	2014-03-08 10:52:53.515357+02
5164	1009	2	\N	2014-03-08 10:52:58.740536+02
5165	1010	2	\N	2014-03-08 10:54:40.946487+02
5166	1010	2	\N	2014-03-08 10:54:50.928085+02
5200	3	2	\N	2014-03-12 12:14:05.203771+02
5235	897	2	\N	2014-03-16 12:53:37.56753+02
5278	1067	2	\N	2014-03-18 19:51:01.87448+02
5375	1164	2	\N	2014-04-02 20:56:42.084197+03
5376	1165	2	\N	2014-04-02 20:56:48.393173+03
5419	1201	2	\N	2014-04-08 10:38:31.154572+03
5440	1214	2	\N	2014-04-12 14:39:05.532456+03
5442	1214	2	\N	2014-04-12 14:43:11.754556+03
5513	1282	2	\N	2014-04-29 10:43:05.718429+03
5586	1355	2	\N	2014-05-17 16:14:39.7443+03
5587	1356	2	\N	2014-05-17 16:14:41.182697+03
5588	1357	2	\N	2014-05-17 16:14:43.239633+03
5590	1359	2	\N	2014-05-17 16:15:43.442935+03
5591	1360	2	\N	2014-05-17 16:15:45.790483+03
5596	1365	2	\N	2014-05-17 16:20:21.389915+03
5597	1366	2	\N	2014-05-17 16:20:22.473385+03
5598	1367	2	\N	2014-05-17 16:20:23.843632+03
4898	853	2	\N	2014-02-08 21:39:09.10029+02
4812	784	2	\N	2014-01-26 21:12:24.209136+02
4813	784	2	\N	2014-01-26 21:13:10.546575+02
4814	784	2	\N	2014-01-26 21:13:20.058093+02
4815	784	2	\N	2014-01-26 21:13:24.693933+02
4817	786	2	\N	2014-01-26 21:15:00.370561+02
4818	784	2	\N	2014-01-26 21:20:14.635984+02
4819	784	2	\N	2014-01-26 21:20:34.941868+02
4931	274	2	\N	2014-02-10 08:49:31.501202+02
4969	893	2	\N	2014-02-22 17:26:37.296722+02
4970	894	2	\N	2014-02-22 17:27:40.771678+02
4991	903	2	\N	2014-02-25 22:43:46.101171+02
4992	904	2	\N	2014-02-25 22:43:53.30222+02
4993	905	2	\N	2014-02-25 22:44:00.024066+02
4994	906	2	\N	2014-02-25 22:44:13.035203+02
4995	907	2	\N	2014-02-25 22:44:59.159297+02
5167	1009	2	\N	2014-03-08 10:57:02.535973+02
5168	1010	2	\N	2014-03-08 10:57:07.365849+02
5201	3	2	\N	2014-03-12 12:29:57.686858+02
5202	3	2	\N	2014-03-12 12:30:07.270368+02
5203	3	2	\N	2014-03-12 12:30:09.982217+02
5204	3	2	\N	2014-03-12 12:32:22.25189+02
5205	894	2	\N	2014-03-12 12:32:26.366205+02
5236	919	2	\N	2014-03-16 13:33:07.651832+02
5444	1218	2	\N	2014-04-12 15:00:38.646853+03
5447	1214	2	\N	2014-04-12 15:02:33.59771+03
5514	1283	2	\N	2014-04-29 12:06:08.689068+03
5515	1284	2	\N	2014-04-29 12:07:06.357367+03
5518	1287	2	\N	2014-04-29 12:09:55.486785+03
5520	1289	2	\N	2014-04-29 12:11:36.874588+03
5589	1358	2	\N	2014-05-17 16:15:09.836615+03
5592	1361	2	\N	2014-05-17 16:16:33.155307+03
5593	1362	2	\N	2014-05-17 16:16:42.585648+03
5594	1363	2	\N	2014-05-17 16:18:45.312153+03
5595	1364	2	\N	2014-05-17 16:18:46.752544+03
4932	872	2	\N	2014-02-10 14:29:53.759164+02
4996	908	2	\N	2014-02-25 23:15:44.304324+02
4997	909	2	\N	2014-02-25 23:16:53.455486+02
5000	912	2	\N	2014-02-25 23:21:05.038132+02
5001	913	2	\N	2014-02-25 23:21:10.720503+02
5002	914	2	\N	2014-02-25 23:21:15.803027+02
5003	915	2	\N	2014-02-25 23:21:21.245593+02
5004	916	2	\N	2014-02-25 23:21:27.843749+02
5005	917	2	\N	2014-02-25 23:21:40.705852+02
5006	918	2	\N	2014-02-25 23:21:45.161533+02
5007	918	2	\N	2014-02-25 23:21:53.74917+02
5008	918	2	\N	2014-02-25 23:21:57.599668+02
5009	919	2	\N	2014-02-25 23:22:22.789803+02
5011	921	2	\N	2014-02-25 23:22:59.534922+02
5012	922	2	\N	2014-02-25 23:23:04.765473+02
5013	923	2	\N	2014-02-25 23:23:16.649188+02
5014	924	2	\N	2014-02-25 23:23:30.151925+02
5015	925	2	\N	2014-02-25 23:25:11.120354+02
5016	926	2	\N	2014-02-25 23:26:11.314153+02
5017	927	2	\N	2014-02-25 23:26:34.378644+02
5018	928	2	\N	2014-02-25 23:26:49.163639+02
5019	929	2	\N	2014-02-25 23:27:07.84413+02
5020	930	2	\N	2014-02-25 23:27:30.797684+02
5021	931	2	\N	2014-02-25 23:27:45.611037+02
5022	932	2	\N	2014-02-25 23:28:05.678992+02
5023	933	2	\N	2014-02-25 23:28:21.001129+02
5025	935	2	\N	2014-02-25 23:28:49.565248+02
5026	936	2	\N	2014-02-25 23:29:05.034117+02
5027	937	2	\N	2014-02-25 23:29:16.11101+02
5028	938	2	\N	2014-02-25 23:29:28.82178+02
5029	939	2	\N	2014-02-25 23:29:41.159219+02
5030	940	2	\N	2014-02-25 23:29:57.589154+02
5031	941	2	\N	2014-02-25 23:30:12.260571+02
5032	942	2	\N	2014-02-25 23:30:25.705958+02
5033	943	2	\N	2014-02-25 23:30:39.278491+02
5034	944	2	\N	2014-02-25 23:30:54.230938+02
5035	945	2	\N	2014-02-25 23:31:08.136642+02
5036	946	2	\N	2014-02-25 23:31:21.084682+02
5037	947	2	\N	2014-02-25 23:31:35.443235+02
5038	948	2	\N	2014-02-25 23:31:50.036032+02
5039	949	2	\N	2014-02-25 23:32:16.232207+02
5040	950	2	\N	2014-02-25 23:32:51.784126+02
5169	1011	2	\N	2014-03-08 15:10:44.638516+02
5206	3	2	\N	2014-03-12 13:00:24.217557+02
5207	3	2	\N	2014-03-12 13:00:34.025605+02
5238	1062	2	\N	2014-03-16 15:10:44.294343+02
5239	1062	2	\N	2014-03-16 15:11:01.269428+02
5240	858	2	\N	2014-03-16 15:11:06.875279+02
5241	903	2	\N	2014-03-16 15:12:25.130202+02
5379	1168	2	\N	2014-04-03 12:39:52.988369+03
5380	1169	2	\N	2014-04-03 12:49:06.139328+03
5448	1221	2	\N	2014-04-12 16:44:14.810824+03
5516	1285	2	\N	2014-04-29 12:08:23.116251+03
5517	1286	2	\N	2014-04-29 12:09:10.712444+03
5522	1291	2	\N	2014-04-29 12:13:37.203069+03
5523	1292	2	\N	2014-04-29 12:14:34.180203+03
4900	854	2	\N	2014-02-08 21:47:34.439997+02
4901	855	2	\N	2014-02-08 21:54:55.399628+02
4936	875	2	\N	2014-02-10 15:58:53.177719+02
4937	875	2	\N	2014-02-10 15:59:03.43204+02
5042	952	2	\N	2014-02-25 23:33:14.57009+02
5043	939	2	\N	2014-02-25 23:33:37.281163+02
5044	938	2	\N	2014-02-25 23:33:44.033176+02
5045	937	2	\N	2014-02-25 23:33:51.697991+02
5046	936	2	\N	2014-02-25 23:33:56.981908+02
5047	935	2	\N	2014-02-25 23:34:03.037741+02
5049	933	2	\N	2014-02-25 23:34:27.937885+02
5050	932	2	\N	2014-02-25 23:34:34.767736+02
5051	931	2	\N	2014-02-25 23:34:39.075165+02
5052	930	2	\N	2014-02-25 23:34:43.896812+02
5053	929	2	\N	2014-02-25 23:34:48.70472+02
5054	928	2	\N	2014-02-25 23:34:54.494127+02
5055	927	2	\N	2014-02-25 23:35:00.125101+02
5056	926	2	\N	2014-02-25 23:35:05.399995+02
5057	925	2	\N	2014-02-25 23:35:10.409443+02
5058	924	2	\N	2014-02-25 23:35:16.447517+02
5059	923	2	\N	2014-02-25 23:35:21.959285+02
5060	922	2	\N	2014-02-25 23:35:27.383937+02
5061	921	2	\N	2014-02-25 23:35:31.660307+02
5063	919	2	\N	2014-02-25 23:35:43.645366+02
5064	918	2	\N	2014-02-25 23:35:47.480218+02
5065	917	2	\N	2014-02-25 23:35:52.042922+02
5066	916	2	\N	2014-02-25 23:35:57.409224+02
5067	915	2	\N	2014-02-25 23:36:01.802966+02
5068	914	2	\N	2014-02-25 23:36:05.670476+02
5069	913	2	\N	2014-02-25 23:36:10.129284+02
5070	912	2	\N	2014-02-25 23:36:14.468359+02
5208	1040	2	\N	2014-03-12 20:50:33.871251+02
5209	1041	2	\N	2014-03-12 20:50:55.466763+02
5210	1041	2	\N	2014-03-12 20:51:02.123714+02
5211	1042	2	\N	2014-03-12 20:53:03.003465+02
5212	1043	2	\N	2014-03-12 20:53:27.910983+02
5213	1044	2	\N	2014-03-12 20:53:45.921718+02
5214	1045	2	\N	2014-03-12 20:54:23.054095+02
5215	1046	2	\N	2014-03-12 20:55:03.071619+02
5286	1078	2	\N	2014-03-20 21:22:51.030666+02
5381	1170	2	\N	2014-04-03 12:49:07.793292+03
5519	1288	2	\N	2014-04-29 12:10:21.572462+03
5521	1290	2	\N	2014-04-29 12:13:35.434847+03
5603	1372	2	\N	2014-05-17 18:47:30.594446+03
5606	1375	2	\N	2014-05-17 18:55:21.896666+03
5613	1382	2	\N	2014-05-17 19:04:51.767284+03
5619	1388	2	\N	2014-05-17 19:09:44.578209+03
5622	1391	2	\N	2014-05-17 19:12:29.996417+03
4902	856	2	\N	2014-02-08 21:59:04.719245+02
4938	876	2	\N	2014-02-10 16:19:24.400952+02
5071	953	2	\N	2014-02-26 23:25:15.548581+02
5072	954	2	\N	2014-02-26 23:25:55.407709+02
5075	957	2	\N	2014-02-26 23:28:34.003373+02
5076	958	2	\N	2014-02-26 23:28:45.594179+02
5077	959	2	\N	2014-02-26 23:28:57.004231+02
5078	960	2	\N	2014-02-26 23:29:08.086342+02
5079	961	2	\N	2014-02-26 23:29:17.646283+02
5080	962	2	\N	2014-02-26 23:29:26.175631+02
5081	963	2	\N	2014-02-26 23:29:35.761623+02
5082	964	2	\N	2014-02-26 23:29:46.892804+02
5083	965	2	\N	2014-02-26 23:29:54.140342+02
5084	966	2	\N	2014-02-26 23:30:01.375033+02
5085	967	2	\N	2014-02-26 23:30:08.774222+02
5086	968	2	\N	2014-02-26 23:30:17.802323+02
5087	969	2	\N	2014-02-26 23:30:29.097872+02
5088	970	2	\N	2014-02-26 23:30:38.081009+02
5089	971	2	\N	2014-02-26 23:30:52.902609+02
5091	973	2	\N	2014-02-26 23:31:31.71567+02
5093	975	2	\N	2014-02-26 23:32:13.646357+02
5094	976	2	\N	2014-02-26 23:32:24.624636+02
5095	977	2	\N	2014-02-26 23:32:34.606814+02
5096	978	2	\N	2014-02-26 23:32:43.318943+02
5097	979	2	\N	2014-02-26 23:32:54.081989+02
5098	980	2	\N	2014-02-26 23:33:04.823892+02
5099	981	2	\N	2014-02-26 23:33:16.574818+02
5100	982	2	\N	2014-02-26 23:33:28.270884+02
5101	983	2	\N	2014-02-26 23:33:40.854578+02
5102	984	2	\N	2014-02-26 23:33:57.05943+02
5103	985	2	\N	2014-02-26 23:34:08.238483+02
5105	987	2	\N	2014-02-26 23:34:29.757456+02
5106	988	2	\N	2014-02-26 23:34:37.99873+02
5216	3	2	\N	2014-03-12 21:55:10.706584+02
5287	1079	2	\N	2014-03-22 12:57:07.526655+02
5480	1249	2	\N	2014-04-27 01:02:16.23036+03
5481	1250	2	\N	2014-04-27 01:02:43.699513+03
5482	1251	2	\N	2014-04-27 01:03:00.011092+03
5483	1252	2	\N	2014-04-27 01:03:22.219667+03
5524	1293	2	\N	2014-04-29 12:17:51.658135+03
5525	1294	2	\N	2014-04-29 12:18:27.913053+03
5601	1370	2	\N	2014-05-17 18:45:54.451262+03
5602	1371	2	\N	2014-05-17 18:47:17.628356+03
5604	1373	2	\N	2014-05-17 18:54:01.477094+03
5607	1376	2	\N	2014-05-17 18:56:40.07768+03
5609	1378	2	\N	2014-05-17 19:02:40.402053+03
5616	1385	2	\N	2014-05-17 19:07:13.667811+03
5617	1386	2	\N	2014-05-17 19:07:36.068126+03
5621	1390	2	\N	2014-05-17 19:11:55.084234+03
4789	763	2	\N	2014-01-12 19:51:49.157909+02
4903	854	2	\N	2014-02-08 22:16:58.906498+02
4904	3	2	\N	2014-02-08 22:17:06.939369+02
4905	854	2	\N	2014-02-08 22:20:32.280238+02
4906	784	2	\N	2014-02-08 22:21:01.290541+02
4908	786	2	\N	2014-02-08 22:21:09.110319+02
5484	1253	2	\N	2014-04-28 00:03:49.599015+03
5289	1081	2	\N	2014-03-22 17:57:05.076581+02
5605	1374	2	\N	2014-05-17 18:55:03.070735+03
5611	1380	2	\N	2014-05-17 19:03:57.212913+03
5614	1383	2	\N	2014-05-17 19:04:59.867959+03
5618	1387	2	\N	2014-05-17 19:09:22.594353+03
5624	1393	2	\N	2014-05-18 10:14:28.009945+03
4790	764	2	\N	2014-01-12 20:33:53.3138+02
4909	723	2	\N	2014-02-08 22:28:37.868751+02
4940	878	2	\N	2014-02-10 16:40:47.442615+02
5610	1379	2	\N	2014-05-17 19:03:38.443538+03
5612	1381	2	\N	2014-05-17 19:04:17.238286+03
5615	1384	2	\N	2014-05-17 19:07:10.869783+03
5620	1389	2	\N	2014-05-17 19:09:47.55779+03
4910	857	2	\N	2014-02-09 00:41:07.487567+02
4911	858	2	\N	2014-02-09 00:41:26.234037+02
4912	859	2	\N	2014-02-09 00:41:48.428505+02
4913	860	2	\N	2014-02-09 00:42:12.938208+02
4914	857	2	\N	2014-02-09 00:42:31.066281+02
4915	861	2	\N	2014-02-09 00:42:52.234296+02
5291	1088	2	\N	2014-03-22 18:51:18.985681+02
5292	1081	2	\N	2014-03-22 18:51:44.158872+02
5458	1225	2	\N	2014-04-13 12:01:26.796233+03
5627	1396	2	\N	2014-05-18 11:58:47.293591+03
4917	764	2	\N	2014-02-09 00:53:58.264629+02
4918	769	2	\N	2014-02-09 00:57:04.796409+02
4919	775	2	\N	2014-02-09 00:57:24.917548+02
4920	788	2	\N	2014-02-09 00:57:42.02056+02
4942	878	2	\N	2014-02-10 22:47:18.374976+02
4943	880	2	\N	2014-02-10 22:48:37.279277+02
4944	881	2	\N	2014-02-10 22:49:24.829434+02
4945	882	2	\N	2014-02-10 22:49:56.066237+02
4946	883	2	\N	2014-02-10 22:50:06.121122+02
4947	884	2	\N	2014-02-10 22:50:26.035905+02
4948	884	2	\N	2014-02-10 22:53:06.689693+02
5294	1090	2	\N	2014-03-22 20:34:50.666418+02
5295	1091	2	\N	2014-03-22 20:36:11.95663+02
5298	1093	2	\N	2014-03-22 20:40:16.040605+02
5629	1398	2	\N	2014-05-18 12:12:21.975254+03
4949	764	2	\N	2014-02-11 19:47:14.055452+02
5488	1257	2	\N	2014-04-28 12:34:34.363475+03
5300	1095	2	\N	2014-03-22 20:52:34.596466+02
5301	1096	2	\N	2014-03-22 20:52:44.740475+02
5302	1097	2	\N	2014-03-22 20:53:03.099066+02
5489	1258	2	\N	2014-04-28 12:34:55.433659+03
5304	1099	2	\N	2014-03-22 20:57:07.889521+02
5535	1304	2	\N	2014-04-29 16:15:23.221696+03
5389	1178	2	\N	2014-04-05 19:40:06.274566+03
5390	1179	2	\N	2014-04-05 19:40:10.823684+03
5490	1259	2	\N	2014-04-28 12:58:44.196537+03
5305	1100	2	\N	2014-03-22 21:00:41.76813+02
5306	1101	2	\N	2014-03-22 21:00:48.529148+02
5307	1102	2	\N	2014-03-22 21:01:34.517288+02
5491	1260	2	\N	2014-04-28 12:59:00.104464+03
5631	1400	2	\N	2014-05-18 13:37:21.801854+03
5632	1401	2	\N	2014-05-18 13:37:41.402585+03
5633	1402	2	\N	2014-05-18 13:44:45.628784+03
5492	1261	2	\N	2014-04-28 13:04:58.29173+03
5634	1403	2	\N	2014-05-18 15:48:34.956287+03
5256	1067	2	\N	2014-03-16 19:34:31.935568+02
5494	1263	2	\N	2014-04-28 13:08:06.602496+03
5635	1404	2	\N	2014-05-18 19:18:07.615122+03
5636	1406	2	\N	2014-05-18 19:18:56.831097+03
5639	1409	2	\N	2014-05-18 19:22:05.971396+03
5394	1185	2	\N	2014-04-05 20:56:20.797318+03
5257	1067	2	\N	2014-03-16 19:55:56.894484+02
5495	1264	2	\N	2014-04-28 13:08:25.610345+03
5637	1407	2	\N	2014-05-18 19:19:36.399614+03
5641	1411	2	\N	2014-05-18 19:23:45.119721+03
5496	1265	2	\N	2014-04-28 13:08:54.519921+03
5638	1408	2	\N	2014-05-18 19:19:43.401474+03
5258	1067	2	\N	2014-03-16 20:09:16.532934+02
5311	1097	2	\N	2014-03-24 19:59:44.290142+02
5640	1410	2	\N	2014-05-18 19:23:00.415796+03
5643	1413	2	\N	2014-05-20 21:26:27.311927+03
5259	1068	2	\N	2014-03-16 20:15:31.769185+02
5499	1268	2	\N	2014-04-28 23:55:09.591646+03
5644	1414	2	\N	2014-05-24 17:02:57.354915+03
5645	1415	2	\N	2014-05-24 17:03:02.922541+03
5646	1416	2	\N	2014-05-24 17:06:48.542492+03
5647	1417	2	\N	2014-05-24 17:06:51.402853+03
5648	1418	2	\N	2014-05-24 17:07:25.101929+03
5649	1419	2	\N	2014-05-24 17:07:29.075778+03
5650	1420	2	\N	2014-05-24 17:24:17.546972+03
4120	16	2	\N	2014-01-01 13:19:09.979922+02
4131	14	2	\N	2014-01-01 18:45:07.902745+02
4144	706	2	\N	2014-01-03 16:12:41.015146+02
4145	706	2	\N	2014-01-03 16:13:23.197097+02
5402	1189	2	\N	2014-04-06 18:46:40.132797+03
5403	1190	2	\N	2014-04-06 18:47:22.030146+03
5138	865	2	\N	2014-03-03 21:09:34.254642+02
5404	1191	2	\N	2014-04-06 18:53:34.002074+03
5263	1009	2	\N	2014-03-16 21:40:10.728496+02
5264	1009	2	\N	2014-03-16 21:44:11.742442+02
5405	1192	2	\N	2014-04-06 19:20:55.890208+03
5140	865	2	\N	2014-03-03 21:57:11.59945+02
5265	1004	2	\N	2014-03-17 10:29:17.115979+02
5266	1004	2	\N	2014-03-17 10:29:24.701637+02
4744	723	2	\N	2014-01-04 23:58:55.624453+02
4746	725	2	\N	2014-01-05 01:09:00.405742+02
4747	726	2	\N	2014-01-05 01:09:15.602018+02
4749	728	2	\N	2014-01-05 01:13:50.125212+02
4756	734	2	\N	2014-01-05 12:36:48.48575+02
4765	743	2	\N	2014-01-05 13:20:17.173661+02
5654	1424	2	\N	2014-06-01 10:25:44.71461+03
5656	1426	2	\N	2014-06-01 12:15:53.295347+03
5661	1431	2	\N	2014-06-07 15:12:11.693366+03
5662	1432	2	\N	2014-06-07 15:12:40.323386+03
5663	1433	2	\N	2014-06-07 17:43:14.620483+03
5665	1435	2	\N	2014-06-07 21:01:18.691193+03
5667	1438	2	\N	2014-06-07 21:11:01.089928+03
5668	1439	2	\N	2014-06-07 21:11:46.797584+03
5669	1440	2	\N	2014-06-07 22:15:09.567299+03
5671	1442	2	\N	2014-06-07 22:16:04.586659+03
5676	1447	2	\N	2014-06-08 21:25:14.638119+03
5677	1448	2	\N	2014-06-08 21:25:35.09515+03
5679	1450	2	\N	2014-06-09 15:50:23.760428+03
5681	1452	2	\N	2014-06-09 17:20:44.311452+03
5693	1464	2	\N	2014-06-14 17:55:00.252916+03
5694	1465	2	\N	2014-06-14 17:55:08.213215+03
5695	1467	2	\N	2014-06-14 17:56:52.935007+03
5696	1468	2	\N	2014-06-14 17:58:15.339465+03
5697	1469	2	\N	2014-06-14 17:58:37.034547+03
5698	1470	2	\N	2014-06-14 18:00:56.71432+03
5699	1471	2	\N	2014-06-14 18:02:10.63169+03
5700	1472	2	\N	2014-06-14 18:02:54.98084+03
5701	1473	2	\N	2014-06-14 18:03:27.411198+03
5713	1485	2	\N	2014-06-15 15:17:28.256792+03
5715	1487	2	\N	2014-06-16 14:42:17.062016+03
5728	1500	2	\N	2014-06-18 16:59:05.631362+03
5730	1502	2	\N	2014-06-22 19:40:05.464875+03
5731	1503	2	\N	2014-06-22 19:40:20.79663+03
5732	1504	2	\N	2014-06-22 19:42:44.939368+03
5733	1505	2	\N	2014-06-22 19:43:05.103699+03
5734	1506	2	\N	2014-06-22 19:43:23.157992+03
5735	1507	2	\N	2014-06-22 19:46:21.388635+03
5737	1509	2	\N	2014-06-22 21:15:50.586549+03
5738	1510	2	\N	2014-06-24 20:30:44.36129+03
5739	1511	2	\N	2014-06-25 19:21:08.001771+03
5740	1512	2	\N	2014-06-25 19:37:43.544622+03
5741	1513	2	\N	2014-06-25 19:38:23.293423+03
5742	1514	2	\N	2014-06-25 19:38:46.712804+03
5743	1515	2	\N	2014-06-25 19:39:14.757449+03
5744	1516	2	\N	2014-06-25 20:37:42.602785+03
5745	1517	2	\N	2014-06-25 20:54:09.96009+03
5746	1518	2	\N	2014-06-25 20:54:50.943042+03
5747	1519	2	\N	2014-06-25 20:55:06.988343+03
5749	1521	2	\N	2014-06-26 21:02:19.488826+03
5750	1535	2	\N	2014-06-28 17:17:15.295903+03
5751	1536	2	\N	2014-06-28 17:31:39.626186+03
5752	1537	2	\N	2014-06-28 20:56:05.816704+03
5753	1538	2	\N	2014-06-28 20:57:41.600837+03
5754	1539	2	\N	2014-06-28 20:59:59.522314+03
5755	1540	2	\N	2014-06-28 21:00:26.365557+03
5756	1541	2	\N	2014-06-28 21:00:51.086753+03
5757	1542	2	\N	2014-06-28 21:18:20.602573+03
5758	1543	2	\N	2014-06-28 21:25:57.336069+03
5759	1544	2	\N	2014-06-28 21:26:14.894807+03
5760	1545	2	\N	2014-06-28 21:26:35.413657+03
5761	1546	2	\N	2014-07-02 23:01:03.321441+03
5762	1547	2	\N	2014-07-02 23:03:30.755887+03
5763	1548	2	\N	2014-07-26 18:07:46.336433+03
5764	1549	2	\N	2014-08-16 20:09:11.73959+03
5766	1551	2	\N	2014-08-16 20:23:59.980051+03
5767	1552	2	\N	2014-08-16 20:24:12.305446+03
5768	1553	2	\N	2014-08-16 20:24:15.930016+03
5769	1554	2	\N	2014-08-16 20:25:09.403552+03
5771	1556	2	\N	2014-08-16 20:51:19.103778+03
5773	1559	2	\N	2014-08-16 21:13:14.302214+03
5774	1560	2	\N	2014-08-16 21:13:18.107616+03
5775	1561	2	\N	2014-08-16 21:22:35.752473+03
5776	1562	2	\N	2014-08-16 21:23:02.397566+03
5777	1563	2	\N	2014-08-16 21:23:05.499294+03
5778	1564	2	\N	2014-08-16 21:24:08.813965+03
5783	1569	2	\N	2014-08-17 11:07:53.713228+03
5784	1570	2	\N	2014-08-17 11:09:10.292392+03
5790	1576	2	\N	2014-08-22 22:48:58.176695+03
5791	1577	2	\N	2014-08-22 22:49:31.584667+03
5792	1578	2	\N	2014-08-22 22:49:35.101959+03
5793	1579	2	\N	2014-08-22 22:50:20.197271+03
5794	1580	2	\N	2014-08-22 22:50:49.188036+03
5795	1581	2	\N	2014-08-22 22:51:29.357367+03
5796	1582	2	\N	2014-08-22 22:52:03.171722+03
5797	1584	2	\N	2014-08-22 22:58:38.326467+03
5798	1585	2	\N	2014-08-22 22:59:28.534906+03
5799	1586	2	\N	2014-08-22 22:59:41.71816+03
5800	1587	2	\N	2014-08-22 23:01:39.676197+03
5801	1588	2	\N	2014-08-22 23:02:11.872661+03
5802	1589	2	\N	2014-08-22 23:04:10.670971+03
5803	1590	2	\N	2014-08-22 23:04:40.181387+03
5804	1591	2	\N	2014-08-22 23:05:46.128053+03
5805	1592	2	\N	2014-08-22 23:06:07.780481+03
5806	1593	2	\N	2014-08-22 23:06:12.342153+03
5810	1597	2	\N	2014-08-22 23:14:17.280337+03
5811	1598	2	\N	2014-08-22 23:35:58.491964+03
5820	1607	2	\N	2014-08-23 13:37:30.044239+03
5821	1608	2	\N	2014-08-23 16:14:22.910225+03
5822	1609	2	\N	2014-08-23 16:16:24.823791+03
5823	1610	2	\N	2014-08-24 14:10:51.002759+03
5824	1611	2	\N	2014-08-24 14:11:19.783792+03
5825	1612	2	\N	2014-08-24 14:11:36.729128+03
5826	1613	2	\N	2014-08-24 14:11:54.849623+03
5827	1614	2	\N	2014-08-24 14:48:54.04485+03
5828	1615	2	\N	2014-08-24 14:48:55.715304+03
5829	1616	2	\N	2014-08-24 14:49:59.373945+03
5832	1619	2	\N	2014-08-24 15:01:16.140346+03
5833	1620	2	\N	2014-08-24 15:02:15.884894+03
5834	1621	2	\N	2014-08-24 15:02:43.162974+03
5835	1622	2	\N	2014-08-24 15:03:06.67481+03
5836	1623	2	\N	2014-08-24 15:03:53.276198+03
5837	1624	2	\N	2014-08-24 15:08:02.737031+03
5838	1625	2	\N	2014-08-24 15:08:18.61161+03
5839	1626	2	\N	2014-08-24 15:08:29.0077+03
5840	1627	2	\N	2014-08-24 15:10:13.736496+03
5841	1628	2	\N	2014-08-24 15:10:44.233145+03
5847	1634	2	\N	2014-08-24 15:21:09.48427+03
5852	1639	2	\N	2014-08-25 15:20:24.884947+03
5853	1640	2	\N	2014-08-26 19:55:53.569882+03
5854	1641	2	\N	2014-08-26 19:56:28.320221+03
5858	1645	2	\N	2014-08-26 20:01:19.187139+03
5860	1647	2	\N	2014-08-26 20:04:08.078366+03
5862	1649	2	\N	2014-08-26 20:04:48.124422+03
5855	1642	2	\N	2014-08-26 19:56:46.695581+03
5856	1643	2	\N	2014-08-26 19:57:13.160198+03
5857	1644	2	\N	2014-08-26 20:01:16.129984+03
5859	1646	2	\N	2014-08-26 20:04:06.105786+03
5861	1648	2	\N	2014-08-26 20:04:09.378364+03
5863	1650	2	\N	2014-08-26 20:06:13.193356+03
5864	1651	2	\N	2014-08-26 20:06:36.249641+03
5865	1652	2	\N	2014-08-26 20:07:23.412381+03
5866	1653	2	\N	2014-08-26 20:07:31.899383+03
5870	1657	2	\N	2014-08-26 20:13:28.887297+03
5873	1660	2	\N	2014-08-31 16:37:37.888486+03
5919	1714	2	\N	2014-09-14 13:27:15.677766+03
5926	1721	2	\N	2014-09-14 14:49:51.512979+03
5967	1764	2	\N	2014-09-14 21:51:09.963908+03
5968	1766	2	\N	2014-09-28 17:08:27.946698+03
5971	1769	2	\N	2014-10-01 20:37:18.107894+03
5972	1771	2	\N	2014-10-01 21:39:17.299667+03
5973	1773	2	\N	2014-10-01 22:04:03.074823+03
5974	1774	2	\N	2014-10-01 22:17:44.949656+03
5975	1775	2	\N	2014-10-03 20:21:54.06353+03
5977	1777	2	\N	2014-10-03 20:35:01.628264+03
5978	1778	2	\N	2014-10-04 21:45:17.702702+03
5980	1780	2	\N	2014-10-05 12:49:28.270538+03
5982	1797	2	\N	2014-10-05 21:08:02.025119+03
5983	1798	2	\N	2014-10-05 22:07:40.176836+03
5984	1799	2	\N	2014-10-09 20:49:57.476724+03
5985	1800	2	\N	2014-10-09 21:44:48.304991+03
5986	1801	2	\N	2014-10-09 21:45:57.042916+03
5987	1802	2	\N	2014-10-09 21:51:36.274928+03
5988	1797	2	\N	2014-10-09 21:58:44.274487+03
5989	1803	2	\N	2014-10-10 21:20:08.467997+03
5990	1804	2	\N	2014-10-10 21:48:32.795064+03
5991	1797	2	\N	2014-10-10 21:48:40.224687+03
5994	1797	2	\N	2014-10-10 22:43:03.886027+03
5995	1807	2	\N	2014-10-12 12:18:58.609492+03
5996	1419	2	\N	2014-10-12 12:21:41.297126+03
5999	1419	2	\N	2014-10-12 14:03:13.921521+03
6000	1419	2	\N	2014-10-12 14:03:56.458732+03
6002	1797	2	\N	2014-10-12 14:08:19.225786+03
6003	1797	2	\N	2014-10-12 14:08:29.322661+03
6005	1797	2	\N	2014-10-12 14:09:47.667654+03
6006	1797	2	\N	2014-10-12 14:10:15.511498+03
6008	894	2	\N	2014-10-12 14:15:30.839116+03
6010	894	2	\N	2014-10-12 14:15:50.178579+03
6011	894	2	\N	2014-10-12 14:16:00.712168+03
6014	1507	2	\N	2014-10-12 14:21:53.792753+03
6015	1507	2	\N	2014-10-12 14:22:06.118134+03
6016	1439	2	\N	2014-10-12 14:22:17.008412+03
6017	1438	2	\N	2014-10-12 14:22:21.965321+03
6020	1780	2	\N	2014-10-12 14:25:19.014258+03
6021	1780	2	\N	2014-10-12 14:25:28.403238+03
6022	1780	2	\N	2014-10-12 14:25:37.930302+03
6025	1413	2	\N	2014-10-12 14:31:06.237149+03
6026	1413	2	\N	2014-10-12 14:31:16.507549+03
6029	1415	2	\N	2014-10-12 14:34:22.672887+03
6030	1415	2	\N	2014-10-12 14:34:32.05391+03
6043	1657	2	\N	2014-10-12 15:41:58.778177+03
6045	1657	2	\N	2014-10-12 15:42:13.36551+03
6046	1657	2	\N	2014-10-12 15:42:24.726059+03
6050	1653	2	\N	2014-10-12 16:27:20.425954+03
6051	1653	2	\N	2014-10-12 16:27:45.783221+03
6053	1283	2	\N	2014-10-12 16:28:08.925372+03
6054	1283	2	\N	2014-10-12 16:28:17.376186+03
6055	1833	2	\N	2014-10-12 16:29:10.045595+03
6056	784	2	\N	2014-10-12 16:29:11.936722+03
6061	1542	2	\N	2014-10-12 17:31:06.178463+03
6063	861	2	\N	2014-10-12 20:54:52.692696+03
6064	861	2	\N	2014-10-12 20:55:02.552131+03
6066	998	2	\N	2014-10-18 11:46:31.67705+03
6075	1657	2	\N	2014-10-18 23:25:55.139592+03
6076	1657	2	\N	2014-10-18 23:26:04.397861+03
6077	1839	2	\N	2014-10-18 23:26:44.642232+03
6078	1634	2	\N	2014-10-18 23:26:52.975425+03
6079	1598	2	\N	2014-10-18 23:27:05.648811+03
6080	1502	2	\N	2014-10-18 23:27:11.743763+03
6081	1503	2	\N	2014-10-18 23:27:18.622533+03
6082	1440	2	\N	2014-10-18 23:27:25.765119+03
6083	1442	2	\N	2014-10-18 23:27:32.509568+03
6084	1840	2	\N	2014-10-18 23:35:01.43267+03
6114	1598	2	\N	2014-10-25 20:24:45.191774+03
6115	1840	2	\N	2014-10-25 20:25:16.419372+03
6116	1839	2	\N	2014-10-25 20:25:25.421645+03
6117	1657	2	\N	2014-10-25 20:25:34.041679+03
6118	1634	2	\N	2014-10-25 20:25:41.778509+03
6119	1598	2	\N	2014-10-25 20:25:49.974159+03
6120	1503	2	\N	2014-10-25 20:25:56.790041+03
6121	1502	2	\N	2014-10-25 20:26:11.552957+03
6122	1487	2	\N	2014-10-25 20:26:20.033323+03
6123	1442	2	\N	2014-10-25 20:26:26.124436+03
6124	1440	2	\N	2014-10-25 20:26:33.450119+03
6125	1660	2	\N	2014-10-25 20:27:51.453322+03
6126	1639	2	\N	2014-10-25 20:27:59.032748+03
6127	1607	2	\N	2014-10-25 20:28:26.48561+03
6128	1547	2	\N	2014-10-25 20:31:18.593123+03
6129	1546	2	\N	2014-10-25 20:31:27.322575+03
6130	1509	2	\N	2014-10-25 20:31:34.596003+03
6131	1500	2	\N	2014-10-25 20:31:41.235636+03
6132	1485	2	\N	2014-10-25 20:31:48.295128+03
6133	1448	2	\N	2014-10-25 20:31:55.364673+03
6134	1447	2	\N	2014-10-25 20:32:03.232605+03
6135	864	2	\N	2014-10-25 22:27:41.085522+03
6136	900	2	\N	2014-10-25 22:27:48.659618+03
6137	780	2	\N	2014-10-25 22:27:56.462817+03
6138	837	2	\N	2014-10-25 22:28:02.931936+03
6139	1394	2	\N	2014-10-25 22:28:08.943421+03
6140	873	2	\N	2014-10-25 22:28:16.618586+03
6141	778	2	\N	2014-10-25 22:28:22.956578+03
6142	1659	2	\N	2014-10-25 22:39:28.23436+03
6144	1849	2	\N	2014-10-25 23:00:37.016264+03
6145	1852	2	\N	2014-10-28 19:57:41.751563+02
6146	1853	2	\N	2014-10-28 20:23:48.907733+02
6147	1854	2	\N	2014-10-28 20:24:58.380434+02
6148	1855	2	\N	2014-10-28 20:25:08.681569+02
6151	1859	2	\N	2014-10-29 12:48:22.905378+02
6152	1860	2	\N	2014-10-30 22:03:33.988542+02
6157	1865	2	\N	2014-11-03 21:33:49.462196+02
6158	1866	2	\N	2014-11-03 21:38:54.729983+02
6159	1867	2	\N	2014-11-03 21:39:31.824693+02
6160	1868	2	\N	2014-11-03 21:40:02.647787+02
6161	1869	2	\N	2014-11-05 21:10:08.261088+02
6162	1870	2	\N	2014-11-05 21:10:38.427296+02
6164	1872	2	\N	2014-11-08 19:05:48.520641+02
6165	1868	2	\N	2014-11-08 19:07:32.928999+02
6166	1868	2	\N	2014-11-08 19:07:58.653299+02
6167	1873	2	\N	2014-11-09 14:14:33.279838+02
6168	1433	2	\N	2014-11-09 14:15:02.053975+02
6170	1875	2	\N	2014-11-09 20:43:57.157494+02
6171	1876	2	\N	2014-11-09 20:50:09.776581+02
6172	1876	2	\N	2014-11-09 21:46:07.106741+02
6173	1876	2	\N	2014-11-09 21:46:46.766703+02
6174	1876	2	\N	2014-11-12 18:42:47.24628+02
6175	1876	2	\N	2014-11-12 18:43:00.917409+02
6176	1876	2	\N	2014-11-12 18:43:51.052257+02
6177	1876	2	\N	2014-11-12 18:49:19.486465+02
6178	1876	2	\N	2014-11-12 18:49:50.992411+02
6182	1880	2	\N	2014-11-12 18:58:13.464317+02
6183	1881	2	\N	2014-11-12 18:58:13.464317+02
6184	1876	2	\N	2014-11-12 19:19:20.155903+02
6185	1880	2	\N	2014-11-12 19:20:04.488842+02
6186	1882	2	\N	2014-11-12 19:21:49.754499+02
6187	1882	2	\N	2014-11-12 20:48:55.295948+02
6188	1876	2	\N	2014-11-13 18:36:19.360925+02
6189	1876	2	\N	2014-11-13 18:36:40.275356+02
6190	1876	2	\N	2014-11-13 18:36:53.848561+02
6191	1876	2	\N	2014-11-13 18:37:04.828162+02
6192	1876	2	\N	2014-11-13 18:44:14.058824+02
6193	1880	2	\N	2014-11-14 13:23:46.652293+02
6196	1884	2	\N	2014-11-15 12:46:51.68956+02
6197	1885	2	\N	2014-11-15 12:55:58.618287+02
6200	1647	2	\N	2014-11-15 19:54:17.589811+02
6201	1647	2	\N	2014-11-15 19:57:05.325517+02
6202	1587	2	\N	2014-11-15 19:57:11.689531+02
6204	1888	2	\N	2014-11-15 20:54:18.530252+02
6209	1893	2	\N	2014-11-15 21:10:00.852505+02
6210	1894	2	\N	2014-11-16 11:36:20.360008+02
6211	1895	2	\N	2014-11-16 11:38:31.304748+02
6212	1896	2	\N	2014-11-16 11:52:22.859107+02
6214	1896	2	\N	2014-11-16 17:28:25.282664+02
6215	1898	2	\N	2014-11-18 19:36:00.947451+02
6217	1900	2	\N	2014-11-18 19:59:41.794255+02
6218	1901	2	\N	2014-11-18 20:00:50.313385+02
6219	1902	2	\N	2014-11-18 20:05:55.399398+02
6220	1903	2	\N	2014-11-18 20:06:23.495804+02
6221	1225	2	\N	2014-11-20 20:55:40.655878+02
6222	1904	2	\N	2014-11-21 20:47:35.513987+02
6223	1434	2	\N	2014-11-21 20:48:05.829054+02
6224	1571	2	\N	2014-11-21 20:48:27.000088+02
6225	1885	2	\N	2014-11-21 20:48:44.475673+02
6226	1905	2	\N	2014-11-21 21:17:50.885382+02
6227	1436	2	\N	2014-11-21 21:19:06.360097+02
6228	1798	2	\N	2014-11-21 21:19:19.899746+02
6229	1425	2	\N	2014-11-21 21:19:42.772209+02
6230	802	2	\N	2014-11-21 21:20:02.792752+02
6231	1906	2	\N	2014-11-21 21:20:18.443474+02
6232	802	2	\N	2014-11-21 21:20:33.430037+02
6233	1395	2	\N	2014-11-21 21:20:55.244524+02
6234	1907	2	\N	2014-11-21 21:25:23.260941+02
6235	879	2	\N	2014-11-21 21:26:01.060638+02
6236	1089	2	\N	2014-11-21 21:34:19.776611+02
6237	874	2	\N	2014-11-21 21:34:45.906696+02
6238	1080	2	\N	2014-11-21 21:35:09.652432+02
6239	1908	2	\N	2014-11-21 21:35:29.643627+02
6240	910	2	\N	2014-11-21 21:36:10.21074+02
6241	1080	2	\N	2014-11-21 21:36:26.556412+02
6242	911	2	\N	2014-11-21 21:36:37.408083+02
6243	956	2	\N	2014-11-21 21:36:56.333028+02
6244	955	2	\N	2014-11-21 21:37:09.845857+02
6246	1896	2	\N	2014-11-21 21:43:10.139464+02
6247	1910	2	\N	2014-11-22 17:58:53.151533+02
6248	1911	2	\N	2014-11-22 17:58:53.151533+02
6251	1903	2	\N	2014-11-23 17:42:18.707964+02
6253	1903	2	\N	2014-11-23 18:15:04.669498+02
6254	1913	2	\N	2014-11-23 18:22:07.34092+02
6255	1915	2	\N	2014-11-23 18:25:34.975922+02
6257	1917	2	\N	2014-11-23 18:40:26.695236+02
6258	1918	2	\N	2014-11-23 18:40:42.249218+02
6259	1919	2	\N	2014-11-27 21:56:12.900683+02
6265	1906	2	\N	2014-11-28 22:02:27.025943+02
6266	1908	2	\N	2014-11-28 22:03:25.613427+02
6267	1919	2	\N	2014-11-30 11:21:31.130821+02
6270	1368	2	\N	2014-11-30 18:22:02.736241+02
6271	1922	2	\N	2014-12-07 14:34:35.538855+02
6276	1924	2	\N	2014-12-07 21:40:24.739542+02
6277	1925	2	\N	2014-12-07 21:41:09.94037+02
6278	1926	2	\N	2014-12-07 21:41:37.63455+02
6279	1471	2	\N	2014-12-07 21:41:39.584636+02
6280	1927	2	\N	2014-12-07 21:42:12.893528+02
6281	1471	2	\N	2014-12-07 21:42:14.781639+02
6285	1930	2	\N	2014-12-08 21:43:55.101305+02
6286	1869	2	\N	2014-12-08 21:46:09.685953+02
6287	1931	2	\N	2014-12-08 21:52:00.685674+02
6288	1930	2	\N	2014-12-08 21:53:17.580512+02
6289	1932	2	\N	2014-12-11 22:45:01.994257+02
6290	1933	2	\N	2014-12-11 22:46:28.273472+02
6291	1934	2	\N	2014-12-11 22:50:30.21811+02
6293	1935	2	\N	2014-12-11 22:53:00.765244+02
6295	1935	2	\N	2014-12-11 22:53:42.569877+02
6297	1936	2	\N	2014-12-13 21:35:47.599877+02
6298	1939	2	\N	2014-12-13 21:37:02.820409+02
6299	1939	2	\N	2014-12-13 21:37:54.352906+02
6300	1936	2	\N	2014-12-13 21:55:38.627009+02
6301	1933	2	\N	2014-12-13 21:55:57.253566+02
6302	1933	2	\N	2014-12-13 21:57:41.570228+02
6303	1933	2	\N	2014-12-13 22:01:39.804954+02
6304	1936	2	\N	2014-12-13 22:01:54.801501+02
6305	1936	2	\N	2014-12-13 22:03:25.347584+02
6306	1933	2	\N	2014-12-13 22:03:37.415197+02
6307	1939	2	\N	2014-12-13 22:03:52.016284+02
6308	1936	2	\N	2014-12-13 22:10:55.202627+02
6309	1936	2	\N	2014-12-13 22:11:45.388631+02
6310	1936	2	\N	2014-12-14 11:10:18.568487+02
6311	1936	2	\N	2014-12-14 11:10:54.616091+02
6312	1936	2	\N	2014-12-14 11:12:20.116844+02
6313	1933	2	\N	2014-12-14 11:12:44.366886+02
6314	1936	2	\N	2014-12-14 11:14:36.987112+02
6315	1933	2	\N	2014-12-14 11:14:46.937016+02
6316	1940	2	\N	2014-12-14 11:16:18.397912+02
6317	1941	2	\N	2014-12-14 17:51:15.587939+02
6318	1940	2	\N	2014-12-14 19:37:37.036036+02
6319	1936	2	\N	2014-12-14 19:37:54.381361+02
6320	1940	2	\N	2014-12-14 19:41:49.794566+02
6321	1940	2	\N	2014-12-14 19:44:37.781977+02
6322	1940	2	\N	2014-12-14 19:48:08.98232+02
6323	1940	2	\N	2014-12-14 19:50:28.583831+02
6324	1940	2	\N	2014-12-14 20:30:31.46273+02
6325	1936	2	\N	2014-12-14 20:30:45.990313+02
6326	1940	2	\N	2014-12-14 20:33:08.50634+02
6327	1940	2	\N	2014-12-14 20:34:47.73587+02
6328	1940	2	\N	2014-12-14 20:37:41.082704+02
6329	1653	2	\N	2014-12-19 21:31:43.967187+02
6330	1653	2	\N	2014-12-19 21:37:31.746728+02
6331	1951	2	\N	2014-12-19 21:38:17.300837+02
6332	725	2	\N	2014-12-19 21:38:20.726452+02
6333	1952	2	\N	2014-12-19 21:42:56.792366+02
6334	1870	2	\N	2014-12-19 21:43:03.803839+02
6335	1906	2	\N	2014-12-20 16:10:55.310323+02
6338	1869	2	\N	2014-12-20 17:01:25.535753+02
6339	1869	2	\N	2014-12-20 17:03:12.810766+02
6340	1869	2	\N	2014-12-20 17:03:22.550854+02
6341	1628	2	\N	2014-12-20 17:05:00.135486+02
6342	1869	2	\N	2014-12-20 17:05:08.130568+02
6343	1626	2	\N	2014-12-20 17:50:11.179188+02
6344	1615	2	\N	2014-12-20 17:50:33.508978+02
6345	1954	2	\N	2014-12-20 18:18:17.329483+02
6346	1954	2	\N	2014-12-20 18:18:27.668631+02
6349	1225	2	\N	2014-12-21 12:57:50.837529+02
6350	1433	2	\N	2014-12-21 12:57:59.036844+02
6351	1954	2	\N	2014-12-21 13:04:30.43023+02
6355	1956	2	\N	2014-12-21 14:58:01.627945+02
6356	1383	2	\N	2014-12-21 14:58:04.4436+02
6357	1383	2	\N	2014-12-21 14:58:18.134114+02
6387	1958	2	\N	2014-12-21 19:20:00.336409+02
6388	1958	2	\N	2014-12-21 19:40:10.412709+02
6389	1958	2	\N	2014-12-21 19:43:18.014602+02
6393	1962	2	\N	2014-12-24 21:32:53.618984+02
6400	1964	2	\N	2014-12-25 21:05:49.345482+02
6411	1317	2	\N	2014-12-27 14:48:10.519499+02
6412	1840	2	\N	2014-12-27 16:05:27.016889+02
6413	1840	2	\N	2014-12-27 16:32:05.180181+02
6414	1840	2	\N	2014-12-27 16:45:52.831401+02
6415	1966	2	\N	2014-12-27 19:34:56.371248+02
6418	1966	2	\N	2014-12-31 19:10:29.989911+02
6420	1968	2	\N	2015-01-03 12:32:10.846571+02
6422	1970	2	\N	2015-01-03 12:35:21.670372+02
6423	1971	2	\N	2015-01-04 12:45:51.571627+02
6424	1840	2	\N	2015-01-04 12:45:53.947837+02
6425	1971	2	\N	2015-01-04 12:46:35.715575+02
6426	1971	2	\N	2015-01-04 14:05:54.230775+02
6428	1975	2	\N	2015-01-04 14:47:53.838979+02
6429	1976	2	\N	2015-01-04 15:06:13.604725+02
6430	1977	2	\N	2015-01-04 16:44:50.635763+02
6431	1975	2	\N	2015-01-04 16:54:32.711408+02
6432	1975	2	\N	2015-01-04 17:11:52.039507+02
6433	1975	2	\N	2015-01-04 17:31:46.570967+02
6434	1975	2	\N	2015-01-07 14:12:48.405815+02
6435	1975	2	\N	2015-01-07 14:22:19.046581+02
6436	1978	2	\N	2015-01-07 18:00:22.111119+02
6437	1979	2	\N	2015-01-07 18:22:39.961593+02
6438	1980	2	\N	2015-01-07 18:22:48.978415+02
6439	1981	2	\N	2015-01-07 18:23:19.524712+02
6440	3	2	\N	2015-01-07 18:23:30.384627+02
6441	1982	2	\N	2015-01-07 18:30:42.662112+02
6442	3	2	\N	2015-01-07 18:30:49.411934+02
6443	3	2	\N	2015-01-07 18:31:24.902432+02
6444	784	2	\N	2015-01-08 13:21:17.321066+02
6445	784	2	\N	2015-01-08 13:27:01.529898+02
6446	784	2	\N	2015-01-08 14:19:17.153858+02
6447	784	2	\N	2015-01-08 14:20:23.527059+02
6448	784	2	\N	2015-01-09 10:59:22.101268+02
6449	1046	2	\N	2015-01-12 22:16:18.421621+02
6450	1046	2	\N	2015-01-12 22:16:29.774766+02
6451	1046	2	\N	2015-01-12 22:18:02.620143+02
6452	1046	2	\N	2015-01-13 17:00:13.07184+02
6453	1983	2	\N	2015-01-13 17:00:57.932019+02
6454	1985	2	\N	2015-01-13 17:03:06.725248+02
6455	1985	2	\N	2015-01-14 21:32:00.651438+02
6456	1046	2	\N	2015-01-14 21:35:47.291833+02
6457	1987	2	\N	2015-01-15 20:30:02.464255+02
6458	1988	2	\N	2015-01-15 21:27:50.402917+02
6459	1989	2	\N	2015-01-17 15:06:55.170629+02
6460	1990	2	\N	2015-01-17 19:50:58.298272+02
6461	1991	2	\N	2015-01-17 19:50:58.298272+02
6462	1992	2	\N	2015-01-17 19:51:20.956564+02
6463	1990	2	\N	2015-01-17 21:28:18.900625+02
6464	1993	2	\N	2015-01-17 21:28:36.972519+02
6465	1994	2	\N	2015-01-17 21:50:01.04394+02
6466	1995	2	\N	2015-01-17 21:50:14.61181+02
6467	1996	2	\N	2015-01-17 21:54:58.910426+02
6468	1997	2	\N	2015-01-17 21:54:58.910426+02
6471	2000	2	\N	2015-01-17 21:56:46.645017+02
6472	2001	2	\N	2015-01-17 21:57:17.28338+02
6473	2002	2	\N	2015-01-17 21:57:17.28338+02
6476	2005	2	\N	2015-01-17 22:00:19.139836+02
6477	2006	2	\N	2015-01-17 22:00:39.986496+02
6478	2007	2	\N	2015-01-17 22:00:39.986496+02
6479	2000	2	\N	2015-01-17 22:01:41.277766+02
6480	2009	2	\N	2015-01-21 21:44:18.418746+02
6481	1985	2	\N	2015-02-01 13:03:47.123323+02
6482	2009	2	\N	2015-02-01 13:05:09.626214+02
6483	2011	2	\N	2015-02-01 13:23:15.549518+02
6484	1004	2	\N	2015-02-01 13:23:17.930893+02
6485	2012	2	\N	2015-02-01 13:51:03.67962+02
6486	1470	2	\N	2015-02-01 13:51:06.125989+02
6487	2013	2	\N	2015-02-01 15:08:04.506074+02
6488	2014	2	\N	2015-02-01 15:08:25.548868+02
6489	2015	2	\N	2015-02-01 15:09:02.223788+02
6490	2016	2	\N	2015-02-01 15:09:49.640295+02
6491	2017	2	\N	2015-02-01 15:09:55.959842+02
6492	2018	2	\N	2015-02-01 15:12:43.612773+02
6493	2019	2	\N	2015-02-01 15:13:13.911124+02
6494	2020	2	\N	2015-02-01 15:13:27.313034+02
6497	2023	2	\N	2015-02-01 15:16:10.834689+02
6498	2024	2	\N	2015-02-01 15:16:30.308954+02
6501	2026	2	\N	2015-02-01 15:27:12.501194+02
6502	2026	2	\N	2015-02-01 15:27:30.084405+02
6503	2027	2	\N	2015-02-01 15:27:55.689729+02
6504	2028	2	\N	2015-02-01 15:27:55.689729+02
6505	2029	2	\N	2015-02-01 19:41:31.921287+02
6506	2030	2	\N	2015-02-01 19:49:07.587188+02
6507	2031	2	\N	2015-02-01 19:49:18.380376+02
6508	2032	2	\N	2015-02-01 19:51:03.621123+02
6509	1004	2	\N	2015-02-01 19:51:06.683043+02
6515	2038	2	\N	2015-02-01 19:53:59.085718+02
6516	2039	2	\N	2015-02-01 19:53:59.085718+02
6521	2044	2	\N	2015-02-01 19:54:52.686809+02
6522	2045	2	\N	2015-02-01 19:54:52.686809+02
6523	2046	2	\N	2015-02-01 19:54:52.686809+02
6524	2047	2	\N	2015-02-01 19:54:52.686809+02
6525	2048	2	\N	2015-02-03 20:05:38.797054+02
6526	2048	2	\N	2015-02-03 20:06:16.781057+02
6528	2049	2	\N	2015-02-03 21:27:11.659126+02
6529	2048	2	\N	2015-02-03 21:27:36.200475+02
6530	2050	2	\N	2015-02-04 21:04:02.527314+02
6531	2051	2	\N	2015-02-04 21:04:04.474427+02
6532	2051	2	\N	2015-02-04 21:11:28.094987+02
6533	2052	2	\N	2015-02-04 21:11:39.281593+02
6534	2051	2	\N	2015-02-23 21:04:13.639992+02
6535	1648	2	\N	2015-02-24 14:58:15.754816+02
6536	2053	2	\N	2015-02-24 21:04:03.673911+02
6537	2054	2	\N	2015-02-24 21:04:26.838046+02
6538	2053	2	\N	2015-02-24 21:06:05.145287+02
6539	2054	2	\N	2015-02-24 21:06:08.284296+02
6540	2053	2	\N	2015-02-24 21:06:25.905562+02
6541	2054	2	\N	2015-02-24 21:06:27.830735+02
6542	2055	2	\N	2015-03-03 16:25:23.003263+02
6553	2051	2	\N	2015-03-05 21:22:31.156271+02
6554	2052	2	\N	2015-03-05 21:22:34.187754+02
6555	2049	2	\N	2015-03-07 13:59:54.391614+02
6556	2049	2	\N	2015-03-07 14:00:01.858793+02
6557	2049	2	\N	2015-03-07 14:00:08.905813+02
6558	2049	2	\N	2015-03-07 17:41:13.176137+02
6559	2049	2	\N	2015-03-07 17:41:24.454712+02
6560	2016	2	\N	2015-03-07 19:11:45.990005+02
6561	1971	2	\N	2015-03-07 20:39:22.05432+02
6562	1939	2	\N	2015-03-07 20:41:30.911568+02
6563	1964	2	\N	2015-03-07 20:41:40.386597+02
6564	1962	2	\N	2015-03-07 20:41:47.24255+02
6565	2009	2	\N	2015-03-07 20:41:57.590912+02
6566	1958	2	\N	2015-03-07 20:42:08.257141+02
6567	2062	2	\N	2015-03-07 20:44:22.388688+02
6568	1958	2	\N	2015-03-07 20:44:57.143369+02
6569	1922	2	\N	2015-03-07 21:16:33.311167+02
6570	1930	2	\N	2015-03-07 21:18:30.204883+02
6571	1980	2	\N	2015-03-07 21:18:36.892234+02
6572	1930	2	\N	2015-03-07 21:21:01.745845+02
6573	1982	2	\N	2015-03-07 21:45:35.899441+02
6574	1983	2	\N	2015-03-07 21:45:46.115364+02
6575	1985	2	\N	2015-03-07 21:45:53.837217+02
6576	2016	2	\N	2015-03-07 21:46:03.965785+02
6577	1940	2	\N	2015-03-07 21:46:13.798132+02
6578	1932	2	\N	2015-03-07 21:46:22.868946+02
6579	1934	2	\N	2015-03-07 21:46:33.42948+02
6580	1935	2	\N	2015-03-07 21:46:42.582075+02
6581	1936	2	\N	2015-03-07 21:46:53.561952+02
6582	1933	2	\N	2015-03-07 21:47:06.74156+02
6584	1922	2	\N	2015-03-08 18:02:14.423833+02
6585	1922	2	\N	2015-03-08 18:02:24.288542+02
6586	1989	2	\N	2015-03-08 18:07:00.091644+02
6587	1922	2	\N	2015-03-08 18:17:03.971743+02
6588	1922	2	\N	2015-03-08 18:29:12.5349+02
6589	2063	2	\N	2015-03-08 18:41:45.468589+02
6590	1989	2	\N	2015-03-08 18:41:51.822924+02
6592	2065	2	\N	2015-03-09 14:02:38.899688+02
6593	2066	2	\N	2015-03-09 17:16:22.759831+02
6594	2068	2	\N	2015-03-09 19:28:40.834898+02
6595	1980	2	\N	2015-03-09 19:37:29.594475+02
6596	1389	2	\N	2015-03-15 19:00:11.360402+02
6597	1389	2	\N	2015-03-15 19:07:00.022851+02
6598	1389	2	\N	2015-03-15 19:08:22.540227+02
6599	2070	2	\N	2015-03-21 15:11:50.495946+02
6600	1989	2	\N	2015-03-21 15:11:59.182752+02
6603	2052	2	\N	2015-03-21 16:50:40.821135+02
6605	2052	2	\N	2015-03-21 16:52:47.683727+02
6606	2075	2	\N	2015-03-21 17:05:47.83578+02
6607	2075	2	\N	2015-03-21 17:06:12.331454+02
6608	2052	2	\N	2015-03-21 17:06:35.32059+02
6609	2070	2	\N	2015-03-21 17:48:31.664941+02
6610	2077	2	\N	2015-03-21 17:49:14.645342+02
6618	2052	2	\N	2015-03-21 18:16:06.930298+02
6621	2052	2	\N	2015-03-21 18:19:16.455929+02
6622	2087	2	\N	2015-03-21 18:20:19.713186+02
6623	2052	2	\N	2015-03-21 18:20:29.187736+02
6624	2052	2	\N	2015-03-21 19:28:39.349206+02
6625	2052	2	\N	2015-03-21 19:30:14.844869+02
6626	2052	2	\N	2015-03-21 19:33:54.902921+02
6627	2052	2	\N	2015-03-21 19:34:11.317898+02
6628	2052	2	\N	2015-03-21 19:35:55.581037+02
6629	2052	2	\N	2015-03-21 19:36:06.902031+02
6630	2052	2	\N	2015-03-21 19:36:15.834648+02
6631	2052	2	\N	2015-03-21 19:36:28.227499+02
6632	2052	2	\N	2015-03-21 19:36:44.271289+02
6633	2088	2	\N	2015-03-21 19:36:44.271289+02
6634	2089	2	\N	2015-03-21 19:38:07.835672+02
6635	2090	2	\N	2015-03-21 19:38:10.203402+02
6637	2052	2	\N	2015-03-21 19:40:18.868487+02
6638	2052	2	\N	2015-03-21 19:41:03.761402+02
6639	2052	2	\N	2015-03-21 19:42:48.725752+02
6640	2052	2	\N	2015-03-21 19:43:52.346215+02
6641	2092	2	\N	2015-03-21 20:11:35.939948+02
6642	2052	2	\N	2015-03-21 20:11:42.394011+02
6643	2052	2	\N	2015-03-21 20:12:01.524624+02
6646	2052	2	\N	2015-03-21 21:14:06.180767+02
6647	2095	2	\N	2015-03-21 22:03:40.435063+02
6648	2051	2	\N	2015-03-21 22:03:42.699321+02
6649	2088	2	\N	2015-03-21 22:03:45.19164+02
6650	2052	2	\N	2015-03-21 22:12:59.222848+02
6651	971	2	\N	2015-03-22 16:55:09.922468+02
6652	2096	2	\N	2015-03-22 17:22:28.394236+02
6653	970	2	\N	2015-03-22 17:22:30.31308+02
6654	971	2	\N	2015-03-22 17:32:58.675826+02
6655	2097	2	\N	2015-03-22 17:35:36.969555+02
6656	2052	2	\N	2015-03-22 17:35:38.710629+02
6657	2052	2	\N	2015-03-22 17:35:54.667572+02
6658	2052	2	\N	2015-03-22 17:36:02.394493+02
6659	1413	2	\N	2015-03-22 21:10:23.96026+02
6660	2098	2	\N	2015-03-22 21:12:12.040889+02
6661	1413	2	\N	2015-03-22 21:12:14.574907+02
6662	953	2	\N	2015-03-23 10:52:07.126828+02
6663	955	2	\N	2015-03-23 10:52:46.434534+02
6664	955	2	\N	2015-03-23 10:53:07.107505+02
6665	971	2	\N	2015-03-23 11:17:09.549645+02
6666	971	2	\N	2015-03-23 11:17:14.786132+02
6667	971	2	\N	2015-03-23 22:30:47.611278+02
6668	2099	2	\N	2015-03-24 19:25:49.743645+02
6669	2100	2	\N	2015-03-24 19:26:22.746874+02
6670	2101	2	\N	2015-03-24 19:30:50.825716+02
6671	1413	2	\N	2015-03-24 21:27:29.027714+02
6672	1413	2	\N	2015-03-24 21:27:56.025596+02
6673	2104	2	\N	2015-03-25 22:08:36.018637+02
6674	2105	2	\N	2015-03-25 22:09:11.121353+02
6675	2106	2	\N	2015-03-25 22:10:32.26983+02
6676	2107	2	\N	2015-03-27 21:02:27.365736+02
6677	1413	2	\N	2015-03-27 22:11:48.664734+02
6678	1318	2	\N	2015-03-27 22:11:57.175441+02
6679	2108	2	\N	2015-03-27 22:14:09.702895+02
6680	1413	2	\N	2015-03-27 22:14:23.177174+02
6681	1975	2	\N	2015-03-29 14:54:09.090695+03
6682	1975	2	\N	2015-03-29 14:56:05.558074+03
6683	2054	2	\N	2015-03-29 18:10:37.298528+03
6684	2054	2	\N	2015-03-29 18:10:44.494853+03
6685	2054	2	\N	2015-03-29 18:11:59.351954+03
6686	894	2	\N	2015-03-29 18:12:33.345883+03
6687	2108	2	\N	2015-03-29 18:41:14.962865+03
6688	2108	2	\N	2015-03-29 18:41:28.932911+03
6689	2108	2	\N	2015-03-29 18:41:35.361837+03
6693	1578	2	\N	2015-03-29 19:28:18.094577+03
6694	1563	2	\N	2015-03-29 19:28:26.306719+03
6695	1560	2	\N	2015-03-29 19:28:31.032916+03
6696	1649	2	\N	2015-03-29 20:30:21.118741+03
6698	2111	2	\N	2015-03-29 20:32:08.188477+03
6699	918	2	\N	2015-03-29 20:45:02.042426+03
6700	918	2	\N	2015-03-29 20:45:08.391579+03
6701	917	2	\N	2015-03-29 20:45:13.080299+03
6702	916	2	\N	2015-03-29 20:45:17.094049+03
6703	952	2	\N	2015-03-29 20:51:29.823177+03
6705	988	2	\N	2015-03-29 20:57:38.470567+03
6707	971	2	\N	2015-03-29 21:04:32.587955+03
6709	1647	2	\N	2015-03-29 21:11:13.101083+03
6710	2115	2	\N	2015-03-29 21:11:20.771189+03
6711	1648	2	\N	2015-03-29 21:19:19.348961+03
6713	1646	2	\N	2015-03-29 21:25:36.400114+03
6715	1419	2	\N	2015-03-31 18:55:34.756779+03
6716	1415	2	\N	2015-03-31 18:55:54.50919+03
6718	1507	2	\N	2015-03-31 19:11:10.805316+03
6719	1507	2	\N	2015-03-31 19:11:17.000092+03
6720	1507	2	\N	2015-03-31 19:11:23.716877+03
6721	1898	2	\N	2015-03-31 19:19:08.662529+03
6722	1898	2	\N	2015-03-31 19:19:13.979595+03
6723	1898	2	\N	2015-03-31 19:19:19.541915+03
6724	2119	2	\N	2015-03-31 19:31:32.255315+03
6725	1419	2	\N	2015-03-31 19:31:35.171043+03
6726	2120	2	\N	2015-03-31 21:42:30.209371+03
6727	2107	2	\N	2015-04-06 22:18:27.344977+03
6728	2054	2	\N	2015-04-22 09:31:23.533867+03
6729	2126	2	\N	2015-04-22 10:21:50.083529+03
6730	2126	2	\N	2015-04-22 10:34:35.83663+03
6731	2127	2	\N	2015-04-22 15:08:30.934237+03
6732	2128	2	\N	2015-04-22 15:09:24.597951+03
6733	2129	2	\N	2015-04-22 15:30:21.099029+03
6734	2130	2	\N	2015-04-22 15:30:28.848383+03
6735	2131	2	\N	2015-04-22 15:33:06.666889+03
6736	2126	2	\N	2015-04-22 15:33:09.520564+03
6737	2132	2	\N	2015-04-22 15:34:13.439147+03
6738	2126	2	\N	2015-04-22 15:34:14.494849+03
6739	2126	2	\N	2015-04-22 15:34:41.240196+03
6740	2130	2	\N	2015-04-24 21:16:26.897843+03
6741	953	2	\N	2015-04-24 21:38:02.133997+03
6742	955	2	\N	2015-04-24 21:39:08.574084+03
6743	2108	2	\N	2015-04-25 13:14:21.858762+03
6745	2135	2	\N	2015-04-25 16:39:24.611492+03
6746	2128	2	\N	2015-04-25 16:59:29.339712+03
6747	2136	2	\N	2015-04-25 16:59:52.412523+03
6748	2137	2	\N	2015-04-25 21:29:39.820793+03
6749	2138	2	\N	2015-04-25 21:29:47.819244+03
6750	2139	2	\N	2015-04-25 21:29:55.72108+03
6751	2144	2	\N	2015-04-26 00:17:08.072699+03
6752	2145	2	\N	2015-04-26 00:17:08.072699+03
6753	2146	2	\N	2015-04-26 00:22:46.640907+03
6754	2147	2	\N	2015-04-26 00:22:46.640907+03
6755	2148	2	\N	2015-04-26 00:26:59.761945+03
6756	2149	2	\N	2015-04-26 00:26:59.761945+03
6757	2150	2	\N	2015-04-26 00:30:11.687983+03
6758	2151	2	\N	2015-04-26 00:30:11.687983+03
6759	2152	2	\N	2015-04-26 00:36:42.355592+03
6760	2153	2	\N	2015-04-26 00:36:42.355592+03
6761	2154	2	\N	2015-04-26 00:44:52.209962+03
6762	2155	2	\N	2015-04-26 00:44:52.209962+03
6763	2156	2	\N	2015-04-26 09:56:13.81422+03
6764	2157	2	\N	2015-04-26 09:56:13.81422+03
6765	2158	2	\N	2015-04-26 10:00:13.021078+03
6766	2159	2	\N	2015-04-26 10:00:13.021078+03
6767	2160	2	\N	2015-04-26 10:09:07.981749+03
6768	2161	2	\N	2015-04-26 10:09:07.981749+03
6769	2162	2	\N	2015-04-26 10:11:20.869074+03
6770	2163	2	\N	2015-04-26 10:11:20.869074+03
6771	2164	2	\N	2015-04-26 10:23:35.980962+03
6772	2165	2	\N	2015-04-26 10:23:35.980962+03
6774	2167	2	\N	2015-04-26 10:30:42.474899+03
6775	2168	2	\N	2015-04-26 10:30:42.474899+03
6778	2171	2	\N	2015-04-26 10:38:49.924523+03
6779	2172	2	\N	2015-04-26 10:41:15.682562+03
6780	2173	2	\N	2015-04-26 10:41:15.682562+03
6781	2174	2	\N	2015-04-26 10:51:18.425172+03
6782	2175	2	\N	2015-04-26 10:51:18.425172+03
6783	2176	2	\N	2015-04-26 10:54:26.243589+03
6784	2177	2	\N	2015-04-26 10:54:26.243589+03
6785	2178	2	\N	2015-04-26 10:57:26.669326+03
6786	2179	2	\N	2015-04-26 10:57:26.669326+03
6787	2180	2	\N	2015-04-26 11:08:04.739521+03
6788	2181	2	\N	2015-04-26 11:08:04.739521+03
6789	2182	2	\N	2015-04-26 11:13:10.975009+03
6790	2183	2	\N	2015-04-26 11:13:10.975009+03
6791	2184	2	\N	2015-04-26 13:03:25.416787+03
6792	2185	2	\N	2015-04-26 13:03:25.416787+03
6793	2186	2	\N	2015-04-26 13:42:49.969814+03
6794	2187	2	\N	2015-04-26 14:04:42.384772+03
6795	2188	2	\N	2015-04-26 14:04:42.384772+03
6796	2189	2	\N	2015-04-26 14:05:26.994527+03
6797	2190	2	\N	2015-04-26 14:05:26.994527+03
6798	2186	2	\N	2015-04-26 14:05:29.313624+03
6801	2197	2	\N	2015-05-03 13:21:34.120955+03
6802	2197	2	\N	2015-05-03 13:23:12.828981+03
6803	2197	2	\N	2015-05-03 13:34:38.831852+03
6804	2197	2	\N	2015-05-03 13:40:51.674186+03
6805	2199	2	\N	2015-05-03 23:18:19.876372+03
6806	1780	2	\N	2015-05-03 23:18:33.103558+03
6807	1368	2	\N	2015-05-04 19:21:58.460934+03
6808	1368	2	\N	2015-05-04 19:22:20.533133+03
6809	2200	2	\N	2015-05-04 20:57:01.637182+03
6810	2201	2	\N	2015-05-04 20:58:33.565049+03
6811	2203	2	\N	2015-05-04 21:30:33.485239+03
6812	1003	2	\N	2015-05-08 21:15:22.303904+03
6813	2205	2	\N	2015-05-08 22:38:40.1563+03
6814	2206	2	\N	2015-05-08 22:40:57.101857+03
6815	2207	2	\N	2015-05-08 22:43:00.228497+03
6816	2208	2	\N	2015-05-08 22:43:46.205549+03
6817	2209	2	\N	2015-05-09 15:04:04.437709+03
6818	2210	2	\N	2015-05-09 15:18:42.295591+03
6819	2211	2	\N	2015-05-09 15:20:41.04877+03
6820	2212	2	\N	2015-05-09 15:21:16.54612+03
6821	2213	2	\N	2015-05-09 15:21:20.750661+03
6822	2214	2	\N	2015-05-09 15:27:46.304009+03
6823	2215	2	\N	2015-05-09 15:27:52.157735+03
6824	2216	2	\N	2015-05-09 15:32:20.738122+03
6825	2216	2	\N	2015-05-09 15:34:43.153612+03
6826	2216	2	\N	2015-05-09 15:35:37.080548+03
6827	2216	2	\N	2015-05-09 15:36:20.491648+03
6828	2216	2	\N	2015-05-09 15:36:28.290218+03
6829	2217	2	\N	2015-05-09 16:10:30.715652+03
6830	2218	2	\N	2015-05-09 16:40:29.294581+03
6831	2216	2	\N	2015-05-09 16:40:47.688279+03
6832	2219	2	\N	2015-05-09 16:52:43.81748+03
6833	1550	2	\N	2015-05-09 16:53:04.04708+03
6834	1008	2	\N	2015-05-09 16:53:15.905297+03
6836	2218	2	\N	2015-05-09 16:56:24.612587+03
6837	2221	2	\N	2015-05-09 16:58:37.060459+03
6838	2216	2	\N	2015-05-09 17:04:04.921556+03
6839	2216	2	\N	2015-05-09 17:04:48.531212+03
6840	1563	2	\N	2015-05-09 19:32:44.822595+03
6841	2222	2	\N	2015-05-09 19:43:25.178079+03
6842	2215	2	\N	2015-05-09 20:07:16.539791+03
6843	2216	2	\N	2015-05-09 20:07:46.078918+03
6844	2223	2	\N	2015-05-09 20:08:53.78535+03
6845	2224	2	\N	2015-05-09 20:09:23.379411+03
6846	2225	2	\N	2015-05-09 20:09:44.887962+03
6847	2226	2	\N	2015-05-09 20:17:22.088876+03
6848	2227	2	\N	2015-05-09 20:29:08.971941+03
6849	2228	2	\N	2015-05-09 20:29:24.701653+03
6850	2229	2	\N	2015-05-09 20:29:40.419576+03
6851	2224	2	\N	2015-05-09 20:29:49.729598+03
6852	2230	2	\N	2015-05-09 20:30:09.233291+03
6853	2231	2	\N	2015-05-09 20:30:23.623593+03
6854	2232	2	\N	2015-05-09 20:30:35.560504+03
6855	2233	2	\N	2015-05-09 20:30:51.356148+03
6856	2234	2	\N	2015-05-09 20:31:09.312334+03
6857	2235	2	\N	2015-05-09 20:31:21.029136+03
6858	2236	2	\N	2015-05-09 20:31:43.127575+03
6859	2237	2	\N	2015-05-09 20:31:57.326798+03
6860	2238	2	\N	2015-05-09 20:32:20.746647+03
6861	2239	2	\N	2015-05-09 20:32:35.107871+03
6862	2240	2	\N	2015-05-09 20:32:50.419187+03
6863	2241	2	\N	2015-05-09 20:33:01.999568+03
6864	2242	2	\N	2015-05-09 20:33:16.190303+03
6865	2236	2	\N	2015-05-09 20:54:08.857766+03
6866	2216	2	\N	2015-05-09 21:04:14.03464+03
6867	1578	2	\N	2015-05-09 21:16:42.718164+03
6868	2243	2	\N	2015-05-10 13:44:27.494956+03
6869	2244	2	\N	2015-05-10 13:45:29.048699+03
6870	2245	2	\N	2015-05-10 13:46:40.29071+03
6871	2246	2	\N	2015-05-10 14:01:26.829403+03
6872	2247	2	\N	2015-05-10 14:01:57.254972+03
6873	2248	2	\N	2015-05-10 14:10:42.034833+03
6874	2249	2	\N	2015-05-10 14:10:53.000133+03
6875	2254	2	\N	2015-05-10 14:35:53.336283+03
6876	2255	2	\N	2015-05-10 14:35:53.336283+03
6877	2256	2	\N	2015-05-10 14:39:45.730714+03
6878	2257	2	\N	2015-05-10 14:39:45.730714+03
6879	2258	2	\N	2015-05-10 14:45:11.098493+03
6880	2259	2	\N	2015-05-10 14:45:11.098493+03
6881	2260	2	\N	2015-05-10 14:53:32.27851+03
6882	2261	2	\N	2015-05-10 14:53:32.27851+03
6883	2262	2	\N	2015-05-10 14:57:13.121414+03
6884	2263	2	\N	2015-05-10 14:57:13.121414+03
6885	2264	2	\N	2015-05-10 14:57:55.441966+03
6886	2265	2	\N	2015-05-10 15:07:20.399588+03
6887	2266	2	\N	2015-05-10 15:07:20.399588+03
6888	2267	2	\N	2015-05-10 15:07:27.786314+03
6889	2268	2	\N	2015-05-10 16:04:17.22685+03
6890	2269	2	\N	2015-05-10 16:04:56.471262+03
6891	1318	2	\N	2015-05-10 16:05:16.31159+03
6892	2270	2	\N	2015-05-10 16:07:24.626275+03
6893	2271	2	\N	2015-05-10 16:08:32.663974+03
6894	2272	2	\N	2015-05-10 16:08:35.587577+03
6895	2273	2	\N	2015-05-10 16:08:47.271902+03
6896	2274	2	\N	2015-05-10 16:08:47.271902+03
6897	2275	2	\N	2015-05-10 16:09:34.650716+03
6898	2276	2	\N	2015-05-10 22:11:18.586994+03
6899	2277	2	\N	2015-05-10 22:12:40.523328+03
6900	1314	2	\N	2015-05-10 22:12:56.872348+03
6901	2278	2	\N	2015-05-10 22:14:48.438204+03
6902	2279	2	\N	2015-05-10 22:14:48.438204+03
6903	2280	2	\N	2015-05-10 22:19:21.083289+03
6904	2280	2	\N	2015-05-13 21:55:52.759278+03
6905	2275	2	\N	2015-05-13 21:56:48.008072+03
6906	2267	2	\N	2015-05-13 21:56:54.031403+03
6907	2264	2	\N	2015-05-13 21:56:59.496539+03
6908	2281	2	\N	2015-05-16 15:29:57.002389+03
6909	2282	2	\N	2015-05-16 15:34:53.800182+03
6910	2283	2	\N	2015-05-16 15:34:53.800182+03
6911	2284	2	\N	2015-05-16 15:36:09.929045+03
6912	2285	2	\N	2015-05-16 15:45:33.371911+03
6913	2286	2	\N	2015-05-16 15:45:33.371911+03
6914	2287	2	\N	2015-05-16 15:48:18.436182+03
6915	2288	2	\N	2015-05-16 15:48:18.436182+03
6916	2289	2	\N	2015-05-17 21:30:51.134604+03
6917	2280	2	\N	2015-05-17 21:31:00.094313+03
6918	2290	2	\N	2015-05-17 21:31:39.003456+03
6919	2280	2	\N	2015-05-17 21:31:48.129633+03
6920	2284	2	\N	2015-05-17 22:02:03.373006+03
6921	2284	2	\N	2015-05-17 22:02:31.027832+03
6922	2291	2	\N	2015-05-18 16:39:17.24427+03
6923	2284	2	\N	2015-05-18 16:40:09.305094+03
6924	2284	2	\N	2015-05-18 20:31:39.659544+03
6925	2284	2	\N	2015-05-18 20:34:34.03653+03
6926	2284	2	\N	2015-05-18 21:22:46.805573+03
6927	2292	2	\N	2015-05-24 12:55:28.784478+03
6928	1212	2	\N	2015-05-24 13:06:21.488837+03
6929	2293	2	\N	2015-05-24 15:06:40.212091+03
6930	2294	2	\N	2015-05-24 15:11:44.965777+03
6931	2295	2	\N	2015-05-24 16:49:53.513439+03
6932	2296	2	\N	2015-05-24 16:50:41.467323+03
6933	2297	2	\N	2015-05-24 16:55:00.642026+03
6934	2299	2	\N	2015-05-24 16:57:39.672043+03
6935	2300	2	\N	2015-05-24 17:03:51.85238+03
6936	2088	2	\N	2015-05-24 17:03:55.878998+03
6937	2301	2	\N	2015-05-24 17:04:54.502108+03
6938	2088	2	\N	2015-05-24 17:10:16.729607+03
6939	2088	2	\N	2015-05-24 17:10:29.437025+03
6940	2088	2	\N	2015-05-24 17:15:30.592241+03
6941	2302	2	\N	2015-05-24 17:16:33.029089+03
6942	2075	2	\N	2015-05-24 17:16:41.742578+03
6943	2303	2	\N	2015-05-24 17:17:17.81127+03
6944	2088	2	\N	2015-05-24 17:17:21.677682+03
6945	2305	2	\N	2015-05-24 20:37:07.412723+03
6946	2052	2	\N	2015-05-24 20:37:10.892479+03
6947	2088	2	\N	2015-05-24 21:01:25.501241+03
6948	2052	2	\N	2015-05-24 21:13:25.598747+03
6949	2306	2	\N	2015-05-24 21:14:39.628922+03
6950	2052	2	\N	2015-05-24 21:14:43.723121+03
6951	2280	2	\N	2015-05-24 21:21:32.476216+03
6952	2280	2	\N	2015-05-24 21:22:00.849383+03
6953	2280	2	\N	2015-05-24 21:22:09.702717+03
6954	2307	2	\N	2015-05-24 21:32:02.910902+03
6955	2308	2	\N	2015-05-24 21:32:24.738611+03
6956	2309	2	\N	2015-05-24 21:32:31.516248+03
6957	2310	2	\N	2015-05-24 21:33:17.528061+03
6958	2311	2	\N	2015-05-24 21:35:46.300244+03
6959	2312	2	\N	2015-05-24 21:36:06.190691+03
6960	2312	2	\N	2015-05-24 21:36:27.205265+03
6961	2313	2	\N	2015-05-25 21:31:05.718794+03
6962	2312	2	\N	2015-05-25 21:31:08.674137+03
6963	2314	2	\N	2015-05-26 20:44:11.702313+03
6964	2315	2	\N	2015-05-26 20:44:48.242189+03
6965	2316	2	\N	2015-05-26 20:44:48.242189+03
6966	2317	2	\N	2015-05-26 20:45:01.161364+03
6967	2284	2	\N	2015-05-28 13:46:35.94219+03
6968	2317	2	\N	2015-05-28 13:46:45.92498+03
6969	2280	2	\N	2015-05-28 13:46:51.874219+03
6970	1507	2	\N	2015-05-31 21:55:12.660877+03
6971	1507	2	\N	2015-05-31 21:56:27.809825+03
6972	1439	2	\N	2015-05-31 21:57:11.520889+03
6973	1507	2	\N	2015-05-31 21:58:33.173778+03
6974	1507	2	\N	2015-05-31 22:00:02.964614+03
6975	1507	2	\N	2015-05-31 22:00:38.733485+03
6976	1507	2	\N	2015-05-31 22:11:01.827304+03
6977	1507	2	\N	2015-06-01 09:54:54.423199+03
6978	2284	2	\N	2015-06-01 11:22:28.244232+03
6979	2319	2	\N	2015-06-01 11:37:24.071069+03
6980	2320	2	\N	2015-06-01 12:56:01.185317+03
6986	2327	2	\N	2015-06-02 13:22:30.670092+03
6987	2328	2	\N	2015-06-02 13:22:36.147873+03
6988	2329	2	\N	2015-06-02 13:23:35.222007+03
6989	2330	2	\N	2015-06-02 13:24:32.384898+03
6990	2331	2	\N	2015-06-02 13:25:52.745886+03
6991	2332	2	\N	2015-06-02 13:27:31.983851+03
6992	2333	2	\N	2015-06-02 13:27:36.950926+03
6993	2334	2	\N	2015-06-02 13:28:43.733459+03
6994	2335	2	\N	2015-06-02 13:29:10.771807+03
6995	2336	2	\N	2015-06-02 13:29:57.138464+03
6996	2337	2	\N	2015-06-02 13:30:11.199071+03
6997	2338	2	\N	2015-06-02 13:34:47.558077+03
6998	2339	2	\N	2015-06-02 13:34:50.130325+03
6999	2340	2	\N	2015-06-02 13:35:46.336511+03
7000	2341	2	\N	2015-06-02 13:36:09.066506+03
7001	2342	2	\N	2015-06-02 13:36:09.066506+03
7002	2343	2	\N	2015-06-02 13:37:26.99598+03
7003	2344	2	\N	2015-06-02 13:37:26.99598+03
7004	2345	2	\N	2015-06-02 13:37:42.100766+03
7023	2345	2	\N	2015-06-06 20:33:35.089301+03
7024	2366	2	\N	2015-06-06 21:47:05.357423+03
7025	2367	2	\N	2015-06-06 21:47:08.978477+03
7026	2368	2	\N	2015-06-06 21:49:00.661472+03
7027	2369	2	\N	2015-06-06 21:50:18.211354+03
7028	2370	2	\N	2015-06-06 21:51:07.167429+03
7029	2371	2	\N	2015-06-06 21:52:21.362863+03
7030	2372	2	\N	2015-06-06 21:52:25.91268+03
7031	2367	2	\N	2015-06-06 22:01:59.580344+03
7032	2373	2	\N	2015-06-06 22:05:50.240364+03
7033	2374	2	\N	2015-06-06 22:06:07.223567+03
7034	2375	2	\N	2015-06-06 22:06:55.79185+03
7035	2376	2	\N	2015-06-06 22:07:46.643073+03
7036	2377	2	\N	2015-06-06 22:08:11.14074+03
7037	2378	2	\N	2015-06-06 22:08:11.14074+03
7038	2379	2	\N	2015-06-06 22:10:53.894076+03
7039	2380	2	\N	2015-06-06 22:10:53.894076+03
7040	2381	2	\N	2015-06-06 22:12:04.71986+03
7041	2382	2	\N	2015-06-06 22:12:17.899878+03
7042	2372	2	\N	2015-06-06 22:12:34.850437+03
7043	2383	2	\N	2015-06-06 22:34:30.822368+03
7044	2384	2	\N	2015-06-06 22:35:06.098136+03
7045	2385	2	\N	2015-06-06 22:35:22.838833+03
7046	2382	2	\N	2015-06-06 22:36:33.646314+03
7047	2388	2	\N	2015-06-06 22:43:36.614024+03
7048	2382	2	\N	2015-06-07 15:30:58.294045+03
7049	2247	2	\N	2015-06-07 17:10:29.033956+03
7050	1413	2	\N	2015-06-07 17:10:56.929199+03
7051	1318	2	\N	2015-06-07 17:11:36.862031+03
7052	1314	2	\N	2015-06-07 17:12:28.161782+03
7053	1431	2	\N	2015-06-07 19:55:54.571452+03
7054	1898	2	\N	2015-06-07 19:59:40.465993+03
7055	1898	2	\N	2015-06-07 20:00:47.882499+03
7056	1432	2	\N	2015-06-07 20:00:59.808075+03
7057	1608	2	\N	2015-06-07 20:01:30.177316+03
7058	1609	2	\N	2015-06-07 20:02:19.266681+03
7059	1769	2	\N	2015-06-07 20:03:05.939338+03
7060	1780	2	\N	2015-06-07 20:04:36.345782+03
7061	1873	2	\N	2015-06-07 20:05:07.816356+03
7062	1898	2	\N	2015-06-07 20:05:26.076509+03
7063	2199	2	\N	2015-06-07 20:05:57.959925+03
7064	2246	2	\N	2015-06-07 20:06:32.075272+03
7065	2246	2	\N	2015-06-07 20:06:41.085651+03
7066	2269	2	\N	2015-06-07 20:07:23.767588+03
7067	2277	2	\N	2015-06-07 20:07:57.192127+03
7068	1426	2	\N	2015-06-07 20:09:52.309668+03
7069	2389	2	\N	2015-06-07 20:10:03.246206+03
7070	2390	2	\N	2015-06-07 20:10:21.42447+03
7071	2391	2	\N	2015-06-07 20:10:54.694938+03
7072	2392	2	\N	2015-06-07 20:11:12.709328+03
7073	2393	2	\N	2015-06-07 20:11:33.449675+03
7074	2394	2	\N	2015-06-07 20:11:54.80775+03
7075	2395	2	\N	2015-06-07 20:12:24.648998+03
7076	2396	2	\N	2015-06-07 20:12:47.549001+03
7077	2397	2	\N	2015-06-07 20:13:09.482196+03
7078	2398	2	\N	2015-06-07 20:13:26.815118+03
7079	2399	2	\N	2015-06-07 20:13:43.442647+03
7080	2400	2	\N	2015-06-07 20:13:57.868779+03
7081	2401	2	\N	2015-06-07 20:14:15.895967+03
7082	2402	2	\N	2015-06-07 20:14:42.501203+03
7083	2403	2	\N	2015-06-07 20:15:33.611845+03
7084	2404	2	\N	2015-06-07 20:15:53.460657+03
7085	2405	2	\N	2015-06-07 20:16:10.772685+03
7086	2406	2	\N	2015-06-07 20:16:32.442601+03
7087	2407	2	\N	2015-06-07 20:16:56.509083+03
7088	2408	2	\N	2015-06-07 20:17:19.457924+03
7089	2409	2	\N	2015-06-07 20:17:39.828441+03
7090	2410	2	\N	2015-06-07 20:17:59.953522+03
7091	2411	2	\N	2015-06-07 20:18:15.36941+03
7092	2412	2	\N	2015-06-07 20:18:33.319787+03
7093	2413	2	\N	2015-06-07 20:18:53.786993+03
7094	2414	2	\N	2015-06-07 20:19:17.251882+03
7095	2415	2	\N	2015-06-07 20:34:54.782206+03
7096	2416	2	\N	2015-06-07 20:35:11.96143+03
7097	2417	2	\N	2015-06-07 20:35:33.998015+03
7098	2418	2	\N	2015-06-07 20:36:01.596002+03
7099	2419	2	\N	2015-06-07 20:36:15.960332+03
7100	2420	2	\N	2015-06-07 20:36:35.413228+03
7101	2421	2	\N	2015-06-07 20:37:30.352425+03
7102	2422	2	\N	2015-06-07 20:37:53.888785+03
7103	2423	2	\N	2015-06-07 20:38:10.610447+03
7104	2424	2	\N	2015-06-07 20:38:59.517394+03
7105	2425	2	\N	2015-06-07 20:39:26.415211+03
7106	2426	2	\N	2015-06-07 20:40:05.840226+03
7107	2427	2	\N	2015-06-07 20:40:46.537019+03
7108	2428	2	\N	2015-06-07 20:41:01.3009+03
7109	2429	2	\N	2015-06-07 20:41:17.634439+03
7110	2430	2	\N	2015-06-07 20:41:36.56949+03
7111	2431	2	\N	2015-06-07 20:41:54.944525+03
7112	2432	2	\N	2015-06-07 20:42:11.063081+03
7113	2433	2	\N	2015-06-10 21:10:55.543668+03
7114	2434	2	\N	2015-06-10 21:10:58.272269+03
7115	2434	2	\N	2015-06-10 21:11:16.546457+03
7116	2435	2	\N	2015-06-10 21:11:49.343497+03
7117	2436	2	\N	2015-06-10 21:12:20.087946+03
7119	2437	2	\N	2015-06-10 21:13:28.379702+03
7120	2434	2	\N	2015-06-10 21:13:35.658848+03
7118	2434	2	\N	2015-06-10 21:12:30.557424+03
7121	2434	2	\N	2015-06-13 11:08:16.884538+03
7122	2438	2	\N	2015-06-13 12:24:23.664338+03
7123	2439	2	\N	2015-06-13 12:25:12.11639+03
7124	2440	2	\N	2015-06-13 12:25:55.053099+03
7125	2439	2	\N	2015-06-13 12:28:23.509307+03
7126	1431	2	\N	2015-06-13 16:13:14.891511+03
7127	2269	2	\N	2015-06-13 16:29:21.58833+03
7128	2391	2	\N	2015-06-13 16:29:38.922876+03
7130	2442	2	\N	2015-06-13 17:22:11.365048+03
7162	2450	2	\N	2015-06-13 19:58:22.391173+03
7163	2317	2	\N	2015-06-13 19:58:33.103367+03
7164	2451	2	\N	2015-06-13 19:59:50.784052+03
7165	2452	2	\N	2015-06-13 19:59:50.784052+03
7166	2317	2	\N	2015-06-13 20:00:28.712308+03
7167	2317	2	\N	2015-06-13 20:01:26.421434+03
7168	2317	2	\N	2015-06-13 20:03:24.653457+03
7176	2451	2	\N	2015-06-14 10:07:32.690694+03
7177	2451	2	\N	2015-06-14 10:16:32.619194+03
7178	2451	2	\N	2015-06-14 13:13:57.393431+03
7179	2451	2	\N	2015-06-14 13:21:50.094038+03
7180	2451	2	\N	2015-06-14 13:22:37.050016+03
7181	2451	2	\N	2015-06-14 13:23:13.387606+03
7182	2451	2	\N	2015-06-14 13:23:25.25704+03
7183	2457	2	\N	2015-06-14 13:25:18.074212+03
7184	2451	2	\N	2015-06-14 13:26:56.97373+03
7185	2458	2	\N	2015-06-14 13:28:59.472857+03
7186	2459	2	\N	2015-06-14 13:29:40.688494+03
7187	2457	2	\N	2015-06-14 14:17:22.935487+03
7199	2463	2	\N	2015-06-14 16:30:22.760587+03
7201	2463	2	\N	2015-06-14 16:43:36.808614+03
7202	2465	2	\N	2015-06-14 18:28:13.295968+03
7203	2466	2	\N	2015-06-14 18:50:25.96227+03
7204	2467	2	\N	2015-06-14 18:50:57.662486+03
7205	2468	2	\N	2015-06-17 21:13:39.6663+03
7206	2469	2	\N	2015-06-17 21:13:39.6663+03
7207	2469	2	\N	2015-06-17 21:39:31.5421+03
7208	2470	2	\N	2015-06-17 21:39:43.056809+03
7211	2296	2	\N	2015-06-17 22:28:24.889672+03
7212	2296	2	\N	2015-06-17 22:28:44.137455+03
7213	2296	2	\N	2015-06-17 22:28:55.531055+03
7214	2296	2	\N	2015-06-17 22:29:04.688414+03
7217	1190	2	\N	2015-06-18 08:41:45.975909+03
7218	1190	2	\N	2015-06-18 08:41:55.712142+03
7219	2475	2	\N	2015-06-18 08:47:40.598128+03
7221	1043	2	\N	2015-06-18 08:49:28.676473+03
7222	2477	2	\N	2015-06-18 08:53:01.574753+03
7229	2484	2	\N	2015-06-18 09:11:44.190988+03
7230	2477	2	\N	2015-06-18 09:15:16.231618+03
7232	2486	2	\N	2015-06-19 08:53:30.530081+03
7235	2489	2	\N	2015-06-19 08:57:56.925224+03
7236	2490	2	\N	2015-06-19 08:58:47.001543+03
7237	2491	2	\N	2015-06-19 09:01:01.141859+03
7239	2493	2	\N	2015-06-19 09:05:15.381515+03
7241	1010	2	\N	2015-06-19 09:18:51.710345+03
7244	2129	2	\N	2015-06-19 09:22:37.844576+03
7248	2137	2	\N	2015-06-19 09:24:18.706637+03
7250	2248	2	\N	2015-06-19 09:24:53.046897+03
7251	2477	2	\N	2015-06-20 10:13:49.575046+03
7252	2484	2	\N	2015-06-20 10:13:59.32685+03
7253	2501	2	\N	2015-06-20 10:23:36.01186+03
7254	2490	2	\N	2015-06-20 10:24:30.090794+03
7255	2502	2	\N	2015-06-20 10:25:23.92051+03
7256	2490	2	\N	2015-06-20 10:25:26.171733+03
7257	2503	2	\N	2015-06-20 10:58:18.119129+03
7259	2505	2	\N	2015-06-20 11:21:58.139735+03
7260	2506	2	\N	2015-06-20 11:22:00.401736+03
7261	2507	2	\N	2015-06-20 11:22:46.430212+03
7262	2506	2	\N	2015-06-20 11:22:51.478424+03
7263	2508	2	\N	2015-06-20 11:23:54.736317+03
7264	2506	2	\N	2015-06-20 11:23:56.167951+03
7265	2345	2	\N	2015-06-20 11:26:36.603828+03
7266	2345	2	\N	2015-06-20 11:27:18.047841+03
7268	2345	2	\N	2015-06-20 11:46:46.13788+03
7269	2510	2	\N	2015-06-20 11:50:12.161837+03
7270	2511	2	\N	2015-06-20 11:50:13.525526+03
7272	2463	2	\N	2015-06-20 23:00:10.769493+03
7273	2467	2	\N	2015-06-20 23:00:18.463896+03
7274	2459	2	\N	2015-06-20 23:00:44.920864+03
7275	2458	2	\N	2015-06-20 23:00:51.132288+03
7276	2457	2	\N	2015-06-20 23:00:57.565186+03
7277	2451	2	\N	2015-06-20 23:01:04.368039+03
7278	2451	2	\N	2015-06-20 23:04:17.342527+03
7279	2457	2	\N	2015-06-20 23:04:23.315461+03
7280	2458	2	\N	2015-06-20 23:04:30.160097+03
7281	2459	2	\N	2015-06-20 23:04:35.721205+03
7282	1896	2	\N	2015-06-21 11:16:22.975624+03
7285	2459	2	\N	2015-06-21 11:19:17.963777+03
7286	2458	2	\N	2015-06-21 11:19:23.880837+03
7287	2457	2	\N	2015-06-21 11:19:29.44712+03
7288	2451	2	\N	2015-06-21 11:19:35.471458+03
7289	2467	2	\N	2015-06-21 11:19:54.443461+03
7290	2463	2	\N	2015-06-21 11:20:00.085347+03
7291	2465	2	\N	2015-06-21 11:21:33.270335+03
7292	2513	2	\N	2015-06-23 22:26:54.54596+03
7293	778	2	\N	2015-06-23 22:31:51.561928+03
7294	2514	2	\N	2015-06-23 22:34:29.078834+03
7295	2514	2	\N	2015-06-23 22:36:01.548881+03
7296	2513	2	\N	2015-06-23 22:42:58.979814+03
7297	2514	2	\N	2015-06-23 22:46:14.322892+03
7298	2515	2	\N	2015-06-23 22:48:32.462285+03
7299	2477	2	\N	2015-06-27 16:53:47.400114+03
7300	2477	2	\N	2015-06-27 17:29:32.884456+03
7301	2477	2	\N	2015-06-27 17:32:15.776144+03
7302	2477	2	\N	2015-06-27 17:33:05.384003+03
7303	2477	2	\N	2015-06-27 17:35:05.607746+03
7304	2477	2	\N	2015-06-27 17:36:45.346277+03
7305	2477	2	\N	2015-06-27 17:38:01.404518+03
7306	784	2	\N	2015-06-27 17:39:03.474446+03
7307	784	2	\N	2015-06-27 17:52:48.813097+03
7308	885	2	\N	2015-06-27 17:53:15.731358+03
7309	2053	2	\N	2015-06-27 17:58:30.465951+03
7310	2477	2	\N	2015-06-27 19:15:20.180008+03
7311	2477	2	\N	2015-06-27 19:49:02.708272+03
7312	784	2	\N	2015-06-27 19:50:37.220816+03
7313	784	2	\N	2015-06-27 19:50:45.528129+03
7314	784	2	\N	2015-06-27 19:50:53.618877+03
7315	784	2	\N	2015-06-27 19:52:29.5324+03
7316	2477	2	\N	2015-06-27 19:52:36.102154+03
7317	2516	2	\N	2015-06-27 20:34:38.335917+03
7318	2517	2	\N	2015-06-27 21:02:52.190849+03
7319	2518	2	\N	2015-06-27 22:00:11.577645+03
7320	784	2	\N	2015-06-27 22:13:51.726755+03
7321	2519	2	\N	2015-06-27 22:13:51.726755+03
7322	2520	2	\N	2015-06-27 22:14:31.050053+03
7323	2521	2	\N	2015-06-27 22:15:06.48124+03
7324	2522	2	\N	2015-06-27 22:27:54.400494+03
7325	2523	2	\N	2015-06-27 22:40:18.037224+03
7326	2524	2	\N	2015-06-27 22:42:17.60206+03
7327	2525	2	\N	2015-06-27 22:42:37.767083+03
7328	784	2	\N	2015-06-27 22:49:09.961687+03
7329	784	2	\N	2015-06-27 22:49:28.712758+03
7330	784	2	\N	2015-06-27 22:49:40.054287+03
7331	2526	2	\N	2015-06-28 15:48:24.134048+03
7332	2527	2	\N	2015-06-28 15:49:06.934643+03
7333	1930	2	\N	2015-06-28 15:49:08.476175+03
7334	1930	2	\N	2015-06-28 15:49:15.43238+03
7335	1286	2	\N	2015-06-28 16:19:06.654271+03
7336	1284	2	\N	2015-06-28 16:19:08.822984+03
7337	2528	2	\N	2015-06-28 16:27:58.214962+03
7338	2529	2	\N	2015-07-04 20:12:31.951644+03
7339	2530	2	\N	2015-07-04 20:16:08.99227+03
7340	2531	2	\N	2015-07-04 20:16:08.99227+03
7341	2532	2	\N	2015-07-04 20:36:07.167824+03
7342	2533	2	\N	2015-07-04 20:36:07.167824+03
7343	2534	2	\N	2015-07-04 20:57:32.449165+03
7344	2491	2	\N	2015-07-04 20:58:12.716739+03
7345	2535	2	\N	2015-07-04 20:58:36.935951+03
7346	2536	2	\N	2015-07-04 20:59:39.366864+03
7347	2491	2	\N	2015-07-04 20:59:49.220324+03
7348	2537	2	\N	2015-07-04 21:00:02.518034+03
7349	2538	2	\N	2015-07-04 21:13:08.541103+03
7350	2539	2	\N	2015-07-04 21:14:30.611204+03
7351	2540	2	\N	2015-07-04 21:14:32.763289+03
7352	2541	2	\N	2015-07-04 21:14:50.821175+03
7353	2450	2	\N	2015-07-04 21:16:23.905581+03
7354	2542	2	\N	2015-07-04 21:17:54.658173+03
7355	2450	2	\N	2015-07-04 21:20:36.496307+03
7356	2450	2	\N	2015-07-04 21:22:20.163177+03
7357	2450	2	\N	2015-07-04 21:25:41.863118+03
7358	2543	2	\N	2015-07-04 21:26:56.584606+03
7359	2544	2	\N	2015-07-04 21:27:23.469843+03
7360	2388	2	\N	2015-07-04 21:27:31.474854+03
7361	2545	2	\N	2015-07-04 21:30:18.47115+03
7362	2546	2	\N	2015-07-04 21:30:37.579131+03
7363	2545	2	\N	2015-07-04 21:30:38.730906+03
7364	2547	2	\N	2015-07-04 21:30:51.680567+03
7365	2548	2	\N	2015-07-04 21:30:51.680567+03
7366	2388	2	\N	2015-07-04 21:31:14.422776+03
7367	2451	2	\N	2015-07-05 14:30:51.54628+03
7368	2457	2	\N	2015-07-05 14:33:01.814653+03
7369	2458	2	\N	2015-07-05 14:33:47.939925+03
7370	2459	2	\N	2015-07-05 14:33:59.629688+03
7371	2451	2	\N	2015-07-05 14:39:43.167129+03
7372	2467	2	\N	2015-07-05 14:49:52.691681+03
7373	2463	2	\N	2015-07-05 14:50:06.470488+03
7374	2549	2	\N	2015-07-05 15:34:32.780638+03
7376	2434	2	\N	2015-07-05 19:13:53.412323+03
7377	3	2	\N	2015-07-17 19:31:34.831317+03
7378	894	2	\N	2015-07-17 19:34:30.132569+03
7379	2054	2	\N	2015-07-17 19:34:44.345599+03
7380	2126	2	\N	2015-07-17 19:35:00.154065+03
7381	2484	2	\N	2015-07-17 19:35:15.872953+03
7382	2550	2	\N	2015-07-18 10:57:05.728016+03
7383	1372	2	\N	2015-07-18 10:57:08.110977+03
7384	1372	2	\N	2015-07-18 10:57:38.113606+03
7385	2551	2	\N	2015-07-18 11:02:48.147598+03
7386	2552	2	\N	2015-07-18 11:22:14.245467+03
7387	2552	2	\N	2015-07-18 11:24:17.241528+03
7388	2553	2	\N	2015-07-18 11:32:44.472503+03
7389	2554	2	\N	2015-07-18 11:46:38.401629+03
7390	2554	2	\N	2015-07-18 11:47:52.858154+03
7392	2556	2	\N	2015-07-18 11:55:59.961331+03
7393	1372	2	\N	2015-07-18 11:56:18.816278+03
7394	1375	2	\N	2015-07-18 11:56:26.8815+03
7395	2557	2	\N	2015-07-18 12:01:04.237446+03
7396	887	2	\N	2015-07-18 12:01:06.541839+03
7397	2376	2	\N	2015-07-18 12:01:31.956124+03
7398	2556	2	\N	2015-07-18 12:01:52.672293+03
7399	2558	2	\N	2015-07-19 10:20:48.263335+03
7400	2559	2	\N	2015-07-19 14:41:19.72071+03
7401	2560	2	\N	2015-07-19 14:41:25.622087+03
7402	2561	2	\N	2015-07-19 14:42:40.770503+03
7403	2562	2	\N	2015-07-19 14:42:45.815524+03
7404	2563	2	\N	2015-07-19 15:12:51.840188+03
7405	2564	2	\N	2015-07-19 15:13:34.062285+03
7406	2565	2	\N	2015-07-19 15:13:36.341158+03
7407	2566	2	\N	2015-07-19 15:17:50.040034+03
7408	2567	2	\N	2015-07-19 15:18:18.066263+03
7409	2568	2	\N	2015-07-19 15:19:23.078636+03
7410	2569	2	\N	2015-07-19 15:19:33.135472+03
7411	2570	2	\N	2015-07-19 15:20:45.489438+03
7412	2571	2	\N	2015-07-19 15:21:40.944498+03
7413	2572	2	\N	2015-07-19 15:21:50.318605+03
7414	2573	2	\N	2015-07-19 16:03:41.362252+03
7415	2574	2	\N	2015-07-19 16:04:11.184096+03
7416	2575	2	\N	2015-07-19 16:04:13.848246+03
7417	2576	2	\N	2015-07-19 16:05:08.205201+03
7418	2577	2	\N	2015-07-19 16:06:12.10907+03
7419	2578	2	\N	2015-07-19 16:06:39.117569+03
7420	2579	2	\N	2015-07-19 16:06:40.986562+03
7421	2580	2	\N	2015-07-19 16:07:27.111556+03
7422	2581	2	\N	2015-07-19 16:08:00.994992+03
7423	2582	2	\N	2015-07-19 16:08:03.06528+03
7424	2583	2	\N	2015-07-19 22:56:54.154484+03
7425	2584	2	\N	2015-07-19 23:47:28.340347+03
7426	2585	2	\N	2015-07-19 23:52:14.447269+03
7427	2586	2	\N	2015-07-19 23:52:36.403304+03
7428	2587	2	\N	2015-07-19 23:52:50.958041+03
7429	2588	2	\N	2015-07-19 23:53:14.681932+03
7430	2589	2	\N	2015-07-19 23:54:00.547115+03
7431	2590	2	\N	2015-07-19 23:54:44.372371+03
7432	2591	2	\N	2015-07-19 23:54:52.387429+03
7433	2593	2	\N	2015-07-19 23:56:11.09679+03
7434	2594	2	\N	2015-07-19 23:56:44.56359+03
7435	2595	2	\N	2015-07-19 23:56:46.53373+03
7436	1932	2	\N	2015-07-20 00:00:04.645587+03
7437	2596	2	\N	2015-07-20 00:04:50.031308+03
7438	2597	2	\N	2015-07-20 00:05:29.444039+03
7439	2598	2	\N	2015-07-20 00:06:05.823851+03
7440	2599	2	\N	2015-07-20 00:06:07.921437+03
7443	2602	2	\N	2015-07-20 23:51:41.323724+03
7444	2603	2	\N	2015-07-20 23:51:41.323724+03
7445	2604	2	\N	2015-07-20 23:51:41.323724+03
7446	2605	2	\N	2015-07-20 23:51:41.323724+03
7449	2608	2	\N	2015-07-20 23:51:41.323724+03
7453	2612	2	\N	2015-07-20 23:51:41.323724+03
7454	2613	2	\N	2015-07-20 23:51:41.323724+03
7458	2617	2	\N	2015-07-20 23:51:41.323724+03
7472	2631	2	\N	2015-07-20 23:51:41.323724+03
7473	2632	2	\N	2015-07-20 23:51:41.323724+03
7474	2633	2	\N	2015-07-20 23:51:41.323724+03
7475	2634	2	\N	2015-07-20 23:51:41.323724+03
7476	2635	2	\N	2015-07-20 23:51:41.323724+03
7477	2636	2	\N	2015-07-20 23:51:41.323724+03
7478	2637	2	\N	2015-07-20 23:51:41.323724+03
7479	2638	2	\N	2015-07-20 23:51:41.323724+03
7483	2642	2	\N	2015-07-20 23:51:41.323724+03
7484	2643	2	\N	2015-07-20 23:51:41.323724+03
7487	2646	2	\N	2015-07-20 23:51:41.323724+03
7488	2647	2	\N	2015-07-20 23:51:41.323724+03
7489	2648	2	\N	2015-07-20 23:51:41.323724+03
7490	2649	2	\N	2015-07-20 23:51:41.323724+03
7491	2650	2	\N	2015-07-20 23:51:41.323724+03
7492	2651	2	\N	2015-07-20 23:51:41.323724+03
7493	2652	2	\N	2015-07-20 23:51:41.323724+03
7494	2653	2	\N	2015-07-20 23:51:41.323724+03
7495	2654	2	\N	2015-07-20 23:51:41.323724+03
7496	2655	2	\N	2015-07-20 23:51:41.323724+03
7497	2658	2	\N	2015-07-20 23:58:46.110129+03
7498	894	2	\N	2015-07-20 23:59:14.903581+03
7499	2659	7	\N	2015-07-21 00:38:27.04357+03
7500	2660	7	\N	2015-07-21 00:38:31.047891+03
7501	2661	7	\N	2015-07-21 00:40:04.89713+03
7502	2662	7	\N	2015-07-21 00:40:08.316954+03
7503	2663	2	\N	2015-07-21 00:42:13.515989+03
7504	2664	2	\N	2015-07-21 00:44:32.068557+03
7505	2662	2	\N	2015-07-21 00:45:19.305589+03
7506	2662	7	\N	2015-07-21 00:47:09.218984+03
7507	894	2	\N	2015-07-22 09:52:23.690178+03
7508	885	2	\N	2015-07-22 09:53:01.082145+03
7509	2665	2	\N	2015-07-22 09:53:01.082145+03
7510	885	2	\N	2015-07-22 09:53:36.087021+03
7511	2272	2	\N	2015-07-22 10:46:42.444349+03
7512	2272	2	\N	2015-07-22 10:47:14.111233+03
7513	2666	2	\N	2015-07-22 10:50:02.98887+03
7514	2667	2	\N	2015-07-22 10:50:08.679496+03
7515	2668	2	\N	2015-07-22 10:51:11.924694+03
7516	2669	2	\N	2015-07-22 10:51:14.586916+03
7517	2669	2	\N	2015-07-22 11:46:47.662266+03
7518	2670	2	\N	2015-07-22 11:49:53.983401+03
7519	2671	2	\N	2015-07-22 11:53:39.590503+03
7520	2669	2	\N	2015-07-22 11:53:54.403754+03
7521	2669	2	\N	2015-07-22 11:54:14.136266+03
7522	2669	2	\N	2015-07-22 12:24:29.892068+03
7523	2673	2	\N	2015-07-22 12:28:35.92606+03
7524	2674	2	\N	2015-07-22 12:28:39.345269+03
7525	2675	2	\N	2015-07-22 12:44:17.155133+03
7526	2676	2	\N	2015-07-22 12:45:19.167404+03
7527	2677	2	\N	2015-07-22 12:45:42.418521+03
7528	2678	2	\N	2015-07-22 12:45:46.782121+03
7529	2679	2	\N	2015-07-22 12:46:34.868393+03
7530	2678	2	\N	2015-07-22 12:47:12.553819+03
7531	2680	2	\N	2015-07-22 12:47:32.725361+03
7532	2681	2	\N	2015-07-22 12:47:48.511246+03
7533	2682	2	\N	2015-07-22 13:40:37.786999+03
7534	2681	2	\N	2015-07-22 13:40:39.941316+03
7535	2681	2	\N	2015-07-22 13:40:55.710058+03
7536	2683	2	\N	2015-07-22 13:41:40.486853+03
7537	2684	2	\N	2015-07-22 13:41:59.700406+03
7538	2685	2	\N	2015-07-22 13:42:00.973433+03
7539	2667	2	\N	2015-07-22 13:42:02.635972+03
7540	2685	2	\N	2015-07-22 13:46:08.824214+03
7541	2667	2	\N	2015-07-22 13:46:13.399464+03
7542	2686	2	\N	2015-07-22 13:47:12.099197+03
7543	2687	2	\N	2015-07-22 13:47:12.099197+03
7544	2688	2	\N	2015-07-22 13:50:14.404321+03
7545	2689	2	\N	2015-07-22 13:50:14.404321+03
7546	2690	2	\N	2015-07-22 13:53:17.909433+03
7547	2690	2	\N	2015-07-22 13:53:48.33605+03
7550	2693	2	\N	2015-07-22 14:07:31.992976+03
7551	2694	2	\N	2015-07-22 14:08:00.072596+03
7552	2695	2	\N	2015-07-22 14:08:45.393051+03
7555	2698	2	\N	2015-07-22 14:13:47.912163+03
7556	2699	2	\N	2015-07-22 14:14:01.749177+03
7557	2700	2	\N	2015-07-22 14:14:10.709485+03
7558	2701	2	\N	2015-07-22 14:14:10.709485+03
7559	2699	2	\N	2015-07-22 14:16:42.964801+03
7560	2702	2	\N	2015-07-22 14:17:00.761945+03
7561	2703	2	\N	2015-07-22 14:17:00.761945+03
7562	2704	2	\N	2015-07-22 14:19:56.751612+03
7563	2705	2	\N	2015-07-22 14:19:56.751612+03
7564	2699	2	\N	2015-07-22 14:20:42.704316+03
7565	2706	2	\N	2015-07-22 14:21:02.027005+03
7566	2707	2	\N	2015-07-22 14:21:02.027005+03
7567	2699	2	\N	2015-07-22 14:21:39.869597+03
7568	2699	2	\N	2015-07-22 14:21:46.984305+03
7569	2708	2	\N	2015-07-22 14:21:59.287338+03
7570	2709	2	\N	2015-07-22 14:21:59.287338+03
7571	2699	2	\N	2015-07-22 14:22:26.322903+03
7572	2710	2	\N	2015-07-22 14:22:35.509695+03
7573	2711	2	\N	2015-07-22 14:22:35.509695+03
7574	2699	2	\N	2015-07-22 14:23:19.576335+03
7575	2712	2	\N	2015-07-22 14:23:36.759685+03
7576	2713	2	\N	2015-07-22 14:23:36.759685+03
7577	2714	2	\N	2015-07-22 14:30:40.877306+03
7578	2715	2	\N	2015-07-22 14:32:25.925422+03
7579	2716	2	\N	2015-07-22 14:32:25.925422+03
7580	2714	2	\N	2015-07-22 14:32:56.995021+03
7581	2717	2	\N	2015-07-22 14:33:08.574387+03
7582	2718	2	\N	2015-07-22 14:33:08.574387+03
7583	2719	2	\N	2015-07-22 14:50:07.747456+03
7584	2720	2	\N	2015-07-22 14:50:07.747456+03
7585	2721	2	\N	2015-07-22 14:53:19.652254+03
7586	2722	2	\N	2015-07-22 14:53:19.652254+03
7587	2723	2	\N	2015-07-22 15:02:17.721876+03
7588	2724	2	\N	2015-07-22 15:02:27.84792+03
7589	2725	2	\N	2015-07-22 15:02:27.84792+03
7590	2726	2	\N	2015-07-22 15:04:12.042101+03
7591	2699	2	\N	2015-07-22 15:04:47.591373+03
7592	2727	2	\N	2015-07-22 15:05:43.153662+03
7593	2728	2	\N	2015-07-22 15:05:43.153662+03
7594	2729	2	\N	2015-07-22 15:13:21.269737+03
7595	2730	2	\N	2015-07-22 15:19:08.113264+03
7596	2729	2	\N	2015-07-22 15:19:11.19218+03
7597	2729	2	\N	2015-07-22 15:35:51.754061+03
7598	2732	2	\N	2015-07-22 15:38:41.939351+03
7599	2729	2	\N	2015-07-22 15:40:32.555996+03
7600	2729	2	\N	2015-07-22 15:55:13.336651+03
7601	2515	2	\N	2015-07-22 15:57:29.189389+03
7602	2729	2	\N	2015-07-22 15:57:36.719306+03
7603	2733	2	\N	2015-07-22 15:58:23.119691+03
7604	2729	2	\N	2015-07-22 15:58:35.528196+03
7605	2450	2	\N	2015-07-22 15:58:59.916186+03
7606	2317	2	\N	2015-07-22 15:59:20.404832+03
7607	2734	2	\N	2015-07-22 15:59:27.667185+03
7608	2735	2	\N	2015-07-22 15:59:52.422862+03
7609	2736	2	\N	2015-07-22 15:59:52.422862+03
7610	2388	2	\N	2015-07-22 16:00:09.725539+03
7611	2450	2	\N	2015-07-22 16:00:21.306194+03
7612	1438	2	\N	2015-07-22 18:57:24.829162+03
7613	2737	2	\N	2015-07-22 19:50:41.44109+03
7614	2738	2	\N	2015-07-22 19:50:41.44109+03
7615	2739	2	\N	2015-07-22 22:10:17.173605+03
7616	2739	2	\N	2015-07-22 22:27:10.60758+03
7617	2740	2	\N	2015-10-05 21:56:31.033698+03
7618	2741	2	\N	2015-10-05 22:00:37.025784+03
7619	2741	2	\N	2015-10-05 22:01:11.294026+03
7620	2740	2	\N	2015-10-11 15:30:17.608326+03
7621	2740	2	\N	2015-10-11 15:49:02.820999+03
7622	2742	2	\N	2015-10-11 16:29:26.485453+03
7655	2741	2	\N	2015-10-19 21:00:27.348936+03
7656	2484	2	\N	2015-10-24 14:58:32.749242+03
7657	2779	2	\N	2015-10-24 14:58:32.749242+03
7658	2484	2	\N	2015-10-24 14:59:57.669772+03
7659	2780	2	\N	2015-10-24 14:59:57.669772+03
7660	894	2	\N	2015-10-24 15:00:56.289933+03
7661	2781	2	\N	2015-10-24 15:00:56.289933+03
7662	885	2	\N	2015-10-24 15:02:23.825848+03
7663	894	2	\N	2015-10-24 15:06:44.559696+03
7664	2782	2	\N	2015-10-24 15:06:44.559696+03
7665	894	2	\N	2015-10-24 15:13:07.98256+03
7666	2783	2	\N	2015-10-24 15:13:07.98256+03
7667	894	2	\N	2015-10-24 15:16:03.818888+03
7668	2784	2	\N	2015-10-24 15:16:03.818888+03
7669	2785	2	\N	2015-10-24 15:23:48.170652+03
7670	2786	2	\N	2015-10-24 15:24:48.816087+03
7671	2787	2	\N	2015-10-24 15:30:54.642902+03
7672	2739	2	\N	2015-10-31 09:47:11.166446+02
7673	2739	2	\N	2015-10-31 09:48:54.569182+02
7674	2739	2	\N	2015-10-31 09:52:21.217177+02
7675	2739	2	\N	2015-10-31 09:52:28.501825+02
7676	2739	2	\N	2015-10-31 10:25:38.872091+02
7677	2593	2	\N	2015-10-31 10:32:28.375294+02
7678	2788	2	\N	2015-10-31 11:46:02.329007+02
7679	2741	2	\N	2015-10-31 11:48:54.106885+02
7698	2813	2	\N	2015-11-22 21:52:45.311354+02
7699	2814	2	\N	2015-11-22 21:57:07.211721+02
7700	2739	2	\N	2015-11-22 21:57:09.506917+02
7701	2739	2	\N	2015-11-22 22:03:49.302367+02
7702	2815	2	\N	2015-11-29 18:03:23.32558+02
7703	2816	2	\N	2015-11-29 18:05:24.319676+02
7704	2818	2	\N	2015-11-29 19:06:37.534692+02
7705	2820	2	\N	2016-01-02 19:03:39.167822+02
7706	1930	2	\N	2016-01-02 19:03:41.6491+02
7707	2821	2	\N	2016-01-02 20:11:21.358279+02
7708	2822	2	\N	2016-01-02 20:11:24.233178+02
7709	2823	2	\N	2016-01-02 20:12:21.682793+02
7710	2824	2	\N	2016-01-02 20:12:46.762385+02
7711	2825	2	\N	2016-01-02 20:15:08.259398+02
7712	2824	2	\N	2016-01-02 20:15:26.352748+02
7713	2826	2	\N	2016-01-02 20:15:55.52191+02
7714	2824	2	\N	2016-01-02 20:17:19.972235+02
7715	2822	2	\N	2016-01-02 20:21:41.413863+02
7716	2827	2	\N	2016-01-02 20:24:24.220398+02
7717	2828	2	\N	2016-01-02 20:24:24.220398+02
7718	2829	2	\N	2016-01-02 20:25:00.491155+02
7719	2830	2	\N	2016-01-02 20:25:43.115841+02
7720	2831	2	\N	2016-01-02 20:26:37.333884+02
7721	2832	2	\N	2016-01-02 20:27:25.581765+02
7722	2833	2	\N	2016-01-02 20:36:13.937348+02
7723	2834	2	\N	2016-01-02 20:36:20.489746+02
7724	2834	2	\N	2016-01-02 20:36:41.364121+02
7725	2835	2	\N	2016-01-02 20:42:25.330155+02
7726	2836	2	\N	2016-01-02 20:42:56.538052+02
7727	2837	2	\N	2016-01-02 20:50:50.737933+02
7728	2838	2	\N	2016-01-02 20:50:50.737933+02
7729	2831	2	\N	2016-01-02 20:50:54.803525+02
7730	2839	2	\N	2016-01-02 20:51:13.095185+02
7731	2840	2	\N	2016-01-02 20:51:13.095185+02
7732	2841	2	\N	2016-01-02 20:52:40.961629+02
7733	2540	2	\N	2016-01-02 20:53:36.703713+02
7734	2842	2	\N	2016-01-02 20:53:48.427475+02
7735	2843	2	\N	2016-01-02 20:53:48.427475+02
7736	2844	2	\N	2016-01-02 21:00:05.527737+02
7737	2845	2	\N	2016-01-02 21:00:05.527737+02
7738	2846	2	\N	2016-01-02 21:03:59.88429+02
7739	2847	2	\N	2016-01-02 21:03:59.88429+02
7740	2848	2	\N	2016-01-02 21:08:47.993297+02
7741	2849	2	\N	2016-01-02 21:08:47.993297+02
7742	2850	2	\N	2016-01-02 21:16:40.983488+02
7743	2851	2	\N	2016-01-02 21:16:40.983488+02
7744	2852	2	\N	2016-01-02 21:36:46.646531+02
7745	2853	2	\N	2016-01-02 21:36:49.099159+02
7746	2854	2	\N	2016-01-02 21:37:14.376182+02
7747	2855	2	\N	2016-01-02 21:37:14.376182+02
7748	2853	2	\N	2016-01-02 21:38:33.232425+02
7749	2853	2	\N	2016-01-02 21:39:02.581845+02
7751	2856	2	\N	2016-01-02 21:39:38.718674+02
7752	2857	2	\N	2016-01-02 21:39:38.718674+02
7755	2858	2	\N	2016-01-02 21:48:47.109583+02
7756	2858	2	\N	2016-01-02 21:49:26.302355+02
7757	2858	2	\N	2016-01-02 21:50:13.774213+02
7759	2841	2	\N	2016-01-02 22:14:54.924705+02
7763	2858	2	\N	2016-01-02 22:21:07.90205+02
7750	2853	2	\N	2016-01-02 21:39:16.771773+02
7753	2858	2	\N	2016-01-02 21:43:29.317483+02
7754	2859	2	\N	2016-01-02 21:48:34.392885+02
7758	2858	2	\N	2016-01-02 21:50:34.02702+02
7760	2835	2	\N	2016-01-02 22:15:05.490599+02
7761	2858	2	\N	2016-01-02 22:15:28.276336+02
7762	2858	2	\N	2016-01-02 22:20:37.944351+02
7764	2858	2	\N	2016-01-02 22:23:01.500364+02
7765	2858	2	\N	2016-01-02 22:24:07.265807+02
7766	2858	2	\N	2016-01-02 22:57:12.346032+02
7767	2858	2	\N	2016-01-02 22:57:27.435802+02
7768	2858	2	\N	2016-01-02 22:58:10.983876+02
7769	2860	2	\N	2016-01-02 23:22:02.986231+02
7770	2861	2	\N	2016-01-02 23:22:02.986231+02
7771	2862	2	\N	2016-01-02 23:29:14.591921+02
7772	2863	2	\N	2016-01-02 23:29:43.595496+02
7773	2864	2	\N	2016-01-02 23:32:59.025447+02
7774	2865	2	\N	2016-01-02 23:33:17.678918+02
7775	2866	2	\N	2016-01-02 23:33:24.314299+02
7776	2867	2	\N	2016-01-02 23:34:03.051927+02
7777	2824	2	\N	2016-01-02 23:39:00.961892+02
\.


--
-- Name: resource_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('resource_log_id_seq', 7777, true);


--
-- Data for Name: resource_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY resource_type (id, resource_id, name, humanize, resource_name, module, descr, settings, status) FROM stdin;
145	2292	leads_items	Leads Items	LeadsItemsResource	travelcrm.resources.leads_items	Leads Items	null	0
103	1317	invoices	Invoices	InvoicesResource	travelcrm.resources.invoices	Invoices list. Invoice can't be created manualy - only using source document such as Tours	{"active_days": 3}	0
87	1190	contacts	Contacts	ContactsResource	travelcrm.resources.contacts	Contacts for persons, business persons etc.	\N	0
148	2513	vats	Vat	VatsResource	travelcrm.resources.vats	Vat for accounts and services	null	0
2	10	users	Users	UsersResource	travelcrm.resources.users	Users list	\N	0
149	2516	uploads	Uploads	UploadsResource	travelcrm.resources.uploads	Uploads for any type of resources	null	0
151	2551	persons_categories	Persons Categories	PersonsCategoriesResource	travelcrm.resources.persons_categories	Categorise your clients with categories of persons	null	0
1	773		Home	Root	travelcrm.resources	Home Page of Travelcrm	\N	0
12	16	resources_types	Resources Types	ResourcesTypesResource	travelcrm.resources.resources_types	Resources types list	\N	0
39	274	regions	Regions	RegionsResource	travelcrm.resources.regions		\N	0
41	283	currencies	Currencies	CurrenciesResource	travelcrm.resources.currencies		\N	0
47	706	employees	Employees	EmployeesResource	travelcrm.resources.employees	Employees Container Datagrid	\N	0
55	723	structures	Structures	StructuresResource	travelcrm.resources.structures	Companies structures is a tree of company structure. It's can be offices, filials, departments and so and so	\N	0
59	764	positions	Positions	PositionsResource	travelcrm.resources.positions	Companies positions is a point of company structure where emplyees can be appointed	\N	0
61	769	permisions	Permisions	PermisionsResource	travelcrm.resources.permisions	Permisions list of company structure position. It's list of resources and permisions	\N	0
65	775	navigations	Navigations	NavigationsResource	travelcrm.resources.navigations	Navigations list of company structure position.	\N	0
67	788	appointments	Appointments	AppointmentsResource	travelcrm.resources.appointments	Employees to positions of company appointments	\N	0
69	865	persons	Persons	PersonsResource	travelcrm.resources.persons	Persons directory. Person can be client or potential client	\N	0
70	872	countries	Countries	CountriesResource	travelcrm.resources.countries	Countries directory	\N	0
71	901	advsources	Advertises Sources	AdvsourcesResource	travelcrm.resources.advsources	Types of advertises	\N	0
72	908	hotelcats	Hotels Categories	HotelcatsResource	travelcrm.resources.hotelcats	Hotels categories	\N	0
73	909	roomcats	Rooms Categories	RoomcatsResource	travelcrm.resources.roomcats	Categories of the rooms	\N	0
75	954	foodcats	Foods Categories	FoodcatsResource	travelcrm.resources.foodcats	Food types in hotels	\N	0
78	1003	suppliers	Suppliers	SuppliersResource	travelcrm.resources.suppliers	Suppliers, such as touroperators, aircompanies, IATA etc.	\N	0
79	1007	bpersons	Business Persons	BPersonsResource	travelcrm.resources.bpersons	Business Persons is not clients it's simple business contacts that can be referenced objects that needs to have contacts	\N	0
83	1081	hotels	Hotels	HotelsResource	travelcrm.resources.hotels	Hotels directory	\N	0
84	1088	locations	Locations	LocationsResource	travelcrm.resources.locations	Locations list is list of cities, vilages etc. places to use to identify part of region	\N	0
86	1189	contracts	Contracts	ContractsResource	travelcrm.resources.contracts	Licences list for any type of resources as need	\N	0
89	1198	passports	Passports	PassportsResource	travelcrm.resources.passports	Clients persons passports lists	\N	0
90	1207	addresses	Addresses	AddressesResource	travelcrm.resources.addresses	Addresses of any type of resources, such as persons, bpersons, hotels etc.	\N	0
91	1211	banks	Banks	BanksResource	travelcrm.resources.banks	Banks list to create bank details and for other reasons	\N	0
93	1225	tasks	Tasks	TasksResource	travelcrm.resources.tasks	Task manager	\N	0
101	1268	banks_details	Banks Details	BanksDetailsResource	travelcrm.resources.banks_details	Banks Details that can be attached to any client or business partner to define account	\N	0
102	1313	services	Services	ServicesResource	travelcrm.resources.services	Additional Services that can be provide with tours sales or separate	\N	0
104	1393	currencies_rates	Currency Rates	CurrenciesRatesResource	travelcrm.resources.currencies_rates	Currencies Rates. Values from this dir used by billing to calc prices in base currency.	\N	0
105	1424	accounts_items	Accounts Items	AccountsItemsResource	travelcrm.resources.accounts_items	Finance accounts items	\N	0
106	1433	incomes	Incomes	IncomesResource	travelcrm.resources.incomes	Incomes Payments Document for invoices	{"account_item_id": 8}	0
107	1435	accounts	Accounts	AccountsResource	travelcrm.resources.accounts	Billing Accounts. It can be bank accouts, cash accounts etc. and has company wide visible	null	0
117	1797	subaccounts	Subaccounts	SubaccountsResource	travelcrm.resources.subaccounts	Subaccounts are accounts from other objects such as clients, touroperators and so on	null	0
118	1799	notes	Notes	NotesResource	travelcrm.resources.notes	Resources Notes	null	0
119	1849	calculations	Caluclations	CalculationsResource	travelcrm.resources.calculations	Calculations of Sale Documents	null	0
121	1894	turnovers	Turnovers	TurnoversResource	travelcrm.resources.turnovers	Turnovers on Accounts and Subaccounts	null	0
126	1968	companies	Companies	CompaniesResource	travelcrm.resources.companies	Multicompanies functionality	null	0
130	2049	leads	Leads	LeadsResource	travelcrm.resources.leads	Leads that can be converted into contacts	null	0
134	2099	orders	Orders	OrdersResource	travelcrm.resources.orders	Orders	null	0
135	2100	orders_items	Orders Items	OrdersItemsResource	travelcrm.resources.orders_items	Orders Items	null	0
137	2108	tours	Tours	ToursResource	travelcrm.resources.tours	Tour Service	null	0
74	953	accomodations	Accomodations	AccomodationsResource	travelcrm.resources.accomodations	Accomodations Types list	\N	0
110	1521	commissions	Commissions	CommissionsResource	travelcrm.resources.commissions	Services sales commissions	null	0
111	1548	outgoings	Outgoings	OutgoingsResource	travelcrm.resources.outgoings	Outgoings payments for touroperators, suppliers, payback payments and so on	null	0
146	2296	leads_offers	Leads Offers	LeadsOffersResource	travelcrm.resources.leads_offers	Leads Offers	null	0
152	2558	leads_stats	Leads Stats	LeadsStatsResource	travelcrm.resources.leads_stats	Portlet with leads statistics	{"column_index": 0}	0
120	1884	crosspayments	Cross Payments	CrosspaymentsResource	travelcrm.resources.crosspayments	Cross payments between accounts and subaccounts. This document is for balance corrections to.	null	0
153	2583	activities	Activities	ActivitiesResource	travelcrm.resources.activities	My last activities	{"column_index": 1}	0
123	1941	notifications	Notifications	NotificationsResource	travelcrm.resources.notifications	Employee Notifications	null	0
138	2127	transfers	Transfers	TransfersResource	travelcrm.resources.transfers	Transfers for tours	null	0
139	2135	transports	Transports	TransportsResource	travelcrm.resources.transports	Transports Types List	null	0
140	2217	suppliers_types	Suppliers Types	SuppliersTypesResource	travelcrm.resources.suppliers_types	Suppliers Types list	null	0
141	2243	tickets_classes	Tickets Classes	TicketsClassesResource	travelcrm.resources.tickets_classes	Tickets Classes list, such as first class, business class etc	null	0
142	2244	tickets	Tickets	TicketsResource	travelcrm.resources.tickets	Ticket is a service for sale tickets of any type	null	0
143	2268	visas	Visas	VisasResource	travelcrm.resources.visas	Visa is a service for sale visas	null	0
144	2276	spassports	Passports Services	SpassportsResource	travelcrm.resources.spassports	Service formulation of foreign passports	null	0
156	2788	campaigns	Campaigns	CampaignsResource	travelcrm.resources.campaigns	Marketings campaigns	{"host_smpp": "94.249.146.183", "system_type_smpp": "transceiver", "password_smpp": "korn17", "port_smtp": "2525", "username_smtp": "mazvv@mail.ru", "password_smtp": "GmA67mpqqYjKQ", "port_smpp": "29900", "username_smpp": "mazvv", "host_smtp": "smtp-pulse.com", "default_sender_smtp": "mazvv@mail.ru"}	0
\.


--
-- Name: resource_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('resource_type_id_seq', 158, true);


--
-- Data for Name: roomcat; Type: TABLE DATA; Schema: public; Owner: -
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
-- Name: roomcat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('roomcat_id_seq', 34, true);


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: -
--

COPY service (id, resource_id, name, descr, display_text, resource_type_id) FROM stdin;
7	2247	Ticket	\N	Ticket booking service	142
5	1413	Tour	Use this service for tour sales	Tour booking service	137
4	1318	A visa	\N	The issues for visas	143
1	1314	Foreign Passport Service	\N	Formulation of foreign passport	144
\.


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('service_id_seq', 7, true);


--
-- Data for Name: spassport; Type: TABLE DATA; Schema: public; Owner: -
--

COPY spassport (id, resource_id, photo_done, docs_receive_date, docs_transfer_date, passport_receive_date, descr) FROM stdin;
1	2279	t	2015-04-29	2015-04-30	2015-05-10	Must be done in 10 days after docs recieved
2	2838	f	\N	\N	\N	\N
\.


--
-- Name: spassport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('spassport_id_seq', 2, true);


--
-- Data for Name: spassport_order_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY spassport_order_item (order_item_id, spassport_id) FROM stdin;
35	1
47	2
\.


--
-- Data for Name: structure; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: structure_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY structure_address (structure_id, address_id) FROM stdin;
32	31
\.


--
-- Data for Name: structure_bank_detail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY structure_bank_detail (structure_id, bank_detail_id) FROM stdin;
\.


--
-- Data for Name: structure_contact; Type: TABLE DATA; Schema: public; Owner: -
--

COPY structure_contact (structure_id, contact_id) FROM stdin;
\.


--
-- Name: structures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('structures_id_seq', 13, true);


--
-- Data for Name: subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

COPY subaccount (id, resource_id, account_id, name, descr, status) FROM stdin;
1	1865	4	Vitalii Mazur EUR | cash	\N	0
2	1866	2	News Travel | Bank	\N	0
3	1867	4	Alexander Karpenko | EUR	\N	0
4	1868	3	Garkaviy Andriy | UAH	\N	0
6	1875	3	Main Cash Account | rid: 1628	\N	0
8	1881	3	Main Cash Account | rid: 1372	\N	0
9	1888	2	Lun Real Estate | UAH	Month Rate	0
10	1902	3	Lun Real Estate | UAH | CASH	Lun on cash account	0
11	1911	4	Main Cash EUR Account | rid: 1465	\N	0
12	1913	2	Sun Marino Trvl | Cash UAH	Sun Marino Main Bank Subaccount	0
13	1991	3	Main Cash Account | rid: 1471	\N	0
14	1997	3	Main Cash Account | rid: 1645	\N	0
15	2002	3	Main Cash Account | rid: 1869	\N	0
16	2007	3	Main Cash Account | rid: 887	\N	0
17	2028	3	Main Cash Account | rid: 2017	\N	0
18	2438	4	COMPANY EUR CASH	Main company Eur cash subaccount	0
20	2440	2	COMPANY UAH BANK	Main Company Uah bank account subaccount	0
19	2439	3	COMPANY UAH CASH	Main company Uah cash subaccount	0
21	2442	3	Stepanchuk Sergey, UAH, cash	\N	0
22	2452	4	Oleg, EUR, cash	\N	0
23	2466	3	Tez Tour UAH, cash	Tez tour cash UAH subaccount	0
24	2738	2	Fedirko Anatoliy, UAH, bank	\N	0
25	2861	3	Romanuta Pavel, UAH, cash	\N	0
26	2862	4	TEZ Tour EUR	\N	0
27	2866	2	Information Technology Inc.	\N	0
\.


--
-- Name: subaccount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('subaccount_id_seq', 27, true);


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: -
--

COPY supplier (id, resource_id, name, status, descr, supplier_type_id) FROM stdin;
65	2216	New Wind	0	First touroperator	1
66	2223	MAU	0	Internation Ukrainian Airlines	2
68	2225	Four Winds	0		1
69	2226	Akkord Tour	0		1
86	2227	Feerija	0		1
87	2228	TEZ Tour	0		1
88	2229	Gamalija	0		1
67	2224	News Travel	1	Cyprus touroperator only	1
89	2230	Voyage De Luxe	0		1
90	2231	IdrisKa tour	0		1
91	2232	Anex Tour	0		1
92	2233	TUI	0		1
93	2234	Turtess Travel	0		1
94	2235	Coral Travel	0		1
96	2237	Natali Turs	0		1
97	2238	Kiy Avia	0		2
98	2239	MIBS Travel	0		1
99	2240	SAM	0		1
100	2241	Pilot	0		1
101	2242	Orbita	0		1
95	2236	Pan Ukraine	1		1
102	2272	Ukrainian Visa Center	0	Quick Visas in EU and helps to get visas in any other countries	3
103	2865	Information Technology Inc.	0		4
\.


--
-- Data for Name: supplier_bank_detail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY supplier_bank_detail (supplier_id, bank_detail_id) FROM stdin;
\.


--
-- Data for Name: supplier_bperson; Type: TABLE DATA; Schema: public; Owner: -
--

COPY supplier_bperson (supplier_id, bperson_id) FROM stdin;
65	7
\.


--
-- Data for Name: supplier_contract; Type: TABLE DATA; Schema: public; Owner: -
--

COPY supplier_contract (supplier_id, contract_id) FROM stdin;
65	50
65	49
97	51
96	52
93	53
100	54
102	55
87	56
92	57
101	58
101	59
87	60
87	61
\.


--
-- Data for Name: supplier_subaccount; Type: TABLE DATA; Schema: public; Owner: -
--

COPY supplier_subaccount (supplier_id, subaccount_id) FROM stdin;
87	23
87	26
103	27
\.


--
-- Data for Name: supplier_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY supplier_type (id, resource_id, name, descr) FROM stdin;
1	2218	Touroperator	
2	2221	Aircompany	
3	2271	Visa Center	
4	2864	Other suppliers	
\.


--
-- Name: supplier_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('supplier_type_id_seq', 4, true);


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: -
--

COPY task (id, resource_id, employee_id, title, deadline, descr, status, reminder) FROM stdin;
37	1933	2	Call and remind about payment	2014-12-14 22:46:00+02	\N	3	\N
38	1934	2	Call and remind about payment	2014-12-12 22:50:00+02	Call and remind to pay invoice	0	\N
39	1935	2	Review Calculation	2014-12-12 22:52:00+02	\N	0	\N
40	1936	2	For testing Purpose only	2014-12-14 22:35:00+02	\N	0	\N
33	1922	30	Test	2014-12-07 21:36:00+02	For testing purpose	1	\N
55	2063	2	Revert status after testing	2015-03-08 19:41:00+02	Set status into active after testing	0	\N
56	2066	2	Notifications testing #2	2015-03-11 17:16:00+02	\N	0	\N
57	2068	2	Test Notification resource link	2015-03-11 19:28:00+02	\N	0	\N
48	1980	2	Check Reminder	2015-01-08 18:21:00+02	Description to task	3	\N
47	1971	2	Check Payments	2015-01-04 15:45:00+02	\N	1	\N
41	1939	2	I have the following code	2014-12-13 23:36:00+02	\N	3	\N
46	1964	2	For testing	2014-12-25 23:05:00+02	For testing purpose only	3	\N
45	1962	2	Test	2014-12-24 23:32:00+02	\N	3	\N
52	2009	2	I decided to try to follow the postgres approach as directly as possible and came up with the following migration.	2015-01-21 22:44:00+02	\N	1	\N
54	2062	2	New JEasyui version migrate	2015-03-07 21:43:00+02	Migrate on new 0.4.2 jeasyui version, check all functionality.	2	\N
44	1958	2	Test new scheduler realization	2014-12-22 19:18:00+02	New scheduler realizations notifications test.	3	\N
49	1982	2	The second task	2015-01-08 18:30:00+02	Second test task	1	\N
50	1983	2	Test	2015-01-13 17:06:00+02	\N	1	\N
51	1985	2	Test 2	2015-01-14 17:02:00+02	\N	1	\N
53	2016	2	Notify his	2015-02-02 17:09:00+02	Notify about the documents	3	\N
42	1940	2	Test notifications	2014-12-14 21:37:00+02	\N	2	\N
59	2131	2	Task For Lastovec	2015-04-23 15:32:00+03	Test description for task	0	\N
60	2171	2	Test for	2015-04-28 10:38:00+03	\N	0	\N
67	2197	2	Check reminder	2015-05-03 13:45:00+03	\N	0	10
68	2291	2	Call and ansswer about discount	2015-05-19 16:39:00+03	talk about discount	0	10
58	2075	2	Call about discounts	2015-03-21 17:20:00+02	Calls and talk about tour discounts	3	10
69	2303	2	Call about offer	2015-05-24 17:30:00+03	\N	0	10
70	2311	2	Select hotels and hot tours	2015-05-25 10:35:00+03	\N	0	10
71	2371	2	Call to client	2015-06-08 15:00:00+03	Call to client with success bucking	0	30
72	2381	2	Make an Invoice	2015-06-06 22:12:00+03	Make invoice for this order	0	10
73	2436	2	Позвонить клиент	2015-06-11 08:12:00+03	\N	0	10
78	2584	2	JEasyui 1.4.3 migration	2015-07-20 00:05:00+03	Migrate to new version of JEasyui	0	10
36	1932	2	Call and remind about payments	2014-12-11 22:48:00+02	Bla-Bla	3	10
79	2671	2	Call to customer!	2015-07-22 12:05:00+03	call to customer and ask for offer	0	10
80	2730	2	Check invoice	2015-07-22 15:30:00+03	Check invoice sum and call about currencies rates	0	10
81	2815	2	Test for notifications	2015-11-29 18:04:00+02	For test purposes only	0	10
82	2816	2	Test for notifications 2	2015-11-29 18:16:00+02	For test purpose only	0	10
83	2818	2	Check for notofications	2015-11-29 19:17:00+02	Test this one	0	10
35	1930	2	Check Person Details	2014-11-12 21:43:00+02	We'll reuse the Amount type from last week. It's mostly the same, except we'll remove __clause_element__(), and additionally provide a classmethod version of the as_currency() method, which we'll use when dealing with SQL expressions.	2	10
84	2829	2	Docs for client	2016-01-15 20:24:00+02	Make docs for client	0	10
\.


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('task_id_seq', 84, true);


--
-- Data for Name: task_resource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY task_resource (task_id, resource_id) FROM stdin;
35	1869
47	1840
53	2017
55	1989
69	2088
58	2088
70	2312
68	2284
71	2372
72	2382
73	2434
48	3
49	3
59	2126
79	2669
80	2729
84	2831
\.


--
-- Data for Name: task_upload; Type: TABLE DATA; Schema: public; Owner: -
--

COPY task_upload (task_id, upload_id) FROM stdin;
\.


--
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ticket (id, resource_id, start_location_id, end_location_id, ticket_class_id, transport_id, start_dt, start_additional_info, end_dt, end_additional_info, adults, children, descr) FROM stdin;
2	2255	15	21	2	1	2015-05-10 14:11:00+03	\N	2015-05-10 15:26:00+03	\N	2	0	\N
3	2257	15	21	2	1	2015-05-16 14:38:00+03	\N	2015-05-16 15:39:00+03	\N	2	0	\N
4	2259	21	15	2	1	2015-05-22 17:38:00+03	\N	2015-05-22 18:39:00+03	\N	2	0	\N
5	2261	15	21	2	1	2015-05-15 17:52:00+03	\N	2015-05-15 18:52:00+03	\N	2	0	\N
6	2263	21	15	2	1	2015-05-22 17:52:00+03	\N	2015-05-22 18:52:00+03	\N	2	0	\N
7	2288	15	37	2	1	2015-05-29 15:46:00+03	TICKET INFO	2015-05-29 17:31:00+03	\N	2	0	\N
\.


--
-- Data for Name: ticket_class; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ticket_class (id, resource_id, name) FROM stdin;
1	2248	First class
2	2249	Business Class
\.


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

COPY ticket_order_item (order_item_id, ticket_id) FROM stdin;
28	2
29	3
30	4
31	5
32	6
38	7
\.


--
-- Data for Name: tour; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tour (id, resource_id, start_location_id, end_location_id, hotel_id, accomodation_id, foodcat_id, roomcat_id, adults, children, start_date, end_date, descr, end_transport_id, start_transport_id, transfer_id, end_additional_info, start_additional_info) FROM stdin;
1	2145	15	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	MAU	MAU
2	2147	14	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
3	2149	15	37	36	\N	\N	\N	2	0	2015-04-25	2015-04-30	\N	1	1	\N	\N	\N
4	2151	15	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
5	2153	15	14	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
6	2155	3	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
7	2157	15	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
8	2159	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
9	2161	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
10	2163	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
11	2165	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
12	2168	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
13	2173	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
14	2175	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
15	2177	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
16	2179	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
17	2181	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
18	2183	33	37	36	\N	\N	\N	2	0	2015-04-30	2015-05-08	\N	1	1	\N	\N	\N
19	2185	33	37	36	\N	15	30	2	0	2015-04-30	2015-05-08	Description for service	1	1	\N	\N	\N
20	2188	33	37	36	\N	15	30	2	0	2015-04-30	2015-05-08	Description for service	1	1	\N	\N	\N
21	2190	33	37	36	\N	15	30	2	0	2015-04-30	2015-05-08	Description for service	1	1	\N	\N	\N
22	2266	15	20	12	2	15	30	2	0	2015-05-16	2015-05-23	\N	1	1	\N	\N	\N
24	2286	15	31	32	12	16	26	2	0	2015-05-20	2015-05-27	\N	1	1	\N	\N	\N
23	2283	15	19	16	\N	\N	\N	2	0	2015-05-22	2015-05-29	\N	1	1	\N	\N	\N
26	2342	15	19	16	10	15	\N	2	1	2015-07-13	2015-07-18	\N	1	1	\N	#MAU	#MAU
27	2378	15	39	39	10	10	\N	2	0	2015-06-28	2015-07-04	\N	1	1	\N	#MAU	#MAU
25	2316	15	19	18	10	10	33	2	0	2015-06-21	2015-06-27	\N	1	1	\N	# MAU	# MAU
28	2687	14	40	40	10	3	\N	2	1	2015-07-24	2015-07-30	\N	1	1	\N	#MAU 892134	#MAU 127193
29	2828	15	31	32	13	16	30	2	0	2016-02-12	2016-02-19	\N	1	1	\N	TREY0987YUt	TYU9881623
\.


--
-- Name: tour_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tour_id_seq1', 29, true);


--
-- Data for Name: tour_order_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tour_order_item (order_item_id, tour_id) FROM stdin;
33	22
36	23
37	24
39	25
40	26
42	27
44	28
46	29
\.


--
-- Name: touroperator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('touroperator_id_seq', 103, true);


--
-- Data for Name: transfer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY transfer (id, resource_id, name) FROM stdin;
1	2129	Group
2	2130	Individual
\.


--
-- Name: transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('transfer_id_seq', 267, true);


--
-- Name: transfer_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('transfer_id_seq1', 3, true);


--
-- Data for Name: transport; Type: TABLE DATA; Schema: public; Owner: -
--

COPY transport (id, resource_id, name) FROM stdin;
1	2137	Avia
2	2138	Auto
3	2139	Railway
\.


--
-- Name: transport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('transport_id_seq', 3, true);


--
-- Data for Name: upload; Type: TABLE DATA; Schema: public; Owner: -
--

COPY upload (id, path, size, media_type, descr, name, resource_id) FROM stdin;
4	2015627/11fad20d-91e8-4aae-9991-84a9f3ce68a2.jpg	0.00	image/jpeg		YniVN8l0kTY.jpg	2517
5	2015627/edbfabe1-5fa4-413f-a34a-7e87d2962dbd.jpg	0.00	image/jpeg		YniVN8l0kTY.jpg	2518
7	2015627/8c985058-a198-42df-97d2-f55996a1a9b3.jpg	0.00	image/jpeg	\N	Che-Guevara-9322774-1-402.jpg	2519
8	2015627/cdef8ade-0166-4206-bac6-43f1a64ee471.jpg	0.00	image/jpeg		YniVN8l0kTY.jpg	2520
9	2015627/e066c3a4-9840-434a-947d-088a46ecbb32.jpg	0.00	image/jpeg		YniVN8l0kTY.jpg	2521
10	2015627/bacad34b-c04f-4a77-b8d1-3a1a5b944f5b.jpg	0.00	image/jpeg		YniVN8l0kTY.jpg	2522
11	2015627/ba9d9b9e-220c-4ee7-b4d6-7e25a8582881.pdf	0.00	application/pdf		Python..pdf	2523
12	2015627/64d46808-2e69-4048-bc60-ca7ee03de0de.pdf	0.00	application/pdf		Python..pdf	2524
13	2015627/5f588c0b-bd08-4f4e-a55e-54f76895a184.png	0.00	image/png		Снимок экрана из 2015-06-18 13:18:52.png	2525
14	2015628/6b2d987b-b6fe-41d9-8edf-37b1e70fe79b.png	0.00	image/png		Снимок экрана из 2015-06-14 22:01:13.png	2526
15	2015628/6e5fbc5e-7ee9-4abd-9329-2c365546a3cd.png	0.00	image/png		Снимок экрана из 2015-06-14 22:00:32.png	2527
16	2015628/283deac4-aa2c-4222-a8c0-905d44de3530.png	0.00	image/png		Снимок экрана из 2015-06-14 22:00:37.png	2528
17	2015721/c0555abd-9463-4c6e-a938-c7319eeb7f6d.jpg	0.00	image/jpeg	Perfect client	the-perfect-client2.jpg	2664
18	2015722/b32166eb-971c-4ce2-a05a-be76bed46579.jpg	0.00	image/jpeg	\N	kabaeva_150.jpg	2665
19	2015722/1ef77eb8-790f-4494-a9de-ae383a4b7142.jpg	0.00	image/jpeg	passport scan	20120908105644_brooks.jpg	2682
20	2015722/317847e8-f61f-404c-91b9-d6f03c8228dd.jpg	0.00	image/jpeg		20120908105644_brooks.jpg	2684
\.


--
-- Name: upload_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('upload_id_seq', 20, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "user" (id, resource_id, username, email, password, employee_id) FROM stdin;
25	2054	maz_iv	maz_iv@travelcrm.org.ua	111111	30
31	2126	v.lastovec	lastovec@travelcrm.org.ua	111111	15
2	3	admin	admin@mail.ru	adminadmin	2
32	2484	alinka	kabaeva_alinka@mail.ru	123456	31
23	894	maziv	maziv@mail.ru	123456	7
34	2787	c.theron	vitalii.mazur@gmail.com	041035	32
\.


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_id_seq', 34, true);


--
-- Data for Name: vat; Type: TABLE DATA; Schema: public; Owner: -
--

COPY vat (id, resource_id, service_id, date, vat, calc_method, descr, account_id) FROM stdin;
2	2542	5	2015-06-01	20.00	0	\N	4
3	2543	5	2015-05-01	20.00	0	\N	3
4	2544	4	2015-05-01	20.00	1	\N	3
5	2732	5	2015-08-01	20.00	1	\N	2
1	2515	5	2015-06-01	20.00	1	Vat on Tours is only for commission	2
6	2733	4	2015-07-01	20.00	1	\N	2
7	2859	1	2016-01-01	20.00	0	\N	3
\.


--
-- Name: vat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('vat_id_seq', 7, true);


--
-- Data for Name: visa; Type: TABLE DATA; Schema: public; Owner: -
--

COPY visa (id, resource_id, country_id, start_date, end_date, type, descr) FROM stdin;
1	2274	21	2015-05-31	2016-05-31	0	\N
3	2380	12	2015-06-14	2016-06-14	0	\N
2	2344	17	2015-08-01	2015-09-01	0	\N
4	2689	16	2015-07-24	2015-07-30	0	Add discount for this service
\.


--
-- Name: visa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('visa_id_seq', 4, true);


--
-- Data for Name: visa_order_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY visa_order_item (order_item_id, visa_id) FROM stdin;
34	1
41	2
43	3
45	4
\.


SET search_path = test, pg_catalog;

--
-- Data for Name: accomodation; Type: TABLE DATA; Schema: test; Owner: -
--

COPY accomodation (id, resource_id, name) FROM stdin;
\.


--
-- Name: accomodation_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('accomodation_id_seq', 1, true);


--
-- Data for Name: account; Type: TABLE DATA; Schema: test; Owner: -
--

COPY account (id, resource_id, currency_id, account_type, name, display_text, status, descr) FROM stdin;
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('account_id_seq', 1, true);


--
-- Data for Name: account_item; Type: TABLE DATA; Schema: test; Owner: -
--

COPY account_item (id, resource_id, parent_id, name, type, status, descr) FROM stdin;
\.


--
-- Name: account_item_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('account_item_id_seq', 1, true);


--
-- Data for Name: address; Type: TABLE DATA; Schema: test; Owner: -
--

COPY address (id, resource_id, location_id, zip_code, address) FROM stdin;
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('address_id_seq', 1, true);


--
-- Data for Name: advsource; Type: TABLE DATA; Schema: test; Owner: -
--

COPY advsource (id, resource_id, name) FROM stdin;
\.


--
-- Name: advsource_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('advsource_id_seq', 1, true);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: test; Owner: -
--

COPY alembic_version (version_num) FROM stdin;
1502d7ef7d40
\.


--
-- Data for Name: appointment; Type: TABLE DATA; Schema: test; Owner: -
--

COPY appointment (id, resource_id, date, employee_id, position_id, salary, currency_id) FROM stdin;
1	789	2014-02-02	2	4	1000.00	54
\.


--
-- Name: appointment_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('appointment_id_seq', 1, true);


--
-- Data for Name: bank; Type: TABLE DATA; Schema: test; Owner: -
--

COPY bank (id, resource_id, name) FROM stdin;
\.


--
-- Data for Name: bank_address; Type: TABLE DATA; Schema: test; Owner: -
--

COPY bank_address (bank_id, address_id) FROM stdin;
\.


--
-- Data for Name: bank_detail; Type: TABLE DATA; Schema: test; Owner: -
--

COPY bank_detail (id, resource_id, currency_id, bank_id, beneficiary, account, swift_code) FROM stdin;
\.


--
-- Name: bank_detail_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('bank_detail_id_seq', 1, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('bank_id_seq', 1, true);


--
-- Data for Name: bperson; Type: TABLE DATA; Schema: test; Owner: -
--

COPY bperson (id, resource_id, first_name, last_name, second_name, position_name, status, descr) FROM stdin;
\.


--
-- Data for Name: bperson_contact; Type: TABLE DATA; Schema: test; Owner: -
--

COPY bperson_contact (bperson_id, contact_id) FROM stdin;
\.


--
-- Name: bperson_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('bperson_id_seq', 1, true);


--
-- Data for Name: calculation; Type: TABLE DATA; Schema: test; Owner: -
--

COPY calculation (id, resource_id, order_item_id, price, contract_id) FROM stdin;
\.


--
-- Name: calculation_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('calculation_id_seq', 1, true);


--
-- Data for Name: campaign; Type: TABLE DATA; Schema: test; Owner: -
--

COPY campaign (id, resource_id, name, subject, plain_content, html_content, start_dt, status) FROM stdin;
\.


--
-- Name: campaign_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('campaign_id_seq', 1, true);


--
-- Data for Name: cashflow; Type: TABLE DATA; Schema: test; Owner: -
--

COPY cashflow (id, subaccount_from_id, subaccount_to_id, account_item_id, sum, vat, date) FROM stdin;
\.


--
-- Name: cashflow_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('cashflow_id_seq', 1, true);


--
-- Data for Name: commission; Type: TABLE DATA; Schema: test; Owner: -
--

COPY commission (id, resource_id, service_id, percentage, price, currency_id, descr) FROM stdin;
\.


--
-- Name: commission_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('commission_id_seq', 1, true);


--
-- Data for Name: company; Type: TABLE DATA; Schema: test; Owner: -
--

COPY company (id, resource_id, currency_id, name, email, settings) FROM stdin;
1	1970	56	Vitalii	vitalii.mazur@gmail.com	{"locale": "ru", "timezone": "Africa/Abidjan"}
\.


--
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('company_id_seq', 1, true);


--
-- Data for Name: company_subaccount; Type: TABLE DATA; Schema: test; Owner: -
--

COPY company_subaccount (company_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: contact; Type: TABLE DATA; Schema: test; Owner: -
--

COPY contact (id, resource_id, contact_type, contact, status, descr) FROM stdin;
\.


--
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('contact_id_seq', 1, true);


--
-- Data for Name: contract; Type: TABLE DATA; Schema: test; Owner: -
--

COPY contract (id, resource_id, num, date, status, descr) FROM stdin;
\.


--
-- Data for Name: contract_commission; Type: TABLE DATA; Schema: test; Owner: -
--

COPY contract_commission (contract_id, commission_id) FROM stdin;
\.


--
-- Name: contract_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('contract_id_seq', 1, true);


--
-- Data for Name: country; Type: TABLE DATA; Schema: test; Owner: -
--

COPY country (id, resource_id, iso_code, name) FROM stdin;
3	878	UA	Ukraine
4	880	EG	Egypt
5	881	TR	Turkey
6	882	GB	United Kingdom
7	883	US	United States
9	1095	RU	Russian Federation
11	1100	DE	Germany
\.


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('country_id_seq', 11, true);


--
-- Data for Name: crosspayment; Type: TABLE DATA; Schema: test; Owner: -
--

COPY crosspayment (id, resource_id, cashflow_id, descr) FROM stdin;
\.


--
-- Name: crosspayment_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('crosspayment_id_seq', 1, true);


--
-- Data for Name: currency; Type: TABLE DATA; Schema: test; Owner: -
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
-- Name: currency_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('currency_id_seq', 57, true);


--
-- Data for Name: currency_rate; Type: TABLE DATA; Schema: test; Owner: -
--

COPY currency_rate (id, resource_id, currency_id, supplier_id, date, rate) FROM stdin;
\.


--
-- Name: currency_rate_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('currency_rate_id_seq', 1, true);


--
-- Data for Name: employee; Type: TABLE DATA; Schema: test; Owner: -
--

COPY employee (id, resource_id, photo_upload_id, first_name, last_name, second_name, itn, dismissal_date) FROM stdin;
2	784	7	John	Doe	\N	\N	\N
\.


--
-- Data for Name: employee_address; Type: TABLE DATA; Schema: test; Owner: -
--

COPY employee_address (employee_id, address_id) FROM stdin;
\.


--
-- Data for Name: employee_contact; Type: TABLE DATA; Schema: test; Owner: -
--

COPY employee_contact (employee_id, contact_id) FROM stdin;
\.


--
-- Name: employee_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('employee_id_seq', 2, true);


--
-- Data for Name: employee_notification; Type: TABLE DATA; Schema: test; Owner: -
--

COPY employee_notification (employee_id, notification_id, status) FROM stdin;
\.


--
-- Data for Name: employee_passport; Type: TABLE DATA; Schema: test; Owner: -
--

COPY employee_passport (employee_id, passport_id) FROM stdin;
\.


--
-- Data for Name: employee_subaccount; Type: TABLE DATA; Schema: test; Owner: -
--

COPY employee_subaccount (employee_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: employee_upload; Type: TABLE DATA; Schema: test; Owner: -
--

COPY employee_upload (employee_id, upload_id) FROM stdin;
\.


--
-- Data for Name: foodcat; Type: TABLE DATA; Schema: test; Owner: -
--

COPY foodcat (id, resource_id, name) FROM stdin;
\.


--
-- Name: foodcat_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('foodcat_id_seq', 1, true);


--
-- Data for Name: hotel; Type: TABLE DATA; Schema: test; Owner: -
--

COPY hotel (id, resource_id, hotelcat_id, location_id, name) FROM stdin;
\.


--
-- Name: hotel_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('hotel_id_seq', 1, true);


--
-- Data for Name: hotelcat; Type: TABLE DATA; Schema: test; Owner: -
--

COPY hotelcat (id, resource_id, name) FROM stdin;
\.


--
-- Name: hotelcat_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('hotelcat_id_seq', 1, true);


--
-- Data for Name: income; Type: TABLE DATA; Schema: test; Owner: -
--

COPY income (id, resource_id, invoice_id, account_item_id, sum, date, descr) FROM stdin;
\.


--
-- Data for Name: income_cashflow; Type: TABLE DATA; Schema: test; Owner: -
--

COPY income_cashflow (income_id, cashflow_id) FROM stdin;
\.


--
-- Name: income_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('income_id_seq', 1, true);


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: test; Owner: -
--

COPY invoice (id, date, active_until, resource_id, order_id, account_id, descr) FROM stdin;
\.


--
-- Name: invoice_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('invoice_id_seq', 1, true);


--
-- Data for Name: invoice_item; Type: TABLE DATA; Schema: test; Owner: -
--

COPY invoice_item (id, invoice_id, order_item_id, price, vat, discount, descr) FROM stdin;
\.


--
-- Name: invoice_item_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('invoice_item_id_seq', 1, true);


--
-- Data for Name: lead; Type: TABLE DATA; Schema: test; Owner: -
--

COPY lead (id, lead_date, resource_id, advsource_id, customer_id, status, descr) FROM stdin;
\.


--
-- Name: lead_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('lead_id_seq', 1, true);


--
-- Data for Name: lead_item; Type: TABLE DATA; Schema: test; Owner: -
--

COPY lead_item (id, resource_id, lead_id, service_id, currency_id, price_from, price_to, descr) FROM stdin;
\.


--
-- Name: lead_item_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('lead_item_id_seq', 1, true);


--
-- Data for Name: lead_offer; Type: TABLE DATA; Schema: test; Owner: -
--

COPY lead_offer (id, resource_id, lead_id, service_id, currency_id, supplier_id, price, status, descr) FROM stdin;
\.


--
-- Name: lead_offer_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('lead_offer_id_seq', 1, true);


--
-- Data for Name: location; Type: TABLE DATA; Schema: test; Owner: -
--

COPY location (id, resource_id, region_id, name) FROM stdin;
\.


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('location_id_seq', 1, true);


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: test; Owner: -
--

COPY navigation (id, resource_id, position_id, parent_id, name, url, action, icon_cls, separator_before, sort_order) FROM stdin;
53	1394	4	\N	Finance	/	\N	fa fa-credit-card	f	7
156	1905	4	53	Billing	/	\N	\N	f	10
107	1777	4	\N	Home	/	\N	fa fa-home	f	1
32	998	4	\N	Sales	/	\N	fa fa-legal	f	2
21	864	4	\N	Clientage	/	\N	fa fa-briefcase	f	3
26	900	4	\N	Marketing	/	\N	fa fa-bullhorn	f	4
10	780	4	\N	HR	/	\N	fa fa-group	f	5
18	837	4	\N	Company	/	\N	fa fa-building-o	f	6
23	873	4	\N	Directories	/	\N	fa fa-book	f	8
152	1895	4	\N	Reports	/	\N	fa fa-pie-chart	f	9
155	1904	4	53	Payments	/	\N	\N	f	12
157	1906	4	53	Currencies		\N	\N	t	7
42	1080	4	159	Hotels List	/hotels	\N	\N	f	5
43	1089	4	158	Locations	/locations	\N	\N	f	3
50	1312	4	53	Services List	/services	\N	\N	f	6
45	1212	4	53	Banks	/banks	tab_open	\N	f	6
153	1896	4	152	Turnovers	/turnovers	tab_open	\N	f	2
51	1368	4	32	Invoices	/invoices	tab_open	\N	t	5
9	779	4	8	Resource Types	/resources_types	\N	\N	f	1
13	790	4	10	Employees	/employees	\N	\N	f	1
8	778	4	\N	System	/	tab_open	fa fa-cog	f	11
54	1395	4	157	Currencies Rates	/currencies_rates	\N	\N	f	8
55	1425	4	156	Accounts Items	/accounts_items	\N	\N	f	3
56	1434	4	155	Income Payments	/incomes	\N	\N	f	9
57	1436	4	156	Accounts	/accounts	\N	\N	f	1
14	791	4	10	Employees Appointments	/appointments	\N	\N	f	2
174	2514	4	156	Vat Settings	/vats	tab_open	\N	t	5
15	792	4	8	Users	/users	\N	\N	f	3
17	802	4	157	Currencies List	/currencies	\N	\N	f	7
19	838	4	18	Structures	/structures	\N	\N	f	1
20	863	4	18	Positions	/positions	\N	\N	f	2
22	866	4	21	Persons	/persons	\N	\N	f	1
24	874	4	158	Countries	/countries	\N	\N	f	4
25	879	4	158	Regions	/regions	\N	\N	f	3
27	902	4	26	Advertising Sources	/advsources	\N	\N	f	1
28	910	4	159	Hotels Categories	/hotelcats	\N	\N	f	6
29	911	4	159	Rooms Categories	/roomcats	\N	\N	f	7
30	955	4	159	Accomodations	/accomodations	tab_open	\N	f	10
31	956	4	159	Food Categories	/foodcats	\N	\N	f	9
61	1571	4	155	Outgoing Payments	/outgoings	\N	\N	f	10
150	1798	4	156	Subaccounts	/subaccounts	\N	\N	f	2
151	1885	4	155	Cross Payments	/crosspayments	\N	\N	f	11
36	1008	4	23	Business Persons	/bpersons	tab_open	\N	f	4
60	1550	4	23	Suppliers	/suppliers	tab_open	\N	f	1
165	1975	4	8	Company	/companies/edit	dialog_open	\N	t	4
166	2048	4	32	Leads	/leads	tab_open	\N	f	2
168	2101	4	32	Orders	/orders	tab_open	\N	f	4
158	1907	4	23	Geography	/	\N	\N	f	10
159	1908	4	23	Hotels	/	\N	\N	t	9
169	2128	4	23	Transfers	/transfers	tab_open	\N	t	5
170	2136	4	23	Transport	/transports	tab_open	\N	f	6
171	2219	4	23	Suppliers Types	/suppliers_types	tab_open	\N	f	3
172	2222	4	23	Contracts	/contracts	tab_open	\N	f	2
173	2245	4	23	Ticket Class	/tickets_classes	tab_open	\N	f	7
175	2552	4	23	Persons Categories	/persons_categories	tab_open	\N	f	8
236	2741	4	26	Campaigns	/campaigns	tab_open	\N	t	3
\.


--
-- Name: navigation_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('navigation_id_seq', 236, true);


--
-- Data for Name: note; Type: TABLE DATA; Schema: test; Owner: -
--

COPY note (id, resource_id, title, descr) FROM stdin;
\.


--
-- Name: note_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('note_id_seq', 1, true);


--
-- Data for Name: note_resource; Type: TABLE DATA; Schema: test; Owner: -
--

COPY note_resource (note_id, resource_id) FROM stdin;
\.


--
-- Data for Name: note_upload; Type: TABLE DATA; Schema: test; Owner: -
--

COPY note_upload (note_id, upload_id) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: test; Owner: -
--

COPY notification (id, resource_id, title, descr, url, created) FROM stdin;
\.


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('notification_id_seq', 1, true);


--
-- Data for Name: notification_resource; Type: TABLE DATA; Schema: test; Owner: -
--

COPY notification_resource (notification_id, resource_id) FROM stdin;
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: test; Owner: -
--

COPY "order" (id, deal_date, resource_id, customer_id, lead_id, advsource_id, status, descr) FROM stdin;
\.


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('order_id_seq', 1, true);


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: test; Owner: -
--

COPY order_item (id, resource_id, order_id, service_id, currency_id, supplier_id, price, discount_sum, discount_percent, status, status_date, status_info) FROM stdin;
\.


--
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('order_item_id_seq', 1, true);


--
-- Data for Name: outgoing; Type: TABLE DATA; Schema: test; Owner: -
--

COPY outgoing (id, date, resource_id, account_item_id, subaccount_id, sum, descr) FROM stdin;
\.


--
-- Data for Name: outgoing_cashflow; Type: TABLE DATA; Schema: test; Owner: -
--

COPY outgoing_cashflow (outgoing_id, cashflow_id) FROM stdin;
\.


--
-- Name: outgoing_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('outgoing_id_seq', 1, true);


--
-- Data for Name: passport; Type: TABLE DATA; Schema: test; Owner: -
--

COPY passport (id, resource_id, country_id, passport_type, num, end_date, descr) FROM stdin;
\.


--
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('passport_id_seq', 1, true);


--
-- Data for Name: passport_upload; Type: TABLE DATA; Schema: test; Owner: -
--

COPY passport_upload (passport_id, upload_id) FROM stdin;
\.


--
-- Data for Name: permision; Type: TABLE DATA; Schema: test; Owner: -
--

COPY permision (id, resource_type_id, position_id, permisions, scope_type, structure_id) FROM stdin;
35	65	4	{view,add,edit,delete}	all	\N
34	61	4	{view,add,edit,delete}	all	\N
32	59	4	{view,add,edit,delete}	all	\N
30	55	4	{view,add,edit,delete}	all	\N
38	41	4	{view,add,edit,delete}	all	\N
37	67	4	{view,add,edit,delete}	all	\N
39	69	4	{view,add,edit,delete}	all	\N
40	39	4	{view,add,edit,delete}	all	\N
41	70	4	{view,add,edit,delete}	all	\N
42	71	4	{view,add,edit,delete}	all	\N
43	72	4	{view,add,edit,delete}	all	\N
44	73	4	{view,add,edit,delete}	all	\N
45	74	4	{view,add,edit,delete}	all	\N
46	75	4	{view,add,edit,delete}	all	\N
48	78	4	{view,add,edit,delete}	all	\N
49	79	4	{view,add,edit,delete}	all	\N
26	47	4	{view,add,edit,delete}	all	\N
294	156	4	{view,add,edit,delete,settings}	all	\N
55	83	4	{view,add,edit,delete}	all	\N
56	84	4	{view,add,edit,delete}	all	\N
58	86	4	{view,add,edit,delete}	all	\N
59	87	4	{view,add,edit,delete}	all	\N
61	89	4	{view,add,edit,delete}	all	\N
62	90	4	{view,add,edit,delete}	all	\N
63	91	4	{view,add,edit,delete}	all	\N
21	1	4	{view}	all	\N
65	93	4	{view,add,edit,delete}	all	\N
70	101	4	{view,add,edit,delete}	all	\N
22	2	4	{view,add,edit,delete}	all	\N
71	102	4	{view,add,edit,delete}	all	\N
73	104	4	{view,add,edit,delete}	all	\N
74	105	4	{view,add,edit,delete}	all	\N
76	107	4	{view,add,edit,delete}	all	\N
79	110	4	{view,add,edit,delete}	all	\N
80	111	4	{view,add,edit,delete}	all	\N
128	117	4	{view,add,edit,delete}	all	\N
129	118	4	{view,add,edit,delete}	all	\N
130	119	4	{autoload,view,edit,delete}	all	\N
131	120	4	{view,add,edit,delete}	all	\N
132	121	4	{view}	all	\N
24	12	4	{view,add,edit,delete,settings}	all	\N
134	123	4	{view,close}	all	\N
137	126	4	{view,edit}	all	\N
158	146	4	{view,add,edit,delete}	all	\N
141	130	4	{view,add,edit,delete,order}	all	\N
157	145	4	{view,add,edit,delete}	all	\N
155	144	4	{view,add,edit,delete}	all	\N
154	143	4	{view,add,edit,delete}	all	\N
153	142	4	{view,add,edit,delete}	all	\N
152	141	4	{view,add,edit,delete}	all	\N
151	140	4	{view,add,edit,delete}	all	\N
150	139	4	{view,add,edit,delete}	all	\N
149	138	4	{view,add,edit,delete}	all	\N
148	137	4	{view,add,edit,delete}	all	\N
146	135	4	{view,add,edit,delete}	all	\N
145	134	4	{view,add,edit,delete,calculation,invoice,contract}	all	\N
75	106	4	{view,add,edit,delete}	all	\N
72	103	4	{view,add,edit,delete,settings}	all	\N
160	148	4	{view,add,edit,delete}	all	\N
161	149	4	{view,add,edit,delete}	all	\N
163	151	4	{view,add,edit,delete}	all	\N
164	152	4	{view,settings}	all	\N
165	153	4	{view,settings}	all	\N
\.


--
-- Name: permision_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('permision_id_seq', 295, true);


--
-- Data for Name: person; Type: TABLE DATA; Schema: test; Owner: -
--

COPY person (id, resource_id, person_category_id, first_name, last_name, second_name, birthday, gender, email_subscription, sms_subscription, descr) FROM stdin;
\.


--
-- Data for Name: person_address; Type: TABLE DATA; Schema: test; Owner: -
--

COPY person_address (person_id, address_id) FROM stdin;
\.


--
-- Data for Name: person_category; Type: TABLE DATA; Schema: test; Owner: -
--

COPY person_category (id, resource_id, name) FROM stdin;
\.


--
-- Name: person_category_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('person_category_id_seq', 1, true);


--
-- Data for Name: person_contact; Type: TABLE DATA; Schema: test; Owner: -
--

COPY person_contact (person_id, contact_id) FROM stdin;
\.


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('person_id_seq', 1, true);


--
-- Data for Name: person_order_item; Type: TABLE DATA; Schema: test; Owner: -
--

COPY person_order_item (order_item_id, person_id) FROM stdin;
\.


--
-- Data for Name: person_passport; Type: TABLE DATA; Schema: test; Owner: -
--

COPY person_passport (person_id, passport_id) FROM stdin;
\.


--
-- Data for Name: person_subaccount; Type: TABLE DATA; Schema: test; Owner: -
--

COPY person_subaccount (person_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: position; Type: TABLE DATA; Schema: test; Owner: -
--

COPY "position" (id, resource_id, structure_id, name) FROM stdin;
4	772	1	Main Developer
\.


--
-- Name: position_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('position_id_seq', 4, true);


--
-- Data for Name: region; Type: TABLE DATA; Schema: test; Owner: -
--

COPY region (id, resource_id, country_id, name) FROM stdin;
\.


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('region_id_seq', 1, true);


--
-- Data for Name: resource; Type: TABLE DATA; Schema: test; Owner: -
--

COPY resource (id, resource_type_id, structure_id, protected) FROM stdin;
1080	65	1	\N
1081	12	1	\N
863	65	1	\N
875	70	1	\N
885	47	1	\N
1100	70	1	\N
895	39	1	\N
1101	39	1	\N
1268	12	1	f
998	65	1	\N
1284	69	1	f
728	55	1	\N
784	47	1	\N
1306	90	1	f
2788	12	1	f
1312	65	1	f
786	47	1	\N
802	65	1	\N
769	12	1	\N
30	12	1	\N
31	12	1	\N
32	12	1	\N
33	12	1	\N
34	12	1	\N
35	12	1	\N
36	12	1	\N
837	65	1	\N
1336	39	1	f
1165	39	1	\N
1347	39	1	f
1355	39	1	f
1204	87	1	\N
1207	12	1	\N
1218	39	1	\N
1365	39	1	f
1240	41	1	f
1398	104	1	f
1257	87	1	f
1258	87	1	f
1413	102	1	f
849	41	1	\N
851	41	1	\N
852	41	1	\N
1285	87	1	f
864	65	1	\N
876	41	1	\N
1286	89	1	f
896	39	1	\N
897	39	1	\N
772	59	1	\N
788	12	1	\N
706	12	1	\N
771	55	1	\N
838	65	1	\N
734	55	1	\N
898	39	1	\N
899	39	1	\N
900	65	1	\N
901	12	1	\N
902	65	1	\N
1304	87	1	f
1011	12	1	\N
1307	90	1	f
1313	12	1	f
1368	65	1	f
1414	90	1	f
1185	39	1	\N
1198	12	1	\N
1205	89	1	\N
1221	12	1	\N
1227	93	1	\N
1241	39	1	f
1259	87	1	f
1260	87	1	f
853	41	1	\N
865	12	1	\N
866	65	1	\N
789	67	1	\N
1288	90	1	f
887	69	1	\N
1290	39	1	f
773	12	1	\N
1308	90	1	f
1314	102	1	f
1372	69	1	f
1375	69	1	f
1382	90	1	f
1168	41	1	\N
1040	47	1	\N
1041	47	1	\N
1042	47	1	\N
1043	47	1	\N
1044	47	1	\N
1045	47	1	\N
1046	47	1	\N
1388	90	1	f
1391	90	1	f
1067	78	1	\N
1400	104	1	f
1401	104	1	f
1199	89	1	\N
1206	89	1	\N
1209	90	1	\N
1402	104	1	f
726	55	1	\N
1416	39	1	f
1418	90	1	f
1251	55	1	f
1261	89	1	f
854	2	1	\N
855	2	1	\N
1278	39	1	f
878	70	1	\N
1293	69	1	f
893	47	1	\N
894	2	1	\N
908	12	1	\N
909	12	1	\N
910	65	1	\N
911	65	1	\N
743	55	1	\N
790	65	1	\N
1294	69	1	f
763	55	1	\N
723	12	1	\N
791	65	1	\N
775	12	1	\N
37	12	1	\N
38	12	1	\N
39	12	1	\N
40	12	1	\N
43	12	1	\N
10	12	1	\N
792	65	1	\N
12	12	1	\N
14	12	1	\N
44	12	1	\N
16	12	1	\N
45	12	1	\N
1309	90	1	f
2	2	1	\N
3	2	1	\N
84	2	1	\N
83	2	1	\N
940	73	1	\N
941	73	1	\N
942	73	1	\N
943	73	1	\N
944	73	1	\N
945	73	1	\N
946	73	1	\N
947	73	1	\N
948	73	1	\N
949	73	1	\N
950	73	1	\N
1316	102	1	f
952	73	1	\N
939	73	1	\N
938	73	1	\N
937	73	1	\N
936	73	1	\N
935	73	1	\N
1370	90	1	f
933	73	1	\N
932	73	1	\N
931	73	1	\N
930	73	1	\N
929	73	1	\N
928	73	1	\N
927	73	1	\N
926	73	1	\N
925	73	1	\N
924	73	1	\N
923	73	1	\N
922	73	1	\N
921	73	1	\N
1371	87	1	f
919	72	1	\N
918	72	1	\N
917	72	1	\N
916	72	1	\N
915	72	1	\N
914	72	1	\N
913	72	1	\N
912	72	1	\N
1373	87	1	f
1376	89	1	f
1378	78	1	f
1060	41	1	\N
1068	12	1	\N
1390	69	1	f
1403	104	1	f
1170	39	1	\N
1179	39	1	\N
1189	12	1	\N
1190	12	1	\N
1200	89	1	\N
1210	90	1	\N
1225	12	1	\N
1230	93	1	\N
1243	87	1	f
1253	65	1	f
1263	87	1	f
856	2	1	\N
870	69	1	\N
1088	12	1	\N
879	65	1	\N
1089	65	1	\N
953	12	1	\N
954	12	1	\N
764	12	1	\N
955	65	1	\N
956	65	1	\N
957	74	1	\N
958	74	1	\N
959	74	1	\N
960	74	1	\N
961	74	1	\N
962	74	1	\N
963	74	1	\N
964	74	1	\N
965	74	1	\N
966	74	1	\N
967	74	1	\N
968	74	1	\N
969	74	1	\N
970	74	1	\N
971	74	1	\N
1310	41	1	f
973	75	1	\N
1317	12	1	f
975	75	1	\N
976	75	1	\N
977	75	1	\N
978	75	1	\N
274	12	1	\N
283	12	1	\N
1318	102	1	f
778	65	1	\N
779	65	1	\N
780	65	1	\N
286	41	1	\N
287	41	1	\N
288	41	1	\N
289	41	1	\N
290	41	1	\N
291	41	1	\N
292	41	1	\N
306	41	1	\N
277	39	1	\N
279	39	1	\N
280	39	1	\N
281	39	1	\N
278	39	1	\N
282	39	1	\N
979	75	1	\N
980	75	1	\N
981	75	1	\N
982	75	1	\N
983	75	1	\N
984	75	1	\N
985	75	1	\N
987	75	1	\N
988	75	1	\N
1003	12	1	\N
1004	78	1	\N
1005	78	1	\N
1328	39	1	f
1374	90	1	f
1191	86	1	\N
1201	87	1	\N
1211	12	1	\N
1212	65	1	\N
1213	90	1	\N
1380	87	1	f
1383	69	1	f
1244	87	1	f
1264	87	1	f
1387	87	1	f
1393	12	1	f
1394	65	1	f
1404	87	1	f
1406	89	1	f
1409	69	1	f
857	55	1	\N
859	55	1	\N
860	55	1	\N
861	55	1	\N
794	55	1	\N
800	55	1	\N
801	55	1	\N
1090	39	1	\N
2586	87	1	f
2587	87	1	f
2588	89	1	f
2589	89	1	f
2590	90	1	f
2591	69	1	f
871	69	1	\N
880	70	1	\N
881	70	1	\N
882	70	1	\N
883	70	1	\N
1007	12	1	\N
1008	65	1	\N
1311	41	1	f
1078	12	1	\N
1332	39	1	f
1192	86	1	\N
1379	87	1	f
1381	89	1	f
1265	89	1	f
1384	39	1	f
1389	69	1	f
1395	65	1	f
1407	90	1	f
1411	69	1	f
872	12	1	\N
873	65	1	\N
874	65	1	\N
725	55	1	\N
1282	87	1	f
1095	70	1	\N
1096	39	1	\N
1079	65	1	\N
1099	39	1	\N
1340	39	1	f
1344	39	1	f
1159	78	1	\N
1193	87	1	\N
1194	87	1	\N
1195	87	1	\N
1352	39	1	f
1396	104	1	f
1408	69	1	f
1410	69	1	f
1424	12	1	f
1425	65	1	f
1426	105	1	f
1431	105	1	f
1432	105	1	f
1433	12	1	f
1434	65	1	f
1435	12	1	f
1436	65	1	f
1440	103	1	f
1442	103	1	f
1447	106	1	f
1448	106	1	f
1450	12	1	f
1452	12	1	f
1464	87	1	f
1465	69	1	f
1467	89	1	f
1469	90	1	f
1471	69	1	f
1472	69	1	f
1473	69	1	f
1485	106	1	f
1487	103	1	f
1500	106	1	f
1502	103	1	f
1503	103	1	f
1504	104	1	f
1505	104	1	f
1506	104	1	f
1509	106	1	f
1516	87	1	f
1517	87	1	f
1518	87	1	f
1519	87	1	f
1521	12	1	f
1535	110	1	f
1536	110	1	f
1537	110	1	f
1538	110	1	f
1539	110	1	f
1540	110	1	f
1541	110	1	f
1543	87	1	f
1544	87	1	f
1545	87	1	f
1546	106	1	f
1547	106	1	f
1548	12	1	f
1549	12	1	f
1550	65	1	f
1551	87	1	f
1552	87	1	f
1559	87	1	f
1561	87	1	f
1562	87	1	f
1571	65	1	f
1575	65	1	f
1576	86	1	f
1577	87	1	f
1579	110	1	f
1580	78	1	f
1581	87	1	f
1582	89	1	f
1584	89	1	f
1585	90	1	f
1586	69	1	f
1587	39	1	f
1591	87	1	f
1592	89	1	f
1593	69	1	f
1597	104	1	f
1598	103	1	f
1607	106	1	f
1608	105	1	f
1609	105	1	f
1610	87	1	f
1611	87	1	f
1612	89	1	f
1613	89	1	f
1614	90	1	f
1615	69	1	f
1616	69	1	f
1619	69	1	f
1620	87	1	f
1621	87	1	f
1622	89	1	f
1623	90	1	f
1624	87	1	f
1625	89	1	f
1626	69	1	f
1627	69	1	f
1628	69	1	f
1634	103	1	f
1639	106	1	f
1640	87	1	f
1641	87	1	f
1642	89	1	f
1643	89	1	f
1644	90	1	f
1645	69	1	f
1647	39	1	f
1650	87	1	f
1651	89	1	f
1652	90	1	f
1653	69	1	f
1657	103	1	f
1659	65	1	f
1660	106	1	f
1714	110	1	f
1721	110	1	f
1764	111	1	f
1766	111	1	f
1769	105	1	f
1771	111	1	f
1773	111	1	f
1774	111	1	f
1777	65	1	f
1780	105	1	f
1797	12	1	f
1798	65	1	f
1799	12	1	f
1807	90	1	f
1839	103	1	f
1840	103	1	f
1849	12	1	f
1852	119	1	f
1853	119	1	f
1854	119	1	f
1855	119	1	f
1859	119	1	f
1860	119	1	f
1866	117	1	f
1869	69	1	f
1870	78	1	f
1873	105	1	f
1876	106	1	f
1880	106	1	f
1882	106	1	f
1884	12	1	f
1885	65	1	f
1888	117	1	f
1893	120	1	f
1894	12	1	f
1895	65	1	f
1896	65	1	f
1898	105	1	f
1900	120	1	f
1901	120	1	f
1902	117	1	f
1903	111	1	f
1904	65	1	f
1905	65	1	f
1906	65	1	f
1907	65	1	f
1908	65	1	f
1910	106	1	f
1913	117	1	f
1915	111	1	f
1917	110	1	f
1918	119	1	f
1919	12	1	f
1922	93	1	f
1925	89	1	f
1926	90	1	f
1927	87	1	f
1941	12	1	f
1945	123	1	f
1946	123	1	f
1947	123	1	f
1948	123	1	f
1949	123	1	f
1950	123	1	f
1951	90	1	f
1952	86	1	f
1954	12	1	f
1956	87	1	f
1959	123	1	f
1961	123	1	f
1963	123	1	f
1965	123	1	f
1966	12	1	f
1968	12	1	f
1970	126	1	f
1972	123	1	f
1973	123	1	f
1975	65	1	f
1977	12	1	f
1978	2	1	f
1984	123	1	f
1986	123	1	f
1987	103	1	f
1988	119	1	f
1989	12	1	f
1990	106	1	f
1992	106	1	f
1993	106	1	f
1994	106	1	f
1995	106	1	f
1996	106	1	f
2000	103	1	f
2001	106	1	f
2005	103	1	f
2006	106	1	f
2010	123	1	f
2011	110	1	f
2013	87	1	f
2014	89	1	f
2015	90	1	f
2017	69	1	f
2018	87	1	f
2019	89	1	f
2020	69	1	f
2023	104	1	f
2024	104	1	f
2026	103	1	f
2027	106	1	f
2029	119	1	f
2030	119	1	f
2031	119	1	f
2032	110	1	f
2038	119	1	f
2039	119	1	f
2044	119	1	f
2045	119	1	f
2046	119	1	f
2047	119	1	f
2048	65	1	f
2049	12	1	f
2050	87	1	f
2051	69	1	f
2053	47	1	f
2054	2	1	f
2055	12	1	f
2064	123	1	f
2067	123	1	f
2069	123	1	f
2070	12	1	f
2076	123	1	f
2077	12	1	f
2089	87	1	f
2090	69	1	f
2095	87	1	f
2099	12	1	f
2100	12	1	f
2101	65	1	f
2104	135	1	f
2105	135	1	f
2106	135	1	f
2107	12	1	f
2108	12	1	f
2115	39	1	f
2119	90	1	f
2126	2	1	f
2127	12	1	f
2128	65	1	f
2129	138	1	f
2130	138	1	f
2133	123	1	f
2135	12	1	f
2136	65	1	f
2137	139	1	f
2138	139	1	f
2139	139	1	f
2144	135	1	f
2145	137	1	f
2146	135	1	f
2147	137	1	f
2148	135	1	f
2149	137	1	f
2150	135	1	f
2151	137	1	f
2152	135	1	f
2153	137	1	f
2154	135	1	f
2155	137	1	f
2156	135	1	f
2157	137	1	f
2158	135	1	f
2159	137	1	f
2160	135	1	f
2161	137	1	f
2162	135	1	f
2163	137	1	f
2164	135	1	f
2165	137	1	f
2167	135	1	f
2168	137	1	f
2172	135	1	f
2173	137	1	f
2174	135	1	f
2175	137	1	f
2176	135	1	f
2177	137	1	f
2178	135	1	f
2179	137	1	f
2180	135	1	f
2181	137	1	f
2182	135	1	f
2183	137	1	f
2184	135	1	f
2185	137	1	f
2186	134	1	f
2187	135	1	f
2188	137	1	f
2189	135	1	f
2190	137	1	f
2198	123	1	f
2199	105	1	f
2200	104	1	f
2201	104	1	f
2203	104	1	f
2205	110	1	f
2206	110	1	f
2207	110	1	f
2208	110	1	f
2209	110	1	f
2210	86	1	f
2211	110	1	f
2212	110	1	f
2213	86	1	f
2214	110	1	f
2215	86	1	f
2217	12	1	f
2219	65	1	f
2222	65	1	f
2243	12	1	f
2244	12	1	f
2245	65	1	f
2246	105	1	f
2247	102	1	f
2248	141	1	f
2249	141	1	f
2254	135	1	f
2255	142	1	f
2256	135	1	f
2257	142	1	f
2258	135	1	f
2259	142	1	f
2260	135	1	f
2261	142	1	f
2262	135	1	f
2263	142	1	f
2265	135	1	f
2266	137	1	f
2268	12	1	f
2269	105	1	f
2273	135	1	f
2274	143	1	f
2276	12	1	f
2277	105	1	f
2278	135	1	f
2279	144	1	f
2282	135	1	f
2283	137	1	f
2285	135	1	f
2286	137	1	f
2287	135	1	f
2288	142	1	f
2292	12	1	f
2293	145	1	f
2294	145	1	f
2295	145	1	f
2296	12	1	f
2297	145	1	f
2299	146	1	f
2300	145	1	f
2301	146	1	f
2304	123	1	f
2305	145	1	f
2306	146	1	f
2307	87	1	f
2308	87	1	f
2309	69	1	f
2310	145	1	f
2313	145	1	f
2314	69	1	f
2315	135	1	f
2316	137	1	f
2320	12	1	f
2327	87	1	f
2328	69	1	f
2329	145	1	f
2330	145	1	f
2331	146	1	f
2332	146	1	f
2338	87	1	f
2339	69	1	f
2340	69	1	f
2341	135	1	f
2342	137	1	f
2343	135	1	f
2344	143	1	f
2366	87	1	f
2367	69	1	f
2368	145	1	f
2369	146	1	f
2373	39	1	f
2376	69	1	f
2377	135	1	f
2378	137	1	f
2379	135	1	f
2380	143	1	f
2389	105	1	f
2390	105	1	f
2391	105	1	f
2392	105	1	f
2393	105	1	f
2394	105	1	f
2395	105	1	f
2396	105	1	f
2397	105	1	f
2398	105	1	f
2399	105	1	f
2400	105	1	f
2401	105	1	f
2402	105	1	f
2403	105	1	f
2404	105	1	f
2405	105	1	f
2406	105	1	f
2407	105	1	f
2408	105	1	f
2409	105	1	f
2410	105	1	f
2411	105	1	f
2412	105	1	f
2413	105	1	f
2414	105	1	f
2415	105	1	f
2416	105	1	f
2417	105	1	f
2418	105	1	f
2419	105	1	f
2420	105	1	f
2421	105	1	f
2422	105	1	f
2423	105	1	f
2424	105	1	f
2425	105	1	f
2426	105	1	f
2427	105	1	f
2428	105	1	f
2429	105	1	f
2430	105	1	f
2431	105	1	f
2432	105	1	f
2433	145	1	f
2435	146	1	f
2437	146	1	f
2465	120	1	f
2468	119	1	f
2469	119	1	f
2470	119	1	f
2475	90	1	f
2477	47	1	f
2484	2	1	f
2489	86	1	f
2490	86	1	f
2491	86	1	f
2493	87	1	f
2501	110	1	f
2502	110	1	f
2503	119	1	f
2505	110	1	f
2506	86	1	f
2507	110	1	f
2508	110	1	f
2510	110	1	f
2511	86	1	f
2513	12	1	f
2514	65	1	f
2516	12	1	f
2517	149	1	f
2518	149	1	f
2519	47	1	f
2520	149	1	f
2521	149	1	f
2522	149	1	f
2523	149	1	f
2524	149	1	f
2525	149	1	f
2526	149	1	f
2527	149	1	f
2528	149	1	f
2529	119	1	f
2530	119	1	f
2531	119	1	f
2532	119	1	f
2533	119	1	f
2534	119	1	f
2535	119	1	f
2536	110	1	f
2537	119	1	f
2538	119	1	f
2539	110	1	f
2540	86	1	f
2541	119	1	f
2545	86	1	f
2546	110	1	f
2547	119	1	f
2548	119	1	f
2549	12	1	f
2550	87	1	f
2551	12	1	f
2552	65	1	f
2553	65	1	f
2554	65	1	f
2556	151	1	f
2557	151	1	f
2558	12	1	f
2559	151	1	f
2560	69	1	f
2561	145	1	f
2563	69	1	f
2564	145	1	f
2566	69	1	f
2567	145	1	f
2568	145	1	f
2570	69	1	f
2571	145	1	f
2573	69	1	f
2574	145	1	f
2576	69	1	f
2577	145	1	f
2578	145	1	f
2580	69	1	f
2581	145	1	f
2583	12	1	f
2585	87	1	f
2592	123	1	f
2593	69	1	f
2594	87	1	f
2595	69	1	f
2596	145	1	f
2597	145	1	f
2598	145	1	f
2602	65	1	f
2603	65	1	f
2604	65	1	f
2605	65	1	f
2608	65	1	f
2612	65	1	f
2613	65	1	f
2617	65	1	f
2631	65	1	f
2632	65	1	f
2633	65	1	f
2634	65	1	f
2635	65	1	f
2636	65	1	f
2637	65	1	f
2638	65	1	f
2642	65	1	f
2643	65	1	f
2646	65	1	f
2647	65	1	f
2648	65	1	f
2649	65	1	f
2650	65	1	f
2651	65	1	f
2652	65	1	f
2653	65	1	f
2654	65	1	f
2655	65	1	f
2665	149	1	f
2666	87	1	f
2667	69	1	f
2668	145	1	f
2670	146	1	f
2672	123	1	f
2673	39	1	f
2676	87	1	f
2677	89	1	f
2678	69	1	f
2679	69	1	f
2680	89	1	f
2681	89	1	f
2682	149	1	f
2683	89	1	f
2684	149	1	f
2685	89	1	f
2686	135	1	f
2687	137	1	f
2688	135	1	f
2689	143	1	f
2693	110	1	f
2694	110	1	f
2695	86	1	f
2698	110	1	f
2699	86	1	f
2700	119	1	f
2701	119	1	f
2702	119	1	f
2703	119	1	f
2704	119	1	f
2705	119	1	f
2706	119	1	f
2707	119	1	f
2708	119	1	f
2709	119	1	f
2710	119	1	f
2711	119	1	f
2712	119	1	f
2713	119	1	f
2715	119	1	f
2716	119	1	f
2717	119	1	f
2718	119	1	f
2719	119	1	f
2720	119	1	f
2721	119	1	f
2722	119	1	f
2724	119	1	f
2725	119	1	f
2726	110	1	f
2727	119	1	f
2728	119	1	f
2729	103	1	f
2731	123	1	f
2734	119	1	f
2735	119	1	f
2736	119	1	f
2739	69	1	f
2740	12	1	f
2741	65	1	f
2742	12	1	f
2779	123	1	f
2780	123	1	f
2781	123	1	f
2785	47	1	f
2786	2	1	f
2787	2	1	f
2790	12	1	f
\.


--
-- Name: resource_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('resource_id_seq', 2790, true);


--
-- Data for Name: resource_log; Type: TABLE DATA; Schema: test; Owner: -
--

COPY resource_log (id, resource_id, employee_id, comment, modifydt) FROM stdin;
7672	725	2	\N	2015-10-25 18:29:36.485331+02
7673	772	2	\N	2015-10-25 18:29:48.734406+02
7674	2742	2	\N	2015-10-25 21:14:37.429267+02
7675	2740	2	\N	2015-10-25 21:14:41.037197+02
7676	2583	2	\N	2015-10-25 21:14:44.152213+02
7677	2558	2	\N	2015-10-25 21:14:47.468287+02
7678	2551	2	\N	2015-10-25 21:14:50.661752+02
7679	2516	2	\N	2015-10-25 21:14:54.043974+02
7680	2513	2	\N	2015-10-25 21:14:57.515749+02
7681	2296	2	\N	2015-10-25 21:15:00.801576+02
7682	2292	2	\N	2015-10-25 21:15:04.579697+02
7683	2276	2	\N	2015-10-25 21:15:07.859876+02
7684	2268	2	\N	2015-10-25 21:15:11.41355+02
7685	2244	2	\N	2015-10-25 21:15:15.08087+02
7686	2243	2	\N	2015-10-25 21:15:18.415374+02
7687	2217	2	\N	2015-10-25 21:15:22.580956+02
7688	2135	2	\N	2015-10-25 21:15:26.822285+02
7689	2127	2	\N	2015-10-25 21:15:30.469938+02
7690	2108	2	\N	2015-10-25 21:15:35.148375+02
7691	2100	2	\N	2015-10-25 21:15:38.483633+02
7692	2099	2	\N	2015-10-25 21:15:43.982787+02
7693	2049	2	\N	2015-10-25 21:15:49.162966+02
7694	1968	2	\N	2015-10-25 21:15:53.440626+02
7695	1941	2	\N	2015-10-25 21:15:57.551908+02
7696	1884	2	\N	2015-10-25 21:16:01.935865+02
7697	1894	2	\N	2015-10-25 21:16:05.350861+02
7698	1849	2	\N	2015-10-25 21:16:08.565296+02
7699	1799	2	\N	2015-10-25 21:16:11.898419+02
7700	1797	2	\N	2015-10-25 21:16:17.305403+02
7701	1548	2	\N	2015-10-25 21:16:20.933341+02
7702	1521	2	\N	2015-10-25 21:16:24.346478+02
7703	1435	2	\N	2015-10-25 21:16:28.278231+02
7704	1433	2	\N	2015-10-25 21:16:32.204893+02
7705	1424	2	\N	2015-10-25 21:16:37.127758+02
7706	1393	2	\N	2015-10-25 21:16:40.502794+02
7707	1317	2	\N	2015-10-25 21:16:43.978797+02
7708	1313	2	\N	2015-10-25 21:16:48.394405+02
7709	1268	2	\N	2015-10-25 21:16:52.253586+02
7710	1225	2	\N	2015-10-25 21:16:55.883212+02
7711	1211	2	\N	2015-10-25 21:17:02.365419+02
7712	1207	2	\N	2015-10-25 21:17:11.228895+02
7713	1198	2	\N	2015-10-25 21:17:14.605706+02
7714	1190	2	\N	2015-10-25 21:17:17.962226+02
7715	1189	2	\N	2015-10-25 21:17:22.169824+02
7716	1088	2	\N	2015-10-25 21:17:27.123342+02
7717	1081	2	\N	2015-10-25 21:17:30.484303+02
7718	1007	2	\N	2015-10-25 21:17:33.84324+02
7719	1003	2	\N	2015-10-25 21:17:37.28513+02
7720	954	2	\N	2015-10-25 21:17:41.191895+02
7721	953	2	\N	2015-10-25 21:17:45.458502+02
7722	909	2	\N	2015-10-25 21:17:49.385186+02
7723	908	2	\N	2015-10-25 21:17:53.112889+02
7724	901	2	\N	2015-10-25 21:17:58.692045+02
7725	872	2	\N	2015-10-25 21:18:02.214698+02
7726	865	2	\N	2015-10-25 21:18:05.09372+02
7727	788	2	\N	2015-10-25 21:18:08.146867+02
7728	775	2	\N	2015-10-25 21:18:11.413701+02
7729	769	2	\N	2015-10-25 21:18:14.703555+02
7730	764	2	\N	2015-10-25 21:18:17.786192+02
7731	723	2	\N	2015-10-25 21:18:21.267664+02
7732	706	2	\N	2015-10-25 21:18:24.219742+02
7733	283	2	\N	2015-10-25 21:18:27.627488+02
7734	274	2	\N	2015-10-25 21:18:30.883104+02
7735	16	2	\N	2015-10-25 21:18:33.921184+02
7736	10	2	\N	2015-10-25 21:18:37.163922+02
7737	773	2	\N	2015-10-25 21:18:49.306767+02
7738	3	2	\N	2015-10-25 21:19:10.539731+02
7739	784	2	\N	2015-10-25 21:19:27.565925+02
7740	789	2	\N	2015-10-25 21:19:38.951573+02
7741	772	2	\N	2015-10-25 21:19:53.535469+02
7742	1100	2	\N	2015-10-25 21:20:18.256979+02
7743	1095	2	\N	2015-10-25 21:20:21.415245+02
7744	883	2	\N	2015-10-25 21:20:24.411401+02
7745	882	2	\N	2015-10-25 21:20:27.610602+02
7746	881	2	\N	2015-10-25 21:20:30.548418+02
7747	880	2	\N	2015-10-25 21:20:34.03857+02
7748	878	2	\N	2015-10-25 21:20:36.956871+02
7749	2788	2	\N	2015-11-15 11:41:32.753196+02
7750	2741	2	\N	2015-11-15 11:42:42.182101+02
7752	2790	2	\N	2015-11-22 22:04:31.745001+02
\.


--
-- Name: resource_log_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('resource_log_id_seq', 7752, true);


--
-- Data for Name: resource_type; Type: TABLE DATA; Schema: test; Owner: -
--

COPY resource_type (id, resource_id, name, humanize, resource_name, module, settings, descr, status) FROM stdin;
145	2292	leads_items	Leads Items	LeadsItemsResource	travelcrm.resources.leads_items	null	Leads Items	0
103	1317	invoices	Invoices	InvoicesResource	travelcrm.resources.invoices	{"active_days": 3}	Invoices list. Invoice can't be created manualy - only using source document such as Tours	0
87	1190	contacts	Contacts	ContactsResource	travelcrm.resources.contacts	null	Contacts for persons, business persons etc.	0
148	2513	vats	Vat	VatsResource	travelcrm.resources.vats	null	Vat for accounts and services	0
2	10	users	Users	UsersResource	travelcrm.resources.users	null	Users list	0
149	2516	uploads	Uploads	UploadsResource	travelcrm.resources.uploads	null	Uploads for any type of resources	0
151	2551	persons_categories	Persons Categories	PersonsCategoriesResource	travelcrm.resources.persons_categories	null	Categorise your clients with categories of persons	0
12	16	resources_types	Resources Types	ResourcesTypesResource	travelcrm.resources.resources_types	null	Resources types list	0
39	274	regions	Regions	RegionsResource	travelcrm.resources.regions	null		0
41	283	currencies	Currencies	CurrenciesResource	travelcrm.resources.currencies	null		0
47	706	employees	Employees	EmployeesResource	travelcrm.resources.employees	null	Employees Container Datagrid	0
55	723	structures	Structures	StructuresResource	travelcrm.resources.structures	null	Companies structures is a tree of company structure. It's can be offices, filials, departments and so and so	0
59	764	positions	Positions	PositionsResource	travelcrm.resources.positions	null	Companies positions is a point of company structure where emplyees can be appointed	0
61	769	permisions	Permisions	PermisionsResource	travelcrm.resources.permisions	null	Permisions list of company structure position. It's list of resources and permisions	0
65	775	navigations	Navigations	NavigationsResource	travelcrm.resources.navigations	null	Navigations list of company structure position.	0
67	788	appointments	Appointments	AppointmentsResource	travelcrm.resources.appointments	null	Employees to positions of company appointments	0
69	865	persons	Persons	PersonsResource	travelcrm.resources.persons	null	Persons directory. Person can be client or potential client	0
70	872	countries	Countries	CountriesResource	travelcrm.resources.countries	null	Countries directory	0
71	901	advsources	Advertises Sources	AdvsourcesResource	travelcrm.resources.advsources	null	Types of advertises	0
72	908	hotelcats	Hotels Categories	HotelcatsResource	travelcrm.resources.hotelcats	null	Hotels categories	0
73	909	roomcats	Rooms Categories	RoomcatsResource	travelcrm.resources.roomcats	null	Categories of the rooms	0
75	954	foodcats	Foods Categories	FoodcatsResource	travelcrm.resources.foodcats	null	Food types in hotels	0
78	1003	suppliers	Suppliers	SuppliersResource	travelcrm.resources.suppliers	null	Suppliers, such as touroperators, aircompanies, IATA etc.	0
79	1007	bpersons	Business Persons	BPersonsResource	travelcrm.resources.bpersons	null	Business Persons is not clients it's simple business contacts that can be referenced objects that needs to have contacts	0
83	1081	hotels	Hotels	HotelsResource	travelcrm.resources.hotels	null	Hotels directory	0
84	1088	locations	Locations	LocationsResource	travelcrm.resources.locations	null	Locations list is list of cities, vilages etc. places to use to identify part of region	0
86	1189	contracts	Contracts	ContractsResource	travelcrm.resources.contracts	null	Licences list for any type of resources as need	0
89	1198	passports	Passports	PassportsResource	travelcrm.resources.passports	null	Clients persons passports lists	0
90	1207	addresses	Addresses	AddressesResource	travelcrm.resources.addresses	null	Addresses of any type of resources, such as persons, bpersons, hotels etc.	0
91	1211	banks	Banks	BanksResource	travelcrm.resources.banks	null	Banks list to create bank details and for other reasons	0
93	1225	tasks	Tasks	TasksResource	travelcrm.resources.tasks	null	Task manager	0
101	1268	banks_details	Banks Details	BanksDetailsResource	travelcrm.resources.banks_details	null	Banks Details that can be attached to any client or business partner to define account	0
102	1313	services	Services	ServicesResource	travelcrm.resources.services	null	Additional Services that can be provide with tours sales or separate	0
104	1393	currencies_rates	Currency Rates	CurrenciesRatesResource	travelcrm.resources.currencies_rates	null	Currencies Rates. Values from this dir used by billing to calc prices in base currency.	0
105	1424	accounts_items	Accounts Items	AccountsItemsResource	travelcrm.resources.accounts_items	null	Finance accounts items	0
106	1433	incomes	Incomes	IncomesResource	travelcrm.resources.incomes	{"account_item_id": 8}	Incomes Payments Document for invoices	0
107	1435	accounts	Accounts	AccountsResource	travelcrm.resources.accounts	null	Billing Accounts. It can be bank accouts, cash accounts etc. and has company wide visible	0
117	1797	subaccounts	Subaccounts	SubaccountsResource	travelcrm.resources.subaccounts	null	Subaccounts are accounts from other objects such as clients, touroperators and so on	0
118	1799	notes	Notes	NotesResource	travelcrm.resources.notes	null	Resources Notes	0
119	1849	calculations	Caluclations	CalculationsResource	travelcrm.resources.calculations	null	Calculations of Sale Documents	0
121	1894	turnovers	Turnovers	TurnoversResource	travelcrm.resources.turnovers	null	Turnovers on Accounts and Subaccounts	0
126	1968	companies	Companies	CompaniesResource	travelcrm.resources.companies	null	Multicompanies functionality	0
130	2049	leads	Leads	LeadsResource	travelcrm.resources.leads	null	Leads that can be converted into contacts	0
134	2099	orders	Orders	OrdersResource	travelcrm.resources.orders	null	Orders	0
135	2100	orders_items	Orders Items	OrdersItemsResource	travelcrm.resources.orders_items	null	Orders Items	0
137	2108	tours	Tours	ToursResource	travelcrm.resources.tours	null	Tour Service	0
74	953	accomodations	Accomodations	AccomodationsResource	travelcrm.resources.accomodations	null	Accomodations Types list	0
110	1521	commissions	Commissions	CommissionsResource	travelcrm.resources.commissions	null	Services sales commissions	0
111	1548	outgoings	Outgoings	OutgoingsResource	travelcrm.resources.outgoings	null	Outgoings payments for touroperators, suppliers, payback payments and so on	0
1	773	 	Home	Root	travelcrm.resources	null	Home Page of Travelcrm	0
146	2296	leads_offers	Leads Offers	LeadsOffersResource	travelcrm.resources.leads_offers	null	Leads Offers	0
152	2558	leads_stats	Leads Stats	LeadsStatsResource	travelcrm.resources.leads_stats	{"column_index": 0}	Portlet with leads statistics	0
120	1884	crosspayments	Cross Payments	CrosspaymentsResource	travelcrm.resources.crosspayments	null	Cross payments between accounts and subaccounts. This document is for balance corrections to.	0
153	2583	activities	Activities	ActivitiesResource	travelcrm.resources.activities	{"column_index": 1}	My last activities	0
123	1941	notifications	Notifications	NotificationsResource	travelcrm.resources.notifications	null	Employee Notifications	0
138	2127	transfers	Transfers	TransfersResource	travelcrm.resources.transfers	null	Transfers for tours	0
139	2135	transports	Transports	TransportsResource	travelcrm.resources.transports	null	Transports Types List	0
140	2217	suppliers_types	Suppliers Types	SuppliersTypesResource	travelcrm.resources.suppliers_types	null	Suppliers Types list	0
141	2243	tickets_classes	Tickets Classes	TicketsClassesResource	travelcrm.resources.tickets_classes	null	Tickets Classes list, such as first class, business class etc	0
142	2244	tickets	Tickets	TicketsResource	travelcrm.resources.tickets	null	Ticket is a service for sale tickets of any type	0
143	2268	visas	Visas	VisasResource	travelcrm.resources.visas	null	Visa is a service for sale visas	0
144	2276	spassports	Passports Services	SpassportsResource	travelcrm.resources.spassports	null	Service formulation of foreign passports	0
156	2788	campaigns	Campaigns	CampaignsResource	travelcrm.resources.campaigns	{"username": "--", "host": "--", "password": "--", "port": "2525", "default_sender": "--"}	Marketings campaigns	0
\.


--
-- Name: resource_type_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('resource_type_id_seq', 157, true);


--
-- Data for Name: roomcat; Type: TABLE DATA; Schema: test; Owner: -
--

COPY roomcat (id, resource_id, name) FROM stdin;
\.


--
-- Name: roomcat_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('roomcat_id_seq', 1, true);


--
-- Data for Name: service; Type: TABLE DATA; Schema: test; Owner: -
--

COPY service (id, resource_id, resource_type_id, name, display_text, descr) FROM stdin;
7	2247	142	Ticket	Ticket booking service	\N
5	1413	137	Tour	Tour booking service	Use this service for tour sales
4	1318	143	A visa	The issues for visas	\N
1	1314	144	Foreign Passport Service	Formulation of foreign passport	\N
\.


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('service_id_seq', 7, true);


--
-- Data for Name: spassport; Type: TABLE DATA; Schema: test; Owner: -
--

COPY spassport (id, resource_id, photo_done, docs_receive_date, docs_transfer_date, passport_receive_date, descr) FROM stdin;
\.


--
-- Name: spassport_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('spassport_id_seq', 1, true);


--
-- Data for Name: spassport_order_item; Type: TABLE DATA; Schema: test; Owner: -
--

COPY spassport_order_item (order_item_id, spassport_id) FROM stdin;
\.


--
-- Data for Name: structure; Type: TABLE DATA; Schema: test; Owner: -
--

COPY structure (id, resource_id, parent_id, company_id, name) FROM stdin;
1	725	\N	1	Head Office
\.


--
-- Data for Name: structure_address; Type: TABLE DATA; Schema: test; Owner: -
--

COPY structure_address (structure_id, address_id) FROM stdin;
\.


--
-- Data for Name: structure_bank_detail; Type: TABLE DATA; Schema: test; Owner: -
--

COPY structure_bank_detail (structure_id, bank_detail_id) FROM stdin;
\.


--
-- Data for Name: structure_contact; Type: TABLE DATA; Schema: test; Owner: -
--

COPY structure_contact (structure_id, contact_id) FROM stdin;
\.


--
-- Name: structure_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('structure_id_seq', 1, true);


--
-- Data for Name: subaccount; Type: TABLE DATA; Schema: test; Owner: -
--

COPY subaccount (id, resource_id, account_id, name, status, descr) FROM stdin;
\.


--
-- Name: subaccount_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('subaccount_id_seq', 1, true);


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: test; Owner: -
--

COPY supplier (id, resource_id, supplier_type_id, name, status, descr) FROM stdin;
\.


--
-- Data for Name: supplier_bank_detail; Type: TABLE DATA; Schema: test; Owner: -
--

COPY supplier_bank_detail (supplier_id, bank_detail_id) FROM stdin;
\.


--
-- Data for Name: supplier_bperson; Type: TABLE DATA; Schema: test; Owner: -
--

COPY supplier_bperson (supplier_id, bperson_id) FROM stdin;
\.


--
-- Data for Name: supplier_contract; Type: TABLE DATA; Schema: test; Owner: -
--

COPY supplier_contract (supplier_id, contract_id) FROM stdin;
\.


--
-- Name: supplier_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('supplier_id_seq', 1, true);


--
-- Data for Name: supplier_subaccount; Type: TABLE DATA; Schema: test; Owner: -
--

COPY supplier_subaccount (supplier_id, subaccount_id) FROM stdin;
\.


--
-- Data for Name: supplier_type; Type: TABLE DATA; Schema: test; Owner: -
--

COPY supplier_type (id, resource_id, name, descr) FROM stdin;
\.


--
-- Name: supplier_type_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('supplier_type_id_seq', 1, true);


--
-- Data for Name: task; Type: TABLE DATA; Schema: test; Owner: -
--

COPY task (id, resource_id, employee_id, title, deadline, reminder, descr, status) FROM stdin;
\.


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('task_id_seq', 1, true);


--
-- Data for Name: task_resource; Type: TABLE DATA; Schema: test; Owner: -
--

COPY task_resource (task_id, resource_id) FROM stdin;
\.


--
-- Data for Name: task_upload; Type: TABLE DATA; Schema: test; Owner: -
--

COPY task_upload (task_id, upload_id) FROM stdin;
\.


--
-- Data for Name: ticket; Type: TABLE DATA; Schema: test; Owner: -
--

COPY ticket (id, resource_id, start_location_id, end_location_id, ticket_class_id, transport_id, start_dt, start_additional_info, end_dt, end_additional_info, adults, children, descr) FROM stdin;
\.


--
-- Data for Name: ticket_class; Type: TABLE DATA; Schema: test; Owner: -
--

COPY ticket_class (id, resource_id, name) FROM stdin;
\.


--
-- Name: ticket_class_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('ticket_class_id_seq', 1, true);


--
-- Name: ticket_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('ticket_id_seq', 1, true);


--
-- Data for Name: ticket_order_item; Type: TABLE DATA; Schema: test; Owner: -
--

COPY ticket_order_item (order_item_id, ticket_id) FROM stdin;
\.


--
-- Data for Name: tour; Type: TABLE DATA; Schema: test; Owner: -
--

COPY tour (id, resource_id, start_location_id, start_transport_id, end_location_id, end_transport_id, hotel_id, accomodation_id, foodcat_id, roomcat_id, transfer_id, adults, children, start_date, start_additional_info, end_date, end_additional_info, descr) FROM stdin;
\.


--
-- Name: tour_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('tour_id_seq', 1, true);


--
-- Data for Name: tour_order_item; Type: TABLE DATA; Schema: test; Owner: -
--

COPY tour_order_item (order_item_id, tour_id) FROM stdin;
\.


--
-- Data for Name: transfer; Type: TABLE DATA; Schema: test; Owner: -
--

COPY transfer (id, resource_id, name) FROM stdin;
\.


--
-- Name: transfer_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('transfer_id_seq', 1, true);


--
-- Data for Name: transport; Type: TABLE DATA; Schema: test; Owner: -
--

COPY transport (id, resource_id, name) FROM stdin;
\.


--
-- Name: transport_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('transport_id_seq', 1, true);


--
-- Data for Name: upload; Type: TABLE DATA; Schema: test; Owner: -
--

COPY upload (id, resource_id, name, path, size, media_type, descr) FROM stdin;
\.


--
-- Name: upload_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('upload_id_seq', 1, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: test; Owner: -
--

COPY "user" (id, resource_id, employee_id, username, email, password) FROM stdin;
2	3	2	admin	admin@mail.ru	adminadmin
\.


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('user_id_seq', 2, true);


--
-- Data for Name: vat; Type: TABLE DATA; Schema: test; Owner: -
--

COPY vat (id, resource_id, account_id, service_id, date, vat, calc_method, descr) FROM stdin;
\.


--
-- Name: vat_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('vat_id_seq', 1, true);


--
-- Data for Name: visa; Type: TABLE DATA; Schema: test; Owner: -
--

COPY visa (id, resource_id, country_id, start_date, end_date, type, descr) FROM stdin;
\.


--
-- Name: visa_id_seq; Type: SEQUENCE SET; Schema: test; Owner: -
--

SELECT pg_catalog.setval('visa_id_seq', 1, true);


--
-- Data for Name: visa_order_item; Type: TABLE DATA; Schema: test; Owner: -
--

COPY visa_order_item (order_item_id, visa_id) FROM stdin;
\.


SET search_path = company, pg_catalog;

--
-- Name: accomodation_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT accomodation_pkey PRIMARY KEY (id);


--
-- Name: account_item_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT account_item_pkey PRIMARY KEY (id);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: advsource_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT advsource_pkey PRIMARY KEY (id);


--
-- Name: appointment_header_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT appointment_header_pk PRIMARY KEY (id);


--
-- Name: bank_address_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT bank_address_pkey PRIMARY KEY (bank_id, address_id);


--
-- Name: bank_detail_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT bank_detail_pkey PRIMARY KEY (id);


--
-- Name: bank_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (id);


--
-- Name: bperson_contact_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT bperson_contact_pkey PRIMARY KEY (bperson_id, contact_id);


--
-- Name: bperson_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bperson
    ADD CONSTRAINT bperson_pkey PRIMARY KEY (id);


--
-- Name: calculation_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT calculation_pkey PRIMARY KEY (id);


--
-- Name: campaign_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY campaign
    ADD CONSTRAINT campaign_pkey PRIMARY KEY (id);


--
-- Name: commission_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT commission_pkey PRIMARY KEY (id);


--
-- Name: company_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


--
-- Name: company_subaccount_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT company_subaccount_pkey PRIMARY KEY (company_id, subaccount_id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: contract_commission_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT contract_commission_pkey PRIMARY KEY (contract_id, commission_id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: crosspayment_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT crosspayment_pkey PRIMARY KEY (id);


--
-- Name: currency_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT currency_pk PRIMARY KEY (id);


--
-- Name: currency_rate_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT currency_rate_pkey PRIMARY KEY (id);


--
-- Name: employee_address_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT employee_address_pkey PRIMARY KEY (employee_id, address_id);


--
-- Name: employee_contact_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT employee_contact_pkey PRIMARY KEY (employee_id, contact_id);


--
-- Name: employee_notification_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT employee_notification_pkey PRIMARY KEY (employee_id, notification_id);


--
-- Name: employee_passport_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT employee_passport_pkey PRIMARY KEY (employee_id, passport_id);


--
-- Name: employee_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pk PRIMARY KEY (id);


--
-- Name: employee_subaccount_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT employee_subaccount_pkey PRIMARY KEY (employee_id, subaccount_id);


--
-- Name: employee_upload_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT employee_upload_pkey PRIMARY KEY (employee_id, upload_id);


--
-- Name: foodcat_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT foodcat_pkey PRIMARY KEY (id);


--
-- Name: hotel_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (id);


--
-- Name: hotelcat_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT hotelcat_pkey PRIMARY KEY (id);


--
-- Name: income_cashflow_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT income_cashflow_pkey PRIMARY KEY (income_id, cashflow_id);


--
-- Name: income_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY income
    ADD CONSTRAINT income_pkey PRIMARY KEY (id);


--
-- Name: invoice_item_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT invoice_item_pkey PRIMARY KEY (id);


--
-- Name: invoice_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);


--
-- Name: lead_item_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT lead_item_pkey PRIMARY KEY (id);


--
-- Name: lead_offer_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT lead_offer_pkey PRIMARY KEY (id);


--
-- Name: lead_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT lead_pkey PRIMARY KEY (id);


--
-- Name: licence_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT licence_pkey PRIMARY KEY (id);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: navigation_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT navigation_pk PRIMARY KEY (id);


--
-- Name: note_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_pkey PRIMARY KEY (id);


--
-- Name: note_resource_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT note_resource_pkey PRIMARY KEY (note_id, resource_id);


--
-- Name: note_upload_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT note_upload_pkey PRIMARY KEY (note_id, upload_id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_resource_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT notification_resource_pkey PRIMARY KEY (notification_id, resource_id);


--
-- Name: order_item_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: outgoing_cashflow_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT outgoing_cashflow_pkey PRIMARY KEY (outgoing_id, cashflow_id);


--
-- Name: outgoing_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT outgoing_pkey PRIMARY KEY (id);


--
-- Name: passport_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY (id);


--
-- Name: passport_upload_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT passport_upload_pkey PRIMARY KEY (passport_id, upload_id);


--
-- Name: permision_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT permision_pk PRIMARY KEY (id);


--
-- Name: person_address_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT person_address_pkey PRIMARY KEY (person_id, address_id);


--
-- Name: person_category_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT person_category_pkey PRIMARY KEY (id);


--
-- Name: person_contact_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT person_contact_pkey PRIMARY KEY (person_id, contact_id);


--
-- Name: person_order_item_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT person_order_item_pkey PRIMARY KEY (order_item_id, person_id);


--
-- Name: person_passport_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT person_passport_pkey PRIMARY KEY (person_id, passport_id);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: person_subaccount_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT person_subaccount_pkey PRIMARY KEY (person_id, subaccount_id);


--
-- Name: position_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT position_pk PRIMARY KEY (id);


--
-- Name: region_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pk PRIMARY KEY (id);


--
-- Name: resource_log_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT resource_log_pk PRIMARY KEY (id);


--
-- Name: resource_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_pk PRIMARY KEY (id);


--
-- Name: resource_type_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT resource_type_pk PRIMARY KEY (id);


--
-- Name: roomcat_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT roomcat_pkey PRIMARY KEY (id);


--
-- Name: service_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: spassport_order_item_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT spassport_order_item_pkey PRIMARY KEY (order_item_id, spassport_id);


--
-- Name: spassport_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY spassport
    ADD CONSTRAINT spassport_pkey PRIMARY KEY (id);


--
-- Name: structure_address_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT structure_address_pkey PRIMARY KEY (structure_id, address_id);


--
-- Name: structure_bank_detail_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT structure_bank_detail_pkey PRIMARY KEY (structure_id, bank_detail_id);


--
-- Name: structure_contact_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT structure_contact_pkey PRIMARY KEY (structure_id, contact_id);


--
-- Name: structure_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT structure_pk PRIMARY KEY (id);


--
-- Name: subaccount_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT subaccount_pkey PRIMARY KEY (id);


--
-- Name: supplier_bank_detail_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT supplier_bank_detail_pkey PRIMARY KEY (supplier_id, bank_detail_id);


--
-- Name: supplier_bperson_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT supplier_bperson_pkey PRIMARY KEY (supplier_id, bperson_id);


--
-- Name: supplier_contract_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT supplier_contract_pkey PRIMARY KEY (supplier_id, contract_id);


--
-- Name: supplier_subaccount_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT supplier_subaccount_pkey PRIMARY KEY (supplier_id, subaccount_id);


--
-- Name: supplier_type_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT supplier_type_pkey PRIMARY KEY (id);


--
-- Name: task_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: task_resource_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT task_resource_pkey PRIMARY KEY (task_id, resource_id);


--
-- Name: task_upload_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT task_upload_pkey PRIMARY KEY (task_id, upload_id);


--
-- Name: ticket_class_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT ticket_class_pkey PRIMARY KEY (id);


--
-- Name: ticket_order_item_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT ticket_order_item_pkey PRIMARY KEY (order_item_id, ticket_id);


--
-- Name: ticket_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- Name: tour_order_item_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT tour_order_item_pkey PRIMARY KEY (order_item_id, tour_id);


--
-- Name: tour_pkey1; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT tour_pkey1 PRIMARY KEY (id);


--
-- Name: touroperator_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT touroperator_pkey PRIMARY KEY (id);


--
-- Name: transfer_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT transfer_pkey PRIMARY KEY (id);


--
-- Name: transfer_pkey1; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_pkey1 PRIMARY KEY (id);


--
-- Name: transport_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT transport_pkey PRIMARY KEY (id);


--
-- Name: uni_list_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY uni_list
    ADD CONSTRAINT uni_list_pkey PRIMARY KEY (id);


--
-- Name: unique_idx_accomodation_name; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT unique_idx_accomodation_name UNIQUE (name);


--
-- Name: unique_idx_country_iso_code; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT unique_idx_country_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_currency_iso_code; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT unique_idx_currency_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_currency_rate_currency_id_date; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT unique_idx_currency_rate_currency_id_date UNIQUE (currency_id, date, supplier_id);


--
-- Name: unique_idx_name_account; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT unique_idx_name_account UNIQUE (name);


--
-- Name: unique_idx_name_account_id_subaccount; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT unique_idx_name_account_id_subaccount UNIQUE (name, account_id);


--
-- Name: unique_idx_name_account_item; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT unique_idx_name_account_item UNIQUE (name);


--
-- Name: unique_idx_name_advsource; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT unique_idx_name_advsource UNIQUE (name);


--
-- Name: unique_idx_name_bank; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT unique_idx_name_bank UNIQUE (name);


--
-- Name: unique_idx_name_company; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT unique_idx_name_company UNIQUE (name);


--
-- Name: unique_idx_name_country_id_region; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT unique_idx_name_country_id_region UNIQUE (name, country_id);


--
-- Name: unique_idx_name_foodcat; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT unique_idx_name_foodcat UNIQUE (name);


--
-- Name: unique_idx_name_hotelcat; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT unique_idx_name_hotelcat UNIQUE (name);


--
-- Name: unique_idx_name_person_category; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT unique_idx_name_person_category UNIQUE (name);


--
-- Name: unique_idx_name_region_id_location; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT unique_idx_name_region_id_location UNIQUE (name, region_id);


--
-- Name: unique_idx_name_roomcat; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT unique_idx_name_roomcat UNIQUE (name);


--
-- Name: unique_idx_name_service; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT unique_idx_name_service UNIQUE (name);


--
-- Name: unique_idx_name_strcuture_id_position; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT unique_idx_name_strcuture_id_position UNIQUE (name, structure_id);


--
-- Name: unique_idx_name_supplier_type; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT unique_idx_name_supplier_type UNIQUE (name);


--
-- Name: unique_idx_name_ticket_class; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT unique_idx_name_ticket_class UNIQUE (name);


--
-- Name: unique_idx_name_transfer; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT unique_idx_name_transfer UNIQUE (name);


--
-- Name: unique_idx_name_transport; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT unique_idx_name_transport UNIQUE (name);


--
-- Name: unique_idx_name_uni_list; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY uni_list
    ADD CONSTRAINT unique_idx_name_uni_list UNIQUE (name);


--
-- Name: unique_idx_path_upload; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT unique_idx_path_upload UNIQUE (path);


--
-- Name: unique_idx_resource_type_id_position_id_permision; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT unique_idx_resource_type_id_position_id_permision UNIQUE (resource_type_id, position_id);


--
-- Name: unique_idx_resource_type_module; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT unique_idx_resource_type_module UNIQUE (module, resource_name);


--
-- Name: unique_idx_resource_type_name; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT unique_idx_resource_type_name UNIQUE (name);


--
-- Name: unique_idx_users_email; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_idx_users_email UNIQUE (email);


--
-- Name: unique_idx_users_username; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_idx_users_username UNIQUE (username);


--
-- Name: upload_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT upload_pkey PRIMARY KEY (id);


--
-- Name: user_pk; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- Name: vat_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT vat_pkey PRIMARY KEY (id);


--
-- Name: visa_order_item_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT visa_order_item_pkey PRIMARY KEY (order_item_id, visa_id);


--
-- Name: visa_pkey; Type: CONSTRAINT; Schema: company; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT visa_pkey PRIMARY KEY (id);


SET search_path = demo_ru, pg_catalog;

--
-- Name: accomodation_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT accomodation_pkey PRIMARY KEY (id);


--
-- Name: account_item_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT account_item_pkey PRIMARY KEY (id);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: advsource_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT advsource_pkey PRIMARY KEY (id);


--
-- Name: appointment_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (id);


--
-- Name: bank_address_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT bank_address_pkey PRIMARY KEY (bank_id, address_id);


--
-- Name: bank_detail_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT bank_detail_pkey PRIMARY KEY (id);


--
-- Name: bank_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (id);


--
-- Name: bperson_contact_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT bperson_contact_pkey PRIMARY KEY (bperson_id, contact_id);


--
-- Name: bperson_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bperson
    ADD CONSTRAINT bperson_pkey PRIMARY KEY (id);


--
-- Name: calculation_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT calculation_pkey PRIMARY KEY (id);


--
-- Name: campaign_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY campaign
    ADD CONSTRAINT campaign_pkey PRIMARY KEY (id);


--
-- Name: cashflow_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT cashflow_pkey PRIMARY KEY (id);


--
-- Name: commission_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT commission_pkey PRIMARY KEY (id);


--
-- Name: company_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


--
-- Name: company_subaccount_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT company_subaccount_pkey PRIMARY KEY (company_id, subaccount_id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: contract_commission_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT contract_commission_pkey PRIMARY KEY (contract_id, commission_id);


--
-- Name: contract_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: crosspayment_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT crosspayment_pkey PRIMARY KEY (id);


--
-- Name: currency_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (id);


--
-- Name: currency_rate_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT currency_rate_pkey PRIMARY KEY (id);


--
-- Name: employee_address_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT employee_address_pkey PRIMARY KEY (employee_id, address_id);


--
-- Name: employee_contact_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT employee_contact_pkey PRIMARY KEY (employee_id, contact_id);


--
-- Name: employee_notification_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT employee_notification_pkey PRIMARY KEY (employee_id, notification_id);


--
-- Name: employee_passport_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT employee_passport_pkey PRIMARY KEY (employee_id, passport_id);


--
-- Name: employee_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- Name: employee_subaccount_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT employee_subaccount_pkey PRIMARY KEY (employee_id, subaccount_id);


--
-- Name: employee_upload_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT employee_upload_pkey PRIMARY KEY (employee_id, upload_id);


--
-- Name: foodcat_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT foodcat_pkey PRIMARY KEY (id);


--
-- Name: hotel_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (id);


--
-- Name: hotelcat_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT hotelcat_pkey PRIMARY KEY (id);


--
-- Name: income_cashflow_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT income_cashflow_pkey PRIMARY KEY (income_id, cashflow_id);


--
-- Name: income_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY income
    ADD CONSTRAINT income_pkey PRIMARY KEY (id);


--
-- Name: invoice_item_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT invoice_item_pkey PRIMARY KEY (id);


--
-- Name: invoice_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);


--
-- Name: lead_item_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT lead_item_pkey PRIMARY KEY (id);


--
-- Name: lead_offer_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT lead_offer_pkey PRIMARY KEY (id);


--
-- Name: lead_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT lead_pkey PRIMARY KEY (id);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: navigation_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT navigation_pkey PRIMARY KEY (id);


--
-- Name: note_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_pkey PRIMARY KEY (id);


--
-- Name: note_resource_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT note_resource_pkey PRIMARY KEY (note_id, resource_id);


--
-- Name: note_upload_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT note_upload_pkey PRIMARY KEY (note_id, upload_id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_resource_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT notification_resource_pkey PRIMARY KEY (notification_id, resource_id);


--
-- Name: order_item_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: outgoing_cashflow_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT outgoing_cashflow_pkey PRIMARY KEY (outgoing_id, cashflow_id);


--
-- Name: outgoing_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT outgoing_pkey PRIMARY KEY (id);


--
-- Name: passport_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY (id);


--
-- Name: passport_upload_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT passport_upload_pkey PRIMARY KEY (passport_id, upload_id);


--
-- Name: permision_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT permision_pkey PRIMARY KEY (id);


--
-- Name: person_address_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT person_address_pkey PRIMARY KEY (person_id, address_id);


--
-- Name: person_category_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT person_category_pkey PRIMARY KEY (id);


--
-- Name: person_contact_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT person_contact_pkey PRIMARY KEY (person_id, contact_id);


--
-- Name: person_order_item_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT person_order_item_pkey PRIMARY KEY (order_item_id, person_id);


--
-- Name: person_passport_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT person_passport_pkey PRIMARY KEY (person_id, passport_id);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: person_subaccount_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT person_subaccount_pkey PRIMARY KEY (person_id, subaccount_id);


--
-- Name: position_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (id);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: resource_log_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT resource_log_pkey PRIMARY KEY (id);


--
-- Name: resource_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- Name: resource_type_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT resource_type_pkey PRIMARY KEY (id);


--
-- Name: roomcat_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT roomcat_pkey PRIMARY KEY (id);


--
-- Name: service_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: spassport_order_item_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT spassport_order_item_pkey PRIMARY KEY (order_item_id, spassport_id);


--
-- Name: spassport_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY spassport
    ADD CONSTRAINT spassport_pkey PRIMARY KEY (id);


--
-- Name: structure_address_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT structure_address_pkey PRIMARY KEY (structure_id, address_id);


--
-- Name: structure_bank_detail_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT structure_bank_detail_pkey PRIMARY KEY (structure_id, bank_detail_id);


--
-- Name: structure_contact_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT structure_contact_pkey PRIMARY KEY (structure_id, contact_id);


--
-- Name: structure_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT structure_pkey PRIMARY KEY (id);


--
-- Name: subaccount_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT subaccount_pkey PRIMARY KEY (id);


--
-- Name: supplier_bank_detail_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT supplier_bank_detail_pkey PRIMARY KEY (supplier_id, bank_detail_id);


--
-- Name: supplier_bperson_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT supplier_bperson_pkey PRIMARY KEY (supplier_id, bperson_id);


--
-- Name: supplier_contract_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT supplier_contract_pkey PRIMARY KEY (supplier_id, contract_id);


--
-- Name: supplier_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- Name: supplier_subaccount_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT supplier_subaccount_pkey PRIMARY KEY (supplier_id, subaccount_id);


--
-- Name: supplier_type_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT supplier_type_pkey PRIMARY KEY (id);


--
-- Name: task_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: task_resource_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT task_resource_pkey PRIMARY KEY (task_id, resource_id);


--
-- Name: task_upload_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT task_upload_pkey PRIMARY KEY (task_id, upload_id);


--
-- Name: ticket_class_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT ticket_class_pkey PRIMARY KEY (id);


--
-- Name: ticket_order_item_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT ticket_order_item_pkey PRIMARY KEY (order_item_id, ticket_id);


--
-- Name: ticket_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- Name: tour_order_item_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT tour_order_item_pkey PRIMARY KEY (order_item_id, tour_id);


--
-- Name: tour_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT tour_pkey PRIMARY KEY (id);


--
-- Name: transfer_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_pkey PRIMARY KEY (id);


--
-- Name: transport_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT transport_pkey PRIMARY KEY (id);


--
-- Name: unique_idx_accomodation_name; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT unique_idx_accomodation_name UNIQUE (name);


--
-- Name: unique_idx_country_iso_code; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT unique_idx_country_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_currency_iso_code; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT unique_idx_currency_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_currency_rate_currency_id_date; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT unique_idx_currency_rate_currency_id_date UNIQUE (currency_id, date, supplier_id);


--
-- Name: unique_idx_name_account; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT unique_idx_name_account UNIQUE (name);


--
-- Name: unique_idx_name_account_id_subaccount; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT unique_idx_name_account_id_subaccount UNIQUE (name, account_id);


--
-- Name: unique_idx_name_account_item; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT unique_idx_name_account_item UNIQUE (name);


--
-- Name: unique_idx_name_advsource; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT unique_idx_name_advsource UNIQUE (name);


--
-- Name: unique_idx_name_bank; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT unique_idx_name_bank UNIQUE (name);


--
-- Name: unique_idx_name_company; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT unique_idx_name_company UNIQUE (name);


--
-- Name: unique_idx_name_country_id_region; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT unique_idx_name_country_id_region UNIQUE (name, country_id);


--
-- Name: unique_idx_name_foodcat; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT unique_idx_name_foodcat UNIQUE (name);


--
-- Name: unique_idx_name_hotelcat; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT unique_idx_name_hotelcat UNIQUE (name);


--
-- Name: unique_idx_name_person_category; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT unique_idx_name_person_category UNIQUE (name);


--
-- Name: unique_idx_name_region_id_location; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT unique_idx_name_region_id_location UNIQUE (name, region_id);


--
-- Name: unique_idx_name_roomcat; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT unique_idx_name_roomcat UNIQUE (name);


--
-- Name: unique_idx_name_service; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT unique_idx_name_service UNIQUE (name);


--
-- Name: unique_idx_name_strcuture_id_position; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT unique_idx_name_strcuture_id_position UNIQUE (name, structure_id);


--
-- Name: unique_idx_name_supplier_type; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT unique_idx_name_supplier_type UNIQUE (name);


--
-- Name: unique_idx_name_ticket_class; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT unique_idx_name_ticket_class UNIQUE (name);


--
-- Name: unique_idx_name_transfer; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT unique_idx_name_transfer UNIQUE (name);


--
-- Name: unique_idx_name_transport; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT unique_idx_name_transport UNIQUE (name);


--
-- Name: unique_idx_path_upload; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT unique_idx_path_upload UNIQUE (path);


--
-- Name: unique_idx_resource_type_id_position_id_permision; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT unique_idx_resource_type_id_position_id_permision UNIQUE (resource_type_id, position_id);


--
-- Name: unique_idx_resource_type_module; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT unique_idx_resource_type_module UNIQUE (module, resource_name);


--
-- Name: unique_idx_resource_type_name; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT unique_idx_resource_type_name UNIQUE (name);


--
-- Name: unique_idx_users_email; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_idx_users_email UNIQUE (email);


--
-- Name: unique_idx_users_username; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_idx_users_username UNIQUE (username);


--
-- Name: upload_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT upload_pkey PRIMARY KEY (id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: vat_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT vat_pkey PRIMARY KEY (id);


--
-- Name: visa_order_item_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT visa_order_item_pkey PRIMARY KEY (order_item_id, visa_id);


--
-- Name: visa_pkey; Type: CONSTRAINT; Schema: demo_ru; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT visa_pkey PRIMARY KEY (id);


SET search_path = public, pg_catalog;

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
-- Name: campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY campaign
    ADD CONSTRAINT campaign_pkey PRIMARY KEY (id);


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
-- Name: passport_upload_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT passport_upload_pkey PRIMARY KEY (passport_id, upload_id);


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
-- Name: person_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT person_category_pkey PRIMARY KEY (id);


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
-- Name: unique_idx_name_person_category; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT unique_idx_name_person_category UNIQUE (name);


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


SET search_path = test, pg_catalog;

--
-- Name: accomodation_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT accomodation_pkey PRIMARY KEY (id);


--
-- Name: account_item_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT account_item_pkey PRIMARY KEY (id);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: advsource_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT advsource_pkey PRIMARY KEY (id);


--
-- Name: appointment_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (id);


--
-- Name: bank_address_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT bank_address_pkey PRIMARY KEY (bank_id, address_id);


--
-- Name: bank_detail_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT bank_detail_pkey PRIMARY KEY (id);


--
-- Name: bank_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (id);


--
-- Name: bperson_contact_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT bperson_contact_pkey PRIMARY KEY (bperson_id, contact_id);


--
-- Name: bperson_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bperson
    ADD CONSTRAINT bperson_pkey PRIMARY KEY (id);


--
-- Name: calculation_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT calculation_pkey PRIMARY KEY (id);


--
-- Name: campaign_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY campaign
    ADD CONSTRAINT campaign_pkey PRIMARY KEY (id);


--
-- Name: cashflow_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT cashflow_pkey PRIMARY KEY (id);


--
-- Name: commission_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT commission_pkey PRIMARY KEY (id);


--
-- Name: company_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


--
-- Name: company_subaccount_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT company_subaccount_pkey PRIMARY KEY (company_id, subaccount_id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: contract_commission_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT contract_commission_pkey PRIMARY KEY (contract_id, commission_id);


--
-- Name: contract_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: crosspayment_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT crosspayment_pkey PRIMARY KEY (id);


--
-- Name: currency_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (id);


--
-- Name: currency_rate_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT currency_rate_pkey PRIMARY KEY (id);


--
-- Name: employee_address_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT employee_address_pkey PRIMARY KEY (employee_id, address_id);


--
-- Name: employee_contact_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT employee_contact_pkey PRIMARY KEY (employee_id, contact_id);


--
-- Name: employee_notification_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT employee_notification_pkey PRIMARY KEY (employee_id, notification_id);


--
-- Name: employee_passport_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT employee_passport_pkey PRIMARY KEY (employee_id, passport_id);


--
-- Name: employee_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- Name: employee_subaccount_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT employee_subaccount_pkey PRIMARY KEY (employee_id, subaccount_id);


--
-- Name: employee_upload_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT employee_upload_pkey PRIMARY KEY (employee_id, upload_id);


--
-- Name: foodcat_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT foodcat_pkey PRIMARY KEY (id);


--
-- Name: hotel_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (id);


--
-- Name: hotelcat_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT hotelcat_pkey PRIMARY KEY (id);


--
-- Name: income_cashflow_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT income_cashflow_pkey PRIMARY KEY (income_id, cashflow_id);


--
-- Name: income_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY income
    ADD CONSTRAINT income_pkey PRIMARY KEY (id);


--
-- Name: invoice_item_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT invoice_item_pkey PRIMARY KEY (id);


--
-- Name: invoice_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);


--
-- Name: lead_item_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT lead_item_pkey PRIMARY KEY (id);


--
-- Name: lead_offer_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT lead_offer_pkey PRIMARY KEY (id);


--
-- Name: lead_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT lead_pkey PRIMARY KEY (id);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: navigation_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT navigation_pkey PRIMARY KEY (id);


--
-- Name: note_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_pkey PRIMARY KEY (id);


--
-- Name: note_resource_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT note_resource_pkey PRIMARY KEY (note_id, resource_id);


--
-- Name: note_upload_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT note_upload_pkey PRIMARY KEY (note_id, upload_id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_resource_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT notification_resource_pkey PRIMARY KEY (notification_id, resource_id);


--
-- Name: order_item_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: outgoing_cashflow_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT outgoing_cashflow_pkey PRIMARY KEY (outgoing_id, cashflow_id);


--
-- Name: outgoing_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT outgoing_pkey PRIMARY KEY (id);


--
-- Name: passport_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY (id);


--
-- Name: passport_upload_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT passport_upload_pkey PRIMARY KEY (passport_id, upload_id);


--
-- Name: permision_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT permision_pkey PRIMARY KEY (id);


--
-- Name: person_address_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT person_address_pkey PRIMARY KEY (person_id, address_id);


--
-- Name: person_category_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT person_category_pkey PRIMARY KEY (id);


--
-- Name: person_contact_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT person_contact_pkey PRIMARY KEY (person_id, contact_id);


--
-- Name: person_order_item_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT person_order_item_pkey PRIMARY KEY (order_item_id, person_id);


--
-- Name: person_passport_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT person_passport_pkey PRIMARY KEY (person_id, passport_id);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: person_subaccount_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT person_subaccount_pkey PRIMARY KEY (person_id, subaccount_id);


--
-- Name: position_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (id);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: resource_log_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT resource_log_pkey PRIMARY KEY (id);


--
-- Name: resource_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- Name: resource_type_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT resource_type_pkey PRIMARY KEY (id);


--
-- Name: roomcat_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT roomcat_pkey PRIMARY KEY (id);


--
-- Name: service_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: spassport_order_item_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT spassport_order_item_pkey PRIMARY KEY (order_item_id, spassport_id);


--
-- Name: spassport_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY spassport
    ADD CONSTRAINT spassport_pkey PRIMARY KEY (id);


--
-- Name: structure_address_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT structure_address_pkey PRIMARY KEY (structure_id, address_id);


--
-- Name: structure_bank_detail_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT structure_bank_detail_pkey PRIMARY KEY (structure_id, bank_detail_id);


--
-- Name: structure_contact_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT structure_contact_pkey PRIMARY KEY (structure_id, contact_id);


--
-- Name: structure_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT structure_pkey PRIMARY KEY (id);


--
-- Name: subaccount_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT subaccount_pkey PRIMARY KEY (id);


--
-- Name: supplier_bank_detail_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT supplier_bank_detail_pkey PRIMARY KEY (supplier_id, bank_detail_id);


--
-- Name: supplier_bperson_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT supplier_bperson_pkey PRIMARY KEY (supplier_id, bperson_id);


--
-- Name: supplier_contract_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT supplier_contract_pkey PRIMARY KEY (supplier_id, contract_id);


--
-- Name: supplier_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- Name: supplier_subaccount_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT supplier_subaccount_pkey PRIMARY KEY (supplier_id, subaccount_id);


--
-- Name: supplier_type_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT supplier_type_pkey PRIMARY KEY (id);


--
-- Name: task_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: task_resource_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT task_resource_pkey PRIMARY KEY (task_id, resource_id);


--
-- Name: task_upload_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT task_upload_pkey PRIMARY KEY (task_id, upload_id);


--
-- Name: ticket_class_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT ticket_class_pkey PRIMARY KEY (id);


--
-- Name: ticket_order_item_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT ticket_order_item_pkey PRIMARY KEY (order_item_id, ticket_id);


--
-- Name: ticket_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (id);


--
-- Name: tour_order_item_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT tour_order_item_pkey PRIMARY KEY (order_item_id, tour_id);


--
-- Name: tour_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT tour_pkey PRIMARY KEY (id);


--
-- Name: transfer_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_pkey PRIMARY KEY (id);


--
-- Name: transport_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT transport_pkey PRIMARY KEY (id);


--
-- Name: unique_idx_accomodation_name; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT unique_idx_accomodation_name UNIQUE (name);


--
-- Name: unique_idx_country_iso_code; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT unique_idx_country_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_currency_iso_code; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT unique_idx_currency_iso_code UNIQUE (iso_code);


--
-- Name: unique_idx_currency_rate_currency_id_date; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT unique_idx_currency_rate_currency_id_date UNIQUE (currency_id, date, supplier_id);


--
-- Name: unique_idx_name_account; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT unique_idx_name_account UNIQUE (name);


--
-- Name: unique_idx_name_account_id_subaccount; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT unique_idx_name_account_id_subaccount UNIQUE (name, account_id);


--
-- Name: unique_idx_name_account_item; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT unique_idx_name_account_item UNIQUE (name);


--
-- Name: unique_idx_name_advsource; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT unique_idx_name_advsource UNIQUE (name);


--
-- Name: unique_idx_name_bank; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT unique_idx_name_bank UNIQUE (name);


--
-- Name: unique_idx_name_company; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT unique_idx_name_company UNIQUE (name);


--
-- Name: unique_idx_name_country_id_region; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT unique_idx_name_country_id_region UNIQUE (name, country_id);


--
-- Name: unique_idx_name_foodcat; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT unique_idx_name_foodcat UNIQUE (name);


--
-- Name: unique_idx_name_hotelcat; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT unique_idx_name_hotelcat UNIQUE (name);


--
-- Name: unique_idx_name_person_category; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT unique_idx_name_person_category UNIQUE (name);


--
-- Name: unique_idx_name_region_id_location; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT unique_idx_name_region_id_location UNIQUE (name, region_id);


--
-- Name: unique_idx_name_roomcat; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT unique_idx_name_roomcat UNIQUE (name);


--
-- Name: unique_idx_name_service; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service
    ADD CONSTRAINT unique_idx_name_service UNIQUE (name);


--
-- Name: unique_idx_name_strcuture_id_position; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT unique_idx_name_strcuture_id_position UNIQUE (name, structure_id);


--
-- Name: unique_idx_name_supplier_type; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT unique_idx_name_supplier_type UNIQUE (name);


--
-- Name: unique_idx_name_ticket_class; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT unique_idx_name_ticket_class UNIQUE (name);


--
-- Name: unique_idx_name_transfer; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT unique_idx_name_transfer UNIQUE (name);


--
-- Name: unique_idx_name_transport; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT unique_idx_name_transport UNIQUE (name);


--
-- Name: unique_idx_path_upload; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT unique_idx_path_upload UNIQUE (path);


--
-- Name: unique_idx_resource_type_id_position_id_permision; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT unique_idx_resource_type_id_position_id_permision UNIQUE (resource_type_id, position_id);


--
-- Name: unique_idx_resource_type_module; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT unique_idx_resource_type_module UNIQUE (module, resource_name);


--
-- Name: unique_idx_resource_type_name; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT unique_idx_resource_type_name UNIQUE (name);


--
-- Name: unique_idx_users_email; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_idx_users_email UNIQUE (email);


--
-- Name: unique_idx_users_username; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT unique_idx_users_username UNIQUE (username);


--
-- Name: upload_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT upload_pkey PRIMARY KEY (id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: vat_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT vat_pkey PRIMARY KEY (id);


--
-- Name: visa_order_item_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT visa_order_item_pkey PRIMARY KEY (order_item_id, visa_id);


--
-- Name: visa_pkey; Type: CONSTRAINT; Schema: test; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT visa_pkey PRIMARY KEY (id);


SET search_path = company, pg_catalog;

--
-- Name: fk_accomodation_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_accomodation_id_tour FOREIGN KEY (accomodation_id) REFERENCES accomodation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_id_invoice; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_account_id_invoice FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_id_vat; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_account_id_vat FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_cashflow; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_account_item_id_cashflow FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_outgoing; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_account_item_id_outgoing FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_transfer; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_account_item_id_transfer FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_parent_id; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT fk_account_item_parent_id FOREIGN KEY (parent_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_bank_address; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT fk_address_id_bank_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_employee_address; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT fk_address_id_employee_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_person_address; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT fk_address_id_person_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_structure_address; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT fk_address_id_structure_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_lead; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_advsource_id_lead FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_order; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_advsource_id_order FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_structure_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_supplier_bank_detail; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_supplier_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_id_bank_address; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT fk_bank_id_bank_address FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_id_bank_detail; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_bank_id_bank_detail FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_bperson_id_bperson_contact; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT fk_bperson_id_bperson_contact FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bperson_id_supplier_bperson; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT fk_bperson_id_supplier_bperson FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_crosspayment; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_cashflow_id_crosspayment FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_income_cashflow; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT fk_cashflow_id_income_cashflow FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_outgoing_cashflow; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT fk_cashflow_id_outgoing_cashflow FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_commission_id_contract_commission; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT fk_commission_id_contract_commission FOREIGN KEY (commission_id) REFERENCES commission(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_company_id_company_subaccount; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT fk_company_id_company_subaccount FOREIGN KEY (company_id) REFERENCES company(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_bperson_contact; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT fk_contact_id_bperson_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_employee_contact; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT fk_contact_id_employee_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_employee_notification; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT fk_contact_id_employee_notification FOREIGN KEY (notification_id) REFERENCES notification(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_person_contact; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT fk_contact_id_person_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_structure_contact; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT fk_contact_id_structure_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contract_id_caluclation; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_contract_id_caluclation FOREIGN KEY (contract_id) REFERENCES contract(id);


--
-- Name: fk_contract_id_contract_commission; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT fk_contract_id_contract_commission FOREIGN KEY (contract_id) REFERENCES contract(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contract_id_supplier_contract; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT fk_contract_id_supplier_contract FOREIGN KEY (contract_id) REFERENCES contract(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_country_id_passport; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_country_id_passport FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_country_id_visa; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT fk_country_id_visa FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_account; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY account
    ADD CONSTRAINT fk_currency_id_account FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_appointment; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_currency_id_appointment FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_bank_detail; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_currency_id_bank_detail FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_commission; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_currency_id_commission FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_company; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY company
    ADD CONSTRAINT fk_currency_id_company FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_lead_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_currency_id_lead_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_lead_offer; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_currency_id_lead_offer FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_currency_id_order_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_currency_id_tour FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_lead; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_customer_id_lead FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_order; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_customer_id_order FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_appointment; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_employee_id_appointment FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_address; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT fk_employee_id_employee_address FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_contact; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT fk_employee_id_employee_contact FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_notification; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT fk_employee_id_employee_notification FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_passport; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_employee_id_employee_passport FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_subaccount; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT fk_employee_id_employee_subaccount FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_upload; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT fk_employee_id_employee_upload FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_resource_log; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_employee_id_resource_log FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_task; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_employee_id_task FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_user; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_employee_id_user FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_location_id_ticket; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_end_location_id_ticket FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_location_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_end_location_id_tour FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_transport_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_end_transport_id_tour FOREIGN KEY (end_transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_foodcat_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_foodcat_id_tour FOREIGN KEY (foodcat_id) REFERENCES foodcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotel_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_hotel_id_tour FOREIGN KEY (hotel_id) REFERENCES hotel(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotelcat_id_hotel; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_hotelcat_id_hotel FOREIGN KEY (hotelcat_id) REFERENCES hotelcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_income_id_income_cashflow; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT fk_income_id_income_cashflow FOREIGN KEY (income_id) REFERENCES income(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_income; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_invoice_id_income FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_invoice_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT fk_invoice_id_invoice_item FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_lead_id_lead_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_lead_id_lead_item FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_lead_offer; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_lead_id_lead_offer FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_order; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_lead_id_order FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_address; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT fk_location_id_address FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_hotel; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_location_id_hotel FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_navigation_position_id; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_navigation_position_id FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_note_id_note_resource; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT fk_note_id_note_resource FOREIGN KEY (note_id) REFERENCES note(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_note_id_note_upload; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT fk_note_id_note_upload FOREIGN KEY (note_id) REFERENCES note(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_notification_id_notification_resource; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT fk_notification_id_notification_resource FOREIGN KEY (notification_id) REFERENCES notification(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_id_invoice; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_order_id_invoice FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_id_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_order_id_order_item FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_caluclation; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_order_item_id_caluclation FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_invoice_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT fk_order_item_id_invoice_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_person_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT fk_order_item_id_person_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_spassport_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT fk_order_item_id_spassport_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_ticket_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT fk_order_item_id_ticket_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_tour_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT fk_order_item_id_tour_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_visa_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT fk_order_item_id_visa_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_outgoing_id_outgoing_cashflow; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT fk_outgoing_id_outgoing_cashflow FOREIGN KEY (outgoing_id) REFERENCES outgoing(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_parent_id_navigation; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_parent_id_navigation FOREIGN KEY (parent_id) REFERENCES navigation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_employee_passport; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_passport_id_employee_passport FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_passport_upload; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT fk_passport_id_passport_upload FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_person_passport; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_passport_id_person_passport FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_permision_structure_id; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_permision_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_category_id_person; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_person_category_id_person FOREIGN KEY (person_category_id) REFERENCES person_category(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_address; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT fk_person_id_person_address FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_contact; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT fk_person_id_person_contact FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT fk_person_id_person_order_item FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_passport; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_person_id_person_passport FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_subaccount; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT fk_person_id_person_subaccount FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_photo_upload_id_employee; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_photo_upload_id_employee FOREIGN KEY (photo_upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_position_id_appointment; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_position_id_appointment FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_position_id_permision; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_position_id_permision FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_position_structure_id; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_position_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_region_country_id; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_region_country_id FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_region_id_location; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_region_id_location FOREIGN KEY (region_id) REFERENCES region(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_accomodation; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT fk_resource_id_accomodation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_account; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY account
    ADD CONSTRAINT fk_resource_id_account FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_account_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT fk_resource_id_account_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_address; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT fk_resource_id_address FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_advsource; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT fk_resource_id_advsource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_appointment; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_resource_id_appointment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bank; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT fk_resource_id_bank FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bank_detail; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_resource_id_bank_detail FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bperson; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY bperson
    ADD CONSTRAINT fk_resource_id_bperson FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_calculation; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_resource_id_calculation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_campaign; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY campaign
    ADD CONSTRAINT fk_resource_id_campaign FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_commission; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_resource_id_commission FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_company; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY company
    ADD CONSTRAINT fk_resource_id_company FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_contact; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT fk_resource_id_contact FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_contact; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT fk_resource_id_contact FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_country; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY country
    ADD CONSTRAINT fk_resource_id_country FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_crosspayment; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_resource_id_crosspayment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_currency; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT fk_resource_id_currency FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_employee; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_resource_id_employee FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_foodcat; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT fk_resource_id_foodcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_hotel; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_resource_id_hotel FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_hotelcat; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT fk_resource_id_hotelcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_income; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_resource_id_income FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_invoice; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_resource_id_invoice FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_resource_id_lead FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_resource_id_lead_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead_offer; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_resource_id_lead_offer FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_licence; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT fk_resource_id_licence FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_location; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_resource_id_location FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_navigation; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_resource_id_navigation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_note; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY note
    ADD CONSTRAINT fk_resource_id_note FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_note_resource; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT fk_resource_id_note_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_notification; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT fk_resource_id_notification FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_notification_resource; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT fk_resource_id_notification_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_order; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_resource_id_order FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_resource_id_order_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_outgoing; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_resource_id_outgoing FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_passport; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_resource_id_passport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_person; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_resource_id_person FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_person_category; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT fk_resource_id_person_category FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_position; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_resource_id_position FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_region; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_resource_id_region FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_resource_log; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_resource_id_resource_log FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_resource_type; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT fk_resource_id_resource_type FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_roomcat; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT fk_resource_id_roomcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_service; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_resource_id_service FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_spassport; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY spassport
    ADD CONSTRAINT fk_resource_id_spassport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_structure; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_resource_id_structure FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_subaccount; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT fk_resource_id_subaccount FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_supplier_type; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT fk_resource_id_supplier_type FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_task; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_resource_id_task FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_task_resource; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_resource_id_task_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_ticket; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_resource_id_ticket FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_ticket_class; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT fk_resource_id_ticket_class FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_touroperator; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT fk_resource_id_touroperator FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_transfer; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_resource_id_transfer FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_transport; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT fk_resource_id_transport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_uni_list; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY uni_list
    ADD CONSTRAINT fk_resource_id_uni_list FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_user; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_resource_id_user FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_vat; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_resource_id_vat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_visa; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT fk_resource_id_visa FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_type_id_permission; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_resource_type_id_permission FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_type_id_resource; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_resource_type_id_resource FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_type_id_service; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_resource_type_id_service FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_roomcat_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_roomcat_id_tour FOREIGN KEY (roomcat_id) REFERENCES roomcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_commission; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_service_id_commission FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_lead_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_service_id_lead_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_lead_offer; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_service_id_lead_offer FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_service_id_order_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_service_id_order_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_spassport_id_spassport_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT fk_spassport_id_spassport_order_item FOREIGN KEY (spassport_id) REFERENCES spassport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_ticket; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_start_location_id_ticket FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_start_location_id_tour FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_transport_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_start_transport_id_tour FOREIGN KEY (start_transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_company_id; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_company_id FOREIGN KEY (company_id) REFERENCES company(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_resource; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_structure_id_resource FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_address; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT fk_structure_id_structure_address FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_structure_id_structure_bank_detail FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_contact; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT fk_structure_id_structure_contact FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_parent_id; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_parent_id FOREIGN KEY (parent_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_account_id; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT fk_subaccount_account_id FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_from_id_transfer; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_subaccount_from_id_transfer FOREIGN KEY (subaccount_from_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_company_subaccount; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT fk_subaccount_id_company_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_employee_subaccount; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT fk_subaccount_id_employee_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_outgoing; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_subaccount_id_outgoing FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_person_subaccount; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT fk_subaccount_id_person_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT fk_subaccount_id_supplier_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_to_id_transfer; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_subaccount_to_id_transfer FOREIGN KEY (subaccount_to_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_currency_rate; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_supplier_id_currency_rate FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_lead_offer; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_supplier_id_lead_offer FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_supplier_id_order_item FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_bank_detail; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT fk_supplier_id_supplier_bank_detail FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_bperson; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT fk_supplier_id_supplier_bperson FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_contract; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT fk_supplier_id_supplier_contract FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT fk_supplier_id_supplier_subaccount FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_type_id_supplier; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT fk_supplier_type_id_supplier FOREIGN KEY (supplier_type_id) REFERENCES supplier_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_task_id_task_resource; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_task_id_task_resource FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_task_id_task_upload; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT fk_task_id_task_upload FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_ticket_class_id_ticket; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_ticket_class_id_ticket FOREIGN KEY (ticket_class_id) REFERENCES ticket_class(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_ticket_id_ticket_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT fk_ticket_id_ticket_order_item FOREIGN KEY (ticket_id) REFERENCES ticket(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT fk_tour_id_tour_order_item FOREIGN KEY (tour_id) REFERENCES tour(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_transfer_id_tour; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_transfer_id_tour FOREIGN KEY (transfer_id) REFERENCES transfer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_transport_id_ticket; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_transport_id_ticket FOREIGN KEY (transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_employee_upload; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT fk_upload_id_employee_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_note_upload; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT fk_upload_id_note_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_passport_upload; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT fk_upload_id_passport_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_task_upload; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT fk_upload_id_task_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_visa_id_visa_order_item; Type: FK CONSTRAINT; Schema: company; Owner: -
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT fk_visa_id_visa_order_item FOREIGN KEY (visa_id) REFERENCES visa(id) ON UPDATE CASCADE ON DELETE RESTRICT;


SET search_path = demo_ru, pg_catalog;

--
-- Name: fk_accomodation_id_tour; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_accomodation_id_tour FOREIGN KEY (accomodation_id) REFERENCES accomodation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_id_invoice; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_account_id_invoice FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_id_vat; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_account_id_vat FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_cashflow; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_account_item_id_cashflow FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_cashflow; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_account_item_id_cashflow FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_outgoing; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_account_item_id_outgoing FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_parent_id; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT fk_account_item_parent_id FOREIGN KEY (parent_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_bank_address; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT fk_address_id_bank_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_employee_address; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT fk_address_id_employee_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_person_address; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT fk_address_id_person_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_structure_address; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT fk_address_id_structure_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_lead; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_advsource_id_lead FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_order; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_advsource_id_order FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_structure_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_supplier_bank_detail; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_supplier_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_id_bank_address; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT fk_bank_id_bank_address FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_id_bank_detail; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_bank_id_bank_detail FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_bperson_id_bperson_contact; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT fk_bperson_id_bperson_contact FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bperson_id_supplier_bperson; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT fk_bperson_id_supplier_bperson FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_crosspayment; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_cashflow_id_crosspayment FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_income_cashflow; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT fk_cashflow_id_income_cashflow FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_outgoing_cashflow; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT fk_cashflow_id_outgoing_cashflow FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_commission_id_contract_commission; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT fk_commission_id_contract_commission FOREIGN KEY (commission_id) REFERENCES commission(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_company_id_company_subaccount; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT fk_company_id_company_subaccount FOREIGN KEY (company_id) REFERENCES company(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_bperson_contact; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT fk_contact_id_bperson_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_employee_contact; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT fk_contact_id_employee_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_person_contact; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT fk_contact_id_person_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_structure_contact; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT fk_contact_id_structure_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contract_id_caluclation; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_contract_id_caluclation FOREIGN KEY (contract_id) REFERENCES contract(id);


--
-- Name: fk_contract_id_contract_commission; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT fk_contract_id_contract_commission FOREIGN KEY (contract_id) REFERENCES contract(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contract_id_supplier_contract; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT fk_contract_id_supplier_contract FOREIGN KEY (contract_id) REFERENCES contract(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_country_id_passport; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_country_id_passport FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_country_id_visa; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT fk_country_id_visa FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_account; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY account
    ADD CONSTRAINT fk_currency_id_account FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_appointment; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_currency_id_appointment FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_bank_detail; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_currency_id_bank_detail FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_commission; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_currency_id_commission FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_company; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY company
    ADD CONSTRAINT fk_currency_id_company FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_currency_rate; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_currency_id_currency_rate FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_lead_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_currency_id_lead_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_lead_offer; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_currency_id_lead_offer FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_currency_id_order_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_lead; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_customer_id_lead FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_order; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_customer_id_order FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_appointment; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_employee_id_appointment FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_address; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT fk_employee_id_employee_address FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_contact; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT fk_employee_id_employee_contact FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_notification; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT fk_employee_id_employee_notification FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_passport; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_employee_id_employee_passport FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_subaccount; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT fk_employee_id_employee_subaccount FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_upload; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT fk_employee_id_employee_upload FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_resource_log; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_employee_id_resource_log FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_task; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_employee_id_task FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_user; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_employee_id_user FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_location_id_ticket; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_end_location_id_ticket FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_location_id_tour; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_end_location_id_tour FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_transport_id_tour; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_end_transport_id_tour FOREIGN KEY (end_transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_foodcat_id_tour; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_foodcat_id_tour FOREIGN KEY (foodcat_id) REFERENCES foodcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotel_id_tour; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_hotel_id_tour FOREIGN KEY (hotel_id) REFERENCES hotel(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotelcat_id_hotel; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_hotelcat_id_hotel FOREIGN KEY (hotelcat_id) REFERENCES hotelcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_income_id_income_cashflow; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT fk_income_id_income_cashflow FOREIGN KEY (income_id) REFERENCES income(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_income; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_invoice_id_income FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_invoice_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT fk_invoice_id_invoice_item FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_lead_id_lead_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_lead_id_lead_item FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_lead_offer; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_lead_id_lead_offer FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_order; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_lead_id_order FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_address; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT fk_location_id_address FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_hotel; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_location_id_hotel FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_navigation_position_id; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_navigation_position_id FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_note_id_note_resource; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT fk_note_id_note_resource FOREIGN KEY (note_id) REFERENCES note(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_note_id_note_upload; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT fk_note_id_note_upload FOREIGN KEY (note_id) REFERENCES note(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_notification_id_employee_notification; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT fk_notification_id_employee_notification FOREIGN KEY (notification_id) REFERENCES notification(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_notification_id_notification_resource; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT fk_notification_id_notification_resource FOREIGN KEY (notification_id) REFERENCES notification(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_id_invoice; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_order_id_invoice FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_id_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_order_id_order_item FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_caluclation; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_order_item_id_caluclation FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_invoice_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT fk_order_item_id_invoice_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_person_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT fk_order_item_id_person_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_spassport_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT fk_order_item_id_spassport_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_ticket_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT fk_order_item_id_ticket_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_tour_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT fk_order_item_id_tour_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_visa_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT fk_order_item_id_visa_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_outgoing_id_outgoing_cashflow; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT fk_outgoing_id_outgoing_cashflow FOREIGN KEY (outgoing_id) REFERENCES outgoing(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_parent_id_navigation; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_parent_id_navigation FOREIGN KEY (parent_id) REFERENCES navigation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_employee_passport; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_passport_id_employee_passport FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_passport_upload; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT fk_passport_id_passport_upload FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_person_passport; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_passport_id_person_passport FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_permision_structure_id; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_permision_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_category_id_person; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_person_category_id_person FOREIGN KEY (person_category_id) REFERENCES person_category(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_address; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT fk_person_id_person_address FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_contact; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT fk_person_id_person_contact FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT fk_person_id_person_order_item FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_passport; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_person_id_person_passport FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_subaccount; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT fk_person_id_person_subaccount FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_photo_upload_id_employee; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_photo_upload_id_employee FOREIGN KEY (photo_upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_position_id_appointment; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_position_id_appointment FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_position_id_permision; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_position_id_permision FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_position_structure_id; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_position_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_region_country_id; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_region_country_id FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_region_id_location; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_region_id_location FOREIGN KEY (region_id) REFERENCES region(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_accomodation; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT fk_resource_id_accomodation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_account; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY account
    ADD CONSTRAINT fk_resource_id_account FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_account_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT fk_resource_id_account_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_address; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT fk_resource_id_address FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_advsource; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT fk_resource_id_advsource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_appointment; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_resource_id_appointment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bank; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT fk_resource_id_bank FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bank_detail; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_resource_id_bank_detail FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bperson; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY bperson
    ADD CONSTRAINT fk_resource_id_bperson FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_calculation; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_resource_id_calculation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_campaign; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY campaign
    ADD CONSTRAINT fk_resource_id_campaign FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_commission; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_resource_id_commission FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_company; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY company
    ADD CONSTRAINT fk_resource_id_company FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_contact; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT fk_resource_id_contact FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_contact; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT fk_resource_id_contact FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_contract; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT fk_resource_id_contract FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_country; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY country
    ADD CONSTRAINT fk_resource_id_country FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_crosspayment; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_resource_id_crosspayment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_currency; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT fk_resource_id_currency FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_currency_rate; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_resource_id_currency_rate FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_employee; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_resource_id_employee FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_foodcat; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT fk_resource_id_foodcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_hotel; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_resource_id_hotel FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_hotelcat; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT fk_resource_id_hotelcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_income; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_resource_id_income FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_invoice; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_resource_id_invoice FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_resource_id_lead FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_resource_id_lead_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead_offer; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_resource_id_lead_offer FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_location; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_resource_id_location FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_navigation; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_resource_id_navigation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_note; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY note
    ADD CONSTRAINT fk_resource_id_note FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_note_resource; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT fk_resource_id_note_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_notification; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT fk_resource_id_notification FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_notification_resource; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT fk_resource_id_notification_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_order; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_resource_id_order FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_resource_id_order_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_outgoing; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_resource_id_outgoing FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_passport; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_resource_id_passport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_person; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_resource_id_person FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_person_category; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT fk_resource_id_person_category FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_position; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_resource_id_position FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_region; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_resource_id_region FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_resource_log; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_resource_id_resource_log FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_resource_type; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT fk_resource_id_resource_type FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_roomcat; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT fk_resource_id_roomcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_service; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_resource_id_service FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_spassport; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY spassport
    ADD CONSTRAINT fk_resource_id_spassport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_structure; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_resource_id_structure FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_subaccount; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT fk_resource_id_subaccount FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_supplier; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT fk_resource_id_supplier FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_supplier_type; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT fk_resource_id_supplier_type FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_task; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_resource_id_task FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_task_resource; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_resource_id_task_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_ticket; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_resource_id_ticket FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_ticket_class; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT fk_resource_id_ticket_class FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_tour; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_transfer; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_resource_id_transfer FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_transport; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT fk_resource_id_transport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_user; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_resource_id_user FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_vat; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_resource_id_vat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_visa; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT fk_resource_id_visa FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_type_id_permission; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_resource_type_id_permission FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_type_id_resource; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_resource_type_id_resource FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_type_id_service; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_resource_type_id_service FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_roomcat_id_tour; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_roomcat_id_tour FOREIGN KEY (roomcat_id) REFERENCES roomcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_commission; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_service_id_commission FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_lead_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_service_id_lead_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_lead_offer; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_service_id_lead_offer FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_service_id_order_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_vat; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_service_id_vat FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_spassport_id_spassport_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT fk_spassport_id_spassport_order_item FOREIGN KEY (spassport_id) REFERENCES spassport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_ticket; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_start_location_id_ticket FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_tour; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_start_location_id_tour FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_transport_id_tour; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_start_transport_id_tour FOREIGN KEY (start_transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_company_id; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_company_id FOREIGN KEY (company_id) REFERENCES company(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_resource; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_structure_id_resource FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_address; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT fk_structure_id_structure_address FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_structure_id_structure_bank_detail FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_contact; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT fk_structure_id_structure_contact FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_parent_id; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_parent_id FOREIGN KEY (parent_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_account_id; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT fk_subaccount_account_id FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_from_id_cashflow; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_subaccount_from_id_cashflow FOREIGN KEY (subaccount_from_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_company_subaccount; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT fk_subaccount_id_company_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_employee_subaccount; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT fk_subaccount_id_employee_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_outgoing; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_subaccount_id_outgoing FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_person_subaccount; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT fk_subaccount_id_person_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT fk_subaccount_id_supplier_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_to_id_cashflow; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_subaccount_to_id_cashflow FOREIGN KEY (subaccount_to_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_currency_rate; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_supplier_id_currency_rate FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_lead_offer; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_supplier_id_lead_offer FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_supplier_id_order_item FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_bank_detail; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT fk_supplier_id_supplier_bank_detail FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_bperson; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT fk_supplier_id_supplier_bperson FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_contract; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT fk_supplier_id_supplier_contract FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT fk_supplier_id_supplier_subaccount FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_type_id_supplier; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT fk_supplier_type_id_supplier FOREIGN KEY (supplier_type_id) REFERENCES supplier_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_task_id_task_resource; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_task_id_task_resource FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_task_id_task_upload; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT fk_task_id_task_upload FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_ticket_class_id_ticket; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_ticket_class_id_ticket FOREIGN KEY (ticket_class_id) REFERENCES ticket_class(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_ticket_id_ticket_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT fk_ticket_id_ticket_order_item FOREIGN KEY (ticket_id) REFERENCES ticket(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT fk_tour_id_tour_order_item FOREIGN KEY (tour_id) REFERENCES tour(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_transfer_id_tour; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_transfer_id_tour FOREIGN KEY (transfer_id) REFERENCES transfer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_transport_id_ticket; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_transport_id_ticket FOREIGN KEY (transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_employee_upload; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT fk_upload_id_employee_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_note_upload; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT fk_upload_id_note_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_passport_upload; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT fk_upload_id_passport_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_task_upload; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT fk_upload_id_task_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_visa_id_visa_order_item; Type: FK CONSTRAINT; Schema: demo_ru; Owner: -
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT fk_visa_id_visa_order_item FOREIGN KEY (visa_id) REFERENCES visa(id) ON UPDATE CASCADE ON DELETE RESTRICT;


SET search_path = public, pg_catalog;

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
    ADD CONSTRAINT fk_account_id_vat FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_cashflow; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_account_item_id_cashflow FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_outgoing; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_account_item_id_outgoing FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_transfer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_account_item_id_transfer FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT fk_account_item_parent_id FOREIGN KEY (parent_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_bank_id_bank_detail FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
    ADD CONSTRAINT fk_cashflow_id_crosspayment FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_contract_id_caluclation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_contract_id_caluclation FOREIGN KEY (contract_id) REFERENCES contract(id);


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
    ADD CONSTRAINT fk_currency_id_company FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_end_transport_id_tour FOREIGN KEY (end_transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_invoice_id_invoice_item FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
    ADD CONSTRAINT fk_lead_id_order FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_order_id_invoice FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_order_id_order_item FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_caluclation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_order_item_id_caluclation FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_invoice_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT fk_order_item_id_invoice_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_passport_id_passport_upload; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT fk_passport_id_passport_upload FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_person_category_id_person; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_person_category_id_person FOREIGN KEY (person_category_id) REFERENCES person_category(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_photo_upload_id_employee FOREIGN KEY (photo_upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_id_campaign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY campaign
    ADD CONSTRAINT fk_resource_id_campaign FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_resource_id_person_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT fk_resource_id_person_category FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_resource_type_id_service FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_start_transport_id_tour FOREIGN KEY (start_transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_company_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_company_id FOREIGN KEY (company_id) REFERENCES company(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_subaccount_id_outgoing FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_supplier_id_currency_rate FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_lead_offer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_supplier_id_lead_offer FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_order_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_supplier_id_order_item FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_supplier_type_id_supplier FOREIGN KEY (supplier_type_id) REFERENCES supplier_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
    ADD CONSTRAINT fk_transfer_id_tour FOREIGN KEY (transfer_id) REFERENCES transfer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: fk_upload_id_passport_upload; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT fk_upload_id_passport_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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


SET search_path = test, pg_catalog;

--
-- Name: fk_accomodation_id_tour; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_accomodation_id_tour FOREIGN KEY (accomodation_id) REFERENCES accomodation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_id_invoice; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_account_id_invoice FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_id_vat; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_account_id_vat FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_cashflow; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_account_item_id_cashflow FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_cashflow; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_account_item_id_cashflow FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_id_outgoing; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_account_item_id_outgoing FOREIGN KEY (account_item_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_account_item_parent_id; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT fk_account_item_parent_id FOREIGN KEY (parent_id) REFERENCES account_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_bank_address; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT fk_address_id_bank_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_employee_address; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT fk_address_id_employee_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_person_address; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT fk_address_id_person_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_address_id_structure_address; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT fk_address_id_structure_address FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_lead; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_advsource_id_lead FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_advsource_id_order; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_advsource_id_order FOREIGN KEY (advsource_id) REFERENCES advsource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_structure_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_detail_id_supplier_bank_detail; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT fk_bank_detail_id_supplier_bank_detail FOREIGN KEY (bank_detail_id) REFERENCES bank_detail(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_id_bank_address; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY bank_address
    ADD CONSTRAINT fk_bank_id_bank_address FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bank_id_bank_detail; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_bank_id_bank_detail FOREIGN KEY (bank_id) REFERENCES bank(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_bperson_id_bperson_contact; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT fk_bperson_id_bperson_contact FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_bperson_id_supplier_bperson; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT fk_bperson_id_supplier_bperson FOREIGN KEY (bperson_id) REFERENCES bperson(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_crosspayment; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_cashflow_id_crosspayment FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_income_cashflow; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT fk_cashflow_id_income_cashflow FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_cashflow_id_outgoing_cashflow; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT fk_cashflow_id_outgoing_cashflow FOREIGN KEY (cashflow_id) REFERENCES cashflow(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_commission_id_contract_commission; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT fk_commission_id_contract_commission FOREIGN KEY (commission_id) REFERENCES commission(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_company_id_company_subaccount; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT fk_company_id_company_subaccount FOREIGN KEY (company_id) REFERENCES company(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_bperson_contact; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY bperson_contact
    ADD CONSTRAINT fk_contact_id_bperson_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_employee_contact; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT fk_contact_id_employee_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_person_contact; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT fk_contact_id_person_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contact_id_structure_contact; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT fk_contact_id_structure_contact FOREIGN KEY (contact_id) REFERENCES contact(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contract_id_caluclation; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_contract_id_caluclation FOREIGN KEY (contract_id) REFERENCES contract(id);


--
-- Name: fk_contract_id_contract_commission; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY contract_commission
    ADD CONSTRAINT fk_contract_id_contract_commission FOREIGN KEY (contract_id) REFERENCES contract(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_contract_id_supplier_contract; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT fk_contract_id_supplier_contract FOREIGN KEY (contract_id) REFERENCES contract(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_country_id_passport; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_country_id_passport FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_country_id_visa; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT fk_country_id_visa FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_account; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY account
    ADD CONSTRAINT fk_currency_id_account FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_appointment; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_currency_id_appointment FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_bank_detail; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_currency_id_bank_detail FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_commission; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_currency_id_commission FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_company; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY company
    ADD CONSTRAINT fk_currency_id_company FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_currency_rate; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_currency_id_currency_rate FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_lead_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_currency_id_lead_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_lead_offer; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_currency_id_lead_offer FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_currency_id_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_currency_id_order_item FOREIGN KEY (currency_id) REFERENCES currency(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_lead; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_customer_id_lead FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_customer_id_order; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_customer_id_order FOREIGN KEY (customer_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_appointment; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_employee_id_appointment FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_address; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT fk_employee_id_employee_address FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_contact; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_contact
    ADD CONSTRAINT fk_employee_id_employee_contact FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_notification; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT fk_employee_id_employee_notification FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_passport; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_employee_id_employee_passport FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_subaccount; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT fk_employee_id_employee_subaccount FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_employee_upload; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT fk_employee_id_employee_upload FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_resource_log; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_employee_id_resource_log FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_task; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_employee_id_task FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_employee_id_user; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_employee_id_user FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_location_id_ticket; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_end_location_id_ticket FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_location_id_tour; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_end_location_id_tour FOREIGN KEY (end_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_end_transport_id_tour; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_end_transport_id_tour FOREIGN KEY (end_transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_foodcat_id_tour; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_foodcat_id_tour FOREIGN KEY (foodcat_id) REFERENCES foodcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotel_id_tour; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_hotel_id_tour FOREIGN KEY (hotel_id) REFERENCES hotel(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_hotelcat_id_hotel; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_hotelcat_id_hotel FOREIGN KEY (hotelcat_id) REFERENCES hotelcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_income_id_income_cashflow; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY income_cashflow
    ADD CONSTRAINT fk_income_id_income_cashflow FOREIGN KEY (income_id) REFERENCES income(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_income; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_invoice_id_income FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_invoice_id_invoice_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT fk_invoice_id_invoice_item FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_lead_id_lead_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_lead_id_lead_item FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_lead_offer; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_lead_id_lead_offer FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_lead_id_order; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_lead_id_order FOREIGN KEY (lead_id) REFERENCES lead(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_address; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT fk_location_id_address FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_location_id_hotel; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_location_id_hotel FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_navigation_position_id; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_navigation_position_id FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_note_id_note_resource; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT fk_note_id_note_resource FOREIGN KEY (note_id) REFERENCES note(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_note_id_note_upload; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT fk_note_id_note_upload FOREIGN KEY (note_id) REFERENCES note(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_notification_id_employee_notification; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_notification
    ADD CONSTRAINT fk_notification_id_employee_notification FOREIGN KEY (notification_id) REFERENCES notification(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_notification_id_notification_resource; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT fk_notification_id_notification_resource FOREIGN KEY (notification_id) REFERENCES notification(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_id_invoice; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_order_id_invoice FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_id_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_order_id_order_item FOREIGN KEY (order_id) REFERENCES "order"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_caluclation; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_order_item_id_caluclation FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_invoice_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY invoice_item
    ADD CONSTRAINT fk_order_item_id_invoice_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_person_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT fk_order_item_id_person_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_spassport_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT fk_order_item_id_spassport_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_ticket_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT fk_order_item_id_ticket_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_tour_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT fk_order_item_id_tour_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_order_item_id_visa_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT fk_order_item_id_visa_order_item FOREIGN KEY (order_item_id) REFERENCES order_item(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_outgoing_id_outgoing_cashflow; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY outgoing_cashflow
    ADD CONSTRAINT fk_outgoing_id_outgoing_cashflow FOREIGN KEY (outgoing_id) REFERENCES outgoing(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_parent_id_navigation; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_parent_id_navigation FOREIGN KEY (parent_id) REFERENCES navigation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_employee_passport; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_passport
    ADD CONSTRAINT fk_passport_id_employee_passport FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_passport_upload; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT fk_passport_id_passport_upload FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_passport_id_person_passport; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_passport_id_person_passport FOREIGN KEY (passport_id) REFERENCES passport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_permision_structure_id; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_permision_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_category_id_person; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_person_category_id_person FOREIGN KEY (person_category_id) REFERENCES person_category(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_address; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT fk_person_id_person_address FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_contact; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_contact
    ADD CONSTRAINT fk_person_id_person_contact FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_order_item
    ADD CONSTRAINT fk_person_id_person_order_item FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_passport; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_passport
    ADD CONSTRAINT fk_person_id_person_passport FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_person_id_person_subaccount; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT fk_person_id_person_subaccount FOREIGN KEY (person_id) REFERENCES person(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_photo_upload_id_employee; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_photo_upload_id_employee FOREIGN KEY (photo_upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_position_id_appointment; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_position_id_appointment FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_position_id_permision; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_position_id_permision FOREIGN KEY (position_id) REFERENCES "position"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_position_structure_id; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_position_structure_id FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_region_country_id; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_region_country_id FOREIGN KEY (country_id) REFERENCES country(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_region_id_location; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_region_id_location FOREIGN KEY (region_id) REFERENCES region(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_accomodation; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY accomodation
    ADD CONSTRAINT fk_resource_id_accomodation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_account; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY account
    ADD CONSTRAINT fk_resource_id_account FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_account_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY account_item
    ADD CONSTRAINT fk_resource_id_account_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_address; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT fk_resource_id_address FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_advsource; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY advsource
    ADD CONSTRAINT fk_resource_id_advsource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_appointment; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY appointment
    ADD CONSTRAINT fk_resource_id_appointment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bank; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY bank
    ADD CONSTRAINT fk_resource_id_bank FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bank_detail; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY bank_detail
    ADD CONSTRAINT fk_resource_id_bank_detail FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_bperson; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY bperson
    ADD CONSTRAINT fk_resource_id_bperson FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_calculation; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY calculation
    ADD CONSTRAINT fk_resource_id_calculation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_campaign; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY campaign
    ADD CONSTRAINT fk_resource_id_campaign FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_commission; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_resource_id_commission FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_company; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY company
    ADD CONSTRAINT fk_resource_id_company FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_contact; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY upload
    ADD CONSTRAINT fk_resource_id_contact FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_contact; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT fk_resource_id_contact FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_contract; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY contract
    ADD CONSTRAINT fk_resource_id_contract FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_country; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY country
    ADD CONSTRAINT fk_resource_id_country FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_crosspayment; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY crosspayment
    ADD CONSTRAINT fk_resource_id_crosspayment FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_currency; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY currency
    ADD CONSTRAINT fk_resource_id_currency FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_currency_rate; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_resource_id_currency_rate FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_employee; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT fk_resource_id_employee FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_foodcat; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY foodcat
    ADD CONSTRAINT fk_resource_id_foodcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_hotel; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY hotel
    ADD CONSTRAINT fk_resource_id_hotel FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_hotelcat; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY hotelcat
    ADD CONSTRAINT fk_resource_id_hotelcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_income; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY income
    ADD CONSTRAINT fk_resource_id_income FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_invoice; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY invoice
    ADD CONSTRAINT fk_resource_id_invoice FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead
    ADD CONSTRAINT fk_resource_id_lead FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_resource_id_lead_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_lead_offer; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_resource_id_lead_offer FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_location; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_resource_id_location FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_navigation; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT fk_resource_id_navigation FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_note; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY note
    ADD CONSTRAINT fk_resource_id_note FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_note_resource; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY note_resource
    ADD CONSTRAINT fk_resource_id_note_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_notification; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT fk_resource_id_notification FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_notification_resource; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY notification_resource
    ADD CONSTRAINT fk_resource_id_notification_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_order; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fk_resource_id_order FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_resource_id_order_item FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_outgoing; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_resource_id_outgoing FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_passport; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY passport
    ADD CONSTRAINT fk_resource_id_passport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_person; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person
    ADD CONSTRAINT fk_resource_id_person FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_person_category; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_category
    ADD CONSTRAINT fk_resource_id_person_category FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_position; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY "position"
    ADD CONSTRAINT fk_resource_id_position FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_region; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY region
    ADD CONSTRAINT fk_resource_id_region FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_resource_log; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY resource_log
    ADD CONSTRAINT fk_resource_id_resource_log FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_id_resource_type; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY resource_type
    ADD CONSTRAINT fk_resource_id_resource_type FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_roomcat; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY roomcat
    ADD CONSTRAINT fk_resource_id_roomcat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_service; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_resource_id_service FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_spassport; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY spassport
    ADD CONSTRAINT fk_resource_id_spassport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_structure; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_resource_id_structure FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_subaccount; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT fk_resource_id_subaccount FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_supplier; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT fk_resource_id_supplier FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_supplier_type; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier_type
    ADD CONSTRAINT fk_resource_id_supplier_type FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_task; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT fk_resource_id_task FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_task_resource; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_resource_id_task_resource FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_ticket; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_resource_id_ticket FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_ticket_class; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY ticket_class
    ADD CONSTRAINT fk_resource_id_ticket_class FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_tour; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_resource_id_tour FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_transfer; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_resource_id_transfer FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_transport; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY transport
    ADD CONSTRAINT fk_resource_id_transport FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_user; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_resource_id_user FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_vat; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_resource_id_vat FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_id_visa; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY visa
    ADD CONSTRAINT fk_resource_id_visa FOREIGN KEY (resource_id) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_type_id_permission; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY permision
    ADD CONSTRAINT fk_resource_type_id_permission FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_resource_type_id_resource; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_resource_type_id_resource FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_resource_type_id_service; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY service
    ADD CONSTRAINT fk_resource_type_id_service FOREIGN KEY (resource_type_id) REFERENCES resource_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_roomcat_id_tour; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_roomcat_id_tour FOREIGN KEY (roomcat_id) REFERENCES roomcat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_commission; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY commission
    ADD CONSTRAINT fk_service_id_commission FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_lead_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_item
    ADD CONSTRAINT fk_service_id_lead_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_lead_offer; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_service_id_lead_offer FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_service_id_order_item FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_service_id_vat; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY vat
    ADD CONSTRAINT fk_service_id_vat FOREIGN KEY (service_id) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_spassport_id_spassport_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY spassport_order_item
    ADD CONSTRAINT fk_spassport_id_spassport_order_item FOREIGN KEY (spassport_id) REFERENCES spassport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_ticket; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_start_location_id_ticket FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_location_id_tour; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_start_location_id_tour FOREIGN KEY (start_location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_start_transport_id_tour; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_start_transport_id_tour FOREIGN KEY (start_transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_company_id; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_company_id FOREIGN KEY (company_id) REFERENCES company(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_resource; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT fk_structure_id_resource FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_address; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY structure_address
    ADD CONSTRAINT fk_structure_id_structure_address FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_bank_detail; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY structure_bank_detail
    ADD CONSTRAINT fk_structure_id_structure_bank_detail FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_id_structure_contact; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY structure_contact
    ADD CONSTRAINT fk_structure_id_structure_contact FOREIGN KEY (structure_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_structure_parent_id; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY structure
    ADD CONSTRAINT fk_structure_parent_id FOREIGN KEY (parent_id) REFERENCES structure(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_account_id; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY subaccount
    ADD CONSTRAINT fk_subaccount_account_id FOREIGN KEY (account_id) REFERENCES account(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_from_id_cashflow; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_subaccount_from_id_cashflow FOREIGN KEY (subaccount_from_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_company_subaccount; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY company_subaccount
    ADD CONSTRAINT fk_subaccount_id_company_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_employee_subaccount; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_subaccount
    ADD CONSTRAINT fk_subaccount_id_employee_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_outgoing; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY outgoing
    ADD CONSTRAINT fk_subaccount_id_outgoing FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_person_subaccount; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY person_subaccount
    ADD CONSTRAINT fk_subaccount_id_person_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT fk_subaccount_id_supplier_subaccount FOREIGN KEY (subaccount_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_subaccount_to_id_cashflow; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY cashflow
    ADD CONSTRAINT fk_subaccount_to_id_cashflow FOREIGN KEY (subaccount_to_id) REFERENCES subaccount(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_currency_rate; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY currency_rate
    ADD CONSTRAINT fk_supplier_id_currency_rate FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_lead_offer; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY lead_offer
    ADD CONSTRAINT fk_supplier_id_lead_offer FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk_supplier_id_order_item FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_bank_detail; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier_bank_detail
    ADD CONSTRAINT fk_supplier_id_supplier_bank_detail FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_bperson; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier_bperson
    ADD CONSTRAINT fk_supplier_id_supplier_bperson FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_contract; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier_contract
    ADD CONSTRAINT fk_supplier_id_supplier_contract FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_id_supplier_subaccount; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier_subaccount
    ADD CONSTRAINT fk_supplier_id_supplier_subaccount FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_supplier_type_id_supplier; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY supplier
    ADD CONSTRAINT fk_supplier_type_id_supplier FOREIGN KEY (supplier_type_id) REFERENCES supplier_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_task_id_task_resource; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY task_resource
    ADD CONSTRAINT fk_task_id_task_resource FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_task_id_task_upload; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT fk_task_id_task_upload FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_ticket_class_id_ticket; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_ticket_class_id_ticket FOREIGN KEY (ticket_class_id) REFERENCES ticket_class(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_ticket_id_ticket_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY ticket_order_item
    ADD CONSTRAINT fk_ticket_id_ticket_order_item FOREIGN KEY (ticket_id) REFERENCES ticket(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_tour_id_tour_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour_order_item
    ADD CONSTRAINT fk_tour_id_tour_order_item FOREIGN KEY (tour_id) REFERENCES tour(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_transfer_id_tour; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY tour
    ADD CONSTRAINT fk_transfer_id_tour FOREIGN KEY (transfer_id) REFERENCES transfer(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_transport_id_ticket; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY ticket
    ADD CONSTRAINT fk_transport_id_ticket FOREIGN KEY (transport_id) REFERENCES transport(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_employee_upload; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY employee_upload
    ADD CONSTRAINT fk_upload_id_employee_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_note_upload; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY note_upload
    ADD CONSTRAINT fk_upload_id_note_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_passport_upload; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY passport_upload
    ADD CONSTRAINT fk_upload_id_passport_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_upload_id_task_upload; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY task_upload
    ADD CONSTRAINT fk_upload_id_task_upload FOREIGN KEY (upload_id) REFERENCES upload(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fk_visa_id_visa_order_item; Type: FK CONSTRAINT; Schema: test; Owner: -
--

ALTER TABLE ONLY visa_order_item
    ADD CONSTRAINT fk_visa_id_visa_order_item FOREIGN KEY (visa_id) REFERENCES visa(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

