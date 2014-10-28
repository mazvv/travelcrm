# -*coding: utf-8-*-

from datetime import datetime, date

from sqlalchemy import desc

from ...models import DBSession
from ...models.commission import Commission
from ...models.touroperator import Touroperator

from ...lib.bl.currencies_rates import currency_exchange
from ...lib.utils.common_utils import money_cast


def get_commission(
    sum, touroperator_id, service_id, currency_id, commission_date
):
    """ get commission sum
    """
    assert isinstance(touroperator_id, int)
    assert isinstance(currency_id, int)
    assert isinstance(service_id, int)
    assert isinstance(commission_date, (datetime, date))

    commission = (
        DBSession.query(Commission)
        .join(Touroperator, Commission.touroperator)
        .filter(
            Commission.service_id == service_id,
            Touroperator.id == touroperator_id,
            Commission.date_from < commission_date,
        )
        .order_by(desc(Commission.date_from))
        .first()
    )
    if not commission:
        return money_cast(0)
    commission_sum = sum * commission.percentage / 100
    if commission.price:
        commission_sum += currency_exchange(
            commission.price,
            commission.currency_id,
            currency_id,
            commission_date
        )
    return money_cast(commission_sum)
