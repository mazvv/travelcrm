# -*coding: utf-8-*-

from collections import Iterable

from pyramid_mailer import Mailer

from ...resources.campaigns import CampaignsResource

from ...models import DBSession
from ...models.resource import Resource
from ...models.person import Person
from ...models.tag import Tag
from ...lib.utils.resources_utils import get_resource_settings_by_resource_cls


def get_mailer_settings():
    return get_resource_settings_by_resource_cls(CampaignsResource)


def get_mailer():
    return Mailer().from_settings(get_mailer_settings(), '')


def query_coverage(person_category_id, tag_id):
    """ get auditory coverage of campaign by persons categories and tags
    """
    assert isinstance(person_category_id, Iterable)
    assert isinstance(tag_id, Iterable)
    query =  DBSession.query(Person)
    conditions = [Person.condition_email_subscribtion()]
    if person_category_id:
        conditions.append(Person.person_category_id.in_(person_category_id))
    if tag_id:
        query = (
            query.distinct(Person.id)
            .join(Resource, Person.resource)
            .join(Tag, Resource.tags)
        )
        conditions.append(Tag.id.in_(tag_id))
    return query.filter(*conditions)
