# -*coding: utf-8-*-

from ...models import DBSession
from ...models.contact import Contact
from ...models.person import Person


def get_all_subscribers():
    """get all subscribers
    """
    return (
        DBSession.query(Person.name, Contact.contact)
        .join(Person, Contact.person)
        .filter(
            Person.condition_subscriber(),
            Contact.condition_email()
        )
    )
