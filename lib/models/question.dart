import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String question;
  final List<dynamic> ans;
  final int correctAnswer;
  final String image;
  final int time;
  final int marks;
  final bool isTimed;
  Question(
      {this.ans,
      this.correctAnswer,
      this.image,
      this.question,
      this.time,
      this.marks,
      this.isTimed});
  static Question fromDocumentSnapshot(DocumentSnapshot doc) {
    return Question(
        correctAnswer: int.tryParse(doc['correct']),
        ans: doc['ans'],
        question: doc['question'],
        image: doc['image'] ?? "",
        isTimed: true,
        time: 10,
        marks: 1);
  }
}
