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

  Future<void> saveRegisterformData(String firstname, String lastname,
      String dob, String email, String pwd,String gender) async {
    DocumentReference docref = await firestore.collection(
        "Users Registration Data").add({
      "firstname": firstname,
      "lastname": lastname,
      "dob": dob,
      "email": email,
      "pwd": pwd,
      "gender": gender,
    });
  }
}
