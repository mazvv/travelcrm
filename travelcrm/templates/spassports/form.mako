<%namespace file="../persons/common.mako" import="persons_selector"/>
<div class="dl65 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(
        action or request.url, 
        class_="_ajax %s" % ('readonly' if readonly else ''), 
        autocomplete="off",
        hidden_fields=[
            ('csrf_token', request.session.get_csrf_token()),
            ('service_id', item.order_item.service_id if item else request.params.get('id'))
        ]
    )}
        <div class="easyui-tabs" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"supplier"), True, "supplier_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.suppliers_combogrid_field(
                            request,
                            'supplier_id',
                            item.order_item.supplier_id if item else None,
                            show_toolbar=(not readonly if readonly else True)
                        )}
                        ${h.common.error_container(name='supplier_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"price"), True, "price")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('price', 
                            item.order_item.price if item else None, 
                            class_="easyui-textbox w20 easyui-numberbox", 
                            data_options="min:0,precision:2"
                        )}
                        ${h.common.error_container(name='price')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"price currency"), True, "currency_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.currencies_combogrid_field(
                            request,
                            'currency_id',
                            item.order_item.currency_id if item else None,
                            show_toolbar=(not readonly if readonly else True)
                        )}
                        ${h.common.error_container(name='currency_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"discount, sum"), False, "discount_sum")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('discount_sum', item.order_item.discount_sum if item else None, class_="easyui-textbox w20 easyui-numberbox", data_options="min:0,precision:2")}
                        ${h.common.error_container(name='discount_sum')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"discount, %"), False, "discount_percent")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('discount_percent', item.order_item.discount_percent if item else None, class_="easyui-textbox w20 easyui-numberbox", data_options="min:0,precision:2")}
                        ${h.common.error_container(name='discount_percent')}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"description"), False, "descr")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('descr', item.descr if item else None, class_="easyui-textbox w20", data_options="multiline:true,height:80")}
                        ${h.common.error_container(name='descr')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Passport Info')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"photo done"), True, "photo_done")}
                    </div>
                    <div class="ml15">
                        ${h.fields.yes_no_field('photo_done', int(item.photo_done) if item else None)}
                        ${h.common.error_container(name='photo_done')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"docs receive"), False, "docs_receive_date")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field('docs_receive_date', item.docs_receive_date if item else None)}
                        ${h.common.error_container(name='docs_receive_date')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"docs transfer"), False, "docs_transfer_date")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field('docs_transfer_date', item.docs_transfer_date if item else None)}
                        ${h.common.error_container(name='docs_transfer_date')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"passport receive"), False, "passport_receive_date")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field('passport_receive_date', item.passport_receive_date if item else None)}
                        ${h.common.error_container(name='passport_receive_date')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Members')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${persons_selector(
                        values=([person.id for person in item.order_item.persons] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            <div title="${_(u'Confirmation')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"status"), True, "status")}
                    </div>
                    <div class="ml15">
                        ${h.fields.orders_items_statuses_combobox_field(
                            'status',
                            item.order_item.status.key if item else None,
                        )}
                        ${h.common.error_container(name='status')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"status date"), False, "status_date")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field('status_date', item.order_item.status_date if item else None)}
                        ${h.common.error_container(name='status_date')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"status info"), False, "status_info")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('status_info', 
                            item.order_item.status_info if item else None, 
                            class_="easyui-textbox w20",
                        )}
                        ${h.common.error_container(name='status_info')}
                    </div>
                </div>
            </div>
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar"></div>
            <div class="ml20 tr button-group">
                ${h.tags.submit('save', _(u"Save"), class_="button easyui-linkbutton")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger easyui-linkbutton")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
