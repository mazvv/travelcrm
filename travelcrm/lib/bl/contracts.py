# -*coding: utf-8-*-

from datetime import datetime

from ...models import DBSession
from ...models.contract import Contract
from ...models.supplier import Supplier
from ...models.commission import Commission


def get_contract(supplier_id, service_id, date=None):
    """ get active ontract on date
    """
    assert isinstance(supplier_id, int)
    assert isinstance(service_id, int)
    if not date:
        date = datetime.now()
    return (
        DBSession.query(Contract)
        .join(Supplier, Contract.supplier)
        .join(Commission, Contract.commissions)
        .filter(
            Contract.condition_active(),
            Contract.date <= date,
            Supplier.id == supplier_id,
            Commission.service_id == service_id,
        )
        .order_by(Contract.date.desc())
        .first()
    )
