import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/data/models/merchant_order_item_model.dart';
import 'package:chupachap/features/orders/data/models/order_model.dart';

class ShareButton extends StatelessWidget {
  final CompletedOrder order;

  const ShareButton({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.background.withOpacity(.4)
            : AppColors.backgroundDark.withOpacity(.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.share_outlined,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => _shareOrder(context),
        ),
      ),
    );
  }

  void _shareOrder(BuildContext context) {
    // Show receipt preview in a dialog
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // This is the widget we'll use for preview only
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'AlkoHut',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'ORDER RECEIPT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  ReceiptWidget(order: order),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      _generateAndSharePdf(context);
                    },
                    child: const Text('Share'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateAndSharePdf(BuildContext context) async {
    try {
      // Generate the PDF
      final pdf = pw.Document();

      // Use PdfPageFormat.a5 for a smaller receipt-style format
      // You can also use custom sizes: PdfPageFormat(width, height)
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a5,
          build: (pw.Context context) {
            return _buildPdfContent();
          },
        ),
      );

      // Save the PDF to a temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/receipt.pdf');
      await file.writeAsBytes(await pdf.save());

      // Close the dialog
      Navigator.pop(context);

      // Share the PDF
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My AlkoHut Order Receipt',
        subject: 'Order #${order.id.substring(0, 8)}',
      );
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      Navigator.pop(context);
      _shareTextOnly();
    }
  }

  pw.Widget _buildPdfContent() {
    final currencyFormat = NumberFormat.currency(
      symbol: 'Ksh ',
      decimalDigits: 0,
      name: '',
    );

    // Load fonts (replace with your custom fonts if needed)

    final boldFont = pw.Font.helveticaBold();

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header Section
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  'AlkoHut',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 24,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'ORDER RECEIPT',
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Divider(color: PdfColors.grey400, thickness: 1),
              ],
            ),
          ),

          // Order Details Section
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Order #${order.id.substring(0, 8)}',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 12,
                  color: PdfColors.black,
                ),
              ),
              pw.Text(
                formatDate(order.date),
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),

          // Order Items Section
          pw.Text(
            'Order Items:',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 8),
          ...order.merchantOrders.map(
            (merchant) =>
                _buildMerchantPdfSection(merchant, currencyFormat, boldFont),
          ),
          pw.SizedBox(height: 10),
          pw.Divider(color: PdfColors.grey400, thickness: 1),

          // Totals Section
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'TOTAL',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 16,
                    color: PdfColors.black,
                  ),
                ),
                pw.Text(
                  currencyFormat.format(order.total),
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 16,
                    color: PdfColors.black,
                  ),
                ),
              ],
            ),
          ),

          // Payment and Delivery Info Section
          pw.SizedBox(height: 8),
          _buildPdfInfoRow('Payment Method:', order.paymentMethod),
          _buildPdfInfoRow('Delivery Type:', order.deliveryType),
          _buildPdfInfoRow('Delivery Time:', order.deliveryTime),
          if (order.specialInstructions.isNotEmpty)
            _buildPdfInfoRow(
                'Special Instructions:', order.specialInstructions),
          pw.SizedBox(height: 10),
          pw.Divider(color: PdfColors.grey400, thickness: 1),

          // Footer Section
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text(
              'Thanks for ordering with AlkoHut!',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 14,
                color: PdfColors.blue800,
              ),
            ),
          ),
          pw.SizedBox(height: 10),

          // Barcode Placeholder
          pw.Center(
            child: pw.Container(
              width: 150,
              height: 40,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Center(
                child: pw.Text(
                  '||||||||||||||||||||||||||||',
                  style: const pw.TextStyle(
                    fontSize: 20,
                    letterSpacing: -1,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text(
              order.id,
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMerchantPdfSection(MerchantOrderItem merchant,
      NumberFormat currencyFormat, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          merchant.merchantStoreName,
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 14,
            color: PdfColors.black,
          ),
        ),
        pw.SizedBox(height: 6),
        ...merchant.items
            .map((item) => _buildPdfOrderItem(item, currencyFormat)),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              'Subtotal: ${currencyFormat.format(merchant.subtotal)}',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 12,
                color: PdfColors.black,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Divider(color: PdfColors.grey400, thickness: 0.5),
      ],
    );
  }

  pw.Widget _buildPdfOrderItem(OrderItem item, NumberFormat currencyFormat) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${item.quantity}x',
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  item.productName,
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.black,
                  ),
                ),
                if (item.measure.isNotEmpty)
                  pw.Text(
                    item.measure,
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
              ],
            ),
          ),
          pw.Text(
            currencyFormat.format(item.price * item.quantity),
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
            ),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _shareTextOnly() {
    final textSummary = _generateTextSummary();
    Share.share(
      textSummary,
      subject: 'My Order Receipt #${order.id.substring(0, 8)}',
    );
  }

  String _generateTextSummary() {
    final currencyFormat = NumberFormat.currency(
      symbol: 'Ksh ',
      decimalDigits: 0,
      name: '',
    );
    StringBuffer receipt = StringBuffer();
    receipt.write('📝 ORDER RECEIPT\n');
    receipt.write('---------------------------\n');
    receipt.write('Order #${order.id.substring(0, 8)}\n');
    receipt.write('${formatDate(order.date)}\n\n');

    receipt.write('📋 ORDER ITEMS\n');
    for (var merchant in order.merchantOrders) {
      receipt.write('${merchant.merchantStoreName.toUpperCase()}\n');
      for (var item in merchant.items) {
        receipt.write(
            '${item.quantity}x ${item.productName} - ${currencyFormat.format(item.price * item.quantity)}\n');
      }
      receipt.write('\n');
    }

    receipt.write('---------------------------\n');
    receipt.write('TOTAL: ${currencyFormat.format(order.total)}\n');
    receipt.write('Payment: ${order.paymentMethod}\n');
    receipt.write('Delivery: ${order.deliveryType}\n');
    if (order.specialInstructions.isNotEmpty) {
      receipt.write('Note: ${order.specialInstructions}\n');
    }
    receipt.write('---------------------------\n');
    receipt.write('Thanks for ordering with AlkoHut!\n');

    return receipt.toString();
  }
}

class ReceiptWidget extends StatelessWidget {
  final CompletedOrder order;

  const ReceiptWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.substring(0, 8)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                dateFormat.format(order.date),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...order.merchantOrders
              .map((merchant) => _buildMerchantSection(merchant)),
          const SizedBox(height: 6),
          const Divider(thickness: 1, color: Colors.black),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  order.total.toStringAsFixed(0),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          _buildInfoRow('Payment Method:', order.paymentMethod),
          _buildInfoRow('Delivery Type:', order.deliveryType),
          _buildInfoRow('Delivery Time:', order.deliveryTime),
          if (order.specialInstructions.isNotEmpty)
            _buildInfoRow('Special Instructions:', order.specialInstructions),
          const SizedBox(height: 6),
          const Divider(thickness: 1, color: Colors.black),
          const SizedBox(height: 8),
          const Text(
            'Thanks for ordering with AlkoHut!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: const Center(
              child: Icon(Icons.qr_code, size: 80),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            order.id,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantSection(MerchantOrderItem merchant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(merchant.merchantImageUrl.isNotEmpty
                      ? merchant.merchantImageUrl
                      : 'https://via.placeholder.com/32'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                merchant.merchantStoreName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...merchant.items.map((item) => _buildOrderItem(item)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Subtotal: ksh ${formatMoney(merchant.subtotal)}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.quantity}x',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                if (item.measure.isNotEmpty)
                  Text(
                    item.measure,
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
              ],
            ),
          ),
          Text(
            'Ksh ${formatMoney(item.price * item.quantity)}',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
