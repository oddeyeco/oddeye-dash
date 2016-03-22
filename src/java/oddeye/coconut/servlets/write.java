/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package oddeye.coconut.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.Collections;
//import sun.org.mozilla.javascript.internal.json.JsonParser;

import kafka.producer.KeyedMessage;

/**
 *
 * @author vahan
 */
public class write extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uid = request.getParameter("UUID");
        String msg = "";
        int idx = Arrays.binarySearch(AppConfiguration.getUsers(), uid, Collections.reverseOrder());
        if (idx > -1) {
            msg = request.getParameter("data");
        }
        if (msg != "") {

//            JsonParser parser = new JsonParser( );

//            JsonObject mainObject = parser.parse(msg).getAsJsonObject();
            msg = msg + "\n";
            String topic = AppConfiguration.getBrokerTopic();
            KeyedMessage<String, String> data = new KeyedMessage<String, String>(topic, msg);
            AppConfiguration.getProducer().send(data);
        }

        response.setContentType(
                "text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet write Data</title>");
            out.println("</head>");
            out.println("<body>");

            out.println("<h1>Servlet write at " + request.getContextPath() + "</h1>");
            out.println("<h1>Servlet write at " + uid + idx + msg + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
