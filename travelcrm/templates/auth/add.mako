<%inherit file="travelcrm:templates/auth/_layout.mako"/>
<%namespace file="../common/infoblock.mako" import="infoblock"/>
<div class="dl45 easyui-dialog"
    title="${_(u'Create company')}"
    data-options="
        modal:true,
        draggable:false,
        closable: false,
        resizable:false,
        iconCls:'fa fa-plus'
    ">
    ${h.tags.form(
        request.url, 
        class_="_ajax", 
        autocomplete="off",
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        <div class="form-field mt05">
            <div class="dl15">
                ${h.tags.title(_(u"email"), True, "email")}
            </div>
            <div class="ml15">
                ${h.tags.text("email", None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='email')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"name"), True, "name")}
            </div>
            <div class="ml15">
                ${h.tags.text("name", None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='name')}
            </div>
        </div>
        % if h.common.get_tarifs():
            <div class="info-block mb05">
                <div class="tc dl2">
                    <span class="fa fa-credit-card">&nbsp;</span>
                </div>
                <div class="ml2 b">
                    ${_(u'Select your tarif')}
                </div>
            </div>

            % for tarif in h.common.get_tarifs_list():
                <div class="form-field">
                    <div class="dl10 b">${tarif[1]}</div>
                    <div class="dl20 class="black-pepper">${tarif[2]}</div>
                    <div class="ml30 b tr">${tarif[-1]}</div>
                </div>
            % endfor

            <div class="form-field mt05">
                <div class="dl15">
                    ${h.tags.title(_(u"tarif"), True, "tarif")}
                </div>
                <div class="ml15">
                    ${h.fields.tarifs_combobox_field(
                        "tarif", value=request.params.get('tarif_code'),
                        style="width:271px;"
                    )}
                    ${h.common.error_container(name='tarif')}
                </div>
            </div>
            <div class="info-block mb05"></div>
        % endif
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"timezone"), True, "timezone")}
            </div>
            <div class="ml15">
                ${h.fields.timezones_field('timezone', style="width:271px;")}
                ${h.common.error_container(name='timezone')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"locale"), True, "locale")}
            </div>
            <div class="ml15">
                ${h.fields.locales_field(
                    'locale', value=h.common.get_default_locale_name()
                )}
                ${h.common.error_container(name='locale')}
            </div>
        </div>
        <div class="form-field mb05">
            <i class="fa fa-long-arrow-left"></i>
            ${h.tags.link_to(_(u"Back to autorization"), auth_url)}
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar">
                <i class="fa fa-info-circle fa-lg"></i> ${_(u"Please, feel all fields")}
            </div>
            <div class="ml20 tr">
                ${h.tags.submit('create', _(u"Create"), class_="button easyui-linkbutton")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
