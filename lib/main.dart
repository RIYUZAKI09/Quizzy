import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oops_project/ui/homePage.dart';
import 'package:oops_project/ui/signUp.dart';

import 'constants.dart';
import 'providers/repository.dart';
import 'package:provider/provider.dart';

import 'ui/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

const color = const Color.fromRGBO(8, 146, 208, 1);

class MyApp extends StatelessWidget {
  final Repository repo = new Repository();
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => repo,
      child: MaterialApp(
        title: 'Quizzy',
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: color),
          primaryColor: color,
          // Color.fromRGBO(8, 146, 208, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image(
                  image: AssetImage("assets/images/logo1.png"),
                  height: 500,
                ),
                SizedBox(height: 5),
                FlatButton(
                  child: button("Sign in"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
                SizedBox(height: 5),
                FlatButton(
                  child: button("Sign up"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
