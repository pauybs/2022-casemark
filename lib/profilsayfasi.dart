import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'authentication/sign_in.dart';
import 'view/HomePage.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Profil Sayfası"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
                (Route<dynamic> route) => true);
          },
        ),
        IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((deger) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => sign_in()),
                    (Route<dynamic> route) => false);
              });
            }),
      ],
    ),
    floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => null!),
              (Route<dynamic> route) => true);
        }),
    body: ProfilEkrani(),
  );
}

class ProfilEkrani extends StatefulWidget {
  const ProfilEkrani({Key? key}) : super(key: key);

  @override
  _ProfilTasarimiState createState() => _ProfilTasarimiState();
}

class _ProfilTasarimiState extends State<ProfilEkrani> {
  late File yuklenecekDosya;
  FirebaseAuth auth = FirebaseAuth.instance;

  String? indirmeBaglantisi;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => baglantiAl());
  }

  baglantiAl() async {
    ;
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child('profilresimleri')
        .child(auth.currentUser!.uid)
        .child('profilResmi.png')
        .getDownloadURL();

    setState(() {
      indirmeBaglantisi = baglanti;
    });
  }

  kameradanYukle() async {
    var alinanDosya = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      maxWidth: null,
      maxHeight: null,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.front,
    );
    setState(() {
      yuklenecekDosya = File(alinanDosya!.path);
    });
    var currentUser = FirebaseAuth.instance.currentUser;
    firebase_storage.Reference referansYol = FirebaseStorage.instance
        .ref()
        .child('profilresimleri')
        .child(auth.currentUser!.uid)
        .child('profilResmi.png');

    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekDosya);
    String url = await (await yuklemeGorevi).ref.getDownloadURL();
    setState(() {
      indirmeBaglantisi = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ClipOval(
              child: indirmeBaglantisi == null
                  ? Text('Resim Yok')
                  : Image.network(
                      indirmeBaglantisi!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )),
          FlatButton(child: Text('Resim Yükle'), onPressed: kameradanYukle)
        ],
      ),
    );
  }
}
