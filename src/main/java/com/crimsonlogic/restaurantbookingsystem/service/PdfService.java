package com.crimsonlogic.restaurantbookingsystem.service;

import com.crimsonlogic.restaurantbookingsystem.entity.Booking;
import com.crimsonlogic.restaurantbookingsystem.entity.Customer;
import com.crimsonlogic.restaurantbookingsystem.entity.Payment;

import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.property.TextAlignment;
import com.itextpdf.layout.property.UnitValue;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Service;

@Service
public class PdfService {

    public void generatePaymentReceipt(HttpServletResponse response, Payment payment, Booking booking) throws IOException {
        // Set the content type and disposition for the response
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=payment-receipt.pdf");

        // Create a PDF writer that writes to the response output stream
        PdfWriter pdfWriter = new PdfWriter(response.getOutputStream());

        // Initialize the PDF document
        PdfDocument pdfDocument = new PdfDocument(pdfWriter);
        Document document = new Document(pdfDocument);

        // Define date formatter
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd MMM yyyy");

        // Add receipt header
        document.add(new Paragraph("BookTables").setBold().setFontSize(20).setTextAlignment(TextAlignment.CENTER));
        document.add(new Paragraph("Receipt").setBold().setFontSize(16).setTextAlignment(TextAlignment.CENTER));
        document.add(new Paragraph(" ").setMarginBottom(10)); // Add a blank space for better formatting

        // Add line separator
        document.add(new Paragraph("------------------------------------------------------------").setTextAlignment(TextAlignment.CENTER));

        // Add customer details section
        Customer customer = payment.getCustomer();
        document.add(new Paragraph("Customer Details").setBold().setFontSize(12).setMarginBottom(8));
        document.add(new Paragraph("Name: " + customer.getCustomerFirstName() + " " + customer.getCustomerLastName()));
        document.add(new Paragraph("Email: " + customer.getCustomerEmail()));
        document.add(new Paragraph("Phone: " + customer.getCustomerPhoneNumber()));
        document.add(new Paragraph(" ")); // Add space

        // Add booking details
        document.add(new Paragraph("Booking Details").setBold().setFontSize(12).setMarginBottom(8));
        document.add(new Paragraph("Booking ID: " + booking.getBookingId()));
        document.add(new Paragraph("Restaurant: " + booking.getRestaurant().getRestaurantName()));
        document.add(new Paragraph("Booking Date: " + booking.getBookingDate().format(dateFormatter)));
        document.add(new Paragraph("Time Slot: " + booking.getTimeSlotStart() + " - " + booking.getTimeSlotEnd()));
        document.add(new Paragraph("Guests: " + booking.getGuestCount()));
        document.add(new Paragraph("Table No: " + booking.getTable().getTableNumber()));
        document.add(new Paragraph(" ")); // Add space

        // Add line separator
        document.add(new Paragraph("------------------------------------------------------------").setTextAlignment(TextAlignment.CENTER));

        // Add payment details as a table for better alignment
        document.add(new Paragraph("Payment Details").setBold().setFontSize(12).setMarginBottom(8));

        Table paymentTable = new Table(UnitValue.createPercentArray(new float[]{70, 30})).useAllAvailableWidth();
        paymentTable.addCell(new Paragraph("Subtotal").setBold());
        paymentTable.addCell(new Paragraph("$" + payment.getPaymentAmount()));
        // You can add discount logic here if needed
        paymentTable.addCell(new Paragraph("Discount").setBold());
        paymentTable.addCell(new Paragraph("$0.00")); // Assuming no discount

        // Final price (after discount if applicable)
        paymentTable.addCell(new Paragraph("Total Amount").setBold());
        paymentTable.addCell(new Paragraph("$" + payment.getPaymentAmount()).setBold());

        // Payment method and status
        paymentTable.addCell(new Paragraph("Payment Method").setBold());
        paymentTable.addCell(new Paragraph(payment.getPaymentMethod()));

        paymentTable.addCell(new Paragraph("Payment Status").setBold());
        paymentTable.addCell(new Paragraph(payment.getPaymentStatus().toString()));

        document.add(paymentTable.setMarginBottom(20));

        // Add line separator
        document.add(new Paragraph("------------------------------------------------------------").setTextAlignment(TextAlignment.CENTER));

        // Add footer section
        document.add(new Paragraph("Thank you for your booking!").setBold().setTextAlignment(TextAlignment.CENTER));
        document.add(new Paragraph("We look forward to serving you.").setTextAlignment(TextAlignment.CENTER));

        // Close the document
        document.close();
    }
}
