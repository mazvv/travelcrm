/**
 * The Patch for jQuery EasyUI 1.4
 */
(function($){
	var plugin = $.fn._size;
	$.fn._size = function(options, parent){
		if (typeof options != 'string'){
			return this.each(function(){
				parent = parent || $(this).parent();
				if (parent.length){
					plugin.call($(this), options, parent);
				}
			});
		} else if (options == 'unfit'){
			return this.each(function(){
				var p = $(this).parent();
				if (p.length){
					plugin.call($(this), options, parent);
				}
			});
		} else {
			return plugin.call(this, options, parent);
		}
	}
})(jQuery);

(function($){
	$.map(['validatebox','textbox','filebox','searchbox',
			'combo','combobox','combogrid','combotree',
			'datebox','datetimebox','numberbox',
			'spinner','numberspinner','timespinner','datetimespinner'], function(plugin){
		if ($.fn[plugin]){
			if ($.fn[plugin].defaults.events){
				$.fn[plugin].defaults.events.click = function(e){
					if (!$(e.data.target).is(':focus')){
						$(e.data.target).trigger('focus');
					}
				};
			}
		}
	});
	$.fn.combogrid.defaults.height = 22;
})(jQuery);

(function($){
	function setSize(target, param){
		var opts = $.data(target, 'linkbutton').options;
		if (param){
			$.extend(opts, param);
		}
		if (opts.width || opts.height || opts.fit){
			var btn = $(target);
			var parent = btn.parent();
			var isVisible = btn.is(':visible');
			if (!isVisible){
				var spacer = $('<div style="display:none"></div>').insertBefore(target);
				var style = {
					position: btn.css('position'),
					display: btn.css('display'),
					left: btn.css('left')
				};
				btn.appendTo('body');
				btn.css({
					position:'absolute',
					display:'inline-block',
					left:-20000
				});
			}
			btn._size(opts, parent);
			var left = btn.find('.l-btn-left');
			left.css('margin-top', 0);
			left.css('margin-top', parseInt((btn.height()-left.height())/2)+'px');
			if (!isVisible){
				btn.insertAfter(spacer);
				btn.css(style);
				spacer.remove();
			}
		}
	}

	var plugin = $.fn.linkbutton;
	$.fn.linkbutton = function(options, param){
		if (typeof options != 'string'){
			return this.each(function(){
				plugin.call($(this), options, param);
				setSize(this);
			});
		} else {
			return plugin.call(this, options, param);
		}
	};
	$.fn.linkbutton.methods = plugin.methods;
	$.fn.linkbutton.defaults = plugin.defaults;
	$.fn.linkbutton.parseOptions = plugin.parseOptions;
	$.extend($.fn.linkbutton.methods, {
		resize: function(jq, param){
			return jq.each(function(){
				setSize(this, param);
			})
		}
	})
})(jQuery);

(function($){
	var plugin = $.fn.dialog;
	$.fn.dialog = function(options, param){
		var result = plugin.call(this, options, param);
		if (typeof options != 'string'){
			this.each(function(){
				var opts = $(this).panel('options');
				if (isNaN(parseInt(opts.height))){
					$(this).css('height', '');
				}
				var onResize = opts.onResize;
				opts.onResize = function(w, h){
					onResize.call(this, w, h);
					if (isNaN(parseInt(opts.height))){
						$(this).css('height', '');
					}
					var shadow = $.data(this, 'window').shadow;
					if (shadow){
						var cc = $(this).panel('panel');
						shadow.css({
							width: cc._outerWidth(),
							height: cc._outerHeight()
						});
					}
				}
				if (opts.closed){
					var pp = $(this).panel('panel');
					pp.show();
					$(this).panel('resize');
					pp.hide();
				}
			});
		}
		return result;
	};
	$.fn.dialog.methods = plugin.methods;
	$.fn.dialog.parseOptions = plugin.parseOptions;
	$.fn.dialog.defaults = plugin.defaults;
})(jQuery);

(function($){
	function createTab(container, pp, options) {
		var state = $.data(container, 'tabs');
		options = options || {};
		
		// create panel
		pp.panel({
			border: false,
			noheader: true,
			closed: true,
			doSize: false,
			iconCls: (options.icon ? options.icon : undefined)
		});
		
		var opts = pp.panel('options');
		$.extend(opts, options, {
			onLoad: function(){
				if (options.onLoad){
					options.onLoad.call(this, arguments);
				}
				state.options.onLoad.call(container, $(this));
			}
		});
		
		var tabs = $(container).children('div.tabs-header').find('ul.tabs');
		
		opts.tab = $('<li></li>').appendTo(tabs);	// set the tab object in panel options
		opts.tab.append(
				'<a href="javascript:void(0)" class="tabs-inner">' +
				'<span class="tabs-title"></span>' +
				'<span class="tabs-icon"></span>' +
				'</a>'
		);
		
		$(container).tabs('update', {
			tab: pp,
			options: opts
		});
	}
	function addTab(container, options) {
		var opts = $.data(container, 'tabs').options;
		var tabs = $.data(container, 'tabs').tabs;
		if (options.selected == undefined) options.selected = true;
		
		var pp = $('<div></div>').appendTo($(container).children('div.tabs-panels'));
		tabs.push(pp);
		createTab(container, pp, options);
		
		opts.onAdd.call(container, options.title, tabs.length-1);
		
		$(container).tabs('resize');
		if (options.selected){
			$(container).tabs('select', tabs.length-1);
		}
	}
	$.extend($.fn.tabs.methods, {
		add: function(jq, options){
			return jq.each(function(){
				addTab(this, options);
			})
		}
	})
})(jQuery);

(function($){
	$.extend($.fn.menubutton.methods, {
		enable: function(jq){
			return jq.each(function(){
				$(this).data('menubutton').options.disabled = false;
				$(this).linkbutton('enable');
			});
		}
	});
})(jQuery);

(function($){
	$.fn.datagrid.defaults.loader = function(param, success, error){
		var opts = $(this).datagrid('options');
		if (!opts.url) return false;
		param.page = param.page || 1;
		$.ajax({
			type: opts.method,
			url: opts.url,
			data: param,
			dataType: 'json',
			success: function(data){
				success(data);
			},
			error: function(){
				error.apply(this, arguments);
			}
		});
	};
})(jQuery);

(function($){
	$.fn.numberbox.defaults.filter = function(e){
		var opts = $(this).numberbox('options');
		var s = $(this).numberbox('getText');
		if (e.which == 45){	//-
			return (s.indexOf('-') == -1 ? true : false);
		}
		var c = String.fromCharCode(e.which);
		if (c == opts.decimalSeparator){
			return (s.indexOf(c) == -1 ? true : false);
		} else if (c == opts.groupSeparator){
			return true;
		} else if ((e.which >= 48 && e.which <= 57 && e.ctrlKey == false && e.shiftKey == false) || e.which == 0 || e.which == 8) {
			return true;
		} else if (e.ctrlKey == true && (e.which == 99 || e.which == 118)) {
			return true;
		} else {
			return false;
		}
	}
})(jQuery);
