<!DOCTYPE html>
<html>
    <head>        
        <meta http-equiv="Content-Type" content="easyui-textbox/html; charset=utf-8" />
        <title>
        	% if title:
        		${title}
        	% else:
        		${_(u"TravelCRM Report")}
        	% endif
        </title>
        <link rel="icon" type="image/ico" href="${request.static_url('travelcrm:static/css/img/favicon.ico')}"/>
        ${h.tags.stylesheet_link(
            request.static_url('travelcrm:static/css/main.css')
        )}
        <%block name="css"></%block>
        <%block name="js"></%block>
    </head>
    <body>
    	<div class="main">
    		${self.body()}
    	</div>
    </body>
</html>
