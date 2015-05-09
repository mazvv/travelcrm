# -*coding: utf-8-*-

from datetime import date
from decimal import Decimal

from sqlalchemy import desc

from ...models import DBSession
from ...models.supplier import Supplier
from ...models.commission import Commission

from ...lib.bl.currencies_rates import currency_exchange


def get_calculation(
    supplier_id, calc_date, service_id, price, currency_id
):
    """ get supplier price by service
    """
    assert isinstance(supplier_id, int), u'Must be integer'
    assert isinstance(calc_date, date), u'Must be date instance'
    assert isinstance(price, Decimal), u'Must be Decimal instance'
    assert isinstance(service_id, int), u'Must be integer'

    commission = (
        DBSession.query(Commission)
        .join(Supplier, Commission.supplier)
        .filter(
            Supplier.id == supplier_id,
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
    return price
