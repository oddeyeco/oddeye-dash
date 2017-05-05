<%-- 
    Document   : gugush
    Created on : May 5, 2017, 2:39:13 PM
    Author     : vahan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<table border="1" cellpadding="4" cellspacing="0">
    <%
        Enumeration eNames = request.getHeaderNames();
        while (eNames.hasMoreElements()) {
            String name = (String) eNames.nextElement();
            String value = normalize(request.getHeader(name));
    %>
    <tr><td><%= name%></td><td><%= value%></td></tr>
    <%
        }
    %>
</table>
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