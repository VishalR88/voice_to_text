import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConnection {
  final firestore = FirebaseFirestore.instance;

  Future<void> saveToFirebase(String email) async {
    DocumentReference docref = await firestore.collection("Users").add({
      "email": email,
    });
    // var refid = docref.id;
    // print("document id $refid");
  }
}
