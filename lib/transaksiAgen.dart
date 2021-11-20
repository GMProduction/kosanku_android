// ignore: file_names
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class TransaksiAgen extends StatefulWidget {
  @override
  _TransaksiAgenState createState() => _TransaksiAgenState();
}

class _TransaksiAgenState extends State<TransaksiAgen> with WidgetsBindingObserver {

  final req = new GenRequest();




//  VARIABEL

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;

//  double currentgurulainValue = 0;
  PageController gurulainController = PageController();
  var stateMetodBelajar = 1;
  var bloc;
  var clientId;
  var stateHari, totalpenumpang;
  var kelas;
  dynamic dataJadwal;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    getKelas();

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

  getKelas() async {
    dataJadwal = await req.getApi("jadwal?id=1");
    // kelas = await getPrefferenceKelas();
    setState(() {});
  }

//  getClientId() async {
//    clientId = await getPrefferenceIdClient();
//    if (clientId != null) {
//      print("CLIENT ID" + clientId);
//    }
//  }

  getProfileAbsen() async {
    // await profileBloc.getProfile(reload: true);
  }

  String clienId;

//  getRoom() async {
//    clienId = await getPrefferenceIdClient();
//    return clienId;
//  }

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
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
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
                    Icon(
                      Icons.notifications,
                      size: 26.0,
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
            SizedBox(
              height: 20,
            ),
            CommonPadding(
                child: GenText(
              "Riwayat Penumpang",
              style: TextStyle(fontSize: 25),
            )),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              CommonPadding(
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: GenShadow()
                          .genShadow(radius: 3.w, offset: Offset(0, 2.w))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        "https://img.inews.co.id/media/822/files/inews_new/2021/02/25/Screenshot_20210225_100311_Samsung_Internet.jpg",
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GenText("Nama Penumpang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          GenText("Nomor Transaksi"),

                        ],
                      ),
                      SizedBox(height: 15,),
                    ],
                  ),
                ),
              )
            ])))
          ],
        ),
      ),
    );
  }

// void getJaddwal(id) async {
//   dataJadwal = await req.getApi("jadwal?id=" + id.toString());
//
//   print("DATA $dataJadwal");
//   print("length" +dataJadwal.length.toString());
//
//   setState(() {});
// }
}
