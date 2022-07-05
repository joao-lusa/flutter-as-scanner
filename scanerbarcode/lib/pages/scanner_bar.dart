import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScannerBar extends StatefulWidget {
  const ScannerBar({Key? key}) : super(key: key);

  @override
  State<ScannerBar> createState() => _ScannerBarState();
}

class _ScannerBarState extends State<ScannerBar> {
  String ticket = '';
  List<String> tickets = [];

  readQRCode() async {
    Stream<dynamic>? reader = FlutterBarcodeScanner.getBarcodeStreamReceiver(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.BARCODE,
    );
    if (reader != null)
      reader.listen((code) {
        setState(() {
          if (!tickets.contains(code.toString()) && code != '-1')
            tickets.add(code.toString());
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //if (ticket != '')
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Ticket: ${tickets.length}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton.icon(
              onPressed: readQRCode,
              icon: const Icon(Icons.qr_code),
              label: const Text('Validar'),
            ),
          ],
        ),
      ),
    );
  }
}
