import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserState with ChangeNotifier {
  final User? user;
  UserState(this.user);
}
