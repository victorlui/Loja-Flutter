import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({this.onSelectFile});

  final Function(File) onSelectFile;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Future<void> editImage(String path) async {
      final File cropperFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Editar Imagem',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white),
        iosUiSettings: const IOSUiSettings(
            title: 'Editar Imagem',
            cancelButtonTitle: 'Cancelar',
            doneButtonTitle: 'Concluir'),
      );

      if(cropperFile != null){
        onSelectFile(cropperFile);
      }
    }

    if (Platform.isAndroid)
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ignore: deprecated_member_use
            FlatButton(
                onPressed: () async {
                  final PickedFile file =
                      await picker.getImage(source: ImageSource.camera);

                  editImage(file.path);
                },
                child: const Text('Câmera')),
            // ignore: deprecated_member_use
            FlatButton(
                onPressed: () async {
                  final PickedFile file =
                      await picker.getImage(source: ImageSource.gallery);
                  editImage(file.path);
                },
                child: const Text('Galeria'))
          ],
        ),
      );
    else
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o item'),
        message: const Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar')),
        actions: [
          CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () async {
                final PickedFile file =
                    await picker.getImage(source: ImageSource.camera);

                editImage(file.path);
              },
              child: const Text('Câmera')),
          CupertinoActionSheetAction(
              onPressed: () async {
                final PickedFile file =
                    await picker.getImage(source: ImageSource.gallery);
                editImage(file.path);
              },
              child: const Text('Galeria'))
        ],
      );
  }
}
