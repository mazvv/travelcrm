<%inherit file="travelcrm:templates/auth/_layout.mak"/>
<div class="easyui-dialog dl30" title="${_(u'Forgot password')}"
    data-options="
    	closable:false,
    	minimizable:false,
    	maximizable:false,
    	collapsible:false,
    	draggable:true,
    	resizable:false,
    	iconCls:'fa fa-envelope'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="form-field">
            <div class="dl10">
            	${h.tags.title(_(u"email"), True, "email")}
            </div>
            <div class="ml10 tr">
            	${h.tags.text("email", None, class_="easyui-textbox w15")}
            </div>
        </div>
        <div class="form-field">
        	${h.tags.link_to(_(u"Back to autorization"), auth_url)}
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar">
                <i class="fa fa-info-circle fa-lg"></i> ${_(u"Please, enter your email")}
            </div>
            <div class="ml20 tr">
            	${h.tags.submit('send', _(u"Send"), class_="button")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
