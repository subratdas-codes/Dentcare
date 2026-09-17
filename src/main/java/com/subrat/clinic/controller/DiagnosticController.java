package com.subrat.clinic.controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.PathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.URL;
import java.util.Enumeration;
import java.util.TreeMap;
import java.util.Map;

@Controller
public class DiagnosticController {

    @GetMapping("/debug/views")
    @ResponseBody
    public Map<String, Object> debug(HttpServletRequest request) {
        Map<String, Object> out = new TreeMap<>();
        ServletContext ctx = request.getServletContext();

        out.put("classpath.root", System.getProperty("java.class.path"));
        out.put("working.dir", System.getProperty("user.dir"));

        String[] paths = {"/WEB-INF/views/index.jsp", "/WEB-INF/views/login.jsp", "index.jsp"};
        for (String p : paths) {
            Map<String, Object> m = new TreeMap<>();
            try {
                URL u = ctx.getResource(p);
                m.put("servletContext.getResource", u == null ? "NULL" : u.toString());
                boolean real = ctx.getRealPath(p) != null;
                m.put("getRealPath", real ? ctx.getRealPath(p) : "NULL");
            } catch (Exception e) {
                m.put("servletContext.error", e.toString());
            }
            try {
                ClassPathResource c = new ClassPathResource((p.startsWith("/") ? p.substring(1) : p));
                m.put("ClassPathResource(" + p + ").exists", c.exists());
            } catch (Exception e) {
                m.put("classpath.error", e.toString());
            }
            out.put("check:" + p, m);
        }

        Map<String, Object> sv = new TreeMap<>();
        ctx.getServletRegistrations().forEach((name, reg) -> sv.put(name, String.join(",", reg.getMappings())));
        out.put("servletRegistrations", sv);

        Map<String, String> res = new TreeMap<>();
        try {
            ResourcePatternResolver rr = new PathMatchingResourcePatternResolver();
            Resource[] rsrcs = rr.getResources("classpath*:WEB-INF/views/*.jsp");
            for (Resource r : rsrcs) res.put(r.getFilename() == null ? "?" : r.getFilename(),
                    r instanceof PathResource ? "file" : r.getURL().toString());
        } catch (Exception e) {
            res.put("scan.error", e.toString());
        }
        out.put("classpath*:WEB-INF/views/*.jsp", res);

        return out;
    }
}