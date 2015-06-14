# -*coding: utf-8-*-

from ...models.order import Order
from ...lib.bl.orders_items import get_price, get_discount


def get_order_price(order_id, date, currency_id):
    order = Order.get(order_id)
    return reduce(
        lambda x, item: x + get_price(item, date, currency_id),
        order.orders_items, 0
    )


def get_order_discount(order_id, date, currency_id):
    order = Order.get(order_id)
    return reduce(
        lambda x, item: x + get_discount(item, date, currency_id),
        order.orders_items, 0
    )
