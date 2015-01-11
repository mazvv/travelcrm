# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    ResourceSearchSchema,
    DateTime
)


class EmailCampaignSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32),
    )
    subject = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=128),
    )
    plain_content = colander.SchemaNode(
        colander.String(),
    )
    html_content = colander.SchemaNode(
        colander.String(),
    )
    start_dt = colander.SchemaNode(
        DateTime(),
    )


class SettingsSchema(colander.Schema):
    timeout = colander.SchemaNode(
        colander.Integer(),
        default=10
    )


class EmailCampaignSearchSchema(ResourceSearchSchema):
    pass
