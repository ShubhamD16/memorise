import 'package:fluttertoast/fluttertoast.dart';

ToastSucessful([String? str]) {
  Fluttertoast.showToast(msg: str ?? "Successful...!");
}
