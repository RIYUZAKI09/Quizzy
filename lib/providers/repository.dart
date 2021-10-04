import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Repository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference questions =
      FirebaseFirestore.instance.collection("questions");
  UserCredential _user;
  Future<String> login({String email, String password}) async {
    try {
      var result = (await _auth.signInWithEmailAndPassword(
          email: email, password: password));
      if (result != null) {
        _user = result;
      }
      return "Success";
    } catch (error) {
      String errorMessage;
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      return errorMessage;
    }
  }

  Future<String> signup({String email, String password}) async {
    try {
      var res = (await _auth.createUserWithEmailAndPassword(
          email: email, password: password));
      if (res != null) _user = res;
      return "Success";
    } catch (error) {
      // String errorMessage;
      // switch (error.code) {
      //   case "ERROR_OPERATION_NOT_ALLOWED":
      //     errorMessage = "Anonymous accounts are not enabled";
      //     break;
      //   case "ERROR_WEAK_PASSWORD":
      //     errorMessage = "Your password is too weak";
      //     break;
      //   case "ERROR_INVALID_EMAIL":
      //     errorMessage = "Your email is invalid";
      //     break;
      //   case "ERROR_EMAIL_ALREADY_IN_USE":
      //     errorMessage = "Email is already in use on different account";
      //     break;
      //   case "ERROR_INVALID_CREDENTIAL":
      //     errorMessage = "Your email is invalid";
      //     break;

      //   default:
      //     errorMessage = "An undefined Error happened.";
      // }
      // return errorMessage;
      return error.code;
    }
  }

  showErrorDialog(BuildContext ctx, String text) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Text(text),
          );
        });
  }

  showBlockingDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(title: Center(child: CircularProgressIndicator()));
        });
  }
}
