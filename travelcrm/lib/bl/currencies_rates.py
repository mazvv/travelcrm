# -*coding: utf-8-*-

from sqlalchemy import desc

from ...models import DBSession
from ...models.currency_rate import CurrencyRate


def get_currency_rate(currency_id, supplier_id, date):
    currency_rate = (
        DBSession.query(CurrencyRate)
        .filter(
            CurrencyRate.currency_id == currency_id,
            CurrencyRate.supplier_id == supplier_id,
            CurrencyRate.date <= date
        )
        .order_by(CurrencyRate.currency_id, desc(CurrencyRate.date))
        .first()
    )
    return currency_rate.rate if currency_rate else 1


def currency_exchange(
    amount, from_currency_id, to_currency_id, supplier_id, date
):
    rate_from = get_currency_rate(from_currency_id, supplier_id, date)
    rate_to = get_currency_rate(to_currency_id, supplier_id, date)
    base_amount = amount * rate_from
    return base_amount / rate_to


def currency_base_exchange(amount, currency_id, supplier_id, date):
    base_rate = get_currency_rate(currency_id, supplier_id, date)
    return base_rate * amount
