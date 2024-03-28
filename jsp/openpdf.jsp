<%
String file = "/" + request.getParameter("file");
System.out.println("file = " + file);
%>
<jsp:forward page="<%= file %>" />