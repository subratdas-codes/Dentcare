<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<footer class="dc-footer pt-5 pb-4 mt-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4">
                <h5 class="text-white fw-bold mb-2"><i class="fa fa-tooth me-2"></i><c:out value="${site.siteName}" /></h5>
                <p class="small mb-2" style="color:#8fd8ce;"><c:out value="${site.siteTagline}" /></p>
                <p class="small mb-0" style="color:#b9c6d8;"><c:out value="${site.footerAbout}" /></p>
            </div>
            <div class="col-6 col-lg-2">
                <h6 class="text-white fw-semibold mb-3">Explore</h6>
                <a href="${pageContext.request.contextPath}/service" class="d-block small mb-2"><c:out value="${site.navServices}" /></a>
                <a href="${pageContext.request.contextPath}/team" class="d-block small mb-2"><c:out value="${site.navDoctors}" /></a>
                <a href="${pageContext.request.contextPath}/price" class="d-block small mb-2"><c:out value="${site.navPricing}" /></a>
                <a href="${pageContext.request.contextPath}/contact" class="d-block small"><c:out value="${site.navContact}" /></a>
            </div>
            <div class="col-6 col-lg-3">
                <h6 class="text-white fw-semibold mb-3">Clinic</h6>
                <p class="small mb-2" style="color:#b9c6d8;"><c:out value="${site.footerAddress}" /></p>
                <p class="small mb-2" style="color:#b9c6d8;"><c:out value="${site.footerPhone}" /></p>
                <p class="small mb-0" style="color:#b9c6d8;"><c:out value="${site.footerEmail}" /></p>
            </div>
            <div class="col-lg-3">
                <h6 class="text-white fw-semibold mb-3">Hours</h6>
                <p class="small mb-2" style="color:#b9c6d8;"><c:out value="${site.footerHours}" /></p>
                <sec:authorize access="hasRole('USER')">
                    <a href="${pageContext.request.contextPath}/book_appointment" class="btn btn-sm btn-light fw-semibold mt-2">
                        <c:out value="${site.bookButton}" />
                    </a>
                </sec:authorize>
            </div>
        </div>
        <hr style="border-color:rgba(255,255,255,.12);" class="my-4">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-2 small" style="color:#9fb0c5;">
            <span>&copy; <span id="dcFooterYear"></span> <c:out value="${site.footerCopyright}" /></span>
            <span>Patient portal • Secure payments • Confidential care</span>
        </div>
    </div>
</footer>
<style>
    .dc-footer { background: #0b172a; }
    .dc-footer a { color: #b9c6d8; text-decoration: none; }
    .dc-footer a:hover { color: #ffffff; }
</style>
<script>document.getElementById('dcFooterYear') && (document.getElementById('dcFooterYear').textContent = new Date().getFullYear());</script>
