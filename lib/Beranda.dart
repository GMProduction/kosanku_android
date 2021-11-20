// ignore: file_names
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kosanku/DetailKos.dart';
import 'package:kosanku/component/JustHelper.dart';
import 'package:kosanku/component/TextFieldLogin.dart';
import 'package:kosanku/component/genDimen.dart';
import 'package:provider/provider.dart';

import 'blocks/baseBloc.dart';
import 'component/NavDrawer.dart';
import 'component/commonPadding.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genRadioMini.dart';
import 'component/genShadow.dart';
import 'component/genText.dart';
import 'component/request.dart';
import 'component/textAndTitle.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with WidgetsBindingObserver {
  final req = new GenRequest();

//  VARIABEL

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;

//  double currentgurulainValue = 0;
  PageController gurulainController = PageController();
  var stateMetodBelajar = 1;
  var bloc, dataProperty;
  var clientId;
  var stateHari;
  var kelas, dariValue, keValue, totalpenumpang;
  dynamic dataUser;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    getUser();
    getProperty();

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  String clienId;

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    // notifbloc.dispose();
    // bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GenColor.primaryColor, // status bar color
    ));

    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery
                .of(context)
                .size
                .width,
            maxHeight: MediaQuery
                .of(context)
                .size
                .height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    bloc = Provider.of<BaseBloc>(context);
    // notifbloc = Provider.of<NotifBloc>(context);

    // sendAnalyticsEvent(testLogAnalytic);
    // print("anal itik "+testLogAnalytic);

    if (!isLoaded) {
      isLoaded = true;
    }

    // notifbloc.getTotalNotif();

    // bloc.util.getActiveOnline();
    // bloc.util.getNotifReview();

    // bloc.util.getRekomendasiAll("district", "level", 1, "limit", "offset");

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GenColor.primaryColor,
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, "notifikasi", arguments: );
                },
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.pushNamed(context, "baseagen");
                      },
                      child: Icon(
                        Icons.notifications,
                        size: 26.0,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: GenColor.primaryColor,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GenText(
                    dataUser == null ? "" : "Hai " + dataUser['nama'] + ",",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  GenText(
                    "Mau cari kos dimana nih?",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  TextLoginField(
                    prefixIcon: Icon(Icons.search),
                    label: "",
                    hintText: "Cari kos disini",
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    CommonPadding(
                        child: GenText(
                          "Rekomendasi Kos",
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 200,
                      child: dataProperty == null
                          ? Container()
                          : dataProperty.length == 0
                          ? Center(
                        child: GenText("Tidak ada mobil tersedia"),
                      )
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: dataProperty.map<Widget>((e) {
                              return CommonPadding(
                                child: InkWell(
                                  onTap: (){
                                    Navigator.pushNamed(context, "detailKos", arguments: DetailKos(id: e["id"],));
                                  },
                                  child: Container(
                                    height: 150,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          ip + e["foto"],
                                          height: 75,
                                          width: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .start,
                                                children: [
                                                  GenText(
                                                    e["nama"],
                                                    style: TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  GenText(
                                                    ". "+e['peruntukan']+" .",
                                                    style: TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  // Icon(
                                                  //   Icons.star,
                                                  //   size: 12,
                                                  // ),
                                                  // GenText(
                                                  //   "4.1",
                                                  //   style: TextStyle(
                                                  //       fontSize: 12),
                                                  // ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //   MainAxisAlignment
                                              //       .start,
                                              //   children: [
                                              //     Icon(
                                              //       Icons.location_pin,
                                              //       size: 11,
                                              //     ),
                                              //     SizedBox(
                                              //       width: 5,
                                              //     ),
                                              //     GenText(
                                              //       e["alamat"],
                                              //       style: TextStyle(
                                              //           fontSize: 12),
                                              //     ),
                                              //   ],
                                              // ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              GenText(
                                                formatRupiah(e["harga"].toString()),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );

                            }).toList()
                        ),
                      ),
                    ),
                    dataProperty == null
                        ? Container()
                        : dataProperty.length == 0
                        ? Center(
                      child: GenText("Tidak ada mobil tersedia"),
                    )
                        : Column(children: dataProperty.map<Widget>((e) {
                      return CommonPadding(
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, "detailKos", arguments: DetailKos(id: e["id"],));
                          },
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: GenShadow().genShadow(
                                    radius: 3.w, offset: Offset(0, 2.w))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                 ip + e["foto"],
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        GenText(
                                         e["nama"],
                                          style: TextStyle(
                                              fontSize: GenDimen.fontSizeBawah),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GenText(
                                          ". "+e["peruntukan"]+" .",
                                          style: TextStyle(
                                              fontSize: GenDimen.fontSizeBawah),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.star,
                                          size: GenDimen.fontSizeBawah,
                                        ),

                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          size: GenDimen.fontSizeBawah,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        GenText(
                                          e["alamat"],
                                          style: TextStyle(
                                              fontSize: GenDimen.fontSizeBawah),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GenText(
                                      formatRupiah(e["harga"].toString()),
                                      style: TextStyle(
                                          fontSize: GenDimen.fontSizeBawah,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          child: GenButton(
                                            text: "Pesan Kos",
                                            padding: EdgeInsets.all(3),
                                            radius: 10,
                                            textSize: 16,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getUser() async {
    print("data usernya :");
    dataUser = await req.getApi("user");

    print(dataUser);
    setState(() {});
  }

  void getProperty() async {
    dataProperty = await req.getApi("user/kos");

    print("DATA $dataProperty");
    print("length" + dataProperty.length.toString());

    setState(() {});
  }
}
