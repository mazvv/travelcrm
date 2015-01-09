<%namespace file="../contacts/common.mak" import="contacts_selector"/>
<%namespace file="../passports/common.mak" import="passports_selector"/>
<%namespace file="../addresses/common.mak" import="addresses_selector"/>
<%namespace file="../notes/common.mak" import="notes_selector"/>
<%namespace file="../tasks/common.mak" import="tasks_selector"/>
<div class="dl70 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax %s" % ('readonly' if readonly else ''), autocomplete="off", multipart=True)}
        <div class="easyui-tabs h100" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
                <div class="p1">
                    <div class="dl15">
                        <div class="image-thumb">
                            % if item and item.photo:
                            ${h.tags.image(
                                request.route_url(
                                    'thumbs', 
                                    size='thumb', 
                                    path=request.storage.url(item.photo)
                                ),
                                item.name,
                                align='center'
                            )}
                            % endif
                        </div>
                    </div>
                    <div class="ml15">
                    	${h.tags.text('photo', None, class_='easyui-filebox w20', data_options="buttonText: '%s'" % _(u'Choose Image'))}
                        ${h.common.error_container(name='photo')}
                        % if item and item.photo:
                        <div class="mt1">
                            ${h.tags.checkbox('delete_photo', 1, False, label=_(u"delete photo"))}
                        </div>
                        % endif
                    </div>
                    <div class="clear"></div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"first name"), True, "first_name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("first_name", item.first_name if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='first_name')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"second name"), False, "second_name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("second_name", item.second_name if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='second_name')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"last name"), True, "last_name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("last_name", item.last_name if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='last_name')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"tax number"), False, "itn")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("itn", item.itn if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='itn')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"dismissal date"), False, "dismissal_date")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field(item.dismissal_date if item else None, "dismissal_date")}
                        ${h.common.error_container(name='dismissal_date')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Contacts')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${contacts_selector(
                        values=([contact.id for contact in item.contacts] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>                
            </div>            
            <div title="${_(u'Passports')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${passports_selector(
                        values=([passport.id for passport in item.passports] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            <div title="${_(u'Addresses')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${addresses_selector(
                        values=([address.id for address in item.addresses] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            % if item:
            <%
                _id = h.common.gen_id()
            %>            
            <div title="${_(u'Appointments')}">
                <table class="easyui-datagrid"
                    id="${_id}"
                    data-options="
                        url:'appointments/list',border:false,
                        pagination:true,fit:true,pageSize:50,singleSelect:true,
                        rownumbers:true,sortName:'date',sortOrder:'desc',
                        pageList:[50,100,500],idField:'_id',checkOnSelect:false,
                        onBeforeLoad: function(param){
                             param.employee_id = ${item.id};
                        }
                    " width="100%">
                    <thead>
                        <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
                        <th data-options="field:'date',sortable:true,width:80">${_(u"date")}</th>
                        <th data-options="field:'position_name',sortable:true,width:150">${_(u"position")}</th>
                        <th data-options="field:'structure_path',sortable:true,width:200,formatter:function(value,row,index){return (value)?value.join(' &rarr; '):'';}">${_(u"structure")}</th>
                        <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
                        <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
                    </thead>
                </table>
            </div>    
            % endif        
            <div title="${_(u'Notes')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${notes_selector(
                        values=([note.id for note in item.resource.notes] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            <div title="${_(u'Tasks')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${tasks_selector(
                        values=([task.id for task in item.resource.tasks] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar"></div>
            <div class="ml20 tr button-group">
                ${h.tags.submit('save', _(u"Save"), class_="button")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
