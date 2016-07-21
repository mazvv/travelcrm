# -*coding: utf-8-*-

from ...lib.utils.common_utils import translate as _


def get_tarifs_list():
    """return list of tarifs
    0 - code, 1 - name, 2 - description, 3 - ip limit, 4 - period, 5 - cost
    """
    #TODO: rework this
    return [
        (
            '1', _(u'Free'),
            _('free for single user, limit support'),
            1, 30, _('0.00 UAH / month')
        ),
        (
            '2', _(u'Standart'), _('up to 3 users with full support'),
            3, 30, _('120.00 UAH / month')
        ),
        (   
            '3', _(u'Premium'), _('up to 10 users with full support'), 
            10, 30, _('250.00 UAH / month')
        )
    ]


def get_tarif_by_code(code):
    for item in get_tarifs_list():
        if item[0] == code:
            return item
