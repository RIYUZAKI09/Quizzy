import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String question;
  final List<dynamic> ans;
  final int correctAnswer;
  final String image;
  Question({this.ans, this.correctAnswer, this.image, this.question});
  static Question fromDocumentSnapshot(DocumentSnapshot doc) {
    return Question(
        correctAnswer: int.tryParse(doc['correct']),
        ans: doc['ans'],
        question: doc['question'],
        image: doc['image'] ?? "");
  }
}
