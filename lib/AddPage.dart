// ignore: file_names
// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_dynamic_calls
import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gelisim_app/position/district.dart';
import 'package:gelisim_app/veritabani.dart';
import 'package:gelisim_app/view/HomePage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

import 'position/district.dart';

class GonderiEkle extends StatefulWidget {
  const GonderiEkle({Key? key}) : super(key: key);

  @override
  _GonderiEkleState createState() => _GonderiEkleState();
}

class _GonderiEkleState extends State<GonderiEkle> {
  double enlem = 0.0;
  double boylam = 0.0;
  String? sSemt;
  String? sKategori;

  List<Marker> myMarker = [];

  var baslangicKonum = CameraPosition(
    target: LatLng(37.738192, 29.103930),
    zoom: 16,
  );

  late dynamic dd;
  late String semt, baslik, olay;
  late LatLng xy;

  VeriTabani veritabani = new VeriTabani();

  File? _resim;
  final secici = ImagePicker();
  var currentUser = FirebaseAuth.instance.currentUser;
  // loading çemberi
  bool loadingC = false;

  var child;

  var _firestore;

  resimAl() async {
    var secilenDosya = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      maxWidth: null,
      maxHeight: null,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      if (secilenDosya == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
            (Route<dynamic> route) => true);
      }

      _resim = File(secilenDosya!.path);
    });
  }

  // ignore: inference_failure_on_function_return_type
  gonder() async {
    if (_resim != null) {
      setState(() {
        loadingC = true;
      });

      firebase_storage.Reference depo = FirebaseStorage.instance
          .ref()
          .child('OlayResimleri')
          .child("${randomAlphaNumeric(9)}");
      // yükleme görevi
      firebase_storage.UploadTask resimYuklemeGorevi = depo.putFile(_resim!);
      //resim urlsi için
      var picUrl = await (await resimYuklemeGorevi).ref.getDownloadURL();
      print(picUrl);

      Map<String, dynamic> cokGonder = {
        'semt': semt,
        'picUrl': picUrl,
        'olay': olay,
        'baslik': baslik,
        'id': currentUser!.uid,
        'location': GeoPoint(xy.latitude, xy.longitude),
      };

      veritabani.veriEkle(cokGonder).then((kullanici) {
        Navigator.pop(context);
      });
    } else {
      Fluttertoast.showToast(msg: 'Resim Seçilmedi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(61, 90, 153, 1),
        ),
        body: SingleChildScrollView(
          child: loadingC
              ? Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      SizedBox(
                        width: 400,
                        height: 300,
                        child: GoogleMap(
                          initialCameraPosition: baslangicKonum,
                          markers: Set.from(myMarker),
                          mapType: MapType.hybrid,
                          myLocationEnabled: true,
                          compassEnabled: true,
                          onTap: _handleTap,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            DropdownButton<String>(
                                hint: Text("Semti Seciniz"),
                                value: sSemt,
                                iconSize: 36,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Colors.blue),
                                isExpanded: true,
                                items: district.map(buildMenuItem).toList(),
                                onChanged: (value) {
                                  semt = value!;
                                  setState(
                                    () => this.sSemt = value,
                                  );
                                }),
                            SizedBox(
                              height: 8,
                            ),
                            DropdownButton<String>(
                                hint: Text("Kategori"),
                                value: sKategori,
                                iconSize: 36,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Colors.blue),
                                isExpanded: true,
                                items: categori.map(buildMenuItem).toList(),
                                onChanged: (value) {
                                  baslik = value!;
                                  setState(
                                    () => this.sKategori = value,
                                  );
                                }),
                            SizedBox(
                              height: 8,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Olaydan/ Tehlikeden Kısaca Bahsedin',
                                labelText: 'Açıklama',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              onChanged: (oge) {
                                olay = oge;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                resimAl();
                              },
                              child: _resim != null
                                  ? Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRect(
                                        child: Align(
                                            alignment: Alignment.topCenter,
                                            heightFactor: 0.5,
                                            child: Image.file(_resim!,
                                                fit: BoxFit.cover)),
                                      ),
                                    )
                                  : Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(61, 90, 153, 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Icon(Icons.add_a_photo,
                                          color: Colors.white)),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(32, 161, 22, 1)),
                              ),
                              onPressed: gonder,
                              child: Container(
                                height: 20,
                                width: 500,
                                child: Text(
                                  "Gönder",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ));
  }

  Future<void> _handleTap(LatLng tappedPoint) async {
    setState(() {
      print(tappedPoint);
      xy = tappedPoint;
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          infoWindow: InfoWindow(title: "yeni marker", snippet: "new marker"),
          draggable: true,
          onDragEnd: (dragEndPosition) {
            print(dragEndPosition);
          }));
    });
  }
}
