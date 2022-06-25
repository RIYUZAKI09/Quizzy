import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oops_project/models/question.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oops_project/models/quiz.dart';
import 'package:oops_project/providers/repository.dart';
import 'package:provider/provider.dart';

class NewQuiz extends StatefulWidget {
  @override
  _NewQuizState createState() => _NewQuizState();
}

class _NewQuizState extends State<NewQuiz> {
  List<Question> ques = [];
  void add(Question q) {
    setState(() {
      ques.add(q);
    });
  }

  TextEditingController time = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuestionInput(add: add)));
          },
        ),
        appBar: AppBar(
          title: Text("Create New Quiz"),
          actions: [
            IconButton(
              onPressed: () async {
                int total = 0;
                for (var i in ques) {
                  total += i.marks;
                }
                var q = Quiz(
                    id: "abc",
                    ques: ques,
                    totalMarks: total,
                    totalTime: int.tryParse(time.text) * 60);
                await Provider.of<Repository>(context, listen: false)
                    .addQuiz(q);
              },
              icon: Icon(Icons.check),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Total Time: "),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    controller: time,
                    decoration: InputDecoration(
                        hintText: "Time in minutes",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ques.length == 0
                  ? Center(child: Text("Tap '+' button to add a new question"))
                  : ListView.builder(
                      itemBuilder: (context, i) {
                        return Container(
                          margin: const EdgeInsets.all(14.0),
                          // padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            key: UniqueKey(),
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10.0),
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  (i + 1).toString() + ". " + ques[i].question,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      ques.removeAt(i);
                                    });
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        );
                      },
                      itemCount: ques.length,
                    ),
            ),
          ],
        ));
  }
}

class QuestionInput extends StatefulWidget {
  Function add;
  Question q;
  QuestionInput({this.q, this.add});
  @override
  State<QuestionInput> createState() => _QuestionInputState();
}

class _QuestionInputState extends State<QuestionInput> {
  final key = new GlobalKey<FormState>();
  int dropdownvalue = 0;
  TextEditingController ques = new TextEditingController();
  List<TextField> options = [];
  bool isTimed = false;
  List<TextEditingController> option_ctrl = [];
  String image = "";
  TextEditingController time = new TextEditingController();
  TextEditingController marks = new TextEditingController();
  ImagePicker _picker = new ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Add new question"),
            actions: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  var q = ques.text;
                  List<String> ans = [];
                  for (var i in option_ctrl) {
                    ans.add(i.text);
                  }
                  widget.add(new Question(
                      question: q,
                      ans: ans,
                      image: image,
                      marks: int.tryParse(marks.text),
                      time: int.tryParse(time.text) ?? 60,
                      isTimed: isTimed,
                      correctAnswer: dropdownvalue + 1));
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              int index = options.length + 1;
              option_ctrl.add(new TextEditingController());
              setState(() {
                options.add(TextField(
                    decoration: InputDecoration(
                        hintText: "Option ${index.toString()}",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    key: UniqueKey(),
                    controller: option_ctrl.last));
              });
            },
          ),
          body: Form(
            key: key,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          controller: ques,
                          decoration: InputDecoration(
                              hintText: "Question",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () async {
                          var path = await _picker.getImage(
                              source: ImageSource.gallery);
                          if (path != null) {
                            setState(() {
                              image = path.path;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            image = "";
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text("Correct Ans: "),
                      DropdownButton<int>(
                          value: dropdownvalue,
                          onChanged: (int newval) {
                            setState(() {
                              dropdownvalue = newval;
                            });
                            print(dropdownvalue);
                          },
                          items: option_ctrl
                              .map((e) => DropdownMenuItem<int>(
                                  value: option_ctrl.indexOf(e),
                                  child: Text(String.fromCharCode(
                                      97 + option_ctrl.indexOf(e)))))
                              .toList()),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Expanded(
                          child: TextField(
                        controller: marks,
                        decoration: InputDecoration(
                            hintText: "Marks",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      Checkbox(
                          value: isTimed,
                          onChanged: (newVal) {
                            setState(() {
                              isTimed = newVal;
                            });
                          }),
                      Text("Is this question timed?"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      isTimed
                          ? Expanded(
                              child: TextField(
                              controller: time,
                              decoration: InputDecoration(
                                  hintText: "Time",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ))
                          : Container()
                    ],
                  ),
                ),
                image != ""
                    ? Image.file(
                        File(image),
                        height: 100,
                        width: 100,
                      )
                    : Container(),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    child: options.length == 0
                        ? Center(child: Text("Tap '+' to add new option"))
                        : ListView.builder(
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 10, top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: options[index],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          options.removeAt(index);
                                          option_ctrl.removeAt(index);
                                        });
                                      },
                                    )
                                  ],
                                ),
                              );
                            }),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
