import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Topics {
  String topic_name;
  int grade_level;
  int publish;
  String img;
  String code;

  Topics(
      this.topic_name,
      this.grade_level,
      this.publish,
      this.img,
      this.code
      );

  // formatting for upload to Firbase when creating the trip
  Map<String, dynamic> toJson() => {
    'topic_name': topic_name,
    'grade_level': grade_level,
    'publish': publish,
    'image': img,
    'code': code,
  };

  // creating a Trip object from a firebase snapshot
  Topics.fromSnapshot(DocumentSnapshot snapshot) :
      topic_name = snapshot['topic_name'],
      grade_level = snapshot['grade_level'],
      publish = snapshot['publish'],
      img = snapshot['image'],
      code = snapshot['code'];
    
}
