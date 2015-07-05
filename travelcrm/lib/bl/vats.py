# -*coding: utf-8-*-

from datetime import date

from ...models import DBSession
from ...models.vat import Vat


def get_vat(
    account_id, service_id, calc_date
):
    """ get supplier price by service
    """
    assert isinstance(account_id, int), u'Must be integer'
    assert isinstance(calc_date, date), u'Must be date instance'
    assert isinstance(service_id, int), u'Must be integer'

    vat = (
        DBSession.query(Vat)
        .filter(
            Vat.account_id == account_id, 
            Vat.service_id == service_id,
            Vat.date <= calc_date
        )
        .order_by(Vat.date.desc())
        .first()
    )
    return vat


def calc_vat(vat_id, amount):
    vat = Vat.get(vat_id)
    return amount * vat.vat / (100 + vat.vat)
