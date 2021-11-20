import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kosanku/profilAgen.dart';
import 'package:kosanku/transaksiAgen.dart';


import 'package:toast/toast.dart';
import 'package:provider/provider.dart';

import 'Beranda.dart';
import 'BerandaAgen.dart';
import 'component/genColor.dart';
import 'component/genPage.dart';
import 'component/menuNavbarAgen.dart';
import 'daftar.dart';
import 'login.dart';

class BaseAgen extends StatefulWidget {
  @override
  _BaseAgenState createState() => _BaseAgenState();
}

class _BaseAgenState extends State<BaseAgen> {
  int _currentIndex = 0;
  DateTime currentBackPressTime;

  // UtilBloc utilbloc;
  // NotifBloc notifbloc;

  final _widgetOptions = [
    BerandaAgen(),
    ProfilAgen(),
  ];

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toast.show("Tekan sekali lagi untuk keluar aplikasi!", context);
      return "";
    }
    return SystemNavigator.pop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      // utilbloc = Provider.of<UtilBloc>(context);
      // notifbloc = Provider.of<NotifBloc>(context);
      // utilbloc.cekProfile(context);
      // notifbloc.getCartCount();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // utilbloc = Provider.of<UtilBloc>(context);
    // notifbloc = Provider.of<NotifBloc>(context);
    // utilbloc.cekProfile(context);
    // notifbloc.getCartCount();

    return GenPage(
      // statusBarColor: GenColor.primaryColor,
      body: WillPopScope(
        child: _widgetOptions.elementAt(_currentIndex),
        onWillPop: () {
          onWillPop();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black54,
        selectedItemColor: GenColor.primaryColor,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map((MenuNavbarAgen menuNavbar) {
          return BottomNavigationBarItem(
              icon: Stack(
                children: <Widget>[
                  Center(child: Icon(menuNavbar.icon)),
                 Container()
                ],
              ),
              label: menuNavbar.title);
        }).toList(),
      ),
    );
  }
}
