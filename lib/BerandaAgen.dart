// ignore: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kosanku/component/JustHelper.dart';
import 'package:kosanku/inputKos.dart';
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

class BerandaAgen extends StatefulWidget {
  @override
  _BerandaAgenState createState() => _BerandaAgenState();
}

class _BerandaAgenState extends State<BerandaAgen> with WidgetsBindingObserver {
  final req = new GenRequest();

//  VARIABEL

  bool loading = false;

  // NotifBloc notifbloc;
  bool isLoaded = false;

//  double currentgurulainValue = 0;
  PageController gurulainController = PageController();
  var stateMetodBelajar = 1;
  var dataProperty;
  var clientId;
  var stateHari;
  var kelas, dariValue, keValue, totalpenumpang;
  dynamic dataJadwal;

  @override
  void initState() {
    // TODO: implement initState
    // analytics.
    getProperty();

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

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
              height: 50,
            ),
            CommonPadding(
                child: GenText(
              "Kos ku",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: dataProperty == null
                    ? Container()
                    : dataProperty.length == 0
                        ? Center(
                            child: GenText("Tidak ada mobil tersedia"),
                          )
                        : SingleChildScrollView(
                            child: Column(
                                children: dataProperty.map<Widget>((e) {
                            return CommonPadding(
                              child: InkWell(
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: GenShadow().genShadow(
                                          radius: 3.w, offset: Offset(0, 2.w))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        ip + e["foto"],
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      CommonPadding(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            GenText(
                                              e["nama"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),

                                            GenText(
                                              e["alamat"],
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            GenText(
                                              formatRupiahUseprefik(e["harga"].toString()) +" /bulan",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            GenText(
                                              "Peruntukan:  "+e["peruntukan"].toString(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            GenButton(
                                              text: "Edit",
                                              padding: EdgeInsets.all(10),
                                              textSize: 16,
                                              ontap: () {
                                                Navigator.pushNamed(
                                                    context, "inputkos", arguments: InputKos(id: e["id"],));
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList())))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "inputkos", arguments: InputKos(id: 0));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void getProperty() async {
    dataProperty = await req.getApi("mitra/kos");

    print("DATA $dataProperty");
    print("length" + dataProperty.length.toString());

    setState(() {});
  }
}
