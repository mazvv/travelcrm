<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${_(u'TravelCRM - login')}</title>

    <!-- Global stylesheets -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,300,100,500,700,900" rel="stylesheet" type="text/css">

    ${h.tags.stylesheet_link(
        request.static_url('travelcrm:static/assets/css/icons/icomoon/styles.css'),
        request.static_url('travelcrm:static/assets/css/bootstrap.css'),
        request.static_url('travelcrm:static/assets/css/core.css'),
        request.static_url('travelcrm:static/assets/css/components.css'),
        request.static_url('travelcrm:static/assets/css/colors.css'),
    )}
    <%block name="css"></%block>
    <!-- /global stylesheets -->
    
    <!-- Core JS files -->
    ${h.tags.javascript_link(
        request.static_url('travelcrm:static/assets/js/plugins/loaders/pace.min.js'), 
        request.static_url('travelcrm:static/assets/js/core/libraries/jquery.min.js'),
        request.static_url('travelcrm:static/assets/js/core/libraries/bootstrap.min.js'),
        request.static_url('travelcrm:static/assets/js/plugins/loaders/blockui.min.js'),
    )}
    <!-- /core JS files -->

    <!-- Theme JS files -->
    ${h.tags.javascript_link(
        request.static_url('travelcrm:static/assets/js/core/app.js'), 
    )}
    <%block name="js"></%block>
    <!-- /theme JS files -->
</head>

<body>
  
  <!-- Main navbar -->
  <div class="navbar navbar-inverse">
    <div class="navbar-header">
      <a class="navbar-brand" href="index.html"><img src="assets/images/logo_light.png" alt=""></a>
      
      <ul class="nav navbar-nav pull-right visible-xs-block">
	<li><a data-toggle="collapse" data-target="#navbar-mobile"><i class="icon-tree5"></i></a></li>
      </ul>
    </div>

    <div class="navbar-collapse collapse" id="navbar-mobile">
      <ul class="nav navbar-nav navbar-right">
	<li>
	  <a href="login_simple.html#">
	    <i class="icon-display4"></i> <span class="visible-xs-inline-block position-right"> Go to website</span>
	  </a>
	</li>
	
	<li>
	  <a href="login_simple.html#">
	    <i class="icon-user-tie"></i> <span class="visible-xs-inline-block position-right"> Contact admin</span>
	  </a>
	</li>
	
	<li class="dropdown">
	  <a class="dropdown-toggle" data-toggle="dropdown">
	    <i class="icon-cog3"></i>
	    <span class="visible-xs-inline-block position-right"> Options</span>
	  </a>
	</li>
      </ul>
    </div>
  </div>
  <!-- /main navbar -->

  <!-- Page container -->
  <div class="page-container login-container">
    
    <!-- Page content -->
    <div class="page-content">
      
      <!-- Main content -->
      <div class="content-wrapper">
	
	<!-- Content area -->
	<div class="content">
	  
	  <!-- Simple login form -->
	  <form action="index.html">
	    <div class="panel panel-body login-form">
	      <div class="text-center">
		<div class="icon-object border-slate-300 text-slate-300"><i class="icon-reading"></i></div>
		<h5 class="content-group">Login to your account <small class="display-block">Enter your credentials below</small></h5>
	      </div>
	      
	      <div class="form-group has-feedback has-feedback-left">
		<input type="text" class="form-control" placeholder="Username">
		<div class="form-control-feedback">
		  <i class="icon-user text-muted"></i>
		</div>
	      </div>
	      
	      <div class="form-group has-feedback has-feedback-left">
		<input type="text" class="form-control" placeholder="Password">
		<div class="form-control-feedback">
		  <i class="icon-lock2 text-muted"></i>
		</div>
	      </div>
	      
	      <div class="form-group">
		<button type="submit" class="btn btn-primary btn-block">Sign in <i class="icon-circle-right2 position-right"></i></button>
	      </div>
	      
	      <div class="text-center">
		<a href="login_password_recover.html">Forgot password?</a>
	      </div>
	    </div>
	  </form>
	  <!-- /simple login form -->
	  
	  
	  <!-- Footer -->
	  <div class="footer text-muted">
	    &copy; 2015. <a href="login_simple.html#">Limitless Web App Kit</a> by <a href="http://themeforest.net/user/Kopyov" target="_blank">Eugene Kopyov</a>
	  </div>
	  <!-- /footer -->
	  
	</div>
	<!-- /content area -->
	
      </div>
      <!-- /main content -->
      
    </div>
    <!-- /page content -->
    
  </div>
  <!-- /page container -->

</body>
</html>
