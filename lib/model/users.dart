import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String fname;
  String lname;
  String uid;
  String email;
  String role;

  Users(
      this.fname,
      this.lname,
      this.uid,
      this.email,
      this.role,
      );

  // formatting for upload to Firbase when creating the trip
  Map<String, dynamic> toJson() => {
    'fname': fname,
    'lname': lname,
    'email': email,
    'role': role,
    'uid': uid,
  };

  // creating a Trip object from a firebase snapshot
  Users.fromSnapshot(DocumentSnapshot snapshot) :
      fname = snapshot['fname'],
      lname = snapshot['lname'],
      email = snapshot['email'],
      role = snapshot['role'],
      uid = snapshot['uid'];
    
}
