import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsModel {
  String question;
  String topic;
  int ans;
  List choices;
  int grade_level;
  int questionID;
  String translation;

  QuestionsModel(
      this.question,
      this.questionID,
      this.ans,
      this.choices,
      this.topic,
      this.grade_level,
      this.translation
      );

  // formatting for upload to Firbase when creating the trip
  Map<String, dynamic> toJson() => {
    'question': question,
    'questionID':questionID,
    'translation:': translation,
    'topic':topic,
    'answer': ans,
    'multiple_choice':choices,
    'grade_level': grade_level,
  };

  // creating a Trip object from a firebase snapshot
  QuestionsModel.fromSnapshot(DocumentSnapshot snapshot) :
      topic = snapshot['topic'],
      question = snapshot['question'],
      translation = snapshot['translation'],
      ans = snapshot['answer'],
      choices = snapshot['multiple_choice'],
      grade_level = snapshot['grade_level'],
      questionID = snapshot['questionID'];
    
}
