import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanerbarcode/pages/history.dart';

class ScannerBar extends StatefulWidget {
  const ScannerBar({Key? key}) : super(key: key);

  @override
  State<ScannerBar> createState() => _ScannerBarState();
}

class _ScannerBarState extends State<ScannerBar> {
  String ticket = '';
  List<String> tickets = [];

  Future readQRCode() async {
    String reader = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.BARCODE,
    );
    setState(() async {
      await Flushbar(
        title: 'Adcionado',
        message: 'item Adicionado',
        duration: const Duration(seconds: 2),
      ).show(context);
    });
    DatabaseHelper.instance.add(Scans(content: reader));
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
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const ScanHistory();
                  }),
                );
              },
              icon: const Icon(Icons.qr_code),
              label: const Text('Histórico'),
            ),
          ],
        ),
      ),
    );
  }
}
