import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Stream<QuerySnapshot> getMarker() {
  var ref = FirebaseFirestore.instance.collection("Gonderiler").snapshots();
  return ref;
}

var baslangicKonum = const CameraPosition(
  target: LatLng(37.738192, 29.103930),
  zoom: 16,
);

class map_page extends StatefulWidget {
  const map_page(param0, {Key? key}) : super(key: key);

  @override
  State<map_page> createState() => _map_pageState();
}

class _map_pageState extends State<map_page> {
  final _firestore = FirebaseFirestore.instance;
  List<Marker> markers = <Marker>[];

  late BitmapDescriptor mapMarker;
  @override
  void initState() {
    setCustomMarker();
    super.initState();
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/custom_marker.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = _firestore.collection('Gonderiler');
    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
        if (asyncSnapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        print(asyncSnapshot.data.docs.length);
        for (int i = 0; i < asyncSnapshot.data.docs.length; i++) {
          print(i);

          GeoPoint location = asyncSnapshot.data.docs[i].get(
            "location",
          );
          print(location);
          if (location == null) {
            return const Text("!ERROR!");
          }
          markers.add(
            Marker(
              markerId: MarkerId(''),
              position: LatLng(asyncSnapshot.data.docs[i]['location'].latitude,
                  asyncSnapshot.data.docs[i]['location'].longitude),
              icon: mapMarker,

              // infoWindow: InfoWindow(
              //   title: asyncSnapshot.data.docs[i]['olay'],
              //   snippet: asyncSnapshot.data.docs[i]['yer'],
              // ),
            ),
          );
          print(asyncSnapshot.data.docs[i]['location'].latitude);
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(61, 90, 153, 1),
          ),
          body: GoogleMap(
            initialCameraPosition: baslangicKonum,
            markers: Set<Marker>.of(markers),
            mapType: MapType.hybrid,
            myLocationEnabled: true,
            compassEnabled: true,
          ),
        );
      },
    );
  }
}
