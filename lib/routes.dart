
import 'package:kosanku/editKos.dart';
import 'package:kosanku/inputKos.dart';
import 'package:kosanku/pembangunan.dart';
import 'package:kosanku/pembayaran.dart';
import 'package:kosanku/pilihlogin.dart';
import 'package:kosanku/profil.dart';
import 'package:kosanku/propertymu.dart';
import 'package:kosanku/scanqr.dart';
import 'package:provider/provider.dart';


import 'DetailKos.dart';
import 'QRcode.dart';
import 'base.dart';
import 'baseagen.dart';
import 'blocks/baseBloc.dart';
import 'daftar.dart';
import 'keterangan.dart';
import 'login.dart';
import 'splashScreen.dart';

class GenProvider {
  static var providers = [
    ChangeNotifierProvider<BaseBloc>.value(value: BaseBloc()),

  ];

  static routes(context) {
    return {
//           '/': (context) {
//        return Base();
//      },

      '/': (context) {
        return SplashScreen();
      },

      'splashScreen': (context) {
        return SplashScreen();
      },

      'login': (context) {
        // return Login();
        return Login();
      },

      'pilihlogin': (context) {
        // return Login();
        return PilihLogin();
      },

      'daftar': (context) {
        // return Login();
        return Daftar();
      },

      'propertymu': (context) {
        // return Login();
        return Propertymu();
      },

      'base': (context) {
        // return Login();
        return Base();
      },


      'pembangunan': (context) {
        return Pembangunan();
      },

      'keterangan': (context) {
        return Keterangan();
      },

      'profil': (context) {
        return Profil();
      },

      'detailKos': (context) {
        return DetailKos();
      },

      'pembayaran': (context) {
        return Pembayaran();
      },

      'qrcode': (context) {
        return QRCode();
      },

      'scanqr': (context) {
        return ScanQR();
      },

      'baseagen': (context) {
        // return Login();
        return BaseAgen();
      },

      'inputkos': (context) {
        // return Login();
        return InputKos();
      },

      'editkos': (context) {
        // return Login();
        return EditKos();
      },

    };
  }
}
