import 'package:flutter/material.dart';
import 'package:oops_project/constants.dart';
import 'package:oops_project/providers/repository.dart';
import 'package:oops_project/ui/quizPage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _code = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
            child: ListView(
          children: [
            Image(
              image: AssetImage("assets/images/logo1.png"),
              height: 500,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "Enter Quiz code",
                  labelText: "Code",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              onChanged: (newVal) {
                _code = newVal;
              },
            ),
            SizedBox(
              height: 50,
            ),
            FlatButton(
              child: button("Start Quiz"),
              onPressed: () async {
                if (_code == "") {
                  Provider.of<Repository>(context, listen: false)
                      .showErrorDialog(context, "Code cannot be empty");
                } else {
                  final doc =
                      await Provider.of<Repository>(context, listen: false)
                          .questions
                          .doc(_code)
                          .get();
                  if (doc.exists) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => QuizPage(_code)));
                  } else {
                    Provider.of<Repository>(context, listen: false)
                        .showErrorDialog(context, "No quiz found");
                  }
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
