import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:kosanku/pembangunan.dart';

import 'component/JustHelper.dart';
import 'component/TextFieldLogin.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genPreferrence.dart';
import 'component/genText.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class Propertymu extends StatefulWidget {
  @override
  _PropertymuState createState() => _PropertymuState();
}

class _PropertymuState extends State<Propertymu> {
  bool readyToHit = true;
  final req = new GenRequest();

  var email, password, dataProperty;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    getProperty();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 50,
          ),
          Text(
            "Property kamu",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              width: 200,
              child: Text(
                "Daftar Property yang kamu miliki",
                style: TextStyle(color: Colors.black54, fontSize: 14),
                textAlign: TextAlign.center,
              )),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: dataProperty == null ? Container() : dataProperty.length == 0 ? Center(child: GenText("TIdak ada Property"),) : SingleChildScrollView(
            child: Column(
                children: dataProperty.map<Widget>((e) {
              return InkWell(
                onTap: () {

                  Navigator.pushNamed(
                      context, 'pembangunan', arguments: Pembangunan(
                      id: e["id"],

                  ));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: GenColor.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenText(
                        "no. Pesanan: " + e["no_pesanan"],
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GenText(
                        "no. Sertifikat: " + e["no_sertifikat"],
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      GenText(
                        "tanggal: " + formatTanggalFromString(e["tanggal_beli"]),
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GenText(
                        "type: " + e["tipe_rumah"],
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      GenText(
                        e["deskripsi"],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }).toList()),
          ))
        ]),
      ),
    );
  }

  void getProperty() async {
    dataProperty = await req.getApi("pesanan");

    print("DATA $dataProperty");
    print("length" + dataProperty.length.toString());

    setState(() {});
  }
}
