# -*coding: utf-8-*-

from ...models import DBSession
from ...models.contract import Contract
from ...models.commission import Commission

from ...lib.bl.currencies_rates import currency_exchange


def get_commission(
    contract_id, service_id, currency_id
):
    """ get commission sum
    """
    assert isinstance(contract_id, int)
    assert isinstance(currency_id, int)
    assert isinstance(service_id, int)

    return (
        DBSession.query(Commission)
        .join(Contract, Commission.contract)
        .filter(
            Contract.id == contract_id,
            Commission.service_id == service_id,
        )
        .first()
    )


def get_commission_sum(commission_id, sum, currency_id, date):
    commission = Commission.get(commission_id)
    commission_sum = sum * commission.percentage / 100
    if commission.price:
        commission_sum += currency_exchange(
            commission.price,
            commission.currency_id,
            currency_id,
            commission.contract.supplier.id,
            date
        )
    return commission_sum
