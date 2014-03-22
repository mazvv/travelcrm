<%def name="searchbar(container)">
    <div class="searchbar" style="padding-top: 2px;">
        ${h.tags.title(_(u"Search"), False, "q")}
        ${h.tags.text("q", None, class_="text w25 searchbox", onkeyup="onkeyup_%s(event);" % container)}
        <span class="field-actions">
		    <span class="fa fa-search easyui-tooltip field-action _action" 
				  title="${_(u'search')}"
				  data-options="container: '#${container}', action: 'refresh'">
			</span>
		</span>
		<script type="text/javascript">
			function onkeyup_${container}(e){
			    if(e.keyCode == 13) refresh_container('#${container}');  
			}
	    </script>
	</div>
</%def>
