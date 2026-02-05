import 'package:flutter/material.dart';

class PaymentGatewayPage extends StatelessWidget {
  const PaymentGatewayPage({Key? key}) : super(key: key);

  void _completePayment(BuildContext context) {
    Navigator.pop(context); // Close the payment page
    _showPaymentSuccessPopup(context);
  }

  void _showPaymentSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Payment Successful"),
          content: const Text("Thank you! Your booking has been confirmed."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Gateway"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.payment, size: 100, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              "Proceed to Payment",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "This is a static payment gateway page. Click below to complete your payment.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _completePayment(context),
              icon: const Icon(Icons.check),
              label: const Text("Pay Now"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
