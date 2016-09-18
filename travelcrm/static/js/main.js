var containers = Array();

function add_container(options){
	if(options.container){
		containers.push(options.container)
	}
	return; 
}

function get_container(){
	if(containers.length > 0){
		return containers[containers.length - 1]
	}
	return null;
}

function delete_container(){
	containers.pop();
	return;
}

function refresh_container(container){
	if(!container)
		container = containers.pop();
	var container = $(container);
	var container_type = get_container_type($(container));
	switch(container_type){
		case('datagrid'):
			container.datagrid('reload');
			break;
		case ('treegrid'):
			container.treegrid('reload');
		    break;
		case('combobox'):
		    container.combobox('reload');
            break;
		case('combogrid'):
			var grid = container.combogrid('grid');
		    grid.datagrid('reload');
            break;
	}

}

function is_undefined(val){
	return typeof(val) == 'undefined';
}

function is_form_errors(errors){
	if(!is_undefined(errors))
		return true;
	return false;
}

function show_form_errors(form, errors){
	clear_form_errors(form);
	if(is_form_errors(errors)){
	    $.each(errors, function(input_name, error) {
	    	set_field_error(form, input_name, error);
	    });
	    set_tabs_errors(form);
	}
}

function set_field_error(form, input_name, error){
	var selector = "[data-name='" + input_name + "']";
	if(form.find(selector).hasClass('as-text'))
		form.find(selector + ' span').html(error);
	else
		form.find(selector).tooltip({content: error, position: 'right'});
	form.find(selector).show();
}

function set_tabs_errors(form){
    var tabs = form.find('.easyui-tabs');
    if(tabs.length){
        tabs = tabs.tabs('tabs');
        $.each(tabs, function(i, tab){
            $.each(tab.panel().find('span.error'), function(j, error){
                if(
                    $(error).css('display') != 'none'
                    && $(error).css('visibility') != 'hidden'
                ){
                    tab.panel('options').tab.find('.tabs-inner').addClass('error');
                }
            });
        });
    }
}


function clear_form_errors(form){
    form.find('span.error').hide();
    form.find('.tabs-inner.error').removeClass('error');
}

$(document).on('click', 'form._ajax input[type=reset]',
    function(event){
        event.preventDefault();
        $(this).closest('.easyui-dialog').dialog('destroy');
        delete_container();
    }
);

$(document).on('click', 'form._ajax input[type=submit]',
    function(event){
        event.preventDefault();
        submit($(this).closest('form._ajax'));
    }
);

function submit(form){
    form.form('submit', {
        url: form.attr('action'),
        success:function(data){
            var json = $.parseJSON(data);
            if(!is_undefined(json.error_message)){
            	show_form_errors(form, json.errors);
                show_status_bar_info(form.find('.status-bar'), 'error', json.error_message);
            } else {
            	if(!is_undefined(json.redirect)) {
            		window.location.href = json.redirect;
            		return;
            	}
                show_status_bar_info(form.find('.status-bar'), 'success', json.success_message);
                if(is_undefined(json.close) || json.close == true){
	                form.closest('.easyui-dialog').dialog('destroy');
                }
                if(!is_undefined(json.response)){
                    save_container_response(json.response);
                }
                refresh_container(null);
            }
        },
        onSubmit: function(){
            show_status_bar_info(form.find('.status-bar'), 'loading', 'loading...');
        },
        onLoadSuccess: function(){
            return false;
        },
        onLoadError: function(){
            show_status_bar_info(form.find('.status-bar'), 'error', 'Oops... Problems during request');
        }
    });
}

function save_container_response(data){
	var container = get_container();
	$(container).data('response', data);
	return;
}

function show_status_bar_info(status_bar, info_type, message){
	var icon = $('<i>');
	if(info_type == 'error'){
		status_bar.addClass('error');
		icon.attr('class', 'fa fa-exclamation-circle fa-lg');
	}
	if(info_type == 'info'){
		status_bar.removeClass('error');
		icon.attr('class', 'fa fa-info-circle fa-lg');
	}
	if(info_type == 'success'){
		status_bar.removeClass('error');
		icon.attr('class', 'fa fa-check-circle fa-lg');
	}
	if(info_type == 'loading'){
		status_bar.removeClass('error');
		icon.attr('class', 'fa fa-spinner fa-spin fa-lg');
	}
	status_bar.html(icon).append('&nbsp;' + message);
}

function datagrid_resource_cell_styler(){
    return 'background-color:#ededed';
}

$(document).on("click", '._action', function(event){
    event.preventDefault();
    action(this);
});

function action(obj){
	var options = $.parser.parseOptions(obj);
	do_action(options);
}

function do_action(options){
	switch(options.action){
		case('tab_open'):
		    tab_open(options);
		    break;
		case('dialog_open'):
		    dialog_open(options);
		    break;
		case('blank_open'):
		    blank_open(options);
		    break;
		case('refresh'):
		    add_container(options);
		    refresh_container(null);
		    break;
		case('container_action'):
		    container_action(options);
		    break;
		case('container_picker'):
		    container_picker(options);
		    break;
	}
}

function container_action(options){
	add_container(options);
	var url = get_action_url(options);
	$.post(url).always(function(){refresh_container(null);});
}

function container_picker(options){
	add_container(options);
	var container = $(get_container());
	row = get_selected(container);
	if(!row) {
	    _dialog_open('/system_need_select_row');
	    return;
    }
	container.closest('.easyui-dialog').dialog('destroy');
	delete_container();
	save_container_response(row.id);
}

function tab_open(options){
	var url = options.url.trim();
	if(!url || url == '/') return;
	var title = options.title;
	var main_tabs = $('#_tabs_');
	if(main_tabs.tabs('exists', title)){
		main_tabs.tabs('select', title);
	} else {
		main_tabs.tabs('add', {
			title: title,
			selected: true,
			closable: true,
			href: url,
			tools:[{
	            iconCls:'icon-mini-refresh',
	            handler:function(){
	            	var li = $(this).closest('li');
	            	var ul = $(this).closest('ul');
	            	var idx = ul.find('li').index(li);
	                var tab = $('#_tabs_').tabs('getTab', idx);
	                tab.panel('refresh');
	            }
	        }]			
		});
	}
}

function dialog_open(options){
	add_container(options);
	var url = get_action_url(options);
	_dialog_open(url);
}

function blank_open(options){
	add_container(options);
	var url = get_action_url(options);
	window.open(url , '_tab');
	delete_container();
}

function get_action_url(options){
	var container = $(get_container());
	var url = options.url;
    var param_name = options.param?options.param:'id';
	switch(options.property){
		case('with_row'):
		    var row = get_selected(container);
    	    if(!row) {
    		    _dialog_open('/system_need_select_row');
    		    return;
    	    }
    	    if(url.indexOf('?') == -1) url = url + '?' + param_name + '=' + row[param_name];
    	    else url = url + '&' + param_name + '=' + row[param_name];
		    break;
		case('with_rows'):
		    var rows = get_checked(container);
	 	    if(!rows.length){
			    _dialog_open('/system_need_select_rows');
				return;
		    }
		    var params = Array();
		    $.each(rows, function(i, row){params.push(row[param_name]);});
	    	if(url.indexOf('?') == -1) url = url + '?' + param_name + '=' + params.join();
	    	else url = url + '&' + param_name + '=' + params.join();
		    break;
	}
	var params_str = options.params_str?options.params_str:null;
	if(params_str){
		if(url.indexOf('?') == -1) url = url + '?' + params_str;
		else url = url + '&' + params_str;
	}
	return url;
}

function get_params_str(options){
	params_str = options.params_str?options.params_str:null;
	if ($.isFunction(params_str)) {
		params_str = params_str();
	}
	console.log(params.str);
	return params_str;
}

function get_selected(container){
	var container_type = get_container_type(container);
	var row = null;
	switch(container_type){
		case('datagrid'):
		    row = container.datagrid('getSelected');
		    break;
		case('treegrid'):
		    row = container.treegrid('getSelected');
		    break;
		case('combogrid'):
			var grid = container.combogrid('grid');
		    row = grid.datagrid('getSelected');
		    break;
	}
	return row;
}

function get_checked(container){
	var container_type = get_container_type(container);
	var rows = null;
	switch(container_type){
		case('datagrid'):
		    rows = container.datagrid('getChecked');
		    break;
		case('treegrid'):
		    rows = container.treegrid('getChecked');
		    break;
	}
	return rows;
}

function clear_checked(container){
	var container_type = get_container_type(container);
	switch(container_type){
		case('datagrid'):
		    container.datagrid('clearChecked');
		    break;
		case('treegrid'):
		    container.treegrid('clearChecked');
		    break;
	}
}

function get_container_type(container){
	var container_type = null;
	if(container.hasClass('easyui-datagrid')) container_type = 'datagrid';
	else if(container.hasClass('easyui-treegrid')) container_type = 'treegrid';
	else if(container.hasClass('easyui-combobox')) container_type = 'combobox';
	else if(container.hasClass('easyui-combotree')) container_type = 'combotree';
	else if(container.hasClass('easyui-combogrid')) container_type = 'combogrid';
	return container_type;
}

function _dialog_open(url){
	$('#_progress_').dialog('open');
	$('#_dialog_').load(url,
		function(data){
			data = disable_inputs(data);
			$('#_dialog_').html(data);
			$('#_progress_').dialog('close');
			$.parser.parse('#_dialog_');
		}
	);
}

function is_int(val){
	var intRegex = /^\d+$/;
	if(intRegex.test(val)) return true;
	return false;
}

function format_contact_type(value){
	var span = $('<span class="fa">');
	switch(value){
		case('phone'):
		    span.addClass('fa-phone');
		    break;
		case('email'):
		    span.addClass('fa-envelope');
		    break; 
		case('skype'):
		    span.addClass('fa-skype');
		    break; 
	}
	span = $('<div>').append(span);
	return span.html();
}

function clear_inputs(selector){
	$(selector).find('.easyui-datebox').datebox('clear');
	$(selector).find('.easyui-datetimebox').datetimebox('clear');
	$(selector).find('.easyui-combobox').combobox('clear');
	$(selector).find('.easyui-combogrid').combogrid('clear');
	$(selector).find('.easyui-combotree').combotree('clear');
	$(selector).find('.easyui-numberbox').numberbox('clear');
}

function add_datebox_clear_btn(selector){
	var datebox_buttons = $.extend([], $.fn.datebox.defaults.buttons);
	datebox_buttons.splice(1, 0, {
		text: 'Clear',
		handler: function(target){
			$(target).datebox('clear');
		}
	});
	$(selector).datebox({
		buttons: datebox_buttons
	});	
}

function add_datetimebox_clear_btn(selector){
	var datetimebox_buttons = $.extend([], $.fn.datetimebox.defaults.buttons);
	datetimebox_buttons.splice(1, 0, {
		text: 'Clear',
		handler: function(target){
			$(target).datetimebox('clear');
		}
	});
	$(selector).datetimebox({
		buttons: datetimebox_buttons
	});	
}


function get_higher_zindex(){
	var highest = -999;
	$("*").each(function() {
	    var current = parseInt($(this).css("z-index"), 10);
	    if(current && highest < current) highest = current;
	});
	return highest;
}

function getKeyByValue(obj, value) {
	var key = null;
	for (var name in obj) {
		if (obj.hasOwnProperty(name) && obj[name] === value) {
			key = name;
			break;
		}
	}
	return key;
}

function payment_indicator(percent){
	var text = $('<span>').html(percent + '%');
	if(percent > 100) percent = 100;
	var el = $('<div>').css('width', percent + '%').html('&nbsp;');
	el = $('<div>').addClass('payment-indicator tc')
		.css('width', '100%').append(text).append(el);
	el = $('<div>').append(el);
	return el.html();
}

$.extend($.fn.textbox.defaults.inputEvents, {
	keyup: function(e){
		var t = $(e.data.target);
		t.textbox('setValue', t.textbox('getText'));
	}
});

function disable_inputs(data){
	var form = $(data).find('form');
	if(form.hasClass('readonly')){
		var d = $('<div>').html(data);
                d = disable_obj_inputs(d);
		return d.html();
	}
	return data;
}

function disable_obj_inputs(obj){
    obj.find(":input").attr("disabled", true);
    obj.find("[type=reset]").attr("disabled", false);
    obj.find("[type=submit]").addClass("disable");
    return obj;
}


function dt_formatter(date, format){
	return Date.format(date, format);
}


function dt_parser(s, format){
	if(!s) return new Date();
	return Date.parseFormatted(s, format);
}


/** helpers **/
function get_icon(cls){
	return $('<span/>').addClass('fa ' + cls);
}

function status_formatter(status){
	if(status){
		var span = $('<span/>').html(status.title);
		span.addClass('status-label ' + status.key);
		return $('<div/>').append(span).html();
	}
}

function account_item_type_formatter(item_type){
	if(item_type){
		var span = $('<span/>').addClass('fa mr05');
		var title = $('<span/>').html(item_type.title);
		switch(item_type.key){
			case 'revenue':
				span.addClass('fa-long-arrow-right');
				break;
			case 'expenses':
				span.addClass('fa-long-arrow-left');
				break;
			default:
				span.addClass('fa-arrows-h');
				break;
		}
		return $('<div/>').append(span).append(title).html();
	}
}


function format_download_link(url){
	var span = $('<span/>').addClass('fa fa-download');
	var a = $('<a target="_blank"/>').attr('href', url).append(span);
	return $('<div/>').append(a).html();
}


function subscriber_cell_formatter(val, row){
    var span = $('<span/>').addClass('fa');
    if(val) span.addClass('fa-thumb-tack');
    return $('<div/>').append(span).html();
}
