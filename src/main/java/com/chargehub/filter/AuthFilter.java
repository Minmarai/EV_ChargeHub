package com.chargehub.filter;

import jakarta.servlet.*;import jakarta.servlet.annotation.WebFilter;import jakarta.servlet.http.*;import java.io.IOException;

@WebFilter({"/user/*","/station-manager/*","/admin/*"})
/**
 * Author: Minma Rai IIC
 */
public class AuthFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request=(HttpServletRequest)req; HttpServletResponse response=(HttpServletResponse)res;
        HttpSession session=request.getSession(false);
        if(session==null || session.getAttribute("userId")==null){ response.sendRedirect(request.getContextPath()+"/login"); return; }
        String role=(String)session.getAttribute("role"); String path=request.getRequestURI();
        if(path.contains("/admin/") && !"admin".equals(role)){ response.sendRedirect(request.getContextPath()+"/error"); return; }
        if(path.contains("/station-manager/") && !"station_manager".equals(role)){ response.sendRedirect(request.getContextPath()+"/error"); return; }
        if(path.contains("/user/") && !"user".equals(role)){ response.sendRedirect(request.getContextPath()+"/error"); return; }
        chain.doFilter(req,res);
    }
}
