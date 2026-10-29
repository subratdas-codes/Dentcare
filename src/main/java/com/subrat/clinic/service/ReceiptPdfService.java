package com.subrat.clinic.service;

import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfWriter;
import com.subrat.clinic.model.Appointment;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import org.springframework.stereotype.Service;

/**
 * Builds a self-contained, DentCare-branded PDF receipt. Everything is drawn
 * with PDF primitives, so no external image or font file is required on the
 * server. The rupee sign is rendered as "Rs." because the built-in PDF fonts
 * do not contain the glyph.
 */
@Service
public class ReceiptPdfService {

    private static final Color NAVY = new Color(11, 23, 42);
    private static final Color TEAL = new Color(15, 118, 110);
    private static final Color TEAL_DARK = new Color(11, 93, 87);
    private static final Color MINT = new Color(235, 248, 245);
    private static final Color INK = new Color(23, 43, 77);
    private static final Color MUTED = new Color(82, 99, 122);
    private static final Color LINE = new Color(223, 232, 241);
    private static final Color WHITE = Color.WHITE;
    private static final Color AMBER = new Color(146, 64, 14);

    private final SiteSettingService siteSettingService;

    public ReceiptPdfService(SiteSettingService siteSettingService) {
        this.siteSettingService = siteSettingService;
    }

    public byte[] generate(Appointment appointment) {
        try (ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Document document = new Document(PageSize.A4, 0, 0, 0, 0);
            PdfWriter writer = PdfWriter.getInstance(document, out);
            document.open();

            PdfContentByte cb = writer.getDirectContent();
            BaseFont regular = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, BaseFont.NOT_EMBEDDED);
            BaseFont bold = BaseFont.createFont(BaseFont.HELVETICA_BOLD, BaseFont.WINANSI, BaseFont.NOT_EMBEDDED);

            String siteName = setting("siteName", "DentCare");
            String tagline = setting("siteTagline", "Gentle dentistry, modern care");
            String address = setting("footerAddress", "Patia, Bhubaneswar, Odisha 751024");
            String phone = setting("footerPhone", "+91 94371 23456");
            String email = setting("footerEmail", "dentcare.support@gmail.com");
            String hours = setting("footerHours", "Mon-Sat: 9:00 AM - 7:00 PM");
            String title = setting("receiptTitle", "Payment Receipt");
            String note = setting("receiptNote", "This is a computer-generated receipt. Please keep it for your records.");
            String footer = setting("receiptFooter", "Thank you for choosing DentCare.");

            drawHeader(cb, regular, bold, siteName, tagline, title, appointment);
            drawDetails(cb, regular, bold, appointment);
            drawPaymentTable(cb, regular, bold, appointment);
            drawTotal(cb, regular, bold, appointment);
            drawNote(cb, regular, note);
            drawFooter(cb, regular, bold, siteName, address, phone, email, hours, footer,
                    appointment.getPaymentReference());

            document.close();
            return out.toByteArray();
        } catch (Exception exception) {
            throw new IllegalStateException("Unable to create the receipt PDF", exception);
        }
    }

    private void drawHeader(PdfContentByte cb, BaseFont regular, BaseFont bold,
                            String siteName, String tagline, String title, Appointment appointment) {
        cb.setColorFill(NAVY);
        cb.rectangle(0, 690, 595, 152);
        cb.fill();
        cb.setColorFill(TEAL);
        cb.rectangle(0, 684, 595, 6);
        cb.fill();

        // Logo mark: white disc with a teal tooth silhouette.
        cb.setColorFill(WHITE);
        cb.circle(57, 779, 23);
        cb.fill();
        drawTooth(cb, 57, 779, TEAL);

        text(cb, bold, safe(siteName), 22, WHITE, 92, 790, Align.LEFT);
        text(cb, regular, safe(tagline), 8.5f, new Color(184, 236, 228), 92, 774, Align.LEFT);

        text(cb, bold, safe(title).toUpperCase(Locale.ROOT), 14, WHITE, 555, 800, Align.RIGHT);
        text(cb, regular, "REFERENCE", 7, new Color(184, 236, 228), 555, 785, Align.RIGHT);
        text(cb, bold, safe(appointment.getPaymentReference()), 10, WHITE, 555, 771, Align.RIGHT);
    }

    private void drawDetails(PdfContentByte cb, BaseFont regular, BaseFont bold, Appointment appointment) {
        roundedBox(cb, 40, 500, 515, 140, 10, new Color(249, 251, 253), LINE);
        text(cb, bold, "PATIENT & APPOINTMENT", 9, TEAL_DARK, 58, 618, Align.LEFT);

        column(cb, regular, bold, 58, 586, "Patient", appointment.getPatientName());
        column(cb, regular, bold, 315, 586, "Doctor", appointment.getDoctorName());
        column(cb, regular, bold, 58, 554, "Visit type",
                appointment.getAppointmentType() == null ? "-" : appointment.getAppointmentType().getLabel());
        column(cb, regular, bold, 315, 554, "Service", appointment.getService());

        String when = appointment.getAppointmentDate() == null ? "-"
                : appointment.getAppointmentDate().format(DateTimeFormatter.ofPattern("dd MMM yyyy"))
                + (appointment.getAppointmentTime() == null ? ""
                : " at " + appointment.getAppointmentTime().format(DateTimeFormatter.ofPattern("hh:mm a")));
        column(cb, regular, bold, 58, 522, "Appointment", when);
        column(cb, regular, bold, 315, 522, "Booking status",
                appointment.getStatus() == null ? "-" : appointment.getStatus().getLabel());
    }

    private void drawPaymentTable(PdfContentByte cb, BaseFont regular, BaseFont bold, Appointment appointment) {
        roundedBox(cb, 40, 350, 515, 132, 10, WHITE, LINE);
        text(cb, bold, "PAYMENT DETAILS", 9, TEAL_DARK, 58, 462, Align.LEFT);

        String method = appointment.getPaymentMethod() == null
                ? "-" : appointment.getPaymentMethod().getLabel();
        String detail = appointment.getPaymentDetail();
        String paidOn = appointment.getPaidAtDisplay();

        paymentRow(cb, regular, 58, 438, 448, "Payment method", method);
        paymentRow(cb, regular, 58, 412, 448, "Payment detail", detail == null || detail.isBlank() ? "-" : detail);
        paymentRow(cb, regular, 58, 386, 448, "Payment status",
                appointment.getPaymentStatus() == null ? "-" : appointment.getPaymentStatus().getLabel());
        paymentRow(cb, regular, 58, 360, 448, "Paid on", paidOn == null ? "-" : paidOn);
    }

    private void drawTotal(PdfContentByte cb, BaseFont regular, BaseFont bold, Appointment appointment) {
        roundedBox(cb, 40, 288, 515, 48, 10, MINT, new Color(198, 232, 224));
        text(cb, bold, "TOTAL AMOUNT", 9, TEAL_DARK, 58, 316, Align.LEFT);
        text(cb, regular, "All amounts are in Indian Rupees (INR)", 8, MUTED, 58, 301, Align.LEFT);
        text(cb, bold, money(appointment.getAmount()), 18, TEAL_DARK, 537, 305, Align.RIGHT);
    }

    private void drawNote(PdfContentByte cb, BaseFont regular, String note) {
        roundedBox(cb, 40, 218, 515, 54, 8, new Color(255, 252, 242), new Color(241, 223, 182));
        text(cb, regular, "NOTE", 7.5f, AMBER, 56, 254, Align.LEFT);
        text(cb, regular, truncate(safe(note), 125), 8.5f, new Color(92, 61, 0), 56, 238, Align.LEFT);
    }

    private void drawFooter(PdfContentByte cb, BaseFont regular, BaseFont bold, String siteName,
                            String address, String phone, String email, String hours, String footer,
                            String reference) {
        line(cb, 40, 190, 555, 190, LINE);
        text(cb, bold, safe(siteName), 10, INK, 40, 172, Align.LEFT);
        text(cb, regular, truncate(safe(address), 80), 8, MUTED, 40, 158, Align.LEFT);
        text(cb, regular, truncate(safe(phone) + "  |  " + safe(email), 95), 8, MUTED, 40, 144, Align.LEFT);
        text(cb, regular, truncate(safe(hours), 80), 8, MUTED, 40, 130, Align.LEFT);
        text(cb, regular, truncate(safe(footer), 110), 8, TEAL_DARK, 555, 172, Align.RIGHT);
        text(cb, regular, "This receipt was generated by " + safe(siteName) + ".", 7.5f, MUTED, 555, 158, Align.RIGHT);

        cb.setColorFill(new Color(246, 249, 252));
        cb.rectangle(0, 0, 595, 92);
        cb.fill();
        text(cb, bold, "DentCare", 9, TEAL_DARK, 40, 46, Align.LEFT);
        text(cb, regular, "Gentle dentistry, modern care", 8, MUTED, 40, 32, Align.LEFT);
        text(cb, regular, "Receipt " + safe(reference), 8, MUTED, 555, 46, Align.RIGHT);
        text(cb, regular, "Page 1 of 1", 8, MUTED, 555, 32, Align.RIGHT);
    }

    private void column(PdfContentByte cb, BaseFont regular, BaseFont bold,
                        float x, float y, String label, String value) {
        text(cb, regular, label.toUpperCase(Locale.ROOT), 7.5f, MUTED, x, y, Align.LEFT);
        text(cb, bold, truncate(safe(value), 36), 10, INK, x, y - 16, Align.LEFT);
    }

    private void paymentRow(PdfContentByte cb, BaseFont regular, float x, float y, float right,
                            String label, String value) {
        text(cb, regular, label, 8.5f, MUTED, x, y, Align.LEFT);
        text(cb, regular, truncate(safe(value), 52), 8.5f, INK, right, y, Align.RIGHT);
        line(cb, x, y - 8, right, y - 8, new Color(238, 243, 248));
    }

    private void drawTooth(PdfContentByte cb, float cx, float cy, Color color) {
        cb.setColorFill(color);
        cb.moveTo(cx - 7, cy + 9);
        cb.curveTo(cx - 11, cy + 5, cx - 9, cy - 2, cx - 7, cy - 6);
        cb.curveTo(cx - 6, cy - 9, cx - 3, cy - 9, cx - 2, cy - 6);
        cb.lineTo(cx, cy - 2);
        cb.lineTo(cx + 2, cy - 6);
        cb.curveTo(cx + 3, cy - 9, cx + 6, cy - 9, cx + 7, cy - 6);
        cb.curveTo(cx + 9, cy - 2, cx + 11, cy + 5, cx + 7, cy + 9);
        cb.curveTo(cx + 4, cy + 12, cx + 2, cy + 10, cx, cy + 7);
        cb.curveTo(cx - 2, cy + 10, cx - 4, cy + 12, cx - 7, cy + 9);
        cb.closePath();
        cb.fill();
    }

    private void roundedBox(PdfContentByte cb, float x, float y, float w, float h,
                            float radius, Color fill, Color stroke) {
        cb.setColorFill(fill);
        cb.setColorStroke(stroke);
        cb.setLineWidth(0.8f);
        cb.roundRectangle(x, y, w, h, radius);
        cb.fillStroke();
    }

    private void line(PdfContentByte cb, float x1, float y1, float x2, float y2, Color color) {
        cb.setColorStroke(color);
        cb.setLineWidth(0.8f);
        cb.moveTo(x1, y1);
        cb.lineTo(x2, y2);
        cb.stroke();
    }

    private void text(PdfContentByte cb, BaseFont font, String value, float size,
                      Color color, float x, float y, Align align) {
        String safe = safe(value);
        cb.beginText();
        cb.setFontAndSize(font, size);
        cb.setColorFill(color);
        float width = font.getWidthPoint(safe, size);
        float drawX = align == Align.RIGHT ? x - width : align == Align.CENTER ? x - (width / 2) : x;
        cb.setTextMatrix(drawX, y);
        cb.showText(safe);
        cb.endText();
    }

    private String money(BigDecimal value) {
        NumberFormat formatter = NumberFormat.getInstance(new Locale("en", "IN"));
        formatter.setMinimumFractionDigits(2);
        formatter.setMaximumFractionDigits(2);
        return "Rs. " + formatter.format(value == null ? BigDecimal.ZERO : value);
    }

    private String setting(String key, String fallback) {
        String value = siteSettingService.get(key);
        return value == null || value.isBlank() ? fallback : value;
    }

    private String truncate(String value, int max) {
        if (value == null) {
            return "-";
        }
        return value.length() <= max ? value : value.substring(0, Math.max(0, max - 3)) + "...";
    }

    private String safe(String value) {
        if (value == null || value.isBlank()) {
            return "-";
        }
        return value
                .replace("₹", "Rs. ")
                .replace("—", "-")
                .replace("–", "-")
                .replace("’", "'")
                .replace("‘", "'")
                .replace("“", "\"")
                .replace("”", "\"");
    }

    private enum Align {
        LEFT, CENTER, RIGHT
    }
}
