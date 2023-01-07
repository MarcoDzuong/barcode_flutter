import 'package:barcode_scan/screen/create_order/create_order.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_controller.dart';
import 'model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
   checkLogin();
  }

  Future<void> checkLogin() async {
      var pres = await SharedPreferences.getInstance();
      String? token = pres.getString("token");
      if(token !=null && token.isNotEmpty){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                const CreateOrderPage(title: "Barcode Scanner")),
            ModalRoute.withName("/Home"));
      }
  }

  String _userName = "";
  String _password = "";

  LoginController loginController = LoginController();

  Future<void> _login() async {
    if (_userName.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
          msg: "username hoặc password đang trống!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
      return;
    }

    LoginResponse? response =
        await loginController.login(email: _userName, passWord: _password);

    if (response != null) {
      var pres = await SharedPreferences.getInstance();
      pres.setString("token",response.userInfo.accessToken);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const CreateOrderPage(title: "Barcode Scanner")),
          ModalRoute.withName("/Home"));
    } else {
      Fluttertoast.showToast(
          msg: "Sai mật khẩu hoặc lỗi mạng!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (text) {
                _userName = text;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'UserName',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (text) {
                _password = text;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
                onPressed: _login,
                child: const Text(
                  "Đăng nhập",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      )),
    );
  }
}
