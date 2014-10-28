<!DOCTYPE html>
<!--[if IE 8]><html class="ie8"><![endif]-->
<!--[if IE 9]><html class="ie9"><![endif]-->
<!--[if gt IE 9]><!-->
<html>
<!--<![endif]-->
  <head>
    <%@ page import="javax.servlet.http.HttpUtils,java.util.Enumeration" %>
    <%@ page import="java.lang.management.*" %>
    <%@ page import="java.util.*" %>
    <title>JBoss EAP - Powered by OpenShift</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="../dist/img/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../dist/img/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../dist/img/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../dist/img/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="../dist/img/apple-touch-icon-57-precomposed.png">
    <link href="../dist/css/patternfly.css" rel="stylesheet" media="screen, print">
    <style>
      #proxy-status .container {
      	box-sizing: border-box;
      	width: 850px;
      	height: 450px;
      	padding: 20px 15px 15px 15px;
      	margin: 15px auto 30px auto;
      	border: 1px solid #ddd;
      	background: #fff;
      	background: linear-gradient(#f6f6f6 0, #fff 50px);
      	background: -o-linear-gradient(#f6f6f6 0, #fff 50px);
      	background: -ms-linear-gradient(#f6f6f6 0, #fff 50px);
      	background: -moz-linear-gradient(#f6f6f6 0, #fff 50px);
      	background: -webkit-linear-gradient(#f6f6f6 0, #fff 50px);
      	box-shadow: 0 3px 10px rgba(0,0,0,0.15);
      	-o-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
      	-ms-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
      	-moz-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
      	-webkit-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
      }
      
      #proxy-status .placeholder {
      	width: 100%;
      	height: 100%;
      	font-size: 14px;
      	line-height: 1.2em;
      }
      
      #proxy-status .legend table {
      	border-spacing: 5px;
      }
      
      #proxy-status .control-group {
      	padding: 0px 15px;
      }
      
      #proxy-status #hostname.failed {
      	color: red;
      }
      
      #proxy-status button#toggle {
      	width: 100px;
      	height: 35px;
      }
      
      #proxy-status button {
      	color: white;
      	font-weight: bold;
      }
      
      #proxy-status button.on {
      	background-color: green;
      }
      
      #proxy-status button.off {
      	background-color: red;
      }
    </style>
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="../components/html5shiv/dist/html5shiv.min.js"></script>
    <script src="../components/respond/dest/respond.min.js"></script>
    <![endif]-->
    <!-- IE8 requires jQuery and Bootstrap JS to load in head to prevent rendering bugs -->
    <!-- IE8 requires jQuery v1.x -->
    <script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="../components/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../dist/js/patternfly.min.js"></script>
    <script src="../components/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="../components/haproxy-status.js"></script>
    <script>
      // Initialize Boostrap-select
      $(document).ready(function() {
        $('.selectpicker').selectpicker();
      });
    </script>
    <!-- haproxy stuff -->
    <script language="javascript" type="text/javascript" src="http://www.flotcharts.org/flot/jquery.flot.js"></script>
    <script language="javascript" type="text/javascript" src="http://www.flotcharts.org/flot/jquery.flot.time.js"></script>
  </head>
  <body>
    <nav class="navbar navbar-default navbar-pf" role="navigation">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse-1">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="/">
          <img src="../dist/img/brand.svg" alt="PatternFly" />
        </a>
      </div>
      <div class="collapse navbar-collapse navbar-collapse-1">
        <ul class="nav navbar-nav navbar-primary">
          <li class="active">
            <a href="#">Home</a>
          </li>
        </ul>
      </div>
    </nav>
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-12">
          <h1>Welcome to an OpenShift Application!</h1>
          <p>The purpose of this application is to demonstrate several interesting features about OpenShift. We hope you enjoy it!</p>
        </div>
      </div>
      <div class="row">
        <div class="col-md-6 col-md-offset-3">
          <h2>Application Information</h2>
          <% String variable = System.getenv("OPENSHIFT_APP_UUID"); %>
          <table class="table table-striped table-bordered table-hover">
            <thead>
              <tr>
                <th>Env Var</th>
                <th>Value</th>
              <tr>
            </thead>
            <tbody>
              <tr>
                <td>Instance UUID</td>
                <td><%= System.getenv("OPENSHIFT_GEAR_UUID") %></td>
              </tr>
              <tr>
                <td>Instance Internal IP</td>
                <td><%= System.getenv("OPENSHIFT_JBOSSEAP_IP") %></td>
              </tr>
              <tr>
                <td>Instance Internal Port</td>
                <td><%= System.getenv("OPENSHIFT_JBOSSEAP_HTTP_PORT") %></td>
              </tr>
              <tr>
                <td>Instance Memory (Allowed [MB])</td>
                <td><%= System.getenv("OPENSHIFT_GEAR_MEMORY_MB") %></td>
              </tr>
              <tr>
                <td>Instance Memory (Used [MB])</td>
                <% int mb = 1024*1024; %>
                <td><%= (Runtime.getRuntime().totalMemory()) / mb %></td>
              </tr>
              <tr>
                <td>Node (header)</td>
                <td><%= request.getHeader("x-forwarded-server") %></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="row" id="proxy-status">
        <div class="col-md-6 col-md-offset-3">
          <h2>HAProxy Status</h2>
	  <h3 id="hostname"></h3>
	  <div id="content">
	    <div class="container">
	    	<div id="placeholder" class="placeholder"></div>
	    </div>
	    <div class="control-group">
	      <span>
	        <button id="toggle" class="on" value="on">ON</button>
	      </span>
	      <span style="float: right">
	        Refresh rate:
	        <select id="updateInterval" style="margin: 5px">
	          <option value="1">1</option>
	          <option value="2" selected>2</option>
	          <option value="5">5</option>
	          <option value="10">10</option>
	          <option value="20">20</option>
	          <option value="30">30</option>
	          <option value="60">60</option>
	          <option value="120">120</option>
	        </select>
	        seconds
	      </span>
            </div>
	  </div>
        </div>
      </div>
    </div>
  </body>
</html>
