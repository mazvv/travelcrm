# -*coding: utf-8-*-

from datetime import date
from decimal import Decimal

from sqlalchemy import desc

from ...models import DBSession
from ...models.resource import Resource
from ...models.touroperator import Touroperator
from ...models.subaccount import Subaccount
from ...models.commission import Commission

from ...lib.bl import SubaccountFactory
from ..utils.common_utils import money_cast
from ...lib.bl.currencies_rates import currency_exchange


def get_calculation(
    touroperator_id, calc_date, service_id, price, currency_id
):
    """ get supplier price by service
    """
    assert isinstance(touroperator_id, int), u'Must be integer'
    assert isinstance(calc_date, date), u'Must be date instance'
    assert isinstance(price, Decimal), u'Must be Decimal instance'
    assert isinstance(service_id, int), u'Must be integer'

    commission = (
        DBSession.query(Commission)
        .join(Touroperator, Commission.touroperator)
        .filter(
            Touroperator.id == touroperator_id,
            Commission.service_id == service_id,
            Commission.date_from <= calc_date,
        )
        .order_by(desc(Commission.date_from))
        .first()
    )
    if commission:
        if commission.percentage:
            price = price * (100 - commission.percentage) / 100
        if commission.price:
            price -= currency_exchange(
                commission.price,
                commission.currency_id,
                currency_id,
                calc_date
            )
    return money_cast(price)


class TouroperatorSubaccountFactory(SubaccountFactory):

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Touroperator.id.label('id'),
                Touroperator.name.label('title'),
                Subaccount.name.label('name'),
                Subaccount.id.label('subaccount_id'),
            )
            .join(Resource, Touroperator.resource)
            .join(Subaccount, Touroperator.subaccounts)
        )
        return query

    @classmethod
    def get_source_resource(cls, id):
        touroperator = Touroperator.get(id)
        return touroperator.resource

    @classmethod
    def bind_subaccount(cls, resource_id, subaccount):
        assert isinstance(subaccount, Subaccount)
        touroperator = (
            DBSession.query(Touroperator)
            .filter(Touroperator.resource_id == resource_id)
            .first()
        )
        touroperator.subaccounts.append(subaccount)
        return touroperator
