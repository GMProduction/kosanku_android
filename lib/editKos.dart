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

class EditKos extends StatefulWidget {
  var id, nama, keterangan, peruntukan, no_hp, harga, alamat, foto, latitude, longtitude;
  EditKos({this.id, this.nama, this.keterangan, this.peruntukan, this.no_hp, this.harga, this.alamat, this.foto, this.latitude, this.longtitude});

  @override
  _EditKosState createState() => _EditKosState();
}

class _EditKosState extends State<EditKos> {
  bool readyToHit = true;
  final req = new GenRequest();
  var isLoaded = false;
  var nama, keterangan, peruntukan, no_hp, harga, alamat, dataProperty, foto, latitude, longtitude;
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
    final EditKos args = ModalRoute.of(context).settings.arguments;
    id = args.id;

    if(!isLoaded){
      nama = args.nama;
      keterangan = args.keterangan;
      peruntukan = args.peruntukan;
      no_hp = args.no_hp;
      harga = args.harga.toString();
      alamat = args.alamat;
      foto = args.foto;
      latitude = args.latitude;
      longtitude = args.longtitude;
      isLoaded = true;
    }


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
                "EDIT KOS",
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
                initVal: longtitude,
                width: double.infinity,
                label: "Longtitude",
                keyboardType: TextInputType.text,
//                                    controller: tecNumber,
                onChanged: (val) {
                  longtitude = val;
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
                      text: "Edit",
                      ontap: () {
                        // login(email, password);
                        // Navigator.pushNamed(context, "base");
                        if(id != 0){
                          tambah(id, nama, alamat, keterangan, peruntukan, harga,
                              _image, latitude, longtitude);
                        }else{
                          edit(nama, alamat, keterangan, peruntukan, harga,
                              _image);
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

  void tambah(id, nama, alamat, keterangan, peruntukan, harga, foto, latitude, longtitude) async {
    setState(() {
      readyToHit = false;
    });
    String fileName = foto.path.split('/').last;
    dynamic data;
    data = await req.postForm("mitra/kos", {
      "id": id,
      "nama": nama,
      "alamat": alamat,
      "keterangan": keterangan,
      "peruntukan": peruntukan,
      "harga": harga,
      "latitude": latitude,
      "longtitude": longtitude,
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

  void edit(nama, alamat, keterangan, peruntukan, harga, foto) async {
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
      "longtitude": longtitude,
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
