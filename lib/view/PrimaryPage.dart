import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../authentication/signUp.dart';
import '../authentication/sign_in.dart';

class primary extends StatefulWidget {
  const primary({Key? key}) : super(key: key);

  @override
  State<primary> createState() => _primaryState();
}

class _primaryState extends State<primary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          children: [
            Center(child: Image.asset("assets/logo/cM.png")),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(61, 90, 153, 1)),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => sign_in()),
                    (Route<dynamic> route) => true);
              },
              child: Container(
                height: 20,
                width: 500,
                child: Text(
                  "SIGN IN",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(61, 90, 153, 1)),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => signUp()),
                    (Route<dynamic> route) => true);
              },
              child: Container(
                height: 20,
                width: 500,
                child: Text(
                  "SIGN UP",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
