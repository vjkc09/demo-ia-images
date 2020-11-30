import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanButton extends StatelessWidget {
  //const ScanButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final Color colorRosa = Color.fromRGBO(237, 0, 140, 1);
    return Container(
      margin: EdgeInsets.only(top: (_screenSize.height * 0.6)),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 0.5,
        color: colorRosa,
        textColor: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 15.0),
          child: Text('Escanear'),
        ),
        onPressed: () async {

          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                    '#ED008C', 
                                                    'Cancelar', 
                                                    false, 
                                                    ScanMode.QR);
          print('escaneo: $barcodeScanRes');
        },
      ),
    );
  }
}
