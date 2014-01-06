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
function refresh_container(){
	var container = containers.pop();
	try{
	    container.find('.easyui-datagrid').datagrid('reload');
    	container.find('.easyui-treegrid').treegrid('reload');
	} 
	finally {
		return;
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
	    	set_field_error_status(form, input_name);
	    	set_field_error_tooltip(form, input_name, error);
	    });
	}
}

function set_field_error_status(form, input_name){
	if(form.find('[name=' + input_name + ']').length > 0)
		form.find('[name=' + input_name + ']').closest('.form-field').addClass('error');
	else if(form.find('[comboname=' + input_name + ']').length > 0)
		form.find('[comboname=' + input_name + ']').closest('.form-field').addClass('error');
}

function set_field_error_tooltip(form, input_name, error){
	var obj = null;
	if(form.find('[name=' + input_name + ']').length > 0)
		obj = form.find('[name=' + input_name + ']');
	else if(form.find('[comboname=' + input_name + ']').length > 0)
		obj = form.find('[comboname=' + input_name + ']');
	if (obj)
		form.find('[name=' + input_name + ']').closest('.form-field').tooltip(
	    	{
	    		content: error, 
	    		position: 'right',
	    		onShow: function(){
	    	        $(this).tooltip('tip').css({
	    	            backgroundColor: '#000',
	    	            borderColor: '#000',
	    	            color: '#fff'
	    	        });
	    	    }
	    	}
	    );
}

function clear_form_errors(form){
    form.find('.error').tooltip('destroy');
    form.find('.error').removeClass('error');
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
	                refresh_container();
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
    	case 1:
    		return $('<div>').append(status.addClass('disabled').html('disabled')).html();
    	case 2:
    		return $('<div>').append(status.addClass('draft').html('draft')).html();
    	default:
    		return $('<div>').append(status.addClass('error').html('error')).html();
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
    var container = $(this).closest('._container');
    if($(this).hasClass('_with_row')){
    	var row = get_selected(container, get_container_type(container))
    	if(!row) {
    		open_dialog('/system_need_select_row');
    		return;
    	}
    	url = url + '?rid=' + row.rid;
    } else if($(this).hasClass('_with_rows')){
    	var rows = get_checked(container, get_container_type(container))
		if(rows.length>0){
		    var rids = Array();
		    $.each(rows, function(i, row){rids.push(row.rid);});
			url = url + '?rid=' + rids.join();
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
	if(container_type == 'datagrid')
		return container.find('.easyui-datagrid').datagrid('getChecked');
	if(container_type == 'treegrid')
		return container.find('.easyui-treegrid').treegrid('getChecked');
	return null;
}

function get_container_type(container){
	var container_type = null;
	if(container.find('.easyui-datagrid').length > 0) container_type = 'datagrid';
	else if(container.find('.easyui-treegrid').length > 0) container_type = 'treegrid';
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
    	params['rid'] = row.rid
    } else if($(this).hasClass('_with_rows')){
    	var rows = get_checked(container, get_container_type(container))
		if(rows.length>0){
		    var rids = Array();
		    $.each(rows, function(i, row){rids.push(row.rid);});
			params['rid'] = rids.join();
		} else {
		    open_dialog('/system_need_select_rows');
	    	    return;
		}
    }
    add_container(container);
    $.post(url, params).always(function(){refresh_container();});
});

function dateformatter(date){  
    var y = date.getFullYear();  
    var m = date.getMonth()+1;  
    var d = date.getDate();  
    return (d<10?('0'+d):d)+'.'+(m<10?('0'+m):m)+'.'+y;  
}

function dateparser(s){  
    if (!s) return new Date();  
    var ss = s.split('.');  
    var y = parseInt(ss[2],10);  
    var m = parseInt(ss[1],10);  
    var d = parseInt(ss[0],10);  
    if (!isNaN(y) && !isNaN(m) && !isNaN(d)){  
        return new Date(y,m-1,d);  
    } else {  
        return new Date();  
    }  
}

$.fn.datebox.defaults.formatter = dateformatter;
$.fn.datebox.defaults.parser = dateparser;
