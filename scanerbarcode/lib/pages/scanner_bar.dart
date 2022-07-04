import 'package:flutter/material.dart';

class ScannerBar extends StatefulWidget {
  const ScannerBar({Key? key}) : super(key: key);

  @override
  State<ScannerBar> createState() => _ScannerBarState();
}

class _ScannerBarState extends State<ScannerBar> {
  String ticket = '';
  List<String> tickets = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (ticket != '')
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Ticket: $ticket',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ElevatedButton.icon(
              onPressed: () => {},
              icon: const Icon(Icons.qr_code),
              label: const Text('Validar'),
            ),
          ],
        ),
      ),
    );
  }
}
