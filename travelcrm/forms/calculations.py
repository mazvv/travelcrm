# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.calculations import CalculationsResource
from ..models.calculation import Calculation
from ..models.order import Order
from ..models.note import Note
from ..models.task import Task
from ..lib.bl.contracts import get_contract
from ..lib.bl.commissions import (
    get_commission, 
    get_commission_sum
)
from ..lib.qb.calculations import CalculationsQueryBuilder


class _CalculationAutoloadSchema(ResourceSchema):
    id = colander.SchemaNode(
        colander.Integer()
    )


class CalculationAutoloadForm(BaseForm):
    _schema = _CalculationAutoloadSchema

    def submit(self):
        context = CalculationsResource(self.request)
        order = Order.get(self._controls.get('id'))
        calculations = []
        for order_item in order.orders_items:
            # make autoload for success items only
            if not order_item.is_success():
                continue
            contract = get_contract(
                order_item.supplier_id,
                order.deal_date
            )
            if not contract:
                continue
            commission = 0
            if contract:
                _commission = get_commission(
                    contract.id, 
                    order_item.service_id,
                    order_item.currency_id,
                )
                if _commission:
                    commission = get_commission_sum(
                        _commission.id, 
                        order_item.price, 
                        order_item.currency_id,
                        order.deal_date
                    )
            calculation = Calculation(
                price=(order_item.final_price - commission),
                order_item=order_item,
                resource=context.create_resource()
            )
            calculation.resource.notes = []
            calculation.resource.tasks = []
            calculations.append(calculation)
        return calculations


class _CalculationSchema(ResourceSchema):
    price = colander.SchemaNode(
        colander.Money()
    )


class CalculationForm(BaseForm):
    _schema = _CalculationSchema

    def submit(self, calculation=None):
        context = CalculationsResource(self.request)
        if not calculation:
            calculation = Calculation(
                resource=context.create_resource()
            )
        else:
            calculation.resource.notes = []
            calculation.resource.tasks = []
        calculation.price = self._controls.get('price')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            calculation.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            calculation.resource.tasks.append(task)
        return calculation


class CalculationSearchForm(BaseSearchForm):
    _qb = CalculationsQueryBuilder

    def _search(self):
        self.qb.search_simple(self._controls.get('q'))
        self.qb.advanced_search(**self._controls)
        id = self._controls.get('id')
        order = Order.get(id)
        ids = [
            (order_item.calculation and order_item.calculation.id)
            for order_item in order.orders_items
        ]
        if ids:
            self.qb.filter_id(ids)
