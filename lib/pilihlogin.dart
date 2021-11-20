import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosanku/login.dart';

import 'component/TextFieldLogin.dart';
import 'component/genButton.dart';
import 'component/genColor.dart';
import 'component/genPreferrence.dart';
import 'component/genText.dart';
import 'component/genToast.dart';
import 'component/request.dart';

class PilihLogin extends StatefulWidget {
  @override
  _PilihLoginState createState() => _PilihLoginState();
}

class _PilihLoginState extends State<PilihLogin> {
  bool readyToHit = true;
  final req = new GenRequest();

  var email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),

              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    "Masuk ke ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Kosanku",
                    style: TextStyle(
                        color: GenColor.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),


              SizedBox(
                height: 15,
              ),
              Text(
                "Saya ingin masuk sebagai ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,),
              ),
              SizedBox(
                height: 50,
              ),

              readyToHit
                  ? GenButton(
                      text: "Pencari Kos",
                      ontap: () {
                        Navigator.pushNamed(context, "login", arguments: Login(
                          roles : "user"
                        ));
                      },
                    )
                  : CircularProgressIndicator(),

              SizedBox(
                height: 20,
              ),

              readyToHit
                  ? GenButton(
                text: "Pemilik Kos",
                ontap: () {
                  Navigator.pushNamed(context, "login",
                      arguments: Login(
                          roles : "mitra"
                      ));
                },
              )
                  : CircularProgressIndicator(),

            ],
          ),
        ),
      ),
    );
  }

  void login(username, pass) async {
    setState(() {
      readyToHit = false;
    });
    dynamic data;
    data = await req.postApi("login", {"username": username, "password":pass});

    print("DATA $data");
    setState(() {
      readyToHit = true;
    });
    if (data["status"] == 200) {
      setState(() {
        setPrefferenceToken(data["data"]["token"]);
        Navigator.pushReplacementNamed(context, "propertymu");
      });
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
