<%inherit file="travelcrm:templates/auth/_layout.mako"/>
<div class="dl40 easyui-dialog"
    title="${_(u'Company creation')}"
    data-options="
        modal:true,
        closable: false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
        <div class="p1">
            <div class="tc">
                <i class="fa fa-info-circle fa-lg"></i> 
                ${_(u"Creation task run soon. Waiting for Email with registration data")}
            </div>
            <div class="form-field mb05 mt05 tc">
                <i class="fa fa-long-arrow-left"></i>
                ${h.tags.link_to(_(u"Back to autorization"), auth_url)}
            </div>
        </div>
</div>
