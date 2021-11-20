import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'component/TextFieldLogin.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genPreferrence.dart';
import 'component/genText.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class Pembayaran extends StatefulWidget {
  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  bool readyToHit = true;
  final req = new GenRequest();

  var email, password;
  var _picker;
  XFile _image;

  Future<XFile> pickImage() async {
    final _picker = ImagePicker();

    final XFile pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      print('PickedFile: ${pickedFile.toString()}');
      setState(() {
        _image = XFile(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }

    if (_image != null) {
      return _image;
    }
    return null;
  }

  void takepic() async {
    final XFile photo = await _picker.pickImage(source: ImageSource.camera);
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.files != null) {
      for (final XFile file in response.files) {
        // _handleFile(file);
      }
    } else {
      // _handleError(response.exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Pembayaran",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextLoginField(
                    initVal: "",
                    width: double.infinity,
                    label: "HolderName",
                    keyboardType: TextInputType.name,
//                                    controller: tecNumber,
                    onChanged: (val) {
                      email = val;
                    },
                    validator: (val) {
                      if (val.length < 1) {
                        return "Isi Nama Dengan Benar";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _image == null
                      ? Container(
                          width: 100,
                          height: 100,
                        )
                      : Image.file(
                          File(_image.path),
                          width: 100,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: GenButton(
                      text: "Upload Bukti",
                      ontap: () {
                        pickImage();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            readyToHit
                ? GenButton(
                    text: "SUBMIT",
                    ontap: () {
                      // login(email, password);
                      Navigator.pushNamed(context, "base");
                    },
                  )
                : CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
