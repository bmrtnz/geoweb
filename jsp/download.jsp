<%@ page import="java.util.*,fr.bluewhale.session.*" 
%>
<%!
   
   public String pagetoLoad = null;
%>

<%
ApplicationController controller = (ApplicationController) session.getAttribute(ProxyPbConstants.PB_CONTROLLER);
pagetoLoad = controller.getSessionData().getPageName();
System.out.println("pagetoLoad = " + pagetoLoad);
%>

<html>
<body onload="top.document.getElementById('geoMessage').style.display='none';top.geoIframeFile.location.replace('/GEOWEB/<%=pagetoLoad%>');">
	
	TELECHARGEMENT EN COURS ...
	
	
</body>
</html>
