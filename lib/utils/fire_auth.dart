
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _userCollection = _firestore.collection('user');
class FireAuth {
   static String? userUid;

  // For registering a new user
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }
  
  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }
  //Adding Data
  static Future<void> addItem({
  required String title,
  required String description,
  }) async {
  DocumentReference documentReferencer =
      _userCollection.doc(userUid).collection('items').doc();

  Map<String, dynamic> data = <String, dynamic>{
    "title": title,
    "description": description,
  };

  await documentReferencer
      .set(data)
      .whenComplete(() => print("Notes item added to the database"))
      .catchError((e) => print(e));
}
//Reading Data 
static Stream<QuerySnapshot> readItems() {
  CollectionReference notesItemCollection =
      _userCollection.doc(userUid).collection('items');

  return notesItemCollection.snapshots();
}
//Reading User Data
readuser() async {
  var UserCollection =
      _userCollection.where('role',isNotEqualTo: 'Admin').get();

  return UserCollection;
}
//UpdateData
static Future<void> updateItem({
  required String title,
  required String description,
  required String docId,
}) async {
  DocumentReference documentReferencer =
      _userCollection.doc(userUid).collection('items').doc(docId);

  Map<String, dynamic> data = <String, dynamic>{
    "title": title,
    "description": description,
  };

  await documentReferencer
      .update(data)
      .whenComplete(() => print("Note item updated in the database"))
      .catchError((e) => print(e));
}
//Delete Data
static Future<void> deleteItem({
  required String docId,
}) async {
  DocumentReference documentReferencer =
      _userCollection.doc(userUid).collection('items').doc(docId);

  await documentReferencer
      .delete()
      .whenComplete(() => print('Note item deleted from the database'))
      .catchError((e) => print(e));
}
}
