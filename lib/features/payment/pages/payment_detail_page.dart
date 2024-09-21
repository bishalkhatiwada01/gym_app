// payment_detail_page.dart

import 'package:flutter/material.dart';
import 'package:gymapp/common/functions/date.dart';
import 'package:gymapp/features/payment/model/payment_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PaymentDetailPage extends StatelessWidget {
  final PaymentModel payment;

  const PaymentDetailPage({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              await generateAndPrintPdf();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction ID: ${payment.transactionId}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Amount: Rs. ${payment.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Payment Type: ${payment.paymentType}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Payment Date: ${payment.paymentDate}',
                style: const TextStyle(fontSize: 18)),
            Text(
              "Posted ${timeAgo(DateTime.parse(payment.paymentDate))}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateAndPrintPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Payment Receipt',
                  style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
              pw.Text('Transaction ID: ${payment.transactionId}',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 8),
              pw.Text('Amount: Rs. ${payment.amount.toStringAsFixed(2)}',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 8),
              pw.Text(
                "Posted ${timeAgo(DateTime.parse(payment.paymentDate))}",
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Payment Type: ${payment.paymentType}',
                  style: const pw.TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );

    // Display the PDF preview and allow download
    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
    );
  }
}
