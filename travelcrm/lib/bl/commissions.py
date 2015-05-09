# -*coding: utf-8-*-

from datetime import datetime, date

from sqlalchemy import desc

from ...models import DBSession
from ...models.commission import Commission
from ...models.supplier import Supplier

from ...lib.bl.currencies_rates import currency_exchange


def get_commission(
    sum, supplier_id, service_id, currency_id, commission_date
):
    """ get commission sum
    """
    assert isinstance(supplier_id, int)
    assert isinstance(currency_id, int)
    assert isinstance(service_id, int)
    assert isinstance(commission_date, (datetime, date))

    commission = (
        DBSession.query(Commission)
        .join(Supplier, Commission.supplier)
        .filter(
            Commission.service_id == service_id,
            Supplier.id == supplier_id,
            Commission.date_from < commission_date,
        )
        .order_by(desc(Commission.date_from))
        .first()
    )
    if not commission:
        return 0
    commission_sum = sum * commission.percentage / 100
    if commission.price:
        commission_sum += currency_exchange(
            commission.price,
            commission.currency_id,
            currency_id,
            commission_date
        )
    return commission_sum
