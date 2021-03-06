import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'component/TextFieldLogin.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class InputKos extends StatefulWidget {
  var id;
  InputKos({this.id});

  @override
  _InputKosState createState() => _InputKosState();
}

class _InputKosState extends State<InputKos> {
  bool readyToHit = true;
  final req = new GenRequest();

  var nama, keterangan, peruntukan, no_hp, harga, alamat, latitude, longitude;
  var id;
  XFile _image;

  Future<XFile> pickImage() async {
    final _picker = ImagePicker();

    final XFile pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

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

  @override
  Widget build(BuildContext context) {
    final InputKos args = ModalRoute.of(context).settings.arguments;
    id = args.id;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "INPUT KOS",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              TextLoginField(
                initVal: nama,
                width: double.infinity,
                label: "Nama Kos",
                keyboardType: TextInputType.name,
//                                    controller: tecNumber,
                onChanged: (val) {
                  nama = val;
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
              TextLoginField(
                initVal: alamat,
                width: double.infinity,
                label: "Alamat Kos",
                keyboardType: TextInputType.streetAddress,
//                                    controller: tecNumber,
                onChanged: (val) {
                  alamat = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Alamat Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: keterangan,
                width: double.infinity,
                label: "Keterangan",
                keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                onChanged: (val) {
                  keterangan = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi No HP";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: peruntukan,
                width: double.infinity,
                label: "Peruntukan",
                keyboardType: TextInputType.streetAddress,
//                                    controller: tecNumber,
                onChanged: (val) {
                  peruntukan = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Peruntukan Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: harga,
                width: double.infinity,
                label: "Harga /bulan",
                keyboardType: TextInputType.number,
//                                    controller: tecNumber,
                onChanged: (val) {
                  harga = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Harga Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: latitude,
                width: double.infinity,
                label: "Latitude",
                keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                onChanged: (val) {
                  latitude = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Latitude Dengan Benar";
                  } else {
                    return null;
                  }
                },
              ),

              SizedBox(
                height: 20,
              ),
              TextLoginField(
                initVal: longitude,
                width: double.infinity,
                label: "Longtitude",
                keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                onChanged: (val) {
                  longitude = val;
                },
                validator: (val) {
                  if (val.length < 1) {
                    return "Isi Longitude Dengan Benar";
                  } else {
                    return null;
                  }
                },
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
              Container(
                child: GenButton(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey,
                  text: "Upload Foto",
                  ontap: () {
                    pickImage();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 30,
              ),
              readyToHit
                  ? GenButton(
                      text: "TAMBAH",
                      ontap: () {
                        // login(email, password);
                        // Navigator.pushNamed(context, "base");
                        if(id != 0){
                          tambah(nama, alamat, keterangan, peruntukan, harga,
                              _image, latitude, longitude);
                        }else{
                          edit(nama, alamat, keterangan, peruntukan, harga,
                              _image, latitude, longitude);
                        }

                      },
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void tambah(nama, alamat, keterangan, peruntukan, harga, foto, latitude, longitude) async {
    setState(() {
      readyToHit = false;
    });
    String fileName = foto.path.split('/').last;
    dynamic data;
    data = await req.postForm("mitra/kos", {
      "nama": nama,
      "alamat": alamat,
      "keterangan": keterangan,
      "peruntukan": peruntukan,
      "harga": harga,
      "latitude": latitude,
      "longtitude": longitude,
      "foto": await MultipartFile.fromFile(foto.path, filename: fileName)
    });

    print("DATA $data");
    setState(() {
      readyToHit = true;
    });
    if (data["nama"] == nama) {
      toastShow("Kos Berhasil di input", context, Colors.black);
      Navigator.pushReplacementNamed(context, "baseagen");
    } else if (data["code"] == 202) {
      setState(() {
        toastShow(data["payload"]["msg"], context, GenColor.red);
      });
    } else {
      setState(() {
        toastShow("Terjadi kesalahan coba cek koneksi internet kamu", context,
            GenColor.red);
      });
    }
  }

  void edit(nama, alamat, keterangan, peruntukan, harga, foto, latitude, longitude) async {
    setState(() {
      readyToHit = false;
    });
    String fileName = foto.path.split('/').last;
    dynamic data;
    data = await req.postForm("mitra/kos", {
      "nama": nama,
      "alamat": alamat,
      "keterangan": keterangan,
      "peruntukan": peruntukan,
      "harga": harga,
      "id": id,
      "latitude": latitude,
      "longtitude": longitude,
      "foto": await MultipartFile.fromFile(foto.path, filename: fileName)
    });

    print("DATA $data");
    setState(() {
      readyToHit = true;
    });
    if (data["nama"] == nama) {
      toastShow("Kos Berhasil di input", context, Colors.black);
      Navigator.pushReplacementNamed(context, "baseagen");
    } else if (data["code"] == 202) {
      setState(() {
        toastShow(data["payload"]["msg"], context, GenColor.red);
      });
    } else {
      setState(() {
        toastShow("Terjadi kesalahan coba cek koneksi internet kamu", context,
            GenColor.red);
      });
    }
  }


}
