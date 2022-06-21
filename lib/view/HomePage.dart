// ignore: file_names
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelisim_app/AddPage.dart';
import 'package:gelisim_app/authentication/sign_in.dart';
import 'package:gelisim_app/main.dart';
import 'package:gelisim_app/profilsayfasi.dart';
import 'package:gelisim_app/view/MapPage.dart';

//veri gösterme fonksiyonu
Stream<QuerySnapshot> getOlay() {
  var ref = FirebaseFirestore.instance.collection("Gonderiler").snapshots();
  return ref;
}

class HomePage extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  late String picUrl, id, baslik, semt, olay;

  //LİSTELEME-------
  Widget Listele() {
    CollectionReference olaysRef = _firestore.collection('Gonderiler');
    return Container(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: olaysRef.snapshots(),
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              if (asyncSnapshot.hasError) {
                return const Center(child: Text('Bir Hata Oluştu'));
              } else {
                if (asyncSnapshot.hasData) {
                  List<DocumentSnapshot<Map>> listOfDocumentSnap =
                      asyncSnapshot.data.docs;
                  return Flexible(
                    child: ListView.builder(
                        itemCount: listOfDocumentSnap
                            .length, //koleksiyondaki veri sayısı kadar veri
                        itemBuilder: (context, index) {
                          return Card(
                            //color: Color.fromRGBO(61, 90, 153, 1),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      width: 500,
                                      height: 500,
                                      child: Image.network(
                                          '${listOfDocumentSnap[index].data()!["picUrl"]}'),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${listOfDocumentSnap[index].data()!["semt"]}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'RussoOne',
                                            color:
                                                Color.fromRGBO(61, 90, 153, 1)),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    color: const Color.fromRGBO(61, 90, 153, 1),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        const map_page(
                                                            MyApp))));
                                          },
                                          child: ListTile(
                                            title: Text(
                                                '${listOfDocumentSnap[index].data()!["baslik"]}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'RussoOne',
                                                    color: Colors.white)),
                                            subtitle: Text(
                                                '${listOfDocumentSnap[index].data()!["olay"]} ',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference olaysRef = _firestore.collection('Gonderiler');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 190, 191, 192),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(61, 90, 153, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '',
                  style: const TextStyle(
                      fontSize: 26,
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const map_page(
                          MyApp)), // HARİTA EKRANINA GİTME SİMGESİ BURADA!!!
                  (Route<dynamic> route) => true);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilEkrani()),
                  (Route<dynamic> route) => true);
            },
          ),
          IconButton(
              icon: const Icon(Icons.exit_to_app),
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
          backgroundColor: const Color.fromRGBO(32, 161, 22, 1),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const GonderiEkle()),
                (Route<dynamic> route) => true);
          }),
      body: Listele(),
    );
  }
}
