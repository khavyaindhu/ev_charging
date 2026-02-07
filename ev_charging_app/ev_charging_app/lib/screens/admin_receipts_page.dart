import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminReceiptsPage extends StatefulWidget {
  const AdminReceiptsPage({Key? key}) : super(key: key);

  @override
  State<AdminReceiptsPage> createState() => _AdminReceiptsPageState();
}

class _AdminReceiptsPageState extends State<AdminReceiptsPage> {
  List<Receipt> receipts = [];
  List<Receipt> filteredReceipts = [];
  String selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateRandomReceipts();
    filteredReceipts = receipts;
  }

  void _generateRandomReceipts() {
    final random = Random();
    final now = DateTime.now();
    
    // Generate 30 random receipts
    for (int i = 0; i < 30; i++) {
      final receiptDate = now.subtract(Duration(days: random.nextInt(90)));
      final receiptTime = TimeOfDay(
        hour: 8 + random.nextInt(11),
        minute: random.nextInt(60),
      );
      
      receipts.add(_createRandomReceipt(i + 1, receiptDate, receiptTime, random));
    }
    
    // Sort by date (newest first)
    receipts.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Receipt _createRandomReceipt(int id, DateTime date, TimeOfDay time, Random random) {
    final List<String> customerNames = [
      'Rahul Kumar', 'Priya Sharma', 'Amit Patel', 'Sneha Reddy', 'Vijay Singh',
      'Lakshmi Iyer', 'Arjun Nair', 'Divya Menon', 'Karthik Raj', 'Ananya Das',
      'Suresh Babu', 'Meera Krishnan', 'Rohan Gupta', 'Kavya Pillai', 'Arun Kumar',
      'Deepa Srinivasan', 'Ravi Shankar', 'Pooja Rao', 'Mahesh Varma', 'Swathi Nambiar',
      'Naveen Chandra', 'Radha Krishnan', 'Sanjay Reddy', 'Nisha Agarwal', 'Manoj Kumar',
      'Shruti Desai', 'Vishal Mehta', 'Bhavya Narayan', 'Ramesh Pillai', 'Anjali Bhat'
    ];

    final List<String> locations = [
      'Madurai EV Station', 'Salem EV Port', 'Coimbatore EV Hub', 
      'Trichy Charging Point', 'Tiruppur Green Charge', 'Nagercoil Power Station',
      'Thanjavur EV Center', 'Dindigul Charging Hub', 'Erode EV Point',
      'Kanchipuram Charge Station', 'Vellore EV Hub', 'Thoothukudi Charging Center',
      'Karur Green Station', 'Pollachi EV Port', 'Kumbakonam Charging Point',
      'Chennai Central EV', 'Bangalore EV Hub', 'Mysore Charging Station',
      'Kochi EV Center', 'Thiruvananthapuram Power Point'
    ];

    final List<List<ServiceItem>> serviceVariations = [
      // Variation 1: Just Charging
      [
        ServiceItem(name: 'Fast Charging (2 hours)', price: 450.0, quantity: 1),
      ],
      // Variation 2: Charging + Parking
      [
        ServiceItem(name: 'Charging Port 1 (3 hours)', price: 300.0, quantity: 1),
        ServiceItem(name: 'Parking Service', price: 100.0, quantity: 1),
      ],
      // Variation 3: Full Service
      [
        ServiceItem(name: 'Fast Charging (1.5 hours)', price: 380.0, quantity: 1),
        ServiceItem(name: 'Car Wash (Premium)', price: 250.0, quantity: 1),
        ServiceItem(name: 'Parking Service', price: 80.0, quantity: 1),
        ServiceItem(name: 'Beverages', price: 120.0, quantity: 2),
      ],
      // Variation 4: Charging + Car Wash
      [
        ServiceItem(name: 'Charging Port 2 (2 hours)', price: 400.0, quantity: 1),
        ServiceItem(name: 'Car Wash (Basic)', price: 150.0, quantity: 1),
      ],
      // Variation 5: Multiple Services
      [
        ServiceItem(name: 'Fast Charging (1 hour)', price: 280.0, quantity: 1),
        ServiceItem(name: 'Mechanic Support', price: 500.0, quantity: 1),
        ServiceItem(name: 'Parking Service', price: 120.0, quantity: 1),
      ],
      // Variation 6: Minimal Service
      [
        ServiceItem(name: 'Charging Port 1 (1 hour)', price: 180.0, quantity: 1),
        ServiceItem(name: 'Drinking Water', price: 20.0, quantity: 2),
      ],
      // Variation 7: Premium Package
      [
        ServiceItem(name: 'Fast Charging (3 hours)', price: 650.0, quantity: 1),
        ServiceItem(name: 'Car Wash (Premium)', price: 300.0, quantity: 1),
        ServiceItem(name: 'Beverages (Coffee)', price: 80.0, quantity: 2),
        ServiceItem(name: 'Parking Service (VIP)', price: 200.0, quantity: 1),
      ],
      // Variation 8: Mechanic Heavy
      [
        ServiceItem(name: 'Charging Port 2 (2 hours)', price: 380.0, quantity: 1),
        ServiceItem(name: 'Mechanic Support (Full Service)', price: 800.0, quantity: 1),
        ServiceItem(name: 'Car Wash', price: 180.0, quantity: 1),
      ],
      // Variation 9: Quick Stop
      [
        ServiceItem(name: 'Fast Charging (30 min)', price: 150.0, quantity: 1),
        ServiceItem(name: 'Beverages', price: 60.0, quantity: 1),
      ],
      // Variation 10: Extended Stay
      [
        ServiceItem(name: 'Charging Port 1 (5 hours)', price: 520.0, quantity: 1),
        ServiceItem(name: 'Parking Service (Extended)', price: 250.0, quantity: 1),
        ServiceItem(name: 'Beverages', price: 100.0, quantity: 3),
        ServiceItem(name: 'Car Wash', price: 200.0, quantity: 1),
      ],
    ];

    final List<String> paymentMethods = [
      'Credit Card', 'Debit Card', 'UPI', 'Cash', 'Mobile Wallet', 'Net Banking'
    ];

    final services = serviceVariations[random.nextInt(serviceVariations.length)];
    final subtotal = services.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final tax = subtotal * 0.18; // 18% GST
    final total = subtotal + tax;

    return Receipt(
      id: 'RCP${id.toString().padLeft(6, '0')}',
      customerName: customerNames[random.nextInt(customerNames.length)],
      dateTime: DateTime(date.year, date.month, date.day, time.hour, time.minute),
      location: locations[random.nextInt(locations.length)],
      services: services,
      subtotal: subtotal,
      tax: tax,
      total: total,
      paymentMethod: paymentMethods[random.nextInt(paymentMethods.length)],
      vehicleNumber: _generateVehicleNumber(random),
    );
  }

  String _generateVehicleNumber(Random random) {
    final states = ['TN', 'KA', 'KL', 'AP', 'MH'];
    final state = states[random.nextInt(states.length)];
    final district = random.nextInt(99) + 1;
    final letters = String.fromCharCodes([
      65 + random.nextInt(26),
      65 + random.nextInt(26),
    ]);
    final number = random.nextInt(9000) + 1000;
    return '$state${district.toString().padLeft(2, '0')}$letters$number';
  }

  void _filterReceipts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredReceipts = receipts;
      } else {
        filteredReceipts = receipts.where((receipt) {
          return receipt.customerName.toLowerCase().contains(query.toLowerCase()) ||
                 receipt.id.toLowerCase().contains(query.toLowerCase()) ||
                 receipt.location.toLowerCase().contains(query.toLowerCase()) ||
                 receipt.vehicleNumber.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      _applyServiceFilter();
    });
  }

  void _applyServiceFilter() {
    if (selectedFilter == 'All') return;
    
    setState(() {
      filteredReceipts = filteredReceipts.where((receipt) {
        return receipt.services.any((service) => 
          service.name.toLowerCase().contains(selectedFilter.toLowerCase())
        );
      }).toList();
    });
  }

  Future<void> _generatePDF(Receipt receipt) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.teal700,
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'EV CHARGING RECEIPT',
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            receipt.location,
                            style: const pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Receipt #',
                            style: const pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            receipt.id,
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),

                // Customer Details
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Customer Details',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.teal700,
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          _buildPdfDetailRow('Name:', receipt.customerName),
                          _buildPdfDetailRow('Vehicle:', receipt.vehicleNumber),
                          _buildPdfDetailRow('Payment:', receipt.paymentMethod),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Transaction Details',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.teal700,
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          _buildPdfDetailRow('Date:', DateFormat('dd MMM yyyy').format(receipt.dateTime)),
                          _buildPdfDetailRow('Time:', DateFormat('hh:mm a').format(receipt.dateTime)),
                          _buildPdfDetailRow('Location:', receipt.location),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),

                // Services Table
                pw.Text(
                  'Services',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.teal700,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    // Header
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        _buildTableCell('Service', isHeader: true),
                        _buildTableCell('Qty', isHeader: true),
                        _buildTableCell('Price', isHeader: true),
                        _buildTableCell('Total', isHeader: true),
                      ],
                    ),
                    // Services
                    ...receipt.services.map((service) => pw.TableRow(
                      children: [
                        _buildTableCell(service.name),
                        _buildTableCell(service.quantity.toString()),
                        _buildTableCell('₹${service.price.toStringAsFixed(2)}'),
                        _buildTableCell('₹${(service.price * service.quantity).toStringAsFixed(2)}'),
                      ],
                    )),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Total Section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      width: 250,
                      child: pw.Column(
                        children: [
                          _buildTotalRow('Subtotal:', '₹${receipt.subtotal.toStringAsFixed(2)}'),
                          _buildTotalRow('Tax (18% GST):', '₹${receipt.tax.toStringAsFixed(2)}'),
                          pw.Divider(thickness: 2),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.teal700,
                              borderRadius: pw.BorderRadius.circular(5),
                            ),
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'TOTAL AMOUNT',
                                  style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                pw.Text(
                                  '₹${receipt.total.toStringAsFixed(2)}',
                                  style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),

                // Footer
                pw.Divider(),
                pw.Center(
                  child: pw.Text(
                    'Thank you for using our EV Charging Services!',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Center(
                  child: pw.Text(
                    'For support, contact: support@evcharging.com | +91 1800-XXX-XXXX',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Show print preview
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildPdfDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(width: 5),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _buildTotalRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Receipts Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                receipts.clear();
                _generateRandomReceipts();
                filteredReceipts = receipts;
                _searchController.clear();
                selectedFilter = 'All';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Receipts refreshed with new random data'),
                  backgroundColor: Colors.teal,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Stats
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal[700]!, Colors.teal[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Total Receipts',
                        receipts.length.toString(),
                        Icons.receipt_long,
                      ),
                      _buildStatCard(
                        'Total Revenue',
                        '₹${receipts.fold(0.0, (sum, r) => sum + r.total).toStringAsFixed(0)}',
                        Icons.currency_rupee,
                      ),
                      _buildStatCard(
                        'Avg. Transaction',
                        '₹${(receipts.fold(0.0, (sum, r) => sum + r.total) / receipts.length).toStringAsFixed(0)}',
                        Icons.analytics,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Search and Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _filterReceipts,
                  decoration: InputDecoration(
                    hintText: 'Search by customer, receipt ID, location, or vehicle...',
                    prefixIcon: const Icon(Icons.search, color: Colors.teal),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterReceipts('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.teal, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Charging'),
                      _buildFilterChip('Parking'),
                      _buildFilterChip('Car Wash'),
                      _buildFilterChip('Mechanic'),
                      _buildFilterChip('Beverage'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Receipts List
          Expanded(
            child: filteredReceipts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No receipts found',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredReceipts.length,
                    itemBuilder: (context, index) {
                      return _buildReceiptCard(filteredReceipts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = label;
            _filterReceipts(_searchController.text);
          });
        },
        selectedColor: Colors.teal,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.white,
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildReceiptCard(Receipt receipt) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showReceiptDetails(receipt),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal[100],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                receipt.id,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[900],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                receipt.customerName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                receipt.location,
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${receipt.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(receipt.dateTime),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      Text(
                        DateFormat('hh:mm a').format(receipt.dateTime),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.directions_car, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    receipt.vehicleNumber,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.payment, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    receipt.paymentMethod,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
Wrap(
  spacing: 6,
  runSpacing: 6,
  children: [
    ...receipt.services.take(3).map((service) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          service.name.split('(')[0].trim(),
          style: const TextStyle(fontSize: 10),
        ),
      );
    }),
    if (receipt.services.length > 3)
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.teal[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '+${receipt.services.length - 3} more',
          style: TextStyle(
            fontSize: 10,
            color: Colors.teal[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
  ],
),
             
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showReceiptDetails(receipt),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _generatePDF(receipt),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReceiptDetails(Receipt receipt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal[700]!, Colors.teal[500]!],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Receipt Details',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  receipt.id,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            receipt.location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Customer Info
                    _buildDetailSection(
                      'Customer Information',
                      [
                        _buildDetailRow('Name', receipt.customerName, Icons.person),
                        _buildDetailRow('Vehicle', receipt.vehicleNumber, Icons.directions_car),
                        _buildDetailRow('Payment Method', receipt.paymentMethod, Icons.payment),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Transaction Info
                    _buildDetailSection(
                      'Transaction Information',
                      [
                        _buildDetailRow('Date', DateFormat('dd MMMM yyyy').format(receipt.dateTime), Icons.calendar_today),
                        _buildDetailRow('Time', DateFormat('hh:mm a').format(receipt.dateTime), Icons.access_time),
                        _buildDetailRow('Location', receipt.location, Icons.location_on),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Services
                    const Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...receipt.services.map((service) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal[100],
                          child: Text(
                            '${service.quantity}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[900],
                            ),
                          ),
                        ),
                        title: Text(service.name),
                        subtitle: Text('₹${service.price.toStringAsFixed(2)} each'),
                        trailing: Text(
                          '₹${(service.price * service.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),

                    // Totals
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildTotalRowWidget('Subtotal', '₹${receipt.subtotal.toStringAsFixed(2)}'),
                          const SizedBox(height: 8),
                          _buildTotalRowWidget('Tax (18% GST)', '₹${receipt.tax.toStringAsFixed(2)}'),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'TOTAL',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹${receipt.total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Download Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _generatePDF(receipt);
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download PDF Receipt'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRowWidget(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Models
class Receipt {
  final String id;
  final String customerName;
  final DateTime dateTime;
  final String location;
  final List<ServiceItem> services;
  final double subtotal;
  final double tax;
  final double total;
  final String paymentMethod;
  final String vehicleNumber;

  Receipt({
    required this.id,
    required this.customerName,
    required this.dateTime,
    required this.location,
    required this.services,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.vehicleNumber,
  });
}

class ServiceItem {
  final String name;
  final double price;
  final int quantity;

  ServiceItem({
    required this.name,
    required this.price,
    required this.quantity,
  });
}