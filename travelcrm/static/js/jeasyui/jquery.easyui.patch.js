/**
 * The Patch for jQuery EasyUI 1.4.3
 */

(function($){

})(jQuery);

(function($){
	$.extend($.fn.filebox.methods, {
		clear: function(jq){
			return jq.each(function(){
				$(this).textbox('clear');
				var target = this;
				var state = $.data(target, 'filebox');
				var opts = state.options;
				var file = state.filebox.find('.textbox-value');
				var id = file.attr('id');
				opts.oldValue = '';
				file.remove();
				file = $('<input type="file" class="textbox-value">').appendTo(state.filebox);
				file.attr('id', id).attr('name', $(target).attr('textboxName')||'');
				file.change(function(){
					$(target).filebox('setText', this.value);
					opts.onChange.call(target, this.value, opts.oldValue);
					opts.oldValue = this.value;
				});
			});
		},
		reset: function(jq){
			return jq.each(function(){
				$(this).filebox('clear');
			});
		}
	});
})(jQuery);

(function($){
	var progress = $.messager.progress;
	$.messager.progress = function(options){
		return progress(typeof options == 'string' ? options : (options||{}));
	}
})(jQuery);

(function($){
	function setSelectionRange(target, start, end){
		if (target.setSelectionRange){
			target.setSelectionRange(start, end);
		} else if (target.createTextRange){
			var range = target.createTextRange();
			range.collapse();
			range.moveEnd('character', end);
			range.moveStart('character', start);
			range.select();
		}
	}
	function highlight(target, index){
		var opts = $.data(target, 'timespinner').options;
		if (index != undefined){
			opts.highlight = index;
		}
		var range = opts.selections[opts.highlight];
		if (range){
			var tb = $(target).timespinner('textbox');
			setSelectionRange(tb[0], range[0], range[1]);
			tb.focus();
		}
	}
	function doSpin(target, down){
		var opts = $.data(target, 'timespinner').options;
		var s = $(target).timespinner('getValue');
		var range = opts.selections[opts.highlight];
		var s1 = s.substring(0, range[0]);
		var s2 = s.substring(range[0], range[1]);
		var s3 = s.substring(range[1]);
		var v = s1 + ((parseInt(s2,10)||0) + opts.increment*(down?-1:1)) + s3;
		$(target).timespinner('setValue', v);
		highlight(target);
	}

	$.extend($.fn.timespinner.defaults, {
		spin: function(down){doSpin(this, down);},
		parser: function(s){
			var opts = $(this).timespinner('options');
			var date = parseD(s);
			if (date){
				var min = parseD(opts.min);
				var max = parseD(opts.max);
				if (min && min > date){date = min;}
				if (max && max < date){date = max;}
			}
			return date;
			
			function parseD(s){
				if (!s){return null;}
				var tt = s.split(opts.separator);
				return new Date(1900, 0, 0, parseInt(tt[0],10)||0, parseInt(tt[1],10)||0, parseInt(tt[2],10)||0);
			}
		}
	});
	$.extend($.fn.datetimespinner.defaults, {
		spin: function(down){doSpin(this, down);}
	});
})(jQuery);

(function($){
	function setSortable(target){
		var dg = $(target);
		var dc = dg.data('datagrid').dc;
		var header = dc.header1.add(dc.header2);
		var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
		fields.map(function(field){
			var col = dg.datagrid('getColumnOption', field);
			if (col.sortable){
				header.find('td[field="'+field+'"] .datagrid-cell').addClass('datagrid-sort');
			}
		});
	}
	var plugin = $.fn.datagrid;
	$.fn.datagrid = function(options, param){
		if (typeof options == 'string'){
			return plugin.call(this, options, param);
		} else {
			return this.each(function(){
				plugin.call($(this), options, param);
				setSortable(this);
			});
		}
	};
	$.fn.datagrid.defaults = plugin.defaults;
	$.fn.datagrid.methods = plugin.methods;
	$.fn.datagrid.parseOptions = plugin.parseOptions;
	$.fn.datagrid.parseData = plugin.parseData;
})(jQuery);

(function($){
	function getLevel(target, idValue){
		var opts = $.data(target, 'treegrid').options;
		var view = $(target).datagrid('getPanel').children('div.datagrid-view');
		var node = view.find('div.datagrid-body tr[node-id="' + idValue + '"]').children('td[field="' + opts.treeField + '"]');
		return node.find('span.tree-indent,span.tree-hit').length;
	}
	$.extend($.fn.treegrid.methods, {
		getLevel: function(jq, id){
			return getLevel(jq[0], id);
		}
	});
})(jQuery);

(function($){
	var alert = $.messager.alert;
	$.messager.alert = function(title, msg, icon, fn){
		var win = alert(title, msg, icon, fn);
		var opts = win.window('options');
		win.css('padding', 0);
		win.css('position', 'relative');
		win.find('.messager-button').css({
			position: 'absolute',
			left: 0,
			bottom: 0,
			width: '100%',
			padding: '10px 0'
		});
		win.wrapInner('<div class="messager-content" style="padding:10px;overflow:auto"></div>');
		var cc = win.find('.messager-content');
		var bb = win.find('.messager-button').insertAfter(cc);
		cc.css('margin-bottom', bb.outerHeight()+'px');
		win.window('options').onResize = function(){
			cc._outerHeight(win.height() - bb.outerHeight());
		};
		win.window('resize');
		win.find('.messager-button a:first').focus();
		return win;
	}
})(jQuery);

(function($){
	function setSelectedSize(container){
		var opts = $.data(container, 'tabs').options;
		var tab = $(container).tabs('getSelected');
		if (tab){
			var panels = $(container).children('div.tabs-panels');
			var width = opts.width=='auto' ? 'auto' : panels.width();
			var height = opts.height=='auto' ? 'auto' : panels.height();
			tab.panel('resize', {
				width: width,
				height: height
			});
		}
	}
	function setSize(container){
		var state = $.data(container, 'tabs');
		var opts = state.options;
		var cc = $(container);
		var header = cc.children('div.tabs-header');
		var panels = cc.children('div.tabs-panels');
		if (opts.tabPosition == 'left' || opts.tabPosition == 'right'){
			header.add(panels)._size('height', isNaN(parseInt(opts.height)) ? '' : cc.height());
		} else {
			panels._size('height', isNaN(parseInt(opts.height)) ? '' : (cc.height()-header.outerHeight()));
		}
	}
	function setDisabled(container){
		var state = $.data(container, 'tabs');
		for(var i=0; i<state.tabs.length; i++){
			var opts = state.tabs[i].panel('options');
			if (opts.disabled){
				$(container).tabs('disableTab', i);
			}
		}
	}

	var plugin = $.fn.tabs;
	$.fn.tabs = function(options, param){
		if (typeof options == 'string'){
			return plugin.call(this, options, param);
		} else {
			return this.each(function(){
				plugin.call($(this), options, param);
				setSize(this);
				setDisabled(this);
				var container = this;
				$(container).bind('_resize', function(e,force){
					if ($(this).hasClass('easyui-fluid') || force){
						setSize(container);
						setSelectedSize(container);
					}
					return false;
				});
			});
		}
	};
	$.fn.tabs.defaults = plugin.defaults;
	$.fn.tabs.methods = plugin.methods;
	$.fn.tabs.parseOptions = plugin.parseOptions;
	
    var resize = $.fn.tabs.methods.resize;
    $.extend($.fn.tabs.methods, {
        resize: function(jq, param){
            return jq.each(function(){
                resize.call($.fn.tabs.methods, $(this), param);
                setSize(this, param);
                setSelectedSize(this);
            });
        }
    })
})(jQuery);

(function($){
	$.extend($.fn.validatebox.defaults.rules, {
		remote: {
			validator: function(value, param){
				var target = this;
				if (target.result == undefined){
					target.result = true;
				}
				if (!target.validated){
					target.validated = true;
					var data = {};
					data[param[1]] = value;
					$.ajax({
						url: param[0],
						type: 'post',
						data: data,
						async: true,
						cache: false,
						success: function(data){
							if ($(target).parent().length){
								target.result = (data == 'true');
								$(target).validatebox('validate');								
							}
						},
						complete: function(){
							target.validated = false;
						}
					});
				}
				return target.result;
			},
			message: 'Please fix this field.'
		}
	})
})(jQuery);
