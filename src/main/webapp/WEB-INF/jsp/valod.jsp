<%-- 
    Document   : valod
    Created on : Nov 6, 2018, 12:09:07 PM
    Author     : vahan
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<form:form method="POST" action="?${_csrf.parameterName}=${_csrf.token}" enctype="multipart/form-data">
    <table>
        <tr>
            <td>Select a file to upload</td>
            <td><input type="file" name="file" /></td>
        </tr>
        <tr>
            <td><input type="submit" value="Submit" /></td>
        </tr>
    </table>
</form:form>            