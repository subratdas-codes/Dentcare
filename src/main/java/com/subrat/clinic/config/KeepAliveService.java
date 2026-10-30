package com.subrat.clinic.config;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

/**
 * Keeps a free host awake by sending a small request to the public health URL
 * from inside the running application.
 *
 * <p>Render and Koyeb sleep free services after a period without inbound
 * traffic. A request to the service's own public URL still arrives through the
 * provider's router, so it counts as traffic and resets the idle timer. The
 * scheduler only runs while the application is awake, which is exactly when it
 * is needed: after a cold start the first request wakes the app, and these
 * pings stop it from falling asleep again.</p>
 *
 * <p>Disabled by default. Enable it only on hosts that sleep, by setting
 * {@code APP_KEEPALIVE_ENABLED=true}. The URL is taken from
 * {@code APP_KEEPALIVE_URL}, or from Render's automatic
 * {@code RENDER_EXTERNAL_URL}.</p>
 */
@Component
@ConditionalOnProperty(name = "app.keepalive.enabled", havingValue = "true")
public class KeepAliveService {

    private static final Logger log = LoggerFactory.getLogger(KeepAliveService.class);

    private final HttpClient client = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .followRedirects(HttpClient.Redirect.NORMAL)
            .build();

    private final String healthUrl;

    public KeepAliveService(@Value("${app.keepalive.url:}") String configuredUrl,
                            @Value("${RENDER_EXTERNAL_URL:}") String renderUrl) {
        this.healthUrl = healthUrl(StringUtils.hasText(configuredUrl) ? configuredUrl : renderUrl);
        if (healthUrl == null) {
            log.warn("Keep-alive is enabled but no URL is configured. "
                    + "Set APP_KEEPALIVE_URL to the public service URL.");
        } else {
            log.info("Keep-alive enabled; pinging {}", healthUrl);
        }
    }

    private static String healthUrl(String baseUrl) {
        if (!StringUtils.hasText(baseUrl)) {
            return null;
        }
        String base = baseUrl.trim();
        while (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        if (base.endsWith("/actuator/health")) {
            return base;
        }
        return base + "/actuator/health";
    }

    @Scheduled(initialDelayString = "${app.keepalive.initial-delay-ms:120000}",
            fixedDelayString = "${app.keepalive.interval-ms:600000}")
    public void ping() {
        if (healthUrl == null) {
            return;
        }
        try {
            HttpRequest request = HttpRequest.newBuilder(URI.create(healthUrl))
                    .timeout(Duration.ofSeconds(20))
                    .header("User-Agent", "DentCare-KeepAlive/1.0")
                    .GET()
                    .build();
            HttpResponse<Void> response = client.send(request, HttpResponse.BodyHandlers.discarding());
            if (response.statusCode() >= 200 && response.statusCode() < 400) {
                log.debug("Keep-alive ping succeeded with HTTP {}", response.statusCode());
            } else {
                log.warn("Keep-alive ping returned HTTP {}", response.statusCode());
            }
        } catch (Exception exception) {
            // A failed ping must never affect clinic traffic; the next run retries.
            log.warn("Keep-alive ping failed: {}", exception.getMessage());
        }
    }
}
