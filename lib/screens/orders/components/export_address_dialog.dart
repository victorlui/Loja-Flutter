import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:screenshot/screenshot.dart';

class ExportAddressDialog extends StatelessWidget {
  ExportAddressDialog(this.address);

  final Address address;

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
            '${address.street}, ${address.number}, ${address.complement}\n'
            '${address.district}\n'
            '${address.city}/${address.state}\n'
            '${address.zipCode}',
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      actions: [
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: () async {
             await screenshotController.capture().then((Uint8List image) async {
              
             
                final result =await ImageGallerySaver.saveImage(
                  Uint8List.fromList(image),
                  quality: 60,
                  name: 'Endereço'
                );

                print(result);
                 
               //await GallerySaver.saveImage(image as String);
            });
           
           
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Exportar'),
        ),
      ],
    );
  }
}
