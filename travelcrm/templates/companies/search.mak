<div class="dl40 easyui-dialog"
    title="${_(u'Find Company')}"
    data-options="
        modal:true,
        closed:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-search'
    ">
	${h.tags.title(_(u"name"), False, "name")}: ${h.tags.text("name", None, class_="text w10")}
</div>