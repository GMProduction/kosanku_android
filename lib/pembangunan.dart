import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'component/TextFieldLogin.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genPreferrence.dart';
import 'component/genText.dart';
import 'component/genToast.dart';
import 'component/request.dart';
import 'keterangan.dart';

class Pembangunan extends StatefulWidget {
  final int id;

  Pembangunan({this.id});

  @override
  _PembangunanState createState() => _PembangunanState();
}

class _PembangunanState extends State<Pembangunan> {
  bool readyToHit = true;
  final req = new GenRequest();

  var dataProperty, id, perkembangan;
  bool isloaded = false;

  @override
  Widget build(BuildContext context) {
    final Pembangunan args = ModalRoute.of(context).settings.arguments;
    id = args.id;

    if (!isloaded) {
      getProperty(id);
      isloaded = true;
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Proses Pembangunan",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
                child: perkembangan == null
                    ? Container()
                    : perkembangan.length == 0
                        ? Center(
                            child: GenText("Belum ada perkembangan"),
                          )
                        : SingleChildScrollView(
                            child: Column(
                                children: perkembangan.map<Widget>((e) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, "keterangan", arguments: Keterangan(
                                    id: e["id"],
                                    idp: id
                                  ));


                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: GenColor.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GenText(
                                        e["tanggal"],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList()),
                          ))
          ],
        ),
      ),
    );
  }

  void getProperty(id) async {
    dataProperty = await req.getApi("pesanan/" + id.toString());

    perkembangan = dataProperty["perkembangan"];

    print("DATA $dataProperty");
    print("length" + dataProperty.length.toString());

    setState(() {});
  }
}
