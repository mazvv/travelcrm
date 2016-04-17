#-*-coding: utf-8-*-

from mock import patch, MagicMock

from pyramid.testing import DummyRequest

from ...tests import BaseTestCase
from ...lib.helpers.fields import (
    employees_combogrid_field,
    positions_combogrid_field,
    bpersons_combogrid_field,
    hotelcats_combogrid_field,
    accomodations_combogrid_field,
    yes_no_field,
    switch_field,
    structures_combotree_field,
    accounts_items_combotree_field,
    permisions_yes_no_field,
    navigations_combotree_field,
    permisions_scope_type_field,
    date_field,
    datetime_field,
    gender_combobox_field,
    contact_type_combobox_field,
    countries_combogrid_field,
    regions_combogrid_field,
    locations_combogrid_field,
    suppliers_combogrid_field,
    foodcats_combogrid_field,
    roomcats_combogrid_field,
    hotels_combogrid_field,
    currencies_combogrid_field,
    persons_combogrid_field,
    advsources_combogrid_field,
    passport_type_field,
    banks_combogrid_field,
    services_combogrid_field,
    accounts_types_combobox_field,
    accounts_combogrid_field,
    invoices_combogrid_field,
    subaccounts_combogrid_field,
    timezones_field,
    locales_field,
    resources_types_statuses_combobox_field,
    tasks_statuses_combobox_field,
    notifications_statuses_combobox_field,
    leads_statuses_combobox_field,
    services_types_combobox_field,
    transfers_combogrid_field,
    transports_combogrid_field,
    tickets_classes_combogrid_field,
    orders_items_statuses_combobox_field,
    tasks_reminders_combobox_field,
    accounts_items_statuses_combobox_field,
    accounts_items_types_combobox_field,
    suppliers_statuses_combobox_field,
    suppliers_types_combogrid_field,
    contracts_statuses_combobox_field,
    bpersons_statuses_combobox_field,
    visas_types_combobox_field,
    leads_offers_statuses_combobox_field,
    leads_combogrid_field,
    orders_combogrid_field,
    accounts_statuses_combobox_field,
    orders_statuses_combobox_field,
    companies_combogrid_field,
    vats_calc_methods_combobox_field,
    persons_categories_combogrid_field,
    campaigns_statuses_combobox_field,
)


class TestFields(BaseTestCase):
    
    def test_employees_combogrid_field(self):
        field = employees_combogrid_field(
            DummyRequest(), 'employee_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_positions_combogrid_field(self):
        field = positions_combogrid_field(
            DummyRequest(), 'position_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_bpersons_combogrid_field(self):
        field = bpersons_combogrid_field(
            DummyRequest(), 'bperson_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_hotelcats_combogrid_field(self):
        field = hotelcats_combogrid_field(
            DummyRequest(), 'hotelcat_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_yes_no_field(self):
        field = yes_no_field(
            DummyRequest(), 'yes_no'
        )
        self.assertTrue('easyui-combobox' in field)

    def test_accomodations_combogrid_field(self):
        field = accomodations_combogrid_field(
            DummyRequest(), 'accomodation_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_switch_field(self):
        field = switch_field('switch')
        self.assertTrue('easyui-switchbutton' in field)

    def test_structures_combotree_field(self):
        field = structures_combotree_field('structure_id')
        self.assertTrue('easyui-combotree' in field)

    def test_accounts_items_combotree_field(self):
        field = accounts_items_combotree_field('account_item_id')
        self.assertTrue('easyui-combotree' in field)

    def test_permisions_yes_no_field(self):
        field = permisions_yes_no_field('account_item_id', 'yes', 'view')
        self.assertTrue('easyui-combobox' in field)

    def test_navigations_combotree_field(self):
        field = navigations_combotree_field('navigation_id', '2')
        self.assertTrue('easyui-combotree' in field)

    def test_permisions_scope_type_field(self):
        field = permisions_scope_type_field('scoped_type', 'all')
        self.assertTrue('easyui-combobox' in field)

    @patch('travelcrm.lib.utils.common_utils.get_locale_name')
    def test_date_field(self, _get_locale_name):
        _get_locale_name.return_value = 'en'
        field = date_field('date')
        self.assertTrue('easyui-datebox' in field)

    @patch('travelcrm.lib.utils.common_utils.get_locale_name')
    def test_datetime_field(self, _get_locale_name):
        _get_locale_name.return_value = 'en'
        field = datetime_field('datetime')
        self.assertTrue('easyui-datetimebox' in field)

    def test_gender_combobox_field(self):
        field = gender_combobox_field('gender')
        self.assertTrue('easyui-combobox' in field)

    def test_contact_type_combobox_field(self):
        field = contact_type_combobox_field('contact_type')
        self.assertTrue('easyui-combobox' in field)

    def test_countries_combogrid_field(self):
        field = countries_combogrid_field(
            DummyRequest(), 'country_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_regions_combogrid_field(self):
        field = regions_combogrid_field(
            DummyRequest(), 'region_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_locations_combogrid_field(self):
        field = locations_combogrid_field(
            DummyRequest(), 'location_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_suppliers_combogrid_field(self):
        field = suppliers_combogrid_field(
            DummyRequest(), 'supplier_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_foodcats_combogrid_field(self):
        field = foodcats_combogrid_field(
            DummyRequest(), 'foodcat_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_roomcats_combogrid_field(self):
        field = roomcats_combogrid_field(
            DummyRequest(), 'roomcat_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_hotels_combogrid_field(self):
        field = hotels_combogrid_field(
            DummyRequest(), 'hotelcat_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_currencies_combogrid_field(self):
        field = currencies_combogrid_field(
            DummyRequest(), 'currencies_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_persons_combogrid_field(self):
        field = persons_combogrid_field(
            DummyRequest(), 'persons_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_advsources_combogrid_field(self):
        field = advsources_combogrid_field(
            DummyRequest(), 'advsources_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_passport_type_field(self):
        field = passport_type_field('passport_type')
        self.assertTrue('easyui-combobox' in field)

    def test_banks_combogrid_field(self):
        field = banks_combogrid_field(
            DummyRequest(), 'bank_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_services_combogrid_field(self):
        field = services_combogrid_field(
            DummyRequest(), 'service_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_accounts_types_combobox_field(self):
        field = accounts_types_combobox_field('account_type')
        self.assertTrue('easyui-combobox' in field)

    def test_accounts_combogrid_field(self):
        field = accounts_combogrid_field(
            DummyRequest(), 'account'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_invoices_combogrid_field(self):
        field = invoices_combogrid_field(
            DummyRequest(), 'invoice_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_subaccounts_combogrid_field(self):
        field = subaccounts_combogrid_field(
            DummyRequest(), 'subaccount_id'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_timezones_field(self):
        field = timezones_field('timezones')
        self.assertTrue('easyui-combobox' in field)

    def test_locales_field(self):
        field = locales_field('locales')
        self.assertTrue('easyui-combobox' in field)

    def test_resources_types_statuses_combobox_field(self):
        field = resources_types_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_tasks_statuses_combobox_field(self):
        field = tasks_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_notifications_statuses_combobox_field(self):
        field = notifications_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_leads_statuses_combobox_field(self):
        field = leads_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_transfers_combogrid_field(self):
        field = transfers_combogrid_field(
            DummyRequest(), 'transfers'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_transports_combogrid_field(self):
        field = transports_combogrid_field(
            DummyRequest(), 'transports'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_tickets_classes_combogrid_field(self):
        field = tickets_classes_combogrid_field(
            DummyRequest(), 'tickets_classes'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_orders_items_statuses_combobox_field(self):
        field = orders_items_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_tasks_reminders_combobox_field(self):
        field = tasks_reminders_combobox_field(
            DummyRequest(), 'reminders'
        )
        self.assertTrue('easyui-combobox' in field)

    def test_accounts_items_statuses_combobox_field(self):
        field = accounts_items_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)


    def test_accounts_items_types_combobox_field(self):
        field = accounts_items_types_combobox_field('items_types')
        self.assertTrue('easyui-combobox' in field)

    def test_suppliers_statuses_combobox_field(self):
        field = suppliers_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_contracts_statuses_combobox_field(self):
        field = contracts_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_bpersons_statuses_combobox_field(self):
        field = bpersons_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_visas_types_combobox_field(self):
        field = visas_types_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_leads_offers_statuses_combobox_field(self):
        field = leads_offers_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_accounts_statuses_combobox_field(self):
        field = accounts_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_orders_statuses_combobox_field(self):
        field = orders_statuses_combobox_field('statuses')
        self.assertTrue('easyui-combobox' in field)

    def test_vats_calc_methods_combobox_field(self):
        field = vats_calc_methods_combobox_field('vats')
        self.assertTrue('easyui-combobox' in field)

    def test_campaigns_statuses_combobox_field(self):
        field = campaigns_statuses_combobox_field('vats')
        self.assertTrue('easyui-combobox' in field)

    def test_suppliers_types_combogrid_field(self):
        field = suppliers_types_combogrid_field(
            DummyRequest(), 'suppliers_types'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_leads_combogrid_field(self):
        field = leads_combogrid_field(
            DummyRequest(), 'leads'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_orders_combogrid_field(self):
        field = orders_combogrid_field(
            DummyRequest(), 'orders'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_companies_combogrid_field(self):
        field = companies_combogrid_field(
            DummyRequest(), 'companies'
        )
        self.assertTrue('easyui-combogrid' in field)

    def test_persons_categories_combogrid_field(self):
        field = persons_categories_combogrid_field(
            DummyRequest(), 'persons_categories'
        )
        self.assertTrue('easyui-combogrid' in field)
