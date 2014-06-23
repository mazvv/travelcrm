# -*coding: utf-8-*-

from sqlalchemy import desc, func

from ...models import DBSession
from ...models.currency_rate import CurrencyRate


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
