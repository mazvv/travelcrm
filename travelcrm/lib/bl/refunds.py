# -*coding: utf-8-*-

from ...models.fin_transaction import FinTransaction

from ...lib.utils.resources_utils import get_resource_type_by_resource_cls


class RefundPaymentsFactory(object):

    @classmethod
    def make_payment(cls, date, sum):
        rt = get_resource_type_by_resource_cls()
        settings = rt.settings()
        return FinTransaction(
            account_item_id=settings.get('account_item_id'),
            date=date,
            sum=sum
        )
