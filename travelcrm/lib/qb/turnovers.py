# -*coding: utf-8-*-

from . import GeneralQueryBuilder
from ...models import DBSession
from ...models.account import Account
from ...models.currency import Currency

from ...lib.bl.turnovers import query_turnovers
from ...lib.utils.common_utils import money_cast


class TurnoversQueryBuilder(GeneralQueryBuilder):
    _subq = query_turnovers().subquery()
    
    _fields = {
        'id': _subq.c.id,
        '_id': _subq.c.id,
        'name': Account.name,
        'currency': Currency.iso_code,
        'sum_from': _subq.c.sum_from,
        'sum_to': _subq.c.sum_to,
        'balance': money_cast(_subq.c.sum_to - _subq.c.sum_from)
    }

    def __init__(self):
        fields = GeneralQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            DBSession.query(*fields)
            .join(Account, Account.id == self._subq.c.id)
            .join(Currency, Account.currency)
        )
