# -*coding: utf-8-*-

from sqlalchemy import func, case

from ...models import DBSession
from ...models.person import Person
from ...models.contact import Contact
from ...models.passport import Passport


def query_person_contacts():
    return (
        DBSession.query(
            Person.id.label('person_id'),
            func.array_to_string(
                func.array_agg(
                    case([(Contact.contact_type == 'phone', Contact.contact)])
                ),
                ', '
            ).label('phone'),
            func.array_to_string(
                func.array_agg(
                    case([(Contact.contact_type == 'email', Contact.contact)])
                ),
                ', '
            ).label('email'),
            func.array_to_string(
                func.array_agg(
                    case([(Contact.contact_type == 'skype', Contact.contact)])
                ),
                ', '
            ).label('skype'),
        )
        .join(Contact, Person.contacts)
        .group_by(Person.id)
    )


def query_person_passports():
    return (
        DBSession.query(
            Person.id.label('person_id'),
            func.array_to_string(
                func.array_agg(
                    case([(Passport.passport_type == 'citizen', Passport.num)])
                ),
                ', '
            ).label('citizen'),
            func.array_to_string(
                func.array_agg(
                    case([(Passport.passport_type == 'foreign', Passport.num)])
                ),
                ', '
            ).label('foreign'),
        )
        .join(Passport, Person.passports)
        .group_by(Person.id)
    )
    