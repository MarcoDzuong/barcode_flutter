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
                const CreateOrderPage(title: "扫码机")),
            ModalRoute.withName("/Home"));
      }
  }

  String _userName = "";
  String _password = "";

  LoginController loginController = LoginController();

  Future<void> _login() async {
    if (_userName.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
          msg: "用户名或密码为空!",
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
      if(response.userInfo.accessToken!=null){
        var pres = await SharedPreferences.getInstance();
        pres.setString("token",response.userInfo.accessToken!);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                const CreateOrderPage(title: "扫码机")),
            ModalRoute.withName("/Home"));
      }else{
        Fluttertoast.showToast(
            msg: response.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0);
      }

    } else {
      Fluttertoast.showToast(
          msg: "密码错误或网络错误!",
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
                hintText: '用户名',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (text) {
                _password = text;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '密码',
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
                onPressed: _login,
                child: const Text(
                  "登录",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      )),
    );
  }
}
