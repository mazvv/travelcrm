# -*-coding: utf-8 -*-

import colander


class AddForm(colander.MappingSchema):
    name = colander.SchemaNode(
        colander.String(),
    )
    status = colander.SchemaNode(
        colander.Integer(),
        validator=colander.OneOf([0, 1, 2])
    )


class EditForm(AddForm):
    pass


class PermissionsForm(colander.MappingSchema):
    rid = colander.SchemaNode(
        colander.Integer(),
    )
    _resources_types_rid = colander.SchemaNode(
        colander.Integer(),
    )
    permissions = colander.SchemaNode(
        colander.Set(),
    )

    def deserialize(self, cstruct):
        cstruct = dict(cstruct)
        cstruct['permissions'] = map(
            lambda x: x.strip(),
            cstruct.get('permissions').split(',')
        )
        return super(PermissionsForm, self).deserialize(cstruct)
