import 'package:barcode_scan/cached/cached_manager.dart';
import 'package:barcode_scan/screen/create_order/create_order.dart';
import 'package:barcode_scan/util/toast_util.dart';
import 'package:flutter/material.dart';

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

  checkLogin() async {
    String token = await MyStorageImpl.getToken();
    if (token.isNotEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const CreateOrderPage(title: "扫码机")),
          ModalRoute.withName("/Home"));
    }
  }

  String _userName = "";
  String _password = "";

  LoginController loginController = LoginController();

  _login() async {
    if (_userName.isEmpty || _password.isEmpty) {
      ToastUtil.showWarning("用户名或密码为空!");
      return;
    }
    setState(() {
      isLoading = true;
    });
    LoginResponse? response =
        await loginController.login(email: _userName, passWord: _password);
    setState(() {
      isLoading = false;
    });
    if (response != null) {
      if (response.userInfo.accessToken != null) {
        ToastUtil.showSuccess("登录成功");
        MyStorageImpl.setToken(response.userInfo.accessToken!);
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateOrderPage(title: "扫码机")),
            ModalRoute.withName("/Home"));
      } else {
        ToastUtil.showError(response.message);
      }
    } else {
      ToastUtil.showError("密码错误或网络错误!");
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Padding(
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
