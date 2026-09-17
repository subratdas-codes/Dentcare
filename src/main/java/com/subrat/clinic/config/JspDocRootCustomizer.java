package com.subrat.clinic.config;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Component;

@Component
public class JspDocRootCustomizer implements WebServerFactoryCustomizer<TomcatServletWebServerFactory> {

    @Override
    public void customize(TomcatServletWebServerFactory factory) {
        try {
            File docRoot = extractWebappToDisk();
            if (docRoot != null) {
                factory.setDocumentRoot(docRoot);
            }
        } catch (IOException e) {
            throw new IllegalStateException("Failed to extract JSP views for embedded Tomcat", e);
        }
    }

    private File extractWebappToDisk() throws IOException {
        Path tmp = Files.createTempDirectory("dentcare-webapp");
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath*:WEB-INF/views/**");
        int count = 0;
        for (Resource res : resources) {
            if (!res.isReadable()) {
                continue;
            }
            String url = res.getURI().toString();
            int idx = url.indexOf("WEB-INF");
            if (idx < 0) {
                continue;
            }
            String relative = url.substring(idx);
            Path target = tmp.resolve(relative);
            Files.createDirectories(target.getParent());
            try (InputStream in = res.getInputStream()) {
                Files.copy(in, target);
            }
            count++;
        }
        return count == 0 ? null : tmp.toFile();
    }
}