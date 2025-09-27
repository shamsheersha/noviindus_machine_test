import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PatientDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> patientData;

  const PatientDetailsScreen({
    super.key,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        elevation: 1,
        foregroundColor: Colors.black87,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _generatePDF(context),
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Generate PDF',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background watermark logo
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.1, // Very low opacity for watermark effect
                child: Image.asset(
                  'assets/images/logo_big.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const Divider(height: 1),
                  _buildPatientDetailsSection(),
                  const Divider(height: 1, thickness: 1),
                  _buildTreatmentSection(),
                  const Divider(height: 1),
                  _buildPaymentSummary(),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final branch = patientData['branch'] ?? {};
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              // Logo on the left
              Image.asset(
                'assets/images/logo.png',
                width: 80,
                height: 80,
              ),
              const Spacer(),
              // Address on the right
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      branch['name']?.toString().toUpperCase() ?? 'KUMARAKOM',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${branch['location'] ?? 'Cheepunkal P.O. Kumarakom'}, ${branch['address'] ?? 'Kottayam, Kerala - 686563'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'e-mail: ${branch['mail'] ?? 'unknown@gmail.com'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mob: ${branch['phone'] ?? '+91 9876543210'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      branch['gst']?.toString().isNotEmpty == true 
                          ? 'GST No: ${branch['gst']}'
                          : 'GST No: 32AABCU9603R1ZW',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          // Use Column for each detail row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Name', patientData['name'] ?? 'N/A'),
              _buildDetailRow('Address', patientData['address'] ?? 'N/A'),
              _buildDetailRow('WhatsApp Number', patientData['phone'] ?? 'N/A'),
              const SizedBox(height: 16),
              _buildDetailRow('Booked On', _formatBookedDate(patientData['created_at'])),
              _buildDetailRow('Treatment Date', _formatTreatmentDate(patientData['date_nd_time'])),
              _buildDetailRow('Treatment Time', _formatTreatmentTime(patientData['date_nd_time'])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentSection() {
    final patientDetailsSet = patientData['patientdetails_set'] as List? ?? [];
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Treatment table header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Treatment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Male',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Female',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Treatment rows
          if (patientDetailsSet.isNotEmpty)
            ...patientDetailsSet.map((treatmentDetail) => _buildTreatmentRow(treatmentDetail))
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Center(
                child: Text(
                  'No treatments found',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTreatmentRow(Map<String, dynamic> treatmentDetail) {
    final treatmentName = treatmentDetail['treatment_name']?.toString() ?? 'Unknown Treatment';
    
    // Get treatment price from the treatment detail or calculate from total
    final treatmentPrice = double.tryParse(treatmentDetail['price']?.toString() ?? '0') ?? 0.0;
    
    // Parse male and female counts from comma-separated IDs
    final maleIds = treatmentDetail['male']?.toString() ?? '';
    final femaleIds = treatmentDetail['female']?.toString() ?? '';
    
    // Count the number of IDs (split by comma and count non-empty items)
    final maleCount = maleIds.isEmpty ? 0 : maleIds.split(',').where((id) => id.trim().isNotEmpty).length;
    final femaleCount = femaleIds.isEmpty ? 0 : femaleIds.split(',').where((id) => id.trim().isNotEmpty).length;
    
    // Calculate total for this treatment
    final totalCount = maleCount + femaleCount;
    final totalPrice = treatmentPrice * totalCount;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              treatmentName,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${treatmentPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              maleCount.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              femaleCount.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    final totalAmount = double.tryParse(patientData['total_amount']?.toString() ?? '0') ?? 0.0;
    final discountAmount = double.tryParse(patientData['discount_amount']?.toString() ?? '0') ?? 0.0;
    final advanceAmount = double.tryParse(patientData['advance_amount']?.toString() ?? '0') ?? 0.0;
    final balanceAmount = totalAmount - discountAmount - advanceAmount;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildPaymentRow('Total Amount', '₹${totalAmount.toStringAsFixed(0)}'),
          _buildPaymentRow('Discount', '₹${discountAmount.toStringAsFixed(0)}'),
          _buildPaymentRow('Advance', '₹${advanceAmount.toStringAsFixed(0)}'),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '₹${balanceAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Thank you for choosing us',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Your well-being is our commitment, and we're honored you've entrusted us with your health journey",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Signature area
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 2,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Signature',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, style: BorderStyle.solid),
                bottom: BorderSide(color: Colors.grey[300]!, style: BorderStyle.solid),
              ),
            ),
            child: Text(
              'Booking amount is non-refundable, and it\'s important to arrive on the allotted time for your treatment.',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // PDF Generation
  Future<void> _generatePDF(BuildContext context) async {
    final pdf = pw.Document();
    final branch = patientData['branch'] ?? {};
    final patientDetailsSet = patientData['patientdetails_set'] as List? ?? [];
    final totalAmount = double.tryParse(patientData['total_amount']?.toString() ?? '0') ?? 0.0;
    final discountAmount = double.tryParse(patientData['discount_amount']?.toString() ?? '0') ?? 0.0;
    final advanceAmount = double.tryParse(patientData['advance_amount']?.toString() ?? '0') ?? 0.0;
    final balanceAmount = totalAmount - discountAmount - advanceAmount;

    // Load the logo images
    final logoImage = await _loadLogoImage();
    final bigLogoImage = await _loadBigLogoImage();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Background watermark
              if (bigLogoImage != null)
                pw.Positioned.fill(
                  child: pw.Center(
                    child: pw.Opacity(
                      opacity: 0.1, // Very low opacity for watermark effect
                      child: pw.Image(
                        bigLogoImage,
                        width: 400,
                        height: 400,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              // Main content
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header
                  pw.Row(
                    children: [
                      // Logo on the left
                      if (logoImage != null)
                        pw.Container(
                          width: 90,
                          height: 90,
                          child: pw.Image(logoImage),
                        )
                      else
                        pw.Container(
                          width: 60,
                          height: 60,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.green100,
                            shape: pw.BoxShape.circle,
                            border: pw.Border.all(color: PdfColors.green, width: 2),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              'H',
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.green,
                              ),
                            ),
                          ),
                        ),
                      pw.Spacer(),
                      // Address on the right
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              branch['name']?.toString().toUpperCase() ?? 'KUMARAKOM',
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              '${branch['location'] ?? 'Cheepunkal P.O. Kumarakom'}, ${branch['address'] ?? 'Kottayam, Kerala - 686563'}',
                              style: pw.TextStyle(fontSize: 12),
                              textAlign: pw.TextAlign.right,
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'e-mail: ${branch['mail'] ?? 'unknown@gmail.com'}',
                              style: pw.TextStyle(fontSize: 12),
                              textAlign: pw.TextAlign.right,
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'Mob: ${branch['phone'] ?? '+91 9876543210'}',
                              style: pw.TextStyle(fontSize: 12),
                              textAlign: pw.TextAlign.right,
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              branch['gst']?.toString().isNotEmpty == true 
                                  ? 'GST No: ${branch['gst']}'
                                  : 'GST No: 32AABCU9603R1ZW',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 20),
                  
                  // Patient Details
                  pw.Text(
                    'Patient Details',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildPDFDetailRow('Name', patientData['name'] ?? 'N/A'),
                            _buildPDFDetailRow('Address', patientData['address'] ?? 'N/A'),
                            _buildPDFDetailRow('WhatsApp Number', patientData['phone'] ?? 'N/A'),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 24),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildPDFDetailRow('Booked On', _formatBookedDate(patientData['created_at'])),
                            _buildPDFDetailRow('Treatment Date', _formatTreatmentDate(patientData['date_nd_time'])),
                            _buildPDFDetailRow('Treatment Time', _formatTreatmentTime(patientData['date_nd_time'])),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 20),
                  
                  // Treatment Section
                  pw.Text(
                    'Treatment Details',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  
                  // Treatment Table
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(4),
                      1: const pw.FlexColumnWidth(2),
                      2: const pw.FlexColumnWidth(2),
                      3: const pw.FlexColumnWidth(2),
                      4: const pw.FlexColumnWidth(2),
                    },
                    children: [
                      // Header
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Treatment',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Price',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Male',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Female',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Total',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      // Treatment rows
                      if (patientDetailsSet.isNotEmpty)
                        ...patientDetailsSet.map((treatmentDetail) {
                          final treatmentName = treatmentDetail['treatment_name']?.toString() ?? 'Unknown Treatment';
                          final treatmentPrice = double.tryParse(treatmentDetail['price']?.toString() ?? '0') ?? 0.0;
                          final maleIds = treatmentDetail['male']?.toString() ?? '';
                          final femaleIds = treatmentDetail['female']?.toString() ?? '';
                          final maleCount = maleIds.isEmpty ? 0 : maleIds.split(',').where((id) => id.trim().isNotEmpty).length;
                          final femaleCount = femaleIds.isEmpty ? 0 : femaleIds.split(',').where((id) => id.trim().isNotEmpty).length;
                          final totalCount = maleCount + femaleCount;
                          final totalPrice = treatmentPrice * totalCount;
                          
                          return pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(treatmentName),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  'Rs. ${treatmentPrice.toStringAsFixed(0)}',
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  maleCount.toString(),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  femaleCount.toString(),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  'Rs. ${totalPrice.toStringAsFixed(0)}',
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 20),
                  
                  // Payment Summary
                  pw.Text(
                    'Payment Summary',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Amount'),
                      pw.Text('Rs. ${totalAmount.toStringAsFixed(0)}'),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Discount'),
                      pw.Text('Rs. ${discountAmount.toStringAsFixed(0)}'),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Advance'),
                      pw.Text('Rs. ${advanceAmount.toStringAsFixed(0)}'),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  pw.Divider(),
                  pw.SizedBox(height: 12),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Balance',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Rs. ${balanceAmount.toStringAsFixed(0)}',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 30),
                  
                  // Footer
                  pw.Center(
                    child: pw.Text(
                      'Thank you for choosing us',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Center(
                    child: pw.Text(
                      "Your well-being is our commitment, and we're honored you've entrusted us with your health journey",
                      style: pw.TextStyle(fontSize: 12),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.Text(
                      'Signature: _________________',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                    ),
                    child: pw.Text(
                      'Booking amount is non-refundable, and it\'s important to arrive on the allotted time for your treatment.',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontStyle: pw.FontStyle.italic,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      ),
    );

    // Show PDF preview and allow printing
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Patient_Booking_${patientData['name'] ?? 'Details'}.pdf',
    );
  }

  pw.Widget _buildPDFDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatBookedDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} | ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}${dateTime.hour >= 12 ? 'pm' : 'am'}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatTreatmentDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Not set';
    try {
      final dateTime = DateTime.parse(dateString.replaceAll(' ', 'T'));
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    } catch (e) {
      return 'Not set';
    }
  }

  String _formatTreatmentTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Not set';
    try {
      final dateTime = DateTime.parse(dateString.replaceAll(' ', 'T'));
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'pm' : 'am'}';
    } catch (e) {
      return 'Not set';
    }
  }

  // Helper method to load logo image
  Future<pw.ImageProvider?> _loadLogoImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/images/logo.png');
      final Uint8List bytes = data.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    } catch (e) {
      print('Error loading logo: $e');
      return null;
    }
  }

  // Helper method to load big logo image
  Future<pw.ImageProvider?> _loadBigLogoImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/images/logo_big.png');
      final Uint8List bytes = data.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    } catch (e) {
      print('Error loading big logo: $e');
      return null;
    }
  }
}
