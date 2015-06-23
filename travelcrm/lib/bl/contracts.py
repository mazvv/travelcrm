# -*coding: utf-8-*-

from datetime import datetime

from ...models import DBSession
from ...models.contract import Contract
from ...models.supplier import Supplier


def get_contract(supplier_id, date=None):
    """ get active ontract on date
    """
    assert isinstance(supplier_id, int)
    if not date:
        date = datetime.now()
    return (
        DBSession.query(Contract)
        .join(Supplier, Contract.supplier)
        .filter(
            Contract.condition_active(),
            Contract.date <= date,
            Supplier.id == supplier_id
        )
        .order_by(Contract.date.desc())
        .first()
    )
