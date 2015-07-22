# -*coding: utf-8-*-

from ...models.order_item import OrderItem
from ...lib.bl.currencies_rates import currency_exchange


def get_price(order_item, date, currency_id):
    assert isinstance(order_item, OrderItem), \
        u'OrderItem expected got %s' % order_item
    if order_item.currency_id == currency_id:
        return order_item.price
    return currency_exchange(
        order_item.price, order_item.currency_id, currency_id, 
        order_item.supplier_id, date
    )


def get_discount(order_item, date, currency_id):
    assert isinstance(order_item, OrderItem), \
        u'OrderItem expected got %s' % order_item
    if order_item.currency_id == currency_id or order_item.discount == 0:
        return order_item.discount
    return currency_exchange(
        order_item.discount, order_item.currency_id, currency_id, 
        order_item.supplier_id, date
    )


def get_calculation_price(order_item, date, currency_id):
    assert isinstance(order_item, OrderItem), \
        u'OrderItem expected got %s' % order_item
    if order_item.currency_id == currency_id:
        return order_item.calculation.price
    assert order_item.calculation, \
        u'Calculation for %s does not exists' % order_item.id
    return currency_exchange(
        order_item.calculation.price, order_item.currency_id, currency_id, 
        order_item.supplier_id, date
    )
