<%-- 
    Document   : gugush
    Created on : May 5, 2017, 2:39:13 PM
    Author     : vahan
--%>
<%@ page import="java.util.*" %><%
        Enumeration eNames = request.getHeaderNames();
        while (eNames.hasMoreElements()) {
            String name = (String) eNames.nextElement();
            String value = normalize(request.getHeader(name));
    %><%= name%> = <%= value%>;
<%}
    %>

<%!
   private String normalize(String value)
   {
      StringBuffer sb = new StringBuffer();
      for (int i = 0; i < value.length(); i++) {
         char c = value.charAt(i);
         sb.append(c);
         if (c == ';')
            sb.append("<br>");
      }
      return sb.toString();
   }
%>