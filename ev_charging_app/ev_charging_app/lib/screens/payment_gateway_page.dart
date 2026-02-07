import 'package:flutter/material.dart';

class PaymentGatewayPage extends StatefulWidget {
  const PaymentGatewayPage({Key? key}) : super(key: key);

  @override
  State<PaymentGatewayPage> createState() => _PaymentGatewayPageState();
}

class _PaymentGatewayPageState extends State<PaymentGatewayPage> {
  String? selectedPaymentMethod;
  final TextEditingController _upiController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: 'gpay',
      name: 'Google Pay',
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
      type: PaymentType.upi,
    ),
    PaymentMethod(
      id: 'phonepe',
      name: 'PhonePe',
      icon: Icons.phone_android,
      color: Colors.purple,
      type: PaymentType.upi,
    ),
    PaymentMethod(
      id: 'paytm',
      name: 'Paytm',
      icon: Icons.payment,
      color: Colors.lightBlue,
      type: PaymentType.upi,
    ),
    PaymentMethod(
      id: 'upi',
      name: 'Other UPI',
      icon: Icons.qr_code_scanner,
      color: Colors.orange,
      type: PaymentType.upi,
    ),
    PaymentMethod(
      id: 'card',
      name: 'Credit/Debit Card',
      icon: Icons.credit_card,
      color: Colors.green,
      type: PaymentType.card,
    ),
    PaymentMethod(
      id: 'netbanking',
      name: 'Net Banking',
      icon: Icons.account_balance,
      color: Colors.red,
      type: PaymentType.netbanking,
    ),
  ];

  void _completePayment() {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate based on payment type
    final method = paymentMethods.firstWhere((m) => m.id == selectedPaymentMethod);
    
    if (method.type == PaymentType.upi && selectedPaymentMethod != 'upi') {
      // For predefined UPI apps, no validation needed
      _processPayment();
    } else if (method.type == PaymentType.upi && _upiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your UPI ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (method.type == PaymentType.card) {
      if (_cardNumberController.text.isEmpty ||
          _cardHolderController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all card details'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      _processPayment();
    } else {
      _processPayment();
    }
  }

  void _processPayment() {
    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing Payment...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close processing dialog
      Navigator.pop(context); // Close payment page
      _showPaymentSuccessPopup();
    });
  }

  void _showPaymentSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Payment Successful!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Thank you! Your booking has been confirmed.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Done"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method) {
    final isSelected = selectedPaymentMethod == method.id;
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method.id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? method.color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? method.color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: method.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                method.icon,
                color: method.color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: method.color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpiInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter UPI ID',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _upiController,
          decoration: InputDecoration(
            hintText: 'example@upi',
            prefixIcon: const Icon(Icons.alternate_email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildCardInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Card Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          maxLength: 16,
          decoration: InputDecoration(
            hintText: 'Card Number',
            prefixIcon: const Icon(Icons.credit_card),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            counterText: '',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cardHolderController,
          decoration: InputDecoration(
            hintText: 'Card Holder Name',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _expiryController,
                keyboardType: TextInputType.datetime,
                maxLength: 5,
                decoration: InputDecoration(
                  hintText: 'MM/YY',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                maxLength: 3,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'CVV',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  counterText: '',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNetBankingInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Your Bank',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text('Choose Bank'),
            items: [
              'State Bank of India',
              'HDFC Bank',
              'ICICI Bank',
              'Axis Bank',
              'Kotak Mahindra Bank',
              'Punjab National Bank',
              'Bank of Baroda',
              'Canara Bank',
            ].map((bank) => DropdownMenuItem(
              value: bank,
              child: Text(bank),
            )).toList(),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedMethod = selectedPaymentMethod != null
        ? paymentMethods.firstWhere((m) => m.id == selectedPaymentMethod)
        : null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Payment Gateway",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal[700]!, Colors.teal[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.payment,
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Choose Payment Method",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "100% Secure Payment",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Payment Methods List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Payment Option',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Payment method cards
                  ...paymentMethods.map((method) => _buildPaymentMethodCard(method)),

                  const SizedBox(height: 24),

                  // Additional input based on selected method
                  if (selectedMethod != null) ...[
                    if (selectedMethod.type == PaymentType.upi && 
                        selectedMethod.id == 'upi')
                      _buildUpiInput(),
                    if (selectedMethod.type == PaymentType.card)
                      _buildCardInput(),
                    if (selectedMethod.type == PaymentType.netbanking)
                      _buildNetBankingInput(),
                  ],
                ],
              ),
            ),
          ),

          // Pay Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _completePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        selectedPaymentMethod == null 
                            ? 'Select Payment Method' 
                            : 'Pay Securely',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _upiController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}

// Models
enum PaymentType {
  upi,
  card,
  netbanking,
}

class PaymentMethod {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final PaymentType type;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}