# -*coding: utf-8-*-

from sqlalchemy import desc, func

from ...models import DBSession
from ...models.currency_rate import CurrencyRate

from ...lib.utils.common_utils import money_cast


def query_convert_rates(in_attr, date_attr):
    subq = (
        DBSession.query(CurrencyRate)
        .order_by(CurrencyRate.currency_id, desc(CurrencyRate.date))
        .subquery()
    )
    query = (
        DBSession.query(
            func.coalesce(subq.c.rate, 1).label('rate')
        )
        .distinct(subq.c.currency_id)
        .filter(
            subq.c.currency_id == in_attr,
            subq.c.date <= date_attr
        )
    )
    return query


def currency_exchange(sum, from_currency_id, to_currency_id, date):
    rate_from = query_convert_rates(from_currency_id, date).scalar() or 1
    rate_to = query_convert_rates(to_currency_id, date).scalar() or 1
    base_sum = sum * rate_from
    return money_cast(base_sum / rate_to)
