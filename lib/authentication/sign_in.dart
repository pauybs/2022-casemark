// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelisim_app/view/HomePage.dart';

import 'signUp.dart';

class sign_in extends StatefulWidget {
  @override
  _sign_inState createState() => _sign_inState();
}

class _sign_inState extends State<sign_in> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  Future<void> girisYap() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: t1.text, password: t2.text)
        .then((kullanici) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(61, 90, 153, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('CASE MARK APP',
                style: TextStyle(
                    fontFamily: "RussoOne",
                    fontSize: 26,
                    color: Color.fromARGB(255, 255, 255, 255))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 25),
          child: Center(
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: "RussoOne",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 500,
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            controller: t1,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            controller: t2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromRGBO(61, 90, 153, 1)),
                            ),
                            onPressed: girisYap,
                            child: Container(
                              height: 20,
                              width: 500,
                              child: Text(
                                "LOGİN",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 00,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                          builder: (_) => signUp()),
                                      (Route<dynamic> route) => true);
                                },
                                child: Text(
                                  'not a member? sign up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Image.asset('assets/logo/cM.png')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
