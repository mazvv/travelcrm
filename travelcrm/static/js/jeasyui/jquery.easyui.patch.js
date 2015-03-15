(function($){
	var renderEmptyRow = $.fn.datagrid.defaults.view.renderEmptyRow;
	$.extend($.fn.datagrid.defaults.view, {
		renderEmptyRow:function(target){
			var fields = $(target).datagrid('getColumnFields');
			for(var i=0; i<fields.length; i++){
				var col = $(target).datagrid('getColumnOption', fields[i]);
				col.formatter1 = col.formatter;
				col.styler1 = col.styler;
				col.formatter = col.styler = undefined;
			}
			renderEmptyRow.call(this, target);
			for(var i=0; i<fields.length; i++){
				var col = $(target).datagrid('getColumnOption', fields[i]);
				col.formatter = col.formatter1;
				col.styler = col.styler1;
				col.formatter1 = col.styler1 = undefined;
			}
		}
	})
})(jQuery);
