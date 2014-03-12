<%def name="searchbar()">
    <div class="searchbar">
        ${h.tags.title(_(u"Search"), False, "q")}
        ${h.tags.text("q", None, class_="text w25 searchbox _searchbox")}
        <span class="field-actions">
		    <span class="fa fa-search easyui-tooltip field-action _runsearch" title="${_(u'search')}"></span>
		</span>
	</div>
</%def>
