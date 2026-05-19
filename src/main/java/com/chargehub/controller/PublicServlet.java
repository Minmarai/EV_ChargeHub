package com.chargehub.controller;

import com.chargehub.dao.ContactDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet handling all publicly accessible pages of the ChargeHub application.
 *
 * <p>Mapped to the following URL patterns:
 * <ul>
 *   <li>{@code /home} — Landing page displaying all active charging stations</li>
 *   <li>{@code /about} — Static about page</li>
 *   <li>{@code /contact} — Contact form page (GET to display, POST to submit)</li>
 *   <li>{@code /error} — Generic error page</li>
 * </ul>
 * </p>
 *
 * <p>All views are resolved under {@code /WEB-INF/views/public/} and forwarded
 * via {@link #forward(HttpServletRequest, HttpServletResponse, String)}.</p>
 *
 * <p>No authentication or session checks are performed in this servlet —
 * all mapped routes are intentionally accessible without login.</p>
 */
@WebServlet({"/home", "/about", "/contact", "/error"})
public class PublicServlet extends HttpServlet {

 /**
  * Handles HTTP GET requests for all public-facing pages.
  *
  * <p>Routing is determined by the servlet path obtained from
  * {@link HttpServletRequest#getServletPath()}:</p>
  * <ul>
  *   <li>{@code /} or {@code /home} — Fetches all stations via
  *       {@link StationDAO#findAll()} and sets them as a request attribute
  *       ({@code "stations"}) before forwarding to {@code public/home.jsp}</li>
  *   <li>{@code /about} — Forwards directly to {@code public/about.jsp}
  *       with no additional request attributes</li>
  *   <li>{@code /contact} — Forwards directly to {@code public/contact.jsp}
  *       with no additional request attributes</li>
  *   <li>Any unrecognised path — Forwards to {@code public/error.jsp}</li>
  * </ul>
  *
  * @param request  the {@link HttpServletRequest} containing the servlet path
  *                 used for route resolution
  * @param response the {@link HttpServletResponse} used for forwarding
  * @throws ServletException if the request dispatcher encounters an error during forwarding
  * @throws IOException      if an I/O error occurs during forwarding
  */
 @Override
 protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
  String path = request.getServletPath();
  if (path.equals("/") || path.equals("/home")) {
   request.setAttribute("stations", new StationDAO().findAll());
   forward(request, response, "public/home.jsp");
  } else if (path.equals("/about")) {
   forward(request, response, "public/about.jsp");
  } else if (path.equals("/contact")) {
   forward(request, response, "public/contact.jsp");
  } else {
   forward(request, response, "public/error.jsp");
  }
 }

 /**
  * Handles HTTP POST requests submitted from the contact form.
  *
  * <p>Reads the following parameters from the request body:
  * <ul>
  *   <li>{@code name} — the sender's full name</li>
  *   <li>{@code email} — the sender's email address</li>
  *   <li>{@code subject} — the subject line of the message</li>
  *   <li>{@code message} — the body of the contact message</li>
  * </ul>
  * </p>
  *
  * <p>The message is persisted via {@link ContactDAO#add(String, String, String, String)}.
  * Depending on the outcome, one of the following request attributes is set
  * before forwarding back to {@code public/contact.jsp}:
  * <ul>
  *   <li>{@code "success"} — set to {@code "Message sent successfully."} on success</li>
  *   <li>{@code "error"} — set to {@code "Failed to send message."} on failure</li>
  * </ul>
  * </p>
  *
  * <p>The page is always re-forwarded to {@code public/contact.jsp} regardless
  * of outcome, allowing the view to display the appropriate feedback message
  * to the user.</p>
  *
  * @param request  the {@link HttpServletRequest} containing the {@code name},
  *                 {@code email}, {@code subject}, and {@code message} form parameters
  * @param response the {@link HttpServletResponse} used for forwarding
  * @throws ServletException if the request dispatcher encounters an error during forwarding
  * @throws IOException      if an I/O error occurs during forwarding
  */
 @Override
 protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
  boolean ok = new ContactDAO().add(
          request.getParameter("name"),
          request.getParameter("email"),
          request.getParameter("subject"),
          request.getParameter("message")
  );
  request.setAttribute(ok ? "success" : "error",
          ok ? "Message sent successfully." : "Failed to send message.");
  forward(request, response, "public/contact.jsp");
 }

 /**
  * Forwards the current request and response to a view under {@code /WEB-INF/views/}.
  *
  * <p>The {@code page} parameter is appended to the base path
  * {@code /WEB-INF/views/} to construct the full dispatcher path.
  * For example, passing {@code "public/home.jsp"} resolves to
  * {@code /WEB-INF/views/public/home.jsp}.</p>
  *
  * <p>Views placed under {@code /WEB-INF/} are protected from direct
  * browser access and can only be reached via a server-side forward,
  * ensuring all requests pass through this servlet first.</p>
  *
  * @param request  the current {@link HttpServletRequest}
  * @param response the current {@link HttpServletResponse}
  * @param page     the relative view path under {@code /WEB-INF/views/}
  *                 (e.g. {@code "public/home.jsp"})
  * @throws ServletException if the request dispatcher encounters an error during forwarding
  * @throws IOException      if an I/O error occurs during forwarding
  */
 private void forward(HttpServletRequest request, HttpServletResponse response, String page)
         throws ServletException, IOException {
  request.getRequestDispatcher("/WEB-INF/views/" + page).forward(request, response);
 }
}