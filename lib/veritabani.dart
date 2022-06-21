import 'package:cloud_firestore/cloud_firestore.dart';

class VeriTabani {
  veriEkle(olayVerisi) async {
    FirebaseFirestore.instance.collection("Gonderiler").add(olayVerisi);
  }
}
