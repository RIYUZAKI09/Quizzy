import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oops_project/constants.dart';
import 'package:oops_project/models/question.dart';
import 'package:oops_project/providers/repository.dart';
import 'package:oops_project/ui/homePage.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  String code;
  QuizPage(this.code);
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int correctAns = 0;
  bool isFinished = false;
  Timer _timer;
  int _start = 600;
  int totalQuestions;
  int prevStart = 600;
  int total = 0;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (isFinished) {
            timer.cancel();
            _start = 0;
          } else if (_start < 1) {
            isFinished = true;
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: isFinished
                ? Text("Result")
                : Row(
                    // mainAxisAlignment: ,
                    children: [
                      Expanded(child: Text("Question ${currentQuestion + 1}")),
                      Text((_start ~/ 60).toString() +
                          ":" +
                          ((_start % 60) < 10
                              ? "0" + "${_start % 60}"
                              : "${(_start % 60)}")),
                    ],
                  ),
          ),
          body: isFinished
              ? Container(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Total Questions: $totalQuestions\nCorrect Ansers: $correctAns"),
                      SizedBox(height: 10),
                      Text(
                        correctAns > totalQuestions / 2
                            ? "Congratulations, You passed"
                            : "Sorry, You Failed",
                        style: TextStyle(
                            color: correctAns > totalQuestions / 2
                                ? Colors.green
                                : Colors.red,
                            fontSize: 20),
                      ),
                      SizedBox(height: 50),
                      FlatButton(
                        child: button("Go to Home Page"),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                      )
                    ],
                  )),
                )
              : StreamBuilder(
                  stream: Provider.of<Repository>(context, listen: false)
                      .questions
                      .doc(widget.code)
                      .collection("ques")
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Question> allQues = [];
                    if (snapshot.hasData) {
                      for (var ques in snapshot.data.documents) {
                        Question question = Question.fromDocumentSnapshot(ques);
                        allQues.add(question);
                      }
                      totalQuestions = allQues.length;
                      // var val = (allQues[currentQuestion].time) * 60;
                      // total = prevStart - _start;
                      // prevStart = val;
                      // // setState(() {
                      // _start = val;
                      // // });
                      return QuizQuestion(
                        key: Key(currentQuestion.toString()),
                        question: allQues[currentQuestion],
                        incrementCorrect: () {
                          setState(() {
                            correctAns++;
                          });
                        },
                        setTimer: (val) {},
                        next: () {
                          if (currentQuestion == allQues.length - 1) {
                            //TO Do
                            //total_time = total_quiz_time - _start
                            setState(() {
                              isFinished = true;
                            });
                          } else {
                            setState(() {
                              currentQuestion++;
                            });
                          }
                        },
                      );
                      // PageView.builder(
                      //     itemCount: allQues[0].ans.length,
                      //     itemBuilder: (context, index) {
                      //       return Text(allQues[0].ans[index]);
                      //     });
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
        ),
      ),
    );
  }
}

class QuizQuestion extends StatefulWidget {
  final Question question;
  final Function next;
  final Function incrementCorrect;
  final Function setTimer;
  QuizQuestion(
      {Key key, this.question, this.next, this.incrementCorrect, this.setTimer})
      : super(key: key);
  @override
  _QuizQuestionState createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion>
    with AutomaticKeepAliveClientMixin {
  bool isPressed = false;
  int currentAnsIndex = -1;
  @override
  bool get wantKeepAlive => true;
  Timer _timer;
  int _start;
  bool isFinished = false;
  @override
  void initState() {
    super.initState();
    if (widget.question.isTimed) {
      _start = widget.question.time;
      startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (isFinished) {
            timer.cancel();
            _start = 0;
          } else if (_start < 1) {
            isFinished = true;
            timer.cancel();
            widget.next();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          widget.question.isTimed
              ? Align(
                  alignment: Alignment.topRight,
                  child: Text((_start ~/ 60).toString() +
                      ":" +
                      ((_start % 60) < 10
                          ? "0" + "${_start % 60}"
                          : "${(_start % 60)}")),
                )
              : Container(),
          Center(
              child: Text(
            widget.question.question,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
          SizedBox(height: 10),
          widget.question.image != ""
              ? Container(
                  child: CachedNetworkImage(imageUrl: widget.question.image),
                  height: MediaQuery.of(context).size.height * 0.25,
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Column(
              children: widget.question.ans.map((e) {
                // bool isCorrect = false;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  // width: MediaQuery.of(context).size.width * 0.5,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: FlatButton(
                    onPressed: () {
                      if (!isPressed) {
                        print("Pressed");
                        setState(() {
                          isPressed = true;
                          currentAnsIndex = widget.question.ans.indexOf(e);
                          if (widget.question.correctAnswer ==
                              currentAnsIndex) {
                            widget.incrementCorrect();
                          }
                        });
                      }
                    },
                    color: isPressed &&
                            currentAnsIndex == widget.question.ans.indexOf(e)
                        ? (currentAnsIndex == widget.question.correctAnswer
                            ? Colors.green
                            : Colors.red)
                        : Colors.grey.shade300,
                    child: Center(child: Text(e)),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          FlatButton(
            child: button("Next"),
            onPressed: widget.next,
          )
        ],
      ),
    );
  }
}
