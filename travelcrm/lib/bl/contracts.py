# -*coding: utf-8-*-

from datetime import datetime

from ...models import DBSession
from ...models.contract import Contract
from ...models.supplier import Supplier
from ...models.commission import Commission
from ...resources.commissions import CommissionsResource
from ...lib.utils.security_utils import get_auth_employee


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


def get_contract_copy(contract_id, request):
    contract = Contract.get(contract_id)
    supplier = contract.supplier

    commissions = []
    for commission in list(contract.commissions):
        commission = Commission.get_copy(commission.id)
        resource = CommissionsResource.create_resource(
            get_auth_employee(request)
        )        
        DBSession.add(resource)
        DBSession.flush([resource,])
        commission.resource = resource
        commissions.append(commission)
    DBSession.add_all(commissions)
    DBSession.flush(commissions)

    contract = Contract.get_copy(contract.id)
    if not contract:
        return

    contract.supplier = supplier
    contract.commissions = commissions
    return contract
