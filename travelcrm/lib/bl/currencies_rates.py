# -*coding: utf-8-*-

from sqlalchemy import desc, cast, func, Numeric

from ...models import DBSession
from ...models.currency_rate import CurrencyRate


def query_convert_rates(in_attr, out_attr, date_attr):
    subq = (
        DBSession.query(CurrencyRate)
        .order_by(CurrencyRate.currency_id, desc(CurrencyRate.date))
        .subquery()
    )
    query_out = (
        DBSession.query(subq.c.rate)
        .distinct(subq.c.currency_id)
        .filter(
            subq.c.currency_id == out_attr,
            subq.c.date <= date_attr
        )
    )
    return (
        DBSession.query(
            cast(
                func.coalesce(subq.c.rate / query_out, subq.c.rate, 1),
                Numeric(16, 4)
            )
        )
        .distinct(subq.c.currency_id)
        .filter(
            subq.c.currency_id == in_attr,
            subq.c.date <= date_attr
        )
    )
