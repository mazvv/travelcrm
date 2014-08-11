<div class="dl45 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"location"), True, "location_id")}
            </div>
            <div class="ml15">
                ${h.fields.locations_combobox_field(request, item.location_id if item else None)}
                ${h.common.error_container(name='location_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"hotel"), False, "hotel_id")}
            </div>
            <div class="ml15">
                ${h.fields.hotels_combobox_field(request, item.hotel_id if item else None)}
                ${h.common.error_container(name='hotel_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"accomodation"), False, "accomodation_id")}
            </div>
            <div class="ml15">
                ${h.fields.accomodations_combobox_field(request, item.accomodation_id if item else None)}
                ${h.common.error_container(name='accomodation_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"food category"), False, "foodcat_id")}
            </div>
            <div class="ml15">
                ${h.fields.foodcats_combobox_field(request, item.foodcat_id if item else None)}
                ${h.common.error_container(name='foodcat_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"room category"), False, "roomcat_id")}
            </div>
            <div class="ml15">
                ${h.fields.roomcats_combobox_field(request, item.roomcat_id if item else None)}
                ${h.common.error_container(name='roomcat_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"start"), True, "start_date")}
            </div>
            <div class="ml15">
                ${h.fields.date_field(item.start_date if item else None, 'start_date')}
                ${h.common.error_container(name='start_date')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"end"), True, "end_date")}
            </div>
            <div class="ml15">
                ${h.fields.date_field(item.end_date if item else None, 'end_date')}
                ${h.common.error_container(name='end_date')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"description"), False, "description")}
            </div>
            <div class="ml15">
                ${h.tags.text('description', item.description if item else None, class_="easyui-textbox w20", data_options="multiline:true,height:80")}
                ${h.common.error_container(name='description')}
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
