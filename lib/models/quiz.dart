import 'package:oops_project/models/question.dart';

class Quiz {
  final String id;
  final List<Question> ques;
  final int totalTime;
  final int totalMarks;
  Quiz({this.id, this.ques, this.totalMarks, this.totalTime});
  // static Quiz fromDocumentSnapshot(List<DocumentSnapshot> docs) {
}
