import 'package:flutter/material.dart';
import 'package:oops_project/constants.dart';
import 'package:oops_project/providers/repository.dart';
import 'package:oops_project/ui/homePage.dart';
import 'package:provider/provider.dart';

import 'loginPage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _email = "";
  String _password = "";
  bool showPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter you email",
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                onChanged: (email) async {
                  _email = email;
                },
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          showPass ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                    ),
                    hintText: "Enter you password",
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                obscureText: !showPass,
                onChanged: (password) async {
                  _password = password;
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a user? ",
                    style: TextStyle(fontSize: 12),
                  ),
                  GestureDetector(
                    child: Text(
                      "Login",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  )
                ],
              ),
              SizedBox(height: 30),
              FlatButton(
                  onPressed: () async {
                    Provider.of<Repository>(context, listen: false)
                        .showBlockingDialog(context);
                    String res =
                        await Provider.of<Repository>(context, listen: false)
                            .signup(email: _email, password: _password);
                    if (res == "Success") {
                      Navigator.of(context).pop();
                      //go to home page
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else {
                      Provider.of<Repository>(context, listen: false)
                          .showErrorDialog(context, res);
                    }
                  },
                  child: button("Sign up"))
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
