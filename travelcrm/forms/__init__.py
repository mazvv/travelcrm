# -*-coding: utf-8-*-

from cgi import FieldStorage

import colander
import phonenumbers
from colander import (
    Date as ColanderDate,
    Invalid,
    null,
    _
)
from babel.dates import (
    parse_date,
    parse_time
)

from ..lib.utils.common_utils import get_locale_name


class ResourceSchema(colander.Schema):
    pass


class Date(ColanderDate):

    def deserialize(self, node, cstruct):
        if not cstruct:
            return null
        try:
            result = parse_date(cstruct, locale=get_locale_name())
        except:
            raise Invalid(
                node,
                _(
                    self.err_template,
                    mapping={'val': cstruct}
                )
            )
        return result


class DateTime(ColanderDate):

    def deserialize(self, node, cstruct):
        if not cstruct:
            return null
        try:
            result = parse_date(cstruct, locale=get_locale_name())
        except:
            raise Invalid(
                node,
                _(
                    self.err_template,
                    mapping={'val': cstruct}
                )
            )
        return result


class Time(ColanderDate):

    def deserialize(self, node, cstruct):
        if not cstruct:
            return null
        try:
            # Now Babel does not understand time without seconds
            cstruct = "%s:00" % cstruct
            result = parse_time(cstruct, locale=get_locale_name())
        except:
            raise Invalid(
                node,
                _(
                    self.err_template,
                    mapping={'val': cstruct}
                )
            )
        return result


class PhoneNumber(object):

    def __call__(self, node, value):
        try:
            phone = phonenumbers.parse(value)
        except phonenumbers.NumberParseException:
            raise Invalid(
                node,
                _(
                    u"Phone must be in format +XXXXXXXXXXX "
                    u"and contains country code",
                    mapping={'val': value}
                )
            )
        if not phonenumbers.is_valid_number(phone):
            raise Invalid(
                node,
                _(
                    u"Phone is not valid",
                    mapping={'val': value}
                )
            )


class File(colander.SchemaType):

    def serialize(self, node, appstruct):
        if appstruct is colander.null:
            return colander.null
        return appstruct

    def deserialize(self, node, cstruct):
        if cstruct is None or not isinstance(cstruct, FieldStorage):
            return colander.null
        return cstruct
