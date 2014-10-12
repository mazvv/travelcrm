# -*coding: utf-8-*-

from ...interfaces import ISubaccountFactory

from ...lib.utils.resources_utils import get_resources_types_by_interface


def get_subaccounts_types():
    return get_resources_types_by_interface(ISubaccountFactory)
