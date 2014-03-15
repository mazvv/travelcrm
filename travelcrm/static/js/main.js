/**
Rules:

Containers
----------
1. ID must begins with cont
**/

var containers = Array();

function add_container(obj){
	var container = obj.closest('._container');
	containers.push(container);
	return; 
}

function delete_container(){
	containers.pop();
	return;
}

function refresh_container(container){
	if(!container)
		container = containers.pop();
	var container_type = get_container_type(container)
	switch(container_type){
		case('datagrid'):
			container.find('.easyui-datagrid').datagrid('reload');
			break;
		case ('treegrid'):
			container.find('.easyui-treegrid').treegrid('reload');
		    break;
		case('combobox'):
		    container.find('.easyui-combobox').combobox('reload');
            break;
		case('combogrid'):
		    container.find('.easyui-combogrid').combogrid('reload');
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
	}
}

function set_field_error(form, input_name, error){
	var selector = "[data-name='" + input_name + "']";
	form.find(selector).tooltip({content: error, position: 'right'});
	form.find(selector).show();
}

function clear_form_errors(form){
    form.find('span.error').hide();
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
	                refresh_container(null);
                }
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

function datagrid_resource_status_format(value){
    var status = $('<span>').addClass('label');
    switch (value){
    	case 0:
    		return $('<div>').append(status.addClass('active').html('active')).html();
    	default:
    		return $('<div>').append(status.addClass('archive').html('archive')).html();
    }
}

function datagrid_resource_cell_styler(){
    return 'background-color:#ededed';
}

function open_dialog(url){
	$('#_dialog').load(url,
		function(data){
			$('#_dialog').html(data);
			$.parser.parse('#_dialog');
		}
	);
}

$(document).on("click", '._tab_open', function(event){
	event.preventDefault();
	var url = $(this).data('url');
	var title = $(this).data('title');
	var main_tabs = $('#_tabs_');
	if(main_tabs.tabs('exists', title)){
		main_tabs.tabs('select', title);
	} else {
		main_tabs.tabs('add', {
			title: title, 
			selected: true,
			closable: true,
			href: url,
		});
		var tab = main_tabs.tabs('getTab', title);
		var container = tab.find('._container');
		$('<div id="_dialog_' + main_tabs.tabs('getTabIndex', tab) + '_"></div>').appendTo(container);
	}
});

$(document).on("click", '._dialog_open', function(event){
    event.preventDefault();
    var url = $(this).data('url');
    var param_name = ($(this).data('param-name'))?$(this).data('param-name'):'id';
    var container = $(this).closest('._container');
    if($(this).hasClass('_with_row')){
    	var row = get_selected(container, get_container_type(container))
    	if(!row) {
    		open_dialog('/system_need_select_row');
    		return;
    	}
    	if(url.indexOf('?') == -1) url = url + '?' + param_name + '=' + row[param_name];
    	else url = url + '&' + param_name + '=' + row[param_name];
    } else if($(this).hasClass('_with_rows')){
    	var rows = get_checked(container, get_container_type(container))
		if(rows.length>0){
		    var params = Array();
		    $.each(rows, function(i, row){params.push(row[param_name]);});
	    	if(url.indexOf('?') == -1) url = url + '?' + param_name + '=' + params.join();
	    	else url = url + '&' + param_name + '=' + params.join();
		} else {
		    open_dialog('/system_need_select_rows');
	    	    return;
		}
    }
    open_dialog(url);
    add_container($(this));
});

function get_selected(container, container_type){
	if(container_type == 'datagrid')
		return container.find('.easyui-datagrid').datagrid('getSelected');
	if(container_type == 'treegrid')
		return container.find('.easyui-treegrid').treegrid('getSelected');
	return null;
}

function get_checked(container, container_type){
    switch(container_type){
		case('datagrid'):
		    return container.find('.easyui-datagrid').datagrid('getChecked');
		case('treegrid'):
		    return container.find('.easyui-treegrid').treegrid('getChecked');
		default:
		    return null;
	}
	return null;
}

function get_current_container(){
    if(containers.length > 0)
	return containers[containers.length - 1];
    return null;
}

function get_container_type(container){
	var container_type = null;
	if(container.find('.easyui-datagrid').length > 0) container_type = 'datagrid';
	else if(container.find('.easyui-treegrid').length > 0) container_type = 'treegrid';
	else if(container.find('.easyui-combobox').length > 0) container_type = 'combobox';
	else if(container.find('.easyui-combotree').length > 0) container_type = 'combotree';
	else if(container.find('.easyui-combogrid').length > 0) container_type = 'combogrid';
	return container_type;
}

$(document).on("click", '._action', function(event){
    event.preventDefault();
    var url = $(this).data('url');
    var container = $(this).closest('._container');
    var params = {}
    if($(this).hasClass('_with_row')){
    	var row = get_selected(container, get_container_type(container))
    	if(!row) {
    		open_dialog('/system_need_select_row');
    		return;
    	}
    	params['id'] = row.id
    } else if($(this).hasClass('_with_rows')){
    	var rows = get_checked(container, get_container_type(container))
		if(rows.length > 0){
		    var ids = Array();
		    $.each(rows, function(i, row){ids.push(row.id);});
			params['id'] = ids.join();
		} else {
		    open_dialog('/system_need_select_rows');
	    	    return;
		}
    }
    add_container(container);
    $.post(url, params).always(function(){refresh_container(null);});
});

$(document).on('keyup', '._searchbox', function(e){
    if(e.keyCode == 13){
    	var container = $(this).closest('._container');
    	refresh_container(container);
    	return;
    }
});

$(document).on('click', '.searchbar ._runsearch', function(e){
	var container = $(this).closest('._container');
	refresh_container(container);
	return;
});

$(document).on('click', '._clearfield', function(event){
	event.preventDefault();
	var container = $(this).closest('._container');
	var container_type = get_container_type(container);
	if(container_type == 'combobox'){
		container.find('.easyui-combobox').combobox('clear');
	}
});

$(document).on('click', '._accumulator', function(event){
	event.preventDefault();
	var container = $(this).closest('._container');
	var container_type = get_container_type(container);
	if(container_type == 'combobox'){
		var name = container.find('.easyui-combobox').data('name');
		var val = container.find('.easyui-combobox').combobox('getValue');
		if(val){
			var inputs = container.find('input[name=' + name + '][value=' + val + ']');
			if(!inputs.length){
				var input = $('<input type="hidden">');
				input.attr('name', name);
				input.val(val);
				container.append(input);
				var parent_container = container.parent().closest('._container');
				refresh_container(parent_container);
			}
			container.find('.easyui-combobox').combobox('clear');
		}
	}
});
